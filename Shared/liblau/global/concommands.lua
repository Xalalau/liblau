-- Command list
-- { [string command] = function callback, ... }
ConCommand = {}

--[[
    Add console commands

    Arguments:
        string command = Console command
        function func  = Function callback

    Return:
        nil
]]
function ConCommand:Add(command, func)
    ConCommand[command] = func
end

--[[
    Remove registered console commands

    Arguments:
        string command = Console command

    Return:
        nil
]]
function ConCommand:Remove(command)
    ConCommand[command] = nil
end

--[[
    Get registered console commands

    Arguments:
        string command = Console command

    Return:
        function return = The associated function
        nil
]]
function ConCommand:Get(command)
    return ConCommand[command]
end

--[[
    Get registered console commands

    Arguments:
        nil

    Return:
        table commands = ConCommand table
]]
function ConCommand:GetTable()
    return ConCommand
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
    if self:GetFunction(command) then
        ConCommand[command](ConCommand[command], ...)
    else
        Package:Error(command .. "not found")
    end
end

-- Call stored console commands
if Client then
    Client:Subscribe("Console", function(text)
        local parts = string.Explode(text, " ")

        if parts[1] and ConCommand:GetFunction(parts[1]) then
            ConCommand:Run(table.unpack(parts))
        end
    end)
end