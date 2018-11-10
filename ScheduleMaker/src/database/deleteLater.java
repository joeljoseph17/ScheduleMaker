package database;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import com.google.api.core.ApiFuture;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.gson.JsonObject;

public class deleteLater {
	private final static String USERS_DB = "Users";

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("Start");
		for(JsonObject json : searchUsers("kim20@usc.edu", "Joel Joseph")) {
			System.out.println(json.getAsString());
		}
		System.out.println("End");
	}

	public static List<JsonObject> searchUsers(String currentUserEmail, String query) {
		Firestore db = initFirestore();
		List<JsonObject> users = new LinkedList<>();
		
		//Define the Collection you want to search
		CollectionReference usersCollection = db.collection(USERS_DB);
		Query myQuery = usersCollection.whereArrayContains("name", query);

		ApiFuture<QuerySnapshot> querySnapshot = myQuery.get();
		
		System.out.println("one");
		try {
			System.out.println(querySnapshot.get().toString());
		} catch (InterruptedException | ExecutionException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		System.out.println("two");
		//Cycle through all the documents that come back
		try {
			for (DocumentSnapshot docSnap : querySnapshot.get().getDocuments()) {		
				System.out.println("loop");
				
				JsonObject user = new JsonObject();
				String name = docSnap.getString("name");
				String email = docSnap.getString("email");
				
				if(!currentUserEmail.equals(email)) { //don't add current user to list of returned user
					//continue;
				}
				
				user.addProperty("name", name);
				user.addProperty("email", email);
				
				users.add(user);
			}
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return users;
	}
	
	private static Firestore initFirestore() {
		Firestore db = null;
		List<FirebaseApp> firebaseApps = FirebaseApp.getApps();

		if(firebaseApps!=null && !firebaseApps.isEmpty()){
			for(FirebaseApp app : firebaseApps){
				if(app.getName().equals(FirebaseApp.DEFAULT_APP_NAME))
					db = FirestoreClient.getFirestore();
			}
		}
		else {
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
		}
		
		return db;
	}
}