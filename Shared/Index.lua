if LL then return end

LL = {
    --[[
        List loaded folders

        read[string package name] = {
            [number index] = {
                [string scope] = {
                    string path = relative file path,
                    number time = file creation time
                }
            },
            ...
        }
    ]]
    read = {},
    -- List loaded folders
    -- Entries are read[string package name] addresses
    loaded = {}
}

--[[
    Get current calling package and scope
    This function is intended to work only within this file

    Arguments:
        nil

    Return:
        string tbl[1] = The calling package name
        string tbl[2] = The calling scope
        string file   = The calling file
]]
function LL:GetCallInfo()
    local tbl, i = {}, 0

    local file = debug.getinfo(3).source

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
        string addonPath    = The relative target addon path in any scope
        string packageName  = The calling package name
        string currentScope = The calling scope

    Return:
        nil
]]
function LL:ReadFolder(addonPath, packageName, currentScope)
    -- Init files structure
    if not LL.read[packageName] then
        LL.read[packageName] = {}
    end

    if not LL.read[packageName][addonPath] then
        LL.read[packageName] = {
            [addonPath] = {
                ["Shared"] = {},
                ["Server"] = {},
                ["Client"] = {}
            }
        }
    else
        return
    end

    -- Get package files
    for _,path in ipairs(Package:GetFiles()) do
        -- Filter Lua files
        if string.sub(path, -4, -1) == ".lua" then
            -- Filter addonPath files
            if addonPath == "" or string.find(path, addonPath .. "/") then
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
                    local luaFile = File("Packages/" .. packageName .. "/" .. path)
                    table.insert(LL.read[packageName][addonPath][scope], { path = path, time = luaFile:Time() })
                    luaFile:Close()
                end
            end
        end
    end
end

--[[
    Require lua files from "Package/Scope/MyAddon" folder

    To load files from a scope (Shared/Server/Client) just call LL:RequireFolder(addonPath) in the respective Index.lua

    In addition, internal dependencies must also be structured in folders for everything to work well. e.g.

    Package/Shared/MyAddon/libA.lua
    Package/Shared/MyAddon/NewFolder/iuselibA.lua
    Package/Shared/MyAddon/NewFolder/ialsouselibA.lua

    So iuselibA.lua and ialsouselibA.lua will load after libA.lua and access its global functions and variables

    Arguments:
        string addonPath = The relative target addon path in any scope
        bool   listFiles = Show all the loaded files for a detailed overview

    Return:
        nil
]]
function LL:RequireFolder(addonPath, listFiles)
    if not addonPath then return end

    -- Remove folder bars
    addonPath:gsub("/", "")
    addonPath:gsub("\\", "")

    local packageName, currentScope = self.GetCallInfo()

    -- Set package title (once)
    local title = not self.loaded[packageName] and packageName

    -- Read folder
    self:ReadFolder(addonPath, packageName, currentScope)

    -- Prepare / Check the LL.loaded table
    if not self.loaded[packageName] then
        self.loaded[packageName] = {}
    end

    if not self.loaded[packageName][addonPath] then
        self.loaded[packageName][addonPath] = {}
    end

    if not self.loaded[packageName][addonPath][currentScope] then
        self.loaded[packageName][addonPath][currentScope] = self.read[packageName][addonPath][currentScope]
    else
        return
    end

    -- Print the package name
    if title then
        Package:Warn("# Loading - " .. packageName)
    end

    for _,info in ipairs(self.loaded[packageName][addonPath][currentScope]) do
        -- Require Lua file
        Package:Require(string.sub(info.path, 7, -1))

        -- Print message (file)
        if listFiles then
            Package:Log("| " .. currentScope .. "/" .. info.path)
        end
    end

    -- Print message (folder)
    if not listFiles then
        Package:Log("| " .. currentScope .. "/" .. addonPath .. "/*")
    end
end

-- Load liblau
LL:RequireFolder("liblau")
