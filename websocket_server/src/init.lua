local main_program = tmr.create()

-- creating callback functions
function connectedcallback (target)
    print('Connected to WiFi: '..target.SSID)
    wifi.eventmon.unregister(wifi.eventmon.STA_CONNECTED)
    print('Starting the main file in 5 seconds...')
    main_program:register(5000, tmr.ALARM_SINGLE, function() main_program:unregister() collectgarbage() dofile('main.lua') return end)
    main_program:start()
end

-- register wifi callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function (target) 
    connectedcallback(target)
end)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function (target)
    if main_program:state() then
        main_program:unregister() -- remove any registered main_program events
    end
    print('Disconnected from WiFi: '..target.SSID)
    collectgarbage()
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, connectedcallback)
end)
