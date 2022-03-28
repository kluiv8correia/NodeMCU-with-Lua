srv = net.createServer(net.TCP)

-- callbacks
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

-- get the IP for ease of access
print('NodeMCU IP: '..wifi.sta.getip())

-- GET routes
route = { -- remember to reference the sck in the table properly
    ['/']=function (sck) sendwebfile(sck, 'index.html', 'text/html') end,
    ['/main.css']=function (sck) sendwebfile(sck, 'main.css', 'text/css') end -- text/javascript for js
}

srv:listen(80, function(conn)
    conn:on('receive', function (sck, request)
        request = string.gsub(request, '^%s*(.-)%s*$', '%1') -- trimming the request
        local _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")

        print('METHOD:', method, 'PATH:', path) -- report some info about the request

        if method == 'GET' then -- all get methods get processed here
            if route[path] then -- check if real route
                route[path](sck) -- run the function and send the sck param
            else
                print('Bad or Missing Path! -> '..path)
            end
        end
    end)
end)