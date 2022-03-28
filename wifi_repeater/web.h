#define CONFIG_PAGE "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n\
<html>\
<head>\
    <title>Extender Configurator</title>\
</head>\
<style>\
    body {\
        font-family: monospace;\
        margin: 0px;\
    }\
    .header {\
        display: flex;\
        justify-content: center;\
        align-items: center;\
        font-size: 1.1rem;\
        color: white;\
        background-color: #303f9f;\
        padding: 5px 0px;\
        border-bottom: clamp(5px, 10px, 2.5vh) solid #001970;\
        letter-spacing: clamp(2px, 20px, 1.4vw);\
    }\
    .header h1 {\
        margin: 10px 0px;\
    }\
    .card {\
        display: flex;\
        color: darkslategray;\
        flex-direction: column;\
        justify-content: center;\
        align-items: center;\
        border: 1px solid silver;\
        width: min(50vw, 500px);\
        margin: 20px auto;\
        padding: 10px;\
        border-radius: 10px;\
        box-shadow: 0px 3px 0px grey;\
        padding: 20px;\
    }\
    .card h2 {\
        letter-spacing: 2px;\
        width: 100%;\
        display: flex;\
        justify-content: center;\
        padding-bottom: 10px;\
        border-bottom: 1px solid silver;\
    }\
    .card form {\
        width: 100%;\
        display: flex;\
        margin: auto;\
        justify-content: center;\
    }\
    .fields {\
        display: grid;\
        grid-template-columns: 0.1fr 1fr;\
        gap: 10px;\
        margin-right: 10px;\
    }\
    .fields p {\
        font-size: 1.02em;\
        text-align: right;\
    }\
    .new-checkbox {\
        appearance: none;\
        cursor: pointer;\
        width: 20px;\
        height: 20px;\
        margin: auto 0px;\
        border: 1px solid silver;\
        border-radius: 20%;\
        transition: all 0.1s ease-in-out;\
    }\
    .new-checkbox:active,\
    .new-checkbox:checked:active {\
        opacity: 0.5;\
    }\
    .new-checkbox:hover {\
        filter: brightness(0.7);\
        border-width: 2px;\
    }\
    .new-checkbox:checked:after {\
        content: '\\2714';\
        font-size: 16px;\
        position: relative;\
        top: 0px;\
        left: 2px;\
        color: blue;\
    }\
    .newfield {\
        border: 1px solid silver;\
        border-radius: 5px;\
        padding: 0px 5px;\
        font-size: 14px;\
        color: black(26, 26, 26);\
        transition: all 0.1s ease-in-out;\
    }\
    .newfield:hover {\
        filter: brightness(0.98);\
    }\
    .newfield:focus {\
        border: 2px solid #303f9f;\
        box-shadow: inset 3px 3px orange;\
        outline: none;\
    }\
    .std-button {\
        background-color: #ffeb3b;\
        border: 2px solid #c66900;\
        color: #c66900;\
        font-weight: bold;\
        font-size: 1.1em;\
        border-radius: 5px;\
        width: min(100px, 100%);\
        transition: all 0.1s ease-in-out;\
    }\
    .std-button:hover {\
        background-color: #fdd835;\
    }\
    .std-button:active {\
        filter: brightness(0.9);\
    }\
    .danger-button {\
        background-color: #ff6f60;\
        border: 2px solid #ab000d;\
        color: #ab000d;\
        font-weight: bold;\
        font-size: 14px;\
        border-radius: 5px;\
        width: min(100px, 100%);\
        transition: all 0.1s ease-in-out;\
    }\
    .danger-button:hover {\
        background-color: #e53935;\
        color: white;\
    }\
    .danger-button:active {\
        filter: brightness(0.9);\
    }\
</style>\
<body>\
    <div class='header'>\
        <h1>ESP WiFi Extender</h1>\
    </div>\
    <div id=config>\
        <script>\
            if (window.location.search.substr(1) != '') {\
                document.getElementById('config').display = 'none';\
                document.body.innerHTML = '<div class=\"header\"><h1>NAT Updated</h1></div><div class=\"card\"><h3 style=\"font-size: 1.4em\">The new settings have been sent to the device...</h3></div>';\
                setTimeout(\"location.href = '/'\", 10000);\
            }\
        </script>\
        <div class='card'>\
            <h2>STA Settings</h2>\
            <form action='' method='GET'>\
                <div class='fields'>\
                    <p>SSID:</p>\
                    <input class='newfield' type='text' name='ssid' value='%s' />\
                    <p>Password:</p>\
                    <input class='newfield' type='password' name='password' value='%s' />\
                    <p>Automesh:</p>\
                    <input class='new-checkbox' type='checkbox' name='am' value='mesh' %s>\
                </div>\
                <input class='std-button' type='submit' value='Connect' />\
            </form>\
        </div>\
        <div class='card'>\
            <h2>AP Settings</h2>\
            <form action='' method='GET'>\
                <div class='fields'>\
                    <p>SSID:</p>\
                    <input class='newfield' type='text' name='ap_ssid' value='%s' />\
                    <p>Password:</p>\
                    <input class='newfield' type='text' name='ap_password' value='%s' />\
                    <p>Security:</p>\
                    <select name='ap_open'>\
                        <option value='open' %s>Open</option>\
                        <option value='wpa2' %s>WPA2</option>\
                    </select>\
                    <p>Subnet:</p>\
                    <input class='newfield' type='text' name='network' value='%d.%d.%d.%d' />\
                </div>\
                <input class='std-button' type='submit' value='Set' />\
            </form>\
        </div>\
        <div class='card'>\
            <h2>Lock Config</h2>\
            <form action='' method='GET'>\
                <div class='fields'>\
                    <p>Lock &ThinSpace; device:</p>\
                    <input class='new-checkbox' type='checkbox' name='lock' value='l'>\
                </div>\
                <input class='danger-button' type='submit' name='dolock' value='Lock' />\
            </form>\
        </div>\
        <div class='card'>\
            <h2>Device Management</h2>\
            <form style='height: 100%' action='' method='GET'>\
                <input style='height: 40px; width: 40%' class='danger-button' type='submit' name='reset'\
                    value='Restart' />\
            </form>\
        </div>\
    </div>\
</body>\
\
</html>\
"

#define LOCK_PAGE "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n\
<html>\
<head></head>\
<style>\
    body {\
        font-family: monospace;\
        margin: 0px;\
    }\
    .header {\
        display: flex;\
        justify-content: center;\
        align-items: center;\
        font-size: 1.1rem;\
        color: white;\
        background-color: #303f9f;\
        padding: 5px 0px;\
        border-bottom: clamp(5px, 10px, 2.5vh) solid #001970;\
        letter-spacing: clamp(2px, 20px, 1.4vw);\
    }\
    .header h1 {\
        margin: 10px 0px;\
    }\
    .card {\
        display: flex;\
        color: darkslategray;\
        flex-direction: column;\
        justify-content: center;\
        align-items: center;\
        border: 1px solid silver;\
        width: min(50vw, 500px);\
        margin: 20px auto;\
        padding: 10px;\
        border-radius: 10px;\
        box-shadow: 0px 3px 0px grey;\
        padding: 20px;\
    }\
    .card h2 {\
        letter-spacing: 2px;\
        width: 100%;\
        display: flex;\
        justify-content: center;\
        padding-bottom: 10px;\
        border-bottom: 1px solid silver;\
    }\
    .card form {\
        width: 100%;\
        display: flex;\
        margin: auto;\
        justify-content: center;\
    }\
    .fields {\
        display: grid;\
        grid-template-columns: 0.1fr 1fr;\
        gap: 10px;\
        margin-right: 10px;\
    }\
    .fields p {\
        font-size: 1.02em;\
        text-align: right;\
    }\
    .new-checkbox {\
        appearance: none;\
        cursor: pointer;\
        width: 20px;\
        height: 20px;\
        margin: auto 0px;\
        border: 1px solid silver;\
        border-radius: 20%;\
        transition: all 0.1s ease-in-out;\
    }\
    .new-checkbox:active,\
    .new-checkbox:checked:active {\
        opacity: 0.5;\
    }\
    .new-checkbox:hover {\
        filter: brightness(0.7);\
        border-width: 2px;\
    }\
    .new-checkbox:checked:after {\
        content: '\\2714';\
        font-size: 16px;\
        position: relative;\
        top: 0px;\
        left: 2px;\
        color: blue;\
    }\
    .newfield {\
        border: 1px solid silver;\
        border-radius: 5px;\
        padding: 0px 5px;\
        font-size: 14px;\
        color: black(26, 26, 26);\
        transition: all 0.1s ease-in-out;\
    }\
    .newfield:hover {\
        filter: brightness(0.98);\
    }\
    .newfield:focus {\
        border: 2px solid #303f9f;\
        box-shadow: inset 3px 3px orange;\
        outline: none;\
    }\
    .std-button {\
        background-color: #ffeb3b;\
        border: 2px solid #c66900;\
        color: #c66900;\
        font-weight: bold;\
        font-size: 1.1em;\
        border-radius: 5px;\
        width: min(100px, 100%);\
        transition: all 0.1s ease-in-out;\
    }\
    .std-button:hover {\
        background-color: #fdd835;\
    }\
    .std-button:active {\
        filter: brightness(0.9);\
    }\
    .danger-button {\
        background-color: #ff6f60;\
        border: 2px solid #ab000d;\
        color: #ab000d;\
        font-weight: bold;\
        font-size: 14px;\
        border-radius: 5px;\
        width: min(100px, 100%);\
        transition: all 0.1s ease-in-out;\
    }\
    .danger-button:hover {\
        background-color: #e53935;\
        color: white;\
    }\
    .danger-button:active {\
        filter: brightness(0.9);\
    }\
</style>\
<body>\
    <div class='header'>\
        <h1>ESP WiFi Extender</h1>\
    </div>\
    <div id='config'>\
        <script>\
            if (window.location.search.substr(1) != '') {\
                document.getElementById('config').display = 'none';\
                document.body.innerHTML = '<div class=\"header\"><h1>NAT Updated</h1></div><div class=\"card\"><h3 style=\"font-size: 1.4em\">The new settings have been sent to the device...</h3></div>';\
                setTimeout(\"location.href = '/'\", 10000);\
            }\
        </script>\
        <div class='card'>\
            <h2>Config Locked</h2>\
            <form autocomplete='off' action='' method='GET'>\
                <div class='fields'>\
                    <p>Password:</p>\
                    <input class='newfield' type='password' name='unlock_password' />\
                    <small style='grid-column: span 2; text-align: left;'>\
                        <i>Default: STA password to unlock<br />\
                    </small>\
                </div>\
                <input style='height: 100%' class='std-button' type='submit' value='Unlock' />\
            </form>\
        </div>\
</body>\
</html>\
"
