-- THIS EXAMPLE DEMONSTRATES THE USE OF SEROUT
-- set the params
ledpin = 4
gpio.mode(ledpin, gpio.OUTPUT)
start_value = gpio.HIGH
delay_times = { -- all in us
    50e3, -- first toggle time
    50e3 -- second toggle time (and so on)
} -- read the doc for limitations of async serout
count_limit = 50 -- number of pulses

print('starting the serout sequence!')
gpio.serout(ledpin, start_value, delay_times, count_limit, function() -- callback on completion
    print('serout sequence complete!')
end)