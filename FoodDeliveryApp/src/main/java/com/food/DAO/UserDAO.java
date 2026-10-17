package com.food.DAO;

import java.util.List;
import com.food.model.User;

public interface UserDAO {

    void addUser(User user);

    User getUser(int userId);

    void updateUser(User user);

    void deleteUser(int userId);
    
    User getUserByEmailAndPassword(String email, String password);

    List<User> getAllUsers();
}