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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `product` VALUES ('2','Marbo 9k','STRAWBERRY','','380.0','310.0','350.0','3','','products/Marbo-Bar-9k-Strawberry.jpg_1743696566.webp','2025-04-03 21:38:20');

CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `line_id` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `customer` VALUES ('1','asd','asdasd','asdasd',NULL,'2025-04-03 21:30:26');
INSERT INTO `customer` VALUES ('2','asdasd','asd','asdasd',NULL,'2025-04-03 22:36:38');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `order` VALUES ('1','1','2025-04-03 21:30:26','0.0','asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_1.png',NULL);
INSERT INTO `order` VALUES ('2','1','2025-04-03 21:55:39','1900.0','',NULL,NULL,'pending','pending','','qrcodes\qrcode_2.png',NULL);
INSERT INTO `order` VALUES ('3','2','2025-04-03 22:36:38','760.0','asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_3.png',NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `order_item` VALUES ('1','2','2','5','380.0');
INSERT INTO `order_item` VALUES ('2','3','2','2','380.0');

CREATE TABLE `inventory_entry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `inventory_entry_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


