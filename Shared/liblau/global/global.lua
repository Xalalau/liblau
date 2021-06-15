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
local function is(var, checkType, checkFields)
    if not var or not checkType or type(checkType) ~= "string" then return false end

    if checkFields then
        if type(checkFields) == "table" then
            for _,field in ipairs(checkFields) do
                if not var[field] then
                    return false
                end
            end
        else
            return false
        end
    end

    return type(var) == checkType or false
end

function isbool(var) return is(var, "boolean") end
function isfunction(var) return is(var, "function") end
function isnumber(var) return is(var, "number") end
function isrotator(var) return is(var, "table", { "Pitch", "Yall", "Roll", "RotateVector" }) end
function isstring(var) return is(var, "string") end
function istable(var) return is(var, "table") and not isvector2d(var) and not isvector(var) and not isrotator(var) end
function isvector(var) return is(var, "table", { "X", "Y", "Z", "Distance" }) end
function isvector2d(var) return is(var, "table", { "X", "Y" }) and not var["Z"] end

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
