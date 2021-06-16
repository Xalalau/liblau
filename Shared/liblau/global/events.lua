local listeners = {}

function Subscribe(originator, event, identifier, func)
    listeners[originator] = listeners[originator] or {}
    listeners[originator][event] = listeners[originator][event] or {}
    listeners[originator][event][identifier] = func
  
    originator:Subscribe(event, function(...)
        for k, listener in pairs(listeners[originator][event]) do
            listener(...)
        end
    end)
end

function Unsubscribe(originator, event, identifier)
    if listeners[originator] and listeners[originator][event] then
        listeners[originator][event][identifier] = nil
    end
end
