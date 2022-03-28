-- SENDING A FILE
-- Multiple consecutive send() calls aren't guaranteed to work (and often don't) 
-- as network requests are treated as separate tasks by the SDK.Instead, 
-- subscribe to the "sent" event on the socket and send additional data (or close) 
-- in that callback. 
-- make sure in STATION

-- callbacks
function receiver(sck)
    local response = {"HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"} -- buffer for expected HTML
    if file.open('index.html') then
        local holder = file.readline()
        while holder do
            response[#response + 1] = holder -- here # is the length operator
            holder = file.readline()
        end
    end

    local function send(lsck) -- local socket
        if #response > 0 then
            lsck:send(table.remove(response, 1)) -- remove from the stack
          else
            lsck:close() -- finally close and remove response
            response = nil
          end
    end

    -- triggers the send() function when 'sent' request is given
    sck:on('sent', send)

    -- run the send function
    send(sck)
end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    -- gets any request, collectgarbage() is optional
    conn:on("receive", function (sck, req) print(req) receiver(sck)  collectgarbage() end)
end)