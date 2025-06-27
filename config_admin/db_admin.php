<?php
//$host = '127.0.0.1';
$dbname = 'Bricks_Management';
$username = 'root';
$password = '';

try {
   $pdo = new PDO('mysql:host=127.0.0.1;dbname=' . $dbname . ';charset=utf8', $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "হান্দানো সঠিক!! ";
     $stmt = $pdo->query("SELECT COUNT(*) FROM Users WHERE user_type = 'admin'");
    if ($stmt->fetchColumn() == 0) {
        $password_hash = password_hash('admin123', PASSWORD_DEFAULT);
        $pdo->exec("
            INSERT INTO Users (username, password_hash, email, phone, user_type) 
            VALUES ('admin', '$password_hash', 'admin@bricksfield.com', '0123456789', 'admin')
        ");
    }
    
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>
