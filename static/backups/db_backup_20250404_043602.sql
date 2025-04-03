-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: marbo9k
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (1,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:28:12'),(2,1,'add_product','product',1,'Added product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:29:48'),(3,1,'delete_product','product',1,'Deleted product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:30:02'),(4,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:37:02'),(5,1,'add_product','product',2,'Added product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:38:20'),(6,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:40:14'),(7,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:42:10'),(8,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:45:56'),(9,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:48:20'),(10,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:48:36'),(11,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:49:09'),(12,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:49:09'),(13,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:55:04'),(14,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:55:16'),(15,1,'add_order','order',2,'Added order for customer: asd','127.0.0.1','2025-04-03 21:55:39'),(16,1,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 22:24:31'),(17,1,'add_user','user',2,'Added user: bishak','127.0.0.1','2025-04-03 22:30:17'),(18,1,'edit_user','user',2,'Edited user: bishak','127.0.0.1','2025-04-03 22:30:24'),(19,1,'add_user','user',3,'Added user: dd','127.0.0.1','2025-04-03 22:30:35'),(20,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 22:52:19'),(21,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 22:56:17'),(22,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:09:26'),(23,1,'add_product','product',3,'Added product: Marbo 9k STRAWBERRY PEACH','127.0.0.1','2025-04-03 23:10:38'),(24,1,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:14:43'),(25,1,'backup_data',NULL,NULL,'Created backup: db_backup_20250403_231446.sql and data_export_20250403_231446.xlsx','127.0.0.1','2025-04-03 23:15:01'),(26,1,'logout',NULL,NULL,NULL,'127.0.0.1','2025-04-03 23:15:54'),(27,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 23:15:57'),(28,2,'add_product','product',4,'Added product: Marbo 9k PEACH','127.0.0.1','2025-04-03 23:17:04'),(29,2,'add_product','product',5,'Added product: Marbo 9k APPLE ALOE','127.0.0.1','2025-04-03 23:17:31'),(30,2,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:18:16'),(31,2,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:18:40'),(32,2,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:18:47'),(33,2,'edit_product','product',3,'Edited product: Marbo 9k STRAWBERRY PEACH','127.0.0.1','2025-04-03 23:18:55'),(34,2,'edit_product','product',4,'Edited product: Marbo 9k PEACH','127.0.0.1','2025-04-03 23:19:01'),(35,2,'edit_product','product',5,'Edited product: Marbo 9k APPLE ALOE','127.0.0.1','2025-04-03 23:19:06'),(36,2,'add_product','product',6,'Added product: Marbo 9k WATERMELON BUBBLEGUM','127.0.0.1','2025-04-03 23:19:34'),(37,2,'add_inventory','product',6,'Added 10 units to Marbo 9k WATERMELON BUBBLEGUM','127.0.0.1','2025-04-03 23:19:53'),(38,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250403_232535.sql and data_export_20250403_232535.xlsx','127.0.0.1','2025-04-03 23:25:40'),(39,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250403_235929.sql and data_export_20250403_235929.xlsx','127.0.0.1','2025-04-03 23:59:32'),(40,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 00:10:15'),(41,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 00:34:09'),(42,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 00:34:38'),(43,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:43:33'),(44,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:43:43'),(45,2,'add_banner',NULL,NULL,'Added banner: NkornDara','127.0.0.1','2025-04-04 00:45:24'),(46,2,'delete_banner',NULL,NULL,'Deleted banner: NkornDara','127.0.0.1','2025-04-04 00:45:49'),(47,2,'update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:46:04'),(48,2,'update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:47:31'),(49,2,'update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:48:19'),(50,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:48:22'),(51,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:48:24'),(52,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:48:33'),(53,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250404_004926.sql and data_export_20250404_004926.xlsx','127.0.0.1','2025-04-04 00:54:39'),(54,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250404_005432.sql and data_export_20250404_005432.xlsx','127.0.0.1','2025-04-04 00:55:34'),(55,2,'update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:58:06'),(56,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 00:58:29'),(57,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 00:59:22'),(58,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 00:59:34'),(59,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250404_005530.sql and data_export_20250404_005530.xlsx','127.0.0.1','2025-04-04 01:01:21'),(60,2,'add_banner',NULL,NULL,'Added banner: Monkey123','127.0.0.1','2025-04-04 01:05:53'),(61,2,'delete_banner',NULL,NULL,'Deleted banner: Monkey123','127.0.0.1','2025-04-04 01:06:19'),(62,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 01:06:44'),(63,2,'update_shop_footer',NULL,NULL,'Updated shop footer settings','127.0.0.1','2025-04-04 01:37:30'),(64,2,'logout',NULL,NULL,NULL,'127.0.0.1','2025-04-04 01:59:27'),(65,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 01:59:38'),(66,2,'edit_product','product',2,'Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-04 02:02:26'),(67,2,'edit_product','product',4,'Edited product: Marbo 9k PEACH','127.0.0.1','2025-04-04 02:02:33'),(68,2,'edit_product','product',3,'Edited product: Marbo 9k STRAWBERRY PEACH','127.0.0.1','2025-04-04 02:02:40'),(69,2,'edit_product','product',5,'Edited product: Marbo 9k APPLE ALOE','127.0.0.1','2025-04-04 02:02:44'),(70,2,'edit_product','product',6,'Edited product: Marbo 9k WATERMELON BUBBLEGUM','127.0.0.1','2025-04-04 02:02:48'),(71,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 02:05:42'),(72,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 02:05:58'),(73,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 02:06:03'),(74,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:48:05'),(75,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:50:46'),(76,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:51:20'),(77,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:51:49'),(78,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:52:10'),(79,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:52:57'),(80,2,'update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:53:25'),(81,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:07'),(82,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:08'),(83,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:48'),(84,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:50'),(85,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:55:00'),(86,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:55:02'),(87,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:55:03'),(88,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:25'),(89,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:27'),(90,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:37'),(91,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:48'),(92,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:58'),(93,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:57:02'),(94,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:57:06'),(95,2,'update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:57:06'),(96,2,'add_banner',NULL,NULL,'Added banner: Monkeyt','127.0.0.1','2025-04-04 04:01:59'),(97,2,'delete_banner',NULL,NULL,'Deleted banner: Monkeyt','127.0.0.1','2025-04-04 04:02:14'),(98,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250404_041638.sql and data_export_20250404_041638.xlsx','127.0.0.1','2025-04-04 04:16:44'),(99,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250404_042940.sql and data_export_20250404_042940.xlsx','127.0.0.1','2025-04-04 04:29:44'),(100,2,'backup_data',NULL,NULL,'Created backup: db_backup_20250404_043136.sql and data_export_20250404_043136.xlsx','127.0.0.1','2025-04-04 04:31:38'),(101,2,'login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 04:38:39'),(102,2,'delete_user','user',3,'Deleted user: dd','127.0.0.1','2025-04-04 04:40:24');
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banner`
--

DROP TABLE IF EXISTS `banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `image_path` varchar(200) NOT NULL,
  `link` varchar(200) DEFAULT NULL,
  `position` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner`
--

LOCK TABLES `banner` WRITE;
/*!40000 ALTER TABLE `banner` DISABLE KEYS */;
/*!40000 ALTER TABLE `banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `line_id` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'asd','asdasd','asdasd',NULL,'2025-04-03 21:30:26'),(2,'asdasd','asd','asdasd',NULL,'2025-04-03 22:36:38'),(3,'jak papho','0877895489','เทสเทส',NULL,'2025-04-03 23:22:13'),(4,'หนองปลา หวาย','0879875487','asdasd',NULL,'2025-04-03 23:32:10'),(5,'ฟหกฟหก','sadasd','asdasdasd',NULL,'2025-04-04 00:49:16'),(6,'ห','151561','ฟหกห',NULL,'2025-04-04 01:16:49'),(15,'xx','xxx','xxx',NULL,'2025-04-04 04:00:21'),(16,'asdasd','asdas','asdasd',NULL,'2025-04-04 04:00:34'),(21,'Walk-in Customer','',NULL,NULL,'2025-04-04 04:13:46'),(22,'Sompong','',NULL,NULL,'2025-04-04 04:16:12'),(23,'David luis','',NULL,NULL,'2025-04-04 04:28:03');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featured_product`
--

DROP TABLE IF EXISTS `featured_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `featured_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `featured_product_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featured_product`
--

LOCK TABLES `featured_product` WRITE;
/*!40000 ALTER TABLE `featured_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `featured_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_entry`
--

DROP TABLE IF EXISTS `inventory_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory_entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `inventory_entry_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_entry`
--

LOCK TABLES `inventory_entry` WRITE;
/*!40000 ALTER TABLE `inventory_entry` DISABLE KEYS */;
INSERT INTO `inventory_entry` VALUES (1,6,10,'2025-04-03 23:19:53','',NULL),(3,2,-1,'2025-04-03 21:13:46','Storefront Sale - Order #11',NULL),(4,5,-5,'2025-04-03 21:16:12','Storefront Sale - Order #12',NULL),(5,2,1,'2025-04-03 21:22:35','Order #11 deleted - Stock restored',NULL),(6,5,5,'2025-04-03 21:22:54','Order #12 deleted - Stock restored',NULL),(7,3,5,'2025-04-03 21:23:32','Order #10 deleted - Stock restored',NULL),(8,2,-1,'2025-04-03 21:28:03','Storefront Sale - Order #13',NULL),(9,4,-1,'2025-04-03 21:28:03','Storefront Sale - Order #13',NULL);
/*!40000 ALTER TABLE `inventory_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `message` varchar(255) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `related_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,1,'มีคำสั่งซื้อใหม่ #1 จากลูกค้า asd','new_order',1,1,'2025-04-03 21:30:26'),(2,1,'มีคำสั่งซื้อใหม่ #2 จากลูกค้า asd','new_order',2,1,'2025-04-03 21:55:39'),(3,1,'มีคำสั่งซื้อใหม่ #3 จากลูกค้า asdasd','new_order',3,1,'2025-04-03 22:36:38'),(4,2,'มีคำสั่งซื้อใหม่ #3 จากลูกค้า asdasd','new_order',3,1,'2025-04-03 22:36:38'),(5,1,'มีคำสั่งซื้อใหม่ #4 จากลูกค้า jak papho','new_order',4,0,'2025-04-03 23:22:13'),(6,2,'มีคำสั่งซื้อใหม่ #4 จากลูกค้า jak papho','new_order',4,0,'2025-04-03 23:22:13'),(7,1,'มีคำสั่งซื้อใหม่ #5 จากลูกค้า หนองปลา หวาย','new_order',5,0,'2025-04-03 23:32:10'),(8,2,'มีคำสั่งซื้อใหม่ #5 จากลูกค้า หนองปลา หวาย','new_order',5,0,'2025-04-03 23:32:10'),(9,1,'มีคำสั่งซื้อใหม่ #6 จากลูกค้า ฟหกฟหก','new_order',6,0,'2025-04-04 00:49:16'),(10,2,'มีคำสั่งซื้อใหม่ #6 จากลูกค้า ฟหกฟหก','new_order',6,0,'2025-04-04 00:49:16'),(11,1,'มีคำสั่งซื้อใหม่ #7 จากลูกค้า ห','new_order',7,0,'2025-04-04 01:16:49'),(12,2,'มีคำสั่งซื้อใหม่ #7 จากลูกค้า ห','new_order',7,0,'2025-04-04 01:16:49'),(13,1,'มีคำสั่งซื้อใหม่ #9 จากลูกค้า xx','new_order',9,0,'2025-04-04 04:00:21'),(14,2,'มีคำสั่งซื้อใหม่ #9 จากลูกค้า xx','new_order',9,0,'2025-04-04 04:00:21'),(15,1,'มีคำสั่งซื้อใหม่ #10 จากลูกค้า asdasd','new_order',10,0,'2025-04-04 04:00:34'),(16,2,'มีคำสั่งซื้อใหม่ #10 จากลูกค้า asdasd','new_order',10,0,'2025-04-04 04:00:34');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `pickup_location` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,1,'2025-04-03 21:30:26',0,'asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\\qrcode_1.png',NULL),(2,1,'2025-04-03 21:55:39',1900,'',NULL,NULL,'pending','pending','','qrcodes\\qrcode_2.png',NULL),(3,2,'2025-04-03 22:36:38',760,'asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\\qrcode_3.png',NULL),(4,3,'2025-04-03 23:22:13',760,'เทสเทส',NULL,NULL,'pending','pending',NULL,'qrcodes\\qrcode_4.png',NULL),(5,4,'2025-04-03 23:32:10',1520,'asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\\qrcode_5.png',NULL),(6,5,'2025-04-04 00:49:16',1520,'asdasdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\\qrcode_6.png',NULL),(7,6,'2025-04-04 01:16:49',380,'ฟหกห',NULL,NULL,'pending','pending',NULL,'qrcodes\\qrcode_7.png',NULL),(9,15,'2025-04-04 04:00:21',3800,'xxx',NULL,NULL,'pending','pending',NULL,'qrcodes\\qrcode_9.png',NULL),(13,23,'2025-04-03 21:28:03',760,NULL,NULL,NULL,'paid','completed','Payment Method: transfer',NULL,NULL);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`),
  CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,2,2,5,380),(2,3,2,2,380),(3,4,2,2,380),(4,5,4,4,380),(5,6,2,2,380),(6,6,6,2,380),(7,7,5,1,380),(8,9,4,10,380),(12,13,2,1,380),(13,13,4,1,380);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `flavor` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` float NOT NULL,
  `cost` float NOT NULL,
  `wholesale_price` float DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (2,'Marbo 9k','STRAWBERRY','',380,310,360,19,'','products/Marbo-Bar-9k-Strawberry.jpg_1743696566.webp','2025-04-03 21:38:20'),(3,'Marbo 9k','STRAWBERRY PEACH','',380,310,360,20,'','products/Marbo-Bar-9k-Peach-Strawberry.jpg_1743696638.webp','2025-04-03 23:10:38'),(4,'Marbo 9k','PEACH','',380,310,360,9,'','products/Marbo-Bar-9k-Peach.jpg_1743697024.webp','2025-04-03 23:17:04'),(5,'Marbo 9k','APPLE ALOE','',380,310,360,20,'','products/Marbo-Bar-9k-Apple-Aloe.jpg_1743697051.webp','2025-04-03 23:17:31'),(6,'Marbo 9k','WATERMELON BUBBLEGUM','',380,310,360,20,'','products/Marbo-Bar-9k-Watermelon-Bubblegum.jpg_1743697174.webp','2025-04-03 23:19:34');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) DEFAULT NULL,
  `company_logo` varchar(200) DEFAULT NULL,
  `company_address` text DEFAULT NULL,
  `company_phone` varchar(20) DEFAULT NULL,
  `company_email` varchar(100) DEFAULT NULL,
  `low_stock_threshold` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_settings`
--

DROP TABLE IF EXISTS `shop_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_settings`
--

LOCK TABLES `shop_settings` WRITE;
/*!40000 ALTER TABLE `shop_settings` DISABLE KEYS */;
INSERT INTO `shop_settings` VALUES (1,'ยินดีต้อนรับสู่ WEED 9k Shop','ส่งGRAB ชนมือได้ @WEED9k',NULL,'#ffffff',' เชียงใหม่ หลังมอ เจ็ดยอด สันติธรรม แม่โจ้ ','สินค้าแนะนำ','','#48a6a7','#006a71','#f2efe7','#333333','Kanit',20,'&copy; 2025 WEED 9k Shop. สงวนลิขสิทธิ์ทุกประการ.','087-7891234','ilovehee@kuy.weed','https://www.facebbok.com/Weed9k/','https://www.instagram.com/Weed9k/','weed9k','2025-04-04 03:57:06');
/*!40000 ALTER TABLE `shop_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL,
  `password` varchar(200) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','pbkdf2:sha256:600000$nJitox4vojzWTUte$a3f3652c647482cf1ee132c2891ea0e14c0ea9a3c70e084f8d1afbba61ced3b0',NULL,'admin','2025-04-03 21:28:07'),(2,'bishak','pbkdf2:sha256:600000$4AivrhcrUX3shdkx$0ea19f69a7da3a7eb8b72a68256ee658d07e8c8d52f3279814c281d93ae16f19','bishak weeding','admin','2025-04-03 22:30:17');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-04  4:42:34
