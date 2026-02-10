package controller;

import dal.FoodDAO;
import java.io.IOException;
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
        double finalTotal = 0;

        for (Integer foodId : cart.keySet()) {
            Food f = fdao.getById(foodId);
            if (f != null) {
                int qty = cart.get(foodId);
                foodMap.put(foodId, f);
                totalQty += qty;
                finalTotal += f.getPrice() * qty;
            }
        }

        request.setAttribute("cart", cart);
        request.setAttribute("foodMap", foodMap);
        request.setAttribute("totalQty", totalQty);
        request.setAttribute("finalTotal", finalTotal);

        /* ========= FORWARD ========= */
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
