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
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductServiceList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductServiceList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductNotificationAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductNotificationAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductStatusList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductStatusList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductStatusDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ProductStatusUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ProductStatusUpdate]
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
		Description:	x_ProductList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductList]
	AS
	BEGIN
		SELECT ProductID, ProductDesc = P.Description, 
		        PS.ProductStatusID, ProductStatusDesc = PS.Description,
		        DisplayMessage
		FROM [passport].[Product] AS P
		INNER JOIN [passport].[ProductStatus] AS PS ON P.ProductStatusID = PS.ProductStatusID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductGet] (
		@ProductID int
	) 
	AS
	BEGIN
		SELECT P.ProductID, ProductDesc = P.Description,
		        P.ProductStatusID, ProductStatusDesc = PS.Description,
		        DisplayMessage, URL, WSDLURL, Name, Namespace
		FROM [passport].[Product] AS P
			INNER JOIN [passport].[ProductStatus]				AS PS ON P.ProductStatusID = PS.ProductStatusID
			LEFT OUTER JOIN [passport].[ProductNotification]	AS PN ON P.ProductID = PN.ProductID
			WHERE P.ProductID = @ProductID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductServiceList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductServiceList] (
		@ProductID int
	)
	AS
	BEGIN
		SELECT S.ProductID, ServiceID, ProductDesc = P.Description, 
		        ServiceDesc = S.Description, S.ServiceStatusID,
		        ServiceStatusDesc = SS.Description, DisplayMessage
		FROM [passport].[Service] AS S
			INNER JOIN [passport].[Product] AS P ON S.ProductID = P.ProductID
			INNER JOIN [passport].[ServiceStatus] AS SS ON S.ServiceStatusID = SS.ServiceStatusID
				WHERE S.ProductID = @ProductID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductAdd] (
		@ProductID int OUTPUT,
		@Description varchar(100),
		@ProductStatusID int
	)
	AS
	BEGIN
		IF @ProductID > 0  --Then UPDATE!!
			BEGIN
				UPDATE [passport].[Product]
					SET Description = @Description,
						ProductStatusID = @ProductStatusID
					WHERE ProductID = @ProductID
			END
		ELSE
			BEGIN
				INSERT INTO [passport].[Product] (Description, ProductStatusID)
				SELECT @Description, @ProductStatusID

				SELECT @ProductID = @@IDENTITY
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductDelete] (@ProductID int)
	AS
	BEGIN
		DELETE [passport].[PersonService]
			FROM [passport].[Service]
				WHERE Service.ProductID = @ProductID

		DELETE [passport].[Service]
			WHERE ProductID = @ProductID

		DELETE [passport].[PersonProduct]
			WHERE ProductID = @ProductID
		 
		DELETE [passport].[Product]
			WHERE ProductID = @ProductID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductUpdate] (
		@ProductID int,
		@Status varchar(25)
	)
	AS
	BEGIN
		UPDATE [passport].[Product]
			SET ProductStatusID = PS.ProductStatusID
		FROM [passport].[ProductStatus] AS PS
			WHERE ProductID = @ProductID
				AND PS.Description = @Status
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductNotificationAdd
		---------------------------------------------------------------------------------------	*/
	Create PROCEDURE [passport].[x_ProductNotificationAdd] (
		@ProductID Int, 
		@URL Varchar(200), 
		@WSDLURL Varchar(200), 
		@Name Varchar(100), 
		@Namespace Varchar(150)
	)
	AS
	BEGIN
		IF EXISTS(SELECT ProductID FROM [passport].[ProductNotification] WHERE ProductID = @ProductID)
			BEGIN
				UPDATE [passport].[ProductNotification]
					SET URL = @URL,
							WSDLURL = @WSDLURL,
							Name = @Name,
							Namespace = @Namespace
				WHERE ProductID = @ProductID
			END
		ELSE
			BEGIN
				INSERT INTO [passport].[ProductNotification] (ProductID, URL, WSDLURL, Name, Namespace)
					SELECT @ProductID, @URL, @WSDLURL, @Name, @Namespace
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductStatusGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductStatusGet] (
		@ProductStatusID int
	)
	AS
	BEGIN
		SELECT Description, DisplayMessage, ProductStatusID
			FROM [passport].[ProductStatus]
				WHERE ProductStatusID = @ProductStatusID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductStatusList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductStatusList]
	AS
	BEGIN
		SELECT ProductStatusID, Description, DisplayMessage
			FROM [passport].[ProductStatus]
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductStatusDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductStatusDelete] (
		@ProductStatusID int,
		@Result varchar(25) Output
	)
	AS
	BEGIN
		IF EXISTS (SELECT ProductStatusID FROM [passport].[Product]
			WHERE ProductStatusID = @ProductStatusID)
			BEGIN
				SELECT @Result = 'Cannot delete'
			END
		ELSE
			BEGIN
				DELETE [passport].[ProductStatus]
					WHERE ProductStatusID = @ProductStatusID
				SELECT @Result = ''
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductStatusAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ProductStatusAdd] (
		@ProductStatusID int OUTPUT,
		@Description varchar(50),
		@DisplayMessage varchar(300)
	)
	AS
	BEGIN
		IF @ProductStatusID > 0 --UPDATE!
			BEGIN
				UPDATE [passport].[ProductStatus]
				SET Description = @Description,
					DisplayMessage = @DisplayMessage
				WHERE ProductStatusID = @ProductStatusID
			END
		ELSE
			BEGIN
				INSERT INTO [passport].[ProductStatus] (Description, DisplayMessage)
				SELECT @Description, @DisplayMessage
				SELECT @ProductStatusID = @@IDENTITY
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ProductStatusUpdate
		---------------------------------------------------------------------------------------	*/
	Create PROCEDURE [passport].[x_ProductStatusUpdate] (
		@ProductID int,
		@Status varchar(15)
	)
	AS
	BEGIN
		DECLARE @ProductStatusID int
		 
		SELECT @ProductStatusID = ProductStatusID
			FROM [passport].[ProductStatus]
				WHERE Description = @Status
			
		UPDATE [passport].[Product]
			SET ProductStatusID = @ProductStatusID
				WHERE ProductID = @ProductID
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
