Timers = {}

--  @function timer
--      | description: Run a callback after delay
--      | params:
--          number time: Time (in seconds)
--          function callback: Callback to run
function timer( time, callback )
    Timers[#Timers + 1] = { max_time = time, time = 0, callback = callback }
end