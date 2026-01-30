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

      <div id="errorMessage" class="error-msg">
        Tên đăng nhập hoặc mật khẩu không đúng!
      </div>

      <form action="LoginServlet" method="GET">
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

    <script>
      // Đoạn script nhỏ này để xử lý hiển thị lỗi khi Servlet redirect về
      // Ví dụ: Khi đăng nhập sai, Servlet sẽ redirect về: Login.html?status=failed

      window.onload = function () {
        const urlParams = new URLSearchParams(window.location.search);

        // Kiểm tra xem trên URL có tham số 'status=failed' không
        if (urlParams.get("status") === "failed") {
          const errorMsg = document.getElementById("errorMessage");
          errorMsg.style.display = "block";

          // Nếu có thông điệp cụ thể từ server (ví dụ: ?message=Sai pass)
          const msg = urlParams.get("message");
          if (msg) {
            errorMsg.innerText = decodeURIComponent(msg);
          }
        }
      };
    </script>
  </body>
</html>
