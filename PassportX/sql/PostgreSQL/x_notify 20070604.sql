/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20070602
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
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_NotificationGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_NotificationGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_NotificationAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_NotificationAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_NotificationUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_NotificationUpdate]
	GO

/*	-----------------------------------------------------------------------
	Create Procedure(s)
	-----------------------------------------------------------------------	*/
		
	SET QUOTED_IDENTIFIER ON 
	GO
	SET ANSI_NULLS ON 
	GO
	CREATE Procedure x_NotificationGet
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Returns all records where the datesent is null!!
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select DISTINCT PersonID, Notification.ProductID, Code, URL, WSDLURL, Name, Namespace
				From Notification
				Inner Join ProductNotification On Notification.ProductID = ProductNotification.ProductID
				Where DateSent IS NULL
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
	CREATE Procedure x_NotificationAdd (
		@PersonID int, 
		@Code Int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Insert a record to indicate that a Person's details has changed 
			and to send a Notification
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Insert Into Notification (PersonID, ProductID, DateInserted, Code)
				Select @PersonID, ProductID, GetDate(), @Code
					From ProductNotification
					Where URL <> '' And URL IS NOT NULL
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
	CREATE Procedure x_NotificationUpdate (
		@PersonID int,
		@ProductID int,
		@Code Int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Update the record where the datesent column is null
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Update Notification
			Set DateSent = GetDate()
				Where PersonID = @PersonID
				And ProductID = @ProductID
				And Code = @Code
				And DateSent IS NULL
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO
