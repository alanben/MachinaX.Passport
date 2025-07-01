using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

using XXBoom.MachinaX.DataX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.6.0
	Build:		20110406
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20070814:	Starting point. Creation of the x_recruit class to deal with recruiting of users
				Class hierarchy is:
				x_recruit -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	20081020:	Added Password field to Recruit
	20081023:	Added Username field to Recruit
	20110406:	Added PersonID field to RegisterRecruit and UserName to SaveRecruit
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// The Recruit class implements methods for the recruiting and verification of users
	/// </summary>
	public class x_recruit : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Recruit";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_GET		= "x_RecruitGet";
		private const string PROC_GET_TOKEN = "x_RecruitGetToken";
		private const string PROC_UPDATE	= "x_RecruitUpdate";
		private const string PROC_INSERT	= "x_RecruitAdd";
		private const string PROC_DELETE	= "x_RecruitDelete";
		#endregion

		#region Error constants
		private const string ERROR_READ = "Error reading the Recruit record.";
		private const int ERROR_READ_CODE = 5001;
		private const string ERROR_REGISTER = "Error registering the Recruit.";
		private const int ERROR_REGISTER_CODE = 5002;
		private const string ERROR_GET = "Error retrieving the Recruit details.";
		private const int ERROR_GET_CODE = 5003;
		private const string ERROR_UPDATE = "Error updating the Recruit details.";
		private const int ERROR_UPDATE_CODE = 5004;
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Recruit class.
		/// </summary>
		public x_recruit(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_recruit(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>Registers a recruit. A recruit is the core identity of a person which is yet to be verified</summary>
		/// <param name="UserName">The user's username.</param>
		/// <param name="Password">The user's password.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's landline number.</param>
		/// <param name="CellNo">The user's mobile number.</param>
		/// <param name="Type">The type (identifier) of user</param>
		/// <param name="PersonID">The ID of the recruit as a user (ie assigned when a recruit becomes a user)</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument RegisterRecruit(string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int Type, int PersonID) {
			using (Connect()) {
				try {
					using (Command(PROC_INSERT)) {
						if (DataXManager.ProviderType != DataProviderType.SqlServer) {
							string thistoken = Guid.NewGuid().ToString();
							AddSQLParameter(thistoken, "@Token", 36);
						}
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Password, "@Password", 50);
						AddSQLParameter(FirstName, "@FirstName", 50);
						AddSQLParameter(Surname, "@Surname", 50);
						AddSQLParameter(EMail, "@Email", 50);
						AddSQLParameter(TelNo, "@TelNo", 35);
						AddSQLParameter(CellNo, "@CellNo", 20);
						AddSQLParameter(Type, "@Type");
						AddSQLParameter(PersonID, "@PersonID");
						readRecruit();
					}
				} catch (Exception exc) {
					Error(ERROR_REGISTER_CODE, ERROR_REGISTER, exc);
				}
			return this as XmlDocument;
			}
		}



		/// <overloads>Retrieves a user's details</overloads>
		/// <summary>Recruit idenitified by Gatekeeper identifier.</summary>
		/// <param name="RecruitID">The user's identifier.</param>
		public XmlDocument GetRecruit(int RecruitID) {
			return getRecruit(RecruitID, "", "", "");
		}
		/// <summary>Recruit idenitified by username.</summary>
		/// <param name="RecruitName">The user's login name</param>
		public XmlDocument GetRecruit(string RecruitName) {
			return getRecruit(0, RecruitName, "", "");
		}
		/// <summary>Recruit idenitified by last issued token.</summary>
		/// <param name="RecruitToken">The user's last token</param>
		public XmlDocument GetRecruit(Guid RecruitToken) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return getRecruit(0, "", RecruitToken.ToString(), "");
			else
				return getRecruit(RecruitToken);
		}
		/// <summary>Recruit idenitified by last issued token.</summary>
		/// <param name="RecruitToken">The user's last token</param>
		public XmlDocument GetRecruitByToken(string RecruitToken) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return getRecruit(0, "", RecruitToken, "");
			else
				return getRecruit(new Guid(RecruitToken));
		}
		/// <summary>Recruit idenitified by cellphone number.</summary>
		/// <param name="RecruitCellNo">The user's cellphone number</param>
		public XmlDocument GetRecruitByCell(string RecruitCellNo) {
			return getRecruit(0, "", "", RecruitCellNo);
		}
		private XmlDocument getRecruit(int RecruitID, string RecruitEmail, string RecruitToken, string RecruitCellNo) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(RecruitID, "@RecruitID");
						AddSQLParameter(RecruitToken, "@RecruitToken", 50);
						AddSQLParameter(RecruitCellNo, "@RecruitCellPhone", 20);
						AddSQLParameter(RecruitEmail, "@RecruitEmail", 50);
						readRecruit();
					}
				} catch (Exception exc) {
					Error(ERROR_GET_CODE, ERROR_GET, exc);
				}
			}
			return this as XmlDocument;
		}
		private XmlDocument getRecruit(Guid RecruitToken) {
			using (Connect()) {
				try {
					using (Command(PROC_GET_TOKEN)) {
						AddSQLParameter(RecruitToken.ToString(), "@RecruitToken", 50);
						readRecruit();
					}
				} catch (Exception exc) {
					Error(ERROR_GET_CODE, ERROR_GET, exc);
				}
			}
			return this as XmlDocument;
		}



		/// <summary>Removes a recruit</summary>
		/// <param name="ID">The recruit ID, used to uniquely identify a user.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		public bool RemoveRecruit(int ID) {
			using (Connect()) {
				try {
					using (Command(PROC_DELETE)) {
						AddSQLParameter(ID, "@ID");
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}



		/// <summary>Updates a recruit's details</summary>
		/// <param name="ID">The recruit ID, used to uniquely identify a user.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address. This will remain constant and is not affected by any subscriptions the user has.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's personal cellphone number.</param>
		/// <param name="PersonID">The ID of the recruit as a user (ie assigned when a recruit becomes a user)</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument SaveRecruit(int ID, string UserName, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int PersonID) {
			using (Connect()) {
				try {
					using (Command(PROC_UPDATE)) {
						AddSQLParameter(ID, "ID");
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(FirstName, "@FirstName", 50);
						AddSQLParameter(Surname, "@Surname", 50);
						AddSQLParameter(EMail, "@Email", 50);
						AddSQLParameter(TelNo, "@TelNo", 35);
						AddSQLParameter(CellNo, "@CellNo", 20);
						AddSQLParameter(PersonID, "@PersonID");
						readRecruit();
					}
				} catch (Exception exc) {
					Error(ERROR_UPDATE_CODE, ERROR_UPDATE, exc);
				}
			return this as XmlDocument;
			}
		}
	

		#endregion

		#region Protected methods
		#endregion

		#region Private methods
		private void readRecruit() {
			using (Reader()) {
				if (Read()) {
					AddAttribute("ID", "ID");
					AddAttribute("Token", "Token");
					AddAttribute("UserName", "UserName");
					AddAttribute("Password", "Password");
					AddAttribute("FirstName", "FirstName");
					AddAttribute("Surname", "Surname");
					AddAttribute("EMail", "Email");
					AddAttribute("TelNo", "TelNo");
					AddAttribute("CellPhone", "CellPhone");
					AddAttribute("SignupDate", "SignupDate");
					AddAttribute("Type", "Type");
					AddAttribute("TypeID", "TypeID");
					AddAttribute("UserID", "PersonID");
				} else {
					Error(ERROR_READ_CODE, ERROR_READ);
				}
			}
		}
		#endregion
	}
}
