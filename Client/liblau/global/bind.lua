Bind = {
    -- Bind list
    -- { [string key name] = { func = function callback, value = string value }, ... }
    list = {}
}

--[[
    Add a key bind

    Arguments:
        string key_name = Keyboard key
        string target   = Cvar or command or function
        string value    = Bind value

    Return:
        nil
]]
local function BindAdd(key_name, target, ...)
    if key_name and target then
        local target_function = Cvars:Get(target) or ConCommand:Get(target) or _G[target]

        if target_function then
            Bind.list[string.upper(key_name)] = { func = target_function, args = { ... } }
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
local function BindRemove(...)
    local binds = table.pack(...)

    for _,key_name in ipairs(binds) do
        Bind.list[string.upper(key_name)] = nil
    end
end

-- ------------------------------------------------------------------------

--[[
    Get a key bind

    Arguments:
        string key_name = Keyboard key

    Return:
        table bind = Bind list entry
        nil
]]
function Bind:Get(key_name)
    return self.list[string.upper(key_name or "")] and table.Copy(self.list[string.upper(key_name)])
end

--[[
    Get a copy of all binds

    Arguments:
        nil

    Return:
        table binds = Bind list
]]
function Bind:GetAll()
    return table.Copy(self.list)
end

-- ------------------------------------------------------------------------

-- Set bind and unbind commands
Client:Subscribe("Console", function(text)
    local parts = string.Explode(text, " ")

    if parts[1] == "bind" then
        BindAdd(parts[2], parts[3], table.Concat(parts, " ", 4))

        return
    end

    if parts[1] == "unbind" then
        BindRemove(table.unpack(parts))

        return
    end
end)

-- Call binds
Client:Subscribe("KeyPress", function(key_name)
    if Bind.list[string.upper(key_name)] then
        return Bind.list[string.upper(key_name)].func(table.unpack(Bind.list[string.upper(key_name)].args))
    end
end)
