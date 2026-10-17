<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | Login</title>

    <!-- External Stylesheets (Zero External JS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>

<body class="auth-page">

    <div class="auth-split-wrapper">
        <!-- ================= LEFT: CULINARY FOOD BANNER ================= -->
        <div class="auth-food-banner">
            <a href="${pageContext.request.contextPath}/restaurant" class="banner-brand">
                <span>🍕</span>
                <span class="logo-text">CRAVORA</span>
            </a>

            <div class="banner-middle">
                <span class="banner-pill-tag" data-confetti="food" style="cursor: pointer;" title="Click for delicious vibes! 🍕">✨ Hot & Fresh Delivery</span>
                <h2>Craving Something Delicious?</h2>
                <p>Order gourmet meals from Bengaluru's top restaurants and enjoy fast doorstep delivery.</p>
            </div>

            <div class="banner-trust-badge" data-confetti="stars" style="cursor: pointer;" title="Click for 5-star sparkles! ⭐">
                <span class="trust-stars">★★★★★</span>
                <span class="trust-text">Loved by 50,000+ foodies</span>
            </div>
        </div>

        <!-- ================= RIGHT: LOGIN FORM ================= -->
        <div class="auth-form-container">
            <div class="auth-form-header">
                <h1>Welcome Back</h1>
                <p>Please enter your credentials to access your account.</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                String logout = request.getParameter("logout");
                if (error != null) {
            %>
                <div class="error-message">
                    <span>⚠️</span>
                    <span><%= error %></span>
                </div>
            <%
                } else if ("true".equals(logout)) {
            %>
                <div class="success-message">
                    <span>👋</span>
                    <span>You have been successfully logged out. See you again!</span>
                </div>
            <%
                }
            %>

            <!-- LOGIN FORM -->
            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden"
                       name="redirect"
                       value="<%= request.getParameter("redirect") != null ? request.getParameter("redirect") : "" %>">

                <div class="form-group-auth">
                    <label for="email">Email Address</label>
                    <div class="input-auth-wrapper">
                        <span class="input-auth-icon">📧</span>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="name@example.com"
                            autocomplete="email"
                            required>
                    </div>
                </div>

                <div class="form-group-auth">
                    <label for="password">Password</label>
                    <div class="input-auth-wrapper">
                        <span class="input-auth-icon">🔒</span>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required>
                    </div>
                </div>

                <button type="submit" class="auth-submit-btn">
                    <span>Log In to CRAVORA</span>
                    <span>→</span>
                </button>
            </form>

            <div class="auth-footer-nav">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/signup.jsp">
                    Sign Up Now
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