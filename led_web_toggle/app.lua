srv = net.createServer(net.TCP)

-- set the pinmode
ledpin = 4
state = false -- start with off state
gpio.mode(ledpin, gpio.OUTPUT)
gpio.write(ledpin, gpio.HIGH) -- turn the inbuilt led off startup

-- set the timer params
interval = 100
blinker = tmr.create()
blinker:register(interval, tmr.ALARM_AUTO, function() -- callback to blink
    state = not state 
    if state then
        gpio.write(ledpin, gpio.LOW)
    else
        gpio.write(ledpin, gpio.HIGH)
    end
end)

-- callbacks and functions
function sendwebfile (sck, sourcefile, ctype)
    local response = {'HTTP/1.0 200 OK\r\nContent-Type: '..ctype..'\r\n\r\n'}

    if file.open(sourcefile) then
        local holder = file.read(64) -- sending 64 bytes per call or till EOF
        while holder do
            response[#response+1] = holder
            holder = file.read(64)
        end
    end

    local function send(lsck)
        if #response > 0 then
            lsck:send(table.remove(response, 1))
        else
            lsck:close()
            response = nil
        end
    end

    sck:on('sent', send)

    send(sck)
end
function toggle (sck)
    sck:on('sent', function (lsck) sck:close() end)
    local buf
    if state then
        gpio.write(ledpin, gpio.HIGH)
        buf = 'off'
    else
        gpio.write(ledpin, gpio.LOW)
        buf = 'on'
    end
    state = not state
    sck:send('HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\n'..buf)
end
function blink (sck, tostart)
    sck:on('sent', function (lsck) lsck:close() end)
    local buf
    if tostart then
        blinker:start()
        buf = 'started'
    else
        blinker:stop()
        buf = 'stopped'
    end
    sck:send('HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\n'..buf)
end
function sendledstate (sck)
    sck:on('sent', function(lsck) lsck:close() end)
    local buf
    if state then
        buf = 'on'
    else
        buf = 'off'
    end
    sck:send('HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\n'..buf)
end

-- get the IP for ease of access
print('NodeMCU IP: '..wifi.sta.getip())

-- GET routes
route = { -- remember to reference the sck in the table properly
    ['/']=function (sck) sendwebfile(sck, 'index.html', 'text/html') end,
    ['/main.css']=function (sck) sendwebfile(sck, 'main.css', 'text/css') end,
    ['/run.js']=function (sck) sendwebfile(sck, 'run.js', 'text/javascript') end,
    ['/toggle']=function (sck) toggle(sck)  end,
    ['/blink_on']=function (sck) blink(sck, true) end,
    ['/blink_off']=function (sck) blink(sck, false) end,
    ['/led_state']=function (sck) sendledstate(sck) end
}

srv:listen(80, function(conn)
    conn:on('receive', function (sck, request)
        request = string.gsub(request, '^%s*(.-)%s*$', '%1') -- trimming the request
        local _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")

        print('METHOD:', method, 'PATH:', path) -- report some info about the request

        if method == 'GET' or method == 'POST' then -- all get methods get processed here
            if route[path] then -- check if real route
                route[path](sck) -- run the function and send the sck param
            else
                print('Bad or Missing Path! -> '..path)
            end
        end
    end)
end)