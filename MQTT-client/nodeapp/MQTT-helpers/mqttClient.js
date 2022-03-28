const mqttHandler = require('./mqttHandler')
const mqttClient = new mqttHandler('mqtt://localhost', 1883)

mqttClient.connect()
.then(rep => console.log(rep))
.catch(err => console.log(err)) // connect the client to the broker

mqttClient.subscribeTopic('nodemcu/ping')

// for external use
module.exports = mqttClient