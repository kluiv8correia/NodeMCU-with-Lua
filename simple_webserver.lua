-- Simple HTTP Server
-- connect to the wifi
wifi.setmode(wifi.STATION)
wifi.sta.config{ssid="FAM", pwd="Iamcool5"}

-- a simple HTTP server
srv = net.createServer(net.TCP) -- create a TCP link
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload) -- here sck it the net.socket object
        print(payload)
        -- now send the required information to the asking end
        -- remember to send the headers first otherwise it won't render as a webpage
        sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n")
        sck:send("<style>body {background-color: #ffeb3b; color: #c8b900; font-family: \"Courier\"}\nli {font-weight: bold; font-size: 1.2rem}</style>")
        sck:send("<h1>Hello Node!</h1>")
        sck:send("<ul>\n<li>one</li>")
        sck:send("<li>two</li>")
        sck:send("<li>three</li>\n</ul>")        
    end)
    conn:on("sent", function(sck) sck:close() end)
end)
