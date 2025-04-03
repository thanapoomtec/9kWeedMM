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

INSERT INTO `user` VALUES ('1','admin','pbkdf2:sha256:600000$nJitox4vojzWTUte$a3f3652c647482cf1ee132c2891ea0e14c0ea9a3c70e084f8d1afbba61ced3b0',NULL,'admin','2025-04-03 21:28:07');
INSERT INTO `user` VALUES ('2','bishak','pbkdf2:sha256:600000$4AivrhcrUX3shdkx$0ea19f69a7da3a7eb8b72a68256ee658d07e8c8d52f3279814c281d93ae16f19','bishak weeding','admin','2025-04-03 22:30:17');
INSERT INTO `user` VALUES ('3','dd','pbkdf2:sha256:600000$3yIX1ol878ok18Ui$b5f199e5d6bbd35d6686ea96687e1262c860f53cb5b636b7ec4d1a198e7473fa','asdsadas','staff','2025-04-03 22:30:35');

CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `line_id` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `customer` VALUES ('1','asd','asdasd','asdasd',NULL,'2025-04-03 21:30:26');
INSERT INTO `customer` VALUES ('2','asdasd','asd','asdasd',NULL,'2025-04-03 22:36:38');
INSERT INTO `customer` VALUES ('3','jak papho','0877895489','เทสเทส',NULL,'2025-04-03 23:22:13');
INSERT INTO `customer` VALUES ('4','หนองปลา หวาย','0879875487','asdasd',NULL,'2025-04-03 23:32:10');
INSERT INTO `customer` VALUES ('5','ฟหกฟหก','sadasd','asdasdasd',NULL,'2025-04-04 00:49:16');
INSERT INTO `customer` VALUES ('6','ห','151561','ฟหกห',NULL,'2025-04-04 01:16:49');
INSERT INTO `customer` VALUES ('15','xx','xxx','xxx',NULL,'2025-04-04 04:00:21');
INSERT INTO `customer` VALUES ('16','asdasd','asdas','asdasd',NULL,'2025-04-04 04:00:34');
INSERT INTO `customer` VALUES ('21','Walk-in Customer','',NULL,NULL,'2025-04-04 04:13:46');
INSERT INTO `customer` VALUES ('22','Sompong','',NULL,NULL,'2025-04-04 04:16:12');

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

INSERT INTO `product` VALUES ('2','Marbo 9k','STRAWBERRY','','380.0','310.0','360.0','19','','products/Marbo-Bar-9k-Strawberry.jpg_1743696566.webp','2025-04-03 21:38:20');
INSERT INTO `product` VALUES ('3','Marbo 9k','STRAWBERRY PEACH','','380.0','310.0','360.0','15','','products/Marbo-Bar-9k-Peach-Strawberry.jpg_1743696638.webp','2025-04-03 23:10:38');
INSERT INTO `product` VALUES ('4','Marbo 9k','PEACH','','380.0','310.0','360.0','10','','products/Marbo-Bar-9k-Peach.jpg_1743697024.webp','2025-04-03 23:17:04');
INSERT INTO `product` VALUES ('5','Marbo 9k','APPLE ALOE','','380.0','310.0','360.0','15','','products/Marbo-Bar-9k-Apple-Aloe.jpg_1743697051.webp','2025-04-03 23:17:31');
INSERT INTO `product` VALUES ('6','Marbo 9k','WATERMELON BUBBLEGUM','','380.0','310.0','360.0','20','','products/Marbo-Bar-9k-Watermelon-Bubblegum.jpg_1743697174.webp','2025-04-03 23:19:34');

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `order` VALUES ('1','1','2025-04-03 21:30:26','0.0','asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_1.png',NULL);
INSERT INTO `order` VALUES ('2','1','2025-04-03 21:55:39','1900.0','',NULL,NULL,'pending','pending','','qrcodes\qrcode_2.png',NULL);
INSERT INTO `order` VALUES ('3','2','2025-04-03 22:36:38','760.0','asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_3.png',NULL);
INSERT INTO `order` VALUES ('4','3','2025-04-03 23:22:13','760.0','เทสเทส',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_4.png',NULL);
INSERT INTO `order` VALUES ('5','4','2025-04-03 23:32:10','1520.0','asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_5.png',NULL);
INSERT INTO `order` VALUES ('6','5','2025-04-04 00:49:16','1520.0','asdasdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_6.png',NULL);
INSERT INTO `order` VALUES ('7','6','2025-04-04 01:16:49','380.0','ฟหกห',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_7.png',NULL);
INSERT INTO `order` VALUES ('9','15','2025-04-04 04:00:21','3800.0','xxx',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_9.png',NULL);
INSERT INTO `order` VALUES ('10','16','2025-04-04 04:00:34','1900.0','asdasd',NULL,NULL,'pending','pending',NULL,'qrcodes\qrcode_10.png',NULL);
INSERT INTO `order` VALUES ('11','21','2025-04-03 21:13:46','380.0',NULL,NULL,NULL,'paid','completed','Payment Method: cash',NULL,NULL);
INSERT INTO `order` VALUES ('12','22','2025-04-03 21:16:12','1900.0',NULL,NULL,NULL,'paid','completed','Payment Method: cash',NULL,NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `order_item` VALUES ('1','2','2','5','380.0');
INSERT INTO `order_item` VALUES ('2','3','2','2','380.0');
INSERT INTO `order_item` VALUES ('3','4','2','2','380.0');
INSERT INTO `order_item` VALUES ('4','5','4','4','380.0');
INSERT INTO `order_item` VALUES ('5','6','2','2','380.0');
INSERT INTO `order_item` VALUES ('6','6','6','2','380.0');
INSERT INTO `order_item` VALUES ('7','7','5','1','380.0');
INSERT INTO `order_item` VALUES ('8','9','4','10','380.0');
INSERT INTO `order_item` VALUES ('9','10','3','5','380.0');
INSERT INTO `order_item` VALUES ('10','11','2','1','380.0');
INSERT INTO `order_item` VALUES ('11','12','5','5','380.0');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `inventory_entry` VALUES ('1','6','10','2025-04-03 23:19:53','',NULL);
INSERT INTO `inventory_entry` VALUES ('3','2','-1','2025-04-03 21:13:46','Storefront Sale - Order #11',NULL);
INSERT INTO `inventory_entry` VALUES ('4','5','-5','2025-04-03 21:16:12','Storefront Sale - Order #12',NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `activity_log` VALUES ('1','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:28:12');
INSERT INTO `activity_log` VALUES ('2','1','add_product','product','1','Added product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:29:48');
INSERT INTO `activity_log` VALUES ('3','1','delete_product','product','1','Deleted product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:30:02');
INSERT INTO `activity_log` VALUES ('4','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:37:02');
INSERT INTO `activity_log` VALUES ('5','1','add_product','product','2','Added product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:38:20');
INSERT INTO `activity_log` VALUES ('6','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:40:14');
INSERT INTO `activity_log` VALUES ('7','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:42:10');
INSERT INTO `activity_log` VALUES ('8','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:45:56');
INSERT INTO `activity_log` VALUES ('9','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:48:20');
INSERT INTO `activity_log` VALUES ('10','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:48:36');
INSERT INTO `activity_log` VALUES ('11','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:49:09');
INSERT INTO `activity_log` VALUES ('12','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:49:09');
INSERT INTO `activity_log` VALUES ('13','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 21:55:04');
INSERT INTO `activity_log` VALUES ('14','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 21:55:16');
INSERT INTO `activity_log` VALUES ('15','1','add_order','order','2','Added order for customer: asd','127.0.0.1','2025-04-03 21:55:39');
INSERT INTO `activity_log` VALUES ('16','1','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 22:24:31');
INSERT INTO `activity_log` VALUES ('17','1','add_user','user','2','Added user: bishak','127.0.0.1','2025-04-03 22:30:17');
INSERT INTO `activity_log` VALUES ('18','1','edit_user','user','2','Edited user: bishak','127.0.0.1','2025-04-03 22:30:24');
INSERT INTO `activity_log` VALUES ('19','1','add_user','user','3','Added user: dd','127.0.0.1','2025-04-03 22:30:35');
INSERT INTO `activity_log` VALUES ('20','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 22:52:19');
INSERT INTO `activity_log` VALUES ('21','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 22:56:17');
INSERT INTO `activity_log` VALUES ('22','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:09:26');
INSERT INTO `activity_log` VALUES ('23','1','add_product','product','3','Added product: Marbo 9k STRAWBERRY PEACH','127.0.0.1','2025-04-03 23:10:38');
INSERT INTO `activity_log` VALUES ('24','1','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:14:43');
INSERT INTO `activity_log` VALUES ('25','1','backup_data',NULL,NULL,'Created backup: db_backup_20250403_231446.sql and data_export_20250403_231446.xlsx','127.0.0.1','2025-04-03 23:15:01');
INSERT INTO `activity_log` VALUES ('26','1','logout',NULL,NULL,NULL,'127.0.0.1','2025-04-03 23:15:54');
INSERT INTO `activity_log` VALUES ('27','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-03 23:15:57');
INSERT INTO `activity_log` VALUES ('28','2','add_product','product','4','Added product: Marbo 9k PEACH','127.0.0.1','2025-04-03 23:17:04');
INSERT INTO `activity_log` VALUES ('29','2','add_product','product','5','Added product: Marbo 9k APPLE ALOE','127.0.0.1','2025-04-03 23:17:31');
INSERT INTO `activity_log` VALUES ('30','2','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:18:16');
INSERT INTO `activity_log` VALUES ('31','2','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:18:40');
INSERT INTO `activity_log` VALUES ('32','2','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-03 23:18:47');
INSERT INTO `activity_log` VALUES ('33','2','edit_product','product','3','Edited product: Marbo 9k STRAWBERRY PEACH','127.0.0.1','2025-04-03 23:18:55');
INSERT INTO `activity_log` VALUES ('34','2','edit_product','product','4','Edited product: Marbo 9k PEACH','127.0.0.1','2025-04-03 23:19:01');
INSERT INTO `activity_log` VALUES ('35','2','edit_product','product','5','Edited product: Marbo 9k APPLE ALOE','127.0.0.1','2025-04-03 23:19:06');
INSERT INTO `activity_log` VALUES ('36','2','add_product','product','6','Added product: Marbo 9k WATERMELON BUBBLEGUM','127.0.0.1','2025-04-03 23:19:34');
INSERT INTO `activity_log` VALUES ('37','2','add_inventory','product','6','Added 10 units to Marbo 9k WATERMELON BUBBLEGUM','127.0.0.1','2025-04-03 23:19:53');
INSERT INTO `activity_log` VALUES ('38','2','backup_data',NULL,NULL,'Created backup: db_backup_20250403_232535.sql and data_export_20250403_232535.xlsx','127.0.0.1','2025-04-03 23:25:40');
INSERT INTO `activity_log` VALUES ('39','2','backup_data',NULL,NULL,'Created backup: db_backup_20250403_235929.sql and data_export_20250403_235929.xlsx','127.0.0.1','2025-04-03 23:59:32');
INSERT INTO `activity_log` VALUES ('40','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 00:10:15');
INSERT INTO `activity_log` VALUES ('41','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 00:34:09');
INSERT INTO `activity_log` VALUES ('42','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 00:34:38');
INSERT INTO `activity_log` VALUES ('43','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:43:33');
INSERT INTO `activity_log` VALUES ('44','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:43:43');
INSERT INTO `activity_log` VALUES ('45','2','add_banner',NULL,NULL,'Added banner: NkornDara','127.0.0.1','2025-04-04 00:45:24');
INSERT INTO `activity_log` VALUES ('46','2','delete_banner',NULL,NULL,'Deleted banner: NkornDara','127.0.0.1','2025-04-04 00:45:49');
INSERT INTO `activity_log` VALUES ('47','2','update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:46:04');
INSERT INTO `activity_log` VALUES ('48','2','update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:47:31');
INSERT INTO `activity_log` VALUES ('49','2','update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:48:19');
INSERT INTO `activity_log` VALUES ('50','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:48:22');
INSERT INTO `activity_log` VALUES ('51','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:48:24');
INSERT INTO `activity_log` VALUES ('52','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 00:48:33');
INSERT INTO `activity_log` VALUES ('53','2','backup_data',NULL,NULL,'Created backup: db_backup_20250404_004926.sql and data_export_20250404_004926.xlsx','127.0.0.1','2025-04-04 00:54:39');
INSERT INTO `activity_log` VALUES ('54','2','backup_data',NULL,NULL,'Created backup: db_backup_20250404_005432.sql and data_export_20250404_005432.xlsx','127.0.0.1','2025-04-04 00:55:34');
INSERT INTO `activity_log` VALUES ('55','2','update_featured_products',NULL,NULL,'Updated featured products','127.0.0.1','2025-04-04 00:58:06');
INSERT INTO `activity_log` VALUES ('56','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 00:58:29');
INSERT INTO `activity_log` VALUES ('57','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 00:59:22');
INSERT INTO `activity_log` VALUES ('58','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 00:59:34');
INSERT INTO `activity_log` VALUES ('59','2','backup_data',NULL,NULL,'Created backup: db_backup_20250404_005530.sql and data_export_20250404_005530.xlsx','127.0.0.1','2025-04-04 01:01:21');
INSERT INTO `activity_log` VALUES ('60','2','add_banner',NULL,NULL,'Added banner: Monkey123','127.0.0.1','2025-04-04 01:05:53');
INSERT INTO `activity_log` VALUES ('61','2','delete_banner',NULL,NULL,'Deleted banner: Monkey123','127.0.0.1','2025-04-04 01:06:19');
INSERT INTO `activity_log` VALUES ('62','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 01:06:44');
INSERT INTO `activity_log` VALUES ('63','2','update_shop_footer',NULL,NULL,'Updated shop footer settings','127.0.0.1','2025-04-04 01:37:30');
INSERT INTO `activity_log` VALUES ('64','2','logout',NULL,NULL,NULL,'127.0.0.1','2025-04-04 01:59:27');
INSERT INTO `activity_log` VALUES ('65','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 01:59:38');
INSERT INTO `activity_log` VALUES ('66','2','edit_product','product','2','Edited product: Marbo 9k STRAWBERRY','127.0.0.1','2025-04-04 02:02:26');
INSERT INTO `activity_log` VALUES ('67','2','edit_product','product','4','Edited product: Marbo 9k PEACH','127.0.0.1','2025-04-04 02:02:33');
INSERT INTO `activity_log` VALUES ('68','2','edit_product','product','3','Edited product: Marbo 9k STRAWBERRY PEACH','127.0.0.1','2025-04-04 02:02:40');
INSERT INTO `activity_log` VALUES ('69','2','edit_product','product','5','Edited product: Marbo 9k APPLE ALOE','127.0.0.1','2025-04-04 02:02:44');
INSERT INTO `activity_log` VALUES ('70','2','edit_product','product','6','Edited product: Marbo 9k WATERMELON BUBBLEGUM','127.0.0.1','2025-04-04 02:02:48');
INSERT INTO `activity_log` VALUES ('71','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 02:05:42');
INSERT INTO `activity_log` VALUES ('72','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 02:05:58');
INSERT INTO `activity_log` VALUES ('73','2','login',NULL,NULL,NULL,'127.0.0.1','2025-04-04 02:06:03');
INSERT INTO `activity_log` VALUES ('74','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:48:05');
INSERT INTO `activity_log` VALUES ('75','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:50:46');
INSERT INTO `activity_log` VALUES ('76','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:51:20');
INSERT INTO `activity_log` VALUES ('77','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:51:49');
INSERT INTO `activity_log` VALUES ('78','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:52:10');
INSERT INTO `activity_log` VALUES ('79','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:52:57');
INSERT INTO `activity_log` VALUES ('80','2','update_shop_theme',NULL,NULL,'Updated shop theme settings','127.0.0.1','2025-04-04 03:53:25');
INSERT INTO `activity_log` VALUES ('81','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:07');
INSERT INTO `activity_log` VALUES ('82','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:08');
INSERT INTO `activity_log` VALUES ('83','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:48');
INSERT INTO `activity_log` VALUES ('84','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:54:50');
INSERT INTO `activity_log` VALUES ('85','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:55:00');
INSERT INTO `activity_log` VALUES ('86','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:55:02');
INSERT INTO `activity_log` VALUES ('87','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:55:03');
INSERT INTO `activity_log` VALUES ('88','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:25');
INSERT INTO `activity_log` VALUES ('89','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:27');
INSERT INTO `activity_log` VALUES ('90','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:37');
INSERT INTO `activity_log` VALUES ('91','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:48');
INSERT INTO `activity_log` VALUES ('92','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:56:58');
INSERT INTO `activity_log` VALUES ('93','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:57:02');
INSERT INTO `activity_log` VALUES ('94','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:57:06');
INSERT INTO `activity_log` VALUES ('95','2','update_shop_hero',NULL,NULL,'Updated shop hero section','127.0.0.1','2025-04-04 03:57:06');
INSERT INTO `activity_log` VALUES ('96','2','add_banner',NULL,NULL,'Added banner: Monkeyt','127.0.0.1','2025-04-04 04:01:59');
INSERT INTO `activity_log` VALUES ('97','2','delete_banner',NULL,NULL,'Deleted banner: Monkeyt','127.0.0.1','2025-04-04 04:02:14');

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

INSERT INTO `notification` VALUES ('1','1','มีคำสั่งซื้อใหม่ #1 จากลูกค้า asd','new_order','1','1','2025-04-03 21:30:26');
INSERT INTO `notification` VALUES ('2','1','มีคำสั่งซื้อใหม่ #2 จากลูกค้า asd','new_order','2','1','2025-04-03 21:55:39');
INSERT INTO `notification` VALUES ('3','1','มีคำสั่งซื้อใหม่ #3 จากลูกค้า asdasd','new_order','3','1','2025-04-03 22:36:38');
INSERT INTO `notification` VALUES ('4','2','มีคำสั่งซื้อใหม่ #3 จากลูกค้า asdasd','new_order','3','1','2025-04-03 22:36:38');
INSERT INTO `notification` VALUES ('5','1','มีคำสั่งซื้อใหม่ #4 จากลูกค้า jak papho','new_order','4','0','2025-04-03 23:22:13');
INSERT INTO `notification` VALUES ('6','2','มีคำสั่งซื้อใหม่ #4 จากลูกค้า jak papho','new_order','4','0','2025-04-03 23:22:13');
INSERT INTO `notification` VALUES ('7','1','มีคำสั่งซื้อใหม่ #5 จากลูกค้า หนองปลา หวาย','new_order','5','0','2025-04-03 23:32:10');
INSERT INTO `notification` VALUES ('8','2','มีคำสั่งซื้อใหม่ #5 จากลูกค้า หนองปลา หวาย','new_order','5','0','2025-04-03 23:32:10');
INSERT INTO `notification` VALUES ('9','1','มีคำสั่งซื้อใหม่ #6 จากลูกค้า ฟหกฟหก','new_order','6','0','2025-04-04 00:49:16');
INSERT INTO `notification` VALUES ('10','2','มีคำสั่งซื้อใหม่ #6 จากลูกค้า ฟหกฟหก','new_order','6','0','2025-04-04 00:49:16');
INSERT INTO `notification` VALUES ('11','1','มีคำสั่งซื้อใหม่ #7 จากลูกค้า ห','new_order','7','0','2025-04-04 01:16:49');
INSERT INTO `notification` VALUES ('12','2','มีคำสั่งซื้อใหม่ #7 จากลูกค้า ห','new_order','7','0','2025-04-04 01:16:49');
INSERT INTO `notification` VALUES ('13','1','มีคำสั่งซื้อใหม่ #9 จากลูกค้า xx','new_order','9','0','2025-04-04 04:00:21');
INSERT INTO `notification` VALUES ('14','2','มีคำสั่งซื้อใหม่ #9 จากลูกค้า xx','new_order','9','0','2025-04-04 04:00:21');
INSERT INTO `notification` VALUES ('15','1','มีคำสั่งซื้อใหม่ #10 จากลูกค้า asdasd','new_order','10','0','2025-04-04 04:00:34');
INSERT INTO `notification` VALUES ('16','2','มีคำสั่งซื้อใหม่ #10 จากลูกค้า asdasd','new_order','10','0','2025-04-04 04:00:34');

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


