package com.food.Controller;

import java.io.IOException;
import java.util.List;

import com.food.DAOImple.RestaurantDAOImple;
import com.food.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurant")
public class RestaurantController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RestaurantDAOImple restaurantDao = new RestaurantDAOImple();

        List<Restaurant> allRestaurants =
                restaurantDao.getAllRestaurants();

        req.setAttribute("restaurants", allRestaurants);

        RequestDispatcher rd =
                req.getRequestDispatcher("restaurant.jsp");

        rd.forward(req, resp);
    }
}