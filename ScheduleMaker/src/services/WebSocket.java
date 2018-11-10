package services;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value="/broadcast")
public class WebSocket {
	
	private static Vector<Session> sessionVector = new Vector<Session>();
	private static Map<String, Session> clientSessionMap = new ConcurrentHashMap<String, Session>();
	
	@OnOpen
	public void open(Session session) {
		sessionVector.add(session);
		System.out.println("New Session Connected!");
	}
	
	@OnMessage
	public void onMessage(String message, Session session) {
		// Split message by ":"
		System.out.println("WebSocket new message: " + message);
		String [] request = message.split(":");
		
		if (request[0].equals("email")) {
			String email = request[1];
			// Check for entry in clientSessionMap
			// If no sessions the server currently hold is registered with the client email, register current session
			if (clientSessionMap.containsKey(email)) {
				// Close previous session and register current session
				try {
					clientSessionMap.get(email).close();
					clientSessionMap.replace(email, session);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			// Else, drop(close) previous session and replace with current session
			else {
				clientSessionMap.put(email, session);
			}
		}
	}
	
	@OnClose
	public void close(Session session) {
		sessionVector.remove(session);
	}
	
	@OnError
	public void error(Throwable error) {
		
	}
	
	// Broadcast some message to the set of sessions specified by a user email list
	public static void broadcast(ArrayList<String> userEmailList, String message) {
		for (String email : userEmailList) {
			// If the user specified by the email is currently holding a session to the server, broadcast
			if (clientSessionMap.containsKey(email)) {
				Session session = clientSessionMap.get(email);
				try {
					session.getBasicRemote().sendText(message);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	// Broadcast some message to all sessions currently communicating to the server
	public static void broadcastAll(String message) {
		for (Session session : sessionVector) {
			try {
				session.getBasicRemote().sendText(message);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
