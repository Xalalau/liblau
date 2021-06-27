--[[
    Explode a string

    Arguments:
        string str = The string to be exploded
        string sep = The pattern to be used as separator

    Return:
        table list = Table with the exploded values
        nil
]]
function string.Explode(str, sep)
    if not str or not sep then return end

    local list = {}

    for subStr in str:FormatPattern():gmatch("([^" .. sep .. "]+)") do
        table.insert(list, subStr:FormatPattern(true))
    end

    return list
end

--[[
    Escape some string characters to use it with Lua pattern

    Arguments:
        string str       = The string to be formatted
        bool   setUnsafe = Restore scaped characters

    Return:
        string str = The formatted string
]]
function string.FormatPattern(str, setUnsafe)
    local replace = {
        ["["] = "%[",
        ["]"] = "%]",
        ["("] = "%(",
        [")"] = "%)",
        ["+"] = "%+",
        ["-"] = "%-",
        ["."] = "%.",
        ["^"] = "%^",
        ["\0"] = "%z",
        ["$"] = "%$",
        ["%"] = "%%",
        ["*"] = "%*",
        ["?"] = "%?"
    }

    if setUnsafe then
        for k,v in pairs(replace) do
            replace[k] = nil
        end
    end

    str = str:gsub(".", replace)

    if setUnsafe then
        str = str:gsub(".", { ["%"] = "" })
    end

    return str
end

--[[
    Correctly separate arguments in between quotes in varargs

    Arguments:
        string varargs = The function arguments

    Return:
        string varargs = The processed function arguments
]]
function string.FormatVarargs(...)
    local vargs = { ... }
    local vargs_str = table.Concat(vargs or {""}, " ")
    local new_vargs

    if string.find(vargs_str, "\"") then
        local in_quotes = false
        local part = ""
        new_vargs = {}

        local function addVArg()
            if part ~= "" then
                table.insert(new_vargs, part)
                part = ""
            end
        end

        for i = 1, #vargs_str do
            local c = vargs_str:sub(i,i)

            if c == "\"" then
                addVArg()
            end

            if not in_quotes and c == " " then
                addVArg()
            end

            if c ~= "\"" and c ~= " " then
                part = part .. c
            end
        end

        addVArg()
    end

    return table.unpack(new_vargs or vargs)
end

--[[
    Get the file extension

    Arguments:
        string path = Full file path

    Return:
        string ext = Extension starting with a dot
        nil
]]
function string.GetExtension(path)
    -- Note: the extension is max. 4 digits and min. 2 digits
    if not path or string.len(path) < 2 then return end

    for i = 2, 5, 1 do
        if string.sub(path, -i, -i) == "." then
            return string.sub(path, -i, -1)
        end
    end
end

--[[
    Get each line of a string as table entries

    Arguments:
        string str = The string to be chopped

    Return:
        table list = Table with the chopped lines
        nil
]]
function string.GetLines(str)
    return string.Explode(str, "\r\n")
end

--[[
    Get the file path without the extension

    Arguments:
        string path = Full file path

    Return:
        string str = File path without the extension
]]
function string.StripExtension(path)
    -- Note: the extension is max. 4 digits and min. 2 digits
    if not path or string.len(path) < 2 then return path end

    for i = 2, 5, 1 do
        if string.sub(path, -i, -i) == "." then
            return string.sub(path, 1, - (i + 1))
        end
    end

    return path
end