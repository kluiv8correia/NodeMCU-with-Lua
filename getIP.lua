-- first create a timer to check for ip address in 1 second
local checker = tmr.create()

-- create the callback function
function getipc()
    local buffer = wifi.sta.getip() -- this can be split into ip, netmask, and gateway
    if buffer == nil then
        print('Connecting to AP...')
    else
        print('IP: ' .. buffer)
        checker:unregister() -- stop the timer
    end
end

-- register the function
checker:register(1000, tmr.ALARM_AUTO, getipc)

-- start the timer
checker:start()