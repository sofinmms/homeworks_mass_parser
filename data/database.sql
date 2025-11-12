# ************************************************************
# Sequel Pro SQL dump
# Version (null)
#
# https://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.5-10.6.18-MariaDB-0ubuntu0.22.04.1)
# Database: homeworks_mass_parsing
# Generation Time: 2024-06-27 15:23:57 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table academic_help_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `academic_help_categories`;

CREATE TABLE `academic_help_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table academic_help_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `academic_help_products`;

CREATE TABLE `academic_help_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table assignment_desk_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assignment_desk_categories`;

CREATE TABLE `assignment_desk_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table assignment_desk_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assignment_desk_products`;

CREATE TABLE `assignment_desk_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table edubirdie_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `edubirdie_categories`;

CREATE TABLE `edubirdie_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table edubirdie_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `edubirdie_products`;

CREATE TABLE `edubirdie_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table edusson_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `edusson_categories`;

CREATE TABLE `edusson_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table edusson_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `edusson_products`;

CREATE TABLE `edusson_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table essay_writer_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `essay_writer_categories`;

CREATE TABLE `essay_writer_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table essay_writer_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `essay_writer_products`;

CREATE TABLE `essay_writer_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table grades_fixer_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `grades_fixer_categories`;

CREATE TABLE `grades_fixer_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table grades_fixer_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `grades_fixer_products`;

CREATE TABLE `grades_fixer_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table ivy_panda_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ivy_panda_categories`;

CREATE TABLE `ivy_panda_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table ivy_panda_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ivy_panda_products`;

CREATE TABLE `ivy_panda_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table papers_owl_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `papers_owl_categories`;

CREATE TABLE `papers_owl_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table papers_owl_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `papers_owl_products`;

CREATE TABLE `papers_owl_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table study_corgi_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `study_corgi_categories`;

CREATE TABLE `study_corgi_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table study_corgi_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `study_corgi_products`;

CREATE TABLE `study_corgi_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table study_moose_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `study_moose_categories`;

CREATE TABLE `study_moose_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



# Dump of table study_moose_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `study_moose_products`;

CREATE TABLE `study_moose_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT 'NULL',
  `title` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
