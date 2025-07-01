using System.Web;
using System.Xml;
using System;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington	
	Started:	2007-MM-DD	
	Status:		release	
	Version:	2.0.0
	Build:		2007MMDD
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	-----------------------------------------------------------------------	
	Development Notes:
	==================
	2007MMDD:
	
	-----------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// The x_pseudo class provides a class that does nothing.
	/// <para>It provides a result formatted like the other classes derived from x_passport.</para>
	/// </summary>
	public class x_pseudo : x_result {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Pseudo";
		private const string TAG_USER = "User";
		#endregion

		#region Constants - Error codes (see x_user)
		private const string ERROR_LOGIN_PASSWORD = "1000";
		private const string ERROR_LOGIN_LIMIT = "1001";
		private const string ERROR_LOGIN_EXPIRED = "1002";
		private const string ERROR_LOGIN_LOCKED = "1003";
		private const string ERROR_LOGIN_STATUS_INACTIVE = "1004";
		private const string ERROR_LOGIN_STATUS_LOCKED = "1005";
		private const string ERROR_LOGIN_STATUS_ONHOLD = "1006";
		private const string ERROR_LOGIN_STATUS_LEGACY = "1007";
		private const string ERROR_LOGIN_STATUS_OTHER = "1008";
		#endregion

		#region Visible properties
		private string token;
		/// <summary>An authentication Token</summary>
		/// <value>A GUID string</value>
		public string Token {
			get { token = getToken(); return token; }
		}
		#endregion

		#region Constructors/Destructors
		/// <overloads>Constructor</overloads>
		/// <summary>Default constructor</summary>
		public x_pseudo() : base(ROOT_NAME) {
		}
		/// <summary>Constructor with root tag</summary>
		/// <param name="tag">The tag</param>
		public x_pseudo(string tag) :  base(tag) {
		}
		#endregion

		#region Public methods
		/// <summary>Logs a user out of the systeml</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		public void Logout(string Token) {
		}

		/// <summary>Validate a user's login information</summary>
		/// <param name="UserName">The Username as chosen/assigned to the user</param>
		/// <param name="Password">PIN or passphrase chosen by the user</param>
		public XmlDocument Login(string UserName, string Password) {
			// NB keep the construct below (from x_user.Login) for testing of conditions
			string procMsg = "";	// ie successful
			if (procMsg != "") {
				switch (procMsg) {
					case "Loginfailure limit reached":
						Code = ERROR_LOGIN_LIMIT;
						break;
					case "Password has expired":
						Code = ERROR_LOGIN_EXPIRED;
						break;
					case "Account still locked":
						Code = ERROR_LOGIN_LOCKED;
						break;
					case "Account is Inactive":
						Code = ERROR_LOGIN_STATUS_INACTIVE;
						break;
					case "Account is Locked":
						Code = ERROR_LOGIN_STATUS_LOCKED;
						break;
					case "Account is On-hold":
						Code = ERROR_LOGIN_STATUS_ONHOLD;
						break;
					case "Account is Legacy":
						Code = ERROR_LOGIN_STATUS_LEGACY;
						break;
					case "Account is ":	// not yet defined
						Code = ERROR_LOGIN_STATUS_OTHER;
						break;
					case "Incorrect Password":
					default:
						Code = ERROR_LOGIN_PASSWORD;
						break;
				}
				Message = procMsg;
			} else {
				Tag = TAG_USER;
				_AddAttribute("Token", getToken());
				_AddAttribute("UserID", "1");
			}
			return this as XmlDocument;
		}

		/// <summary>User idenitified by username.</summary>
		/// <param name="UserName">The user's login name</param>
		public XmlDocument GetUser() {
			Tag = TAG_USER;
			_AddAttribute("UserID", "1");
			return this as XmlDocument;
		}
		/// <summary>User idenitified by username.</summary>
		/// <param name="UserName">The user's login name</param>
		public XmlDocument GetUser(string UserName) {
			Tag = TAG_USER;
			_AddAttribute("Token", getToken());
			_AddAttribute("UserID", "1");
			return this as XmlDocument;
		}
		/// <summary>User idenitified by token.</summary>
		/// <param name="UserToken">The user's login name</param>
		public XmlDocument GetUser(Guid UserToken) {
			Tag = TAG_USER;
			_AddAttribute("Token", UserToken.ToString());
			_AddAttribute("UserID", "1");
			return this as XmlDocument;
		}
		/// <summary>User idenitified by token.</summary>
		/// <param name="UserToken">The user's login name</param>
		public XmlDocument GetUser(int UserID) {
			Tag = TAG_USER;
			_AddAttribute("Token", getToken());
			_AddAttribute("UserID", UserID.ToString());
			_AddElement("UserName", "pietiep");
			_AddElement("FirstName", "Piet");
			_AddElement("Surname", "Pompies");
			_AddElement("EMail", "pietiep@clickclickBOOM.com");
			_AddElement("TelNo", "0114829234");
			_AddElement("CellPhone", "0836475808");
			_AddElement("Status", "Description", "Active");
			_AddAttribute("Status", "PersonStatusID", "1");
			_AddElement("Safeguard", "no");
			return this as XmlDocument;
		}
		/// <summary>Used to reset the account locking mechanism for a user.</summary>
		/// <param name="Token">An authentication token</param>
		public bool ClearLock(string Token) {
			Tag = TAG_USER;
			return true;
		}
		/// <summary>Save a User's details</summary>
		/// <param name="UserID">The public User ID number used to uniquely identify a user.</param>
		/// <param name="UserName">The login name of the user.</param>
		/// <param name="Password">The password or PIN the user has chosen. No rules have been associated with this field, although it cannot be empty.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address. This will remain constant and is not affected by any subscriptions the user has.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's personal cellphone number.</param>
		/// <param name="PersonStatusID">The status of the user - linked to the PersonStatus Lookup</param>
		public XmlDocument SaveUser(int UserID, string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID) {
			return this as XmlDocument;
		}
		/// <summary>Used to register a user</summary>
		/// <param name="UserName">The login name of the user.</param>
		/// <param name="Password">The password or PIN of the user.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's mobile telephone number.</param>
		public XmlDocument RegisterUser(string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo) {
			return this as XmlDocument;
		}
		/// <summary>Gets a user's password.</summary>
		/// <param name="UserName">The login name of the user.</param>
		public XmlDocument GetPassword(string UserName) {
			return this as XmlDocument;
		}
		#endregion

		#region Private methods
		public string getToken() {
			Random rdm = new Random(unchecked((int)DateTime.Now.Ticks));
			Byte[] b = new Byte[16];
			rdm.NextBytes(b);
			Guid thisguid = new Guid(b);
			//return thisguid.ToString().Substring(0, 23);
			return thisguid.ToString();
		}
		#endregion
	}
}
