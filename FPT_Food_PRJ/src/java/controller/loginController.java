/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author AN
 */
public class loginController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String url = "";
        HttpSession session = request.getSession();

        // ===== CHƯA LOGIN =====
        if (session.getAttribute("user") == null) {

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            UserDAO udao = new UserDAO();
            User user = udao.login(username, password);

            if (user != null) {     
                    // lưu session
                    session.setAttribute("user", user);

                    // điều hướng theo role
                    switch (user.getRole()) {
                        case "manager":
                            response.sendRedirect("dashboard.jsp");
                            return;
                        case "worker":
                            response.sendRedirect("kitchen.jsp");
                            return;
                        default:
                            response.sendRedirect("home.jsp");
                            return;
                    }

            } else {
                request.setAttribute("message", "Invalid username or password!");
                url = "login.jsp";
            }

        } // ===== ĐÃ LOGIN =====
        else {
            //lấy session
            User user = (User) session.getAttribute("user");

            switch (user.getRole()) {
                case "manager":
                    response.sendRedirect("dashboard.jsp");
                    return;
                case "worker":
                    response.sendRedirect("kitchen.jsp");
                    return;
                default:
                    response.sendRedirect("home.jsp");
                    return;
            }
        }

        RequestDispatcher rd = request.getRequestDispatcher(url);
        rd.forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
