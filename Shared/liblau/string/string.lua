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

    local ext

    for i = 2, 5, 1 do
        if string.sub(path, -i, -i) == "." then
            ext = string.sub(path, -i, -1)
            break
        end
    end

    return ext
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
    Explode a string

    Arguments:
        string str           = The string to be exploded
        string sep           = The pattern to be used as separator

    Return:
        table list = Table with the exploded values
        nil
]]
function string.Explode(str, sep)
    if not str or not sep then return end
    str = string.PatternFormat(str)

    local list = {}

    for subStr in str:gmatch("([^" .. sep .. "]+)") do
        table.insert(list, subStr)
    end

    return list
end

--[[
    Escape some string characters to use it with Lua pattern

    Arguments:
        string str = The string to be formatted

    Return:
        string str = The formatted string
]]
function string.PatternFormat(str)
    return str:gsub(".", {
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
    })
end