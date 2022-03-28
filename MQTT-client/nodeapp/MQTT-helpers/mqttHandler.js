const mqtt = require('mqtt') // require the mqtt module

class MqttHandler {
    constructor(host, port) {
        this.mqttClient = null
        this.host = host
        this.port = port
    }

    connect() {
        return new Promise((resolve, reject) => {
            this.mqttClient = mqtt.connect(this.host, {port: this.port})
            // error callback
            this.mqttClient.on('error', (err) => {
                this.mqttClient.end()
                reject(err)
            })
            // connection callback
            this.mqttClient.on('connect', () => {
                resolve('MQTT client connected')
            })
            // onclose callback
            this.mqttClient.on('close', () => {
                reject('MQTT client disconnected')
            })
        })
    }

    sendMessage(message, topic) {
        return new Promise((resolve, reject) => {
            this.mqttClient.publish(topic, message, err => {
                if (!err)
                    resolve()
                else
                    reject('message not sent')
            })
        })
    }

    subscribeTopic(topic) {
        return new Promise((resolve, reject) => {
            this.mqttClient.subscribe(topic, err => {
                if (!err) {
                    console.log(`subscribed to topic: ${topic}`)
                    this.mqttClient.on('message', (topic, message) => {
                        console.log(`from topic ${topic}: ${message}`)
                    })
                } else {
                    console.log(`failed to subscribe to topic: ${err}`)
                }
            })
        })
    }
}

// export for external use
module.exports = MqttHandler