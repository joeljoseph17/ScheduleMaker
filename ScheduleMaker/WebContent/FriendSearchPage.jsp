<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    	<%@ page import="com.google.gson.Gson" %>
	<%@ page import="java.io.StringReader" %>
	<%@ page import="com.google.gson.JsonObject" %>
	<%@ page import="com.google.gson.JsonArray" %>
	<%@ page import="com.google.gson.JsonElement" %>
	<%@ page import="com.google.gson.stream.JsonReader" %>
<!DOCTYPE HTML>
<!--
	Stellar by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html>
	<head>
		<title>Find Friends</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="google-signin-client_id" content="173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3.apps.googleusercontent.com">
		<script src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>
		<link rel="stylesheet" href="assets/css/main.css" />
		<noscript><link rel="stylesheet" href="assets/css/noscript.css" /></noscript>
		
		<style>
			nav a{
				margin: 15px;
				padding: 15px;
			}
			#top{
				width: 100%;
				text-align: center;
				background-color: white;
				color: black;
				height: 60px;
				font-size:2em;
			}
			a:hover{
				cursor: pointer;
				color: black;
			}
			h1{
				text-align: center;
				font-size: 5em;
			}
			form{
				width: 60%;
				padding: 20px;
			}
			#main{
				margin-top: 20px;
				padding: 30px;
			}
			select{
				margin: 20px;
			}
			h2{
				text-align: center;
				font-size: 2em;
			}
			li{
				background-color:white;
				color:black;
				width:400px;
			}
			#searchbar{
				width:100%; 
     			display: flex;
				flex-direction: column;
				justify-content:center;
				align-items: center;
				margin-left: auto;
				margin-right: auto;
			}
			#searchForm {
    			margin: 0 0 2em 0;
    			width: 30%;
    			display: flex;
			}
			button{
				height:44px;
			}
			#uniqueID{
				margin-right: 10px;
			}
			#results{
				background-color: white;
				margin-bottom: 500px;
				width: 40%;
				margin-left: auto;
				margin-right: auto;
				padding: 0;
				font-size: 20px;
			}
			li{
				list-style-position:inside;
    			border: 2px solid black;
    			width: 100%;
    			border-collapse: collapse;
			}
			ul, li{
				padding: 0;
				margin: 0;
			}
		</style>
		
		<script src="https://cdnjs.cloudflare.com/ajax/libs/push.js/0.0.11/push.min.js"></script>
		<script>
		var CLIENT_ID = "173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3.apps.googleusercontent.com";
		var API_KEY = "173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3";
		var email;
			function onLoad(){
			      gapi.load('auth2:client', function(){
			          gapi.auth2.init({
			        	  client_id: CLIENT_ID
			          }).then(function(){
			              var auth2 = gapi.auth2.getAuthInstance(); 
			           	  var googleUser = gapi.auth2.getAuthInstance().currentUser.get();
			        	  var profile = googleUser.getBasicProfile();
			        	  email = profile.getEmail();
			        	  console.log(email);
			          });
				  });
			}
			function doFunction(){
				
				//Pack Request 
				var nameValue = document.getElementById("uniqueID").value;
				console.log("this is " + nameValue);
				sessionStorage.setItem("SearchTerms",nameValue);
				
				//Send out to be triaged at search
				window.location.href = "FriendSearchPage.jsp";
					
			}
			function redirectUser(event){
				var clickedThing = event.target.innerHTML;
				console.log(clickedThing)
				var secondHalf = clickedThing.split(":")[1];
				secondHalf=secondHalf.substr(1);
				console.log(secondHalf);
				var replacement="saved-schedules?email="+secondHalf;
				window.location.replace(replacement);
			}
			
		</script>
		
		<script type="text/javascript">
		console.log("Hello world");
		 var xhttp = new XMLHttpRequest();
		 
    	xhttp.onreadystatechange = function() {
    		console.log("Hit");
        if (this.readyState == 4 && this.status == 200) {
        	
        	var obj = JSON.parse(xhttp.responseText);
        	
        	if(obj===null){
        		console.log("Empty");
        	}
        	else {
        		console.log("NORCOM");
        		console.log(xhttp.responseText);
        		var response = xhttp.responseText;
        		response = response.substr(1, response.length-2);
        		console.log(response);
        		var users = response.split("}");
        		console.log(users);
        		var jsonUsers=[];
        		for(var i=0; i<users.length; i++){
        			users[i]=users[i]+"}";
        			if(users[i].length > 1){
        				if(users[i].indexOf(",")==0){
        					users[i]=users[i].substring(1);
        				}
        				jsonUsers.push(JSON.parse(users[i]));
        			}	
        		}
        		console.log(jsonUsers);
        		var content="<ul style=\"list-style-type:none\">";
        		for(var i=0; i<jsonUsers.length; i++){
        			var othername=jsonUsers[i].name;
        			var otheremail = jsonUsers[i].email;
        			content=content+"<li onclick=\"redirectUser(event)\">";
        			content=content+othername+": "+otheremail;
        			content=content+"</li>";
        		}
        		content=content+"</ul>";
        		document.getElementById("results").innerHTML = content;
        		
        	}

        	
        	
        	}
    	}
		var email;
    	document.addEventListener("DOMContentLoaded", function () {
    		//console.log("H");
    		var searchTerm = sessionStorage.getItem("SearchTerms")
    		console.log("search Term Recieved by Triage @" + searchTerm);
    		
    		
    		var requeststr = "search?";
    		
    		email = sessionStorage.getItem("email");
    		document.getElementById("seeSaved").href="saved-schedules?email="+email;
    		//var URL = sessionStorage.getItem("URL");	
    		
    		requeststr += "email=" + email;
          	requeststr += "&query=" + searchTerm; 
    		
    		
		   
	      	xhttp.open("GET", requeststr, true);
	      	console.log("about to send");
	      	xhttp.send();
	   
	      	
	      	console.log("Orders sent: ");
	      	console.log(requeststr);
	      	
	      	console.log("Outbound");
	      	
	      	
	      	//var temp = document.getElementById("hello").innerHTML;
	      	
	      	
    	});
    	
    	

    	
    	
    </script>
    <script>
		var socket;
		function connectToServer() {
			// If current session does not have email, then user not logged in. 
			// Do not create Websocket connection to server
			if (email == null || email == "") {
				return;
			}
			
			console.log("Entering Web Socket Connection");
		    socket = new WebSocket("ws://localhost:8080/ScheduleMaker/broadcast");
		    console.log("Got out of init");
		    console.log("Registering session client email: " + email);
		    socket.onopen = function(event) {
		        // When the connection open, send a message to server identifying the email of current client 
		        socket.send("email:"+email);
		        console.log("Session Opened!")
		    }

		    socket.onmessage = function(event) {
		    	console.log(event.data);
		    	Push.create('Someone just created a new schedule', {
				    body: event.data,
				    timeout: 10000,               // Timeout before notification closes automatically.
				    vibrate: [100, 100, 100],    // An array of vibration pulses for mobile devices.
				    onClick: function() {
				        // Callback for when the notification is clicked. 
				        console.log(this);
				    }  
				});
		    }

		    socket.onclose = function(event) {

		    }

		    socket.onerror = function(event) {

		    }
		}
	</script>
	</head>
	<body class="is-preload" onload="connectToServer()">
		
		<nav id="top">
			<ul>
				<a href="index.jsp">Home</a>
				<a href="generator.jsp">Create a Schedule</a>
				<a id="seeSaved" href="">Saved Schedules</a>
			</ul>
		</nav>
		
		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Header -->
					<br>
					<br>
					<div id="searchbar">
						<form id="searchForm">
			      			<input type="text" placeholder="Search Friends"  id="uniqueID" type="submit" >
			     		 	<button onclick="doFunction();" type="reset"><i class="fa fa-search"></i></button>
			    		</form>
			    	</div>
			    	<h1>Results</h1>
					<div id="results">
					
					</div>

			</div>

		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/jquery.scrollex.min.js"></script>
			<script src="assets/js/jquery.scrolly.min.js"></script>
			<script src="assets/js/browser.min.js"></script>
			<script src="assets/js/breakpoints.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>

	</body>
</html>>
