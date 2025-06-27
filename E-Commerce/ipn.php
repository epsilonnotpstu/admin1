<?php
include '../config_admin/db_admin.php'; 

// SSLCOMMERZ credentials
$store_id = 'your_sandbox_store_id'; // Replace with your sandbox Store ID
$store_passwd = 'your_sandbox_store_password'; // Replace with your sandbox Store Password
$api_domain = 'https://sandbox.sslcommerz.com';
$validation_url = $api_domain . '/validator/api/validationserverAPI.php';

$tran_id = $_POST['tran_id'] ?? '';
$amount = $_POST['amount'] ?? 0;
$currency = $_POST['currency'] ?? '';

if ($tran_id) {
    try {
        $pdo->beginTransaction();

        // Verify payment
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
        curl_close($ch);

        $validation = json_decode($response, true);
        if (isset($validation['status']) && ($validation['status'] === 'VALID' || $validation['status'] === 'VALIDATED')) {
            // Find order by transaction ID
            $stmt = $pdo->prepare("
                SELECT o.order_id
                FROM Orders o
                JOIN Payments p ON o.order_id = p.order_id
                WHERE p.transaction_id = ?
            ");
            $stmt->execute([$tran_id]);
            $order = $stmt->fetch();

            if ($order) {
                $stmt = $pdo->prepare("
                    UPDATE Orders
                    SET payment_status = 'paid', status = 'processing'
                    WHERE order_id = ?
                ");
                $stmt->execute([$order['order_id']]);
            }
        }

        $pdo->commit();
    } catch (PDOException $e) {
        $pdo->rollBack();
        error_log("IPN Error: " . $e->getMessage());
    }
}
?>