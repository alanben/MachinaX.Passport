using System.Web.Services;
using System.Xml;

using XXBoom.MachinaX.PassportX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2012-06-15	
	Status:		release	
	Version:	4.0.2
	Build:		20200506
	Target:		Microsoft SQL Server 2008
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20120615:	Starting point from Ididthatad.
	20130715:	Moved implementation from XXService (common to XXService implmentations)
				Set namespace to MachinaX.PassportX
	20200506:	Added GetUserToken and UpdateUserStatus that went MIA
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace MachinaX.PassportX {
	/// <summary>MachinaX common implementation</summary>
	[WebService(Name = "PassportX Customer Services",
				Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX",	// NB: Needs to be constant accross implementations - called from cmsX.dll
				Description = "PassportX Authentication Web Service")]
	public class Customer : XXBoom.MachinaX.PassportX.PassportServiceX.PassportX {
		#region Invisible properties
		XmlDocument result = null;
		#endregion

		#region Constants
		private const string RESULT_OK = "0";
		private const string RESULT_USER_DUPLICATE = "2068";

		private const int STATUS_ACTIVE = 1;
		#endregion

        #region Visible properties
        public XmlElement ResultCode {
            get { return result.SelectSingleNode("//Result/ResultCode") as XmlElement; }
        }
        public XmlElement ResultDesc {
            get { return result.SelectSingleNode("//Result/Description") as XmlElement; }
        }
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor 
		/// </summary>
		public Customer() : base() {
		}
		#endregion

		#region Overridden methods (to hide web methods)
		public override XmlDocument Login(string UserName, string Password) {
			return base.Login(UserName, Password);
		}
		#endregion

		#region Public web methods
		/// <summary>Validate a user's login information (password case INsensitive)</summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="Expire">Flag to expire login (ie token).</param>
		[WebMethod(Description = "Authenticates a user via login")]
		public XmlDocument LoginBase(string UserName, string Password) {
			return Login(UserName, Password);
		}


		/// <summary>Validate a user's login information (password case INsensitive)</summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="Expire">Flag to expire login (ie token).</param>
		[WebMethod(Description = "Authenticates a user via login (password case INsensitive)")]
		public XmlDocument Login(string UserName, string Password, bool Expire) {
			try {
				Result = _User.Login(UserName, Password.ToLower(), Expire, false);
			}
			catch {
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


		/// <summary>Registers an account Holder on PassportX</summary>
		/// <param name="UserName">The iburst username.</param>
		/// <param name="Password">The iburst password.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's mobile telephone number.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Registers an account Holder on PassportX")]
		public XmlDocument RegisterUser(string Username, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo) {
			Logger.Debug("REgisterUser start");
			try {
                result = _User.GetUser(Username);
                if (ResultCode != null) {
                    if (ResultCode.InnerText == RESULT_OK) {
                        string userID = result.SelectSingleNode("//User/@UserID").InnerText;

                        ResultCode.InnerText = "2074";
                        ResultDesc.InnerText = "User exists";
                        //result = _User.SaveUser(Convert.ToInt32(userID), Username, Password, FirstName, Surname, EMail, TelNo, CellNo, STATUS_ACTIVE);
                    } else {
                        ResultCode.InnerText = "0";
                        ResultDesc.InnerText = "ok";
                        result = _User.RegisterUser(Username, Password, FirstName, Surname, EMail, TelNo, CellNo);
                    }
                }
			}
			catch { }
			_LogResult("RegisterUser");
			return result;
		}

		/// <summary>Verifies that a user exists</summary>
		/// <param name="Username">The user's login name.</param>
		/// <returns>'true' if username exists, all else 'false'</returns>
		[WebMethod(Description = "Verifies that a user exists")]
		public bool VerifyUsername(string Username) {
			try {
				result = _User.GetUser(Username);
				if (ResultCode != null)
					return (ResultCode.InnerText == RESULT_OK);
			} catch { }
			return false;
		}


		/// <summary>Gets a user</summary>
		/// <param name="Username">The user's login name.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Gets a user")]
		public XmlDocument GetUser(string Username) {
			try {
				result = _User.GetUser(Username);
			}
			catch { }
			return result;
		}


		/// <summary>Gets a user by UserID</summary>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Gets the user information for a given user ID (including the password)")]
		public XmlDocument GetUserID(int UserID) {
			try {
				result = _User.GetUser(UserID, true);
			}
			catch { }
			return result;
		}


		/// <summary>Gets a user by Token</summary>
		/// <param name="Token">A temporarily defined unique identifier for the user.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Gets the user information for a given user Token (including the password)")]
		public XmlDocument GetUserToken(string Token) {
			try {
				result = _User.GetUserByToken(Token);
			} catch { }
			return result;
		}


		/// <summary>Unlocks a user's account</summary>
		/// <param name="Token">A temporarily defined unique identifier for the user.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Unlocks a user's account")]
		public bool UnlockUser(string Token) {
			try {
				return _User.ClearLock(Token);
			}
			catch {
				return false;
			}
		}


		/// <summary>Gets a user's password</summary>
		/// <param name="Username">The user's login name.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Gets a user's password")]
		public XmlDocument GetPassword(string Username) {
			try {
				result = _User.GetPassword(Username);
			}
			catch { }
			return result;
		}


		/// <summary>Gets a user's password hint information</summary>
		/// <param name="Username">The user's login name.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Gets a user's password hint information")]
		public XmlDocument GetHint(string Username) {
			try {
				result = _User.GetHint(Username);
			}
			catch { }
			return result;
		}


		/// <summary>Unlocks a user's account</summary>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <param name="Status">The user's status, typically 'Locked' or 'Active'</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Unlocks a user's account")]
		public bool UpdateUserStatus(int UserID, string Status) {
			try {
				return _User.UpdateUserStatus(UserID, Status);
			} catch {
				return false;
			}
		}

		#endregion
	}
}
