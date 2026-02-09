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

}
