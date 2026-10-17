<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.food.model.Cart" %>
<%@ page import="com.food.model.CartItem" %>
<%@ page import="java.util.Collection" %>
<%@ page import="com.food.model.User"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | Your Food Cart</title>

    <!-- External Stylesheets (Zero External JS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/carts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>

<body>

    <!-- MODULAR NAVBAR -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- ================= TOP NAVIGATION BAR ================= -->
    <div style="width: 90%; max-width: 1200px; margin: 110px auto 0; display: flex; align-items: center; justify-content: space-between;">
        <a href="${pageContext.request.contextPath}/restaurant" class="back-nav-btn">
            <span class="back-arrow">←</span>
            <span>Back to Restaurants</span>
        </a>
    </div>

    <!-- ================= STEPPER PROGRESS BAR ================= -->
    <div class="stepper-container" style="margin-top: 25px;">
        <div class="stepper-line"></div>

        <div class="step-item active">
            <div class="step-circle">1</div>
            <div class="step-title">Cart Review</div>
        </div>

        <div class="step-item">
            <div class="step-circle">2</div>
            <div class="step-title">Delivery & Address</div>
        </div>

        <div class="step-item">
            <div class="step-circle">3</div>
            <div class="step-title">Payment</div>
        </div>
    </div>

    <!-- ================= CART CONTENT ================= -->
    <%
        Cart pageCart = (Cart) session.getAttribute("cart");
    %>

    <%
        if (pageCart != null && pageCart.getCartItems() != null && !pageCart.getCartItems().isEmpty()) {
            Collection<CartItem> cartItems = pageCart.getCartItems();
    %>

    <main class="cart-page-layout">
        <!-- ================= LEFT COLUMN: CART ITEMS ================= -->
        <div>
            <!-- DELIVERY NOTICE -->
            <div class="delivery-notice-banner">
                <span class="banner-icon">⚡</span>
                <span>Express Delivery in <strong>25-30 mins</strong> from your chosen restaurant</span>
            </div>

            <div class="cart-items-wrapper">
                <%
                    for (CartItem cartItem : cartItems) {
                %>

                <!-- ITEM CARD -->
                <div class="cart-card">
                    <!-- IMAGE -->
                    <div class="cart-image">
                        <img
                            src="<%= cartItem.getMenu().getImagePath() %>"
                            alt="<%= cartItem.getMenu().getItemName() %>"
                            loading="lazy">
                    </div>

                    <!-- DETAILS -->
                    <div class="cart-details">
                        <div class="cart-item-header">
                            <span class="food-type-icon"></span>
                            <h3><%= cartItem.getMenu().getItemName() %></h3>
                        </div>

                        <p><%= cartItem.getMenu().getDescription() %></p>

                        <div class="unit-price">
                            ₹<%= String.format("%.0f", cartItem.getMenu().getPrice()) %> each
                        </div>

                        <!-- INTERACTIVE QUANTITY CONTROLS (+ / -) -->
                        <div class="cart-quantity-row">
                            <span class="quantity-label">Quantity:</span>
                            <div class="cart-quantity-control">
                                <form action="${pageContext.request.contextPath}/cart" method="post" class="qty-form">
                                    <input type="hidden" name="action" value="decrease">
                                    <input type="hidden" name="source" value="cart">
                                    <input type="hidden" name="menuId" value="<%= cartItem.getMenu().getMenuId() %>">
                                    <button type="submit" class="cart-qty-btn decrease-btn" title="Decrease Quantity" aria-label="Decrease Quantity">−</button>
                                </form>
                                <span class="cart-qty-val"><%= cartItem.getQuantity() %></span>
                                <form action="${pageContext.request.contextPath}/cart" method="post" class="qty-form">
                                    <input type="hidden" name="action" value="increase">
                                    <input type="hidden" name="source" value="cart">
                                    <input type="hidden" name="menuId" value="<%= cartItem.getMenu().getMenuId() %>">
                                    <button type="submit" class="cart-qty-btn increase-btn" title="Increase Quantity" aria-label="Increase Quantity">+</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ITEM TOTAL -->
                    <div class="item-total-box">
                        <span class="item-total-label">Subtotal</span>
                        <span class="item-total">
                            ₹<%= String.format("%.0f", cartItem.getMenu().getPrice() * cartItem.getQuantity()) %>
                        </span>
                    </div>
                </div>

                <%
                    }
                %>
            </div>
        </div>

        <!-- ================= RIGHT COLUMN: ORDER SUMMARY ================= -->
        <aside>
            <div class="cart-summary-card">
                <h2><span>🧾</span> Bill Summary</h2>

                <!-- OFFER CALLOUT -->
                <div class="offer-banner" data-confetti="food" style="cursor: pointer;" title="Click to celebrate free delivery! 🎉">
                    <span>🎉</span>
                    <span>Free Delivery unlocked on this order!</span>
                </div>

                <!-- BILL BREAKDOWN -->
                <div class="bill-breakdown">
                    <div class="bill-row">
                        <span class="bill-label">Item Total</span>
                        <span class="bill-value">₹<%= String.format("%.0f", pageCart.getTotalAmount()) %></span>
                    </div>

                    <div class="bill-row free-badge">
                        <span class="bill-label">Delivery Partner Fee</span>
                        <span class="bill-value">FREE</span>
                    </div>

                    <div class="bill-row">
                        <span class="bill-label">Platform Fee</span>
                        <span class="bill-value">₹5</span>
                    </div>

                    <div class="bill-row">
                        <span class="bill-label">Govt Taxes & Charges</span>
                        <span class="bill-value">₹0</span>
                    </div>

                    <div class="bill-row grand-total">
                        <span class="bill-label">To Pay</span>
                        <span class="bill-value">₹<%= String.format("%.0f", pageCart.getTotalAmount() + 5) %></span>
                    </div>
                </div>

                <!-- CHECKOUT CTA BUTTON -->
                <a href="${pageContext.request.contextPath}/checkout" class="checkout-cta-btn">
                    <span>Proceed to Checkout</span>
                    <span class="btn-arrow">→</span>
                </a>

                <!-- CLEAR CART -->
                <form action="${pageContext.request.contextPath}/cart" method="post" class="clear-cart-form">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="clear-cart-action-btn">
                        <span>🗑️</span>
                        <span>Clear Cart</span>
                    </button>
                </form>
            </div>
        </aside>
    </main>

    <%
        } else {
    %>

    <!-- EMPTY CART STATE -->
    <div class="empty-cart-card">
        <span class="empty-cart-illustration">🛒</span>
        <h2>Your Cart is Empty</h2>
        <p>Good food is always just a few clicks away! Explore top-rated restaurants and add delicious items to your cart.</p>
        <a href="${pageContext.request.contextPath}/restaurant" class="browse-restaurants-btn">
            Explore Restaurants →
        </a>
    </div>

    <%
        }
    %>

    <!-- MODULAR FOOTER -->
    <%@ include file="includes/footer.jsp" %>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>

</body>

</html>