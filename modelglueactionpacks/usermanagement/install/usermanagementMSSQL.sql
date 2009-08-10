/* Created with SQL Script Builder v.1.6.1.20 */
/* 6/27/2008 9:21:08 AM */
/* Type of SQL : MS SQL */

CREATE TABLE [group] (
  [GroupID] [int] PRIMARY KEY,
  [Name] [varchar] (50),
  [Description] [varchar] (100)
)

INSERT INTO [group] (GroupID,Name)
VALUES (1, 'Administrators')

INSERT INTO [group] (GroupID,Name)
VALUES (5, 'User Administrators')


CREATE TABLE [groupsecuredmodelglueeventrelationship] (
[Id] [int] PRIMARY KEY,
[GroupID] [int],
[EventID] [int]
)
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('88','1','8')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('89','1','5')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('90','1','7')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('91','1','13')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('92','1','11')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('93','1','9')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('94','1','12')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('95','1','4')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('96','1','2')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('97','1','1')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('98','1','3')
INSERT INTO [groupsecuredmodelglueeventrelationship] (Id,GroupID,EventID)
   VALUES ('99','1','6')
CREATE TABLE [securedmodelglueevent] (
[EventId] [int] PRIMARY KEY,
[Name] [varchar] (500)
)
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('1','userManagement.user.list')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('2','userManagement.user.edit')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('3','userManagement.user.save')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('4','userManagement.user.delete')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('5','userManagement.group.list')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('6','userManagement.group.edit')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('7','userManagement.group.save')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('8','userManagement.group.delete')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('9','userManagement.securedModelGlueEvent.list')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('11','userManagement.securedModelGlueEvent.edit')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('12','userManagement.securedModelGlueEvent.save')
INSERT INTO [securedmodelglueevent] (EventId,Name)
   VALUES ('13','userManagement.securedModelGlueEvent.delete')
CREATE TABLE [user] (
[UserId] [int] PRIMARY KEY,
[Username] [varchar] (50),
[Password] [varchar] (50),
[emailAddress] [varchar] (200),
[annonymousAccount] [bit]
)
INSERT INTO [user] (UserId,Username,Password,emailAddress,annonymousAccount)
   VALUES ('1','anon','3mous3','blah','1')
INSERT INTO [user] (UserId,Username,Password,emailAddress,annonymousAccount)
   VALUES ('12','admin','admin','admin@test.tst','1')
CREATE TABLE [usergrouprelationship] (
[userGroupRelationshipId] [int] PRIMARY KEY,
[UserId] [int],
[GroupId] [int]
)
INSERT INTO [usergrouprelationship] (userGroupRelationshipId,UserId,GroupId)
   VALUES ('31','12','1')
