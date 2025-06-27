<?php
session_start();
include '../config_admin/db_admin.php'; 

// SSLCOMMERZ sandbox credentials
$store_id = 'your_sandbox_store_id'; // Replace with your sandbox Store ID
$store_passwd = 'your_sandbox_store_password'; // Replace with your sandbox Store Password
$api_domain = 'https://sandbox.sslcommerz.com';
$api_url = $api_domain . '/gwprocess/v4/api.php';

// Check if user is logged in
$user_id = $_SESSION['user_id'] ?? null;

// Initialize variables
$cart_items = [];
$cart_subtotal = 0;
$cart_vat = 0;
$cart_total = 0;
$vat_rate = 0.15; // 15% VAT
$errors = [];

// Fetch cart items
if ($user_id) {
    try {
        // Get user's cart
        $stmt = $pdo->prepare("SELECT cart_id FROM Cart WHERE user_id = ?");
        $stmt->execute([$user_id]);
        $cart = $stmt->fetch();

        if ($cart) {
            // Fetch cart items with product details
            $stmt = $pdo->prepare("
                SELECT ci.product_id, ci.quantity, p.display_name, p.base_price, p.discount_price, p.image_url, p.stock_quantity
                FROM CartItems ci
                JOIN Products p ON ci.product_id = p.product_id
                WHERE ci.cart_id = ?
            ");
            $stmt->execute([$cart['cart_id']]);
            $cart_items = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Calculate totals and validate stock
            foreach ($cart_items as $item) {
                if ($item['quantity'] > $item['stock_quantity']) {
                    $errors[] = "Insufficient stock for {$item['display_name']}. Available: {$item['stock_quantity']}";
                }
                $price = $item['discount_price'] ?? $item['base_price'];
                $cart_subtotal += $price * $item['quantity'];
            }
            $cart_vat = round($cart_subtotal * $vat_rate, 2);
            $cart_total = $cart_subtotal + $cart_vat;
        }
    } catch (PDOException $e) {
        error_log("Checkout Error: " . $e->getMessage());
        $errors[] = "Failed to load cart: " . $e->getMessage();
    }
}

// Process form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && empty($errors)) {
    // Validate form inputs
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $phone = trim($_POST['phone_number'] ?? '');
    $shipping_address = trim($_POST['shipping_address']);
    $billing_address = trim($_POST['billing_address']) ?: $shipping_address;
    $payment_method = $_POST['payment_method'] ?? '';
    $notes = trim($_POST['notes'] ?? '');

    // Validation
    if (!$user_id) {
        if (empty($name)) $errors[] = "Name is required";
        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = "Valid email is required";
        if (empty($phone)) $errors[] = "Phone number is required";
    }
    if (empty($shipping_address)) $errors[] = "Shipping address is required";
    if (!in_array($payment_method, ['cash', 'bkash', 'nagad', 'card', 'bank_transfer'])) {
        $errors[] = "Invalid payment method";
    }

    if (empty($cart_items)) {
        $errors[] = "Your cart is empty";
    }

    if (empty($errors)) {
        try {
            $pdo->beginTransaction();

            // Create or update customer
            $customer_id = null;
            if ($user_id) {
                $stmt = $pdo->prepare("SELECT customer_id, full_name, phone_number FROM Customers WHERE user_id = ?");
                $stmt->execute([$user_id]);
                $customer = $stmt->fetch();
                if ($customer) {
                    $customer_id = $customer['customer_id'];
                    $name = $customer['full_name'];
                    $phone = $customer['phone_number'];
                }
            } else {
                $stmt = $pdo->prepare("
                    INSERT INTO Customers (user_id, full_name, phone_number, shipping_address, billing_address)
                    VALUES (NULL, ?, ?, ?, ?)
                ");
                $stmt->execute([$name, $phone, $shipping_address, $billing_address]);
                $customer_id = $pdo->lastInsertId();
            }

            // Create temporary order
            $tran_id = uniqid('order_'); // Unique transaction ID
            $stmt = $pdo->prepare("
                INSERT INTO Orders (
                    customer_id, shipping_address, billing_address,
                    subtotal, vat_amount, total_amount,
                    payment_method, status, notes
                ) VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', ?)
            ");
            $stmt->execute([
                $customer_id, $shipping_address, $billing_address,
                $cart_subtotal, $cart_vat, $cart_total,
                $payment_method, $notes
            ]);
            $order_id = $pdo->lastInsertId();

            // Save order items
            foreach ($cart_items as $item) {
                $price = $item['discount_price'] ?? $item['base_price'];
                $discount_percentage = $item['discount_price'] ?
                    (($item['base_price'] - $item['discount_price']) / $item['base_price']) * 100 : 0;

                $stmt = $pdo->prepare("
                    INSERT INTO OrderDetails (
                        order_id, product_id, quantity, unit_price, discount_percentage
                    ) VALUES (?, ?, ?, ?, ?)
                ");
                $stmt->execute([$order_id, $item['product_id'], $item['quantity'], $price, $discount_percentage]);
            }

            // Commit transaction
            $pdo->commit();

            // Initiate SSLCOMMERZ payment
            if ($payment_method !== 'cash') {
                $post_data = [
                    'store_id' => $store_id,
                    'store_passwd' => $store_passwd,
                    'total_amount' => $cart_total,
                    'currency' => 'BDT', // Use BDT as per your project
                    'tran_id' => $tran_id,
                    'success_url' => 'http://yourdomain.com/success.php',
                    'fail_url' => 'http://yourdomain.com/fail.php',
                    'cancel_url' => 'http://yourdomain.com/cancel.php',
                    'ipn_url' => 'http://yourdomain.com/ipn.php',
                    'cus_name' => $name,
                    'cus_email' => $email,
                    'cus_add1' => $shipping_address,
                    'cus_add2' => $billing_address,
                    'cus_city' => 'Dhaka', // Adjust based on your needs
                    'cus_state' => 'Dhaka',
                    'cus_postcode' => '1000',
                    'cus_country' => 'Bangladesh',
                    'cus_phone' => $phone,
                    'cus_fax' => $phone,
                    'ship_name' => $name,
                    'ship_add1' => $shipping_address,
                    'ship_add2' => $billing_address,
                    'ship_city' => 'Dhaka',
                    'ship_state' => 'Dhaka',
                    'ship_postcode' => '1000',
                    'ship_country' => 'Bangladesh',
                    'shipping_method' => 'Courier',
                    'product_name' => 'Bricks Order',
                    'product_category' => 'Construction',
                    'product_profile' => 'general',
                    'value_a' => 'order_' . $order_id,
                    'value_b' => 'brick_field',
                    'value_c' => $customer_id,
                    'value_d' => $payment_method
                ];

                // Initiate payment with cURL
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $api_url);
                curl_setopt($ch, CURLOPT_POST, 1);
                curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post_data));
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // Disable in sandbox; enable in production
                $response = curl_exec($ch);
                $err = curl_error($ch);
                curl_close($ch);

                if ($err) {
                    $errors[] = "Payment initiation failed: " . $err;
                } else {
                    $response_data = json_decode($response, true);
                    if (isset($response_data['GatewayPageURL'])) {
                        // Store order_id and tran_id in session for success.php
                        $_SESSION['order_id'] = $order_id;
                        $_SESSION['tran_id'] = $tran_id;
                        // Redirect to SSLCOMMERZ payment page
                        header("Location: " . $response_data['GatewayPageURL']);
                        exit;
                    } else {
                        $errors[] = "Failed to initiate payment: " . ($response_data['failedreason'] ?? 'Unknown error');
                    }
                }
            } else {
                // For cash on delivery, redirect to order.php
                header("Location: order.php?order_id=$order_id");
                exit;
            }
        } catch (PDOException $e) {
            $pdo->rollBack();
            error_log("Checkout Error: " . $e->getMessage());
            $errors[] = "Failed to process order: " . $e->getMessage();
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Brick Field</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>Brick Field E-Commerce</h1>
        <nav>
            <ul>
                <li><a href="index.php">Home</a></li>
                <li><a href="products.php">Products</a></li>
                <li><a href="cart.php">Cart<span id="cart-count">0</span></a></li>
                <li><a href="dashboard.php">My Account</a></li>
                <li><a href="logout.php">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main class="container checkout-page">
        <h1>Checkout</h1>

        <?php if (empty($cart_items)): ?>
            <div class="error-message">
                <p>Your cart is empty. Please add items to proceed.</p>
                <a href="products.php" class="btn">Continue Shopping</a>
            </div>
        <?php else: ?>
            <div class="checkout-grid">
                <div class="checkout-form">
                    <h2>Billing & Shipping</h2>

                    <?php if (!empty($errors)): ?>
                        <div class="error-message">
                            <ul>
                                <?php foreach ($errors as $error): ?>
                                    <li><?= htmlspecialchars($error) ?></li>
                                <?php endforeach; ?>
                            </ul>
                        </div>
                    <?php endif; ?>

                    <form method="POST" action="cheekout.php">
                        <?php if (!$user_id): ?>
                            <div class="form-group">
                                <label for="name">Full Name*</label>
                                <input type="text" id="name" name="name" required
                                       value="<?= isset($_POST['name']) ? htmlspecialchars($_POST['name']) : '' ?>">
                            </div>
                            <div class="form-group">
                                <label for="email">Email*</label>
                                <input type="email" id="email" name="email" required
                                       value="<?= isset($_POST['email']) ? htmlspecialchars($_POST['email']) : '' ?>">
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone*</label>
                                <input type="tel" id="phone" name="phone_number" required
                                       value="<?= isset($_POST['phone_number']) ? htmlspecialchars($_POST['phone_number']) : '' ?>">
                            </div>
                        <?php endif; ?>
                        <div class="form-group">
                            <label for="shipping_address">Shipping Address*</label>
                            <textarea id="shipping_address" name="shipping_address" required><?= 
                                isset($_POST['shipping_address']) ? htmlspecialchars($_POST['shipping_address']) : ''
                            ?></textarea>
                        </div>
                        <div class="form-group">
                            <label for="billing_address">Billing Address (if different)</label>
                            <textarea id="billing_address" name="billing_address"><?= 
                                isset($_POST['billing_address']) ? htmlspecialchars($_POST['billing_address']) : ''
                            ?></textarea>
                        </div>
                        <div class="form-group">
                            <label>Payment Method*</label>
                            <div class="payment-options">
                                <label><input type="radio" name="payment_method" value="cash" <?= 
                                    (!isset($_POST['payment_method']) || $_POST['payment_method'] === 'cash' ? 'checked' : '')
                                ?>> Cash on Delivery</label>
                                <label><input type="radio" name="payment_method" value="bkash" <?= 
                                    (isset($_POST['payment_method']) && $_POST['payment_method'] === 'bkash' ? 'checked' : '')
                                ?>> bKash</label>
                                <label><input type="radio" name="payment_method" value="nagad" <?= 
                                    (isset($_POST['payment_method']) && $_POST['payment_method'] === 'nagad' ? 'checked' : '')
                                ?>> Nagad</label>
                                <label><input type="radio" name="payment_method" value="card" <?= 
                                    (isset($_POST['payment_method']) && $_POST['payment_method'] === 'card' ? 'checked' : '')
                                ?>> Credit/Debit Card</label>
                                <label><input type="radio" name="payment_method" value="bank_transfer" <?= 
                                    (isset($_POST['payment_method']) && $_POST['payment_method'] === 'bank_transfer' ? 'checked' : '')
                                ?>> Bank Transfer</label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="notes">Order Notes</label>
                            <textarea id="notes" name="notes"><?= 
                                isset($_POST['notes']) ? htmlspecialchars($_POST['notes']) : ''
                            ?></textarea>
                        </div>
                        <button type="submit" class="btn">Place Order</button>
                    </form>
                </div>
                <div class="order-summary">
                    <h2>Your Order</h2>
                    <div class="summary-items">
                        <?php foreach ($cart_items as $item): ?>
                            <div class="summary-item">
                                <span class="item-name"><?= htmlspecialchars($item['display_name']) ?></span>
                                <span class="item-quantity"><?= $item['quantity'] ?> ×</span>
                                <span class="item-price">৳<?= number_format($item['discount_price'] ?? $item['base_price'], 2) ?></span>
                                <?php if ($item['discount_price'] && $item['discount_price'] < $item['base_price']): ?>
                                    <span class="item-discount">
                                        (<?= number_format((($item['base_price'] - $item['discount_price']) / $item['base_price']) * 100, 2) ?>% off)
                                    </span>
                                <?php endif; ?>
                            </div>
                        <?php endforeach; ?>
                    </div>
                    <div class="summary-totals">
                        <div class="summary-row">
                            <span>Subtotal:</span>
                            <span>৳<?= number_format($cart_subtotal, 2) ?></span>
                        </div>
                        <div class="summary-row">
                            <span>VAT (15%):</span>
                            <span>৳<?= number_format($cart_vat, 2) ?></span>
                        </div>
                        <div class="summary-row total">
                            <span>Total:</span>
                            <span>৳<?= number_format($cart_total, 2) ?></span>
                        </div>
                    </div>
                </div>
            </div>
        <?php endif; ?>
    </main>

    <footer>
        <p>© <?= date('Y') ?> Brick Field E-Commerce. All rights reserved.</p>
    </footer>
</body>
</html>