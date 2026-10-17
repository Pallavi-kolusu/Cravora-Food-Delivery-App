package com.food.Controller;

import java.io.IOException;

import com.food.DAOImple.UserDAOImple;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/signup")
public class SignupController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
            throws ServletException, IOException {

        // Get signup form values

        String name =
                req.getParameter("name");

        String username =
                req.getParameter("username");

        String email =
                req.getParameter("email");

        String phoneNumber =
                req.getParameter("phoneNumber");

        String address =
                req.getParameter("address");

        String password =
                req.getParameter("password");


        // Create User object

        User user = new User(
                name,
                username,
                password,
                email,
                phoneNumber,
                address,
                "CUSTOMER"
        );


        // Create DAO object

        UserDAOImple userDAO =
                new UserDAOImple();


        // Save user
        // Password will be hashed inside UserDAOImple

        userDAO.addUser(user);


        // Get the newly registered user

        User loggedUser =
                userDAO.getUserByEmailAndPassword(
                        email,
                        password
                );


        // Store user in session

        if (loggedUser != null) {

            req.getSession().setAttribute(
                    "user",
                    loggedUser
            );
        }


        // Redirect to restaurant page

        resp.sendRedirect(
                req.getContextPath()
                + "/restaurant"
        );
    }
}