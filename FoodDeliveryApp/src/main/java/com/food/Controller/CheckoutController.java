package com.food.Controller;

import java.io.IOException;
import java.sql.Timestamp;

import com.food.DAOImple.OrderDAOImple;
import com.food.DAOImple.OrderItemDAOImple;
import com.food.DAOImple.RestaurantDAOImple;
import com.food.model.Cart;
import com.food.model.CartItem;
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

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedUser = (User) session.getAttribute("user");

        // Redirect to login if user is not authenticated
        if (loggedUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");

        // Redirect to cart if cart is empty
        if (cart == null || cart.getCartItems() == null || cart.getCartItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        RequestDispatcher rd = req.getRequestDispatcher("checkout.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getCartItems() == null || cart.getCartItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String paymentMode = req.getParameter("paymentMode");
        if (paymentMode == null || paymentMode.trim().isEmpty()) {
            paymentMode = "UPI";
        }

        String formattedPaymentMode = paymentMode;
        if ("CARD".equalsIgnoreCase(paymentMode)) {
            String cardNumber = req.getParameter("cardNumber");
            if (cardNumber != null && cardNumber.replaceAll("\\s+", "").length() >= 4) {
                String cleanNumber = cardNumber.replaceAll("\\s+", "");
                String last4 = cleanNumber.substring(cleanNumber.length() - 4);
                formattedPaymentMode = "CARD (**** " + last4 + ")";
            } else {
                formattedPaymentMode = "CARD";
            }
        } else if ("UPI".equalsIgnoreCase(paymentMode)) {
            String upiId = req.getParameter("upiId");
            if (upiId != null && !upiId.trim().isEmpty()) {
                formattedPaymentMode = "UPI (" + upiId.trim() + ")";
            } else {
                formattedPaymentMode = "UPI";
            }
        } else if ("COD".equalsIgnoreCase(paymentMode)) {
            formattedPaymentMode = "COD";
        }

        String deliveryAddress = req.getParameter("address");
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            deliveryAddress = loggedUser.getAddress();
        }

        String phoneNumber = req.getParameter("phoneNumber");
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            phoneNumber = loggedUser.getPhoneNumber();
        }

        int restaurantId = cart.getRestaurantId();
        int userId = loggedUser.getUserId();
        Timestamp orderDate = new Timestamp(System.currentTimeMillis());
        double totalAmount = cart.getTotalAmount() + 5.0; // Total includes ₹5 platform fee
        String status = "CONFIRMED";

        // 1. Insert into `orders` table
        Order order = new Order(restaurantId, userId, orderDate, totalAmount, status, formattedPaymentMode);
        OrderDAOImple orderDAO = new OrderDAOImple();
        int orderId = orderDAO.addOrder(order);

        // 2. Insert into `orderitem` table for every item in cart
        OrderItemDAOImple orderItemDAO = new OrderItemDAOImple();
        for (CartItem cartItem : cart.getCartItems()) {
            int menuId = cartItem.getMenu().getMenuId();
            int quantity = cartItem.getQuantity();
            double itemTotal = cartItem.getMenu().getPrice() * quantity;

            OrderItem orderItem = new OrderItem(orderId, menuId, quantity, itemTotal);
            orderItemDAO.addOrderItem(orderItem);
        }

        // 3. Fetch restaurant details for order confirmation summary
        RestaurantDAOImple restaurantDAO = new RestaurantDAOImple();
        Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);

        // 4. Clear cart after successful order creation
        session.removeAttribute("cart");

        // 5. Store placed order information for confirmation screen
        session.setAttribute("placedOrder", order);
        session.setAttribute("orderRestaurant", restaurant);
        session.setAttribute("orderAddress", deliveryAddress);
        session.setAttribute("orderPhone", phoneNumber);

        // 6. Redirect to animated order confirmation page
        resp.sendRedirect(req.getContextPath() + "/orderConfirmation.jsp");
    }
}