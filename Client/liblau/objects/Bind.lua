Bind = {}

local bind_list = {
    --[[
        [string key name] = {
            function func = Function callback,
            table    args = { any arg, ... }
        },
        ...
    ]]
}

--[[
    Add a key bind

    Arguments:
        string key_name = Keyboard key
        string target   = Cvar or command or function name
        any    ...      = Arguments

    Return:
        nil
]]
local function BindAdd(key_name, target, ...)
    if key_name and target then
        local console = CVar:Get(target) or ConCommand:Get(target)
        local func = console and console.func or _G[target]

        if func then
            bind_list[string.upper(key_name)] = { func = func, args = { ... } }
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
        string ... = Bind names

    Return:
        nil
]]
local function BindRemove(...)
    local binds = table.pack(...)

    for _,key_name in ipairs(binds) do
        bind_list[string.upper(key_name)] = nil
    end
end

-- ------------------------------------------------------------------------

--[[
    Check if a bind exists

    Arguments:
        string key_name = Keyboard key

    Return:
        bool
]]
function Bind:Exists(key_name)
    return bind_list[string.upper(key_name or "")] and true or false
end

--[[
    Get a key bind

    Arguments:
        string key_name = Keyboard key

    Return:
        table bind = Bind list entry
        nil
]]
function Bind:Get(key_name)
    return Bind:Exists(key_name) and table.Copy(bind_list[string.upper(key_name)])
end

--[[
    Get a copy of all binds

    Arguments:
        nil

    Return:
        table binds = Bind list
]]
function Bind:GetAll()
    return table.Copy(bind_list)
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
    if bind_list[string.upper(key_name)] then
        return bind_list[string.upper(key_name)].func(table.unpack(bind_list[string.upper(key_name)].args))
    end
end)
