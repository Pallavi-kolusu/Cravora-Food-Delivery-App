package com.food.DAOImple;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.food.DAO.OrderDAO;
import com.food.model.Order;
import com.food.utility.DBConnection;

public class OrderDAOImple implements OrderDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO `orders`(restaurantId,userId,orderDate,totalAmount,status,paymentMode) "
            + "VALUES (?,?,?,?,?,?)";

    private static final String SELECT_ONE_QUERY =
            "SELECT * FROM `orders` WHERE orderId=?";

    private static final String UPDATE_QUERY =
            "UPDATE `orders` SET restaurantId=?,userId=?,orderDate=?,totalAmount=?,status=?,paymentMode=? "
            + "WHERE orderId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM `orders` WHERE orderId=?";

    private static final String SELECT_ALL_QUERY =
            "SELECT * FROM `orders`";
    
    private static final String SELECT_BY_USER_QUERY =
            "SELECT * FROM `orders` WHERE userId=?";

    @Override
    public int addOrder(Order order) {
        int generatedOrderId = 0;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, order.getRestaurantId());
            statement.setInt(2, order.getUserId());
            statement.setTimestamp(3, order.getOrderDate());
            statement.setDouble(4, order.getTotalAmount());
            statement.setString(5, order.getStatus());
            statement.setString(6, order.getPaymentMode());

            int affectedRows = statement.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedOrderId = generatedKeys.getInt(1);
                        order.setOrderId(generatedOrderId);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return generatedOrderId;
    }

    @Override
    public Order getOrder(int orderId) {

        Order order = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_ONE_QUERY)) {

            statement.setInt(1, orderId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                order = extractOrderFromResultSet(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public void updateOrder(Order order) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(UPDATE_QUERY)) {

            statement.setInt(1, order.getRestaurantId());
            statement.setInt(2, order.getUserId());
            statement.setTimestamp(3, order.getOrderDate());
            statement.setDouble(4, order.getTotalAmount());
            statement.setString(5, order.getStatus());
            statement.setString(6, order.getPaymentMode());
            statement.setInt(7, order.getOrderId());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(DELETE_QUERY)) {

            statement.setInt(1, orderId);
            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Order> getAllOrders() {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet =
                     statement.executeQuery(SELECT_ALL_QUERY)) {

            while (resultSet.next()) {
                orders.add(extractOrderFromResultSet(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    private Order extractOrderFromResultSet(ResultSet resultSet)
            throws Exception {

        Order order = new Order();

        order.setOrderId(resultSet.getInt("orderId"));
        order.setRestaurantId(resultSet.getInt("restaurantId"));
        order.setUserId(resultSet.getInt("userId"));
        order.setOrderDate(resultSet.getTimestamp("orderDate"));
        order.setTotalAmount(resultSet.getDouble("totalAmount"));
        order.setStatus(resultSet.getString("status"));
        order.setPaymentMode(resultSet.getString("paymentMode"));

        return order;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_BY_USER_QUERY)) {

            statement.setInt(1, userId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                orders.add(
                        extractOrderFromResultSet(resultSet)
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }
}