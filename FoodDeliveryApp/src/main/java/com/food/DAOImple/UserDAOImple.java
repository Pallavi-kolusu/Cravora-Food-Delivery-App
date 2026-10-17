package com.food.DAOImple;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.food.DAO.UserDAO;
import com.food.model.User;
import com.food.utility.DBConnection;

public class UserDAOImple implements UserDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO users(name,username,password,email,phoneNumber,address,role,createDate,lastLoginDate) "
            + "VALUES (?,?,?,?,?,?,?,?,?)";

    private static final String SELECT_ONE_QUERY =
            "SELECT * FROM users WHERE userId=?";

    private static final String SELECT_BY_EMAIL_QUERY =
            "SELECT * FROM users WHERE email=?";

    private static final String UPDATE_QUERY =
            "UPDATE users SET name=?,username=?,password=?,email=?,phoneNumber=?,address=?,role=?,createDate=?,lastLoginDate=? "
            + "WHERE userId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM users WHERE userId=?";

    private static final String SELECT_ALL_QUERY =
            "SELECT * FROM users";


    @Override
    public void addUser(User user) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(INSERT_QUERY)) {

            statement.setString(1, user.getName());
            statement.setString(2, user.getUsername());

            // Hash password before storing in database
            String hashedPassword =
                    BCrypt.hashpw(
                            user.getPassword(),
                            BCrypt.gensalt()
                    );

            statement.setString(3, hashedPassword);

            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhoneNumber());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getRole());

            statement.setTimestamp(
                    8,
                    new Timestamp(System.currentTimeMillis())
            );

            statement.setTimestamp(
                    9,
                    user.getLastLoginDate()
            );

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public User getUser(int userId) {

        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_ONE_QUERY)) {

            statement.setInt(1, userId);

            ResultSet resultSet =
                    statement.executeQuery();

            if (resultSet.next()) {

                user =
                        extractUserFromResultSet(
                                resultSet
                        );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }


    @Override
    public User getUserByEmailAndPassword(
            String email,
            String password) {

        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             SELECT_BY_EMAIL_QUERY)) {

            // Search user only by email
            statement.setString(1, email);

            ResultSet resultSet =
                    statement.executeQuery();

            if (resultSet.next()) {

                user =
                        extractUserFromResultSet(
                                resultSet
                        );

                // Verify entered password with stored hash
                boolean passwordMatches =
                        BCrypt.checkpw(
                                password,
                                user.getPassword()
                        );

                if (!passwordMatches) {

                    user = null;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }


    @Override
    public void updateUser(User user) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(UPDATE_QUERY)) {

            statement.setString(1, user.getName());
            statement.setString(2, user.getUsername());

            /*
             * Password handling:
             * If the password is already a BCrypt hash,
             * keep it as it is.
             *
             * Otherwise hash the password before updating.
             */

            String password =
                    user.getPassword();

            if (password != null &&
                !password.startsWith("$2a$") &&
                !password.startsWith("$2b$") &&
                !password.startsWith("$2y$")) {

                password =
                        BCrypt.hashpw(
                                password,
                                BCrypt.gensalt()
                        );
            }

            statement.setString(3, password);

            statement.setString(4, user.getEmail());
            statement.setString(5, user.getPhoneNumber());
            statement.setString(6, user.getAddress());
            statement.setString(7, user.getRole());
            statement.setTimestamp(8, user.getCreateDate());
            statement.setTimestamp(9, user.getLastLoginDate());
            statement.setInt(10, user.getUserId());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteUser(int userId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(DELETE_QUERY)) {

            statement.setInt(1, userId);

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public List<User> getAllUsers() {

        List<User> users =
                new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement =
                     connection.createStatement();
             ResultSet resultSet =
                     statement.executeQuery(
                             SELECT_ALL_QUERY
                     )) {

            while (resultSet.next()) {

                users.add(
                        extractUserFromResultSet(
                                resultSet
                        )
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }


    private User extractUserFromResultSet(
            ResultSet resultSet)
            throws Exception {

        User user =
                new User();

        user.setUserId(
                resultSet.getInt("userId")
        );

        user.setName(
                resultSet.getString("name")
        );

        user.setUsername(
                resultSet.getString("username")
        );

        user.setPassword(
                resultSet.getString("password")
        );

        user.setEmail(
                resultSet.getString("email")
        );

        user.setPhoneNumber(
                resultSet.getString("phoneNumber")
        );

        user.setAddress(
                resultSet.getString("address")
        );

        user.setRole(
                resultSet.getString("role")
        );

        user.setCreateDate(
                resultSet.getTimestamp("createDate")
        );

        user.setLastLoginDate(
                resultSet.getTimestamp("lastLoginDate")
        );

        return user;
    }
}