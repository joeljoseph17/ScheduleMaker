
var socket;
function connectToServer() {
	console.log("Entering Web Socket Connection");
    socket = new WebSocket("ws://localhost:8080/ScheduleMaker_ScheduleMaker/ws");
    console.log("Got out of init");
    socket.onopen = function(event) {
        // When the connection open, send a message to server identifying the email of current client 
        socket.send("email:"+email);
        console.log("Session Opened!")
    }

    socket.onmessage = function(event) {
        // Process the message received
    }

    socket.onclose = function(event) {

    }

    socket.onerror = function(event) {

    }
}