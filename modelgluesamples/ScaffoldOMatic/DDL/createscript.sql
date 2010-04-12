DROP TABLE `team`;
CREATE TABLE `team` (
  `TeamID` int(11) NOT NULL auto_increment,
  `Name` varchar(100) NOT NULL,
  `Captain` varchar(100) default NULL,
  `Color` varchar(50) default NULL,
  PRIMARY KEY  (`TeamID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `team` AUTO_INCREMENT=0;


DROP TABLE `standing`;
CREATE TABLE `standing` (
  `StandingID` int(11) NOT NULL auto_increment,
  `TeamID` int(11) NOT NULL,
  `CompetitionID` int(11) NOT NULL,
  `Points` decimal(10,0) NOT NULL,
  `Rank` int(11) default NULL,
  PRIMARY KEY  (`StandingID`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
ALTER TABLE `standing` AUTO_INCREMENT=0;

DROP TABLE `competition`;
CREATE TABLE `competition` (
  `CompetitionID` int(11) NOT NULL auto_increment,
  `Name` varchar(100) NOT NULL,
  `StartDate` date default NULL,
  `EndDate` date default NULL,
  PRIMARY KEY  (`CompetitionID`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
ALTER TABLE `competition` AUTO_INCREMENT=0;