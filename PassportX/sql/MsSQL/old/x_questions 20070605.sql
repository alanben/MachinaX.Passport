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
	
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_QuestionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_QuestionGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_QuestionList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_QuestionList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_QuestionDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_QuestionDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_QuestionAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_QuestionAdd]
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
			Used to retrieve a Question record, typically for editing purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_QuestionGet (@QuestionID int)
	As
		Begin
		  Select QuestionID, Description 
		  From Question
		  Where QuestionID = @QuestionID
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
			Retrieve a list of all Question records in the database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_QuestionList
	As
		Begin
		  Select QuestionID, Description
		  From Question
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
			Remove a Question and all related records from the database.
			This method does not return any values.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_QuestionDelete (@QuestionID int)
	As
		Begin
		  Delete Answer
		  Where QuestionID = @QuestionID

		  Delete Question
		  Where QuestionID = @QuestionID
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
			Method used to add/update a Question record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_QuestionAdd (
		@QuestionID int OUTPUT,
		@Description varchar(100)
	)
	As
		Begin
		  If @QuestionID > 0 --Then Update!!
		    Begin
		      Update Question 
		      Set Description = @Description
		      Where QuestionID = @QuestionID
		    End
		  Else
		    Begin
		      Insert Into Question (Description)
		      Select @Description

		      Select @QuestionID = @@IDENTITY
		    End
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO

