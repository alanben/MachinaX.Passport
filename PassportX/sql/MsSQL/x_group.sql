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
	20111212:	Moved to passport schema
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
USE [PassportX]
GO

/*	-----------------------------------------------------------------------
	Check AND DROP PROCEDURE(s)
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupGets]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupGets]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupUserList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupUserList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupServiceAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupServiceAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupServiceAddAlt]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupServiceAddAlt]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupServiceDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupServiceDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupServiceDeleteAlt]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupServiceDeleteAlt]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupProductAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupProductAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupProductDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupProductDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupDeleteStatus]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupDeleteStatus]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupRightsList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupRightsList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupStatusList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupStatusList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_GroupStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_GroupStatusDelete]
	GO

/*	-----------------------------------------------------------------------
	Create Procedures
	-----------------------------------------------------------------------	*/
	
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupAdd] (
		@GroupID int OUTPUT,
		@Description varchar(100),
		@GroupStatusID int
	)
	AS
		BEGIN
		  IF @GroupID > 0 --Then UPDATE!!
		  BEGIN
		    UPDATE [passport].[Groups]
				SET Description = @Description,
					GroupStatusID = @GroupStatusID
				WHERE GroupID = @GroupID
		  END
		  ELSE --Then Insert!!
		  BEGIN
		    INSERT INTO [passport].[Groups] (Description, GroupStatusID)
				SELECT @Description, @GroupStatusID
			
		    SELECT @GroupID = @@IDENTITY
		  END
			EXEC [passport].[x_NotificationAdd] @GroupID, 200
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupUpdate] (
		@GroupID int, 
		@Status varchar(25)
	) 
	AS
		BEGIN
			DECLARE @PrevStatus Varchar(50)
			SELECT @PrevStatus = GS.Description
				FROM [passport].[GroupStatus] AS GS
					INNER JOIN [passport].[Groups] AS G ON G.GroupStatusID = GS.GroupStatusID
					WHERE GroupID = @GroupID
				
			UPDATE Groups
				SET GroupStatusID = GS.GroupStatusID
				FROM [passport].[GroupStatus] AS GS
					WHERE GroupID = @GroupID
					AND GS.Description = @Status

			IF @Status = 'Deleted'
				BEGIN
					EXEC [passport].[x_NotificationAdd] @GroupID, 201
				END
			IF @Status = 'Active' AND @PrevStatus = 'Deleted' -- Undelete Group
				BEGIN
					EXEC [passport].[x_NotificationAdd] @GroupID, 202
				END
			IF @Status = 'Locked'
				BEGIN
					EXEC [passport].[x_NotificationAdd] @GroupID, 204
				END
			IF @Status = 'Active' AND @PrevStatus = 'Locked' -- Unlock Group
				BEGIN
					EXEC [passport].[x_NotificationAdd] @GroupID, 205
				END
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupDelete] (@GroupID int) 
	AS
		BEGIN
			DELETE [passport].[PersonGroup] WHERE GroupID = @GroupID
			DELETE [passport].[Groups] WHERE GroupID = @GroupID
			EXEC [passport].[x_NotificationAdd] @GroupID, 203
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupGet] (@GroupID int)
	AS
		BEGIN
			SELECT GroupDesc = G.Description, G.GroupStatusID, GroupStatusDesc = GS.Description, G.GroupStatusID
				FROM [passport].[Groups] AS G
				INNER JOIN [passport].[GroupStatus] AS GS ON G.GroupStatusID = GS.GroupStatusID
				WHERE GroupID = @GroupID
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupGets
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupGets]
	AS
		BEGIN
			SELECT GroupID, GroupName = G.Description, StatusID = G.GroupStatusID, Status = GS.Description
				FROM [passport].[Groups] AS G
				INNER JOIN [passport].[GroupStatus] AS GS ON G.GroupStatusID = GS.GroupStatusID
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupList]
	AS
		BEGIN
			SELECT GroupID, GroupDesc = G.Description, G.GroupStatusID, GroupStatusDesc = GS.Description
				FROM [passport].[Groups] AS G
				INNER JOIN [passport].[GroupStatus] AS GS ON G.GroupStatusID = GS.GroupStatusID
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupUserList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupUserList] (@GroupID int)
	AS
		BEGIN
			SELECT G.GroupID, GroupDesc = Description, P.PersonID, FirstName, Surname
				FROM [passport].[Groups] AS G
					INNER JOIN [passport].[PersonGroup] AS PG ON G.GroupID = PG.GroupID
					INNER JOIN [passport].[Person] AS P ON PG.PersonID = P.PersonID
					WHERE G.GroupID = @GroupID
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupServiceAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupServiceAdd] (
		@GroupID int,
		@ServiceID int,
		@SecurityLevelID int
	)
	AS
		BEGIN
			INSERT INTO [passport].[PersonService] (PersonID, ServiceID, SecurityLevelID, ServiceIdentifier)  
				SELECT PersonID, @ServiceID, @SecurityLevelID, ''
					FROM [passport].[PersonGroup]
						WHERE GroupID = @GroupID
							AND PersonID NOT IN (SELECT PersonID FROM [passport].[PersonService] WHERE ServiceID = @ServiceID AND SecurityLevelID = @SecurityLevelID)
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupServiceAddAlt
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupServiceAddAlt] (
		@GroupID int,
		@ServiceID int,
		@SecurityLevelID int
	)
	AS
		BEGIN
			INSERT INTO [passport].[ProfileService] (GroupID, ServiceID, SecurityLevelID)  
				SELECT @GroupID, @ServiceID, @SecurityLevelID
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupServiceDelete
		---------------------------------------------------------------------------------------	*/
	Create PROCEDURE [passport].[x_GroupServiceDelete] (
		@GroupID int,
		@ServiceID int
	)
	AS
		BEGIN
			DELETE [passport].[PersonService]
				FROM [passport].[PersonGroup] AS PG
					INNER JOIN [passport].[PersonService] AS PS ON PS.PersonID = PG.PersonID
					WHERE GroupID = @GroupID
						AND ServiceID = @ServiceID
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupServiceDeleteAlt
		---------------------------------------------------------------------------------------	*/
	Create PROCEDURE [passport].[x_GroupServiceDeleteAlt] (
		@GroupID int,
		@ServiceID int,
		@SecurityLevelID int
	)
	AS
		BEGIN
			DELETE [passport].[ProfileService]
				WHERE GroupID = @GroupID
					AND ServiceID = @ServiceID
					AND SecurityLevelID = @SecurityLevelID
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupProductAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupProductAdd] (
		@GroupID int,
		@ProductID int,
		@SecurityLevelID int
	)
	AS
		BEGIN
			INSERT INTO [passport].[PersonProduct] (PersonID, ProductID, SecurityLevelID)
				SELECT PersonID, @ProductID, @SecurityLevelID
					FROM [passport].[PersonGroup]
					WHERE GroupID = @GroupID
						AND PersonID NOT IN (SELECT PersonID FROM [passport].[PersonProduct] WHERE ProductID = @ProductID AND SecurityLevelID = @SecurityLevelID)
		END
	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupProductDelete
		---------------------------------------------------------------------------------------	*/
	Create PROCEDURE [passport].[x_GroupProductDelete] (
		@GroupID int,
		@ProductID int
	)
	AS
		BEGIN
			DELETE [passport].[PersonProduct]
			FROM [passport].[PersonGroup] AS PG
				INNER JOIN [passport].[PersonProduct] AS PP ON PP.PersonID = PG.PersonID
					WHERE GroupID = @GroupID
						AND ProductID = @ProductID
		END

	GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupStatusAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupStatusAdd] (
		@GroupStatusID int OUTPUT,
		@Description varchar(100)
	)
	AS
	BEGIN
		IF @GroupStatusID > 0 --UPDATE!
			BEGIN
				UPDATE [passport].[GroupStatus]
					SET Description = @Description
						WHERE GroupStatusID = @GroupStatusID
			END
		ELSE  --Insert!
			BEGIN
				INSERT INTO [passport].[GroupStatus] (Description)
					SELECT @Description
				SELECT @GroupStatusID = @@IDENTITY
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupDeleteStatus
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupDeleteStatus] (
		@GroupStatusID int,
		@Result varchar(25) Output
	)
	AS
	BEGIN
		IF EXISTS (SELECT GroupStatusID FROM [passport].[Groups]
			WHERE GroupStatusID = @GroupStatusID)
			BEGIN
				SELECT @Result = 'Cannot delete record - record in use.'
			END
		ELSE
			BEGIN
				DELETE [passport].[GroupStatus]
					WHERE GroupStatusID = @GroupStatusID
				SELECT @Result = ''
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupRightsList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupRightsList] (
		@GroupID int
	)
	AS
	BEGIN
		IF @GroupID > 0 
			SELECT PS.GroupID, GroupDesc = G.Description,
					S.ProductID, ProductDesc = P.Description, 
					PS.ServiceID, ServiceDesc = S.Description,
					PS.SecurityLevelID, SecurityLevelDesc = SL.Description
				FROM [passport].[ProfileService] AS PS
					INNER JOIN [passport].[Groups]			AS G	ON PS.GroupID = G.GroupID
					INNER JOIN [passport].[Service]			AS S	ON PS.ServiceID = S.ServiceID
					INNER JOIN [passport].[Product]			AS P	ON S.ProductID = P.ProductID
					INNER JOIN [passport].[SecurityLevel]	AS SL	ON PS.SecurityLevelID = SL.SecurityLevelID
					WHERE PS.GroupID = @GroupID
						ORDER BY PS.GroupID, ServiceDesc, PS.ServiceID
		ELSE
			SELECT PS.GroupID, GroupDesc = G.Description,
					S.ProductID, ProductDesc = P.Description, 
					PS.ServiceID, ServiceDesc = S.Description,
					PS.SecurityLevelID, SecurityLevelDesc = SL.Description
				FROM [passport].[ProfileService] AS PS
					INNER JOIN [passport].[Groups]			AS G	ON PS.GroupID = G.GroupID
					INNER JOIN [passport].[Service]			AS S	ON PS.ServiceID = S.ServiceID
					INNER JOIN [passport].[Product]			AS P	ON S.ProductID = P.ProductID
					INNER JOIN [passport].[SecurityLevel]	AS SL	ON PS.SecurityLevelID = SL.SecurityLevelID
						ORDER BY PS.GroupID, ServiceDesc, PS.ServiceID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupStatusGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupStatusGet] (
		@GroupStatusID int
	) 
	AS
	BEGIN
		SELECT Description, GroupStatusID
			FROM [passport].[GroupStatus]
				WHERE GroupStatusID = @GroupStatusID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupStatusList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupStatusList]
	AS
	BEGIN
		SELECT GroupStatusID, Description 
		FROM [passport].[GroupStatus]
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_GroupStatusDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_GroupStatusDelete] (
		@GroupStatusID int,
		@Result varchar(25) Output
	)
	AS
	BEGIN
		IF EXISTS (SELECT GroupStatusID FROM [passport].[Groups]
			WHERE GroupStatusID = @GroupStatusID)
			BEGIN
				SELECT @Result = 'Cannot delete record - record in use.'
			END
		ELSE
			BEGIN
				DELETE [passport].[GroupStatus]
					WHERE GroupStatusID = @GroupStatusID
				SELECT @Result = ''
			END
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

	