/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.FoodDAO;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Food;

/**
 *
 * @author AN
 */
public class recipesController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        action = action == null ? "": request.getParameter("action");
        switch (action) {
            case "update":
                updateStatusFood(request, response);
                break;
            default:
                displayMenu(request,response);
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    private void displayMenu(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, ServletException, IOException{
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String activeSection = "recipes";
        String mesg = "";
        FoodDAO  fDAO = new FoodDAO();
        ArrayList<Food> listFood = new ArrayList<>();
        listFood.addAll(fDAO.getAll());
        if(listFood == null){
            mesg += "Không có món nào trong menu";
            request.setAttribute("activeSection", activeSection);
            request.setAttribute("mesg", mesg);
            request.getRequestDispatcher("kitchen.jsp").forward(request, response);
        }else{
            request.setAttribute("listFood", listFood);
            request.setAttribute("activeSection", activeSection);
            request.getRequestDispatcher("kitchen.jsp").forward(request, response);
        }
    }

    private void updateStatusFood(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");       
        int foodID = Integer.parseInt(request.getParameter("foodId"));
        int selectedFoodId = foodID;
        String status = request.getParameter("status");
        FoodDAO fDAO = new FoodDAO();
        int check = fDAO.updateStatus(foodID,status);
        if(check >=0){
            System.out.println("So dong da duoc cap nhat la " + check);
            request.setAttribute("selectedFoodId", selectedFoodId);
            displayMenu(request, response);
        }else{
            System.out.println("Error");
            request.setAttribute("selectedFoodId", selectedFoodId);
            displayMenu(request, response);
        }
    }
}
