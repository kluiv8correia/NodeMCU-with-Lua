-- function checks the connection status as a station
function connection_status ()
    local state = wifi.sta.status()
    local tree = {
        [0]='IDLE',
        [1]='CONNECTING',
        [2]='WRONG PASSWORD',
        [3]='AP NOT FOUND',
        [4]='CONNECTION FAILED',
        [5]='CONNECTION SUCCESSFUL'
    } -- emulating switch case
    print('CONNECTION STATUS: '..tree[state])
end

print('Checking connection status every 1 second...')

-- create a timed event
local interval = 1000
local driver = tmr.create()
driver:register(interval, tmr.ALARM_AUTO, connection_status)
driver:start()