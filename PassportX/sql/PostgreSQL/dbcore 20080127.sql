/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-12-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20080127
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
	20071227:	Starting point for PostgreSQL version from MsSQL version
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Check and drop Indexes and Constraints
	-----------------------------------------------------------------------
	DROP INDEX UDX_Group;
	
	DROP INDEX idx_Token;
	
	DROP INDEX idx_Token_Recruit;

	ALTER TABLE ActivityLog DROP CONSTRAINT FK_Activity_ActivityLog;

	ALTER TABLE Groups DROP CONSTRAINT FK_GroupStatus_Groups;

	ALTER TABLE Person DROP CONSTRAINT FK_Person_PersonStatus;

	ALTER TABLE Product DROP CONSTRAINT FK_Product_ProductStatus;

	ALTER TABLE Answer DROP CONSTRAINT Question_Answer_FK1;

	ALTER TABLE PersonProduct DROP CONSTRAINT FK_PersonProduct_SecurityLevel;

	ALTER TABLE PersonService DROP CONSTRAINT FK_PersonService_SecurityLevel;

	ALTER TABLE ProfileService DROP CONSTRAINT FK_GroupService_SecurityLevel;

	ALTER TABLE Service DROP CONSTRAINT FK_Service_ServiceStatus;

	ALTER TABLE PersonGroup DROP CONSTRAINT FK_PersonGroup_Group;

	ALTER TABLE ProfileService DROP CONSTRAINT FK_GroupService_Group;

	ALTER TABLE ActivityLog DROP CONSTRAINT FK_Person_ActivityLog;

	ALTER TABLE Answer DROP CONSTRAINT Person_Answer_FK1;

	ALTER TABLE PersonGroup DROP CONSTRAINT FK_PersonGroup_Person;

	ALTER TABLE PersonProduct DROP CONSTRAINT FK_PersonProduct_Person;

	ALTER TABLE PersonService DROP CONSTRAINT FK_PersonService_Person;

	ALTER TABLE Notification DROP CONSTRAINT FK_Product_Notification;

	ALTER TABLE PersonProduct DROP CONSTRAINT FK_PersonProduct_Product;

	ALTER TABLE ProductNotification DROP CONSTRAINT FK_ProductNotification_Product;

	ALTER TABLE Service DROP CONSTRAINT Product_Service_FK1;

	ALTER TABLE ActivityLog DROP CONSTRAINT Service_ActivityLog_FK1;

	ALTER TABLE PersonService DROP CONSTRAINT FK_Service_PersonService;

	ALTER TABLE ProfileService DROP CONSTRAINT FK_Service_GroupService;

*/

/*	-----------------------------------------------------------------------
	Check and drop Tables
	-----------------------------------------------------------------------	*/
		DROP TABLE IF EXISTS ActivityLog;

		DROP TABLE IF EXISTS PersonService;

		DROP TABLE IF EXISTS ProfileService;

		DROP TABLE IF EXISTS Answer;

		DROP TABLE IF EXISTS Notification;

		DROP TABLE IF EXISTS PersonGroup;

		DROP TABLE IF EXISTS PersonProduct;

		DROP TABLE IF EXISTS ProductNotification;

		DROP TABLE IF EXISTS Service;

		DROP TABLE IF EXISTS Groups;

		DROP TABLE IF EXISTS Person;

		DROP TABLE IF EXISTS Product;

		DROP TABLE IF EXISTS Activity;

		DROP TABLE IF EXISTS Config;

		DROP TABLE IF EXISTS GroupCount;

		DROP TABLE IF EXISTS GroupStatus;

		DROP TABLE IF EXISTS PersonStatus;

		DROP TABLE IF EXISTS ProductStatus;

		DROP TABLE IF EXISTS Question;

		DROP TABLE IF EXISTS SecurityLevel;

		DROP TABLE IF EXISTS ServiceStatus;

		DROP TABLE IF EXISTS Recruit;

		DROP TABLE IF EXISTS RecruitType;

/*	-----------------------------------------------------------------------
	Create Tables
	-----------------------------------------------------------------------	*/
	CREATE TABLE Activity (
		ActivityID SERIAL UNIQUE ,
		Description varchar (50) NOT NULL 
	);

	CREATE TABLE Config (
		Description varchar (100) NOT NULL ,
		RetValue varchar (50) NOT NULL 
	);

	CREATE TABLE GroupCount (
		Count int NULL ,
		Description varchar (50) NULL 
	);

	CREATE TABLE GroupStatus (
		GroupStatusID SERIAL UNIQUE ,
		Description varchar (100) NOT NULL 
	);

	CREATE TABLE PersonStatus (
		PersonStatusID SERIAL UNIQUE ,
		Description varchar (50) NOT NULL 
	);

	CREATE TABLE ProductStatus (
		ProductStatusID SERIAL UNIQUE ,
		Description varchar (50) NOT NULL ,
		DisplayMessage varchar (300) NULL 
	);

	CREATE TABLE Question (
		QuestionID SERIAL UNIQUE ,
		Description varchar (100) NOT NULL 
	);

	CREATE TABLE SecurityLevel (
		SecurityLevelID SERIAL UNIQUE ,
		Description varchar (50) NOT NULL 
	);

	CREATE TABLE ServiceStatus (
		ServiceStatusID SERIAL UNIQUE ,
		Description varchar (50) NOT NULL ,
		DisplayMessage varchar (300) NULL 
	);

	CREATE TABLE Groups (
		GroupID SERIAL UNIQUE ,
		Description varchar (100) NOT NULL ,
		GroupStatusID int NOT NULL 
	);

	CREATE TABLE Person (
		PersonID SERIAL UNIQUE ,
		UserName varchar (30) NOT NULL UNIQUE,
		Password varchar (50) NOT NULL ,
		FirstName varchar (50) NULL ,
		Surname varchar (50) NULL ,
		EMail varchar (50) NOT NULL UNIQUE ,
		TelNo varchar (35) NULL ,
		CellPhone varchar (20) NULL ,
		Token varchar (36) NULL ,
		TokenExpiryDate timestamp NULL ,
		PersonStatusID int NULL ,
		LoginFailures int NULL ,
		PasswordExpiryDate timestamp NOT NULL ,
		LastLoginDate timestamp NULL ,
		LoginFailureDate timestamp NULL ,
		AccLockedDate timestamp NULL 
	);

	CREATE TABLE Product (
		ProductID SERIAL UNIQUE ,
		Description varchar (100) NOT NULL ,
		ProductStatusID int NOT NULL 
	);

	CREATE TABLE Answer (
		QuestionID int NOT NULL ,
		PersonID int NOT NULL ,
		Answer varchar (100) NOT NULL 
	);

	CREATE TABLE Notification (
		PersonID int NOT NULL ,
		ProductID int NOT NULL ,
		DateInserted timestamp NOT NULL ,
		DateSent timestamp NULL ,
		Code int NOT NULL 
	);

	CREATE TABLE PersonGroup (
		PersonID int NOT NULL ,
		GroupID int NOT NULL 
	);

	CREATE TABLE PersonProduct (
		PersonID int NOT NULL ,
		ProductID int NOT NULL ,
		SecurityLevelID int NOT NULL 
	);

	CREATE TABLE ProductNotification (
		ProductID int NOT NULL ,
		URL varchar (200) NOT NULL ,
		WSDLURL varchar (200) NULL ,
		Name varchar (100) NULL ,
		Namespace varchar (150) NULL 
	);

	CREATE TABLE Service (
		ServiceID SERIAL UNIQUE ,
		ProductID int NOT NULL ,
		ServiceStatusID int NOT NULL ,
		Description varchar (100) NOT NULL 
	);

	CREATE TABLE ActivityLog (
		ActivityLogID SERIAL UNIQUE ,
		ActivityID int NOT NULL ,
		ServiceID int NULL ,
		Token varchar (36) NOT NULL ,
		PersonID int NOT NULL ,
		ActivityDate timestamp NOT NULL 
	);

	CREATE TABLE PersonService (
		PersonID int NOT NULL ,
		ServiceID int NOT NULL ,
		SecurityLevelID int NOT NULL ,
		ServiceIdentifier varchar (50) NULL 
	);

	CREATE TABLE ProfileService (
		GroupID int NOT NULL ,
		ServiceID int NOT NULL ,
		SecurityLevelID int NOT NULL 
	);

	CREATE TABLE Recruit (
		ID SERIAL UNIQUE ,
		Token varchar (36) NOT NULL ,
		FirstName varchar (50) NOT NULL ,
		Surname varchar (50) NOT NULL ,
		EMail varchar (50) NOT NULL ,
		TelNo varchar (35) NULL ,
		CellPhone varchar (20) NULL ,
		TypeID int NOT NULL ,
		PersonID int NULL ,
		SignupDate timestamp NOT NULL 
	);

	CREATE TABLE RecruitType (
		ID SERIAL UNIQUE ,
		Description varchar (50) NOT NULL 
	);

/*	-----------------------------------------------------------------------
	Create Indexes and Constraints
	-----------------------------------------------------------------------	*/

	ALTER TABLE Activity ADD CONSTRAINT Activity_PK PRIMARY KEY
		(
			ActivityID
		);

	ALTER TABLE Config ADD CONSTRAINT Config_PK PRIMARY KEY
		(
			Description
		);

	ALTER TABLE GroupStatus ADD CONSTRAINT PK_GroupStatus PRIMARY KEY
		(
			GroupStatusID
		);

	ALTER TABLE PersonStatus ADD CONSTRAINT PK_PersonStatus PRIMARY KEY
		(
			PersonStatusID
		);

	ALTER TABLE ProductStatus ADD CONSTRAINT PK_ProductStatus PRIMARY KEY
		(
			ProductStatusID
		);

	ALTER TABLE Question ADD CONSTRAINT Question_PK PRIMARY KEY
		(
			QuestionID
		);

	ALTER TABLE SecurityLevel ADD CONSTRAINT PK_SecurityLevel PRIMARY KEY
		(
			SecurityLevelID
		);

	ALTER TABLE ServiceStatus ADD CONSTRAINT PK_ServiceStatus PRIMARY KEY
		(
			ServiceStatusID
		);

	ALTER TABLE Groups ADD CONSTRAINT PK_Group PRIMARY KEY
		(
			GroupID
		);

	ALTER TABLE Person ADD CONSTRAINT PK_Person PRIMARY KEY
		(
			PersonID
		);

	ALTER TABLE Product ADD CONSTRAINT PK_Product PRIMARY KEY
		(
			ProductID
		);

	ALTER TABLE Answer ADD CONSTRAINT PK_Answer PRIMARY KEY
		(
			PersonID,
			QuestionID
		);

	ALTER TABLE PersonGroup ADD CONSTRAINT PK_PersonGroup PRIMARY KEY
		(
			PersonID,
			GroupID
		);

	ALTER TABLE PersonProduct ADD CONSTRAINT PK_PersonProduct PRIMARY KEY
		(
			ProductID,
			PersonID
		);

	ALTER TABLE ProductNotification ADD CONSTRAINT PK_ProductNotification PRIMARY KEY
		(
			ProductID
		);

	ALTER TABLE Service ADD CONSTRAINT PK_Service PRIMARY KEY
		(
			ServiceID
		);

	ALTER TABLE ActivityLog ADD CONSTRAINT PK_ActivityLog PRIMARY KEY
		(
			ActivityLogID
		);

	ALTER TABLE PersonService ADD CONSTRAINT PK_PersonService PRIMARY KEY
		(
			PersonID,
			ServiceID,
			SecurityLevelID
		);

	ALTER TABLE ProfileService ADD CONSTRAINT PK_GroupService PRIMARY KEY
		(
			GroupID,
			ServiceID,
			SecurityLevelID
		);
	
	-- ALTER TABLE Notification ADD CONSTRAINT DF__Notificat__DateI__114A936A DEFAULT (getdate()) FOR DateInserted;
	
	CREATE UNIQUE INDEX UDX_Group ON Groups (Description);
	
	CREATE INDEX idx_Token ON Person (Token);

	ALTER TABLE Groups ADD CONSTRAINT FK_GroupStatus_Groups FOREIGN KEY 
		(
			GroupStatusID
		) REFERENCES GroupStatus (
			GroupStatusID
		);

	ALTER TABLE Person ADD CONSTRAINT FK_Person_PersonStatus FOREIGN KEY 
		(
			PersonStatusID
		) REFERENCES PersonStatus (
			PersonStatusID
		);

	ALTER TABLE Product ADD CONSTRAINT FK_Product_ProductStatus FOREIGN KEY 
		(
			ProductStatusID
		) REFERENCES ProductStatus (
			ProductStatusID
		);

	ALTER TABLE Answer ADD CONSTRAINT Person_Answer_FK1 FOREIGN KEY 
		(
			PersonID
		) REFERENCES Person (
			PersonID
		),
		ADD CONSTRAINT Question_Answer_FK1 FOREIGN KEY 
		(
			QuestionID
		) REFERENCES Question (
			QuestionID
		);

	ALTER TABLE Notification ADD CONSTRAINT FK_Product_Notification FOREIGN KEY 
		(
			ProductID
		) REFERENCES Product (
			ProductID
		);

	ALTER TABLE PersonGroup ADD CONSTRAINT FK_PersonGroup_Group FOREIGN KEY 
		(
			GroupID
		) REFERENCES Groups (
			GroupID
		),
		ADD CONSTRAINT FK_PersonGroup_Person FOREIGN KEY 
		(
			PersonID
		) REFERENCES Person (
			PersonID
		);

	ALTER TABLE PersonProduct ADD CONSTRAINT FK_PersonProduct_Person FOREIGN KEY 
		(
			PersonID
		) REFERENCES Person (
			PersonID
		),
		ADD CONSTRAINT FK_PersonProduct_Product FOREIGN KEY 
		(
			ProductID
		) REFERENCES Product (
			ProductID
		),
		ADD CONSTRAINT FK_PersonProduct_SecurityLevel FOREIGN KEY 
		(
			SecurityLevelID
		) REFERENCES SecurityLevel (
			SecurityLevelID
		);

	ALTER TABLE ProductNotification ADD CONSTRAINT FK_ProductNotification_Product FOREIGN KEY 
		(
			ProductID
		) REFERENCES Product (
			ProductID
		);

	ALTER TABLE Service ADD CONSTRAINT FK_Service_ServiceStatus FOREIGN KEY 
		(
			ServiceStatusID
		) REFERENCES ServiceStatus (
			ServiceStatusID
		),
		ADD CONSTRAINT Product_Service_FK1 FOREIGN KEY 
		(
			ProductID
		) REFERENCES Product (
			ProductID
		);

	ALTER TABLE ActivityLog ADD CONSTRAINT FK_Activity_ActivityLog FOREIGN KEY 
		(
			ActivityID
		) REFERENCES Activity (
			ActivityID
		),
		ADD CONSTRAINT FK_Person_ActivityLog FOREIGN KEY 
		(
			PersonID
		) REFERENCES Person (
			PersonID
		),
		ADD CONSTRAINT Service_ActivityLog_FK1 FOREIGN KEY 
		(
			ServiceID
		) REFERENCES Service (
			ServiceID
		);

	ALTER TABLE PersonService ADD CONSTRAINT FK_PersonService_Person FOREIGN KEY 
		(
			PersonID
		) REFERENCES Person (
			PersonID
		),
		ADD CONSTRAINT FK_PersonService_SecurityLevel FOREIGN KEY 
		(
			SecurityLevelID
		) REFERENCES SecurityLevel (
			SecurityLevelID
		),
		ADD CONSTRAINT FK_Service_PersonService FOREIGN KEY 
		(
			ServiceID
		) REFERENCES Service (
			ServiceID
		);

	ALTER TABLE ProfileService ADD CONSTRAINT FK_GroupService_Group FOREIGN KEY 
		(
			GroupID
		) REFERENCES Groups (
			GroupID
		),
		ADD CONSTRAINT FK_GroupService_SecurityLevel FOREIGN KEY 
		(
			SecurityLevelID
		) REFERENCES SecurityLevel (
			SecurityLevelID
		),
		ADD CONSTRAINT FK_Service_GroupService FOREIGN KEY 
		(
			ServiceID
		) REFERENCES Service (
			ServiceID
		);

	ALTER TABLE Recruit ADD CONSTRAINT PK_Recruit PRIMARY KEY
		(
			ID
		);

	CREATE INDEX idx_Token_Recruit ON Recruit(Token);

/*	-----------------------------------------------------------------------
	Create Procedures
	-----------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Create Function(s)
	-----------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Add default data into tables
	-----------------------------------------------------------------------	*/
	
	insert into GroupStatus (Description) Select 'Active';
	insert into GroupStatus (Description) Select 'Inactive';

	insert into ServiceStatus (Description, DisplayMessage) Select 'Active', '';
	insert into ServiceStatus (Description, DisplayMessage) Select 'Inactive', 'This service is currently unavailable';
	insert into ServiceStatus (Description, DisplayMessage) Select 'Locked', 'This service is currently unavailable';

	insert into ProductStatus (Description, DisplayMessage) Select 'Active', '';
	insert into ProductStatus (Description, DisplayMessage) Select 'Inactive', 'This product is currently unavailable';
	insert into ProductStatus (Description, DisplayMessage) Select 'Locked', 'This product is currently unavailable';

	insert into PersonStatus (Description) Select 'Active';
	insert into PersonStatus (Description) Select 'Inactive';
	insert into PersonStatus (Description) Select 'Locked';
	insert into PersonStatus (Description) Select 'On-hold';
	insert into PersonStatus (Description) Select 'Legacy';

	insert into Config (Description, RetValue) Select 'LoginFailures', '3';
	insert into Config (Description, RetValue) Select 'PasswordExpiryDate', '90';
	insert into Config (Description, RetValue) Select 'SessionExpiryTime', '20'; 
	insert into Config (Description, RetValue) Select 'AccLockedDate', '24';

	insert into Person (username, password, firstname, surname, email, telno, cellphone, personstatusid, loginfailures, passwordexpirydate) select 'sa', 'password', 'System', 'Administrator', 'passportX@umlungu.com', '', '', 1, 0, '31 Dec 2100';
	insert into Product (Description, ProductStatusID) Select 'PassportX', 1;

	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockUserService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UpdatePassword';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SavePersonStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeletePersonStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroupService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroupProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteGroupService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteGroupProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockGroup';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveGroupStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveGroupStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetProductServiceList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockProduct';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProductStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteProductStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetServiceList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UndeleteService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LockService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UnlockService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveServiceStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetServiceStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetServiceStatusList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteServiceStatus';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveSecurityLevel';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetSecurityLevel';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetSecurityLevelList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteSecurityLevel';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveActivity';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveActivity';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetActivity';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetActivityList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'LogActivity';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetActivityLog';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveConfigValue';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetConfigValue';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetConfigValueList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteConfigValue';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveQuestion';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetQuestion';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetQuestionList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteQuestion';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SendPassword';
	-- Reserved starts at 70
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'Reserved';
	-- Gatekeep services start at 80
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RegisterUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProfile';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetProfile';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveProfile';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveProfileService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetProfileRightsList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteProfileService';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUserList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SearchUserList';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUsers';

	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUsersSort';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUserRights';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetUserProfiles';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'SaveUserProfile';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'DeleteUserProfile';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'AddUserProfile';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'RemoveUserProfile';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'UpdateUser';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'ImportUsers';
	insert into Service (productid, ServiceStatusID, Description) select 1, 1, 'GetGroups';

	-- Add the Authentication Server SecurityLevels
	Insert Into SecurityLevel (Description) Select 'administer';

	-- Add Administrator Service rights
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 1, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 2, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 3, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 4, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 5, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 6, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 7, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 8, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 9, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 10, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 11, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 12, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 13, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 14, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 15, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 16, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 17, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 18, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 19, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 20, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 21, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 22, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 23, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 24, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 25, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 26, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 27, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 28, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 29, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 30, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 31, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 32, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 33, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 34, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 35, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 36, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 37, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 38, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 39, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 40, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 41, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 42, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 43, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 44, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 45, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 46, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 47, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 48, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 49, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 50, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 51, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 52, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 53, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 54, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 55, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 56, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 57, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 58, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 59, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 60, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 61, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 62, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 63, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 64, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 65, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 66, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 67, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 68, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 69, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 70, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 71, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 72, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 73, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 74, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 75, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 76, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 77, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 78, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 79, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 80, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 81, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 82, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 83, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 84, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 85, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 86, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 87, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 88, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 89, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 90, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 91, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 92, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 93, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 94, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 95, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 96, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 97, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 98, 1;
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID) Select 1, 99, 1;

	insert into RecruitType (Description) Select 'Subscriber';
	insert into RecruitType (Description) Select 'Non-subscriber';
