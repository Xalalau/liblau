--[[
    Get the file extension

    Arguments:
        string path = Full file path

    Return:
        string ext = Extension starting with a dot
        nil
]]
function string.getextension(path)
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
function string.getlines(str)
    return string.split(str, "\r\n")
end

--[[
    Explode a string

    Arguments:
        string str = The string to be exploded
        string sep = The pattern to be used as separator

    Return:
        table list = Table with the exploded values
        nil
]]
function string.split(str, sep)
    if not str then return end
    if not sep then sep = "%s" end

    local list = {}

    for subStr in str:gmatch("([^"..sep.."]+)") do
        table.insert(list, subStr)
    end

    return list
end