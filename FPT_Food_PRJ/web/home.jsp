<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.text.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%!
    // Food(foodID, name, price, categoryID, status)
    public static class Food {

        public int foodID;
        public String name;
        public double price;
        public Integer categoryID;   // NULL allowed
        public String status;        // available/unavailable

        // Field phụ để hiển thị UI (do DB cần JOIN Category)
        public String categoryName;

        public Food(int foodID, String name, double price, Integer categoryID, String status, String categoryName) {
            this.foodID = foodID;
            this.name = name;
            this.price = price;
            this.categoryID = categoryID;
            this.status = status;
            this.categoryName = categoryName;
        }
    }

    // Review(reviewID, userID, foodID, rating, comment, reviewDate)
    public static class Review {

        public int reviewID;
        public int userID;
        public int foodID;
        public int rating;
        public String comment;
        public String reviewDate;

        // Field phụ để hiển thị UI (do DB cần JOIN User)
        public String username;

        public Review(int reviewID, int userID, int foodID, int rating, String comment, String reviewDate, String username) {
            this.reviewID = reviewID;
            this.userID = userID;
            this.foodID = foodID;
            this.rating = rating;
            this.comment = comment;
            this.reviewDate = reviewDate;
            this.username = username;
        }
    }

    // Orders(orderID, tableID, voucherID, status, totalPrice, finalPrice, createdTime)
    public static class OrderHistory {

        public int orderID;
        public int tableID;
        public Integer voucherID;
        public String status;          // pending/cooking/done/paid
        public double totalPrice;
        public double finalPrice;
        public String createdTime;     // demo string

        // Field phụ để hiển thị UI (do DB cần JOIN DiningTable)
        public String tableName;

        // Field phụ để hiển thị UI (do DB cần JOIN OrderItem + Food)
        public List<String> items = new ArrayList<>();

        public OrderHistory(int orderID, int tableID, String tableName, Integer voucherID,
                String status, double totalPrice, double finalPrice, String createdTime) {
            this.orderID = orderID;
            this.tableID = tableID;
            this.tableName = tableName;
            this.voucherID = voucherID;
            this.status = status;
            this.totalPrice = totalPrice;
            this.finalPrice = finalPrice;
            this.createdTime = createdTime;
        }
    }
%>

<%
    // ===== DATA (Mock nếu chưa có Servlet/DAO) =====
    // Khi có DB: setAttribute từ Servlet/DAO, bỏ phần mock bên dưới.
    List<Food> foods = (List<Food>) request.getAttribute("foods");
    if (foods == null) {
        foods = new ArrayList<>();
        foods.add(new Food(1, "Pizza Hải Sản", 150000, 1, "available", "Pizza"));
        foods.add(new Food(2, "Pepsi Tươi", 20000, 2, "available", "Đồ uống"));
        foods.add(new Food(3, "Burger Bò", 80000, 3, "available", "Món chính"));
        foods.add(new Food(4, "Trà Đào", 25000, 2, "available", "Đồ uống"));
        request.setAttribute("foods", foods);
    }

    List<OrderHistory> history = (List<OrderHistory>) request.getAttribute("orderHistory");
    if (history == null) {
        history = new ArrayList<>();

        OrderHistory h1 = new OrderHistory(101, 1, "Bàn 01", null, "paid", 170000, 170000, "27/01/2025 12:30");
        h1.items.add("Pizza Hải Sản (x1)");
        h1.items.add("Pepsi Tươi (x1)");
        history.add(h1);

        OrderHistory h2 = new OrderHistory(102, 5, "Bàn 05", null, "cooking", 80000, 80000, "27/01/2025 18:45");
        h2.items.add("Burger Bò (x1)");
        history.add(h2);

        request.setAttribute("orderHistory", history);
    }

    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    if (reviews == null) {
        reviews = new ArrayList<>();
        reviews.add(new Review(1, 1, 1, 5, "Pizza rất ngon, nhiều phô mai!", "27/01/2025", "NguyenVanA"));
        reviews.add(new Review(2, 2, 1, 4, "Hơi đợi lâu xíu nhưng ngon.", "27/01/2025", "TranThiB"));
        reviews.add(new Review(3, 1, 3, 5, "Burger to, ăn bao no.", "27/01/2025", "LeVanC"));
        request.setAttribute("reviews", reviews);
    }

    // ===== STATE (view/menu/history, filter) =====
    String view = request.getParameter("view");
    if (view == null) {
        view = "menu";
    }

    String cat = request.getParameter("cat");
    if (cat == null) {
        cat = "all";
    }

    String q = request.getParameter("q");
    if (q == null) {
        q = "";
    }
    q = q.trim();

    // food modal (open by GET param foodId)
    String foodIdStr = request.getParameter("foodId");
    int openFoodId = (foodIdStr != null && foodIdStr.matches("\\d+")) ? Integer.parseInt(foodIdStr) : -1;

    // ===== CART in session (foodID -> qty) =====
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new LinkedHashMap<>();
        session.setAttribute("cart", cart);
    }

    Integer discountPercent = (Integer) session.getAttribute("discountPercent");
    if (discountPercent == null) {
        discountPercent = 0;
    }

    // Map foodID -> Food
    Map<Integer, Food> foodMap = new HashMap<>();
    for (Food f : foods) {
        foodMap.put(f.foodID, f);
    }

    int totalQty = 0;
    double tempTotal = 0;

    class CartLine {

        Food food;
        int qty;

        CartLine(Food f, int q) {
            food = f;
            qty = q;
        }
    }

    List<CartLine> cartLines = new ArrayList<>();
    for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
        Food f = foodMap.get(e.getKey());
        int qtyVal = e.getValue() == null ? 0 : e.getValue();
        if (f == null || qtyVal <= 0) {
            continue;
        }

        cartLines.add(new CartLine(f, qtyVal));
        totalQty += qtyVal;
        tempTotal += f.price * qtyVal;
    }

    double discountVal = tempTotal * (discountPercent / 100.0);
    double finalTotal = tempTotal - discountVal;

    NumberFormat nf = NumberFormat.getInstance(new Locale("vi", "VN"));
    nf.setMaximumFractionDigits(0);

    // ===== FILTER foods list server-side =====
    List<Food> foodsView = new ArrayList<>();
    for (Food f : foods) {
        boolean okCat = "all".equals(cat) || (f.categoryID != null && String.valueOf(f.categoryID).equals(cat));
        boolean okQ = q.isEmpty() || f.name.toLowerCase().contains(q.toLowerCase());
        if (okCat && okQ) {
            foodsView.add(f);
        }
    }

    // ===== Modal data (food + its reviews) =====
    Food modalFood = null;
    if (openFoodId != -1) {
        modalFood = foodMap.get(openFoodId);
    }

    List<Review> modalReviews = new ArrayList<>();
    if (modalFood != null) {
        for (Review r : reviews) {
            if (r.foodID == modalFood.foodID) {
                modalReviews.add(r);
            }
        }
    }
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>FPT Food - Đặt món</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <link rel="stylesheet" href="./css/home.css"/>
    </head>

    <body class="<%= (request.getParameter("cartOpen") != null) ? "cart-open" : ""%>">
        <div class="container">
            <header>
                <div class="logo">FPT Food</div>
                <div>
                    <a href="login.jsp" class="btn-add"
                       style="background:white;color:#333;border:1px solid #ddd">
                        <i class="fas fa-sign-in-alt"></i> Đăng nhập
                    </a>
                </div>
            </header>

            <!-- Tabs (server) -->
            <div class="nav-tabs">
                <div class="nav-item <%= "menu".equals(view) ? "active" : ""%>" onclick="goView('menu')">Menu đặt món</div>
                <div class="nav-item <%= "history".equals(view) ? "active" : ""%>" onclick="goView('history')">Lịch sử đơn hàng</div>
            </div>

            <!-- MENU -->
            <div id="menu-view" class="view-section <%= "menu".equals(view) ? "active" : ""%>">
                <form class="search-box" method="GET" action="Home.jsp">
                    <input type="hidden" name="view" value="menu"/>
                    <input type="hidden" name="cat" value="<%= cat%>"/>
                    <i class="fas fa-search"></i>
                    <input type="text" name="q" value="<%= q%>" placeholder="Tìm kiếm món ăn..."/>
                </form>

                <div class="categories">
                    <button class="cat-chip <%= "all".equals(cat) ? "active" : ""%>" onclick="goCat('all');return false;">Tất cả</button>
                    <button class="cat-chip <%= "1".equals(cat) ? "active" : ""%>" onclick="goCat('1');return false;">Pizza</button>
                    <button class="cat-chip <%= "2".equals(cat) ? "active" : ""%>" onclick="goCat('2');return false;">Đồ uống</button>
                    <button class="cat-chip <%= "3".equals(cat) ? "active" : ""%>" onclick="goCat('3');return false;">Món chính</button>
                </div>

                <div class="food-grid">
                    <% if (foodsView.isEmpty()) { %>
                    <p style="grid-column:1/-1;text-align:center;color:#999;">Không có món.</p>
                    <% } %>

                    <% for (Food f : foodsView) {%>
                    <div class="food-card" onclick="openFood(<%= f.foodID%>)">
                        <div class="food-img-placeholder"><i class="fas fa-utensils food-icon"></i></div>
                        <div class="card-body">
                            <div>
                                <div style="font-weight:bold;"><%= f.name%></div>
                                <div style="font-size:13px;color:#999;"><%= f.categoryName%></div>
                            </div>

                            <div style="display:flex;justify-content:space-between;align-items:center;margin-top:10px;">
                                <span class="price"><%= nf.format(f.price)%>đ</span>

                                <!-- Add to cart: POST -->
                                <form action="AddToCartServlet" method="POST" style="margin:0;" onclick="event.stopPropagation();">
                                    <input type="hidden" name="foodId" value="<%= f.foodID%>"/>
                                    <input type="hidden" name="returnUrl" value="Home.jsp?view=menu&cat=<%= cat%>&q=<%= java.net.URLEncoder.encode(q, "UTF-8")%>&cartOpen=1"/>
                                    <button class="btn-add" type="submit"><i class="fas fa-plus"></i> Thêm</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% }%>
                </div>
            </div>

            <!-- HISTORY -->
            <div id="history-view" class="view-section <%= "history".equals(view) ? "active" : ""%>">
                <% if (history.isEmpty()) { %>
                <p style="text-align:center;color:#999;">Chưa có đơn hàng nào.</p>
                <% } %>

                <% for (OrderHistory o : history) {
                        String statusText = "Chờ xác nhận", statusClass = "status-pending";
                        if ("cooking".equals(o.status)) {
                            statusText = "Đang nấu";
                            statusClass = "status-cooking";
                        } else if ("done".equals(o.status)) {
                            statusText = "Đã xong món";
                            statusClass = "status-done";
                        } else if ("paid".equals(o.status)) {
                            statusText = "Đã thanh toán";
                            statusClass = "status-paid";
                        }
                        boolean canReview = "done".equals(o.status) || "paid".equals(o.status);
                %>
                <div class="history-card">
                    <div class="history-header">
                        <div>
                            <b>Đơn hàng #<%= o.orderID%></b>
                            <div style="font-size:12px;color:#888;"><%= o.createdTime%></div>
                        </div>
                        <span class="order-status <%= statusClass%>"><%= statusText%></span>
                    </div>

                    <div class="history-items">
                        <% for (String it : o.items) {%>
                        <%= it%><br>
                        <% }%>
                    </div>

                    <div class="history-footer">
                        <span>Tổng: <%= nf.format(o.finalPrice)%>đ</span>
                        <% if (canReview) {%>
                        <button class="btn-review-sm" type="button" onclick="openReview(<%= o.orderID%>)">Viết đánh giá</button>
                        <% } %>
                    </div>
                </div>
                <% }%>
            </div>
        </div>

        <!-- Cart FAB -->
        <button class="fab-cart" type="button" onclick="toggleCart()">
            <i class="fas fa-shopping-cart"></i>
            <span class="cart-count"><%= totalQty%></span>
        </button>

        <div class="cart-overlay" onclick="toggleCart()"></div>
        <div class="cart-sidebar">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:15px;">
                <h3>Giỏ hàng (<%= totalQty%>)</h3>
                <span onclick="toggleCart()" style="cursor:pointer;font-size:20px">&times;</span>
            </div>

            <div class="cart-items">
                <% if (cartLines.isEmpty()) { %>
                <p style="text-align:center;color:#999;">Giỏ hàng trống</p>
                <% } %>

                <% for (CartLine line : cartLines) {
                        double lineTotal = line.food.price * line.qty;
                %>
                <div class="cart-item">
                    <div style="flex:1;">
                        <div style="font-weight:bold;"><%= line.food.name%></div>
                        <div style="font-size:13px;color:#777;"><%= nf.format(line.food.price)%>đ</div>

                        <div class="qty-controls">
                            <form action="UpdateCartServlet" method="POST" style="margin:0;">
                                <input type="hidden" name="foodId" value="<%= line.food.foodID%>">
                                <input type="hidden" name="action" value="dec">
                                <input type="hidden" name="returnUrl" value="Home.jsp?view=<%= view%>&cat=<%= cat%>&q=<%= java.net.URLEncoder.encode(q, "UTF-8")%>&cartOpen=1">
                                <button class="btn-qty" type="submit"><i class="fas fa-minus"></i></button>
                            </form>

                            <span class="qty-text"><%= line.qty%></span>

                            <form action="UpdateCartServlet" method="POST" style="margin:0;">
                                <input type="hidden" name="foodId" value="<%= line.food.foodID%>">
                                <input type="hidden" name="action" value="inc">
                                <input type="hidden" name="returnUrl" value="Home.jsp?view=<%= view%>&cat=<%= cat%>&q=<%= java.net.URLEncoder.encode(q, "UTF-8")%>&cartOpen=1">
                                <button class="btn-qty" type="submit"><i class="fas fa-plus"></i></button>
                            </form>
                        </div>
                    </div>

                    <div style="font-weight:bold;align-self:center;"><%= nf.format(lineTotal)%>đ</div>
                </div>
                <% }%>
            </div>

            <form class="voucher-section" action="ApplyVoucherServlet" method="POST">
                <input type="text" class="voucher-input" name="voucherCode" placeholder="Mã giảm giá (VD: SALE10)">
                <input type="hidden" name="returnUrl" value="Home.jsp?view=<%= view%>&cat=<%= cat%>&q=<%= java.net.URLEncoder.encode(q, "UTF-8")%>&cartOpen=1">
                <button class="btn-apply" type="submit">Áp dụng</button>
            </form>

            <div class="cart-footer">
                <div style="display:flex;justify-content:space-between;margin-bottom:5px;">
                    <span>Tạm tính:</span><span><%= nf.format(tempTotal)%>đ</span>
                </div>
                <div style="display:flex;justify-content:space-between;margin-bottom:10px;color:var(--primary);">
                    <span>Giảm giá (<%= discountPercent%>%)</span><span>-<%= nf.format(discountVal)%>đ</span>
                </div>
                <div style="display:flex;justify-content:space-between;font-weight:bold;font-size:18px;">
                    <span>Tổng cộng:</span><span><%= nf.format(finalTotal)%>đ</span>
                </div>

                <form action="PlaceOrderServlet" method="POST">
                    <input type="hidden" name="returnUrl" value="Home.jsp?view=history">
                    <button class="btn-checkout" type="submit">Đặt món ngay</button>
                </form>
            </div>
        </div>

        <!-- Food Modal (open by ?foodId=) -->
        <div class="modal <%= (modalFood != null) ? "active" : ""%>" id="foodModal">
            <div class="modal-content">
                <div class="modal-header">
                    <span><%= (modalFood != null) ? modalFood.name : "Tên món ăn"%></span>
                    <span onclick="closeModal('foodModal')" style="cursor:pointer">&times;</span>
                </div>
                <div class="modal-body">
                    <p style="margin-bottom:20px;color:#555;">
                        <%= (modalFood != null) ? ("Danh mục: " + modalFood.categoryName) : ""%>
                    </p>

                    <h4 style="margin-bottom:10px">Đánh giá từ khách hàng</h4>
                    <% if (modalFood == null) { %>
                    <p style="font-style:italic;color:#999;">Chưa chọn món.</p>
                    <% } else if (modalReviews.isEmpty()) { %>
                    <p style="font-style:italic;color:#999;">Chưa có đánh giá nào.</p>
                    <% } else {
                        for (Review r : modalReviews) {
                    %>
                    <div class="review-item">
                        <div class="review-user"><%= r.username%></div>
                        <div class="review-stars">
                            <% for (int i = 0; i < r.rating; i++) { %><i class="fas fa-star"></i><% }%>
                        </div>
                        <div class="review-text"><%= r.comment%></div>
                    </div>
                    <% }
                        }%>
                </div>
            </div>
        </div>

        <!-- Review Modal (form submit) -->
        <div class="modal" id="writeReviewModal">
            <div class="modal-content">
                <div class="modal-header">
                    <span>Viết đánh giá</span>
                    <span onclick="closeModal('writeReviewModal')" style="cursor:pointer">&times;</span>
                </div>
                <div class="modal-body">
                    <p id="reviewTargetName" style="font-weight:bold;margin-bottom:10px">Đơn hàng #...</p>
                    <p style="font-size:14px;margin-bottom:5px">Bạn cảm thấy thế nào?</p>

                    <div class="star-rating-input" id="starInput">
                        <i class="fas fa-star active" onclick="setRating(1)"></i>
                        <i class="fas fa-star active" onclick="setRating(2)"></i>
                        <i class="fas fa-star active" onclick="setRating(3)"></i>
                        <i class="fas fa-star active" onclick="setRating(4)"></i>
                        <i class="fas fa-star active" onclick="setRating(5)"></i>
                    </div>

                    <form action="SubmitReviewServlet" method="POST">
                        <input type="hidden" name="orderId" id="reviewOrderId" value="">
                        <input type="hidden" name="rating" id="ratingVal" value="5">
                        <input type="hidden" name="returnUrl" value="Home.jsp?view=history">
                        <textarea class="review-input" name="comment" rows="4" placeholder="Hãy chia sẻ trải nghiệm món ăn của bạn..."></textarea>
                        <button class="btn-add" type="submit" style="width:100%;">Gửi đánh giá</button>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // JS chỉ để mở/đóng UI 
            function toggleCart() {
                document.body.classList.toggle("cart-open");
            }
            function closeModal(id) {
                document.getElementById(id).classList.remove("active");
                if (id === 'foodModal') { // đóng food modal => remove param foodId
                    const url = new URL(window.location.href);
                    url.searchParams.delete("foodId");
                    window.history.replaceState({}, "", url.toString());
                }
            }

            function goView(v) {
                const url = new URL(window.location.href);
                url.searchParams.set("view", v);
                if (v === "history") {
                    url.searchParams.delete("cat");
                    url.searchParams.delete("q");
                    url.searchParams.delete("foodId");
                }
                window.location.href = url.toString();
            }
            function goCat(c) {
                const url = new URL(window.location.href);
                url.searchParams.set("view", "menu");
                url.searchParams.set("cat", c);
                url.searchParams.delete("foodId");
                window.location.href = url.toString();
            }
            function openFood(id) {
                const url = new URL(window.location.href);
                url.searchParams.set("view", "menu");
                url.searchParams.set("foodId", id);
                window.location.href = url.toString();
            }

            // Review modal
            let selectedRating = 5;
            function setRating(star) {
                selectedRating = star;
                document.getElementById("ratingVal").value = star;
                const stars = document.querySelectorAll("#starInput i");
                stars.forEach((s, idx) => idx < star ? s.classList.add("active") : s.classList.remove("active"));
            }
            function openReview(orderId) {
                document.getElementById("reviewTargetName").innerText = "Đánh giá cho Đơn hàng #" + orderId;
                document.getElementById("reviewOrderId").value = orderId;
                setRating(5);
                document.getElementById("writeReviewModal").classList.add("active");
            }

            // Auto-open cart nếu có cartOpen=1
            (function () {
                const url = new URL(window.location.href);
                if (url.searchParams.get("cartOpen") === "1")
                    document.body.classList.add("cart-open");
            })();
        </script>

    </body>
</html>


