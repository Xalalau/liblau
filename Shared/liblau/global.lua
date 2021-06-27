-- Valve like CLIENT/SERVER macros
CLIENT = Client and true
SERVER = Server and true

--[[
    Check variable type

    Arguments:
        any var = The variable to be checked
    
    Return:
        bool
]]
function IsBasicTable(var) return type(var) == "table" and not getmetatable(var) end -- Pure Lua table type
function IsBool(var) return type(var) == "boolean" end
function IsBool(var) return type(var) == "boolean" end
function IsColor(var) return getmetatable(var) == Color end
function IsFunction(var) return type(var) == "function" end
function IsNumber(var) return type(var) == "number" end
function IsQuat(var) return getmetatable(var) == Quat end -- Quaternion
function IsRotator(var) return getmetatable(var) == Rotator end
function IsString(var) return type(var) == "string" end
function IsTable(var) return type(var) == "table" end -- All kinds of tables, even Vector() and Rotator()
function IsVector(var) return getmetatable(var) == Vector end
function IsVector2D(var) return getmetatable(var) == Vector2D end
function IsUserdata(var) return type(var) == "userdata" end

--[[
    Iterate a table with all keys sorted alphabetically

    Arguments:
        table tab  = The variable to be iterated
        bool  desc = Sort the order reversed (descending)
    
    Return:
        function iterator
]]
function SortedPairs(tab, desc)
    local keys, len = {}, 0

    for k, v in pairs(tab) do
        len = len + 1
        keys[len] = IsNumber(k) and v or k
    end

    table.sort(keys, function(a,b)
        return (desc and a or b):lower() > (desc and b or a):lower()
    end)

    local k = 0
    return function()
        k = k + 1
        if IsBasicTable(tab[keys[k]]) then
            return keys[k], tab[keys[k]]
        elseif tab[k] then
            return k, keys[k]
        end
    end
end

--[[
    Change variable type to boolean

    Arguments:
        any var = The variable to be converted
    
    Return:
        bool
]]
function toBool(var)
    return var and var ~= "" and tonumber(var) ~= 0 and var ~= "false" and true or false
end