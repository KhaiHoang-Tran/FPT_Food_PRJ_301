package controller;

import dal.FoodDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Food;
import model.Voucher;

@WebServlet(name = "homeController", urlPatterns = {"/homeController"})
public class homeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        FoodDAO fdao = new FoodDAO();

        /* ========= CATEGORY FILTER ========= */
        String cat = request.getParameter("cat");
        List<Food> foods;

        if (cat == null || cat.trim().isEmpty()) {
            foods = fdao.getAllAvailable();
        } else {
            foods = fdao.getByCategoryName(cat);
        }

        request.setAttribute("foods", foods);

        /* ========= CART ========= */
        HttpSession session = request.getSession();
        Map<Integer, Integer> cart
                = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        Map<Integer, Food> foodMap = new HashMap<>();
        int totalQty = 0;
        double total = 0;

        for (Integer foodId : cart.keySet()) {
            Food f = fdao.getById(foodId);
            if (f != null) {
                int qty = cart.get(foodId);
                foodMap.put(foodId, f);
                totalQty += qty;
                total += f.getPrice() * qty;
            }
        }

        request.setAttribute("cart", cart);
        request.setAttribute("foodMap", foodMap);

        /* ========= VOUCHER ========= */
        Voucher v = (Voucher) session.getAttribute("voucher");
        double discount = 0;
        double finalTotal = total;

        if (v != null) {
            LocalDateTime now = LocalDateTime.now();

            boolean validTime = now.isAfter(v.getStartDate()) && now.isBefore(v.getEndDate());
            boolean validStatus
                    = v.getStatus().equals("active");

            boolean validMinOrder
                    = total >= v.getMinOrderValue();

            if (validTime && validStatus && validMinOrder) {

                discount = total * v.getDiscountPercent() / 100;
                finalTotal = total - discount;

            } else {
                session.removeAttribute("voucher");
                session.setAttribute("voucherError", "Voucher không hợp lệ");
            }
        }

        request.setAttribute("totalQty", totalQty);
        request.setAttribute("finalTotal", finalTotal);
        request.setAttribute("discount", discount);
        request.setAttribute("total", total);
        /* ========= FORWARD ========= */
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
