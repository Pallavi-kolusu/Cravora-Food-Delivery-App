package com.food.Controller;

import java.io.IOException;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.food.DAOImple.OrderDAOImple;
import com.food.DAOImple.UserDAOImple;
import com.food.model.Order;
import com.food.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session =
                req.getSession();

        User loggedUser =
                (User) session.getAttribute("user");


        // Redirect to login if not authenticated

        if (loggedUser == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp?redirect=profile"
            );

            return;
        }


        // Get latest user details from database

        UserDAOImple userDAO =
                new UserDAOImple();

        User currentUser =
                userDAO.getUser(
                        loggedUser.getUserId()
                );


        if (currentUser != null) {

            loggedUser = currentUser;

            session.setAttribute(
                    "user",
                    currentUser
            );
        }


        // Fetch user's orders

        OrderDAOImple orderDAO =
                new OrderDAOImple();

        List<Order> userOrders =
                orderDAO.getOrdersByUserId(
                        loggedUser.getUserId()
                );


        // Calculate statistics

        int totalOrders =
                (userOrders != null)
                ? userOrders.size()
                : 0;

        double totalSpent = 0.0;


        if (userOrders != null) {

            for (Order o : userOrders) {

                totalSpent +=
                        o.getTotalAmount();
            }
        }


        // Set attributes for profile.jsp

        req.setAttribute(
                "userProfile",
                loggedUser
        );

        req.setAttribute(
                "totalOrders",
                totalOrders
        );

        req.setAttribute(
                "totalSpent",
                totalSpent
        );

        req.setAttribute(
                "recentOrders",
                userOrders
        );


        // Open profile page

        RequestDispatcher rd =
                req.getRequestDispatcher(
                        "profile.jsp"
                );

        rd.forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session =
                req.getSession();

        User loggedUser =
                (User) session.getAttribute("user");


        // Redirect to login if not authenticated

        if (loggedUser == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp?redirect=profile"
            );

            return;
        }


        String action =
                req.getParameter("action");


        UserDAOImple userDAO =
                new UserDAOImple();


        User currentUser =
                userDAO.getUser(
                        loggedUser.getUserId()
                );


        if (currentUser == null) {

            currentUser = loggedUser;
        }


        // UPDATE PROFILE

        if ("updateProfile".equalsIgnoreCase(action)) {

            String name =
                    req.getParameter("name");

            String username =
                    req.getParameter("username");

            String phoneNumber =
                    req.getParameter("phoneNumber");

            String address =
                    req.getParameter("address");


            if (name != null &&
                !name.trim().isEmpty()) {

                currentUser.setName(
                        name.trim()
                );
            }


            if (username != null &&
                !username.trim().isEmpty()) {

                currentUser.setUsername(
                        username.trim()
                );
            }


            if (phoneNumber != null &&
                !phoneNumber.trim().isEmpty()) {

                currentUser.setPhoneNumber(
                        phoneNumber.trim()
                );
            }


            if (address != null &&
                !address.trim().isEmpty()) {

                currentUser.setAddress(
                        address.trim()
                );
            }


            // Update profile

            userDAO.updateUser(
                    currentUser
            );


            // Update session

            session.setAttribute(
                    "user",
                    currentUser
            );


            session.setAttribute(
                    "profileSuccess",
                    "Your profile details have been successfully updated!"
            );
        }


        // CHANGE PASSWORD

        else if ("changePassword"
                .equalsIgnoreCase(action)) {

            String currentPassword =
                    req.getParameter(
                            "currentPassword"
                    );

            String newPassword =
                    req.getParameter(
                            "newPassword"
                    );

            String confirmPassword =
                    req.getParameter(
                            "confirmPassword"
                    );


            // Check current password

            boolean currentPasswordMatches =
                    currentPassword != null
                    && currentUser.getPassword() != null
                    && BCrypt.checkpw(
                            currentPassword,
                            currentUser.getPassword()
                    );


            if (!currentPasswordMatches) {

                session.setAttribute(
                        "profileError",
                        "Current password does not match."
                );
            }


            else if (newPassword == null ||
                     newPassword.trim().isEmpty()) {

                session.setAttribute(
                        "profileError",
                        "New password cannot be empty."
                );
            }


            else if (!newPassword.equals(
                    confirmPassword)) {

                session.setAttribute(
                        "profileError",
                        "New password and confirmation do not match."
                );
            }


            else {

                /*
                 * Set the new plain password.
                 *
                 * UserDAOImple.updateUser()
                 * will automatically hash it
                 * before storing it in MySQL.
                 */

                currentUser.setPassword(
                        newPassword
                );


                // Update database

                userDAO.updateUser(
                        currentUser
                );


                // Update session

                session.setAttribute(
                        "user",
                        currentUser
                );


                session.setAttribute(
                        "profileSuccess",
                        "Your password has been changed successfully!"
                );
            }
        }


        // Return to profile page

        resp.sendRedirect(
                req.getContextPath()
                + "/profile"
        );
    }
}