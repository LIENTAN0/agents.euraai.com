-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: company_directory
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `address` text,
  `image_url` varchar(255) DEFAULT NULL,
  `source` enum('修理工会','Map','Facebook','Google') DEFAULT NULL,
  `area` varchar(50) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'AA Seng Motor Sdn Bhd','016-331 6666','www.aasengmotor.com','','No. 17, Jalan 10/32, Taman Jinjang Baru, 52000 Kuala Lumpur.','/images/aaseng.jpeg','修理工会','Jinjang',3.21760000,101.65670000,'2024-10-30 07:32:22','2024-10-30 07:32:22'),(2,'B&W Auto Service','012-345 6789','','','Lot 123, Jalan Kepong, 52100 Kuala Lumpur.','/images/default.jpg','Facebook','Kepong',3.20870000,101.63410000,'2024-10-30 07:32:22','2024-10-30 09:08:25'),(3,'Car Master Workshop','013-987 6543','','','45, Jalan Segambut, 51200 Kuala Lumpur.','/images/default.jpg','Google','Segambut',3.18970000,101.67890000,'2024-10-30 07:32:22','2024-10-30 07:32:22'),(4,'MS AUTO service & diagnose','013-6828287',NULL,NULL,'12G, Jalan Bandar 2, Pusat Bandar Puchong, 47100 Puchong, Selangor',NULL,'Map','Puchong',3.18970000,101.67890000,'2024-10-30 08:04:50','2024-10-30 08:05:30'),(5,'MS AUTO service & diagnose','013-6828287',NULL,NULL,'12G, Jalan Bandar 2, Pusat Bandar Puchong, 47100 Puchong, Selangor',NULL,'Map','Kuala Lumpur',3.18970000,101.67890000,'2024-10-30 08:04:54','2024-10-30 08:05:30');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-30 17:26:17
