-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 31, 2025 at 08:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Bricks_Management`
--

-- --------------------------------------------------------

--
-- Table structure for table `Attendance`
--

CREATE TABLE `Attendance` (
  `attendance_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL,
  `status` enum('present','absent','late','half_day','on_leave') NOT NULL,
  `overtime_hours` decimal(4,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Attendance`
--

INSERT INTO `Attendance` (`attendance_id`, `employee_id`, `date`, `check_in`, `check_out`, `status`, `overtime_hours`, `notes`) VALUES
(1, 6, '2025-05-23', '08:00:00', '16:00:00', 'present', 2.00, NULL),
(2, 4, '2025-05-23', '17:19:00', '21:21:00', 'present', 4.00, 'good'),
(3, 1, '2025-05-23', '13:01:00', '18:02:00', 'present', 5.00, 'good\r\n'),
(4, 7, '2025-05-23', '13:31:00', '18:31:00', 'half_day', 5.00, 'goodf');

-- --------------------------------------------------------

--
-- Table structure for table `BrickField`
--

CREATE TABLE `BrickField` (
  `field_id` int(11) NOT NULL,
  `field_name` varchar(100) NOT NULL,
  `location` varchar(255) NOT NULL,
  `district` varchar(50) NOT NULL,
  `upazila` varchar(50) NOT NULL,
  `total_area` decimal(10,2) DEFAULT NULL COMMENT 'in decimals',
  `owner_name` varchar(100) NOT NULL,
  `license_number` varchar(50) DEFAULT NULL,
  `establishment_date` date DEFAULT NULL,
  `contact_number` varchar(20) NOT NULL,
  `tax_id` varchar(30) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `BrickField`
--

INSERT INTO `BrickField` (`field_id`, `field_name`, `location`, `district`, `upazila`, `total_area`, `owner_name`, `license_number`, `establishment_date`, `contact_number`, `tax_id`, `is_active`) VALUES
(1, 'Rahman Brick Field', 'Savar', 'Dhaka', 'Savar', 5.50, 'Abdur Rahman', 'BRK-2023-001', NULL, '01711223344', NULL, 1),
(2, 'Jony Bricks', 'Magura', 'sdgf', 'dfg', 543.00, 'Jony Shiekh', '342534534', '2025-05-07', '01833054648', '234534534', 1);

-- --------------------------------------------------------

--
-- Table structure for table `BrickType`
--

CREATE TABLE `BrickType` (
  `brick_type_id` int(11) NOT NULL,
  `type_name` varchar(50) NOT NULL,
  `size` varchar(20) NOT NULL COMMENT 'e.g. 10x5x3 inches',
  `weight_kg` decimal(5,2) NOT NULL,
  `compressive_strength_psi` int(11) DEFAULT NULL,
  `water_absorption` decimal(5,2) DEFAULT NULL COMMENT 'in %',
  `standard` enum('ASTM','BNBC','custom') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `BrickType`
--

INSERT INTO `BrickType` (`brick_type_id`, `type_name`, `size`, `weight_kg`, `compressive_strength_psi`, `water_absorption`, `standard`) VALUES
(1, 'Red Brick', '10x5x3 inches', 2.50, 3000, 12.50, 'BNBC'),
(2, 'Hollow Brick', '12x6x4 inches', 1.80, 2500, 10.20, 'ASTM'),
(3, 'Perforated Brick', '9x4.5x3 inches', 2.20, 2800, 11.00, 'custom'),
(4, 'test', '5348', 453.00, 4353, NULL, 'custom');

-- --------------------------------------------------------

--
-- Table structure for table `Cart`
--

CREATE TABLE `Cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Cart`
--

INSERT INTO `Cart` (`cart_id`, `user_id`, `created_at`, `updated_at`) VALUES
(2, 8, '2025-05-20 08:07:38', '2025-05-20 08:07:38'),
(3, 13, '2025-05-23 15:53:52', '2025-05-23 15:53:52');

-- --------------------------------------------------------

--
-- Table structure for table `CartItems`
--

CREATE TABLE `CartItems` (
  `cart_item_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `CartItems`
--

INSERT INTO `CartItems` (`cart_item_id`, `cart_id`, `product_id`, `quantity`, `added_at`) VALUES
(4, 2, 1, 2, '2025-05-20 08:07:38'),
(8, 3, 2, 1, '2025-05-23 15:53:52');

-- --------------------------------------------------------

--
-- Table structure for table `contact_submissions`
--

CREATE TABLE `contact_submissions` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `message` text NOT NULL,
  `submitted_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `contact_submissions`
--

INSERT INTO `contact_submissions` (`id`, `name`, `email`, `phone`, `message`, `submitted_at`) VALUES
(1, 'Afridi Alom Pranto', 'afridialom510@gmail.com', '01833054648', '7tuidyjhjfycgjcfgj', '2025-05-18 22:00:29');

-- --------------------------------------------------------

--
-- Table structure for table `CustomerRatings`
--

CREATE TABLE `CustomerRatings` (
  `rating_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` between 1 and 5),
  `review` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `CustomerRatings`
--

INSERT INTO `CustomerRatings` (`rating_id`, `product_id`, `user_id`, `rating`, `review`, `created_at`) VALUES
(1, 1, 5, 5, 'good', '2025-05-26 10:25:40'),
(2, 1, 9, 4, 'good', '2025-05-26 10:26:41');

-- --------------------------------------------------------

--
-- Table structure for table `Customers`
--

CREATE TABLE `Customers` (
  `customer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `organization_name` varchar(100) DEFAULT NULL,
  `shipping_address` text DEFAULT NULL,
  `billing_address` text DEFAULT NULL,
  `tax_id` varchar(30) DEFAULT NULL,
  `preferred_payment_method` enum('cash','bkash','nagad','card','bank_transfer') DEFAULT NULL,
  `credit_limit` decimal(12,2) DEFAULT 0.00 COMMENT 'For B2B customers'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Customers`
--

INSERT INTO `Customers` (`customer_id`, `user_id`, `full_name`, `phone_number`, `organization_name`, `shipping_address`, `billing_address`, `tax_id`, `preferred_payment_method`, `credit_limit`) VALUES
(1, 6, 'Afrisdfsadi Alom Pranto', NULL, NULL, NULL, NULL, NULL, NULL, 0.00),
(2, 5, 'Afridi Alom Pranto', '01833054648', 'Patuakhali Science and Technology University', 'M Keramot Ali Hall, PSTU', 'M Keramot Ali Hall, PSTU', '354364565454', 'bank_transfer', 0.00),
(4, 28, 'testorder', '016457281961', 'High School', 'Beltia,Jamalpur Sadar, Jamalpur', 'Beltia,Jamalpur Sadar, Jamalpur', '2345345', 'bkash', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `DryingProcess`
--

CREATE TABLE `DryingProcess` (
  `drying_id` int(11) NOT NULL,
  `production_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `weather_condition` enum('sunny','cloudy','rainy','stormy') NOT NULL,
  `temperature` decimal(5,2) DEFAULT NULL COMMENT 'in °C',
  `humidity` decimal(5,2) DEFAULT NULL COMMENT 'in %',
  `flipped_count` int(11) DEFAULT 0 COMMENT 'Times bricks were flipped',
  `quality_check_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `DryingProcess`
--

INSERT INTO `DryingProcess` (`drying_id`, `production_id`, `start_date`, `end_date`, `weather_condition`, `temperature`, `humidity`, `flipped_count`, `quality_check_notes`) VALUES
(1, 1, '2025-05-23', '2025-05-23', 'sunny', 50.00, 50.00, 565, 'uihiu'),
(2, 2, '2025-05-23', NULL, 'sunny', NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Employees`
--

CREATE TABLE `Employees` (
  `employee_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `nid_number` varchar(20) NOT NULL,
  `role` enum('manager','supervisor','molder','kiln_operator','driver','accountant','other') NOT NULL,
  `joining_date` date NOT NULL,
  `salary` decimal(10,2) NOT NULL,
  `bank_account` varchar(30) DEFAULT NULL,
  `emergency_contact` varchar(20) DEFAULT NULL,
  `current_status` enum('active','on_leave','terminated') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Employees`
--

INSERT INTO `Employees` (`employee_id`, `user_id`, `field_id`, `nid_number`, `role`, `joining_date`, `salary`, `bank_account`, `emergency_contact`, `current_status`) VALUES
(1, 9, 1, '67890', 'molder', '2024-05-15', 70.77, '98538345834', '43598043958', 'active'),
(3, 13, 1, '1234567890', 'supervisor', '2025-05-20', 35000.00, NULL, NULL, 'active'),
(4, 14, 1, '84758475348753478534', 'driver', '2025-05-20', 80000.00, '7865434343', '98765432', 'active'),
(5, 15, 1, '2345678903456789', 'accountant', '2025-05-20', 10.00, '4567845678', '345678345678', 'active'),
(6, 16, 1, '123456789', 'molder', '2025-01-01', 20000.00, NULL, NULL, 'active'),
(7, 27, 1, '9876543210', 'kiln_operator', '2025-05-22', 500.00, '3678657453', '6543363', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `Expenses`
--

CREATE TABLE `Expenses` (
  `expense_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `expense_date` date NOT NULL,
  `category` enum('fuel','labor','raw_material','equipment','transport','utility','other') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `description` text DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `receipt_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Expenses`
--

INSERT INTO `Expenses` (`expense_id`, `field_id`, `expense_date`, `category`, `amount`, `description`, `approved_by`, `receipt_image`) VALUES
(4, 1, '2025-05-23', 'fuel', 987.00, '987987', 3, 'receipt_1747991000.jpg'),
(5, 1, '2025-05-23', 'transport', 657.00, 'jhkghkighj', 3, 'receipt_1747991020.jpg'),
(6, 1, '2025-05-23', 'transport', 657.00, 'jhkghkighj', 3, 'receipt_1747991275.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `Firing`
--

CREATE TABLE `Firing` (
  `firing_id` int(11) NOT NULL,
  `kiln_id` int(11) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL,
  `supervisor_id` int(11) NOT NULL,
  `fuel_consumed` decimal(10,2) DEFAULT NULL COMMENT 'in kg',
  `temperature_profile` text DEFAULT NULL COMMENT 'JSON data of temp changes',
  `success_rate` decimal(5,2) DEFAULT NULL COMMENT 'Percentage of good bricks'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Firing`
--

INSERT INTO `Firing` (`firing_id`, `kiln_id`, `start_date`, `end_date`, `supervisor_id`, `fuel_consumed`, `temperature_profile`, `success_rate`) VALUES
(1, 1, '2025-05-23 13:24:12', NULL, 1, NULL, NULL, NULL),
(2, 1, '2025-05-23 13:26:34', '2025-05-23 13:27:04', 3, 95.00, '564', 90.00);

-- --------------------------------------------------------

--
-- Table structure for table `Inventory`
--

CREATE TABLE `Inventory` (
  `inventory_id` int(11) NOT NULL,
  `brick_type_id` int(11) NOT NULL,
  `current_quantity` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Inventory`
--

INSERT INTO `Inventory` (`inventory_id`, `brick_type_id`, `current_quantity`, `last_updated`) VALUES
(1, 2, 90000, '2025-05-20 17:34:41');

-- --------------------------------------------------------

--
-- Table structure for table `Kiln`
--

CREATE TABLE `Kiln` (
  `kiln_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `kiln_type` enum('bulls_trench','hoffman','tunnel','clamp') NOT NULL,
  `capacity` int(11) NOT NULL COMMENT 'Max bricks per firing',
  `fuel_type` enum('coal','wood','rice_husk','gas') NOT NULL,
  `status` enum('active','maintenance','inactive') DEFAULT 'active',
  `construction_date` date DEFAULT NULL,
  `last_maintenance_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Kiln`
--

INSERT INTO `Kiln` (`kiln_id`, `field_id`, `kiln_type`, `capacity`, `fuel_type`, `status`, `construction_date`, `last_maintenance_date`) VALUES
(1, 1, 'hoffman', 10000, 'coal', 'active', '2024-01-01', '2025-05-23');

-- --------------------------------------------------------

--
-- Table structure for table `MaterialReceipt`
--

CREATE TABLE `MaterialReceipt` (
  `receipt_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `receipt_date` date NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `quality_rating` enum('excellent','good','average','poor') DEFAULT NULL,
  `received_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `MaterialReceipt`
--

INSERT INTO `MaterialReceipt` (`receipt_id`, `material_id`, `supplier_id`, `receipt_date`, `quantity`, `unit_price`, `quality_rating`, `received_by`) VALUES
(1, 2, 3, '2025-05-23', 534.00, 53745.00, 'average', 3),
(2, 2, 6, '2025-05-23', 50.00, 500.00, 'excellent', 3);

-- --------------------------------------------------------

--
-- Table structure for table `OrderDetails`
--

CREATE TABLE `OrderDetails` (
  `order_detail_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `discount_percentage` decimal(5,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS (`quantity` * `unit_price` * (1 - `discount_percentage` / 100)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `OrderDetails`
--

INSERT INTO `OrderDetails` (`order_detail_id`, `order_id`, `product_id`, `quantity`, `unit_price`, `discount_percentage`) VALUES
(1, 42, 2, 1, 10.00, 9.01),
(2, 43, 1, 2, 8.50, 19.05),
(3, 43, 3, 2, 10.00, 9.01),
(4, 43, 2, 1, 10.00, 9.01),
(5, 44, 1, 1, 8.50, 19.05);

-- --------------------------------------------------------

--
-- Table structure for table `Orders`
--

CREATE TABLE `Orders` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_date` datetime DEFAULT current_timestamp(),
  `delivery_date` date DEFAULT NULL,
  `shipping_address` text NOT NULL,
  `billing_address` text DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `vat_amount` decimal(10,2) DEFAULT 0.00,
  `discount_amount` decimal(10,2) DEFAULT 0.00,
  `total_amount` decimal(12,2) NOT NULL,
  `payment_method` enum('cash','bkash','nagad','card','bank_transfer') DEFAULT NULL,
  `payment_status` enum('pending','partial','paid') DEFAULT 'pending',
  `status` enum('pending','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Orders`
--

INSERT INTO `Orders` (`order_id`, `customer_id`, `order_date`, `delivery_date`, `shipping_address`, `billing_address`, `subtotal`, `vat_amount`, `discount_amount`, `total_amount`, `payment_method`, `payment_status`, `status`, `notes`) VALUES
(41, 1, '2025-05-01 10:00:00', '2025-05-05', '123 Gulshan Avenue, Dhaka', '123 Gulshan Avenue, Dhaka', 5000.00, 750.00, 0.00, 5750.00, 'cash', 'paid', 'delivered', 'Please deliver in the morning'),
(42, 4, '2025-05-23 22:09:05', NULL, 'fdgdfxg', 'fdgdfxg', 10.00, 1.50, 0.00, 11.50, 'cash', 'pending', 'processing', 'dfgdf'),
(43, 2, '2025-05-23 22:26:16', NULL, 'sdfds', 'sdfds', 47.00, 7.05, 0.00, 54.05, 'card', 'pending', 'processing', 'sdfgds'),
(44, 2, '2025-05-26 12:00:41', NULL, 'dsf', 'sf', 8.50, 1.28, 0.00, 9.78, 'nagad', 'pending', 'pending', 'vxv');

-- --------------------------------------------------------

--
-- Table structure for table `Payments`
--

CREATE TABLE `Payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_date` datetime DEFAULT current_timestamp(),
  `payment_method` enum('cash','bkash','nagad','card','bank_transfer') NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `receipt_url` varchar(255) DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL COMMENT 'Admin/Manager who verified',
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Payments`
--

INSERT INTO `Payments` (`payment_id`, `order_id`, `amount`, `payment_date`, `payment_method`, `transaction_id`, `receipt_url`, `verified_by`, `notes`) VALUES
(1, 41, 56756.00, '2025-05-20 23:42:53', 'bkash', '634564', NULL, NULL, '4563456435');

-- --------------------------------------------------------

--
-- Table structure for table `Production`
--

CREATE TABLE `Production` (
  `production_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `brick_type_id` int(11) NOT NULL,
  `quantity_produced` int(11) NOT NULL,
  `production_date` date NOT NULL,
  `supervisor_id` int(11) NOT NULL,
  `quality_rating` enum('A','B','C','rejected') NOT NULL,
  `firing_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Production`
--

INSERT INTO `Production` (`production_id`, `field_id`, `brick_type_id`, `quantity_produced`, `production_date`, `supervisor_id`, `quality_rating`, `firing_id`) VALUES
(1, 1, 2, 7000, '2025-05-20', 3, 'A', NULL),
(2, 1, 2, 10000, '2025-05-20', 3, 'B', NULL),
(3, 1, 3, 10000, '2025-05-20', 3, 'rejected', NULL),
(4, 1, 1, 6556, '2025-05-23', 3, 'A', NULL),
(5, 1, 1, 1000, '2025-05-23', 3, 'A', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Products`
--

CREATE TABLE `Products` (
  `product_id` int(11) NOT NULL,
  `brick_type_id` int(11) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `base_price` decimal(10,2) NOT NULL COMMENT 'in BDT',
  `discount_price` decimal(10,2) DEFAULT NULL,
  `min_order_quantity` int(11) DEFAULT 500 COMMENT 'Minimum bricks per order',
  `stock_quantity` int(11) NOT NULL,
  `is_featured` tinyint(1) DEFAULT 0,
  `is_available` tinyint(1) DEFAULT 1,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Products`
--

INSERT INTO `Products` (`product_id`, `brick_type_id`, `display_name`, `description`, `base_price`, `discount_price`, `min_order_quantity`, `stock_quantity`, `is_featured`, `is_available`, `image_url`) VALUES
(1, 1, 'Red Bricks', 'Best', 10.50, 8.50, 500, 9997, 1, 1, 'https://cforcivil.com/wp-content/uploads/2018/02/Havenbrick50_L-NSWVICSQLDNQLDSA-Terracotta.jpg'),
(2, 2, 'new bricks', 'Its good', 10.99, 10.00, 500, 3998, 1, 1, 'https://media.istockphoto.com/id/154137677/photo/original-brick.jpg?s=1024x1024&w=is&k=20&c=Ij9DysSAtWdnLbW-nUZALje-sllqnNGFuEtuRDlr-pI='),
(3, 2, 'new bricks', 'Its good', 10.99, 10.00, 500, 3998, 1, 1, 'https://media.istockphoto.com/id/154137677/photo/original-brick.jpg?s=1024x1024&w=is&k=20&c=Ij9DysSAtWdnLbW-nUZALje-sllqnNGFuEtuRDlr-pI='),
(4, 4, 'jjj', 'ooo', 9.00, 4.00, 500, 5000, 1, 1, 'https://www.google.com/url?sa=i&url=https%3A%2F%2Flandscapesupply.au%2Fproducts%2Fcommon-brick-230x110x76mm&psig=AOvVaw3sEFffUJ23_-MoD9FyqEf5&ust=1748117888782000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCPCKkuW0uo0DFQAAAAAdAAAAABAE');

-- --------------------------------------------------------

--
-- Table structure for table `QualityControl`
--

CREATE TABLE `QualityControl` (
  `quality_control_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `grade` enum('A','B','C') NOT NULL,
  `inspection_date` datetime NOT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `QualityControl`
--

INSERT INTO `QualityControl` (`quality_control_id`, `field_id`, `grade`, `inspection_date`, `notes`) VALUES
(1, 1, 'A', '2025-05-23 09:00:00', 'High-quality batch'),
(2, 1, 'A', '2025-05-23 10:30:00', 'Excellent bricks'),
(3, 1, 'B', '2025-05-23 14:00:00', 'Minor surface defects'),
(4, 2, 'C', '2025-05-23 11:00:00', 'Cracks detected');

-- --------------------------------------------------------

--
-- Table structure for table `RawBrickLoss`
--

CREATE TABLE `RawBrickLoss` (
  `loss_id` int(11) NOT NULL,
  `production_id` int(11) NOT NULL,
  `loss_date` date NOT NULL,
  `loss_reason` enum('cracking','breaking','rain_damage','theft') DEFAULT NULL,
  `quantity_lost` int(11) NOT NULL,
  `reported_by` int(11) DEFAULT NULL COMMENT 'Employee who reported'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `RawBrickLoss`
--

INSERT INTO `RawBrickLoss` (`loss_id`, `production_id`, `loss_date`, `loss_reason`, `quantity_lost`, `reported_by`) VALUES
(1, 1, '2025-05-23', 'cracking', 50, 1),
(2, 1, '2025-05-23', 'rain_damage', 500, 3),
(3, 1, '2025-05-23', 'cracking', 50, 6);

-- --------------------------------------------------------

--
-- Table structure for table `RawBrickProduction`
--

CREATE TABLE `RawBrickProduction` (
  `production_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `mold_type` enum('standard','hollow','perforated','special') NOT NULL,
  `quantity` int(11) NOT NULL COMMENT 'Number of wet bricks',
  `production_date` datetime DEFAULT current_timestamp(),
  `drying_location` enum('north_yard','south_yard','east_yard','west_yard') DEFAULT NULL,
  `drying_start_date` date DEFAULT NULL,
  `expected_drying_days` int(11) DEFAULT 7,
  `status` enum('wet','drying','dry','fired','rejected') DEFAULT 'wet',
  `supervisor_approved` tinyint(1) DEFAULT 0,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `RawBrickProduction`
--

INSERT INTO `RawBrickProduction` (`production_id`, `field_id`, `employee_id`, `mold_type`, `quantity`, `production_date`, `drying_location`, `drying_start_date`, `expected_drying_days`, `status`, `supervisor_approved`, `notes`) VALUES
(1, 1, 1, 'standard', 1000, '2025-05-23 13:06:38', 'north_yard', '2025-05-23', 7, 'dry', 1, NULL),
(2, 1, 6, 'standard', 1000, '2025-05-23 13:14:01', 'north_yard', '2025-05-23', 7, 'drying', 0, NULL),
(3, 1, 1, 'standard', 1000, '2025-05-23 13:24:12', 'north_yard', '2025-05-23', 7, 'wet', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `RawMaterials`
--

CREATE TABLE `RawMaterials` (
  `material_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `material_name` enum('clay','sand','coal','wood','rice_husk','chemicals') NOT NULL,
  `current_stock` decimal(10,2) NOT NULL,
  `unit_of_measure` enum('ton','kg','cubic_meter','bag') NOT NULL,
  `reorder_level` decimal(10,2) NOT NULL,
  `last_restock_date` date DEFAULT NULL,
  `avg_monthly_consumption` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `RawMaterials`
--

INSERT INTO `RawMaterials` (`material_id`, `field_id`, `material_name`, `current_stock`, `unit_of_measure`, `reorder_level`, `last_restock_date`, `avg_monthly_consumption`) VALUES
(1, 1, 'wood', 600.00, 'kg', 55.00, NULL, NULL),
(2, 1, 'clay', 657900.00, 'ton', 50.00, '2025-05-23', NULL),
(3, 1, 'sand', 200.00, 'ton', 100.00, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Suppliers`
--

CREATE TABLE `Suppliers` (
  `supplier_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `supplied_materials` text NOT NULL COMMENT 'Comma-separated list',
  `address` text DEFAULT NULL,
  `tax_id` varchar(30) DEFAULT NULL,
  `account_number` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Suppliers`
--

INSERT INTO `Suppliers` (`supplier_id`, `name`, `contact_person`, `phone`, `email`, `supplied_materials`, `address`, `tax_id`, `account_number`) VALUES
(1, 'Alpha Bricks Co.', 'John Mason', '123-456-7890', 'john@alphabricks.com', 'Clay Bricks', '123 Clay Rd, Bricktown', 'TX123456789', '00123456789'),
(2, 'BuildWell Ltd.', 'Sarah Stone', '234-567-8901', 'sarah@buildwell.com', 'Cement, Sand', '456 Cement St, Mason City', 'TX987654321', '00987654321'),
(3, 'RedRock Supplies', 'David Rock', '345-678-9012', 'david@redrock.com', 'Red Bricks', '789 Quarry Ln, Rockville', 'TX192837465', '00765432109'),
(4, 'Urban Materials Inc.', 'Emma Clay', '456-789-0123', 'emma@urbanmat.com', 'Concrete Blocks', '321 Urban Ave, Cityplace', 'TX564738291', '00432109876'),
(5, 'GreenField Traders', 'Liam Green', '567-890-1234', 'liam@greenfield.com', 'Soil, Lime', '654 Field Dr, Greentown', 'TX847362915', '00321098765'),
(6, 'Afridi Alom Pranto', 'Afridi Alom Pranto', '01833054648', 'afridialom510@gmail.com', 'clay,mad,klinton', 'Adorsha para, Magura, Bangladesh', '354364565454', '4566354');

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE `Users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `user_type` enum('admin','manager','supervisor','worker','customer') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`user_id`, `username`, `password_hash`, `email`, `phone`, `user_type`, `created_at`, `last_login`, `is_active`) VALUES
(5, 'afridi', '$2y$12$5KhVSdrwX/x2C8j1d9zB6uzdDVKqhRIPIx8m8NK5ddjWwbeWSzFNi', 'afridialom510@gmail.com', '01833054648', 'customer', '2025-05-17 06:54:40', NULL, 1),
(6, 'asdfsadfsa', '$2y$12$c11P44voK8eb9K04cVYfv.7iJ2XfWsPY4Kpj78U2vm/b0v1OK2UZu', 'afridiasdfsadlom510@gmail.com', '01833054648', 'customer', '2025-05-17 12:21:49', NULL, 1),
(7, 'admin', '$2y$10$ZU21DdKvYkvAD1eag6Ry8e78vToX2vjfk37hUCcegC/B7pZVWj3.u', 'admin@bricksfield.com', '0123456789', 'admin', '2025-05-20 04:11:45', NULL, 1),
(8, 'afridiadmin', '$2y$12$XYhJvQVJjj1KXDDUnFxVQuDnDX9Ln61uXiKNiqEN2df47yRpBTyeC', 'afridi@gamil.com', '018330546634548', 'admin', '2025-05-20 04:29:14', NULL, 1),
(9, 'sakib', '$2y$12$V6ku.DGLqurySLw7PLJL4u35G6NNTooqr66mhR6JcnRNgps9fCe1u', 'sakib@gmail.com', '12345', 'worker', '2025-05-20 07:29:00', NULL, 1),
(13, 'abcd', '$2y$12$dxD4sYddSabXUsglB2rNsuqQNwZ4NghNk8e3GwO95XNe9GvGejmEq', 'abcd@email.com', '1234567890', 'supervisor', '2025-05-20 07:55:34', NULL, 1),
(14, 'fuad', '$2y$12$XK/AbLAxdSJyjdLm.nbLPOTFOLwzUf3TNSSut1KQ4wrcAMbYMlFTe', 'fuad@gamil.com', '12345', 'worker', '2025-05-20 08:10:19', NULL, 1),
(15, 'sourov', '$2y$12$Aq4.9seSSJFNL.eyIRyWn.Mk/5rLXXL8Y.AxRTImEUV/95hOlWed6', 'sourov@gamil.com', '56789', 'worker', '2025-05-20 16:24:59', NULL, 1),
(16, 'worker1', '$2y$12$hash', 'worker1@example.com', '01712345678', 'worker', '2025-05-23 07:14:01', NULL, 1),
(20, 'supervisor152', '$2y$12$hashedpassword', 'supervisogfhr1@example.com', '01712345678', 'supervisor', '2025-05-23 07:55:17', NULL, 1),
(22, 'supervdgdfisor152', '$2y$12$hashedpassword', 'supervisoxdgfgfhr1@example.com', '01712345678', 'supervisor', '2025-05-23 07:56:49', NULL, 1),
(23, 'supervsfdgdgdfisor152', '$2y$12$hashedpassword', 'supervisdfgoxdgfgfhr1@example.com', '01712345678', 'supervisor', '2025-05-23 07:57:49', NULL, 1),
(25, 'supervisor1', '$2y$12$hashedpassword', 'supervisor1@example.com', '01712345678', 'supervisor', '2025-05-23 08:15:10', NULL, 1),
(27, 'mubin', '$2y$12$PUxRVvXmdrQ5d.4xacfosOAH0KtM3wQUSpu39OQ4MCboJ2c.LDXCC', 'mubin@gmail.com', '123456799', 'worker', '2025-05-23 12:30:30', NULL, 1),
(28, 'testorder', '$2y$12$bDmOOokGML27ouYLC2g.MuP.ICRbQUCGQxJdzDQelA/4fqVlhvR/O', 'testorder@gmail.com', '01935303388', 'customer', '2025-05-23 16:05:50', NULL, 1),
(30, 'afridipstu', '$2y$12$0SxykGwTHbceXmzyPE0CPu/.HTO/MzDxQPcBwTWVtt/zrLqN8CaqK', 'afridipstu@gmail.com', '01833054648', 'admin', '2025-05-24 06:52:15', NULL, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Attendance`
--
ALTER TABLE `Attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD UNIQUE KEY `employee_id` (`employee_id`,`date`);

--
-- Indexes for table `BrickField`
--
ALTER TABLE `BrickField`
  ADD PRIMARY KEY (`field_id`),
  ADD UNIQUE KEY `license_number` (`license_number`);

--
-- Indexes for table `BrickType`
--
ALTER TABLE `BrickType`
  ADD PRIMARY KEY (`brick_type_id`),
  ADD UNIQUE KEY `type_name` (`type_name`);

--
-- Indexes for table `Cart`
--
ALTER TABLE `Cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `CartItems`
--
ALTER TABLE `CartItems`
  ADD PRIMARY KEY (`cart_item_id`),
  ADD UNIQUE KEY `cart_id` (`cart_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `contact_submissions`
--
ALTER TABLE `contact_submissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `CustomerRatings`
--
ALTER TABLE `CustomerRatings`
  ADD PRIMARY KEY (`rating_id`),
  ADD UNIQUE KEY `user_product` (`user_id`,`product_id`),
  ADD KEY `CustomerRatings_ibfk_1` (`product_id`);

--
-- Indexes for table `Customers`
--
ALTER TABLE `Customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `DryingProcess`
--
ALTER TABLE `DryingProcess`
  ADD PRIMARY KEY (`drying_id`),
  ADD KEY `production_id` (`production_id`);

--
-- Indexes for table `Employees`
--
ALTER TABLE `Employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `nid_number` (`nid_number`),
  ADD KEY `idx_field_employee` (`field_id`);

--
-- Indexes for table `Expenses`
--
ALTER TABLE `Expenses`
  ADD PRIMARY KEY (`expense_id`),
  ADD KEY `field_id` (`field_id`),
  ADD KEY `Expenses_ibfk_2` (`approved_by`);

--
-- Indexes for table `Firing`
--
ALTER TABLE `Firing`
  ADD PRIMARY KEY (`firing_id`),
  ADD KEY `kiln_id` (`kiln_id`),
  ADD KEY `supervisor_id` (`supervisor_id`);

--
-- Indexes for table `Inventory`
--
ALTER TABLE `Inventory`
  ADD PRIMARY KEY (`inventory_id`),
  ADD KEY `brick_type_id` (`brick_type_id`);

--
-- Indexes for table `Kiln`
--
ALTER TABLE `Kiln`
  ADD PRIMARY KEY (`kiln_id`),
  ADD KEY `field_id` (`field_id`);

--
-- Indexes for table `MaterialReceipt`
--
ALTER TABLE `MaterialReceipt`
  ADD PRIMARY KEY (`receipt_id`),
  ADD KEY `material_id` (`material_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `received_by` (`received_by`);

--
-- Indexes for table `OrderDetails`
--
ALTER TABLE `OrderDetails`
  ADD PRIMARY KEY (`order_detail_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `Orders`
--
ALTER TABLE `Orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `idx_order_date` (`order_date`),
  ADD KEY `idx_payment_status` (`payment_status`);

--
-- Indexes for table `Payments`
--
ALTER TABLE `Payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `verified_by` (`verified_by`);

--
-- Indexes for table `Production`
--
ALTER TABLE `Production`
  ADD PRIMARY KEY (`production_id`),
  ADD KEY `field_id` (`field_id`),
  ADD KEY `brick_type_id` (`brick_type_id`),
  ADD KEY `supervisor_id` (`supervisor_id`),
  ADD KEY `firing_id` (`firing_id`),
  ADD KEY `idx_production_date` (`production_date`);

--
-- Indexes for table `Products`
--
ALTER TABLE `Products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `idx_brick_type` (`brick_type_id`);

--
-- Indexes for table `QualityControl`
--
ALTER TABLE `QualityControl`
  ADD PRIMARY KEY (`quality_control_id`),
  ADD KEY `idx_field_date` (`field_id`,`inspection_date`);

--
-- Indexes for table `RawBrickLoss`
--
ALTER TABLE `RawBrickLoss`
  ADD PRIMARY KEY (`loss_id`),
  ADD KEY `production_id` (`production_id`),
  ADD KEY `reported_by` (`reported_by`);

--
-- Indexes for table `RawBrickProduction`
--
ALTER TABLE `RawBrickProduction`
  ADD PRIMARY KEY (`production_id`),
  ADD KEY `field_id` (`field_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `RawMaterials`
--
ALTER TABLE `RawMaterials`
  ADD PRIMARY KEY (`material_id`),
  ADD KEY `field_id` (`field_id`);

--
-- Indexes for table `Suppliers`
--
ALTER TABLE `Suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Attendance`
--
ALTER TABLE `Attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `BrickField`
--
ALTER TABLE `BrickField`
  MODIFY `field_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `BrickType`
--
ALTER TABLE `BrickType`
  MODIFY `brick_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Cart`
--
ALTER TABLE `Cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `CartItems`
--
ALTER TABLE `CartItems`
  MODIFY `cart_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `contact_submissions`
--
ALTER TABLE `contact_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `CustomerRatings`
--
ALTER TABLE `CustomerRatings`
  MODIFY `rating_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Customers`
--
ALTER TABLE `Customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `DryingProcess`
--
ALTER TABLE `DryingProcess`
  MODIFY `drying_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Employees`
--
ALTER TABLE `Employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Expenses`
--
ALTER TABLE `Expenses`
  MODIFY `expense_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Firing`
--
ALTER TABLE `Firing`
  MODIFY `firing_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Inventory`
--
ALTER TABLE `Inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Kiln`
--
ALTER TABLE `Kiln`
  MODIFY `kiln_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `MaterialReceipt`
--
ALTER TABLE `MaterialReceipt`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `OrderDetails`
--
ALTER TABLE `OrderDetails`
  MODIFY `order_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Orders`
--
ALTER TABLE `Orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `Payments`
--
ALTER TABLE `Payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Production`
--
ALTER TABLE `Production`
  MODIFY `production_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Products`
--
ALTER TABLE `Products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `QualityControl`
--
ALTER TABLE `QualityControl`
  MODIFY `quality_control_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `RawBrickLoss`
--
ALTER TABLE `RawBrickLoss`
  MODIFY `loss_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `RawBrickProduction`
--
ALTER TABLE `RawBrickProduction`
  MODIFY `production_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `RawMaterials`
--
ALTER TABLE `RawMaterials`
  MODIFY `material_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Suppliers`
--
ALTER TABLE `Suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Attendance`
--
ALTER TABLE `Attendance`
  ADD CONSTRAINT `Attendance_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `Employees` (`employee_id`);

--
-- Constraints for table `Cart`
--
ALTER TABLE `Cart`
  ADD CONSTRAINT `Cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `CartItems`
--
ALTER TABLE `CartItems`
  ADD CONSTRAINT `CartItems_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `Cart` (`cart_id`),
  ADD CONSTRAINT `CartItems_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`);

--
-- Constraints for table `CustomerRatings`
--
ALTER TABLE `CustomerRatings`
  ADD CONSTRAINT `CustomerRatings_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`),
  ADD CONSTRAINT `CustomerRatings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `Customers`
--
ALTER TABLE `Customers`
  ADD CONSTRAINT `Customers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `DryingProcess`
--
ALTER TABLE `DryingProcess`
  ADD CONSTRAINT `DryingProcess_ibfk_1` FOREIGN KEY (`production_id`) REFERENCES `RawBrickProduction` (`production_id`);

--
-- Constraints for table `Employees`
--
ALTER TABLE `Employees`
  ADD CONSTRAINT `Employees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  ADD CONSTRAINT `Employees_ibfk_2` FOREIGN KEY (`field_id`) REFERENCES `BrickField` (`field_id`);

--
-- Constraints for table `Expenses`
--
ALTER TABLE `Expenses`
  ADD CONSTRAINT `Expenses_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `BrickField` (`field_id`),
  ADD CONSTRAINT `Expenses_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `Employees` (`employee_id`);

--
-- Constraints for table `Firing`
--
ALTER TABLE `Firing`
  ADD CONSTRAINT `Firing_ibfk_1` FOREIGN KEY (`kiln_id`) REFERENCES `Kiln` (`kiln_id`),
  ADD CONSTRAINT `Firing_ibfk_2` FOREIGN KEY (`supervisor_id`) REFERENCES `Employees` (`employee_id`);

--
-- Constraints for table `Inventory`
--
ALTER TABLE `Inventory`
  ADD CONSTRAINT `Inventory_ibfk_1` FOREIGN KEY (`brick_type_id`) REFERENCES `BrickType` (`brick_type_id`);

--
-- Constraints for table `Kiln`
--
ALTER TABLE `Kiln`
  ADD CONSTRAINT `Kiln_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `BrickField` (`field_id`);

--
-- Constraints for table `MaterialReceipt`
--
ALTER TABLE `MaterialReceipt`
  ADD CONSTRAINT `MaterialReceipt_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `RawMaterials` (`material_id`),
  ADD CONSTRAINT `MaterialReceipt_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `Suppliers` (`supplier_id`),
  ADD CONSTRAINT `MaterialReceipt_ibfk_3` FOREIGN KEY (`received_by`) REFERENCES `Employees` (`employee_id`);

--
-- Constraints for table `OrderDetails`
--
ALTER TABLE `OrderDetails`
  ADD CONSTRAINT `OrderDetails_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`),
  ADD CONSTRAINT `OrderDetails_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`);

--
-- Constraints for table `Orders`
--
ALTER TABLE `Orders`
  ADD CONSTRAINT `Orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customers` (`customer_id`);

--
-- Constraints for table `Payments`
--
ALTER TABLE `Payments`
  ADD CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`),
  ADD CONSTRAINT `Payments_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `Production`
--
ALTER TABLE `Production`
  ADD CONSTRAINT `Production_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `BrickField` (`field_id`),
  ADD CONSTRAINT `Production_ibfk_2` FOREIGN KEY (`brick_type_id`) REFERENCES `BrickType` (`brick_type_id`),
  ADD CONSTRAINT `Production_ibfk_3` FOREIGN KEY (`supervisor_id`) REFERENCES `Employees` (`employee_id`),
  ADD CONSTRAINT `Production_ibfk_4` FOREIGN KEY (`firing_id`) REFERENCES `Firing` (`firing_id`);

--
-- Constraints for table `Products`
--
ALTER TABLE `Products`
  ADD CONSTRAINT `Products_ibfk_1` FOREIGN KEY (`brick_type_id`) REFERENCES `BrickType` (`brick_type_id`);

--
-- Constraints for table `QualityControl`
--
ALTER TABLE `QualityControl`
  ADD CONSTRAINT `QualityControl_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `BrickField` (`field_id`);

--
-- Constraints for table `RawBrickLoss`
--
ALTER TABLE `RawBrickLoss`
  ADD CONSTRAINT `RawBrickLoss_ibfk_1` FOREIGN KEY (`production_id`) REFERENCES `RawBrickProduction` (`production_id`),
  ADD CONSTRAINT `RawBrickLoss_ibfk_2` FOREIGN KEY (`reported_by`) REFERENCES `Employees` (`employee_id`);

--
-- Constraints for table `RawBrickProduction`
--
ALTER TABLE `RawBrickProduction`
  ADD CONSTRAINT `RawBrickProduction_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `BrickField` (`field_id`),
  ADD CONSTRAINT `RawBrickProduction_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `Employees` (`employee_id`);

--
-- Constraints for table `RawMaterials`
--
ALTER TABLE `RawMaterials`
  ADD CONSTRAINT `RawMaterials_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `BrickField` (`field_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
