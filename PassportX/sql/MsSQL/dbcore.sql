/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2011-10-03	
	Status:		release	
	Version:	2.6.0
	Build:		20111212
	Target:		Microsoft SQL Server 2008
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20111003:	Starting point FROM EconoPassport.
	20111116:	Removed Collation SQL_Latin1_General_CP1_CI_AS from all columns
	20111212:	Moved all passport tables, views and procs into passport schema
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Initialisation:
	==================
	Note the SQL modules can be run in the following sequence:
	-	dbupdate/dbclean.sql (when prior installation does not have passport schema)
	-	dbcore.sql
	-	dbdata.sql
	-	x_config.sql
	-	x_notify.sql
	-	x_group.sql
	-	x_product.sql
	-	x_questions.sql
	-	x_recruit.sql
	-	x_security.sql
	-	x_service.sql
	-	x_user.sql
	
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
USE [PassportX]
GO

/*	-----------------------------------------------------------------------
	Check AND DROP Schema
	-----------------------------------------------------------------------	*/
	IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'passport')
	DROP SCHEMA [passport]
	GO

	CREATE SCHEMA [passport] AUTHORIZATION [dbo]
	GO

/*	-----------------------------------------------------------------------
	Check AND DROP Indexes AND Constraints
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Activity_ActivityLog]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[ActivityLog] DROP CONSTRAINT FK_Activity_ActivityLog
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_GroupStatus_Groups]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Groups] DROP CONSTRAINT FK_GroupStatus_Groups
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Person_PersonStatus]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Person] DROP CONSTRAINT FK_Person_PersonStatus
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Product_ProductStatus]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Product] DROP CONSTRAINT FK_Product_ProductStatus
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Question_Answer_FK1]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Answer] DROP CONSTRAINT Question_Answer_FK1
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_PersonProduct_SecurityLevel]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_SecurityLevel
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_PersonService_SecurityLevel]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonService] DROP CONSTRAINT FK_PersonService_SecurityLevel
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_GroupService_SecurityLevel]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[ProfileService] DROP CONSTRAINT FK_GroupService_SecurityLevel
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Service_ServiceStatus]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Service] DROP CONSTRAINT FK_Service_ServiceStatus
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_PersonGroup_Group]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonGroup] DROP CONSTRAINT FK_PersonGroup_Group
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_GroupService_Group]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[ProfileService] DROP CONSTRAINT FK_GroupService_Group
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Person_ActivityLog]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[ActivityLog] DROP CONSTRAINT FK_Person_ActivityLog
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Person_Answer_FK1]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Answer] DROP CONSTRAINT Person_Answer_FK1
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_PersonGroup_Person]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonGroup] DROP CONSTRAINT FK_PersonGroup_Person
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_PersonProduct_Person]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_Person
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_PersonService_Person]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonService] DROP CONSTRAINT FK_PersonService_Person
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Product_Notification]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Notification] DROP CONSTRAINT FK_Product_Notification
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_PersonProduct_Product]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_Product
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_ProductNotification_Product]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[ProductNotification] DROP CONSTRAINT FK_ProductNotification_Product
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Product_Service_FK1]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[Service] DROP CONSTRAINT Product_Service_FK1
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Service_ActivityLog_FK1]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[ActivityLog] DROP CONSTRAINT Service_ActivityLog_FK1
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Service_PersonService]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[PersonService] DROP CONSTRAINT FK_Service_PersonService
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[FK_Service_GroupService]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [passport].[ProfileService] DROP CONSTRAINT FK_Service_GroupService
	GO

/*	-----------------------------------------------------------------------
	Check AND DROP Tables
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ActivityLog]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[ActivityLog]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[PersonService]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[PersonService]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ProfileService]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[ProfileService]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Answer]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Answer]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Notification]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Notification]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[PersonGroup]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[PersonGroup]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[PersonProduct]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[PersonProduct]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ProductNotification]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[ProductNotification]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Service]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Service]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Groups]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Groups]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Person]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Person]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Product]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Product]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Activity]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Activity]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Config]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Config]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[GroupCount]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[GroupCount]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[GroupStatus]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[GroupStatus]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[PersonStatus]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[PersonStatus]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ProductStatus]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[ProductStatus]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Question]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Question]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[SecurityLevel]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[SecurityLevel]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ServiceStatus]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[ServiceStatus]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[Recruit]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[Recruit]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[RecruitType]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [passport].[RecruitType]
	GO

/*	-----------------------------------------------------------------------
	Create Tables
	-----------------------------------------------------------------------	*/
	CREATE TABLE [passport].[Activity] (
		[ActivityID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Config] (
		[Description] [varchar] (100) NOT NULL ,
		[RetValue] [varchar] (50) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[GroupCount] (
		[Count] [int] NULL ,
		[Description] [varchar] (50) NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[GroupStatus] (
		[GroupStatusID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[PersonStatus] (
		[PersonStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[ProductStatus] (
		[ProductStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) NOT NULL ,
		[DisplayMessage] [varchar] (300) NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Question] (
		[QuestionID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[SecurityLevel] (
		[SecurityLevelID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[ServiceStatus] (
		[ServiceStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) NOT NULL ,
		[DisplayMessage] [varchar] (300) NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Groups] (
		[GroupID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) NOT NULL ,
		[GroupStatusID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Person] (
		[PersonID] [int] IDENTITY (1, 1) NOT NULL ,
		[UserName] [varchar] (50) NOT NULL ,
		[Password] [varchar] (50) NOT NULL ,
		[FirstName] [varchar] (50) NULL ,
		[Surname] [varchar] (50) NULL ,
		[EMail] [varchar] (50) NULL ,
		[TelNo] [varchar] (35) NULL ,
		[CellPhone] [varchar] (20) NULL ,
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

	CREATE TABLE [passport].[Product] (
		[ProductID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (100) NOT NULL ,
		[ProductStatusID] [tinyint] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Answer] (
		[QuestionID] [int] NOT NULL ,
		[PersonID] [int] NOT NULL ,
		[Answer] [varchar] (100) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Notification] (
		[PersonID] [int] NOT NULL ,
		[ProductID] [int] NOT NULL ,
		[DateInserted] [datetime] NOT NULL ,
		[DateSent] [datetime] NULL ,
		[Code] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[PersonGroup] (
		[PersonID] [int] NOT NULL ,
		[GroupID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[PersonProduct] (
		[PersonID] [int] NOT NULL ,
		[ProductID] [int] NOT NULL ,
		[SecurityLevelID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[ProductNotification] (
		[ProductID] [int] NOT NULL ,
		[URL] [varchar] (200) NOT NULL ,
		[WSDLURL] [varchar] (200) NULL ,
		[Name] [varchar] (100) NULL ,
		[Namespace] [varchar] (150) NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Service] (
		[ServiceID] [int] IDENTITY (1, 1) NOT NULL ,
		[ProductID] [int] NOT NULL ,
		[ServiceStatusID] [tinyint] NOT NULL ,
		[Description] [varchar] (100) NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[ActivityLog] (
		[ActivityLogID] [int] IDENTITY (1, 1) NOT NULL ,
		[ActivityID] [int] NOT NULL ,
		[ServiceID] [int] NULL ,
		[Token] [uniqueidentifier] NOT NULL ,
		[PersonID] [int] NOT NULL ,
		[ActivityDate] [datetime] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[PersonService] (
		[PersonID] [int] NOT NULL ,
		[ServiceID] [int] NOT NULL ,
		[SecurityLevelID] [int] NOT NULL ,
		[ServiceIdentifier] [varchar] (50) NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[ProfileService] (
		[GroupID] [int] NOT NULL ,
		[ServiceID] [int] NOT NULL ,
		[SecurityLevelID] [int] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[Recruit] (
		[ID] [int] IDENTITY (1, 1) NOT NULL ,
		[Token] [uniqueidentifier] NOT NULL ,
		[FirstName] [varchar] (50) NOT NULL ,
		[Surname] [varchar] (50) NOT NULL ,
		[EMail] [varchar] (50) NOT NULL ,
		[TelNo] [varchar] (35) NULL ,
		[CellPhone] [varchar] (20) NULL ,
		[TypeID] [int] NOT NULL ,
		[PersonID] [int] NULL ,
		[SignupDate] [datetime] NOT NULL 
	) ON [PRIMARY]
	GO

	CREATE TABLE [passport].[RecruitType] (
		[ID] [int] IDENTITY (1, 1) NOT NULL ,
		[Description] [varchar] (50) NOT NULL 
	) ON [PRIMARY]
	GO

/*	-----------------------------------------------------------------------
	Create Indexes AND Constraints
	-----------------------------------------------------------------------	*/

	ALTER TABLE [passport].[Activity] WITH NOCHECK ADD 
		CONSTRAINT [Activity_PK] PRIMARY KEY  CLUSTERED 
		(
			[ActivityID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Config] WITH NOCHECK ADD 
		CONSTRAINT [Config_PK] PRIMARY KEY  CLUSTERED 
		(
			[Description]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[GroupStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_GroupStatus] PRIMARY KEY  CLUSTERED 
		(
			[GroupStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[PersonStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonStatus] PRIMARY KEY  CLUSTERED 
		(
			[PersonStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[ProductStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_ProductStatus] PRIMARY KEY  CLUSTERED 
		(
			[ProductStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Question] WITH NOCHECK ADD 
		CONSTRAINT [Question_PK] PRIMARY KEY  CLUSTERED 
		(
			[QuestionID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[SecurityLevel] WITH NOCHECK ADD 
		CONSTRAINT [PK_SecurityLevel] PRIMARY KEY  CLUSTERED 
		(
			[SecurityLevelID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[ServiceStatus] WITH NOCHECK ADD 
		CONSTRAINT [PK_ServiceStatus] PRIMARY KEY  CLUSTERED 
		(
			[ServiceStatusID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Groups] WITH NOCHECK ADD 
		CONSTRAINT [PK_Group] PRIMARY KEY  CLUSTERED 
		(
			[GroupID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Person] WITH NOCHECK ADD 
		CONSTRAINT [PK_Person] PRIMARY KEY  CLUSTERED 
		(
			[PersonID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Product] WITH NOCHECK ADD 
		CONSTRAINT [PK_Product] PRIMARY KEY  CLUSTERED 
		(
			[ProductID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Answer] WITH NOCHECK ADD 
		CONSTRAINT [PK_Answer] PRIMARY KEY  CLUSTERED 
		(
			[PersonID],
			[QuestionID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[PersonGroup] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonGroup] PRIMARY KEY  CLUSTERED 
		(
			[PersonID],
			[GroupID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[PersonProduct] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonProduct] PRIMARY KEY  CLUSTERED 
		(
			[ProductID],
			[PersonID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[ProductNotification] WITH NOCHECK ADD 
		CONSTRAINT [PK_ProductNotification] PRIMARY KEY  CLUSTERED 
		(
			[ProductID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Service] WITH NOCHECK ADD 
		CONSTRAINT [PK_Service] PRIMARY KEY  CLUSTERED 
		(
			[ServiceID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[ActivityLog] WITH NOCHECK ADD 
		CONSTRAINT [PK_ActivityLog] PRIMARY KEY  CLUSTERED 
		(
			[ActivityLogID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[PersonService] WITH NOCHECK ADD 
		CONSTRAINT [PK_PersonService] PRIMARY KEY  CLUSTERED 
		(
			[PersonID],
			[ServiceID],
			[SecurityLevelID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[ProfileService] WITH NOCHECK ADD 
		CONSTRAINT [PK_GroupService] PRIMARY KEY  CLUSTERED 
		(
			[GroupID],
			[ServiceID],
			[SecurityLevelID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	ALTER TABLE [passport].[Notification] WITH NOCHECK ADD 
		CONSTRAINT [DF__Notificat__DateI__114A936A] DEFAULT (getdate()) FOR [DateInserted]
	GO

	 CREATE  UNIQUE  INDEX [UDX_Group] ON [passport].[Groups]([Description]) WITH  FILLFACTOR = 90 ON [PRIMARY]
	GO

	 CREATE  INDEX [idx_Token] ON [passport].[Person]([Token]) WITH  FILLFACTOR = 90 ON [PRIMARY]
	GO

	ALTER TABLE [passport].[Groups] ADD 
		CONSTRAINT [FK_GroupStatus_Groups] FOREIGN KEY 
		(
			[GroupStatusID]
		) REFERENCES [passport].[GroupStatus] (
			[GroupStatusID]
		)
	GO

	ALTER TABLE [passport].[Person] ADD 
		CONSTRAINT [FK_Person_PersonStatus] FOREIGN KEY 
		(
			[PersonStatusID]
		) REFERENCES [passport].[PersonStatus] (
			[PersonStatusID]
		)
	GO

	ALTER TABLE [passport].[Product] ADD 
		CONSTRAINT [FK_Product_ProductStatus] FOREIGN KEY 
		(
			[ProductStatusID]
		) REFERENCES [passport].[ProductStatus] (
			[ProductStatusID]
		)
	GO

	ALTER TABLE [passport].[Answer] ADD 
		CONSTRAINT [Person_Answer_FK1] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [passport].[Person] (
			[PersonID]
		),
		CONSTRAINT [Question_Answer_FK1] FOREIGN KEY 
		(
			[QuestionID]
		) REFERENCES [passport].[Question] (
			[QuestionID]
		)
	GO

	ALTER TABLE [passport].[Notification] ADD 
		CONSTRAINT [FK_Product_Notification] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [passport].[Product] (
			[ProductID]
		)
	GO

	ALTER TABLE [passport].[PersonGroup] ADD 
		CONSTRAINT [FK_PersonGroup_Group] FOREIGN KEY 
		(
			[GroupID]
		) REFERENCES [passport].[Groups] (
			[GroupID]
		),
		CONSTRAINT [FK_PersonGroup_Person] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [passport].[Person] (
			[PersonID]
		)
	GO

	ALTER TABLE [passport].[PersonProduct] ADD 
		CONSTRAINT [FK_PersonProduct_Person] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [passport].[Person] (
			[PersonID]
		),
		CONSTRAINT [FK_PersonProduct_Product] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [passport].[Product] (
			[ProductID]
		),
		CONSTRAINT [FK_PersonProduct_SecurityLevel] FOREIGN KEY 
		(
			[SecurityLevelID]
		) REFERENCES [passport].[SecurityLevel] (
			[SecurityLevelID]
		)
	GO

	ALTER TABLE [passport].[ProductNotification] ADD 
		CONSTRAINT [FK_ProductNotification_Product] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [passport].[Product] (
			[ProductID]
		) ON DELETE CASCADE  ON UPDATE CASCADE 
	GO

	ALTER TABLE [passport].[Service] ADD 
		CONSTRAINT [FK_Service_ServiceStatus] FOREIGN KEY 
		(
			[ServiceStatusID]
		) REFERENCES [passport].[ServiceStatus] (
			[ServiceStatusID]
		),
		CONSTRAINT [Product_Service_FK1] FOREIGN KEY 
		(
			[ProductID]
		) REFERENCES [passport].[Product] (
			[ProductID]
		)
	GO

	ALTER TABLE [passport].[ActivityLog] ADD 
		CONSTRAINT [FK_Activity_ActivityLog] FOREIGN KEY 
		(
			[ActivityID]
		) REFERENCES [passport].[Activity] (
			[ActivityID]
		),
		CONSTRAINT [FK_Person_ActivityLog] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [passport].[Person] (
			[PersonID]
		),
		CONSTRAINT [Service_ActivityLog_FK1] FOREIGN KEY 
		(
			[ServiceID]
		) REFERENCES [passport].[Service] (
			[ServiceID]
		)
	GO

	ALTER TABLE [passport].[PersonService] ADD 
		CONSTRAINT [FK_PersonService_Person] FOREIGN KEY 
		(
			[PersonID]
		) REFERENCES [passport].[Person] (
			[PersonID]
		),
		CONSTRAINT [FK_PersonService_SecurityLevel] FOREIGN KEY 
		(
			[SecurityLevelID]
		) REFERENCES [passport].[SecurityLevel] (
			[SecurityLevelID]
		),
		CONSTRAINT [FK_Service_PersonService] FOREIGN KEY 
		(
			[ServiceID]
		) REFERENCES [passport].[Service] (
			[ServiceID]
		)
	GO

	ALTER TABLE [passport].[ProfileService] ADD 
		CONSTRAINT [FK_GroupService_Group] FOREIGN KEY 
		(
			[GroupID]
		) REFERENCES [passport].[Groups] (
			[GroupID]
		),
		CONSTRAINT [FK_GroupService_SecurityLevel] FOREIGN KEY 
		(
			[SecurityLevelID]
		) REFERENCES [passport].[SecurityLevel] (
			[SecurityLevelID]
		),
		CONSTRAINT [FK_Service_GroupService] FOREIGN KEY 
		(
			[ServiceID]
		) REFERENCES [passport].[Service] (
			[ServiceID]
		)
	GO

	ALTER TABLE [passport].[Recruit] WITH NOCHECK ADD 
		CONSTRAINT [PK_Recruit] PRIMARY KEY  CLUSTERED 
		(
			[ID]
		) WITH  FILLFACTOR = 90  ON [PRIMARY] 
	GO

	CREATE  INDEX [idx_Token] ON [passport].[Recruit]([Token]) WITH  FILLFACTOR = 90 ON [PRIMARY]
	GO

