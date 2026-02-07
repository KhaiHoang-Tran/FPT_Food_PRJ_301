/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author AN
 */
public class FoodDAO extends DBContext {

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

}
