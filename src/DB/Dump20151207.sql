CREATE DATABASE  IF NOT EXISTS `lyric_pma` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `lyric_pma`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: lyric_pma
-- ------------------------------------------------------
-- Server version	5.7.9-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `projectID` int(11) NOT NULL AUTO_INCREMENT,
  `projectName` varchar(50) NOT NULL,
  `projectCodeNo` varchar(20) NOT NULL,
  `projectDutyman` varchar(10) NOT NULL,
  `projectStatus` varchar(10) NOT NULL,
  PRIMARY KEY (`projectID`),
  UNIQUE KEY `projectID_UNIQUE` (`projectID`),
  UNIQUE KEY `projectName_UNIQUE` (`projectName`),
  UNIQUE KEY `projectCodeNo_UNIQUE` (`projectCodeNo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES (1,'B1091 LFP包装机左线排期表（2台','B1091','付爽','RUNNING'),(2,'B1090 LFP包装机左线排期表（2台）','B1090','付爽','RUNNING'),(3,'测试项目','B1234','何家欢','RUNNING');
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stage`
--

DROP TABLE IF EXISTS `stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stage` (
  `stageID` int(11) NOT NULL AUTO_INCREMENT,
  `stageName` varchar(10) NOT NULL,
  `stageSequence` int(11) NOT NULL,
  `starttime` datetime DEFAULT NULL,
  `endtime` datetime NOT NULL,
  `completedTime` datetime DEFAULT NULL,
  `progress` float DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `stageDutyman` varchar(10) NOT NULL,
  `projectBelong` varchar(50) NOT NULL,
  `stationBelong` varchar(50) NOT NULL,
  PRIMARY KEY (`stageID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stage`
--

LOCK TABLES `stage` WRITE;
/*!40000 ALTER TABLE `stage` DISABLE KEYS */;
INSERT INTO `stage` VALUES (1,'3D',1,'2015-11-02 00:00:00','2015-11-04 00:00:00',NULL,NULL,'COMPLETED','付爽1','B1090 LFP包装机左线排期表（2台）','第一个工位'),(2,'2D',2,'2015-11-04 00:00:00','2015-11-05 00:00:00',NULL,NULL,'RUNNING','付爽2','B1090 LFP包装机左线排期表（2台）','第一个工位'),(3,'3D',1,'2015-11-03 00:00:00','2015-11-04 00:00:00',NULL,NULL,'RUNNING','付爽3','B1091 LFP包装机左线排期表（2台','第二个工位'),(4,'2D',1,'2015-11-03 00:00:00','2015-11-03 00:00:00',NULL,NULL,'RUNNING','何家欢','测试项目','第一个工位'),(5,'资材',3,'2015-11-04 00:00:00','2015-11-05 00:00:00',NULL,NULL,'RUNNING','付爽4','B1090 LFP包装机左线排期表（2台）','第二个工位');
/*!40000 ALTER TABLE `stage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station` (
  `stationID` int(11) NOT NULL AUTO_INCREMENT,
  `stationName` varchar(50) NOT NULL,
  `stationNo` int(11) NOT NULL,
  `stationDutyman` varchar(10) NOT NULL,
  `starttime` datetime NOT NULL,
  `blueprintQuantity` int(11) NOT NULL,
  `currentStage` int(11) unsigned NOT NULL,
  `projectBelong` varchar(50) NOT NULL,
  PRIMARY KEY (`stationID`),
  KEY `projectName_idx` (`projectBelong`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'第一个工位',1,'付爽','2015-11-03 00:00:00',30,0,'B1090 LFP包装机左线排期表（2台）'),(2,'第二个工位',2,'付爽','2015-11-04 00:00:00',46,0,'B1091 LFP包装机左线排期表（2台'),(3,'第一个工位',1,'何家欢','2015-11-04 00:00:00',40,0,'测试项目'),(4,'第二个工位',2,'付爽','2015-11-03 00:00:00',33,0,'B1090 LFP包装机左线排期表（2台）');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `un` varchar(10) NOT NULL,
  `pw` varchar(20) NOT NULL,
  `role` varchar(8) NOT NULL,
  `name` varchar(10) NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'fs','123','manager','付爽'),(2,'pm1','321','pm','何家欢');
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

-- Dump completed on 2015-12-07 17:30:11
