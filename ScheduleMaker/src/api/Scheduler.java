package api;

import java.util.List;

import com.google.gson.Gson;

import java.util.ArrayList;


import models.Session;

/**
 * Returns a list of schedules based on course titles
 * 
 * @author Justin Kim
 *
 */
public class Scheduler {
	
	public static String getSchedules(List<Session> sessions) {
		Schedule schedule = new Schedule();
		
		for(Session s : sessions) {
			int id= schedule.getSessionGroupID(s.getSessionCourseName(), s.getSessionType());
			if(id==-1) {
				id = schedule.createSessionGroup(s.getSessionCourseId(), s.getSessionCourseName(), s.getSessionType());

			} 
			schedule.addSession(id, s.getSessionID(), s.getSessionInstructor(), s.getStartTime(), s.getEndTime(), s.getOnDay(), s.getLocation(), s.isTimeTBA());
		}
		

		List<Schedule> schedules = schedule.generateSomeSchedules(10);
		ArrayList<ArrayList<String>> results = new ArrayList<>();
		
		for(Schedule sch : schedules) {
			ArrayList<String> scheduleResult = new ArrayList<>();
			for(Session sess : sch) {
				scheduleResult.add(sess.getJsonString());
			}
			results.add(scheduleResult);
		}
		
		Gson gson = new Gson();
		
		return gson.toJson(results);
	}

}
