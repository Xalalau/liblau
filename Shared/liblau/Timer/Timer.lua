Timer.list = {
    --[[
    [identifier] = {
        int  id    = Timer identifier number
        bool pause = false
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

    local i = 1

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
                print(Timer.list[identifier].stop)

                Timer.list[identifier].stop = Timer.list[identifier].stop + delay/(repetitions == 0 and 1 or repetitions)
                print(Timer.list[identifier].stop)
            end
        end),
        repetitions = repetitions ~= 0 and repetitions,
        start = os.clock(),
        stop = repetitions ~= 0 and os.clock() + delay * repetitions
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
    if not identifier or not Timer.list[identifier] then return end

    return Timer.list[identifier] and true or false
end

--[[
    "Pause" a timer

    Arguments:
        string identifier = Timer name

    Return:
        nil
]]
function Timer:Pause(identifier)
    if not identifier or not Timer.list[identifier] then return end

    Timer.list[identifier].pause = true
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
    if not identifier or not Timer.list[identifier] then return end

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
        nil
]]
function Timer:Toggle(identifier)
    if not identifier or not Timer.list[identifier] then return end

    Timer.list[identifier].pause = not Timer.list[identifier].pause
end

--[[
    "Unpause" a timer

    Arguments:
        string identifier = Timer name

    Return:
        nil
]]
function Timer:UnPause(identifier)
    if not identifier or not Timer.list[identifier] then return end

    Timer.list[identifier].pause = false
end
