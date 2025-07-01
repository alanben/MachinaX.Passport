/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-06-05	
	Status:		dev	
	Version:	2.0.0
	Build:		20070611
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
	20070611:	Starting point from Gatekeeper
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Check and drop Procedure(s)
	-----------------------------------------------------------------------	*/
	
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_SecurityLevelGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_SecurityLevelGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_SecurityLevelAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_SecurityLevelAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_SecurityLevelList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_SecurityLevelList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_SecurityLevelDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_SecurityLevelDelete]
	GO

/*	-----------------------------------------------------------------------
	Create Procedures
	-----------------------------------------------------------------------	*/
			
	SET QUOTED_IDENTIFIER ON 
	GO
	SET ANSI_NULLS ON 
	GO
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Returns details for a specific Security Level record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_SecurityLevelGet (@SecurityLevelID int)
	As
		Begin
			Select Description, SecurityLevelID
				From SecurityLevel
				Where SecurityLevelID = @SecurityLevelID
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
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to add/update a SecurityLevel record in the Gatekeeper database. 
			Will check for the existence of a record, before adding a new record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_SecurityLevelAdd (
		@SecurityLevelID int OUTPUT,
		@Description varchar(50)
	)
	As
		Begin
		  If @SecurityLevelID > 0 --Update!
			Begin
			  Update SecurityLevel
			  Set Description = @Description
			  Where SecurityLevelID = @SecurityLevelID
			End
		  Else  --Insert!
			Begin
			  Insert Into SecurityLevel (Description)
			  Select @Description

			  Select @SecurityLevelID = @@IDENTITY
			End
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
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to retrieve a list of all Security Level records in the database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_SecurityLevelList
	As
		Begin
			Select SecurityLevelID, Description From SecurityLevel
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
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove a Security Level record from the Gatekeeper database.
			The system will check that the record is not in use any more before 
			attempting to delete the record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_SecurityLevelDelete (
		@SecurityLevelID int,
		@Result varchar(25) Output
	)
	As
		Begin
			  If Exists (Select SecurityLevelID From PersonService
			             Where SecurityLevelID = @SecurityLevelID)
			    Begin
			      Select @Result = 'Cannot delete'
			    End
			  Else
			    Begin
			      Delete SecurityLevel
			      Where SecurityLevelID = @SecurityLevelID
			      Select @Result = ''
			    End
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO

