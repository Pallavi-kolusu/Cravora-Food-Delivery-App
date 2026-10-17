package com.food.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.lang.ClassNotFoundException;

public class DBConnection {
	private static final String URL = "jdbc:mysql://localhost:3306/fooddeliverydb";
	private static final String USERNAME = "";
	private static final String PASSWORD = "";
	private static Connection connection = null;

	public static Connection getConnection()
	{
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		
			connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
	
			} catch (ClassNotFoundException e) {
				
				e.printStackTrace();
			}
			catch (SQLException e) {
			
			e.printStackTrace();
			}
		return connection;
	}

}
