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
function IsColor(var) return getmetatable(var) == Color end
function IsFunction(var) return type(var) == "function" end
function IsNumber(var) return type(var) == "number" end
function IsRotator(var) return getmetatable(var) == Rotator end
function IsString(var) return type(var) == "string" end
function IsTable(var) return type(var) == "table" end -- All kinds of tables, even Vector() and Rotator()
function IsVector(var) return getmetatable(var) == Vector end
function IsVector2D(var) return getmetatable(var) == Vector2D end
function IsUserdata(var) return type(var) == "userdata" end
