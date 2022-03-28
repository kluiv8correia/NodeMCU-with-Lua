-- Event driven led flashing
-- this works with lua sdk > 2.1.0 (so build from source)
-- here we don't need to worry about the watchdog timer resetting

local interval = 500 -- in ms
local ledPin = 4
local ledState = 0 -- to keep track during toggles

-- settting pinmode
gpio.mode(ledPin, gpio.OUTPUT)

function toggle() -- function to toggle (callback for event)
    if (ledState) then
        gpio.write(ledPin, 0) -- inverted for active low
    else
        gpio.write(ledPin, 1)
    end
    print('LED state: '..tostring(ledState))
    ledState = not ledState -- toggle here
end

-- create a timer object
local driver = tmr.create()

-- register the even as infinite loop using AUTO
-- here toggle is the callback on trigger
driver:register(interval, tmr.ALARM_AUTO, toggle)

-- start the timer even
driver:start()
