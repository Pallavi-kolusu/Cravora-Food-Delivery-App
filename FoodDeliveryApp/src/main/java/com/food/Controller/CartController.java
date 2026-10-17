package com.food.Controller;

import java.io.IOException;

import com.food.DAOImple.MenuDAOImple;
import com.food.model.Cart;
import com.food.model.CartItem;
import com.food.model.Menu;
import com.food.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req,
	                     HttpServletResponse resp)
	        throws ServletException, IOException {

	    HttpSession session = req.getSession();

	    User loggedUser =
	            (User) session.getAttribute("user");

	    if (loggedUser == null) {

	    	resp.sendRedirect(
	    	        req.getContextPath()
	    	        + "/login.jsp?redirect=cart"
	    	);
	    	
	        return;
	    }

	    RequestDispatcher rd =
	            req.getRequestDispatcher("cart.jsp");

	    rd.forward(req, resp);
	}

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String source = req.getParameter("source");

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        // ================= ADD TO CART =================
        if ("add".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));
            MenuDAOImple menuDAO = new MenuDAOImple();
            Menu menu = menuDAO.getMenu(menuId);

            if (menu == null) {
                resp.sendRedirect("menu");
                return;
            }

            if (cart == null) {
                cart = new Cart(menu.getRestaurantId());
                session.setAttribute("cart", cart);
            }

            if (cart.getRestaurantId() == menu.getRestaurantId()) {
                CartItem cartItem = new CartItem(menu, 1);
                cart.addItem(cartItem);
            } else {
                session.setAttribute(
                    "cartMessage",
                    "Your cart contains items from another restaurant."
                );
            }

            if ("cart".equals(source)) {
                resp.sendRedirect(req.getContextPath() + "/cart");
            } else {
                resp.sendRedirect("menu?restaurantId=" + menu.getRestaurantId());
            }
        }

        // ================= INCREASE QUANTITY =================
        else if ("increase".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));

            if (cart != null && cart.getItems().containsKey(menuId)) {
                CartItem cartItem = cart.getItems().get(menuId);
                cartItem.setQuantity(cartItem.getQuantity() + 1);
            }

            String restaurantId = req.getParameter("restaurantId");

            if ("cart".equals(source) || restaurantId == null || restaurantId.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart");
            } else {
                resp.sendRedirect("menu?restaurantId=" + restaurantId);
            }
        }

        // ================= DECREASE QUANTITY =================
        else if ("decrease".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));

            if (cart != null && cart.getItems().containsKey(menuId)) {
                CartItem cartItem = cart.getItems().get(menuId);
                int quantity = cartItem.getQuantity();

                if (quantity > 1) {
                    cartItem.setQuantity(quantity - 1);
                } else {
                    cart.removeItem(menuId);
                }
            }

            String restaurantId = req.getParameter("restaurantId");

            if ("cart".equals(source) || restaurantId == null || restaurantId.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart");
            } else {
                resp.sendRedirect("menu?restaurantId=" + restaurantId);
            }
        }

        // ================= CLEAR CART =================
        else if ("clear".equals(action)) {
            session.removeAttribute("cart");
            resp.sendRedirect(req.getContextPath() + "/cart");
        }       
    }
}