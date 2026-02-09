/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;

/**
 *
 * @author AN
 */
public class UserDAO extends DBContext {

    public User login(String username, String password) {
        String sql = "SELECT * FROM [User] WHERE username = ? AND [password] = ? AND status = 'active'";

        try {
            connection = getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("userID"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("fullname"),
                        rs.getString("phone"),
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //Check trùng username
    public boolean isUsernameExist(String username) {
        String sql = "SELECT 1 FROM [User] WHERE username = ?";
        try {
            connection = getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //Check trùng phone
    public boolean isPhoneExist(String phone) {
        String sql = "SELECT 1 FROM [User] WHERE phone = ?";
        try {
            connection = getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //Insert user mới
    public void register(User user) {
        String sql = "INSERT INTO [User] (username, [password], role, fullname, phone, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());      // "user"
            ps.setString(4, user.getFullname());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getStatus());    // "active"
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
