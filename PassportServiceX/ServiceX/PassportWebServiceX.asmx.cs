using System;
using System.Collections;
using System.ComponentModel;
using System.Xml;
using System.Diagnostics;
using System.Web;
using System.Web.Services;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20070531
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	-------------------------------------------------------------------------------------------------
	Note re MachinaX.PassportX:
	------------------------------------
	The refactoring mentioned below is intended to result in a code base that can be migrated
	into the MachinaX framework as follows:
	- Base classes migrated to the MachinaX.PassportX namespace.
	- Web Service classes migrated to the MachinaX.PassportServiceX namespace.
	- Web service classes can remain in an implementation class (eg NashuaMobile.Gatekeeper)
	Note: Once this is completed the Gatekeeper code will become dependant on PassportX base classes.
		  If this is not desired, a fork in the codebase will be created at that stage.
	-------------------------------------------------------------------------------------------------	*/
	
/*	-------------------------------------------------------------------------------------------------
	Development Notes:
	20070531:	Starting point from NMGatekeeper.2.0.2.
	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX.PassportServiceX {
	/// <summary>
	/// This PassportService class is
	/// </summary>
	[WebService(Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX")]
	public class PassportWebServiceX : PassportBaseX {
		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor for the NMPortal Web Service
		/// </summary>
		public PassportWebServiceX() : base() {
		}
/*		
		[WebMethod] public XmlDocument CheckToken(string Token, string Service) {
			return _Validate(Token, Service);
		}
*/
		#endregion

		#region User related methods
		/// <summary>
		/// Used to register a user on the Gatekeeper system. This method will only be called once for a user, when
		/// they register to use the system. The system will assign a User ID to the user, which will be returned,
		/// but which the user should not know - it is for internal referencing only. All updates associated with
		/// the user will be done using the User ID. This method will most likely be called by a user interface
		/// where the user has the option to register to make use of the online services which the Gatekeeper controls
		/// access to.
		/// </summary>
		/// <param name="UserName">The login name the user has chosen. This name must be unique in the system. The Register routine will check for this, and if it is not unique, will return an appropriate error message.</param>
		/// <param name="Password">The password or PIN the user has chosen. No rules have been associated with this field, although it cannot be empty.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's mobile telephone number.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:<br>
		/// &lt;User UserID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/User&gt;<br><br>
		/// If the save is successful, the ResultCode will be 0 (zero) and the UserID attribute will contain the value assigned
		/// to the user by the Gatekeeper system. If not, the Result will contain the error code and message or reason the
		/// save failed, as well as all the details the user supplied, except for the password.
		/// </returns>
		protected XmlDocument _RegisterUser(string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo) {
			XmlDocument registerUser;
			_User = new x_user(DSN);
			registerUser = _User.RegisterUser(UserName, Password, FirstName, Surname, EMail, TelNo, CellNo);
			_User = null;
			return registerUser;
		}


		/// <summary>
		/// Save a User's details - database implementation will check if no UserID is present, a new 
		/// user record is created.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID number used to uniquely identify a user.</param>
		/// <param name="UserName">The login name the user will use to access all systems controlled by the Gatekeeper system. This name must be unique in the Gatekeeper database.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address. This will remain constant and is not affected by any subscriptions the user has.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's personal cellphone number.</param>
		/// <param name="PersonStatusID">The status of the user - linked to the PersonStatus Lookup</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:<br>
		/// &lt;User UserID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/User&gt;<br><br>
		/// If the save is successful, the ResultCode will be 0 (zero) and the UserID attribute will contain the value assigned
		/// to the user by the Gatekeeper system. If not, the Result will contain the error code and message or reason indicating why
		/// save failed.
		/// </returns>
		protected XmlDocument _SaveUser(string Token, int UserID, string UserName, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID) {
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUser");
			XmlDocument saveUser;
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUser = _User.SaveUser(UserID, UserName,  FirstName, Surname, EMail, TelNo, CellNo, PersonStatusID);
				_User = null;
			} else {
				saveUser = new XmlDocument();
				saveUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return saveUser;
		}
	

		/// <summary>
		/// Retrieves a specific user's details for display or editing on a user interface.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:<br>
		/// &lt;User UserID=""&gt;<br>
		/// &nbsp;&lt;UserName/&gt;<br>
		/// &nbsp;&lt;FirstName/&gt;<br>
		/// &nbsp;&lt;Surname/&gt;<br>
		/// &nbsp;&lt;EMail/&gt;<br>
		/// &nbsp;&lt;TelNo/&gt;<br>
		/// &nbsp;&lt;CellNo/&gt;<br>
		/// &nbsp;&lt;Status PersonStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &lt;/User&gt;
		/// </returns>
		protected XmlDocument _GetUser(string Token, int UserID) {
			XmlDocument getUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				getUser = _User.GetUser(UserID);
				_User = null;
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return getUser;
		}


		/// <summary>
		/// Overloaded method to retrieve a user's details using the User Name / Login Name.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="Username">The user's login name used to access all systems managed by the Gatekeeper system</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:<br>
		/// &lt;User UserID=""&gt;<br>
		/// &nbsp;&lt;UserName/&gt;<br>
		/// &nbsp;&lt;FirstName/&gt;<br>
		/// &nbsp;&lt;Surname/&gt;<br>
		/// &nbsp;&lt;EMail/&gt;<br>
		/// &nbsp;&lt;TelNo/&gt;<br>
		/// &nbsp;&lt;CellNo/&gt;<br>
		/// &nbsp;&lt;Status PersonStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &lt;/User&gt;
		/// </returns>
		protected XmlDocument _GetUserByName(string Token, string Username) {
			XmlDocument getUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				getUser = _User.GetUser(Username);
				_User = null;
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return getUser;
		}


		/// <summary>
		/// Method used to retrieve a user by passing in the Token of the user.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserToken">The login Token of the user to be queried.</param>
		protected XmlDocument _GetUserByToken(string Token, string UserToken) {
			XmlDocument getUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				getUser = _User.GetUser(UserToken);
				_User = null;
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return getUser;
		}


		/// <summary>
		/// Mark a user as inactive on the database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID, used to uniquely identify a user.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		protected bool _DeleteUser(string Token, int UserID) {
			bool deleteUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUser = _User.DeleteUser(UserID);
				_User = null;
			} else {
				deleteUser = false;
			}
			return deleteUser;
		}


		/// <summary>
		/// Overloaded function - mark a user as inactive on the database, using the Login Name to identify the user.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login Name.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		protected bool _DeleteUserByName(string Token, string UserName) {
			bool deleteUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUser = _User.DeleteUser(UserName);
				_User = null;
			} else {
				deleteUser = false;
			}
			return deleteUser;
		}


		/// <summary>
		/// Restore a user who was previously delete to active status.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user. Function can also be called using the Login Name / User Name.</param>
		/// <returns>
		/// A boolean value, indicating whether the user was successfully restored.
		/// </returns>
		protected bool _UndeleteUser(string Token, int UserID) {
			bool undeleteUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UndeleteUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				undeleteUser = _User.UndeleteUser(UserID);
				_User = null;
			} else {
				undeleteUser = false;
			}
			return undeleteUser;
		}


		/// <summary>
		/// Overloaded function - restore a user who was previously deleted, using the Login Name / User Name.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User name</param>
		/// <returns>
		/// A boolean value indicating whether the user was successfully restored.
		/// </returns>
		protected bool _UndeleteUserByName(string Token, string UserName) {
			bool undeleteUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UndeleteUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				undeleteUser = _User.UndeleteUser(UserName);
				_User = null;
			} else {
				undeleteUser = false;
			}
			return undeleteUser;
		}


		/// <summary>
		/// Remove a user from the Gatekeeper database. All records associated with the user will also be removed
		/// ie. all service and product links, group links and activity logged.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID, used to uniquely identify a user.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		protected bool _RemoveUser(string Token, int UserID) {
			bool removeUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				removeUser = _User.RemoveUser(UserID);
				_User = null;
			} else {
				removeUser = false;
			}
			return removeUser;
		}


		/// <summary>
		/// Remove a user from the Gatekeeper database. All records associated with the user will also be removed
		/// ie. all service and product links, group links and activity logged.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User name</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		protected bool _RemoveUserByName(string Token, string UserName) {
			bool removeUserByName;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				removeUserByName = _User.RemoveUser(UserName);
				_User = null;
			} else {
				removeUserByName = false;
			}
			return removeUserByName;
		}


		/// <summary>
		/// Lock a user from all transactional systems - this will prevent the user from accessing any such systems
		/// until such time as the user is unlocked. This will not prevent the user from logging into the system,
		/// but will limit most functionality to View Only.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <returns>A boolean value indicating whether the Lock was successful or not.</returns>
		protected bool _LockUser(string Token, int UserID) {
			bool lockUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LockUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				lockUser = _User.LockUser(UserID);
				_User = null;
			} else {
				lockUser = false;
			}
			return lockUser;
		}


		/// <summary>
		/// Overloaded method - Lock a user from all transactional systems using the Login/User Name. This will prevent the user from accessing any such systems
		/// until such time as the user is unlocked. This will not prevent the user from logging into the system,
		/// but will limit most functionality to View Only.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User Name</param>
		/// <returns>A boolean value indicating whether the Lock was successful or not.</returns>
		protected bool _LockUserByName(string Token, string UserName) {
			bool lockUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LockUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				lockUser = _User.LockUser(UserName);
				_User = null;
			} else {
				lockUser = false;
			}
			return lockUser;
		}


		/// <summary>
		/// Block access for a user to a specific service only
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <param name="ServiceName">The name of the service to be blocked.</param>
		/// <returns>
		/// A boolean value indicating whether the Lock was successful or not.
		/// </returns>
		protected bool _LockUserService(string Token, int UserID, string ServiceName) {
			bool lockUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LockUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				lockUser = _User.LockUser(UserID, ServiceName);
				_User = null;
			} else {
				lockUser = false;
			}
			return lockUser;
		}


		/// <summary>
		/// Block access for a user to a specific service only
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User Name</param>
		/// <param name="ServiceName">The name of the service to be blocked.</param>
		/// <returns>
		/// A boolean value indicating whether the Lock was successful or not.
		/// </returns>
		protected bool _LockUserServiceByName(string Token, string UserName, string ServiceName) {
			bool lockUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LockUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				lockUser = _User.LockUser(UserName, ServiceName);
				_User = null;
			} else {
				lockUser = false;
			}
			return lockUser;
		}


		/// <summary>
		/// Unlock a user from accessing transactional systems managed by the Gatekeeper.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <returns>A boolean value indicating whether the update was successful.</returns>
		protected bool _UnlockUser(string Token, int UserID) {
			bool unlockUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UnlockUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				unlockUser = _User.UnlockUser(UserID);
				_User = null;
			} else {
				unlockUser = false;
			}
			return unlockUser;
		}


		/// <summary>
		/// Overloaded method - Unlock a user from accessing transactional systems managed by the Gatekeeper, using the User/Login Name.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's User/Login name, used to access systems managed by the Gatekeeper system.</param>
		/// <returns>A boolean value indicating whether the update was successful.</returns>
		protected bool _UnlockUserByName(string Token, string UserName) {
			bool unlockUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UnlockUser");
			if (validUser == null) {
				_User = new x_user(DSN);
				unlockUser = _User.UnlockUser(UserName);
				_User = null;
			} else {
				unlockUser = false;
			}
			return unlockUser;
		}


		/// <summary>
		/// Update a user's password. Method will validate the old password, against the saved password for verification purposes.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <param name="OldPassword">The user's current password.</param>
		/// <param name="Password">The new password for the user.</param>
		/// <returns>
		/// An XmlDocument object, which contains information on the result of the method in the following format:<br>
		/// &lt;User&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/User&gt;<br><br>
		/// If the update is successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code and message or reason indicating why
		/// update failed.
		/// </returns>
		protected XmlDocument _UpdatePassword(string Token, int UserID, string OldPassword, string Password) {
			XmlDocument updatePassword;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UpdatePassword");
			if (validUser == null) {
				_User = new x_user(DSN);
				updatePassword = _User.UpdatePassword(UserID, OldPassword, Password);
				_User = null;
			} else {
				updatePassword = new XmlDocument();
				updatePassword.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return updatePassword;
		}


		/// <summary>
		/// Update a user's password. Method will validate the old password, against the saved password for verification purposes.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User name.</param>
		/// <param name="OldPassword">The user's current password.</param>
		/// <param name="Password">The new password for the user.</param>
		/// <returns>
		/// An XmlDocument object, which contains information on the result of the method in the following format:<br>
		/// &lt;User&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/User&gt;<br><br>
		/// If the update is successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code and message or reason indicating why
		/// update failed.
		/// </returns>
		protected XmlDocument _UpdatePasswordByName(string Token, string UserName, string OldPassword, string Password) {
			XmlDocument updatePassword;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UpdatePassword");
			if (validUser == null) {
				_User = new x_user(DSN);
				updatePassword = _User.UpdatePassword(UserName, OldPassword, Password);
				_User = null;
			} else {
				updatePassword = new XmlDocument();
				updatePassword.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return updatePassword;
		}


		/// <summary>
		/// Sends the user's pin/password to their cellphone. This is the only method that implements any
		/// external system, and is dependant on that service to run correctly.
		/// </summary>
		/// <param name="Token">The Token of the Service/Application calling the method, which has already logged on, and has a valid session. The SMS Gateway will validate this token when the SMS is sent.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <returns>A boolean value indicating whether the SMS was sent successfully.</returns>
		protected bool _SendPassword(string Token, int UserID) {
			bool sendPassword;
			_User = new x_user(DSN);
			sendPassword = _User.SendPassword(Token, UserID);
			_User = null;
			return sendPassword;
		}


		/// <summary>
		/// Sends the user's pin/password to their cellphone. This is the only method that implements any
		/// external system, and is dependant on that service to run correctly.
		/// </summary>
		/// <param name="Token">The Token of the Service/Application calling the method, which has already logged on, and has a valid session. The SMS Gateway will validate this token when the SMS is sent.</param>
		/// <param name="UserName">The Login/User Name of the user to send the SMS to.</param>
		/// <returns>A boolean value indicating whether the SMS was sent successfully.</returns>
		protected bool _SendPasswordByName(string Token, string UserName) {
			bool sendPassword;
			_User = new x_user(DSN);
			sendPassword = _User.SendPassword(Token, UserName);
			_User = null;
			return sendPassword;
		}


		/// <summary>
		/// Method used to force the expiry of a user's password, which will force them to renew their password at next logon.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the User on the Gatekeeper database.</param>
		protected void _ExpireUserPassword(string Token, int UserID) {
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UpdatePassword");
			if (validUser == null) {
				_User = new x_user(DSN);
				_User.ExpireUserPassword(UserID);
				_User = null;
			}
		}


		/// <summary>
		/// Method used to add/update an answer for a user to a question, for password reminders.
		/// </summary>
		/// <param name="UserID">The internal ID of the User in the Gatekeeper database</param>
		/// <param name="QuestionID">The internal ID of the Question in the Gatekeeper database</param>
		/// <param name="Answer">The text answer that the user entered in response to the question</param>
		/// <returns>
		/// Returns a boolean value indicating whether save was succesful or not.
		/// </returns>
		protected bool _SaveUserQuestion(int UserID, int QuestionID, string Answer) {
			bool saveUserQuestion;
			_User = new x_user(DSN);
			saveUserQuestion = _User.SaveUserQuestion(UserID, QuestionID, Answer);
			_User = null;
			return saveUserQuestion;
		}


		/// <summary>
		/// Validates a user's answer to a question against a value in the Gatekeeper database. If the answer matches
		/// the answer stored in the database for the User and Question, the method will return True;
		/// </summary>
		/// <param name="UserID">The internal ID of the User in the Gatekeeper database.</param>
		/// <param name="QuestionID">The internal ID of the Question in the Gatekeeper database.</param>
		/// <param name="Answer">The text answer supplied by the user, which will be validated against the answer in the database.</param>
		/// <returns>
		/// Returns a boolean value indicating whether the user's answer to a question is that same as a value stored
		/// in the database. If the user has not previously answered this question, and there is no saved value in the
		/// database, the result will also return false.
		/// </returns>
		protected bool _ValidateUserQuestion(int UserID, int QuestionID, string Answer) {
			bool validateUserQuestion;
			_User = new x_user(DSN);
			validateUserQuestion = _User.ValidateUserQuestion(UserID, QuestionID, Answer);
			_User = null;
			return validateUserQuestion;
		}


		/// <summary>
		/// Link a user to a selected service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <param name="ServiceID">The internal Service ID of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		protected bool _SaveUserService(string Token, int UserID, int ServiceID, int SecurityLevelID, string ServiceIdentifier) {
			bool saveUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserService = _User.SaveUserService(UserID, ServiceID, SecurityLevelID, ServiceIdentifier);
				_User = null;
			} else {
				saveUserService = false;
			}
			return saveUserService;
		}


		/// <summary>
		/// Link a user to a selected service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		protected bool _SaveUserServiceByIDName(string Token, int UserID, string ServiceName, int SecurityLevelID, string ServiceIdentifier) {
			bool saveUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserService = _User.SaveUserService(UserID, ServiceName, SecurityLevelID, ServiceIdentifier);
				_User = null;
			} else {
				saveUserService = false;
			}
			return saveUserService;
		}


		/// <summary>
		/// Link a user to a selected service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceID">The internal Service ID of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		protected bool _SaveUserServiceByNameID(string Token, string UserName, int ServiceID, int SecurityLevelID, string ServiceIdentifier) {
			bool saveUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserService = _User.SaveUserService(UserName, ServiceID, SecurityLevelID, ServiceIdentifier);
				_User = null;
			} else {
				saveUserService = false;
			}
			return saveUserService;
		}


		/// <summary>
		/// Link a user to a selected service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		protected bool _SaveUserServiceByName(string Token, string UserName, string ServiceName, int SecurityLevelID, string ServiceIdentifier) {
			bool saveUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserService = _User.SaveUserService(UserName, ServiceName, SecurityLevelID, ServiceIdentifier);
				_User = null;
			} else {
				saveUserService = false;
			}
			return saveUserService;
		}


		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <param name="ServiceID">The internal Service ID of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		protected bool _DeleteUserService(string Token, int UserID, int ServiceID) {
			bool deleteUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserService = _User.DeleteUserService(UserID, ServiceID);
				_User = null;
			} else {
				deleteUserService = false;
			}
			return deleteUserService;
		}


		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		protected bool _DeleteUserServiceByIDName(string Token, int UserID, string ServiceName) {
			bool deleteUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserService = _User.DeleteUserService(UserID, ServiceName);
				_User = null;
			} else {
				deleteUserService = false;
			}
			return deleteUserService;
		}


		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceID">The internal Service ID of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		protected bool _DeleteUserServiceByNameID(string Token, string UserName, int ServiceID) {
			bool deleteUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserService = _User.DeleteUserService(UserName, ServiceID);
				_User = null;
			} else {
				deleteUserService = false;
			}
			return deleteUserService;
		}


		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		protected bool _DeleteUserServiceByName(string Token, string UserName, string ServiceName) {
			bool deleteUserService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserService");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserService = _User.DeleteUserService(UserName, ServiceName);
				_User = null;
			} else {
				deleteUserService = false;
			}
			return deleteUserService;
		}


		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The internal ID of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The internal ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		protected bool _SaveUserProduct(string Token, int UserID, int ProductID, int SecurityLevelID) {
			bool saveUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserProduct = _User.SaveUserProduct(UserID, ProductID, SecurityLevelID);
				_User = null;
			} else {
				saveUserProduct = false;
			}
			return saveUserProduct;
		}


		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The internal ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		protected bool _SaveUserProductByIDName(string Token, int UserID, string ProductName, int SecurityLevelID) {
			bool saveUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserProduct = _User.SaveUserProduct(UserID, ProductName, SecurityLevelID);
				_User = null;
			} else {
				saveUserProduct = false;
			}
			return saveUserProduct;
		}


		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The internal ID of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The internal ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		protected bool _SaveUserProductByNameID(string Token, string UserName, int ProductID, int SecurityLevelID) {
			bool saveUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserProduct = _User.SaveUserProduct(UserName, ProductID, SecurityLevelID);
				_User = null;
			} else {
				saveUserProduct = false;
			}
			return saveUserProduct;
		}


		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The internal ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		protected bool _SaveUserProductByName(string Token, string UserName, string ProductName, int SecurityLevelID) {
			bool saveUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserProduct = _User.SaveUserProduct(UserName, ProductName, SecurityLevelID);
				_User = null;
			} else {
				saveUserProduct = false;
			}
			return saveUserProduct;
		}


		/// <summary>
		/// Method used to remove the link between a user and a Product.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The internal ID of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		protected bool _DeleteUserProduct(string Token, int UserID, int ProductID) {
			bool deleteUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserProduct = _User.DeleteUserProduct(UserID, ProductID);
				_User = null;
			} else {
				deleteUserProduct = false;
			}
			return deleteUserProduct;
		}


		/// <summary>
		/// Method used to remove the link between a user and a Product.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		protected bool _DeleteUserProductByIDName(string Token, int UserID, string ProductName) {
			bool deleteUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserProduct = _User.DeleteUserProduct(UserID, ProductName);
				_User = null;
			} else {
				deleteUserProduct = false;
			}
			return deleteUserProduct;
		}


		/// <summary>
		/// Method used to remove the link between a user and a Product.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The internal ID of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		protected bool _DeleteUserProductByNameID(string Token, string UserName, int ProductID) {
			bool deleteUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserProduct = _User.DeleteUserProduct(UserName, ProductID);
				_User = null;
			} else {
				deleteUserProduct = false;
			}
			return deleteUserProduct;
		}


		/// <summary>
		/// Method used to remove the link between a user and a Product.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		protected bool _DeleteUserProductByName(string Token, string UserName, string ProductName) {
			bool deleteUserProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserProduct");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserProduct = _User.DeleteUserProduct(UserName, ProductName);
				_User = null;
			} else {
				deleteUserProduct = false;
			}
			return deleteUserProduct;
		}


		/// <summary>
		/// Used to add a User to a Group in the Gatekeeper database. The system will check that the user is not
		/// already a member of the Group before adding the record. This will not cause the method to fail.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the User in the Gatekeeper database.</param>
		/// <param name="GroupID">The internal ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value, indicating whether the save was successful.
		/// </returns>
		protected bool _SaveUserGroup(string Token, int UserID, int GroupID) {
			bool saveUserGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveUserGroup");
			if (validUser == null) {
				_User = new x_user(DSN);
				saveUserGroup = _User.SaveUserGroup(UserID, GroupID);
				_User = null;
			} else {
				saveUserGroup = false;
			}
			return saveUserGroup;
		}


		/// <summary>
		/// Used to remove a user from a Group in the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the User in the Gatekeeper database.</param>
		/// <param name="GroupID">The internal ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns boolean value, indicating whether the delete was successful.
		/// </returns>
		protected bool _DeleteUserGroup(string Token, int UserID, int GroupID) {
			bool deleteUserGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteUserGroup");
			if (validUser == null) {
				_User = new x_user(DSN);
				deleteUserGroup = _User.DeleteUserGroup(UserID, GroupID);
				_User = null;
			} else {
				deleteUserGroup = false;
			}
			return deleteUserGroup;
		}


		/// <summary>
		/// Used to do bulk importing of users.
		/// </summary>
		/// <param name="UsersXML">A string, in XML format, containing information on users, in the following
		/// format:<p>
		/// &lt;Users&gt;<br>
		/// &nbsp;&lt;User&gt;<br>
		/// &nbsp;&nbsp;&lt;UserName/&gt;<br>
		/// &nbsp;&nbsp;&lt;Password/&gt;<br>
		/// &nbsp;&nbsp;&lt;FirstName/&gt;<br>
		/// &nbsp;&nbsp;&lt;Surname/&gt;<br>
		/// &nbsp;&nbsp;&lt;Email/&gt;<br>
		/// &nbsp;&nbsp;&lt;TelNo/&gt;<br>
		/// &nbsp;&nbsp;&lt;CellNo/&gt;<br>
		/// &nbsp;&lt;/User&gt;<br>
		/// &lt;/Users&gt;
		/// </param>
		/// <returns>
		/// Returns an XmlDocument object, indicating whether the import was successful or not, per user, in the following format:<p>
		/// &lt;Users&gt;<br>
		/// &nbsp;&lt;User UserID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;UserName/&gt;<br>
		/// &nbsp;&nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;/Result&gt;<br>
		/// &nbsp;&lt;/User&gt;<br>
		/// &lt;/Users&gt;<p>
		/// If the user is imported successfully, the value of ResultCode will be 0, and the UserID value will contain
		/// the value of the UserID assigned to the user. If the import fails, there will be no UserID value, and the
		/// ResultCode will contain 99999, and the Description the reason for the failure.
		/// </returns>
		protected XmlDocument _ImportUsers(string UsersXML) {
			XmlDocument importUsers;
			_User = new x_user(DSN);
			importUsers = _User.ImportUsers(UsersXML);
			_User = null;
			return importUsers;
		}


		/// <summary>
		/// Get the services for a user.
		/// Token must be a valid (administrator) token.
		/// </summary>
		/// <param name="Token">A string parameter containing the administrator Token.</param>
		/// <param name="UserID">The internal ID of a User for which the service list will be returned.</param>
		/// <returns>
		/// Returns an XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service,
		/// in the following format:<br>
		/// &lt;User&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &nbsp;&lt;Products&gt;<br>
		/// &nbsp;&nbsp;&lt;Product Description="" Status="" DisplayMessage=""/&gt;<br>
		/// &nbsp;&lt;/Products&gt;<br>
		/// &nbsp;&lt;Services&gt;<br>
		/// &nbsp;&nbsp;&lt;Service Description="" Status="" DisplayMessage="" ServiceIdentifier=""/&gt;<br>
		/// &nbsp;&lt;/Services&gt;<br>
		/// &lt;/User&gt;<br><br>
		/// If the validation is successful, the ResultCode will be 0 (zero) and the Products and Services will be
		/// populated with the records where the user has access. If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		protected XmlDocument _GetUserServiceList(string Token, int UserID) {
			XmlDocument getUser;
			_User = new x_user(DSN);
			getUser = _User.GetUserServiceList(UserID, 0);
			_User = null;
			return getUser;
		}
		#endregion

		#region PersonStatus related methods
		/// <summary>
		/// Used to add/update a PersonStatus record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="PersonStatusID">The internal ID of the Person Status record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Person Status. This must be unqiue in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save, in the following format:<br>
		/// &lt;PersonStatus PersonStatusID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/PersonStatus&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 (zero) and the PersonStatusID will contain the
		/// value assigned to the record by the Gatekeeper. If not, the Result will contain an error code and the error description or
		/// reason the save failed.
		/// </returns>
		protected XmlDocument _SavePersonStatus(string Token, int PersonStatusID, string Description) {
			XmlDocument savePersonStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SavePersonStatus");
			if (validUser == null) {
				_UserStatus = new x_userStatus(DSN);
				savePersonStatus = _UserStatus.SavePersonStatus(PersonStatusID, Description);
				_UserStatus = null;
			} else {
				savePersonStatus = new XmlDocument();
				savePersonStatus.LoadXml ("<PersonStatus>" + validUser.OuterXml + "</PersonStatus>");
				validUser = null;
			}
			return savePersonStatus;
		}

		/// <summary>
		/// Return details for a specific Person Status in the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="PersonStatusID">The internal ID of the Person Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object with the following layout:<br>
		/// &lt;PersonStatus PersonStatusID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &lt;/PersonStatus&gt;
		/// </returns>
		protected XmlDocument _GetPersonStatus(int PersonStatusID) {
			XmlDocument getPersonStatus;
			_UserStatus = new x_userStatus(DSN);
			getPersonStatus = _UserStatus.GetPersonStatus(PersonStatusID);
			_UserStatus = null;
			return getPersonStatus;
		}

		/// <summary>
		/// Returns a list of all person status' in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;PersonStatusList&gt;<br>
		/// &nbsp;&lt;PersonStatus PersonStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/PersonStatus&gt;<br>
		/// &lt;/PersonStatusList&gt;
		/// </returns>
		protected XmlDocument _GetPersonStatusList() {
			XmlDocument getPersonStatusList;
			_UserStatus = new x_userStatus(DSN);
			getPersonStatusList = _UserStatus.GetPersonStatusList();
			_UserStatus = null;
			return getPersonStatusList;
		}

		/// <summary>
		/// Used to delete a Person Status record from the database. Validation will be done that the Person Status is not
		/// in use any more, before the deletion will take place.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="PersonStatusID">The internal Person Status ID of the Person Status record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, as below:<br>
		/// &lt;PersonStatus&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/PersonStatus&gt;<br><br>
		/// If the method is successful, the value of ResultCode will be 0 (zero). If not, the Result will contain the
		/// error code and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _DeletePersonStatus(string Token, int PersonStatusID) {
			XmlDocument deletePersonStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeletePersonStatus");
			if (validUser == null) {
				_UserStatus = new x_userStatus(DSN);
				deletePersonStatus = _UserStatus.DeletePersonStatus(PersonStatusID);
				_UserStatus = null;
			} else {
				deletePersonStatus = new XmlDocument();
				deletePersonStatus.LoadXml ("<PersonStatus>" + validUser.OuterXml + "</PersonStatus>");
				validUser = null;
			}
			return deletePersonStatus;
		}
		#endregion

		#region Group-related methods
		/// <summary>
		/// Used to add/update a Group record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Group. This must be unqiue in the Gatekeeper database.</param>
		/// <param name="GroupStatusID">The ID of the GroupStatus indicating the status of this Group record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save, in the following format:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 (zero) and the GroupID will contain the
		/// value assigned to the record by the Gatekeeper. If not, the Result will contain the error code and description or
		/// reason the save failed.
		/// </returns>
		protected XmlDocument _SaveGroup(string Token, int GroupID, string Description, int GroupStatusID) {
			XmlDocument saveGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveGroup");
			if (validUser == null) {
				_Group = new x_group(DSN);
				saveGroup = _Group.SaveGroup(GroupID, Description, GroupStatusID);
				_Group = null;
			} else {
				saveGroup = new XmlDocument();
				saveGroup.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return saveGroup;
		}


		/// <summary>
		/// Return details for a specific Group in the Gatekeeper database.
		/// </summary>
		/// <param name="GroupID">The internal ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object with the following layout:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;Status GroupStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &lt;/Group&gt;
		/// </returns>
		protected XmlDocument _GetGroup(int GroupID) {
			XmlDocument getGroup;
			_Group = new x_group(DSN);
			getGroup = _Group.GetGroup(GroupID);
			_Group = null;
			return getGroup;
		}


		/// <summary>
		/// Returns a list of all groups in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;Groups&gt;<br>
		/// &nbsp;&lt;Group GroupID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;Status GroupStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;/Status&gt;<br>
		/// &nbsp;&lt;/Group&gt;<br>
		/// &lt;/Groups&gt;
		/// </returns>
		protected XmlDocument _GetGroupList() {
			XmlDocument getGroupList;
			_Group = new x_group(DSN);
			getGroupList = _Group.GetGroupList();
			_Group = null;
			return getGroupList;
		}


		/// <summary>
		/// Returns a list of users in a group.
		/// </summary>
		/// <param name="GroupID">The internal ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;Users&gt;<br>
		/// &nbsp;&nbsp;&lt;User UserID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;FirstName/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Surname/&gt;<br>
		/// &nbsp;&nbsp;&lt;/User&gt;<br>
		/// &nbsp;&lt;/Users&gt;<br>
		/// &lt;/Group&gt;
		/// </returns>
		protected XmlDocument _GetGroupMemberList(int GroupID) {
			XmlDocument getGroupMemberList;
			_Group = new x_group(DSN);
			getGroupMemberList = _Group.GetGroupMemberList(GroupID);
			_Group = null;
			return getGroupMemberList;
		}


		/// <summary>
		/// Used to delete a Group record from the database. Validation will be done that the Group is not
		/// in use any more, before the deletion will take place.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal Group ID of the Group record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, as below:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the method is successful, the value of ResultCode will be 0 (zero). If not, the Result will contain
		/// the error code and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _DeleteGroup(string Token, int GroupID) {
			XmlDocument deleteGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteGroup");
			if (validUser == null) {
				_Group = new x_group(DSN);
				deleteGroup = _Group.DeleteGroup(GroupID);
				_Group = null;
			} else {
				deleteGroup = new XmlDocument();
				deleteGroup.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return deleteGroup;
		}


		/// <summary>
		/// Used to restore a Group record that was previously deleted on the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the restore, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the undelete is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		protected XmlDocument _UndeleteGroup(string Token, int GroupID) {
			XmlDocument undeleteGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UndeleteGroup");
			if (validUser == null) {
				_Group = new x_group(DSN);
				undeleteGroup = _Group.UndeleteGroup(GroupID);
				_Group = null;
			} else {
				undeleteGroup = new XmlDocument();
				undeleteGroup.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return undeleteGroup;
		}


		/// <summary>
		/// Used to completely delete a Group from the Gatekeeper database. The system will also remove any links
		/// between any users and the group, and remove them as well.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the remove, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the delete is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the delete failed.
		/// </returns>
		protected XmlDocument _RemoveGroup(string Token, int GroupID) {
			XmlDocument removeGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveGroup");
			if (validUser == null) {
				_Group = new x_group(DSN);
				removeGroup = _Group.RemoveGroup(GroupID);
				_Group = null;
			} else {
				removeGroup = new XmlDocument();
				removeGroup.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return removeGroup;
		}


		/// <summary>
		/// Method used to link all users in a Group to a Service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <param name="ServiceID">The internal ID of the Service to which the link is to be created.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level that is to be set for all users linked to the Service.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the save is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		protected XmlDocument _SaveGroupService(string Token, int GroupID, int ServiceID, int SecurityLevelID) {
			XmlDocument saveGroupService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveGroupService");
			if (validUser == null) {
				_Group = new x_group(DSN);
				saveGroupService = _Group.SaveGroupService(GroupID, ServiceID, SecurityLevelID);
				_Group = null;
			} else {
				saveGroupService = new XmlDocument();
				saveGroupService.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return saveGroupService;
		}
		

		/// <summary>
		/// Method used to link all users in a Group to a Product.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <param name="ProductID">The internal ID of the Product to which the link is to be created.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level that is to be set for all users linked to the Product.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the save is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		protected XmlDocument _SaveGroupProduct(string Token, int GroupID, int ProductID, int SecurityLevelID) {
			XmlDocument saveGroupProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveGroupProduct");
			if (validUser == null) {
				_Group = new x_group(DSN);
				saveGroupProduct = _Group.SaveGroupProduct(GroupID, ProductID, SecurityLevelID);
				_Group = null;
			} else {
				saveGroupProduct = new XmlDocument();
				saveGroupProduct.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return saveGroupProduct;
		}


		/// <summary>
		/// Method used to remove the link between all users in a Group and a Service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <param name="ServiceID">The internal ID of the Service to which the link is to be created.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the delete is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		protected XmlDocument _DeleteGroupService(string Token, int GroupID, int ServiceID) {
			XmlDocument deleteGroupService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteGroupService");
			if (validUser == null) {
				_Group = new x_group(DSN);
				deleteGroupService = _Group.DeleteGroupService(GroupID, ServiceID);
				_Group = null;
			} else {
				deleteGroupService = new XmlDocument();
				deleteGroupService.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return deleteGroupService;
		}


		/// <summary>
		/// Method used to remove the link all users in a Group and a Product.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <param name="ProductID">The internal ID of the Product to which the link is to be created.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the delete is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		protected XmlDocument _DeleteGroupProduct(string Token, int GroupID, int ProductID) {
			XmlDocument deleteGroupProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteGroupProduct");
			if (validUser == null) {
				_Group = new x_group(DSN);
				deleteGroupProduct = _Group.DeleteGroupProduct(GroupID, ProductID);
				_Group = null;
			} else {
				deleteGroupProduct = new XmlDocument();
				deleteGroupProduct.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return deleteGroupProduct;
		}


		/// <summary>
		/// Method used to lock all users in a Group.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the update, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the update is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		protected XmlDocument _LockGroup(string Token, int GroupID) {
			XmlDocument lockGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LockGroup");
			if (validUser == null) {
				_Group = new x_group(DSN);
				lockGroup = _Group.LockGroup(GroupID);
				_Group = null;
			} else {
				lockGroup = new XmlDocument();
				lockGroup.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return lockGroup;
		}


		/// <summary>
		/// Method used to unlock all users in a Group.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the update, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the update is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		protected XmlDocument _UnlockGroup(string Token, int GroupID) {
			XmlDocument unlockGroup;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UnlockGroup");
			if (validUser == null) {
				_Group = new x_group(DSN);
				unlockGroup = _Group.UnlockGroup(GroupID);
				_Group = null;
			} else {
				unlockGroup = new XmlDocument();
				unlockGroup.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
				validUser = null;
			}
			return unlockGroup;
		}


		#endregion

		#region GroupStatus-related methods

		/// <summary>
		/// Used to add/update a Group Status record in the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupStatusID">The internal ID of the GroupStatus record in the Gatekeeper database. If the value does not exist in the database, a new record will be added, and the newly generated ID will be returned.</param>
		/// <param name="Description">The text description of the Group Status.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save, in the following format:<br>
		/// &lt;GroupStatus GroupStatusID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/GroupStatus&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 (zero) and the GroupStatusID will contain the
		/// value assigned to the record by the Gatekeeper. If not, the Result will contain the error code and description or
		/// reason the save failed.
		/// </returns>
		protected XmlDocument _SaveGroupStatus(string Token, int GroupStatusID, string Description) {
			XmlDocument saveGroupStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveGroupStatus");
			if (validUser == null) {
				_GroupStatus = new x_groupStatus(DSN);
				saveGroupStatus = _GroupStatus.SaveGroupStatus(GroupStatusID, Description);
				_GroupStatus = null;
			} else {
				saveGroupStatus = new XmlDocument();
				saveGroupStatus.LoadXml ("<GroupStatus>" + validUser.OuterXml + "</GroupStatus>");
				validUser = null;
			}
			return saveGroupStatus;
		}


		/// <summary>
		/// Used to retrieve details for a specific GroupStatus record in the Gatekeeper database, typically for
		/// editing purposes.
		/// </summary>
		/// <param name="GroupStatusID">The internal ID of the Group Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the information of the GroupStatus record, in the following format:<br>
		/// &lt;GroupStatus GroupStatusID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &lt;/GroupStatus&gt;
		/// </returns>
		protected XmlDocument _GetGroupStatus(int GroupStatusID) {
			XmlDocument getGroupStatus;
			_GroupStatus = new x_groupStatus(DSN);
			getGroupStatus = _GroupStatus.GetGroupStatus(GroupStatusID);
			_GroupStatus = null;
			return getGroupStatus;
		}


		/// <summary>
		/// Returns a list of all GroupStatus records in the Gatekeeper database, typically for selection on a
		/// user interface.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object, in the following format:<br>
		/// &lt;GroupStatusList&gt;<br>
		/// &nbsp;&lt;GroupStatus GroupStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/GroupStatus&gt;<br>
		/// &lt;/GroupStatusList&gt;
		/// </returns>
		protected XmlDocument _GetGroupStatusList() {
			XmlDocument getGroupStatusList;
			_GroupStatus = new x_groupStatus(DSN);
			getGroupStatusList = _GroupStatus.GetGroupStatusList();
			_GroupStatus = null;
			return getGroupStatusList;
		}


		/// <summary>
		/// Used to permanently remove a GroupStatus record from the Gatekeeper database. The system will check that
		/// the record is no longer in use before attempting the delete.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupStatusID">The internal ID of the GroupStatus record to be deleted.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, in the following format:<br>
		/// &lt;GroupStatus&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/GroupStatus&gt;<br><br>
		/// If the delete is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the delete failed.
		/// </returns>
		protected XmlDocument _RemoveGroupStatus(string Token, int GroupStatusID) {
			XmlDocument removeGroupStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveGroupStatus");
			if (validUser == null) {
				_GroupStatus = new x_groupStatus(DSN);
				removeGroupStatus = _GroupStatus.RemoveGroupStatus(GroupStatusID);
				_GroupStatus = null;
			} else {
				removeGroupStatus = new XmlDocument();
				removeGroupStatus.LoadXml ("<GroupStatus>" + validUser.OuterXml + "</GroupStatus>");
				validUser = null;
			}
			return removeGroupStatus;
		}

		#endregion

		#region Product related methods
		/// <summary>
		/// Method to save a Product's details. The database implementation will check for the existince of a record,
		/// and if not present will add it.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductID">The internal Product ID. This value must be 0 (zero) for a new record.</param>
		/// <param name="Description">The description of the Product.</param>
		/// <param name="ProductStatusID">The internal Product Status ID, linked to the ProductStatus lookup.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save in the following format:<br>
		/// &lt;Product ProductID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Product&gt;<br><br>
		/// If the save is successful, the ResultCode will be 0 (zero) and the ProductID attribute will contain the value
		/// assigned to the Product by the Gatekeeper. If not, the Result will contain the error code and description or reason
		/// the save failed.
		/// </returns>
		protected XmlDocument _SaveProduct(string Token, int ProductID, string Description, int ProductStatusID) {
			XmlDocument saveProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveProduct");
			if (validUser == null) {
				_Product = new x_product(DSN);
				saveProduct = _Product.SaveProduct(ProductID, Description, ProductStatusID);
				_Product = null;
			} else {
				saveProduct = new XmlDocument();
				saveProduct.LoadXml ("<Product>" + validUser.OuterXml + "</Product>");
				validUser = null;
			}
			return saveProduct;
		}


		/// <summary>
		/// Add/update a Product Notification details
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductID">The internal ID of an already existing Product record in the Gatekeeper database.</param>
		/// <param name="URL">The URL of the web service or web page to be called when sending notifications</param>
		/// <param name="WSDLURL">If the application being called is a web service, the URL of the WSDL document of the web service.</param>
		/// <param name="Name">The application name of the web service to be called.</param>
		/// <param name="Namespace">The namespace of the web service to be called.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save in the following format:<br>
		/// &lt;Product ProductID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Product&gt;<br><br>
		/// If the save is successful, the ResultCode will be 0 (zero) and the ProductID attribute will contain the value
		/// assigned to the Product by the Gatekeeper. If not, the Result will contain the error code and description or reason
		/// the save failed.
		/// </returns>
		protected XmlDocument _SaveProductNotification(string Token, int ProductID, string URL, string WSDLURL, string Name, string Namespace) {
			XmlDocument saveProductNotification;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveProduct");
			if (validUser == null) {
				_Product = new x_product(DSN);
				saveProductNotification = _Product.SaveProductNotification(ProductID, URL, WSDLURL, Name, Namespace);
				_Product = null;
			} else {
				saveProductNotification = new XmlDocument();
				saveProductNotification.LoadXml ("<Product>" + validUser.OuterXml + "</Product>");
				validUser = null;
			}
			return saveProductNotification;
		}


		/// <summary>
		/// Return details for a specific Product in the Gatekeeper database.
		/// </summary>
		/// <param name="ProductID">The internal ID of the Product record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object with the following layout:<br>
		/// &lt;Product ProductID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;Notification&gt;<br>
		/// &nbsp;&nbsp;&lt;URL/&gt;<br>
		/// &nbsp;&nbsp;&lt;WSDLURL/&gt;<br>
		/// &nbsp;&nbsp;&lt;Name/&gt;<br>
		/// &nbsp;&nbsp;&lt;Namespace/&gt;<br>
		/// &nbsp;&lt;/Notification&gt;<br>
		/// &nbsp;&lt;Status ProductStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;DisplayMessage/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &lt;/Product&gt;
		/// </returns>
		protected XmlDocument _GetProduct(int ProductID) {
			XmlDocument getProduct;
			_Product = new x_product(DSN);
      getProduct = _Product.GetProduct(ProductID);
			_Product = null;
			return getProduct;
		}


		/// <summary>
		/// Returns a list of all products in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;Products&gt;<br>
		/// &nbsp;&lt;Product ProductID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;Status ProductStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;DisplayMessage/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &nbsp;&lt;/Product&gt;<br>
		/// &lt;/Products&gt;
		/// </returns>
		protected XmlDocument _GetProductList() {
			XmlDocument getProductList;
			_Product = new x_product(DSN);
			getProductList = _Product.GetProductList();
			_Product = null;
			return getProductList;
		}


		/// <summary>
		/// Used to retrieve a list of all services related to a selected product.
		/// </summary>
		/// <param name="ProductID">The internal ID of the Product record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, in the following format:<br>
		/// &lt;Product ProductID=""&gt;<br>
		/// &nbsp;&lt;Service ServiceID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;Status ServiceStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;DisplayMessage/&gt;<br>
		/// &nbsp;&nbsp;&lt;/Status&gt;<br>
		/// &nbsp;&lt;/Service&gt;<br>
		/// &lt;/Product&gt;
		/// </returns>
		protected XmlDocument _GetProductServiceList(string Token, int ProductID) {
			XmlDocument getServiceList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetProductServiceList");
			if (validUser == null) {
				_Product = new x_product(DSN);
				getServiceList = _Product.GetServiceList(ProductID);
				_Product = null;
			} else {
				getServiceList = new XmlDocument();
				getServiceList.LoadXml ("<Product>" + validUser.OuterXml + "</Product>");
				validUser = null;
			}
			return getServiceList;
		}


		/// <summary>
		/// Marks a product as deleted on the Gatekeeper database. Validation will be done that the product is not in use any more.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductID">The internal Product ID of the record to be deleted.</param>
		/// <returns>
		/// Returns an XmlDocument object indicating the result of the delete, in the following format:<br>
		/// &lt;Product&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Product&gt;<br><br>
		/// If the delete is successful, the ResultCode will contain 0 (zero). If not, the Result will contain the
		/// error code and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _DeleteProduct(string Token, int ProductID) {
			XmlDocument deleteProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteProduct");
			if (validUser == null) {
				_Product = new x_product(DSN);
				deleteProduct = _Product.DeleteProduct(ProductID);
				_Product = null;
			} else {
				deleteProduct = new XmlDocument();
				deleteProduct.LoadXml ("<Product>" + validUser.OuterXml + "</Product>");
				validUser = null;
			}
			return deleteProduct;
		}


		/// <summary>
		/// Restores a product that was previously deleted on the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductID">The internal Product ID of the record to be restored.</param>
		/// <returns>
		/// Returns an XmlDocument object indicating the result of the undelete, in the following format:<br>
		/// &lt;Product&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Product&gt;<br><br>
		/// If the undelete is successful, the ResultCode will contain 0 (zero). If not, the Result will contain the
		/// error code and description or reason the undelete failed.
		/// </returns>
		protected XmlDocument _UndeleteProduct(string Token, int ProductID) {
			XmlDocument undeleteProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UndeleteProduct");
			if (validUser == null) {
				_Product = new x_product(DSN);
				undeleteProduct = _Product.UndeleteProduct(ProductID);
				_Product = null;
			} else {
				undeleteProduct = new XmlDocument();
				undeleteProduct.LoadXml ("<Product>" + validUser.OuterXml + "</Product>");
				validUser = null;
			}
			return undeleteProduct;
		}


		/// <summary>
		/// Permanently removes a product from the Gatekeeper database. Any links between Users 
		/// and the selected product will also be removed. Any services linked to the product will also
		/// be removed, as well as any links to those services.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductID">The internal Product ID of the record to be deleted.</param>
		/// <returns>
		/// Returns an XmlDocument object indicating the result of the delete, in the following format:<br>
		/// &lt;Product&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Product&gt;<br><br>
		/// If the delete is successful, the ResultCode will contain 0 (zero). If not, the Result will contain the
		/// error code and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _RemoveProduct(string Token, int ProductID) {
			XmlDocument removeProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveProduct");
			if (validUser == null) {
				_Product = new x_product(DSN);
				removeProduct = _Product.RemoveProduct(ProductID);
				_Product = null;
			} else {
				removeProduct = new XmlDocument();
				removeProduct.LoadXml ("<Product>" + validUser.OuterXml + "</Product>");
				validUser = null;
			}
			return removeProduct;
		}


		/// <summary>
		/// Used to lock access to an entire Product. This will not deny access to the system, but will indicate
		/// to the Product's system that it should not allow any transactional functionality.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductID">The internal Product ID of the Product record, used to identify the unique product.</param>
		/// <returns>Returns a boolean value indicating whether the Lock was successful.</returns>
		protected bool _LockProduct(string Token, int ProductID) {
			bool lockProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LockProduct");
			if (validUser == null) {
				_Product = new x_product(DSN);
				lockProduct = _Product.LockProduct(ProductID);
				_Product = null;
			} else {
				lockProduct = false;
			}
			return lockProduct;
		}


		/// <summary>
		/// Used to unlock access to a Product, after it has been locked.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductID">The internal Product ID of the Product record, used to uniquely identify a product in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value indicating the result of the Unlock
		/// </returns>
		protected bool _UnlockProduct(string Token, int ProductID) {
			bool unlockProduct;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UnlockProduct");
			if (validUser == null) {
				_Product = new x_product(DSN);
				unlockProduct = _Product.UnlockProduct(ProductID);
				_Product = null;
			} else {
				unlockProduct = false;
			}
			return unlockProduct;
		}


		#endregion

		#region ProductStatus related methods
		/// <summary>
		/// Used to add/update a ProductStatus record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductStatusID">The internal ID of the Product Status record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Product Status. This must be unqiue in the Gatekeeper database.</param>
		/// <param name="DisplayMessage">A text description that can be used to display a message to users when the system is offline, or unavailable, that contains more detailed information on the status of product.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save, in the following format:<br>
		/// &lt;ProductStatus ProductStatusID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/ProductStatus&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 (zero) and the ProductStatusID will contain the
		/// value assigned to the record by the Gatekeeper. If not, the Result will contain the error code and description or
		/// reason the save failed.
		/// </returns>
		protected XmlDocument _SaveProductStatus(string Token, int ProductStatusID, string Description, string DisplayMessage) {
			XmlDocument saveProductStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveProductStatus");
			if (validUser == null) {
				_ProductStatus = new x_productStatus(DSN);
				saveProductStatus = _ProductStatus.SaveProductStatus(ProductStatusID, Description, DisplayMessage);
				_ProductStatus = null;
			} else {
				saveProductStatus = new XmlDocument();
				saveProductStatus.LoadXml ("<ProductStatus>" + validUser.OuterXml + "</ProductStatus>");
				validUser = null;
			}
			return saveProductStatus;
		}


		/// <summary>
		/// Return details for a specific Product Status in the Gatekeeper database.
		/// </summary>
		/// <param name="ProductStatusID">The internal ID of the Product Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object with the following layout:<br>
		/// &lt;ProductStatus ProductStatusID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;DisplayMessage/&gt;<br>
		/// &lt;/ProductStatus&gt;
		/// </returns>
		protected XmlDocument _GetProductStatus(int ProductStatusID) {
			XmlDocument getProductStatus;
			_ProductStatus = new x_productStatus(DSN);
			getProductStatus = _ProductStatus.GetProductStatus(ProductStatusID);
			_ProductStatus = null;
			return getProductStatus;
		}


		/// <summary>
		/// Returns a list of all product status' in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;ProductStatusList&gt;<br>
		/// &nbsp;&lt;ProductStatus ProductStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;DisplayMessage/&gt;<br>
		/// &nbsp;&lt;/ProductStatus&gt;<br>
		/// &lt;/ProductStatus&gt;
		/// </returns>
		protected XmlDocument _GetProductStatusList() {
			XmlDocument getProductStatusList;
			_ProductStatus = new x_productStatus(DSN);
			getProductStatusList = _ProductStatus.GetProductStatusList();
			_ProductStatus = null;
			return getProductStatusList;
		}


		/// <summary>
		/// Used to delete a ProductStatus record from the database. Validation will be done that the Product Status is not
		/// in use any more, before the deletion will take place.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ProductStatusID">The internal Product Status ID of the Product Status record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, as below:<br>
		/// &lt;ProductStatus&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/ProductStatus&gt;<br><br>
		/// If the method is successful, the value of ResultCode will be 0 (zero). If not, the Result will contain
		/// the error code and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _DeleteProductStatus(string Token, int ProductStatusID) {
			XmlDocument deleteProductStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteProductStatus");
			if (validUser == null) {
				_ProductStatus = new x_productStatus(DSN);
				deleteProductStatus = _ProductStatus.DeleteProductStatus(ProductStatusID);
				_ProductStatus = null;
			} else {
				deleteProductStatus = new XmlDocument();
				deleteProductStatus.LoadXml ("<ProductStatus>" + validUser.OuterXml + "</ProductStatus>");
				validUser = null;
			}
			return deleteProductStatus;
		}


		#endregion

		#region Service related methods

		/// <summary>
		/// Method to save the details of a Service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceID">The internal Service ID of the Service record.</param>
		/// <param name="ProductID">The internal ID of the Product to which the service is linked.</param>
		/// <param name="Description">The description of the service, used to reference the service in other methods.</param>
		/// <param name="ServiceStatusID">The internal ID of the Service Status record, which identifies the status of the service.</param>
		/// <returns>Returns an XmlDocument object indicating the result of the Save method in the following format:<br>
		/// &lt;Service ServiceID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Service&gt;<Br><Br>
		/// If the save is successful, the ResultCode will be 0 (zero), and the ServiceID attribute will contain the value
		/// assigned to the Service record by the Gatekeeper. If not, the Result will contain the error code and description
		/// or reason the save failed.
		/// </returns>
		protected XmlDocument _SaveService (string Token, int ServiceID, int ProductID, string Description, int ServiceStatusID) {
			XmlDocument saveService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveService");
			if (validUser == null) {
				_Service = new x_service(DSN);
				saveService = _Service.SaveService(ServiceID, ProductID, Description, ServiceStatusID);
				_Service = null;
			} else {
				saveService = new XmlDocument();
				saveService.LoadXml ("<Service>" + validUser.OuterXml + "</Service>");
				validUser = null;
			}
			return saveService;
		}


		/// <summary>
		/// Retrieves details of a selected Service in the Gatekeeper database, usually for editing purposes.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceID">The internal ID of the Service record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the information on the Service, in the following format:<br>
		/// &lt;Service ServiceID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;Status ServiceStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;DisplayMessage/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &lt;/Service&gt;
		/// </returns>
		protected XmlDocument _GetService (string Token, int ServiceID) {
			XmlDocument getService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetService");
			if (validUser == null) {
				_Service = new x_service(DSN);
				getService = _Service.GetService(ServiceID);
				_Service = null;
			} else {
				getService = new XmlDocument();
				getService.LoadXml ("<Service>" + validUser.OuterXml + "</Service>");
				validUser = null;
			}
			return getService;
		}


		/// <summary>
		/// Retrieves a list of all Services in the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <returns>
		/// Returns an XmlDocument object, in the following format:<br>
		/// &lt;Services&gt;<br>
		/// &nbsp;&lt;Service ServiceID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;Status ServiceStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;DisplayMessage/&gt;<br>
		/// &nbsp;&nbsp;&lt;/Status&gt;<br>
		/// &nbsp;&lt;/Service&gt;<br>
		/// &lt;/Services&gt;
		/// </returns>
		protected XmlDocument _GetServiceList (string Token) {
			XmlDocument getServiceList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetServiceList");
			if (validUser == null) {
				_Service = new x_service(DSN);
				getServiceList = _Service.GetServiceList();
				_Service = null;
			} else {
				getServiceList = new XmlDocument();
				getServiceList.LoadXml ("<Service>" + validUser.OuterXml + "</Service>");
				validUser = null;
			}
			return getServiceList;
		}


		/// <summary>
		/// Used to delete a Service record from the database. Validation will be done that the Service is not
		/// in use any more, before the deletion will take place.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceID">The internal Service ID of the Service record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, as below:<br>
		/// &lt;Service&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Service&gt;<br><br>
		/// If the method is successful, the value of ResultCode will be 0 (zero). If not, the Result will contain the
		/// error code and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _DeleteService(string Token, int ServiceID) {
			XmlDocument deleteService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteService");
			if (validUser == null) {
				_Service = new x_service(DSN);
				deleteService = _Service.DeleteService(ServiceID);
				_Service = null;
			} else {
				deleteService = new XmlDocument();
				deleteService.LoadXml ("<Service>" + validUser.OuterXml + "</Service>");
				validUser = null;
			}
			return deleteService;
		}


		/// <summary>
		/// Used to restore a Service record on the Gatekeeper database that was previously marked as inactive.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceID">The internal ID of the Service record, used to uniquely identify the record in the Gatekeeper database.</param>
		/// <returns>Returns an XmlDocument object, indicating the result of the restore, in the following format:<br>
		/// &lt;Service&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Service&gt;<br><br>
		/// If the undelete was successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code
		/// and description or reason the undelete failed.
		/// </returns>
		protected XmlDocument _UndeleteService(string Token, int ServiceID) {
			XmlDocument undeleteService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UndeleteService");
			if (validUser == null) {
				_Service = new x_service(DSN);
				undeleteService = _Service.UndeleteService(ServiceID);
				_Service = null;
			} else {
				undeleteService = new XmlDocument();
				undeleteService.LoadXml ("<Service>" + validUser.OuterXml + "</Service>");
				validUser = null;
			}
			return undeleteService;
		}


		/// <summary>
		/// Used to completely remove a Service record from the Gatekeeper database. Any links from Users to the service
		/// will also be removed.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceID">The internal ID of the Service record, used to uniquely identify the record in the Gatekeeper database.</param>
		/// <returns>Returns an XmlDocument object, indicating the result of the delete, in the following format:<br>
		/// &lt;Service&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Service&gt;<br><br>
		/// If the Delete was successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code
		/// and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _RemoveService(string Token, int ServiceID) {
			XmlDocument removeService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveService");
			if (validUser == null) {
				_Service = new x_service(DSN);
				removeService = _Service.RemoveService(ServiceID);
				_Service = null;
			} else {
				removeService = new XmlDocument();
				removeService.LoadXml ("<Service>" + validUser.OuterXml + "</Service>");
				validUser = null;
			}
			return removeService;
		}


		/// <summary>
		/// Used to lock a service in the Gatekeeper database. This will not prevent access to the Service,
		/// but will inform the Service when a user is validated that the Service should not allow any
		/// transactional processing to occur.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceID">The internal ID of the Service record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value indicating whether the lock was successful.
		/// </returns>
		protected bool _LockService(string Token, int ServiceID) {
			bool lockService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LockService");
			if (validUser == null) {
				_Service = new x_service(DSN);
				lockService = _Service.LockService(ServiceID);
				_Service = null;
			} else {
				lockService = false;
			}
			return lockService;
		}


		/// <summary>
		/// Used to unlock a service in the Gatekeeper database that was previously locked.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceID">The internal ID of the Service record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value indicating whether the unlock was successful.
		/// </returns>
		protected bool _UnlockService(string Token, int ServiceID) {
			bool unlockService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "UnlockService");
			if (validUser == null) {
				_Service = new x_service(DSN);
				unlockService = _Service.UnlockService(ServiceID);
				_Service = null;
			} else {
				unlockService = false;
			}
			return unlockService;
		}

		#endregion

		#region ServiceStatus related methods
		/// <summary>
		/// Used to add/update a Service Status record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceStatusID">The internal ID of the Service Status record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Service Status. This must be unqiue in the Gatekeeper database.</param>
		/// <param name="DisplayMessage">A text description that can be used to display a message to users when the service is unavailable, that contains more detailed information on the status of service.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save, in the following format:<br>
		/// &lt;ServiceStatus ServiceStatusID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/ServiceStatus&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 (zero) and the ServiceStatusID will contain the
		/// value assigned to the record by the Gatekeeper. If not, the Result will contain the error code and description or
		/// reason the save failed.
		/// </returns>
		protected XmlDocument _SaveServiceStatus(string Token, int ServiceStatusID, string Description, string DisplayMessage) {
			XmlDocument saveServiceStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveServiceStatus");
			if (validUser == null) {
				_ServiceStatus = new x_serviceStatus(DSN);
				saveServiceStatus = _ServiceStatus.SaveServiceStatus(ServiceStatusID, Description, DisplayMessage);
				_ServiceStatus = null;
			} else {
				saveServiceStatus = new XmlDocument();
				saveServiceStatus.LoadXml ("<ServiceStatus>" + validUser.OuterXml + "</ServiceStatus>");
				validUser = null;
			}
			return saveServiceStatus;
		}

		/// <summary>
		/// Return details for a specific Service Status in the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceStatusID">The internal ID of the Service Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object with the following layout:<br>
		/// &lt;ServiceStatus ServiceStatusID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;DisplayMessage/&gt;<br>
		/// &lt;/ServiceStatus&gt;
		/// </returns>
		protected XmlDocument _GetServiceStatus(string Token, int ServiceStatusID) {
			XmlDocument getServiceStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetServiceStatus");
			if (validUser == null) {
				_ServiceStatus = new x_serviceStatus(DSN);
				getServiceStatus = _ServiceStatus.GetServiceStatus(ServiceStatusID);
				_ServiceStatus = null;
			} else {
				getServiceStatus = new XmlDocument();
				getServiceStatus.LoadXml ("<ServiceStatus>" + validUser.OuterXml + "</ServiceStatus>");
				validUser = null;
			}
			return getServiceStatus;
		}

		/// <summary>
		/// Returns a list of all service status' in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;ServiceStatusList&gt;<br>
		/// &nbsp;&lt;ServiceStatus ServiceStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;DisplayMessage/&gt;<br>
		/// &nbsp;&lt;/ServicsStatus&gt;<br>
		/// &lt;/ServiceStatusList&gt;
		/// </returns>
		protected XmlDocument _GetServiceStatusList(string Token) {
			XmlDocument getServiceStatusList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetServiceStatusList");
			if (validUser == null) {
				_ServiceStatus = new x_serviceStatus(DSN);
				getServiceStatusList = _ServiceStatus.GetServiceStatusList();
				_ServiceStatus = null;
			} else {
				getServiceStatusList = new XmlDocument();
				getServiceStatusList.LoadXml ("<ServiceStatus>" + validUser.OuterXml + "</ServiceStatus>");
				validUser = null;
			}
			return getServiceStatusList;
		}

		/// <summary>
		/// Used to delete a Service Status record from the database. Validation will be done that the Service Status is not
		/// in use any more, before the deletion will take place.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ServiceStatusID">The internal Service Status ID of the Service Status record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, as below:<br>
		/// &lt;ServiceStatus&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/ServiceStatus&gt;<br><br>
		/// If the method is successful, the value of ResultCode will be 0 (zero). If not, the Result will contain the
		/// error code and description or reason the delete failed.
		/// </returns>
		protected XmlDocument _DeleteServiceStatus(string Token, int ServiceStatusID) {
			XmlDocument deleteServiceStatus;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteServiceStatus");
			if (validUser == null) {
				_ServiceStatus = new x_serviceStatus(DSN);
				deleteServiceStatus = _ServiceStatus.DeleteServiceStatus(ServiceStatusID);
				_ServiceStatus = null;
			} else {
				deleteServiceStatus = new XmlDocument();
				deleteServiceStatus.LoadXml ("<ServiceStatus>" + validUser.OuterXml + "</ServiceStatus>");
				validUser = null;
			}
			return deleteServiceStatus;
		}

		#endregion

		#region Security Level-related methods

		/// <summary>
		/// Used to add/update a SecurityLevel record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Security Level. This must be unqiue in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save, in the following format:<br>
		/// &lt;SecurityLevel SecurityLevelID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/SecurityLevel&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 and the SecurityLevelID will contain the
		/// value assigned to the record by the Gatekeeper. If not, the Result will contain the error code and description or
		/// reason the save failed.
		/// </returns>
		protected XmlDocument _SaveSecurityLevel(string Token, int SecurityLevelID, string Description) {
			XmlDocument saveSecurityLevel;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveSecurityLevel");
			if (validUser == null) {
				_SecurityLevel = new x_securityLevel(DSN);
				saveSecurityLevel = _SecurityLevel.SaveSecurityLevel(SecurityLevelID, Description);
				_SecurityLevel = null;
			} else {
				saveSecurityLevel = new XmlDocument();
				saveSecurityLevel.LoadXml ("<SecurityLevel>" + validUser.OuterXml + "</SecurityLevel>");
				validUser = null;
			}
			return saveSecurityLevel;
		}


		/// <summary>
		/// Returns details for a specific Security Level record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level record</param>
		/// <returns>
		/// Returns an XmlDocument containing information on the SecurityLevel in the following format:<br>
		/// &lt;SecurityLevel SecurityLevelID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &lt;/SecurityLevel&gt;
		/// </returns>
		protected XmlDocument _GetSecurityLevel(string Token, int SecurityLevelID) {
			XmlDocument getSecurityLevel;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetSecurityLevel");
			if (validUser == null) {
				_SecurityLevel = new x_securityLevel(DSN);
				getSecurityLevel = _SecurityLevel.GetSecurityLevel(SecurityLevelID);
				_SecurityLevel = null;
			} else {
				getSecurityLevel = new XmlDocument();
				getSecurityLevel.LoadXml ("<SecurityLevel>" + validUser.OuterXml + "</SecurityLevel>");
				validUser = null;
			}
			return getSecurityLevel;
		}


		/// <summary>
		/// Used to retrieve a list of all Security Level records in the database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <returns>
		/// Returns an XmlDocument in the following format:<br>
		/// &lt;SecurityLevels&gt;<br>
		/// &nbsp;&lt;SecurityLevel SecurityLevelID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/SecurityLevel&gt;<br>
		/// &lt;/SecurityLevels&gt;
		/// </returns>
		protected XmlDocument _GetSecurityLevelList(string Token) {
			XmlDocument getSecurityLevelList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetSecurityLevelList");
			if (validUser == null) {
				_SecurityLevel = new x_securityLevel(DSN);
				getSecurityLevelList = _SecurityLevel.GetSecurityLevelList();
				_SecurityLevel = null;
			} else {
				getSecurityLevelList = new XmlDocument();
				getSecurityLevelList.LoadXml ("<SecurityLevel>" + validUser.OuterXml + "</SecurityLevel>");
				validUser = null;
			}
			return getSecurityLevelList;
		}


		/// <summary>
		/// Used to remove a Security Level record from the Gatekeeper database. The system will check that the
		/// record is not in use any more before attempting to delete the record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the delete, in the following format:<br>
		/// &lt;SecurityLevel&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/SecurityLevel&gt;<br><br>
		/// If the delete was successful, the value of ResultCode will be 0 (zero). If not, the Result will contain the
		/// error code and description or reason the delete failed.
		/// </returns>		
		protected XmlDocument _DeleteSecurityLevel(string Token, int SecurityLevelID) {
			XmlDocument deleteSecurityLevel;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteSecurityLevel");
			if (validUser == null) {
				_SecurityLevel = new x_securityLevel(DSN);
				deleteSecurityLevel = _SecurityLevel.DeleteSecurityLevel(SecurityLevelID);
				_SecurityLevel = null;
			} else {
				deleteSecurityLevel = new XmlDocument();
				deleteSecurityLevel.LoadXml ("<SecurityLevel>" + validUser.OuterXml + "</SecurityLevel>");
				validUser = null;
			}
			return deleteSecurityLevel;
		}
		#endregion

		#region Activity Logging-related methods
		/// <summary>
		/// Add/update an Activity record in the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ActivityID">The internal ID of the Activity record in the Gatekeeper database. If the value does not exist in the database, a new record will added, and the newly generated ID returned.</param>
		/// <param name="Description">The text description of the activity.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save, in the following format:<br>
		/// &lt;Activity ActivityID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Activity&gt;<br><br>
		/// If the save is successful, the ResultCode will be 0 (zero) and the ActivityID attribute will contain the value assigned
		/// to the Activity by the Gatekeeper system. If not, the Result will contain the error code and message or reason the
		/// save failed.
		/// </returns>
		protected XmlDocument _SaveActivity(string Token, int ActivityID, string Description) {
			XmlDocument saveActivity;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveActivity");
			if (validUser == null) {
				_Activity = new x_activity(DSN);
				saveActivity = _Activity.SaveActivity(ActivityID, Description);
				_Activity = null;
			} else {
				saveActivity = new XmlDocument();
				saveActivity.LoadXml ("<Activity>" + validUser.OuterXml + "</Activity>");
				validUser = null;
			}
			return saveActivity;
		}


		/// <summary>
		/// Used to remove an Activity record from the Gatekeeper database. The system will check that the record
		/// is no longer in use before attempting the delete.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ActivityID">The internal ID of the Activity record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete, in the following format:<br>
		/// &lt;Activity&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Activity&gt;<br><br>
		/// If the delete is successful, the ResultCode will be 0 (zero). If not, the Result will contain the 
		/// error code and message or reason the delete failed.
		/// </returns>
		protected XmlDocument _RemoveActivity(string Token, int ActivityID) {
			XmlDocument removeActivity;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveActivity");
			if (validUser == null) {
				_Activity = new x_activity(DSN);
				removeActivity = _Activity.RemoveActivity(ActivityID);
				_Activity = null;
			} else {
				removeActivity = new XmlDocument();
				removeActivity.LoadXml ("<Activity>" + validUser.OuterXml + "</Activity>");
				validUser = null;
			}
			return removeActivity;
		}


		/// <summary>
		/// Used to retrieve details for a specific Activity record in the Gatekeeper database, typically for editing purposes.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="ActivityID">The internal ID of the Activity record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object containing all the details of the Activity record, in the following format:<br>
		/// &lt;Activity ActivityID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &lt;/Activity&gt;
		/// </returns>
		protected XmlDocument _GetActivity(string Token, int ActivityID) {
			XmlDocument getActivity;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetActivity");
			if (validUser == null) {
				_Activity = new x_activity(DSN);
				getActivity = _Activity.GetActivity(ActivityID);
				_Activity = null;
			} else {
				getActivity = new XmlDocument();
				getActivity.LoadXml ("<Activity>" + validUser.OuterXml + "</Activity>");
				validUser = null;
			}
			return getActivity;
		}


		/// <summary>
		/// Retrieves a list of all Activity records in the Gatekeeper database, typically for selection purposes
		/// on a user interface.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <returns>
		/// Returns an XmlDocument object, in the following format:<br>
		/// &lt;ActivityList&gt;<br>
		/// &nbsp;&lt;Activity ActivityID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Activity&gt;<br>
		/// &lt;/ActivityList&gt;
		/// </returns>
		protected XmlDocument _GetActivityList(string Token) {
			XmlDocument getActivityList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetActivityList");
			if (validUser == null) {
				_Activity = new x_activity(DSN);
				getActivityList = _Activity.GetActivityList();
				_Activity = null;
			} else {
				getActivityList = new XmlDocument();
				getActivityList.LoadXml ("<Activity>" + validUser.OuterXml + "</Activity>");
				validUser = null;
			}
			return getActivityList;
		}


		/// <summary>
		/// Log an activity in the Gatekeeper database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of a User for which the activity will be logged.</param>
		/// <param name="UserToken">The Token of the user against whom the activity is logged.</param>
		/// <param name="DateTime">The date and time of the activity.</param>
		/// <param name="ActivityID">The internal ID of the Activity to which this record is linked.</param>
		/// <param name="ServiceID">The internal ID of the Service that is logging the activity.</param>
		protected void _LogActivity(string Token, int UserID, string UserToken, string DateTime, int ActivityID, int ServiceID) {
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "LogActivity");
			if (validUser == null) {
				_Activity = new x_activity(DSN);
				_Activity.LogActivity(UserID, UserToken, DateTime, ActivityID, ServiceID);
				_Activity = null;
			}
		}


		/// <summary>
		/// Method used to retrieve activity details. All parameters are optional, but at least the User ID or From Date must be specified.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the User in the Gatekeeper database.</param>
		/// <param name="FromDateTime">The date and time from which to extract the information.</param>
		/// <param name="ToDateTime">The date and time up to which to extract the information. If not specified, records up to the current date and time will be retrieved.</param>
		/// <param name="ProductName">Optional. The name of a Product in the Gatekeeper database, to limit results to only the specified product and its services.</param>
		/// <param name="ServiceName">Optional. The name of a Service in the Gatekeeper database, to limit results to only the specified service.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing all Activity records, in the following format:<br>
		/// &lt;ActivityLogs&gt;<br>
		/// &nbsp;&lt;ActivityLog&gt;<br>
		/// &nbsp;&nbsp;&lt;User UserID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;FirstName/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Surname/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Email/&gt;<br>
		/// &nbsp;&nbsp;&lt;/User&gt;<br>
		/// &nbsp;&nbsp;&lt;ActivityDateTime/&gt;<br>
		/// &nbsp;&nbsp;&lt;Activity/&gt;<br>
		/// &nbsp;&nbsp;&lt;Token/&gt;<br>
		/// &nbsp;&nbsp;&lt;Service ServiceID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;/Service&gt;<br>
		/// &nbsp;&lt;/ActivityLog&gt;<br>
		/// &lt;/ActivityLogs&gt;
		/// </returns>
		protected XmlDocument _GetActivityLog(string Token, int UserID, string FromDateTime, string ToDateTime, string ProductName, string ServiceName) {
			XmlDocument getActivityLog;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetActivityLog");
			if (validUser == null) {
				_Activity = new x_activity(DSN);
				getActivityLog = _Activity.GetActivityLog(UserID, FromDateTime, ToDateTime, ProductName, ServiceName);
				_Activity = null;
			} else {
				getActivityLog = new XmlDocument();
				getActivityLog.LoadXml ("<ActivityLogs>" + validUser.OuterXml + "</ActivityLogs>");
				validUser = null;
			}
			return getActivityLog;
		}

		#endregion

		#region System Configuration-related methods
		/// <summary>
		/// Method used to change the value of a system setting.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="Key">The name of the system setting to change</param>
		/// <param name="Value">The value of the system setting</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save, in the following format:<br>
		/// &lt;Configuration&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Configuration&gt;
		/// </returns>
		protected XmlDocument _SaveConfigValue(string Token, string Key, string Value) {
			XmlDocument saveConfigValue;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveConfigValue");
			if (validUser == null) {
				_Config = new x_config(DSN);
				saveConfigValue = _Config.SaveConfigValue(Key, Value);
				_Config = null;
			} else {
				saveConfigValue = new XmlDocument();
				saveConfigValue.LoadXml ("<Configuration>" + validUser.OuterXml + "</Configuration>");
				validUser = null;
			}
			return saveConfigValue;
		}

		/// <summary>
		/// Method used to return the value of a system setting.
		/// </summary>
		/// <param name="Key">The name of the Configuration value to return</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the details of the system setting, in the following format:
		/// &lt;Configuration Key=""&gt;<br>
		/// &nbsp;&lt;Value/&gt;<br>
		/// &lt;/Configuration&gt;
		/// </returns>
		protected XmlDocument _GetConfigValue(string Token, string Key) {
			XmlDocument getConfigValue;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetConfigValue");
			if (validUser == null) {
				_Config = new x_config(DSN);
				getConfigValue = _Config.GetConfigValue(Key);
				_Config = null;
			} else {
				getConfigValue = new XmlDocument();
				getConfigValue.LoadXml ("<Configuration>" + validUser.OuterXml + "</Configuration>");
				validUser = null;
			}
			return getConfigValue;
		}

		/// <summary>
		/// Method used to retrieve a list of all System Configuration values.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object containing all System Configuration values, in the following format:<br>
		/// &lt;ConfigurationList&gt;<br>
		/// &nbsp;&lt;Configuration Key=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Value/&gt;<br>
		/// &nbsp;&lt;/Configuration&gt;<br>
		/// &lt;/ConfigurationList&gt;
		/// </returns>
		protected XmlDocument _GetConfigValueList(string Token) {
			XmlDocument getConfigValueList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetConfigValueList");
			if (validUser == null) {
				_Config = new x_config(DSN);
				getConfigValueList = _Config.GetConfigValueList();
				_Config = null;
			} else {
				getConfigValueList = new XmlDocument();
				getConfigValueList.LoadXml ("<ConfigurationList>" + validUser.OuterXml + "</ConfigurationList>");
				validUser = null;
			}
			return getConfigValueList;
		}

		/// <summary>
		/// Method used to remove a System Configuration value. This method does not return any values.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="Key">The name of the Configuration value to delete.</param>
		protected void _DeleteConfigValue(string Token, string Key) {
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteConfigValue");
			if (validUser == null) {
				_Config = new x_config(DSN);
				_Config.DeleteConfigValue(Key);
				_Config = null;
			}
		}
		#endregion

		#region Question-related methods
		/// <summary>
		/// Method used to add/update a Question record.
		/// </summary>
		/// <param name="QuestionID">The internal ID of the Question record. If the value is 0, a new record will be created, and the new ID will be returned.</param>
		/// <param name="Question">The text of the question, eg. 'Mother's maiden name'.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the result of the save, in the following format:<br>
		/// &lt;Question QuestionID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;Description/&gt;<br>
		/// &nbsp;/Result&gt;<br>
		/// &lt;/Question&gt;<br><br>
		/// If the save is successful, the ResultCode will contain 0 (zero) and the QuestionID will be populated with
		/// the relevant record's ID. If not, the Result will contain an error code
		/// and Description/Reason the save failed.
		/// </returns>
		protected XmlDocument _SaveQuestion(string Token, int QuestionID, string Question) {
			XmlDocument saveQuestion;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveQuestion");
			if (validUser == null) {
				_Questions = new x_questions(DSN);
				saveQuestion = _Questions.SaveQuestion(QuestionID, Question);
				_Questions = null;
			} else {
				saveQuestion = new XmlDocument();
				saveQuestion.LoadXml ("<Question>" + validUser.OuterXml + "</Question>");
				validUser = null;
			}
			return saveQuestion;
		}

		/// <summary>
		/// Method to retrieve a Question record, typically for editing purposes.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="QuestionID">The internal ID of the Question record to be retrieved.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the details of the Question record, in the following format:<br>
		/// &lt;Question QuestionID=""&gt;<br>
		/// &nbsp;&lt;Description&gt;<br>
		/// &lt;/Question&gt;
		/// </returns>
		protected XmlDocument _GetQuestion(string Token, int QuestionID) {
			XmlDocument getQuestion;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetQuestion");
			if (validUser == null) {
				_Questions = new x_questions(DSN);
				getQuestion = _Questions.GetQuestion(QuestionID);
				_Questions = null;
			} else {
				getQuestion = new XmlDocument();
				getQuestion.LoadXml ("<Question>" + validUser.OuterXml + "</Question>");
				validUser = null;
			}
			return getQuestion;
		}

		/// <summary>
		/// Method used to retrieve a list of all Question records in the database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <returns>
		/// Returns an XmlDocument, in the following format:<br>
		/// &lt;Questions&gt;<br>
		/// &nbsp;&lt;Question QuestionID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description&gt;<br>
		/// &nbsp;&lt;/Question&gt;<br>
		/// &lt;/Questions&gt;
		/// </returns>
		protected XmlDocument _GetQuestionList(string Token) {
			XmlDocument getQuestionList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetQuestionList");
			if (validUser == null) {
				_Questions = new x_questions(DSN);
				getQuestionList = _Questions.GetQuestionList();
				_Questions = null;
			} else {
				getQuestionList = new XmlDocument();
				getQuestionList.LoadXml ("<Question>" + validUser.OuterXml + "</Question>");
				validUser = null;
			}
			return getQuestionList;
		}

		/// <summary>
		/// Method used to remove a Question and all related records from the database. This method does not return any values.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="QuestionID">The internal ID of the Question record.</param>
		protected void _DeleteQuestion(string Token, int QuestionID) {
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "DeleteQuestion");
			if (validUser == null) {
				_Questions = new x_questions(DSN);
				_Questions.DeleteQuestion(QuestionID);
				_Questions = null;
			}
		}
		#endregion
	}
}
