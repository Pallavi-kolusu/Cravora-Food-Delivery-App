<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.model.Cart" %>
<%@ page import="com.food.model.CartItem" %>
<%@ page import="com.food.model.User"%>

<%
    Cart _navCart = (Cart) session.getAttribute("cart");
    int _navCartCount = 0;
    if (_navCart != null && _navCart.getCartItems() != null) {
        for (CartItem _cItem : _navCart.getCartItems()) {
            _navCartCount += _cItem.getQuantity();
        }
    }
    User _navUser = (User) session.getAttribute("user");
    String _currentUri = request.getRequestURI();
    boolean _isRestaurantPage = _currentUri != null && (_currentUri.endsWith("/restaurant") || _currentUri.endsWith("/restaurant.jsp"));
%>

<header class="navbar <%= _isRestaurantPage ? "navbar-hero" : "" %>" id="navbar">
    <div class="navbar-container">
        <!-- BRAND LOGO -->
        <a href="${pageContext.request.contextPath}/restaurant" class="logo">
            <span class="logo-icon">🍕</span>
            <span class="logo-text">CRAVORA</span>
        </a>

        <!-- NAVIGATION LINKS -->
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/restaurant">
                <span>🍽️ Restaurants</span>
            </a>

            <a href="${pageContext.request.contextPath}/orders">
                <span>📦 Orders</span>
            </a>

            <a href="${pageContext.request.contextPath}/cart" class="cart-link">
                <span>🛒 Cart</span>
                <span class="cart-count <%= _navCartCount > 0 ? "has-items" : "" %>">
                    <%= _navCartCount %>
                </span>
            </a>

            <% if (_navUser == null) { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="nav-btn login-nav-btn">
                    <span>Login</span>
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/profile" class="user-pill">
                    <span class="user-avatar">👤</span>
                    <span class="user-name"><%= _navUser.getName() %></span>
                </a>
            <% } %>
        </nav>
    </div>
</header>
