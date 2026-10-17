<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.food.model.Restaurant"%>
<%@ page import="com.food.model.Cart" %>
<%@ page import="com.food.model.CartItem" %>
<%@ page import="com.food.model.User"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | Restaurants & Food Delivery</title>

    <!-- External Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/restaurants.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>

<body>

    <!-- =====================================================
         VIDEO HERO + FIXED NAVBAR
    ===================================================== -->
    <section class="hero">

        <!-- BACKGROUND FOOD VIDEO -->
        <video
            class="hero-video"
            autoplay
            muted
            loop
            playsinline>
            <source
                src="${pageContext.request.contextPath}/assets/videos/cravora-food-video.mp4"
                type="video/mp4">
            Your browser does not support the video tag.
        </video>

        <!-- MODULAR NAVBAR -->
        <%@ include file="includes/navbar.jsp" %>

        <!-- HERO CONTENT -->
        <div class="hero-content">
            <div class="hero-badge" data-confetti="stars" style="cursor: pointer;" title="Click for celebratory sparkles! ✨">
                ✨ BENGALURU'S PREMIER FOOD DESTINATION • CRAVORA
            </div>

            <h1>
                Good Food.<br>
                <span>Beautifully Delivered.</span>
            </h1>

            <p>
                Discover top-rated restaurants across Bengaluru and explore the finest culinary delights delivered fresh to your doorstep.
            </p>
        </div>

    </section>


    <!-- =====================================================
         RESTAURANTS SECTION
    ===================================================== -->
    <main class="restaurant-section">

        <!-- ATTRACTIVE MODERN SECTION HEADER (CLEAN TYPOGRAPHY) -->
        <div class="section-heading-container">
            <div class="heading-badge" data-confetti="food" style="cursor: pointer;" title="Click for food vibes! 🍕">
                <span class="pulse-dot"></span>
                <span>🔥 TOP CURATED SPOTS • BENGALURU</span>
            </div>

            <div class="heading-text">
                <h2 class="main-title">
                    Discover & Order From <span class="gradient-text">Top Rated Eateries</span>
                </h2>
                <p class="subtitle">
                    Explore handpicked culinary spots, gourmet delicacies & authentic regional kitchens delivering fresh in Bengaluru.
                </p>
            </div>
        </div>

        <%
            List<Restaurant> restaurants =
                (List<Restaurant>) request.getAttribute("restaurants");

            if (restaurants != null && !restaurants.isEmpty()) {
        %>

        <div class="restaurant-grid">

            <%
                for (Restaurant restaurant : restaurants) {
            %>

            <!-- RESTAURANT CARD -->
            <div class="restaurant-card">

                <!-- IMAGE & FLOATING BADGES -->
                <div class="image-container">
                    <img
                        src="<%= restaurant.getImagePath() %>"
                        alt="<%= restaurant.getName() %>"
                        class="restaurant-image"
                        loading="lazy">

                    <!-- LOCATION BADGE -->
                    <div class="location-badge">
                        📍 <%= restaurant.getAddress() %>
                    </div>

                    <!-- RATING BADGE -->
                    <div class="rating-badge">
                        <span class="star-icon">★</span>
                        <span><%= restaurant.getRating() %></span>
                    </div>
                </div>

                <!-- CONTENT -->
                <div class="restaurant-content">
                    <!-- NAME -->
                    <h2 class="restaurant-name">
                        <%= restaurant.getName() %>
                    </h2>

                    <!-- CUISINE -->
                    <div class="cuisine">
                        <%= restaurant.getCuisineType() %>
                    </div>

                    <!-- DETAILS -->
                    <div class="restaurant-details">
                        <!-- ADDRESS -->
                        <div class="detail">
                            <span class="detail-icon">📍</span>
                            <span><%= restaurant.getAddress() %></span>
                        </div>

                        <!-- PHONE -->
                        <div class="detail">
                            <span class="detail-icon">📞</span>
                            <span><%= restaurant.getPhoneNumber() %></span>
                        </div>

                        <!-- OPEN / CLOSED STATUS -->
                        <div class="detail">
                            <span class="detail-icon">●</span>
                            <span class="<%= restaurant.isActive() ? "open-status" : "closed-status" %>">
                                <%= restaurant.isActive() ? "Open Now" : "Currently Closed" %>
                            </span>
                        </div>
                    </div>

                    <!-- DIVIDER -->
                    <hr class="divider">

                    <!-- CARD BOTTOM -->
                    <div class="card-bottom">
                        <span class="delivery-time">
                            ⚡ <%= restaurant.getDeliveryTime() %>
                        </span>

                        <a href="menu?restaurantId=<%= restaurant.getRestaurantId() %>" class="view-menu">
                            View Menu →
                        </a>
                    </div>
                </div>

            </div>

            <%
                }
            %>

        </div>

        <%
            } else {
        %>

        <!-- NO DATA STATE -->
        <div class="no-restaurants">
            <h2>No restaurants available right now</h2>
            <p>Please check back later or refresh your search.</p>
        </div>

        <%
            }
        %>

    </main>

    <!-- MODULAR FOOTER -->
    <%@ include file="includes/footer.jsp" %>

    <!-- NAVBAR SCROLL EFFECT SCRIPT -->
    <script>
        window.addEventListener("scroll", function () {
            const navbar = document.getElementById("navbar");
            if (navbar) {
                if (window.scrollY > 50) {
                    navbar.classList.add("scrolled");
                } else {
                    navbar.classList.remove("scrolled");
                }
            }
        });
    </script>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>

</body>

</html>