local listeners = {}

--[[
    [Auxiliar] Refresh a list of events

    Arguments:
        class    originator = Class with subscribe method
        string   event      = Event name

    Return:
        nil
]]
local function RefreshSubscriptions(originator, event)
    originator:Subscribe(event, function(...)
        for k, listener in pairs(listeners[originator][event]) do
            listener(...)
        end
    end)
end

-- ------------------------------------------------------------------------

--[[
    Subscribe to event

    Arguments:
        class    originator = Class with subscribe method
        string   event      = Event name
        string   identifier = Unique name to identify the event
        function func       = Callback

    Return:
        nil
]]
function Subscribe(originator, event, identifier, func)
    listeners[originator] = listeners[originator] or {}

    if listeners[originator][event] then
        originator:Unsubscribe(event)
    end

    listeners[originator][event] = listeners[originator][event] or {}
    listeners[originator][event][identifier] = func

    RefreshSubscriptions(originator, event)
end

--[[
    Unsubscribe to event

    Arguments:
        class    originator = Class with subscribe method
        string   event      = Event name

    Return:
        nil
]]
function Unsubscribe(originator, event, identifier)
    if listeners[originator] and listeners[originator][event] then
        originator:Unsubscribe(event)

        listeners[originator][event][identifier] = nil

        if table.count(listeners[originator][event]) > 0 then
            RefreshSubscriptions(originator, event)
        end
    end
end