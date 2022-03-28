-- file : config.lua
local module = {}

module.SSID = {}
module.SSID["FAM"] = "Iamcool5"

module.HOST = "192.168.0.108"
module.PORT = 1883
module.ID = node.chipid()

module.ENDPOINT = "nodemcu/"

return module