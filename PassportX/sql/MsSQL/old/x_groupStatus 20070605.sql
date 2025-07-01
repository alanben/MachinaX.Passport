/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-06-05	
	Status:		dev	
	Version:	2.0.0
	Build:		20070605
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
	20070605:	Starting point from Gatekeeper
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Check and drop Procedure(s)
	-----------------------------------------------------------------------	*/
	
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupStatusAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupStatusAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupStatusGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupStatusGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupStatusList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupStatusList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupStatusDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupStatusDelete]
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
			Used to add/update a Group Status record in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupStatusAdd
	(@GroupStatusID int OUTPUT,
	 @Description varchar(100))
	As
	Begin
	  If @GroupStatusID > 0 --Update!
	    Begin
	      Update GroupStatus
	      Set Description = @Description
	      Where GroupStatusID = @GroupStatusID
	    End
	  Else  --Insert!
	    Begin
	      Insert Into GroupStatus (Description)
	      Select @Description

	      Select @GroupStatusID = @@IDENTITY
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
			Used to retrieve details for a specific GroupStatus record in the Gatekeeper database.
			Typically for editing purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupStatusGet
	(@GroupStatusID int) 
	As
	Begin
	  Select Description, GroupStatusID
	  From GroupStatus
	  Where GroupStatusID = @GroupStatusID
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
			Returns a list of all GroupStatus records in the Gatekeeper database.
			Typically for selection on a user interface.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupStatusList
	As
	Begin
	  Select GroupStatusID, Description 
	  From GroupStatus
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
			Used to permanently remove a GroupStatus record from the Gatekeeper database.
			The system will check that the record is no longer in use before attempting the delete.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupStatusDelete
	(@GroupStatusID int,
	 @Result varchar(25) Output)
	As
	Begin
	  If Exists (Select GroupStatusID From Groups 
	             Where GroupStatusID = @GroupStatusID)
	    Begin
	      Select @Result = 'Cannot delete record - record in use.'
	    End
	  Else
	    Begin
	      Delete GroupStatus
	      Where GroupStatusID = @GroupStatusID
	      Select @Result = ''
	    End
	End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO

