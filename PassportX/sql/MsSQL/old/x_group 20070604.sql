/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20070604
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
	20070604:	Starting point from Gatekeeper
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Check and drop Procedure(s)
	-----------------------------------------------------------------------	*/
	
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupUpdate]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupGet]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupGets]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupGets]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupUserList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupUserList]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupServiceAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupServiceAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupServiceAddAlt]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupServiceAddAlt]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupServiceDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupServiceDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupServiceDeleteAlt]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupServiceDeleteAlt]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupProductAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupProductAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupProductDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupProductDelete]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupStatusAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupStatusAdd]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupDeleteStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupDeleteStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_GroupRightsList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[x_GroupRightsList]
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
			Used to add/update a Group record in the Gatekeeper database. 
			All Group descriptions must be unique. 
			The Group ID is assigned when the record is created in the database, 
			and will be returned to the user.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupAdd (
		@GroupID int OUTPUT,
		@Description varchar(100),
		@GroupStatusID int
	)
	As
		Begin
		  If @GroupID > 0 --Then Update!!
		  Begin
		    Update Groups
		    Set Description = @Description,
		        GroupStatusID = @GroupStatusID
		    Where GroupID = @GroupID
		  End
		  Else --Then Insert!!
		  Begin
		    Insert Into Groups (Description, GroupStatusID)
		      Select @Description, @GroupStatusID
			
		    Select @GroupID = @@IDENTITY
		  End
			Exec x_NotificationAdd @GroupID, 200
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
			Used to mark a Group record as deleted on the Gatekeeper database. 
			The record will NOT be physically removed from the database, but flagged as deleted/inactive.
			Used to restore a Group record that was previously deleted on the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupUpdate (
		@GroupID int, 
		@Status varchar(25)
	) 
	As
		Begin
			Declare @PrevStatus Varchar(50)
			Select @PrevStatus = GroupStatus.Description
				From GroupStatus
				Inner Join Groups On Groups.GroupStatusID = GroupStatus.GroupStatusID
				Where GroupID = @GroupID
				
			Update Groups
				Set GroupStatusID = GroupStatus.GroupStatusID
				From GroupStatus 
				Where GroupID = @GroupID
				And GroupStatus.Description = @Status

			If @Status = 'Deleted'
				Begin
					Exec x_NotificationAdd @GroupID, 201
				End
			If @Status = 'Active' And @PrevStatus = 'Deleted' -- Undelete Group
				Begin
					Exec x_NotificationAdd @GroupID, 202
				End
			If @Status = 'Locked'
				Begin
					Exec x_NotificationAdd @GroupID, 204
				End
			If @Status = 'Active' And @PrevStatus = 'Locked' -- Unlock Group
				Begin
					Exec x_NotificationAdd @GroupID, 205
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
			Used to completely delete a Group from the Gatekeeper database. 
			The system will also remove any links between any users and the group, and remove them as well.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupDelete (@GroupID int) 
	As
		Begin
			Delete PersonGroup Where GroupID = @GroupID
			Delete Groups Where GroupID = @GroupID
			Exec x_NotificationAdd @GroupID, 203
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
			Return details for a specific Group in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupGet (@GroupID int)
	As
		Begin
			Select GroupDesc = Groups.Description, Groups.GroupStatusID, GroupStatusDesc = GroupStatus.Description, Groups.GroupStatusID
				From Groups
				Inner Join GroupStatus On Groups.GroupStatusID = GroupStatus.GroupStatusID
				Where GroupID = @GroupID
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
			Returns a list of all groups in the Gatekeeper database.
			Commonly used to generate a list on a user interface for selection purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupGets
	As
		Begin
			Select GroupID, GroupName = Groups.Description, StatusID = Groups.GroupStatusID, Status = GroupStatus.Description
				From Groups
				Inner Join GroupStatus On Groups.GroupStatusID = GroupStatus.GroupStatusID
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
			Returns a list of all groups in the Gatekeeper database. 
			Commonly used to generate a list on a user interface for selection purposes.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupList
	As
		Begin
			Select GroupID, GroupDesc = Groups.Description, Groups.GroupStatusID, GroupStatusDesc = GroupStatus.Description
			From Groups
			Inner Join GroupStatus On Groups.GroupStatusID = GroupStatus.GroupStatusID
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
			Returns a list of users in a group.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupUserList (@GroupID int)
	As
		Begin
			Select Groups.GroupID, GroupDesc = Description, Person.PersonID, FirstName, Surname
				From Groups
				Inner Join PersonGroup On Groups.GroupID = PersonGroup.GroupID
				Inner Join Person On PersonGroup.PersonID = Person.PersonID
				Where Groups.GroupID = @GroupID
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
			Method used to link all users in a Group to a Service
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupServiceAdd (
		@GroupID int,
		@ServiceID int,
		@SecurityLevelID int
	)
	As
		Begin
			Insert Into PersonService (PersonID, ServiceID, SecurityLevelID, ServiceIdentifier)  
				Select PersonID, @ServiceID, @SecurityLevelID, ''
					From PersonGroup
					Where GroupID = @GroupID
					And PersonID NOT IN (Select PersonID From PersonService Where ServiceID = @ServiceID And SecurityLevelID = @SecurityLevelID)
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
			Method used to link all users in a Group to a Service
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupServiceAddAlt (
		@GroupID int,
		@ServiceID int,
		@SecurityLevelID int
	)
	As
		Begin
			Insert Into ProfileService (GroupID, ServiceID, SecurityLevelID)  
				Select @GroupID, @ServiceID, @SecurityLevelID
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
			Method used to remove the link between all users in a Group and a Service.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	Create Procedure x_GroupServiceDelete (
		@GroupID int,
		@ServiceID int
	)
	As
		Begin
			Delete PersonService
				From PersonGroup 
				Inner Join PersonService On PersonService.PersonID = PersonGroup.PersonID
				Where GroupID = @GroupID
				And ServiceID = @ServiceID
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
			Method used to remove the link between a Profile and a Service.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	Create Procedure x_GroupServiceDeleteAlt (
		@GroupID int,
		@ServiceID int,
		@SecurityLevelID int
	)
	As
		Begin
			Delete ProfileService
				Where GroupID = @GroupID
				And ServiceID = @ServiceID
				And SecurityLevelID = @SecurityLevelID
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
			Method used to link all users in a Group to a Product.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupProductAdd (
		@GroupID int,
		@ProductID int,
		@SecurityLevelID int
	)
	As
		Begin
			Insert Into PersonProduct (PersonID, ProductID, SecurityLevelID)
				Select PersonID, @ProductID, @SecurityLevelID
				From PersonGroup
				Where GroupID = @GroupID
					And PersonID NOT IN (Select PersonID From PersonProduct Where ProductID = @ProductID And SecurityLevelID = @SecurityLevelID)
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
			Method used to remove the link all users in a Group and a Product
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	Create Procedure x_GroupProductDelete (
		@GroupID int,
		@ProductID int
	)
	As
		Begin
			Delete PersonProduct
			From PersonGroup 
				Inner Join PersonProduct On PersonProduct.PersonID = PersonGroup.PersonID
				Where GroupID = @GroupID
				And ProductID = @ProductID
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
			Used to add/update a Group Status record in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupStatusAdd (
		@GroupStatusID int OUTPUT,
		@Description varchar(100)
	)
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
			Used to permanently remove a GroupStatus record from the Gatekeeper database. 
			The system will check that the record is no longer in use before attempting the delete.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupDeleteStatus (
		@GroupStatusID int,
		@Result varchar(25) Output
	)
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

	
	SET QUOTED_IDENTIFIER ON 
	GO
	SET ANSI_NULLS ON 
	GO
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to retrieve a list of all services related to a selected profile.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE Procedure x_GroupRightsList (@GroupID int)
	As
		Begin
			If @GroupID > 0 
				Select ProfileService.GroupID, GroupDesc = Groups.Description,
						Service.ProductID, ProductDesc = Product.Description, 
						ProfileService.ServiceID, ServiceDesc = Service.Description,
						ProfileService.SecurityLevelID, SecurityLevelDesc = SecurityLevel.Description
					From ProfileService
					Inner Join Groups On ProfileService.GroupID = Groups.GroupID
					Inner Join Service On ProfileService.ServiceID = Service.ServiceID
					Inner Join Product On Service.ProductID = Product.ProductID
					Inner Join SecurityLevel On ProfileService.SecurityLevelID = SecurityLevel.SecurityLevelID
					Where ProfileService.GroupID = @GroupID
					Order by ProfileService.GroupID, ServiceDesc, ProfileService.ServiceID
			Else
				Select ProfileService.GroupID, GroupDesc = Groups.Description,
						Service.ProductID, ProductDesc = Product.Description, 
						ProfileService.ServiceID, ServiceDesc = Service.Description,
						ProfileService.SecurityLevelID, SecurityLevelDesc = SecurityLevel.Description
					From ProfileService
					Inner Join Groups On ProfileService.GroupID = Groups.GroupID
					Inner Join Service On ProfileService.ServiceID = Service.ServiceID
					Inner Join Product On Service.ProductID = Product.ProductID
					Inner Join SecurityLevel On ProfileService.SecurityLevelID = SecurityLevel.SecurityLevelID
					Order by ProfileService.GroupID, ServiceDesc, ProfileService.ServiceID
		End
	GO
	SET QUOTED_IDENTIFIER OFF 
	GO
	SET ANSI_NULLS ON 
	GO
	
	
