// create selectors
const stateElement = document.getElementById('state')
const sentElement = document.getElementById('sent')
const receivedElement = document.getElementById('received')

// create the websocket client object
const wsURL = 'ws://'+window.location.hostname+'/echo'
console.log('wsURL: '+wsURL)
let ws = new WebSocket(wsURL)


// handle connection establishment
ws.onopen = function (event) {
    console.log('connection established')
    stateElement.innerText = 'SUCCESS'
    ws.send('Donnerstag')
    sentElement.innerText = 'Donnerstag'
}
ws.onmessage = function (event) {
    console.log('message received: ' + event.data)
    receivedElement.innerText = event.data
    const sendData = event.data.toUpperCase()
    sentElement.innerText = sendData
    ws.send(sendData) // send back the same data in upper
}
ws.onerror = function (error) {
    const bufferType = error.type[0].toUpperCase() + error.type.slice(1)
    stateElement.innerText = bufferType
}
ws.onclose = function (event) {
    console.log('Websocket closed!')
    stateElement.innerText = 'CLOSED'
    receivedElement.innerText = event.reason
    console.log(event)
}