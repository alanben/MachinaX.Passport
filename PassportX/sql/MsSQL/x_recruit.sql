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
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_RecruitGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_RecruitGet]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_RecruitAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_RecruitAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_RecruitDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_RecruitDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[passport].[x_RecruitUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [passport].[x_RecruitUpdate]
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
		Description:	x_RecruitGet
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_RecruitGet] (
		@RecruitID int,
		@RecruitToken varchar(50),
		@RecruitCellPhone varchar(20),
		@RecruitEmail varchar(50)
	)
	AS
	BEGIN
		SELECT R.ID, Token, FirstName, Surname, Email, TelNo, CellPhone, SignupDate, PersonID, TypeID = RT.ID, Type = RT.Description
			FROM [passport].[Recruit] AS R
				INNER JOIN [passport].[RecruitType] AS RT ON R.TypeID = RT.ID
				WHERE (@RecruitID != 0 AND R.ID = @RecruitID)
					Or (@RecruitToken != '' AND Convert(Varchar(50), Token) = @RecruitToken)
					Or (@RecruitCellPhone != '' AND CellPhone = @RecruitCellPhone)
					Or (@RecruitEmail != '' AND Email = @RecruitEmail)
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_RecruitAdd
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_RecruitAdd] (
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@Type int
	)
	AS
	BEGIN
		DECLARE @ID int
		IF NOT EXISTS (SELECT Email FROM [passport].[Recruit] WHERE Email = @Email)
			BEGIN 
				INSERT INTO [passport].[Recruit] (Token, FirstName, Surname, Email, TelNo, CellPhone, TypeID, SignupDate)
					SELECT NEWID(), @FirstName, @Surname, @Email, @TelNo, @CellNo, @Type, GETDATE()
				SELECT @ID = @@IDENTITY
			END
		ELSE
			BEGIN
				SELECT @ID = (SELECT ID FROM [passport].[Recruit] WHERE Email = @Email)
				UPDATE [passport].[Recruit]
					SET FirstName = @FirstName,
						Surname = @Surname,
						Email = @Email,
						TelNo = @TelNo,
						CellPhone = @CellNo,
						TypeID = @Type
					WHERE ID = @ID
			END
		EXEC [passport].[x_RecruitGet] @ID, '', '', ''
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_RecruitUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_RecruitUpdate] (
		@ID int,
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@PersonID int
	)
	AS
	BEGIN
		UPDATE [passport].[Recruit]
			SET FirstName = @FirstName,
				Surname = @Surname,
				Email = @Email,
				TelNo = @TelNo,
				CellPhone = @CellNo,
				PersonID = @PersonID
			WHERE ID = @ID
		EXEC [passport].[x_RecruitGet] @ID, '', '', ''
	END
GO

	/*	---------------------------------------------------------------------------------------
		Author:			Alan Benington
		Create date:	20111003
		Description:	x_RecruitUpdate
		---------------------------------------------------------------------------------------	*/
	CREATE PROCEDURE [passport].[x_RecruitDelete] (
		@ID int
	)
	AS
	BEGIN
		DELETE [passport].[Recruit] 
			WHERE ID = @ID
	END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


