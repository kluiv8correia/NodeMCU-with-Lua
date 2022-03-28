-- config the ADC pin
if adc.force_init_mode(adc.INIT_ADC)
then
  node.restart()
  return
end

-- create a timer
timer = tmr.create()
timer:register(200, tmr.ALARM_AUTO, function() print(adc.read(0)/1024*3.3..'V') end)
timer:start()
