/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2011-10-03	
	Status:		release	
	Version:	4.0.2
	Build:		20140217
	Target:		Microsoft SQL Server 2008
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20111003:	Starting point FROM EconoPassport.
	20111212:	Moved to passport schema
	20140217:	Updated x_UserValidate and x_UserValidateOnly from Tabula
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
USE [PassportX]
GO

/*	-----------------------------------------------------------------------
	Check AND DROP View(s)
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_User]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP view [passport].[x_User]
	GO	

	
/*	-----------------------------------------------------------------------
	Check AND DROP PROCEDURE(s)
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserGet]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserGetID]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserGetID]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserLogin]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserLogin]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserLogout]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserLogout]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserLoginOld]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserLoginOld]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserLoginAlt]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserLoginAlt]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserPasswordExpire]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserPasswordExpire]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserQuestionValidate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserQuestionValidate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserStatusDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserGroupDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserGroupDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserProductDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserProductDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserServiceDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserServiceDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserServiceList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserServiceList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserStatusGetList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserStatusGetList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserAnswerAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserAnswerAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserGroupAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserGroupAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserProductAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserProductAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserServiceAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserServiceAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserStatusUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserStatusUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserValidate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserValidate]
	GO
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserValidateOnly]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserValidateOnly]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserLockClear]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserLockClear]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserProfileDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserProfileDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserGetName]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserGetName]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserListPaged]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserListPaged]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserListPagedSorted]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserListPagedSorted]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserProfileList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserProfileList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserProfileAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserProfileAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserSearch]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserSearch]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserSearchAdvanced]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserSearchAdvanced]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserLockSet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserLockSet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserPasswordUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserPasswordUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_Validate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_Validate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserFind]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserFind]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserFindAdvanced]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserFindAdvanced]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserPassword]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserPassword]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserLoginGetName]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserLoginGetName]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserSetLoginFail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserSetLoginFail]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserSetLoginOK]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserSetLoginOK]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_UserGetAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_UserGetAll]
	GO

/*	-----------------------------------------------------------------------
	Create View(s)
	-----------------------------------------------------------------------	*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_User
		---------------------------------------------------------------------------------------	*/
	CREATE VIEW [passport].[x_User]
	AS
		SELECT PersonID, 
				PersonID AS ID, 
				PersonName = FirstName + ' ' + Surname, 
				UserName, 
				[Password], 
				P.FirstName, 
				P.Surname, 
				EMail, 
				P.TelNo, 
				CellPhone,
				P.Token, 
				P.PersonStatusID, 
				PS.Description AS PersonStatusDesc, 
				P.AccLockedDate
			FROM [passport].[Person] AS P
				LEFT OUTER JOIN [passport].[PersonStatus] AS PS ON P.PersonStatusID = PS.PersonStatusID;
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO	

/*	-----------------------------------------------------------------------
	Create PROCEDURE(s)
	-----------------------------------------------------------------------	*/
		
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserGet] (
		@UserID int,
		@UserName varchar(50),
		@UserToken varchar(50),
		@UserCellPhone varchar(20)
	)
	AS
	BEGIN
		SELECT PersonID
			,UserName
			,Password
			,FirstName
			,Surname
			,PersonName = FirstName + ' ' + Surname
			,Email
			,TelNo
			,CellPhone
			,Token
			,P.PersonStatusID
			,PersonStatusDesc = PS.Description
			,AccLockedDate
		FROM [passport].[Person] AS P
			INNER JOIN [passport].[PersonStatus] AS PS ON P.PersonStatusID = PS.PersonStatusID
		WHERE (@UserID != 0 AND PersonID = @UserID)
			OR (@UserName != '' AND UserName = @UserName)
			OR (@UserToken != '' AND Convert(Varchar(50), Token) = @UserToken)
			OR (@UserCellPhone != '' AND CellPhone = @UserCellPhone)
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserGetID
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserGetID] (
		@UserID int
	)
	AS
	BEGIN
		SET NOCOUNT ON;
		SELECT *
			FROM x_User
			WHERE (@UserID <> 0 AND "PersonID" = @UserID);
		SET NOCOUNT OFF;
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserLogin
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserLogin] (
		@UserName varchar(50),
		@Password varchar(50),
		@Userid int OUTPUT
	)
	AS
	BEGIN
		DECLARE @PersonID int, @Token UniqueIdentifier
		DECLARE @PWord varchar(50), @LFailures int
		DECLARE @TExpiryDate datetime, @TokenDate int
		DECLARE @PExpiryDate datetime, @FailureTimes int
		DECLARE @AccLockedTime int, @AccLockedDate datetime
		DECLARE @PersonAccLockedDate datetime, @Result varchar(50), @PersonStatus Varchar(50)
		DECLARE @ExpiryDate int, @PasswordExpiryDate datetime
			
		SELECT @Result = ''
		SELECT @PersonID = PersonID, @PWord = Password, @LFailures = LoginFailures, @PExpiryDate = PasswordExpiryDate, @PersonAccLockedDate = AccLockedDate, @PersonStatus = PS.Description
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus] AS PS ON P.PersonStatusID = PS.PersonStatusID
				WHERE UserName = @UserName
		SELECT @Userid = @PersonID
		IF DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
			BEGIN
				SELECT @Token = NewID()
				UPDATE [passport].[Person]
					SET Token = @Token
					WHERE PersonID = @PersonID        
				SELECT @Result = 'Account still locked'
			END
		ELSE IF @PersonStatus <> 'Active'
			BEGIN
				SELECT @Result = 'Account is ' + @PersonStatus
			END
		ELSE
			BEGIN
				IF DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 OR DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
					BEGIN
						UPDATE [passport].[Person]
							SET AccLockedDate = null, LoginFailures = 0
							WHERE PersonID = @PersonID
					END
				IF @Password = @PWord
					BEGIN
						IF CONVERT(varchar(11), @PExpiryDate, 103) = CONVERT(varchar(11), getdate(), 103)
							BEGIN
								SELECT @Result = 'Password has expired'
							END
						ELSE
							BEGIN
								SELECT @TokenDate = RetValue FROM [passport].[Config] WHERE Description = 'SessionExpiryTime'
								SELECT @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
								SELECT @Token = NewID()
								SELECT @ExpiryDate = RetValue FROM [passport].[Config] WHERE Description = 'PasswordExpiryDate'
								SELECT @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())

								UPDATE [passport].[Person]
									SET Token = @Token,
										TokenExpiryDate = @TExpiryDate,
										PasswordExpiryDate = @PasswordExpiryDate,
										LoginFailures = 0,
										LastLoginDate = getdate()
									WHERE PersonID = @PersonID        
							END  
					END 
				ELSE
					BEGIN
						SELECT @FailureTimes = RetValue FROM [passport].[Config] WHERE Description = 'LoginFailures'
						SELECT @AccLockedTime = RetValue FROM [passport].[Config] WHERE Description = 'AccLockedDate'
						IF @LFailures = @FailureTimes
							BEGIN
								SELECT @Result = 'Loginfailure limit reached'
							END
						ELSE
							BEGIN
								SELECT @LFailures = @LFailures + 1
								SELECT @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
								IF @LFailures = @FailureTimes
									BEGIN
										UPDATE [passport].[Person]
											SET LoginFailures = @LFailures,
												LoginFailureDate = getdate(),
												AccLockedDate = @AccLockedDate
										WHERE PersonID = @PersonID
										SELECT @Result = 'Incorrect Password'
									END
								ELSE
									BEGIN
										UPDATE [passport].[Person]
										SET LoginFailures = @LFailures,
											LoginFailureDate = getdate()
											WHERE PersonID = @PersonID
										SELECT @Result = 'Incorrect Password'
									END
							END 
					END
			END
		SELECT Token = @Token, Result = @Result
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserLogout
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserLogout] (
		@Token uniqueidentifier
	)
	AS
	BEGIN
		UPDATE [passport].[Person]
			SET Token = null, TokenExpiryDate = null
			WHERE Token = @Token
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserPasswordExpire
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserPasswordExpire] (
		@UserID int
	)
	AS
	BEGIN
		UPDATE [passport].[Person]
			SET PasswordExpiryDate = getdate()
				WHERE PersonID = @UserID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserQuestionValidate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserQuestionValidate] (
		@UserID int,
		@QuestionID int,
		@Answer varchar(100),
		@Result varchar(50) OUTPUT
	)
	AS
	BEGIN
		DECLARE @CorrectAns varchar(100)
			
		SELECT @CorrectAns = Answer
			FROM [passport].[Answer] 
				WHERE PersonID = @UserID
					AND QuestionID = @QuestionID
			
		IF @CorrectAns = @Answer
			BEGIN
				SELECT @Result = 'OK'
			END
		ELSE
			BEGIN
				SELECT @Result = 'Incorrect [passport].[Answer]'
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserStatusDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserStatusDelete] (
		@PersonStatusID int,
		@Result varchar(25) Output
	)
	AS
	BEGIN
		IF EXISTS (SELECT PersonStatusID FROM [passport].[Person] WHERE PersonStatusID = @PersonStatusID)
			BEGIN
				SELECT @Result = 'Cannot delete'
			END
		ELSE
			BEGIN
				DELETE [passport].[PersonStatus] 
					WHERE PersonStatusID = @PersonStatusID
				SELECT @Result = ''
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserDelete] (
		@UserID int,
		@UserName varchar(50)
	)
	AS
	BEGIN
		IF @UserID = 0 OR @UserID IS NULL
			BEGIN
				SELECT @UserID = PersonID FROM [passport].[Person] 
					WHERE UserName = @UserName
			END

		-- DELETE the [passport].[PersonService] record!
		DELETE [passport].[PersonService] 
			WHERE PersonID = @UserID
		-- DELETE the [passport].[PersonGroup] record!
		DELETE [passport].[PersonGroup] 
			WHERE PersonID = @UserID
		-- DELETE the [passport].[PersonProduct] record!
		DELETE [passport].[PersonProduct] 
			WHERE PersonID = @UserID
		-- DELETE the [passport].[ActivityLog] record!
		DELETE [passport].[ActivityLog] 
			WHERE PersonID = @UserID
		-- DELETE the [passport].[Answer] record!
		DELETE [passport].[Answer] 
			WHERE PersonID = @UserID
		-- DELETE the [passport].[Person] record!
		DELETE [passport].[Person] 
			WHERE PersonID = @UserID
		EXEC [passport].[x_NotificationAdd] @UserID, 104
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	Xxxx
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserGroupDelete] (
		@UserID int,
		@GroupID int
	)
	AS
	BEGIN
		DELETE [passport].[PersonGroup] 
			WHERE PersonID = @UserID AND GroupID = @GroupID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserProductDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserProductDelete] (
		@UserID int,
		@UserName varchar(50),
		@ProductID int,
		@ProductName varchar(100)
	)
	AS
	BEGIN
		IF @UserID = 0
			BEGIN
				SELECT @UserID = PersonID FROM [passport].[Person] 
					WHERE UserName = @UserName
			END
				
		IF @ProductID = 0
			BEGIN
				SELECT @ProductID = ProductID FROM [passport].[Product] 
					WHERE Description = @ProductName
			END

		DELETE [passport].[PersonProduct] WHERE PersonID = @UserID AND ProductID = @ProductID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserServiceDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserServiceDelete] (
		@UserID int,
		@UserName varchar(50),
		@ServiceID int,
		@ServiceName varchar(100)
	)
	AS
	BEGIN
		DECLARE @NewUserID int
		DECLARE @NewServiceID int
			
		IF @UserID = 0  
			BEGIN
				SELECT @NewUserID = PersonID FROM [passport].[Person] 
					WHERE UserName = @UserName
			END
		ELSE
			BEGIN
				SELECT @NewUserID = @UserID
			END

		IF @ServiceID = 0
			BEGIN
				SELECT @NewServiceID = ServiceID FROM [passport].[Service] 
					WHERE Description = @ServiceName
			END
		ELSE
			BEGIN
				SELECT @NewServiceID = @ServiceID
			END

		DELETE [passport].[PersonService] 
			WHERE PersonID = @NewUserID 
				AND ServiceID = @NewServiceID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserServiceList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserServiceList] (
		@PersonID int, 
		@ServiceID int
	)
	AS
	BEGIN
		IF @ServiceID = 0 --Return all Services WHERE PersonID linked to
			BEGIN
				SELECT S.ServiceID,
					ServiceIdentifier, 
					S.Description, 
					SS.Description AS Status, 
					SS.DisplayMessage, 
					SL.Description AS SecurityLevel
					FROM [passport].[PersonService] AS PS
						INNER JOIN [passport].[Service]			AS S	ON PS.ServiceID = S.ServiceID
						INNER JOIN [passport].[ServiceStatus]	AS SS	ON S.ServiceStatusID = SS.ServiceStatusID
						INNER JOIN [passport].[SecurityLevel]	AS SL	ON PS.SecurityLevelID = SL.SecurityLevelID
						WHERE PersonID = @PersonID
			END
		ELSE --Return only specific [passport].[Service] information
			BEGIN
				SELECT S.ServiceID,
					ServiceIdentifier, 
					S.Description, 
					SS.Description AS Status, 
					SS.DisplayMessage, 
					SL.Description AS SecurityLevel
					FROM [passport].[PersonService] AS PS
						INNER JOIN [passport].[Service]			AS S	ON PS.ServiceID = S.ServiceID
						INNER JOIN [passport].[ServiceStatus]	AS SS	ON S.ServiceStatusID = SS.ServiceStatusID
						INNER JOIN [passport].[SecurityLevel]	AS SL	ON PS.SecurityLevelID = SL.SecurityLevelID
						WHERE PS.PersonID = @PersonID
							AND PS.ServiceID = @ServiceID
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserStatusGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserStatusGet] (
		@PersonStatusID int
	)
	AS
	BEGIN
		SELECT Description, PersonStatusID
			FROM [passport].[PersonStatus]
				WHERE PersonStatusID = @PersonStatusID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserStatusGetList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserStatusGetList]
	AS
	BEGIN
		SELECT PersonStatusID, Description 
			FROM [passport].[PersonStatus]
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserAdd] (
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@UserID int OUTPUT
	)
	AS
	BEGIN
		DECLARE @PasswExpiryDate int, @PasswordExpiryDate datetime
		SELECT @PasswExpiryDate = RetValue FROM [passport].[Config] WHERE Description = 'PasswordExpiryDate'
		SELECT @PasswordExpiryDate = DATEADD(dd, @PasswExpiryDate, getdate())
		
		IF NOT EXISTS (SELECT UserName FROM [passport].[Person] WHERE UserName = @UserName)
			BEGIN 
				IF NOT EXISTS (SELECT CellPhone FROM [passport].[Person] WHERE CellPhone = @CellNo)
					BEGIN 
						INSERT INTO [passport].[Person] (UserName, Password, FirstName, Surname, Email, TelNo, CellPhone, PasswordExpiryDate, LoginFailures, PersonStatusID)
							SELECT @UserName, @Password, @FirstName, @Surname, @Email, @TelNo, @CellNo, @PasswordExpiryDate, 0, 1
							SELECT @UserID = @@IDENTITY
						EXEC [passport].[x_NotificationAdd] @UserID, 100
					END
				ELSE
					BEGIN
						SELECT @UserID = 0
					END     
			END
		ELSE
			BEGIN
				SELECT @UserID = 0      
			END  
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserStatusAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserStatusAdd] (
		@PersonStatusID int OUTPUT,
		@Description varchar(50)
	)
	AS
	BEGIN
		IF @PersonStatusID > 0 --UPDATE!
			BEGIN
				UPDATE [passport].[PersonStatus]
					SET Description = @Description
					WHERE PersonStatusID = @PersonStatusID
			END
		ELSE  --Insert!
			BEGIN
				INSERT INTO [passport].[PersonStatus] (Description) 
					SELECT @Description
				SELECT @PersonStatusID = @@IDENTITY
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserAnswerAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserAnswerAdd] (
		@UserID int,
		@QuestionID int,
		@Answer varchar(100)
	)
	AS
	BEGIN
		IF EXISTS (SELECT PersonID, QuestionID FROM [passport].[Answer] WHERE PersonID = @UserID AND QuestionID = @QuestionID)
			BEGIN
				UPDATE [passport].[Answer]
					SET Answer = @Answer
					WHERE PersonID = @UserID AND QuestionID = @QuestionID
			END
		ELSE
			BEGIN
				INSERT INTO [passport].[Answer] (QuestionID, PersonID, [passport].[Answer])
					SELECT @QuestionID, @UserID, @Answer
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserGroupAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserGroupAdd] (
		@UserID int,
		@GroupID int
	)
	AS
	BEGIN
		IF NOT EXISTS (SELECT PersonID, GroupID FROM [passport].[PersonGroup] WHERE PersonID = @UserID AND GroupID = @GroupID)
			BEGIN
				INSERT INTO [passport].[PersonGroup] (PersonID, GroupID) 
					SELECT @UserID, @GroupID
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserProductAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserProductAdd] (
		@UserID int,
		@UserName varchar(50),
		@ProductID int,
		@ProductName varchar(100),
		@SecurityLevelID int
	)
	AS
	BEGIN
		DECLARE @ServiceStatusID int

		IF @UserID = 0  
			BEGIN
				SELECT @UserID = PersonID FROM [passport].[Person]
					WHERE UserName = @UserName
			END
		IF @ProductID = 0
			BEGIN
				SELECT @ProductID = ProductID FROM [passport].[Product]
					WHERE Description = @ProductName
			END
		IF EXISTS (SELECT PersonID, ProductID FROM [passport].[PersonProduct] WHERE PersonID = @UserID AND ProductID = @ProductID)
			BEGIN
				UPDATE [passport].[PersonProduct]
					SET SecurityLevelID = @SecurityLevelID
						WHERE PersonID = @UserID AND ProductID = @ProductID
			END
		ELSE
			BEGIN
				INSERT INTO [passport].[PersonProduct] (PersonID, ProductID, SecurityLevelID)
					SELECT @UserID, @ProductID, @SecurityLevelID
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserServiceAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserServiceAdd] (
		@UserID int,
		@UserName varchar(50),
		@ServiceID int,
		@ServiceName varchar(100),
		@SecurityLevelID int,
		@ServiceIdentifier varchar(50)
	)
	AS
	BEGIN
		DECLARE @ServiceStatusID int
		IF @UserID = 0  
			BEGIN
				SELECT @UserID = PersonID FROM [passport].[Person]
					WHERE UserName = @UserName
			END
		IF @ServiceID = 0
			BEGIN
				SELECT @ServiceID = ServiceID FROM [passport].[Service]
					WHERE Description = @ServiceName
			END
		IF NOT EXISTS (SELECT * FROM [passport].[PersonService] WHERE PersonID = @UserID AND ServiceID = @ServiceID AND SecurityLevelID = @SecurityLevelID)
			BEGIN
				INSERT INTO [passport].[PersonService] (PersonID, ServiceID, SecurityLevelID, ServiceIdentifier)
					SELECT @UserID, @ServiceID, @SecurityLevelID, @ServiceIdentifier
			END
		UPDATE [passport].[PersonService]
			SET ServiceIdentifier = @ServiceIdentifier
			WHERE PersonID = @UserID AND ServiceID = @ServiceID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserUpdate] (
		@UserID int,
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@PersonStatusID int,
		@Result Varchar(50) OUTPUT
	)
	AS
	BEGIN
		IF EXISTS(SELECT * FROM [passport].[Person] WHERE PersonID = @UserID)
			BEGIN
				IF EXISTS(SELECT * FROM [passport].[Person] WHERE Username = @UserName AND PersonID <> @UserID)
					BEGIN
						SELECT @Result = 'Invalid Username supplied - Username already EXISTS.'
					END
				ELSE
					BEGIN
						IF @Password = ''
							BEGIN
								UPDATE [passport].[Person]
								SET UserName = @UserName,
									FirstName = @FirstName,
									Surname = @Surname,
									Email = @Email,
									TelNo = @TelNo,
									CellPhone = @CellNo,
									PersonStatusID = @PersonStatusID
								WHERE PersonID = @UserID
							END
						ELSE
							BEGIN
								UPDATE [passport].[Person]
								SET UserName = @UserName,
									Password = @Password,
									FirstName = @FirstName,
									Surname = @Surname,
									Email = @Email,
									TelNo = @TelNo,
									CellPhone = @CellNo,
									PersonStatusID = @PersonStatusID
								WHERE PersonID = @UserID
							END
						EXEC [passport].[x_NotificationAdd] @UserID, 101
					END
			END
		ELSE
			BEGIN
				SELECT @Result = 'Invalid User ID supplied - User does not exist.'
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserStatusUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserStatusUpdate] (
		@PersonID int,
		@UserName Varchar(50),
		@Status varchar(50)
	)
	AS
	BEGIN
		IF @PersonID = 0 OR @PersonID IS NULL
			BEGIN
				SELECT @PersonID = PersonID FROM [passport].[Person]
					WHERE UserName = @UserName
			END
		IF @PersonID = 0 OR @PersonID IS NULL
			BEGIN
				Return
			END
		DECLARE @PrevStatus Varchar(50)
		SELECT @PrevStatus = Description
			FROM [passport].[PersonStatus] AS PS
				INNER JOIN [passport].[Person] AS P ON P.PersonStatusID = PS.PersonStatusID
				WHERE PersonID = @PersonID
		UPDATE [passport].[Person]
			SET PersonStatusID = PS.PersonStatusID
			FROM [passport].[PersonStatus] AS PS
				WHERE PersonID = @PersonID AND Description = @Status
		IF @Status = 'Deleted'
			BEGIN
				EXEC [passport].[x_NotificationAdd] @PersonID, 102
			END
		IF @Status = 'Active' AND @PrevStatus = 'Deleted' -- Undelete User
			BEGIN
				EXEC [passport].[x_NotificationAdd] @PersonID, 103
			END
		IF @Status = 'Locked'
			BEGIN
				EXEC [passport].[x_NotificationAdd] @PersonID, 105
			END
		IF @Status = 'Active' AND @PrevStatus = 'Locked' -- Unlock User
			BEGIN
				EXEC [passport].[x_NotificationAdd] @PersonID, 106
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Update date:	20121114
		Description:	x_UserValidate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserValidate] (
		 @Token			uniqueidentifier
		,@Service		varchar(100)
		,@LoginDate		datetime
		,@TokenDate		datetime
		,@ExpireDate	datetime
		,@Userid		int OUTPUT
		,@Result		Varchar(100) OUTPUT
	)
	AS
	BEGIN
		DECLARE @PersonID int
		DECLARE @ServiceID int
		DECLARE @TokenExpiryDate DateTime

		SELECT @PersonID = PersonID, @TokenExpiryDate = TokenExpiryDate FROM [passport].[Person] WHERE Token = @Token
		SELECT @Userid = @PersonID
		SELECT @ServiceID = ServiceID FROM [passport].[Service] WHERE Description = @Service

		IF @TokenExpiryDate IS NULL OR DateDiff(n, @LoginDate, @TokenExpiryDate) < 0
			BEGIN
				SELECT @Result = 'User session has expired, or user has not yet logged in.'
				RETURN
			END
		ELSE
			BEGIN
				UPDATE [passport].[Person]
					SET TokenExpiryDate = @TokenDate,
						PasswordExpiryDate = @ExpireDate,
						LastLoginDate = @LoginDate
					WHERE PersonID = @PersonID
			END
				
		IF @Service = '' --Return all Services WHERE PersonID linked to
			BEGIN
				SELECT PS.PersonID,
					S.ServiceID,
					ServiceIdentifier, 
					S.Description, 
					SS.Description AS Status, 
					SS.DisplayMessage, 
					SL.Description AS SecurityLevel
					FROM [passport].[PersonService] AS PS
						INNER JOIN [passport].[Service]			AS S	ON PS.ServiceID = S.ServiceID
						INNER JOIN [passport].[ServiceStatus]	AS SS	ON S.ServiceStatusID = SS.ServiceStatusID
						INNER JOIN [passport].[SecurityLevel]	AS SL	ON PS.SecurityLevelID = SL.SecurityLevelID
						WHERE PersonID = @PersonID
			END
		ELSE --Return only specific [passport].[Service] information
			BEGIN
				SELECT PS.PersonID,
					S.ServiceID,
					ServiceIdentifier, 
					S.Description, 
					SS.Description AS Status, 
					SS.DisplayMessage, 
					SL.Description AS SecurityLevel
					FROM [passport].[PersonService] AS PS
						INNER JOIN [passport].[Service]			AS S	ON PS.ServiceID = S.ServiceID
						INNER JOIN [passport].[ServiceStatus]	AS SS	ON S.ServiceStatusID = SS.ServiceStatusID
						INNER JOIN [passport].[SecurityLevel]	AS SL	ON PS.SecurityLevelID = SL.SecurityLevelID
						WHERE PS.PersonID = @PersonID AND PS.ServiceID = @ServiceID
			END
	END
GO


	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Update date:	20121114
		Description:	x_UserValidateOnly
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserValidateOnly] (
		 @Token uniqueidentifier
		,@LoginDate		datetime
		,@TokenDate		datetime
		,@ExpireDate	datetime
	)
	AS
	BEGIN
		DECLARE @PersonID int
		DECLARE @ServiceID int
		DECLARE @TokenExpiryDate DateTime

		SELECT @PersonID = PersonID, @TokenExpiryDate = TokenExpiryDate FROM [passport].[Person] WHERE Token = @Token

		IF @TokenExpiryDate IS NULL Or DateDiff(n, @LoginDate, @TokenExpiryDate) < 0
			BEGIN
				RETURN
			END
		ELSE
			BEGIN
				UPDATE [passport].[Person]
					SET TokenExpiryDate = @TokenDate,
						PasswordExpiryDate = @ExpireDate,
						LastLoginDate = @LoginDate
					WHERE PersonID = @PersonID
				EXEC [passport].[x_UserGet] @PersonID, '', '', ''
			END
	END
GO


	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserLockClear
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserLockClear] (
		@UserID int,
		@Token varchar(65)
	)
	AS
	BEGIN
		DECLARE @ThisToken uniqueidentifier
		SET @ThisToken = CAST(@Token AS uniqueidentifier )

		IF EXISTS(SELECT * FROM [passport].[Person] WHERE PersonID = @UserID or (Token = @ThisToken AND @Token <> ''))
			BEGIN
				UPDATE [passport].[Person]
					SET LoginFailureDate = NULL,
						AccLockedDate = NULL,
						LoginFailures = 0
					WHERE PersonID = @UserID or (Token = @ThisToken AND @Token <> '')
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserProfileDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserProfileDelete] (
		@UserID int,
		@GroupID int
	)
	AS
	BEGIN
		BEGIN
			DELETE [passport].[PersonGroup]
			WHERE PersonID = @UserID
			AND GroupID = @GroupID
		END
		BEGIN
			DELETE [passport].[PersonService]
				WHERE PersonID = @UserID 
				AND ServiceID IN
					(SELECT ServiceID
						FROM [passport].[ProfileService] AS PF
							WHERE GroupID = @GroupID
								AND PF.SecurityLevelID = SecurityLevelID
					)
				AND ServiceID NOT IN
					(SELECT	PS.ServiceID
						FROM [passport].[PersonService] AS PS
							INNER JOIN [passport].[ProfileService] AS PF ON PS.ServiceID = PF.ServiceID
						AND PF.SecurityLevelID = PS.SecurityLevelID
							WHERE PS.PersonID = @UserID
							AND PF.GroupID IN
								(SELECT GroupID
									FROM [passport].[PersonGroup]
										WHERE PersonID = @UserID
										AND GroupID <> @GroupID
								)
					)
		END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserList] (@GroupID int)
	AS
	BEGIN
		IF @GroupID > 0 
			SELECT	P.PersonID, 
					UserName, 
					Password, 
					FirstName, 
					Surname, 
					Email, 
					TelNo, 
					CellPhone,
					Token, 
					P.PersonStatusID, 
					PersonStatusDesc = PS.Description,
					PG.GroupID
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
				INNER JOIN [passport].[PersonGroup]		AS PG	ON P.PersonID = PG.PersonID
				WHERE PG.GroupID = @GroupID
					AND P.PersonID > 5
		ELSE
			SELECT	PersonID, 
					UserName, 
					Password, 
					FirstName, 
					Surname, 
					Email, 
					TelNo, 
					CellPhone,
					Token, 
					P.PersonStatusID, 
					PersonStatusDesc = PS.Description
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus] AS PS ON P.PersonStatusID = PS.PersonStatusID
					AND P.PersonID > 5
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserGetName
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserGetName] (
		@UserID int
	)
	AS
	BEGIN
		SELECT UserName FROM [passport].[Person] 
			WHERE PersonID = @UserID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserListPaged
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserListPaged] (
		@GroupID int,
		@StartRow int,
		@NumberRows int
	)
	AS
	BEGIN
		DECLARE	@TotalRows int
		CREATE TABLE #UserTemp (
			[RowID] [int] IDENTITY (1, 1) NOT NULL ,
			[PersonID] [int],
			[UserName] [varchar] (50)  ,
			[FirstName] [varchar] (50)  ,
			[Surname] [varchar] (50)  ,
			[EMail] [varchar] (50)  ,
			[TelNo] [varchar] (35)  ,
			[CellPhone] [varchar] (20)  ,
			[Status] [varchar] (50)  ,
			[GroupID] [int],
			[GroupName] [varchar] (100)  ,
			CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
		)
			
		IF @GroupID > 0 
			INSERT INTO #UserTemp (
				[PersonID] , 
				[UserName] ,
				[FirstName] ,
				[Surname] ,
				[EMail] ,
				[TelNo] ,
				[CellPhone] ,
				[Status] ,
				GroupID ,
				GroupName)
			SELECT 
				P.PersonID , 
				[UserName] ,
				[FirstName] ,
				[Surname] ,
				[EMail] ,
				[TelNo] ,
				[CellPhone] ,
				Status = PS.Description ,
				@GroupID ,
				GroupName = G.Description
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
				INNER JOIN [passport].[PersonGroup]		AS PG	ON P.PersonID = PG.PersonID
				INNER JOIN [passport].[Groups]			AS G	ON PG.GroupID = G.GroupID
				WHERE PG.GroupID = @GroupID
					AND P.PersonID > 5
						ORDER BY P.PersonID
		ELSE
			INSERT INTO #UserTemp (
				[PersonID] , 
				[UserName] ,
				[FirstName] ,
				[Surname] ,
				[EMail] ,
				[TelNo] ,
				[CellPhone] ,
				[Status] ,
				GroupID )
			SELECT 
				P.PersonID , 
				[UserName] ,
				[FirstName] ,
				[Surname] ,
				[EMail] ,
				[TelNo] ,
				[CellPhone] ,
				Status = PS.Description,
				@GroupID
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
				WHERE P.PersonID > 5
					ORDER BY P.PersonID
			
		SET @TotalRows = @@ROWCOUNT
			
		SELECT * FROM #UserTemp 
			WHERE RowID between @StartRow AND @StartRow + @NumberRows - 1
			ORDER BY RowID
			
		DROP TABLE #UserTemp
			
		SELECT TotalRows = @TotalRows
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserListPagedSorted
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserListPagedSorted] (
		@GroupID int,
		@ColumnName varchar(30),
		@StartRow int,
		@NumberRows int
	)
	AS
	BEGIN
		
		DECLARE	@TotalRows int
		DECLARE @SQLSelect Varchar(1000)
		DECLARE @SQLOrder Varchar(200)
		DECLARE @SQLWhere Varchar(200)
			
		CREATE TABLE #UserTemp (
			[RowID] [int] IDENTITY (1, 1) NOT NULL ,
			[PersonID] [int],
			[UserName] [varchar] (50)  ,
			[FirstName] [varchar] (50)  ,
			[Surname] [varchar] (50)  ,
			[EMail] [varchar] (50)  ,
			[TelNo] [varchar] (35)  ,
			[CellPhone] [varchar] (20)  ,
			[Status] [varchar] (50)  ,
			[GroupID] [int],
			[GroupName] [varchar] (100)  ,
			CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
		)
		SET @SQLSelect = 'INSERT INTO #UserTemp ([PersonID], [UserName], [FirstName], [Surname], [EMail], [TelNo], [CellPhone], [Status]'
		IF @GroupID > 0
			SET @SQLSelect = @SQLSelect + ', GroupID, GroupName ) '
		else
			SET @SQLSelect = @SQLSelect + ') '
			
		SET @SQLSelect = @SQLSelect + 'SELECT P.PersonID ,[UserName] ,[FirstName] ,[Surname] ,[EMail] ,[TelNo] ,[CellPhone], Status = PS.Description '
		IF @GroupID > 0
			SET @SQLSelect = @SQLSelect + ', PG.GroupID, GroupName = G.Description '
			
		SET @SQLSelect = @SQLSelect + 'FROM [passport].[Person] AS P INNER JOIN [passport].[PersonStatus] AS PS ON P.PersonStatusID = PS.PersonStatusID '
		IF @GroupID > 0
			BEGIN
				SET @SQLSelect = @SQLSelect + 'INNER JOIN [passport].[PersonGroup] AS PG ON P.PersonID = PG.PersonID '
				SET @SQLSelect = @SQLSelect + 'INNER JOIN [passport].[Groups] AS G ON PG.GroupID = G.GroupID '
			END
			
		IF @GroupID > 0
			BEGIN
				SET @SQLWhere = 'WHERE PG.GroupID = ' + Convert(Varchar(5), @GroupID)
				SET @SQLWhere = @SQLWhere + 'AND P.PersonID > 5'
			END
		else
			SET @SQLWhere = 'WHERE P.PersonID > 5'
			
		SET @SQLOrder = ' ORDER BY '
		SET @SQLOrder = @SQLOrder + @ColumnName
			
		EXEC (@SQLSelect + @SQLWhere + @SQLOrder)  
			
		SET @TotalRows = @@ROWCOUNT
			
		SELECT * FROM #UserTemp 
			WHERE RowID between @StartRow AND @StartRow + @NumberRows - 1
			ORDER BY RowID
			
		DROP TABLE #UserTemp
		SELECT TotalRows = @TotalRows
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserProfileList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserProfileList] (@UserID int)
	AS
	BEGIN
		SELECT PG.PersonID, 
			PG.GroupID, 
			G.GroupStatusID, 
			GroupDesc = G.Description, 
			GroupStatus = GS.Description
			FROM [passport].[PersonGroup] AS PG
				INNER JOIN [passport].[Groups]		AS G	ON PG.GroupID = G.GroupID
				INNER JOIN [passport].[GroupStatus]	AS GS	ON G.GroupStatusID = GS.GroupStatusID
			WHERE PersonID = @UserID
			ORDER BY GroupDesc
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserProfileAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserProfileAdd] (
		@UserID int,
		@GroupID int
	)
	AS
	BEGIN
		CREATE TABLE #ServiceTemp ([PersonID] [int], [ServiceID] [int], [SecurityLevelID] [int])
			INSERT INTO #ServiceTemp ([PersonID], [ServiceID], [SecurityLevelID])
			SELECT 	PS.PersonID,
					PS.ServiceID, 
					PS.SecurityLevelID 
					FROM [passport].[PersonService] AS PS
						JOIN [passport].[ProfileService] AS PF ON PF.ServiceID = PS.ServiceID AND PF.SecurityLevelID = PS.SecurityLevelID
						WHERE PS.PersonID = @UserID AND PF.GroupID = @GroupID
	END
	BEGIN
		IF NOT EXISTS (SELECT PersonID, GroupID FROM [passport].[PersonGroup] WHERE PersonID = @UserID AND GroupID = @GroupID)
			BEGIN
				INSERT INTO [passport].[PersonGroup] (PersonID, GroupID)
				SELECT @UserID, @GroupID
			END
		
		INSERT INTO [passport].[PersonService] (PersonID, ServiceID, SecurityLevelID)
			SELECT @UserID, PF.ServiceID, PF.SecurityLevelID
				FROM [passport].[ProfileService] AS PF
					WHERE PF.GroupID = @GroupID
						AND ServiceID NOT IN (SELECT ServiceID FROM #ServiceTemp)
		DROP TABLE #ServiceTemp
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserSearch
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserSearch] (
		@GroupID int,
		@SearchName varchar(20),
		@SearchNo varchar(20),
		@Exact int
	)
	AS
	BEGIN
	IF @GroupID > 0 
			SELECT P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
				    Token, P.PersonStatusID, PersonStatusDesc = PS.Description,
				    PG.GroupID
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
				INNER JOIN [passport].[PersonGroup]		AS PG	ON P.PersonID = PG.PersonID
				WHERE PG.GroupID = @GroupID
					AND (UserName LIKE @SearchName + '%'
						OR FirstName LIKE @SearchName + '%'
						OR Surname LIKE @SearchName + '%'
						OR TelNo LIKE @SearchNo + '%'
						OR CellPhone LIKE @SearchNo + '%')
	ELSE
			BEGIN
				IF @Exact > 0
					SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
						    Token, P.PersonStatusID, PersonStatusDesc = PS.Description
					FROM [passport].[Person] AS P
						INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
						WHERE UserName = @SearchName OR CellPhone = @SearchNo
				ELSE
					SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
						    Token, P.PersonStatusID, PersonStatusDesc = PS.Description
					FROM [passport].[Person] AS P
						INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
						WHERE UserName LIKE @SearchName + '%'
							OR FirstName LIKE @SearchName + '%'
							OR Surname LIKE @SearchName + '%'
							OR TelNo LIKE @SearchNo + '%'
							OR CellPhone LIKE @SearchNo + '%'
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserSearchAdvanced
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserSearchAdvanced] (
		@GroupID int,
		@SearchUserID varchar(20),
		@SearchUserName varchar(20),
		@SearchFirstName varchar(20),
		@SearchSurname varchar(20),
		@SearchEmail varchar(20),
		@SearchTelNo varchar(20),
		@SearchCellNo varchar(20)
	)
	AS
	BEGIN
			IF @GroupID > 0 
				SELECT P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					    Token, P.PersonStatusID, PersonStatusDesc = PS.Description,
					    PG.GroupID
				FROM [passport].[Person] AS P
					INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
					INNER JOIN [passport].[PersonGroup]		AS PG	ON P.PersonID = PG.PersonID
					WHERE PG.GroupID = @GroupID
							AND (P.PersonID LIKE @SearchUserID + '%'
								OR UserName LIKE @SearchUserName + '%'
								OR FirstName LIKE @SearchFirstName + '%'
								OR Surname LIKE @SearchSurname + '%'
								OR TelNo LIKE @SearchTelNo + '%'
								OR CellPhone LIKE @SearchCellNo + '%'
								OR Email LIKE @SearchEmail + '%')
			ELSE
				SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					    Token, P.PersonStatusID, PersonStatusDesc = PS.Description
				FROM [passport].[Person] AS P
					INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
					WHERE PersonID LIKE @SearchUserID + '%'
						OR UserName LIKE @SearchUserName + '%'
						OR FirstName LIKE @SearchFirstName + '%'
						OR Surname LIKE @SearchSurname + '%'
						OR TelNo LIKE @SearchTelNo + '%'
						OR CellPhone LIKE @SearchCellNo + '%'
						OR Email LIKE @SearchEmail + '%'
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserLockSet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserLockSet] (
		@UserID int
	)
	AS
	BEGIN
		DECLARE @LFailures int, @FailureTimes int, @AccLockedTime int, @AccLockedDate datetime

		SELECT @FailureTimes = RetValue FROM [passport].[Config] WHERE Description = 'LoginFailures'
		SELECT @AccLockedTime = RetValue FROM [passport].[Config] WHERE Description = 'AccLockedDate'
		SELECT @LFailures = @FailureTimes + 1
		SELECT @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())

		UPDATE [passport].[Person]
			SET LoginFailures = @LFailures,
				LoginFailureDate = getdate(),
				AccLockedDate = @AccLockedDate
			WHERE PersonID = @UserID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserPasswordUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserPasswordUpdate] (--1, '', 'Test Password' 
		@UserID int,
		@UserName varchar(50),
		@Password varchar(50)
	)
	AS
	BEGIN
		DECLARE @NewUserID int
		DECLARE @ExpiryDate int
		DECLARE @PasswordExpiryDate datetime
		IF @UserID = 0 
			BEGIN
				SELECT @NewUserID = PersonID FROM [passport].[Person]
					WHERE UserName = @UserName
			END
		ELSE
			BEGIN
				SELECT @NewUserID = @UserID
			END
				
		SELECT @ExpiryDate = RetValue FROM [passport].[Config] WHERE Description = 'PasswordExpiryDate'
		SELECT @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())
				
		IF EXISTS (SELECT PersonID FROM [passport].[Person] WHERE PersonID = @NewUserID)
			BEGIN
				UPDATE [passport].[Person]
					SET Password = @Password, PasswordExpiryDate = @PasswordExpiryDate
					WHERE PersonID = @NewUserID
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_Validate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_Validate] (
		 @Token uniqueidentifier
		,@ExpiryMinutes varchar(50) = null
	)
	AS
	BEGIN
		DECLARE @PersonID int
		DECLARE @ServiceID int
		DECLARE @TokenDate Int, @TExpiryDate DateTime
		DECLARE @Result Varchar(100)
		SELECT @PersonID = PersonID, @TExpiryDate = TokenExpiryDate FROM [passport].[Person] WHERE Token = @Token
		IF @TExpiryDate IS NULL OR DateDiff(n, Getdate(), @TExpiryDate) < 0
			SELECT @Result = 'User session has expired, or user has not yet logged in.'
		ELSE
			BEGIN
				SELECT @Result = 'ok'
				IF (@ExpiryMinutes IS NULL OR @ExpiryMinutes = '')
					SELECT @TokenDate = RetValue FROM [passport].[Config] WHERE Description = 'SessionExpiryTime'
				ELSE 
					SET @TokenDate = @ExpiryMinutes
				SELECT @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
					
				UPDATE [passport].[Person]
					SET TokenExpiryDate = @TExpiryDate,
						LastLoginDate = getdate()
					WHERE PersonID = @PersonID
			END
		SELECT Result = @Result
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserFind
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserFind] (
		@GroupID int,
		@SearchName varchar(20),
		@SearchNo varchar(20),
		@Exact int
	)
	AS
	BEGIN
		IF @GroupID > 0 
			SELECT P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					Token, P.PersonStatusID, PersonStatusDesc = PS.Description,
					PG.GroupID
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
				INNER JOIN [passport].[PersonGroup]		AS PG	ON P.PersonID = PG.PersonID
				WHERE PG.GroupID = @GroupID
					AND (UserName LIKE @SearchName + '%'
						OR FirstName LIKE @SearchName + '%'
						OR Surname LIKE @SearchName + '%'
						OR TelNo LIKE @SearchNo + '%'
						OR CellPhone LIKE @SearchNo + '%')
		ELSE
			BEGIN
				IF @Exact > 0
					SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
							Token, StatusID = P.PersonStatusID, Status = PS.Description
					FROM [passport].[Person] AS P
						INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
						WHERE UserName = @SearchName OR CellPhone = @SearchNo
				ELSE
					SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
							Token, StatusID = P.PersonStatusID, Status = PS.Description
					FROM [passport].[Person] AS P
						INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
						WHERE UserName LIKE @SearchName + '%'
							OR FirstName LIKE @SearchName + '%'
							OR Surname LIKE @SearchName + '%'
							OR TelNo LIKE @SearchNo + '%'
							OR CellPhone LIKE @SearchNo + '%'
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserFindAdvanced
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserFindAdvanced] (
		@GroupID int,
		@SearchUserID varchar(20),
		@SearchUserName varchar(20),
		@SearchFirstName varchar(20),
		@SearchSurname varchar(20),
		@SearchEmail varchar(20),
		@SearchTelNo varchar(20),
		@SearchCellNo varchar(20)
	)
	AS
	BEGIN
		IF @GroupID > 0 
			SELECT P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					Token, StatusID = P.PersonStatusID, Status = PS.Description, PG.GroupID
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
				INNER JOIN [passport].[PersonGroup]		AS PG	ON P.PersonID = PG.PersonID
				WHERE PG.GroupID = @GroupID
					AND (P.PersonID LIKE @SearchUserID + '%'
						OR UserName LIKE @SearchUserName + '%'
						OR FirstName LIKE @SearchFirstName + '%'
						OR Surname LIKE @SearchSurname + '%'
						OR TelNo LIKE @SearchTelNo + '%'
						OR CellPhone LIKE @SearchCellNo + '%'
						OR Email LIKE @SearchEmail + '%')
		ELSE
			SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					Token, StatusID = P.PersonStatusID, Status = PS.Description
			FROM [passport].[Person] AS P
				INNER JOIN [passport].[PersonStatus]	AS PS	ON P.PersonStatusID = PS.PersonStatusID
				WHERE PersonID LIKE @SearchUserID + '%'
					OR UserName LIKE @SearchUserName + '%'
					OR FirstName LIKE @SearchFirstName + '%'
					OR Surname LIKE @SearchSurname + '%'
					OR TelNo LIKE @SearchTelNo + '%'
					OR CellPhone LIKE @SearchCellNo + '%'
					OR Email LIKE @SearchEmail + '%'
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserPassword
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserPassword] (
		@UserID int,
		@UserName varchar(50)
	)
	AS
	BEGIN
		SELECT UserName, FirstName, PersonName = FirstName + ' ' + Surname, CellPhone, EMail, Password
			FROM [passport].[Person]
				WHERE PersonID = @UserID OR UserName = @UserName
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserLoginGetName
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserLoginGetName] (
		@UserName varchar(50)
	) 
	AS
	BEGIN
		SELECT	PersonID, 
				Token,
				TokenExpiryDate,
				UserName, 
				Password, 
				FirstName, 
				Surname, 
				Email, 
				TelNo, 
				CellPhone,
				LoginFailures, 
				PasswordExpiryDate, 
				AccLockedDate, 
				PersonStatusID = P.PersonStatusID, 
				PersonStatusDesc = PS.Description
		FROM [passport].[Person] AS P
			INNER JOIN [passport].[PersonStatus] AS PS ON P.PersonStatusID = PS.PersonStatusID
				WHERE UserName = @UserName
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserSetLoginFail
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserSetLoginFail] (
		@UserID int,
		@FailCount int,
		@FailDate datetime,
		@LockDate datetime
	) 
	AS 
	BEGIN
		UPDATE [passport].[Person]
			SET LoginFailures = @FailCount,
				LoginFailureDate = @FailDate,
				AccLockedDate = @LockDate
		WHERE PersonID = @UserID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserSetLoginOK
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserSetLoginOK] (
		@UserID int,
		@FailCount int,
		@Token uniqueidentifier,
		@LoginDate datetime,
		@TokenDate datetime,
		@ExpireDate datetime
	) 
	AS 
	BEGIN
		UPDATE [passport].[Person]
			SET LoginFailures = @FailCount,
				Token = @Token,
				TokenExpiryDate = @TokenDate,
				PasswordExpiryDate = @ExpireDate,
				LastLoginDate = @LoginDate
		WHERE PersonID = @UserID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_UserGetAll
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_UserGetAll]
	AS
	BEGIN
		SELECT	PersonID, 
				UserName, 
				Password, 
				FirstName, 
				Surname, 
				Email, 
				TelNo, 
				CellPhone,
				Token, 
				P.PersonStatusID, 
				PersonStatusDesc = PS.Description
		FROM [passport].[Person] AS P
			INNER JOIN [passport].[PersonStatus] AS PS ON P.PersonStatusID = PS.PersonStatusID
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO