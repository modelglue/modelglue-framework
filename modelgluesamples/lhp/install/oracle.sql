Begin  
  execute immediate 'Drop table LH_ANNOUNCEMENTS';
  Exception when others then null;
End;

CREATE TABLE LH_ANNOUNCEMENTS
(
  ID           VARCHAR2(35 BYTE)                NOT NULL,
  TITLE        VARCHAR2(50 BYTE)                NOT NULL,
  BODY         VARCHAR2(2000 BYTE)              NOT NULL,
  PROJECTIDFK  VARCHAR2(35 BYTE)                NOT NULL,
  USERIDFK     VARCHAR2(35 BYTE)                NOT NULL,
  POSTED       DATE                             NOT NULL,
  CONSTRAINT PK_LH_ANNOUNCEMENTS PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_ATTACHMENTS';
  Exception when others then null;
End;

CREATE TABLE LH_ATTACHMENTS
(
  ID    VARCHAR2(35 BYTE)                       NOT NULL,
  ISSUEIDFK  VARCHAR2(35 BYTE)                       NOT NULL,
  ATTACHMENT  VARCHAR2(255 BYTE)                       NOT NULL,
  FILENAME  VARCHAR2(255 BYTE)                       NOT NULL,

  CONSTRAINT PK_LH_ATTACHMENTS PRIMARY KEY (ID)
);
Begin  
  execute immediate 'Drop table LH_GROUPS';
  Exception when others then null;
End;

CREATE TABLE LH_GROUPS
(
  ID    VARCHAR2(35 BYTE)                       NOT NULL,
  NAME  VARCHAR2(50 BYTE)                       NOT NULL,
  CONSTRAINT PK_LH_GROUPS PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_ISSUES';
  Exception when others then null;
End;

CREATE TABLE LH_ISSUES
(
  ID            VARCHAR2(35 BYTE)               NOT NULL,
  NAME          VARCHAR2(255 BYTE)              NOT NULL,
  PROJECTIDFK   VARCHAR2(35 BYTE)               NOT NULL,
  CREATED       DATE                            DEFAULT sysdate               NOT NULL,
  UPDATED       DATE                            DEFAULT sysdate               NOT NULL,
  USERIDFK      VARCHAR2(35 BYTE)               NOT NULL,
  DESCRIPTION   VARCHAR2(2000 BYTE)             NOT NULL,
  HISTORY       VARCHAR2(1000 BYTE)             NOT NULL,
  ISSUETYPEIDFK VARCHAR( 35 BYTE )				NOT NULL,
  LOCUSIDFK     VARCHAR2(35 BYTE)               NOT NULL,
  SEVERITYIDFK  VARCHAR2(35 BYTE)               NOT NULL,
  STATUSIDFK    VARCHAR2(35 BYTE)               NOT NULL,
  RELATEDURL    VARCHAR2(500 BYTE),
  CREATORIDFK   VARCHAR2(35 BYTE),
  PUBLICID      NUMBER,
  DUEDATE       DATE,
  MILESTONEIDFK VARCHAR( 35 BYTE )				NOT NULL,
  CONSTRAINT PK_LH_ISSUES PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_ISSUETYPES';
  Exception when others then null;
End;

CREATE TABLE LH_ISSUETYPES
(
  ID    VARCHAR2(35 BYTE)                       NOT NULL,
  NAME  VARCHAR2(50 BYTE)                       NOT NULL,
  RANK  NUMBER(4)                               NOT NULL,
  CONSTRAINT PK_LH_ISSUETYPES PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_PROJECTLOCI';
  Exception when others then null;
End;

CREATE TABLE LH_PROJECTLOCI
(
  ID    VARCHAR2(35 BYTE)                       NOT NULL,
  NAME  VARCHAR2(50 BYTE)                       NOT NULL,
  CONSTRAINT PK_LH_PROJECTLOCI PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_PROJECTS';
  Exception when others then null;
End;

CREATE TABLE LH_PROJECTS
(
  ID    VARCHAR2(35 BYTE)                       NOT NULL,
  NAME  VARCHAR2(50 BYTE)                       NOT NULL,
  MAILSERVER  VARCHAR2(255 BYTE)                       NOT NULL,
  MAILUSERNAME  VARCHAR2(255 BYTE)                       NOT NULL,
  MAILPASSWORD  VARCHAR2(255 BYTE)                       NOT NULL,
  MAILEMAILADDRESS  VARCHAR2(255 BYTE)                       NOT NULL, 
  CONSTRAINT PK_LH_PROJECTS PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_PROJECTS_PROJECTLOCI';
  Exception when others then null;
End;

CREATE TABLE LH_PROJECTS_PROJECTLOCI
(
  PROJECTIDFK      VARCHAR2(35 BYTE)            NOT NULL,
  PROJECTLOCIIDFK  VARCHAR2(35 BYTE)            NOT NULL
);

Begin  
  execute immediate 'Drop table LH_PROJECTS_USERS';
  Exception when others then null;
End;

CREATE TABLE LH_PROJECTS_USERS
(
  PROJECTIDFK  VARCHAR2(35 BYTE)                NOT NULL,
  USERIDFK     VARCHAR2(35 BYTE)                NOT NULL
);

Begin  
  execute immediate 'Drop table LH_PROJECTS_USERS_EMAIL';
  Exception when others then null;
End;

CREATE TABLE LH_PROJECTS_USERS_EMAIL
(
  PROJECTIDFK  VARCHAR2(35 BYTE)                NOT NULL,
  USERIDFK     VARCHAR2(35 BYTE)                NOT NULL
);

Begin  
  execute immediate 'Drop table LH_SEVERITIES';
  Exception when others then null;
End;

CREATE TABLE LH_SEVERITIES
(
  ID    VARCHAR2(35 BYTE)                       NOT NULL,
  NAME  VARCHAR2(50 BYTE)                       NOT NULL,
  RANK  NUMBER(4)                               NOT NULL,
  CONSTRAINT PK_LH_SEVERITIES PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_STATUSES';
  Exception when others then null;
End;

CREATE TABLE LH_STATUSES
(
  ID    VARCHAR2(35 BYTE)                       NOT NULL,
  NAME  VARCHAR2(50 BYTE)                       NOT NULL,
  RANK  NUMBER(4)                               NOT NULL,
  CONSTRAINT PK_LH_STATUSES PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_USERS';
  Exception when others then null;
End;

CREATE TABLE LH_USERS
(
  ID            VARCHAR2(35 BYTE)               NOT NULL,
  NAME          VARCHAR2(50 BYTE)               NOT NULL,
  USERNAME      VARCHAR2(50 BYTE)               NOT NULL,
  PASSWORD      VARCHAR2(50 BYTE)               NOT NULL,
  EMAILADDRESS  VARCHAR2(50 BYTE)               NOT NULL,
  CONSTRAINT PK_LH_USERS PRIMARY KEY (ID)
);

Begin  
  execute immediate 'Drop table LH_USERS_GROUPS';
  Exception when others then null;
End;

CREATE TABLE LH_USERS_GROUPS
(
  GROUPIDFK  VARCHAR2(35 BYTE)                  NOT NULL,
  USERIDFK   VARCHAR2(50 BYTE)                  NOT NULL
);

CREATE TABLE LH_MILESTONES
(
  ID            VARCHAR2(35 BYTE)               NOT NULL,
  NAME          VARCHAR2(255 BYTE)              NOT NULL,
  DUEDATE       DATE                            DEFAULT sysdate               NOT NULL,
  CONSTRAINT PK_LH_MILESTONES PRIMARY KEY (ID)
);

INSERT INTO LH_groups(id, name) VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','admin');

INSERT INTO LH_issuetypes(id, name,rank) VALUES ('47B0B2F8-1111-82AF-D68EA128E83692F5','Bug', 1 );

INSERT INTO LH_issuetypes(id, name,rank) VALUES ('47B16214-1111-82AF-D68B6F8C349D0E5F','Enhancement', 2 );

INSERT INTO LH_projectloci(id, name) VALUES ('A5EF700C-AB69-4306-4449F6526B7009E4','Front End');

INSERT INTO LH_projectloci(id, name) VALUES ('A5EFAF58-9200-29D3-A4CC2FC42580944D','Administration');

INSERT INTO LH_projectloci(id, name) VALUES ('A5F0620E-F052-9042-7478FF91A21A420A','Documentation');

INSERT INTO LH_projectloci(id, name) VALUES ('A5F174B6-AF3C-D585-4E7BCBABA1403DA5','Design');

INSERT INTO LH_projectloci(id, name) VALUES ('A5F47B30-BB4C-8AB5-3524012968ACD958','Database');

INSERT INTO LH_projectloci(id, name) VALUES ('D24608FA-D932-FD61-D6A16A505941A5DD','Code');

INSERT INTO LH_severities(id, name, rank)  VALUES ('B39A54CA-9301-0F14-4A3A11FAB743FC0A','Low',1);

INSERT INTO LH_severities(id, name, rank) VALUES ('B39AD7F4-B8B1-2D90-80C3EFB34D77C27B','Normal',2);

INSERT INTO LH_severities(id, name, rank) VALUES ('B39AF9E4-A525-B9AE-20F2B6728C98A61B','High',3);

INSERT INTO LH_statuses(id, name, rank) VALUES ('B39CBA41-F798-06C7-3C7B89400E935B36','Open',1);

INSERT INTO LH_statuses(id, name, rank) VALUES ('B39CDD69-BC54-D278-386E2C062727CCEE','Fixed',2);

INSERT INTO LH_statuses(id, name, rank) VALUES ('B39D0043-B9C9-B5CB-85A208D3154A760F','Closed',3);

INSERT INTO LH_users(id,name, username, password,emailaddress) values ('94CC6A2B-A60E-187D-5BFEA49A0FB60145','admin','admin','password','admin@localhost.com');

INSERT INTO LH_users_groups(groupidfk, useridfk) VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','94CC6A2B-A60E-187D-5BFEA49A0FB60145');

commit;
