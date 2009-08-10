/****** Object:  Table [dbo].[lh_announcements]    Script Date: 6/16/2006 12:59:21 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_announcements]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_announcements]
GO

/****** Object:  Table [dbo].[issuetypes]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_issuetypes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_issuetypes]
GO

/****** Object:  Table [dbo].[groups]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_groups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_groups]
GO

/****** Object:  Table [dbo].[issues]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_issues]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_issues]
GO

/****** Object:  Table [dbo].[projectloci]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_projectloci]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_projectloci]
GO

/****** Object:  Table [dbo].[projects]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_projects]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_projects]
GO

/****** Object:  Table [dbo].[projects_projectloci]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_projects_projectloci]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_projects_projectloci]
GO

/****** Object:  Table [dbo].[projects_users]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_projects_users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_projects_users]
GO

/****** Object:  Table [dbo].[projects_users_email]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_projects_users_email]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_projects_users_email]
GO

/****** Object:  Table [dbo].[severities]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_severities]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_severities]
GO

/****** Object:  Table [dbo].[statuses]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_statuses]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_statuses]
GO

/****** Object:  Table [dbo].[users]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_users]
GO

/****** Object:  Table [dbo].[users_groups]    Script Date: 2/7/2006 7:11:14 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_users_groups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_users_groups]
GO

/****** Object:  Table [dbo].[announcements]    Script Date: 6/16/2006 12:59:21 PM ******/
CREATE TABLE [dbo].[lh_announcements] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[body] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[useridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[posted] [datetime] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[groups]    Script Date: 2/7/2006 7:11:14 AM ******/
CREATE TABLE [dbo].[lh_groups] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[lh_issues] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[created] [datetime] NOT NULL ,
	[updated] [datetime] NOT NULL ,
	[name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[useridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[creatoridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[history] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[locusidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[severityidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[issuetypeidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[statusidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[relatedurl] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[publicid] [int] NULL ,
	[duedate] [datetime] NULL, 
	[milestoneidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL  
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[projectloci]    Script Date: 2/7/2006 7:11:15 AM ******/
CREATE TABLE [dbo].[lh_projectloci] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[projects]    Script Date: 2/7/2006 7:11:15 AM ******/
CREATE TABLE [dbo].[lh_projects] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[mailserver] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[mailusername] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[mailpassword] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[mailemailaddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[projects_projectloci]    Script Date: 2/7/2006 7:11:15 AM ******/
CREATE TABLE [dbo].[lh_projects_projectloci] (
	[projectidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectlociidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[projects_users]    Script Date: 2/7/2006 7:11:15 AM ******/
CREATE TABLE [dbo].[lh_projects_users] (
	[projectidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[useridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[projects_users_email]    Script Date: 2/7/2006 7:11:15 AM ******/
CREATE TABLE [dbo].[lh_projects_users_email] (
	[useridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[projectidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[severities]    Script Date: 2/7/2006 7:11:15 AM ******/
CREATE TABLE [dbo].[lh_severities] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rank] [int] NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[statuses]    Script Date: 2/7/2006 7:11:16 AM ******/
CREATE TABLE [dbo].[lh_statuses] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rank] [int] NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[users]    Script Date: 2/7/2006 7:11:16 AM ******/
CREATE TABLE [dbo].[lh_users] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[username] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[emailaddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[users_groups]    Script Date: 2/7/2006 7:11:16 AM ******/
CREATE TABLE [dbo].[lh_users_groups] (
	[useridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[groupidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[issuetypes]    Script Date: 2/7/2006 7:11:14 AM ******/
CREATE TABLE [dbo].[lh_issuetypes] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[lh_issuetypes] WITH NOCHECK ADD 
	CONSTRAINT [PK_lh_issuetypes] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[lh_issues] WITH NOCHECK ADD 
	CONSTRAINT [PK_lh_issues] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[lh_projectloci] WITH NOCHECK ADD 
	CONSTRAINT [PK_lh_projectloci] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[lh_severities] WITH NOCHECK ADD 
	CONSTRAINT [PK_lh_severities] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[lh_statuses] WITH NOCHECK ADD 
	CONSTRAINT [PK_lh_statuses] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lh_attachments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lh_attachments]
GO

CREATE TABLE [dbo].[lh_attachments] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[issueidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[attachment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[filename] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

) ON [PRIMARY]
GO

ALTER TABLE [dbo].[lh_attachments] WITH NOCHECK ADD 
	CONSTRAINT [PK_lh_attachments] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

INSERT INTO [lh_groups](id, name) VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','admin');

INSERT INTO lh_projectloci(id, name) VALUES ('A5EF700C-AB69-4306-4449F6526B7009E4','Front End');
INSERT INTO lh_projectloci(id, name) VALUES ('A5EFAF58-9200-29D3-A4CC2FC42580944D','Administration');
INSERT INTO lh_projectloci(id, name) VALUES ('A5F0620E-F052-9042-7478FF91A21A420A','Documentation');
INSERT INTO lh_projectloci(id, name) VALUES ('A5F174B6-AF3C-D585-4E7BCBABA1403DA5','Design');
INSERT INTO lh_projectloci(id, name) VALUES ('A5F47B30-BB4C-8AB5-3524012968ACD958','Database');
INSERT INTO lh_projectloci(id, name) VALUES ('D24608FA-D932-FD61-D6A16A505941A5DD','Code');

INSERT INTO lh_severities(id, name, rank)  VALUES ('B39A54CA-9301-0F14-4A3A11FAB743FC0A','Low',1);
INSERT INTO lh_severities(id, name, rank) VALUES ('B39AD7F4-B8B1-2D90-80C3EFB34D77C27B','Normal',2);
INSERT INTO lh_severities(id, name, rank) VALUES ('B39AF9E4-A525-B9AE-20F2B6728C98A61B','High',3);

INSERT INTO lh_statuses(id, name, rank) VALUES ('B39CBA41-F798-06C7-3C7B89400E935B36','Open',1);
INSERT INTO lh_statuses(id, name, rank) VALUES ('B39CDD69-BC54-D278-386E2C062727CCEE','Fixed',2);
INSERT INTO lh_statuses(id, name, rank) VALUES ('B39D0043-B9C9-B5CB-85A208D3154A760F','Closed',3);

INSERT INTO lh_users(id,name, username, password,emailaddress) values ('94CC6A2B-A60E-187D-5BFEA49A0FB60145','admin','admin','password','admin@localhost.com');

INSERT INTO lh_users_groups(groupidfk, useridfk) VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','94CC6A2B-A60E-187D-5BFEA49A0FB60145');

INSERT INTO lh_issuetypes(id, name) VALUES ('43596077-123F-6B7B-AC3FFFE3034D0854','Bug');
INSERT INTO lh_issuetypes(id, name) VALUES ('43597816-123F-6B7B-AC9EF8944B417E67','Enhancement');

CREATE TABLE [dbo].[lh_milestones] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , 
	[duedate] [datetime] NULL, 
	[projectidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO
