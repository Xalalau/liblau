if LL then return end

LL = {
    --[[
        Read folders list

        LL.read[string package name] = {
            [string addon folder] = {
                [string scope] = {
                    string path = relative file path,
                    (Server) number time = file creation time
                }
            },
            ...
        }, ...
    ]]
    read = {},
    -- Loaded LL.read entries
    -- { LL.read[string package name][string addon folder][string scope], ... }
    loaded = {}
}

--[[
    Get current calling package and scope
    This function is intended to work only within this file

    Arguments:
        up_threads = The amount of call levels to go up

    Return:
        string tbl[1] = The calling package name; string tbl[2] = The calling scope; string file = The calling file
]]
function LL.GetCallInfo(up_threads)
    local tbl, i = {}, 0
    local call_info = debug.getinfo(up_threads)

    if not call_info then return end

    local file = call_info.source

    for info in file:gsub("\\", "/"):gmatch("([^/]+)") do
        i = i + 1
        table.insert(tbl, info)
        if i == 2 then break end
    end

    return tbl[1], tbl[2], file
end

--[[
    Populate a entry in LL.read folder

    Arguments:
        string package_name  = The calling package name
        string addon_folder  = The relative target addon path in any scope
        string current_scope = The calling scope

    Return:
        nil
]]
function LL.ReadFolder(package_name, addon_folder, current_scope)
    -- Init files structure
    if not LL.read[package_name] then
        LL.read[package_name] = {}
    end

    if not LL.read[package_name][addon_folder] then
        LL.read[package_name] = {
            [addon_folder] = {
                ["Shared"] = {},
                ["Server"] = {},
                ["Client"] = {}
            }
        }
    else
        return
    end

    -- Get module files 
    local package_files = {}
    for k, path in ipairs(Package.GetFiles()) do
        if not string.find(path, ".git") and
           string.sub(path, -4, -1) == ".lua" and
           not string.find(path, "/Index.lua") and
           string.find(path, addon_folder .. "/") then
            table.insert(package_files, path)
        end
    end

    -- Sort module files
    -- Less points = the file has precedence
    table.sort(package_files, function(a, b)
        local points_a = 0
        local points_b = 0
        a:gsub("([^/]+)", function()
            points_a = points_a + 1
        end)
        b:gsub("([^/]+)", function()
            points_b = points_b + 1
        end)
        if a:lower() < b:lower() then
            points_b = points_b + 0.02
        else
            points_a = points_a + 0.01
        end
        return points_a < points_b
    end)

    -- Get package files
    for _,path in ipairs(package_files) do
        local scope 

        -- Get the current file scope
        if string.find(path, "Shared/") then
            scope = "Shared"
        elseif Server and string.find(path, "Server/") then
            scope = "Server"
        elseif string.find(path, "Client/") then
            scope = "Client"
        end

        -- Store the file path and file creation time
        if scope then
            if Server then
                table.insert(LL.read[package_name][addon_folder][scope], { path = path, time = File.Time("Packages/" .. package_name .. "/" .. path) })
            else
                table.insert(LL.read[package_name][addon_folder][scope], { path = path })
            end
        end
    end
end

--[[
    Require lua files from "Package/Scope/MyAddon" folder

    To load files from a scope (Shared/Server/Client) just call LL.RequireFolder(addon_folder) in the respective Index.lua

    In addition, internal dependencies must also be structured in folders for everything to work well. e.g.

    Package/Shared/MyAddon/libA.lua
    Package/Shared/MyAddon/NewFolder/iuselibA.lua
    Package/Shared/MyAddon/NewFolder/ialsouselibA.lua

    So iuselibA.lua and ialsouselibA.lua will load after libA.lua and access its global functions and variables

    Arguments:
        string addon_folder = The relative target addon path in any scope
        bool   list_files   = Show all the loaded files for a detailed overview

    Return:
        nil
]]
function LL.RequireFolder(addon_folder, list_files)
    if not addon_folder then return end
    list_files = true

    -- Remove folder bars
    addon_folder:gsub("/", "")
    addon_folder:gsub("\\", "")

    -- Call info
    local package_name, current_scope = LL.GetCallInfo(4)

    -- Build LL.loaded table
    if not LL.loaded[package_name] then
        LL.loaded[package_name] = {}
    end

    if not LL.loaded[package_name][addon_folder] then
        LL.loaded[package_name][addon_folder] = {}
    end

    if not LL.loaded[package_name][addon_folder][current_scope] then
        -- Read folder
        LL.ReadFolder(package_name, addon_folder, current_scope)
        LL.loaded[package_name][addon_folder][current_scope] = LL.read[package_name][addon_folder][current_scope]
    else
        return
    end

    -- Print the package name
    local title = not LL.loaded[package_name] and package_name

    if title then
        Package.Warn("# Loading - " .. package_name)
    end

    -- Require Lua files and print the results
    for _,info in ipairs(LL.loaded[package_name][addon_folder][current_scope]) do
        Package.Require(package_name .. "/" .. info.path)
        
        if list_files then -- Detailed print message
            Package.Log("| Packages/" .. package_name .. "/" .. info.path)
        end
    end

    if not list_files then -- General
        Package.Log("| " .. current_scope .. "/" .. addon_folder .. "/*")
    end
end

-- Load liblau
LL.RequireFolder("libs")

-- Cvar
if CVar then
    CVar.Add("sv_cheats", "Enable cheat commands", false, false, { FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_REPLICATED })
end
