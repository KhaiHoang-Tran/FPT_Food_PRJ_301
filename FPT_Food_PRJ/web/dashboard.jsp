<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // --- PHẦN 1: GIẢ LẬP DỮ LIỆU (MOCK DATA) ---
    DecimalFormat formatter = new DecimalFormat("#,###"); // Định dạng tiền tệ
    
    // 1. Danh sách Bàn
    List<Map<String, Object>> tableList = new ArrayList<>();
    for (int i = 1; i <= 6; i++) {
        Map<String, Object> t = new HashMap<>();
        t.put("id", i);
        t.put("name", "Bàn " + i);
        if (i == 2) {
            t.put("status", "busy"); t.put("itemCount", 1); t.put("total", 300000);
        } else if (i == 5) {
            t.put("status", "busy"); t.put("itemCount", 3); t.put("total", 150000);
        } else if (i == 3) {
            t.put("status", "booked"); t.put("itemCount", 0); t.put("total", 0);
        } else {
            t.put("status", "empty"); t.put("itemCount", 0); t.put("total", 0);
        }
        tableList.add(t);
    }

    // 2. Danh sách Danh mục
    List<Map<String, Object>> categoryList = new ArrayList<>();
    categoryList.add(new HashMap<String, Object>() {{ put("id", 1); put("name", "Pizza"); put("desc", "Các loại bánh Pizza Ý"); }});
    categoryList.add(new HashMap<String, Object>() {{ put("id", 2); put("name", "Đồ uống"); put("desc", "Nước ngọt, Trà, Cà phê"); }});
    categoryList.add(new HashMap<String, Object>() {{ put("id", 3); put("name", "Món chính"); put("desc", "Cơm, Mì, Beefsteak"); }});

    // 3. Danh sách Món ăn
    List<Map<String, Object>> foodList = new ArrayList<>();
    foodList.add(new HashMap<String, Object>() {{ put("id", 1); put("name", "Pizza Hải Sản"); put("price", 150000); put("cat", "Pizza"); }});
    foodList.add(new HashMap<String, Object>() {{ put("id", 2); put("name", "Burger Bò"); put("price", 80000); put("cat", "Món chính"); }});
    
    // 4. Danh sách Kho
    List<Map<String, Object>> inventoryList = new ArrayList<>();
    inventoryList.add(new HashMap<String, Object>() {{ put("id", 1); put("name", "Bột mì"); put("unit", "kg"); put("qty", 50); }});

    // 5. DANH SÁCH TÀI KHOẢN (MỚI THÊM)
    List<Map<String, Object>> userList = new ArrayList<>();
    userList.add(new HashMap<String, Object>() {{ put("id", 1); put("username", "admin"); put("role", "admin"); }});
    userList.add(new HashMap<String, Object>() {{ put("id", 2); put("username", "nhanvien1"); put("role", "worker"); }});
    userList.add(new HashMap<String, Object>() {{ put("id", 3); put("username", "nhanvien2"); put("role", "worker"); }});
%>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FPT Food - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="./css/dashboard.css"/>
</head>
<body>
    <header>
        <div class="brand">
            <h1>FPT Food - Dashboard</h1>
            <p>Xin chào, Quản lý</p>
        </div>
        <a href="logoutController" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
    </header>

    <div class="container">
        <div class="nav-tabs">
            <button class="tab-btn active" onclick="switchTab('tables', this)"><i class="fas fa-chair"></i> Quản lý bàn</button>
            <button class="tab-btn" onclick="switchTab('categories', this)"><i class="fas fa-tags"></i> Danh mục</button>
            <button class="tab-btn" onclick="switchTab('food', this)"><i class="fas fa-utensils"></i> Món ăn</button>
            <button class="tab-btn" onclick="switchTab('inventory', this)"><i class="fas fa-boxes"></i> Quản lý kho</button>
            <button class="tab-btn" onclick="switchTab('accounts', this)"><i class="fas fa-users"></i> Tài khoản</button> <button class="tab-btn" onclick="switchTab('bills', this)"><i class="fas fa-file-invoice-dollar"></i> Hóa đơn</button>
        </div>

        <section id="tables" class="section-content active">
            <div class="table-grid">
                <% for (Map<String, Object> t : tableList) { 
                    String status = (String) t.get("status");
                    String statusText = status.equals("empty") ? "Trống" : (status.equals("busy") ? "Đang dùng" : "Đã đặt");
                    int itemCount = (int) t.get("itemCount");
                    int total = (int) t.get("total");
                    String formattedTotal = formatter.format(total);
                %>
                <div class="table-card">
                    <div class="table-header">
                        <b><%= t.get("name") %></b>
                        <span class="badge <%= status %>"><%= statusText %></span>
                    </div>
                    <form action="UpdateTableServlet" method="POST">
                        <input type="hidden" name="tableId" value="<%= t.get("id") %>">
                        <div class="status-control">
                            <select name="status" class="status-select">
                                <option value="empty" <%= status.equals("empty") ? "selected" : "" %>>Trống</option>
                                <option value="busy" <%= status.equals("busy") ? "selected" : "" %>>Đang dùng</option>
                                <option value="booked" <%= status.equals("booked") ? "selected" : "" %>>Đã đặt</option>
                            </select>
                            <button type="submit" class="btn-save" title="Lưu lại"><i class="fas fa-save"></i></button>
                        </div>
                    </form>
                    <% if (status.equals("busy")) { %>
                    <div class="order-summary">
                        Đang phục vụ: <%= itemCount %> món
                        <span class="total-price">Tổng: <%= formattedTotal %>đ</span>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </section>

        <section id="categories" class="section-content">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <h3>Danh mục món ăn</h3>
                <button class="btn-add" onclick="openAddCategoryModal()">+ Thêm danh mục</button>
            </div>
            <table class="data-table">
                <thead><tr><th>ID</th><th>Tên danh mục</th><th>Mô tả</th><th>Thao tác</th></tr></thead>
                <tbody>
                    <% for (Map<String, Object> c : categoryList) { %>
                    <tr>
                        <td><%= c.get("id") %></td><td><b><%= c.get("name") %></b></td><td><%= c.get("desc") %></td>
                        <td>
                            <button class="action-btn" style="color:blue" onclick="openEditCategoryModal('<%= c.get("id") %>', '<%= c.get("name") %>', '<%= c.get("desc") %>')"><i class="fas fa-edit"></i></button>
                            <form action="DeleteCategoryServlet" method="POST" style="display:inline;" onsubmit="return confirm('Xóa?')"><input type="hidden" name="id" value="<%= c.get("id") %>"><button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button></form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

        <section id="food" class="section-content">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <h3>Danh sách món ăn</h3>
                <button class="btn-add" onclick="openAddFoodModal()">+ Thêm món</button>
            </div>
            <table class="data-table">
                <thead><tr><th>Tên món</th><th>Danh mục</th><th>Giá</th><th>Thao tác</th></tr></thead>
                <tbody>
                    <% for (Map<String, Object> f : foodList) { %>
                    <tr>
                        <td><%= f.get("name") %></td><td><%= f.get("cat") %></td><td><%= f.get("price") %>đ</td>
                        <td>
                            <button class="action-btn" style="color:blue" onclick="openEditFoodModal('<%= f.get("id") %>', '<%= f.get("name") %>', '<%= f.get("price") %>')"><i class="fas fa-edit"></i></button>
                            <form action="DeleteFoodServlet" method="POST" style="display:inline;" onsubmit="return confirm('Xóa?')"><input type="hidden" name="id" value="<%= f.get("id") %>"><button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button></form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

        <section id="inventory" class="section-content">
            <div style="display:flex; justify-content:space-between;">
                <h3>Kho nguyên liệu</h3>
                <button class="btn-add" style="background:#28a745" onclick="document.getElementById('inventoryModal').classList.add('active')">+ Nhập kho</button>
            </div>
            <table class="data-table">
                <thead><tr><th>Tên</th><th>Đơn vị</th><th>Số lượng</th><th>Thao tác</th></tr></thead>
                <tbody>
                    <% for (Map<String, Object> i : inventoryList) { %>
                    <tr>
                        <td><%= i.get("name") %></td><td><%= i.get("unit") %></td><td><%= i.get("qty") %></td>
                        <td>
                            <form action="DeleteStockServlet" method="POST" style="display:inline;" onsubmit="return confirm('Xóa?')"><input type="hidden" name="id" value="<%= i.get("id") %>"><button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button></form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </section>
        
        <section id="accounts" class="section-content">
            <div style="display:flex; justify-content:space-between;">
                <h3>Danh sách tài khoản</h3>
                <button class="btn-add" onclick="openAddAccountModal()">+ Tạo tài khoản</button>
            </div>
            <table class="data-table">
                <thead>
                    <tr><th>ID</th><th>Tên đăng nhập</th><th>Vai trò (Role)</th><th>Thao tác</th></tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> u : userList) { 
                        String role = (String) u.get("role");
                        String roleBadge = role.equals("admin") ? "role-admin" : "role-worker";
                    %>
                    <tr>
                        <td><%= u.get("id") %></td>
                        <td><b><%= u.get("username") %></b></td>
                        <td><span class="badge <%= roleBadge %>"><%= role.toUpperCase() %></span></td>
                        <td>
                            <form action="DeleteAccountServlet" method="POST" style="display:inline;" onsubmit="return confirm('Xóa tài khoản này?')">
                                <input type="hidden" name="id" value="<%= u.get("id") %>">
                                <button type="submit" class="action-btn" style="color:red"><i class="fas fa-trash"></i></button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </section>

        <section id="bills" class="section-content">
            <h3>Hóa đơn cần thanh toán</h3>
            <div class="table-grid">
                <% for (Map<String, Object> t : tableList) {
                        if (t.get("status").equals("busy")) { %>
                <div class="table-card" style="border-left: 5px solid var(--danger);">
                    <div style="display:flex; justify-content:space-between; margin-bottom:10px;"><b><%= t.get("name") %></b><span class="badge busy">Chưa thanh toán</span></div>
                    <p>Tổng tiền tạm tính: <b><%= formatter.format(t.get("total")) %>đ</b></p>
                    <form action="PayBillServlet" method="POST" style="margin-top:15px;">
                        <input type="hidden" name="tableId" value="<%= t.get("id") %>">
                        <button type="submit" class="btn-add" style="width:100%; background:#28a745;">Xác nhận Thanh toán</button>
                    </form>
                </div>
                <% } } %>
            </div>
        </section>
    </div>

    <div class="modal" id="accountModal">
        <div class="modal-content">
            <h3>Tạo tài khoản mới</h3>
            <form action="SaveAccountServlet" method="POST">
                <label>Tên đăng nhập:</label>
                <input type="text" name="username" id="accUsername" class="form-control" required>
                
                <label>Mật khẩu:</label>
                <input type="password" name="password" id="accPassword" class="form-control" required>
                
                <label>Vai trò:</label>
                <select name="role" id="accRole" class="form-control">
                    <option value="worker">Worker (Nhân viên)</option>
                    <option value="admin">Admin (Quản lý)</option>
                </select>
                
                <div class="modal-footer">
                    <button type="button" class="action-btn" onclick="document.getElementById('accountModal').classList.remove('active')">Hủy</button>
                    <button type="submit" class="btn-add">Tạo mới</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal" id="categoryModal">
        <div class="modal-content">
            <h3>Thông tin danh mục</h3>
            <form action="SaveCategoryServlet" method="POST">
                <input type="hidden" name="id" id="modalCatId">
                <label>Tên danh mục:</label><input type="text" name="name" id="modalCatName" class="form-control" required>
                <label>Mô tả:</label><input type="text" name="desc" id="modalCatDesc" class="form-control">
                <div class="modal-footer"><button type="button" class="action-btn" onclick="document.getElementById('categoryModal').classList.remove('active')">Hủy</button><button type="submit" class="btn-add">Lưu lại</button></div>
            </form>
        </div>
    </div>

    <div class="modal" id="foodModal">
        <div class="modal-content">
            <h3>Thông tin món ăn</h3>
            <form action="SaveFoodServlet" method="POST">
                <input type="hidden" name="id" id="modalFoodId">
                <label>Tên món:</label><input type="text" name="name" id="modalFoodName" class="form-control" required>
                <label>Giá bán:</label><input type="number" name="price" id="modalFoodPrice" class="form-control" required>
                <div class="modal-footer"><button type="button" class="action-btn" onclick="document.getElementById('foodModal').classList.remove('active')">Hủy</button><button type="submit" class="btn-add">Lưu lại</button></div>
            </form>
        </div>
    </div>
    
    <div class="modal" id="inventoryModal">
        <div class="modal-content">
            <h3>Nhập kho mới</h3>
            <form action="SaveInventoryServlet" method="POST">
                <label>Tên nguyên liệu:</label><input type="text" name="name" class="form-control" required>
                <label>Số lượng:</label><input type="number" name="qty" class="form-control" required>
                <div class="modal-footer"><button type="button" class="action-btn" onclick="document.getElementById('inventoryModal').classList.remove('active')">Hủy</button><button type="submit" class="btn-add">Lưu</button></div>
            </form>
        </div>
    </div>

    <script>
        function switchTab(tabId, btn) {
            document.querySelectorAll(".section-content").forEach(el => el.classList.remove("active"));
            document.querySelectorAll(".tab-btn").forEach(el => el.classList.remove("active"));
            document.getElementById(tabId).classList.add("active");
            btn.classList.add("active");
        }

        // JS cho Tài khoản
        function openAddAccountModal() {
            document.getElementById('accUsername').value = "";
            document.getElementById('accPassword').value = "";
            document.getElementById('accRole').value = "worker"; // Default
            document.getElementById('accountModal').classList.add('active');
        }

        // Các hàm cũ giữ nguyên
        function openAddCategoryModal() { document.getElementById('modalCatId').value=""; document.getElementById('modalCatName').value=""; document.getElementById('modalCatDesc').value=""; document.getElementById('categoryModal').classList.add('active'); }
        function openEditCategoryModal(id,name,desc) { document.getElementById('modalCatId').value=id; document.getElementById('modalCatName').value=name; document.getElementById('modalCatDesc').value=desc; document.getElementById('categoryModal').classList.add('active'); }
        function openAddFoodModal() { document.getElementById('modalFoodId').value=""; document.getElementById('modalFoodName').value=""; document.getElementById('modalFoodPrice').value=""; document.getElementById('foodModal').classList.add('active'); }
        function openEditFoodModal(id,name,price) { document.getElementById('modalFoodId').value=id; document.getElementById('modalFoodName').value=name; document.getElementById('modalFoodPrice').value=price; document.getElementById('foodModal').classList.add('active'); }
    </script>
</body>
</html>