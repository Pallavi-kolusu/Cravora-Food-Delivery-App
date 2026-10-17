<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | Create Account</title>

    <!-- External Stylesheets (Zero External JS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>

<body class="auth-page">

    <div class="auth-split-wrapper signup-mode">
        <!-- ================= LEFT: CULINARY FOOD BANNER ================= -->
        <div class="auth-food-banner">
            <a href="${pageContext.request.contextPath}/restaurant" class="banner-brand">
                <span>🍕</span>
                <span class="logo-text">CRAVORA</span>
            </a>

            <div class="banner-middle">
                <span class="banner-pill-tag" data-confetti="stars" style="cursor: pointer;" title="Click for celebratory sparkles! ✨">🍔 Join The Food Revolution</span>
                <h2>Delicious Food, Just A Click Away!</h2>
                <p>Sign up now to explore curated menus, track your orders, and unlock exclusive discounts.</p>
            </div>

            <div class="banner-trust-badge" data-confetti="food" style="cursor: pointer;" title="Click for welcome celebration! 🎉">
                <span class="trust-stars">⚡ Free Delivery</span>
                <span class="trust-text">On your first 3 orders</span>
            </div>
        </div>

        <!-- ================= RIGHT: SIGNUP FORM ================= -->
        <div class="auth-form-container">
            <div class="auth-form-header">
                <h1>Create Account</h1>
                <p>Fill in your details to start ordering today.</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message">
                    <span>⚠️</span>
                    <span><%= error %></span>
                </div>
            <%
                }
            %>

            <!-- SIGNUP FORM -->
            <form action="${pageContext.request.contextPath}/signup" method="post">
                <div class="form-grid-auth">
                    <div class="form-group-auth">
                        <label for="name">Full Name</label>
                        <div class="input-auth-wrapper">
                            <span class="input-auth-icon">👤</span>
                            <input
                                type="text"
                                id="name"
                                name="name"
                                placeholder="John Doe"
                                required>
                        </div>
                    </div>

                    <div class="form-group-auth">
                        <label for="username">Username</label>
                        <div class="input-auth-wrapper">
                            <span class="input-auth-icon">🏷️</span>
                            <input
                                type="text"
                                id="username"
                                name="username"
                                placeholder="johndoe"
                                required>
                        </div>
                    </div>
                </div>

                <div class="form-grid-auth">
                    <div class="form-group-auth">
                        <label for="email">Email Address</label>
                        <div class="input-auth-wrapper">
                            <span class="input-auth-icon">📧</span>
                            <input
                                type="email"
                                id="email"
                                name="email"
                                placeholder="name@example.com"
                                required>
                        </div>
                    </div>

                    <div class="form-group-auth">
                        <label for="phoneNumber">Phone Number</label>
                        <div class="input-auth-wrapper">
                            <span class="input-auth-icon">📱</span>
                            <input
                                type="tel"
                                id="phoneNumber"
                                name="phoneNumber"
                                placeholder="10-digit number"
                                required>
                        </div>
                    </div>
                </div>

                <div class="form-group-auth full-span">
                    <label for="address">Default Delivery Address</label>
                    <textarea
                        id="address"
                        name="address"
                        placeholder="Enter your complete house/flat and street address"
                        required></textarea>
                </div>

                <div class="form-group-auth full-span">
                    <label for="password">Password</label>
                    <div class="input-auth-wrapper">
                        <span class="input-auth-icon">🔒</span>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create a strong password"
                            required>
                    </div>
                </div>

                <button type="submit" class="auth-submit-btn">
                    <span>Create Account & Order</span>
                    <span>→</span>
                </button>
            </form>

            <div class="auth-footer-nav">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login.jsp">
                    Log In
                </a>
            </div>

            <a href="${pageContext.request.contextPath}/restaurant" class="auth-back-home">
                ← Back to Restaurants
            </a>
        </div>
    </div>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>

</body>
</html>