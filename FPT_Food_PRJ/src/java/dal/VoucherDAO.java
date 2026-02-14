/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Voucher;

/**
 *
 * @author AN
 */
public class VoucherDAO extends DBContext {

    public Voucher getByCode(String code) {
        String sql = "SELECT * FROM Voucher WHERE code = ?";
        try {
            connection = getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, code);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherID(rs.getInt("VoucherID"));
                v.setCode(rs.getString("code"));
                v.setDiscountPercent(rs.getInt("DiscountPercent"));
                v.setStartDate(rs.getTimestamp("startDate").toLocalDateTime());
                v.setEndDate(rs.getTimestamp("endDate").toLocalDateTime());
                v.setMinOrderValue(rs.getDouble("minOrderValue"));
                v.setStatus(rs.getString("status"));
                return v;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    
}
