package services;

import java.io.IOException;
import java.io.StringReader;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;

import database.Firebase;

/**
 * Servlet implementation class SavedSchedules
 */
@WebServlet("/saved-schedules")
public class SavedSchedules extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SavedSchedules() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String email = request.getParameter("email");
		System.out.println(email);
		String json= new Gson().toJson(Firebase.getSavedSchedules(email));
		System.out.println(json);
		if(json==null) {
			json="";
		}
		
		request.setAttribute("schedules", json);
		RequestDispatcher dispatcher = request.getRequestDispatcher("saved.jsp");
		dispatcher.forward(request,  response);
		//response.setContentType("application/json");
		//response.setCharacterEncoding("UTF-8");
		//response.getWriter().write(json);
		}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
