
-- Shared macros
FCVAR_NONE       = 0       -- No flags
FCVAR_ARCHIVE    = 1 << 7  -- Save CVar value
FCVAR_CHEAT	     = 1 << 14 -- Requires sv_cheats to change or run the CVar
FCVAR_SPONLY     = 1 << 6  -- Requires singleplayer to change or run the CVar -- TO-DO: We can't detect "singleplayer" in Nano's World yet
-- Server macros
FCVAR_GAMEDLL    = 1 << 2  -- Server console variable
FCVAR_PROTECTED	 = 1 << 5  -- Don't show the CVar during autocompletion -- TO-DO: Nano's World doesn't support autocompletion yet
FCVAR_REPLICATED = 1 << 13 -- Send the CVar value to all clients
FCVAR_NOTIFY     = 1 << 8  -- Notifies all players when the CVar value gets changed
-- Client macros
FCVAR_CLIENTDLL	 = 1 << 3  -- Client console variable
FCVAR_USERINFO   = 1 << 9  -- Sends the CVar value to the server

CVar = {}

local cvar_list = {
    --[[
    [string owner] = { -- "Scope" or some player
        [string cvar name] = {
            function func        =  Callback or nil,
            string   default     =  Default value or "",
            string   value       =  Current value or default value,
            string   description =  A description of what the cvar does or "",
            int      flags       =  CVar flags (bitwise)
        },
    },
    ...
    }
    ]]
    ["Scope"] = {}
}

-- Set the console variable flags number
local function SetFlags(flags)
    local bit_flags = FCVAR_NONE

    for _, flag in ipairs(flags or {}) do
        bit_flags = bit_flags | flag
    end

    return bit_flags
end

-- Check if a flag bit is up
local function IsFlagSet(flags, flag)
    return flags & flag ~= FCVAR_NONE and true or false
end

-- ------------------------------------------------------------------------

--[[
    Add a cvar

    Arguments:
        string   cvar        = Console variable
        string   description = Cvar description
        string   default     = Cvar default value
        string   value       = Cvar value
        table    flags       = { int flag, ... }
        function func        = Function callback (Optional)
        Player   player      = A player. Only used with FCVAR_USERINFO

    Return:
        nil
]]
function CVar:Add(cvar, description, default, value, flags, func, player)
    if not cvar then return end

    if CVar:Exists(cvar) or (player and CVar:Exists(cvar, player)) then
        Package:Error("Console variable '" .. cvar .. "' already exists")
        Package:Error(debug.traceback())
        return
    end

    flags = SetFlags(flags)

    if player and not IsFlagSet(flags, FCVAR_USERINFO) then
        Package:Warn("Warning! You need FCVAR_USERINFO to set up a player in the CVar '" .. cvar .. "'. Ignoring field and creating normal CVar...")
        player = nil
    end

    if flags ~= FCVAR_NONE then
        local msg = "Error creating CVar '" .. cvar .. "'."
        if IsFlagSet(flags, FCVAR_GAMEDLL) and IsFlagSet(flags, FCVAR_CLIENTDLL) then
            Package:Error(msg .. " You can't set both flags FCVAR_GAMEDLL and FCVAR_CLIENTDLL at the same time")
            Package:Error(debug.traceback())
            return
        elseif IsFlagSet(flags, FCVAR_USERINFO) and not IsFlagSet(flags, FCVAR_CLIENTDLL) then
            Package:Error(msg .. " Please, set the flag FCVAR_CLIENTDLL to use FCVAR_USERINFO")
            Package:Error(debug.traceback())
            return
        elseif (IsFlagSet(flags, FCVAR_PROTECTED) or IsFlagSet(flags, FCVAR_REPLICATED) or IsFlagSet(flags, FCVAR_NOTIFY)) and not IsFlagSet(flags, FCVAR_GAMEDLL) then
            Package:Error(msg .. " Please, set the flag FCVAR_GAMEDLL to use FCVAR_PROTECTED, FCVAR_REPLICATED or FCVAR_NOTIFY")
            Package:Error(debug.traceback())
            return
        end
    end

    local cvar_tab = {
        func = func,
        value = tostring(value == nil and default or value),
        description = description or "",
        default = tostring(default == nil and "" or default),
        flags = flags,
        bla = "1"
    }

    cvar_list[player or "Scope"][string.upper(cvar)] = cvar_tab
end

--[[
    Check if a cvar exists

    Arguments:
        string cvar   = Console variable
        Player player = A player. Only used with FCVAR_USERINFO

    Return:
        bool
]]
function CVar:Exists(cvar, player)
    local list = cvar_list[player or "Scope"]
    return list and list[string.upper(cvar or "")] and true or false
end

--[[
    Get a copy of a cvar table

    Arguments:
        string cvar   = Console variable
        Player player = A player. Only used with FCVAR_USERINFO

    Return:
        table cvar = Cvar list entry
        nil
]]
function CVar:Get(cvar, player)
    local list = cvar_list[player or "Scope"]
    local res = list and table.Copy(list[string.upper(cvar)])

    if CLIENT and res and IsFlagSet(res.flags, FCVAR_GAMEDLL) then
        res.func = "PROTECTED"
    end

    return res
end

--[[
    Get a cvar value

    Arguments:
        string cvar        = Console variable
        string change_type = Type conversion (number or bool)
        Player player      = A player. Only used with FCVAR_USERINFO

    Return:
        type value = Console variable value as string by default or converted to number or boolean
        nil
]]
function CVar:GetValue(cvar, change_type, player)
    local cvar_tab = CVar:Get(cvar, player)

    if cvar_tab then
        local changeType = change_type == "number" and tonumber or change_type == "bool" and toBool or function(val) return val end

        return changeType(cvar_tab.value)
    end
end

--[[
    Get a copy of all cvars

    Arguments:
        Player player = A player. Only used with FCVAR_USERINFO

    Return:
        table cvars = Cvar list
]]
function CVar:GetAll(player)
    local copy = table.Copy(cvar_list[player or "Scope"])

    if CLIENT and copy then
        for k, v in pairs(copy) do
            if IsFlagSet(v.flags, FCVAR_GAMEDLL) then
                v.func = "PROTECTED"
            end
        end
    end

    return copy
end

--[[
    Set a cvar and run the associated callback passing
    (Player player, string cvar, string value)
 
    Arguments:
        string cvar  = Console variable
        string value = New cvar value
        Player player = A player. Only used with FCVAR_USERINFO

    Return:
        nil
]]
function CVar:SetValue(cvar, value, player)
    if CVar:GetValue(cvar, nil, player) == value then return end

    local cvar_tab = CVar:Get(cvar, player)

    if cvar_tab then
        local flags = cvar_tab.flags

        -- Flags operations
        if flags ~= FCVAR_NONE then
            -- Checks

            --[[ TO-DO: Implement
            if IsFlagSet(flags, FCVAR_SPONLY) and "max players == 1" then
                Package:Error("You can't set '".. cvar .. "' in singleplayer")
                return
            end ]]

            if IsFlagSet(flags, FCVAR_CHEAT) and not CVar:GetValue("sv_cheats", "bool") then
                Package:Error("Enable sv_cheats to use '".. cvar .. "'")
                return
            end

            if CLIENT and (IsFlagSet(flags, FCVAR_GAMEDLL)) then
                Package:Error("Only the Server can modify '".. cvar .. "'")
                return
            end

            if SERVER and IsFlagSet(flags, FCVAR_CLIENTDLL) then
                Package:Error("Only the Client can modify '".. cvar .. "'")
                return
            end

            -- Set user info
            if CLIENT and IsFlagSet(flags, FCVAR_USERINFO) then
                Events:CallRemote("LL_CVar_SetUserInfo", {
                    cvar,
                    cvar_tab.description,
                    cvar_tab.default,
                    value,
                    cvar_tab.flags,
                    cvar_tab.func
                }) 
            end
            
            -- Notify
            if SERVER and IsFlagSet(flags, FCVAR_NOTIFY) then
                Server:BroadcastChatMessage("<blue>" .. cvar .. "</> has been changed to <blue>" .. value .. "</>")
            end

            -- Replicate
            if SERVER and IsFlagSet(flags, FCVAR_REPLICATED) then
                Events:BroadcastRemote("LL_CVar_Replicate", {
                    cvar,
                    cvar_tab.description,
                    cvar_tab.default,
                    value,
                    cvar_tab.flags,
                    cvar_tab.func,
                }) 
            end

            -- Archive
            if IsFlagSet(flags, FCVAR_ARCHIVE) then
                Package:SetPersistentData("LL_CVar_" .. (player or "Scope") .. "_" .. cvar, value)
            end
        end

        -- Set value
        value = string.gsub(tostring(value), "\"", "")
        cvar_list[player or "Scope"][string.upper(cvar)].value = value

        -- Callback
        if cvar_tab.func then
            cvar_tab.func(CLIENT and NanosWorld:GetLocalPlayer(), cvar, value)
        end
    end
end

-- ------------------------------------------------------------------------

-- Run cvars in the console
Subscribe(Client or Server, "Console", "LL_CvarConsole", function(text)
    local parts = string.Explode(text, " ")
    local cvar_tab = parts[1] and (CVar:Get(parts[1]) or CLIENT and CVar:Get(parts[1], NanosWorld:GetLocalPlayer()))

    if cvar_tab then
        if not parts[2] then
            local value = cvar_tab.value
            local default = cvar_tab.default
            local description = cvar_tab.description

            default = default ~= value and "( def. \"" .. default .. "\" )" or ""

            print("\n\n\t\"" .. parts[1] .. "\" = \"" .. value .. "\" " .. default .. "\n" .. (description ~= "" and "\n\t" .. description .. "\n" or ""))
        else
            CVar:SetValue(parts[1], table.Concat(parts, " ", 2), player)
        end
    end
end)

-- Receive FCVAR_REPLICATED vars from server
if CLIENT then
    Events:Subscribe("LL_CVar_Replicate", function(cvar, description, default, value, flags, func)
        if not CVar:Exists(cvar) then
            CVar:Add(cvar, description, default, value, flags, func)
        else
            cvar_list["Scope"][string.upper(cvar)].value = tostring(value)
        end
    end)
end

-- Send FCVAR_REPLICATED vars to clients
if SERVER then
    local function InitReplicated(player)
        for cvar, cvar_tab in pairs(CVar:GetAll()) do
            if IsFlagSet(cvar_tab.flags, FCVAR_REPLICATED) then
                Events:CallRemote("LL_CVar_Replicate", player, {
                    cvar,
                    cvar_tab.description,
                    cvar_tab.default,
                    cvar_tab.value,
                    cvar_tab.flags,
                    cvar_tab.func,
                }) 
            end
        end
    end

    Package:Subscribe("Load", function()
        for _, player in ipairs(NanosWorld:GetPlayers()) do
            InitReplicated(player)
        end
    end)

    Player:Subscribe("Spawn", function (player)
        InitReplicated(player)
    end)
end

-- Initialize cvar_list[player] for FCVAR_USERINFO
Package:Subscribe("Load", function()
    if SERVER then
        for _, player in ipairs(NanosWorld:GetPlayers()) do
            cvar_list[player] = {}
        end
    elseif NanosWorld:GetLocalPlayer() then
        cvar_list[NanosWorld:GetLocalPlayer()] = {}
    end
end)

Player:Subscribe("Spawn", function (player)
    cvar_list[player] = {}
end)

-- Receive FCVAR_USERINFO vars from client
if SERVER then
    Events:Subscribe("LL_CVar_SetUserInfo", function(player, cvar, description, default, value, flags, func)
        if not CVar:Exists(cvar, player) then
            CVar:Add(cvar, description, default, value, flags, func, player)
        else
            cvar_list[player][string.upper(cvar)].value = tostring(value)
        end
    end)
end

-- Update FCVAR_ARCHIVE cvars
local function LoadPersistentData()
    _Timer:Simple(0.1, function()
        for k,v in pairs(Package:GetPersistentData()) do
            if string.find(k, "LL_CVar") == 1 then
                k = k:sub(9, #k)
                local id = string.Explode(k, "_")
                local owner = id[1]
                local cvar = table.Concat(id, "_", 2)
                local cvar_tab = CVar:Get(cvar, owner)

                if cvar_tab and IsFlagSet(cvar_tab.flags, FCVAR_ARCHIVE) and
                   not (CLIENT and IsFlagSet(cvar_tab.flags, FCVAR_GAMEDLL)) and
                   not (SERVER and IsFlagSet(cvar_tab.flags, FCVAR_CLIENTDLL)) then
                    cvar_list[owner][string.upper(cvar)].value = v
                end
            end
        end
    end)
end

Package:Subscribe("Load", function()
    LoadPersistentData()
end)

Player:Subscribe("Spawn", function (player)
    LoadPersistentData()
end)
