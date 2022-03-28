-- NodeMCU Examples

-- make sure that the wifi mode is NOT SOFTAP and set to STATION
if wifi.getmode() ~= wifi.STATION then
    print('Setting wifi mode to STATION...')
    wifi.setmode(wifi.STATION)
end

-- also remove any previous configs
wifi.sta.clearconfig()

-- get Access Point data
local station_config = {ssid='FAM', pwd='Iamcool5'}
station_config.save = false -- do not save to flash

-- set the config
if (wifi.sta.config(station_config)) then
    print('Successfully configured WiFi station...')
else
    print('ERROR: Unable to configure WiFi station')
end

-- creating a callback function for getap()
function listAP(t)
    for bssid, v in pairs(t) do
        print(bssid .. '\t|\t' .. v)
     end
end

-- using the getap sta method to get ap list info
-- here 1 stands for the new format, otherwise 0 for old format
wifi.sta.getap(1, listAP)