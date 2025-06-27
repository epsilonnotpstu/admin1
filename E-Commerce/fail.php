<?php
session_start();
$order_id = $_SESSION['order_id'] ?? null;
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Failed - Brick Field</title>
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
        <div class="error-message">
            <h2>Payment Failed</h2>
            <p>Your payment could not be processed. Please try again.</p>
            <a href="cheekout.php" class="btn">Back to Checkout</a>
        </div>
    </main>

    <footer>
        <p>© <?= date('Y') ?> Brick Field E-Commerce. All rights reserved.</p>
    </footer>
</body>
</html>