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
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_QuestionGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_QuestionGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_QuestionList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_QuestionList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_QuestionDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_QuestionDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_QuestionAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_QuestionAdd]
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
		Description:	x_QuestionGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_QuestionGet] (
		@QuestionID int
	)
	AS
	BEGIN
		SELECT QuestionID, Description 
			FROM [passport].[Question]
				WHERE QuestionID = @QuestionID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_QuestionList
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_QuestionList]
	AS
	BEGIN
		SELECT QuestionID, Description
			FROM [passport].[Question]
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_QuestionDelete
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_QuestionDelete] (
		@QuestionID int
	)
	AS
	BEGIN
		DELETE [passport].[Answer]
			WHERE QuestionID = @QuestionID

		DELETE [passport].[Question]
			WHERE QuestionID = @QuestionID
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_QuestionAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_QuestionAdd] (
		@QuestionID int OUTPUT,
		@Description varchar(100)
	)
	AS
	BEGIN
		IF @QuestionID > 0 --Then UPDATE!!
			BEGIN
				UPDATE [passport].[Question]
					SET Description = @Description
						WHERE QuestionID = @QuestionID
			END
		ELSE
			BEGIN
				INSERT INTO [passport].[Question] (Description)
				SELECT @Description

				SELECT @QuestionID = @@IDENTITY
			END
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

