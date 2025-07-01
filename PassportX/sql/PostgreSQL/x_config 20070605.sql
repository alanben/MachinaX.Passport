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
	20070602:	Starting point from Gatekeeper
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Check and drop Procedure(s)
	-----------------------------------------------------------------------	*/
	
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ConfigAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ConfigAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ConfigDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ConfigDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ConfigGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ConfigGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ConfigList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ConfigList]
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
			Used to change the value of a system setting.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ConfigAdd (
		@Description varchar(100),
		@RetValue varchar(50)
	)
		As
			Begin
			  If Exists (Select Description From Config
			             Where Description = @Description)
			    Begin
			      Update Config
			      Set RetValue = @RetValue
			      Where Description = @Description
			    End
			  Else
			    Begin
			      Insert Into Config (Description, RetValue)
			      Select @Description, @RetValue
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
			Used to remove a System Configuration value.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ConfigDelete (@Description varchar(100))
		As
			Begin
				Delete Config
					Where Description = @Description
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
			Used to return the value of a system setting.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ConfigGet (@Description varchar(100))
		As
			Begin
				Select Description, RetValue
					From Config
					Where Description = @Description
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
			Used to retrieve a list of all System Configuration values.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ConfigList
		As
			Begin
			  Select Description, RetValue 
				From Config
			End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO

