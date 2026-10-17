<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.food.model.Cart" %>
<%@ page import="com.food.model.CartItem" %>
<%@ page import="com.food.model.User"%>

<%
    User loggedUser = (User) session.getAttribute("user");
    if (loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
        return;
    }
    Cart checkoutCart = (Cart) session.getAttribute("cart");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRAVORA | Secure Checkout</title>

    <!-- External Stylesheets (Zero External JS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkouts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>

<body>

    <!-- MODULAR NAVBAR -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- ================= TOP NAVIGATION BAR ================= -->
    <div style="width: 90%; max-width: 1200px; margin: 110px auto 0; display: flex; align-items: center; justify-content: space-between;">
        <a href="${pageContext.request.contextPath}/cart" class="back-nav-btn">
            <span class="back-arrow">←</span>
            <span>Back to Cart</span>
        </a>
    </div>

    <!-- ================= STEPPER PROGRESS BAR ================= -->
    <div class="stepper-container" style="margin-top: 25px;">
        <div class="stepper-line"></div>

        <div class="step-item completed">
            <div class="step-circle">✓</div>
            <div class="step-title">Cart Review</div>
        </div>

        <div class="step-item active">
            <div class="step-circle">2</div>
            <div class="step-title">Delivery & Address</div>
        </div>

        <div class="step-item">
            <div class="step-circle">3</div>
            <div class="step-title">Payment</div>
        </div>
    </div>

    <%
        if (checkoutCart != null && checkoutCart.getCartItems() != null && !checkoutCart.getCartItems().isEmpty()) {
    %>

    <!-- CHECKOUT FORM POSTS TO /checkout CONTROLLER -->
    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <main class="checkout-page-layout">
            <!-- ================= LEFT COLUMN: ADDRESS & PAYMENT ================= -->
            <div>
                <!-- CARD 1: DELIVERY ADDRESS -->
                <div class="checkout-box">
                    <div class="checkout-box-header">
                        <span class="box-icon-pill">📍</span>
                        <h2>Delivery Details</h2>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">Contact Name</label>
                            <input
                                type="text"
                                id="name"
                                name="name"
                                value="<%= (loggedUser != null && loggedUser.getName() != null) ? loggedUser.getName() : "" %>"
                                placeholder="Enter your full name"
                                required>
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber">Phone Number</label>
                            <input
                                type="tel"
                                id="phoneNumber"
                                name="phoneNumber"
                                value="<%= (loggedUser != null && loggedUser.getPhoneNumber() != null) ? loggedUser.getPhoneNumber() : "" %>"
                                placeholder="10-digit mobile number"
                                required>
                        </div>

                        <div class="form-group full-width">
                            <label for="address">Delivery Address</label>
                            <textarea
                                id="address"
                                name="address"
                                placeholder="Flat/House No., Building Name, Street & Landmark"
                                required><%= (loggedUser != null && loggedUser.getAddress() != null) ? loggedUser.getAddress() : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- CARD 2: PAYMENT METHOD (Swiggy / Zomato Interactive Experience) -->
                <div class="checkout-box">
                    <div class="checkout-box-header">
                        <span class="box-icon-pill">💳</span>
                        <h2>Choose Payment Method</h2>
                    </div>

                    <div class="payment-methods-grid">
                        <!-- ================= 1. UPI PAYMENT ================= -->
                        <div class="payment-method-group active" id="group-upi">
                            <label class="payment-card" for="upi">
                                <div class="payment-card-left">
                                    <input
                                        type="radio"
                                        id="upi"
                                        name="paymentMode"
                                        value="UPI"
                                        checked
                                        onchange="onPaymentModeChange('UPI')">
                                    <div class="payment-card-label">
                                        <span class="payment-card-title">
                                            <span>📱</span> UPI Payment (Instant)
                                        </span>
                                        <span class="payment-card-sub">Google Pay, PhonePe, Paytm, BHIM UPI</span>
                                    </div>
                                </div>
                                <span class="payment-badge instant">Fast & Secure</span>
                            </label>

                            <!-- EXPANDABLE UPI DETAILS -->
                            <div class="payment-subpanel" id="panel-upi">
                                <div class="upi-apps-selector">
                                    <span class="subpanel-title">Choose Preferred UPI App:</span>
                                    <div class="upi-apps-list">
                                        <!-- Google Pay with Official 4-color G Logo -->
                                        <button type="button" class="upi-app-chip active" onclick="selectUpiApp(this, 'Google Pay', '@oksbi')">
                                            <svg class="app-logo-svg" width="22" height="22" viewBox="0 0 48 48">
                                                <path fill="#4285F4" d="M43.6 20.1H42V20H24v8h11.3C33.7 32.7 29.3 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.8 1.1 8 3l5.7-5.7C34.2 6.1 29.4 4 24 4 13 4 4 13 4 24s9 20 20 20 20-9 20-20c0-1.3-.1-2.7-.4-3.9z"/>
                                                <path fill="#34A853" d="M6.3 14.7l6.6 4.8C14.7 16.1 19 14 24 14c3.1 0 5.8 1.1 8 3l5.7-5.7C34.2 6.1 29.4 4 24 4c-7.7 0-14.4 4.3-17.7 10.7z"/>
                                                <path fill="#FBBC05" d="M24 44c5.2 0 10-2 13.6-5.3l-6.3-5.2C29.3 35 26.8 36 24 36c-5.3 0-9.7-3.3-11.3-8l-6.6 5.1C9.4 39.6 16.1 44 24 44z"/>
                                                <path fill="#EA4335" d="M43.6 20.1H42V20H24v8h11.3c-.8 2.2-2.2 4.1-4 5.5l6.3 5.2C41.4 35.2 44 30 44 24c0-1.3-.1-2.7-.4-3.9z"/>
                                            </svg>
                                            <span>Google Pay</span>
                                        </button>

                                        <!-- PhonePe with Official Purple Circle Logo -->
                                        <button type="button" class="upi-app-chip" onclick="selectUpiApp(this, 'PhonePe', '@ybl')">
                                            <svg class="app-logo-svg" width="22" height="22" viewBox="0 0 48 48" fill="none">
                                                <circle cx="24" cy="24" r="22" fill="#5F259F"/>
                                                <path d="M26.8 14H19.5c-1.1 0-2 .9-2 2v18c0 .6.4 1 1 1s1-.4 1-1v-6.5h7.3c4.7 0 8.2-3.3 8.2-7.8 0-4.4-3.5-7.7-8.2-7.7zm0 11.5H19.5V18h7.3c2.4 0 4.2 1.6 4.2 3.7 0 2.2-1.8 3.8-4.2 3.8z" fill="#FFFFFF"/>
                                                <path d="M28.5 27.5l-6.2 8.8c-.3.4-.2 1 .2 1.3.4.3 1 .2 1.3-.2l6.8-9.7c.3-.4.2-1-.2-1.3-.4-.3-1-.1-1.9 1.1z" fill="#FFFFFF"/>
                                            </svg>
                                            <span>PhonePe</span>
                                        </button>

                                        <!-- Paytm with Official Dual Tone Logo -->
                                        <button type="button" class="upi-app-chip" onclick="selectUpiApp(this, 'Paytm', '@paytm')">
                                            <svg class="app-logo-svg" width="22" height="22" viewBox="0 0 32 32">
                                                <rect width="32" height="32" rx="6" fill="#002E6E"/>
                                                <path d="M6 10h10v3h-3.5v9h-3v-9H6v-3z" fill="#00BAF2"/>
                                                <path d="M18 10h3v12h-3v-12z" fill="#00BAF2"/>
                                                <circle cx="19.5" cy="7" r="1.5" fill="#00BAF2"/>
                                            </svg>
                                            <span>Paytm</span>
                                        </button>

                                        <!-- BHIM UPI with Official Tri-color Icon -->
                                        <button type="button" class="upi-app-chip" onclick="selectUpiApp(this, 'BHIM', '@upi')">
                                            <svg class="app-logo-svg" width="22" height="22" viewBox="0 0 32 32" fill="none">
                                                <rect width="32" height="32" rx="6" fill="#00796B"/>
                                                <path d="M11 8l7 8-7 8" stroke="#FFFFFF" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                                                <path d="M16 8l7 8-7 8" stroke="#80CBC4" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                                            </svg>
                                            <span>BHIM UPI</span>
                                        </button>
                                    </div>
                                </div>

                                <div class="upi-id-input-box">
                                    <label for="upiId">Or Enter Custom UPI ID / VPA</label>
                                    <div class="upi-input-wrapper">
                                        <input
                                            type="text"
                                            id="upiId"
                                            name="upiId"
                                            placeholder="e.g. mobileNumber@upi or yourname@okhdfcbank"
                                            value="">
                                        <button type="button" class="upi-verify-btn" onclick="verifyUpiId()">Verify</button>
                                    </div>
                                    <span class="upi-hint" id="upiHintText">⚡ Payment request will be sent to your selected UPI app</span>
                                </div>
                            </div>
                        </div>

                        <!-- ================= 2. CREDIT / DEBIT CARD (NEW) ================= -->
                        <div class="payment-method-group" id="group-card">
                            <label class="payment-card" for="card">
                                <div class="payment-card-left">
                                    <input
                                        type="radio"
                                        id="card"
                                        name="paymentMode"
                                        value="CARD"
                                        onchange="onPaymentModeChange('CARD')">
                                    <div class="payment-card-label">
                                        <span class="payment-card-title">
                                            <span>💳</span> Credit / Debit Card
                                        </span>
                                        <span class="payment-card-sub">Visa, MasterCard, RuPay & Diners</span>
                                    </div>
                                </div>
                                <span class="payment-badge card-badge">Offers Available</span>
                            </label>

                            <!-- EXPANDABLE CARD DETAILS -->
                            <div class="payment-subpanel" id="panel-card" style="display: none;">
                                <div class="card-brand-bar">
                                    <span class="subpanel-title">Accepted Cards:</span>
                                    <div class="card-icons-inline">
                                        <!-- VISA Brand Logo -->
                                        <span class="card-brand-pill visa" id="brand-visa">
                                            <svg width="34" height="20" viewBox="0 0 60 36" fill="none">
                                                <rect width="60" height="36" rx="4" fill="#1A1F71"/>
                                                <text x="50%" y="64%" dominant-baseline="middle" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-weight="900" font-style="italic" font-size="20" fill="#FFFFFF" letter-spacing="1">VISA</text>
                                            </svg>
                                        </span>

                                        <!-- Mastercard Brand Logo -->
                                        <span class="card-brand-pill mc" id="brand-mc">
                                            <svg width="34" height="20" viewBox="0 0 60 36" fill="none">
                                                <rect width="60" height="36" rx="4" fill="#222222"/>
                                                <circle cx="23" cy="18" r="11" fill="#EB001B"/>
                                                <circle cx="37" cy="18" r="11" fill="#F79E1B" fill-opacity="0.9"/>
                                            </svg>
                                        </span>

                                        <!-- RuPay Brand Logo -->
                                        <span class="card-brand-pill rupay" id="brand-rupay">
                                            <svg width="44" height="20" viewBox="0 0 70 36" fill="none">
                                                <rect width="70" height="36" rx="4" fill="#FFFFFF" stroke="#CBD5E1"/>
                                                <text x="30" y="62%" dominant-baseline="middle" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-weight="900" font-size="13" fill="#097939">RuPay</text>
                                                <path d="M52 11l5 7-5 7" stroke="#FF5400" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                                                <path d="M57 11l5 7-5 7" stroke="#0079C1" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                                            </svg>
                                        </span>

                                        <!-- AMEX Brand Logo -->
                                        <span class="card-brand-pill amex" id="brand-amex">
                                            <svg width="34" height="20" viewBox="0 0 60 36" fill="none">
                                                <rect width="60" height="36" rx="4" fill="#006FCF"/>
                                                <text x="50%" y="64%" dominant-baseline="middle" text-anchor="middle" font-family="'Helvetica Neue', Arial, sans-serif" font-weight="900" font-size="12" fill="#FFFFFF" letter-spacing="1">AMEX</text>
                                            </svg>
                                        </span>
                                    </div>
                                </div>

                                <div class="card-form-fields">
                                    <div class="form-group full-width" style="margin-bottom: 14px;">
                                        <label for="cardNumber">Card Number</label>
                                        <div class="card-input-with-icon">
                                            <input
                                                type="text"
                                                id="cardNumber"
                                                name="cardNumber"
                                                placeholder="4532 0123 4567 8910"
                                                maxlength="19"
                                                autocomplete="cc-number">
                                            <span class="card-type-icon" id="detectedCardIcon">💳</span>
                                        </div>
                                    </div>

                                    <div class="form-group full-width" style="margin-bottom: 14px;">
                                        <label for="cardHolderName">Name on Card</label>
                                        <input
                                            type="text"
                                            id="cardHolderName"
                                            name="cardHolderName"
                                            value="<%= (loggedUser != null && loggedUser.getName() != null) ? loggedUser.getName().toUpperCase() : "" %>"
                                            placeholder="e.g. RAHUL SHARMA"
                                            autocomplete="cc-name">
                                    </div>

                                    <div class="card-split-row">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label for="cardExpiry">Valid Thru (MM/YY)</label>
                                            <input
                                                type="text"
                                                id="cardExpiry"
                                                name="cardExpiry"
                                                placeholder="MM / YY"
                                                maxlength="5"
                                                autocomplete="cc-exp">
                                        </div>

                                        <div class="form-group" style="margin-bottom: 0;">
                                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                                <label for="cardCvv" style="margin-bottom: 0;">CVV / CVC</label>
                                                <span class="cvv-tooltip" title="3-digit security code on back of card">ℹ️ 3 digits</span>
                                            </div>
                                            <input
                                                type="password"
                                                id="cardCvv"
                                                name="cardCvv"
                                                placeholder="•••"
                                                maxlength="4"
                                                autocomplete="cc-csc">
                                        </div>
                                    </div>

                                    <div class="save-card-check">
                                        <label>
                                            <input type="checkbox" checked>
                                            <span>🔒 Securely save this card for faster future checkouts</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ================= 3. CASH ON DELIVERY (COD) ================= -->
                        <div class="payment-method-group" id="group-cod">
                            <label class="payment-card" for="cod">
                                <div class="payment-card-left">
                                    <input
                                        type="radio"
                                        id="cod"
                                        name="paymentMode"
                                        value="COD"
                                        onchange="onPaymentModeChange('COD')">
                                    <div class="payment-card-label">
                                        <span class="payment-card-title">
                                            <span>💵</span> Cash on Delivery
                                        </span>
                                        <span class="payment-card-sub">Pay cash or UPI to delivery partner upon arrival</span>
                                    </div>
                                </div>
                                <span class="payment-badge cod">Standard</span>
                            </label>

                            <!-- EXPANDABLE COD DETAILS -->
                            <div class="payment-subpanel" id="panel-cod" style="display: none;">
                                <div class="cod-info-box">
                                    <div class="cod-icon">💵</div>
                                    <div class="cod-text">
                                        <strong>No online transaction needed right now.</strong>
                                        <p>Please keep exact change ready or you can also scan delivery partner's QR code via GPay/PhonePe upon arrival.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ================= RIGHT COLUMN: ORDER SUMMARY ================= -->
            <aside>
                <div class="checkout-summary-card">
                    <h2><span>🧾</span> Order Summary</h2>

                    <!-- ITEMS LIST -->
                    <div class="checkout-items-list">
                        <%
                            for (CartItem item : checkoutCart.getCartItems()) {
                        %>

                        <div class="checkout-item-row">
                            <div>
                                <div class="item-info-title">
                                    <%= item.getMenu().getItemName() %>
                                </div>
                                <div class="item-info-qty">
                                    Qty: <%= item.getQuantity() %> × ₹<%= String.format("%.0f", item.getMenu().getPrice()) %>
                                </div>
                            </div>

                            <div class="item-info-price">
                                ₹<%= String.format("%.0f", item.getMenu().getPrice() * item.getQuantity()) %>
                            </div>
                        </div>

                        <%
                            }
                        %>
                    </div>

                    <!-- BILL DETAILS -->
                    <div class="checkout-bill">
                        <div class="bill-line">
                            <span class="lbl">Items Total</span>
                            <span class="val">₹<%= String.format("%.0f", checkoutCart.getTotalAmount()) %></span>
                        </div>

                        <div class="bill-line free">
                            <span class="lbl">Delivery Partner Fee</span>
                            <span class="val">FREE</span>
                        </div>

                        <div class="bill-line">
                            <span class="lbl">Platform Fee</span>
                            <span class="val">₹5</span>
                        </div>

                        <div class="bill-line total-payable">
                            <span class="lbl">Total Payable</span>
                            <span class="val">₹<%= String.format("%.0f", checkoutCart.getTotalAmount() + 5) %></span>
                        </div>
                    </div>

                    <!-- PLACE ORDER CTA BUTTON (SUBMITS FORM) -->
                    <button type="submit" id="placeOrderBtn" class="place-order-cta-btn">
                        <span id="placeOrderBtnText">Pay ₹<%= String.format("%.0f", checkoutCart.getTotalAmount() + 5) %> via UPI</span>
                        <span>→</span>
                    </button>
                </div>
            </aside>
        </main>
    </form>

    <%
        } else {
    %>

    <!-- EMPTY CART STATE ON CHECKOUT -->
    <div class="checkout-box" style="max-width: 600px; margin: 40px auto 100px; text-align: center; padding: 70px 30px;">
        <h2 style="font-size: 26px; font-weight: 800; margin-bottom: 10px;">Your cart is empty</h2>
        <p style="color: var(--text-secondary); margin-bottom: 24px;">Please add delicious dishes to your cart before proceeding to checkout.</p>
        <a href="${pageContext.request.contextPath}/restaurant" class="checkout-cta-btn" style="display: inline-flex; width: auto; padding: 12px 28px;">
            Explore Restaurants →
        </a>
    </div>

    <%
        }
    %>

    <!-- MODULAR FOOTER -->
    <%@ include file="includes/footer.jsp" %>

    <!-- ================= JAVASCRIPT: INTERACTIVE PAYMENT CONTROLS ================= -->
    <script>
        const totalPayableAmount = "<%= (checkoutCart != null) ? String.format("%.0f", checkoutCart.getTotalAmount() + 5) : "0" %>";

        function onPaymentModeChange(mode) {
            // Remove active from all groups
            document.querySelectorAll('.payment-method-group').forEach(group => {
                group.classList.remove('active');
            });

            // Hide all subpanels
            document.getElementById('panel-upi').style.display = 'none';
            document.getElementById('panel-card').style.display = 'none';
            document.getElementById('panel-cod').style.display = 'none';

            // Show selected panel & activate group
            const btnText = document.getElementById('placeOrderBtnText');

            if (mode === 'UPI') {
                document.getElementById('group-upi').classList.add('active');
                document.getElementById('panel-upi').style.display = 'block';
                if (btnText) btnText.textContent = "Pay ₹" + totalPayableAmount + " via UPI";
            } else if (mode === 'CARD') {
                document.getElementById('group-card').classList.add('active');
                document.getElementById('panel-card').style.display = 'block';
                if (btnText) btnText.textContent = "Pay ₹" + totalPayableAmount + " via Card";
            } else if (mode === 'COD') {
                document.getElementById('group-cod').classList.add('active');
                document.getElementById('panel-cod').style.display = 'block';
                if (btnText) btnText.textContent = "Place Order (COD) ₹" + totalPayableAmount;
            }
        }

        // UPI App Chip Selection
        function selectUpiApp(btn, appName, handle) {
            document.querySelectorAll('.upi-app-chip').forEach(chip => chip.classList.remove('active'));
            btn.classList.add('active');
            const hint = document.getElementById('upiHintText');
            if (hint) {
                hint.textContent = "⚡ Payment request will be sent to your " + appName + " app.";
            }
            const upiInput = document.getElementById('upiId');
            if (upiInput && !upiInput.value.trim()) {
                upiInput.placeholder = "e.g. yourname" + handle;
            }
        }

        function verifyUpiId() {
            const upiInput = document.getElementById('upiId');
            const hint = document.getElementById('upiHintText');
            if (!upiInput.value.trim()) {
                alert("Please enter a valid UPI ID (e.g. mobileNumber@upi or name@oksbi)");
                upiInput.focus();
                return;
            }
            if (hint) {
                hint.style.color = "var(--success-green)";
                hint.innerHTML = "✓ Verified: <strong>" + upiInput.value.trim() + "</strong> (Ready to pay)";
            }
        }

        // Auto-format Card Number with spaces (XXXX XXXX XXXX XXXX) & Brand Detection
        const cardInput = document.getElementById('cardNumber');
        if (cardInput) {
            cardInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '').substring(0, 16);
                let formatted = value.match(/.{1,4}/g)?.join(' ') || value;
                e.target.value = formatted;

                // Detect Brand
                detectCardBrand(value);
            });
        }

        function detectCardBrand(num) {
            const icon = document.getElementById('detectedCardIcon');
            const pills = {
                visa: document.getElementById('brand-visa'),
                mc: document.getElementById('brand-mc'),
                rupay: document.getElementById('brand-rupay'),
                amex: document.getElementById('brand-amex')
            };

            // Reset pills
            Object.values(pills).forEach(p => p && p.classList.remove('active'));

            if (num.startsWith('4')) {
                if (pills.visa) pills.visa.classList.add('active');
                if (icon) icon.textContent = "💳 (Visa)";
            } else if (/^5[1-5]/.test(num) || /^2[2-7]/.test(num)) {
                if (pills.mc) pills.mc.classList.add('active');
                if (icon) icon.textContent = "💳 (Mastercard)";
            } else if (/^(60|65|81|82)/.test(num)) {
                if (pills.rupay) pills.rupay.classList.add('active');
                if (icon) icon.textContent = "💳 (RuPay)";
            } else if (/^3[47]/.test(num)) {
                if (pills.amex) pills.amex.classList.add('active');
                if (icon) icon.textContent = "💳 (AMEX)";
            } else {
                if (icon) icon.textContent = "💳";
            }
        }

        // Auto-format Expiry (MM / YY)
        const expiryInput = document.getElementById('cardExpiry');
        if (expiryInput) {
            expiryInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '').substring(0, 4);
                if (value.length >= 3) {
                    e.target.value = value.substring(0, 2) + '/' + value.substring(2, 4);
                } else {
                    e.target.value = value;
                }
            });
        }

        // CVV Digits only
        const cvvInput = document.getElementById('cardCvv');
        if (cvvInput) {
            cvvInput.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/\D/g, '').substring(0, 4);
            });
        }

        // Form Submit Validation
        const checkoutForm = document.querySelector('form[action$="/checkout"]');
        if (checkoutForm) {
            checkoutForm.addEventListener('submit', function(e) {
                const selectedMode = document.querySelector('input[name="paymentMode"]:checked')?.value;
                if (selectedMode === 'CARD') {
                    const cardNum = document.getElementById('cardNumber')?.value.replace(/\s+/g, '');
                    const cardExp = document.getElementById('cardExpiry')?.value.trim();
                    const cardCvv = document.getElementById('cardCvv')?.value.trim();

                    if (!cardNum || cardNum.length < 15) {
                        e.preventDefault();
                        alert('Please enter a valid 16-digit Card Number.');
                        document.getElementById('cardNumber')?.focus();
                        return;
                    }
                    if (!cardExp || cardExp.length < 5) {
                        e.preventDefault();
                        alert('Please enter a valid card expiry date (MM/YY).');
                        document.getElementById('cardExpiry')?.focus();
                        return;
                    }
                    if (!cardCvv || cardCvv.length < 3) {
                        e.preventDefault();
                        alert('Please enter a valid 3-digit CVV code.');
                        document.getElementById('cardCvv')?.focus();
                        return;
                    }
                }

                // Fire celebration burst on successful submission
                if (window.CravoraConfetti) {
                    window.CravoraConfetti.doubleCannon();
                }
            });
        }
    </script>

    <!-- CRAVORA CELEBRATION CONFETTI ENGINE -->
    <script src="${pageContext.request.contextPath}/js/confetti.js"></script>
</body>

</html>