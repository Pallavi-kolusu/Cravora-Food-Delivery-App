package com.food.Controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.food.DAOImple.MenuDAOImple;
import com.food.DAOImple.OrderDAOImple;
import com.food.DAOImple.OrderItemDAOImple;
import com.food.DAOImple.RestaurantDAOImple;
import com.food.model.Menu;
import com.food.model.Order;
import com.food.model.OrderItem;
import com.food.model.Restaurant;
import com.food.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedUser = (User) session.getAttribute("user");

        // Redirect to login if user is not authenticated
        if (loggedUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=orders");
            return;
        }

        OrderDAOImple orderDAO = new OrderDAOImple();
        List<Order> orders = orderDAO.getOrdersByUserId(loggedUser.getUserId());

        RestaurantDAOImple restaurantDAO = new RestaurantDAOImple();
        OrderItemDAOImple orderItemDAO = new OrderItemDAOImple();
        MenuDAOImple menuDAO = new MenuDAOImple();

        Map<Integer, Restaurant> restaurantMap = new HashMap<>();
        Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
        Map<Integer, Menu> menuMap = new HashMap<>();

        if (orders != null && !orders.isEmpty()) {
            for (Order order : orders) {
                int orderId = order.getOrderId();
                int restaurantId = order.getRestaurantId();

                // Cache restaurant
                if (!restaurantMap.containsKey(restaurantId)) {
                    Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);
                    if (restaurant != null) {
                        restaurantMap.put(restaurantId, restaurant);
                    }
                }

                // Fetch and cache order items
                List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
                if (items == null) {
                    items = new ArrayList<>();
                }
                orderItemsMap.put(orderId, items);

                // Cache menu items
                for (OrderItem item : items) {
                    int menuId = item.getMenuId();
                    if (!menuMap.containsKey(menuId)) {
                        Menu menu = menuDAO.getMenu(menuId);
                        if (menu != null) {
                            menuMap.put(menuId, menu);
                        }
                    }
                }
            }
        }

        req.setAttribute("orders", orders);
        req.setAttribute("restaurantMap", restaurantMap);
        req.setAttribute("orderItemsMap", orderItemsMap);
        req.setAttribute("menuMap", menuMap);

        RequestDispatcher rd = req.getRequestDispatcher("orders.jsp");
        rd.forward(req, resp);
    }
}
