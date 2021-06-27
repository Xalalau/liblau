

--[[
    TO-DO: In the current game state the File lib is horrible... So in the future when we
    can do things like read dates and check if files exist decently, I need to re-implement
    file.lua.
]]


_File = {
    -- File lists
    list = {}, -- { string path, ... }
    list_easy_check = {}  -- { [string path] = string creation date, ... }
}

-- Initialize package files list
local function Init()
    local package_name = LL:GetCallInfo(3)

    for k,v in ipairs(Package:GetFiles()) do
        -- Ignore git files
        if not string.find(v, ".git") then
            table.insert(_File.list, v)
            local lua_file = File("Packages/" .. package_name .. "/" .. v)
            _File.list_easy_check[v] = lua_file:Time()
            lua_file:Close()
        end
    end
end
if SERVER then
    Init()
end

-- Sort files list
-- Less points = the file has precedence
local function Sort(list)
    table.sort(list, function(a, b)
        local points_a = 0
        local points_b = 0

        -- Precedence: Folder on Top > Bottom
        local function checkFoldersPrecedence(str)
            local folders_precedence = {
                "Shared",
                "Server",
                "Client"
            }

            for k,v in ipairs(folders_precedence) do
                if str:find(v) then
                    return 50000 * k
                end
            end

            return 0
        end

        points_a = points_a + checkFoldersPrecedence(a)
        points_b = points_b + checkFoldersPrecedence(b)

        -- Precedence: Less bars > More bars
        a:gsub("([^/]+)", function()
            points_a = points_a + 1
        end)

        b:gsub("([^/]+)", function()
            points_b = points_b + 1
        end)

        -- Precedence: selected sorting
        if sorting == "nameasc" and a:lower() < b:lower() or 
           sorting == "namedesc" and a:lower() > b:lower() or 
           sorting == "dateasc" and _File.list_easy_check[a] < _File.list_easy_check[b] or
           sorting == "datedesc" and _File.list_easy_check[a] > _File.list_easy_check[b]
            then
            points_b = points_b + 0.00001
        else
            points_a = points_a + 0.00001
        end

        return points_a < points_b
    end)
end

-- ------------------------------------------------------------------------

--[[
    Search for files and folders

    Arguments:
        string name    ("*")       = File name
        string path    ("")        = Relative file path
        string sorting ("nameasc") =
            "nameasc"  = sort the files ascending by name
            "namedesc" = sort the files descending by name
            "dateasc"  = sort the files ascending by date
            "datedesc" = sort the files descending by date

    Return:
        bool
]]
function _File:Find(name, path, sorting)
    local filename = not name and "*" or string.StripExtension(name)
    local extension = string.GetExtension(name)
    path = path or ""
    sorting = sorting or "nameasc"

    if CLIENT and sorting == "dateasc" or sorting == "datedesc" then
        Package:Error("Error. Nano's World doesn't support reading file dates in the clientside yet")
        return
    end

    -- Remove bar from the beginning
    if path:sub(1,1) == "/" then
        path = path:sub(2, #path)
    end

    -- Get module files 
    local package_files = {}
    for k,v in ipairs(self.list) do
        if (not extension or string.find(v, extension)) and
           (string.find(v, path) == 1) and
           (filename == "*" or string.find(v, name)) then
            table.insert(package_files, v)
        end
    end

    -- Sort files list
    Sort(package_files)

    -- Build dir structure
    local dir_tree = {}

    for _,path in ipairs(package_files) do
        local last_folder = dir_tree

        for subStr in path:gmatch("([^/]+)") do
            if not string.GetExtension(subStr) then
                last_folder[subStr] = last_folder[subStr] or {}
                last_folder = last_folder[subStr]
            else
                table.insert(last_folder, subStr)
            end
        end
    end

    return dir_tree
end
