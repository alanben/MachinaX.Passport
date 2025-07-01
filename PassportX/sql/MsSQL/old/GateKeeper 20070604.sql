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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[act_RptUserActivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[act_RptUserActivity]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[act_RptUserActivityByMonth]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[act_RptUserActivityByMonth]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[act_RptUserActivityLoginByMonth]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[act_RptUserActivityLoginByMonth]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[act_RptUserActivityService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[act_RptUserActivityService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delActivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delActivity]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delGroupService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delGroupService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delSecurityLevel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delSecurityLevel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delUserService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delUserService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getPersonServiceList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getPersonServiceList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insGroupService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insGroupService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insPerson]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insPerson]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insUserService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insUserService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_logActivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_logActivity]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updPerson]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updPerson]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updPersonStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updPersonStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_validatePerson]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_validatePerson]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_DelProfileService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_DelProfileService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_DelUserProfile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_DelUserProfile]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetProductService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetProductService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetProductServiceList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetProductServiceList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetProfileRightsList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetProfileRightsList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_InsPersonFromUsers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_InsPersonFromUsers]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_InsProfileService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_InsProfileService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ActivityDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_ActivityDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ActivityLog]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_ActivityLog]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UpdateGroupService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UpdateGroupService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserProfileDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserProfileDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserServiceAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserServiceAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserServiceDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserServiceDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserServiceList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserServiceList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserStatusUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserStatusUpdate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserUpdate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserValidate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_ValidateUserQuestion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_ValidateUserQuestion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delGroupProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delGroupProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delQuestion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delQuestion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delServiceStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delServiceStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delUserGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delUserGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delUserProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delUserProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getGroupMemberList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getGroupMemberList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getNotification]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getNotification]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getProductServiceList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getProductServiceList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getServiceList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getServiceList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insGroupProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insGroupProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insNotification]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insNotification]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insProductNotification]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insProductNotification]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insUserAnswer]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insUserAnswer]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insUserGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insUserGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insUserProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insUserProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updNotification]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updNotification]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updService]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updServiceStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updServiceStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetPersonList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetPersonList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetPersonProfiles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetPersonProfiles]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetProductServiceRightList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetProductServiceRightList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_InsUserProfile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_InsUserProfile]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_SearchPersonList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_SearchPersonList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_SearchPersonListAdvanced]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_SearchPersonListAdvanced]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserAnswerAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserAnswerAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserFind]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserFind]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserFindAdvanced]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserFindAdvanced]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserGroupAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserGroupAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserGroupDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserGroupDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserProductAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserProductAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserProductDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserProductDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserProfileAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserProfileAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserProfileList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserProfileList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserQuestionValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserQuestionValidate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserSearch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserSearch]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserSearchAdvanced]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserSearchAdvanced]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_ExpirePassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_ExpirePassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delGroupStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delGroupStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delPersonStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delPersonStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delProductStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delProductStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getGroupList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getGroupList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getPassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getPassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getPerson]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getPerson]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getProductList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getProductList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_loginUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_loginUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_logoutUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_logoutUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updPassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updPassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updProduct]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updProduct]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updProductStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updProductStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_updUserStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_updUserStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[nm_LoginUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[nm_LoginUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tsp_logoutUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[tsp_logoutUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_ClearLock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_ClearLock]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetGroup]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetGroups]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetPassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetPassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetPerson]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetPerson]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetPersonName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetPersonName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetProfileList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetProfileList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_LoginUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_LoginUser]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_ResetPerson]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_ResetPerson]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_SetLock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_SetLock]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_UpdatePassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_UpdatePassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_Validate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_Validate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserGet]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserGetName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserGetName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserLockClear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserLockClear]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserLockSet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserLockSet]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserLogin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserLogin]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserLoginAlt]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserLoginAlt]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserLoginOld]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserLoginOld]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserLogout]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserLogout]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserPassword]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserPassword]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserPasswordExpire]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserPasswordExpire]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserPasswordUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserPasswordUpdate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserStatusDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserStatusDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_Validate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_Validate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_delConfig]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_delConfig]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getActivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getActivity]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getActivityList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getActivityList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getConfig]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getConfig]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getConfigList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getConfigList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getGroupStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getGroupStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getGroupStatusList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getGroupStatusList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getPersonStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getPersonStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getPersonStatusList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getPersonStatusList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getProductStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getProductStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getProductStatusList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getProductStatusList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getQuestion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getQuestion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getQuestionList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getQuestionList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getSecurityLevel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getSecurityLevel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getSecurityLevelList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getSecurityLevelList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getServiceStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getServiceStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getServiceStatusList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getServiceStatusList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insActivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insActivity]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insConfig]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insConfig]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insGroupStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insGroupStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insPersonStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insPersonStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insProductStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insProductStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insQuestion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insQuestion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insSecurityLevel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insSecurityLevel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_insServiceStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_insServiceStatus]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ActivityAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_ActivityAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ActivityGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_ActivityGet]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ActivityList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_ActivityList]
GO

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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserStatusAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserStatusAdd]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserStatusGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserStatusGet]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserStatusGetList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserStatusGetList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[jtsp_getActivityLog]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[jtsp_getActivityLog]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetPersonPagedList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetPersonPagedList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[um_GetPersonPagedSortedList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[um_GetPersonPagedSortedList]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_ActivityLogGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_ActivityLogGet]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserListPaged]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserListPaged]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[x_UserListPagedSorted]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[x_UserListPagedSorted]
GO

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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Users]
GO

CREATE TABLE [dbo].[Activity] (
	[ActivityID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Config] (
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RetValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[GroupCount] (
	[Count] [int] NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[GroupStatus] (
	[GroupStatusID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PersonStatus] (
	[PersonStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProductStatus] (
	[ProductStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DisplayMessage] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Question] (
	[QuestionID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SecurityLevel] (
	[SecurityLevelID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ServiceStatus] (
	[ServiceStatusID] [tinyint] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DisplayMessage] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Users] (
	[CustDealStaff] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UserName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Surname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Option] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TelNo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CellPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Groups] (
	[GroupID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[GroupStatusID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Person] (
	[PersonID] [int] IDENTITY (1, 1) NOT NULL ,
	[UserName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Surname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EMail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TelNo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CellPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Token] [uniqueidentifier] NULL ,
	[TokenExpiryDate] [smalldatetime] NULL ,
	[PersonStatusID] [tinyint] NULL ,
	[LoginFailures] [tinyint] NULL ,
	[PasswordExpiryDate] [datetime] NOT NULL ,
	[LastLoginDate] [datetime] NULL ,
	[LoginFailureDate] [datetime] NULL ,
	[AccLockedDate] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Product] (
	[ProductID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ProductStatusID] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Answer] (
	[QuestionID] [int] NOT NULL ,
	[PersonID] [int] NOT NULL ,
	[Answer] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Notification] (
	[PersonID] [int] NOT NULL ,
	[ProductID] [int] NOT NULL ,
	[DateInserted] [datetime] NOT NULL ,
	[DateSent] [datetime] NULL ,
	[Code] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PersonGroup] (
	[PersonID] [int] NOT NULL ,
	[GroupID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PersonProduct] (
	[PersonID] [int] NOT NULL ,
	[ProductID] [int] NOT NULL ,
	[SecurityLevelID] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProductNotification] (
	[ProductID] [int] NOT NULL ,
	[URL] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[WSDLURL] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Namespace] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Service] (
	[ServiceID] [int] IDENTITY (1, 1) NOT NULL ,
	[ProductID] [int] NOT NULL ,
	[ServiceStatusID] [tinyint] NOT NULL ,
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ActivityLog] (
	[ActivityLogID] [int] IDENTITY (1, 1) NOT NULL ,
	[ActivityID] [int] NOT NULL ,
	[ServiceID] [int] NULL ,
	[Token] [uniqueidentifier] NOT NULL ,
	[PersonID] [int] NOT NULL ,
	[ActivityDate] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PersonService] (
	[PersonID] [int] NOT NULL ,
	[ServiceID] [int] NOT NULL ,
	[SecurityLevelID] [int] NOT NULL ,
	[ServiceIdentifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProfileService] (
	[GroupID] [int] NOT NULL ,
	[ServiceID] [int] NOT NULL ,
	[SecurityLevelID] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Activity] WITH NOCHECK ADD 
	CONSTRAINT [Activity_PK] PRIMARY KEY  CLUSTERED 
	(
		[ActivityID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Config] WITH NOCHECK ADD 
	CONSTRAINT [Config_PK] PRIMARY KEY  CLUSTERED 
	(
		[Description]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[GroupStatus] WITH NOCHECK ADD 
	CONSTRAINT [PK_GroupStatus] PRIMARY KEY  CLUSTERED 
	(
		[GroupStatusID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PersonStatus] WITH NOCHECK ADD 
	CONSTRAINT [PK_PersonStatus] PRIMARY KEY  CLUSTERED 
	(
		[PersonStatusID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProductStatus] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProductStatus] PRIMARY KEY  CLUSTERED 
	(
		[ProductStatusID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Question] WITH NOCHECK ADD 
	CONSTRAINT [Question_PK] PRIMARY KEY  CLUSTERED 
	(
		[QuestionID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SecurityLevel] WITH NOCHECK ADD 
	CONSTRAINT [PK_SecurityLevel] PRIMARY KEY  CLUSTERED 
	(
		[SecurityLevelID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ServiceStatus] WITH NOCHECK ADD 
	CONSTRAINT [PK_ServiceStatus] PRIMARY KEY  CLUSTERED 
	(
		[ServiceStatusID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Groups] WITH NOCHECK ADD 
	CONSTRAINT [PK_Group] PRIMARY KEY  CLUSTERED 
	(
		[GroupID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Person] WITH NOCHECK ADD 
	CONSTRAINT [PK_Person] PRIMARY KEY  CLUSTERED 
	(
		[PersonID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Product] WITH NOCHECK ADD 
	CONSTRAINT [PK_Product] PRIMARY KEY  CLUSTERED 
	(
		[ProductID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Answer] WITH NOCHECK ADD 
	CONSTRAINT [PK_Answer] PRIMARY KEY  CLUSTERED 
	(
		[PersonID],
		[QuestionID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PersonGroup] WITH NOCHECK ADD 
	CONSTRAINT [PK_PersonGroup] PRIMARY KEY  CLUSTERED 
	(
		[PersonID],
		[GroupID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PersonProduct] WITH NOCHECK ADD 
	CONSTRAINT [PK_PersonProduct] PRIMARY KEY  CLUSTERED 
	(
		[ProductID],
		[PersonID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProductNotification] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProductNotification] PRIMARY KEY  CLUSTERED 
	(
		[ProductID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Service] WITH NOCHECK ADD 
	CONSTRAINT [PK_Service] PRIMARY KEY  CLUSTERED 
	(
		[ServiceID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ActivityLog] WITH NOCHECK ADD 
	CONSTRAINT [PK_ActivityLog] PRIMARY KEY  CLUSTERED 
	(
		[ActivityLogID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PersonService] WITH NOCHECK ADD 
	CONSTRAINT [PK_PersonService] PRIMARY KEY  CLUSTERED 
	(
		[PersonID],
		[ServiceID],
		[SecurityLevelID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProfileService] WITH NOCHECK ADD 
	CONSTRAINT [PK_GroupService] PRIMARY KEY  CLUSTERED 
	(
		[GroupID],
		[ServiceID],
		[SecurityLevelID]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Notification] WITH NOCHECK ADD 
	CONSTRAINT [DF__Notificat__DateI__114A936A] DEFAULT (getdate()) FOR [DateInserted]
GO

 CREATE  UNIQUE  INDEX [UDX_Group] ON [dbo].[Groups]([Description]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [idx_Token] ON [dbo].[Person]([Token]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

ALTER TABLE [dbo].[Groups] ADD 
	CONSTRAINT [FK_GroupStatus_Groups] FOREIGN KEY 
	(
		[GroupStatusID]
	) REFERENCES [dbo].[GroupStatus] (
		[GroupStatusID]
	)
GO

ALTER TABLE [dbo].[Person] ADD 
	CONSTRAINT [FK_Person_PersonStatus] FOREIGN KEY 
	(
		[PersonStatusID]
	) REFERENCES [dbo].[PersonStatus] (
		[PersonStatusID]
	)
GO

ALTER TABLE [dbo].[Product] ADD 
	CONSTRAINT [FK_Product_ProductStatus] FOREIGN KEY 
	(
		[ProductStatusID]
	) REFERENCES [dbo].[ProductStatus] (
		[ProductStatusID]
	)
GO

ALTER TABLE [dbo].[Answer] ADD 
	CONSTRAINT [Person_Answer_FK1] FOREIGN KEY 
	(
		[PersonID]
	) REFERENCES [dbo].[Person] (
		[PersonID]
	),
	CONSTRAINT [Question_Answer_FK1] FOREIGN KEY 
	(
		[QuestionID]
	) REFERENCES [dbo].[Question] (
		[QuestionID]
	)
GO

ALTER TABLE [dbo].[Notification] ADD 
	CONSTRAINT [FK_Product_Notification] FOREIGN KEY 
	(
		[ProductID]
	) REFERENCES [dbo].[Product] (
		[ProductID]
	)
GO

ALTER TABLE [dbo].[PersonGroup] ADD 
	CONSTRAINT [FK_PersonGroup_Group] FOREIGN KEY 
	(
		[GroupID]
	) REFERENCES [dbo].[Groups] (
		[GroupID]
	),
	CONSTRAINT [FK_PersonGroup_Person] FOREIGN KEY 
	(
		[PersonID]
	) REFERENCES [dbo].[Person] (
		[PersonID]
	)
GO

ALTER TABLE [dbo].[PersonProduct] ADD 
	CONSTRAINT [FK_PersonProduct_Person] FOREIGN KEY 
	(
		[PersonID]
	) REFERENCES [dbo].[Person] (
		[PersonID]
	),
	CONSTRAINT [FK_PersonProduct_Product] FOREIGN KEY 
	(
		[ProductID]
	) REFERENCES [dbo].[Product] (
		[ProductID]
	),
	CONSTRAINT [FK_PersonProduct_SecurityLevel] FOREIGN KEY 
	(
		[SecurityLevelID]
	) REFERENCES [dbo].[SecurityLevel] (
		[SecurityLevelID]
	)
GO

ALTER TABLE [dbo].[ProductNotification] ADD 
	CONSTRAINT [FK_ProductNotification_Product] FOREIGN KEY 
	(
		[ProductID]
	) REFERENCES [dbo].[Product] (
		[ProductID]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [dbo].[Service] ADD 
	CONSTRAINT [FK_Service_ServiceStatus] FOREIGN KEY 
	(
		[ServiceStatusID]
	) REFERENCES [dbo].[ServiceStatus] (
		[ServiceStatusID]
	),
	CONSTRAINT [Product_Service_FK1] FOREIGN KEY 
	(
		[ProductID]
	) REFERENCES [dbo].[Product] (
		[ProductID]
	)
GO

ALTER TABLE [dbo].[ActivityLog] ADD 
	CONSTRAINT [FK_Activity_ActivityLog] FOREIGN KEY 
	(
		[ActivityID]
	) REFERENCES [dbo].[Activity] (
		[ActivityID]
	),
	CONSTRAINT [FK_Person_ActivityLog] FOREIGN KEY 
	(
		[PersonID]
	) REFERENCES [dbo].[Person] (
		[PersonID]
	),
	CONSTRAINT [Service_ActivityLog_FK1] FOREIGN KEY 
	(
		[ServiceID]
	) REFERENCES [dbo].[Service] (
		[ServiceID]
	)
GO

ALTER TABLE [dbo].[PersonService] ADD 
	CONSTRAINT [FK_PersonService_Person] FOREIGN KEY 
	(
		[PersonID]
	) REFERENCES [dbo].[Person] (
		[PersonID]
	),
	CONSTRAINT [FK_PersonService_SecurityLevel] FOREIGN KEY 
	(
		[SecurityLevelID]
	) REFERENCES [dbo].[SecurityLevel] (
		[SecurityLevelID]
	),
	CONSTRAINT [FK_Service_PersonService] FOREIGN KEY 
	(
		[ServiceID]
	) REFERENCES [dbo].[Service] (
		[ServiceID]
	)
GO

ALTER TABLE [dbo].[ProfileService] ADD 
	CONSTRAINT [FK_GroupService_Group] FOREIGN KEY 
	(
		[GroupID]
	) REFERENCES [dbo].[Groups] (
		[GroupID]
	),
	CONSTRAINT [FK_GroupService_SecurityLevel] FOREIGN KEY 
	(
		[SecurityLevelID]
	) REFERENCES [dbo].[SecurityLevel] (
		[SecurityLevelID]
	),
	CONSTRAINT [FK_Service_GroupService] FOREIGN KEY 
	(
		[ServiceID]
	) REFERENCES [dbo].[Service] (
		[ServiceID]
	)
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO









/* Object: Stored procedure */
CREATE Procedure jtsp_getActivityLog --1, '25 Jan 2002', '31 Dec 2002'
(@UserID int,
 @FromDateTime varchar(25),
 @ToDateTime varchar(25),
 @ProductDesc Varchar(100),
 @ServiceDesc Varchar(100))
As
-- Retrieve activity details. All parameters are optional, but at least the User ID or From Date must be specified.
Begin
  Declare @SQLWhere Varchar(3000)
  Declare @SQLSelect Varchar(1000)
  Declare @ORDERBYCOL Varchar(50)
  Declare @ORDERBYDIR Varchar(5)

	Set NoCount On
  Select @SQLWhere = ''

  Create Table #tmpActivityLog
  (tmpActivityLogID Int Identity(1,1) Not Null,
   ActivityID int,
   ServiceID int,
   PersonID int,
   ActivityDate varchar(25),
   FirstName varchar(50),
   Surname varchar(50),
   Email varchar(50),
   Token Varchar(50),
   ServiceDescription varchar(100),
   ActivityDescription varchar(100))

  Set @SQLSelect = 'Insert Into #tmpActivityLog '
  Set @SQLSelect = @SQLSelect + '(ActivityID, ServiceID, PersonID, ActivityDate, FirstName, Surname, Email, Token, ServiceDescription, ActivityDescription)'
  Set @SQLSelect = @SQLSelect + 'Select ActivityLog.ActivityID, ActivityLog.ServiceID, ActivityLog.PersonID, ActivityDate, FirstName, Surname, Email, ActivityLog.Token, Service.Description, Activity.Description'
  Set @SQLSelect = @SQLSelect + ' From ActivityLog '  
  Set @SQLSelect = @SQLSelect + 'Inner Join Person On ActivityLog.PersonID = Person.PersonID '
  Set @SQLSelect = @SQLSelect + 'Inner Join Activity On ActivityLog.ActivityID = Activity.ActivityID '
  Set @SQLSelect = @SQLSelect + 'Inner Join Service On ActivityLog.ServiceID = Service.ServiceID '
  Set @SQLSelect = @SQLSelect + 'Inner Join Product On Product.ProductID = Service.ProductID '

  If @UserID > 0 --Specific User's details! 
  Begin
    Set @SQLWhere = 'Where ActivityLog.PersonID = ' + Convert(Varchar(5), @UserID)
  End

  If @FromDateTime <> '' --Specify Begin and End dates!!
  Begin
    If @SQLWhere = ''
    Begin
      Set @SQLWhere = 'Where CONVERT(Varchar(25), ActivityLog.ActivityDate) Between ' + '''' + @FromDateTime + '''' + ' And ' + '''' + @ToDateTime + ''''
    End
    Else
    Begin
      Set @SQLWhere = @SQLWhere + ' And CONVERT(Varchar(25), ActivityLog.ActivityDate) Between ' + '''' + @FromDateTime + '''' + ' And ' + '''' + @ToDateTime + ''''
    End 
  End

	If @ProductDesc <> '' And @ProductDesc IS NOT NULL
	Begin
		If @SQLWhere = ''
		Begin
			Select @SQLWhere = 'Where Product.Description = ''' + @ProductDesc + ''''
		End
		Else
		Begin
			Select @SQLWhere = @SQLWhere + 'And Product.Description = ''' + @ProductDesc + ''''
		End
	End

	If @ServiceDesc <> '' And @ServiceDesc IS NOT NULL
	Begin
		If @SQLWhere = ''
		Begin
			Select @SQLWhere = 'Where Service.Description = ''' + @ServiceDesc + ''''
		End
		Else
		Begin
			Select @SQLWhere = @SQLWhere + 'And Service.Description = ''' + @ServiceDesc + ''''
		End
	End

  EXEC (@SQLSelect + @SQLWhere)  

	Set NoCount Off

  Select PersonID, ActivityDate, FirstName, Surname, Email, Token,
         ServiceID, ServiceDescription, ActivityDescription
  From #tmpActivityLog

  Drop Table #tmpActivityLog

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

CREATE Procedure um_GetPersonPagedList (
		@GroupID int,
		@StartRow int,
		@NumberRows int
	)
		/*	-----------------------------------------------------------------------
			Procedure: um_GetPersonPagedList
				- Retrieves users within a group (or all).
			Parameters:
				@GroupID:		Group identifier
			Returns:
				0:	Success
				n:	Some error condition
			-----------------------------------------------------------------------	*/
	As
		Begin
			Declare	@TotalRows int
			CREATE TABLE #UserTemp (
				[RowID] [int] IDENTITY (1, 1) NOT NULL ,
				[PersonID] [int],
				[UserName] [varchar] (30)  ,
				[FirstName] [varchar] (50)  ,
				[Surname] [varchar] (50)  ,
				[EMail] [varchar] (50)  ,
				[TelNo] [varchar] (35)  ,
				[CellPhone] [varchar] (20)  ,
				[Status] [varchar] (50)  ,
				[GroupID] [int],
				[GroupName] [varchar] (100)  ,
				CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
			)
			
			If @GroupID > 0 
				Insert into #UserTemp (
					[PersonID] , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					[Status] ,
					GroupID ,
					GroupName)
				select 
					Person.PersonID , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					Status = PersonStatus.Description ,
					@GroupID ,
					GroupName = Groups.Description
				from Person 
					inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
				  	inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
					inner Join Groups On PersonGroup.GroupID = Groups.GroupID
				  	where PersonGroup.GroupID = @GroupID
						and Person.PersonID > 5
					order by Person.PersonID
			Else
				Insert into #UserTemp (
					[PersonID] , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					[Status] ,
					GroupID )
				select 
					Person.PersonID , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					Status = PersonStatus.Description,
					@GroupID
				from Person 
					inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					where Person.PersonID > 5
				order by Person.PersonID
			
			Set @TotalRows = @@ROWCOUNT
			
			Select * from #UserTemp 
				where RowID between @StartRow and @StartRow + @NumberRows - 1
				order by RowID
			
			Drop table #UserTemp
			
			Select TotalRows = @TotalRows
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

CREATE Procedure um_GetPersonPagedSortedList (
		@GroupID int,
		@ColumnName varchar(30),
		@StartRow int,
		@NumberRows int)
		/*	-----------------------------------------------------------------------
			Procedure: um_GetPersonPagedSortedList
				- Retrieves users within a group (or all).
			Parameters:
				@GroupID:		Group identifier
			Returns:
				0:	Success
				n:	Some error condition
			-----------------------------------------------------------------------	*/
	As
		Begin
		
			Declare	@TotalRows int
			Declare @SQLSelect Varchar(1000)
			Declare @SQLOrder Varchar(200)
			Declare @SQLWhere Varchar(200)
			
			CREATE TABLE #UserTemp (
				[RowID] [int] IDENTITY (1, 1) NOT NULL ,
				[PersonID] [int],
				[UserName] [varchar] (30)  ,
				[FirstName] [varchar] (50)  ,
				[Surname] [varchar] (50)  ,
				[EMail] [varchar] (50)  ,
				[TelNo] [varchar] (35)  ,
				[CellPhone] [varchar] (20)  ,
				[Status] [varchar] (50)  ,
				[GroupID] [int],
				[GroupName] [varchar] (100)  ,
				CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
			)
			Set @SQLSelect = 'Insert into #UserTemp ([PersonID], [UserName], [FirstName], [Surname], [EMail], [TelNo], [CellPhone], [Status]'
			if @GroupID > 0
				Set @SQLSelect = @SQLSelect + ', GroupID, GroupName ) '
			else
				Set @SQLSelect = @SQLSelect + ') '
			
			Set @SQLSelect = @SQLSelect + 'select Person.PersonID ,[UserName] ,[FirstName] ,[Surname] ,[EMail] ,[TelNo] ,[CellPhone], Status = PersonStatus.Description '
			if @GroupID > 0
				Set @SQLSelect = @SQLSelect + ', PersonGroup.GroupID, GroupName = Groups.Description '
			
			Set @SQLSelect = @SQLSelect + 'from Person inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID '
			if @GroupID > 0
				begin
					Set @SQLSelect = @SQLSelect + 'inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID '
					Set @SQLSelect = @SQLSelect + 'inner Join Groups On PersonGroup.GroupID = Groups.GroupID '
				end
			
			if @GroupID > 0
				begin
					Set @SQLWhere = 'where PersonGroup.GroupID = ' + Convert(Varchar(5), @GroupID)
					Set @SQLWhere = @SQLWhere + 'and Person.PersonID > 5'
				end
			else
				Set @SQLWhere = 'where Person.PersonID > 5'
			
			Set @SQLOrder = ' order by '
			Set @SQLOrder = @SQLOrder + @ColumnName
			
			EXEC (@SQLSelect + @SQLWhere + @SQLOrder)  
			
			Set @TotalRows = @@ROWCOUNT
			
			Select * from #UserTemp 
				where RowID between @StartRow and @StartRow + @NumberRows - 1
				order by RowID
			
			Drop table #UserTemp
			Select TotalRows = @TotalRows
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

CREATE Procedure x_ActivityLogGet (--1, '25 Jan 2002', '31 Dec 2002'
		@UserID int,
		@FromDateTime varchar(25),
		@ToDateTime varchar(25),
		@ProductDesc Varchar(100),
		@ServiceDesc Varchar(100)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieve activity details. All parameters are optional, but at least the User ID or From Date must be specified.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @SQLWhere Varchar(3000)
			Declare @SQLSelect Varchar(1000)
			Declare @ORDERBYCOL Varchar(50)
			Declare @ORDERBYDIR Varchar(5)

			Set NoCount On
			Select @SQLWhere = ''

			Create Table #tmpActivityLog (
				tmpActivityLogID Int Identity(1,1) Not Null,
				ActivityID int,
				ServiceID int,
				PersonID int,
				ActivityDate varchar(25),
				FirstName varchar(50),
				Surname varchar(50),
				Email varchar(50),
				Token Varchar(50),
				ServiceDescription varchar(100),
				ActivityDescription varchar(100)
			)
			
			Set @SQLSelect = 'Insert Into #tmpActivityLog '
			Set @SQLSelect = @SQLSelect + '(ActivityID, ServiceID, PersonID, ActivityDate, FirstName, Surname, Email, Token, ServiceDescription, ActivityDescription)'
			Set @SQLSelect = @SQLSelect + 'Select ActivityLog.ActivityID, ActivityLog.ServiceID, ActivityLog.PersonID, ActivityDate, FirstName, Surname, Email, ActivityLog.Token, Service.Description, Activity.Description'
			Set @SQLSelect = @SQLSelect + ' From ActivityLog '  
			Set @SQLSelect = @SQLSelect + 'Inner Join Person On ActivityLog.PersonID = Person.PersonID '
			Set @SQLSelect = @SQLSelect + 'Inner Join Activity On ActivityLog.ActivityID = Activity.ActivityID '
			Set @SQLSelect = @SQLSelect + 'Inner Join Service On ActivityLog.ServiceID = Service.ServiceID '
			Set @SQLSelect = @SQLSelect + 'Inner Join Product On Product.ProductID = Service.ProductID '
			
			If @UserID > 0 --Specific User's details! 
				Begin
					Set @SQLWhere = 'Where ActivityLog.PersonID = ' + Convert(Varchar(5), @UserID)
				End
			
			If @FromDateTime <> '' --Specify Begin and End dates!!
				Begin
					If @SQLWhere = ''
						Begin
							Set @SQLWhere = 'Where CONVERT(Varchar(25), ActivityLog.ActivityDate) Between ' + '''' + @FromDateTime + '''' + ' And ' + '''' + @ToDateTime + ''''
						End
					Else
						Begin
							Set @SQLWhere = @SQLWhere + ' And CONVERT(Varchar(25), ActivityLog.ActivityDate) Between ' + '''' + @FromDateTime + '''' + ' And ' + '''' + @ToDateTime + ''''
						End 
				End
			
			If @ProductDesc <> '' And @ProductDesc IS NOT NULL
				Begin
					If @SQLWhere = ''
						Begin
							Select @SQLWhere = 'Where Product.Description = ''' + @ProductDesc + ''''
						End
					Else
						Begin
							Select @SQLWhere = @SQLWhere + 'And Product.Description = ''' + @ProductDesc + ''''
						End
				End
			
			If @ServiceDesc <> '' And @ServiceDesc IS NOT NULL
				Begin
					If @SQLWhere = ''
						Begin
							Select @SQLWhere = 'Where Service.Description = ''' + @ServiceDesc + ''''
						End
					Else
						Begin
							Select @SQLWhere = @SQLWhere + 'And Service.Description = ''' + @ServiceDesc + ''''
						End
				End
			
			EXEC (@SQLSelect + @SQLWhere)  
			
			Set NoCount Off
			Select PersonID, ActivityDate, FirstName, Surname, Email, Token, ServiceID, ServiceDescription, ActivityDescription From #tmpActivityLog
			Drop Table #tmpActivityLog
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

CREATE Procedure x_UserListPaged (
		@GroupID int,
		@StartRow int,
		@NumberRows int
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_UserListPaged
			- Retrieves users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare	@TotalRows int
			CREATE TABLE #UserTemp (
				[RowID] [int] IDENTITY (1, 1) NOT NULL ,
				[PersonID] [int],
				[UserName] [varchar] (30)  ,
				[FirstName] [varchar] (50)  ,
				[Surname] [varchar] (50)  ,
				[EMail] [varchar] (50)  ,
				[TelNo] [varchar] (35)  ,
				[CellPhone] [varchar] (20)  ,
				[Status] [varchar] (50)  ,
				[GroupID] [int],
				[GroupName] [varchar] (100)  ,
				CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
			)
			
			If @GroupID > 0 
				Insert into #UserTemp (
					[PersonID] , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					[Status] ,
					GroupID ,
					GroupName)
				select 
					Person.PersonID , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					Status = PersonStatus.Description ,
					@GroupID ,
					GroupName = Groups.Description
				from Person 
					inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
					inner Join Groups On PersonGroup.GroupID = Groups.GroupID
					where PersonGroup.GroupID = @GroupID
						and Person.PersonID > 5
					order by Person.PersonID
			Else
				Insert into #UserTemp (
					[PersonID] , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					[Status] ,
					GroupID )
				select 
					Person.PersonID , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					Status = PersonStatus.Description,
					@GroupID
				from Person 
					inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					where Person.PersonID > 5
				order by Person.PersonID
			
			Set @TotalRows = @@ROWCOUNT
			
			Select * from #UserTemp 
				where RowID between @StartRow and @StartRow + @NumberRows - 1
				order by RowID
			
			Drop table #UserTemp
			
			Select TotalRows = @TotalRows
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

CREATE Procedure x_UserListPagedSorted (
		@GroupID int,
		@ColumnName varchar(30),
		@StartRow int,
		@NumberRows int
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_UserListPagedSorted
			- Retrieves users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
		
			Declare	@TotalRows int
			Declare @SQLSelect Varchar(1000)
			Declare @SQLOrder Varchar(200)
			Declare @SQLWhere Varchar(200)
			
			CREATE TABLE #UserTemp (
				[RowID] [int] IDENTITY (1, 1) NOT NULL ,
				[PersonID] [int],
				[UserName] [varchar] (30)  ,
				[FirstName] [varchar] (50)  ,
				[Surname] [varchar] (50)  ,
				[EMail] [varchar] (50)  ,
				[TelNo] [varchar] (35)  ,
				[CellPhone] [varchar] (20)  ,
				[Status] [varchar] (50)  ,
				[GroupID] [int],
				[GroupName] [varchar] (100)  ,
				CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
			)
			Set @SQLSelect = 'Insert into #UserTemp ([PersonID], [UserName], [FirstName], [Surname], [EMail], [TelNo], [CellPhone], [Status]'
			if @GroupID > 0
				Set @SQLSelect = @SQLSelect + ', GroupID, GroupName ) '
			else
				Set @SQLSelect = @SQLSelect + ') '
			
			Set @SQLSelect = @SQLSelect + 'select Person.PersonID ,[UserName] ,[FirstName] ,[Surname] ,[EMail] ,[TelNo] ,[CellPhone], Status = PersonStatus.Description '
			if @GroupID > 0
				Set @SQLSelect = @SQLSelect + ', PersonGroup.GroupID, GroupName = Groups.Description '
			
			Set @SQLSelect = @SQLSelect + 'from Person inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID '
			if @GroupID > 0
				begin
					Set @SQLSelect = @SQLSelect + 'inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID '
					Set @SQLSelect = @SQLSelect + 'inner Join Groups On PersonGroup.GroupID = Groups.GroupID '
				end
			
			if @GroupID > 0
				begin
					Set @SQLWhere = 'where PersonGroup.GroupID = ' + Convert(Varchar(5), @GroupID)
					Set @SQLWhere = @SQLWhere + 'and Person.PersonID > 5'
				end
			else
				Set @SQLWhere = 'where Person.PersonID > 5'
			
			Set @SQLOrder = ' order by '
			Set @SQLOrder = @SQLOrder + @ColumnName
			
			EXEC (@SQLSelect + @SQLWhere + @SQLOrder)  
			
			Set @TotalRows = @@ROWCOUNT
			
			Select * from #UserTemp 
				where RowID between @StartRow and @StartRow + @NumberRows - 1
				order by RowID
			
			Drop table #UserTemp
			Select TotalRows = @TotalRows
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delConfig
(@Description varchar(100))
As
-- Used to remove a System Configuration value.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getActivity
(@ActivityID int)
As
-- Used to retrieve details for a specific Activity record in the Gatekeeper database, typically for editing purposes.
Begin
  Select Description, ActivityID
  From Activity
  Where ActivityID = @ActivityID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getActivityList
As
-- Retrieves a list of all Activity records in the Gatekeeper database, typically for selection purposes
-- on a user interface.
Begin
  Select ActivityID, Description
  From Activity
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getConfig
(@Description varchar(100))
As
-- Used to return the value of a system setting.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getConfigList
As
-- Used to retrieve a list of all System Configuration values.
Begin
  Select Description, RetValue 
  From Config
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getGroupStatus
(@GroupStatusID int) 
As
-- Used to retrieve details for a specific GroupStatus record in the Gatekeeper database, typically for
-- editing purposes.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getGroupStatusList
As
-- Returns a list of all GroupStatus records in the Gatekeeper database, typically for selection on a
-- user interface.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getPersonStatus
(@PersonStatusID int)
As
-- Return details for a specific Person Status in the Gatekeeper database.
Begin
  Select Description, PersonStatusID
  From PersonStatus
  Where PersonStatusID = @PersonStatusID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getPersonStatusList
As
-- Returns a list of all person status' in the Gatekeeper database, commonly used to generate a list on a user
-- interface for selection purposes.
Begin
  Select PersonStatusID, Description 
  From PersonStatus
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getProductStatus
(@ProductStatusID int)
As
-- Return details for a specific Product Status in the Gatekeeper database.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getProductStatusList
As
-- Returns a list of all product status' in the Gatekeeper database, commonly used to generate a list on a user
--  interface for selection purposes.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getQuestion
(@QuestionID int)
As
-- Used to retrieve a Question record, typically for editing purposes.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getQuestionList
As
-- used to retrieve a list of all Question records in the database.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getSecurityLevel
(@SecurityLevelID int)
As
-- Returns details for a specific Security Level record.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getSecurityLevelList
As
-- Used to retrieve a list of all Security Level records in the database.
Begin
  Select SecurityLevelID, Description
  From SecurityLevel
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getServiceStatus
(@ServiceStatusID int) 
As
-- Return details for a specific Service Status in the Gatekeeper database.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getServiceStatusList
As
-- Returns a list of all service status' in the Gatekeeper database, commonly used to generate a list on a user
-- interface for selection purposes.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insActivity
(@ActivityID int OUTPUT,
 @Description varchar(50))
As
--Add/update an Activity record in the Gatekeeper database.
Begin
  If @ActivityID > 0 --Update!
    Begin
      Update Activity
      Set Description = @Description
      Where ActivityID = @ActivityID
    End
  Else  --Insert!
    Begin
      Insert Into Activity (Description)
      Select @Description

      Select @ActivityID = @@IDENTITY
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insConfig
(@Description varchar(100),
 @RetValue varchar(50))
As
-- Used to change the value of a system setting.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insGroupStatus
(@GroupStatusID int OUTPUT,
 @Description varchar(100))
As
-- Used to add/update a Group Status record in the Gatekeeper database.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insPersonStatus
(@PersonStatusID int OUTPUT,
 @Description varchar(50))
As
-- Used to add/update a PersonStatus record in the Gatekeeper database. All PersonStatus records must have unique
-- descriptions.
Begin
  If @PersonStatusID > 0 --Update!
    Begin
      Update PersonStatus
      Set Description = @Description
      Where PersonStatusID = @PersonStatusID
    End
  Else  --Insert!
    Begin
      Insert Into PersonStatus (Description)
      Select @Description

      Select @PersonStatusID = @@IDENTITY
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insProductStatus
(@ProductStatusID int OUTPUT,
 @Description varchar(50),
 @DisplayMessage varchar(300))
As
-- Used to add/update a ProductStatus record in the Gatekeeper database. Will check for the existence
--  of a record, before adding a new record.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insQuestion
(@QuestionID int OUTPUT,
 @Description varchar(100))
As
-- Method used to add/update a Question record.
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO









/* Object: Stored procedure */
CREATE Procedure jtsp_insSecurityLevel
(@SecurityLevelID int OUTPUT,
 @Description varchar(50))
As
-- Used to add/update a SecurityLevel record in the Gatekeeper database. Will check for the existence
-- of a record, before adding a new record.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insServiceStatus
(@ServiceStatusID int OUTPUT,
 @Description varchar(50),
 @DisplayMessage varchar(300))
As
-- Used to add/update a Service Status record in the Gatekeeper database. Will check for the existence
-- of a record, before adding a new record.
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

CREATE Procedure x_ActivityAdd (
		@ActivityID int OUTPUT,
		@Description varchar(50)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Add/update an Activity record in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @ActivityID > 0 --Update!
				Begin
					Update Activity
						Set Description = @Description
						Where ActivityID = @ActivityID
				End
			Else  --Insert!
				Begin
					Insert Into Activity (Description) Select @Description
					Select @ActivityID = @@IDENTITY
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

CREATE Procedure x_ActivityGet (
		@ActivityID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieve details for a specific Activity record
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select Description, ActivityID
				From Activity
				Where ActivityID = @ActivityID
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

CREATE Procedure x_ActivityList
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves a list of all Activity records 
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select ActivityID, Description From Activity
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

CREATE Procedure x_ConfigAdd (
		@Description varchar(100),
		@RetValue varchar(50)
	)
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

CREATE Procedure x_ConfigDelete (
		@Description varchar(100)
	)
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

CREATE Procedure x_ConfigGet (
		@Description varchar(100)
	)
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

CREATE Procedure x_ConfigList
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE Procedure x_UserStatusAdd (
		@PersonStatusID int OUTPUT,
		@Description varchar(50)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Add/update a PersonStatus record in the Gatekeeper database. 
			All PersonStatus records must have unique descriptions.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @PersonStatusID > 0 --Update!
				Begin
					Update PersonStatus
						Set Description = @Description
						Where PersonStatusID = @PersonStatusID
				End
			Else  --Insert!
				Begin
					Insert Into PersonStatus (Description) Select @Description
					Select @PersonStatusID = @@IDENTITY
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

CREATE Procedure x_UserStatusGet (
		@PersonStatusID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Return details for a specific Person Status in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select Description, PersonStatusID
				From PersonStatus
					Where PersonStatusID = @PersonStatusID
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

CREATE Procedure x_UserStatusGetList
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Returns a list of all person status' in the Gatekeeper database
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select PersonStatusID, Description From PersonStatus
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









/* Object: Stored procedure */
Create Procedure jtsp_ExpirePassword
(@UserID int)
As
-- Method used to force the expiry of a user's password, which will force them to renew their password at next logon.
Begin
  Update Person
  Set PasswordExpiryDate = getdate()
  Where PersonID = @UserID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delGroupStatus
(@GroupStatusID int,
 @Result varchar(25) Output)
As
-- Used to permanently remove a GroupStatus record from the Gatekeeper database. The system will check that
--  the record is no longer in use before attempting the delete.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delPersonStatus
(@PersonStatusID int,
 @Result varchar(25) Output)
As
-- Used to remove a PersonStatus record from the Gatekeeper database. The system will first check whether the
--  record is still in use before attempting to delete the record.
Begin
  If Exists (Select PersonStatusID From Person
             Where PersonStatusID = @PersonStatusID)
    Begin
      Select @Result = 'Cannot delete'
    End
  Else
    Begin
      Delete PersonStatus
      Where PersonStatusID = @PersonStatusID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delProductStatus
(@ProductStatusID int,
 @Result varchar(25) Output)
As
-- Used to delete a ProductStatus record from the database. Validation will be done that the Product Status is not
--  in use any more, before the deletion will take place.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getGroup
(@GroupID int)
As
-- Return details for a specific Group in the Gatekeeper database.
Begin
  Select GroupDesc = Groups.Description, Groups.GroupStatusID, 
         GroupStatusDesc = GroupStatus.Description, Groups.GroupStatusID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getGroupList
As
-- Returns a list of all groups in the Gatekeeper database, commonly used to generate a list on a user
--  interface for selection purposes.
Begin
  Select GroupID, GroupDesc = Groups.Description, 
         Groups.GroupStatusID, GroupStatusDesc = GroupStatus.Description
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getPassword
(@UserID int,
 @UserName varchar(50))
As
-- Sends the user's pin/password to their cellphone. This is the only method that implements any
-- external system, and is dependant on that service to run correctly.
Begin
  Select PersonName = FirstName + ' ' + Surname, CellPhone, Password
  From Person
  Where PersonID = @UserID Or UserName = @UserName
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









/* Object: Stored procedure */CREATE Procedure jtsp_getPerson
(@UserID int,
 @UserName varchar(50))
As
-- Retrieves a specific user's details for display or editing on a user interface.
Begin
  Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
         Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
  From Person
  Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
  Where PersonID = @UserID Or UserName = @UserName Or Convert(Varchar(50), Token) = @UserName
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getProductList
As
-- Returns a list of all products in the Gatekeeper database, commonly used to generate a list on a user
-- interface for selection purposes.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insProduct
(@ProductID int OUTPUT,
 @Description varchar(100),
 @ProductStatusID int)
As
-- Save a Product's details. The database implementation will check for the existince of a record,
-- and if not present will add it.
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE   Procedure jtsp_loginUser
(@UserName varchar(30),
 @Password varchar(50),
 @Userid int OUTPUT)
As
-- Validate a user's login information, and returns an XML document containing a Token to the user which must be used 
-- throughout the session to validate the user when accessing any system the Gatekeeper controls access to.
-- XML = <User UserID="" Token=""><Result><ResultCode><Description></Result></User>
-- If the login is successful, the ResultCode will be 0 (zero), and the Token will contain the value that must
-- be used for the session to validate the user for any functionality. If not, the Result will contain the
-- error code and description or reason the login failed.
Begin
  Declare @PersonID int, @Token UniqueIdentifier
  Declare @PWord varchar(50), @LFailures int
  Declare @TExpiryDate datetime, @TokenDate int
  Declare @PExpiryDate datetime, @FailureTimes int
  Declare @AccLockedTime int, @AccLockedDate datetime
  Declare @PersonAccLockedDate datetime, @Result varchar(25), @PersonStatus Varchar(50)
  Declare @ExpiryDate int, @PasswordExpiryDate datetime

  Select @Result = ''
  Select @PersonID = PersonID, @PWord = Password, @LFailures = LoginFailures, 
         @PExpiryDate = PasswordExpiryDate, @PersonAccLockedDate = AccLockedDate,
				 @PersonStatus = PersonStatus.Description
  From Person
	Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
	Where UserName = @UserName
  Select @Userid = @PersonID
  If DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
  Begin
    Select @Result = 'Account still locked'
  End
  Else If @PersonStatus <> 'Active'
	Begin
		Select @Result = 'Account is ' + @PersonStatus
	End
	Else
  Begin
    If DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 Or DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
    Begin
      Update Person
      Set AccLockedDate = null,
          LoginFailures = 0
      Where PersonID = @PersonID
    End
      If @Password = @PWord
        Begin
          If CONVERT(varchar(11), @PExpiryDate, 103) = CONVERT(varchar(11), getdate(), 103)
            Begin
              Select @Result = 'Password has expired'
            End
          Else
            Begin
              Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
              Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
              Select @Token = NewID()
			  Select @ExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
			  Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())
             
              Update Person
              Set Token = @Token,
				  TokenExpiryDate = @TExpiryDate,
				  PasswordExpiryDate = @PasswordExpiryDate,
                  LoginFailures = 0,
                  LastLoginDate = getdate()
              Where PersonID = @PersonID        
            End  
        End 
      Else
        Begin
          Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
          Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
          If @LFailures = @FailureTimes
            Begin
              Select @Result = 'Loginfailure limit reached'
            End
          Else
            Begin
              Select @LFailures = @LFailures + 1
              Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
              If @LFailures = @FailureTimes
                Begin
                  Update Person
                  Set LoginFailures = @LFailures,
                      LoginFailureDate = getdate(),
                      AccLockedDate = @AccLockedDate
                  Where PersonID = @PersonID
                  Select @Result = 'Incorrect Password'
                End
              Else
                Begin
                  Update Person
                  Set LoginFailures = @LFailures,
                      LoginFailureDate = getdate()
                  Where PersonID = @PersonID
                  Select @Result = 'Incorrect Password'
                End
            End 
       End
    End
  Select Token = @Token, Result = @Result
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









/* Object: Stored procedure */
Create Procedure jtsp_logoutUser
(@Token uniqueidentifier)
As
-- A string containing the GUID supplied by the Gatekeeper when the user logged in
Begin
  Update Person
  Set Token = null,
      TokenExpiryDate = null
  Where Token = @Token
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







/* Object: Stored procedure */
CREATE  Procedure jtsp_updPassword --1, '', 'Test Password'
(@UserID int,
 @UserName varchar(50),
 @Password varchar(50))
As
-- Update a user's password. 
Begin
	Declare @NewUserID int
	Declare @ExpiryDate int
	Declare @PasswordExpiryDate datetime
	
	If @UserID = 0 
		Begin
			Select @NewUserID = PersonID From Person
				Where UserName = @UserName
		End
	Else
		Begin
			Select @NewUserID = @UserID
		End
	
	Select @ExpiryDate = RetValue From Config
		Where Description = 'PasswordExpiryDate'
	
	Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())
	
	If Exists (Select PersonID From Person Where PersonID = @NewUserID)
		Begin
			Update Person
				Set Password = @Password,
				PasswordExpiryDate = @PasswordExpiryDate
				Where PersonID = @UserID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_updProduct
(@ProductID int,
 @Status varchar(25))
As
-- Lock/Unlock a Product 
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









/* Object: Stored procedure */
Create Procedure jtsp_updProductStatus
(@ProductID int,
 @Status varchar(15))
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO









/* Object: Stored procedure */
Create Procedure jtsp_updUserStatus
(@UserID int,
 @UserName varchar(50),
 @Status varchar(100))
As
Begin
  Declare @NewUserID int
  Declare @PersonStatusID int

  If @UserID = 0
    Begin
      Select @NewUserID = PersonID From Person
      Where UserName = @UserName
    End
  Else
    Begin
      Select @NewUserID = @UserID
    End

  Select @PersonStatusID = PersonStatusID From PersonStatus
  Where Description = @Status

  Update Person
  Set PersonStatusID = @PersonStatusID
  Where PersonID = @NewUserID
End










GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE    Procedure nm_LoginUser
(@UserName varchar(30),
 @Password varchar(50),
 @Userid int OUTPUT)
As
-- Validate a user's login information, and returns an XML document containing a Token to the user which must be used 
-- throughout the session to validate the user when accessing any system the Gatekeeper controls access to.
-- XML = <User UserID="" Token=""><Result><ResultCode><Description></Result></User>
-- If the login is successful, the ResultCode will be 0 (zero), and the Token will contain the value that must
-- be used for the session to validate the user for any functionality. If not, the Result will contain the
-- error code and description or reason the login failed.
Begin
	Declare @PersonID int, @Token UniqueIdentifier
	Declare @PWord varchar(50), @LFailures int
	Declare @TExpiryDate datetime, @TokenDate int
	Declare @PExpiryDate datetime, @FailureTimes int
	Declare @AccLockedTime int, @AccLockedDate datetime
	Declare @PersonAccLockedDate datetime, @Result varchar(25), @PersonStatus Varchar(50)
	Declare @ExpiryWarning varchar(50), @PasswordWarningDate int
	Declare @ExpiryDate int, @PasswordExpiryDate datetime
	
	Select @Result = ''
	Select @ExpiryWarning =''
	Select @PersonID = PersonID, @PWord = Password, @LFailures = LoginFailures, 
			@PExpiryDate = PasswordExpiryDate, @PersonAccLockedDate = AccLockedDate,
			@PersonStatus = PersonStatus.Description
	From Person
	Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
	Where UserName = @UserName
	
	if Exists(Select * From Person Where UserName = @UserName)
		Begin
	
			Select @Userid = @PersonID
			
			If DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
				Begin
					Select @Result = 'Account still locked'
				End
				-- On-hold is also ok login
			Else If not (@PersonStatus = 'Active' or @PersonStatus = 'On-hold' or @PersonStatus = 'Legacy' or @PersonStatus = 'Email-billing')
				Begin
					Select @Result = 'Account is ' + @PersonStatus
				End
			Else
				Begin
					If DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 Or DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
						Begin
							Update Person
							Set AccLockedDate = null, LoginFailures = 0
							Where PersonID = @PersonID
						End
				
					If @Password = @PWord
						Begin
						  If @PExpiryDate <= getdate()
						    Begin
						      Select @Result = 'Password has expired'
						    End
						  Else
						    Begin
						      Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
						      Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
						      Select @Token = NewID()
						      Select @PasswordWarningDate = RetValue From Config Where Description = 'PasswordWarningDate'
							  Select @ExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
							  Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())
						      If DATEDIFF(day, getdate(), @PExpiryDate) <= @PasswordWarningDate
						         Begin
									Select @ExpiryWarning =  CONVERT(varchar (50), DATEDIFF(day, getdate(), @PExpiryDate ))
						         End
						     
						      Update Person
						      Set Token = @Token,
								  TokenExpiryDate = @TExpiryDate,
								  PasswordExpiryDate = @PasswordExpiryDate,
						          LoginFailures = 0,
						          LastLoginDate = getdate()
						      Where PersonID = @PersonID        
						    End  
						End 
					Else
						Begin
						  Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
						  Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
						  If @LFailures = @FailureTimes
						    Begin
						      Select @Result = 'Loginfailure limit reached'
						    End
						  Else
						    Begin
						      Select @LFailures = @LFailures + 1
						      Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
						      If @LFailures = @FailureTimes
						        Begin
						          Update Person
						          Set LoginFailures = @LFailures,
						              LoginFailureDate = getdate(),
						              AccLockedDate = @AccLockedDate
						          Where PersonID = @PersonID
						          Select @Result = 'Incorrect Password'
						        End
						      Else
						        Begin
						          Update Person
						          Set LoginFailures = @LFailures,
						              LoginFailureDate = getdate()
						          Where PersonID = @PersonID
						          Select @Result = 'Incorrect Password'
						        End
						    End 
						End
					-- End Else
				End
			-- End Else
			
		End
	Else
		Begin
			Select @Result = 'No such username'
		end
	Select Token = @Token, Result = @Result, ExpiryWarning = @ExpiryWarning

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

CREATE Procedure tsp_logoutUser (
		@Token uniqueidentifier
	)
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
	As
		Begin
			Update Person
				Set Token = null, TokenExpiryDate = null
				Where Token = @Token
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






CREATE  Procedure um_ClearLock
(@UserID int)
As
-- Restore a user who was previously delete to active status.
Begin
	If Exists(Select * From Person Where PersonID = @UserID)
	Begin
		Update Person
		Set LoginFailureDate = NULL,
			AccLockedDate = NULL,
		  LoginFailures = 0
		Where PersonID = @UserID
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




CREATE  Procedure um_GetGroup
(@GroupID int)
As
-- Return details for a specific Group in the Gatekeeper database.
Begin
	Select GroupDesc = Groups.Description, Groups.GroupStatusID, 
	     GroupStatusDesc = GroupStatus.Description, Groups.GroupStatusID
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









/* Object: Stored procedure */

CREATE Procedure um_GetGroups
As
-- Returns a list of all groups in the Gatekeeper database, commonly used to generate a list on a user
--  interface for selection purposes.
Begin
  Select GroupID, GroupName = Groups.Description, 
         StatusID = Groups.GroupStatusID, Status = GroupStatus.Description
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



CREATE    Procedure um_GetPassword
(@UserID int,
 @UserName varchar(50))
As
Begin
	Select UserName, FirstName, PersonName = FirstName + ' ' + Surname, CellPhone, EMail, Password
		From Person
		Where PersonID = @UserID Or UserName = @UserName
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



CREATE Procedure um_GetPerson
(@UserID int,
 @UserName varchar(50))
As
-- Retrieves a specific user's details for display or editing on a user interface.
Begin
	Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
	     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description, AccLockedDate
	From Person
	Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
	Where PersonID = @UserID Or UserName = @UserName Or Convert(Varchar(50), Token) = @UserName
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




CREATE Procedure um_GetPersonName
(@UserID int)
As
-- Retrieves a specific user's username.
Begin
	Select UserName
		From Person
		Where PersonID = @UserID
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









/* Object: Stored procedure */

CREATE Procedure um_GetProfileList
As
-- Returns a list of all groups in the Gatekeeper database, commonly used to generate a list on a user
--  interface for selection purposes.
Begin
  Select GroupID, GroupDesc = Groups.Description, 
         Groups.GroupStatusID, GroupStatusDesc = GroupStatus.Description
  From Groups
  Inner Join GroupStatus On Groups.GroupStatusID = GroupStatus.GroupStatusID
  Order by GroupDesc
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


CREATE    Procedure um_LoginUser
(@UserName varchar(30),
 @Password varchar(50),
 @Userid int OUTPUT)
As
-- Validate a user's login information, and returns an XML document containing a Token to the user which must be used 
-- throughout the session to validate the user when accessing any system the Gatekeeper controls access to.
-- XML = <User UserID="" Token=""><Result><ResultCode><Description></Result></User>
-- If the login is successful, the ResultCode will be 0 (zero), and the Token will contain the value that must
-- be used for the session to validate the user for any functionality. If not, the Result will contain the
-- error code and description or reason the login failed.
Begin
	Declare @PersonID int, @Token UniqueIdentifier
	Declare @PWord varchar(50), @LFailures int
	Declare @TExpiryDate datetime, @TokenDate int
	Declare @PExpiryDate datetime, @FailureTimes int
	Declare @AccLockedTime int, @AccLockedDate datetime
	Declare @PersonAccLockedDate datetime, @Result varchar(25), @PersonStatus Varchar(50)
	
	Select @Result = ''
	
	Select @PersonID = PersonID, @PWord = Password, @LFailures = LoginFailures, 
			@PExpiryDate = PasswordExpiryDate, @PersonAccLockedDate = AccLockedDate,
			@PersonStatus = PersonStatus.Description
	From Person
	Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
	Where UserName = @UserName
	
	Select @Userid = @PersonID
	
	If DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
		Begin
			Select @Result = 'Account still locked'
		End
		-- On-hold is also ok login
	Else If not (@PersonStatus = 'Active' or @PersonStatus = 'On-hold' or @PersonStatus = 'Legacy' or @PersonStatus = 'Survey')
		Begin
			Select @Result = 'Account is ' + @PersonStatus
		End
	Else
		Begin
			If DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 Or DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
				Begin
					Update Person
					Set AccLockedDate = null, LoginFailures = 0
					Where PersonID = @PersonID
				End
		
			If @Password = @PWord
				Begin
				  If CONVERT(varchar(11), @PExpiryDate, 103) = CONVERT(varchar(11), getdate(), 103)
				    Begin
				      Select @Result = 'Password has expired'
				    End
				  Else
				    Begin
				      Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
				      Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
				      Select @Token = NewID()
				     
				      Update Person
				      Set Token = @Token,
											TokenExpiryDate = @TExpiryDate,
				          LoginFailures = 0,
				          LastLoginDate = getdate()
				      Where PersonID = @PersonID        
				    End  
				End 
			Else
				Begin
				  Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
				  Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
				  If @LFailures = @FailureTimes
				    Begin
				      Select @Result = 'Loginfailure limit reached'
				    End
				  Else
				    Begin
				      Select @LFailures = @LFailures + 1
				      Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
				      If @LFailures = @FailureTimes
				        Begin
				          Update Person
				          Set LoginFailures = @LFailures,
				              LoginFailureDate = getdate(),
				              AccLockedDate = @AccLockedDate
				          Where PersonID = @PersonID
				          Select @Result = 'Incorrect Password'
				        End
				      Else
				        Begin
				          Update Person
				          Set LoginFailures = @LFailures,
				              LoginFailureDate = getdate()
				          Where PersonID = @PersonID
				          Select @Result = 'Incorrect Password'
				        End
				    End 
				End
			-- End Else
		End
	-- End Else
	
	Select Token = @Token, Result = @Result
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









/* Object: Stored procedure */

CREATE  Procedure um_ResetPerson
(@UserID int)
As
-- Restore a user who was previously delete to active status.
Begin
	If Exists(Select * From Person Where PersonID = @UserID)
	Begin
		Update Person
		Set LoginFailureDate = NULL,
			AccLockedDate = NULL,
		  LoginFailures = 0
		Where PersonID = @UserID
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






CREATE   Procedure um_SetLock
(@UserID int)
As
Begin
	Declare @LFailures int, @FailureTimes int, @AccLockedTime int, @AccLockedDate datetime

	Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
	Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
	Select @LFailures = @FailureTimes + 1
	Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())

	Update Person
		Set LoginFailures = @LFailures,
			LoginFailureDate = getdate(),
			AccLockedDate = @AccLockedDate
		Where PersonID = @UserID
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









/* Object: Stored procedure */

CREATE Procedure um_UpdatePassword --1, '', 'Test Password'
(@UserID int,
 @UserName varchar(50),
 @Password varchar(50))
As
-- Update a user's password. 
Begin
  Declare @NewUserID int
  Declare @ExpiryDate int
  Declare @PasswordExpiryDate datetime

  If @UserID = 0 
    Begin
      Select @NewUserID = PersonID From Person
      Where UserName = @UserName
    End
  Else
    Begin
      Select @NewUserID = @UserID
    End

  Select @ExpiryDate = RetValue From Config
  Where Description = 'PasswordExpiryDate'

  Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())

  If Exists (Select PersonID From Person Where PersonID = @NewUserID)
    Begin
      Update Person
      Set Password = @Password,
          PasswordExpiryDate = @PasswordExpiryDate
      Where PersonID = @NewUserID
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









/* Object: Stored procedure */

CREATE  Procedure um_Validate
(@Token uniqueidentifier)
As
-- Validates the token.
Begin
	Declare @PersonID int
	Declare @ServiceID int
	Declare @TokenDate Int, @TExpiryDate DateTime
	Declare @Result Varchar(100)

	Select @PersonID = PersonID, @TExpiryDate = TokenExpiryDate From Person Where Token = @Token

	If @TExpiryDate IS NULL Or DateDiff(n, Getdate(), @TExpiryDate) < 0
		Select @Result = 'User session has expired, or user has not yet logged in.'
	Else
		Begin
			Select @Result = 'ok'
			Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
			Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
			
			Update Person
			Set TokenExpiryDate = @TExpiryDate,
				LastLoginDate = getdate()
			Where PersonID = @PersonID
		End

	Select Result = @Result
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

CREATE Procedure x_UserGet (
		@UserID int,
		@UserName varchar(50),
		@UserToken varchar(50),
		@UserCellPhone varchar(20)
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_UserGet
			- Stored procedure to retrieve a specific user's details
		Parameters:
			@UserID:		User identifier
			@UserName:		Username
			@UserToken:		User's login token (guid)
			@UserCellPhone:	User's cellphone number
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
				 Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description, AccLockedDate
			From Person
			Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
			Where (@UserID != 0 And PersonID = @UserID)
				Or (@UserName != '' And UserName = @UserName)
				Or (@UserToken != '' And Convert(Varchar(50), Token) = @UserToken)
				Or (@UserCellPhone != '' And CellPhone = @UserCellPhone)
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

CREATE Procedure x_UserGetName (
		@UserID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves a specific user's username.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select UserName From Person Where PersonID = @UserID
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

CREATE Procedure x_UserLockClear (
		@UserID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Restore a user who was previously delete to active status.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If Exists(Select * From Person Where PersonID = @UserID)
				Begin
					Update Person
						Set LoginFailureDate = NULL,
							AccLockedDate = NULL,
							LoginFailures = 0
						Where PersonID = @UserID
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

CREATE Procedure x_UserLockSet (
		@UserID int
	)
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
	As
		Begin
			Declare @LFailures int, @FailureTimes int, @AccLockedTime int, @AccLockedDate datetime

			Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
			Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
			Select @LFailures = @FailureTimes + 1
			Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())

			Update Person
				Set LoginFailures = @LFailures,
					LoginFailureDate = getdate(),
					AccLockedDate = @AccLockedDate
				Where PersonID = @UserID
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


CREATE Procedure x_UserLogin (
		@UserName varchar(30),
		@Password varchar(50),
		@Userid int OUTPUT
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Validate a user's login information
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @PersonID int, @Token UniqueIdentifier
			Declare @PWord varchar(50), @LFailures int
			Declare @TExpiryDate datetime, @TokenDate int
			Declare @PExpiryDate datetime, @FailureTimes int
			Declare @AccLockedTime int, @AccLockedDate datetime
			Declare @PersonAccLockedDate datetime, @Result varchar(50), @PersonStatus Varchar(50)
			Declare @ExpiryDate int, @PasswordExpiryDate datetime
			
			Select @Result = ''
			Select @PersonID = PersonID, @PWord = Password, @LFailures = LoginFailures, @PExpiryDate = PasswordExpiryDate, @PersonAccLockedDate = AccLockedDate, @PersonStatus = PersonStatus.Description
				From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Where UserName = @UserName
			Select @Userid = @PersonID
			If DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
				Begin
					Select @Result = 'Account still locked'
				End
			Else If @PersonStatus <> 'Active'
				Begin
					Select @Result = 'Account is ' + @PersonStatus
				End
			Else
				Begin
					If DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 Or DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
						Begin
							Update Person
								Set AccLockedDate = null, LoginFailures = 0
								Where PersonID = @PersonID
						End
					If @Password = @PWord
						Begin
							If CONVERT(varchar(11), @PExpiryDate, 103) = CONVERT(varchar(11), getdate(), 103)
								Begin
									Select @Result = 'Password has expired'
								End
							Else
								Begin
									Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
									Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
									Select @Token = NewID()
									Select @ExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
									Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())

									Update Person
										Set Token = @Token,
											TokenExpiryDate = @TExpiryDate,
											PasswordExpiryDate = @PasswordExpiryDate,
											LoginFailures = 0,
											LastLoginDate = getdate()
										Where PersonID = @PersonID        
								End  
						End 
					Else
						Begin
							Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
							Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
							If @LFailures = @FailureTimes
								Begin
									Select @Result = 'Loginfailure limit reached'
								End
							Else
								Begin
									Select @LFailures = @LFailures + 1
									Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
									If @LFailures = @FailureTimes
										Begin
											Update Person
												Set LoginFailures = @LFailures,
													LoginFailureDate = getdate(),
													AccLockedDate = @AccLockedDate
											Where PersonID = @PersonID
											Select @Result = 'Incorrect Password'
										End
									Else
										Begin
											Update Person
											Set LoginFailures = @LFailures,
												LoginFailureDate = getdate()
												Where PersonID = @PersonID
											Select @Result = 'Incorrect Password'
										End
								End 
						End
				End
			Select Token = @Token, Result = @Result
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

CREATE Procedure x_UserLoginAlt (
		@UserName varchar(30),
		@Password varchar(50),
		@Userid int OUTPUT
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Originally 'um_LoginUser'
			Deprecated?
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
				Declare @PersonID int, @Token UniqueIdentifier
				Declare @PWord varchar(50), @LFailures int
				Declare @TExpiryDate datetime, @TokenDate int
				Declare @PExpiryDate datetime, @FailureTimes int
				Declare @AccLockedTime int, @AccLockedDate datetime
				Declare @PersonAccLockedDate datetime, @Result varchar(25), @PersonStatus Varchar(50)
				
				Select @Result = ''
				
				Select @PersonID = PersonID, @PWord = Password, @LFailures = LoginFailures, 
						@PExpiryDate = PasswordExpiryDate, @PersonAccLockedDate = AccLockedDate,
						@PersonStatus = PersonStatus.Description
				From Person
				Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
				Where UserName = @UserName
				
				Select @Userid = @PersonID
				
				If DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
					Begin
						Select @Result = 'Account still locked'
					End
					-- On-hold is also ok login
				Else If not (@PersonStatus = 'Active' or @PersonStatus = 'On-hold' or @PersonStatus = 'Legacy' or @PersonStatus = 'Survey')
					Begin
						Select @Result = 'Account is ' + @PersonStatus
					End
				Else
					Begin
						If DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 Or DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
							Begin
								Update Person
								Set AccLockedDate = null, LoginFailures = 0
								Where PersonID = @PersonID
							End
					
						If @Password = @PWord
							Begin
							  If CONVERT(varchar(11), @PExpiryDate, 103) = CONVERT(varchar(11), getdate(), 103)
							    Begin
							      Select @Result = 'Password has expired'
							    End
							  Else
							    Begin
							      Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
							      Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
							      Select @Token = NewID()
							     
							      Update Person
							      Set Token = @Token,
														TokenExpiryDate = @TExpiryDate,
							          LoginFailures = 0,
							          LastLoginDate = getdate()
							      Where PersonID = @PersonID        
							    End  
							End 
						Else
							Begin
							  Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
							  Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
							  If @LFailures = @FailureTimes
							    Begin
							      Select @Result = 'Loginfailure limit reached'
							    End
							  Else
							    Begin
							      Select @LFailures = @LFailures + 1
							      Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
							      If @LFailures = @FailureTimes
							        Begin
							          Update Person
							          Set LoginFailures = @LFailures,
							              LoginFailureDate = getdate(),
							              AccLockedDate = @AccLockedDate
							          Where PersonID = @PersonID
							          Select @Result = 'Incorrect Password'
							        End
							      Else
							        Begin
							          Update Person
							          Set LoginFailures = @LFailures,
							              LoginFailureDate = getdate()
							          Where PersonID = @PersonID
							          Select @Result = 'Incorrect Password'
							        End
							    End 
							End
						-- End Else
					End
				-- End Else
				
				Select Token = @Token, Result = @Result
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

CREATE Procedure x_UserLoginOld (
		@UserName varchar(30),
		@Password varchar(50),
		@Userid int OUTPUT
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Validate a user's login information
			Originally 'nm_LoginUser'
			Deprecated?
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @PersonID int, @Token UniqueIdentifier
			Declare @PWord varchar(50), @LFailures int
			Declare @TExpiryDate datetime, @TokenDate int
			Declare @PExpiryDate datetime, @FailureTimes int
			Declare @AccLockedTime int, @AccLockedDate datetime
			Declare @PersonAccLockedDate datetime, @Result varchar(25), @PersonStatus Varchar(50)
			Declare @ExpiryWarning varchar(50), @PasswordWarningDate int
			Declare @ExpiryDate int, @PasswordExpiryDate datetime
			
			Select @Result = ''
			Select @ExpiryWarning =''
			Select @PersonID = PersonID, 
				@PWord = Password, 
				@LFailures = LoginFailures, 
				@PExpiryDate = PasswordExpiryDate, 
				@PersonAccLockedDate = AccLockedDate,
				@PersonStatus = PersonStatus.Description
				From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Where UserName = @UserName
				
			if Exists(Select * From Person Where UserName = @UserName)
				Begin
					Select @Userid = @PersonID
					If DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
						Begin
							Select @Result = 'Account still locked'
						End
					-- On-hold is also ok login
					Else If not (@PersonStatus = 'Active' or @PersonStatus = 'On-hold' or @PersonStatus = 'Legacy' or @PersonStatus = 'Email-billing')
						Begin
							Select @Result = 'Account is ' + @PersonStatus
						End
					Else
						Begin
							If DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 Or DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
								Begin
									Update Person
										Set AccLockedDate = null, LoginFailures = 0
										Where PersonID = @PersonID
								End
							If @Password = @PWord
								Begin
									If @PExpiryDate <= getdate()
										Begin
											Select @Result = 'Password has expired'
										End
									Else
										Begin
											Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
											Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
											Select @Token = NewID()
											Select @PasswordWarningDate = RetValue From Config Where Description = 'PasswordWarningDate'
											Select @ExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
											Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())
											If DATEDIFF(day, getdate(), @PExpiryDate) <= @PasswordWarningDate
												Begin
													Select @ExpiryWarning =  CONVERT(varchar (50), DATEDIFF(day, getdate(), @PExpiryDate ))
												End
											Update Person
												Set Token = @Token,
													TokenExpiryDate = @TExpiryDate,
													PasswordExpiryDate = @PasswordExpiryDate,
													LoginFailures = 0,
													LastLoginDate = getdate()
												Where PersonID = @PersonID        
										End  
								End 
							Else
								Begin
									Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
									Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
									If @LFailures = @FailureTimes
										Begin
											Select @Result = 'Loginfailure limit reached'
										End
									Else
										Begin
											Select @LFailures = @LFailures + 1
											Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
											If @LFailures = @FailureTimes
												Begin
													Update Person
														Set LoginFailures = @LFailures,
															LoginFailureDate = getdate(),
															AccLockedDate = @AccLockedDate
														Where PersonID = @PersonID
													Select @Result = 'Incorrect Password'
												End
											Else
												Begin
													Update Person
														Set LoginFailures = @LFailures, LoginFailureDate = getdate()
														Where PersonID = @PersonID
													Select @Result = 'Incorrect Password'
												End
										End 
								End
							-- End Else
						End
					-- End Else
				End
			Else
				Begin
					Select @Result = 'No such username'
				End
			Select Token = @Token, Result = @Result, ExpiryWarning = @ExpiryWarning
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

CREATE Procedure x_UserLogout (
		@Token uniqueidentifier
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Stored procedure for...
		Parameters:
			@parameter1:	the GUID supplied by the Gatekeeper when the user logged in
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Update Person
				Set Token = null, TokenExpiryDate = null
				Where Token = @Token
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

CREATE Procedure x_UserPassword (
		@UserID int,
		@UserName varchar(50)
	)
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
	As
		Begin
			Select UserName, FirstName, PersonName = FirstName + ' ' + Surname, CellPhone, EMail, Password
				From Person
				Where PersonID = @UserID Or UserName = @UserName
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

CREATE Procedure x_UserPasswordExpire (
		@UserID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Method used to force the expiry of a user's password, which will force them to renew their password at next logon.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Update Person
			Set PasswordExpiryDate = getdate()
			Where PersonID = @UserID
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

CREATE Procedure x_UserPasswordUpdate (--1, '', 'Test Password' 
		@UserID int,
		@UserName varchar(50),
		@Password varchar(50)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Update a user's password.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @NewUserID int
			Declare @ExpiryDate int
			Declare @PasswordExpiryDate datetime
			If @UserID = 0 
				Begin
					Select @NewUserID = PersonID From Person Where UserName = @UserName
				End
			Else
				Begin
					Select @NewUserID = @UserID
				End
				
			Select @ExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
			Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())
				
			If Exists (Select PersonID From Person Where PersonID = @NewUserID)
				Begin
					Update Person
						Set Password = @Password, PasswordExpiryDate = @PasswordExpiryDate
						Where PersonID = @NewUserID
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

CREATE Procedure x_UserStatusDelete (
		@PersonStatusID int,
		@Result varchar(25) Output
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove a PersonStatus record from the Gatekeeper database. 
			The system will first check whether the record is still in use before attempting to delete the record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If Exists (Select PersonStatusID From Person Where PersonStatusID = @PersonStatusID)
				Begin
					Select @Result = 'Cannot delete'
				End
			Else
				Begin
					Delete PersonStatus Where PersonStatusID = @PersonStatusID
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

CREATE Procedure x_Validate (
		@Token uniqueidentifier
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Validates the token.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @PersonID int
			Declare @ServiceID int
			Declare @TokenDate Int, @TExpiryDate DateTime
			Declare @Result Varchar(100)
			Select @PersonID = PersonID, @TExpiryDate = TokenExpiryDate From Person Where Token = @Token
			If @TExpiryDate IS NULL Or DateDiff(n, Getdate(), @TExpiryDate) < 0
				Select @Result = 'User session has expired, or user has not yet logged in.'
			Else
				Begin
					Select @Result = 'ok'
					Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
					Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
					
					Update Person
					Set TokenExpiryDate = @TExpiryDate,
						LastLoginDate = getdate()
					Where PersonID = @PersonID
				End
			Select Result = @Result
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









/* Object: Stored procedure */
Create Procedure jtsp_ValidateUserQuestion 
(@UserID int,
 @QuestionID int,
 @Answer varchar(100),
 @Result varchar(50) OUTPUT)
As
-- Validates a user's answer to a question against a value in the Gatekeeper database. If the answer matches
-- the answer stored in the database for the User and Question, the method will return OK;
Begin
  Declare @CorrectAns varchar(100)

  Select @CorrectAns = Answer
  From Answer 
  Where PersonID = @UserID
  And QuestionID = @QuestionID

  If @CorrectAns = @Answer
    Begin
      Select @Result = 'OK'
    End
  Else
    Begin
      Select @Result = 'Incorrect Answer'
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









/* Object: Stored procedure */
Create Procedure jtsp_delGroupProduct
(@GroupID int,
 @ProductID int)
As
-- Method used to remove the link all users in a Group and a Product
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delQuestion
(@QuestionID int)
As
-- used to remove a Question and all related records from the database. This method does not return any values.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delServiceStatus
(@ServiceStatusID int,
 @Result varchar(25) Output)
As
-- Used to delete a Service Status record from the database. Validation will be done that the Service Status is not
-- in use any more, before the deletion will take place.
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO









/* Object: Stored procedure */
CREATE Procedure jtsp_delUserGroup
(@UserID int,
 @GroupID int)
As
-- Used to remove a user from a Group in the Gatekeeper database.
Begin
  Delete PersonGroup
  Where PersonID = @UserID
  And GroupID = @GroupID
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









/* Object: Stored procedure */CREATE Procedure jtsp_delUserProduct
(@UserID int,
 @UserName varchar(50),
 @ProductID int,
 @ProductName varchar(100))
As
-- Used to remove the link between a user and a Product.
Begin
  If @UserID = 0
  Begin
    Select @UserID = PersonID From Person
    Where UserName = @UserName
  End

  If @ProductID = 0
  Begin
    Select @ProductID = ProductID From Product
    Where Description = @ProductName
  End

  Delete PersonProduct
  Where PersonID = @UserID 
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getGroupMemberList
(@GroupID int)
As
-- Returns a list of users in a group.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getNotification
As
-- Returns all records where the datesent is null!!
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getProduct (@ProductID int) As
-- Return details for a specific Product in the Gatekeeper database.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getProductServiceList
(@ProductID int)
As
-- Used to retrieve a list of all services related to a selected product.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getService
(@ServiceID int)
As
-- Retrieves details of a selected Service in the Gatekeeper database, usually for editing purposes.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_getServiceList
As
-- Retrieves a list of all Services in the Gatekeeper database.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insGroupProduct
(@GroupID int,
 @ProductID int,
 @SecurityLevelID int)
As
-- Method used to link all users in a Group to a Product.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insNotification (@PersonID int, @Code Int) As
-- Insert a record to indicate that a Person's details has changed and to send a Notification
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









/* Object: Stored procedure */
Create Procedure jtsp_insProductNotification (@ProductID Int, @URL Varchar(200), @WSDLURL Varchar(200), @Name Varchar(100), @Namespace Varchar(150)) As

/*
18/2/2003  Thys  Created. Add/update Product Notification details
*/

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









/* Object: Stored procedure */CREATE Procedure jtsp_insService
(@ServiceID int OUTPUT,
 @ProductID int,
 @ServiceStatusID int,
 @Description varchar(100))
As
-- Method to save the details of a Service.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insUserAnswer
(@UserID int,
 @QuestionID int,
 @Answer varchar(100))
As
-- Method used to add/update an answer for a user to a question, for password reminders.
Begin
  If Exists (Select PersonID, QuestionID From Answer 
             Where PersonID = @UserID And QuestionID = @QuestionID)
    Begin
      Update Answer
      Set Answer = @Answer
      Where PersonID = @UserID
      And QuestionID = @QuestionID
    End
  Else
    Begin
      Insert Into Answer (QuestionID, PersonID, Answer)
      Select @QuestionID, @UserID, @Answer
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insUserGroup
(@UserID int,
 @GroupID int)
As
-- Used to add a User to a Group in the Gatekeeper database. The system will check that the user is not
-- already a member of the Group before adding the record. 
Begin
  If Not Exists (Select PersonID, GroupID From PersonGroup Where PersonID = @UserID And GroupID = @GroupID)
    Begin
      Insert Into PersonGroup (PersonID, GroupID)
      Select @UserID, @GroupID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insUserProduct
(@UserID int,
 @UserName varchar(50),
 @ProductID int,
 @ProductName varchar(100),
 @SecurityLevelID int)
As
-- Method used to link a user to a Product, and assign a security level to the user. If a user is already
-- linked to a Product, the system will update the SecurityLevel associated with that product only.
Begin
  Declare @ServiceStatusID int

  If @UserID = 0  
  Begin
    Select @UserID = PersonID From Person Where UserName = @UserName
  End

  If @ProductID = 0
  Begin
    Select @ProductID = ProductID From Product Where Description = @ProductName
  End

  If Exists (Select PersonID, ProductID From PersonProduct
             Where PersonID = @UserID And ProductID = @ProductID)
  Begin
    Update PersonProduct
    Set SecurityLevelID = @SecurityLevelID
		Where PersonID = @UserID
			And ProductID = @ProductID
  End
  Else
  Begin
    Insert Into PersonProduct (PersonID, ProductID, SecurityLevelID)
    Select @UserID, @ProductID, @SecurityLevelID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_updNotification
(@PersonID int,
 @ProductID int,
 @Code Int)
As
-- Update the record where the datesent column is null
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO









/* Object: Stored procedure */
CREATE Procedure jtsp_updService
(@ServiceID int,
 @Status varchar(15))
As
-- Used to restore a Service record on the Gatekeeper database that was previously marked as inactive.
-- Used to mark a Service record as inactive on the Gatekeeper database. The system will check that the Service is
-- no longer in use before attempting the delete of the record.
-- Used to lock a service in the Gatekeeper database. This will not prevent access to the Service,
-- but will inform the Service when a user is validated that the Service should not allow any
-- transactional processing to occur.
-- Used to unlock a service in the Gatekeeper database that was previously locked.
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









/* Object: Stored procedure */
Create Procedure jtsp_updServiceStatus
(@ServiceID int,
 @Status varchar(15))
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

CREATE  Procedure um_GetPersonList (@GroupID int)
		/*	-----------------------------------------------------------------------
			Procedure: um_GetPersonList
				- Stored procedure for retrieving users within a group (or all).
			Parameters:
				@GroupID:		Group identifier
			Returns:
				0:	Success
				n:	Some error condition
			-----------------------------------------------------------------------	*/
	As
	-- Retrieves users within a group (or all).
	Begin
		If @GroupID > 0 
			Select	Person.PersonID, 
					UserName, 
					Password, 
					FirstName, 
					Surname, 
					Email, 
					TelNo, 
					CellPhone,
					Token, 
					Person.PersonStatusID, 
					PersonStatusDesc = PersonStatus.Description,
					PersonGroup.GroupID
			From Person
				Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
				Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
				Where PersonGroup.GroupID = @GroupID
					and Person.PersonID > 5
		Else
			Select	PersonID, 
					UserName, 
					Password, 
					FirstName, 
					Surname, 
					Email, 
					TelNo, 
					CellPhone,
					Token, 
					Person.PersonStatusID, 
					PersonStatusDesc = PersonStatus.Description
			From Person
				Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					and Person.PersonID > 5
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









/* Object: Stored procedure */


CREATE   Procedure um_GetPersonProfiles
(@UserID int)
As
-- Retrieves the groups (profiles) for a user.
Begin
  Select PersonGroup.PersonID, PersonGroup.GroupID, Groups.GroupStatusID, 
	 GroupDesc = Groups.Description, GroupStatus = GroupStatus.Description
  From PersonGroup
  Inner Join Groups On PersonGroup.GroupID = Groups.GroupID
  Inner Join GroupStatus On Groups.GroupStatusID = GroupStatus.GroupStatusID
  Where PersonID = @UserID
  Order by GroupDesc
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



CREATE       Procedure um_GetProductServiceRightList
(@ProductID int)
As
-- Used to retrieve a list of all services related to a selected product.
Begin
	If @ProductID > 0 
		Select Distinct ProductID = Service.ProductID, ProductDesc = Product.Description, 
		     Service.ServiceID, ServiceDesc = Service.Description, 
		     SecurityLevel.SecurityLevelID, SecurityLevelDesc = SecurityLevel.Description
			From Service
			Inner Join Product On Service.ProductID = Product.ProductID
			Cross Join SecurityLevel
			Where Service.ProductID = @ProductID
			Order by Service.ProductID, Service.ServiceDesc, SecurityLevel.Description
	Else
		Select Distinct ProductID = Service.ProductID, ProductDesc = Product.Description, 
		     Service.ServiceID, ServiceDesc = Service.Description, 
		     SecurityLevel.SecurityLevelID, SecurityLevelDesc = SecurityLevel.Description
			From Service
			Inner Join Product On Service.ProductID = Product.ProductID
			Cross Join SecurityLevel
			Order by Service.ProductID, Service.ServiceDesc, SecurityLevel.Description
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












CREATE    Procedure um_InsUserProfile
(@UserID int,
 @GroupID int)
As
-- Used to add a User to a Group in the Gatekeeper database. The system will check that the user is not
-- already a member of the Group before adding the record. 

Begin
	CREATE TABLE #ServiceTemp ([PersonID] [int], [ServiceID] [int], [SecurityLevelID] [int])
		Insert into #ServiceTemp ([PersonID], [ServiceID], [SecurityLevelID])
		Select 	PersonService.PersonID,
				PersonService.ServiceID, 
				PersonService.SecurityLevelID from PersonService
				Join ProfileService
					on ProfileService.ServiceID = PersonService.ServiceID and ProfileService.SecurityLevelID = PersonService.SecurityLevelID
				Where PersonService.PersonID = @UserID and ProfileService.GroupID = @GroupID
End

Begin

	If Not Exists (Select PersonID, GroupID From PersonGroup Where PersonID = @UserID And GroupID = @GroupID)
		Begin
			Insert Into PersonGroup (PersonID, GroupID)
			Select @UserID, @GroupID
		End
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
	Select @UserID, ProfileService.ServiceID, ProfileService.SecurityLevelID
		From ProfileService 
		Where ProfileService.GroupID = @GroupID
			and ServiceID NOT IN ( 
			Select ServiceID from #ServiceTemp
			)

	Drop table #ServiceTemp
	
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










/* Object: Stored procedure */



CREATE    Procedure um_SearchPersonList
(@GroupID int,
 @SearchName varchar(20),
 @SearchNo varchar(20),
 @Exact int)
As
-- Retrieves users within a group (or all).
Begin
If @GroupID > 0 
	Select Person.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
	     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description,
	     PersonGroup.GroupID
	From Person
	Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
	Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
	Where PersonGroup.GroupID = @GroupID
			and (UserName Like @SearchName + '%'
				Or FirstName Like @SearchName + '%'
				Or Surname Like @SearchName + '%'
				Or TelNo Like @SearchNo + '%'
				Or CellPhone Like @SearchNo + '%')
Else
	Begin
		If @Exact > 0
			Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
			     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
			From Person
			Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
			Where UserName = @SearchName Or CellPhone = @SearchNo
		Else
			Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
			     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
			From Person
			Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
			Where UserName Like @SearchName + '%'
				Or FirstName Like @SearchName + '%'
				Or Surname Like @SearchName + '%'
				Or TelNo Like @SearchNo + '%'
				Or CellPhone Like @SearchNo + '%'
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




CREATE      Procedure um_SearchPersonListAdvanced
(@GroupID int,
 @SearchUserID varchar(20),
 @SearchUserName varchar(20),
 @SearchFirstName varchar(20),
 @SearchSurname varchar(20),
 @SearchEmail varchar(20),
 @SearchTelNo varchar(20),
 @SearchCellNo varchar(20)
)
As
-- Retrieves users within a group (or all).
Begin
	If @GroupID > 0 
		Select Person.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
		     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description,
		     PersonGroup.GroupID
		From Person
		Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
		Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
		Where PersonGroup.GroupID = @GroupID
				and (Person.PersonID Like @SearchUserID + '%'
					Or UserName Like @SearchUserName + '%'
					Or FirstName Like @SearchFirstName + '%'
					Or Surname Like @SearchSurname + '%'
					Or TelNo Like @SearchTelNo + '%'
					Or CellPhone Like @SearchCellNo + '%'
					Or Email Like @SearchEmail + '%')
	Else
		Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
		     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
		From Person
		Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
		Where PersonID Like @SearchUserID + '%'
			Or UserName Like @SearchUserName + '%'
			Or FirstName Like @SearchFirstName + '%'
			Or Surname Like @SearchSurname + '%'
			Or TelNo Like @SearchTelNo + '%'
			Or CellPhone Like @SearchCellNo + '%'
			Or Email Like @SearchEmail + '%'
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

CREATE Procedure x_UserAnswerAdd (
		@UserID int,
		@QuestionID int,
		@Answer varchar(100)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Add/update an answer for a user to a question, for password reminders.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If Exists (Select PersonID, QuestionID From Answer Where PersonID = @UserID And QuestionID = @QuestionID)
				Begin
					Update Answer
						Set Answer = @Answer
						Where PersonID = @UserID And QuestionID = @QuestionID
				End
			Else
				Begin
					Insert Into Answer (QuestionID, PersonID, Answer)
					Select @QuestionID, @UserID, @Answer
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

CREATE Procedure x_UserFind (
		@GroupID int,
		@SearchName varchar(20),
		@SearchNo varchar(20),
		@Exact int
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_UserFind
			- Stored procedure for retrieving users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
			@SearchName:	Name or partial name to search on
			@SearchNo:		Name or partial number to search on
			@Exact:			Flag for exact search, exact=1
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @GroupID > 0 
				Select P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					 Token, P.PersonStatusID, PersonStatusDesc = PS.Description,
					 PG.GroupID
				From Person as P
				Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
				Inner Join PersonGroup as PG On P.PersonID = PG.PersonID
				Where PG.GroupID = @GroupID
						and (UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%')
			Else
				Begin
					If @Exact > 0
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
							 Token, StatusID = P.PersonStatusID, Status = PS.Description
						From Person as P
						Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
						Where UserName = @SearchName Or CellPhone = @SearchNo
					Else
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
							 Token, StatusID = P.PersonStatusID, Status = PS.Description
						From Person as P
						Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
						Where UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%'
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

CREATE Procedure x_UserFindAdvanced (
		@GroupID int,
		@SearchUserID varchar(20),
		@SearchUserName varchar(20),
		@SearchFirstName varchar(20),
		@SearchSurname varchar(20),
		@SearchEmail varchar(20),
		@SearchTelNo varchar(20),
		@SearchCellNo varchar(20)
	)
	/*	-----------------------------------------------------------------------
		Procedure: x_UserFindAdvanced
			- Stored procedure for retrieving users within a group (or all).
			- Uses non-exact matches on a number of parameters
		Parameters:
			@GroupID:			Group identifier
			@SearchUserID:		User's identifier
			@SearchUserName:	User's username
			@SearchFirstName:	User's first name
			@SearchSurname:		User's surname
			@SearchEmail:		User's email address
			@SearchTelNo:		User's contact (not cell) number
			@SearchCellNo:		User's cell number
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @GroupID > 0 
				Select P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					 Token, StatusID = P.PersonStatusID, Status = PS.Description, PG.GroupID
				From Person as P
				Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
				Inner Join PersonGroup as PG On P.PersonID = PG.PersonID
				Where PG.GroupID = @GroupID
						and (P.PersonID Like @SearchUserID + '%'
							Or UserName Like @SearchUserName + '%'
							Or FirstName Like @SearchFirstName + '%'
							Or Surname Like @SearchSurname + '%'
							Or TelNo Like @SearchTelNo + '%'
							Or CellPhone Like @SearchCellNo + '%'
							Or Email Like @SearchEmail + '%')
			Else
				Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					 Token, StatusID = P.PersonStatusID, Status = PS.Description
				From Person as P
				Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
				Where PersonID Like @SearchUserID + '%'
					Or UserName Like @SearchUserName + '%'
					Or FirstName Like @SearchFirstName + '%'
					Or Surname Like @SearchSurname + '%'
					Or TelNo Like @SearchTelNo + '%'
					Or CellPhone Like @SearchCellNo + '%'
					Or Email Like @SearchEmail + '%'
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

CREATE Procedure x_UserGroupAdd (
		@UserID int,
		@GroupID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Add a User to a Group in the Gatekeeper database. 
			Checks that the user is not already a member of the Group before adding the record. 
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If Not Exists (Select PersonID, GroupID From PersonGroup Where PersonID = @UserID And GroupID = @GroupID)
				Begin
					Insert Into PersonGroup (PersonID, GroupID) Select @UserID, @GroupID
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

CREATE Procedure x_UserGroupDelete (
		@UserID int,
		@GroupID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove a user from a Group in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Delete PersonGroup Where PersonID = @UserID And GroupID = @GroupID
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

CREATE Procedure x_UserList (@GroupID int)
	/*	-----------------------------------------------------------------------
		Procedure: x_UserList
			Retrieves users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @GroupID > 0 
				Select	Person.PersonID, 
						UserName, 
						Password, 
						FirstName, 
						Surname, 
						Email, 
						TelNo, 
						CellPhone,
						Token, 
						Person.PersonStatusID, 
						PersonStatusDesc = PersonStatus.Description,
						PersonGroup.GroupID
				From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
					Where PersonGroup.GroupID = @GroupID
						and Person.PersonID > 5
			Else
				Select	PersonID, 
						UserName, 
						Password, 
						FirstName, 
						Surname, 
						Email, 
						TelNo, 
						CellPhone,
						Token, 
						Person.PersonStatusID, 
						PersonStatusDesc = PersonStatus.Description
				From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
						and Person.PersonID > 5
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

CREATE Procedure x_UserProductAdd (
		@UserID int,
		@UserName varchar(50),
		@ProductID int,
		@ProductName varchar(100),
		@SecurityLevelID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Method used to link a user to a Product, and assign a security level to the user. If a user is already
			linked to a Product, the system will update the SecurityLevel associated with that product only.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @ServiceStatusID int

			If @UserID = 0  
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
			If @ProductID = 0
				Begin
					Select @ProductID = ProductID From Product Where Description = @ProductName
				End
			If Exists (Select PersonID, ProductID From PersonProduct Where PersonID = @UserID And ProductID = @ProductID)
				Begin
					Update PersonProduct
						Set SecurityLevelID = @SecurityLevelID
						Where PersonID = @UserID And ProductID = @ProductID
				End
			Else
				Begin
					Insert Into PersonProduct (PersonID, ProductID, SecurityLevelID)
						Select @UserID, @ProductID, @SecurityLevelID
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

CREATE Procedure x_UserProductDelete (
		@UserID int,
		@UserName varchar(50),
		@ProductID int,
		@ProductName varchar(100)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove the link between a user and a Product.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @UserID = 0
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
				
			If @ProductID = 0
				Begin
					Select @ProductID = ProductID From Product Where Description = @ProductName
				End

			Delete PersonProduct Where PersonID = @UserID And ProductID = @ProductID
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

CREATE Procedure x_UserProfileAdd (
		@UserID int,
		@GroupID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to add a User to a Group in the Gatekeeper database. 
			The system will check that the user is not already a member of the Group before adding the record. 
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			CREATE TABLE #ServiceTemp ([PersonID] [int], [ServiceID] [int], [SecurityLevelID] [int])
				Insert into #ServiceTemp ([PersonID], [ServiceID], [SecurityLevelID])
				Select 	PersonService.PersonID,
						PersonService.ServiceID, 
						PersonService.SecurityLevelID from PersonService
						Join ProfileService
							on ProfileService.ServiceID = PersonService.ServiceID and ProfileService.SecurityLevelID = PersonService.SecurityLevelID
						Where PersonService.PersonID = @UserID and ProfileService.GroupID = @GroupID
		End
		Begin
			If Not Exists (Select PersonID, GroupID From PersonGroup Where PersonID = @UserID And GroupID = @GroupID)
				Begin
					Insert Into PersonGroup (PersonID, GroupID)
					Select @UserID, @GroupID
				End
			Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
			Select @UserID, ProfileService.ServiceID, ProfileService.SecurityLevelID
				From ProfileService 
				Where ProfileService.GroupID = @GroupID
					And ServiceID NOT IN (Select ServiceID from #ServiceTemp)
			Drop table #ServiceTemp
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

CREATE Procedure x_UserProfileList (@UserID int)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves the groups (profiles) for a user.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Select PersonGroup.PersonID, 
				PersonGroup.GroupID, 
				Groups.GroupStatusID, 
				GroupDesc = Groups.Description, 
				GroupStatus = GroupStatus.Description
				From PersonGroup
					Inner Join Groups On PersonGroup.GroupID = Groups.GroupID
					Inner Join GroupStatus On Groups.GroupStatusID = GroupStatus.GroupStatusID
				Where PersonID = @UserID
				Order by GroupDesc
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

CREATE Procedure x_UserQuestionValidate (
		@UserID int,
		@QuestionID int,
		@Answer varchar(100),
		@Result varchar(50) OUTPUT
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Validates a user's answer to a question against a value in the Gatekeeper database. 
			If the answer matches the answer stored in the database for the User and Question, 
			the method will return OK;
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @CorrectAns varchar(100)
			
			Select @CorrectAns = Answer
				From Answer 
				Where PersonID = @UserID
					And QuestionID = @QuestionID
			
			If @CorrectAns = @Answer
				Begin
					Select @Result = 'OK'
				End
			Else
				Begin
					Select @Result = 'Incorrect Answer'
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

CREATE Procedure x_UserSearch (
		@GroupID int,
		@SearchName varchar(20),
		@SearchNo varchar(20),
		@Exact int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves users within a group (or all).
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
		If @GroupID > 0 
				Select Person.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
				     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description,
				     PersonGroup.GroupID
				From Person
				Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
				Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
				Where PersonGroup.GroupID = @GroupID
						and (UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%')
		Else
				Begin
					If @Exact > 0
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
						     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
						From Person
						Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
						Where UserName = @SearchName Or CellPhone = @SearchNo
					Else
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
						     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
						From Person
						Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
						Where UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%'
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

CREATE Procedure x_UserSearchAdvanced (
		@GroupID int,
		@SearchUserID varchar(20),
		@SearchUserName varchar(20),
		@SearchFirstName varchar(20),
		@SearchSurname varchar(20),
		@SearchEmail varchar(20),
		@SearchTelNo varchar(20),
		@SearchCellNo varchar(20)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves users within a group (or all).
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
				If @GroupID > 0 
					Select Person.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description,
					     PersonGroup.GroupID
					From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
					Where PersonGroup.GroupID = @GroupID
							and (Person.PersonID Like @SearchUserID + '%'
								Or UserName Like @SearchUserName + '%'
								Or FirstName Like @SearchFirstName + '%'
								Or Surname Like @SearchSurname + '%'
								Or TelNo Like @SearchTelNo + '%'
								Or CellPhone Like @SearchCellNo + '%'
								Or Email Like @SearchEmail + '%')
				Else
					Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
					From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Where PersonID Like @SearchUserID + '%'
						Or UserName Like @SearchUserName + '%'
						Or FirstName Like @SearchFirstName + '%'
						Or Surname Like @SearchSurname + '%'
						Or TelNo Like @SearchTelNo + '%'
						Or CellPhone Like @SearchCellNo + '%'
						Or Email Like @SearchEmail + '%'
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




CREATE   Procedure act_RptUserActivity (@Group int, @Activity int)
As
	Begin
		If @Group = 0
			Select 
				PersonGroup.PersonID, Person.Username,
				Access = count(all ActivityID)
				from PersonGroup
				inner join Person on Person.PersonID = PersonGroup.PersonID
				inner join ActivityLog on ActivityLog.PersonID = PersonGroup.PersonID
				inner join Groups on Groups.GroupID = PersonGroup.GroupID
					where ActivityID = @Activity
				Group by PersonGroup.PersonID, Person.Username
				Order by Access desc
		Else
			Select 
				PersonGroup.PersonID, Person.Username,
				Access = count(all ActivityID)
				from PersonGroup
				inner join Person on Person.PersonID = PersonGroup.PersonID
				inner join ActivityLog on ActivityLog.PersonID = PersonGroup.PersonID
				inner join Groups on Groups.GroupID = PersonGroup.GroupID
					where PersonGroup.GroupID = @Group
					and ActivityID = @Activity
				Group by PersonGroup.PersonID, Person.Username
				Order by Access desc
	End




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE act_RptUserActivityByMonth (@service int)

As
	Begin
		SELECT TOP 100 PERCENT 
			dbo.PersonGroup.PersonID, dbo.Person.Username, COUNT(dbo.ActivityLog.ActivityID) AS Access
		FROM dbo.PersonGroup INNER JOIN
			dbo.Person ON dbo.Person.PersonID = dbo.PersonGroup.PersonID INNER JOIN
                      		dbo.ActivityLog ON dbo.ActivityLog.PersonID = dbo.PersonGroup.PersonID INNER JOIN
                      		dbo.Groups ON dbo.Groups.GroupID = dbo.PersonGroup.GroupID
		WHERE (dbo.ActivityLog.ActivityID = 3) AND 
			(dbo.ActivityLog.ServiceID = @service) AND 
			(dbo.PersonGroup.GroupID = 14) AND 
			(MONTH(dbo.ActivityLog.ActivityDate) = MONTH(GETDATE())) AND 
			(YEAR(dbo.ActivityLog.ActivityDate) = YEAR(GETDATE()))
		GROUP BY dbo.PersonGroup.PersonID, dbo.Person.UserName, dbo.ActivityLog.ServiceID
	End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE PROCEDURE act_RptUserActivityLoginByMonth (@activity int)

As
	Begin
		SELECT TOP 100 PERCENT 
			dbo.PersonGroup.PersonID, dbo.Person.Username, COUNT(dbo.ActivityLog.ActivityID) AS Access
		FROM dbo.PersonGroup INNER JOIN
			dbo.Person ON dbo.Person.PersonID = dbo.PersonGroup.PersonID INNER JOIN
                      		dbo.ActivityLog ON dbo.ActivityLog.PersonID = dbo.PersonGroup.PersonID INNER JOIN
                      		dbo.Groups ON dbo.Groups.GroupID = dbo.PersonGroup.GroupID
		WHERE (dbo.ActivityLog.ActivityID = @activity) AND 
			(dbo.PersonGroup.GroupID = 14) AND 
			(MONTH(dbo.ActivityLog.ActivityDate) = MONTH(GETDATE())) AND 
			(YEAR(dbo.ActivityLog.ActivityDate) = YEAR(GETDATE()))
		GROUP BY dbo.PersonGroup.PersonID, dbo.Person.UserName
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



CREATE Procedure act_RptUserActivityService (@Group int, @Service int)
As
	Begin
		If @Group = 0
			Select 
				PersonGroup.PersonID, Person.Username,
				Access = count(all ActivityID)
				from PersonGroup
				inner join Person on Person.PersonID = PersonGroup.PersonID
				inner join ActivityLog on ActivityLog.PersonID = PersonGroup.PersonID
				inner join Groups on Groups.GroupID = PersonGroup.GroupID
					where ActivityID = 3 
					and ActivityLog.ServiceID = @Service
				Group by PersonGroup.PersonID, Person.Username, ActivityLog.ServiceID
				Order by Access desc
		Else
			Select 
				PersonGroup.PersonID, Person.Username,
				Access = count(all ActivityID)
				from PersonGroup
				inner join Person on Person.PersonID = PersonGroup.PersonID
				inner join ActivityLog on ActivityLog.PersonID = PersonGroup.PersonID
				inner join Groups on Groups.GroupID = PersonGroup.GroupID
					where ActivityID = 3 
					and ActivityLog.ServiceID = @Service
					and PersonGroup.GroupID = @Group
				Group by PersonGroup.PersonID, Person.Username, ActivityLog.ServiceID
				Order by Access desc
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









/* Object: Stored procedure */CREATE Procedure jtsp_delActivity 
(@ActivityID int,
 @Result varchar(25) Output)
As
--Used to remove an Activity record from the Gatekeeper database. The system will check that the record
-- is no longer in use before attempting the delete.
Begin
  If Exists (Select ActivityID From ActivityLog
             Where ActivityID = @ActivityID)
    Begin
      Select @Result = 'Cannot delete'
    End
  Else
    Begin
      Delete Activity
      Where ActivityID = @ActivityID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delGroup (@GroupID int) As
-- Used to completely delete a Group from the Gatekeeper database. The system will also remove any links
--  between any users and the group, and remove them as well.
Begin
  Delete PersonGroup
  Where GroupID = @GroupID

  Delete Groups
  Where GroupID = @GroupID

	Exec jtsp_insNotification @GroupID, 203
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









/* Object: Stored procedure */
Create Procedure jtsp_delGroupService
(@GroupID int,
 @ServiceID int)
As
-- Method used to remove the link between all users in a Group and a Service.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delProduct
(@ProductID int)
As
-- Permanently removes a product from the Gatekeeper database. Any links between Users 
-- and the selected product will also be removed. Any services linked to the product will also
--  be removed, as well as any links to those services.
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









/* Object: Stored procedure */
CREATE Procedure jtsp_delSecurityLevel
(@SecurityLevelID int,
 @Result varchar(25) Output)
As
-- Used to remove a Security Level record from the Gatekeeper database. The system will check that the
-- record is not in use any more before attempting to delete the record.
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO









/* Object: Stored procedure */
CREATE Procedure jtsp_delService
(@ServiceID int)
As
-- Used to completely remove a Service record from the Gatekeeper database. Any links from Users to the service
-- will also be removed.
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




CREATE  Procedure jtsp_delUser
(@UserID int,
 @UserName varchar(50))
As
-- Remove a user from the Gatekeeper database. All records associated with the user will also be removed
-- ie. all service and product links, group links and activity logged.
Begin

  If @UserID = 0 Or @UserID IS NULL
  Begin
    Select @UserID = PersonID From Person Where UserName = @UserName
  End

  -- Delete the PersonService record!
  Delete PersonService
  Where PersonID = @UserID

  -- Delete the PersonGroup record!
  Delete PersonGroup
  Where PersonID = @UserID

  -- Delete the PersonProduct record!
  Delete PersonProduct
  Where PersonID = @UserID

  -- Delete the ActivityLog record!
  Delete ActivityLog
  Where PersonID = @UserID

  -- Delete the Answer record!
  Delete Answer
  Where PersonID = @UserID

  -- Delete the Person record!
  Delete Person
  Where PersonID = @UserID

	Exec jtsp_insNotification @UserID, 104

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









/* Object: Stored procedure */
CREATE Procedure jtsp_delUserService
(@UserID int,
 @UserName varchar(50),
 @ServiceID int,
 @ServiceName varchar(100))
As
-- Remove the link between a user and specific service.
Begin
  Declare @NewUserID int
  Declare @NewServiceID int

  If @UserID = 0  
    Begin
      Select @NewUserID = PersonID From Person Where UserName = @UserName
    End
  Else
    Begin
      Select @NewUserID = @UserID
    End

  If @ServiceID = 0
    Begin
      Select @NewServiceID = ServiceID From Service Where Description = @ServiceName
    End
  Else
    Begin
      Select @NewServiceID = @ServiceID
    End

  Delete PersonService
  Where PersonID = @NewUserID
  And ServiceID = @NewServiceID
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









/* Object: Stored procedure */


CREATE Procedure jtsp_getPersonServiceList
(@PersonID int, @ServiceID int)
As
-- The name of a service to return the access to, and also relevant permissions and status information.
Begin
  If @ServiceID = 0 --Return all Services where PersonID linked to
    Begin
      Select Service.ServiceID,
						 ServiceIdentifier, 
             Service.Description, 
             ServiceStatus.Description As Status, 
             ServiceStatus.DisplayMessage, 
             SecurityLevel.Description As SecurityLevel
      From PersonService 
      Inner Join Service On PersonService.ServiceID = Service.ServiceID
      Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
      Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
			Where PersonID = @PersonID
    End
  Else --Return only specific Service information
    Begin
      Select Service.ServiceID,
						 ServiceIdentifier, 
             Service.Description, 
             ServiceStatus.Description As Status, 
             ServiceStatus.DisplayMessage, 
             SecurityLevel.Description As SecurityLevel
      From PersonService 
      Inner Join Service On PersonService.ServiceID = Service.ServiceID
      Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
      Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
      Where PersonService.PersonID = @PersonID
				And PersonService.ServiceID = @ServiceID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insGroup
(@GroupID int OUTPUT,
 @Description varchar(100),
 @GroupStatusID int)
As
-- Used to add/update a Group record in the Gatekeeper database. All Group descriptions must be unique. The Group ID is assigned
-- when the record is created in the database, and will be returned to the user.
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

	Exec jtsp_insNotification @GroupID, 200

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









/* Object: Stored procedure */
CREATE Procedure jtsp_insGroupService
(@GroupID int,
 @ServiceID int,
 @SecurityLevelID int)
As
-- Method used to link all users in a Group to a Service
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insPerson
(@UserName varchar(50),
 @Password varchar(50),
 @FirstName varchar(50),
 @Surname varchar(50),
 @Email varchar(50),
 @TelNo varchar(35),
 @CellNo varchar(20),
 @UserID int OUTPUT)
As
-- Used to register a user on the Gatekeeper system. This method will only be called once for a user, when
-- they register to use the system. The system will assign a User ID to the user, which will be returned,
-- but which the user should not know - it is for internal referencing only. All updates associated with
-- the user will be done using the User ID. This method will most likely be called by a user interface
-- where the user has the option to register to make use of the online services which the Gatekeeper controls
-- access to.
Begin
  Declare @PasswExpiryDate int, @PasswordExpiryDate datetime

  Select @PasswExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
  Select @PasswordExpiryDate = DATEADD(dd, @PasswExpiryDate, getdate())

  If Not Exists (Select UserName From Person Where UserName = @UserName)
    Begin 
      If Not Exists (Select CellPhone From Person Where CellPhone = @CellNo)
        Begin 
          Insert Into Person (UserName, Password, FirstName, Surname,
                              Email, TelNo, CellPhone, PasswordExpiryDate,
                              LoginFailures, PersonStatusID)
          Select @UserName, @Password, @FirstName, @Surname,
                 @Email, @TelNo, @CellNo, @PasswordExpiryDate,
                 0, 1
         
          Select @UserID = @@IDENTITY

					Exec jtsp_insNotification @UserID, 100
        End
      Else
        Begin
          Select @UserID = 0
        End     
    End
  Else
    Begin
      Select @UserID = 0      
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









/* Object: Stored procedure */
CREATE Procedure jtsp_insUserService
(@UserID int,
 @UserName varchar(50),
 @ServiceID int,
 @ServiceName varchar(100),
 @SecurityLevelID int,
 @ServiceIdentifier varchar(50))
As
-- Link a user to a selected service.
Begin
  Declare @ServiceStatusID int

  If @UserID = 0  
  Begin
    Select @UserID = PersonID From Person Where UserName = @UserName
  End

  If @ServiceID = 0
  Begin
    Select @ServiceID = ServiceID From Service Where Description = @ServiceName
  End

  If Not Exists (Select * From PersonService
             Where PersonID = @UserID And ServiceID = @ServiceID And SecurityLevelID = @SecurityLevelID)
  Begin
    Insert Into PersonService (PersonID, ServiceID, SecurityLevelID, ServiceIdentifier)
    Select @UserID, @ServiceID, @SecurityLevelID, @ServiceIdentifier
  End

  Update PersonService
  Set ServiceIdentifier = @ServiceIdentifier
  Where PersonID = @UserID
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









/* Object: Stored procedure */
CREATE Procedure jtsp_logActivity
(@ActivityID int,
 @PersonID int,
 @ServiceID int,
 @Token uniqueidentifier)
As
-- Log an activity in the Gatekeeper database.
Begin
  Insert Into ActivityLog (ActivityID, PersonID, ServiceID, Token, ActivityDate)
  Select @ActivityID, @PersonID, @ServiceID, @Token, getdate()
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









/* Object: Stored procedure */
CREATE Procedure jtsp_updGroup (@GroupID int, @Status varchar(25)) As
-- Used to mark a Group record as deleted on the Gatekeeper database. The record will NOT be physically removed from
--  the database, but flagged as deleted/inactive.
-- Used to restore a Group record that was previously deleted on the Gatekeeper database.
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
		Exec jtsp_insNotification @GroupID, 201
	End
	If @Status = 'Active' And @PrevStatus = 'Deleted' -- Undelete Group
	Begin
		Exec jtsp_insNotification @GroupID, 202
	End
	If @Status = 'Locked'
	Begin
		Exec jtsp_insNotification @GroupID, 204
	End
	If @Status = 'Active' And @PrevStatus = 'Locked' -- Unlock Group
	Begin
		Exec jtsp_insNotification @GroupID, 205
	End

End










GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/* Object: Stored procedure */
CREATE Procedure jtsp_updPerson
	(@UserID int,
	@UserName varchar(50),
	@FirstName varchar(50),
	@Surname varchar(50),
	@Email varchar(50),
	@TelNo varchar(35),
	@CellNo varchar(20),
	@PersonStatusID int,
	@Result Varchar(50) OUTPUT)
As
	-- Mark a user as inactive on the database.
	-- Restore a user who was previously delete to active status.
Begin
	If Exists(Select * From Person Where PersonID = @UserID)
		Begin
			If Exists(Select * From Person Where Username = @UserName AND PersonID <> @UserID)
				Begin
					Select @Result = 'Invalid Username supplied - Username already exists.'
				End
			Else
				Begin
					Update Person
					Set UserName = @UserName,
					FirstName = @FirstName,
					Surname = @Surname,
					Email = @Email,
					TelNo = @TelNo,
					CellPhone = @CellNo,
					PersonStatusID = @PersonStatusID
					Where PersonID = @UserID
					Exec jtsp_insNotification @UserID, 101
				End
		End
	Else
		Begin
			Select @Result = 'Invalid User ID supplied - User does not exist.'
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









/* Object: Stored procedure */
CREATE Procedure jtsp_updPersonStatus
(@PersonID int,
 @UserName Varchar(50),
 @Status varchar(50))
As
-- Unlock a user from accessing transactional systems managed by the Gatekeeper, using the User/Login Name.
-- Can do the same by locking - set a user's status!
Begin

	If @PersonID = 0 Or @PersonID IS NULL
	Begin
		Select @PersonID = PersonID
		From Person
		Where UserName = @UserName
	End

	If @PersonID = 0 Or @PersonID IS NULL
	Begin
		Return
	End

	Declare @PrevStatus Varchar(50)
	Select @PrevStatus = Description
	From PersonStatus
	Inner Join Person On Person.PersonStatusID = PersonStatus.PersonStatusID
	Where PersonID = @PersonID

  Update Person
  Set PersonStatusID = PersonStatus.PersonStatusID
  From PersonStatus
  Where PersonID = @PersonID
  	And Description = @Status

	If @Status = 'Deleted'
	Begin
		Exec jtsp_insNotification @PersonID, 102
	End
	If @Status = 'Active' And @PrevStatus = 'Deleted' -- Undelete User
	Begin
		Exec jtsp_insNotification @PersonID, 103
	End
	If @Status = 'Locked'
	Begin
		Exec jtsp_insNotification @PersonID, 105
	End
	If @Status = 'Active' And @PrevStatus = 'Locked' -- Unlock User
	Begin
		Exec jtsp_insNotification @PersonID, 106
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









/* Object: Stored procedure */

CREATE  Procedure jtsp_validatePerson
(@Token uniqueidentifier,
 @Service varchar(100),
 @Userid int OUTPUT,
 @Result Varchar(100) OUTPUT)
As
-- The name of a service to return the access to, and also relevant permissions and status information.
Begin
  Declare @PersonID int
  Declare @ServiceID int
	Declare @TokenDate Int, @TExpiryDate DateTime

  Select @PersonID = PersonID, @TExpiryDate = TokenExpiryDate From Person Where Token = @Token
  Select @Userid = @PersonID
  Select @ServiceID = ServiceID From Service Where Description = @Service

	If @TExpiryDate IS NULL Or DateDiff(n, Getdate(), @TExpiryDate) < 0
	Begin
		Select @Result = 'User session has expired, or user has not yet logged in.'
		Return
	End

  Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
  Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())

  Update Person
  Set TokenExpiryDate = @TExpiryDate,
      LastLoginDate = getdate()
  Where PersonID = @PersonID        

  If @Service = '' --Return all Services where PersonID linked to
    Begin
      Select PersonService.PersonID,
						 Service.ServiceID,
						 ServiceIdentifier, 
             Service.Description, 
             ServiceStatus.Description As Status, 
             ServiceStatus.DisplayMessage, 
             SecurityLevel.Description As SecurityLevel
      From PersonService 
      Inner Join Service On PersonService.ServiceID = Service.ServiceID
      Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
      Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
			Where PersonID = @PersonID
    End
  Else --Return only specific Service information
    Begin
      Select PersonService.PersonID,
						 Service.ServiceID,
						 ServiceIdentifier, 
             Service.Description, 
             ServiceStatus.Description As Status, 
             ServiceStatus.DisplayMessage, 
             SecurityLevel.Description As SecurityLevel
      From PersonService 
      Inner Join Service On PersonService.ServiceID = Service.ServiceID
      Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
      Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
      Where PersonService.PersonID = @PersonID
				And PersonService.ServiceID = @ServiceID
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









/* Object: Stored procedure */

Create Procedure um_DelProfileService
(@GroupID int,
 @ServiceID int,
 @SecurityLevelID int)
As
-- Method used to remove the link between a Profile and a Service.
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO











CREATE  Procedure um_DelUserProfile
(@UserID int,
 @GroupID int)

As
-- Used to remove a Profile from a User in the Gatekeeper database (remove user from Group). 
-- Will also remove the rights (ServiceID/SecurityLevelID) associated with the Profile
Begin
	Begin
		Delete PersonGroup
		Where PersonID = @UserID
		And GroupID = @GroupID
	End
	Begin
		Delete PersonService
			Where PersonID = @UserID 
			AND ServiceID IN
				(SELECT ServiceID
					FROM ProfileService
						WHERE GroupID = @GroupID
						AND ProfileService.SecurityLevelID = PersonService.SecurityLevelID
				)
			AND ServiceID NOT IN
				(SELECT	PersonService.ServiceID
					FROM PersonService 
					INNER JOIN ProfileService
					ON PersonService.ServiceID = ProfileService.ServiceID
					AND ProfileService.SecurityLevelID = PersonService.SecurityLevelID
						WHERE PersonService.PersonID = @UserID
						AND ProfileService.GroupID IN
							(SELECT GroupID
								FROM PersonGroup
									WHERE PersonID = @UserID
									AND GroupID <> @GroupID
							)
				)
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









/* Object: Stored procedure */

CREATE  Procedure um_GetProductService
As
-- The name of a service to return the access to, and also relevant permissions and status information.
Begin
Select Service.ServiceID,
             SecurityLevel.SecurityLevelID,
             ServiceStatus.ServiceStatusID 
      From PersonService 
      Inner Join Service On PersonService.ServiceID = Service.ServiceID
      Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
      Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
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









/* Object: Stored procedure */



CREATE   Procedure um_GetProductServiceList
(@ProductID int)
As
-- Used to retrieve a list of all services related to a selected product.
Begin
If @ProductID > 0 
  Select Distinct ProductID = Service.ProductID, ProductDesc = Product.Description, 
         ProfileService.ServiceID, ServiceDesc = Service.Description, 
         ProfileService.SecurityLevelID, SecurityLevelDesc = SecurityLevel.Description
  From ProfileService
  Inner Join Service On ProfileService.ServiceID = Service.ServiceID
  Inner Join SecurityLevel On ProfileService.SecurityLevelID = SecurityLevel.SecurityLevelID
  Inner Join Product On Service.ProductID = Product.ProductID
  Where Service.ProductID = @ProductID
Else
  Select Distinct ProductID = Service.ProductID, ProductDesc = Product.Description, 
         ProfileService.ServiceID, ServiceDesc = Service.Description, 
         ProfileService.SecurityLevelID, SecurityLevelDesc = SecurityLevel.Description
  From ProfileService
  Inner Join Service On ProfileService.ServiceID = Service.ServiceID
  Inner Join SecurityLevel On ProfileService.SecurityLevelID = SecurityLevel.SecurityLevelID
  Inner Join Product On Service.ProductID = Product.ProductID
  Order by ProfileService.ProductID, ProfileService.ServiceID
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




CREATE     Procedure um_GetProfileRightsList
(@GroupID int)
As
-- Used to retrieve a list of all services related to a selected profile.
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO











CREATE      Procedure um_InsPersonFromUsers
As
Begin
	Declare @PasswExpiryDate int, @PasswordExpiryDate datetime
	Declare @Profile int
	
	Select @PasswExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
	Select @PasswordExpiryDate = DATEADD(dd, @PasswExpiryDate, getdate())


	Insert into Person ([UserName], [Password], [FirstName], [Surname], 
						[EMail], [TelNo], [CellPhone], [PasswordExpiryDate],
						[LoginFailures], [PersonStatusID])
		Select 	[UserName], [Password], [FirstName], [Surname], 
				[EMail], [TelNo], [CellPhone], @PasswordExpiryDate, 0, 5
			From Users
			Where [CustDealStaff] != 'Dealer' and [CustDealStaff] != 'Staff'
	
	-- Set fields that should be NOT NULL constrained:
	Declare @value varchar(50)

	-- Set FirstName:
	Select @value = '?'
	Update Person
		Set FirstName = @value
			Where FirstName is NULL
	-- Set Email:
	Update Person
		Set EMail = @value
			Where EMail is NULL
	-- Set TelNo:
	Update Person
		Set TelNo = @value
			Where TelNo is NULL

	-- Create a 'web customer' profile for all users 
	-- Add to Group
	Select @Profile = 6
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Where PersonID > 5
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile

	-- Create 'Corporate administrator - standard' profile for users 
	-- Add to Group
	Select @Profile = 7
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Inner Join Users On Person.UserName = Users.UserName 
			Where PersonID > 5 and Users.Type = 'Administrator' and Users.[Option] = 'Standard'
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile

	-- Create 'Corporate administrator - premium' profile for users 
	-- Add to Group
	Select @Profile = 8
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Inner Join Users On Person.UserName = Users.UserName 
			Where PersonID > 5 and Users.Type = 'Administrator' and Users.[Option] = 'Premium'
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile

	-- Create 'Corporate user' profile for users 
	-- Add to Group
	Select @Profile = 9
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Inner Join Users On Person.UserName = Users.UserName 
			Where PersonID > 5 and Users.Type = 'Corporate'
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile

	-- Create 'Individual subscriber - standard' profile for users 
	-- Add to Group
	Select @Profile = 10
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Inner Join Users On Person.UserName = Users.UserName 
			Where PersonID > 5 and Users.Type = 'Individual' and Users.[Option] = 'Standard'
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile

	-- Create 'Individual subscriber - premium' profile for users 
	-- Add to Group
	Select @Profile = 11
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Inner Join Users On Person.UserName = Users.UserName 
			Where PersonID > 5 and Users.Type = 'Individual' and Users.[Option] = 'Premium'
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile

	-- Create 'Prepaid administrator' profile for users 
	-- Add to Group
	Select @Profile = 12
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Where PersonID > 5 and UserName Like '777%'
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile

	-- Create 'Dealer' profile for users 
	-- Add to Group
	Select @Profile = 14
	Insert into PersonGroup(PersonID, GroupID)
		Select PersonID, @Profile From Person
			Inner Join Users On Person.UserName = Users.UserName 
			Where PersonID > 5 and Users.CustDealStaff = 'LCR Dealer'
	-- Now add Service/SecurityLevel from group profile
	Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
		Select PersonID, ProfileService.ServiceID, ProfileService.SecurityLevelID
			From ProfileService 
			Join PersonGroup on  PersonGroup.GroupID = ProfileService.GroupID
			Where ProfileService.GroupID = @Profile
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









/* Object: Stored procedure */


CREATE Procedure um_InsProfileService
(@GroupID int,
 @ServiceID int,
 @SecurityLevelID int)
As
-- Method used to link all users in a Group to a Service
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

CREATE Procedure x_ActivityDelete (
		@ActivityID int,
		@Result varchar(25) Output
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove an Activity record from the Gatekeeper database. 
			The system will check that the record is no longer in use before attempting the delete.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If Exists (Select ActivityID From ActivityLog Where ActivityID = @ActivityID)
				Begin
					Select @Result = 'Cannot delete'
				End
			Else
				Begin
					Delete Activity
						Where ActivityID = @ActivityID
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

CREATE Procedure x_ActivityLog (
		@ActivityID int,
		@PersonID int,
		@ServiceID int,
		@Token uniqueidentifier
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Log an activity in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Insert Into ActivityLog (ActivityID, PersonID, ServiceID, Token, ActivityDate)
			Select @ActivityID, @PersonID, @ServiceID, @Token, getdate()
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


CREATE Procedure x_UpdateGroupService (@GroupID int, @ServiceID int, @SecurityLevelID int)
/* -----------------------------------------------------------------------
Procedure: Template
- Stored procedure for...
- something else about the procedure
Parameters:
@parameter1: Description of @parameter1...
@parameter2: Description of @parameter2...
Returns:
0: Success
n: Some error condition
----------------------------------------------------------------------- */
As
Begin
-- Declarations:
-- Code:
Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
Select pg.PersonID, @ServiceID, @SecurityLevelID
From PersonGroup as pg
Where pg.GroupID = @GroupID
and pg.PersonID not in (Select PersonID from PersonService where ServiceID = @ServiceID)

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

CREATE Procedure x_UserAdd (
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@UserID int OUTPUT
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to register a user on the Gatekeeper system. This method will only be called once for a user, when
			they register to use the system. The system will assign a User ID to the user, which will be returned,
			but which the user should not know - it is for internal referencing only. All updates associated with
			the user will be done using the User ID. This method will most likely be called by a user interface
			where the user has the option to register to make use of the online services which the Gatekeeper controls
			access to.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
		Declare @PasswExpiryDate int, @PasswordExpiryDate datetime
		Select @PasswExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
		Select @PasswordExpiryDate = DATEADD(dd, @PasswExpiryDate, getdate())
		
		If Not Exists (Select UserName From Person Where UserName = @UserName)
			Begin 
				If Not Exists (Select CellPhone From Person Where CellPhone = @CellNo)
					Begin 
						Insert Into Person (UserName, Password, FirstName, Surname, Email, TelNo, CellPhone, PasswordExpiryDate, LoginFailures, PersonStatusID)
							Select @UserName, @Password, @FirstName, @Surname, @Email, @TelNo, @CellNo, @PasswordExpiryDate, 0, 1
							Select @UserID = @@IDENTITY
							Exec jtsp_insNotification @UserID, 100
					End
				Else
					Begin
						Select @UserID = 0
					End     
			End
		Else
			Begin
				Select @UserID = 0      
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

CREATE Procedure x_UserDelete (
		@UserID int,
		@UserName varchar(50)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Remove a user from the Gatekeeper database. All records associated with the user will also be removed
			ie. all service and product links, group links and activity logged.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @UserID = 0 Or @UserID IS NULL
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
			-- Delete the PersonService record!
			Delete PersonService Where PersonID = @UserID
			-- Delete the PersonGroup record!
			Delete PersonGroup Where PersonID = @UserID
			-- Delete the PersonProduct record!
			Delete PersonProduct Where PersonID = @UserID
			-- Delete the ActivityLog record!
			Delete ActivityLog Where PersonID = @UserID
			-- Delete the Answer record!
			Delete Answer Where PersonID = @UserID
			-- Delete the Person record!
			Delete Person Where PersonID = @UserID
			Exec jtsp_insNotification @UserID, 104
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

CREATE Procedure x_UserProfileDelete (
		@UserID int,
		@GroupID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove a Profile from a User in the Gatekeeper database (remove user from Group). 
			Will also remove the rights (ServiceID/SecurityLevelID) associated with the Profile
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Begin
				Delete PersonGroup
				Where PersonID = @UserID
				And GroupID = @GroupID
			End
			Begin
				Delete PersonService
					Where PersonID = @UserID 
					AND ServiceID IN
						(SELECT ServiceID
							FROM ProfileService
								WHERE GroupID = @GroupID
								AND ProfileService.SecurityLevelID = PersonService.SecurityLevelID
						)
					AND ServiceID NOT IN
						(SELECT	PersonService.ServiceID
							FROM PersonService 
							INNER JOIN ProfileService
							ON PersonService.ServiceID = ProfileService.ServiceID
							AND ProfileService.SecurityLevelID = PersonService.SecurityLevelID
								WHERE PersonService.PersonID = @UserID
								AND ProfileService.GroupID IN
									(SELECT GroupID
										FROM PersonGroup
											WHERE PersonID = @UserID
											AND GroupID <> @GroupID
									)
						)
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

CREATE Procedure x_UserServiceAdd (
		@UserID int,
		@UserName varchar(50),
		@ServiceID int,
		@ServiceName varchar(100),
		@SecurityLevelID int,
		@ServiceIdentifier varchar(50)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Link a user to a selected service.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @ServiceStatusID int
			If @UserID = 0  
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
			If @ServiceID = 0
				Begin
					Select @ServiceID = ServiceID From Service Where Description = @ServiceName
				End
			If Not Exists (Select * From PersonService Where PersonID = @UserID And ServiceID = @ServiceID And SecurityLevelID = @SecurityLevelID)
				Begin
					Insert Into PersonService (PersonID, ServiceID, SecurityLevelID, ServiceIdentifier)
						Select @UserID, @ServiceID, @SecurityLevelID, @ServiceIdentifier
				End
			Update PersonService
				Set ServiceIdentifier = @ServiceIdentifier
				Where PersonID = @UserID And ServiceID = @ServiceID
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

CREATE Procedure x_UserServiceDelete (
		@UserID int,
		@UserName varchar(50),
		@ServiceID int,
		@ServiceName varchar(100)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Remove the link between a user and specific service.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @NewUserID int
			Declare @NewServiceID int
			
			If @UserID = 0  
				Begin
					Select @NewUserID = PersonID From Person Where UserName = @UserName
				End
			Else
				Begin
					Select @NewUserID = @UserID
				End

			If @ServiceID = 0
				Begin
					Select @NewServiceID = ServiceID From Service Where Description = @ServiceName
				End
			Else
				Begin
					Select @NewServiceID = @ServiceID
				End

			Delete PersonService Where PersonID = @NewUserID And ServiceID = @NewServiceID
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

CREATE Procedure x_UserServiceList (
		@PersonID int, 
		@ServiceID int
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			The name of a service to return the access to, and also relevant permissions and status information.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @ServiceID = 0 --Return all Services where PersonID linked to
				Begin
					Select Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonID = @PersonID
				End
			Else --Return only specific Service information
				Begin
					Select Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonService.PersonID = @PersonID
								And PersonService.ServiceID = @ServiceID
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

CREATE Procedure x_UserStatusUpdate (
		@PersonID int,
		@UserName Varchar(50),
		@Status varchar(50)
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Unlock a user from accessing transactional systems managed by the Gatekeeper, using the User/Login Name.
			Can do the same by locking - set a user's status!
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			If @PersonID = 0 Or @PersonID IS NULL
				Begin
					Select @PersonID = PersonID From Person
						Where UserName = @UserName
				End
			If @PersonID = 0 Or @PersonID IS NULL
				Begin
					Return
				End
			Declare @PrevStatus Varchar(50)
			Select @PrevStatus = Description
				From PersonStatus
					Inner Join Person On Person.PersonStatusID = PersonStatus.PersonStatusID
					Where PersonID = @PersonID
			Update Person
				Set PersonStatusID = PersonStatus.PersonStatusID
				From PersonStatus
					Where PersonID = @PersonID And Description = @Status
			If @Status = 'Deleted'
				Begin
					Exec jtsp_insNotification @PersonID, 102
				End
			If @Status = 'Active' And @PrevStatus = 'Deleted' -- Undelete User
				Begin
					Exec jtsp_insNotification @PersonID, 103
				End
			If @Status = 'Locked'
				Begin
					Exec jtsp_insNotification @PersonID, 105
				End
			If @Status = 'Active' And @PrevStatus = 'Locked' -- Unlock User
				Begin
					Exec jtsp_insNotification @PersonID, 106
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

CREATE Procedure x_UserUpdate (
		@UserID int,
		@UserName varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@PersonStatusID int,
		@Result Varchar(50) OUTPUT
	)
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
	As
		Begin
			If Exists(Select * From Person Where PersonID = @UserID)
				Begin
					If Exists(Select * From Person Where Username = @UserName AND PersonID <> @UserID)
						Begin
							Select @Result = 'Invalid Username supplied - Username already exists.'
						End
					Else
						Begin
							Update Person
							Set UserName = @UserName,
								FirstName = @FirstName,
								Surname = @Surname,
								Email = @Email,
								TelNo = @TelNo,
								CellPhone = @CellNo,
								PersonStatusID = @PersonStatusID
							Where PersonID = @UserID
							Exec jtsp_insNotification @UserID, 101
						End
				End
			Else
				Begin
					Select @Result = 'Invalid User ID supplied - User does not exist.'
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

CREATE Procedure x_UserValidate (
		@Token uniqueidentifier,
		@Service varchar(100),
		@Userid int OUTPUT,
		@Result Varchar(100) OUTPUT
	)
	/*	-----------------------------------------------------------------------
		Procedure: Template
			relevant permissions and status information.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As
		Begin
			Declare @PersonID int
			Declare @ServiceID int
			Declare @TokenDate Int, @TExpiryDate DateTime
			Select @PersonID = PersonID, @TExpiryDate = TokenExpiryDate From Person Where Token = @Token
			Select @Userid = @PersonID
			Select @ServiceID = ServiceID From Service Where Description = @Service

			If @TExpiryDate IS NULL Or DateDiff(n, Getdate(), @TExpiryDate) < 0
				Begin
					Select @Result = 'User session has expired, or user has not yet logged in.'
					Return
				End
				
			Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
			Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
			Update Person
				Set TokenExpiryDate = @TExpiryDate, LastLoginDate = getdate()
				Where PersonID = @PersonID
				
			If @Service = '' --Return all Services where PersonID linked to
				Begin
					Select PersonService.PersonID,
						Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonID = @PersonID
				End
			Else --Return only specific Service information
				Begin
					Select PersonService.PersonID,
						Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonService.PersonID = @PersonID And PersonService.ServiceID = @ServiceID
				End
		End
	
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

