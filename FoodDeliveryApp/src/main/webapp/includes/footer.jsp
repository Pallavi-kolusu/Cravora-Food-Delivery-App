<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer">
    <div class="footer-container">
        <!-- BRAND COLUMN -->
        <div class="footer-brand">
            <div class="footer-logo">
                <span class="logo-icon">🍕</span>
                <span class="logo-text">CRAVORA</span>
            </div>
            <p class="footer-tagline">
                Authentic food delivered hot & fresh to your doorstep across Bengaluru. Discover top restaurants and delectable meals.
            </p>
            <div class="footer-socials">
                <a href="#" class="social-icon" aria-label="Instagram">📸</a>
                <a href="#" class="social-icon" aria-label="Twitter">🐦</a>
                <a href="#" class="social-icon" aria-label="Facebook">📘</a>
            </div>
        </div>

        <!-- LINKS COLUMNS -->
        <div class="footer-links-grid">
            <div class="footer-col">
                <h4 class="footer-title">Company</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/restaurant">About Us</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#">Team</a></li>
                    <li><a href="#">CRAVORA One</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4 class="footer-title">Contact</h4>
                <ul class="footer-links">
                    <li><a href="#">Help & Support</a></li>
                    <li><a href="#">Partner with us</a></li>
                    <li><a href="#">Ride with us</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4 class="footer-title">Legal</h4>
                <ul class="footer-links">
                    <li><a href="#">Terms & Conditions</a></li>
                    <li><a href="#">Refund & Cancellation</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Cookie Policy</a></li>
                </ul>
            </div>
        </div>
    </div>

    <!-- BOTTOM COPYRIGHT -->
    <div class="footer-bottom">
        <p>&copy; <%= java.time.Year.now().getValue() %> CRAVORA Technologies Inc. All rights reserved.</p>
        <p>Crafted with ❤️ for food lovers</p>
    </div>
</footer>
