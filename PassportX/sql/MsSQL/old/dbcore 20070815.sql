/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20070815
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	-------------------------------------------------------------------------------------------------
	PassportX:
	==========
	Refactored database for PassportX.
	Refactoring objectives are:
		1.	Convert all structures and procedures to EngineX naming conventions.
		2.	Refine structure and code to requirements of the PassportX classes.
		3.	Create templates for equivalent proceduires in other db's (eg MySQL)
	-------------------------------------------------------------------------------------------------	*/
	
/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20070602:	Starting point from Gatekeeper.
	20070603:	Added sql for default data.
				Note that this sets up the services for PassportX and the administrator identity with access
				to these services. Any other product related default data should be done in script associated
				with that implementation (eg GateKeeper)
	20070815:	Added Recruit table and procedures	
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Check and drop Indexes and Constraints
	-----------------------------------------------------------------------	*/
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Activity_ActivityLog]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ActivityLog] DROP CONSTRAINT FK_Activity_ActivityLog
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GroupStatus_Groups]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Groups] DROP CONSTRAINT FK_GroupStatus_Groups
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Person_PersonStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Person] DROP CONSTRAINT FK_Person_PersonStatus
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_ProductStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Product_ProductStatus
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Question_Answer_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Answer] DROP CONSTRAINT Question_Answer_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonProduct_SecurityLevel]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_SecurityLevel
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonService_SecurityLevel]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonService] DROP CONSTRAINT FK_PersonService_SecurityLevel
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GroupService_SecurityLevel]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProfileService] DROP CONSTRAINT FK_GroupService_SecurityLevel
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Service_ServiceStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Service] DROP CONSTRAINT FK_Service_ServiceStatus
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonGroup_Group]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonGroup] DROP CONSTRAINT FK_PersonGroup_Group
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GroupService_Group]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProfileService] DROP CONSTRAINT FK_GroupService_Group
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Person_ActivityLog]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ActivityLog] DROP CONSTRAINT FK_Person_ActivityLog
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Person_Answer_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Answer] DROP CONSTRAINT Person_Answer_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonGroup_Person]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonGroup] DROP CONSTRAINT FK_PersonGroup_Person
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonProduct_Person]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_Person
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonService_Person]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonService] DROP CONSTRAINT FK_PersonService_Person
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_Notification]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Notification] DROP CONSTRAINT FK_Product_Notification
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonProduct_Product]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_Product
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProductNotification_Product]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProductNotification] DROP CONSTRAINT FK_ProductNotification_Product
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Product_Service_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Service] DROP CONSTRAINT Product_Service_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Service_ActivityLog_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ActivityLog] DROP CONSTRAINT Service_ActivityLog_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Service_PersonService]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonService] DROP CONSTRAINT FK_Service_PersonService
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Service_GroupService]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProfileService] DROP CONSTRAINT FK_Service_GroupService
	GO

/*	-----------------------------------------------------------------------
	Check and drop Tables
	-----------------------------------------------------------------------	*/
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ActivityLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ActivityLog]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonService]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonService]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProfileService]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ProfileService]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Answer]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Answer]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Notification]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Notification]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonGroup]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonGroup]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonProduct]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonProduct]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProductNotification]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ProductNotification]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Service]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Service]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Groups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Groups]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Person]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Person]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Product]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Product]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Activity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Activity]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Config]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Config]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GroupCount]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[GroupCount]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GroupStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[GroupStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProductStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ProductStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Question]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Question]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityLevel]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[SecurityLevel]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ServiceStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ServiceStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Recruit]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Recruit]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecruitType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RecruitType]
	GO

/*	-----------------------------------------------------------------------
	Create Tables
	-----------------------------------------------------------------------	*/
	CREATE TABLE [dbo].[Activity] (
		[ActivityID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Config] (
		[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[RetValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[GroupCount] (
		[Count] [int] NULL ,
		[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[GroupStatus] (
		[GroupStatusID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[PersonStatus] (
		[PersonStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[ProductStatus] (
		[ProductStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[DisplayMessage] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Question] (
		[QuestionID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[SecurityLevel] (
		[SecurityLevelID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[ServiceStatus] (
		[ServiceStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[DisplayMessage] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Groups] (
		[GroupID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[GroupStatusID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Person] (
		[PersonID] [int] IDENTITY (1, 1) NOT NULL ,
		[UserName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[Password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[Surname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[EMail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[TelNo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[CellPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[Token] [uniqueidentifier] NULL ,
		[TokenExpiryDate] [smalldatetime] NULL ,
		[PersonStatusID] [tinyint] NULL ,
		[LoginFailures] [tinyint] NULL ,
		[PasswordExpiryDate] [datetime] NOT NULL ,
		[LastLoginDate] [datetime] NULL ,
		[LoginFailureDate] [datetime] NULL ,
		[AccLockedDate] [datetime] NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Product] (
		[ProductID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[ProductStatusID] [tinyint] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Answer] (
		[QuestionID] [int] NOT NULL ,
		[PersonID] [int] NOT NULL ,
		[Answer] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Notification] (
		[PersonID] [int] NOT NULL ,
		[ProductID] [int] NOT NULL ,
		[DateInserted] [datetime] NOT NULL ,
		[DateSent] [datetime] NULL ,
		[Code] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[PersonGroup] (
		[PersonID] [int] NOT NULL ,
		[GroupID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[PersonProduct] (
		[PersonID] [int] NOT NULL ,
		[ProductID] [int] NOT NULL ,
		[SecurityLevelID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[ProductNotification] (
		[ProductID] [int] NOT NULL ,
		[URL] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[WSDLURL] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[Namespace] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Service] (
		[ServiceID] [int] IDENTITY (1, 1) NOT NULL ,
		[ProductID] [int] NOT NULL ,
		[ServiceStatusID] [tinyint] NOT NULL ,
		[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[ActivityLog] (
		[ActivityLogID] [int] IDENTITY (1, 1) NOT NULL ,
		[ActivityID] [int] NOT NULL ,
		[ServiceID] [int] NULL ,
		[Token] [uniqueidentifier] NOT NULL ,
		[PersonID] [int] NOT NULL ,
		[ActivityDate] [datetime] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[PersonService] (
		[PersonID] [int] NOT NULL ,
		[ServiceID] [int] NOT NULL ,
		[SecurityLevelID] [int] NOT NULL ,
		[ServiceIdentifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[ProfileService] (
		[GroupID] [int] NOT NULL ,
		[ServiceID] [int] NOT NULL ,
		[SecurityLevelID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[Recruit] (
		[ID] [int] IDENTITY (1, 1) NOT NULL ,
		[Token] [uniqueidentifier] NOT NULL ,
		[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[Surname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[EMail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[TelNo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[CellPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[TypeID] [int] NOT NULL ,
		[PersonID] [int] NULL ,
		[SignupDate] [datetime] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [dbo].[RecruitType] (
		[ID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	) ON [PRIMARY]
	GO

/*	-----------------------------------------------------------------------
	Create Indexes and Constraints
	-----------------------------------------------------------------------	*/

	ALTER TABLE [dbo].[Activity] WITH NOCHECK ADD 
		CONSTRAINT [Activity_PK] PRIMARY KEY  CLUSTERED 
		(
			[ActivityID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Config] WITH NOCHECK ADD 
		CONSTRAINT [Config_PK] PRIMARY KEY  CLUSTERED 
		(
			[Description]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[GroupStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_GroupStatus] PRIMARY KEY  CLUSTERED 
		(
			[GroupStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[PersonStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonStatus] PRIMARY KEY  CLUSTERED 
		(
			[PersonStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[ProductStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_ProductStatus] PRIMARY KEY  CLUSTERED 
		(
			[ProductStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Question] WITH NOCHECK ADD 
		CONSTRAINT [Question_PK] PRIMARY KEY  CLUSTERED 
		(
			[QuestionID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[SecurityLevel] WITH NOCHECK ADD 
		CONSTRAINT [PK_SecurityLevel] PRIMARY KEY  CLUSTERED 
		(
			[SecurityLevelID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[ServiceStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_ServiceStatus] PRIMARY KEY  CLUSTERED 
		(
			[ServiceStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Groups] WITH NOCHECK ADD 
		CONSTRAINT [PK_Group] PRIMARY KEY  CLUSTERED 
		(
			[GroupID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Person] WITH NOCHECK ADD 
		CONSTRAINT [PK_Person] PRIMARY KEY  CLUSTERED 
		(
			[PersonID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Product] WITH NOCHECK ADD 
		CONSTRAINT [PK_Product] PRIMARY KEY  CLUSTERED 
		(
			[ProductID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Answer] WITH NOCHECK ADD 
		CONSTRAINT [PK_Answer] PRIMARY KEY  CLUSTERED 
		(
			[PersonID],
			[QuestionID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[PersonGroup] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonGroup] PRIMARY KEY  CLUSTERED 
		(
			[PersonID],
			[GroupID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[PersonProduct] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonProduct] PRIMARY KEY  CLUSTERED 
		(
			[ProductID],
			[PersonID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[ProductNotification] WITH NOCHECK ADD 
		CONSTRAINT [PK_ProductNotification] PRIMARY KEY  CLUSTERED 
		(
			[ProductID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Service] WITH NOCHECK ADD 
		CONSTRAINT [PK_Service] PRIMARY KEY  CLUSTERED 
		(
			[ServiceID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[ActivityLog] WITH NOCHECK ADD 
		CONSTRAINT [PK_ActivityLog] PRIMARY KEY  CLUSTERED 
		(
			[ActivityLogID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[PersonService] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonService] PRIMARY KEY  CLUSTERED 
		(
			[PersonID],
			[ServiceID],
			[SecurityLevelID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[ProfileService] WITH NOCHECK ADD 
		CONSTRAINT [PK_GroupService] PRIMARY KEY  CLUSTERED 
		(
			[GroupID],
			[ServiceID],
			[SecurityLevelID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [dbo].[Notification] WITH NOCHECK ADD 
		CONSTRAINT [DF__Notificat__DateI__114A936A] DEFAULT (getdate()) FOR [DateInserted]
	GO

	 CREATE  UNIQUE  INDEX [UDX_Group] ON [dbo].[Groups]([Description]) WITH  FILLFACTOR = 90 ON [PRIMARY]
	GO

	 CREATE  INDEX [idx_Token] ON [dbo].[Person]([Token]) WITH  FILLFACTOR = 90 ON [PRIMARY]
	GO

	ALTER TABLE [dbo].[Groups] ADD 
		CONSTRAINT [FK_GroupStatus_Groups] FOREIGN KEY 
		(
			[GroupStatusID]
		) REFERENCES [dbo].[GroupStatus] (
			[GroupStatusID]
		)
	GO

	ALTER TABLE [dbo].[Person] ADD 
		CONSTRAINT [FK_Person_PersonStatus] FOREIGN KEY 
		(
			[PersonStatusID]
		) REFERENCES [dbo].[PersonStatus] (
			[PersonStatusID]
		)
	GO

	ALTER TABLE [dbo].[Product] ADD 
		CONSTRAINT [FK_Product_ProductStatus] FOREIGN KEY 
		(
			[ProductStatusID]
		) REFERENCES [dbo].[ProductStatus] (
			[ProductStatusID]
		)
	GO

	ALTER TABLE [dbo].[Answer] ADD 
		CONSTRAINT [Person_Answer_FK1] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [dbo].[Person] (
			[PersonID]
		),
		CONSTRAINT [Question_Answer_FK1] FOREIGN KEY 
		(
			[QuestionID]
		) REFERENCES [dbo].[Question] (
			[QuestionID]
		)
	GO

	ALTER TABLE [dbo].[Notification] ADD 
		CONSTRAINT [FK_Product_Notification] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [dbo].[Product] (
			[ProductID]
		)
	GO

	ALTER TABLE [dbo].[PersonGroup] ADD 
		CONSTRAINT [FK_PersonGroup_Group] FOREIGN KEY 
		(
			[GroupID]
		) REFERENCES [dbo].[Groups] (
			[GroupID]
		),
		CONSTRAINT [FK_PersonGroup_Person] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [dbo].[Person] (
			[PersonID]
		)
	GO

	ALTER TABLE [dbo].[PersonProduct] ADD 
		CONSTRAINT [FK_PersonProduct_Person] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [dbo].[Person] (
			[PersonID]
		),
		CONSTRAINT [FK_PersonProduct_Product] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [dbo].[Product] (
			[ProductID]
		),
		CONSTRAINT [FK_PersonProduct_SecurityLevel] FOREIGN KEY 
		(
			[SecurityLevelID]
		) REFERENCES [dbo].[SecurityLevel] (
			[SecurityLevelID]
		)
	GO

	ALTER TABLE [dbo].[ProductNotification] ADD 
		CONSTRAINT [FK_ProductNotification_Product] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [dbo].[Product] (
			[ProductID]
		) ON DELETE CASCADE  ON UPDATE CASCADE 
	GO

	ALTER TABLE [dbo].[Service] ADD 
		CONSTRAINT [FK_Service_ServiceStatus] FOREIGN KEY 
		(
			[ServiceStatusID]
		) REFERENCES [dbo].[ServiceStatus] (
			[ServiceStatusID]
		),
		CONSTRAINT [Product_Service_FK1] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [dbo].[Product] (
			[ProductID]
		)
	GO

	ALTER TABLE [dbo].[ActivityLog] ADD 
		CONSTRAINT [FK_Activity_ActivityLog] FOREIGN KEY 
		(
			[ActivityID]
		) REFERENCES [dbo].[Activity] (
			[ActivityID]
		),
		CONSTRAINT [FK_Person_ActivityLog] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [dbo].[Person] (
			[PersonID]
		),
		CONSTRAINT [Service_ActivityLog_FK1] FOREIGN KEY 
		(
			[ServiceID]
		) REFERENCES [dbo].[Service] (
			[ServiceID]
		)
	GO

	ALTER TABLE [dbo].[PersonService] ADD 
		CONSTRAINT [FK_PersonService_Person] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [dbo].[Person] (
			[PersonID]
		),
		CONSTRAINT [FK_PersonService_SecurityLevel] FOREIGN KEY 
		(
			[SecurityLevelID]
		) REFERENCES [dbo].[SecurityLevel] (
			[SecurityLevelID]
		),
		CONSTRAINT [FK_Service_PersonService] FOREIGN KEY 
		(
			[ServiceID]
		) REFERENCES [dbo].[Service] (
			[ServiceID]
		)
	GO

	ALTER TABLE [dbo].[ProfileService] ADD 
		CONSTRAINT [FK_GroupService_Group] FOREIGN KEY 
		(
			[GroupID]
		) REFERENCES [dbo].[Groups] (
			[GroupID]
		),
		CONSTRAINT [FK_GroupService_SecurityLevel] FOREIGN KEY 
		(
			[SecurityLevelID]
		) REFERENCES [dbo].[SecurityLevel] (
			[SecurityLevelID]
		),
		CONSTRAINT [FK_Service_GroupService] FOREIGN KEY 
		(
			[ServiceID]
		) REFERENCES [dbo].[Service] (
			[ServiceID]
		)
	GO

	ALTER TABLE [dbo].[Recruit] WITH NOCHECK ADD 
		CONSTRAINT [PK_Recruit] PRIMARY KEY  CLUSTERED 
		(
			[ID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	CREATE  INDEX [idx_Token] ON [dbo].[Recruit]([Token]) WITH  FILLFACTOR = 90 ON [PRIMARY]
	GO

/*	-----------------------------------------------------------------------
	Create Procedures
	-----------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Create Function(s)
	-----------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Add default data into tables
	-----------------------------------------------------------------------	*/
	
	insert into GroupStatus (Description)Select 'Active' Go
	insert into GroupStatus (Description)Select 'Inactive' Go

	insert into ServiceStatus (Description, DisplayMessage)Select 'Active', '' Go
	insert into ServiceStatus (Description, DisplayMessage)Select 'Inactive', 'This service is currently unavailable' Go
	insert into ServiceStatus (Description, DisplayMessage)Select 'Locked', 'This service is currently unavailable' Go

	insert into ProductStatus (Description, DisplayMessage)Select 'Active', '' Go
	insert into ProductStatus (Description, DisplayMessage)Select 'Inactive', 'This product is currently unavailable' Go
	insert into ProductStatus (Description, DisplayMessage)Select 'Locked', 'This product is currently unavailable' Go

	insert into PersonStatus (Description)Select 'Active' Go
	insert into PersonStatus (Description)Select 'Inactive' Go
	insert into PersonStatus (Description)Select 'Locked' Go
	insert into PersonStatus (Description)Select 'On-hold' Go
	insert into PersonStatus (Description)Select 'Legacy' Go

	insert into Config (Description, RetValue)Select 'LoginFailures', '3' Go
	insert into Config (Description, RetValue)Select 'PasswordExpiryDate', '90' Go
	insert into Config (Description, RetValue)Select 'SessionExpiryTime', '20' Go 
	insert into Config (Description, RetValue)Select 'AccLockedDate', '24' Go

	insert into Person (username, password, firstname, surname, email, telno, cellphone, personstatusid, loginfailures, passwordexpirydate) select 'sa', 'password', 'System', 'Administrator', 'passportX@umlungu.com', '', '', 1, 0, '31 Dec 2100' Go
	insert into Product (Description, ProductStatusID)Select 'PassportX', 1 Go

	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockUserService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UpdatePassword' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SavePersonStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeletePersonStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroupService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroupProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteGroupService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteGroupProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockGroup' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroupStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveGroupStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetProductServiceList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockProduct' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProductStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteProductStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetServiceList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveServiceStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetServiceStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetServiceStatusList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteServiceStatus' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveSecurityLevel' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetSecurityLevel' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetSecurityLevelList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteSecurityLevel' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveActivity' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveActivity' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetActivity' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetActivityList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LogActivity' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetActivityLog' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveConfigValue' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetConfigValue' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetConfigValueList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteConfigValue' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveQuestion' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetQuestion' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetQuestionList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteQuestion' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SendPassword' Go
	-- Reserved starts at 70
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved' Go
	-- Gatekeep services start at 80
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RegisterUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProfile' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetProfile' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveProfile' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProfileService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetProfileRightsList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteProfileService' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUserList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SearchUserList' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUsers' Go

	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUsersSort' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUserRights' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUserProfiles' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserProfile' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserProfile' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'AddUserProfile' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveUserProfile' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UpdateUser' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'ImportUsers' Go
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetGroups' Go

	-- Add the Authentication Server SecurityLevels
	Insert Into SecurityLevel (Description)
	Select 'administer' Go

	-- Add Administrator Service rights
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 1, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 2, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 3, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 4, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 5, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 6, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 7, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 8, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 9, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 10, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 11, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 12, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 13, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 14, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 15, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 16, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 17, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 18, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 19, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 20, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 21, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 22, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 23, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 24, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 25, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 26, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 27, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 28, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 29, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 30, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 31, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 32, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 33, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 34, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 35, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 36, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 37, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 38, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 39, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 40, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 41, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 42, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 43, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 44, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 45, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 46, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 47, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 48, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 49, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 50, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 51, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 52, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 53, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 54, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 55, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 56, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 57, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 58, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 59, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 60, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 61, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 62, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 63, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 64, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 65, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 66, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 67, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 68, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 69, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 70, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 71, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 72, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 73, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 74, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 75, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 76, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 77, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 78, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 79, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 80, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 81, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 82, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 83, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 84, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 85, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 86, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 87, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 88, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 89, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 90, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 91, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 92, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 93, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 94, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 95, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 96, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 97, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 98, 1 Go
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 99, 1 Go

	insert into RecruitType (Description)Select 'Subscriber' Go
	insert into RecruitType (Description)Select 'Non-subscriber' Go
