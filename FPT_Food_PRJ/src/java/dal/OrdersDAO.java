/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.OrderItem;
import model.Orders;

/**
 *
 * @author AN
 */
public class OrdersDAO extends DBContext {

    public ArrayList<Orders> getAll() {
        ArrayList<Orders> list = new ArrayList<>();
        connection = getConnection();
        String sql = "SELECT *\n"
                + "  FROM [FPT_Food_PRJ].[dbo].[Orders]";
        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int orderID = resultSet.getInt("orderID");
                int tableID = resultSet.getInt("tableID");
                int voucherID = resultSet.getInt("voucherID");
                String status = resultSet.getString("status");
                Double totalPrice = resultSet.getDouble("totalPrice");
                Double finalPrice = resultSet.getDouble("finalPrice");
                // Bước A: Lấy Timestamp từ SQL (chứa ngày + giờ)
                java.sql.Timestamp timestamp = resultSet.getTimestamp("createdTime");
                // Bước B: Chuyển đổi sang LocalDateTime (nếu không null)
                LocalDateTime createdTime = null;
                if (timestamp != null) {
                    createdTime = timestamp.toLocalDateTime();
                }
                // lay cac item
                ArrayList<OrderItem> listItem = new ArrayList<>();
                OrderItemDAO oiDAO = new OrderItemDAO();
                listItem.addAll(oiDAO.getOrderItemByOrderID(orderID));
                Orders o = Orders.builder()
                        .orderID(orderID)
                        .tableID(tableID)
                        .voucherID(voucherID)
                        .status(status)
                        .totalPrice(totalPrice)
                        .finalPrice(finalPrice)
                        .createdTime(createdTime)
                        .orderItem(listItem).build();
                list.add(o);
            }
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public int updateStatusOrder(int orderID, String curr_status) {
        connection = getConnection();
        String sql = "UPDATE [dbo].[Orders]\n"
                + "   SET \n"
                + "      [status] = ?\n"
                + " WHERE orderID = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, curr_status);
            statement.setInt(2, orderID);
            return statement.executeUpdate();
        } catch (SQLException ex) {
            System.out.println(ex.toString());
        }
        return 0;
    }
}
