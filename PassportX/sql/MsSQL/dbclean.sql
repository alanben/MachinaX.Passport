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
	20111003:	Starting point.
	20111212:	Moved to passport schema
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
USE [PassportX]
GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - UserX
	-----------------------------------------------------------------------	*/

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[GetUserName]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[GetUserName]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[GetUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[GetUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[UpdateUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[UpdateUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[AddUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[AddUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DeleteUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[DeleteUser]
	GO	


/*	-----------------------------------------------------------------------
	Check and drop - LinkLogX
	-----------------------------------------------------------------------	*/

/*	-----------------------------------------------------------------------
	Check AND drop Indexes AND Constraints
	-----------------------------------------------------------------------	*/
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LinkLog_Person]') AND parent_object_id = OBJECT_ID(N'[dbo].[LinkLog]'))
	ALTER TABLE [dbo].[LinkLog] DROP CONSTRAINT [FK_LinkLog_Person]
	GO

/*	-----------------------------------------------------------------------
	Check AND drop Tables
	-----------------------------------------------------------------------	*/
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LinkLog]') AND type IN (N'U'))
	DROP TABLE [dbo].[LinkLog]
	GO

/*	-------------------------
	Drop Procedures
	-------------------------	*/
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetLinkLog]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListLinkLogs]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ListLinkLogs]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndexLinkLogs]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[IndexLinkLogs]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchLinkLogs]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[SearchLinkLogs]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[AddLinkLog]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EditLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[EditLinkLog]
	GO

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteLinkLog]') AND type IN (N'P', N'PC'))
	DROP PROCEDURE [dbo].[DeleteLinkLog]
	GO

/*	-------------------------
	Drop Views
	-------------------------	*/
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[x_LinkLog]'))
	DROP VIEW [dbo].[x_LinkLog]
	GO


/*	-----------------------------------------------------------------------
	Check and drop - AccessX
	-----------------------------------------------------------------------	*/

/*	-----------------------------------------------------------------------
	Check AND DROP Indexes AND Constraints
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_PersonCollection_Group]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonCollection] DROP CONSTRAINT FK_PersonCollection_Group
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_PersonCollection_Person]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonCollection] DROP CONSTRAINT FK_PersonCollection_Person
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[[FK_RightsGroups_Categories]]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Rights_Groups] DROP CONSTRAINT [FK_RightsGroups_Categories]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[[FK_RightsGroups_Groups]]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Rights_Groups] DROP CONSTRAINT [FK_RightsGroups_Groups]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[[FK_RightsGroups_Levels]]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Rights_Groups] DROP CONSTRAINT [FK_RightsGroups_Levels]
	GO

/*	-----------------------------------------------------------------------
	Check AND DROP View(s)
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ServiceX_UserRights]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP view [dbo].[ServiceX_UserRights]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ServiceX_AdminUser]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP view [dbo].[ServiceX_AdminUser]
	GO	

	
/*	-----------------------------------------------------------------------
	Check AND DROP Tables
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[Collections]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [dbo].[Collections]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PersonCollection]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [dbo].[PersonCollection]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[Rights_Groups]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [dbo].[Rights_Groups]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[Rights_Categories]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [dbo].[Rights_Categories]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[Rights_Levels]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP table [dbo].[Rights_Levels]
	GO


/*	-----------------------------------------------------------------------
	Check AND DROP PROCEDURE(s)
	-----------------------------------------------------------------------	*/
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListCollections]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListCollections]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[GetCollection]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[GetCollection]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListCollectionsUsersAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListCollectionsUsersAll]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DeleteCollectionUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[DeleteCollectionUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[GetGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[GetGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListGroups]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListGroups]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[AddGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[AddGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[EditGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[EditGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DeleteGroup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[DeleteGroup]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[AddAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[AddAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListAdminUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListAdminUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[GetAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[GetAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DeleteAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[DeleteAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[UpdateAdminUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[UpdateAdminUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListGroupsUsersAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListGroupsUsersAll]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[AddGroupUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[AddGroupUser]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DeleteGroupUsers]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[DeleteGroupUsers]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[AddGroupCategory]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[AddGroupCategory]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DeleteGroupCategories]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[DeleteGroupCategories]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListRightsCategoriesAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListRightsCategoriesAll]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[ListUserRights]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ListUserRights]
	GO	



/*	-----------------------------------------------------------------------
	Check and drop procedures - x_config
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ConfigAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ConfigAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ConfigDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ConfigDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ConfigGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ConfigGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ConfigList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ConfigList]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - x_notify
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_NotificationGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_NotificationGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_NotificationAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_NotificationAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_NotificationUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_NotificationUpdate]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - x_group
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupGets]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupGets]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupUserList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupUserList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupServiceAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupServiceAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupServiceAddAlt]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupServiceAddAlt]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupServiceDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupServiceDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupServiceDeleteAlt]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupServiceDeleteAlt]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupProductAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupProductAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupProductDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupProductDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupDeleteStatus]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupDeleteStatus]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupRightsList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupRightsList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupStatusList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupStatusList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_GroupStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_GroupStatusDelete]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - x_product
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductServiceList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductServiceList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductNotificationAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductNotificationAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductStatusList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductStatusList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductStatusDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ProductStatusUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ProductStatusUpdate]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - x_questions
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_QuestionGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_QuestionGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_QuestionList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_QuestionList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_QuestionDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_QuestionDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_QuestionAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_QuestionAdd]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - x_recruit
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_RecruitGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_RecruitGet]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_RecruitAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_RecruitAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_RecruitDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_RecruitDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_RecruitUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_RecruitUpdate]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - x_security
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_SecurityLevelGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_SecurityLevelGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_SecurityLevelAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_SecurityLevelAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_SecurityLevelList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_SecurityLevelList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_SecurityLevelDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_SecurityLevelDelete]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - x_service
	-----------------------------------------------------------------------	*/
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceUpdate]
	GO


	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceStatusList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceStatusList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceStatusDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_ServiceStatusUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_ServiceStatusUpdate]
	GO
	

/*	-----------------------------------------------------------------------
	Check and drop procedures - x_user
	-----------------------------------------------------------------------	*/

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_User]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP view [dbo].[x_User]
	GO	


	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserGet]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserGetID]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserGetID]
	GO	

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserLogin]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserLogin]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserLogout]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserLogout]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserLoginOld]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserLoginOld]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserLoginAlt]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserLoginAlt]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserPasswordExpire]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserPasswordExpire]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserQuestionValidate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserQuestionValidate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserStatusDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserStatusDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserGroupDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserGroupDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserProductDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserProductDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserServiceDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserServiceDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserServiceList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserServiceList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserStatusGet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserStatusGet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserStatusGetList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserStatusGetList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserStatusAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserStatusAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserAnswerAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserAnswerAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserGroupAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserGroupAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserProductAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserProductAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserServiceAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserServiceAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserStatusUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserStatusUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserValidate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserValidate]
	GO
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserValidateOnly]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserValidateOnly]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserLockClear]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserLockClear]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserProfileDelete]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserProfileDelete]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserGetName]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserGetName]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserListPaged]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserListPaged]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserListPagedSorted]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserListPagedSorted]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserProfileList]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserProfileList]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserProfileAdd]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserProfileAdd]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserSearch]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserSearch]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserSearchAdvanced]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserSearchAdvanced]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserLockSet]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserLockSet]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserPasswordUpdate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserPasswordUpdate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_Validate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_Validate]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserFind]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserFind]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserFindAdvanced]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserFindAdvanced]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserPassword]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserPassword]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserLoginGetName]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserLoginGetName]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserSetLoginFail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserSetLoginFail]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserSetLoginOK]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserSetLoginOK]
	GO

	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[x_UserGetAll]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[x_UserGetAll]
	GO


/*	-----------------------------------------------------------------------
	Check and drop procedures - dbcore
	-----------------------------------------------------------------------	*/
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Activity_ActivityLog]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ActivityLog] DROP CONSTRAINT FK_Activity_ActivityLog
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GroupStatus_Groups]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Groups] DROP CONSTRAINT FK_GroupStatus_Groups
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Person_PersonStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Person] DROP CONSTRAINT FK_Person_PersonStatus
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_ProductStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Product] DROP CONSTRAINT FK_Product_ProductStatus
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Question_Answer_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Answer] DROP CONSTRAINT Question_Answer_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonProduct_SecurityLevel]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_SecurityLevel
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonService_SecurityLevel]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonService] DROP CONSTRAINT FK_PersonService_SecurityLevel
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GroupService_SecurityLevel]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProfileService] DROP CONSTRAINT FK_GroupService_SecurityLevel
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Service_ServiceStatus]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Service] DROP CONSTRAINT FK_Service_ServiceStatus
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonGroup_Group]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonGroup] DROP CONSTRAINT FK_PersonGroup_Group
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GroupService_Group]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProfileService] DROP CONSTRAINT FK_GroupService_Group
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Person_ActivityLog]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ActivityLog] DROP CONSTRAINT FK_Person_ActivityLog
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Person_Answer_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Answer] DROP CONSTRAINT Person_Answer_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonGroup_Person]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonGroup] DROP CONSTRAINT FK_PersonGroup_Person
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonProduct_Person]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_Person
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonService_Person]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonService] DROP CONSTRAINT FK_PersonService_Person
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Product_Notification]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Notification] DROP CONSTRAINT FK_Product_Notification
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PersonProduct_Product]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonProduct] DROP CONSTRAINT FK_PersonProduct_Product
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProductNotification_Product]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProductNotification] DROP CONSTRAINT FK_ProductNotification_Product
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Product_Service_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[Service] DROP CONSTRAINT Product_Service_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Service_ActivityLog_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ActivityLog] DROP CONSTRAINT Service_ActivityLog_FK1
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Service_PersonService]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[PersonService] DROP CONSTRAINT FK_Service_PersonService
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Service_GroupService]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[ProfileService] DROP CONSTRAINT FK_Service_GroupService
	GO

/*	-----------------------------------------------------------------------
	Check and drop Tables
	-----------------------------------------------------------------------	*/
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ActivityLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ActivityLog]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonService]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonService]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProfileService]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ProfileService]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Answer]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Answer]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Notification]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Notification]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonGroup]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonGroup]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonProduct]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonProduct]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProductNotification]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ProductNotification]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Service]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Service]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Groups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Groups]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Person]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Person]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Product]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Product]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Activity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Activity]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Config]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Config]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GroupCount]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[GroupCount]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GroupStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[GroupStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PersonStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProductStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ProductStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Question]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Question]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SecurityLevel]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[SecurityLevel]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ServiceStatus]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ServiceStatus]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Recruit]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Recruit]
	GO

	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecruitType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RecruitType]
	GO
