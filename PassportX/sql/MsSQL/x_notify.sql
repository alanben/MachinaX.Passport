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
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_NotificationGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_NotificationGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_NotificationAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_NotificationAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_NotificationUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_NotificationUpdate]
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
		Description:	x_NotificationGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_NotificationGet]
	AS
	BEGIN
		SELECT DISTINCT PersonID, N.ProductID, Code, URL, WSDLURL, Name, Namespace
			FROM [passport].[Notification] AS N
				INNER JOIN [passport].[ProductNotification] AS PN ON N.ProductID = PN.ProductID
				WHERE DateSent IS NULL
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_NotificationAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_NotificationAdd] (
		@PersonID int, 
		@Code Int
	)
	AS
	BEGIN
		INSERT INTO [passport].[Notification] (PersonID, ProductID, DateInserted, Code)
			SELECT @PersonID, ProductID, GetDate(), @Code
				FROM [passport].[ProductNotification]
					WHERE URL <> '' AND URL IS NOT NULL
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_NotificationUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_NotificationUpdate] (
		@PersonID int,
		@ProductID int,
		@Code Int
	)
	AS
	BEGIN
		UPDATE [passport].[Notification]
		SET DateSent = GetDate()
			WHERE PersonID = @PersonID
				AND ProductID = @ProductID
				AND Code = @Code
				AND DateSent IS NULL
	END
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
