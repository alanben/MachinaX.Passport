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
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceUpdate]
	GO


	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceStatusList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceStatusList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceStatusDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ServiceStatusUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ServiceStatusUpdate]
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
		Description:	x_ServiceGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceGet] (@ServiceID int)
	AS
	BEGIN
		SELECT S.ProductID, ServiceID, ProductDesc = P.Description, 
		        ServiceDesc = S.Description, S.ServiceStatusID,
		        ServiceStatusDesc = SS.Description, DisplayMessage
		FROM [passport].[Service] AS S
			INNER JOIN [passport].[Product]			AS P	ON S.ProductID = P.ProductID
			INNER JOIN [passport].[ServiceStatus]	AS SS	ON S.ServiceStatusID = SS.ServiceStatusID
			WHERE S.ServiceID = @ServiceID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceList]
	AS
	BEGIN
		SELECT S.ProductID, ServiceID, ProductDesc = P.Description, 
		        ServiceDesc = S.Description, S.ServiceStatusID,
		        ServiceStatusDesc = SS.Description, DisplayMessage
		FROM [passport].[Service] AS S
			INNER JOIN [passport].[Product]			AS P	ON S.ProductID = P.ProductID
			INNER JOIN [passport].[ServiceStatus]	AS SS	ON S.ServiceStatusID = SS.ServiceStatusID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceAdd] (
		@ServiceID int OUTPUT,
		@ProductID int,
		@ServiceStatusID int,
		@Description varchar(100)
	)
	AS
	BEGIN
		IF @ServiceID > 0 --Then UPDATE!!
			BEGIN
				UPDATE [passport].[Service]
				SET ProductID = @ProductID,
					ServiceStatusID = @ServiceStatusID,
					Description = @Description
						WHERE ServiceID = @ServiceID
			END
		ELSE  --Then Insert!!
			BEGIN
				INSERT INTO [passport].[Service] (ProductID, ServiceStatusID, Description)
				SELECT @ProductID, @ServiceStatusID, @Description
				
				SELECT @ServiceID = @@IDENTITY
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceUpdate] (
		@ServiceID int,
		@Status varchar(15)
	)
	AS
	BEGIN
		DECLARE @ServiceStatusID int
		  
		SELECT @ServiceStatusID = ServiceStatusID
			FROM [passport].[ServiceStatus]
				WHERE Description = @Status
		 
		UPDATE [passport].[Service]
			SET ServiceStatusID = @ServiceStatusID
				WHERE ServiceID = @ServiceID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceDelete] (@ServiceID int)
	AS
	BEGIN
		DELETE [passport].[PersonService]
			WHERE ServiceID = @ServiceID

		DELETE [passport].[Service]
			WHERE ServiceID = @ServiceID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceStatusGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceStatusGet] (@ServiceStatusID int) 
	AS
	BEGIN
		SELECT Description, DisplayMessage, ServiceStatusID
			FROM [passport].[ServiceStatus]
				WHERE ServiceStatusID = @ServiceStatusID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceStatusList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceStatusList]
	AS
	BEGIN
		SELECT ServiceStatusID, Description, DisplayMessage 
			FROM [passport].[ServiceStatus]
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceStatusAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceStatusAdd] (
		@ServiceStatusID int OUTPUT,
		@Description varchar(50),
		@DisplayMessage varchar(300)
	)
	AS
	BEGIN
		IF @ServiceStatusID > 0 --UPDATE!
			BEGIN
				UPDATE [passport].[ServiceStatus]
				SET Description = @Description,
					DisplayMessage = @DisplayMessage
				WHERE ServiceStatusID = @ServiceStatusID
			END
		ELSE  --Insert!
			BEGIN
				INSERT INTO [passport].[ServiceStatus] (Description, DisplayMessage)
				SELECT @Description, @DisplayMessage
				
				SELECT @ServiceStatusID = @@IDENTITY
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceStatusUpdate
		---------------------------------------------------------------------------------------	*/
	Create PROCEDURE [passport].[x_ServiceStatusUpdate] (
		@ServiceID int,
		@Status varchar(15)
	)
	AS
	BEGIN
		DECLARE @ServiceStatusID int
	  
		SELECT @ServiceStatusID = ServiceStatusID
			FROM [passport].[ServiceStatus]
				WHERE Description = @Status
	 
		UPDATE [passport].[Service]
			SET ServiceStatusID = @ServiceStatusID
				WHERE ServiceID = @ServiceID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ServiceStatusDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ServiceStatusDelete] (
		@ServiceStatusID int,
		@Result varchar(25) Output
	)
	AS
	BEGIN
		IF EXISTS (SELECT ServiceStatusID FROM [passport].[Service]
		            WHERE ServiceStatusID = @ServiceStatusID)
			BEGIN
				SELECT @Result = 'Cannot delete record - record in use.'
			END
		ELSE
			BEGIN
				DELETE [passport].[ServiceStatus]
					WHERE ServiceStatusID = @ServiceStatusID
				SELECT @Result = ''
			END
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

