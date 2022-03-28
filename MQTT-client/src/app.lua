local module = {}
local m = nil
local timer = nil

local function send_ping()
    m:publish(config.ENDPOINT..'ping','id='..config.ID, 0, 0)
end

local function register_myself()
    m:subscribe(config.ENDPOINT .. config.ID, 0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()
    m = mqtt.Client(config.ID, 120)
    m:on('message', function(conn, topic, data)
        if data ~= nil then
            print(topic..': '..data)
        end
    end)
    m:connect(config.HOST, config.PORT, false, function(con)
        print('connected to broker')
        register_myself()
        timer = tmr.create()
        timer:register(1000, tmr.ALARM_AUTO, send_ping)
        timer:start()
    end)
end

function module.start()
    mqtt_start()
end

return module