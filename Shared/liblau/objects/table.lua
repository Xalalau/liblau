-- Create a new var instead of copying the address
local function CopyCustomTableType(v)
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

    return v
end

-- ------------------------------------------------------------------------

--[[
    Creates a table copy

    Arguments:
        table tab = The table to be copied

    Return:
        table copy = The new allocated table
        nil
]]
function table.Copy(tab)
    if not IsTable(tab) then return end

    local copy = {}

    for k,v in pairs(tab) do
        if IsBasicTable(v) then
            copy[k] = table.Copy(v, v)
        else
            copy[k] = CopyCustomTableType(v)
        end
    end

    return copy
end

--[[
    Concatenate all values of a sequential table 
    It doesn't read subtables

    Arguments:
        table  tab                 = Sequential table to generate the string
        string concatenator ("")   = Text to be pacled between each value
        int    startPos     (1)    = Starting point
        int    endPos       (#tab) = Finishing point

    Return:
        string text = Concatenated values
        nil
]]
function table.Concat(tab, concatenator, startPos, endPos)
    if not IsTable(tab) then return end

    concatenator = concatenator or ""
    startPos = startPos or 1
    endPos = endPos or #tab

    local str = ""

    for k,v in ipairs(tab) do
        if k > endPos then break end
        if not IsTable(v) then
            if k >= startPos then
                str = str .. concatenator .. v
            end
        end
    end

    return str:sub(concatenator:len() + 1, #str)
end

--[[
    Counts the amount of keys in a table
    Use # when a table is numerically and sequentially indexed
    It doesn't read subtables

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

--[[
    Check if the table has a given value

    Arguments:
        table tab    = The table where to search
        string value = The value to be found

    Return:
        bool
        nil
]]
function table.HasValue(tab, value)
    if not IsTable(tab) then return false end

    for k,v in pairs(tab) do
        if v == value then return true end
    end

    return false
end

--[[
    Check if the table is empty

    Arguments:
        table tab = The table to be verifyed

    Return:
        bool
        nil
]]
function table.IsEmpty(tab)
    if not IsTable(tab) then return end

    return not next(tab) and true or false
end

--[[
    Safely prints a entire table to the console

    Arguments:
        table tab       = The table to convert
        string tab_name = A name to identify the table

    Return:
        nil
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

    Return:
        string str = The converted table
        nil
]]
function table.ToString(tab, tab_name)
    if not IsTable(tab) then return end

    local function stringify(tab, str, indent, done)
        indent = "\t" .. indent

        for k,v in SortedPairs(tab) do
            local k_quotation = IsString(k) and "\"" or ""
            local v_quotation = IsString(v) and "\"" or ""
 
            str = str .. indent .. "[" .. k_quotation .. tostring(k) .. k_quotation .. "]"

            if IsBasicTable(v) and not done[v] then
                str = str .. " = {\n"
                done[v] = true
                str = stringify(v, str, indent, done)
                done[v] = nil
                str = str .. indent .. "},\n"
            else
                str = str .. " = " .. v_quotation .. tostring(v) .. v_quotation .. ",\n"
            end
        end

        return str
    end

    local str = (tab_name or "Table") .. " = {\n"
    str = stringify(tab, str, "", {})
    str = str .. "}\n"

    return str
end

--[[
    Transfer elements from one table to another

    Arguments:
        table base                   = Get table entries from base
        table target                 = Send table entries to target
        bool  modify_base     (true) = Set if the base table entries will be moved or copied
        bool  override_target (true) = Set if the target table existing entries will be overridden or kept

        Note: when modify_base is true and override_target is false, matching keys will be left behind in the base table

    Return:
        nil
]]
function table.Transfer(base, target, modify_base, override_target)
    if not IsTable(base) or not IsTable(target) then return end
    modify_base = modify_base == nil and true or modify_base
    override_target = override_target == nil and true or override_target

    for k,v in pairs(base) do
        if IsBasicTable(v) then
            target[k] = target[k] or {}
            table.Transfer(v, target[k], modify_base, override_target)

            if table.Count(base[k]) == 0 then
                base[k] = not modify_base and base[k] or nil
            end
        else
            local is_k_in_both = target[k] and base[k]
            if is_k_in_both and not override_target then
                goto continue
            end

            base[k] = not modify_base and base[k] or nil

            target[k] = not modify_base and CopyCustomTableType(v) or v
        end

        ::continue::
    end
end
