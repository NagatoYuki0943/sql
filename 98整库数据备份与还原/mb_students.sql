-- MySQL dump 10.13  Distrib 8.0.12, for Win64 (x86_64)
--
-- Host: localhost    Database: mb
-- ------------------------------------------------------
-- Server version	8.0.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `mb_students1`
--

DROP TABLE IF EXISTS `mb_students1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `mb_students1` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sex` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `age` int(255) DEFAULT NULL,
  `class` int(255) DEFAULT NULL,
  `score` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=89 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mb_students1`
--

LOCK TABLES `mb_students1` WRITE;
/*!40000 ALTER TABLE `mb_students1` DISABLE KEYS */;
INSERT INTO `mb_students1` VALUES (1,'赵一','male',15,1,58),(2,'钱二','female',16,2,55),(3,'孙三','male',16,2,88),(88,'李四','male',11,1,100),(5,'周五','female',15,2,88),(6,'吴六','male',16,1,75),(7,'郑七','female',16,1,87),(8,'王八','male',16,3,88),(9,'冯九','male',14,3,45),(10,'陈十','female',14,4,85),(11,'褚十一','female',16,3,85),(12,'卫十二','male',17,4,85),(13,'蒋十三','female',13,5,33),(14,'沈十四','male',16,4,11),(15,'韩十五','female ',14,3,49),(16,'杨十六','male',17,5,94),(17,'朱十七','female',19,5,60),(18,'秦十八','male',17,4,11),(19,'尤十九','female ',11,5,NULL),(20,'许二十','male',17,6,44),(21,'何二十一','male',16,3,58),(22,'吕二十二','female',15,6,59),(23,'施二十三','male',14,5,86),(24,'张二十四','female',18,6,88),(25,'孔二十五','male',14,6,80),(26,'曹二十六','female',15,5,55);
/*!40000 ALTER TABLE `mb_students1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mb_students2`
--

DROP TABLE IF EXISTS `mb_students2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `mb_students2` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sex` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `age` int(255) DEFAULT NULL,
  `class` int(255) DEFAULT NULL,
  `score` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mb_students2`
--

LOCK TABLES `mb_students2` WRITE;
/*!40000 ALTER TABLE `mb_students2` DISABLE KEYS */;
INSERT INTO `mb_students2` VALUES (1,'赵一','male',15,1,58),(2,'钱二','female',16,2,55),(3,'孙三','male',16,2,88),(4,'李四','male',11,1,100),(5,'周五','female',15,2,88),(6,'吴六','male',16,1,75),(7,'郑七','female',16,1,87),(8,'王八','male',16,3,88),(9,'冯九','male',14,3,45),(10,'陈十','female',14,4,85),(11,'褚十一','female',16,3,85),(55,'卫十二','male',17,4,85),(13,'蒋十三','female',13,5,33),(14,'沈十四','male',16,4,11),(15,'韩十五','female ',14,3,49),(16,'杨十六','male',17,5,94),(17,'朱十七','female',19,5,60),(18,'秦十八','male',17,4,11),(19,'尤十九','female ',11,5,0),(30,'许二十','male',17,6,44),(31,'何二十一','male',16,3,58),(32,'吕二十二','female',15,6,59),(33,'施二十三','male',14,5,86),(34,'张二十四','female',18,6,88),(35,'孔二十五','male',14,6,80),(36,'曹二十六','female',15,4,55);
/*!40000 ALTER TABLE `mb_students2` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-03 20:04:07
