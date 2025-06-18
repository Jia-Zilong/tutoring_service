/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80028 (8.0.28)
 Source Host           : localhost:3306
 Source Schema         : tutoring_service

 Target Server Type    : MySQL
 Target Server Version : 80028 (8.0.28)
 File Encoding         : 65001

 Date: 18/06/2025 23:32:21
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
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fee
-- ----------------------------
INSERT INTO `fee` VALUES (15, '架子龙', '高中', '数学教学', '2025-06-18', '17:54:00', '20:54:00', 300.00, 'unpaid');
INSERT INTO `fee` VALUES (16, '津坤', '初中', '物理教学', '2025-06-18', '06:09:00', '08:10:00', 161.60, 'unpaid');

-- ----------------------------
-- Table structure for fee_rate
-- ----------------------------
DROP TABLE IF EXISTS `fee_rate`;
CREATE TABLE `fee_rate`  (
  `level` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `rate_per_hour` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`level`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
  PRIMARY KEY (`schedule_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of salary
-- ----------------------------
INSERT INTO `salary` VALUES (15, '架子龙', '高中', '数学教学', '2025-06-18', '17:54:00', '20:54:00', 300.00, 'unpaid');
INSERT INTO `salary` VALUES (16, '津坤', '初中', '物理教学', '2025-06-18', '06:09:00', '08:10:00', 161.60, 'unpaid');

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schedule
-- ----------------------------
INSERT INTO `schedule` VALUES ('0001', '2025-06-18', '17:54:00', '20:54:00', '架子龙', 15, '数学教学', '高中');
INSERT INTO `schedule` VALUES ('0308', '2025-06-18', '06:09:00', '08:10:00', '津坤', 16, '物理教学', '初中');

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
) ENGINE = InnoDB AUTO_INCREMENT = 309 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of teachers
-- ----------------------------
INSERT INTO `teachers` VALUES ('0001', '架子龙', '男', '12345678962', NULL);
INSERT INTO `teachers` VALUES ('0005', '天天开心', '男', '18715519307', NULL);
INSERT INTO `teachers` VALUES ('0308', '津坤', '男', '12345678912', NULL);

-- ----------------------------
-- Procedure structure for CountOccupationDemand
-- ----------------------------
DROP PROCEDURE IF EXISTS `CountOccupationDemand`;
delimiter ;;
CREATE PROCEDURE `CountOccupationDemand`()
BEGIN
    SELECT
        o.name AS occupation,
        COUNT(s.id) AS demand_times
    FROM schedule s
    JOIN occupation o ON s.occupation_id = o.id
    GROUP BY s.occupation_id;
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

  -- 计算补课时长（小时）
  SET duration_in_hours = TIME_TO_SEC(TIMEDIFF(NEW.end_time, NEW.start_time)) / 3600;

  -- 获取对应level的收费标准
  SELECT rate_per_hour INTO fee_rate
  FROM fee_rate
  WHERE level = NEW.level;

  -- 计算总费用
  SET fee_total = ROUND(duration_in_hours * fee_rate, 2);

  -- 插入 fee 表记录
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

  -- 计算时长（小时）
  SET duration_in_hours = TIME_TO_SEC(TIMEDIFF(NEW.end_time, NEW.start_time)) / 3600;

  -- 根据 level 设置工资率
  IF NEW.level = '小学' THEN
    SET rate = 60;
  ELSEIF NEW.level = '初中' THEN
    SET rate = 80;
  ELSEIF NEW.level = '高中' THEN
    SET rate = 100;
  ELSE
    SET rate = 0;
  END IF;

  -- 计算总工资
  SET total_salary = ROUND(duration_in_hours * rate, 2);

  -- 插入 salary 表
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
DROP TRIGGER IF EXISTS `trg_update_schedule_fee`;
delimiter ;;
CREATE TRIGGER `trg_update_schedule_fee` AFTER UPDATE ON `schedule` FOR EACH ROW BEGIN
  DECLARE duration_in_hours DECIMAL(10,2);
  DECLARE fee_rate DECIMAL(10,2);
  DECLARE fee_total DECIMAL(10,2);

  -- 计算时长
  SET duration_in_hours = TIME_TO_SEC(TIMEDIFF(NEW.end_time, NEW.start_time)) / 3600;

  -- 获取收费标准
  SELECT rate_per_hour INTO fee_rate
  FROM fee_rate
  WHERE level = NEW.level;

  -- 计算费用
  SET fee_total = ROUND(duration_in_hours * fee_rate, 2);

  -- 更新 fee 表
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

SET FOREIGN_KEY_CHECKS = 1;
