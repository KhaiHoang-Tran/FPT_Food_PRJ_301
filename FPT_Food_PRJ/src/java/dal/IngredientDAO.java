/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Ingredient;

/**
 *
 * @author AN
 */
public class IngredientDAO extends DBContext {

    public ArrayList<Ingredient> getAll() {
        ArrayList<Ingredient> list = new ArrayList<>();
        connection = getConnection();
        String sql = "SELECT *\n"
                + "  FROM [FPT_Food_PRJ].[dbo].[Ingredient]";
        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {                
                int id = resultSet.getInt("ingredientID");
                String name = resultSet.getString("name");
                String unit = resultSet.getString("unit");
                Double quantityInStock = resultSet.getDouble("quantityInStock");
                Double minThreshold = resultSet.getDouble("minThreshold");
                Ingredient i = Ingredient.builder()
                        .ingredientID(id)
                        .name(name)
                        .unit(unit)
                        .quantityInStock(quantityInStock)
                        .minThreshold(minThreshold).build();
                list.add(i);
            }
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(IngredientDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

}
