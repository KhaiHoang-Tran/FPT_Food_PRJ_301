/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Food;

/**
 *
 * @author AN
 */
public class FoodDAO extends DBContext {

    public List<Food> getAllAvailable() {
        List<Food> list = new ArrayList<Food>();
        String sql =
            "SELECT f.foodID, f.name, f.price, f.categoryID, f.status, " +
            "c.name AS categoryName " +
            "FROM Food f " +
            "LEFT JOIN Category c ON f.categoryID = c.categoryID " +
            "WHERE f.status = 'available'";

        try {
            connection = getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Food f = new Food();
                f.setFoodID(rs.getInt("foodID"));
                f.setName(rs.getString("name"));
                f.setPrice(rs.getDouble("price"));
                f.setCategoryID(rs.getInt("categoryID"));
                f.setStatus(rs.getString("status"));
                f.setCategoryName(rs.getString("categoryName"));
                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Food> getByCategoryName(String cat) {
        List<Food> list = new ArrayList<Food>();
        String sql =
            "SELECT f.foodID, f.name, f.price, f.categoryID, f.status, " +
            "c.name AS categoryName " +
            "FROM Food f " +
            "LEFT JOIN Category c ON f.categoryID = c.categoryID " +
            "WHERE c.name = ? AND f.status = 'available'";

        try {
            connection = getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, cat);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Food f = new Food();
                f.setFoodID(rs.getInt("foodID"));
                f.setName(rs.getString("name"));
                f.setPrice(rs.getDouble("price"));
                f.setCategoryID(rs.getInt("categoryID"));
                f.setStatus(rs.getString("status"));
                f.setCategoryName(rs.getString("categoryName"));
                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Food getById(int id) {
    String sql =
        "SELECT f.foodID, f.name, f.price, f.categoryID, f.status, " +
        "c.name AS categoryName " +
        "FROM Food f " +
        "LEFT JOIN Category c ON f.categoryID = c.categoryID " +
        "WHERE f.foodID = ?";

    try {
        connection = getConnection();
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Food f = new Food();
            f.setFoodID(rs.getInt("foodID"));
            f.setName(rs.getString("name"));
            f.setPrice(rs.getDouble("price"));
            f.setCategoryID(rs.getInt("categoryID"));
            f.setStatus(rs.getString("status"));
            f.setCategoryName(rs.getString("categoryName"));
            return f;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    public String getFoodNameByFoodID(int foodID) {
        connection = getConnection();
        String sql = "SELECT [name]\n"
                + "  FROM [dbo].[Food]\n"
                + "  Where foodID = ?";
        String name = "";
        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, foodID);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                name = resultSet.getString("name");
            }
        } catch (SQLException ex) {
            System.out.println(ex.toString());
        }
        return name;
    }

    public ArrayList<Food> getAll() {
        ArrayList<Food> listFood = new ArrayList<>();
        connection = getConnection();
        String sql = "SELECT *\n"
                + "  FROM [dbo].[Food]";
        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int foodID = resultSet.getInt("foodID");
                String name = resultSet.getString("name");
                Double price = resultSet.getDouble("price");
                int categoryID = resultSet.getInt("categoryID");
                String status = resultSet.getString("status");
                Food f = Food.builder()
                        .foodID(foodID)
                        .name(name)
                        .price(price)
                        .categoryID(categoryID)
                        .status(status).build();
                listFood.add(f);
            }
        } catch (SQLException ex) {
            System.out.println(ex.toString());
        }
        return listFood;
    }

    public int updateStatus(int foodID, String status) {
        status = switchStatus(status);
        int resultSet = 0;
        connection = getConnection();
        String sql = "UPDATE [dbo].[Food]\n"
                + "   SET \n"
                + "      [status] = ?\n"
                + "	  WHERE foodID = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, foodID);
            resultSet = statement.executeUpdate();
        } catch (SQLException ex) {
            System.out.println(ex.toString());
        }
        return resultSet;
    }

    private String switchStatus(String status) {
        switch (status) {
            case "available":
                status = "unavailable";
                break;
            case "unavailable":
                status = "available";
                break;
        }
        return status;
    }

}
