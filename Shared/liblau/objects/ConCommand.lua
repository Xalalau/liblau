ConCommand = {}

-- Command list
-- { [string command] = { function func = Function callback, bool is_shared = It needs to run shared }, ... }
local ccon_list = {}

--[[
    Add console commands

    Arguments:
        string   command   = Console command
        function func      = Function callback name or address
        bool     is_shared = It needs to run shared (Only the server can run this command)

    Return:
        nil
]]
function ConCommand:Add(command, func, is_shared)
    if not command then return end

    if not IsFunction(func) then
        Package:Error("Console command '" .. command .. "' couldn't be created because the selected callback doesn't exist")
        Package:Error(debug.traceback())
        return
    end

    if not ConCommand:Exists(command) then
        ccon_list[string.upper(command)] = {
            func = func,
            is_shared = is_shared
        }
    else
        Package:Error("Console command '" .. command .. "' already exists")
        Package:Error(debug.traceback())
    end
end

--[[
    Check if a console command exists

    Arguments:
        string command = Console command

    Return:
        bool
]]
function ConCommand:Exists(command)
    return ccon_list[string.upper(command or "")] and true or false
end

--[[
    Get a console command callback

    Arguments:
        string command = Console command

    Return:
        function func = Callback
        nil
]]
function ConCommand:Get(command)
    local res = ConCommand:Exists(command) and ccon_list[string.upper(command)]

    if CLIENT and res and res.is_shared then
        res.func = "PROTECTED"
    end

    return res
end

--[[
    Get a copy of all console commands

    Arguments:
        nil

    Return:
        table commands = ConCommand table
]]
function ConCommand:GetAll()
    local copy = table.Copy(ccon_list)

    if CLIENT then
        for k, v in pairs(copy) do
            if v.is_shared then
                v.func = "PROTECTED"
            end
        end
    end

    return copy
end

--[[
    Run a registered console command passing
    (Player player, string command, table arguments)

    Arguments:
        string command = Console command
        string arg     = Argument for the stored function
        ...

    Return:
        nil
]]
function ConCommand:Run(command, ...)
    local cmd_tab = ConCommand:Get(command)

    if cmd_tab then
        if CLIENT and cmd_tab.is_shared then
            Package:Error("Only the Server can run the command '" .. command .. "'")
        else
            cmd_tab.func(CLIENT and NanosWorld:GetLocalPlayer(), command, { string.FormatVarargs(...) })

            if cmd_tab.is_shared then
                Events:BroadcastRemote("LL_ConCommand_RunShared", { command, ... })
            end
        end
    else
        Package:Error(command .. "not found")
    end
end

-- ------------------------------------------------------------------------

-- Run console commands
Subscribe(Client or Server, "Console", "LL_CommandsConsole", function(text)
    local parts = string.Explode(text, " ")

    if ConCommand:Exists(parts[1]) then
        ConCommand:Run(table.unpack(parts))
    end
end)

-- Finish running shared commands
if CLIENT then
    Events:Subscribe("LL_ConCommand_RunShared", function(command, ...)
        local cmd_tab = ConCommand:Exists(command) and ccon_list[string.upper(command)]

        if cmd_tab and cmd_tab.is_shared then
            cmd_tab.func(NanosWorld:GetLocalPlayer(), command, { string.FormatVarargs(...) })
        end
    end)
end