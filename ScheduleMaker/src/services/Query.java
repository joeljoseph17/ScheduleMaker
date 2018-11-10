package services;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import api.Scheduler;
import database.Firebase;

/**
 * Servlet implementation class Query
 */
@WebServlet("/query")
public class Query extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Query() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String pathInfo = request.getPathInfo();

		if(pathInfo == null || pathInfo.equals("/")){

			StringBuilder buffer = new StringBuilder();
			BufferedReader reader = request.getReader();
			String line;
			while ((line = reader.readLine()) != null) {
				buffer.append(line);
			}

			String payload = buffer.toString();
			System.out.println(payload);
			System.out.println("That was the payload");
			String[] portions = payload.split("&");
			String email = "";
			List<String> courses = new ArrayList<String>();
			for(String choice: portions) {
				System.out.println(choice);
				String courseName = choice.split("=")[1];
				String fieldName = choice.split("=")[0];
				if(fieldName=="myuser" || fieldName.equals("myuser")) {
					email=courseName;
				}
				if(courseName!="None") {
					courses.add(courseName);
				}
			}

			//System.out.println(email);
			System.out.println(courses.toString());
			String schedule = Scheduler.getSchedules(Firebase.getCourses(courses));
			request.setAttribute("schedules", schedule);
			request.setAttribute("user", email);
		}
		RequestDispatcher dispatcher = request.getRequestDispatcher("comparison.jsp");
		dispatcher.forward(request,  response);
		/*else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}*/
	}

}
