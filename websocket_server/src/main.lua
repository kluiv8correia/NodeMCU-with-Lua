print('Inside main.lua file!')

-- create a new callback for wifi disconnection
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function (target)
    if srv then
        srv:close()
        srv = nil
    end
    if listener then
        listener = nil
        collectgarbage()
    end
    print('Disconnected from WiFi: '..target.SSID)
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function (target)
        print('Connected to WiFi ['..target.SSID..'] Restarting Server')
        srv = net.createServer(net.TCP)
        listener = coroutine.create(startlistening)
        coroutine.resume(listener)
    end)
end)

-- start the HTTP server
srv = net.createServer(net.TCP)
print('NodeMCU IP: '..wifi.sta.getip())

-- httpserver helper functions
dofile('http-helper.lua')

-- page router and method selector, peers sockets, and opcode response
local methods = {['GET']=true, ['POST']=true}
local routes = {
    ['/']=function(sck) sendfile(sck, 'index.html', 'text/html') end,
    ['/style.css']=function(sck) sendfile(sck, 'style.css', 'text/css') end,
    ['/run.js']=function(sck) sendfile(sck, 'run.js', 'text/javascript') end,
    ['/echo']=function(sck, request) initwebsocket(sck, request) end
}
local opcodes = {
    [1]=function(sck, payload, ip)  print('from ws ['..ip..']: '..payload) end,
    [8]=function(sck, payload, ip) print('CLOSING WS W/ '..ip) end
}
peers = {} -- peer container, this has to be global

-- create the listening wrapper
function startlistening()
    srv:listen(80, function(conn)
        conn:on('receive', function(sck, request)
            local _, ip = sck:getpeer() -- gives peer port and ip
            if string.find(request, 'HTTP') then -- tend to HTTP request
                local _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
                print('PEER: '..ip,'METHOD: '..method, 'PATH: '..path)
                if methods[method] then
                    if routes[path] then
                        routes[path](sck, request)
                    end
                end
            else -- tend to websocket transactions
                local extra, payload, opcode = decode(request)
                if opcodes[opcode] then
                    opcodes[opcode](sck, payload, ip)
                else
                    print('WS_ERROR: BAD OPCODE')
                end
            end
        end)
    end)
end

-- listen
listener = coroutine.create(startlistening)
coroutine.resume(listener)

-- actual publisher
local ptimer = tmr.create()
ptimer:register(1000, tmr.ALARM_AUTO, function() publish(string.char(node.random(128)), peers) end)
ptimer:start()