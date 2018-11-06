package database;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.lang.reflect.Type;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;

import com.google.api.core.ApiFuture;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.SetOptions;
import com.google.cloud.firestore.WriteResult;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import com.google.gson.stream.JsonReader;

import models.Session;

public class deleteLater {
	static Firestore db = null;
	public static void main(String[] args) {
		db = null;
		try {
			InputStream serviceAccount = new FileInputStream("cs201-final-project-firebase-adminsdk-mobr9-2f3704063b.json");
			GoogleCredentials credentials = GoogleCredentials.fromStream(serviceAccount);
			FirebaseOptions options = new FirebaseOptions.Builder()
					.setCredentials(credentials)
					.build();
			FirebaseApp.initializeApp(options);

			db = FirestoreClient.getFirestore();
		}
		catch(FileNotFoundException e) {
			System.out.println("LOL something went wrong");
			System.out.println(e.getMessage());
		}
		catch(IOException e) {
			System.out.println("LOL something went wrong");
			System.out.println(e.getMessage());
		}
		System.out.println("Connected to firebase");


		if(!testRegisterNewUser()) {
			System.out.println("Something went wrong in registering a new user");
		}
		//set up for getting saved schedules
		Map<String, Object> update = new HashMap<>();

		ArrayList<String> schedules = new ArrayList<>();
		schedules.add("Test Schedule");
		ArrayList<String> friends = new ArrayList<>();
		schedules.add("Test Friend");
		update.put("savedSchedules", schedules);
		update.put("friends", friends);

		ApiFuture<WriteResult> writeResult =
				db
				.collection("Users")
				.document("testOnlyUser@gmail.com")
				.set(update, SetOptions.merge());

		if(!testGetAUsersSavedSchedules()) {
			System.out.println("Something went wrong in getting the saved schedules of a user");
		}
		if(!testGetCourseSchedules()) {
			System.out.println("Something went wrong in getting a course schedule");
		}
		if(!testSaveSchedule()) {
			System.out.println("Something went wrong in saving a course schedule");
		}
		if(!testGetFriends()) {
			System.out.println("Something went wrong with getting the friends of a user");
		}
		if(!testFollowUser()) {
			System.out.println("Something went wrong with following a user");
		}
		db.collection("Users").document("testOnlyUser@gmail.com").delete();
	}
	public static boolean testRegisterNewUser() {
		//hit endpoint to add a new user "testOnlyUser@gmail.com" name="Test User"
		HttpClient httpclient = HttpClients.createDefault();
		HttpPost httppost = new HttpPost("localhost:8080/register");

		// Request parameters and other properties.
		List<NameValuePair> params = new ArrayList<NameValuePair>(2);
		params.add(new BasicNameValuePair("email", "testOnlyUser@gmail.com"));
		params.add(new BasicNameValuePair("user", "{\"friends\":[], \"name\":\"Test User\", \"savedSchedules\":[]}"));
		try {
			httppost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
			//Execute and get the response.
			HttpResponse response = httpclient.execute(httppost);
			HttpEntity entity = response.getEntity();
		}catch(Exception e) {
			return false;
		}

		//confirm that the user is now in the database
		DocumentReference docRef = db.collection("Users").document("testOnlyUser@gmail.com");
		ApiFuture<DocumentSnapshot> future = docRef.get();
		try {
			DocumentSnapshot document = future.get();
			if(document.exists()) {
				return true;
			}else {
				return false;
			}
		}
		catch (Exception e){
			return false;
		}

	}
	public static boolean testGetAUsersSavedSchedules() {
		//hit endpoint to get saved schedules for testUserOnly@gmail.com
		//expect single element ["Test Schedule"]
		HttpClient httpclient = HttpClients.createDefault();
		HttpGet httpget = new HttpGet("localhost:8080/saved-schedules?email=testUserOnly@gmail.com");
		try {
			ResponseHandler<String> handler = new BasicResponseHandler();
			String body = httpclient.execute(httpget, handler);
			//make sure it comes back as what I expect
			if(body.contains("Test Schedule")) {
				return true;
			}
			return false;
		}catch (Exception e) {
			return false;
		}
	}
	public static boolean testGetCourseSchedules() {
		//hit endpoint to get a course schedule for CS104, CS170, CS109
		HttpClient httpclient = HttpClients.createDefault();
		HttpGet httpget = new HttpGet("localhost:8080/query");

		try {
			ResponseHandler<String> handler = new BasicResponseHandler();
			String body = httpclient.execute(httpget, handler);
			
			Gson gson = new Gson();
			JsonReader jr = new JsonReader(new StringReader(body.trim())); 
			jr.setLenient(true); 

			JsonObject jsonObj = gson.fromJson(jr, JsonObject.class);

			Type scheduleType = new TypeToken<List<List<Session>>>() {}.getType();    

			List<List<Session>> schedule = gson.fromJson(body, scheduleType);			//make sure it comes back as what I expect
			if(schedule.size()==0)
				return false;
			if(!schedule.get(0).get(0).getSessionCourseName().startsWith(("CSCI 104")))
				return false;
		}catch (Exception e) {
		}
		return false;
	}
	public static boolean testSaveSchedule() {
	      //hit endpoint to add friend, expect to come back ["Test@Friend", "Test@Friend2"]
        HttpClient httpclient = HttpClients.createDefault();
        HttpPost httppost = new HttpPost("localhost:8080/save");

        // Request parameters and other properties.
        List<NameValuePair> params = new ArrayList<NameValuePair>(2);
        params.add(new BasicNameValuePair("email", "testOnlyUser@gmail.com"));
        params.add(new BasicNameValuePair("schedule", "[\n" + 
        		"    	\"CSCI-356 30126R\",\n" + 
        		"    	\"CSCI-360 29983R\",\n" + 
        		"    	\"CSCI-360 30031D\",\n" + 
        		"    	\"CSCI-380 31872D\",\n" + 
        		"    	\"CSCI-401 30227R\"\n" + 
        		"	]"));
        try {
            httppost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
            //Execute and get the response.
            HttpResponse response = httpclient.execute(httppost);
            HttpEntity entity = response.getEntity();
        }catch(Exception e) {
            return false;
        }
        
        //confirm that the new friend is there now
        DocumentReference docRef = db.collection("Users").document("testOnlyUser@gmail.com");
        ApiFuture<DocumentSnapshot> future = docRef.get();
        try {
        DocumentSnapshot document = future.get();
        if(document.exists()) {
            Map<String, Object> data = document.getData();
            Gson gson = new Gson();
			JsonReader jr = new JsonReader(new StringReader(data.get("savedSchedule").toString())); 
			jr.setLenient(true); 

			JsonObject jsonObj = gson.fromJson(jr, JsonObject.class);

			Type scheduleType = new TypeToken<List<List<Session>>>() {}.getType();    

			
			List<List<Session>> schedule = gson.fromJson(jr, scheduleType);
			if(schedule.size()==0)
				return false;
			if(!schedule.get(0).get(0).getSessionCourseName().startsWith(("CSCI 104")))
				return false;
			
            if(data.get("savedSchedule").toString().contains(""))
                return true;
            else
                return false;
        }else {
            return false;
        }
        }
        catch (Exception e){
            return false;
        }
	}
	public static boolean testGetFriends() {
		//hit endpoint to get friends, expect to come back ["Test Friend"]
		return false;
	}
	public static boolean testFollowUser() {
		//hit endpoint to add friend, expect to come back ["Test Friend 2"]
		return false;
	}
}