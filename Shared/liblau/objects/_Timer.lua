_Timer = {
    list = {
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
        table    args               = { any var, ... } -- Arguments table for func.

        -- Note: "args" actually has only one use: making _Timer:Change capable of keeping a function state. Otherwise it's useless.
    }
    ]]
    }
}

--[[
    Change a running timer

    Arguments:
        string   identifier  = Timer name
        float    delay       = Timer delay (seconds)
        int      repetitions = How many times we should loop. 0 = infinite
        function func        = Callback
        table    args        = { any var, ... }

    Return:
        bool
]]
function _Timer:Change(identifier, delay, repetitions, func, args)
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

    -- Deal with new function and arguments
    func = func or timer.func
    args = IsBasicTable(args) and args or timer.args

    -- Remove old timer
    Timer:ClearTimeout(timer.id)

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

    _Timer:Simple(time_to_next < 0 and 0 or time_to_next, function()
        timer.current_repetition = timer.current_repetition + 2

        func(table.unpack(args))

        _Timer:Create(identifier, delay, repetitions, func, args)
    end)

    return true
end

--[[
    Create and register a timer

    Note: for timers that run only once, use _Timer:Simple

    Arguments:
        string   identifier  = Timer name
        float    delay       = Timer delay (seconds)
        int      repetitions = How many times we should loop. 0 = infinite
        function func        = Callback
        table    args        = { any var, ... }

    Return:
        nil
]]
function _Timer:Create(identifier, delay, repetitions, func, args)
    if not identifier or not delay or not repetitions or not func then return end

    local i = self.list[identifier] and self.list[identifier].current_repetition or 1

    local error_break = false

    self.list[identifier] = {
        id = Timer:SetTimeout(1000 * delay, function()
            if error_break then return false end

            if repetitions ~= 0 and i >= repetitions + 1 then
                self.list[identifier] = nil

                return false
            end

            error_break = true
            func(table.unpack(self.list[identifier].args))
            error_break = false

            i = i + 1

            if self.list[identifier] then
                self.list[identifier].current_repetition = i
            end
        end),
        args = IsBasicTable(args) and args or {},
        current_repetition = 1,
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
function _Timer:Exists(identifier)
    return self.list[identifier] and true or false
end

--[[
    Get a timer

    Arguments:
        string identifier = Timer name

    Return:
        table _Timer.list[identifier]
        nil
]]
function _Timer:Get(identifier)
    return self.list[identifier]
end

--[[
    Get all timers

    Arguments:
        nil

    Return:
        table _Timer.list
]]
function _Timer:GetAll()
    return self.list
end

--[[
    Pause a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function _Timer:Pause(identifier)
    local timer = identifier and self.list[identifier]

    if not timer then return false end

    Timer:ClearTimeout(timer.id)
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
function _Timer:Remove(identifier)
    if not (identifier and self.list[identifier]) then return false end

    Timer:ClearTimeout(self.list[identifier].id)
    self.list[identifier] = nil

    return true
end

--[[
    Get amount of repetitions left to finish a timer

    Arguments:
        string identifier = Timer name

    Return:
        int repetitions_left = Repetitions left
]]
function _Timer:RepsLeft(identifier)
    local timer = self.list[identifier]

    if not timer then return end

    return not timer.repetitions and "infinite" or (timer.repetitions - timer.current_repetition)
end

--[[
    Restart a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function _Timer:Restart(identifier)
    local timer = identifier and self.list[identifier]

    if not timer then return false end

    Timer:ClearTimeout(timer.id)
    timer.current_repetition = 1
    _Timer:Create(identifier, timer.delay, timer.repetitions, timer.func)
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
function _Timer:Simple(delay, func, args)
    if not delay or not func then return end

    local error_break = false

    return Timer:SetTimeout(1000 * delay, function()
        if error_break then return false end
    
        error_break = true
        func(IsBasicTable(args) and table.unpack(args))
        error_break = false

        return false
    end)
end

--[[
    Get amount of time left to finish a timer

    Arguments:
        string identifier = Timer name

    Return:
        float time_left       = Time left to finish the current repetition (seconds)
        float total_time_left = Time left to finish the current and next repetitions (seconds)
        nil
]]
function _Timer:TimeLeft(identifier)
    local timer = self.list[identifier]

    if not timer then return end

    local time_left = not timer.stop and "infinite" or timer.stop - os.clock()
    local total_time_left = time_left + timer.delay * (timer.repetitions - timer.current_repetition)

    return time_left, total_time_left
end

--[[
    "Pause" a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function _Timer:Toggle(identifier)
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
function _Timer:UnPause(identifier)
    local timer = identifier and self.list[identifier]

    if not timer then return false end

    local last_cycle_start = timer.start + timer.delay * timer.current_repetition
    local time_diff =  timer.pause - last_cycle_start
    local time_to_next = timer.delay - time_diff

    _Timer:Simple(time_to_next, function()
        timer.current_repetition = timer.current_repetition + 1

        timer.func()

        _Timer:Create(identifier, timer.delay, timer.repetitions, timer.func)
    end)

    return true
end