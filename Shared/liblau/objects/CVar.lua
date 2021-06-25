
-- Shared macros
FCVAR_ARCHIVE    = 128   -- Save CVar value -- TO-DO: Not implemented
FCVAR_CHEAT	     = 16384 -- Requires sv_cheats to change or run the CVar
FCVAR_SPONLY     = 64    -- Requires singleplayer to change or run the CVar -- TO-DO: We can't detect "singleplayer" in Nano's World yet
-- Server macros
FCVAR_GAMEDLL    = 4     -- Server command
FCVAR_PROTECTED	 = 32    -- Don't show the CVar during autocompletion -- TO-DO: Nano's World doesn't support autocompletion yet
FCVAR_REPLICATED = 8192  -- Send the CVar value to all clients
FCVAR_NOTIFY     = 256   -- Notifies all players when the CVar value gets changed
-- Client macros
FCVAR_CLIENTDLL	 = 8     -- Client command
FCVAR_USERINFO   = 512   -- Sends the CVar value to the server

CVar = {
    --[[
    Cvars.list = {
        [string owner] = { -- "Scope" or some player
            [string cvar name] = {
                func = function callback or nil,
                default = string default value or "",
                value = string current value or default value,
                description = string description or "",
                flags = { [int flag] = true, ... }
            },
        },
        ...
    }
    ]]
    list = {
        ["Scope"] = {}
    },
}

--[[
    Add a cvar

    Arguments:
        string cvar        = Console variable
        string description = Cvar description
        string default     = Cvar default value
        string value       = Cvar value
        table  flags       = { int flag, ... }
        string func        = Function callback name (Optional)
        Player player      = A player. Only used with FCVAR_USERINFO

    Return:
        nil
]]
function CVar:Add(cvar, description, default, value, flags, func, player)
    if not cvar then return end

    flags = (not flags or not IsBasicTable(flags)) and {} or flags

    if #flags > 0 then
        local easy_flags = {}
        for k,v in pairs(flags) do easy_flags[v] = true end
        flags = easy_flags

        if player and not flags[FCVAR_USERINFO] then
            Package:Warn("Warning! You need FCVAR_USERINFO to set up a player in the CVar '" .. cvar .. "'. Ignoring field and creating normal CVar...")
            player = nil
        end

        local msg = "Error creating CVar '" .. cvar .. "'."
        if flags[FCVAR_GAMEDLL] and flags[FCVAR_CLIENTDLL] then
            Package:Error(msg .. " You can't set both flags FCVAR_GAMEDLL and FCVAR_CLIENTDLL at the same time")
            return
        elseif flags[FCVAR_USERINFO] and not flags[FCVAR_CLIENTDLL] then
            Package:Error(msg .. " Please, set the flag FCVAR_CLIENTDLL to use FCVAR_USERINFO")
            return
        elseif (flags[FCVAR_PROTECTED] or flags[FCVAR_REPLICATED] or flags[FCVAR_NOTIFY]) and not flags[FCVAR_GAMEDLL] then
            Package:Error(msg .. " Please, set the flag FCVAR_GAMEDLL to use FCVAR_PROTECTED, FCVAR_REPLICATED or FCVAR_NOTIFY")
            return
        end
    end

    if not CVar:Exists(cvar, player) then
        local cvar_tag = {
            func = func,
            value = tostring(value == nil and default or value),
            description = description or "",
            default = tostring(default == nil and "" or default),
            flags = flags
        }

        self.list[player or "Scope"][string.upper(cvar)] = cvar_tag
    else
        Package:Error("Console variable '" .. cvar .. "' already exists")
    end
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
    return self.list[player or "Scope"][string.upper(cvar or "")] and true or false
end

--[[
    Get a copy of a cvar table

    Arguments:
        string cvar   = Console variable
        Player player = A player. Only used with FCVAR_USERINFO

    Return:
        table cvar = Cvars list entry
        nil
]]
function CVar:Get(cvar, player)
    return table.Copy(self.list[player or "Scope"][string.upper(cvar)]) or nil
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
        local value = cvar_tab and cvar_tab.value
        local changeType = change_type == "number" and tonumber or change_type == "bool" and toBool or function(val) return val end

        return changeType(value)
    end

    return 
end

--[[
    Get a copy of all cvars

    Arguments:
        Player player = A player. Only used with FCVAR_USERINFO

    Return:
        table cvars = Cvars list
]]
function CVar:GetAll(player)
    return table.Copy(self.list[player or "Scope"])
end

--[[
    Set a cvar

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

        --[[
        -- TO-DO: Implement
        if flags[FCVAR_SPONLY] and "max players == 1" then
            Package:Error("You can't set '".. cvar .. "' in singleplayer")
            return
        end
        ]]

        -- Checks
        if flags[FCVAR_CHEAT] and not CVar:GetValue("sv_cheats", "bool") then
            Package:Error("Enable sv_cheats to use '".. cvar .. "'")
            return
        end

        if CLIENT and (flags[FCVAR_REPLICATED] or flags[FCVAR_NOTIFY]) then
            Package:Error("Only the Server can modify '".. cvar .. "'")
            return
        end

        if SERVER and flags[FCVAR_USERINFO] then
            Package:Error("Only the Client can modify '".. cvar .. "'")
            return
        end

        -- Set user info
        if CLIENT and flags[FCVAR_USERINFO] then
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
        if SERVER and flags[FCVAR_NOTIFY] then
            Server:BroadcastChatMessage("<blue>" .. cvar .. "</> has been changed to <blue>" .. value .. "</>")
        end

        -- Replicate
        if SERVER and flags[FCVAR_REPLICATED] then
            Events:BroadcastRemote("LL_CVar_Replicate", {
                cvar,
                cvar_tab.description,
                cvar_tab.default,
                value,
                cvar_tab.flags,
                cvar_tab.func,
            }) 
        end

        -- Set value
        self.list[player or "Scope"][string.upper(cvar)].value = value

        -- Archive
        -- TO-DO: Implement
        if flags[FCVAR_ARCHIVE] then
            SetPersistentData("LL_cvar_" .. (player and player or "Scope") .. "_" .. cvar, CVar:Get(cvar, player))
        end

        -- Callback
        local func = _G[cvar_tab.func or ""]
        if func then
            func(value)
        end
    end
end

-- ------------------------------------------------------------------------

-- Interact with cvars in the console
Subscribe(Client or Server, "Console", "LL_CvarsConsole", function(text)
    local parts = string.Explode(text, " ")

    local function checkConsoleCommands(parts, player)
        if CVar:Exists(parts[1], player) then
            if not parts[2] then
                local cvar_tab = CVar:Get(parts[1], player)
                local value = cvar_tab.value
                local default = cvar_tab.default
                local description = cvar_tab.description

                default = default ~= value and "( def. \"" .. default .. "\" )" or ""

                print("\n\n\t\"" .. parts[1] .. "\" = \"" .. value .. "\" " .. default .. "\n\n\t" .. description .. "\n")
            else
                CVar:SetValue(parts[1], table.Concat(parts, " ", 2), player)
            end
        end
    end

    checkConsoleCommands(parts)
    if CLIENT then
        checkConsoleCommands(parts, NanosWorld:GetLocalPlayer())
    end
end)

-- Initialize self.list[player] here, so it doesn't break after a package reload
Character:Subscribe("Spawn", function(char)
    _Timer:Simple(0.2, function()
        local player = char:GetPlayer()

    end)
end)

-- Create CVar.list[player] for FCVAR_USERINFO
Package:Subscribe("Load", function()
    if SERVER then
        for _, player in ipairs(NanosWorld:GetPlayers()) do
            CVar.list[player] = {}
        end
    elseif NanosWorld:GetLocalPlayer() then
        CVar.list[NanosWorld:GetLocalPlayer()] = {}
    end
end)

-- Replicate commands on a new or player
Player:Subscribe("Spawn", function (player)
    CVar.list[player] = {}

    if SERVER then
        _Timer:Simple(1, function()
            for cvar, cvar_tab in pairs(CVar:GetAll()) do
                if cvar_tab.flags[FCVAR_REPLICATED] then
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
        end)
    end
end)

 -- Get userinfo from a player
if SERVER then
    Events:Subscribe("LL_CVar_SetUserInfo", function(player, cvar, description, default, value, flags, func)
        if not CVar:Exists(cvar, player) then
            CVar:Add(cvar, description, default, value, flags, func, player)
        else
            CVar.list[player][string.upper(cvar)].value = tostring(value)
        end
    end)
end

-- Get replicated commands from server
if CLIENT then
    Events:Subscribe("LL_CVar_Replicate", function(cvar, description, default, value, flags, func)
        if not CVar:Exists(cvar) then
            CVar:Add(cvar, description, default, value, flags, func)
        else
            CVar.list["Scope"][string.upper(cvar)].value = tostring(value)
        end
    end)
end
