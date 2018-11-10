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
		</style>
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
			
		</script>
		
		<script type="text/javascript">
		var email;
    	document.addEventListener("DOMContentLoaded", function () {
    		//console.log("H");
    		var searchTerm = sessionStorage.getItem("SearchTerms")
    		console.log("search Term Recieved by Triage @" + searchTerm);
    		
    		
    		var requeststr = "search?";
    		
    		email = sessionStorage.getItem("email");
    		//var URL = sessionStorage.getItem("URL");	
    		
    		requeststr += "email=" + email;
          	requeststr += "&query=" + searchTerm; 
    		
    		
		    var xhttp = new XMLHttpRequest();
	      	xhttp.open("GET", requeststr, true);
	      	xhttp.send();
	   
	      	
	      	console.log("Orders sent: ");
	      	console.log(requeststr);
	      	
	      	console.log("Outbound");
	      	
	      	
	      	//var temp = document.getElementById("hello").innerHTML;
	      	
	      	
    	})
    	
    	
    	
    </script>
    
	</head>
	<body class="is-preload">
		
		<nav id="top">
			<ul>
				<a href="index.jsp">Home</a>
				<a href="generator.jsp">Create a Schedule</a>
				<a href="saved.jsp">Saved Schedules</a>
			</ul>
		</nav>
		
		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Header -->
					<header id="header" class = "alt">
						<h1>Find Friends</h1>
					</header>
						<table>
					<%
					/*
						String param = request.getAttribute("users").toString();
						Gson gson = new Gson();
						JsonReader jr = new JsonReader(new StringReader(param)); 
						jr.setLenient(true); 
						JsonArray body = gson.fromJson(jr, JsonArray.class);
						System.out.println(body);
						for(int i = 0; i<body.size(); i++){
							String thisUser = body.get(i).getAsString();
							JsonReader reader = new JsonReader(new StringReader(thisUser)); 
							reader.setLenient(true); 
							JsonObject userChoice = gson.fromJson(reader, JsonObject.class);
							String name = gson.fromJson(userChoice.get("name"), String.class);
							String email = gson.fromJson(userChoice.get("email"), String.class);
							*/
					%>
						<tr>
							<td></td>
						</tr>
					<%
					/*
						}
						*/
					%>
						</table>

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
