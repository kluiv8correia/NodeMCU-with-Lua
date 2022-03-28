-- This contains all methods for http transactions

-- send a file
function sendfile(sck, source, ctype)
    local response = {'HTTP/1.0 200 OK\r\nContent-Type: '..ctype..'\r\n\r\n'}
    if file.open(source) then
        local holder = file.read(64) -- chunk size 64
        while holder do
            response[#response+1] = holder
            holder = file.read(64)
        end
    end
    local function send(sck)
        if #response > 0 then
            sck:send(table.remove(response, 1))
        else
            sck:close()
            response = nil
        end
    end
    sck:on('sent', send)
    send(sck)
end

-- initialize the websocket
function initwebsocket(sck, request)
    local _, stop = string.find(request, 'Key:')
    local key = string.sub(request, stop+2, stop+25)
    local uuid = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
    wskey = encoder.toBase64(crypto.hash('sha1', key..uuid))
    sck:send('HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: '..wskey..'\r\n\r\n')
    -- first check whether the peer exists
    local check = sck:getpeer()
    local found = false
    for i, v in ipairs(peers) do
        if check == v:getpeer() then
            found = true
            break
        end
    end
    if not found then
        table.insert(peers, sck)
    end
end

-- publish the data to the peers
function publish(message, peers)
    if #peers then
        for i, v in ipairs(peers) do
            if v:getpeer() then
                v:send(encode(message, 1, true))
            else
                table.remove(peers, i)
                print('peer disconnected')
            end
        end
    end
end

-- close the websocket
function closewebsocket(sck, status_code, message)
    -- for closing a connection with a body, the first 2 bytes must indicate a status code
    status_code = status_code or 1000 -- normal closure
    message = message or ''
    local second_byte = string.char(bit.band(status_code, 0xff))
    local first_byte = string.char(bit.rshift(status_code, 8))
    local message = encode(first_byte..second_byte..message, 8, true)
    sck:send(message)
    sck:on('sent', function(sck) sck:close() end)
end

-- encode and decode websocket messages
function encode(payload, opcode, fin)
    opcode = opcode or 2 -- default to binary
    local len = #payload
    local head = string.char( -- converts to character
        bit.bor(fin and 0x80 or 0x00, opcode), -- fin and opcode
        len < 126 and len or len < 0x10000 and 126 or 127
    )
    if len >= 0x10000 then
        head = head .. string.char(
            0,0,0,0, -- software limiting to 32bits (otherwise 64bits) len
            bit.band(bit.rshift(len, 24), 0xff),
            bit.band(bit.rshift(len, 16), 0xff),
            bit.band(bit.rshift(len, 8), 0xff),
            bit.band(len, 0xff)
        )
    elseif len >= 126 then
        head = head..string.char( -- 16 bit len
            bit.band(bit.rshift(len, 8), 0xff),
            bit.band(len, 0xff)
        )
    end
    return head .. payload -- concat and return full framed message
end
function decode(chunk)
    if #chunk < 2 then return end -- fake data
    local second_byte = string.byte(chunk, 2) -- convert 2nd char to int form
    local len = bit.band(second_byte, 0x7f) -- get the length code
    local offset
    if len == 126 then
        if #chunk < 4 then return end -- fake data
        len = bit.bor( -- 16 bit length
            bit.lshift(string.byte(chunk, 3), 8),
            string.byte(chunk, 4)
        )
        offset = 4 -- init_byte + len_code + 16bit_len = 4bytes
    elseif len == 127 then -- 64 bit length
        if #chunk < 10 then return end -- fake data
        len = bit.bor(
            0,0,0,0,-- ignore 32 bits (optimized)
            bit.lshift(string.byte(chunk, 7), 24),
            bit.lshift(string.byte(chunk, 8), 16),
            bit.lshift(string.byte(chunk, 9), 8),
            string.byte(chunk, 10)
        )
        offset = 10 -- init_byte + len_code + 64bit_len = 10bytes
    else
        offset = 2 -- below 126 length -- init_byte + len_code = 2bytes
    end
    local mask_bit = bit.band(second_byte, 0x80) > 0 -- checks for mask bit
    local payload
    if mask_bit then
        offset = offset + 4 -- 4 bytes for masking key
        local masking_key = string.sub(chunk, offset-3, offset)
        payload = crypto.mask(string.sub(chunk, offset+1, -1), masking_key) -- decrypt payload
    end
    local extra = string.sub(chunk, offset+len+1) -- any extra headers or other data
    local opcode = bit.band(string.byte(chunk, 1), 0xf) -- get the opcode
    return extra, payload, opcode -- if opcode is nil then bad transaction
end