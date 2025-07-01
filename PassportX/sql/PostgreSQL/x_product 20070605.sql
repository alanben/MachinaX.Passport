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
	
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductServiceList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductServiceList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductUpdate]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductNotificationAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductNotificationAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductStatusGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductStatusGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductStatusList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductStatusList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductStatusDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductStatusDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductStatusAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductStatusAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ProductStatusUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_ProductStatusUpdate]
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
			Returns a list of all products in the Gatekeeper database. 
			Commonly used to generate a list on a user interface for selection purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductList
	As
		Begin
		  Select ProductID, ProductDesc = Product.Description, 
		         Product.ProductStatusID, ProductStatusDesc = ProductStatus.Description,
		         DisplayMessage
		  From Product
		  Inner Join ProductStatus On Product.ProductStatusID = ProductStatus.ProductStatusID
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
			Return details for a specific Product in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductGet (@ProductID int) 
	As
		Begin
		  Select Product.ProductID, ProductDesc = Product.Description,
		         Product.ProductStatusID, ProductStatusDesc = ProductStatus.Description,
		         DisplayMessage, URL, WSDLURL, Name, Namespace
		  From Product
		  Inner Join ProductStatus On Product.ProductStatusID = ProductStatus.ProductStatusID
			Left Outer Join ProductNotification On Product.ProductID = ProductNotification.ProductID
		  Where Product.ProductID = @ProductID
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
			Used to retrieve a list of all services related to a selected product.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductServiceList (@ProductID int)
	As
		Begin
		  Select Service.ProductID, ServiceID, ProductDesc = Product.Description, 
		         ServiceDesc = Service.Description, Service.ServiceStatusID,
		         ServiceStatusDesc = ServiceStatus.Description, DisplayMessage
		  From Service
		  Inner Join Product On Service.ProductID = Product.ProductID
		  Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
		  Where Service.ProductID = @ProductID
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
			Save a Product's details. 
			The database implementation will check for the existince of a record,
			and if not present will add it.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductAdd (
		@ProductID int OUTPUT,
		@Description varchar(100),
		@ProductStatusID int
	)
	As
		Begin
		  If @ProductID > 0  --Then Update!!
		    Begin
		      Update Product
		      Set Description = @Description,
		          ProductStatusID = @ProductStatusID
		      Where ProductID = @ProductID
		    End
		  Else
		    Begin
		      Insert Into Product (Description, ProductStatusID)
		      Select @Description, @ProductStatusID

		      Select @ProductID = @@IDENTITY
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
			Permanently removes a product from the Gatekeeper database. 
			Any links between Users and the selected product will also be removed. 
			Any services linked to the product will also be removed, as well as any 
			links to those services
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductDelete (@ProductID int)
	As
		Begin
		  Delete PersonService
		  From Service
		  Where Service.ProductID = @ProductID

		  Delete Service
		  Where ProductID = @ProductID

		  Delete PersonProduct
		  Where ProductID = @ProductID
		 
		  Delete Product
		  Where ProductID = @ProductID
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
			Lock/Unlock a Product 
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductUpdate (
		@ProductID int,
		@Status varchar(25)
	)
	As
		Begin
		  Update Product
		  Set ProductStatusID = ProductStatus.ProductStatusID
		  From ProductStatus 
		  Where ProductID = @ProductID
		    And ProductStatus.Description = @Status
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
			Add/update Product Notification details
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	Create Procedure x_ProductNotificationAdd (
		@ProductID Int, 
		@URL Varchar(200), 
		@WSDLURL Varchar(200), 
		@Name Varchar(100), 
		@Namespace Varchar(150)
	)
	As
		Begin
			If Exists(Select ProductID From ProductNotification Where ProductID = @ProductID)
			Begin
				Update ProductNotification
					Set URL = @URL,
							WSDLURL = @WSDLURL,
							Name = @Name,
							Namespace = @Namespace
				Where ProductID = @ProductID
			End
			Else
			Begin
				Insert Into ProductNotification
				(ProductID, URL, WSDLURL, Name, Namespace)
				Select @ProductID, @URL, @WSDLURL, @Name, @Namespace
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
			Return details for a specific Product Status in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductStatusGet (@ProductStatusID int)
	As
		Begin
		  Select Description, DisplayMessage, ProductStatusID
		  From ProductStatus
		  Where ProductStatusID = @ProductStatusID
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
			Returns a list of all product status' in the Gatekeeper database. 
			Commonly used to generate a list on a user interface for selection purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductStatusList
	As
		Begin
		  Select ProductStatusID, Description, DisplayMessage
		  From ProductStatus
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
			Used to delete a ProductStatus record from the database.
			Validation will be done that the Product Status is not in use any more, 
			before the deletion will take place.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductStatusDelete (
		@ProductStatusID int,
		@Result varchar(25) Output
	)
	As
		Begin
		  If Exists (Select ProductStatusID From Product
		             Where ProductStatusID = @ProductStatusID)
		    Begin
		      Select @Result = 'Cannot delete'
		    End
		  Else
		    Begin
		      Delete ProductStatus
		      Where ProductStatusID = @ProductStatusID
		      Select @Result = ''
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
			Used to add/update a ProductStatus record in the Gatekeeper database.
			Will check for the existence of a record, before adding a new record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_ProductStatusAdd (
		@ProductStatusID int OUTPUT,
		@Description varchar(50),
		@DisplayMessage varchar(300)
	)
	As
		Begin
		  If @ProductStatusID > 0 --Update!
		    Begin
		      Update ProductStatus
		      Set Description = @Description,
		          DisplayMessage = @DisplayMessage
		      Where ProductStatusID = @ProductStatusID
		    End
		  Else
		    Begin
		      Insert Into ProductStatus (Description, DisplayMessage)
		      Select @Description, @DisplayMessage
				
		      Select @ProductStatusID = @@IDENTITY
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
	Create Procedure x_ProductStatusUpdate (
		@ProductID int,
		@Status varchar(15)
	)
	As
		Begin
		  Declare @ProductStatusID int
		 
		  Select @ProductStatusID = ProductStatusID
		  From ProductStatus
		  Where Description = @Status
			
		  Update Product
		  Set ProductStatusID = @ProductStatusID
		  Where ProductID = @ProductID
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO
