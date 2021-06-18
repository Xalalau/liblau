Timer.list = {
    --[[
    [identifier] = {
        int      id                 = Timer address
        float    delay              = The time until the function is called
        float    start              = Time when the timer started
        float    stop               = Time when the timer finishes
        float    pause              = Time when the timer got paused
        int      repetitions        = How many times we should loop (0 = infinite)
        int      current_repetition = The current execution number
        function func               = Callback
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

    local i = self.list[identifier] and self.list[identifier].current_repetition or 1

    self.list[identifier] = {
        id = self:SetTimeout(1000 * delay, function()
            func()

            self.list[identifier].current_repetition = i

            if repetitions~= 0 and i == repetitions then
                self.list[identifier] = nil
                return false
            end

            i = i + 1
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
        int   repetitions_left = Repetitions left
        float time_left        = Time left (seconds)
]]
function Timer:Left(identifier)
    local timer = self.list[identifier]

    local repetitions_left = not timer.repetitions and "infinite" or (timer.repetitions - timer.current_repetition)
    local time_left = not timer.stop and "infinite" or timer.stop - os.clock()

    return repetitions_left, time_left
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

    local last_cycle_start = timer.start + timer.delay * timer.current_repetition
    local time_diff =  timer.pause - last_cycle_start

    self:Simple(time_diff, function()
        timer.current_repetition = timer.current_repetition + 1

        timer.func()

        self:Create(identifier, timer.delay, timer.repetitions, timer.func)
    end)

    return true
end
