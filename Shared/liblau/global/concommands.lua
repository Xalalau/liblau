ConCommand = {
    -- Command list
    -- { [string command] = function callback, ... }
    list = {}
}

--[[
    Add console commands

    Arguments:
        string command = Console command
        function func  = Function callback

    Return:
        nil
]]
function ConCommand:Add(command, func)
    if not command or not func then return end

    if not ConCommand:Exists(command) then
        self.list[string.upper(command)] = func
    else
        Package:Error("Console command '" .. cvar .. "' already exists")
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
    return self.list[string.upper(command or "")] and true or false
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
    return ConCommand:Exists(command) and self.list[string.upper(command)] or nil
end

--[[
    Get a copy of all console commands

    Arguments:
        nil

    Return:
        table commands = ConCommand table
]]
function ConCommand:GetAll()
    return table.Copy(self.list)
end

--[[
    Run a registered console command

    Arguments:
        string command = Console command
        string arg     = Argument for the stored function
        ...

    Return:
        nil
]]
function ConCommand:Run(command, ...)
    if ConCommand:Exists(command) then
        ConCommand:Get(command)(...)
    else
        Package:Error(command .. "not found")
    end
end

-- ------------------------------------------------------------------------

-- Call stored console commands
Subscribe(Client or Server, "Console", "LL_CommandsConsole", function(text)
    local parts = string.Explode(text, " ")

    if ConCommand:Exists(parts[1]) then
        ConCommand:Run(table.unpack(parts))
    end
end)