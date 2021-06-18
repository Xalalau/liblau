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

    local i = self.list[identifier] and self.list[identifier].currentRepetition or 1

    self.list[identifier] = {
        id = self:SetTimeout(1000 * delay, function()
            if not self.list[identifier].pause then 
                func()

                self.list[identifier].currentRepetition = i

                if repetitions~= 0 and i == repetitions then
                    self.list[identifier] = nil
                    return false
                end

                i = i + 1
            else
                self.list[identifier].stop = self.list[identifier].stop + delay/(repetitions == 0 and 1 or repetitions)
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
    return self.list[identifier] and true or false
end

--[[
    Pause a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function Timer:Pause(identifier)
    local timer = identifier and self.list[identifier]

    if not timer then return false end

    self:ClearTimeout(timer.id)
    timer.pause = os.clock()
    timer.id = nil

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
    if not (identifier and self.list[identifier]) then return false end

    self:ClearTimeout(self.list[identifier].id)
    self.list[identifier] = nil

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
    local timer = self.list[identifier]

    local repetitionsLeft = not timer.repetitions and "infinite" or (timer.repetitions - timer.currentRepetition)
    local timeLeft = not timer.stop and "infinite" or timer.stop - os.clock()

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

    return self:SetTimeout(1000 * delay, function()
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
    local timer = identifier and self.list[identifier]

    if not timer then return false end

    timer.pause = not timer.pause

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
    local timer = identifier and self.list[identifier]

    if not timer then return false end

    local lastCycleStart = timer.start + timer.delay * timer.currentRepetition
    local timeDiff =  timer.pause - lastCycleStart

    self:Simple(timeDiff, function()
        timer.currentRepetition = timer.currentRepetition + 1

        timer.func()

        self:Create(identifier, timer.delay, timer.repetitions, timer.func)
    end)

    return true
end
