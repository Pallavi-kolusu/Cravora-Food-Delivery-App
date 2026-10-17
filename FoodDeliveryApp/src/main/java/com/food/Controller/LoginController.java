package com.food.Controller;

import java.io.IOException;

import com.food.DAOImple.UserDAOImple;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        String email =
                req.getParameter("email");

        String password =
                req.getParameter("password");

        String redirect =
                req.getParameter("redirect");


        // Create DAO object

        UserDAOImple userDAO =
                new UserDAOImple();


        // Check email and password
        // BCrypt verification happens inside UserDAOImple

        User loggedUser =
                userDAO.getUserByEmailAndPassword(
                        email,
                        password
                );


        if (loggedUser != null) {

            // Create session

            HttpSession session =
                    req.getSession();

            session.setAttribute(
                    "user",
                    loggedUser
            );


            // Redirect based on previous page

            if ("cart".equals(redirect)) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/cart"
                );

            } else if ("checkout".equals(redirect)) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/checkout"
                );

            } else if ("orders".equals(redirect)) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/orders"
                );

            } else if ("profile".equals(redirect)) {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/profile"
                );

            } else {

                resp.sendRedirect(
                        req.getContextPath()
                        + "/restaurant"
                );
            }

        } else {

            // Invalid login

            req.setAttribute(
                    "error",
                    "Invalid email or password"
            );

            req.getRequestDispatcher(
                    "login.jsp"
            ).forward(req, resp);
        }
    }
}