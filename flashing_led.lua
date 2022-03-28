-- flashing led at pin 4 (inbuilt)
-- this is active low
local ledPin = 4
local interval = 1e6 -- in us

print('Flashing led at ' .. interval .. 'us...')

-- setting the pinmode
gpio.mode(ledPin, gpio.OUTPUT)

-- stop watchdog timer from resetting
tmr.wdclr()

-- start infinite loop, using 1 not True
while (1)
do
    gpio.write(ledPin, 0)
    tmr.delay(interval) -- using the tmr module for time operations
    gpio.write(ledPin, 1)
    tmr.delay(interval)
end
