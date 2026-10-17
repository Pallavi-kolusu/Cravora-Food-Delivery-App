package com.food.DAOImple;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.food.DAO.MenuDAO;
import com.food.model.Menu;
import com.food.utility.DBConnection;

public class MenuDAOImple implements MenuDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO menu(restaurantId,itemName,description,price,isAvailable,ratings,imagePath) "
            + "VALUES (?,?,?,?,?,?,?)";

    private static final String SELECT_ONE_QUERY =
            "SELECT * FROM menu WHERE menuId=?";

    private static final String UPDATE_QUERY =
            "UPDATE menu SET restaurantId=?,itemName=?,description=?,price=?,isAvailable=?,ratings=?,imagePath=? "
            + "WHERE menuId=?";

    private static final String DELETE_QUERY =
            "DELETE FROM menu WHERE menuId=?";

    private static final String SELECT_ALL_QUERY =
            "SELECT * FROM menu";
    private static final String SELECT_BY_RESTAURANT_QUERY =
            "SELECT * FROM menu WHERE restaurantId=?";

    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(INSERT_QUERY)) {

            statement.setInt(1, menu.getRestaurantId());
            statement.setString(2, menu.getItemName());
            statement.setString(3, menu.getDescription());
            statement.setDouble(4, menu.getPrice());
            statement.setBoolean(5, menu.isAvailable());
            statement.setDouble(6, menu.getRatings());
            statement.setString(7, menu.getImagePath());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_ONE_QUERY)) {

            statement.setInt(1, menuId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                menu = extractMenuFromResultSet(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(UPDATE_QUERY)) {

            statement.setInt(1, menu.getRestaurantId());
            statement.setString(2, menu.getItemName());
            statement.setString(3, menu.getDescription());
            statement.setDouble(4, menu.getPrice());
            statement.setBoolean(5, menu.isAvailable());
            statement.setDouble(6, menu.getRatings());
            statement.setString(7, menu.getImagePath());
            statement.setInt(8, menu.getMenuId());

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(DELETE_QUERY)) {

            statement.setInt(1, menuId);
            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet =
                     statement.executeQuery(SELECT_ALL_QUERY)) {

            while (resultSet.next()) {
                menus.add(extractMenuFromResultSet(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return menus;
    }

    private Menu extractMenuFromResultSet(ResultSet resultSet)
            throws Exception {

        Menu menu = new Menu();

        menu.setMenuId(resultSet.getInt("menuId"));
        menu.setRestaurantId(resultSet.getInt("restaurantId"));
        menu.setItemName(resultSet.getString("itemName"));
        menu.setDescription(resultSet.getString("description"));
        menu.setPrice(resultSet.getDouble("price"));
        menu.setAvailable(resultSet.getBoolean("isAvailable"));
        menu.setRatings(resultSet.getDouble("ratings"));
        menu.setImagePath(resultSet.getString("imagePath"));

        return menu;
    }
    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        String query = "SELECT * FROM menu WHERE restaurantId=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(query)) {

            statement.setInt(1, restaurantId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                menus.add(extractMenuFromResultSet(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return menus;
    }
}