-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: tutoring_service
-- ------------------------------------------------------
-- Server version	8.0.28

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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','123456');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_history`
--

DROP TABLE IF EXISTS `backup_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `backup_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `backup_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_history`
--

LOCK TABLES `backup_history` WRITE;
/*!40000 ALTER TABLE `backup_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `backup_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee`
--

DROP TABLE IF EXISTS `fee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee` (
  `schedule_id` int NOT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `fee_amount` decimal(10,2) NOT NULL,
  `pay_status` enum('paid','unpaid') CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT 'unpaid',
  PRIMARY KEY (`schedule_id`) USING BTREE,
  CONSTRAINT `fee_fk_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee`
--

LOCK TABLES `fee` WRITE;
/*!40000 ALTER TABLE `fee` DISABLE KEYS */;
INSERT INTO `fee` VALUES (32,'张三','高中','数学教学','2025-06-19','02:09:00','05:09:00',300.00,'unpaid'),(33,'张三','高中','数学教学','2025-06-19','06:30:00','08:30:00',200.00,'unpaid'),(34,'李四','初中','数学教学','2025-06-20','09:00:00','11:00:00',160.00,'unpaid'),(35,'王五','高中','地理教学','2025-06-20','14:30:00','16:30:00',200.00,'unpaid'),(36,'王五','初中','物理教学','2025-06-21','10:00:00','12:00:00',160.00,'unpaid'),(37,'赵六','小学','语文教学','2025-06-21','15:30:00','17:30:00',120.00,'unpaid'),(38,'钱七','初中','英语教学','2025-06-22','08:00:00','10:00:00',160.00,'unpaid');
/*!40000 ALTER TABLE `fee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_rate`
--

DROP TABLE IF EXISTS `fee_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_rate` (
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `rate_per_hour` decimal(10,2) NOT NULL,
  PRIMARY KEY (`level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_rate`
--

LOCK TABLES `fee_rate` WRITE;
/*!40000 ALTER TABLE `fee_rate` DISABLE KEYS */;
INSERT INTO `fee_rate` VALUES ('初中',80.00),('小学',60.00),('高中',100.00);
/*!40000 ALTER TABLE `fee_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occupation`
--

DROP TABLE IF EXISTS `occupation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupation` (
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `occupation_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '小学',
  PRIMARY KEY (`teacher_id`,`occupation_name`,`level`) USING BTREE,
  KEY `teacher_id` (`teacher_id`) USING BTREE,
  CONSTRAINT `occupation_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupation`
--

LOCK TABLES `occupation` WRITE;
/*!40000 ALTER TABLE `occupation` DISABLE KEYS */;
INSERT INTO `occupation` VALUES ('0001','数学教学','高中'),('0005','数学教学','初中'),('0308','地理教学','高中'),('0308','物理教学','初中'),('0308','物理教学','高中'),('0409','语文教学','小学'),('0510','英语教学','初中');
/*!40000 ALTER TABLE `occupation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salary`
--

DROP TABLE IF EXISTS `salary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salary` (
  `schedule_id` int NOT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `salary_amount` decimal(10,2) DEFAULT NULL,
  `pay_status` enum('unpaid','paid') CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT 'unpaid',
  PRIMARY KEY (`schedule_id`) USING BTREE,
  CONSTRAINT `salary_fk_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salary`
--

LOCK TABLES `salary` WRITE;
/*!40000 ALTER TABLE `salary` DISABLE KEYS */;
INSERT INTO `salary` VALUES (32,'张三','高中','数学教学','2025-06-19','02:09:00','05:09:00',300.00,'unpaid'),(33,'张三','高中','数学教学','2025-06-19','06:30:00','08:30:00',200.00,'unpaid'),(34,'李四','初中','数学教学','2025-06-20','09:00:00','11:00:00',160.00,'unpaid'),(35,'王五','高中','地理教学','2025-06-20','14:30:00','16:30:00',200.00,'unpaid'),(36,'王五','初中','物理教学','2025-06-21','10:00:00','12:00:00',160.00,'unpaid'),(37,'赵六','小学','语文教学','2025-06-21','15:30:00','17:30:00',120.00,'unpaid'),(38,'钱七','初中','英语教学','2025-06-22','08:00:00','10:00:00',160.00,'unpaid');
/*!40000 ALTER TABLE `salary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `teacher_id` (`teacher_id`) USING BTREE,
  KEY `teacher_name` (`teacher_name`) USING BTREE,
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`teacher_name`) REFERENCES `teachers` (`name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES ('0001','2025-06-19','02:09:00','05:09:00','张三',32,'数学教学','高中'),('0001','2025-06-19','06:30:00','08:30:00','张三',33,'数学教学','高中'),('0005','2025-06-20','09:00:00','11:00:00','李四',34,'数学教学','初中'),('0308','2025-06-20','14:30:00','16:30:00','王五',35,'地理教学','高中'),('0308','2025-06-21','10:00:00','12:00:00','王五',36,'物理教学','初中'),('0409','2025-06-21','15:30:00','17:30:00','赵六',37,'语文教学','小学'),('0510','2025-06-22','08:00:00','10:00:00','钱七',38,'英语教学','初中');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_insert_fee` AFTER INSERT ON `schedule` FOR EACH ROW BEGIN
  DECLARE duration_in_hours DECIMAL(10,2);
  DECLARE fee_rate DECIMAL(10,2);
  DECLARE fee_total DECIMAL(10,2);

  
  SET duration_in_hours = TIME_TO_SEC(TIMEDIFF(NEW.end_time, NEW.start_time)) / 3600;

  
  SELECT rate_per_hour INTO fee_rate
  FROM fee_rate
  WHERE level = NEW.level;

  
  SET fee_total = ROUND(duration_in_hours * fee_rate, 2);

  
  INSERT INTO fee (
    schedule_id, teacher_name, level, occupation_name, date,
    start_time, end_time, fee_amount, pay_status
  ) VALUES (
    NEW.id, NEW.teacher_name, NEW.level, NEW.occupation_name, NEW.date,
    NEW.start_time, NEW.end_time, fee_total, 'unpaid'
  );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_insert_salary` AFTER INSERT ON `schedule` FOR EACH ROW BEGIN
  DECLARE duration_in_hours DECIMAL(10,2);
  DECLARE rate DECIMAL(10,2);
  DECLARE total_salary DECIMAL(10,2);

  
  SET duration_in_hours = TIME_TO_SEC(TIMEDIFF(NEW.end_time, NEW.start_time)) / 3600;

  
  IF NEW.level = '小学' THEN
    SET rate = 60;
  ELSEIF NEW.level = '初中' THEN
    SET rate = 80;
  ELSEIF NEW.level = '高中' THEN
    SET rate = 100;
  ELSE
    SET rate = 0;
  END IF;

  
  SET total_salary = ROUND(duration_in_hours * rate, 2);

  
  INSERT INTO salary (
    schedule_id, teacher_name, level, occupation_name,
    date, start_time, end_time, salary_amount, pay_status
  ) VALUES (
    NEW.id, NEW.teacher_name, NEW.level, NEW.occupation_name,
    NEW.date, NEW.start_time, NEW.end_time, total_salary, 'unpaid'
  );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_schedule_insert` AFTER INSERT ON `schedule` FOR EACH ROW BEGIN
  INSERT INTO schedule_history (
    schedule_id, teacher_id, teacher_name, date,
    start_time, end_time, occupation_name, level,
    operation_type
  ) VALUES (
    NEW.id, NEW.teacher_id, NEW.teacher_name, NEW.date,
    NEW.start_time, NEW.end_time, NEW.occupation_name, NEW.level,
    'INSERT'
  );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_schedule_fee` AFTER UPDATE ON `schedule` FOR EACH ROW BEGIN
  DECLARE duration_in_hours DECIMAL(10,2);
  DECLARE fee_rate DECIMAL(10,2);
  DECLARE fee_total DECIMAL(10,2);

  
  SET duration_in_hours = TIME_TO_SEC(TIMEDIFF(NEW.end_time, NEW.start_time)) / 3600;

  
  SELECT rate_per_hour INTO fee_rate
  FROM fee_rate
  WHERE level = NEW.level;

  
  SET fee_total = ROUND(duration_in_hours * fee_rate, 2);

  
  UPDATE fee
  SET
    teacher_name = NEW.teacher_name,
    level = NEW.level,
    occupation_name = NEW.occupation_name,
    date = NEW.date,
    start_time = NEW.start_time,
    end_time = NEW.end_time,
    fee_amount = fee_total
  WHERE schedule_id = NEW.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_salary` AFTER UPDATE ON `schedule` FOR EACH ROW BEGIN
  DECLARE duration_in_hours DECIMAL(10,2);
  DECLARE rate DECIMAL(10,2);
  DECLARE total_salary DECIMAL(10,2);

  SET duration_in_hours = TIME_TO_SEC(TIMEDIFF(NEW.end_time, NEW.start_time)) / 3600;

  IF NEW.level = '小学' THEN
    SET rate = 60;
  ELSEIF NEW.level = '初中' THEN
    SET rate = 80;
  ELSEIF NEW.level = '高中' THEN
    SET rate = 100;
  ELSE
    SET rate = 0;
  END IF;

  SET total_salary = ROUND(duration_in_hours * rate, 2);

  UPDATE salary
  SET
    teacher_name = NEW.teacher_name,
    level = NEW.level,
    occupation_name = NEW.occupation_name,
    date = NEW.date,
    start_time = NEW.start_time,
    end_time = NEW.end_time,
    salary_amount = total_salary
  WHERE schedule_id = NEW.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_schedule_update` AFTER UPDATE ON `schedule` FOR EACH ROW BEGIN
  INSERT INTO schedule_history (
    schedule_id, teacher_id, teacher_name, date,
    start_time, end_time, occupation_name, level,
    operation_type
  ) VALUES (
    OLD.id, OLD.teacher_id, OLD.teacher_name, OLD.date,
    OLD.start_time, OLD.end_time, OLD.occupation_name, OLD.level,
    'UPDATE'
  );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_schedule_delete` BEFORE DELETE ON `schedule` FOR EACH ROW BEGIN
  INSERT INTO schedule_history (
    schedule_id, teacher_id, teacher_name, date,
    start_time, end_time, occupation_name, level,
    operation_type
  ) VALUES (
    OLD.id, OLD.teacher_id, OLD.teacher_name, OLD.date,
    OLD.start_time, OLD.end_time, OLD.occupation_name, OLD.level,
    'DELETE'
  );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `schedule_history`
--

DROP TABLE IF EXISTS `schedule_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `schedule_id` int NOT NULL,
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `operation_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `version_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_history`
--

LOCK TABLES `schedule_history` WRITE;
/*!40000 ALTER TABLE `schedule_history` DISABLE KEYS */;
INSERT INTO `schedule_history` VALUES (16,32,'0001','张三','2025-06-19','02:09:00','05:09:00','数学教学','高中','INSERT','2025-06-19 06:17:51'),(17,33,'0001','张三','2025-06-19','06:30:00','08:30:00','数学教学','高中','INSERT','2025-06-19 06:17:51'),(18,34,'0005','李四','2025-06-20','09:00:00','11:00:00','数学教学','初中','INSERT','2025-06-19 06:17:51'),(19,35,'0308','王五','2025-06-20','14:30:00','16:30:00','地理教学','高中','INSERT','2025-06-19 06:17:51'),(20,36,'0308','王五','2025-06-21','10:00:00','12:00:00','物理教学','初中','INSERT','2025-06-19 06:17:51'),(21,37,'0409','赵六','2025-06-21','15:30:00','17:30:00','语文教学','小学','INSERT','2025-06-19 06:17:51'),(22,38,'0510','钱七','2025-06-22','08:00:00','10:00:00','英语教学','初中','INSERT','2025-06-19 06:17:51');
/*!40000 ALTER TABLE `schedule_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `gender` enum('男','女') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES ('0001','张三','男','12345678962','北京市海淀区'),('0005','李四','女','18715519307','上海市浦东新区'),('0308','王五','男','12345678912','深圳市南山区'),('0409','赵六','女','23456789012','广州市天河区'),('0510','钱七','男','34567890123','成都市武侯区');
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-19  6:21:30
