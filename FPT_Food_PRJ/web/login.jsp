<%-- 
    Document   : Login
    Created on : Jan 20, 2026, 10:57:37 AM
    Author     : AN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập - FPT Food</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link rel="stylesheet" href="./css/login.css"/>
  </head>
  <body>
    <div class="login-card">
      <div class="logo-circle">
        <i class="fas fa-utensils"></i>
      </div>

      <h2>FPT Food</h2>
      <p class="subtitle">Đăng nhập để đặt món</p>
      
      <form action="MainController?action=login" method="Post">
        <div class="form-group">
          <label>Tên đăng nhập</label>
          <input
            type="text"
            id="username"
            name="username"
            placeholder="Nhập tên đăng nhập"
            required
          />
        </div>

        <div class="form-group">
          <label>Mật khẩu</label>
          <input
            type="password"
            id="password"
            name="password"
            placeholder="Nhập mật khẩu"
            required
          />
        </div>

        <button type="submit" class="btn btn-login">Đăng nhập</button>

        <button
          type="button"
          class="btn btn-register"
          onclick="window.location.href = 'Register.jsp'"
        >
          Đăng ký tài khoản
        </button>
      </form>
    </div>
  </body>
</html>
