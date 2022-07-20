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
        local args = { ... }
        local console = CVar.Get(target) or ConCommand.Get(target)
        local func = console and console.func or _G[target]

        if func then
            local bind_exists = Bind.Exists(key_name)
            local print_args = args[1] and "(\"" .. table.Concat(args, "\", \"") .. "\")" or ""

            print((bind_exists and "Rebinding" or "Binding") .. " '" .. string.upper(key_name) .. "' key to '" .. target .. print_args .. "'")
            bind_list[string.upper(key_name)] = { func = target, args = args }

            Package.SetPersistentData("LL_Bind_" .. string.upper(key_name) .. "_" .. target, args)
        else
            Package.Error("Unable to find command / function '" .. target .. "'")
        end
    else
        Package.Error("Usage: bind <keyname> <command or function name>")
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
        if Bind.Exists(key_name) then
            print("Removing '".. key_name .."' bind...")
            bind_list[string.upper(key_name)] = nil

            local keyPartialName = "LL_Bind_" .. string.upper(key_name)
            for k,v in pairs(Package.GetPersistentData()) do
                if string.find(k, keyPartialName) == 1 then
                    Package.SetPersistentData(k, nil)

                    break
                end
            end
        end
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
function Bind.Exists(key_name)
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
function Bind.Get(key_name)
    return Bind.Exists(key_name) and table.Copy(bind_list[string.upper(key_name)])
end

--[[
    Get a copy of all binds

    Arguments:
        nil

    Return:
        table binds = Bind list
]]
function Bind.GetAll()
    return table.Copy(bind_list)
end

-- ------------------------------------------------------------------------

-- Set commands
ConCommand.Add("bind", function(player, command, args)
    local key_name = args[1]
    local target = args[2]
    table.remove(args, 1)
    table.remove(args, 1)
    BindAdd(key_name, target, table.unpack(args))
end)

ConCommand.Add("bind_list", function()
    local list = Bind.GetAll()

    if table.IsEmpty(list) then
        print("There are no binds loaded")
    else
        for k, v in SortedPairs(Bind.GetAll()) do
            print(string.format("%-10s %s", k, tostring(v.func)))
        end
    end
end)

ConCommand.Add("unbind", function(player, command, args)
    BindRemove(table.unpack(args))
end)

ConCommand.Add("unbind_all", function(player, command, args)
    local list = {}

    for k, v in SortedPairs(Bind.GetAll()) do
        table.insert(list, k)
    end
 
    if table.IsEmpty(list) then
        print("No binds to remove")
    else
        BindRemove(table.unpack(list)) 
    end
end)

-- Call binds
Client.Subscribe("KeyPress", function(key_name)
    if bind_list[string.upper(key_name)] then
        local target = bind_list[string.upper(key_name)].func
        local console = CVar.Get(target) or ConCommand.Get(target)
        local func = console and console.func or _G[target]

        return func(table.unpack(bind_list[string.upper(key_name)].args))
    end
end)

-- Restore old binds
Package.Subscribe("Load", function()
    Timerx.Simple(0.1, function()
        local applyied = {}

        for k,v in pairs(Package.GetPersistentData()) do
            if string.find(k, "LL_Bind") == 1 then
                local id = string.Explode(k:sub(9, #k), "_")
                local key_name = id[1]
                local target = id[2]
                local args = v

                if applyied[key_name] then
                    Package.SetPersistentData(applyied[key_name], nil)
                end
                applyied[key_name] = k

                BindAdd(key_name, target, table.unpack(args))
            end
        end
    end)
end)
