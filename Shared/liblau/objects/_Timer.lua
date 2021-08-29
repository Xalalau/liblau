_Timer = {}

local timer_list = {
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

        -- Note: "args" actually has only one use: making _Timer.Change capable of keeping a function state. Otherwise it's useless.
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
        table    args        = { any var, ... }

    Return:
        bool
]]
function _Timer.Change(identifier, delay, repetitions, func, args)
    local timer = identifier and timer_list[identifier]

    -- Check if we have something to change
    if not timer or not timer.id then return false end

    if (timer.delay == delay or not delay) and
       (timer.repetitions == repetitions or not repetitions) and
       (timer.func == func or not func) and
       (not args)
       then
        return false
    end

    -- Remove old timer
    Timer.ClearTimeout(timer.id)

    -- Manualy update fields, so other functions can already return the new values
    timer.func = func or timer.func
    timer.args = IsBasicTable(args) and args or timer.args
    timer.repetitions = repetitions or timer.repetitions
    timer.delay = delay or timer.delay

    -- Do a delay compensation and start the changed timer
    local time_to_next = _Timer.TimeLeft(identifier)
    _Timer.Simple(time_to_next < 0 and 0 or time_to_next, function()
        timer.start = os.clock()

        timer.func(table.unpack(timer.args))

        timer.current_repetition = timer.current_repetition + 1

        _Timer.Create(identifier, timer.delay, timer.repetitions, timer.func, timer.args)
    end)

    return true
end

--[[
    Create and register a timer

    Note: for timers that run only once, use _Timer.Simple

    Arguments:
        string   identifier  = Timer name
        float    delay       = Timer delay (seconds)
        int      repetitions = How many times we should loop. 0 = infinite
        function func        = Callback
        table    args        = { any var, ... }

    Return:
        nil
]]
function _Timer.Create(identifier, delay, repetitions, func, args)
    if not identifier or not delay or not repetitions or not func then return end

    local i = timer_list[identifier] and timer_list[identifier].current_repetition or 1

    local error_break = false

    timer_list[identifier] = {
        id = Timer.SetInterval(function()
            if error_break then return false end

            if repetitions ~= 0 and i >= repetitions + 1 then
                timer_list[identifier] = nil

                return false
            end

            timer_list[identifier].start = os.clock()

            error_break = true
            func(table.unpack(timer_list[identifier].args))
            error_break = false

            i = i + 1

            if timer_list[identifier] then
                timer_list[identifier].current_repetition = i
            end
        end, 1000 * delay),
        args = IsBasicTable(args) and args or {},
        current_repetition = i,
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
function _Timer.Exists(identifier)
    return timer_list[identifier] and true or false
end

--[[
    Get a timer

    Arguments:
        string identifier = Timer name

    Return:
        table timer_list[identifier]
        nil
]]
function _Timer.Get(identifier)
    return table.Copy(timer_list[identifier])
end

--[[
    Get all timers

    Arguments:
        nil

    Return:
        table timer_list
]]
function _Timer.GetAll()
    return table.Copy(timer_list)
end

--[[
    Pause a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function _Timer.Pause(identifier)
    local timer = identifier and timer_list[identifier]

    if not timer or not timer.id then return false end

    Timer.ClearTimeout(timer.id)
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
function _Timer.Remove(identifier)
    local timer = identifier and timer_list[identifier]

    if not timer or not timer.id then return false end

    Timer.ClearTimeout(timer_list[identifier].id)
    timer_list[identifier] = nil

    return true
end

--[[
    Get amount of repetitions left to finish a timer

    Arguments:
        string identifier = Timer name

    Return:
        int repetitions_left = Repetitions left
]]
function _Timer.RepsLeft(identifier)
    local timer = timer_list[identifier]

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
function _Timer.Restart(identifier)
    local timer = identifier and timer_list[identifier]

    if not timer or not timer.id then return false end

    Timer.ClearTimeout(timer.id)
    timer.current_repetition = 1
    _Timer.Create(identifier, timer.delay, timer.repetitions, timer.func, timer.args)
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
function _Timer.Simple(delay, func, args)
    if not delay or not func then return end

    local error_break = false

    return Timer.SetTimeout(function()
        if error_break then return false end
    
        error_break = true
        func(table.unpack(IsBasicTable(args) and args or {}))
        error_break = false

        return false
    end, 1000 * delay)
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
function _Timer.TimeLeft(identifier)
    local timer = timer_list[identifier]

    if not timer then return end

    local time_left = not timer.stop and "infinite" or os.clock() - timer.start
    local total_time_left = time_left + timer.delay * (timer.repetitions - timer.current_repetition)

    return time_left, total_time_left
end

--[[
    Pause or unpause a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function _Timer.Toggle(identifier)
    local timer = identifier and timer_list[identifier]

    if not timer then return false end

    if timer.pause then
        _Timer.UnPause(identifier)
    else
        _Timer.Pause(identifier)
    end

    return true
end

--[[
    Unpause a timer

    Arguments:
        string identifier = Timer name

    Return:
        bool
]]
function _Timer.UnPause(identifier)
    local timer = identifier and timer_list[identifier]

    if not timer then return false end

    local time_to_next = timer.pause - timer.start
    timer.start = os.clock() - time_to_next
    timer.pause = nil

    _Timer.Simple(time_to_next, function()
        timer.func(table.unpack(timer.args))

        timer.current_repetition = timer.current_repetition + 1

        _Timer.Create(identifier, timer.delay, timer.repetitions, timer.func, timer.args)
    end)

    return true
end
