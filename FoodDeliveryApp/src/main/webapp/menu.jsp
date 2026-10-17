<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.food.model.Menu" %>
<%@ page import="com.food.model.Cart" %>
<%@ page import="com.food.model.CartItem" %>
<%@ page import="com.food.model.User"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | Delicious Menu</title>

    <!-- External Stylesheets (Zero External JS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menus.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>

<body class="menu-page">

    <!-- MODULAR NAVBAR -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- ================= PAGE HEADER & BACK NAVIGATION ================= -->
    <section class="page-header">
        <div class="header-top-bar">
            <a href="${pageContext.request.contextPath}/restaurant" class="back-nav-btn">
                <span class="back-arrow">←</span>
                <span>Back to Restaurants</span>
            </a>
        </div>

        <h1>Explore Our <span>Menu</span></h1>
        <p>Delicious gourmet dishes prepared with love, finest ingredients, and served fresh.</p>
    </section>

    <!-- ================= MENU DATA ================= -->
    <%
        List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    %>

    <main class="menu-container">
        <%
            if (menuList != null && !menuList.isEmpty()) {
                for (Menu menu : menuList) {
        %>

        <!-- MENU CARD WITH ROTATING GLOWING BORDER -->
        <div class="menu-card">

            <!-- IMAGE & RATING BADGE -->
            <div class="menu-image">
                <img
                    src="<%= menu.getImagePath() %>"
                    alt="<%= menu.getItemName() %>"
                    loading="lazy">

                <div class="rating-badge">
                    <span style="color: #f59e0b;">★</span>
                    <span><%= menu.getRatings() %></span>
                </div>
            </div>

            <!-- CONTENT -->
            <div class="menu-content">
                <h3><%= menu.getItemName() %></h3>
                <p class="description"><%= menu.getDescription() %></p>

                <!-- PRICE + ADD TO CART / QUANTITY -->
                <div class="menu-bottom">
                    <span class="price">₹<%= String.format("%.0f", menu.getPrice()) %></span>

                    <%
                        if (menu.isAvailable()) {
                            Cart menuCart = (Cart) session.getAttribute("cart");
                            CartItem existingCartItem = null;

                            if (menuCart != null && menuCart.getItems() != null) {
                                existingCartItem = menuCart.getItems().get(menu.getMenuId());
                            }
                    %>

                    <% if (existingCartItem == null) { %>

                    <!-- ADD TO CART FORM -->
                    <form action="${pageContext.request.contextPath}/cart" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                        <button type="submit" class="add-cart-btn">
                            Add to Cart +
                        </button>
                    </form>

                    <% } else { %>

                    <!-- QUANTITY CONTROLLER -->
                    <div class="quantity-control">
                        <!-- DECREASE -->
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="decrease">
                            <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                            <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantId() %>">
                            <button type="submit" class="quantity-btn">−</button>
                        </form>

                        <span class="quantity">
                            <%= existingCartItem.getQuantity() %>
                        </span>

                        <!-- INCREASE -->
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="increase">
                            <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                            <input type="hidden" name="restaurantId" value="<%= menu.getRestaurantId() %>">
                            <button type="submit" class="quantity-btn">+</button>
                        </form>
                    </div>

                    <% } %>

                    <% } else { %>

                    <!-- UNAVAILABLE STATE -->
                    <button type="button" class="add-cart-btn unavailable-btn" disabled>
                        Unavailable
                    </button>

                    <% } %>
                </div>

                <% if (!menu.isAvailable()) { %>
                <div class="unavailable-text">
                    Currently sold out
                </div>
                <% } %>
            </div>

        </div>

        <%
                }
            } else {
        %>

        <!-- NO MENU STATE -->
        <div class="no-menu">
            <p>No menu items available for this restaurant at the moment.</p>
        </div>

        <%
            }
        %>
    </main>

    <!-- ================= STICKY FLOATING CART BAR ================= -->
    <%
        Cart pageStickyCart = (Cart) session.getAttribute("cart");
        int pageStickyCartCount = 0;

        if (pageStickyCart != null && pageStickyCart.getCartItems() != null) {
            for (CartItem item : pageStickyCart.getCartItems()) {
                pageStickyCartCount += item.getQuantity();
            }
        }
    %>

    <% if (pageStickyCartCount > 0) { %>
    <aside class="sticky-cart-bar" data-confetti="food" title="Cart active! 🍕">
        <div class="sticky-cart-info">
            <span>🛒</span>
            <span class="sticky-cart-count">
                <%= pageStickyCartCount %> <%= pageStickyCartCount == 1 ? "item" : "items" %>
            </span>
            <span>added in your cart</span>
        </div>

        <a href="${pageContext.request.contextPath}/cart" class="view-cart-btn">
            VIEW CART →
        </a>
    </aside>
    <% } %>

    <!-- MODULAR FOOTER -->
    <%@ include file="includes/footer.jsp" %>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>

</body>

</html>