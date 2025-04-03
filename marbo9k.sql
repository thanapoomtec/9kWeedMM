-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 04, 2025 at 12:36 AM
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
-- Database: `marbo9k`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`id`, `user_id`, `action`, `entity_type`, `entity_id`, `details`, `ip_address`, `timestamp`) VALUES
(1, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 21:28:12'),
(2, 1, 'add_product', 'product', 1, 'Added product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 21:29:48'),
(3, 1, 'delete_product', 'product', 1, 'Deleted product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 21:30:02'),
(4, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 21:37:02'),
(5, 1, 'add_product', 'product', 2, 'Added product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 21:38:20'),
(6, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 21:40:14'),
(7, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 21:42:10'),
(8, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 21:45:56'),
(9, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 21:48:20'),
(10, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 21:48:36'),
(11, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 21:49:09'),
(12, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 21:49:09'),
(13, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 21:55:04'),
(14, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 21:55:16'),
(15, 1, 'add_order', 'order', 2, 'Added order for customer: asd', '127.0.0.1', '2025-04-03 21:55:39'),
(16, 1, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 22:24:31'),
(17, 1, 'add_user', 'user', 2, 'Added user: bishak', '127.0.0.1', '2025-04-03 22:30:17'),
(18, 1, 'edit_user', 'user', 2, 'Edited user: bishak', '127.0.0.1', '2025-04-03 22:30:24'),
(19, 1, 'add_user', 'user', 3, 'Added user: dd', '127.0.0.1', '2025-04-03 22:30:35'),
(20, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 22:52:19'),
(21, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 22:56:17'),
(22, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 23:09:26'),
(23, 1, 'add_product', 'product', 3, 'Added product: Marbo 9k STRAWBERRY PEACH', '127.0.0.1', '2025-04-03 23:10:38'),
(24, 1, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 23:14:43'),
(25, 1, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250403_231446.sql and data_export_20250403_231446.xlsx', '127.0.0.1', '2025-04-03 23:15:01'),
(26, 1, 'logout', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 23:15:54'),
(27, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-03 23:15:57'),
(28, 2, 'add_product', 'product', 4, 'Added product: Marbo 9k PEACH', '127.0.0.1', '2025-04-03 23:17:04'),
(29, 2, 'add_product', 'product', 5, 'Added product: Marbo 9k APPLE ALOE', '127.0.0.1', '2025-04-03 23:17:31'),
(30, 2, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 23:18:16'),
(31, 2, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 23:18:40'),
(32, 2, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-03 23:18:47'),
(33, 2, 'edit_product', 'product', 3, 'Edited product: Marbo 9k STRAWBERRY PEACH', '127.0.0.1', '2025-04-03 23:18:55'),
(34, 2, 'edit_product', 'product', 4, 'Edited product: Marbo 9k PEACH', '127.0.0.1', '2025-04-03 23:19:01'),
(35, 2, 'edit_product', 'product', 5, 'Edited product: Marbo 9k APPLE ALOE', '127.0.0.1', '2025-04-03 23:19:06'),
(36, 2, 'add_product', 'product', 6, 'Added product: Marbo 9k WATERMELON BUBBLEGUM', '127.0.0.1', '2025-04-03 23:19:34'),
(37, 2, 'add_inventory', 'product', 6, 'Added 10 units to Marbo 9k WATERMELON BUBBLEGUM', '127.0.0.1', '2025-04-03 23:19:53'),
(38, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250403_232535.sql and data_export_20250403_232535.xlsx', '127.0.0.1', '2025-04-03 23:25:40'),
(39, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250403_235929.sql and data_export_20250403_235929.xlsx', '127.0.0.1', '2025-04-03 23:59:32'),
(40, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 00:10:15'),
(41, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 00:34:09'),
(42, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 00:34:38'),
(43, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 00:43:33'),
(44, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 00:43:43'),
(45, 2, 'add_banner', NULL, NULL, 'Added banner: NkornDara', '127.0.0.1', '2025-04-04 00:45:24'),
(46, 2, 'delete_banner', NULL, NULL, 'Deleted banner: NkornDara', '127.0.0.1', '2025-04-04 00:45:49'),
(47, 2, 'update_featured_products', NULL, NULL, 'Updated featured products', '127.0.0.1', '2025-04-04 00:46:04'),
(48, 2, 'update_featured_products', NULL, NULL, 'Updated featured products', '127.0.0.1', '2025-04-04 00:47:31'),
(49, 2, 'update_featured_products', NULL, NULL, 'Updated featured products', '127.0.0.1', '2025-04-04 00:48:19'),
(50, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 00:48:22'),
(51, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 00:48:24'),
(52, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 00:48:33'),
(53, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_004926.sql and data_export_20250404_004926.xlsx', '127.0.0.1', '2025-04-04 00:54:39'),
(54, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_005432.sql and data_export_20250404_005432.xlsx', '127.0.0.1', '2025-04-04 00:55:34'),
(55, 2, 'update_featured_products', NULL, NULL, 'Updated featured products', '127.0.0.1', '2025-04-04 00:58:06'),
(56, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 00:58:29'),
(57, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 00:59:22'),
(58, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 00:59:34'),
(59, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_005530.sql and data_export_20250404_005530.xlsx', '127.0.0.1', '2025-04-04 01:01:21'),
(60, 2, 'add_banner', NULL, NULL, 'Added banner: Monkey123', '127.0.0.1', '2025-04-04 01:05:53'),
(61, 2, 'delete_banner', NULL, NULL, 'Deleted banner: Monkey123', '127.0.0.1', '2025-04-04 01:06:19'),
(62, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 01:06:44'),
(63, 2, 'update_shop_footer', NULL, NULL, 'Updated shop footer settings', '127.0.0.1', '2025-04-04 01:37:30'),
(64, 2, 'logout', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 01:59:27'),
(65, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 01:59:38'),
(66, 2, 'edit_product', 'product', 2, 'Edited product: Marbo 9k STRAWBERRY', '127.0.0.1', '2025-04-04 02:02:26'),
(67, 2, 'edit_product', 'product', 4, 'Edited product: Marbo 9k PEACH', '127.0.0.1', '2025-04-04 02:02:33'),
(68, 2, 'edit_product', 'product', 3, 'Edited product: Marbo 9k STRAWBERRY PEACH', '127.0.0.1', '2025-04-04 02:02:40'),
(69, 2, 'edit_product', 'product', 5, 'Edited product: Marbo 9k APPLE ALOE', '127.0.0.1', '2025-04-04 02:02:44'),
(70, 2, 'edit_product', 'product', 6, 'Edited product: Marbo 9k WATERMELON BUBBLEGUM', '127.0.0.1', '2025-04-04 02:02:48'),
(71, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 02:05:42'),
(72, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 02:05:58'),
(73, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 02:06:03'),
(74, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:48:05'),
(75, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 03:50:46'),
(76, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 03:51:20'),
(77, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 03:51:49'),
(78, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:52:10'),
(79, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 03:52:57'),
(80, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 03:53:25'),
(81, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:54:07'),
(82, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:54:08'),
(83, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:54:48'),
(84, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:54:50'),
(85, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:55:00'),
(86, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:55:02'),
(87, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:55:03'),
(88, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:56:25'),
(89, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:56:27'),
(90, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:56:37'),
(91, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:56:48'),
(92, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:56:58'),
(93, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:57:02'),
(94, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:57:06'),
(95, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 03:57:06'),
(96, 2, 'add_banner', NULL, NULL, 'Added banner: Monkeyt', '127.0.0.1', '2025-04-04 04:01:59'),
(97, 2, 'delete_banner', NULL, NULL, 'Deleted banner: Monkeyt', '127.0.0.1', '2025-04-04 04:02:14'),
(98, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_041638.sql and data_export_20250404_041638.xlsx', '127.0.0.1', '2025-04-04 04:16:44'),
(99, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_042940.sql and data_export_20250404_042940.xlsx', '127.0.0.1', '2025-04-04 04:29:44'),
(100, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_043136.sql and data_export_20250404_043136.xlsx', '127.0.0.1', '2025-04-04 04:31:38'),
(101, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 04:38:39'),
(102, 2, 'delete_user', 'user', 3, 'Deleted user: dd', '127.0.0.1', '2025-04-04 04:40:24'),
(103, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_043602.sql and data_export_20250404_043602.xlsx', '127.0.0.1', '2025-04-04 04:42:35'),
(104, 2, 'logout', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 04:59:56'),
(105, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 05:00:41'),
(106, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_050120.sql and data_export_20250404_050120.xlsx', '127.0.0.1', '2025-04-04 05:01:21'),
(107, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_050133.sql and data_export_20250404_050133.xlsx', '127.0.0.1', '2025-04-04 05:01:33'),
(108, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_050316.sql and data_export_20250404_050316.xlsx', '127.0.0.1', '2025-04-04 05:03:16'),
(109, 2, 'update_settings', NULL, NULL, 'Updated system settings', '127.0.0.1', '2025-04-04 05:03:46'),
(110, 2, 'update_payment', 'order', 4, 'Updated payment for order #4', '127.0.0.1', '2025-04-04 05:05:30'),
(111, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 05:13:06'),
(112, 2, 'backup_data', NULL, NULL, 'Created backup: db_backup_20250404_052047.sql and data_export_20250404_052047.xlsx', '127.0.0.1', '2025-04-04 05:20:47'),
(113, 2, 'update_shop_theme', NULL, NULL, 'Updated shop theme settings', '127.0.0.1', '2025-04-04 05:21:51'),
(114, 2, 'update_shop_hero', NULL, NULL, 'Updated shop hero section', '127.0.0.1', '2025-04-04 05:22:49'),
(115, 2, 'update_settings', NULL, NULL, 'Updated system settings', '127.0.0.1', '2025-04-04 05:29:21'),
(116, 2, 'logout', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 05:29:25'),
(117, 2, 'login', NULL, NULL, NULL, '127.0.0.1', '2025-04-04 05:29:28');

-- --------------------------------------------------------

--
-- Table structure for table `banner`
--

CREATE TABLE `banner` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `image_path` varchar(200) NOT NULL,
  `link` varchar(200) DEFAULT NULL,
  `position` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `line_id` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `name`, `phone`, `address`, `line_id`, `created_at`) VALUES
(1, 'asd', 'asdasd', 'asdasd', NULL, '2025-04-03 21:30:26'),
(2, 'asdasd', 'asd', 'asdasd', NULL, '2025-04-03 22:36:38'),
(3, 'jak papho', '0877895489', 'เทสเทส', NULL, '2025-04-03 23:22:13'),
(4, 'หนองปลา หวาย', '0879875487', 'asdasd', NULL, '2025-04-03 23:32:10'),
(5, 'ฟหกฟหก', 'sadasd', 'asdasdasd', NULL, '2025-04-04 00:49:16'),
(6, 'ห', '151561', 'ฟหกห', NULL, '2025-04-04 01:16:49'),
(15, 'xx', 'xxx', 'xxx', NULL, '2025-04-04 04:00:21'),
(16, 'asdasd', 'asdas', 'asdasd', NULL, '2025-04-04 04:00:34'),
(21, 'Walk-in Customer', '', NULL, NULL, '2025-04-04 04:13:46'),
(22, 'Sompong', '', NULL, NULL, '2025-04-04 04:16:12'),
(23, 'David luis', '', NULL, NULL, '2025-04-04 04:28:03'),
(24, 'xx', 'xx', 'xxx', NULL, '2025-04-04 05:03:59');

-- --------------------------------------------------------

--
-- Table structure for table `featured_product`
--

CREATE TABLE `featured_product` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_entry`
--

CREATE TABLE `inventory_entry` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_entry`
--

INSERT INTO `inventory_entry` (`id`, `product_id`, `quantity`, `date`, `notes`, `user_id`) VALUES
(1, 6, 10, '2025-04-03 23:19:53', '', NULL),
(3, 2, -1, '2025-04-03 21:13:46', 'Storefront Sale - Order #11', NULL),
(4, 5, -5, '2025-04-03 21:16:12', 'Storefront Sale - Order #12', NULL),
(5, 2, 1, '2025-04-03 21:22:35', 'Order #11 deleted - Stock restored', NULL),
(6, 5, 5, '2025-04-03 21:22:54', 'Order #12 deleted - Stock restored', NULL),
(7, 3, 5, '2025-04-03 21:23:32', 'Order #10 deleted - Stock restored', NULL),
(8, 2, -1, '2025-04-03 21:28:03', 'Storefront Sale - Order #13', NULL),
(9, 4, -1, '2025-04-03 21:28:03', 'Storefront Sale - Order #13', NULL),
(10, 4, 10, '2025-04-03 21:46:53', 'Order #9 deleted - Stock restored', NULL),
(11, 2, 15, '2025-04-03 22:04:38', 'Order #14 deleted - Stock restored', NULL),
(12, 2, -1, '2025-04-03 22:24:23', 'Storefront Sale - Order #15', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` varchar(255) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `related_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `user_id`, `message`, `type`, `related_id`, `is_read`, `created_at`) VALUES
(1, 1, 'มีคำสั่งซื้อใหม่ #1 จากลูกค้า asd', 'new_order', 1, 1, '2025-04-03 21:30:26'),
(2, 1, 'มีคำสั่งซื้อใหม่ #2 จากลูกค้า asd', 'new_order', 2, 1, '2025-04-03 21:55:39'),
(3, 1, 'มีคำสั่งซื้อใหม่ #3 จากลูกค้า asdasd', 'new_order', 3, 1, '2025-04-03 22:36:38'),
(4, 2, 'มีคำสั่งซื้อใหม่ #3 จากลูกค้า asdasd', 'new_order', 3, 1, '2025-04-03 22:36:38'),
(5, 1, 'มีคำสั่งซื้อใหม่ #4 จากลูกค้า jak papho', 'new_order', 4, 0, '2025-04-03 23:22:13'),
(6, 2, 'มีคำสั่งซื้อใหม่ #4 จากลูกค้า jak papho', 'new_order', 4, 0, '2025-04-03 23:22:13'),
(7, 1, 'มีคำสั่งซื้อใหม่ #5 จากลูกค้า หนองปลา หวาย', 'new_order', 5, 0, '2025-04-03 23:32:10'),
(8, 2, 'มีคำสั่งซื้อใหม่ #5 จากลูกค้า หนองปลา หวาย', 'new_order', 5, 0, '2025-04-03 23:32:10'),
(9, 1, 'มีคำสั่งซื้อใหม่ #6 จากลูกค้า ฟหกฟหก', 'new_order', 6, 0, '2025-04-04 00:49:16'),
(10, 2, 'มีคำสั่งซื้อใหม่ #6 จากลูกค้า ฟหกฟหก', 'new_order', 6, 0, '2025-04-04 00:49:16'),
(11, 1, 'มีคำสั่งซื้อใหม่ #7 จากลูกค้า ห', 'new_order', 7, 0, '2025-04-04 01:16:49'),
(12, 2, 'มีคำสั่งซื้อใหม่ #7 จากลูกค้า ห', 'new_order', 7, 0, '2025-04-04 01:16:49'),
(13, 1, 'มีคำสั่งซื้อใหม่ #9 จากลูกค้า xx', 'new_order', 9, 0, '2025-04-04 04:00:21'),
(14, 2, 'มีคำสั่งซื้อใหม่ #9 จากลูกค้า xx', 'new_order', 9, 0, '2025-04-04 04:00:21'),
(15, 1, 'มีคำสั่งซื้อใหม่ #10 จากลูกค้า asdasd', 'new_order', 10, 0, '2025-04-04 04:00:34'),
(16, 2, 'มีคำสั่งซื้อใหม่ #10 จากลูกค้า asdasd', 'new_order', 10, 0, '2025-04-04 04:00:34'),
(17, 1, 'มีคำสั่งซื้อใหม่ #14 จากลูกค้า xx', 'new_order', 14, 0, '2025-04-04 05:03:59'),
(18, 2, 'มีคำสั่งซื้อใหม่ #14 จากลูกค้า xx', 'new_order', 14, 0, '2025-04-04 05:03:59'),
(19, 1, 'มีการชำระเงินสำหรับคำสั่งซื้อ #4 จากลูกค้า jak papho', 'payment', 4, 0, '2025-04-04 05:05:30'),
(20, 2, 'มีการชำระเงินสำหรับคำสั่งซื้อ #4 จากลูกค้า jak papho', 'payment', 4, 0, '2025-04-04 05:05:30');

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `order_date` datetime DEFAULT NULL,
  `total_amount` float DEFAULT NULL,
  `shipping_address` text DEFAULT NULL,
  `payment_slip` varchar(200) DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `qr_code_path` varchar(200) DEFAULT NULL,
  `pickup_location` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`id`, `customer_id`, `order_date`, `total_amount`, `shipping_address`, `payment_slip`, `payment_date`, `payment_status`, `status`, `notes`, `qr_code_path`, `pickup_location`) VALUES
(2, 1, '2025-04-03 21:55:39', 1900, '', NULL, NULL, 'pending', 'pending', '', 'qrcodes\\qrcode_2.png', NULL),
(3, 2, '2025-04-03 22:36:38', 760, 'asdasd', NULL, NULL, 'pending', 'pending', NULL, 'qrcodes\\qrcode_3.png', NULL),
(4, 3, '2025-04-03 23:22:13', 760, 'เทสเทส', 'slips/d64cdd98-6bd2-4627-a8ed-f691a6f8be4a_1743717930.jpg', '2025-04-04 05:05:30', 'paid', 'pending', NULL, 'qrcodes\\qrcode_4.png', NULL),
(5, 4, '2025-04-03 23:32:10', 1520, 'asdasd', NULL, NULL, 'pending', 'pending', NULL, 'qrcodes\\qrcode_5.png', NULL),
(6, 5, '2025-04-04 00:49:16', 1520, 'asdasdasd', NULL, NULL, 'pending', 'pending', NULL, 'qrcodes\\qrcode_6.png', NULL),
(7, 6, '2025-04-04 01:16:49', 380, 'ฟหกห', NULL, NULL, 'pending', 'pending', NULL, 'qrcodes\\qrcode_7.png', NULL),
(13, 23, '2025-04-03 21:28:03', 760, NULL, NULL, NULL, 'paid', 'completed', 'Payment Method: transfer', NULL, NULL),
(15, 21, '2025-04-03 22:24:23', 380, NULL, NULL, NULL, 'paid', 'completed', 'Payment Method: cash', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_item`
--

CREATE TABLE `order_item` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_item`
--

INSERT INTO `order_item` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 2, 2, 5, 380),
(2, 3, 2, 2, 380),
(3, 4, 2, 2, 380),
(4, 5, 4, 4, 380),
(5, 6, 2, 2, 380),
(6, 6, 6, 2, 380),
(7, 7, 5, 1, 380),
(12, 13, 2, 1, 380),
(13, 13, 4, 1, 380),
(15, 15, 2, 1, 380);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `flavor` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` float NOT NULL,
  `cost` float NOT NULL,
  `wholesale_price` float DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `flavor`, `description`, `price`, `cost`, `wholesale_price`, `stock`, `barcode`, `image_path`, `created_at`) VALUES
(2, 'Marbo 9k', 'STRAWBERRY', '', 380, 310, 360, 18, '', 'products/Marbo-Bar-9k-Strawberry.jpg_1743696566.webp', '2025-04-03 21:38:20'),
(3, 'Marbo 9k', 'STRAWBERRY PEACH', '', 380, 310, 360, 20, '', 'products/Marbo-Bar-9k-Peach-Strawberry.jpg_1743696638.webp', '2025-04-03 23:10:38'),
(4, 'Marbo 9k', 'PEACH', '', 380, 310, 360, 19, '', 'products/Marbo-Bar-9k-Peach.jpg_1743697024.webp', '2025-04-03 23:17:04'),
(5, 'Marbo 9k', 'APPLE ALOE', '', 380, 310, 360, 20, '', 'products/Marbo-Bar-9k-Apple-Aloe.jpg_1743697051.webp', '2025-04-03 23:17:31'),
(6, 'Marbo 9k', 'WATERMELON BUBBLEGUM', '', 380, 310, 360, 20, '', 'products/Marbo-Bar-9k-Watermelon-Bubblegum.jpg_1743697174.webp', '2025-04-03 23:19:34');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `company_logo` varchar(200) DEFAULT NULL,
  `company_address` text DEFAULT NULL,
  `company_phone` varchar(20) DEFAULT NULL,
  `company_email` varchar(100) DEFAULT NULL,
  `low_stock_threshold` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `company_name`, `company_logo`, `company_address`, `company_phone`, `company_email`, `low_stock_threshold`) VALUES
(1, 'WEED 9k Shop', 'logos/avatar_1743719361.png', '123 ถนนสุขุมวิท, กรุงเทพฯ 10110', '087-587-8879', 'info@marbo9k.com', 5);

-- --------------------------------------------------------

--
-- Table structure for table `shop_settings`
--

CREATE TABLE `shop_settings` (
  `id` int(11) NOT NULL,
  `hero_title` varchar(200) DEFAULT NULL,
  `hero_subtitle` varchar(200) DEFAULT NULL,
  `hero_background` varchar(200) DEFAULT NULL,
  `hero_text_color` varchar(20) DEFAULT NULL,
  `hero_button_text` varchar(50) DEFAULT NULL,
  `featured_title` varchar(100) DEFAULT NULL,
  `featured_subtitle` varchar(200) DEFAULT NULL,
  `primary_color` varchar(20) DEFAULT NULL,
  `secondary_color` varchar(20) DEFAULT NULL,
  `accent_color` varchar(20) DEFAULT NULL,
  `text_color` varchar(20) DEFAULT NULL,
  `font_family` varchar(50) DEFAULT NULL,
  `border_radius` int(11) DEFAULT NULL,
  `footer_text` varchar(200) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `social_facebook` varchar(200) DEFAULT NULL,
  `social_instagram` varchar(200) DEFAULT NULL,
  `social_line` varchar(50) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shop_settings`
--

INSERT INTO `shop_settings` (`id`, `hero_title`, `hero_subtitle`, `hero_background`, `hero_text_color`, `hero_button_text`, `featured_title`, `featured_subtitle`, `primary_color`, `secondary_color`, `accent_color`, `text_color`, `font_family`, `border_radius`, `footer_text`, `contact_phone`, `contact_email`, `social_facebook`, `social_instagram`, `social_line`, `updated_at`) VALUES
(1, 'ยินดีต้อนรับสู่ WEED 9k Shop', 'ในเชียงใหม่ ส่งGRAB ชนมือได้ @WEED9k', NULL, '#ffffff', ' เชียงใหม่ หลังมอ เจ็ดยอด สันติธรรม แม่โจ้ ', 'สินค้าแนะนำ', '', '#df6d6d', '#006a71', '#f2efe7', '#333333', 'Kanit', 20, '&copy; 2025 WEED 9k Shop. สงวนลิขสิทธิ์ทุกประการ.', '087-7891234', 'ilovehee@kuy.weed', 'https://www.facebbok.com/Weed9k/', 'https://www.instagram.com/Weed9k/', 'weed9k', '2025-04-04 05:22:48');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password` varchar(200) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `name`, `role`, `created_at`) VALUES
(1, 'admin', 'pbkdf2:sha256:600000$nJitox4vojzWTUte$a3f3652c647482cf1ee132c2891ea0e14c0ea9a3c70e084f8d1afbba61ced3b0', NULL, 'admin', '2025-04-03 21:28:07'),
(2, 'bishak', 'pbkdf2:sha256:600000$4AivrhcrUX3shdkx$0ea19f69a7da3a7eb8b72a68256ee658d07e8c8d52f3279814c281d93ae16f19', 'bishak weeding', 'admin', '2025-04-03 22:30:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `banner`
--
ALTER TABLE `banner`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `featured_product`
--
ALTER TABLE `featured_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `inventory_entry`
--
ALTER TABLE `inventory_entry`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `order_item`
--
ALTER TABLE `order_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shop_settings`
--
ALTER TABLE `shop_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT for table `banner`
--
ALTER TABLE `banner`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `featured_product`
--
ALTER TABLE `featured_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `inventory_entry`
--
ALTER TABLE `inventory_entry`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `order_item`
--
ALTER TABLE `order_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `shop_settings`
--
ALTER TABLE `shop_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `featured_product`
--
ALTER TABLE `featured_product`
  ADD CONSTRAINT `featured_product_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `inventory_entry`
--
ALTER TABLE `inventory_entry`
  ADD CONSTRAINT `inventory_entry_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Constraints for table `order_item`
--
ALTER TABLE `order_item`
  ADD CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`),
  ADD CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
