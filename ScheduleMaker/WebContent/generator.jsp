<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<!--
	Stellar by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html>
	<head>
		<title>Schedule Generator</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<!--  <meta name="google-signin-client_id" content="173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3.apps.googleusercontent.com">-->
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
		</style>
		
		<script src="https://cdnjs.cloudflare.com/ajax/libs/push.js/0.0.11/push.min.js"></script>
		<script>
		var CLIENT_ID = "173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3.apps.googleusercontent.com";
		var API_KEY = "173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3";
		var email;
			/*function onLoad(){
			      gapi.load('auth2:client', function(){
			          gapi.auth2.init({
			        	  client_id: CLIENT_ID
			          }).then(function(){
			              var auth2 = gapi.auth2.getAuthInstance(); 
			           	  var googleUser = gapi.auth2.getAuthInstance().currentUser.get();
			        	  var profile = googleUser.getBasicProfile();
			        	  email = profile.getEmail();

			        	  console.log(email);
			        	  document.getElementById("myuser").value=email;
			        	  console.log(document.getElementById("myuser").value);
			          });
				  });
			}*/
			function requestCourses(){
				var courses = [];
				var c1 = document.getElementById("course1").value;
				if(c1!="None"){
					courses.push(c1);
				}
				var c2 = document.getElementById("course2").value;
				if(c2!="None"){
					courses.push(c2);
				}
				var c3 = document.getElementById("course3").value;
				if(c3!="None"){
					courses.push(c3);
				}
				var c4 = document.getElementById("course4").value;
				if(c4!="None"){
					courses.push(c4);
				}
				var c5 = document.getElementById("course5").value;
				if(c5!="None"){
					courses.push(c5);
				}
				console.log(courses);
				var xhttp = new XMLHttpRequest();
			  	xhttp.onreadystatechange = function(){
			  		console.log("got schedule");
			  		var response = xhttp.responseText;
			  		console.log(response);
			  	};
			  	xhttp.open("POST", "query", true);
			  	xhttp.send(JSON.stringify(courses));
			}
			
			function getEmail(){
				console.log("getEmail");
				console.log(sessionStorage.getItem("email"));
				email = sessionStorage.getItem("email");
				document.getElementById("seeSaved").href="saved-schedules?email="+email;
				console.log("that email was from getEmail");
				document.getElementById("myuser").value=email;
	        	console.log(document.getElementById("myuser").value);
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
		<!-- <script type="text/javascript" src="websocket.js"></script> -->
		
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
	<body class="is-preload" onload="getEmail(); connectToServer()">
		
		<nav id="top">
			<ul>
				<a href="index.jsp">Home</a>
				<a id="seeSaved" href="">Saved Schedules</a>
			</ul>
			<div id="searchbar">
				<form id="searchForm">
	      			<input type="text" placeholder="Search Friends"  id="uniqueID" type="submit" >
	     		 	<button onclick="doFunction();" type="reset"><i class="fa fa-search"></i></button>
	    		</form>
	    	</div>
		</nav>
		
		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Header -->
					<header id="header" class = "alt">
						<h1>Schedule Generator</h1>
					</header>

					<div id="main">
						<h2>Input classes you would like to take:</h2>
						<div id = "form">
							<form id="classForm" method="POST" action="query">
								<input type="hidden" id="myuser" name="myuser" value="">
								<select name="course1" id="course1">
									<option value="None">None</option>
									<option value="CSCI-100xg">CSCI 100xg</option>
									<option value="CSCI-102L">CSCI 102L</option>
									<option value="CSCI-103L">CSCI 103L</option>
									<option value="CSCI-104L">CSCI 104L</option>
									<option value="CSCI-109">CSCI 109</option>
									<option value="CSCI-170">CSCI 170</option>
									<option value="CSCI-201">CSCI 201</option>
									<option value="CSCI-270">CSCI 270</option>
									<option value="CSCI-310">CSCI 310</option>
									<option value="CSCI-350">CSCI 350</option>
									<option value="CSCI-353">CSCI 353</option>
									<option value="CSCI-356">CSCI 356</option>
									<option value="CSCI-360">CSCI 360</option>
									<option value="CSCI-368">CSCI 368</option>
									<option value="CSCI-380">CSCI 380</option>
									<option value="CSCI-401">CSCI 401</option>
									<option value="CSCI-402">CSCI 402</option>
									<option value="CSCI-420">CSCI 420</option>
									<option value="CSCI-426">CSCI 426</option>
									<option value="CSCI-430">CSCI 430</option>
									<option value="CSCI-435">CSCI 435</option>
									<option value="CSCI-445L">CSCI 445L</option>
									<option value="CSCI-450">CSCI 450</option>
									<option value="CSCI-454L">CSCI 454L</option>
									<option value="CSCI-455x">CSCI 455x</option>
									<option value="CSCI-457">CSCI 457</option>
									<option value="CSCI-458">CSCI 458</option>
									<option value="CSCI-467">CSCI 467</option>
									<option value="CSCI-487">CSCI 487</option>
									<option value="CSCI-490X">CSCI 490X</option>
									<option value="CSCI-491aL">CSCI 491aL</option>
									<option value="CSCI-495">CSCI 495</option>
									<option value="CSCI-499">CSCI 499</option>
									<option value="CSCI-505a">CSCI 505a</option>
									<option value="CSCI-510">CSCI 510</option>
									<option value="CSCI-522">CSCI 522</option>
									<option value="CSCI-526">CSCI 526</option>
									<option value="CSCI-529a">CSCI 529a</option>
									<option value="CSCI-530">CSCI 530</option>
									<option value="CSCI-534">CSCI 534</option>
									<option value="CSCI-536">CSCI 536</option>
									<option value="CSCI-537">CSCI 537</option>
									<option value="CSCI-538">CSCI 538</option>
									<option value="CSCI-541">CSCI 541</option>
									<option value="CSCI-544">CSCI 544</option>
									<option value="CSCI-550">CSCI 550</option>
									<option value="CSCI-555L">CSCI 555L</option>
									<option value="CSCI-557">CSCI 557</option>
									<option value="CSCI-560">CSCI 560</option>
									<option value="CSCI-561">CSCI 561</option>
									<option value="CSCI-563">CSCI 563</option>
									<option value="CSCI-567">CSCI 567</option>
									<option value="CSCI-570">CSCI 570</option>
									<option value="CSCI-571">CSCI 571</option>
									<option value="CSCI-572">CSCI 572</option>
									<option value="CSCI-576">CSCI 576</option>
									<option value="CSCI-577a">CSCI 577a</option>
									<option value="CSCI-580">CSCI 580</option>
									<option value="CSCI-585">CSCI 585</option>
									<option value="CSCI-586">CSCI 586</option>
									<option value="CSCI-590">CSCI 590</option>
									<option value="CSCI-591">CSCI 591</option>
									<option value="CSCI-594a">CSCI 594a</option>
									<option value="CSCI-594b">CSCI 594b</option>
									<option value="CSCI-594z">CSCI 594z</option>
									<option value="CSCI-596">CSCI 596</option>
									<option value="CSCI-599">CSCI 599</option>
									<option value="CSCI-610">CSCI 610</option>
									<option value="CSCI-644">CSCI 610</option>
									<option value="CSCI-658">CSCI 610</option>
									<option value="CSCI-670">CSCI 610</option>
									<option value="CSCI-671">CSCI 610</option>
									<option value="CSCI-677">CSCI 610</option>
									<option value="CSCI-697">CSCI 610</option>
									<option value="CSCI-698">CSCI 610</option>
									<option value="CSCI-699">CSCI 610</option>
									<option value="CSCI-790">CSCI 790</option>
									<option value="CSCI-794a">CSCI 794a</option>
									<option value="CSCI-794b">CSCI 794b</option>
									<option value="CSCI-794c">CSCI 794c</option>
									<option value="CSCI-794d">CSCI 794d</option>
									<option value="CSCI-794z">CSCI 794z</option>
								</select>
								<select name="course2" id="course2">
									<option value="None">None</option>
									<option value="CSCI-100xg">CSCI 100xg</option>
									<option value="CSCI-102L">CSCI 102L</option>
									<option value="CSCI-103L">CSCI 103L</option>
									<option value="CSCI-104L">CSCI 104L</option>
									<option value="CSCI-109">CSCI 109</option>
									<option value="CSCI-170">CSCI 170</option>
									<option value="CSCI-201">CSCI 201</option>
									<option value="CSCI-270">CSCI 270</option>
									<option value="CSCI-310">CSCI 310</option>
									<option value="CSCI-350">CSCI 350</option>
									<option value="CSCI-353">CSCI 353</option>
									<option value="CSCI-356">CSCI 356</option>
									<option value="CSCI-360">CSCI 360</option>
									<option value="CSCI-368">CSCI 368</option>
									<option value="CSCI-380">CSCI 380</option>
									<option value="CSCI-401">CSCI 401</option>
									<option value="CSCI-402">CSCI 402</option>
									<option value="CSCI-420">CSCI 420</option>
									<option value="CSCI-426">CSCI 426</option>
									<option value="CSCI-430">CSCI 430</option>
									<option value="CSCI-435">CSCI 435</option>
									<option value="CSCI-445L">CSCI 445L</option>
									<option value="CSCI-450">CSCI 450</option>
									<option value="CSCI-454L">CSCI 454L</option>
									<option value="CSCI-455x">CSCI 455x</option>
									<option value="CSCI-457">CSCI 457</option>
									<option value="CSCI-458">CSCI 458</option>
									<option value="CSCI-467">CSCI 467</option>
									<option value="CSCI-487">CSCI 487</option>
									<option value="CSCI-490X">CSCI 490X</option>
									<option value="CSCI-491aL">CSCI 491aL</option>
									<option value="CSCI-495">CSCI 495</option>
									<option value="CSCI-499">CSCI 499</option>
									<option value="CSCI-505a">CSCI 505a</option>
									<option value="CSCI-510">CSCI 510</option>
									<option value="CSCI-522">CSCI 522</option>
									<option value="CSCI-526">CSCI 526</option>
									<option value="CSCI-529a">CSCI 529a</option>
									<option value="CSCI-530">CSCI 530</option>
									<option value="CSCI-534">CSCI 534</option>
									<option value="CSCI-536">CSCI 536</option>
									<option value="CSCI-537">CSCI 537</option>
									<option value="CSCI-538">CSCI 538</option>
									<option value="CSCI-541">CSCI 541</option>
									<option value="CSCI-544">CSCI 544</option>
									<option value="CSCI-550">CSCI 550</option>
									<option value="CSCI-555L">CSCI 555L</option>
									<option value="CSCI-557">CSCI 557</option>
									<option value="CSCI-560">CSCI 560</option>
									<option value="CSCI-561">CSCI 561</option>
									<option value="CSCI-563">CSCI 563</option>
									<option value="CSCI-567">CSCI 567</option>
									<option value="CSCI-570">CSCI 570</option>
									<option value="CSCI-571">CSCI 571</option>
									<option value="CSCI-572">CSCI 572</option>
									<option value="CSCI-576">CSCI 576</option>
									<option value="CSCI-577a">CSCI 577a</option>
									<option value="CSCI-580">CSCI 580</option>
									<option value="CSCI-585">CSCI 585</option>
									<option value="CSCI-586">CSCI 586</option>
									<option value="CSCI-590">CSCI 590</option>
									<option value="CSCI-591">CSCI 591</option>
									<option value="CSCI-594a">CSCI 594a</option>
									<option value="CSCI-594b">CSCI 594b</option>
									<option value="CSCI-594z">CSCI 594z</option>
									<option value="CSCI-596">CSCI 596</option>
									<option value="CSCI-599">CSCI 599</option>
									<option value="CSCI-610">CSCI 610</option>
									<option value="CSCI-644">CSCI 610</option>
									<option value="CSCI-658">CSCI 610</option>
									<option value="CSCI-670">CSCI 610</option>
									<option value="CSCI-671">CSCI 610</option>
									<option value="CSCI-677">CSCI 610</option>
									<option value="CSCI-697">CSCI 610</option>
									<option value="CSCI-698">CSCI 610</option>
									<option value="CSCI-699">CSCI 610</option>
									<option value="CSCI-790">CSCI 790</option>
									<option value="CSCI-794a">CSCI 794a</option>
									<option value="CSCI-794b">CSCI 794b</option>
									<option value="CSCI-794c">CSCI 794c</option>
									<option value="CSCI-794d">CSCI 794d</option>
									<option value="CSCI-794z">CSCI 794z</option>
								</select>
								<select name="course3" id="course3">
									<option value="None">None</option>
									<option value="CSCI-100xg">CSCI 100xg</option>
									<option value="CSCI-102L">CSCI 102L</option>
									<option value="CSCI-103L">CSCI 103L</option>
									<option value="CSCI-104L">CSCI 104L</option>
									<option value="CSCI-109">CSCI 109</option>
									<option value="CSCI-170">CSCI 170</option>
									<option value="CSCI-201">CSCI 201</option>
									<option value="CSCI-270">CSCI 270</option>
									<option value="CSCI-310">CSCI 310</option>
									<option value="CSCI-350">CSCI 350</option>
									<option value="CSCI-353">CSCI 353</option>
									<option value="CSCI-356">CSCI 356</option>
									<option value="CSCI-360">CSCI 360</option>
									<option value="CSCI-368">CSCI 368</option>
									<option value="CSCI-380">CSCI 380</option>
									<option value="CSCI-401">CSCI 401</option>
									<option value="CSCI-402">CSCI 402</option>
									<option value="CSCI-420">CSCI 420</option>
									<option value="CSCI-426">CSCI 426</option>
									<option value="CSCI-430">CSCI 430</option>
									<option value="CSCI-435">CSCI 435</option>
									<option value="CSCI-445L">CSCI 445L</option>
									<option value="CSCI-450">CSCI 450</option>
									<option value="CSCI-454L">CSCI 454L</option>
									<option value="CSCI-455x">CSCI 455x</option>
									<option value="CSCI-457">CSCI 457</option>
									<option value="CSCI-458">CSCI 458</option>
									<option value="CSCI-467">CSCI 467</option>
									<option value="CSCI-487">CSCI 487</option>
									<option value="CSCI-490X">CSCI 490X</option>
									<option value="CSCI-491aL">CSCI 491aL</option>
									<option value="CSCI-495">CSCI 495</option>
									<option value="CSCI-499">CSCI 499</option>
									<option value="CSCI-505a">CSCI 505a</option>
									<option value="CSCI-510">CSCI 510</option>
									<option value="CSCI-522">CSCI 522</option>
									<option value="CSCI-526">CSCI 526</option>
									<option value="CSCI-529a">CSCI 529a</option>
									<option value="CSCI-530">CSCI 530</option>
									<option value="CSCI-534">CSCI 534</option>
									<option value="CSCI-536">CSCI 536</option>
									<option value="CSCI-537">CSCI 537</option>
									<option value="CSCI-538">CSCI 538</option>
									<option value="CSCI-541">CSCI 541</option>
									<option value="CSCI-544">CSCI 544</option>
									<option value="CSCI-550">CSCI 550</option>
									<option value="CSCI-555L">CSCI 555L</option>
									<option value="CSCI-557">CSCI 557</option>
									<option value="CSCI-560">CSCI 560</option>
									<option value="CSCI-561">CSCI 561</option>
									<option value="CSCI-563">CSCI 563</option>
									<option value="CSCI-567">CSCI 567</option>
									<option value="CSCI-570">CSCI 570</option>
									<option value="CSCI-571">CSCI 571</option>
									<option value="CSCI-572">CSCI 572</option>
									<option value="CSCI-576">CSCI 576</option>
									<option value="CSCI-577a">CSCI 577a</option>
									<option value="CSCI-580">CSCI 580</option>
									<option value="CSCI-585">CSCI 585</option>
									<option value="CSCI-586">CSCI 586</option>
									<option value="CSCI-590">CSCI 590</option>
									<option value="CSCI-591">CSCI 591</option>
									<option value="CSCI-594a">CSCI 594a</option>
									<option value="CSCI-594b">CSCI 594b</option>
									<option value="CSCI-594z">CSCI 594z</option>
									<option value="CSCI-596">CSCI 596</option>
									<option value="CSCI-599">CSCI 599</option>
									<option value="CSCI-610">CSCI 610</option>
									<option value="CSCI-644">CSCI 610</option>
									<option value="CSCI-658">CSCI 610</option>
									<option value="CSCI-670">CSCI 610</option>
									<option value="CSCI-671">CSCI 610</option>
									<option value="CSCI-677">CSCI 610</option>
									<option value="CSCI-697">CSCI 610</option>
									<option value="CSCI-698">CSCI 610</option>
									<option value="CSCI-699">CSCI 610</option>
									<option value="CSCI-790">CSCI 790</option>
									<option value="CSCI-794a">CSCI 794a</option>
									<option value="CSCI-794b">CSCI 794b</option>
									<option value="CSCI-794c">CSCI 794c</option>
									<option value="CSCI-794d">CSCI 794d</option>
									<option value="CSCI-794z">CSCI 794z</option>
								</select>
								<select name="course4" id="course4">
									<option value="None">None</option>
									<option value="CSCI-100xg">CSCI 100xg</option>
									<option value="CSCI-102L">CSCI 102L</option>
									<option value="CSCI-103L">CSCI 103L</option>
									<option value="CSCI-104L">CSCI 104L</option>
									<option value="CSCI-109">CSCI 109</option>
									<option value="CSCI-170">CSCI 170</option>
									<option value="CSCI-201">CSCI 201</option>
									<option value="CSCI-270">CSCI 270</option>
									<option value="CSCI-310">CSCI 310</option>
									<option value="CSCI-350">CSCI 350</option>
									<option value="CSCI-353">CSCI 353</option>
									<option value="CSCI-356">CSCI 356</option>
									<option value="CSCI-360">CSCI 360</option>
									<option value="CSCI-368">CSCI 368</option>
									<option value="CSCI-380">CSCI 380</option>
									<option value="CSCI-401">CSCI 401</option>
									<option value="CSCI-402">CSCI 402</option>
									<option value="CSCI-420">CSCI 420</option>
									<option value="CSCI-426">CSCI 426</option>
									<option value="CSCI-430">CSCI 430</option>
									<option value="CSCI-435">CSCI 435</option>
									<option value="CSCI-445L">CSCI 445L</option>
									<option value="CSCI-450">CSCI 450</option>
									<option value="CSCI-454L">CSCI 454L</option>
									<option value="CSCI-455x">CSCI 455x</option>
									<option value="CSCI-457">CSCI 457</option>
									<option value="CSCI-458">CSCI 458</option>
									<option value="CSCI-467">CSCI 467</option>
									<option value="CSCI-487">CSCI 487</option>
									<option value="CSCI-490X">CSCI 490X</option>
									<option value="CSCI-491aL">CSCI 491aL</option>
									<option value="CSCI-495">CSCI 495</option>
									<option value="CSCI-499">CSCI 499</option>
									<option value="CSCI-505a">CSCI 505a</option>
									<option value="CSCI-510">CSCI 510</option>
									<option value="CSCI-522">CSCI 522</option>
									<option value="CSCI-526">CSCI 526</option>
									<option value="CSCI-529a">CSCI 529a</option>
									<option value="CSCI-530">CSCI 530</option>
									<option value="CSCI-534">CSCI 534</option>
									<option value="CSCI-536">CSCI 536</option>
									<option value="CSCI-537">CSCI 537</option>
									<option value="CSCI-538">CSCI 538</option>
									<option value="CSCI-541">CSCI 541</option>
									<option value="CSCI-544">CSCI 544</option>
									<option value="CSCI-550">CSCI 550</option>
									<option value="CSCI-555L">CSCI 555L</option>
									<option value="CSCI-557">CSCI 557</option>
									<option value="CSCI-560">CSCI 560</option>
									<option value="CSCI-561">CSCI 561</option>
									<option value="CSCI-563">CSCI 563</option>
									<option value="CSCI-567">CSCI 567</option>
									<option value="CSCI-570">CSCI 570</option>
									<option value="CSCI-571">CSCI 571</option>
									<option value="CSCI-572">CSCI 572</option>
									<option value="CSCI-576">CSCI 576</option>
									<option value="CSCI-577a">CSCI 577a</option>
									<option value="CSCI-580">CSCI 580</option>
									<option value="CSCI-585">CSCI 585</option>
									<option value="CSCI-586">CSCI 586</option>
									<option value="CSCI-590">CSCI 590</option>
									<option value="CSCI-591">CSCI 591</option>
									<option value="CSCI-594a">CSCI 594a</option>
									<option value="CSCI-594b">CSCI 594b</option>
									<option value="CSCI-594z">CSCI 594z</option>
									<option value="CSCI-596">CSCI 596</option>
									<option value="CSCI-599">CSCI 599</option>
									<option value="CSCI-610">CSCI 610</option>
									<option value="CSCI-644">CSCI 610</option>
									<option value="CSCI-658">CSCI 610</option>
									<option value="CSCI-670">CSCI 610</option>
									<option value="CSCI-671">CSCI 610</option>
									<option value="CSCI-677">CSCI 610</option>
									<option value="CSCI-697">CSCI 610</option>
									<option value="CSCI-698">CSCI 610</option>
									<option value="CSCI-699">CSCI 610</option>
									<option value="CSCI-790">CSCI 790</option>
									<option value="CSCI-794a">CSCI 794a</option>
									<option value="CSCI-794b">CSCI 794b</option>
									<option value="CSCI-794c">CSCI 794c</option>
									<option value="CSCI-794d">CSCI 794d</option>
									<option value="CSCI-794z">CSCI 794z</option>
								</select>
								<select name="course5" id="course5">
									<option value="None">None</option>
									<option value="CSCI-100xg">CSCI 100xg</option>
									<option value="CSCI-102L">CSCI 102L</option>
									<option value="CSCI-103L">CSCI 103L</option>
									<option value="CSCI-104L">CSCI 104L</option>
									<option value="CSCI-109">CSCI 109</option>
									<option value="CSCI-170">CSCI 170</option>
									<option value="CSCI-201">CSCI 201</option>
									<option value="CSCI-270">CSCI 270</option>
									<option value="CSCI-310">CSCI 310</option>
									<option value="CSCI-350">CSCI 350</option>
									<option value="CSCI-353">CSCI 353</option>
									<option value="CSCI-356">CSCI 356</option>
									<option value="CSCI-360">CSCI 360</option>
									<option value="CSCI-368">CSCI 368</option>
									<option value="CSCI-380">CSCI 380</option>
									<option value="CSCI-401">CSCI 401</option>
									<option value="CSCI-402">CSCI 402</option>
									<option value="CSCI-420">CSCI 420</option>
									<option value="CSCI-426">CSCI 426</option>
									<option value="CSCI-430">CSCI 430</option>
									<option value="CSCI-435">CSCI 435</option>
									<option value="CSCI-445L">CSCI 445L</option>
									<option value="CSCI-450">CSCI 450</option>
									<option value="CSCI-454L">CSCI 454L</option>
									<option value="CSCI-455x">CSCI 455x</option>
									<option value="CSCI-457">CSCI 457</option>
									<option value="CSCI-458">CSCI 458</option>
									<option value="CSCI-467">CSCI 467</option>
									<option value="CSCI-487">CSCI 487</option>
									<option value="CSCI-490X">CSCI 490X</option>
									<option value="CSCI-491aL">CSCI 491aL</option>
									<option value="CSCI-495">CSCI 495</option>
									<option value="CSCI-499">CSCI 499</option>
									<option value="CSCI-505a">CSCI 505a</option>
									<option value="CSCI-510">CSCI 510</option>
									<option value="CSCI-522">CSCI 522</option>
									<option value="CSCI-526">CSCI 526</option>
									<option value="CSCI-529a">CSCI 529a</option>
									<option value="CSCI-530">CSCI 530</option>
									<option value="CSCI-534">CSCI 534</option>
									<option value="CSCI-536">CSCI 536</option>
									<option value="CSCI-537">CSCI 537</option>
									<option value="CSCI-538">CSCI 538</option>
									<option value="CSCI-541">CSCI 541</option>
									<option value="CSCI-544">CSCI 544</option>
									<option value="CSCI-550">CSCI 550</option>
									<option value="CSCI-555L">CSCI 555L</option>
									<option value="CSCI-557">CSCI 557</option>
									<option value="CSCI-560">CSCI 560</option>
									<option value="CSCI-561">CSCI 561</option>
									<option value="CSCI-563">CSCI 563</option>
									<option value="CSCI-567">CSCI 567</option>
									<option value="CSCI-570">CSCI 570</option>
									<option value="CSCI-571">CSCI 571</option>
									<option value="CSCI-572">CSCI 572</option>
									<option value="CSCI-576">CSCI 576</option>
									<option value="CSCI-577a">CSCI 577a</option>
									<option value="CSCI-580">CSCI 580</option>
									<option value="CSCI-585">CSCI 585</option>
									<option value="CSCI-586">CSCI 586</option>
									<option value="CSCI-590">CSCI 590</option>
									<option value="CSCI-591">CSCI 591</option>
									<option value="CSCI-594a">CSCI 594a</option>
									<option value="CSCI-594b">CSCI 594b</option>
									<option value="CSCI-594z">CSCI 594z</option>
									<option value="CSCI-596">CSCI 596</option>
									<option value="CSCI-599">CSCI 599</option>
									<option value="CSCI-610">CSCI 610</option>
									<option value="CSCI-644">CSCI 610</option>
									<option value="CSCI-658">CSCI 610</option>
									<option value="CSCI-670">CSCI 610</option>
									<option value="CSCI-671">CSCI 610</option>
									<option value="CSCI-677">CSCI 610</option>
									<option value="CSCI-697">CSCI 610</option>
									<option value="CSCI-698">CSCI 610</option>
									<option value="CSCI-699">CSCI 610</option>
									<option value="CSCI-790">CSCI 790</option>
									<option value="CSCI-794a">CSCI 794a</option>
									<option value="CSCI-794b">CSCI 794b</option>
									<option value="CSCI-794c">CSCI 794c</option>
									<option value="CSCI-794d">CSCI 794d</option>
									<option value="CSCI-794z">CSCI 794z</option>
								</select>
								<button type="submit">Generate Schedules</button>
							</form>
						</div>
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
