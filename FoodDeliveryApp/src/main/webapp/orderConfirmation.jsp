<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.food.model.Order" %>
<%@ page import="com.food.model.Restaurant" %>
<%@ page import="com.food.model.User"%>

<%
    Order placedOrder = (Order) session.getAttribute("placedOrder");
    Restaurant orderRestaurant = (Restaurant) session.getAttribute("orderRestaurant");
    String orderAddress = (String) session.getAttribute("orderAddress");
    User loggedUser = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | Order Confirmed</title>

    <!-- External Stylesheets (Zero External JS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkouts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>

<body>

    <!-- MODULAR NAVBAR -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="confirmation-container">
        <!-- ================= STAGE 1: DELIVERY BOY BIKE ANIMATION (Swiggy / Zomato Style) ================= -->
        <div class="delivery-animation-stage">
            <div class="bike-scene">
                <div class="bike-wrapper">
                    <!-- ANIMATED DELIVERY SCOOTER SVG -->
                    <div class="bike-svg-container">
                        <svg width="100" height="70" viewBox="0 0 100 70" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <!-- Delivery Box -->
                            <rect x="12" y="16" width="24" height="22" rx="4" fill="#FF5400"/>
                            <text x="18" y="31" font-size="12" font-family="Arial" fill="#FFFFFF">🍕</text>
                            
                            <!-- Bike Frame -->
                            <path d="M30 38 L48 38 L58 24 L72 24" stroke="#1E293B" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>
                            <path d="M48 38 L54 48 L68 48" stroke="#1E293B" stroke-width="3" stroke-linecap="round"/>
                            
                            <!-- Rider Body -->
                            <circle cx="56" cy="12" r="7" fill="#FF5400"/> <!-- Helmet -->
                            <path d="M53 19 L46 32 L58 35" stroke="#334155" stroke-width="4" stroke-linecap="round"/> <!-- Torso & Legs -->
                            <path d="M50 24 L66 24" stroke="#334155" stroke-width="3" stroke-linecap="round"/> <!-- Arm to Handle -->
                            
                            <!-- Back Wheel -->
                            <g class="wheel-back">
                                <circle cx="22" cy="48" r="12" stroke="#1E293B" stroke-width="4" fill="#F8FAFC"/>
                                <circle cx="22" cy="48" r="3" fill="#FF5400"/>
                                <line x1="22" y1="36" x2="22" y2="60" stroke="#94A3B8" stroke-width="1.5"/>
                                <line x1="10" y1="48" x2="34" y2="48" stroke="#94A3B8" stroke-width="1.5"/>
                            </g>
                            
                            <!-- Front Wheel -->
                            <g class="wheel-front">
                                <circle cx="76" cy="48" r="12" stroke="#1E293B" stroke-width="4" fill="#F8FAFC"/>
                                <circle cx="76" cy="48" r="3" fill="#FF5400"/>
                                <line x1="76" y1="36" x2="76" y2="60" stroke="#94A3B8" stroke-width="1.5"/>
                                <line x1="64" y1="48" x2="88" y2="48" stroke="#94A3B8" stroke-width="1.5"/>
                            </g>
                        </svg>
                    </div>
                </div>

                <!-- MOVING ROAD STRIP -->
                <div class="road-strip"></div>
            </div>

            <div class="confirming-text">
                <span>Confirming your order with restaurant</span>
                <span class="dots">...</span>
            </div>
        </div>

        <!-- ================= STAGE 2: CELEBRATION GREEN TICK & ORDER DETAILS ================= -->
        <div class="order-success-card">
            <!-- GREEN TICK ICON WITH CELEBRATION POP (Clickable for Confetti Burst) -->
            <div class="success-checkmark-circle" 
                 title="Click to celebrate! 🎉" 
                 onclick="if (window.CravoraConfetti) { CravoraConfetti.foodBlast(0.5, 0.35); CravoraConfetti.doubleCannon(); }">
                ✓
            </div>

            <h1>Order Placed Successfully! 🎉</h1>
            <p class="subtitle">Your order has been received and is being prepared fresh at the restaurant.</p>

            <!-- CELEBRATE REPLAY BUTTON -->
            <div class="confetti-replay-wrapper">
                <button type="button" 
                        class="confetti-replay-btn" 
                        onclick="if (window.CravoraConfetti) { CravoraConfetti.orderSuccess(); }"
                        title="Shoot more celebratory confetti!">
                    <span>🎊 Celebrate Again!</span>
                </button>
            </div>

            <!-- ORDER DETAILS SUMMARY -->
            <div class="confirmed-details-box">
                <div class="detail-block">
                    <span class="lbl">Order ID</span>
                    <span class="val highlight">#CRV-<%= (placedOrder != null && placedOrder.getOrderId() > 0) ? placedOrder.getOrderId() : "1048" %></span>
                </div>

                <div class="detail-block">
                    <span class="lbl">Order Status</span>
                    <span class="val status-pill">⚡ <%= (placedOrder != null) ? placedOrder.getStatus() : "CONFIRMED" %></span>
                </div>

                <div class="detail-block">
                    <span class="lbl">Estimated Delivery</span>
                    <span class="val">⏱️ 25 - 30 Mins</span>
                </div>

                <div class="detail-block">
                    <span class="lbl">Restaurant</span>
                    <span class="val"><%= (orderRestaurant != null) ? orderRestaurant.getName() : "CRAVORA Partner Restaurant" %></span>
                </div>

                <div class="detail-block">
                    <span class="lbl">Payment Method</span>
                    <span class="val">
                        <% 
                            String payMode = (placedOrder != null && placedOrder.getPaymentMode() != null) ? placedOrder.getPaymentMode() : "UPI";
                            if (payMode.toUpperCase().contains("CARD")) {
                        %>
                            💳 <%= payMode %>
                        <% } else if (payMode.toUpperCase().contains("COD") || payMode.toUpperCase().contains("CASH")) { %>
                            💵 <%= payMode %>
                        <% } else { %>
                            📱 <%= payMode %>
                        <% } %>
                    </span>
                </div>

                <div class="detail-block">
                    <span class="lbl">Total Paid</span>
                    <span class="val highlight">₹<%= (placedOrder != null) ? String.format("%.0f", placedOrder.getTotalAmount()) : "0" %></span>
                </div>

                <div class="detail-block" style="grid-column: 1 / -1;">
                    <span class="lbl">Delivery Address</span>
                    <span class="val">📍 <%= (orderAddress != null && !orderAddress.trim().isEmpty()) ? orderAddress : ((loggedUser != null) ? loggedUser.getAddress() : "Your delivery address") %></span>
                </div>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="success-action-buttons">
                <a href="${pageContext.request.contextPath}/restaurant" class="btn-primary-home" data-confetti="food">
                    <span>Explore More Restaurants</span>
                    <span>🍽️</span>
                </a>

                <a href="${pageContext.request.contextPath}/orders" class="btn-secondary-orders">
                    <span>View Orders</span>
                    <span>📦</span>
                </a>
            </div>
        </div>
    </main>

    <!-- MODULAR FOOTER -->
    <%@ include file="includes/footer.jsp" %>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Stage 1 delivery bike animation finishes and green tick pops in at 3.0 seconds
            // Automatically launch the multi-wave celebratory confetti cannons!
            setTimeout(function() {
                if (window.CravoraConfetti) {
                    window.CravoraConfetti.orderSuccess();
                }
            }, 3000);
        });
    </script>

</body>

</html>
