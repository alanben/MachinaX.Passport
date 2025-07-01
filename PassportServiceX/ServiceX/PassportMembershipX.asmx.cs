using System;
using System.Web.Services;
using System.Xml;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2008-06-22	
	Status:		redev	
	Version:	2.0.0
	Build:		20080622
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	-------------------------------------------------------------------------------------------------
	Development Notes:
	20080622:	Starting point from PassportX
	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX.PassportServiceX {
	/// <summary>
	/// This PassportService class is
	/// </summary>
	[WebService(Name = "MachinaX Passport Services",
				Namespace = "urn:clickclickBOOM:MachinaX",
				Description = "MachinaX.PassportX Membership Web Service")]
	public class PassportMembershipX : PassportBaseX {
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
		public PassportMembershipX() : base("PassportMembershipX") {
			_Member = new x_member(DSN, DBType);
		}
		#endregion

		#region Overridden methods (to hide web methods)
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
		#endregion

		#region Web methods required by MembershipProviderX
		/// <summary>Gets a user by email address</summary>
		/// <param name="EmailAddress">The user's email address.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Gets a user by email address")]
		public XmlDocument GetUserByEmail(string EmailAddress) {
			try {
				Result = _Member.GetMemberByEmail(EmailAddress);
			}
			catch { }
			return Result;
		}
		#endregion

		#region Web methods originally from PassportX
/*
		/// <summary>Validate a user's login information</summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="Expire">Flag to expire login (ie token).</param>
		[WebMethod(Description = "Authenticates a user via login")]
		public XmlDocument Login(string UserName, string Password, bool Expire) {
			try {
				Result = _User.Login(UserName, Password, Expire);
			} catch {
				return null;
			}
			_LogResult("Login");
			return Result;
		}

		/// <summary>Validates a user by token</summary>
		/// <param name="Token">The token issued to the user at login.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Validates the token and returns the user information")]
		public XmlDocument ValidateUser(string Token) {
			try {
				Result = _User.Validate(Token);
			}
			catch (Exception e) {
				AddError(e);
			}
			_LogResult("ValidateUser");
			return Result;
		}

		/// <summary>Validates a token</summary>
		/// <param name="Token">The token issued to the user at login.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Validates the token and returns ok/notok status only")]
		public XmlDocument Validate(string Token) {
			try {
				if (String.IsNullOrEmpty(Token))
					AddError("1003", "Token null");
				else if (_User.ValidateToken(Token))
					AddOk();
				else
					AddError("1004", String.Concat("Token not valid: ", Token));
			}
			catch (Exception e) {
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

		/// <summary>Adds a user to WebmailPassport</summary>
		/// <param name="UserName">The user's username.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's mobile telephone number.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Adds a user to WebmailPassport")]
		public XmlDocument AddUser(string Username, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo) {
			try {
				Result = _User.RegisterUser(Username, Password, FirstName, Surname, EMail, TelNo, CellNo);
			} catch (Exception e) {
				AddError(e);
			}
			_LogResult("AddUser");
			return Result;
		}
*/
		#endregion
	}
}
