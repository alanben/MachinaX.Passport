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
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ConfigAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ConfigAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ConfigDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ConfigDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ConfigGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ConfigGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_ConfigList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_ConfigList]
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
		Description:	x_ConfigAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ConfigAdd] (
		@Description varchar(100),
		@RetValue varchar(50)
	)
	AS
	BEGIN
		IF EXISTS (SELECT Description FROM [passport].[Config]
			        WHERE Description = @Description)
			BEGIN
				UPDATE [passport].[Config]
				SET RetValue = @RetValue
				WHERE Description = @Description
			END
		ELSE
			BEGIN
				INSERT INTO [passport].[Config] (Description, RetValue)
				SELECT @Description, @RetValue
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ConfigDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ConfigDelete] (
		@Description varchar(100)
	)
	AS
	BEGIN
		DELETE [passport].[Config]
			WHERE Description = @Description
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ConfigGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ConfigGet] (
		@Description varchar(100)
	)
	AS
	BEGIN
		SELECT Description, RetValue
			FROM [passport].[Config]
			WHERE Description = @Description
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_ConfigList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_ConfigList]
	AS
	BEGIN
		SELECT Description, RetValue 
			FROM [passport].[Config]
	END
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

