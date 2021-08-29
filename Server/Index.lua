LL = LL

if LL.sv_initialized then return end
LL.sv_initialized = true

-- Live reloading for selected folders
-- Entries are read[string package name] addresses
local LL_live_reloading = {}

--[[
    Set live reloading to a folder

    Arguments:
        string scope        = "Server", "Client" or "Shared". Can be set as "All" to easyly select the three
        string path         = Any path from any package and scope. No path = the entire scope

        string package_name = Repass the package name, internal use only

    Return:
        nil
]]
function LL.SetLiveReloading(scope, path, package_name)
    if not path then path = "" end
    if scope ~= "All" and scope ~= "Server" and scope ~= "Client" and scope ~= "Shared" then
        Package.Error("| [Live Reloading] Bad Scope selected for '" .. path .. "'")
        Package.Error(debug.traceback())
        return 
    end

    local title
    package_name = package_name or LL.GetCallInfo(3)

    -- Remove folder bars
    path:gsub("/", "")
    path:gsub("\\", "")

    -- Fully set all scopes
    if scope == "All" then
        -- Drop older running live reloadings
        if LL_live_reloading[package_name] then
            LL_live_reloading[package_name] = {}
            Package.Log("| Dropped older orders to set all folders")
        end

        -- Set each scope
        LL.SetLiveReloading("Shared", path, package_name)
        LL.SetLiveReloading("Server", path, package_name)
        LL.SetLiveReloading("Client", path, package_name)

        return
    -- Prepare / Check the LL_live_reloading table for the selected operation
    else
        if not LL_live_reloading[package_name] then
            LL_live_reloading[package_name] = {}
            title = package_name
        end

        if not LL_live_reloading[package_name][path] then
            LL_live_reloading[package_name][path] = {}
        end

        if LL_live_reloading[package_name][path][scope] then
            return
        else
            if not LL.read[package_name][path] then
                LL.ReadFolder(path, package_name, scope)
            end

            LL_live_reloading[package_name][path][scope] = LL.read[package_name][path][scope]
        end
    end

    -- Print the package name
    if title then
        Package.Warn("# Set Live Reloading - " .. package_name)
    end

    -- Ignore empty folders
    if #LL_live_reloading[package_name][path][scope] == 0 then
        return
    end

    -- Print message
    Package.Log("| " .. scope .. (path == "" and "" or "/" .. path) .. "/*")

    -- Set the live reloading (check for changes every 0.33s)
    Timer.SetInterval(function(package_name, path)
        local scopes = LL_live_reloading[package_name][path]

        if not scopes then
            return true
        end

        for scope,file_list in pairs(scopes) do
            for _,info in pairs(file_list) do
                local currentFileTime = File.Time("Packages/" .. package_name .. "/" .. info.path)

                if currentFileTime ~= info.time then
                    Server.ReloadPackage(Package.GetName())
                end
            end
        end
    end, 330, package_name, path)
end
