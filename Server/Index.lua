LL = LL

if LL.liveReloading then return end

LL.liveReloading = {
    -- Live reloading for selected folders
    -- Entries are read[string package name] addresses
    liveReloading = {}
}

--[[
    Set live reloading to a folder

    Arguments:
        string scope       = "Server", "Client" or "Shared". Can be set as "All" to easyly select the three
        string path        = Any path from any package and scope. No path = the entire scope
        string packageName = Repass the package name, internal use only

    Return:
        nil
]]
function LL:SetLiveReloading(scope, path, packageName)
    if not path then path = "" end
    if scope ~= "All" and scope ~= "Server" and scope ~= "Client" and scope ~= "Shared" then
        Package:Error("| [Live Reloading] Bad Scope selected for '" .. path .. "'")
        Package:Error(debug.traceback())
        return 
    end

    local title
    packageName = packageName or self.GetCallInfo()

    -- Remove folder bars
    path:gsub("/", "")
    path:gsub("\\", "")

    -- Fully set all scopes
    if scope == "All" then
        -- Drop older running live reloadings
        if self.liveReloading[packageName] then
            self.liveReloading[packageName] = {}
            Package:Log("| Dropped older orders to set all folders")
        end

        -- Set each scope
        self:SetLiveReloading("Shared", path, packageName)
        self:SetLiveReloading("Server", path, packageName)
        self:SetLiveReloading("Client", path, packageName)

        return
    -- Prepare / Check the LL.liveReloading table for the selected operation
    else
        if not self.liveReloading[packageName] then
            self.liveReloading[packageName] = {}
            title = packageName
        end

        if not self.liveReloading[packageName][path] then
            self.liveReloading[packageName][path] = {}
        end

        if self.liveReloading[packageName][path][scope] then
            return
        else
            if not self.read[packageName][path] then
                self:ReadFolder(path, packageName, scope)
            end

            self.liveReloading[packageName][path][scope] = self.read[packageName][path][scope]
        end
    end

    -- Print the package name
    if title then
        Package:Warn("# Set Live Reloading - " .. packageName)
    end

    -- Ignore empty folders
    if #self.liveReloading[packageName][path][scope] == 0 then
        return
    end

    -- Print message
    Package:Log("| " .. scope .. (path == "" and "" or "/" .. path) .. "/*")

    -- Set the live reloading (check for changes every 0.33s)
    Timer:SetTimeout(330, function(packageName, path)
        local scopes = LL.liveReloading[packageName][path]

        if not scopes then
            return true
        end

        for scope,fileList in pairs(scopes) do
            for _,info in pairs(fileList) do
                luaFile = File("Packages/" .. packageName .. "/" .. info.path)

                if luaFile:IsBad() or luaFile:Time() ~= info.time then -- How 'IsBad' works?
                    luaFile:Close()

                    Server:ReloadPackage(Package:GetName())
                else
                    luaFile:Close()
                end
            end
        end
    end, { packageName, path })
end
