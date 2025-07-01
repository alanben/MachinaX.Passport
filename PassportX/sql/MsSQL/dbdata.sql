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
	Add default data into tables
	-----------------------------------------------------------------------	*/
	
	INSERT INTO passport.GroupStatus (Description)SELECT 'Active' GO
	INSERT INTO passport.GroupStatus (Description)SELECT 'Inactive' GO

	INSERT INTO passport.ServiceStatus (Description, DisplayMessage)SELECT 'Active', '' GO
	INSERT INTO passport.ServiceStatus (Description, DisplayMessage)SELECT 'Inactive', 'This service is currently unavailable' GO
	INSERT INTO passport.ServiceStatus (Description, DisplayMessage)SELECT 'Locked', 'This service is currently unavailable' GO

	INSERT INTO passport.ProductStatus (Description, DisplayMessage)SELECT 'Active', '' GO
	INSERT INTO passport.ProductStatus (Description, DisplayMessage)SELECT 'Inactive', 'This product is currently unavailable' GO
	INSERT INTO passport.ProductStatus (Description, DisplayMessage)SELECT 'Locked', 'This product is currently unavailable' GO

	INSERT INTO passport.PersonStatus (Description)SELECT 'Active' GO
	INSERT INTO passport.PersonStatus (Description)SELECT 'Inactive' GO
	INSERT INTO passport.PersonStatus (Description)SELECT 'Locked' GO
	INSERT INTO passport.PersonStatus (Description)SELECT 'ON-hold' GO
	INSERT INTO passport.PersonStatus (Description)SELECT 'Legacy' GO

	INSERT INTO passport.Config (Description, RetValue)SELECT 'LoginFailures', '3' GO
	INSERT INTO passport.Config (Description, RetValue)SELECT 'PasswordExpiryDate', '365' GO
	INSERT INTO passport.Config (Description, RetValue)SELECT 'SessionExpiryTime', '60' GO 
	INSERT INTO passport.Config (Description, RetValue)SELECT 'AccLockedDate', '8' GO

	INSERT INTO passport.Person (username, password, firstname, surname, email, telno, cellphone, personstatusid, loginfailures, passwordexpirydate) SELECT 'admin', 'password', 'System', 'Administrator', 'passportX@mrretirement.co.za', '', '', 1, 0, '31 Dec 2100' GO
	INSERT INTO passport.Product (Description, ProductStatusID)SELECT 'PassportX', 1 GO

	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UndeleteUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'LockUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'LockUserService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UnlockUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UpdatePassword' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveUserService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteUserService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveUserProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteUserProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveUserGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteUserGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SavePersonStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeletePersonStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UndeleteGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveGroupService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveGroupProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteGroupService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteGroupProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'LockGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UnlockGroup' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveGroupStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveGroupStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetProductServiceList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UndeleteProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'LockProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UnlockProduct' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveProductStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteProductStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetServiceList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UndeleteService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'LockService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UnlockService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveServiceStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetServiceStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetServiceStatusList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteServiceStatus' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveSecurityLevel' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetSecurityLevel' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetSecurityLevelList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteSecurityLevel' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveActivity' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveActivity' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetActivity' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetActivityList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'LogActivity' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetActivityLog' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveConfigValue' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetConfigValue' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetConfigValueList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteConfigValue' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveQuestion' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetQuestion' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetQuestionList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteQuestion' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SendPassword' GO
	-- Reserved starts at 70
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'Reserved' GO
	-- Gatekeep services start at 80
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RegisterUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveProfile' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetProfile' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveProfile' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveProfileService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetProfileRightsList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteProfileService' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetUserList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SearchUserList' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetUsers' GO

	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetUsersSort' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetUserRights' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetUserProfiles' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'SaveUserProfile' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'DeleteUserProfile' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'AddUserProfile' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'RemoveUserProfile' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'UpdateUser' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'ImportUsers' GO
	INSERT INTO passport.Service (productid, ServiceStatusID, Description) SELECT 1, 1, 'GetGroups' GO

	-- Add the Authentication Server SecurityLevels
	INSERT INTO passport.SecurityLevel (Description)
	SELECT 'administer' GO

	-- Add Administrator Service rights
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 1, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 2, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 3, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 4, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 5, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 6, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 7, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 8, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 9, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 10, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 11, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 12, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 13, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 14, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 15, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 16, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 17, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 18, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 19, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 20, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 21, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 22, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 23, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 24, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 25, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 26, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 27, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 28, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 29, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 30, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 31, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 32, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 33, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 34, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 35, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 36, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 37, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 38, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 39, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 40, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 41, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 42, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 43, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 44, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 45, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 46, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 47, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 48, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 49, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 50, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 51, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 52, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 53, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 54, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 55, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 56, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 57, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 58, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 59, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 60, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 61, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 62, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 63, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 64, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 65, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 66, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 67, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 68, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 69, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 70, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 71, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 72, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 73, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 74, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 75, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 76, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 77, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 78, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 79, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 80, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 81, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 82, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 83, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 84, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 85, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 86, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 87, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 88, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 89, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 90, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 91, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 92, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 93, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 94, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 95, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 96, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 97, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 98, 1 GO
	INSERT INTO passport.PersonService (PersonID, ServiceID, SecurityLevelID) SELECT 1, 99, 1 GO

	INSERT INTO passport.RecruitType (Description)SELECT 'Subscriber' GO
	INSERT INTO passport.RecruitType (Description)SELECT 'Non-subscriber' GO
