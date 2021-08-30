local listeners = {}

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

    listeners[originator][event] = listeners[originator][event] or {}
    listeners[originator][event][identifier] = func

    if not listeners[originator][event] then
        originator.Subscribe(event, function(...)
            for k, listener in pairs(listeners[originator][event]) do
                listener(...)
            end
        end)
    end
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
        listeners[originator][event][identifier] = nil
    end
end
