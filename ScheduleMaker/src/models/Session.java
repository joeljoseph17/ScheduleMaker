package models;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;


public class Session {
	private static final String UTCstring = "2018-10-13T%s:00.00Z"; // Default standard UTC time string to translate to time
	
	private String courseName;
	private String instructor;
	private String sessionType;
	private String sessionID;
	private Instant startTime;
	private Instant endTime;
	private boolean [] onDay;
	private String location;
	
	// public method for checking whether two sessions are in time conflict
	public static boolean isConflict(Session session1, Session session2) {
		for (int i = 0; i < 5; i++) {
			if (session1.getOnDay()[i] && session2.getOnDay()[i]) {
				//if (session1.getStartTime().isAfter(session2.getStartTime()) && session1.getStartTime().isBefore(session2.getEndTime())
				 //|| session1.getEndTime().isAfter(session2.getStartTime()) && session1.getEndTime().isBefore(session2.getEndTime())) {
				if (!(session1.getStartTime().isBefore(session2.getStartTime()) && session1.getEndTime().isBefore(session2.getStartTime())
					|| (session1.getStartTime().isAfter(session2.getEndTime()) && session1.getEndTime().isAfter(session2.getEndTime())))) {	
					return true;
				}
			}
		}
		return false;
	}
	
	// Constructor
	// startTime and endTime format: hh:mm
	public Session(String courseName, String instructor, String sessionType, String sessionID, String startTime, 
			       String endTime, boolean [] onDay, String location) 
		throws DateTimeParseException{
		this(courseName, instructor, sessionType, sessionID, 
				Instant.parse(String.format(UTCstring, startTime)), Instant.parse(String.format(UTCstring, endTime)),
				onDay, location);
	}
	
	// Constructor
	// startTime and endTime format: hh:mm
	public Session(String courseName, String instructor, String sessionType, String sessionID, Instant startTime, 
				   Instant endTime, boolean [] onDay, String location) {
		this.courseName = courseName;
		this.instructor = instructor;
		this.sessionType = sessionType;
		this.sessionID = sessionID;
		this.startTime = startTime;
		this.endTime = endTime;
		this.onDay = onDay;
		this.location = location;
	}	
	
	public String getJsonString() {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("hh:mm a").withZone(ZoneId.of("Z"));
		String json = "";
		json += "{";
		json += "'courseName' : '" + this.courseName + "', ";
		json += "'instructor' : '" + this.instructor + "', ";
		json += "'sessionType' : '" + this.sessionType + "', ";
		json += "'sessionID' : '" + this.sessionID + "', ";
		json += "'startTime' : '" + formatter.format(this.startTime) + "', ";
		json += "'endTime': '" + formatter.format(this.endTime) + "', ";
		json += "'onDay': " + "[";
		for (int i = 0; i < this.onDay.length; i++) {
			json += this.onDay[i] + (i == this.onDay.length - 1 ? "], " : ", ");
		}
		json += "'location': '" + this.location + "'";
		json += "}";
		System.out.println(json);
		return json;
	}
	
	public String getSessionCourseName() {
		return courseName;
	}
	
	public String getSessionInstructor() {
		return instructor;
	}
	
	public String getSessionType() {
		return sessionType;
	}
	
	public String getSessionID() {
		return sessionID;
	}
	
	// Return the session's start time in string format
	public Instant getStartTime() {
		return startTime;
	}
	
	// Return the session's end time in string format
	public Instant getEndTime() {
		return endTime;
	}
	
	// Return the session's location
	public String getLocation() {
		return location;
	}
	
	// Return an boolean array indicating which day the session is on
	public boolean[] getOnDay() {
		return onDay;
	}
}