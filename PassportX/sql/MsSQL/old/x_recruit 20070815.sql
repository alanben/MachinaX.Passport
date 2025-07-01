/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-08-15	
	Status:		redev	
	Version:	2.0.0
	Build:		20070806
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	-------------------------------------------------------------------------------------------------
	PassportX:
	==========
	Refactored database for PassportX.
	Refactoring objectives are:
		1.	Convert all structures and procedures to EngineX naming conventions.
		2.	Refine structure and code to requirements of the PassportX classes.
		3.	Create templates for equivalent proceduires in other db's (eg MySQL)
	-------------------------------------------------------------------------------------------------	*/
	
/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20070815:	Starting point from x_user
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	

/*	-----------------------------------------------------------------------
	Check and drop Procedure(s)
	-----------------------------------------------------------------------	*/
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_RecruitGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_RecruitGet]
	GO	

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_RecruitAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_RecruitAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_RecruitDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_RecruitDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_RecruitUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_RecruitUpdate]
	GO


/*	-----------------------------------------------------------------------
	Create Procedure(s)
	-----------------------------------------------------------------------	*/
		
	SET QUOTED_IDENTIFIER ON 
	GO
	SET ANSI_NULLS ON 
	GO
	CREATE Procedure x_RecruitGet (
		@RecruitID int,
		@RecruitToken varchar(50),
		@RecruitCellPhone varchar(20),
		@RecruitEmail varchar(50)
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_RecruitGet
			- Stored procedure to retrieve a specific user's details
		Parameters:
			@RecruitID:		Recruit identifier
			@RecruitToken:		Recruit's login token (guid)
			@RecruitCellPhone:	Recruit's cellphone number
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select Recruit.ID, Token, FirstName, Surname, Email, TelNo, CellPhone, SignupDate, PersonID, TypeID = RecruitType.ID, Type = RecruitType.Description
				From Recruit
				Inner Join RecruitType On Recruit.TypeID = RecruitType.ID
				Where (@RecruitID != 0 And Recruit.ID = @RecruitID)
					Or (@RecruitToken != '' And Convert(Varchar(50), Token) = @RecruitToken)
					Or (@RecruitCellPhone != '' And CellPhone = @RecruitCellPhone)
					Or (@RecruitEmail != '' And Email = @RecruitEmail)
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO



	SET QUOTED_IDENTIFIER ON 
	GO
	SET ANSI_NULLS ON 
	GO
	CREATE Procedure x_RecruitAdd (
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@Type int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Adds a Recruit.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @ID int
			If Not Exists (Select Email From Recruit Where Email = @Email)
				Begin 
					Insert Into Recruit (Token, FirstName, Surname, Email, TelNo, CellPhone, TypeID, SignupDate)
					Select NEWID(), @FirstName, @Surname, @Email, @TelNo, @CellNo, @Type, GETDATE()
					Select @ID = @@IDENTITY
				End
			Else
				Begin
					Select @ID = (Select ID From Recruit Where Email = @Email)
					Update Recruit
					Set FirstName = @FirstName,
						Surname = @Surname,
						Email = @Email,
						TelNo = @TelNo,
						CellPhone = @CellNo,
						TypeID = @Type
					Where ID = @ID
				End
			Exec x_RecruitGet @ID, '', '', ''
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO



	SET QUOTED_IDENTIFIER ON 
	GO
	SET ANSI_NULLS ON 
	GO
	CREATE Procedure x_RecruitUpdate (
		@ID int,
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@PersonID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_RecruitUpdate
			- Updates an existing recruit details.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Update Recruit
			Set FirstName = @FirstName,
				Surname = @Surname,
				Email = @Email,
				TelNo = @TelNo,
				CellPhone = @CellNo,
				PersonID = @PersonID
			Where ID = @ID
			Exec x_RecruitGet @ID, '', '', ''
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO



	SET QUOTED_IDENTIFIER ON 
	GO
	SET ANSI_NULLS ON 
	GO
	CREATE Procedure x_RecruitDelete (
		@ID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_RecruitDelete
			Removes a recruit permanently.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Delete Recruit Where ID = @ID
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO


