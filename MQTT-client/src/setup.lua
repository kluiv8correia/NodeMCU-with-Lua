local module = {}
local timer = nil

local function wifi_wait_ip()
    if not wifi.sta.getip() then
        print('Still waiting...')
    else
        timer:stop()
        timer = nil
        print('WiFi connected!')
        print('IP: '..wifi.sta.getip())
        app.start()
    end
end

local function wifi_start(aps)
    for key, value in pairs(aps) do
        if config.SSID and config.SSID[key] then
            local ssid, _, _, _ = wifi.sta.getconfig()
            if ssid ~= key then                
                wifi.sta.config{ssid=key, pwd=config.SSID[key]}
            end
            wifi.sta.connect()
            print('Connecting to '..key..'...')
            timer = tmr.create()
            timer:register(2500, tmr.ALARM_AUTO, wifi_wait_ip)
            timer:start()
        end
    end
end

function module.start()
    print('Configuring WiFi...')
    wifi.setmode(wifi.STATION)
    wifi.sta.getap(wifi_start)
end

return module