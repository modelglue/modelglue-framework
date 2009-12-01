/*
SQLyog Community Edition- MySQL GUI v6.15
MySQL - 5.0.45-community-nt : Database - usermanangement
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

create database if not exists `usermanagement`;

USE `usermanagement`;

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

INSERT INTO `group` (GroupID,Name)
VALUES (1,'Administrators'),
	(5,'User Administrators');

/*Table structure for table `groupSecuredModelGlueEventRelationship` */

DROP TABLE IF EXISTS `groupSecuredModelGlueEventRelationship`;

CREATE TABLE `groupSecuredModelGlueEventRelationship` (
  `Id` int(11) NOT NULL auto_increment,
  `GroupID` int(11) default NULL,
  `EventID` int(11) NOT NULL,
  PRIMARY KEY  (`Id`),
  KEY `gsmer_event` (`EventID`),
  KEY `gsmer_groupid` (`GroupID`),
  CONSTRAINT `gsmer_groupid` FOREIGN KEY (`GroupID`) REFERENCES `group` (`GroupID`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

INSERT INTO `groupSecuredModelGlueEventRelationship` (Id,GroupID,EventID)
VALUES ('88','1','8'),
	('89','1','5'),
	('90','1','7'),
	('91','1','13'),
	('92','1','11'),
	('93','1','9'),
	('94','1','12'),
	('95','1','4'),
	('96','1','2'),
	('97','1','1'),
	('98','1','3'),
	('99','1','6');

/*Table structure for table `securedModelGlueEvent` */

DROP TABLE IF EXISTS `securedModelGlueEvent`;

CREATE TABLE `securedModelGlueEvent` (
  `EventId` int(11) NOT NULL auto_increment,
  `Name` varchar(500) NOT NULL,
  PRIMARY KEY  (`EventId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

INSERT INTO `securedModelGlueEvent` (EventId,Name)
VALUES ('1','userManagement.user.list'),
	('2','userManagement.user.edit'),
	('3','userManagement.user.save'),
	('4','userManagement.user.delete'),
	('5','userManagement.group.list'),
	('6','userManagement.group.edit'),
	('7','userManagement.group.save'),
	('8','userManagement.group.delete'),
	('9','userManagement.securedModelGlueEvent.list'),
	('11','userManagement.securedModelGlueEvent.edit'),
	('12','userManagement.securedModelGlueEvent.save'),
	('13','userManagement.securedModelGlueEvent.delete');

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `UserId` int(11) NOT NULL auto_increment,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `emailAddress` varchar(200) NOT NULL,
  `anonymousAccount` bit(1) NOT NULL,
  PRIMARY KEY  (`UserId`),
  UNIQUE KEY `user_unique_username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

INSERT INTO `user` (UserId,Username,Password,emailAddress,anonymousAccount)
VALUES ('1','anon','3mous3','blah','1'),
	('12','admin','admin','admin@test.tst','1');

/*Table structure for table `userGroupRelationship` */

DROP TABLE IF EXISTS `userGroupRelationship`;

CREATE TABLE `userGroupRelationship` (
  `userGroupRelationshipId` int(11) NOT NULL auto_increment,
  `UserId` int(11) NOT NULL,
  `GroupId` int(11) NOT NULL,
  PRIMARY KEY  (`userGroupRelationshipId`),
  KEY `ugr_group` (`GroupId`),
  KEY `ugr_user` (`UserId`),
  CONSTRAINT `ugr_group` FOREIGN KEY (`GroupId`) REFERENCES `group` (`GroupID`),
  CONSTRAINT `ugr_user` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

INSERT INTO `userGroupRelationship` (userGroupRelationshipId,UserId,GroupId)
VALUES ('31','12','1');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
