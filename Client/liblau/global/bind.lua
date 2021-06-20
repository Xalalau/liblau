-- Bind list
-- { [string command] = { func = function callback, args = table arguments }, ... }
Bind = {}

--[[
    Add a key bind

    Arguments:
        string key_name = Keyboard key
        string target   = Command or function
        any arg         = Argument
        ...

    Return:
        nil
]]
function Bind:Add(key_name, target, ...)
    if key_name and target then
        local target_aux = ConCommand:GetFunction(target) or _G[target]

        if target_aux then
            self[string.upper(key_name)] = { func = target_aux, args = { ... } }
        else
            Package:Error("Unable to find command / function '" .. target .. "'")
        end
    else
        Package:Error("Usage: bind <keyname> <command or function>")
    end
end

--[[
    Remove key binds

    Arguments:
        string = Bind name
        ...

    Return:
        nil
]]
function Bind:Remove(...)
    local binds = table.pack(...)

    for _,key_name in ipairs(binds) do
        self[string.upper(key_name)] = nil
    end
end

-- ------------------------------------------------------------------------

-- Set bind and unbind commands
Client:Subscribe("Console", function(text)
    local parts = string.Explode(text, " ")

    if parts[1] == "bind" then
        table.remove(parts, 1)
        Bind:Add(table.unpack(parts))

        return
    end

    if parts[1] == "unbind" then
        table.remove(parts, 1)
        Bind:Remove(table.unpack(parts))

        return
    end
end)

-- Call binds
Client:Subscribe("KeyPress", function(key_name)
    if Bind[string.upper(key_name)] then
        return Bind[string.upper(key_name)].func(table.unpack(Bind[string.upper(key_name)].args))
    end
end)
