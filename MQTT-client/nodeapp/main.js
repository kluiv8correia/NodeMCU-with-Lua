const mqttClient = require('./MQTT-helpers/mqttClient')
const express = require('express')

// set the express var
let app = express()

// middle for body parser
function rawBody(req, res, next) {
    req.setEncoding('utf8');
    req.rawBody = '';
    req.on('data', function (chunk) {
        req.rawBody += chunk;
    });
    req.on('end', function () {
        next();
    });
}

// set the express params ---------------------
app.use(rawBody) // to handle the text/plain
app.use(express.static('public')) // holds the stylesheet
app.use(express.static('pages')) // holds the index page
// --------------------------------------------

// local router -------------------------------
app.post('/message', (req, res) => {
    const message = req.rawBody // use middleware to extract data
    mqttClient.sendMessage(message, target.topic)
    .then(() => console.log('publishing MQTT: ' + message))
    .catch(err => console.log(err))
    res.end() // send back empty response
})
// --------------------------------------------

// set global target topic
const target = {
    topic: 'nodemcu/912361'
}

const PORT = 5000
app.listen(PORT, () => console.log(`Started listening at port ${PORT}`))
