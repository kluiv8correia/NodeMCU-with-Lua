print('Server is about to start in 6 seconds...')

local count = 6 -- for 6 seconds

-- create the timer for the countdown
local countdown = tmr.create()

-- create the callback function for the startup_sequence
function startup_sequence()
    count = count - 1
    print(count)
    if (count <= 0) then
        countdown:unregister() -- remove the callback and stops it
        dofile('simple_webserver.lua')
        print('Server started...')
    end
end


-- register the countdown function
countdown:register(1000, tmr.ALARM_AUTO, startup_sequence)

-- start the timer
countdown:start()