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
function isbool(var) return type(var) == "boolean" end
function isfunction(var) return type(var) == "function" end
function isnumber(var) return type(var) == "number" end
function isrotator(var) return getmetatable(var) == Rotator end
function isstring(var) return type(var) == "string" end
function istable(var) return type(var) == "table" end
function isvector(var) return getmetatable(var) == Vector end
function isvector2d(var) return getmetatable(var) == Vector2D end
