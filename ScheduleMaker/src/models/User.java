package models;

import java.util.List;
import api.Schedule;

public class User {
	
	List<String> friends;
	List<String> name;
	List<String> savedSchedules;
	
	public List<String> getFriends() {
		return friends;
	}
	public List<String> getName() {
		return name;
	}
	public List<String> getSavedSchedules() {
		return savedSchedules;
	}
	
	
}
