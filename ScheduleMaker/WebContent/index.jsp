<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Home</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
		<meta name="google-signin-client_id" content="173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3.apps.googleusercontent.com">
		<link rel="stylesheet" href="assets/css/main.css" />
		<noscript><link rel="stylesheet" href="assets/css/noscript.css"/></noscript>

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
								display: flex;
				flex-direction: column;
			}
			a:hover{
				cursor: pointer;
				color: black;
			}
			#additionalFeatures{
				width: 40%;
				margin-left: auto;
				margin-right: auto;
			}
			#members{
				width: 20%;
				margin-left: auto;
				margin-right: auto;
			}
			#seeSaved{
				margin: 15px;
				padding: 15px;
			}
			#seeSaved:hover{
				cursor: pointer;
				color: black;
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
		</style>
	</head>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/push.js/0.0.11/push.min.js"></script>
<script>
var email;
function onSignIn(googleUser) {
	
	Push.Permission.request();
	
	  var profile = googleUser.getBasicProfile();
	  console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
	  console.log('Name: ' + profile.getName());
	  console.log('Image URL: ' + profile.getImageUrl());
	  console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
	  email = profile.getEmail();
	  var fname = profile.getName().split(" ")[0];
	  var name = profile.getName();
	  document.getElementById('status').innerHTML =
	        'Thanks for logging in, ' + fname + '!';
	 var thisUser = {
			 "email": email,
			 "user" : {
				 "friends": [],
				 "name": [name],
				 "savedSchedules": []
			 }
	 }
	 var xhttp = new XMLHttpRequest();
	  	xhttp.onreadystatechange = function(){
	  		console.log("added user");
	  		console.log(xhttp.responseText);
	  	};
	  	xhttp.open("POST", "register", true);
	  	xhttp.send(JSON.stringify(thisUser));
	  	
	  	sessionStorage.setItem("email",email);
	  	document.getElementById("seeSaved").href="saved-schedules?email="+email;
  	  	console.log(document.getElementById("seeSaved").href);
  	  	connectToServer();
	}
	
	
	

	
function doFunction(){
	
	//Pack Request 
	var nameValue = document.getElementById("uniqueID").value;
	console.log("this is " + nameValue);
	sessionStorage.setItem("SearchTerms",nameValue);
	
	//Send out to be triaged at search
	window.location.href = "FriendSearchPage.jsp";
	
  	
}

</script>



<script type="text/javascript">
    	document.addEventListener("DOMContentLoaded", function () {
    		//console.log("H");
    		var searchTerm = sessionStorage.getItem("SearchTerms")
    		console.log("search Term Recieved by Triage @" + searchTerm);
    		
    		
    		var requeststr = "search?";
    		
    		var email = sessionStorage.getItem("Email");
    		var URL = sessionStorage.getItem("URL");	
    		
    		requeststr += "email=" + email;
          	requeststr += "&query=" + searchTerm; 
    		
    		
		    var xhttp = new XMLHttpRequest();
	      	xhttp.open("GET", requeststr, true);
	      	xhttp.send();
	   
	      	
	      	console.log("Orders sent: " + requeststr);
	      	
	      	console.log("Outbound");
	      	
	      	
	      	//var temp = document.getElementById("hello").innerHTML;
	      	
	      	
    	})
    	
    	
    	
  </script>
  <script>
			var socket;
			function connectToServer() {
				console.log("Entering Web Socket Connection");
				// If current session does not have email, then user not logged in. 
				// Do not create Websocket connection to server
				if (email == null || email == "") {
					return;
				}

				console.log("Entering Web Socket Connection");
				socket = new WebSocket(
						"ws://localhost:8080/ScheduleMaker/broadcast");
				console.log("Got out of init");
				console.log("Registering session client email: " + email);
				socket.onopen = function(event) {
					// When the connection open, send a message to server identifying the email of current client 
					socket.send("email:" + email);
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

<body class="is-preload" onload="connectToServer()">

			<nav id="top">
				<ul>
					<a href="generator.jsp">Create a Schedule</a>
					<a id="seeSaved" href="saved-schedules?email=">Saved Schedules</a>
				</ul>
			</nav>

		<!-- Wrapper -->
			<div id="wrapper">
				
				<!-- Header -->
					<header id="header" class="alt">
						<h1>SChedule Maker</h1>
					</header>

				<div id="searchbar">
					<form id="searchForm">
      					<input type="text" placeholder="Search Friends"  id="uniqueID" type="submit" >
     		 			<button onclick="doFunction();" type="reset"><i class="fa fa-search"></i></button>
    				</form>
    			</div>
				<!-- Nav -->
					<nav id="nav">
						<ul>
							<li><a href="#first">Project Features</a></li>
							<li><a href="#second">Profile</a></li>
							<li><a href="#team">The Team</a></li>
							<li><a href="#cta">Get Started</a></li>
						</ul>
					</nav>

				<!-- Main -->
					<div id="main">
						<!-- First Section -->
							<section id="first" class="main special">
								<header class="major">
									<h2>Project Features</h2>
								</header>
								<ul class="features">
									<li>
										<span class="icon major style1 fa-code"></span>
										<h3>Create Schedules</h3>
										<p>Ever get frustrated trying to fit all the classes you want to take without any schedule conflict? We can fix that for you. Just enter which courses you need to take, and we do all the hard work for you!</p>
									</li>
									<li>
										<span class="icon major style3 fa-copy"></span>
										<h3>Compare Schedules</h3>
										<p>By saving all the schedules you like, you can go to your profile and compare all saved schedules to help decide which is the best for you!</p>
									</li>
									<li>
										<span class="icon major style5 fa-diamond"></span>
										<h3>Bonus Features</h3>
										<p>Set time/location preferences, prioritize by professor rating, and see which friends have saved the same classes as you.</p>
									</li>
								</ul>
							</section>

						<!-- Second Section -->
							<section id="second" class="main special">
								<header class="major">
									<h2>Profile</h2>
									<p>By creating a profile users are given access to additional features</p><br>
									<div id="additionalFeatures">
										<ul>
											<li>Saving your preferred schedules</li>
											<li>Identifying friends in the same courses</li>
											<li>Comparing your saved schedules</li>
											<li>Add preferences to schedule generator</li>
										</ul>
									</div>
								</header>
							</section>

							<!-- Get Started -->
							<section id="team" class="main special">
								<header class="major">
									<h2>The Team</h2>
								</header>
								<div id="members">
									<ul>
										<li>Luis Loza</li>
										<li>Jillian Khoo</li>
										<li>Jincheng Zhou</li>
										<li>Joel Joseph</li>
										<li>Justin Kim</li>
									</ul>
								</div>
							</section>

						<!-- Get Started -->
							<section id="cta" class="main special">
								<header class="major">
									<h2>Get Started</h2>
								</header>
								<footer class="major">
									<ul class="actions special">
										<li>
											<div class="g-signin2" data-onsuccess="onSignIn" data-scope="https://www.googleapis.com/auth/calendar"></div>
										</li>
									</ul>
									<div id="status">
									</div>
								</footer>
							</section>
							

					</div>
					<br>
					<br>
					<br>

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
</html>
