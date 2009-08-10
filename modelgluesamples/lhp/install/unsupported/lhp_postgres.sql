-- Note: need to create Lighthouse database first, run this script from connection;
-- assumes use of 'public' schema

drop table if exists lh_announcements;
drop table if exists lh_groups;
drop table if exists lh_issues;
drop table if exists lh_projectloci;
drop table if exists lh_projects;
drop table if exists lh_projects_projectloci;
drop table if exists lh_projects_users;
drop table if exists lh_projects_users_email;
drop table if exists lh_severities;
drop table if exists lh_statuses;
drop table if exists lh_users;
drop table if exists lh_users_groups;
drop table if exists lh_issuetypes;
drop table if exists lh_attachments;
drop table if exists lh_milestones;



CREATE TABLE lh_announcements (
    id varchar(35)  NOT NULL ,
    title varchar (50) NOT NULL ,
    body text NOT NULL ,
    projectidfk varchar (35) NOT NULL ,
    useridfk varchar (35)  NOT NULL ,
    posted timestamp NOT NULL ,
    CONSTRAINT lh_announcements_pkey_id PRIMARY KEY(id)
);


CREATE TABLE lh_groups (
  id varchar(35) NOT NULL default '',
  name varchar(50) NOT NULL default '',
  CONSTRAINT lh_groups_pkey_id PRIMARY KEY(id)
);

INSERT INTO lh_groups VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','admin');


CREATE TABLE lh_issues (
	id varchar (35) NOT NULL ,
	projectidfk varchar (35)  NOT NULL ,
	created timestamp NOT NULL ,
	updated timestamp NOT NULL ,
	name varchar (255) NOT NULL ,
	useridfk varchar (35) NOT NULL ,
	creatoridfk varchar (35) NULL ,
	description text NOT NULL ,
	history text NOT NULL ,
	locusidfk varchar (35) NOT NULL ,
	severityidfk varchar (35) NOT NULL ,
	issuetypeidfk varchar (35) NOT NULL ,
	statusidfk varchar (35) NOT NULL ,
	relatedurl varchar (255) NULL ,
	publicid int NULL ,
	duedate timestamp NULL, 
	milestoneidfk varchar (35) NOT NULL,
	CONSTRAINT lh_issues_pkey_id PRIMARY KEY(id)
);
   CLUSTER lh_issues_pkey_id ON lh_issues;


CREATE TABLE lh_projectloci (
  id varchar(35) NOT NULL,
  name varchar(50) NOT NULL,
  CONSTRAINT lh_projectloci_pkey_id PRIMARY KEY(id)
);
  CLUSTER lh_projectloci_pkey_id ON lh_projectloci;

INSERT INTO lh_projectloci(id, name) VALUES ('A5EF700C-AB69-4306-4449F6526B7009E4','Front End');
INSERT INTO lh_projectloci(id, name) VALUES ('A5EFAF58-9200-29D3-A4CC2FC42580944D','Administration');
INSERT INTO lh_projectloci(id, name) VALUES ('A5F0620E-F052-9042-7478FF91A21A420A','Documentation');
INSERT INTO lh_projectloci(id, name) VALUES ('A5F174B6-AF3C-D585-4E7BCBABA1403DA5','Design');
INSERT INTO lh_projectloci(id, name) VALUES ('A5F47B30-BB4C-8AB5-3524012968ACD958','Database');
INSERT INTO lh_projectloci(id, name) VALUES ('D24608FA-D932-FD61-D6A16A505941A5DD','Code');


CREATE TABLE lh_projects (
  id varchar(35) NOT NULL,
  name varchar(50) NOT NULL,
  mailserver varchar (255) NOT NULL,
  mailusername varchar (255) NOT NULL,
  mailpassword varchar (255) NOT NULL,
  mailemailaddress varchar (255) NOT NULL,
  CONSTRAINT lh_projects_pkey_id PRIMARY KEY(id)
);

CREATE TABLE lh_projects_projectloci (
  projectidfk varchar(35) NOT NULL ,
  projectlociidfk varchar(35) NOT NULL,
  CONSTRAINT lh_projects_projectloci_unq UNIQUE(projectidfk, projectlociidfk)
 
);


CREATE TABLE lh_projects_users (
  projectidfk varchar(35) NOT NULL,
  useridfk varchar(35) NOT NULL
);


CREATE TABLE lh_projects_users_email (
  projectidfk varchar(35) NOT NULL,
  useridfk varchar(35) NOT NULL
);


CREATE TABLE lh_severities (
  id varchar(35) NOT NULL,
  name varchar(50) NOT NULL,
  rank integer NOT NULL,
  CONSTRAINT lh_severities_pkey_id PRIMARY KEY(id)
);


INSERT INTO lh_severities(id, name, rank) VALUES ('B39A54CA-9301-0F14-4A3A11FAB743FC0A','Low',1);
INSERT INTO lh_severities(id, name, rank) VALUES ('B39AD7F4-B8B1-2D90-80C3EFB34D77C27B','Normal',2);
INSERT INTO lh_severities(id, name, rank) VALUES ('B39AF9E4-A525-B9AE-20F2B6728C98A61B','High',3);

CREATE TABLE lh_statuses (
  id varchar(35) NOT NULL,
  name varchar(50) NOT NULL,
  rank integer NOT NULL,
  CONSTRAINT lh_statuses_pkey_id PRIMARY KEY(id)
);

INSERT INTO lh_statuses(id, name, rank) VALUES ('B39CBA41-F798-06C7-3C7B89400E935B36','Open',1);
INSERT INTO lh_statuses(id, name, rank) VALUES ('B39CDD69-BC54-D278-386E2C062727CCEE','Fixed',2);
INSERT INTO lh_statuses(id, name, rank) VALUES ('B39D0043-B9C9-B5CB-85A208D3154A760F','Closed',3);

CREATE TABLE lh_users (
  id varchar(35) NOT NULL,
  name varchar(50) NOT NULL,
  username varchar(50) NULL,
  password varchar(50) NULL,
  emailaddress varchar(50) NULL,
  CONSTRAINT lh_users_pkey_id PRIMARY KEY(id)
);

INSERT INTO lh_users(id, name, username, password, emailaddress) VALUES ('94CC6A2B-A60E-187D-5BFEA49A0FB60145','admin','admin','password','admin@localhost.com');


CREATE TABLE lh_users_groups (
  groupidfk varchar(35) NOT NULL,
  useridfk varchar(35) NOT NULL,
  CONSTRAINT lh_users_groups_unq PRIMARY KEY(groupidfk,useridfk)
);

INSERT INTO lh_users_groups(groupidfk, useridfk) VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','94CC6A2B-A60E-187D-5BFEA49A0FB60145');


CREATE TABLE   lh_issuetypes (
  id varchar (35) NOT NULL ,
  name varchar (50) NOT NULL ,
  CONSTRAINT lh_issuetypes_pkey_id PRIMARY KEY(id)
);
   CLUSTER lh_issuetypes_pkey_id ON lh_issuetypes;

INSERT INTO lh_issuetypes(id, name) VALUES ('43596077-123F-6B7B-AC3FFFE3034D0854','Bug');
INSERT INTO lh_issuetypes(id, name) VALUES ('43597816-123F-6B7B-AC9EF8944B417E67','Enhancement');


CREATE TABLE  lh_attachments (
  id varchar (35) NOT NULL ,
  issueidfk varchar (35) NOT NULL ,
  attachment varchar (255) NOT NULL ,
  filename varchar (255) NOT NULL,
  CONSTRAINT lh_attachments_pkey_id PRIMARY KEY(id)
);

CREATE TABLE lh_milestones (
  id varchar (35)  NOT NULL ,
  name varchar (50) NOT NULL , 
  duedate timestamp NULL, 
  projectidfk varchar (35) NOT NULL,
  CONSTRAINT lh_milestones_pkey_id PRIMARY KEY (id)
); 
