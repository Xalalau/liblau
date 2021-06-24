--[[
    Check if the table has a given value

    Arguments:
        table tab    = The table where to search
        string value = The value to be found

    Return:
        bool
]]
function table.HasValue(tab, value)
    if not IsTable(tab) then return false end

    for k,v in pairs(tab) do
        if v == value then return true end
    end

    return false
end

--[[
    Safely prints a entire table to the console

    Arguments:
        table tab       = The table to convert
        string tab_name = A name to identify the table

    Return:
]]
function table.Print(tab, tab_name)
    if not IsTable(tab) then return end

    local lines = string.GetLines(table.ToString(tab, tab_name))

    for k,v in ipairs(lines) do
        print(v)
    end
end

--[[
    Covert a table into a string

    Arguments:
        table tab       = The table to convert
        string tab_name = A name to identify the table

        str and indent are for internal use

    Return:
        string str = The converted table
        nil
]]
function table.ToString(tab, tab_name, str, indent)
    if not IsTable(tab) then return end

    local first_call = not str

    if first_call then str = (tab_name or "Table") .. " = {\n" end

    local last_indent = indent or ""
    indent = "    " .. (indent or "")

    for k,v in pairs(tab) do
        str = str .. indent .. "[" .. (IsString(k) and "\"" or "") .. tostring(k) .. (IsString(k) and "\"" or "") .. "]" -- K
        if IsBasicTable(v) then
            str = str .. " = {\n"
            str = table.ToString(v, tab_name, str, indent)
        else
            str = str .. " = " .. (IsString(v) and "\"" or "") .. tostring(v) .. (IsString(v) and "\"" or "") .. ",\n" -- V
        end
    end

    str = str .. last_indent .. "}" .. (not first_call and "," or "") .. "\n"

    return str
end

--[[
    Creates a table copy

    Arguments:
        table tab = The table to be copied

    Return:
        table copy = The new allocated table
]]
function table.Copy(tab)
    if not IsTable(tab) then return end

    local copy = {}

    for k,v in pairs(tab) do
        if IsBasicTable(v) then
            table.Copy(v, tab_name, str, indent)
        else
            if IsVector(v) then
                v = Vector(v.X, v.Y, v.Z)
            elseif IsVector2D(v) then
                v = Vector2D(v.X, v.Y)
            elseif IsRotator(v) then
                v = Rotator(v.Pitch, v.Yaw, v.Roll)
            elseif IsColor(v) then
                v = Color(v.R, v.G, v.B, v.A)
            elseif IsQuat(v) then
                v = Quat(v.X, v.Y, v.Z, v.W)
            end

            copy[k] = v
        end
    end

    return copy
end

--[[
    Counts the amount of keys in a table
    Use # when a table is numerically and sequentially indexed

    Arguments:
        table tab = The table to count the keys

    Return:
        int i = Total keys
        nil
]]
function table.Count(tab)
    if not IsTable(tab) then return end

    local i = 0

    for k,v in pairs(tab) do
        i = i + 1
    end

    return i
end