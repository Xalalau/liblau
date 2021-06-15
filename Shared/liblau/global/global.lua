-- Valve like CLIENT/SERVER macros
CLIENT = Client and true
SERVER = Server and true

--[[
    Check variable type

    Arguments:
        any var           = The variable to be checked
        string checkType  = A type
        table checkFields = { "Field name", ... } -- Check if the fields exist
    
    Return:
        bool
]]
local function is_checktype(var, checkType)
    if not var or not checkType or type(checkType) ~= "string" then return false end
    return type(var) == checkType or false
end

local function is_checkmeta(var, checkMeta)
    if not var or not checkMeta or not istable(var) then return false end
    return getmetatable(var) == checkMeta or false
end

function isbool(var) return is_checktype(var, "boolean") end
function isfunction(var) return is_checktype(var, "function") end
function isnumber(var) return is_checktype(var, "number") end
function isrotator(var) return is_checkmeta(var, Rotator) end
function isstring(var) return is_checktype(var, "string") end
function istable(var) return is_checktype(var, "table") end
function isvector(var) return is_checkmeta(var, Vector) end
function isvector2d(var) return is_checkmeta(var, Vector2D) end

--[[
    Make print accept multiple arguments (detour)

    Arguments:
        any var = The variable to be printed
        ...

    Return:
        nil
]]
local _print = print
function print(...)
    local str = ""
    local args = { ... }

    for _,arg in ipairs(args) do
        str = str .. tostring(arg) .. "    "
    end

    _print(str)
end
