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
-- Table structure for table `auto`
--

DROP TABLE IF EXISTS `auto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `auto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL COMMENT '用户名',
  `pass` varchar(50) NOT NULL COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auto`
--

LOCK TABLES `auto` WRITE;
/*!40000 ALTER TABLE `auto` DISABLE KEYS */;
INSERT INTO `auto` VALUES (1,'tom','123');
/*!40000 ALTER TABLE `auto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `comment` (
  `name` varchar(10) NOT NULL COMMENT '当前是用户名,且不为空',
  `pass` varchar(50) NOT NULL COMMENT '密码不能为空'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `date`
--

DROP TABLE IF EXISTS `date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `date` (
  `d1` date DEFAULT NULL,
  `d2` time DEFAULT NULL,
  `d3` datetime DEFAULT NULL,
  `d4` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `d5` year(4) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `date`
--

LOCK TABLES `date` WRITE;
/*!40000 ALTER TABLE `date` DISABLE KEYS */;
INSERT INTO `date` VALUES ('2000-01-01','14:14:14','1900-01-01 14:14:14','2020-09-29 11:55:19',2069),('1900-01-01','14:14:14','1900-01-01 14:14:14','1999-01-01 06:14:14',2015),('1900-01-01','14:14:14','1900-01-01 14:14:14','1999-01-01 06:14:14',1970),('1900-01-01','110:14:14','1900-01-01 14:14:14','1999-01-01 06:14:14',1970),('1900-01-01','132:12:13','1900-01-01 14:14:14','1999-01-01 06:14:14',1970);
/*!40000 ALTER TABLE `date` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `decimal1`
--

DROP TABLE IF EXISTS `decimal1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `decimal1` (
  `f1` float(10,2) DEFAULT NULL,
  `d1` decimal(10,2) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decimal1`
--

LOCK TABLES `decimal1` WRITE;
/*!40000 ALTER TABLE `decimal1` DISABLE KEYS */;
INSERT INTO `decimal1` VALUES (12345679.00,12345678.90),(100000000.00,99999999.99);
/*!40000 ALTER TABLE `decimal1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `default`
--

DROP TABLE IF EXISTS `default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `default` (
  `name` varchar(10) NOT NULL,
  `age` int(11) DEFAULT '18'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `default`
--

LOCK TABLES `default` WRITE;
/*!40000 ALTER TABLE `default` DISABLE KEYS */;
INSERT INTO `default` VALUES ('小明',18),('小红',18);
/*!40000 ALTER TABLE `default` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enum`
--

DROP TABLE IF EXISTS `enum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `enum` (
  `gender` enum('男','女','保密') DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enum`
--

LOCK TABLES `enum` WRITE;
/*!40000 ALTER TABLE `enum` DISABLE KEYS */;
INSERT INTO `enum` VALUES ('男'),('女'),('保密'),('男'),('女'),('保密');
/*!40000 ALTER TABLE `enum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `float1`
--

DROP TABLE IF EXISTS `float1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `float1` (
  `f1` float DEFAULT NULL,
  `f2` float(10,3) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `float1`
--

LOCK TABLES `float1` WRITE;
/*!40000 ALTER TABLE `float1` DISABLE KEYS */;
INSERT INTO `float1` VALUES (10.5424,1234567.125),(10.5424,12345.155),(10.24,10000000.000);
/*!40000 ALTER TABLE `float1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gbk`
--

DROP TABLE IF EXISTS `gbk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gbk` (
  `name` varchar(32766) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=gbk;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gbk`
--

LOCK TABLES `gbk` WRITE;
/*!40000 ALTER TABLE `gbk` DISABLE KEYS */;
/*!40000 ALTER TABLE `gbk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `int1`
--

DROP TABLE IF EXISTS `int1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `int1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `int_1` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `int1`
--

LOCK TABLES `int1` WRITE;
/*!40000 ALTER TABLE `int1` DISABLE KEYS */;
INSERT INTO `int1` VALUES (1,1),(2,2),(3,4),(4,55),(5,51),(6,3),(7,3),(8,5),(9,8),(10,0);
/*!40000 ALTER TABLE `int1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `int2`
--

DROP TABLE IF EXISTS `int2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `int2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `int_1` int(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `int2`
--

LOCK TABLES `int2` WRITE;
/*!40000 ALTER TABLE `int2` DISABLE KEYS */;
INSERT INTO `int2` VALUES (4,46),(5,51),(6,3),(7,3),(8,9),(9,97),(10,66),(11,14),(12,54),(13,85),(14,0),(15,0),(16,99);
/*!40000 ALTER TABLE `int2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `int3`
--

DROP TABLE IF EXISTS `int3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `int3` (
  `int_1` tinyint(4) DEFAULT NULL,
  `int_2` smallint(6) DEFAULT NULL,
  `int_3` mediumint(9) DEFAULT NULL,
  `int_4` int(11) DEFAULT NULL,
  `int_5` bigint(20) DEFAULT NULL,
  `int_6` tinyint(3) unsigned DEFAULT NULL,
  `int_7` tinyint(3) unsigned zerofill DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `int3`
--

LOCK TABLES `int3` WRITE;
/*!40000 ALTER TABLE `int3` DISABLE KEYS */;
INSERT INTO `int3` VALUES (10,10000,100000,100000000,100000000000,NULL,NULL),(10,10000,100000,100000000,100000000000,255,NULL),(1,1,1,1,1,1,001);
/*!40000 ALTER TABLE `int3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pri1`
--

DROP TABLE IF EXISTS `pri1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pri1` (
  `username` varchar(10) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pri1`
--

LOCK TABLES `pri1` WRITE;
/*!40000 ALTER TABLE `pri1` DISABLE KEYS */;
/*!40000 ALTER TABLE `pri1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pri2`
--

DROP TABLE IF EXISTS `pri2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pri2` (
  `username` varchar(10) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pri2`
--

LOCK TABLES `pri2` WRITE;
/*!40000 ALTER TABLE `pri2` DISABLE KEYS */;
/*!40000 ALTER TABLE `pri2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pri3`
--

DROP TABLE IF EXISTS `pri3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `pri3` (
  `username` varchar(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pri3`
--

LOCK TABLES `pri3` WRITE;
/*!40000 ALTER TABLE `pri3` DISABLE KEYS */;
/*!40000 ALTER TABLE `pri3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score`
--

DROP TABLE IF EXISTS `score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `score` (
  `student_no` char(10) NOT NULL,
  `course_no` char(10) NOT NULL,
  `score` tinyint(4) NOT NULL,
  PRIMARY KEY (`student_no`,`course_no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score`
--

LOCK TABLES `score` WRITE;
/*!40000 ALTER TABLE `score` DISABLE KEYS */;
INSERT INTO `score` VALUES ('00000001','course001',100),('00000002','course001',100),('00000001','course002',100);
/*!40000 ALTER TABLE `score` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `set`
--

DROP TABLE IF EXISTS `set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `set` (
  `hobby` set('篮球','足球','羽毛球','乒乓球','网球','橄榄球','冰球','高俅') DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `set`
--

LOCK TABLES `set` WRITE;
/*!40000 ALTER TABLE `set` DISABLE KEYS */;
INSERT INTO `set` VALUES ('篮球,足球,乒乓球'),('篮球,足球,乒乓球,冰球,高俅'),('篮球,足球,羽毛球,乒乓球,网球,橄榄球,冰球,高俅'),('篮球');
/*!40000 ALTER TABLE `set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `simple`
--

DROP TABLE IF EXISTS `simple`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `simple` (
  `name` char(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `simple`
--

LOCK TABLES `simple` WRITE;
/*!40000 ALTER TABLE `simple` DISABLE KEYS */;
INSERT INTO `simple` VALUES ('e'),('b'),('c'),('d'),('e'),('b'),('c'),('d'),('e'),('b'),('c'),('d'),('e'),('b'),('c'),('d'),('a'),('b'),('c'),('d'),('a'),('b'),('c'),('d'),('a'),('b'),('c'),('d'),('a'),('b'),('c'),('d');
/*!40000 ALTER TABLE `simple` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students1`
--

DROP TABLE IF EXISTS `students1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `students1` (
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
-- Dumping data for table `students1`
--

LOCK TABLES `students1` WRITE;
/*!40000 ALTER TABLE `students1` DISABLE KEYS */;
INSERT INTO `students1` VALUES (1,'赵一','male',15,1,58),(2,'钱二','female',16,2,55),(3,'孙三','male',16,2,88),(88,'李四','male',11,1,100),(5,'周五','female',15,2,88),(6,'吴六','male',16,1,75),(7,'郑七','female',16,1,87),(8,'王八','male',16,3,88),(9,'冯九','male',14,3,45),(10,'陈十','female',14,4,85),(11,'褚十一','female',16,3,85),(12,'卫十二','male',17,4,85),(13,'蒋十三','female',13,5,33),(14,'沈十四','male',16,4,11),(15,'韩十五','female ',14,3,49),(16,'杨十六','male',17,5,94),(17,'朱十七','female',19,5,60),(18,'秦十八','male',17,4,11),(19,'尤十九','female ',11,5,NULL),(20,'许二十','male',17,6,44),(21,'何二十一','male',16,3,58),(22,'吕二十二','female',15,6,59),(23,'施二十三','male',14,5,86),(24,'张二十四','female',18,6,88),(25,'孔二十五','male',14,6,80),(26,'曹二十六','female',15,5,55);
/*!40000 ALTER TABLE `students1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students2`
--

DROP TABLE IF EXISTS `students2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `students2` (
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
-- Dumping data for table `students2`
--

LOCK TABLES `students2` WRITE;
/*!40000 ALTER TABLE `students2` DISABLE KEYS */;
INSERT INTO `students2` VALUES (1,'赵一','male',15,1,58),(2,'钱二','female',16,2,55),(3,'孙三','male',16,2,88),(4,'李四','male',11,1,100),(5,'周五','female',15,2,88),(6,'吴六','male',16,1,75),(7,'郑七','female',16,1,87),(8,'王八','male',16,3,88),(9,'冯九','male',14,3,45),(10,'陈十','female',14,4,85),(11,'褚十一','female',16,3,85),(55,'卫十二','male',17,4,85),(13,'蒋十三','female',13,5,33),(14,'沈十四','male',16,4,11),(15,'韩十五','female ',14,3,49),(16,'杨十六','male',17,5,94),(17,'朱十七','female',19,5,60),(18,'秦十八','male',17,4,11),(19,'尤十九','female ',11,5,0),(30,'许二十','male',17,6,44),(31,'何二十一','male',16,3,58),(32,'吕二十二','female',15,6,59),(33,'施二十三','male',14,5,86),(34,'张二十四','female',18,6,88),(35,'孔二十五','male',14,6,80),(36,'曹二十六','female',15,4,55);
/*!40000 ALTER TABLE `students2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students3`
--

DROP TABLE IF EXISTS `students3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `students3` (
  `stu_id` varchar(10) NOT NULL COMMENT '主键,id',
  `stu_name` varchar(10) NOT NULL COMMENT '学生姓名',
  PRIMARY KEY (`stu_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students3`
--

LOCK TABLES `students3` WRITE;
/*!40000 ALTER TABLE `students3` DISABLE KEYS */;
INSERT INTO `students3` VALUES ('stu0001','张三'),('stu0002','张四'),('stu0003','张五'),('stu0004','哈哈哈哈');
/*!40000 ALTER TABLE `students3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unique1`
--

DROP TABLE IF EXISTS `unique1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `unique1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(10) DEFAULT NULL,
  `pass` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`,`pass`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unique1`
--

LOCK TABLES `unique1` WRITE;
/*!40000 ALTER TABLE `unique1` DISABLE KEYS */;
INSERT INTO `unique1` VALUES (1,NULL,NULL),(2,NULL,NULL),(3,NULL,NULL),(4,'amy',NULL);
/*!40000 ALTER TABLE `unique1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unique2`
--

DROP TABLE IF EXISTS `unique2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `unique2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unique2`
--

LOCK TABLES `unique2` WRITE;
/*!40000 ALTER TABLE `unique2` DISABLE KEYS */;
/*!40000 ALTER TABLE `unique2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unique3`
--

DROP TABLE IF EXISTS `unique3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `unique3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unique3`
--

LOCK TABLES `unique3` WRITE;
/*!40000 ALTER TABLE `unique3` DISABLE KEYS */;
/*!40000 ALTER TABLE `unique3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utf`
--

DROP TABLE IF EXISTS `utf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `utf` (
  `name` varchar(21844) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utf`
--

LOCK TABLES `utf` WRITE;
/*!40000 ALTER TABLE `utf` DISABLE KEYS */;
/*!40000 ALTER TABLE `utf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ysf1`
--

DROP TABLE IF EXISTS `ysf1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ysf1` (
  `int_1` int(11) DEFAULT NULL,
  `int_2` int(11) DEFAULT NULL,
  `int_3` int(11) DEFAULT NULL,
  `int_4` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ysf1`
--

LOCK TABLES `ysf1` WRITE;
/*!40000 ALTER TABLE `ysf1` DISABLE KEYS */;
INSERT INTO `ysf1` VALUES (100,-100,0,NULL);
/*!40000 ALTER TABLE `ysf1` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-03 20:02:39
