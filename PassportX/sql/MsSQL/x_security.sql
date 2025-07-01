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
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_SecurityLevelGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_SecurityLevelGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_SecurityLevelAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_SecurityLevelAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_SecurityLevelList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_SecurityLevelList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_SecurityLevelDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_SecurityLevelDelete]
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
		Description:	x_SecurityLevelGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_SecurityLevelGet] (@SecurityLevelID int)
	AS
	BEGIN
		SELECT Description, SecurityLevelID
			FROM [passport].[SecurityLevel]
			WHERE SecurityLevelID = @SecurityLevelID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_SecurityLevelAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_SecurityLevelAdd] (
		@SecurityLevelID int OUTPUT,
		@Description varchar(50)
	)
	AS
	BEGIN
		IF @SecurityLevelID > 0 --UPDATE!
			BEGIN
				UPDATE [passport].[SecurityLevel]
					SET Description = @Description
						WHERE SecurityLevelID = @SecurityLevelID
			END
		ELSE  --Insert!
			BEGIN
				INSERT INTO [passport].[SecurityLevel] (Description)
				SELECT @Description

				SELECT @SecurityLevelID = @@IDENTITY
			END
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_SecurityLevelList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_SecurityLevelList]
	AS
	BEGIN
		SELECT SecurityLevelID, Description 
			FROM [passport].[SecurityLevel]
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_SecurityLevelDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_SecurityLevelDelete] (
		@SecurityLevelID int,
		@Result varchar(25) Output
	)
	AS
	BEGIN
		IF EXISTS (SELECT SecurityLevelID FROM [passport].[PersonService]
			        WHERE SecurityLevelID = @SecurityLevelID)
			BEGIN
				SELECT @Result = 'Cannot delete'
			END
		ELSE
			BEGIN
				DELETE [passport].[SecurityLevel]
					WHERE SecurityLevelID = @SecurityLevelID
				SELECT @Result = ''
			END
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

