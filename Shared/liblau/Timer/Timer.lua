Timer.list = {
    --[[
    [identifier] = {
        int      id                = Timer address
        float    delay             = The time until the function is called
        float    start             = Time when the timer started
        float    stop              = Time when the timer finishes
        float    pause             = Time when the timer got paused
        int      repetitions       = How many times we should loop (0 = infinite)
        int      currentRepetition = The current execution number
        function func              = Callback
    }
    ]]
}

--[[
    Create and register a timer

    Arguments:
        string   identifier  = Timer name
        float    delay       = Timer delay (seconds)
        int      repetitions = How many times we should loop. 0 = infinite
        function func        = Callback

    Return:
        nil
]]
function Timer:Create(identifier, delay, repetitions, func)
    if not identifier or not delay or not repetitions or not func then return end

    local i = Timer.list[identifier] and Timer.list[identifier].currentRepetition or 1

    Timer.list[identifier] = {
        id = Timer:SetTimeout(1000 * delay, function()
            if not Timer.list[identifier].pause then 
                func()

                Timer.list[identifier].currentRepetition = i

                if repetitions~= 0 and i == repetitions then
                    Timer.list[identifier] = nil
                    return false
                end

                i = i + 1
            else
                Timer.list[identifier].stop = Timer.list[identifier].stop + delay/(repetitions == 0 and 1 or repetitions)
            end
        end),
        repetitions = repetitions ~= 0 and repetitions,
        start = os.clock(),
        stop = repetitions ~= 0 and os.clock() + delay * repetitions,
        delay = delay,
        func = func
    }
end

--[[
    Check if a timer exists

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function Timer:Exists(identifier)
    return Timer.list[identifier] and true or false
end

--[[
    Pause a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function Timer:Pause(identifier)
    if not identifier or not Timer.list[identifier] then return false end

    Timer:ClearTimeout(Timer.list[identifier].id)
    Timer.list[identifier].pause = os.clock()
    Timer.list[identifier].id = nil

    return true
end

--[[
    remove a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function Timer:Remove(identifier)
    if not identifier or not Timer.list[identifier] then return false end

    Timer:ClearTimeout(Timer.list[identifier].id)
    Timer.list[identifier] = nil

    return true
end

--[[
    Get what's left to finish a timer

    Arguments:
        string identifier = Timer name

    Return:
        int   repetitionsLeft = Repetitions left
        float timeLeft        = Time left (seconds)
]]
function Timer:Left(identifier)
    local repetitionsLeft = not Timer.list[identifier].repetitions and "infinite" or (Timer.list[identifier].repetitions - Timer.list[identifier].currentRepetition)
    local timeLeft = not Timer.list[identifier].stop and "infinite" or Timer.list[identifier].stop - os.clock()

    return repetitionsLeft, timeLeft
end

--[[
    Create a simple timer that executes once

    Arguments:
        float    delay = Timer delay (seconds)
        function func  = Callback

    Return:
        nil
]]
function Timer:Simple(delay, func)
    if not delay or not func then return end

    return Timer:SetTimeout(1000 * delay, function()
        func()
        return false
    end)
end

--[[
    "Pause" a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function Timer:Toggle(identifier)
    if not identifier or not Timer.list[identifier] then return false end

    Timer.list[identifier].pause = not Timer.list[identifier].pause

    return true
end

--[[
    Unpause a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function Timer:UnPause(identifier)
    if not identifier or not Timer.list[identifier] then return false end

    local lastCycleStart = Timer.list[identifier].start + Timer.list[identifier].delay * Timer.list[identifier].currentRepetition
    local timeDiff =  Timer.list[identifier].pause - lastCycleStart

    Timer:Simple(timeDiff, function()
        Timer.list[identifier].currentRepetition = Timer.list[identifier].currentRepetition + 1

        Timer.list[identifier].func()

        Timer:Create(identifier, Timer.list[identifier].delay, Timer.list[identifier].repetitions, Timer.list[identifier].func)
    end)

    return true
end
