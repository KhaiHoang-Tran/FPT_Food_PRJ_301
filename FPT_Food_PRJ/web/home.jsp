<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>FPT Food - Đặt món</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <link rel="stylesheet" href="css/home.css"/>
    </head>

    <body>

        <div class="container">

            <!-- HEADER -->
            <header>
                <div class="logo">FPT Food</div>

                <a href="login.jsp" class="btn-add"
                   style="background:white;color:#333;border:1px solid #ddd">
                    <i class="fas fa-sign-in-alt"></i> Đăng nhập
                </a>
            </header>

            <!-- TABS -->
            <div class="nav-tabs">
                <div class="nav-item active">Menu đặt món</div>
                <div class="nav-item">Lịch sử đơn hàng</div>
            </div>

            <!-- SEARCH (UI only) -->
            <form class="search-box" method="get">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Tìm kiếm món ăn...">
            </form>

            <!-- CATEGORY -->
            <div class="categories">
                <form action="homeController" method="get" style="display:flex;gap:12px">

                    <button class="cat-chip ${empty param.cat ? 'active' : ''}">
                        Tất cả
                    </button>

                    <button class="cat-chip ${param.cat == 'Khai vị' ? 'active' : ''}"
                            name="cat" value="Khai vị">
                        Khai vị
                    </button>

                    <button class="cat-chip ${param.cat == 'Món chính' ? 'active' : ''}"
                            name="cat" value="Món chính">
                        Món chính
                    </button>

                    <button class="cat-chip ${param.cat == 'Đồ uống' ? 'active' : ''}"
                            name="cat" value="Đồ uống">
                        Đồ uống
                    </button>

                    <button class="cat-chip ${param.cat == 'Tráng miệng' ? 'active' : ''}"
                            name="cat" value="Tráng miệng">
                        Tráng miệng
                    </button>

                </form>
            </div>



            <!-- FOOD GRID -->
            <c:if test="${empty foods}">
                <div style="text-align:center;color:#999;margin-top:40px">
                    Chưa có món ăn
                </div>
            </c:if>

            <div class="food-grid">
                <c:forEach var="f" items="${foods}">
                    <div class="food-card">
                        <div class="food-img-placeholder">
                            <i class="fa-solid fa-utensils food-icon"></i>
                        </div>

                        <div class="card-body">
                            <div>
                                <h4>${f.name}</h4>
                                <small>${f.categoryName}</small>
                            </div>

                            <div style="display:flex;justify-content:space-between;align-items:center">
                                <span class="price">
                                    ${f.price}đ
                                </span>

                                <form action="addToCart" method="post">
                                    <input type="hidden" name="foodId" value="${f.foodID}">
                                    <input type="hidden" name="cat" value="${param.cat}">
                                    <button class="btn-add">+ Thêm</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

        </div>

        <!-- CART FAB -->
        <button class="fab-cart" onclick="toggleCart()">
            <i class="fas fa-shopping-cart"></i>
            <span class="cart-count">
                <c:out value="${totalQty != null ? totalQty : 0}"/>
            </span>
        </button>

        <div class="cart-overlay" onclick="toggleCart()"></div>

        <!-- CART SIDEBAR -->
        <div class="cart-sidebar">

            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:15px;">
                <h3>
                    Giỏ hàng (
                    <c:out value="${totalQty != null ? totalQty : 0}"/>
                    )
                </h3>
                <span onclick="toggleCart()" style="cursor:pointer;font-size:20px">&times;</span>
            </div>

            <div class="cart-items">

                <c:if test="${empty cart}">
                    <p style="text-align:center;color:#999;">Giỏ hàng trống</p>
                </c:if>

                <c:forEach items="${cart}" var="c">
                    <c:set var="f" value="${foodMap[c.key]}" />

                    <div class="cart-item">
                        <div style="flex:1;">
                            <div style="font-weight:bold">${f.name}</div>
                            <div style="font-size:13px;color:#777;">
                                <fmt:formatNumber value="${f.price}" pattern="#,###"/>đ
                            </div>

                            <div class="qty-controls">
                                <form action="updateCart" method="post" style="display:flex;gap:6px">
                                    <input type="hidden" name="foodId" value="${f.foodID}"/>

                                    <button class="btn-qty" name="action" value="minus">−</button>

                                    <span class="qty-text">${c.value}</span>

                                    <button class="btn-qty" name="action" value="plus">+</button>
                                </form>
                            </div>

                        </div>

                        <div style="font-weight:bold;">
                            <fmt:formatNumber value="${f.price * c.value}" pattern="#,###"/>đ
                        </div>
                    </div>
                </c:forEach>

            </div>

            <!-- CART FOOTER -->
            <div class="cart-footer">

                <!-- VOUCHER -->
                <form class="voucher-section">
                    <input type="text"
                           class="voucher-input"
                           placeholder="Mã giảm giá (VD: SALE10)">
                    <button type="button" class="btn-apply">Áp dụng</button>
                </form>

                <div style="display:flex;justify-content:space-between;margin-bottom:6px;">
                    <span>Tạm tính:</span>
                    <span>
                        <fmt:formatNumber value="${finalTotal != null ? finalTotal : 0}"
                                          pattern="#,###"/>đ
                    </span>
                </div>

                <div style="display:flex;justify-content:space-between;margin-bottom:10px;color:var(--primary);">
                    <span>Giảm giá:</span>
                    <span>-0đ</span>
                </div>

                <div style="display:flex;justify-content:space-between;font-weight:bold;font-size:18px;">
                    <span>Tổng cộng:</span>
                    <span>
                        <fmt:formatNumber value="${finalTotal != null ? finalTotal : 0}"
                                          pattern="#,###"/>đ
                    </span>
                </div>

                <button class="btn-checkout">Đặt món ngay</button>
            </div>


        </div>

        <script>
            function toggleCart() {
                document.body.classList.toggle("cart-open");
            }
        </script>

    </body>
</html>
