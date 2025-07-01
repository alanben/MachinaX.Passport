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
	
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceUpdate]
	GO


	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceStatusAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceStatusAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceStatusGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceStatusGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceStatusList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceStatusList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceStatusDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceStatusDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ServiceStatusUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ServiceStatusUpdate]
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
			Retrieves details of a selected Service in the Gatekeeper database, 
			usually for editing purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceGet (@ServiceID int)
	As
		Begin
		  Select Service.ProductID, ServiceID, ProductDesc = Product.Description, 
		         ServiceDesc = Service.Description, Service.ServiceStatusID,
		         ServiceStatusDesc = ServiceStatus.Description, DisplayMessage
		  From Service
		  Inner Join Product On Service.ProductID = Product.ProductID
		  Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
		  Where Service.ServiceID = @ServiceID
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
			Retrieves a list of all Services in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceList
	As
		Begin
		  Select Service.ProductID, ServiceID, ProductDesc = Product.Description, 
		         ServiceDesc = Service.Description, Service.ServiceStatusID,
		         ServiceStatusDesc = ServiceStatus.Description, DisplayMessage
		  From Service
		  Inner Join Product On Service.ProductID = Product.ProductID
		  Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
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
			Method to save the details of a Service.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceAdd (
		@ServiceID int OUTPUT,
		@ProductID int,
		@ServiceStatusID int,
		@Description varchar(100)
	)
	As
		Begin
		  If @ServiceID > 0 --Then Update!!
		    Begin
		      Update Service
		      Set ProductID = @ProductID,
		          ServiceStatusID = @ServiceStatusID,
		          Description = @Description
					Where ServiceID = @ServiceID
		    End
		  Else  --Then Insert!!
		    Begin
		      Insert Into Service (ProductID, ServiceStatusID, Description)
		      Select @ProductID, @ServiceStatusID, @Description
				
		      Select @ServiceID = @@IDENTITY
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
			Used to restore a Service record on the Gatekeeper database that was previously marked as inactive.
			Used to mark a Service record as inactive on the Gatekeeper database. The system will check that the Service is
			no longer in use before attempting the delete of the record.
			Used to lock a service in the Gatekeeper database. This will not prevent access to the Service,
			but will inform the Service when a user is validated that the Service should not allow any
			transactional processing to occur.
			Used to unlock a service in the Gatekeeper database that was previously locked.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceUpdate (
		@ServiceID int,
		@Status varchar(15)
	)
	As
		Begin
		  Declare @ServiceStatusID int
		  
		  Select @ServiceStatusID = ServiceStatusID
		  From ServiceStatus
		  Where Description = @Status
		 
		  Update Service
		  Set ServiceStatusID = @ServiceStatusID
		  Where ServiceID = @ServiceID
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
			Used to completely remove a Service record from the Gatekeeper database. 
			Any links from Users to the service will also be removed.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceDelete (@ServiceID int)
	As
		Begin
		  Delete PersonService
		  Where ServiceID = @ServiceID

		  Delete Service
		  Where ServiceID = @ServiceID
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
			Return details for a specific Service Status in the database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceStatusGet (@ServiceStatusID int) 
	As
		Begin
			Select Description, DisplayMessage, ServiceStatusID
				From ServiceStatus
				Where ServiceStatusID = @ServiceStatusID
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
			Returns a list of all service status' in the Gatekeeper database, 
			commonly used to generate a list on a user interface for selection purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceStatusList
	As
		Begin
		  Select ServiceStatusID, Description, DisplayMessage 
		  From ServiceStatus
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
			Used to add/update a Service Status record in the Gatekeeper database. 
			Will check for the existence of a record, before adding a new record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceStatusAdd (
		@ServiceStatusID int OUTPUT,
		@Description varchar(50),
		@DisplayMessage varchar(300)
	)
	As
		Begin
		  If @ServiceStatusID > 0 --Update!
		    Begin
		      Update ServiceStatus
		      Set Description = @Description,
		          DisplayMessage = @DisplayMessage
		      Where ServiceStatusID = @ServiceStatusID
		    End
		  Else  --Insert!
		    Begin
		      Insert Into ServiceStatus (Description, DisplayMessage)
		      Select @Description, @DisplayMessage
				
		      Select @ServiceStatusID = @@IDENTITY
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
			- Stored procedure for...
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	Create Procedure x_ServiceStatusUpdate (
		@ServiceID int,
		@Status varchar(15)
	)
	As
	Begin
	  Declare @ServiceStatusID int
	  
	  Select @ServiceStatusID = ServiceStatusID
	  From ServiceStatus
	  Where Description = @Status
	 
	  Update Service
	  Set ServiceStatusID = @ServiceStatusID
	  Where ServiceID = @ServiceID
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
			Used to delete a Service Status record from the database. 
			Validation will be done that the Service Status is not in use any more, 
			before the deletion will take place.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ServiceStatusDelete (
		@ServiceStatusID int,
		@Result varchar(25) Output
	)
	As
		Begin
		  If Exists (Select ServiceStatusID From Service
		             Where ServiceStatusID = @ServiceStatusID)
		    Begin
		      Select @Result = 'Cannot delete record - record in use.'
		    End
		  Else
		    Begin
		      Delete ServiceStatus
		      Where ServiceStatusID = @ServiceStatusID
		      Select @Result = ''
		    End
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO

