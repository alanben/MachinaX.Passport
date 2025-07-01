using System;
using System.Configuration;
using System.Collections;
using System.ComponentModel;
using System.Xml;
using System.Diagnostics;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		release	
	Version:	2.0.1
	Build:		20081015
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
	20070815:	Added recruit functionality.
	20071220:	Made some WebMethods virtual to allow them to be overridden (ie hidden)
	20081015:	Added construction of the _Pattern property
	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX.PassportServiceX {
	/// <summary>
	/// This PassportService class is
	/// </summary>
	[WebService(Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX")]
	public class PassportX : PassportBaseX {
		#region Invisible properties
		#endregion

		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>Default Constructor</summary>
		public PassportX() : base("PassportX") {
			initialise();
		}
		/// <summary>
		/// Constructor that supplies the name
		/// </summary>
		public PassportX(string name) : base(name) {
			initialise();
		}
		private void initialise() {
			_User = new x_user(DSN, DBType);
			_Activity = new x_activity(DSN, DBType);
			_Recruit = new x_recruit(DSN, DBType);
			_Pattern = new x_pattern(DSN, DBType);
		}
		#endregion

		#region Protected methods
		#endregion

		#region Public Web methods
		/// <summary>Logs a user out</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		[WebMethod(Description = "Invalidates a token")]
		public XmlDocument Logout(string Token) {
			XmlDocument logout = null;
			try {
				logout = _User.Logout(Token);
				return logout;
			}
			catch {
				return null;
			}
		}
		
		
		/// <summary>
		/// Validate a user's login information, and returns an XML document containing a Token to the user which must be used 
		/// throughout the session to validate the user when accessing any system the Gatekeeper controls access to.
		/// </summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <returns>
		/// XmlDocument object, containing information on the result of the login, and any related error messages.
		/// If the login is successful, the ResultCode will be 0 (zero), and the Token will contain the value that must
		/// be used for the session to validate the user for any functionality. If not, the ResultCode will contain
		/// a non-zero number indicating the error code and Description any related message.
		/// </returns>
		[WebMethod(Description = "Authenticates a user via login")]
		public override XmlDocument Login(string UserName, string Password) {
			XmlDocument login = null;
			try {
				login = _User.Login(UserName, Password);
				return login;
			} catch {
				return null;
			}
		}


		/// <summary>Validates a token and extends expiry</summary>
		/// <param name="Token">A string parameter containing the Token supplied when the user logged in.</param>
		/// <param name="Remember">Flag to set token same as login expiry (ie for 'Remember me' login option).</param>
		/// <returns>
		/// Returns an XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service,
		/// If the validation is successful, the ResultCode will be 0 (zero) and the Products and Services will be
		/// populated with the records where the user has access. If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		[WebMethod(Description = "Validates a token and extends expiry")]
		public virtual XmlDocument ValidateUser(string Token, bool Remember) {
			XmlDocument validateUser = _User.Validate(Token, !Remember);
			return validateUser;
		}


		/// <summary>Validates a token and access to a particular service</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <param name="ServiceName">The name of a service to return the access to, and also relevant permissions and status information.</param>
		/// <param name="Remember">Flag to set token same as login expiry (ie for 'Remember me' login option).</param>
		/// <returns>
		/// An XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service.
		/// </returns>
		[WebMethod(Description = "Validates a token and access to a particular service")]
		public virtual XmlDocument ValidateUserService(string Token, string ServiceName, bool Remember) {
			XmlDocument validateUser = _User.Validate(Token, ServiceName, !Remember);
			return validateUser;
		}


		/// <summary>
		/// Validate that a user has a valid Token, and that it has not expired.
		/// If the token is valid, the expiry date/time will be extended further.
		/// </summary>
		/// <param name="Token">A string parameter containing the Token supplied when the user logged in.</param>
		/// <returns>
		/// Returns an XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service,
		/// If the validation is successful, the ResultCode will be 0 (zero) and the Products and Services will be
		/// populated with the records where the user has access. If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		[WebMethod(Description = "DEPRECATED: Validates a token and extends expiry")]
		public virtual XmlDocument Validate(string Token) {
			XmlDocument validateUser = _User.Validate(Token);
			return validateUser;
		}


		/// <summary>
		/// Overrides the Validate function to return access to a specific service only
		/// </summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <param name="ServiceName">The name of a service to return the access to, and also relevant permissions and status information.</param>
		/// <returns>
		/// An XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service.
		/// </returns>
		[WebMethod(Description = "DEPRECATED: Validates a token and access to a particular service")]
		public virtual XmlDocument ValidateService(string Token, string ServiceName) {
			XmlDocument validateUser = _User.Validate(Token, ServiceName);
			return validateUser;
		}
		#endregion

		#region Recruit-related Web methods
		/// <summary>Gets a PassportX recruit</summary>
		/// <param name="RecruitID">The recruit's uid.</param>
		/// <returns>An XmlDocument containing the recruit's details</returns>
		[WebMethod(Description = "Gets a PassportX recruit")]
		public virtual XmlDocument GetRecruit(int RecruitID) {
			XmlDocument recruit = null;
			try {
				recruit = _Recruit.GetRecruit(RecruitID);
				return recruit;
			} catch {
				return null;
			}
		}


		/// <summary>Gets a PassportX recruit</summary>
		/// <param name="RecruitToken">The recruit's token.</param>
		/// <returns>An XmlDocument containing the recruit's details</returns>
		[WebMethod(Description = "Gets a PassportX recruit by token")]
		public virtual XmlDocument GetRecruitToken(string RecruitToken) {
			XmlDocument recruit = null;
			try {
				recruit = _Recruit.GetRecruit(new Guid(RecruitToken));
				return recruit;
			} catch {
				return null;
			}
		}


		/// <summary>Adds a new PassportX recruit</summary>
		/// <param name="UserName">The recruit's username.</param>
		/// <param name="Password">The recruit's password.</param>
		/// <param name="FirstName">The recruit's first name.</param>
		/// <param name="Surname">The recruit's surname.</param>
		/// <param name="Email">The recruit's email address.</param>
		/// <param name="TelNo">The recruit's landline number.</param>
		/// <param name="CellNo">The recruit's cellphone number.</param>
		/// <param name="TypeID">An identifier for the type of recruit.</param>
		/// <param name="UserID">An identifier for the recruit in the user list.</param>
		/// <returns>An XmlDocument containing the recruit's details</returns>
		[WebMethod(Description = "Adds a new PassportX recruit")]
		public virtual XmlDocument AddRecruit(string UserName, string Password, string FirstName, string Surname, string Email, string TelNo, string CellNo, int TypeID, int UserID) {
			XmlDocument recruit = null;
			try {
				recruit = _Recruit.RegisterRecruit(UserName, Password, FirstName, Surname, Email, TelNo, CellNo, TypeID, UserID);
				return recruit;
			} catch {
				return null;
			}
		}


		/// <summary>Updates an existing PassportX recruit</summary>
		/// <param name="RecruitID">The recruit's uid.</param>
		/// <param name="Password">The recruit's password.</param>
		/// <param name="FirstName">The recruit's first name.</param>
		/// <param name="Surname">The recruit's surname.</param>
		/// <param name="Email">The recruit's email address.</param>
		/// <param name="TelNo">The recruit's landline number.</param>
		/// <param name="CellNo">The recruit's cellphone number.</param>
		/// <param name="UserID">An identifier for the recruit in the user list.</param>
		/// <returns>An XmlDocument containing the recruit's details</returns>
		[WebMethod(Description = "Updates an existing PassportX recruit")]
		public virtual XmlDocument UpdateRecruit(int RecruitID, string UserName, string FirstName, string Surname, string Email, string TelNo, string CellNo, int UserID) {
			XmlDocument recruit = null;
			try {
				recruit = _Recruit.SaveRecruit(RecruitID, UserName, FirstName, Surname, Email, TelNo, CellNo, UserID);
				return recruit;
			} catch {
				return null;
			}
		}


		/// <summary>Deletes a PassportX recruit</summary>
		/// <param name="RecruitID">The recruit's uid.</param>
		/// <returns>An XmlDocument containing the recruit's details</returns>
		[WebMethod(Description = "Gets a PassportX recruit")]
		public virtual bool DeleteRecruit(int RecruitID) {
			try {
				return _Recruit.RemoveRecruit(RecruitID);
			} catch {
				return false;
			}
		}


		#endregion
	}
}
