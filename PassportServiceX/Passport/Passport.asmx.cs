#define PRODUCTION

using System;
using System.Web.Services;
using System.Xml;

using XXBoom.MachinaX.PassportX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2012-06-15	
	Status:		release	
	Version:	4.0.2
	Build:		20130715
	Target:		Microsoft SQL Server 2008
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20120615:	Starting point from Ididthatad.
	20130715:	Moved implementation from XXService (common to XXService implmentations)
				Set namespace to MachinaX.PassportX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace MachinaX.PassportX {
	/// <summary>MachinaX common implementation</summary>
	[WebService(Name = "PassportX Passport Services",
				Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX",	// NB: Needs to be constant accross implementations - called from cmsX.dll
				Description = "PassportX Authentication Web Service")]
	public class Passport : XXBoom.MachinaX.PassportX.PassportServiceX.PassportBaseX {
		#region Invisible properties
		#endregion

		#region Constants
		private const string RESULT_NAME = "Passport";
		private const string RESULT_OK = "0";
		private const string RESULT_USER_DUPLICATE = "2068";

		private const int STATUS_ACTIVE = 1;
		#endregion

		#region Visible properties
		public XmlElement ResultCode {
			get { return Result.SelectSingleNode("//ResultCode") as XmlElement; }
		}
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor 
		/// </summary>
		public Passport() : base("Passport") {
			_User = new x_user(DSN, DBType);
		}
		#endregion

		#region Overridden methods (to hide web methods)
#if PRODUCTION
		public override XmlDocument Login(string UserName, string Password) {
			return base.Login(UserName, Password);
		}
		public override string TestName() {
			return base.TestName();
		}
		public override XmlDocument TestConnection() {
			return base.TestConnection();
		}
		public override XmlDocument TestCustom(string Format, string RootName, string ResultName, string CodeName, string DescriptionName) {
			return base.TestConnection();
		}
		public override XmlDocument TestError() {
			return base.TestConnection();
		}
		public override XmlDocument TestException() {
			return base.TestConnection();
		}
#endif
		/*
		/// <summary>
		/// This method overrides the WebMethod in the parent class so that this is not exposed in the webservice
		/// </summary>
		public override XmlDocument AddRecruit(string FirstName, string Surname, string Email, string TelNo, string CellNo, int TypeID) {
		 	 return base.AddRecruit(FirstName, Surname, Email, TelNo, CellNo, TypeID);
		}
		public override XmlDocument GetRecruit(int RecruitID) {
			return base.GetRecruit(RecruitID);
		}
		public override bool DeleteRecruit(int RecruitID) {
			return base.DeleteRecruit(RecruitID);
		}
		public override XmlDocument UpdateRecruit(int RecruitID, string FirstName, string Surname, string Email, string TelNo, string CellNo, int UserID) {
			return base.UpdateRecruit(RecruitID, FirstName, Surname, Email, TelNo, CellNo, UserID);
		}
		public override XmlDocument ValidateService(string Token, string ServiceName) {
			return base.ValidateService(Token, ServiceName);
		}
*/
		#endregion

		#region Public web methods
		/// <summary>Validate a user's login information (password case INsensitive)</summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="Expire">Flag to expire login (ie token).</param>
		[WebMethod(Description = "Authenticates a user via login (password case INsensitive)")]
		public XmlDocument Login(string UserName, string Password, bool Expire) {
			try {
				Result = _User.Login(UserName, Password.ToLower(), Expire, false);
			} catch {
				return null;
			}
			_LogResult("Login");
			return Result;
		}

		/// <summary>Validate a user's login information (password case sensitive)</summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="Expire">Flag to expire login (ie token).</param>
		[WebMethod(Description = "Authenticates a user via login (password case sensitive)")]
		public XmlDocument LoginCase(string UserName, string Password, bool Expire) {
			try {
				Result = _User.Login(UserName, Password, Expire, true);
			}
			catch {
				return null;
			}
			_LogResult("Login");
			return Result;
		}

		/// <summary>Validates a user by token</summary>
		/// <param name="Token">The token issued to the user at login.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Validates the token and returns the user information")]
		public XmlDocument ValidateUser(string Token, bool Remember) {
			try {
				if (String.IsNullOrEmpty(Token))
					AddError("1003", "Token null");
				Result = _User.Validate(Token, !Remember);
			}
			catch (Exception e) {
				AddError(e);
			}
			_LogResult("ValidateUser");
			return Result;
		}

		/// <summary>Validates a token</summary>
		/// <param name="Token">The token issued to the user at login.</param>
		/// <param name="Remember">Flag to set token same as login expiry (ie for 'Remember me' login option).</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Validates the token and returns ok/notok status only")]
		public XmlDocument ValidateToken(string Token, bool Remember) {
			try {
				if (String.IsNullOrEmpty(Token)) {
					AddError("1003", "Token null");
				} else if (_User.ValidateToken(Token, !Remember)) {
					AddOk();
				} else {
					AddError("1004", String.Concat("Token not valid: ", Token));
				}
			}
			catch (Exception e) {
				AddError(e);
			}
			_LogResult("ValidateToken");
			return Result;
		}

		/// <summary>Validates a token (deprecated - use ValidateToken)</summary>
		/// <param name="Token">The token issued to the user at login.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "DEPRECATED: Validates the token and returns ok/notok status only ")]
		public XmlDocument Validate(string Token) {
			try {
				if (String.IsNullOrEmpty(Token)) {
					AddError("1003", "Token null");
				} else if (_User.ValidateToken(Token)) {
					AddOk();
				} else {
					AddError("1004", String.Concat("Token not valid: ", Token));
				}
			} catch (Exception e) {
				AddError(e);
			}
			_LogResult("Validate");
			return Result;
		}

		/// <summary>
		/// Does not require token - used for system acces to the user details.
		/// </summary>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description="Gets the user information for a given user ID")]
		public XmlDocument GetUser(int UserID) {
			try {
				Result = _User.GetUser(UserID);
			} catch (Exception e) {
				AddError(e);
			}
			_LogResult("GetUser");
			return Result;
		}

		/// <summary>Adds a user to LoeriesPassport</summary>
		/// <param name="UserName">The user's username.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's mobile telephone number.</param>
		/// <param name="CheckCell">Flag to check cell number for uniqueness.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Adds a user to LoeriesPassport")]
		public XmlDocument AddUser(string Username, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, bool CheckCell) {
			try {
				Result = _User.RegisterUser(Username, Password, FirstName, Surname, EMail, TelNo, CellNo, CheckCell);
			} catch (Exception e) {
				AddError(e);
			}
			_LogResult("AddUser");
			return Result;
		}
		#endregion
	}
}
