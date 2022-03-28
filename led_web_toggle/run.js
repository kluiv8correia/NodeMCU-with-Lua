const toggleButton = document.getElementById('toggle')
const blinkButton = document.getElementById('blink')
const request = new XMLHttpRequest()

// function for post
function post (target, sourceButton, trigger) {
    return new Promise(function(resolve, reject) {
        sourceButton.className += ' disable'
        request.open('POST', target)
        request.send()
        request.onload = () => {
            let data = request.responseText
            console.log(data)
            if (data == trigger)
                sourceButton.className = 'card-toggle on'
            else
                sourceButton.className = 'card-toggle'
            resolve()
        }
        request.onerror = () => {
            reject()
        }
    })
}

// adding event listeners
toggleButton.addEventListener('click', function () {
    post('/toggle', toggleButton, 'on') // here on triggers true condition
})
blinkButton.addEventListener('click', function() {
    if (blinkButton.className == 'card-toggle') {
        toggleButton.className += ' disable'
        post('/blink_on', blinkButton, 'started')
    }
    else {
        post('/blink_off', blinkButton, 'started').then(() => {
            request.open('GET', '/led_state')
            request.send()
            request.onload = () => {
                let data = request.responseText
                if (data == 'on')
                    toggleButton.className = 'card-toggle on'
                else
                    toggleButton.className = 'card-toggle'
            }
        })
    }
})