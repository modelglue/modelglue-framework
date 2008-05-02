ALTER TABLE userGroupRelationship
	DROP FOREIGN KEY ugr_user
GO
ALTER TABLE userGroupRelationship
	DROP FOREIGN KEY ugr_group
GO
ALTER TABLE groupSecuredModelGlueEventRelationship
	DROP FOREIGN KEY gsmer_groupid
GO
ALTER TABLE groupSecuredModelGlueEventRelationship
	DROP FOREIGN KEY gsmer_event
GO
ALTER TABLE user
	DROP CONSTRAINT user_unique_username
GO
ALTER TABLE userGroupRelationship
	DROP PRIMARY KEY 
GO
ALTER TABLE user
	DROP PRIMARY KEY 
GO
ALTER TABLE securedModelGlueEvent
	DROP PRIMARY KEY 
GO
ALTER TABLE groupSecuredModelGlueEventRelationship
	DROP PRIMARY KEY 
GO
ALTER TABLE group
	DROP PRIMARY KEY 
GO
DROP INDEX ugr_group ON userGroupRelationship
GO
DROP INDEX ugr_user ON userGroupRelationship
GO
DROP INDEX user_unique_username ON user
GO
DROP INDEX gsmer_event ON groupSecuredModelGlueEventRelationship
GO
DROP INDEX gsmer_groupid ON groupSecuredModelGlueEventRelationship
GO
DROP TABLE userGroupRelationship
GO
DROP TABLE user
GO
DROP TABLE securedModelGlueEvent
GO
DROP TABLE groupSecuredModelGlueEventRelationship
GO
DROP TABLE group
GO

CREATE TABLE group ( 
	GroupId    	int(11) AUTO_INCREMENT NOT NULL,
	Name       	varchar(50) NOT NULL,
	Description	varchar(100) NULL 
	)
GO
CREATE TABLE groupSecuredModelGlueEventRelationship ( 
	id     	int(11) AUTO_INCREMENT NOT NULL,
	groupId	int(11) NULL,
	eventId	int(11) NOT NULL 
	)
GO
CREATE TABLE securedModelGlueEvent ( 
	EventId	int(11) AUTO_INCREMENT NOT NULL,
	Name   	varchar(500) NOT NULL 
	)
GO
CREATE TABLE user ( 
	userId          	int(11) AUTO_INCREMENT NOT NULL,
	username        	varchar(50) NOT NULL,
	password        	varchar(50) NOT NULL,
	emailAddress    	varchar(200) NOT NULL,
	anonymousAccount	bit(1) NOT NULL 
	)
GO
CREATE TABLE userGroupRelationship ( 
	userGroupRelationshipId	int(11) AUTO_INCREMENT NOT NULL,
	UserId                 	int(11) NOT NULL,
	GroupId                	int(11) NOT NULL 
	)
GO

INSERT INTO group(GroupId, Name, Description)
  VALUES(1, 'Administrators', NULL)
GO
INSERT INTO group(GroupId, Name, Description)
  VALUES(5, 'User Administrators', NULL)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(88, 1, 8)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(89, 1, 5)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(90, 1, 7)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(91, 1, 13)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(92, 1, 11)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(93, 1, 9)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(94, 1, 12)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(95, 1, 4)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(96, 1, 2)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(97, 1, 1)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(98, 1, 3)
GO
INSERT INTO groupSecuredModelGlueEventRelationship(id, groupId, eventId)
  VALUES(99, 1, 6)
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(1, 'userManagement.user.list')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(2, 'userManagement.user.edit')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(3, 'userManagement.user.save')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(4, 'userManagement.user.delete')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(5, 'userManagement.group.list')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(6, 'userManagement.group.edit')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(7, 'userManagement.group.save')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(8, 'userManagement.group.delete')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(9, 'userManagement.securedModelGlueEvent.list')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(11, 'userManagement.securedModelGlueEvent.edit')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(12, 'userManagement.securedModelGlueEvent.save')
GO
INSERT INTO securedModelGlueEvent(EventId, Name)
  VALUES(13, 'userManagement.securedModelGlueEvent.delete')
GO
INSERT INTO user(userId, username, password, emailAddress, anonymousAccount)
  VALUES(1, 'anon', '3mous3', 'blah', 1)
GO
INSERT INTO user(userId, username, password, emailAddress, anonymousAccount)
  VALUES(12, 'admin', 'admin', 'admin@test.tst', 0)
GO
INSERT INTO userGroupRelationship(userGroupRelationshipId, UserId, GroupId)
  VALUES(31, 12, 1)
GO
CREATE INDEX gsmer_event
	ON groupSecuredModelGlueEventRelationship(eventId)
GO
CREATE INDEX gsmer_groupid
	ON groupSecuredModelGlueEventRelationship(groupId)
GO
CREATE UNIQUE INDEX user_unique_username
	ON user(username)
GO
CREATE INDEX ugr_group
	ON userGroupRelationship(GroupId)
GO
CREATE INDEX ugr_user
	ON userGroupRelationship(UserId)
GO
ALTER TABLE group
	ADD PRIMARY KEY (GroupId)
GO
ALTER TABLE groupSecuredModelGlueEventRelationship
	ADD PRIMARY KEY (id)
GO
ALTER TABLE securedModelGlueEvent
	ADD PRIMARY KEY (EventId)
GO
ALTER TABLE user
	ADD PRIMARY KEY (userId)
GO
ALTER TABLE userGroupRelationship
	ADD PRIMARY KEY (userGroupRelationshipId)
GO
ALTER TABLE user
	ADD CONSTRAINT user_unique_username
	UNIQUE (username)
GO
ALTER TABLE groupSecuredModelGlueEventRelationship
	ADD CONSTRAINT gsmer_groupid
	FOREIGN KEY(groupId)
	REFERENCES group(GroupId)
GO
ALTER TABLE groupSecuredModelGlueEventRelationship
	ADD CONSTRAINT gsmer_event
	FOREIGN KEY(eventId)
	REFERENCES securedmodelglueevent(EventId)
GO
ALTER TABLE userGroupRelationship
	ADD CONSTRAINT ugr_user
	FOREIGN KEY(UserId)
	REFERENCES user(userId)
GO
ALTER TABLE userGroupRelationship
	ADD CONSTRAINT ugr_group
	FOREIGN KEY(GroupId)
	REFERENCES group(GroupId)
GO
