--[[
    Check if the table has a given value

    Arguments:
        table tab    = The table where to search
        string value = The value to be found

    Return:
        bool
]]
function table.HasValue(tab, value)
    if not value then return false end

    for k,v in pairs(tab) do
        if v == value then return true end
    end

    return false
end

--[[
    Safely prints a entire table to the console

    Arguments:
        table tab      = The table to convert
        string tabName = A name to identify the table

    Return:
]]
function table.Print(tab, tabName)
    if not tab then return end

    local lines = string.GetLines(table.ToString(tab, tabName))

    for k,v in ipairs(lines) do
        print(v)
    end
end

--[[
    Covert a table into a string

    Arguments:
        table tab      = The table to convert
        string tabName = A name to identify the table

        str and indent are for internal use

    Return:
        string str = The converted table
        nil
]]
function table.ToString(tab, tabName, str, indent)
    if not tab then return end

    if not str then str = (tabName or "Table") .. " = {\n" end

    local lastIndent = indent or ""
    indent = "    " .. (indent or "")

    for k,v in pairs(tab) do
        if IsTable(v) then
            str = str .. indent ..  tostring(k) .. " = {\n"
            str = table.ToString(v, tabName, str, indent)
        else
            str = str .. indent .. tostring(k) .. " = " .. tostring(v) .. "\n"
        end
    end

    str = str .. lastIndent .. "}\n"

    return str
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
    if not tab then return end

    local i = 0

    for k,v in pairs(tab) do
        i = i + 1
    end

    return i
end