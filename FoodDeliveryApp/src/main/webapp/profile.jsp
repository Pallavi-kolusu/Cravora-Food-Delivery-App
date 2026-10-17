<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.food.model.User" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=profile");
        return;
    }

    // Flash messages
    String successMsg = (String) session.getAttribute("profileSuccess");
    String errorMsg = (String) session.getAttribute("profileError");
    if (successMsg != null) {
        session.removeAttribute("profileSuccess");
    }
    if (errorMsg != null) {
        session.removeAttribute("profileError");
    }

    // Stats
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    if (totalOrders == null) {
        totalOrders = 0;
    }
    Double totalSpent = (Double) request.getAttribute("totalSpent");
    if (totalSpent == null) {
        totalSpent = 0.0;
    }

    // Formatted Initials
    String name = loggedUser.getName() != null ? loggedUser.getName().trim() : "User";
    String initials = "U";
    if (!name.isEmpty()) {
        String[] parts = name.split("\\s+");
        if (parts.length >= 2) {
            initials = ("" + parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
        } else {
            initials = ("" + name.charAt(0)).toUpperCase();
        }
    }

    // Member Since Date
    String memberSince = "2026";
    Timestamp createDate = loggedUser.getCreateDate();
    if (createDate != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("MMM yyyy");
        memberSince = sdf.format(createDate);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | My Profile</title>

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>
<body>

    <!-- MODULAR NAVBAR -->
    <%@ include file="includes/navbar.jsp" %>

    <main class="profile-page-container">

        <!-- SUCCESS & ERROR FLASH ALERTS -->
        <% if (successMsg != null) { %>
            <div class="alert-banner success">
                <span>✅</span>
                <span><%= successMsg %></span>
            </div>
        <% } %>

        <% if (errorMsg != null) { %>
            <div class="alert-banner error">
                <span>⚠️</span>
                <span><%= errorMsg %></span>
            </div>
        <% } %>

        <!-- =====================================================
             PROFILE HERO BANNER
        ===================================================== -->
        <section class="profile-hero-card">
            <div class="profile-hero-content">
                <div class="profile-user-left">
                    <div class="profile-avatar-wrapper">
                        <div class="profile-avatar-circle">
                            <%= initials %>
                        </div>
                        <span class="avatar-online-dot" title="Active Account"></span>
                    </div>

                    <div class="profile-user-meta">
                        <h1>
                            <%= loggedUser.getName() %>
                            <span class="profile-role-badge">⭐ <%= loggedUser.getRole() != null ? loggedUser.getRole() : "CUSTOMER" %></span>
                        </h1>
                        <div class="profile-user-handle">
                            @<%= loggedUser.getUsername() != null ? loggedUser.getUsername() : "user" %>
                        </div>
                        <div class="profile-user-details-pills">
                            <span class="meta-pill">📧 <%= loggedUser.getEmail() %></span>
                            <span class="meta-pill">📱 <%= loggedUser.getPhoneNumber() != null ? loggedUser.getPhoneNumber() : "Not set" %></span>
                            <span class="meta-pill">📅 Member since <%= memberSince %></span>
                        </div>
                    </div>
                </div>

                <div class="profile-hero-actions">
                    <a href="${pageContext.request.contextPath}/orders" class="hero-action-btn btn-orders">
                        <span>📦 My Orders</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="hero-action-btn btn-logout">
                        <span>🚪 Log Out</span>
                    </a>
                </div>
            </div>
        </section>

        <!-- =====================================================
             QUICK STATS SUMMARY CARDS
        ===================================================== -->
        <section class="profile-stats-grid">
            <div class="stat-card">
                <div class="stat-icon-pill orange">
                    📦
                </div>
                <div class="stat-content">
                    <span class="stat-val"><%= totalOrders %></span>
                    <span class="stat-lbl">Orders Placed</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon-pill green">
                    💳
                </div>
                <div class="stat-content">
                    <span class="stat-val">₹<%= String.format("%.0f", totalSpent) %></span>
                    <span class="stat-lbl">Total Spent on Food</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon-pill blue">
                    📍
                </div>
                <div class="stat-content">
                    <span class="stat-val">1 Saved</span>
                    <span class="stat-lbl">Delivery Location</span>
                </div>
            </div>
        </section>

        <!-- =====================================================
             MAIN PROFILE CONTENT (2-COLUMN LAYOUT)
        ===================================================== -->
        <div class="profile-content-layout">

            <!-- LEFT COLUMN: EDIT DETAILS & SECURITY -->
            <div class="profile-main-forms">

                <!-- 1. PERSONAL INFORMATION CARD -->
                <div class="profile-card-box">
                    <div class="card-box-header">
                        <div class="card-box-header-title">
                            <span class="header-icon">👤</span>
                            <div>
                                <h2>Personal Information</h2>
                                <p>Update your personal info and delivery preferences</p>
                            </div>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="updateProfile">

                        <div class="profile-form-grid">
                            <div class="form-field-group">
                                <label for="name">Full Name</label>
                                <div class="input-with-icon">
                                    <span class="field-icon">👤</span>
                                    <input
                                        type="text"
                                        id="name"
                                        name="name"
                                        value="<%= loggedUser.getName() != null ? loggedUser.getName() : "" %>"
                                        placeholder="Your full name"
                                        required>
                                </div>
                            </div>

                            <div class="form-field-group">
                                <label for="username">Username</label>
                                <div class="input-with-icon">
                                    <span class="field-icon">🏷️</span>
                                    <input
                                        type="text"
                                        id="username"
                                        name="username"
                                        value="<%= loggedUser.getUsername() != null ? loggedUser.getUsername() : "" %>"
                                        placeholder="Your username"
                                        required>
                                </div>
                            </div>
                        </div>

                        <div class="profile-form-grid">
                            <div class="form-field-group">
                                <label for="email">Email Address (Read-only)</label>
                                <div class="input-with-icon">
                                    <span class="field-icon">📧</span>
                                    <input
                                        type="email"
                                        id="email"
                                        name="email"
                                        value="<%= loggedUser.getEmail() != null ? loggedUser.getEmail() : "" %>"
                                        readonly
                                        title="Email is linked to your account ID">
                                </div>
                            </div>

                            <div class="form-field-group">
                                <label for="phoneNumber">Phone Number</label>
                                <div class="input-with-icon">
                                    <span class="field-icon">📱</span>
                                    <input
                                        type="tel"
                                        id="phoneNumber"
                                        name="phoneNumber"
                                        value="<%= loggedUser.getPhoneNumber() != null ? loggedUser.getPhoneNumber() : "" %>"
                                        placeholder="10-digit mobile number"
                                        required>
                                </div>
                            </div>
                        </div>

                        <div class="form-field-group full-span">
                            <label for="address">Default Delivery Address</label>
                            <textarea
                                id="address"
                                name="address"
                                placeholder="Enter your full street address, apartment, and landmark"
                                required><%= loggedUser.getAddress() != null ? loggedUser.getAddress() : "" %></textarea>
                        </div>

                        <button type="submit" class="btn-submit-profile">
                            <span>💾 Save Profile Changes</span>
                        </button>
                    </form>
                </div>

                <!-- 2. SECURITY / CHANGE PASSWORD CARD -->
                <div class="profile-card-box">
                    <div class="card-box-header">
                        <div class="card-box-header-title">
                            <span class="header-icon">🔒</span>
                            <div>
                                <h2>Security & Password</h2>
                                <p>Manage your account password to keep your profile secure</p>
                            </div>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="changePassword">

                        <div class="form-field-group">
                            <label for="currentPassword">Current Password</label>
                            <div class="input-with-icon">
                                <span class="field-icon">🔑</span>
                                <input
                                    type="password"
                                    id="currentPassword"
                                    name="currentPassword"
                                    placeholder="Enter your current password"
                                    required>
                            </div>
                        </div>

                        <div class="profile-form-grid">
                            <div class="form-field-group">
                                <label for="newPassword">New Password</label>
                                <div class="input-with-icon">
                                    <span class="field-icon">🔒</span>
                                    <input
                                        type="password"
                                        id="newPassword"
                                        name="newPassword"
                                        placeholder="Enter new password"
                                        required>
                                </div>
                            </div>

                            <div class="form-field-group">
                                <label for="confirmPassword">Confirm New Password</label>
                                <div class="input-with-icon">
                                    <span class="field-icon">🔒</span>
                                    <input
                                        type="password"
                                        id="confirmPassword"
                                        name="confirmPassword"
                                        placeholder="Repeat new password"
                                        required>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn-submit-profile">
                            <span>🔐 Update Password</span>
                        </button>
                    </form>
                </div>

            </div>

            <!-- RIGHT COLUMN: QUICK SHORTCUTS & PERKS -->
            <aside class="profile-sidebar">

                <!-- QUICK SHORTCUTS -->
                <div class="profile-card-box">
                    <div class="card-box-header">
                        <div class="card-box-header-title">
                            <span class="header-icon">⚡</span>
                            <div>
                                <h2>Quick Actions</h2>
                                <p>Navigate your CRAVORA account</p>
                            </div>
                        </div>
                    </div>

                    <div class="quick-links-list">
                        <a href="${pageContext.request.contextPath}/orders" class="quick-link-item">
                            <div class="quick-link-item-left">
                                <span class="link-icon">📦</span>
                                <span>Past Orders History</span>
                            </div>
                            <span class="arrow">→</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/cart" class="quick-link-item">
                            <div class="quick-link-item-left">
                                <span class="link-icon">🛒</span>
                                <span>My Food Cart</span>
                            </div>
                            <span class="arrow">→</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/restaurant" class="quick-link-item">
                            <div class="quick-link-item-left">
                                <span class="link-icon">🍽️</span>
                                <span>Browse Restaurants</span>
                            </div>
                            <span class="arrow">→</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/logout" class="quick-link-item" style="color: var(--danger-red);">
                            <div class="quick-link-item-left">
                                <span class="link-icon">🚪</span>
                                <span>Log Out Account</span>
                            </div>
                            <span class="arrow" style="color: var(--danger-red);">→</span>
                        </a>
                    </div>
                </div>

                <!-- SAVED ADDRESS PREVIEW -->
                <div class="profile-card-box">
                    <div class="card-box-header">
                        <div class="card-box-header-title">
                            <span class="header-icon">📍</span>
                            <div>
                                <h2>Primary Delivery Address</h2>
                            </div>
                        </div>
                    </div>

                    <div class="address-preview-box">
                        <p>
                            <%= (loggedUser.getAddress() != null && !loggedUser.getAddress().trim().isEmpty()) 
                                ? loggedUser.getAddress() 
                                : "No default address saved yet. Update it in the personal information form above." %>
                        </p>
                    </div>
                </div>

                <!-- CRAVORA GOURMET CLUB PERKS -->
                <div class="tier-card" data-confetti="stars" style="cursor: pointer;" title="Click for VIP Club Sparkles! ✨">
                    <div class="tier-badge-title">
                        <span>✨</span>
                        <span>Cravora Foodie Club</span>
                    </div>
                    <p>
                        Enjoy priority kitchen delivery, special gourmet discounts, and fast customer assistance on every single order!
                    </p>
                </div>

            </aside>

        </div>

    </main>

    <!-- MODULAR FOOTER -->
    <%@ include file="includes/footer.jsp" %>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>
    <% if (successMsg != null) { %>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (window.CravoraConfetti) {
                window.CravoraConfetti.profileSuccess();
            }
        });
    </script>
    <% } %>

</body>
</html>
