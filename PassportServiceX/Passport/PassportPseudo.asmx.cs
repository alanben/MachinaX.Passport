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
	[WebService(Name = "PassportX PassportPseudo Services",
				Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX",
				Description = "PassportX Authentication Web Service")]
	public class PassportPseudo : XXBoom.MachinaX.PassportX.PassportServiceX.PassportRootX {
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
		#endregion

		#region Constructors/Destructors
		/// <summary>Default Constructor</summary>
		public PassportPseudo() : base("User") {
			_Pseudo = new x_pseudo();
		}
		#endregion

		#region Overridden methods (to hide web methods)
		/// <summary>
		/// This method overrides the WebMethod in the parent class so that this is not exposed in the webservice
		/// </summary>
		//public override string Name() {
		//	return base.Name();
		//}
#if PRODUCTION
		public override XmlDocument Test() {
			return base.Test();
		}
		public override string TestName() {
			return base.TestName();
		}
		public override XmlDocument TestCustom(string Format, string RootName, string ResultName, string CodeName, string DescriptionName) {
			return base.Test();
		}
		public override XmlDocument TestError() {
			return base.Test();
		}
		public override XmlDocument TestException() {
			return base.Test();
		}
#endif
		#endregion

		#region Public web methods
		/// <summary>Logs a user out</summary>
		/// <param name="Token">A string containing the GUID supplied by PassportX when the user logged in.</param>
		[WebMethod(Description = "Invalidates a token")]
		public void Logout(string Token) {
			_Pseudo.Logout(Token);
		}

		/// <summary>Validate a user's login information</summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Authenticates a user via login")]
		public XmlDocument Login(string UserName, string Password) {
			XmlDocument login = null;
			try {
				login = _Pseudo.Login(UserName, Password);
				return login;
			} catch {
				return null;
			}
		}

		/// <summary>Validates a user by token</summary>
		/// <param name="Token">The token issued to the user at login.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Validates the token and returns the user information")]
		public XmlDocument ValidateUser(string Token) {
			try {
				AddOk();
				Guid tok = new Guid(Token);
				result = _Pseudo.GetUser(tok);
			} catch (Exception e) {
				AddError(e);
				result = Result;
			}
			return result;
		}

		[WebMethod(Description = "Validates a token and extends expiry")]
		public XmlDocument ValidateOnly(string Token) {
			try {
				result = _Pseudo.GetUser();
			}
			catch { }
			return result;
		}


		/// <summary>
		/// Does not require token - used for system acces to the user details.
		/// </summary>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Gets the user information for a given user ID")]
		public XmlDocument GetUser(int UserID) {
			try {
				result = _Pseudo.GetUser(UserID);
			} catch (Exception e) {
				_AddError(e);
			}
			return result;
		}

		#endregion

		#region Orginal web methods
		/*
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
			try {
				result = _Pseudo.GetUser(Username);
				if (ResultCode != null) {
					if (ResultCode.InnerText == RESULT_OK) {
						string userID = result.SelectSingleNode("//User/@UserID").InnerText;
						result = _Pseudo.SaveUser(Convert.ToInt32(userID), Username, Password, FirstName, Surname, EMail, TelNo, CellNo, STATUS_ACTIVE);
					} else {
						result = _Pseudo.RegisterUser(Username, Password, FirstName, Surname, EMail, TelNo, CellNo);
					}
				}
			}
			catch { }
			return result;
		}

		/// <summary>Verifies that a user exists</summary>
		/// <param name="Username">The user's login name.</param>
		/// <returns>'true' if username exists, all else 'false'</returns>
		[WebMethod(Description = "Verifies that a user exists")]
		public bool VerifyUsername(string Username) {
			try {
				result = _Pseudo.GetUser(Username);
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
				result = _Pseudo.GetUser(Username);
			}
			catch { }
			return result;
		}


		/// <summary>Unlocks a user's account</summary>
		/// <param name="Token">A temporarily defined unique identifier for the user.</param>
		/// <returns>Returns an XmlDocument object</returns>
		[WebMethod(Description = "Unlocks a user's account")]
		public bool UnlockUser(string Token) {
			try {
				return _Pseudo.ClearLock(Token);
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
				result = _Pseudo.GetPassword(Username);
			}
			catch { }
			return result;
		}
		*/
		#endregion
	}
}
