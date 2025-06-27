<?php
session_start();
include '../config_admin/db_admin.php'; 

// SSLCOMMERZ credentials
$store_id = 'your_sandbox_store_id'; // Replace with your sandbox Store ID
$store_passwd = 'your_sandbox_store_password'; // Replace with your sandbox Store Password
$api_domain = 'https://sandbox.sslcommerz.com';
$validation_url = $api_domain . '/validator/api/validationserverAPI.php';

$errors = [];
$success = false;
$order_id = $_SESSION['order_id'] ?? null;
$tran_id = $_POST['tran_id'] ?? '';

if (!$order_id || !$tran_id) {
    $errors[] = "Invalid order or transaction ID";
}

if (empty($errors)) {
    try {
        $pdo->beginTransaction();

        // Verify payment with SSLCOMMERZ
        $validation_data = [
            'val_id' => $_POST['val_id'] ?? '',
            'store_id' => $store_id,
            'store_passwd' => $store_passwd,
            'format' => 'json'
        ];

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $validation_url . '?' . http_build_query($validation_data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // Disable in sandbox; enable in production
        $response = curl_exec($ch);
        $err = curl_error($ch);
        curl_close($ch);

        if ($err) {
            $errors[] = "Payment validation failed: " . $err;
        } else {
            $validation = json_decode($response, true);
            if (isset($validation['status']) && ($validation['status'] === 'VALID' || $validation['status'] === 'VALIDATED')) {
                // Fetch order details
                $stmt = $pdo->prepare("
                    SELECT o.*, c.full_name, c.phone_number, c.shipping_address
                    FROM Orders o
                    JOIN Customers c ON o.customer_id = c.customer_id
                    WHERE o.order_id = ?
                ");
                $stmt->execute([$order_id]);
                $order = $stmt->fetch();

                if ($order) {
                    // Update stock
                    $stmt = $pdo->prepare("
                        SELECT ci.product_id, ci.quantity
                        FROM CartItems ci
                        JOIN Cart c ON ci.cart_id = c.cart_id
                        WHERE c.user_id = ?
                    ");
                    $stmt->execute([$_SESSION['user_id']]);
                    $cart_items = $stmt->fetchAll(PDO::FETCH_ASSOC);

                    foreach ($cart_items as $item) {
                        $stmt = $pdo->prepare("
                            UPDATE Products
                            SET stock_quantity = stock_quantity - ?
                            WHERE product_id = ?
                        ");
                        $stmt->execute([$item['quantity'], $item['product_id']]);
                    }

                    // Clear cart
                    $stmt = $pdo->prepare("SELECT cart_id FROM Cart WHERE user_id = ?");
                    $stmt->execute([$_SESSION['user_id']]);
                    $cart = $stmt->fetch();

                    if ($cart) {
                        $stmt = $pdo->prepare("DELETE FROM CartItems WHERE cart_id = ?");
                        $stmt->execute([$cart['cart_id']]);
                        $stmt = $pdo->prepare("DELETE FROM Cart WHERE cart_id = ?");
                        $stmt->execute([$cart['cart_id']]);
                    }

                    // Update order status
                    $stmt = $pdo->prepare("
                        UPDATE Orders
                        SET payment_status = 'paid', status = 'processing'
                        WHERE order_id = ?
                    ");
                    $stmt->execute([$order_id]);

                    // Record payment
                    $stmt = $pdo->prepare("
                        INSERT INTO Payments (order_id, amount, payment_method, transaction_id, payment_date)
                        VALUES (?, ?, ?, ?, NOW())
                    ");
                    $stmt->execute([$order_id, $order['total_amount'], $order['payment_method'], $tran_id]);

                    $success = true;
                } else {
                    $errors[] = "Order not found";
                }
            } else {
                $errors[] = "Payment validation failed: " . ($validation['error'] ?? 'Unknown error');
            }
        }

        $pdo->commit();
    } catch (PDOException $e) {
        $pdo->rollBack();
        error_log("Payment Error: " . $e->getMessage());
        $errors[] = "Failed to process payment: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Success - Brick Field</title>
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

    <main class="container">
        <?php if ($success): ?>
            <div class="success-message">
                <h2>Order #<?= $order_id ?> Placed Successfully!</h2>
                <p>Thank you for your purchase. Payment has been verified, and we'll process your order shortly.</p>
                <div class="order-summary">
                    <p><strong>Total Amount:</strong> ৳<?= number_format($_POST['amount'] ?? $order['total_amount'], 2) ?></p>
                    <p><strong>Payment Method:</strong> <?= ucfirst(str_replace('_', ' ', $_POST['card_issuer'] ?? $order['payment_method'])) ?></p>
                    <p><strong>Transaction ID:</strong> <?= htmlspecialchars($tran_id) ?></p>
                    <p><strong>Shipping Address:</strong> <?= htmlspecialchars($order['shipping_address']) ?></p>
                </div>
                <a href="products.php" class="btn">Continue Shopping</a>
            </div>
        <?php else: ?>
            <div class="error-message">
                <h2>Payment Failed</h2>
                <ul>
                    <?php foreach ($errors as $error): ?>
                        <li><?= htmlspecialchars($error) ?></li>
                    <?php endforeach; ?>
                </ul>
                <a href="cheekout.php" class="btn">Back to Checkout</a>
            </div>
        <?php endif; ?>
    </main>

    <footer>
        <p>© <?= date('Y') ?> Brick Field E-Commerce. All rights reserved.</p>
    </footer>
</body>
</html>