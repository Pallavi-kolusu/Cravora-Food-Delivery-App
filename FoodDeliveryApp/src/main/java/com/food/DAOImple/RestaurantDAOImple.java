package com.food.DAOImple;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.food.DAO.RestaurantDAO;
import com.food.model.Restaurant;
import com.food.utility.DBConnection;

public class RestaurantDAOImple implements RestaurantDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO restaurant(name,address,phoneNumber,cuisineType,deliveryTime,adminUserId,rating,isActive,imagePath) "
            + "VALUES (?,?,?,?,?,?,?,?,?)";

    private static final String SELECT_ONE_QUERY =
            "SELECT * FROM restaurant WHERE restaurantId=?";

    private static final String UPDATE_QUERY =
            "UPDATE restaurant SET name=?,address=?,phoneNumber=?,cuisineType=?,deliveryTime=?,adminUserId=?,rating=?,isActive=?,imagePath=? "
            + "WHERE restaurantId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM restaurant WHERE restaurantId=?";

    private static final String SELECT_ALL_QUERY =
            "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(INSERT_QUERY)) {

            statement.setString(1, restaurant.getName());
            statement.setString(2, restaurant.getAddress());
            statement.setString(3, restaurant.getPhoneNumber());
            statement.setString(4, restaurant.getCuisineType());
            statement.setString(5, restaurant.getDeliveryTime());
            statement.setInt(6, restaurant.getAdminUserId());
            statement.setDouble(7, restaurant.getRating());
            statement.setBoolean(8, restaurant.isActive());
            statement.setString(9, restaurant.getImagePath());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_ONE_QUERY)) {

            statement.setInt(1, restaurantId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                restaurant = extractRestaurantFromResultSet(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(UPDATE_QUERY)) {

            statement.setString(1, restaurant.getName());
            statement.setString(2, restaurant.getAddress());
            statement.setString(3, restaurant.getPhoneNumber());
            statement.setString(4, restaurant.getCuisineType());
            statement.setString(5, restaurant.getDeliveryTime());
            statement.setInt(6, restaurant.getAdminUserId());
            statement.setDouble(7, restaurant.getRating());
            statement.setBoolean(8, restaurant.isActive());
            statement.setString(9, restaurant.getImagePath());
            statement.setInt(10, restaurant.getRestaurantId());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(DELETE_QUERY)) {

            statement.setInt(1, restaurantId);
            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet =
                     statement.executeQuery(SELECT_ALL_QUERY)) {

            while (resultSet.next()) {
                restaurants.add(
                        extractRestaurantFromResultSet(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    private Restaurant extractRestaurantFromResultSet(
            ResultSet resultSet) throws Exception {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantId(
                resultSet.getInt("restaurantId"));

        restaurant.setName(
                resultSet.getString("name"));

        restaurant.setAddress(
                resultSet.getString("address"));

        restaurant.setPhoneNumber(
                resultSet.getString("phoneNumber"));

        restaurant.setCuisineType(
                resultSet.getString("cuisineType"));

        restaurant.setDeliveryTime(
                resultSet.getString("deliveryTime"));

        restaurant.setAdminUserId(
                resultSet.getInt("adminUserId"));

        restaurant.setRating(
                resultSet.getDouble("rating"));

        restaurant.setActive(
                resultSet.getBoolean("isActive"));

        restaurant.setImagePath(
                resultSet.getString("imagePath"));

        return restaurant;
    }
}