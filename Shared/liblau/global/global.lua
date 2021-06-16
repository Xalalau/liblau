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
function IsBool(var) return type(var) == "boolean" end
function IsFunction(var) return type(var) == "function" end
function IsNumber(var) return type(var) == "number" end
function IsRotator(var) return getmetatable(var) == Rotator end
function IsString(var) return type(var) == "string" end
function IsTable(var) return type(var) == "table" end
function IsVector(var) return getmetatable(var) == Vector end
function IsVector2d(var) return getmetatable(var) == Vector2D end
