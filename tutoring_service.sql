/*
 Navicat Premium Data Transfer

 Source Server         : myroot
 Source Server Type    : MySQL
 Source Server Version : 80028 (8.0.28)
 Source Host           : localhost:3306
 Source Schema         : tutoring_service

 Target Server Type    : MySQL
 Target Server Version : 80028 (8.0.28)
 File Encoding         : 65001

 Date: 19/06/2025 07:29:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '123456');

-- ----------------------------
-- Table structure for backup_history
-- ----------------------------
DROP TABLE IF EXISTS `backup_history`;
CREATE TABLE `backup_history`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `backup_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `backup_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of backup_history
-- ----------------------------
INSERT INTO `backup_history` VALUES (4, 'backup_20250619_062128.sql', '2025-06-19 06:21:30', 'Initial Backup');

-- ----------------------------
-- Table structure for fee
-- ----------------------------
DROP TABLE IF EXISTS `fee`;
CREATE TABLE `fee`  (
  `schedule_id` int NOT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `fee_amount` decimal(10, 2) NOT NULL,
  `pay_status` enum('paid','unpaid') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'unpaid',
  PRIMARY KEY (`schedule_id`) USING BTREE,
  CONSTRAINT `fee_fk_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of fee
-- ----------------------------
INSERT INTO `fee` VALUES (32, '张三', '高中', '数学教学', '2025-06-19', '02:09:00', '05:09:00', 300.00, 'unpaid');
INSERT INTO `fee` VALUES (33, '张三', '高中', '数学教学', '2025-06-19', '06:30:00', '08:30:00', 200.00, 'unpaid');
INSERT INTO `fee` VALUES (34, '李四', '初中', '数学教学', '2025-06-20', '09:00:00', '11:00:00', 160.00, 'unpaid');
INSERT INTO `fee` VALUES (35, '王五', '高中', '地理教学', '2025-06-20', '14:30:00', '16:30:00', 200.00, 'unpaid');
INSERT INTO `fee` VALUES (36, '王五', '初中', '物理教学', '2025-06-21', '10:00:00', '12:00:00', 160.00, 'unpaid');
INSERT INTO `fee` VALUES (37, '赵六', '小学', '语文教学', '2025-06-21', '15:30:00', '17:30:00', 120.00, 'unpaid');
INSERT INTO `fee` VALUES (38, '钱七', '初中', '英语教学', '2025-06-22', '08:00:00', '10:00:00', 160.00, 'unpaid');

-- ----------------------------
-- Table structure for fee_rate
-- ----------------------------
DROP TABLE IF EXISTS `fee_rate`;
CREATE TABLE `fee_rate`  (
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `rate_per_hour` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`level`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of fee_rate
-- ----------------------------
INSERT INTO `fee_rate` VALUES ('初中', 80.00);
INSERT INTO `fee_rate` VALUES ('小学', 60.00);
INSERT INTO `fee_rate` VALUES ('高中', 100.00);

-- ----------------------------
-- Table structure for occupation
-- ----------------------------
DROP TABLE IF EXISTS `occupation`;
CREATE TABLE `occupation`  (
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `occupation_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '小学',
  PRIMARY KEY (`teacher_id`, `occupation_name`, `level`) USING BTREE,
  INDEX `teacher_id`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `occupation_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of occupation
-- ----------------------------
INSERT INTO `occupation` VALUES ('0001', '数学教学', '高中');
INSERT INTO `occupation` VALUES ('0005', '数学教学', '初中');
INSERT INTO `occupation` VALUES ('0308', '地理教学', '高中');
INSERT INTO `occupation` VALUES ('0308', '物理教学', '初中');
INSERT INTO `occupation` VALUES ('0308', '物理教学', '高中');
INSERT INTO `occupation` VALUES ('0409', '语文教学', '小学');
INSERT INTO `occupation` VALUES ('0510', '英语教学', '初中');

-- ----------------------------
-- Table structure for salary
-- ----------------------------
DROP TABLE IF EXISTS `salary`;
CREATE TABLE `salary`  (
  `schedule_id` int NOT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `date` date NULL DEFAULT NULL,
  `start_time` time NULL DEFAULT NULL,
  `end_time` time NULL DEFAULT NULL,
  `salary_amount` decimal(10, 2) NULL DEFAULT NULL,
  `pay_status` enum('unpaid','paid') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'unpaid',
  PRIMARY KEY (`schedule_id`) USING BTREE,
  CONSTRAINT `salary_fk_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of salary
-- ----------------------------
INSERT INTO `salary` VALUES (32, '张三', '高中', '数学教学', '2025-06-19', '02:09:00', '05:09:00', 300.00, 'unpaid');
INSERT INTO `salary` VALUES (33, '张三', '高中', '数学教学', '2025-06-19', '06:30:00', '08:30:00', 200.00, 'unpaid');
INSERT INTO `salary` VALUES (34, '李四', '初中', '数学教学', '2025-06-20', '09:00:00', '11:00:00', 160.00, 'unpaid');
INSERT INTO `salary` VALUES (35, '王五', '高中', '地理教学', '2025-06-20', '14:30:00', '16:30:00', 200.00, 'unpaid');
INSERT INTO `salary` VALUES (36, '王五', '初中', '物理教学', '2025-06-21', '10:00:00', '12:00:00', 160.00, 'unpaid');
INSERT INTO `salary` VALUES (37, '赵六', '小学', '语文教学', '2025-06-21', '15:30:00', '17:30:00', 120.00, 'unpaid');
INSERT INTO `salary` VALUES (38, '钱七', '初中', '英语教学', '2025-06-22', '08:00:00', '10:00:00', 160.00, 'unpaid');

-- ----------------------------
-- Table structure for schedule
-- ----------------------------
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule`  (
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` date NULL DEFAULT NULL,
  `start_time` time NULL DEFAULT NULL,
  `end_time` time NULL DEFAULT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `teacher_id`(`teacher_id` ASC) USING BTREE,
  INDEX `teacher_name`(`teacher_name` ASC) USING BTREE,
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`teacher_name`) REFERENCES `teachers` (`name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schedule
-- ----------------------------
INSERT INTO `schedule` VALUES ('0001', '2025-06-19', '02:09:00', '05:09:00', '张三', 32, '数学教学', '高中');
INSERT INTO `schedule` VALUES ('0001', '2025-06-19', '06:30:00', '08:30:00', '张三', 33, '数学教学', '高中');
INSERT INTO `schedule` VALUES ('0005', '2025-06-20', '09:00:00', '11:00:00', '李四', 34, '数学教学', '初中');
INSERT INTO `schedule` VALUES ('0308', '2025-06-20', '14:30:00', '16:30:00', '王五', 35, '地理教学', '高中');
INSERT INTO `schedule` VALUES ('0308', '2025-06-21', '10:00:00', '12:00:00', '王五', 36, '物理教学', '初中');
INSERT INTO `schedule` VALUES ('0409', '2025-06-21', '15:30:00', '17:30:00', '赵六', 37, '语文教学', '小学');
INSERT INTO `schedule` VALUES ('0510', '2025-06-22', '08:00:00', '10:00:00', '钱七', 38, '英语教学', '初中');

-- ----------------------------
-- Table structure for schedule_history
-- ----------------------------
DROP TABLE IF EXISTS `schedule_history`;
CREATE TABLE `schedule_history`  (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `schedule_id` int NOT NULL,
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `teacher_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` date NULL DEFAULT NULL,
  `start_time` time NULL DEFAULT NULL,
  `end_time` time NULL DEFAULT NULL,
  `occupation_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `operation_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `version_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schedule_history
-- ----------------------------
INSERT INTO `schedule_history` VALUES (16, 32, '0001', '张三', '2025-06-19', '02:09:00', '05:09:00', '数学教学', '高中', 'INSERT', '2025-06-19 06:17:51');
INSERT INTO `schedule_history` VALUES (17, 33, '0001', '张三', '2025-06-19', '06:30:00', '08:30:00', '数学教学', '高中', 'INSERT', '2025-06-19 06:17:51');
INSERT INTO `schedule_history` VALUES (18, 34, '0005', '李四', '2025-06-20', '09:00:00', '11:00:00', '数学教学', '初中', 'INSERT', '2025-06-19 06:17:51');
INSERT INTO `schedule_history` VALUES (19, 35, '0308', '王五', '2025-06-20', '14:30:00', '16:30:00', '地理教学', '高中', 'INSERT', '2025-06-19 06:17:51');
INSERT INTO `schedule_history` VALUES (20, 36, '0308', '王五', '2025-06-21', '10:00:00', '12:00:00', '物理教学', '初中', 'INSERT', '2025-06-19 06:17:51');
INSERT INTO `schedule_history` VALUES (21, 37, '0409', '赵六', '2025-06-21', '15:30:00', '17:30:00', '语文教学', '小学', 'INSERT', '2025-06-19 06:17:51');
INSERT INTO `schedule_history` VALUES (22, 38, '0510', '钱七', '2025-06-22', '08:00:00', '10:00:00', '英语教学', '初中', 'INSERT', '2025-06-19 06:17:51');

-- ----------------------------
-- Table structure for teachers
-- ----------------------------
DROP TABLE IF EXISTS `teachers`;
CREATE TABLE `teachers`  (
  `id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `gender` enum('男','女') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of teachers
-- ----------------------------
INSERT INTO `teachers` VALUES ('0001', '张三', '男', '12345678962', '北京市海淀区');
INSERT INTO `teachers` VALUES ('0005', '李四', '女', '18715519307', '上海市浦东新区');
INSERT INTO `teachers` VALUES ('0308', '王五', '男', '12345678912', '深圳市南山区');
INSERT INTO `teachers` VALUES ('0409', '赵六', '女', '23456789012', '广州市天河区');
INSERT INTO `teachers` VALUES ('0510', '钱七', '男', '34567890123', '成都市武侯区');

-- ----------------------------
-- Procedure structure for CountOccupationUsage
-- ----------------------------
DROP PROCEDURE IF EXISTS `CountOccupationUsage`;
delimiter ;;
CREATE PROCEDURE `CountOccupationUsage`()
BEGIN
  SELECT
    occupation_name AS Subject,
    level AS Level,
    COUNT(*) AS DemandCount
  FROM schedule
  GROUP BY occupation_name, level
  ORDER BY DemandCount DESC;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TotalHoursPerTeacherByLevel
-- ----------------------------
DROP PROCEDURE IF EXISTS `TotalHoursPerTeacherByLevel`;
delimiter ;;
CREATE PROCEDURE `TotalHoursPerTeacherByLevel`(IN start_date DATE,
    IN end_date DATE,
    IN teacher_id_param CHAR(4))
BEGIN
    SELECT
        t.id AS TeacherID,
        t.name AS TeacherName,
        s.level AS Level,
        s.occupation_name AS Subject,
        COALESCE(SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(s.end_time, s.start_time)))), '00:00:00') AS TotalHours
    FROM teachers t
    LEFT JOIN schedule s
        ON t.id = s.teacher_id
        AND s.date BETWEEN start_date AND end_date
    WHERE (teacher_id_param IS NULL OR teacher_id_param = '' OR t.id = teacher_id_param)
    GROUP BY t.id, t.name, s.level, s.occupation_name
    ORDER BY t.id, s.level, s.occupation_name;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_insert_fee`;
delimiter ;;
CREATE TRIGGER `trg_insert_fee` AFTER INSERT ON `schedule` FOR EACH ROW BEGIN
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_insert_salary`;
delimiter ;;
CREATE TRIGGER `trg_insert_salary` AFTER INSERT ON `schedule` FOR EACH ROW BEGIN
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_schedule_insert`;
delimiter ;;
CREATE TRIGGER `trg_schedule_insert` AFTER INSERT ON `schedule` FOR EACH ROW BEGIN
  INSERT INTO schedule_history (
    schedule_id, teacher_id, teacher_name, date,
    start_time, end_time, occupation_name, level,
    operation_type
  ) VALUES (
    NEW.id, NEW.teacher_id, NEW.teacher_name, NEW.date,
    NEW.start_time, NEW.end_time, NEW.occupation_name, NEW.level,
    'INSERT'
  );
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_update_schedule_fee`;
delimiter ;;
CREATE TRIGGER `trg_update_schedule_fee` AFTER UPDATE ON `schedule` FOR EACH ROW BEGIN
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_update_salary`;
delimiter ;;
CREATE TRIGGER `trg_update_salary` AFTER UPDATE ON `schedule` FOR EACH ROW BEGIN
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
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_schedule_update`;
delimiter ;;
CREATE TRIGGER `trg_schedule_update` AFTER UPDATE ON `schedule` FOR EACH ROW BEGIN
  INSERT INTO schedule_history (
    schedule_id, teacher_id, teacher_name, date,
    start_time, end_time, occupation_name, level,
    operation_type
  ) VALUES (
    OLD.id, OLD.teacher_id, OLD.teacher_name, OLD.date,
    OLD.start_time, OLD.end_time, OLD.occupation_name, OLD.level,
    'UPDATE'
  );
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_schedule_delete`;
delimiter ;;
CREATE TRIGGER `trg_schedule_delete` BEFORE DELETE ON `schedule` FOR EACH ROW BEGIN
  INSERT INTO schedule_history (
    schedule_id, teacher_id, teacher_name, date,
    start_time, end_time, occupation_name, level,
    operation_type
  ) VALUES (
    OLD.id, OLD.teacher_id, OLD.teacher_name, OLD.date,
    OLD.start_time, OLD.end_time, OLD.occupation_name, OLD.level,
    'DELETE'
  );
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
