<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Home</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
				<meta name="google-signin-client_id" content="173320350877-evj10cjs6durmcoij1vnubs9fkalg0i3.apps.googleusercontent.com">
		<script src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>
		<link rel="stylesheet" href="assets/css/main.css" />
		<noscript><link rel="stylesheet" href="assets/css/noscript.css"/></noscript>
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
			function saveSchedule(event){
				var clickedThing = event.target;
				while(clickedThing.nodeName != "TABLE"){
					clickedThing = clickedThing.parentElement;
				}
				var scheduleId = clickedThing.id.substring(8);
				var thisSchedule = document.getElementById("hidden"+scheduleId).innerHTML;
				console.log(thisSchedule);
			}
		</script>
		<style>
			.schedule {
			    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
			    border-collapse: collapse;
			    width: 40%;
			    margin: 20px;
			}
			
			.schedule td, .schedule th {
			    border: 1px solid #ddd;
			    padding: 8px;
			}
			
			.schedule tr:nth-child(even){background-color: #f2f2f2;}
			
			.schedule tr:hover {background-color: #ddd;}
			
			
			.schedule th {
			    padding-top: 12px;
			    padding-bottom: 12px;
			    text-align: left;
			    background-color: rgb(255, 255, 85);
			    color: white;
			}
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
			#schedules{
				display: flex;
				flex-flow: row wrap;
				justify-content: center;
			}
		</style>
	</head>
	<body class="is-preload">
	<%@ page import="com.google.gson.Gson" %>
	<%@ page import="java.io.StringReader" %>
	<%@ page import="com.google.gson.JsonObject" %>
	<%@ page import="com.google.gson.JsonArray" %>
	<%@ page import="com.google.gson.JsonElement" %>
	<%@ page import="com.google.gson.stream.JsonReader" %>
				<%
String param = request.getAttribute("schedules").toString();
//System.out.println(param);
System.out.println("made it to the jsp comparison page");
Gson gson = new Gson();
JsonReader jr = new JsonReader(new StringReader(param)); 
jr.setLenient(true); 
JsonArray body = gson.fromJson(jr, JsonArray.class);
System.out.println(body);

%>
		
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
					<header id="header" class="alt">
						<h1>Schedules</h1>
					</header>

				<!-- Main -->
					<div id="main">
							
					<!-- Second Section -->
						<section id="saved" class="main special">
							<header class="major">
								<h2>Schedules</h2>
								<div id="schedules">
								<% 
								for(int i=0; i<body.size(); i++){
									JsonArray thisSchedule = body.get(i).getAsJsonArray();
									String whichSchedule="schedule"+i;
									String hiddenId = "hidden"+i;
								
								%>
								<p style="display:none" id=<%= hiddenId %>><%= thisSchedule.toString() %></p>
									<table class="schedule" onClick="saveSchedule(event)" id=<%=whichSchedule %>>
										<tr>
											<th>Course Name</th>
											<th>Date(s)</th>
											<th>Time</th>
											<th>Instructor</th>
											<th>Location</th>
										</tr>
								<%
											for(int j=0; j<thisSchedule.size(); j++){
												String thisThing = thisSchedule.get(j).getAsString();
												JsonReader reader = new JsonReader(new StringReader(thisThing)); 
												reader.setLenient(true); 
												JsonObject courseChoice = gson.fromJson(reader, JsonObject.class);
												String name = gson.fromJson(courseChoice.get("courseName"), String.class)+" "+gson.fromJson(courseChoice.get("sessionType"), String.class);
												String date = "";
												boolean[] days = gson.fromJson(courseChoice.get("onDay"), boolean[].class);
												if(days[0]){
													date=date+"M";
												}
												if(days[1]){
													date = date+"T";
												}
												if(days[2]){
													date=date+"W";
												}
												if(days[3]){
													date=date+"Th";
												}
												if(days[4]){
													date=date+"F";
												}
												
												
												
												String time = gson.fromJson(courseChoice.get("startTime"), String.class)+" - "+gson.fromJson(courseChoice.get("endTime"), String.class);
												String location = gson.fromJson(courseChoice.get("location"), String.class);
												String instructor = gson.fromJson(courseChoice.get("instructor"), String.class);
												if(instructor.equals("No Information")){
													instructor = "TBD";
												}
										%>
										<tr>
											<td><%= name %></td>
											<td><%= date %></td>
											<td><%= time %></td>
											<td><%= instructor %></td>
											<td><%= location %></td>
										</tr>
										<%} %>
									
									</table>
									<%
								}
									%>
								</div>
								
								
							</header>
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
