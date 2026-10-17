package com.food.Controller;

import java.io.IOException;
import java.util.List;

import com.food.DAOImple.MenuDAOImple;
import com.food.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
		
		MenuDAOImple menuDao = new MenuDAOImple();
		
		 List<Menu> menuList =  menuDao.getMenuByRestaurantId(restaurantId);
		 
		 req.setAttribute("menuList", menuList);
		
		 RequestDispatcher rd  = req.getRequestDispatcher("menu.jsp");
		 rd.forward(req, resp);
	}

}
