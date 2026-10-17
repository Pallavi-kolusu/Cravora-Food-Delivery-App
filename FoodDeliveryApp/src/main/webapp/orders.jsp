<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.food.model.Order" %>
<%@ page import="com.food.model.OrderItem" %>
<%@ page import="com.food.model.Restaurant" %>
<%@ page import="com.food.model.Menu" %>
<%@ page import="com.food.model.User"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=orders");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Map<Integer, Restaurant> restaurantMap = (Map<Integer, Restaurant>) request.getAttribute("restaurantMap");
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");
    Map<Integer, Menu> menuMap = (Map<Integer, Menu>) request.getAttribute("menuMap");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | My Orders</title>

    <!-- External Stylesheets (Zero External JS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkouts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>

<body>

    <!-- MODULAR NAVBAR -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="orders-history-container">
        <!-- HEADER BAR -->
        <div class="orders-page-header">
            <div>
                <a href="${pageContext.request.contextPath}/restaurant" class="back-nav-btn" style="margin-bottom: 14px;">
                    <span class="back-arrow">←</span>
                    <span>Back to Restaurants</span>
                </a>
                <h1>My <span>Past Orders</span></h1>
            </div>
            <p style="color: var(--text-secondary); font-size: 14px;">
                Review past food deliveries and easily reorder your favorites
            </p>
        </div>

        <%
            if (orders != null && !orders.isEmpty()) {
        %>

        <div class="orders-list-wrapper">
            <%
                for (Order order : orders) {
                    Restaurant restaurant = (restaurantMap != null) ? restaurantMap.get(order.getRestaurantId()) : null;
                    List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(order.getOrderId()) : null;
            %>

            <!-- ORDER CARD -->
            <div class="order-history-card">
                <!-- CARD TOP -->
                <div class="order-card-top">
                    <div class="order-restaurant-info">
                        <div class="restaurant-avatar-badge">
                            🍽️
                        </div>
                        <div class="order-restaurant-meta">
                            <h3><%= (restaurant != null) ? restaurant.getName() : "Restaurant #" + order.getRestaurantId() %></h3>
                            <p>
                                📍 <%= (restaurant != null) ? restaurant.getAddress() : "Bengaluru" %> • 
                                <%= (order.getOrderDate() != null) ? order.getOrderDate().toString().substring(0, 16) : "Recent" %>
                            </p>
                        </div>
                    </div>

                    <div class="order-meta-right">
                        <span class="order-id-pill">#CRV-<%= order.getOrderId() %></span>
                        <span class="order-status-badge confirmed" 
                              data-confetti="stars" 
                              style="cursor: pointer;" 
                              title="Click for celebration sparkles! ✨">
                            ⚡ <%= order.getStatus() %>
                        </span>
                    </div>
                </div>

                <!-- ITEMS LIST -->
                <div class="order-card-items">
                    <%
                        if (items != null && !items.isEmpty()) {
                            for (OrderItem item : items) {
                                Menu menu = (menuMap != null) ? menuMap.get(item.getMenuId()) : null;
                                String itemName = (menu != null) ? menu.getItemName() : "Dish #" + item.getMenuId();
                    %>

                    <div class="order-item-line">
                        <div class="order-item-name">
                            <span style="color: #10b981;">●</span>
                            <span><%= itemName %></span>
                            <span class="order-item-qty">× <%= item.getQuantity() %></span>
                        </div>
                        <div class="order-item-amt">
                            ₹<%= String.format("%.0f", item.getTotalAmount()) %>
                        </div>
                    </div>

                    <%
                            }
                        } else {
                    %>
                        <div style="color: var(--text-secondary); font-size: 13px;">Gourmet Meal Items</div>
                    <%
                        }
                    %>
                </div>

                <!-- CARD BOTTOM -->
                <div class="order-card-bottom">
                    <div>
                        <span style="font-size: 13px; color: var(--text-secondary); margin-right: 6px;">Total Paid (<%= order.getPaymentMode() %>):</span>
                        <span class="order-total-price">₹<%= String.format("%.0f", order.getTotalAmount()) %></span>
                    </div>

                    <%
                        if (restaurant != null) {
                    %>
                    <a href="menu?restaurantId=<%= restaurant.getRestaurantId() %>" class="reorder-btn" data-confetti="food">
                        <span>View Menu / Reorder</span>
                        <span>→</span>
                    </a>
                    <%
                        }
                    %>
                </div>
            </div>

            <%
                }
            %>
        </div>

        <%
            } else {
        %>

        <!-- EMPTY ORDERS STATE -->
        <div class="checkout-box" style="text-align: center; padding: 70px 30px; border-radius: var(--radius-xl);">
            <div style="font-size: 60px; margin-bottom: 16px;">📦</div>
            <h2 style="font-size: 26px; font-weight: 800; margin-bottom: 10px;">No Orders Placed Yet</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">You haven't ordered any delicious food yet. Treat yourself to amazing meals!</p>
            <a href="${pageContext.request.contextPath}/restaurant" class="checkout-cta-btn" style="display: inline-flex; width: auto; padding: 12px 30px;">
                Explore Restaurants →
            </a>
        </div>

        <%
            }
        %>
    </main>

    <!-- MODULAR FOOTER -->
    <%@ include file="includes/footer.jsp" %>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>

</body>

</html>
