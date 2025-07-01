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
	20111003:	Starting point.
	20111212:	Moved to passport schema
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

/*	-----------------------
	Move to Passport Schema
	-----------------------	*/

	ALTER SCHEMA passport TRANSFER dbo.GroupStatus
	GO
	ALTER SCHEMA passport TRANSFER dbo.PersonStatus
	GO
	ALTER SCHEMA passport TRANSFER dbo.ProductStatus
	GO
	ALTER SCHEMA passport TRANSFER dbo.Question
	GO
	ALTER SCHEMA passport TRANSFER dbo.SecurityLevel
	GO
	ALTER SCHEMA passport TRANSFER dbo.ServiceStatus
	GO
	ALTER SCHEMA passport TRANSFER dbo.Groups
	GO
	ALTER SCHEMA passport TRANSFER dbo.Person
	GO
	ALTER SCHEMA passport TRANSFER dbo.Product
	GO
	ALTER SCHEMA passport TRANSFER dbo.Answer
	GO
	ALTER SCHEMA passport TRANSFER dbo.Notification
	GO
	ALTER SCHEMA passport TRANSFER dbo.PersonGroup
	GO
	ALTER SCHEMA passport TRANSFER dbo.PersonProduct
	GO
	ALTER SCHEMA passport TRANSFER dbo.ProductNotification
	GO
	ALTER SCHEMA passport TRANSFER dbo.Service
	GO
	ALTER SCHEMA passport TRANSFER dbo.ActivityLog
	GO
	ALTER SCHEMA passport TRANSFER dbo.LinkLog
	GO
	ALTER SCHEMA passport TRANSFER dbo.PersonService
	GO
	ALTER SCHEMA passport TRANSFER dbo.ProfileService
	GO
	ALTER SCHEMA passport TRANSFER dbo.Recruit
	GO
	ALTER SCHEMA passport TRANSFER dbo.x_LinkLog
	GO
	ALTER SCHEMA passport TRANSFER dbo.RecruitType
	GO
	ALTER SCHEMA passport TRANSFER dbo.Collections
	GO
	ALTER SCHEMA passport TRANSFER dbo.PersonCollection
	GO
	ALTER SCHEMA passport TRANSFER dbo.Rights_Categories
	GO
	ALTER SCHEMA passport TRANSFER dbo.Rights_Levels
	GO
	ALTER SCHEMA passport TRANSFER dbo.Rights_Groups
	GO
	ALTER SCHEMA passport TRANSFER dbo.ServiceX_UserRights
	GO
	ALTER SCHEMA passport TRANSFER dbo.ServiceX_AdminUser
	GO
	ALTER SCHEMA passport TRANSFER dbo.x_User
	GO
	ALTER SCHEMA passport TRANSFER dbo.Activity
	GO
	ALTER SCHEMA passport TRANSFER dbo.Config
	GO
	ALTER SCHEMA passport TRANSFER dbo.GroupCount
	GO

/*	------------------
	Procedures
	------------------	*/
	ALTER SCHEMA passport TRANSFER dbo.AddAdminUser
	ALTER SCHEMA passport TRANSFER dbo.AddGroup
	ALTER SCHEMA passport TRANSFER dbo.AddGroupCategory
	ALTER SCHEMA passport TRANSFER dbo.AddGroupUser
	ALTER SCHEMA passport TRANSFER dbo.AddLinkLog
	ALTER SCHEMA passport TRANSFER dbo.AddUser
	ALTER SCHEMA passport TRANSFER dbo.DeleteAdminUser
	ALTER SCHEMA passport TRANSFER dbo.DeleteCollectionUsers
	ALTER SCHEMA passport TRANSFER dbo.DeleteGroup
	ALTER SCHEMA passport TRANSFER dbo.DeleteGroupCategories
	ALTER SCHEMA passport TRANSFER dbo.DeleteGroupUsers
	ALTER SCHEMA passport TRANSFER dbo.DeleteLinkLog
	ALTER SCHEMA passport TRANSFER dbo.DeleteUser
	ALTER SCHEMA passport TRANSFER dbo.EditGroup
	ALTER SCHEMA passport TRANSFER dbo.EditLinkLog
	ALTER SCHEMA passport TRANSFER dbo.GetAdminUser
	ALTER SCHEMA passport TRANSFER dbo.GetCollection
	ALTER SCHEMA passport TRANSFER dbo.GetGroup
	ALTER SCHEMA passport TRANSFER dbo.GetLinkLog
	ALTER SCHEMA passport TRANSFER dbo.GetUser
	ALTER SCHEMA passport TRANSFER dbo.GetUserName
	ALTER SCHEMA passport TRANSFER dbo.IndexLinkLogs
	ALTER SCHEMA passport TRANSFER dbo.ListAdminUsers
	ALTER SCHEMA passport TRANSFER dbo.ListCollections
	ALTER SCHEMA passport TRANSFER dbo.ListCollectionsUsersAll
	ALTER SCHEMA passport TRANSFER dbo.ListGroups
	ALTER SCHEMA passport TRANSFER dbo.ListGroupsUsersAll
	ALTER SCHEMA passport TRANSFER dbo.ListLinkLogs
	ALTER SCHEMA passport TRANSFER dbo.ListRightsCategoriesAll
	ALTER SCHEMA passport TRANSFER dbo.ListUserRights
	ALTER SCHEMA passport TRANSFER dbo.ListUsers
	ALTER SCHEMA passport TRANSFER dbo.Searcher
	ALTER SCHEMA passport TRANSFER dbo.SearchLinkLogs
	ALTER SCHEMA passport TRANSFER dbo.UpdateAdminUser
	ALTER SCHEMA passport TRANSFER dbo.UpdateSeriesCount
	ALTER SCHEMA passport TRANSFER dbo.UpdateUser

	ALTER SCHEMA passport TRANSFER dbo.x_ConfigAdd
	ALTER SCHEMA passport TRANSFER dbo.x_ConfigDelete
	ALTER SCHEMA passport TRANSFER dbo.x_ConfigGet
	ALTER SCHEMA passport TRANSFER dbo.x_ConfigList
	ALTER SCHEMA passport TRANSFER dbo.x_GroupAdd
	ALTER SCHEMA passport TRANSFER dbo.x_GroupDelete
	ALTER SCHEMA passport TRANSFER dbo.x_GroupDeleteStatus
	ALTER SCHEMA passport TRANSFER dbo.x_GroupGet
	ALTER SCHEMA passport TRANSFER dbo.x_GroupGets
	ALTER SCHEMA passport TRANSFER dbo.x_GroupList
	ALTER SCHEMA passport TRANSFER dbo.x_GroupProductAdd
	ALTER SCHEMA passport TRANSFER dbo.x_GroupProductDelete
	ALTER SCHEMA passport TRANSFER dbo.x_GroupRightsList
	ALTER SCHEMA passport TRANSFER dbo.x_GroupServiceAdd
	ALTER SCHEMA passport TRANSFER dbo.x_GroupServiceAddAlt
	ALTER SCHEMA passport TRANSFER dbo.x_GroupServiceDelete
	ALTER SCHEMA passport TRANSFER dbo.x_GroupServiceDeleteAlt
	ALTER SCHEMA passport TRANSFER dbo.x_GroupStatusAdd
	ALTER SCHEMA passport TRANSFER dbo.x_GroupStatusDelete
	ALTER SCHEMA passport TRANSFER dbo.x_GroupStatusGet
	ALTER SCHEMA passport TRANSFER dbo.x_GroupStatusList
	ALTER SCHEMA passport TRANSFER dbo.x_GroupUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_GroupUserList
	ALTER SCHEMA passport TRANSFER dbo.x_NotificationAdd
	ALTER SCHEMA passport TRANSFER dbo.x_NotificationGet
	ALTER SCHEMA passport TRANSFER dbo.x_NotificationUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_ProductAdd
	ALTER SCHEMA passport TRANSFER dbo.x_ProductDelete
	ALTER SCHEMA passport TRANSFER dbo.x_ProductGet
	ALTER SCHEMA passport TRANSFER dbo.x_ProductList
	ALTER SCHEMA passport TRANSFER dbo.x_ProductNotificationAdd
	ALTER SCHEMA passport TRANSFER dbo.x_ProductServiceList
	ALTER SCHEMA passport TRANSFER dbo.x_ProductStatusAdd
	ALTER SCHEMA passport TRANSFER dbo.x_ProductStatusDelete
	ALTER SCHEMA passport TRANSFER dbo.x_ProductStatusGet
	ALTER SCHEMA passport TRANSFER dbo.x_ProductStatusList
	ALTER SCHEMA passport TRANSFER dbo.x_ProductStatusUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_ProductUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_QuestionAdd
	ALTER SCHEMA passport TRANSFER dbo.x_QuestionDelete
	ALTER SCHEMA passport TRANSFER dbo.x_QuestionGet
	ALTER SCHEMA passport TRANSFER dbo.x_QuestionList
	ALTER SCHEMA passport TRANSFER dbo.x_RecruitAdd
	ALTER SCHEMA passport TRANSFER dbo.x_RecruitDelete
	ALTER SCHEMA passport TRANSFER dbo.x_RecruitGet
	ALTER SCHEMA passport TRANSFER dbo.x_RecruitUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_SecurityLevelAdd
	ALTER SCHEMA passport TRANSFER dbo.x_SecurityLevelDelete
	ALTER SCHEMA passport TRANSFER dbo.x_SecurityLevelGet
	ALTER SCHEMA passport TRANSFER dbo.x_SecurityLevelList
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceAdd
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceDelete
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceGet
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceList
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceStatusAdd
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceStatusDelete
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceStatusGet
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceStatusList
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceStatusUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_ServiceUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_UserAdd
	ALTER SCHEMA passport TRANSFER dbo.x_UserAnswerAdd
	ALTER SCHEMA passport TRANSFER dbo.x_UserDelete
	ALTER SCHEMA passport TRANSFER dbo.x_UserFind
	ALTER SCHEMA passport TRANSFER dbo.x_UserFindAdvanced
	ALTER SCHEMA passport TRANSFER dbo.x_UserGet
	ALTER SCHEMA passport TRANSFER dbo.x_UserGetAll
	ALTER SCHEMA passport TRANSFER dbo.x_UserGetID
	ALTER SCHEMA passport TRANSFER dbo.x_UserGetName
	ALTER SCHEMA passport TRANSFER dbo.x_UserGroupAdd
	ALTER SCHEMA passport TRANSFER dbo.x_UserGroupDelete
	ALTER SCHEMA passport TRANSFER dbo.x_UserList
	ALTER SCHEMA passport TRANSFER dbo.x_UserListPaged
	ALTER SCHEMA passport TRANSFER dbo.x_UserListPagedSorted
	ALTER SCHEMA passport TRANSFER dbo.x_UserLockClear
	ALTER SCHEMA passport TRANSFER dbo.x_UserLockSet
	ALTER SCHEMA passport TRANSFER dbo.x_UserLogin
	ALTER SCHEMA passport TRANSFER dbo.x_UserLoginGetName
	ALTER SCHEMA passport TRANSFER dbo.x_UserLogout
	ALTER SCHEMA passport TRANSFER dbo.x_UserPassword
	ALTER SCHEMA passport TRANSFER dbo.x_UserPasswordExpire
	ALTER SCHEMA passport TRANSFER dbo.x_UserPasswordUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_UserProductAdd
	ALTER SCHEMA passport TRANSFER dbo.x_UserProductDelete
	ALTER SCHEMA passport TRANSFER dbo.x_UserProfileAdd
	ALTER SCHEMA passport TRANSFER dbo.x_UserProfileDelete
	ALTER SCHEMA passport TRANSFER dbo.x_UserProfileList
	ALTER SCHEMA passport TRANSFER dbo.x_UserQuestionValidate
	ALTER SCHEMA passport TRANSFER dbo.x_UserSearch
	ALTER SCHEMA passport TRANSFER dbo.x_UserSearchAdvanced
	ALTER SCHEMA passport TRANSFER dbo.x_UserServiceAdd
	ALTER SCHEMA passport TRANSFER dbo.x_UserServiceDelete
	ALTER SCHEMA passport TRANSFER dbo.x_UserServiceList
	ALTER SCHEMA passport TRANSFER dbo.x_UserSetLoginFail
	ALTER SCHEMA passport TRANSFER dbo.x_UserSetLoginOK
	ALTER SCHEMA passport TRANSFER dbo.x_UserStatusAdd
	ALTER SCHEMA passport TRANSFER dbo.x_UserStatusDelete
	ALTER SCHEMA passport TRANSFER dbo.x_UserStatusGet
	ALTER SCHEMA passport TRANSFER dbo.x_UserStatusGetList
	ALTER SCHEMA passport TRANSFER dbo.x_UserStatusUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_UserUpdate
	ALTER SCHEMA passport TRANSFER dbo.x_UserValidate
	ALTER SCHEMA passport TRANSFER dbo.x_Validate


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*	-----------------------------------------------------------------------
	AccesssX: Check AND DROP PROCEDURE(s)
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListCollections]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListCollections]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[GetCollection]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[GetCollection]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListCollectionsUsersAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListCollectionsUsersAll]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[DeleteCollectionUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[DeleteCollectionUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[GetGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[GetGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListGroups]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListGroups]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[AddGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[AddGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[EditGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[EditGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[DeleteGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[DeleteGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[AddAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[AddAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListAdminUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListAdminUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[GetAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[GetAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[DeleteAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[DeleteAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[UpdateAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[UpdateAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListGroupsUsersAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListGroupsUsersAll]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[AddGroupUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[AddGroupUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[DeleteGroupUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[DeleteGroupUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[AddGroupCategory]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[AddGroupCategory]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[DeleteGroupCategories]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[DeleteGroupCategories]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListRightsCategoriesAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListRightsCategoriesAll]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListUserRights]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListUserRights]
	GO	

/*	-----------------------
	AccessX: Add Procedures
	-----------------------	*/

/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Lists the [passport].[Collections]
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListCollections] 
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM [passport].[Collections]
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets an Award Collection
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[GetCollection] 
		@CollectionID int 
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM [passport].[Collections]
				WHERE ID = @CollectionID
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets all of the admin users with status relating to the assigned show
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListCollectionsUsersAll] 
		@CollectionID int
	AS
	BEGIN
		SELECT  DISTINCT [PersonID]
				,[Username]
				,[FirstName]
				,[Surname]
				,[GroupDescription]
				,status = (SELECT
							CASE
								WHEN EXISTS(SELECT PersonID FROM [passport].[PersonCollection] WHERE (CollectionID = @CollectionID AND PersonID = grp.PersonID)) THEN
									1
								ELSE
									0
							END)
			FROM [passport].[ServiceX_AdminUser] AS grp 
			ORDER BY [FirstName]
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Deletes all users IN an awards show
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[DeleteCollectionUsers] 
		@CollectionID int
	AS
	BEGIN			
		DELETE FROM [passport].[PersonCollection]
			WHERE [CollectionID] = @CollectionID	
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets a Admin User Group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[GetGroup] 
		@GroupID int 
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM [passport].[Groups]
				WHERE GroupID = @GroupID
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Lists the Admin User [passport].[Groups] 
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListGroups] 
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM [passport].[Groups];
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Adds an admin group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[AddGroup] 
		@Name varchar(20) 
	AS
	BEGIN
	   INSERT INTO [passport].[Groups]
			   ([Description]
			   ,[GroupStatusID])
		 VALUES
			   (@Name
			   ,1)
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Edits an admin group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[EditGroup] 
		@GroupID int, 
		@Name varchar(20)
	AS
	BEGIN
		UPDATE [passport].[Groups]
			SET [Description] = @Name
				WHERE GroupID = @GroupID
		
		EXEC [passport].[GetGroup] @GroupID
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Deletes an admin group AND the rights of the group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[DeleteGroup] 
		@GroupID int
	AS
	BEGIN
		DELETE FROM [passport].[Rights_Groups]
			WHERE [GroupID] = @GroupID
		DELETE FROM [passport].[Groups]
			WHERE [GroupID] = @GroupID
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Update date:	20111003
		Description:	Add a new admin user (NB default group)
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[AddAdminUser] 
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20)
	AS
	BEGIN
		IF EXISTS (Select PersonID From [passport].[Person] Where Username = @UserName)
			UPDATE [passport].[Person]
				SET UserName = @UserName,
					Password = @Password,
					FirstName = @FirstName,
					Surname = @Surname,
					Email = @Email,
					TelNo = @TelNo,
					CellPhone = @CellNo,
					PersonStatusID = 1
			WHERE Username = @Username;
		ELSE
			INSERT INTO [passport].[Person] (UserName, Password, FirstName, Surname, Email, TelNo, CellPhone, PasswordExpiryDate, LoginFailures, PersonStatusID)
				VALUES(
					@UserName,
					@Password,
					@FirstName,
					@Surname,
					@Email,
					@TelNo,
					@CellNo,
					dateadd(m, 3, getdate()), 0, 1 --@PersonStatusID = active
				)
				
		INSERT INTO [passport].[PersonGroup] (PersonID, GroupID)
			select 
					Person.PersonID , 
					GroupID = 5	-- NB: Default group 'No Access'
				from Person
					where Person.Username = @UserName
			
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	ListAdminUsers - gets a list of administrative users
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListAdminUsers] 
		@GroupID int, 
		@StatusID int, 
		@StartPage int = null, 
		@Rows int = null, 
		@SortBy varchar(50) = '', 
		@SortType bit = null, 
		@IDList varchar(max) = null
	AS
	BEGIN
		
		DECLARE @MinRow int, @TotRows int, @MaxRow int
		Set @MinRow  = 0
		Set @MaxRow  = 0
		if not(@StartPage is null OR @Rows is null)
			Begin
				SET @MinRow  = (@StartPage - 1) * @Rows  + 1
				SET @MaxRow  = @MinRow + @Rows  - 1
			End
			
		SET NOCOUNT ON;
		
		-- Get result set identities
		SELECT IDENTITY(int,1,1) AS RowID, [ID]
			INTO #TMP_RANK_TBL
			  FROM [passport].[ServiceX_AdminUser] AS usr 
					WHERE (@IDList IS NOT NULL AND ID IN (select [value] from fn_Split(@IDList, ',')))
					 OR @IDList is null AND (
						(@GroupID = GroupID OR @GroupID = 0)
						AND (PersonStatusID = @StatusID OR @StatusID = 0)
					)
		ORDER BY 
			CASE @SortBy  WHEN '1' THEN  [ID] END,
			CASE @SortBy  WHEN '2' THEN  [PersonID] END,
			CASE @SortBy  WHEN '3' THEN  [PersonName] END,
			CASE @SortBy  WHEN '4' THEN  [Username] END,
			CASE @SortBy  WHEN '5' THEN  [Password] END,
			CASE @SortBy  WHEN '6' THEN  [FirstName] END,
			CASE @SortBy  WHEN '7' THEN  [Surname] END,
			CASE @SortBy  WHEN '8' THEN  [Email] END,
			CASE @SortBy  WHEN '9' THEN  [Cellphone] END,
			CASE @SortBy  WHEN '10' THEN  [GroupID] END,
			CASE @SortBy  WHEN '11' THEN  [GroupDescription] END,
			CASE @SortBy  WHEN '12' THEN  [PersonStatusID] END,
			CASE @SortBy  WHEN '13' THEN  [PersonStatusDesc] END,
			CASE @SortBy  WHEN '14' THEN  [AccLockedDate] END,	 
			 [ID]
		--
		SELECT @TotRows = count(*) FROM #TMP_RANK_TBL
		--
		SELECT  TotalRows = @TotRows, 
				TotalPages = @TotRows/coalesce(@Rows, 1),
				RowID, 
				usr.*
			FROM #TMP_RANK_TBL AS RNK 
			INNER JOIN [passport].[ServiceX_AdminUser] AS usr ON RNK.[ID] = usr.ID
		WHERE  (@SortType <> 1 AND RowID BETWEEN @MinRow AND @MaxRow) 
			OR (@SortType = 1 AND (@TotRows - RowID + 1) BETWEEN @MinRow AND @MaxRow) 
			OR (@MinRow = 0 AND @MaxRow = 0)
		ORDER BY 
			CASE  WHEN @SortType =  1 THEN RowID END DESC,
			CASE  WHEN @SortType <> 1 THEN RowID END,
			usr.ID
		
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets an admin user (originally x_UserGet1)
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[GetAdminUser] 
		@UserID int = 0
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM [passport].[ServiceX_AdminUser]
				WHERE (@UserID <> 0 AND [ID] = @UserID);
		SET NOCOUNT OFF;
	END
GO

/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Deletes user from admin groups 
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[DeleteAdminUser] 
		@UserID int
	AS
	BEGIN
		DELETE FROM [passport].[PersonGroup]
			WHERE [PersonID] = @UserID
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Updates an Admin user (originally x_UserUpdate)
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[UpdateAdminUser] 
		@UserID int,
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@PersonStatusID int
	AS
	BEGIN
		SET NOCOUNT ON;
		IF @Password = '' 
			UPDATE [passport].[Person]
				SET UserName = @UserName,
					FirstName = @FirstName,
					Surname = @Surname,
					Email = @Email,
					TelNo = @TelNo,
					CellPhone = @CellNo,
					PersonStatusID = @PersonStatusID
			WHERE PersonID = @UserID;
		ELSE
			UPDATE [passport].[Person]
				SET UserName = @UserName,
					Password = @Password,
					FirstName = @FirstName,
					Surname = @Surname,
					Email = @Email,
					TelNo = @TelNo,
					CellPhone = @CellNo,
					PersonStatusID = @PersonStatusID
			WHERE PersonID = @UserID;
			
		EXEC [passport].[GetUser] @UserID
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets all of the admin users with status
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListGroupsUsersAll] 
			@GroupID int
	AS
	BEGIN
		SELECT  DISTINCT [PersonID]
				,[Username]
				,[FirstName]
				,[Surname]
				,[GroupDescription]
				,status = (SELECT
							CASE
								WHEN (@GroupID = grp.GroupID) THEN
									1
								ELSE
									0
							END)
			FROM [passport].[ServiceX_AdminUser] AS grp 
			ORDER BY [FirstName]
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Adds user to an admin group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[AddGroupUser] 
		@GroupID int,
		@UserID int
	AS
	BEGIN
		IF EXISTS (Select PersonID From [passport].[PersonGroup] Where PersonID = @UserID)
			UPDATE [passport].[PersonGroup]
			SET [GroupID] = @GroupID
			WHERE PersonID = @UserID
		ELSE
			INSERT INTO [passport].[PersonGroup] (PersonID, GroupID)
				VALUES(
					@UserID,
					@GroupID
				)
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Deletes all users IN an admin group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[DeleteGroupUsers] 
		@GroupID int
	AS
	BEGIN
		UPDATE [passport].[PersonGroup]
			SET [GroupID] = 5	-- NB: Default group 'No Access'
			WHERE GroupID = @GroupID
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Adds category AND rights to an admin group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[AddGroupCategory] 
		@GroupID int,
		@CategoryID int,
		@RightID int
	AS
	BEGIN
		IF EXISTS (Select GroupID From [passport].[Rights_Groups] Where GroupID = @GroupID AND CategoryID = @CategoryID)
			UPDATE [passport].[Rights_Groups]
			SET [RightID] = @RightID
			WHERE GroupID = @GroupID AND CategoryID = @CategoryID
		ELSE
			INSERT INTO [passport].[Rights_Groups] (GroupID, CategoryID, RightID)
				VALUES(
					@GroupID,
					@CategoryID,
					@RightID
				)
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Deletes categories AND rights for a group
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[DeleteGroupCategories] 
		@GroupID int
	AS
	BEGIN
		DELETE FROM  [passport].[Rights_Groups]
			WHERE GroupID = @GroupID
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets all of the Rights Categories with Rights Status
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListRightsCategoriesAll] 
			@GroupID int
	AS
	BEGIN
		SELECT  rtgrp.GroupID,
				cat.CategoryID, 
				cat.Name AS CategoryDescription, 
				rtgrp.RightID AS status,
				cat.Extra AS extra
		FROM [passport].[Rights_Categories] AS cat
			LEFT OUTER JOIN [passport].[Rights_Groups] AS rtgrp ON cat.CategoryID = rtgrp.CategoryID AND rtgrp.GroupID = @GroupID
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets all of the Rights for a user
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListUserRights] 
			@UserID int
	AS
	BEGIN
		SELECT   [RightID]
				,[Name]
			FROM [passport].[ServiceX_UserRights] AS pgrp 
				WHERE pgrp.PersonID = @UserID
	END
GO



/*	-------------------------
	LinkLogX: Drop Procedures
	-------------------------	*/
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[passport].[GetLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [passport].[GetLinkLog]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[passport].[ListLinkLogs]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [passport].[ListLinkLogs]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[passport].[IndexLinkLogs]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [passport].[IndexLinkLogs]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[passport].[SearchLinkLogs]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [passport].[SearchLinkLogs]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[passport].[AddLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [passport].[AddLinkLog]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[passport].[EditLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [passport].[EditLinkLog]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[passport].[DeleteLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [passport].[DeleteLinkLog]
	GO

/*	-------------------------
	LinkLogX: Drop Views
	-------------------------	*/
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[passport].[x_LinkLog]'))
	DROP VIEW [passport].[x_LinkLog]
	GO

/*	------------------
	LinkLogX: Views
	------------------	*/

/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20111003
	Description:	[x_LinkLog]
	---------------------------------------------------------------------------------------	*/
	CREATE VIEW [passport].[x_LinkLog]
	AS
		SELECT LL.ID
			,LL.Link
			,LL.Token
			,LL.Date
			,LL.PersonID
			,PersonName = P.FirstName + ' ' + P.Surname COLLATE Latin1_General_CI_AS	-- NB Need 'cause Passport has different collation to default IN temp tables (ie Searcher)
			,P.UserName
			,P.Password
			,P.FirstName
			,P.Surname
			,P.EMail
			,P.TelNo
			,P.CellPhone
		FROM [passport].[LinkLog] AS LL
			INNER JOIN [passport].[Person] AS P ON P.[PersonID] = LL.PersonID
GO


/*	----------------------
	LinkLogX: Procedures
	----------------------	*/

/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20111003
	Description:	[GetLinkLog]
	---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[GetLinkLog]
		@LinkLogID int
	AS
	BEGIN
		SET NOCOUNT ON;

		SELECT *
			FROM [passport].[x_LinkLog]
				WHERE ID = @LinkLogID
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20111003
	Description:	[ListLinkLogs]
	---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListLinkLogs]
		@PersonID int,
		@SortBy varchar(10) = '',
		@SortType bit = null	-- not yet implemented
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT * FROM [passport].[x_LinkLog]
			WHERE @PersonID = 0	OR PersonID = @PersonID
			ORDER BY -- NB: Ordering same AS [IndexLinkLogs]
				CASE @SortBy  WHEN '2'	THEN  [Link] END,
				CASE @SortBy  WHEN '3'	THEN  [Date] END,
				CASE @SortBy  WHEN '4'	THEN  [PersonID] END,
				CASE @SortBy  WHEN '5'	THEN  [PersonName]  END,
				CASE @SortBy  WHEN '6'	THEN  [UserName]  END,
				CASE @SortBy  WHEN '7'	THEN  [FirstName]  END,
				CASE @SortBy  WHEN '8'	THEN  [Surname]  END,
				CASE @SortBy  WHEN '9'	THEN  [EMail]  END,
				CASE @SortBy  WHEN '10'	THEN  [TelNo]  END,
				CASE @SortBy  WHEN '11'	THEN  [CellPhone]  END,
				[ID]
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20111003
	Description:	[IndexLinkLogs]
	---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[IndexLinkLogs] 
		@PersonID int,
		@StartPage int = null, 
		@Rows int = null, 
		@SortBy varchar(10) = '', 
		@SortType bit = null, 
		@IDList varchar(max) = null
	AS
	BEGIN
		
		DECLARE @MinRow int, @TotRows int, @MaxRow int
		SET @MinRow  = 0
		SET @MaxRow  = 0
		IF NOT(@StartPage IS NULL OR @Rows IS NULL)
			BEGIN
				SET @MinRow  = (@StartPage - 1) * @Rows  + 1
				SET @MaxRow  = @MinRow + @Rows  - 1
			END
			
		SET NOCOUNT ON;
		
		-- Get result set identities
		SELECT IDENTITY(int,1,1) AS RowID, [ID]
			INTO #TMP_RANK_TBL
			  FROM [passport].[x_LinkLog]
					WHERE (@IDList IS NOT NULL AND ID IN (SELECT [value] FROM fn_Split(@IDList, ',')))
					 OR @IDList IS NULL AND (
							(@PersonID = 0	OR PersonID = @PersonID)
					)
		ORDER BY -- NB: Ordering same AS [ListLinkLogs]
			CASE @SortBy  WHEN '2'	THEN  [Link] END,
			CASE @SortBy  WHEN '3'	THEN  [Date] END,
			CASE @SortBy  WHEN '4'	THEN  [PersonID] END,
			CASE @SortBy  WHEN '5'	THEN  [PersonName]  END,
			CASE @SortBy  WHEN '6'	THEN  [UserName]  END,
			CASE @SortBy  WHEN '7'	THEN  [FirstName]  END,
			CASE @SortBy  WHEN '8'	THEN  [Surname]  END,
			CASE @SortBy  WHEN '9'	THEN  [EMail]  END,
			CASE @SortBy  WHEN '10'	THEN  [TelNo]  END,
			CASE @SortBy  WHEN '11'	THEN  [CellPhone]  END,
			[ID]
		--
		SELECT @TotRows = count(*) FROM #TMP_RANK_TBL
		--
		SELECT  TotalRows = @TotRows, 
				TotalPages = @TotRows/coalesce(@Rows, 1),
				RowID, 
				[passport].[x_LinkLog].*
			FROM #TMP_RANK_TBL AS RNK 
				INNER JOIN [passport].[x_LinkLog] ON RNK.[ID] = [x_LinkLog].ID
				WHERE  (@SortType <> 1 AND RowID BETWEEN @MinRow AND @MaxRow) 
					OR (@SortType = 1 AND (@TotRows - RowID + 1) BETWEEN @MinRow AND @MaxRow) 
					OR (@MinRow = 0 AND @MaxRow = 0)
				ORDER BY 
					CASE  WHEN @SortType =  1 THEN RowID END DESC,
					CASE  WHEN @SortType <> 1 THEN RowID END,
					[passport].[x_LinkLog].ID
		
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20100816
	Description:	[SearchLinkLogs]
	---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[SearchLinkLogs]
		@PersonIDSrchType int = 0,
		@PersonID varchar(50) = null,
		@NameSrchType int = 0,
		@Name varchar(255) = null,
		@LinkSrchType int = 0,
		@Link varchar(100) = null,
		--
		@DateStartSrchType int = 0,
		@DateStart varchar(50) = null, 
		@DateEndSrchType int = 0,
		@DateEnd varchar(50) = null, 
		--
		@StartPage int = null, 
		@Rows int = null, 
		@SortBy varchar(50) = '', 
		@SortType bit = null
	AS
	BEGIN
		CREATE TABLE #TmpMaster(TmpID int)
		CREATE TABLE #TmpTbl(TmpID int)
		CREATE TABLE #TmpTbl_0(TmpID int)
		CREATE TABLE #TmpTbl_1(TmpID int)
		CREATE TABLE #TmpTbl_2(TmpID int)
		CREATE TABLE #TmpTbl_3(TmpID int)
		CREATE TABLE #TmpTbl_4(TmpID int)
		--
		INSERT INTO #TmpTbl_0 EXEC [dbo].[Searcher] 'x_LinkLog', 'PersonID',  @PersonIDSrchType, @PersonID
		INSERT INTO #TmpTbl_1 EXEC [dbo].[Searcher] 'x_LinkLog', 'PersonName',  @NameSrchType, @Name
		INSERT INTO #TmpTbl_2 EXEC [dbo].[Searcher] 'x_LinkLog', 'Link',  @LinkSrchType, @Link
		INSERT INTO #TmpTbl_3 EXEC [dbo].[Searcher] 'x_LinkLog', 'Date',  @DateStartSrchType, @DateStart
		INSERT INTO #TmpTbl_4 EXEC [dbo].[Searcher] 'x_LinkLog', 'Date',  @DateEndSrchType, @DateEnd
		--
		Insert into #TmpTbl 
			SELECT TmpID FROM #TmpTbl_0 
			UNION SELECT TmpID FROM #TmpTbl_1
			UNION SELECT TmpID FROM #TmpTbl_2
			UNION SELECT TmpID FROM #TmpTbl_3
			UNION SELECT TmpID FROM #TmpTbl_4

		DELETE FROM #TmpTbl WHERE TmpID = 0
		
		INSERT INTO #TmpMaster 
			SELECT TmpID FROM #TmpTbl 
			WHERE	( TmpID IN (SELECT TmpID FROM #TmpTbl_0) OR @PersonIDSrchType = 0)
				AND	( TmpID IN (SELECT TmpID FROM #TmpTbl_1) OR @NameSrchType = 0)
				AND ( TmpID IN (SELECT TmpID FROM #TmpTbl_2) OR @LinkSrchType = 0)
				AND ( TmpID IN (SELECT TmpID FROM #TmpTbl_3) OR @DateStartSrchType = 0)
				AND ( TmpID IN (SELECT TmpID FROM #TmpTbl_4) OR @DateEndSrchType = 0)
		
		DECLARE @IDList varchar(max)
		SET @IDList = --SELECT
			 STUFF(
					(	SELECT DISTINCT ',' + cast(TmpID AS varchar(8)) FROM #TmpMaster 
						FOR XML PATH('')
					),
					1, 1, ''
				) 
		IF @IDList is null
			SET @IDList = ''
		PRINT '[SearchLinkLogs]' + @IDList


		DROP table #TmpTbl
		DROP table #TmpMaster
		DROP table #TmpTbl_0
		DROP table #TmpTbl_1
		DROP table #TmpTbl_2
		DROP table #TmpTbl_3
		DROP table #TmpTbl_4

		EXECUTE [passport].[IndexLinkLogs] 
			 0
			,@StartPage
			,@Rows
			,@SortBy
			,@SortType
			,@IDList
		
	END
GO
	
/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20111003
	Description:	[AddLinkLog]
	---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[AddLinkLog]
		@Link nvarchar(100),
		@Token uniqueidentifier,
		@PersonID int
	AS
	BEGIN
		INSERT INTO [passport].[LinkLog]
           ([Link]
           ,[Token]
           ,[PersonID]
           ,[Date])
		VALUES
           (@Link
           ,@Token
           ,@PersonID 
           ,GETDATE())
		EXEC [passport].[GetLinkLog] @@IDENTITY
	END
GO


/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20111003
	Description:	[EditLinkLog]
	---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[EditLinkLog]
		@LinkLogID int,
		@Link nvarchar(100),
		@Token uniqueidentifier,
		@PersonID int
	AS
	BEGIN
		UPDATE [passport].[LinkLog]
			SET	 [Link] = @Link
				,[Token] = @Token
				,[PersonID] = @PersonID
			WHERE ID = @LinkLogID
		EXEC [passport].[GetLinkLog] @LinkLogID
	END
GO


/*	---------------------------------------------------------------------------------------
	Author:			Alan Benington
	Create date:	20111003
	Description:	[DeleteLinkLog]
	---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[DeleteLinkLog]
		@LinkLogID int
	AS
	BEGIN
		DELETE FROM [passport].[LinkLog]
			WHERE ID = @LinkLogID
	END
GO



/*	-----------------------------------------------------------------------
	UserX: Check AND DROP PROCEDURE(s)
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[ListUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[ListUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[GetUserName]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[GetUserName]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[GetUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[GetUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[UpdateUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[UpdateUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[AddUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[AddUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[DeleteUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[DeleteUser]
	GO	


/*	------------------
	UserX: Procedures
	------------------	*/

/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Lists users
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[ListUsers] 
		@StatusID int, 
		@StartPage int = null, 
		@Rows int = null, 
		@SortBy varchar(50) = '', 
		@SortType bit = null, 
		@IDList varchar(max) = null
	AS
	BEGIN
		
		DECLARE @MinRow int, @TotRows int, @MaxRow int
		Set @MinRow  = 0
		Set @MaxRow  = 0
		if not(@StartPage is null OR @Rows is null)
			Begin
				SET @MinRow  = (@StartPage - 1) * @Rows  + 1
				SET @MaxRow  = @MinRow + @Rows  - 1
			End
			
		-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
		SET NOCOUNT ON;
		
		-- Get result set identities
		SELECT IDENTITY(int,1,1) AS RowID, [ID]
			INTO #TMP_RANK_TBL
				FROM [passport].[x_User] AS usr 
					WHERE (@IDList IS NOT NULL AND ID IN (select [value] from fn_Split(@IDList, ',')))
						OR @IDList is null  AND (PersonStatusID = @StatusID OR @StatusID = 0)
		ORDER BY 
			CASE @SortBy  WHEN '1' THEN  [ID] END,
			CASE @SortBy  WHEN '2' THEN  [PersonID] END,
			CASE @SortBy  WHEN '3' THEN  [PersonName] END,
			CASE @SortBy  WHEN '4' THEN  [Username] END,
			CASE @SortBy  WHEN '5' THEN  [Password] END,
			CASE @SortBy  WHEN '6' THEN  [FirstName] END,
			CASE @SortBy  WHEN '7' THEN  [Surname] END,
			CASE @SortBy  WHEN '8' THEN  [Email] END,
			CASE @SortBy  WHEN '9' THEN  [Cellphone] END,
			CASE @SortBy  WHEN '10' THEN  [PersonStatusID] END,
			CASE @SortBy  WHEN '11' THEN  [PersonStatusDesc] END,
			CASE @SortBy  WHEN '12' THEN  [AccLockedDate] END,	 
			 [ID]
		--
		SELECT @TotRows = count(*) FROM #TMP_RANK_TBL
		--
		SELECT  TotalRows = @TotRows, 
				TotalPages = @TotRows/coalesce(@Rows, 1),
				RowID, 
				usr.*
			FROM #TMP_RANK_TBL AS RNK 
			INNER JOIN [passport].[x_User] AS usr ON RNK.[ID] = usr.ID
		WHERE  (@SortType <> 1 AND RowID BETWEEN @MinRow AND @MaxRow) 
			OR (@SortType = 1 AND (@TotRows - RowID + 1) BETWEEN @MinRow AND @MaxRow) 
			OR (@MinRow = 0 AND @MaxRow = 0)
		ORDER BY 
			CASE  WHEN @SortType =  1 THEN RowID END DESC,
			CASE  WHEN @SortType <> 1 THEN RowID END,
			usr.ID
		
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	[GetUserName]
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[GetUserName] 
		@UserName varchar(50)
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM [passport].[x_User]
			WHERE ([UserName] = @UserName);
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Gets a user (originally x_UserGet1)
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[GetUser] 
		@UserID int = 0
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM [passport].[x_User]
				WHERE (@UserID <> 0 AND [ID] = @UserID);
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Updates a user (originally x_UserUpdate)
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[UpdateUser] 
		@UserID int,
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@PersonStatusID int
	AS
	BEGIN
		SET NOCOUNT ON;
		IF @Password = '' 
			UPDATE [passport].[Person]
				SET UserName = @UserName,
					FirstName = @FirstName,
					Surname = @Surname,
					Email = @Email,
					TelNo = @TelNo,
					CellPhone = @CellNo,
					PersonStatusID = @PersonStatusID
			WHERE PersonID = @UserID;
		ELSE
			UPDATE [passport].[Person]
				SET UserName = @UserName,
					Password = @Password,
					FirstName = @FirstName,
					Surname = @Surname,
					Email = @Email,
					TelNo = @TelNo,
					CellPhone = @CellNo,
					PersonStatusID = @PersonStatusID
			WHERE PersonID = @UserID;
			
		EXEC [passport].[GetUser] @UserID
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Adds a user (originally x_UserAdd)
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[AddUser] 
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20)
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @UserID int
		INSERT INTO [passport].[Person] (UserName, Password, FirstName, Surname, Email, TelNo, CellPhone, PasswordExpiryDate, LoginFailures, PersonStatusID)
			VALUES(
				@UserName,
				@Password,
				@FirstName,
				@Surname,
				@Email,
				@TelNo,
				@CellNo,
				dateadd(m, 3, getdate()), 0, 1 --@PersonStatusID = active
			)
			SELECT @UserID = PersonID FROM [passport].[Person] WHERE UserName = @UserName
		EXEC [passport].[GetUser] @UserID
		SET NOCOUNT OFF;
	END
GO


/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Deletes a user (originally x_UserDelete)
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[DeleteUser] (
		@UserID int,
		@UserName varchar(50)
	)
	AS
	BEGIN
		If @UserID = 0 Or @UserID IS NULL
			BEGIN
				SELECT @UserID = PersonID FROM [passport].[Person] WHERE UserName = @UserName
			END
		-- DELETE the PersonService record!
		DELETE [passport].[PersonService] WHERE PersonID = @UserID
		-- DELETE the PersonGroup record!
		DELETE [passport].[PersonGroup] WHERE PersonID = @UserID
		-- DELETE the PersonProduct record!
		DELETE [passport].[PersonProduct] WHERE PersonID = @UserID
		-- DELETE the ActivityLog record!
		DELETE [passport].[ActivityLog] WHERE PersonID = @UserID
		-- DELETE the Answer record!
		DELETE [passport].[Answer] WHERE PersonID = @UserID
		-- DELETE the [passport].[Person] record!
		DELETE [passport].[Person] WHERE PersonID = @UserID
		EXEC x_NotificationAdd @UserID, 104
	End
GO

	
/*	------------------
	Data
	------------------	*/

