Timer.list = {
    --[[
    [identifier] = {
        int      id                 = Timer identification
        float    delay              = The time until the function is called
        float    start              = Time when the timer started
        float    stop               = Time when the timer finishes
        float    pause              = Time when the timer got paused
        int      repetitions        = How many times we should loop (0 = infinite)
        int      current_repetition = The current execution number
        function func               = Callback
        table    args               = { any var, ... } -- Arguments table for func
    }
    ]]
}

--[[
    Change a running timer

    Arguments:
        string   identifier  = Timer name
        float    delay       = Timer delay (seconds)
        int      repetitions = How many times we should loop. 0 = infinite
        function func        = Callback
        table    args  = { any var, ... }

    Return:
        bool
]]
function Timer:Change(identifier, delay, repetitions, func, args)
    local timer = identifier and self.list[identifier]

    -- Check if we have something to change
    if not timer then return false end

    if (timer.delay == delay or not delay) and
       (timer.repetitions == repetitions or not repetitions) and
       (timer.func == func or not func) and
       (not args)
       then
        return false
    end

    -- Deal with a new function
    args = func and (IsTable(args) and args or {}) or timer.args
    func = func or timer.func

    -- Remove old timer
    self:ClearTimeout(timer.id)

    -- Check if repetitions are ok
    repetitions = repetitions or timer.repetitions

    if repetitions ~= 0 and timer.current_repetition >= repetitions then
        self.list[identifier] = nil

        return true
    end

    -- Check the delay and change the timer
    delay = delay or timer.delay
    local last_cycle_start = timer.start + timer.delay * timer.current_repetition
    local time_diff = os.clock() - last_cycle_start
    local time_to_next = delay - time_diff

    self:Simple(time_to_next < 0 and 0 or time_to_next, function()
        timer.current_repetition = timer.current_repetition + 1

        func(table.unpack(args))

        self:Create(identifier, delay, repetitions, func, args)
    end)

    return true
end

--[[
    Create and register a timer

    Arguments:
        string   identifier  = Timer name
        float    delay       = Timer delay (seconds)
        int      repetitions = How many times we should loop. 0 = infinite
        function func        = Callback
        table    args  = { any var, ... }

    Return:
        nil
]]
function Timer:Create(identifier, delay, repetitions, func, args)
    if not identifier or not delay or not repetitions or not func then return end

    local i = self.list[identifier] and self.list[identifier].current_repetition or 1

    local emergency_brake = false

    self.list[identifier] = {
        id = self:SetTimeout(1000 * delay, function()
            if repetitions ~= 0 and i >= repetitions + 1 then
                self.list[identifier] = nil

                return false
            end

            if emergency_brake then
                return false
            end

            emergency_brake = true
            func(table.unpack(self.list[identifier].args))
            emergency_brake = false

            self.list[identifier].current_repetition = i

            i = i + 1
        end),
        args = IsTable(args) and args or {},
        current_repetition = 0,
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
    Restart a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function Timer:Restart(identifier)
    local timer = identifier and self.list[identifier]

    if not timer then return false end

    self:ClearTimeout(timer.id)
    timer.current_repetition = 1
    self:Create(identifier, timer.delay, timer.repetitions, timer.func)
end


--[[
    Create a simple timer that executes once

    Arguments:
        float    delay = Timer delay (seconds)
        function func  = Callback
        table    args  = { any var, ... }

    Return:
        nil
]]
function Timer:Simple(delay, func, args)
    if not delay or not func then return end

    local emergency_brake = false

    return self:SetTimeout(1000 * delay, function()
        if emergency_brake then
            return false
        end
    
        emergency_brake = true
        func(IsTable(args) and table.unpack(args))
        emergency_brake = false

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
    local time_to_next = timer.delay - time_diff

    self:Simple(time_to_next, function()
        timer.current_repetition = timer.current_repetition + 1

        timer.func()

        self:Create(identifier, timer.delay, timer.repetitions, timer.func)
    end)

    return true
end
