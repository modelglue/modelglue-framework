/*
SQLyog Community Edition- MySQL GUI v6.15
MySQL - 5.0.45-community-nt : Database - usermanangement
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

create database if not exists `usermanangement`;

USE `usermanangement`;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `group` */

DROP TABLE IF EXISTS `group`;

CREATE TABLE `group` (
  `GroupID` int(11) NOT NULL auto_increment,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(100) default NULL,
  PRIMARY KEY  (`GroupID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `groupsecuredmodelglueeventrelationship` */

DROP TABLE IF EXISTS `groupsecuredmodelglueeventrelationship`;

CREATE TABLE `groupsecuredmodelglueeventrelationship` (
  `Id` int(11) NOT NULL auto_increment,
  `GroupID` int(11) default NULL,
  `EventID` int(11) NOT NULL,
  PRIMARY KEY  (`Id`),
  KEY `gsmer_event` (`EventID`),
  KEY `gsmer_groupid` (`GroupID`),
  CONSTRAINT `gsmer_groupid` FOREIGN KEY (`GroupID`) REFERENCES `group` (`GroupID`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

/*Table structure for table `securedmodelglueevent` */

DROP TABLE IF EXISTS `securedmodelglueevent`;

CREATE TABLE `securedmodelglueevent` (
  `EventId` int(11) NOT NULL auto_increment,
  `Name` varchar(500) NOT NULL,
  PRIMARY KEY  (`EventId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `UserId` int(11) NOT NULL auto_increment,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `emailAddress` varchar(200) NOT NULL,
  `annonymousAccount` bit(1) NOT NULL,
  PRIMARY KEY  (`UserId`),
  UNIQUE KEY `user_unique_username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*Table structure for table `usergrouprelationship` */

DROP TABLE IF EXISTS `usergrouprelationship`;

CREATE TABLE `usergrouprelationship` (
  `userGroupRelationshipId` int(11) NOT NULL auto_increment,
  `UserId` int(11) NOT NULL,
  `GroupId` int(11) NOT NULL,
  PRIMARY KEY  (`userGroupRelationshipId`),
  KEY `ugr_group` (`GroupId`),
  KEY `ugr_user` (`UserId`),
  CONSTRAINT `ugr_group` FOREIGN KEY (`GroupId`) REFERENCES `group` (`GroupID`),
  CONSTRAINT `ugr_user` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
