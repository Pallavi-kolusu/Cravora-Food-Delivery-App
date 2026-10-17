package com.food.DAOImple;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.food.DAO.OrderItemDAO;
import com.food.model.OrderItem;
import com.food.utility.DBConnection;

public class OrderItemDAOImple implements OrderItemDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO `orderitem`(orderId,menuId,quantity,totalAmount) "
            + "VALUES (?,?,?,?)";

    private static final String SELECT_ONE_QUERY =
            "SELECT * FROM `orderitem` WHERE orderItemId=?";

    private static final String UPDATE_QUERY =
            "UPDATE `orderitem` SET orderId=?,menuId=?,quantity=?,totalAmount=? "
            + "WHERE orderItemId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM `orderitem` WHERE orderItemId=?";

    private static final String SELECT_ALL_QUERY =
            "SELECT * FROM `orderitem`";
    
    private static final String SELECT_BY_ORDER_QUERY =
            "SELECT * FROM `orderitem` WHERE orderId=?";

    @Override
    public void addOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(INSERT_QUERY)) {

            statement.setInt(1, orderItem.getOrderId());
            statement.setInt(2, orderItem.getMenuId());
            statement.setInt(3, orderItem.getQuantity());
            statement.setDouble(4, orderItem.getTotalAmount());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {

        OrderItem orderItem = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_ONE_QUERY)) {

            statement.setInt(1, orderItemId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                orderItem =
                        extractOrderItemFromResultSet(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderItem;
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(UPDATE_QUERY)) {

            statement.setInt(1, orderItem.getOrderId());
            statement.setInt(2, orderItem.getMenuId());
            statement.setInt(3, orderItem.getQuantity());
            statement.setDouble(4, orderItem.getTotalAmount());
            statement.setInt(5, orderItem.getOrderItemId());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(DELETE_QUERY)) {

            statement.setInt(1, orderItemId);
            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet =
                     statement.executeQuery(SELECT_ALL_QUERY)) {

            while (resultSet.next()) {

                orderItems.add(
                        extractOrderItemFromResultSet(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    private OrderItem extractOrderItemFromResultSet(
            ResultSet resultSet) throws Exception {

        OrderItem orderItem = new OrderItem();

        orderItem.setOrderItemId(
                resultSet.getInt("orderItemId"));

        orderItem.setOrderId(
                resultSet.getInt("orderId"));

        orderItem.setMenuId(
                resultSet.getInt("menuId"));

        orderItem.setQuantity(
                resultSet.getInt("quantity"));

        orderItem.setTotalAmount(
                resultSet.getDouble("totalAmount"));

        return orderItem;
    }
    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        List<OrderItem> orderItems = new ArrayList<>();

        String query = "SELECT * FROM `orderitem` WHERE orderId=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(query)) {

            statement.setInt(1, orderId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                orderItems.add(
                        extractOrderItemFromResultSet(resultSet)
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderItems;
    }
}