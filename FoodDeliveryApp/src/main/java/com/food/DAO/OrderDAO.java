package com.food.DAO;

import java.util.List;

import com.food.model.Order;

public interface OrderDAO {

	int addOrder(Order order);

	Order getOrder(int orderID);

	void updateOrder(Order order);

	void deleteOrder(int orderID);

	List<Order> getAllOrders();
	
    List<Order> getOrdersByUserId(int userId);

}