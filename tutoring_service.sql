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

 Date: 18/06/2025 03:30:57
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
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `occupation_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `amount` decimal(10, 2) NULL DEFAULT NULL,
  `date` date NULL DEFAULT NULL,
  PRIMARY KEY (`teacher_id`) USING BTREE,
  CONSTRAINT `fee_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of fee
-- ----------------------------
INSERT INTO `fee` VALUES ('0001', '语文', 2.00, '2025-06-18');

-- ----------------------------
-- Table structure for occupation
-- ----------------------------
DROP TABLE IF EXISTS `occupation`;
CREATE TABLE `occupation`  (
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `occupation_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `level` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '小学',
  PRIMARY KEY (`teacher_id`, `occupation_name`) USING BTREE,
  INDEX `teacher_id`(`teacher_id` ASC) USING BTREE,
  CONSTRAINT `occupation_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of occupation
-- ----------------------------
INSERT INTO `occupation` VALUES ('0001', '语文教学', '小学');
INSERT INTO `occupation` VALUES ('0005', '数学教学', '高中');

-- ----------------------------
-- Table structure for salary
-- ----------------------------
DROP TABLE IF EXISTS `salary`;
CREATE TABLE `salary`  (
  `teacher_id` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `amount` decimal(10, 2) NULL DEFAULT NULL,
  `date` date NULL DEFAULT NULL,
  PRIMARY KEY (`teacher_id`) USING BTREE,
  CONSTRAINT `salary_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of salary
-- ----------------------------
INSERT INTO `salary` VALUES ('0001', 5.00, '2025-06-18');

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
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `teacher_id`(`teacher_id` ASC) USING BTREE,
  INDEX `teacher_name`(`teacher_name` ASC) USING BTREE,
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`teacher_name`) REFERENCES `teachers` (`name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schedule
-- ----------------------------
INSERT INTO `schedule` VALUES ('0001', '2025-06-17', '06:47:00', '12:43:00', '架子龙', 2);
INSERT INTO `schedule` VALUES ('0005', '2025-06-18', '07:01:00', '08:06:00', '天天开心', 3);

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
-- Procedure structure for TotalHoursPerTeacher
-- ----------------------------
DROP PROCEDURE IF EXISTS `TotalHoursPerTeacher`;
delimiter ;;
CREATE PROCEDURE `TotalHoursPerTeacher`(IN start_date DATE,
    IN end_date DATE,
    IN teacher_id_param CHAR(4))
BEGIN
    SELECT
        t.id AS TeacherID,
        t.name AS TeacherName,
        COALESCE(SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(s.end_time, s.start_time)))), '00:00:00') AS TotalHours
    FROM teachers t
    LEFT JOIN schedule s
      ON t.id = s.teacher_id
      AND s.date BETWEEN start_date AND end_date
    WHERE (teacher_id_param IS NULL OR teacher_id_param = '' OR t.id = teacher_id_param)
    GROUP BY t.id, t.name;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
