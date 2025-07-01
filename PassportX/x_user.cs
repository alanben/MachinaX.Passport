using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

using XXBoom.MachinaX.DataX;
//using Npgsql;
//using CoreLab.PostgreSql;
//using MySql.Data;			// MySQL Connector/Net

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	4.0.3
	Build:		20140831
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

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20070220:  Changes have been made in refactoring that serve as a model for other the other GK objects, these include:
				- use of AddSQLParameter, GetSqlString, GetSqlYesNo etc
				Was: 2469 lines, now 1854 including notes and comments
				Class hierarchy as follows:
				GK(User) _
						| _ GateKeeperBase _
										|_ GateKeeperResult
	20070527:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_user -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	20080103:	Added alternative login mechnaism that uses logic defined in this class (rather than in the store proc)
				- this is to make the logic easier to manage and more configurable.
	20080413:	Added GetHint to get hint info (quetionID, hint answer and password)
	20080507:	Added support for PostGreSQL using CoreLab's data provider (Exception in login)
	20080529:	Added GetUser overload with flag to return password in result.
	20080622:	Added GetUserByEmail overloads.
	20080704:	Changes to allow for Login where the check on the password is case-insensitive (ie this assumes that
				the password supplied is lower-cased and then checks against a result from the db that is lower-cased.)
	20081009:	The following changes:
				- Error code handling (ex x_pattern)
				- IsUser added.
				- RegisterUser modified to return the user details as per GetUser
				- SaveUser modified to return the user details as per GetUser
	20081104:	Added Contact Preference data/fields to the user
	20090520:	Temporarily commented Contact Preference in addgotUser (backward compatability)
	20090526:	Extended session to 60 minutes and removed addgotUser from registerUserDB (for Loeries)
	20090728:	Added token expiry to be read from config and passed as 
				parameters in login and validate procedure calls.
	20110320:	Added CellCheck to RegisterUser
	20121114:	Replaced VaildateToken with new method that allows for validation of tokens that expire with login (ie RememberMe is on)
	20140831:	Commented references to Npgsql, CoreLab, MySql namespaces to remove dependencies
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
										
namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// The User class implements validation for a user, Login
	/// and also allows users with necessary permissions to add/update/delete users.
	/// <p>Access to the User class is limited to the Gatekeeper Web Service only.</p>
	/// </summary>
	public class x_user : x_passport {
		#region Invisible properties
		private int LOGIN_FAILURE_LIMIT = 3;
		#endregion

		#region Constants
		private const string ROOT_NAME = "User";
		private const string DEFAULT_ACCLOCK_HOURS = "6";
		private const string DEFAULT_TOKEN_MINUTES = "60";	// NB -- needs to be set in config (Also look at how SqlServer deals with this - ie in Config table)
		private const string DEFAULT_PASSWORD_DAYS = "90";
		private const int LOGIN_STATUS_ACTIVE = 1;
		private const int LOGIN_STATUS_INACTIVE = 2;
		private const int LOGIN_STATUS_LOCKED = 3;
		private const int LOGIN_STATUS_ONHOLD = 4;
		private const int LOGIN_STATUS_LEGACY = 5;
		private const int PARAM_TOKEN_LENGTH = 50;
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_LOGIN				=	"x_UserLogin";
		private const string PROC_LOGINGET			=	"x_UserLoginGet";
		private const string PROC_LOGINGETT			=	"x_UserLoginGetName";
		private const string PROC_LOGOUT			=	"x_UserLogout";
		private const string PROC_VALID				=	"x_Validate";
		private const string PROC_VALID_TOKEN		=	"x_ValidateToken";
		private const string PROC_VALIDATE			=	"x_UserValidate";
		private const string PROC_VALIDATE_ONLY		=	"x_UserValidateOnly";
		private const string PROC_PERSON			=	"x_UserGet";
		private const string PROC_PERSONS			=	"x_UserListPaged";
		private const string PROC_PERSONSS			=	"x_UserListPagedSorted";
		private const string PROC_LIST				=	"x_UserList";
		private const string PROC_GET				=	"x_UserGet";
		private const string PROC_GETID				=	"x_UserGetID";
		private const string PROC_GET_UNAME			=	"x_UserGetUsername";
		private const string PROC_GET_TOKEN			=	"x_UserGetToken";
		private const string PROC_GET_CELLNO		=	"x_UserGetCellphone";
		private const string PROC_GET_EMAIL			=	"x_UserGetEmail";
		private const string PROC_GETALL			=	"x_UserGetAll";
		private const string PROC_UPDATE			=	"x_UserUpdate";
		private const string PROC_INSERT			=	"x_UserAdd";
		private const string PROC_DELETE			=	"x_UserDelete";
		private const string PROC_NAME				=	"x_UserGetName";
		private const string PROC_FIND				=	"x_UserFind";
		private const string PROC_FIND_ADV			=	"x_UserFindAdvanced";
		private const string PROC_SEARCH			=	"x_UserSearch";
		private const string PROC_SEARCH_ADV		=	"x_UserSearchAdvanced";
		private const string PROC_STATUS			=	"x_UserStatusUpdate";
		private const string PROC_HINT				=	"x_UserHint";
		private const string PROC_PASSWORD_GET		= "x_UserPassword";
		private const string PROC_PASSWORD_UPDATE	= "x_UserPasswordUpdate";
		private const string PROC_EXPIRE			=	"x_UserPasswordExpire";
		private const string PROC_ANSWER			=	"x_UserAnswerAdd";
		private const string PROC_QUESTION			=	"x_UserQuestionValidate";
		private const string PROC_SERVICES			=	"x_UserServiceList";
		private const string PROC_SERVICE_ADD		=	"x_UserServiceAdd";
		private const string PROC_SERVICE_DEL		=	"x_UserServiceDelete";
		private const string PROC_PRODUCT_ADD		=	"x_UserProductAdd";
		private const string PROC_PRODUCT_DEL		=	"x_UserProductDelete";
		private const string PROC_GROUP_ADD			=	"x_UserGroupAdd";
		private const string PROC_GROUP_DEL			=	"x_UserGroupDelete";
		private const string PROC_PROFILES			=	"x_UserProfileList";
		private const string PROC_PROFILE_ADD		=	"x_UserProfileAdd";
		private const string PROC_PROFILE_DEL		=	"x_UserProfileDelete";
		private const string PROC_LOCK_DEL			=	"x_UserLockClear";
		private const string PROC_LOCK_ADD			=	"x_UserLockSet";
		private const string PROC_SET_LOGIN_FAIL	= "x_UserSetLoginFail";
		private const string PROC_SET_LOGIN_OK		= "x_UserSetLoginOK";
		private const string PROC_CONTACT			= "x_UserContact";
		#endregion

		#region Constants - Login Error codes
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

		#region Constants - General Error Codes
		private const int ERROR_BASE = 2100;
		private const int ERROR_GET = 1;
		private const int ERROR_GET_EXC = 2;
		private const int ERROR_VALID = 3;
		private const int ERROR_VALID_EXC = 4;
		private const int ERROR_LOGIN = 5;
		private const int ERROR_LOGIN_EXC = 6;
		private const int ERROR_SAVE = 7;
		private const int ERROR_SAVE_EXC = 8;
		private const int ERROR_SAVE_DUPL = 9;
		private const int ERROR_PASSWORD = 10;
		private const int ERROR_IMPORT = 11;
		private const int ERROR_CONTACT = 12;
		private const int ERROR_CONTACT_EXC = 13;
		#endregion

		#region Visible properties
		private string userID;
		/// <summary>The User's unique identifier.</summary>
		/// <value>A string containing the unique identifier.</value>
		public string UserID {
			get { return userID; }
			set { userID = value; }
		}
		private string expireToken;
		/// <summary></summary>
		/// <value></value>
		public int ExpireToken {
			get { return Int32.Parse(expireToken); }
			set { expireToken = value.ToString(); }
		}
		private string expireAccountLock;
		/// <summary></summary>
		/// <value></value>
		public double ExpireAccountLock {
			get { return Double.Parse(expireAccountLock); }
			set { expireAccountLock = value.ToString(); }
		}
		private string expirePassword;
		/// <summary></summary>
		/// <value></value>
		public double ExpirePassword {
			get { return Double.Parse(expirePassword); }
			set { expirePassword = value.ToString(); }
		}
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the User class.
		/// </summary>
		/// <param name="DSN">Data provider connection string</param>
		public x_user(string DSN) : base(DSN, ROOT_NAME) {
			initialise();
		}
		/// <summary>
		/// Constructor that specifies data provider type
		/// </summary>
		/// <param name="DSN">Data provider connection string</param>
		/// <param name="DBType">Data provider type</param>
		public x_user(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
			initialise();
		}
		#endregion

		#region Private methods
		private void initialise() {
			expireToken = Config.Value(String.Format("PassportX/ExpiryPeriods/Period[@id='{0}']", "Token"), DEFAULT_TOKEN_MINUTES);
			expireAccountLock = Config.Value(String.Format("PassportX/ExpiryPeriods/Period[@id='{0}']", "AccountLock"), DEFAULT_ACCLOCK_HOURS);
			expirePassword = Config.Value(String.Format("PassportX/ExpiryPeriods/Period[@id='{0}']", "Password"), DEFAULT_PASSWORD_DAYS);
			Logger.Debug(String.Concat("initialise::expireToken:", expireToken, " :expireAccountLock:", expireAccountLock, " :expirePassword:", expirePassword));
		}
		#endregion

		#region Public methods
		/// <summary>Connect to database - used to test connection</summary>
		public XmlDocument Connection() {
			using (Connect()) {
			}
			return this as XmlDocument;
		}
		
		/// <summary>
		/// Validate a user's login information, and returns an XML document containing a Token to the user which must be used 
		/// throughout the session to validate the user when accessing any system the Gatekeeper controls access to.
		/// </summary>
		/// <param name="UserName">The Username as chosen/assigned to the user</param>
		/// <param name="Password">PIN or passphrase chosen by the user</param>
		/// <param name="ExpireToken">Flag to indicate if token is expired (else set to password expiry date)</param>
		/// <param name="PasswordCase">Flag to indicate if password check is case-sensitive (else check is lower-cased)</param>
		/// <param name="PasswordEncrypted">Flag to indicate if password is encrypted (then check done in the login procedure)</param>
		/// <returns>
		/// XmlDocument object, containing information on the result of the login, and any related error messages.
		/// </returns>
		public XmlDocument Login(string UserName, string Password, bool ExpireToken, bool PasswordCase, bool PasswordEncrypted) {
			login(UserName, Password, ExpireToken, PasswordCase, PasswordEncrypted);
			return this as XmlDocument;
		}
		public XmlDocument Login(string UserName, string Password, bool ExpireToken, bool PasswordCase) {
			login(UserName, Password, ExpireToken, PasswordCase, false);
			return this as XmlDocument;
		}
		public XmlDocument Login(string UserName, string Password, bool ExpireToken) {
			login(UserName, Password, ExpireToken, true, false);
			return this as XmlDocument;
		}
		public XmlDocument Login(string UserName, string Password) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				loginDB(UserName, Password);
			else
				login(UserName, Password);
			return this as XmlDocument;
		}
		private void login(string UserName, string Password) {
			login(UserName, Password, true, true, false);
		}
		private void login(string UserName, string Password, bool expireToken, bool passwordCase, bool passwordEncrypted) {
			Logger.Debug(String.Concat("login::UserName:", UserName, ":Password:", Password, ":expireToken:", expireToken.ToString(), ":passwordCase:", passwordCase.ToString(), ":passwordEncrypted:", passwordEncrypted.ToString()));
			
			int loginStatus = 1;	// > 0 indicates login not verified, this set to  0 only in the case of status being returned from a procedure that does a check in the db against encrypted password
			
			using (Connect()) {
				try {
					string proc = (passwordEncrypted) ? PROC_LOGINGET : PROC_LOGINGETT;
					Logger.Debug(String.Concat("login::proc:", proc));

					using (Command(proc)) {
						Logger.Debug(String.Concat("login::UserName:>", UserName, "<"));

						AddSQLParameter(UserName, "@UserName", 128);
						if (passwordEncrypted) {
							AddSQLParameter(Password, "@UserPassword", 128);
						}

						using (Reader()) {
							if (Read()) {
								Logger.Debug(String.Concat("login::PersonID:", GetValue("PersonID")));

								int userID = Convert.ToInt32(GetValue("PersonID", DbType.Int32));
								string userPassword = (passwordCase) ? GetValue("Password") : GetValue("Password").ToLower();

								int userLoginFailures = Convert.ToInt32(GetValue("LoginFailures", DbType.Int32));
								Logger.Debug(String.Concat("login::userPassword:", userPassword));

								string userPasswordExpiryDate = GetValue("PasswordExpiryDate");
								Logger.Debug(String.Concat("login::userPasswordExpiryDate:", userPasswordExpiryDate));

								string userAccLockedDate = GetValue("AccLockedDate");
								int userStatusID = Convert.ToInt32(GetValue("PersonStatusID", DbType.Int32));
								if (passwordEncrypted) {
									loginStatus = Convert.ToInt32(GetValue("LoginStatus", DbType.Int32));
								}
								DBReader.Close();

								string userMsg, userToken;
								Code = checkLogin(expireToken, userID, Password, userPassword, userLoginFailures, userPasswordExpiryDate, userAccLockedDate, userStatusID, loginStatus, out userMsg, out userToken);
								Message = userMsg;
								
								_AddAttribute("Token", userToken);
								_AddAttribute("UserID", userID.ToString());	// get UserID from output parameter
							} else {
								Error(ERROR_BASE, ERROR_VALID, "There was an unexpected error while validating the login information. Does username exist?");
							}
						}
					}
				//} catch (MySql.Data.MySqlClient.MySqlException e) {
				//	Error(ERROR_BASE, ERROR_LOGIN, String.Concat("There was an error attempting to Login:", e.Source, "::", e.Number.ToString()), e as Exception);
				//} catch (NpgsqlException e) {
				//	Error(ERROR_BASE, ERROR_LOGIN, String.Concat("There was an error attempting to Login:", e.Routine, "::", e.ErrorSql), e as Exception);
				//} catch (PgSqlException e) {
				//	Error(ERROR_BASE, ERROR_LOGIN, String.Concat("There was an error attempting to Login:", e.ProcedureName, "::", e.Message), e as Exception);
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_LOGIN_EXC, "There was an error attempting to Login", exc);
				}
			}
		}
		private string checkLogin(bool expToken, int userid, string inpassword, string password, int loginfail, string passexpiredate, string acclockeddate, int statusid, int loginstatus, out string message, out string token) {
			Logger.Debug(String.Concat("checkLogin::userid:", userid.ToString(), ":loginstatus:", loginstatus.ToString()));
			Logger.Debug(String.Concat("checkLogin::inpassword:", inpassword, ":password:", password));
			int thisloginfail = 0;
			message = "Incorrect Password";
			token = "";
			string code = ERROR_LOGIN_PASSWORD;
			DateTime loginDate = DateTime.Now;

			// first check if login expiry date has been reached (ie hasn't logged on within expiry period)
			if (passexpiredate != "null" && DateTime.Compare(loginDate, DateTime.Parse(passexpiredate)) > 0) {
				message = "Login has expired";
				code = ERROR_LOGIN_EXPIRED;
				Logger.Debug(String.Concat("checkLogin::", message));
			// next check if account is (temporarily) locked
			} else if (acclockeddate != "null" && DateTime.Compare(loginDate, DateTime.Parse(acclockeddate)) < 0) {
				message = "Account still locked";
				code = ERROR_LOGIN_LOCKED;
				Logger.Debug(String.Concat("checkLogin::", message));
			// check the status of the user (ie "Active" is OK all else NotOK)
			} else if (statusid != LOGIN_STATUS_ACTIVE) {
				switch (statusid) {
					case LOGIN_STATUS_INACTIVE:
						message = "Account is Inactive";
						code = ERROR_LOGIN_STATUS_INACTIVE;
						break;
					case LOGIN_STATUS_LOCKED:
						message = "Account is Locked";
						code = ERROR_LOGIN_STATUS_LOCKED;
						break;
					case LOGIN_STATUS_ONHOLD:
						message = "Account is On-hold";
						code = ERROR_LOGIN_STATUS_ONHOLD;
						break;
					case LOGIN_STATUS_LEGACY:
						message = "Account is Legacy";
						code = ERROR_LOGIN_STATUS_LEGACY;
						break;
					default:
						message = "Account is not active";	// not yet defined
						Code = ERROR_LOGIN_STATUS_OTHER;
						break;
				}
				Logger.Debug(String.Concat("checkLogin::", message));
			// correct password: update session and dates
			} else if (inpassword.CompareTo(password) == 0 || loginstatus == 0) {
				Logger.Debug(String.Concat("checkLogin::OK"));
				// if expToken flag is set, set token to expire in minutes else expire in same period as password;
				DateTime tokenExpire = (expToken) ? loginDate.AddMinutes(ExpireToken) : loginDate.AddDays(ExpirePassword);
				DateTime loginExpire = loginDate.AddDays(ExpirePassword);
				string thistoken = Guid.NewGuid().ToString();
				using (Command(PROC_SET_LOGIN_OK)) {
					AddSQLParameter(userid, "@UserID");
					AddSQLParameter(thisloginfail, "@FailCount");
					AddSQLParameter(thistoken, "@Token", PARAM_TOKEN_LENGTH);
					AddSQLParameter(loginDate, "@LoginDate", DbType.DateTimeOffset);
					AddSQLParameter(tokenExpire, "@TokenDate", DbType.DateTimeOffset);
					AddSQLParameter(loginExpire, "@ExpireDate", DbType.DateTimeOffset);
					Execute();
				}
				message = "Login OK";
				code = "0";
				token = thistoken;

			// incorrect password: handle the failure count and locking where necassary
			} else {
				thisloginfail = loginfail + 1;
				DateTime thisLockDate = DateTime.Now;
				if (thisloginfail > LOGIN_FAILURE_LIMIT) {
					thisloginfail = 0;	// ie will get other tries after lock date
					code = ERROR_LOGIN_LIMIT;
					message = "Loginfailure limit reached";
					thisLockDate = DateTime.Now.AddHours(ExpireAccountLock);
				}
				using (Command(PROC_SET_LOGIN_FAIL)) {
					AddSQLParameter(userid, "@UserID");
					AddSQLParameter(thisloginfail, "@FailCount");
					AddSQLParameter(DateTime.Now, "@FailDate", DbType.DateTimeOffset);
					AddSQLParameter(thisLockDate, "@LockDate", DbType.DateTimeOffset);
					Execute();
				}
			}
			return code;
		}
		private void loginDB(string UserName, string Password) {
			using (Connect()) {
				try {
					using (Command(PROC_LOGIN)) {
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Password, "@Password", 50);
						IDataParameter userid = AddSQLParameter("@Userid");
						using (Reader()) {
							if (Read()) {
								if (Test("Result")) {
									string procMsg = GetValue("Result");
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
										
									}
									Message = procMsg;
								}
								if (Test("Token")) {
									AddAttribute("Token", "Token", DbType.Guid);
								}
							} else {
								Error(ERROR_BASE, ERROR_VALID, "There was an unexpected error while validating the login information.");
							}
						}
						_AddAttribute("UserID", GetValue(userid));	// get UserID from output parameter
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_LOGIN_EXC, "There was an error attempting to Login", exc);
				}
			}
		}

		/// <summary>Validate that a user has a valid Token, and extends validity period.</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <returns>
		/// An XML Document object.
		/// If the validation is successful, the ResultCode will be 0 (zero) and the Products and Services will be
		/// populated with the records where the user has access. If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		public XmlDocument Validate(string Token, bool Expire) {
			DateTime loginDate = DateTime.Now;
			DateTime tokenExpire = (Expire) ? loginDate.AddMinutes(ExpireToken) : loginDate.AddDays(ExpirePassword);
			DateTime loginExpire = loginDate.AddDays(ExpirePassword);

			//if (DataXManager.ProviderType == DataProviderType.SqlServer) {
			//	return Validate(Token, "", loginDate, tokenExpire, loginExpire);
			//} else {
			//	return ValidateOnly(Token, loginDate, tokenExpire, loginExpire);
			//}
			return validate(Token, loginDate, tokenExpire, loginExpire);
		}
		/// <summary>Validate that a user has a valid Token, and extends validity period.</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <returns>
		/// An XML Document object.
		/// If the validation is successful, the ResultCode will be 0 (zero) and the Products and Services will be
		/// populated with the records where the user has access. If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		public XmlDocument Validate(string Token, string ServiceName, bool Expire) {
			DateTime loginDate = DateTime.Now;
			DateTime tokenExpire = (Expire) ? loginDate.AddMinutes(ExpireToken) : loginDate.AddDays(ExpirePassword);
			DateTime loginExpire = loginDate.AddDays(ExpirePassword);

			return validate(Token, ServiceName, loginDate, tokenExpire, loginExpire);
		}
		/// <summary>Validates access to a specific service or services (if ServiceName IsNullorEmpty)</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <param name="ServiceName">The name of a service to return the access to, and also relevant permissions and status information.</param>
		/// <returns>
		/// An XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service.
		/// If the validation is successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		private XmlDocument validate(string Token, string ServiceName, DateTime LoginDate, DateTime TokenExpire, DateTime LoginExpire) {
			using (Connect()) {
				try {
					using (Command(PROC_VALIDATE)) {
						AddSQLParameter(Token, "@Token", PARAM_TOKEN_LENGTH);
						AddSQLParameter(ServiceName, "@Service", 100);
						AddSQLParameter(LoginDate, "@LoginDate", DbType.DateTimeOffset);
						AddSQLParameter(TokenExpire, "@TokenDate", DbType.DateTimeOffset);
						AddSQLParameter(LoginExpire, "@ExpireDate", DbType.DateTimeOffset);
						IDataParameter parUserid = AddSQLParameter("@UserID");
						IDataParameter parResult = AddSQLParameter("@Result", 100, true);
						using (Reader()) {
							if (parResult.Value == DBNull.Value || parResult.Value == null || parResult.Value.ToString() == "") {
								while (Read()) {
									XmlElement xnServices = _AddElement("Services");
									XmlElement xnService = _AddElement(xnServices, "Service");
									xnService.SetAttribute("ServiceID", GetValue("ServiceID", DbType.Int32));
									xnService.SetAttribute("Description", GetValue("Description"));
									xnService.SetAttribute("Status", GetValue("Status"));
									xnService.SetAttribute("SecurityLevel", GetValue("SecurityLevel"));
									xnService.SetAttribute("DisplayMessage", GetValue("DisplayMessage"));
									xnService.SetAttribute("ServiceIdentifier", GetValue("ServiceIdentifier"));
								}
							} else {
								Error(ERROR_BASE, parResult.Value.ToString());
							}
						}
						_AddAttribute("ResultID", parResult.Value.ToString());	// get UserID from output parameter
						_AddAttribute("UserID", parUserid.Value.ToString());	// get UserID from output parameter
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALID_EXC, "There was an error validating the user", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>Validates user</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <returns>
		/// An XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service.
		/// If the validation is successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		private XmlDocument validate(string Token, DateTime LoginDate, DateTime TokenExpire, DateTime LoginExpire) {
			using (Connect()) {
				try {
					using (Command(PROC_VALIDATE_ONLY)) {
						AddSQLParameter(Token, "@Token", PARAM_TOKEN_LENGTH);
						AddSQLParameter(LoginDate, "@LoginDate", DbType.DateTimeOffset);
						AddSQLParameter(TokenExpire, "@TokenDate", DbType.DateTimeOffset);
						AddSQLParameter(LoginExpire, "@ExpireDate", DbType.DateTimeOffset);
						using (Reader()) {
							if (Read()) {
								AddAttribute("Token", "Token");
								AddAttribute("UserID", "PersonID");
								AddElement("Password", "Password");
								AddElement("UserName", "UserName");
								AddElement("FirstName", "FirstName");
								AddElement("Surname", "Surname");
								AddElement("EMail", "Email");
								AddElement("TelNo", "TelNo");
								AddElement("CellPhone", "CellPhone");
								AddElement("Status", "Description", "PersonStatusDesc");
								AddAttribute("Status", "PersonStatusID", "PersonStatusID", DbType.Int32);
								AddElement("Safeguard", "AccLockedDate", DbType.Boolean);
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALID_EXC, "There was an error validating the user", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>DEPRECATED: Validate that a user has a valid Token, and extends validity period.</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <returns>
		/// An XML Document object.
		/// If the validation is successful, the ResultCode will be 0 (zero) and the Products and Services will be
		/// populated with the records where the user has access. If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		public XmlDocument Validate(string Token) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return Validate(Token, "");
			else
				return ValidateOnly(Token);
			
		}
		/// <summary>DEPRECATED: Validates access to a specific service only</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <param name="ServiceName">The name of a service to return the access to, and also relevant permissions and status information.</param>
		/// <returns>
		/// An XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service.
		/// If the validation is successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		public XmlDocument Validate(string Token, string ServiceName) {
			using (Connect()) {
				try {
					using (Command(PROC_VALIDATE)) {
						AddSQLParameter(Token, "@Token", 65);
						AddSQLParameter(ExpireToken, "@ExpiryMinutes");
						AddSQLParameter(ServiceName, "@Service", 100);
						IDataParameter parUserid = AddSQLParameter("@UserID");
						IDataParameter parResult = AddSQLParameter("@Result", 100, true);
						using (Reader()) {
							if (parResult.Value == DBNull.Value || parResult.Value == null || parResult.Value.ToString() == "") {
								while (Read()) {
									if (ServiceName != "") {
										XmlElement xnServices = _AddElement("Services");
										XmlElement xnService = _AddElement(xnServices, "Service");
										xnService.SetAttribute("ServiceID", GetValue("ServiceID", DbType.Int32));
										xnService.SetAttribute("Description", GetValue("Description"));
										xnService.SetAttribute("Status", GetValue("Status"));
										xnService.SetAttribute("SecurityLevel", GetValue("SecurityLevel"));
										xnService.SetAttribute("DisplayMessage", GetValue("DisplayMessage"));
										xnService.SetAttribute("ServiceIdentifier", GetValue("ServiceIdentifier"));
									}
								}
							} else {
								Error(ERROR_BASE, parResult.Value.ToString());
							}
						}
						_AddAttribute("ResultID", parResult.Value.ToString());	// get UserID from output parameter
						_AddAttribute("UserID", parUserid.Value.ToString());	// get UserID from output parameter
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALID_EXC, "There was an error validating the user", exc);
				}
			}
			return this as XmlDocument;
		}
		/// <summary>DEPRECATED: Validates access to a specific service only</summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <returns>
		/// An XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service.
		/// If the validation is successful, the ResultCode will be 0 (zero). If not, the Result will contain the error code and
		/// description or reason the validation failed.
		/// </returns>
		public XmlDocument ValidateOnly(string Token) {
			using (Connect()) {
				try {
					using (Command(PROC_VALIDATE_ONLY)) {
						AddSQLParameter(Token, "@Token", 65);
						AddSQLParameter(ExpireToken, "@ExpiryMinutes");
						using (Reader()) {
							if (Read()) {
								AddAttribute("Token", "Token");
								AddAttribute("UserID", "PersonID");
								AddElement("Password", "Password");
								AddElement("UserName", "UserName");
								AddElement("FirstName", "FirstName");
								AddElement("Surname", "Surname");
								AddElement("EMail", "Email");
								AddElement("TelNo", "TelNo");
								AddElement("CellPhone", "CellPhone");
								AddElement("Status", "Description", "PersonStatusDesc");
								AddAttribute("Status", "PersonStatusID", "PersonStatusID", DbType.Int32);
								AddElement("Safeguard", "AccLockedDate", DbType.Boolean);
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALID_EXC, "There was an error validating the user", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Logs a user out from the Gatekeeper system
		/// </summary>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		public XmlDocument Logout(string Token) {
			using (Connect()) {
				try {
					using (Command(PROC_LOGOUT)) {
						AddSQLParameter(Token, "@Token", 65);
						Execute();
						_AddAttribute("Token", Token);
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALID_EXC, "There was an error validating the user", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Save a User's details - database implementation will check if no UserID is present, a new 
		/// user record is created.
		/// </summary>
		/// <param name="UserID">The public User ID number used to uniquely identify a user.</param>
		/// <param name="UserName">The login name the user will use to access all systems controlled by the Gatekeeper system. This name must be unique in the Gatekeeper database.</param>
		/// <param name="Password">The password or PIN the user has chosen. No rules have been associated with this field, although it cannot be empty.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's personal cellphone number.</param>
		/// <param name="PersonStatusID">The status of the user - linked to the PersonStatus Lookup</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument SaveUser(int UserID, string UserName, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID) {
			return SaveUser(UserID, UserName, "", FirstName, Surname, EMail, TelNo, CellNo, PersonStatusID);
		}
		public XmlDocument SaveUser(int UserID, string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				saveUserDB(UserID, UserName, Password, FirstName, Surname, EMail, TelNo, CellNo, PersonStatusID);
			else
				saveUser(UserID, UserName, Password, FirstName, Surname, EMail, TelNo, CellNo, PersonStatusID);
			return this as XmlDocument;
		}

		public XmlDocument saveUserDB(int UserID, string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_UPDATE)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Password, "@Password", 50);
						AddSQLParameter(FirstName, "@FirstName", 50);
						AddSQLParameter(Surname, "@Surname", 50);
						AddSQLParameter(EMail, "@Email", 50);
						AddSQLParameter(TelNo, "@TelNo", 35);
						AddSQLParameter(CellNo, "@CellNo", 20);
						AddSQLParameter(PersonStatusID, "@PersonStatusID");
						using (Reader()) {
							if (Read()) {
								addgotUser();
							} else {
								Error(ERROR_BASE, ERROR_SAVE, "Could not save the data for the User record.");
								_AddAttribute("UserID", UserID.ToString());
								_AddElement("UserName", UserName);
							}
						}
						// Original code...
						//IDataParameter parResult = AddSQLParameter("@Result", 50, true);
						//Execute();
						//if (parResult.Value != DBNull.Value) {
						//    Error(2074, parResult.Value.ToString());
						//}
						//_AddAttribute("UserID", UserID.ToString());
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_SAVE_EXC, "There was an error updating the User details", exc);
					_AddAttribute("UserID", UserID.ToString());
				}
			return this as XmlDocument;
			}
		}

		public XmlDocument saveUser(int UserID, string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_UPDATE)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Password, "@Password", 50);
						AddSQLParameter(FirstName, "@FirstName", 50);
						AddSQLParameter(Surname, "@Surname", 50);
						AddSQLParameter(EMail, "@Email", 50);
						AddSQLParameter(TelNo, "@TelNo", 35);
						AddSQLParameter(CellNo, "@CellNo", 20);
						AddSQLParameter(PersonStatusID, "@PersonStatusID");
						using (Reader()) {
							if (Read()) {
								addgotUser();
							} else {
								Error(ERROR_BASE, ERROR_SAVE, "Could not save the data for the User record.");
								_AddAttribute("UserID", UserID.ToString());
								_AddElement("UserName", UserName);
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_SAVE_EXC, "There was an error updating the User details", exc);
					_AddAttribute("UserID", UserID.ToString());
				}
				return this as XmlDocument;
			}
		}
	


		/// <summary>
		/// Used to register a user on the Gatekeeper system. This method will only be called once for a user, when
		/// they register to use the system. The system will assign a User ID to the user, which will be returned,
		/// but which the user should not know - it is for public referencing only. All updates associated with
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
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument RegisterUser(string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				registerUserDB(UserName, Password, FirstName, Surname, EMail, TelNo, CellNo, true);
			else
				registerUser(UserName, Password, FirstName, Surname, EMail, TelNo, CellNo);
			return this as XmlDocument;
		}
		public XmlDocument RegisterUser(string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, bool CellCheck) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				registerUserDB(UserName, Password, FirstName, Surname, EMail, TelNo, CellNo, CellCheck);
			else
				registerUser(UserName, Password, FirstName, Surname, EMail, TelNo, CellNo);
			return this as XmlDocument;
		}
		private XmlDocument registerUserDB(string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo, bool CellCheck) {
			using (Connect()) {
				try {
					using (Command(PROC_INSERT)) {
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Password, "@Password", 50);
						AddSQLParameter(FirstName, "@FirstName", 50);
						AddSQLParameter(Surname, "@Surname", 50);
						AddSQLParameter(EMail, "@Email", 50);
						AddSQLParameter(TelNo, "@TelNo", 35);
						AddSQLParameter(CellNo, "@CellNo", 20);
						if (!CellCheck) {
							AddSQLParameter(0, "@CheckCell");
						}
						IDataParameter parUserid = AddSQLParameter(0, "@UserID", true);
						Execute();
						if (parUserid.Value.ToString() == "0") {
							Error(ERROR_BASE, ERROR_SAVE_DUPL, "Registration failed - a duplicate user already exists on the system.");
						} else {
							// This is removed for the Loeries project...
							//using (Reader()) {
							//    if (Read()) {
							//        addgotUser();
							//    }
							//}
							_AddAttribute("UserID", parUserid.Value.ToString());	// get UserID from output parameter
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_SAVE_EXC, "There was an error updating the User details", exc);
				}
				return this as XmlDocument;
			}
		}
		private XmlDocument registerUser(string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo) {
			using (Connect()) {
				try {
					using (Command(PROC_INSERT)) {
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Password, "@Password", 50);
						AddSQLParameter(FirstName, "@FirstName", 50);
						AddSQLParameter(Surname, "@Surname", 50);
						AddSQLParameter(EMail, "@Email", 50);
						AddSQLParameter(TelNo, "@TelNo", 35);
						AddSQLParameter(CellNo, "@CellNo", 20);
						using (Reader()) {
							if (Read()) {
								addgotUser();
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_SAVE_EXC, "There was an error updating the User details", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <overloads>Retrieves a user's details</overloads>
		/// <summary>User idenitified by Gatekeeper identifier.</summary>
		/// <param name="UserID">The user's identifier.</param>
		public XmlDocument GetUsers() {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					using (Command(PROC_GETALL)) {
						using (Reader()) {
							XmlElement user, users;
							XmlAttribute xaUserID, xaPersonStatusID;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = this.CreateElement("User") as XmlElement;
								xaUserID = this.CreateAttribute("UserID");
								xaUserID.InnerText = GetValue("PersonID");
								xaPersonStatusID = this.CreateAttribute("PersonStatusID");
								xaPersonStatusID.InnerText = GetValue("PersonStatusID");
								
								user.InnerXml = "<UserName/><FirstName/><Surname/><EMail/><TelNo/><CellNo/><Status/>";
								user.SelectSingleNode("UserName").InnerText = GetValue("UserName");
								user.SelectSingleNode("FirstName").InnerText = GetValue("FirstName");
								user.SelectSingleNode("Surname").InnerText = GetValue("Surname");
								user.SelectSingleNode("EMail").InnerText = GetValue("Email");
								user.SelectSingleNode("TelNo").InnerText = GetValue("TelNo");
								user.SelectSingleNode("CellNo").InnerText = GetValue("CellPhone");
								user.SelectSingleNode("Status").InnerText = GetValue("PersonStatusDesc");
								
								user.Attributes.Append(xaUserID);
								user.Attributes.Append(xaPersonStatusID);
								users.AppendChild(user);
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <overloads>Retrieves a user's details</overloads>
		/// <summary>User idenitified by Gatekeeper identifier.</summary>
		/// <param name="UserID">The user's identifier.</param>
		public XmlDocument GetUser(int UserID) {
			return getUser(UserID, false);
		}
		/// <summary>User idenitified by Gatekeeper identifier.</summary>
		/// <param name="UserID">The user's identifier.</param>
		/// <param name="WantPassword">Flag to indicate if password is wanted in the result xml</param>
		public XmlDocument GetUser(int UserID, bool WantPassword) {
			return getUser(UserID, WantPassword);
		}
		/// <summary>User idenitified by username.</summary>
		/// <param name="UserName">The user's login name</param>
		public XmlDocument GetUser(string UserName) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return getUser(0, UserName, "", "");
			else
				return getUserByUsername(UserName);
		}
		/// <summary>User idenitified by last issued token.</summary>
		/// <param name="UserToken">The user's last token</param>
		public XmlDocument GetUser(Guid UserToken) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return getUser(0, "", UserToken.ToString(), "");
			else
				return getUserByToken(UserToken.ToString());
		}
		/// <summary>User idenitified by last issued token.</summary>
		/// <param name="UserToken">The user's last token</param>
		public XmlDocument GetUserByToken(string UserToken) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return getUser(0, "", UserToken, "");
			else
				return getUserByToken(UserToken);
		}
		/// <summary>User idenitified by cellphone number.</summary>
		/// <param name="UserCellNo">The user's cellphone number</param>
		public XmlDocument GetUserByCell(string UserCellNo) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return getUser(0, "", "", UserCellNo);
			else
				return getUserByCellno(UserCellNo);
		}
		/// <summary>User idenitified by email address.</summary>
		/// <param name="UserEmail">The user's email address</param>
		public XmlDocument GetUserByEmail(string UserEmail) {
			return getUserByEmail(UserEmail, true);
		}
		/// <summary>User idenitified by email address.</summary>
		/// <param name="UserEmail">The user's email address</param>
		/// <param name="WantPassword">Flag to indicate if password is required</param>
		public XmlDocument GetUserByEmail(string UserEmail, bool WantPassword) {
			return getUserByEmail(UserEmail, WantPassword);
		}
		private XmlDocument getUser(int UserID, string UserName, string UserToken, string UserCellNo) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 128);
						AddSQLParameter(UserToken, "@UserToken", 50);
						AddSQLParameter(UserCellNo, "@UserCellPhone", 20);
						using (Reader()) {
							if (Read()) {
								addgotUser();
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddAttribute("UserID", UserID.ToString());
								_AddElement("UserName", UserName);
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}
		private XmlDocument getUserByUsername(string UserName) {
			using (Connect()) {
				try {
					using (Command(PROC_GET_UNAME)) {
						AddSQLParameter(UserName, "@UserName", 128);
						using (Reader()) {
							if (Read()) {
								addgotUser();
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddElement("UserName", UserName);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}
		private XmlDocument getUserByToken(string UserToken) {
			using (Connect()) {
				try {
					using (Command(PROC_GET_TOKEN)) {
						AddSQLParameter(UserToken, "@UserToken", 50);
						using (Reader()) {
							if (Read()) {
								addgotUser();
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddElement("UserToken", UserToken);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}
		private XmlDocument getUserByCellno(string UserCellNo) {
			using (Connect()) {
				try {
					using (Command(PROC_GET_CELLNO)) {
						AddSQLParameter(UserCellNo, "@UserCellPhone", 20);
						using (Reader()) {
							if (Read()) {
								addgotUser();
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddElement("UserCellNo", UserCellNo);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}
		private XmlDocument getUser(int UserID, bool WantPassword) {
			using (Connect()) {
				try {
					using (Command(PROC_GETID)) {
						AddSQLParameter(UserID, "@UserID");
						using (Reader()) {
							if (Read()) {
								addgotUser(WantPassword);
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddAttribute("UserID", UserID.ToString());
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}
		/// <summary>
		/// 
		/// </summary>
		/// <param name="UserEmail">The user's email address</param>
		/// <param name="WantPassword">Flag to indicate if password is required in the result xml</param>
		/// <returns></returns>
		private XmlDocument getUserByEmail(string UserEmail, bool WantPassword) {
			using (Connect()) {
				try {
					using (Command(PROC_GET_EMAIL)) {
						AddSQLParameter(UserEmail, "@UserEmail", 50);
						using (Reader()) {
							if (Read()) {
								addgotUser(WantPassword);
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddAttribute("UserEmail", UserEmail);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}
		private void addgotUser() {
			addgotUser(false);
		}
		private void addgotUser(bool WantPassword) {
			AddAttribute("Token", "Token");
			AddAttribute("UserID", "PersonID");
			AddElement("UserName", "UserName");
			AddElement("FirstName", "FirstName");
			AddElement("Surname", "Surname");
			AddElement("FullName", "PersonName");
			AddElement("EMail", "Email");
			AddElement("TelNo", "TelNo");
			AddElement("CellPhone", "CellPhone");
			AddElement("Status", "Description", "PersonStatusDesc");
			AddAttribute("Status", "PersonStatusID", "PersonStatusID", DbType.Int32);
			//AddElement("Contact", "Preference", "ContactPreferenceDesc");
			//AddAttribute("Contact", "ContactPreferenceID", "ContactPreferenceID", DbType.Int32);
			AddElement("Safeguard", "AccLockedDate", DbType.Boolean);
			if (WantPassword)
				AddElement("Password", "Password");
		}
		// Deprecated in favour of isUser...
		//private bool checkUser(int UserID, string UserName, string UserToken, string UserCellNo) {
		//    using (Connect()) {
		//        try {
		//            using (Command(PROC_GET)) {
		//                AddSQLParameter(UserID, "@UserID");
		//                AddSQLParameter(UserName, "@UserName", 128);
		//                AddSQLParameter(UserToken, "@UserToken", 50);
		//                AddSQLParameter(UserCellNo, "@UserCellPhone", 20);
		//                using (Reader()) {
		//                    if (Read()) {
		//                        return true;
		//                    }
		//                }
		//            }
		//        } catch { }
		//    }
		//    return false;
		//}


		/// <summary>Check for the existence of a user with a given username</summary>
		/// <param name="UserName">The user's login name</param>
		public bool IsUser(string UserName) {
			if (DataXManager.ProviderType == DataProviderType.SqlServer)
				return isUser(0, UserName, "", "");
			else
				return isUser(UserName);
		}
		private bool isUser(int UserID, string UserName, string UserToken, string UserCellNo) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(UserToken, "@UserToken", 50);
						AddSQLParameter(UserCellNo, "@UserCellPhone", 20);
						using (Reader()) {
							if (Read()) {
								userID = GetValue("PersonID");
								return true;
							} else {
								return false;
							}
						}
					}
				} catch {
					return false;
				}
			}
		}
		private bool isUser(string UserName) {
			using (Connect()) {
				try {
					using (Command(PROC_GET_UNAME)) {
						AddSQLParameter(UserName, "@UserName", 50);
						using (Reader()) {
							if (Read()) {
								userID = GetValue("PersonID");
								return true;
							} else {
								return false;
							}
						}
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>
		/// Remove a user from the Gatekeeper database. All records associated with the user will also be removed
		/// ie. all service and product links, group links and activity logged.
		/// </summary>
		/// <param name="UserID">The public User ID, used to uniquely identify a user.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		public bool RemoveUser(int UserID) {
			return RemoveUser(UserID, "");
		}
		/// <summary>
		/// Remove a user from the Gatekeeper database. All records associated with the user will also be removed
		/// ie. all service and product links, group links and activity logged.
		/// </summary>
		/// <param name="UserName">The user's Login/User name</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		public bool RemoveUser(string UserName) {
			return RemoveUser(0, UserName);
		}
		private bool RemoveUser(int UserID, string UserName) {
			using (Connect()) {
				try {
					using (Command(PROC_DELETE)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>
		/// Mark a user as on-hold on the database.
		/// </summary>
		/// <param name="UserID">The public User ID, used to uniquely identify a user.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		public bool HoldUser(int UserID) {
			return updateUserStatus(UserID, "", "On-hold");
		}
		/// <summary>
		/// Overloaded function - mark a user as on-hold on the database, using the Login Name to identify the user.
		/// </summary>
		/// <param name="UserName">The user's Login Name.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		public bool HoldUser(string UserName) {
			return updateUserStatus(0, UserName, "On-hold");
		}
		/// <summary>
		/// Mark a user as inactive on the database.
		/// </summary>
		/// <param name="UserID">The public User ID, used to uniquely identify a user.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		public bool DeleteUser(int UserID) {
			return updateUserStatus(UserID, "", "Inactive");	// was Deleted
		}
		/// <summary>
		/// Overloaded function - mark a user as inactive on the database, using the Login Name to identify the user.
		/// </summary>
		/// <param name="UserName">The user's Login Name.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		public bool DeleteUser(string UserName) {
			return updateUserStatus(0, UserName, "Inactive");	// was Deleted
		}
		/// <summary>
		/// Restore a user who was previously delete to active status.
		/// </summary>
		/// <param name="UserID">The public User ID of the user. Function can also be called using the Login Name / User Name.</param>
		/// <returns>
		/// A boolean value, indicating whether the user was successfully restored.
		/// </returns>
		public bool UndeleteUser(int UserID) {
			return updateUserStatus(UserID, "", "Active");
		}
		/// <summary>
		/// Overloaded function - restore a user who was previously deleted, using the Login Name / User Name.
		/// </summary>
		/// <param name="UserName">The user's Login/User name</param>
		/// <returns>
		/// A boolean value indicating whether the user was successfully restored.
		/// </returns>
		public bool UndeleteUser(string UserName) {
			return updateUserStatus(0, UserName, "Active");
		}
		/// <summary>
		/// Lock a user from all transactional systems - this will prevent the user from accessing any such systems
		/// until such time as the user is unlocked. This will not prevent the user from logging into the system,
		/// but will limit most functionality to View Only.
		/// </summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <returns>A boolean value indicating whether the Lock was successful or not.</returns>
		public bool LockUser(int UserID) {
			return updateUserStatus(UserID, "", "Locked");
		}
		/// <summary>
		/// Overloaded method - Lock a user from all transactional systems using the Login/User Name. This will prevent the user from accessing any such systems
		/// until such time as the user is unlocked. This will not prevent the user from logging into the system,
		/// but will limit most functionality to View Only.
		/// </summary>
		/// <param name="UserName">The user's Login/User Name</param>
		/// <returns>A boolean value indicating whether the Lock was successful or not.</returns>
		public bool LockUser(string UserName) {
			return updateUserStatus(0, UserName, "Locked");
		}
		/// <summary>
		/// Block access for a user to a specific service only
		/// </summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <param name="ServiceName">The name of the service to be blocked.</param>
		/// <returns>
		/// A boolean value indicating whether the Lock was successful or not.
		/// </returns>
		public bool LockUser(int UserID, string ServiceName) {
			return updateUserStatus(UserID, "", "Locked");
		}
		/// <summary>
		/// Block access for a user to a specific service only
		/// </summary>
		/// <param name="UserName">The user's Login/User Name</param>
		/// <param name="ServiceName">The name of the service to be blocked.</param>
		/// <returns>
		/// A boolean value indicating whether the Lock was successful or not.
		/// </returns>
		public bool LockUser(string UserName, string ServiceName) {
			return updateUserStatus(0, UserName, "Locked");
		}
		/// <summary>
		/// Unlock a user from accessing transactional systems managed by the Gatekeeper.
		/// </summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <returns>A boolean value indicating whether the update was successful.</returns>
		public bool UnlockUser(int UserID) {
			return updateUserStatus(UserID, "", "Active");
		}
		/// <summary>
		/// Overloaded method - Unlock a user from accessing transactional systems managed by the Gatekeeper, using the User/Login Name.
		/// </summary>
		/// <param name="UserName">The user's User/Login name, used to access systems managed by the Gatekeeper system.</param>
		/// <returns>A boolean value indicating whether the update was successful.</returns>
		public bool UnlockUser(string UserName) {
			return updateUserStatus(0, UserName, "Active");
		}
		/// <summary>
		/// Update a user's status.
		/// </summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <param name="Status">The description of the new status.</param>
		/// <returns>A boolean value indicating whether the update was successful.</returns>
		public bool UpdateUserStatus(int UserID, string Status) {
			return updateUserStatus(UserID, "", Status);
		}
		private bool updateUserStatus(int UserID, string UserName, string Status) {
			using (Connect()) {
				try {
					using (Command(PROC_STATUS)) {
						AddSQLParameter(UserID, "@PersonID");
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Status, "@Status", 50);
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <overloads>Gets a user's password</overloads>
		/// <summary>Gets a user's password.</summary>
		public XmlDocument GetHint(string UserName) {
			return getHint(UserName);
		}
		private XmlDocument getHint(string UserName) {
			using (Connect()) {
				try {
					using (Command(PROC_HINT)) {
						AddSQLParameter(UserName, "@UserName", 128);
						using (Reader()) {
							if (Read()) {
								AddAttribute("UserID", "PersonID");
								AddElement("UserName", "UserName");
								AddElement("Fullname", "PersonName");
								AddElement("Password", "Password");
								AddElement("QuestionID", "QuestionID");
								AddElement("Answer", "Answer");
								AddElement("EMail", "EMail");
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddAttribute("UserName", UserName);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <overloads>Gets a user's password</overloads>
		/// <summary>Gets a user's password.</summary>
		public XmlDocument GetPassword(int UserID) {
			return getPassword(UserID, "");
		}
		public XmlDocument GetPassword(string UserName) {
			return getPassword(0, UserName);
		}
		private XmlDocument getPassword(int UserID, string UserName) {
			using (Connect()) {
				try {
					using (Command(PROC_PASSWORD_GET)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						using (Reader()) {
							if (Read()) {
								AddElement("UserName", "UserName");
								AddElement("Password", "Password");
								AddElement("FirstName", "FirstName");
								AddElement("Fullname", "PersonName");
								AddElement("EMail", "EMail");
								AddElement("CellPhone", "CellPhone");
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
								_AddAttribute("UserID", UserID.ToString());
								_AddElement("UserName", UserName);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <overloads>Update a user's password</overloads>
		/// <summary>Without validating the against the saved password.</summary>
		public XmlDocument UpdatePassword(int UserID, string Password) {
			return updatePassword(UserID, "", Password);
		}
		public XmlDocument UpdatePassword(string UserName, string Password) {
			return updatePassword(0, UserName, Password);
		}
		public XmlDocument updatePassword(int UserID, string UserName, string Password) {
			using (Connect()) {
				try {
					using (Command(PROC_PASSWORD_UPDATE)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(Password, "@Password", 50);
						Execute();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_SAVE_EXC, "There was an error updating the User details", exc);
				}
			}
			return this as XmlDocument;
		}
		/// <summary>Validate the old password, against the saved password for verification purposes.</summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <param name="OldPassword">The user's current password.</param>
		/// <param name="Password">The new password for the user.</param>
		/// <returns>An XmlDocument object</returns>
		public XmlDocument UpdatePassword(int UserID, string OldPassword, string Password) {
			return updatePassword(UserID, "", OldPassword, Password);
		}
		/// <summary>Validate the old password, against the saved password for verification purposes.</summary>
		/// <param name="UserName">The user's Login/User name.</param>
		/// <param name="OldPassword">The user's current password.</param>
		/// <param name="Password">The new password for the user.</param>
		/// <returns>An XmlDocument object</returns>
		public XmlDocument UpdatePassword(string UserName, string OldPassword, string Password) {
			return updatePassword(0, UserName, OldPassword, Password);
		}
		private XmlDocument updatePassword(int UserID, string UserName, string OldPassword, string Password) {
			string UserToken = "", UserCellNo = "";
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						AddSQLParameter(UserToken, "@UserToken", 50);
						AddSQLParameter(UserCellNo, "@UserCellPhone", 20);
						using (Reader(CommandBehavior.SingleRow)) {
							if (Read()) {
								string oldpass = GetValue("Password");
								if (oldpass == OldPassword) {
									using (Command(PROC_PASSWORD_UPDATE)) {
										AddSQLParameter(UserID, "@UserID");
										AddSQLParameter(UserName, "@UserName", 50);
										AddSQLParameter(Password, "@Password", 50);
										try {
											int rows = Execute();
										} catch (Exception exc) {
											Error(ERROR_BASE, ERROR_SAVE_EXC, "There was an error updating the User details", exc);
										}
									}
								} else {
									Error(ERROR_BASE, ERROR_PASSWORD, "There was an error updating User password - old password does not match");
								}
							} else {
								Error(ERROR_BASE, ERROR_PASSWORD, "There was an error updating User password - Could not read user record");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_SAVE_EXC, "There was an error updating the User details", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <overloads>Sends the user's pin/password to their cellphone.</overloads>
		/// <summary>Implements an external system (SMS Gateway), and is dependant on that service to run correctly.</summary>
		/// <param name="Token">The Token of the Service/Application calling the method, which has already logged on, and has a valid session. The SMS Gateway will validate this token when the SMS is sent.</param>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <returns>A boolean value indicating whether the SMS was sent successfully.</returns>
		public bool SendPassword(string Token, int UserID) {
			try {
				x_message thismsg = new x_message(DSN);
				return thismsg.SendPassword(UserID, "");
			} catch {
				return false;
			}
		}
		/// <summary>Implements an external system (SMS Gateway), and is dependant on that service to run correctly.</summary>
		/// <param name="Token">The Token of the Service/Application calling the method, which has already logged on, and has a valid session. The SMS Gateway will validate this token when the SMS is sent.</param>
		/// <param name="UserName">The Login/User Name of the user to send the SMS to.</param>
		/// <returns>A boolean value indicating whether the SMS was sent successfully.</returns>
		public bool SendPassword(string Token, string UserName) {
			try {
				x_message thismsg = new x_message(DSN);
				return thismsg.SendPassword(0, UserName);
			} catch {
				return false;
			}
		}


		/// <summary>Sends a message to the user. This method implements an external system (SMS Gateway), and is dependant on that service to run correctly.</summary>
		/// <param name="UserID">The public User ID of the user (or 0).</param>
		/// <param name="UserName">The public User Name of the user (or "").</param>
		/// <param name="Message">The message to be sent to the user.</param>
		/// <returns>A boolean value indicating whether the SMS was sent successfully.</returns>
		public XmlDocument SendMessage(int UserID, string UserName, string Message) {
			using (Connect()) {
				try {
					using (Command(PROC_PERSON)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						using (Reader()) {
							if (Read()) {
								AddAttribute("UserID", "PersonID");
								AddElement("CellNo", "CellPhone");
								x_message thismsg = new x_message(DSN);
								if (!thismsg.SendSMS(GetValue("CellPhone"), Message))
									throw new Exception("Could not send message.");
							} else {
								throw new Exception("Could not get the User's details.");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
					_AddAttribute("UserID", UserID.ToString());
					_AddElement("UserName", UserName);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>Force the expiry of a user's password, which will force them to renew their password at next logon.</summary>
		/// <param name="UserID">The public ID of the User on the Gatekeeper database.</param>
		public void ExpireUserPassword(int UserID) {
			using (Connect()) {
				try {
					using (Command(PROC_EXPIRE)) {
						AddSQLParameter(UserID, "@UserID");
						Execute();
					}
				} catch {}
			}
		}


		/// <summary>Add/update an answer for a user to a question, for password reminders.</summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database</param>
		/// <param name="QuestionID">The public ID of the Question in the Gatekeeper database</param>
		/// <param name="Answer">The text answer that the user entered in response to the question</param>
		/// <returns>
		/// Returns a boolean value indicating whether save was succesful or not.
		/// </returns>
		public bool SaveUserQuestion(int UserID, int QuestionID, string Answer) {
			using (Connect()) {
				try {
					using (Command(PROC_ANSWER)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(QuestionID, "@QuestionID");
						AddSQLParameter(Answer, "@Answer", 100);
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>
		/// Validates a user's answer to a question against a value in the Gatekeeper database. If the answer matches
		/// the answer stored in the database for the User and Question, the method will return True;
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <param name="QuestionID">The public ID of the Question in the Gatekeeper database.</param>
		/// <param name="Answer">The text answer supplied by the user, which will be validated against the answer in the database.</param>
		/// <returns>
		/// Returns a boolean value indicating whether the user's answer to a question is that same as a value stored
		/// in the database. If the user has not previously answered this question, and there is no saved value in the
		/// database, the result will also return false.
		/// </returns>
		public bool ValidateUserQuestion(int UserID, int QuestionID, string Answer) {
			using (Connect()) {
				try {
					bool bResult;
					using (Command(PROC_QUESTION)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(QuestionID, "@QuestionID");
						AddSQLParameter(Answer, "@Answer", 100);
						IDataParameter parResult = AddSQLParameter("@Result", 50, true);
						Execute();
						if (parResult.Value != DBNull.Value) {
							if (parResult.Value.ToString() == "OK") {
								bResult = true;
							} else {
								bResult = false;
							}
						} else {
							bResult = false;
						}
						return bResult;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>Link a user to a selected service.</summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <param name="ServiceID">The public Service ID of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The public ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		public bool SaveUserService(int UserID, int ServiceID, int SecurityLevelID, string ServiceIdentifier) {
			try {
				return insertUserService(UserID, "", ServiceID, "", SecurityLevelID, ServiceIdentifier);
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Link a user to a selected service.
		/// </summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The public ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		public bool SaveUserService(int UserID, string ServiceName, int SecurityLevelID, string ServiceIdentifier) {
			try {
				return insertUserService(UserID, "", 0, ServiceName, SecurityLevelID, ServiceIdentifier);
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Link a user to a selected service.
		/// </summary>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceID">The public Service ID of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The public ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		public bool SaveUserService(string UserName, int ServiceID, int SecurityLevelID, string ServiceIdentifier) {
			try {
				return insertUserService(0, UserName, ServiceID, "", SecurityLevelID, ServiceIdentifier);
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Link a user to a selected service.
		/// </summary>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <param name="SecurityLevelID">The public ID of the Security Level to which the user has been associated for the selected service.</param>
		/// <param name="ServiceIdentifier">The unique ID of the user used by the service to identify the user on the service database</param>
		/// <returns>A boolean value indicating whether the link was made successfully.</returns>
		public bool SaveUserService(string UserName, string ServiceName, int SecurityLevelID, string ServiceIdentifier) {
			try {
				return insertUserService(0, UserName, 0, ServiceName, SecurityLevelID, ServiceIdentifier);
			} catch {
				return false;
			}
		}
		private bool insertUserService(int UserID, string UserName, int ServiceID, string ServiceName, int SecurityLevelID, string ServiceIdentifier) {
			using (Connect()) {
				using (Command(PROC_SERVICE_ADD)) {
					AddSQLParameter(UserID, "@UserID");
					AddSQLParameter(UserName, "@UserName", 50);
					AddSQLParameter(ServiceID, "@ServiceID");
					AddSQLParameter(ServiceName, "@ServiceName", 100);
					AddSQLParameter(SecurityLevelID, "@SecurityLevelID");
					AddSQLParameter(ServiceIdentifier, "@ServiceIdentifier", 50);
					Execute();
				}
			}
			return true;
		}


		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <param name="ServiceID">The public Service ID of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		public bool DeleteUserService(int UserID, int ServiceID) {
			try {
				return deleteUserService(UserID, "", ServiceID, "");
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="UserID">The public User ID of the user.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		public bool DeleteUserService(int UserID, string ServiceName) {
			try {
				return deleteUserService(UserID, "", 0, ServiceName);
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceID">The public Service ID of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		public bool DeleteUserService(string UserName, int ServiceID) {
			try {
				return deleteUserService(0, UserName, ServiceID, "");
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Remove the link between a user and specific service.
		/// </summary>
		/// <param name="UserName">The user's Login/User Name.</param>
		/// <param name="ServiceName">The name of the service to which the user is to be linked.</param>
		/// <returns>A boolean value indicating whether the link was removed successfully.</returns>
		public bool DeleteUserService(string UserName, string ServiceName) {
			try {
				return deleteUserService(0, UserName, 0, ServiceName);
			} catch {
				return false;
			}
		}
		private bool deleteUserService(int UserID, string UserName, int ServiceID, string ServiceName) {
			using (Connect()) {
				using (Command(PROC_SERVICE_DEL)) {
					AddSQLParameter(UserID, "@UserID");
					AddSQLParameter(UserName, "@UserName", 50);
					AddSQLParameter(ServiceID, "@ServiceID");
					AddSQLParameter(ServiceName, "@ServiceName", 100);
					Execute();
				}
			}
			return true;
		}


		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="UserID">The public ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The public ID of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The public ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		public bool SaveUserProduct(int UserID, int ProductID, int SecurityLevelID) {
			try {
				return insertUserProduct(UserID, "", ProductID, "", SecurityLevelID);
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="UserID">The public ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The public ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		public bool SaveUserProduct(int UserID, string ProductName, int SecurityLevelID) {
			try {
				return insertUserProduct(UserID, "", 0, ProductName, SecurityLevelID);
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The public ID of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The public ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		public bool SaveUserProduct(string UserName, int ProductID, int SecurityLevelID) {
			try {
				return insertUserProduct(0, UserName, ProductID, "", SecurityLevelID);
			} catch {
				return false;
			}
		}
		/// <summary>
		/// Method used to link a user to a Product, and assign a security level to the user. If a user is already
		/// linked to a Product, the system will update the SecurityLevel associated with that product only.
		/// </summary>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <param name="SecurityLevelID">The public ID of the SecurityLevel record in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the save was successful.</returns>
		public bool SaveUserProduct(string UserName, string ProductName, int SecurityLevelID) {
			try {
				return insertUserProduct(0, UserName, 0, ProductName, SecurityLevelID);
			} catch {
				return false;
			}
		}
		private bool insertUserProduct(int UserID, string UserName, int ProductID, string ProductName, int SecurityLevelID) {
			using (Connect()) {
				using (Command(PROC_PRODUCT_ADD)) {
					AddSQLParameter(UserID, "@UserID");
					AddSQLParameter(UserName, "@UserName", 50);
					AddSQLParameter(ProductID, "@ProductID");
					AddSQLParameter(ProductName, "@ProductName", 100);
					AddSQLParameter(SecurityLevelID, "@SecurityLevelID");
					Execute();
				}
			}
			return true;
		}


		/// <overloads>Remove the link between a user and a Product.</overloads>
		/// <summary></summary>
		/// <param name="UserID">The public ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The public ID of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		public bool DeleteUserProduct(int UserID, int ProductID) {
			try {
				return deleteUserProduct(UserID, "", ProductID, "");
			} catch {
				return false;
			}
		}
		/// <summary></summary>
		/// <param name="UserID">The public ID of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		public bool DeleteUserProduct(int UserID, string ProductName) {
			try {
				return deleteUserProduct(UserID, "", 0, ProductName);
			} catch {
				return false;
			}
		}
		/// <summary></summary>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductID">The public ID of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		public bool DeleteUserProduct(string UserName, int ProductID) {
			try {
				return deleteUserProduct(0, UserName, ProductID, "");
			} catch {
				return false;
			}
		}
		/// <summary></summary>
		/// <param name="UserName">The unique Login Name of the user in the Gatekeeper database.</param>
		/// <param name="ProductName">The unique description of the Product in the Gatekeeper database.</param>
		/// <returns>Returns a boolean value, indicating the whether the delete was successful.</returns>
		public bool DeleteUserProduct(string UserName, string ProductName) {
			try {
				return deleteUserProduct(0, UserName, 0, ProductName);
			} catch {
				return false;
			}
		}
		private bool deleteUserProduct(int UserID, string UserName, int ProductID, string ProductName) {
			using (Connect()) {
				using (Command(PROC_PRODUCT_DEL)) {
					AddSQLParameter(UserID, "@UserID");
					AddSQLParameter(UserName, "@UserName", 50);
					AddSQLParameter(ProductID, "@ProductID");
					AddSQLParameter(ProductName, "@ProductName", 100);
					Execute();
				}
			}
			return true;
		}


		/// <summary>
		/// Used to add a User to a Group in the Gatekeeper database. The system will check that the user is not
		/// already a member of the Group before adding the record. This will not cause the method to fail.
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <param name="GroupID">The public ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value, indicating whether the save was successful.
		/// </returns>
		public bool SaveUserGroup(int UserID, int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_GROUP_ADD)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(GroupID, "@GroupID");
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>Remove a user from a Group in the Gatekeeper database.</summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <param name="GroupID">The public ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns boolean value, indicating whether the delete was successful.
		/// </returns>
		public bool DeleteUserGroup(int UserID, int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_GROUP_DEL)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(GroupID, "@GroupID");
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>Bulk importing of users.</summary>
		/// <param name="UsersXML">A string, in XML format, containing information on users</param>
		/// <returns>Returns an XmlDocument object, indicating whether the import was successful or not, per user</returns>
		public XmlDocument ImportUsers(string UsersXML) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			XmlDocument toImport = new XmlDocument();
			try {
				toImport.LoadXml(UsersXML);
			} catch (Exception exc) {
				Error(ERROR_BASE, ERROR_IMPORT, "User import failed", exc);
				return this as XmlDocument;
			}
			
			try {
				if (toImport.FirstChild.Name != "Users") {
					Error(ERROR_BASE, ERROR_IMPORT, "The XML provided for the import is not in the correct format.");
				} else {
					foreach (XmlNode nUser in toImport.SelectSingleNode("/Users").SelectNodes("User")) {
						XmlDocument regUser;
						XmlNode xnUser, xnUserName, xnResult, xnResultCode, xnDescription;
						XmlAttribute xaUserID;
						string userName = "", password = "", firstName = "", surname = "", email = "", telNo = "", cellNo = "";
						if (nUser.SelectSingleNode("UserName") != null)
							userName = nUser.SelectSingleNode("UserName").InnerText;
						if (nUser.SelectSingleNode("Password") != null)
							password = nUser.SelectSingleNode("Password").InnerText;
						if (nUser.SelectSingleNode("FirstName") != null)
							firstName = nUser.SelectSingleNode("FirstName").InnerText;
						if (nUser.SelectSingleNode("Surname") != null)
							surname = nUser.SelectSingleNode("Surname").InnerText;
						if (nUser.SelectSingleNode("Email") != null)
							email = nUser.SelectSingleNode("Email").InnerText;
						if (nUser.SelectSingleNode("TelNo") != null)
							telNo = nUser.SelectSingleNode("TelNo").InnerText;
						if (nUser.SelectSingleNode("CellNo") != null)
							cellNo = nUser.SelectSingleNode("CellNo").InnerText;
							
						// NB: Need to do this faster! try:
						//	- use a XmlReader stream to get the nodes (not a document?)
						//	- call a RegUser function that returns the UserID
						//	- Use UserID to assign user to group(s) - add to web customer group automatically
						//	- dont add a whole element as below (only exceptions/failures?)
							
						regUser = RegisterUser(userName, password, firstName, surname, email, telNo, cellNo);
						
						xnUser = this.CreateElement("User");
						xnResult = this.CreateElement("Result");
						xnResultCode = this.CreateElement("ResultCode");
						xnDescription = this.CreateElement("Description");
						xnResult.AppendChild(xnResultCode);
						xnResult.AppendChild(xnDescription);
						if (regUser.SelectSingleNode("/User/Result/ResultCode").InnerText == "0") {
							xaUserID = this.CreateAttribute("UserID");
							xaUserID.InnerText = regUser.SelectSingleNode("/User/@UserID").InnerText;
							xnUser.Attributes.Append(xaUserID);
							xnResultCode.InnerText = "0";
						}
						else {
							Error(ERROR_BASE, regUser.SelectSingleNode("/User/Result/Description").InnerText);
						}
						xnUserName = this.CreateElement("UserName");
						xnUserName.InnerText = nUser.SelectSingleNode("UserName").InnerText;
						xnUser.AppendChild(xnUserName);
						xnUser.AppendChild(xnResult);
						this.SelectSingleNode("/Users").AppendChild(xnUser);
					}
				}
			} catch (Exception exc) {
				Error(ERROR_BASE, ERROR_IMPORT, "User import failed", exc);
			}
			return this as XmlDocument;
		}
		
		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument GetUserList(int GroupID) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						AddSQLParameter(GroupID, "@GroupID");
						using (Reader()) {
							XmlElement user, users;
							XmlAttribute xaUserID, xaPersonStatusID;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = this.CreateElement("User") as XmlElement;
								xaUserID = this.CreateAttribute("UserID");
								xaUserID.InnerText = GetValue("PersonID");
								xaPersonStatusID = this.CreateAttribute("PersonStatusID");
								xaPersonStatusID.InnerText = GetValue("PersonStatusID");
								
								user.InnerXml = "<UserName/><FirstName/><Surname/><EMail/><TelNo/><CellNo/><Status/>";
								user.SelectSingleNode("UserName").InnerText = GetValue("UserName");
								user.SelectSingleNode("FirstName").InnerText = GetValue("FirstName");
								user.SelectSingleNode("Surname").InnerText = GetValue("Surname");
								user.SelectSingleNode("EMail").InnerText = GetValue("Email");
								user.SelectSingleNode("TelNo").InnerText = GetValue("TelNo");
								user.SelectSingleNode("CellNo").InnerText = GetValue("CellPhone");
								user.SelectSingleNode("Status").InnerText = GetValue("PersonStatusDesc");
								
								user.Attributes.Append(xaUserID);
								user.Attributes.Append(xaPersonStatusID);
								users.AppendChild(user);
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves user by an exact match on a username or cell number.
		/// </summary>
		/// <param name="SearchName">The username of the user.</param>
		/// <param name="SearchNo">The cellphone number of the user.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument FindUser(string SearchName, string SearchNo) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					int Exact = 1, GroupID = 0;
					using (Command(PROC_FIND)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(SearchName, "@SearchName", 20);
						AddSQLParameter(SearchNo, "@SearchNo", 20);
						AddSQLParameter(Exact, "@Exact");
						using (Reader()) {
							XmlElement user, users;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = users.AppendChild(this.CreateElement("User")) as XmlElement;
								AddAttribute(user, "UserID", "PersonID");
								AddAttribute(user, "UserName", "UserName");
								AddAttribute(user, "FirstName", "FirstName");
								AddAttribute(user, "Surname", "Surname");
								AddAttribute(user, "EMail", "Email");
								AddAttribute(user, "TelNo", "TelNo");
								AddAttribute(user, "CellNo", "CellPhone");
								AddAttribute(user, "Status", "Status");
								AddAttribute(user, "StatusID", "StatusID");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves a users from a group (or all).
		/// Like SearchUserList, but returns an item list
		/// </summary>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="SearchName">The name to search on.</param>
		/// <param name="SearchNo">The number to search on.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument FindUsers(int GroupID, string SearchName, string SearchNo) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					int Exact = 0;
					using (Command(PROC_FIND)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(SearchName, "@SearchName", 20);
						AddSQLParameter(SearchNo, "@SearchNo", 20);
						AddSQLParameter(Exact, "@Exact");
						using (Reader()) {
							XmlElement user, users;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = users.AppendChild(this.CreateElement("item")) as XmlElement;
								AddAttribute(user, "UserID", "PersonID");
								AddAttribute(user, "UserName", "UserName");
								AddAttribute(user, "FirstName", "FirstName");
								AddAttribute(user, "Surname", "Surname");
								AddAttribute(user, "EMail", "Email");
								AddAttribute(user, "TelNo", "TelNo");
								AddAttribute(user, "CellNo", "CellPhone");
								AddAttribute(user, "Status", "Status");
								AddAttribute(user, "StatusID", "PersonStatusID");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves a users from a group (or all).
		/// Like SearchUserList, but returns an item list
		/// </summary>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="SearchUserID"></param>
		/// <param name="SearchUserName"></param>
		/// <param name="SearchFirstName"></param>
		/// <param name="SearchSurname"></param>
		/// <param name="SearchCellNo"></param>
		/// <param name="SearchTelNo"></param>
		/// <param name="SearchEmail"></param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument FindUsers(int GroupID, string SearchUserID, string SearchUserName, string SearchFirstName, string SearchSurname, string SearchCellNo, string SearchTelNo, string SearchEmail) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					using (Command(PROC_FIND_ADV)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(SearchUserID, "@SearchUserID", 20);
						AddSQLParameter(SearchUserName, "@SearchUserName", 20);
						AddSQLParameter(SearchFirstName, "@SearchFirstName", 20);
						AddSQLParameter(SearchSurname, "@SearchSurname", 20);
						AddSQLParameter(SearchCellNo, "@SearchCellNo", 20);
						AddSQLParameter(SearchTelNo, "@SearchTelNo", 20);
						AddSQLParameter(SearchEmail, "@SearchEmail", 20);
						using (Reader()) {
							XmlElement user, users;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = users.AppendChild(this.CreateElement("item")) as XmlElement;
								AddAttribute(user, "UserID", "PersonID");
								AddAttribute(user, "UserName", "UserName");
								AddAttribute(user, "FirstName", "FirstName");
								AddAttribute(user, "Surname", "Surname");
								AddAttribute(user, "EMail", "Email");
								AddAttribute(user, "TelNo", "TelNo");
								AddAttribute(user, "CellNo", "CellPhone");
								AddAttribute(user, "Status", "Status");
								AddAttribute(user, "StatusID", "PersonStatusID");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="SearchName">The name to search on.</param>
		/// <param name="SearchNo">The number to search on.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument SearchUserList(int GroupID, string SearchName, string SearchNo) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					int Exact = 0;
					using (Command(PROC_SEARCH)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(SearchName, "@SearchName", 20);
						AddSQLParameter(SearchNo, "@SearchNo", 20);
						AddSQLParameter(Exact, "@Exact");
						using (Reader()) {
							XmlElement user, users;
							XmlAttribute xaUserID, xaPersonStatusID;
							
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = this.CreateElement("User");
								xaUserID = this.CreateAttribute("UserID");
								xaUserID.InnerText = GetValue("PersonID");
								xaPersonStatusID = this.CreateAttribute("PersonStatusID");
								xaPersonStatusID.InnerText = GetValue("PersonStatusID");
								
								user.InnerXml = "<UserName/><FirstName/><Surname/><EMail/><TelNo/><CellNo/><Status/>";
								user.SelectSingleNode("UserName").InnerText = GetValue("UserName");
								user.SelectSingleNode("FirstName").InnerText = GetValue("FirstName");
								user.SelectSingleNode("Surname").InnerText = GetValue("Surname");
								user.SelectSingleNode("EMail").InnerText = GetValue("Email");
								user.SelectSingleNode("TelNo").InnerText = GetValue("TelNo");
								user.SelectSingleNode("CellNo").InnerText = GetValue("CellPhone");
								user.SelectSingleNode("Status").InnerText = GetValue("PersonStatusDesc");
								
								user.Attributes.Append(xaUserID);
								user.Attributes.Append(xaPersonStatusID);
								users.AppendChild(user);
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="SearchUserID"></param>
		/// <param name="SearchUserName"></param>
		/// <param name="SearchFirstName"></param>
		/// <param name="SearchSurname"></param>
		/// <param name="SearchCellNo"></param>
		/// <param name="SearchTelNo"></param>
		/// <param name="SearchEmail"></param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument SearchUserList(int GroupID, string SearchUserID, string SearchUserName, string SearchFirstName, string SearchSurname, string SearchCellNo, string SearchTelNo, string SearchEmail) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					using (Command(PROC_SEARCH_ADV)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(SearchUserID, "@SearchUserID", 20);
						AddSQLParameter(SearchUserName, "@SearchUserName", 20);
						AddSQLParameter(SearchFirstName, "@SearchFirstName", 20);
						AddSQLParameter(SearchSurname, "@SearchSurname", 20);
						AddSQLParameter(SearchCellNo, "@SearchCellNo", 20);
						AddSQLParameter(SearchTelNo, "@SearchTelNo", 20);
						AddSQLParameter(SearchEmail, "@SearchEmail", 20);
						using (Reader()) {
							XmlElement user, users;
							XmlAttribute xaUserID, xaPersonStatusID;
							
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = this.CreateElement("User");
								xaUserID = this.CreateAttribute("UserID");
								xaUserID.InnerText = GetValue("PersonID");
								xaPersonStatusID = this.CreateAttribute("PersonStatusID");
								xaPersonStatusID.InnerText = GetValue("PersonStatusID");
								
								user.InnerXml = "<UserName/><FirstName/><Surname/><EMail/><TelNo/><CellNo/><Status/>";
								user.SelectSingleNode("UserName").InnerText = GetValue("UserName");
								user.SelectSingleNode("FirstName").InnerText = GetValue("FirstName");
								user.SelectSingleNode("Surname").InnerText = GetValue("Surname");
								user.SelectSingleNode("EMail").InnerText = GetValue("Email");
								user.SelectSingleNode("TelNo").InnerText = GetValue("TelNo");
								user.SelectSingleNode("CellNo").InnerText = GetValue("CellPhone");
								user.SelectSingleNode("Status").InnerText = GetValue("PersonStatusDesc");
								
								user.Attributes.Append(xaUserID);
								user.Attributes.Append(xaPersonStatusID);
								users.AppendChild(user);
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves users by an exact match on a user by username or cell number.
		/// </summary>
		/// <param name="SearchName">The username of the user.</param>
		/// <param name="SearchNo">The cellphone number of the user.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument SearchUserList(string SearchName, string SearchNo) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					int Exact = 1, GroupID = 0;
					using (Command(PROC_SEARCH)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(SearchName, "@SearchName", 20);
						AddSQLParameter(SearchNo, "@SearchNo", 20);
						AddSQLParameter(Exact, "@Exact");
						using (Reader()) {
							XmlElement user, users;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = users.AppendChild(this.CreateElement("User")) as XmlElement;
								AddAttribute(user, "Username", "UserName");
								AddAttribute(user, "UserID", "PersonID");
								AddAttribute(user, "Status", "PersonStatusDesc");
								AddAttribute(user, "StatusID", "PersonStatusID");
								AddAttribute(user, "CellNo", "CellPhone");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves a specific user's details for display or editing on a user interface.
		/// </summary>
		/// <param name="UserID">The public User ID, which is used to uniquely identify a user.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument GetUserRights(int UserID) {
			string UserName = "";
			using (Connect()) {
				try {
					using (Command(PROC_PERSON)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						using (Reader()) {
							XmlNode user;
							XmlAttribute xaUserID, xaPersonStatusID;
							
							if(Read()) {
								user = this.SelectSingleNode("User");
								xaUserID = this.CreateAttribute("UserID");
								xaUserID.InnerText = GetValue("PersonID");
								xaPersonStatusID = this.CreateAttribute("PersonStatusID");
								xaPersonStatusID.InnerText = GetValue("PersonStatusID");
								
								user.InnerXml = "<Result><ResultCode>0</ResultCode><Description/></Result><UserName/><FirstName/><Surname/><EMail/><TelNo/><CellNo/><Status/><Safeguard/>";
								
								user.SelectSingleNode("UserName").InnerText = GetValue("UserName");
								user.SelectSingleNode("FirstName").InnerText = GetValue("FirstName");
								user.SelectSingleNode("Surname").InnerText = GetValue("Surname");
								user.SelectSingleNode("EMail").InnerText = GetValue("Email");
								user.SelectSingleNode("TelNo").InnerText = GetValue("TelNo");
								user.SelectSingleNode("CellNo").InnerText = GetValue("CellPhone");
								user.SelectSingleNode("Status").InnerText = GetValue("PersonStatusDesc");
								user.SelectSingleNode("Safeguard").InnerText = GetValue("AccLockedDate", DbType.Boolean);
								
								user.Attributes.Append(xaUserID);
								user.Attributes.Append(xaPersonStatusID);
							} else {
								Error(ERROR_BASE, ERROR_GET, "Could not retrieve the data for the User record.");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <overloads>Retrieves a specific user's details for display or editing on a user interface.</overloads>
		/// <summary></summary>
		/// <param name="UserID">The public User ID, which is used to uniquely identify a user.</param>
		/// <returns>Returns an XmlDocument object</returns>
		public XmlDocument GetUserGroups(int UserID) {
			return GetUserGroups(UserID, false);
		}
		/// <summary></summary>
		/// <param name="UserID">The public User ID, which is used to uniquely identify a user.</param>
		/// <param name="wantItems"></param>
		public XmlDocument GetUserGroups(int UserID, bool wantItems) {
			using (Connect()) {
				try {
					using (Command(PROC_PROFILES)) {
						AddSQLParameter(UserID, "@UserID");
						using (Reader()) {
							XmlNode user, groupDesc, groupStatus;
							XmlElement group, groups;
							XmlAttribute xaUserID, xaGroupID, xaGroupStatusID;
							
							user = this.SelectSingleNode("/User");
							xaUserID = this.CreateAttribute("UserID");
							xaUserID.InnerText = UserID.ToString();
							user.Attributes.Append(xaUserID);
							
							groups = this.CreateElement("Groups");
							user.AppendChild(groups);
							while (Read()) {
								if (wantItems) {
									group = this.CreateElement("item");
									AddAttribute(group, "GroupID", "GroupID");
									AddAttribute(group, "GroupStatusID", "GroupStatusID");
									AddAttribute(group, "Description", "GroupDesc");
									AddAttribute(group, "Status", "GroupStatus");
									groups.AppendChild(group);
								} else {
									group = this.CreateElement("Group");
									xaGroupID = this.CreateAttribute("GroupID");
									xaGroupID.InnerText = GetValue("GroupID");
									xaGroupStatusID = this.CreateAttribute("GroupStatusID");
									xaGroupStatusID.InnerText = GetValue("GroupStatusID");
									
									groupDesc = this.CreateElement("Description");
									groupDesc.InnerText = GetValue("GroupDesc");
									groupStatus = this.CreateElement("Status");
									groupStatus.InnerText = GetValue("GroupStatus");
									
									group.Attributes.Append(xaGroupID);
									group.Attributes.Append(xaGroupStatusID);
									group.AppendChild(groupDesc);
									group.AppendChild(groupStatus);
									groups.AppendChild(group);
								}
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="StartRow">The row number of the first row.</param>
		/// <param name="NumberRows">The number of rows to return.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument GetUsers(int GroupID, int StartRow, int NumberRows) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					using (Command(PROC_PERSONS)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(StartRow, "@StartRow");
						AddSQLParameter(NumberRows, "@NumberRows");
						using (Reader()) {
							XmlElement user, users;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = this.CreateElement("item");
								AddAttribute(user, "UserID", "PersonID");
								AddAttribute(user, "UserName", "UserName");
								AddAttribute(user, "FirstName", "FirstName");
								AddAttribute(user, "Surname", "Surname");
								AddAttribute(user, "EMail", "Email");
								AddAttribute(user, "TelNo", "TelNo");
								AddAttribute(user, "CellNo", "CellPhone");
								AddAttribute(user, "Status", "Status");
								AddAttribute(user, "GroupID", "GroupID");
								AddAttribute(user, "Group", "GroupName");
								users.AppendChild(user);
							}
							Next();	// get total - in next result set
							Read();
							AddAttribute(users, "TotalRows", "TotalRows");
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="StartRow">The row number of the first row.</param>
		/// <param name="NumberRows">The number of rows to return.</param>
		/// <param name="SortCol">The column to sort on.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:
		/// </returns>
		public XmlDocument GetUsers(int GroupID, int StartRow, int NumberRows, string SortCol) {
			Tag = "Users";	// set the result xml to have a "Users" root element
			using (Connect()) {
				try {
					using (Command(PROC_PERSONSS)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(SortCol, "@ColumnName", 30);
						AddSQLParameter(StartRow, "@StartRow");
						AddSQLParameter(NumberRows, "@NumberRows");
						using (Reader()) {
							XmlElement user, users;
							users = this.SelectSingleNode("/Users") as XmlElement;
							while (Read()) {
								user = this.CreateElement("item");
								AddAttribute(user, "UserID", "PersonID");
								AddAttribute(user, "UserName", "UserName");
								AddAttribute(user, "FirstName", "FirstName");
								AddAttribute(user, "Surname", "Surname");
								AddAttribute(user, "EMail", "Email");
								AddAttribute(user, "TelNo", "TelNo");
								AddAttribute(user, "CellNo", "CellPhone");
								AddAttribute(user, "Status", "Status");
								AddAttribute(user, "GroupID", "GroupID");
								AddAttribute(user, "Group", "GroupName");
								users.AppendChild(user);
							}
							Next(); // get total - in next result set
							Read();
							AddAttribute(users, "TotalRows", "TotalRows");
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET_EXC, "There was an error retrieving the User details", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>Validates (and extends) a user session</summary>
		/// <remarks>This replaces the old version and allows for validation of tokens that expire with login (ie RememberMe is on)</remarks>
		/// <param name="Token">A string containing the GUID supplied by the Gatekeeper when the user logged in.</param>
		/// <returns>true or false</returns>
		public bool ValidateToken(string Token) {
			return ValidateToken(Token, true);
		}

		public bool ValidateToken(string Token, bool expireToken) {
			bool retval = true;
			using (Connect()) {
				try {
					DateTime loginDate = DateTime.Now;
					DateTime tokenExpire = (expireToken) ? loginDate.AddMinutes(ExpireToken) : loginDate.AddDays(ExpirePassword);
					DateTime loginExpire = loginDate.AddDays(ExpirePassword);
					
					using (Command(PROC_VALID_TOKEN)) {
						AddSQLParameter(Token, "@Token", 65);
						AddSQLParameter(loginDate, "@LoginDate", DbType.DateTimeOffset);
						AddSQLParameter(tokenExpire, "@TokenDate", DbType.DateTimeOffset);
						AddSQLParameter(loginExpire, "@ExpireDate", DbType.DateTimeOffset);
						using (Reader()) {
							if (Read()) {
								// expect an "ok" result for MsSql else assume ok unless exception
								if (DataXManager.ProviderType == DataProviderType.SqlServer) {
									if (GetValue("Result") != "ok") {
										retval = false;
									}
								}
							} else {	// ie when an empty result set returned
								retval = false;
							}
						}
					}
				} catch (Exception e) {
					Logger.Debug(String.Concat("ValidateToken:exception:", e.Message, ":trace:", e.StackTrace));
					retval = false;
				}
			}
			return(retval);
		}

		public bool ValidateTokenOld(string Token) {
			bool retval = true;
			using (Connect()) {
				try {
					using (Command(PROC_VALID)) {
						AddSQLParameter(Token, "@Token", 65);
						AddSQLParameter(ExpireToken, "@ExpiryMinutes");
						using (Reader()) {
							if (Read()) {
								// expect an "ok" result for MsSql else assume ok unless exception
								if (DataXManager.ProviderType == DataProviderType.SqlServer) {
									if (GetValue("Result") != "ok") {
										retval = false;
									}
								}
							} else {	// ie when an empty result set returned
								retval = false;
							}
						}
					}
				} catch (Exception e) {
					Logger.Debug(String.Concat("ValidateToken:exception:", e.Message, ":trace:", e.StackTrace));
					retval = false;
				}
			}
			return (retval);
		}
		
		/// <summary>
		/// Used to add a profile to a User in the Gatekeeper database. 
		/// This is similar to SaveUserGroup, with the exception that all the rights of the group
		/// are added to the user at the same time.
		/// The system will check that the user is not already a member of the Group before adding the record. This will not cause the method to fail.
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <param name="GroupID">The public ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value, indicating whether the save was successful.
		/// </returns>
		public bool SaveUserProfile(int UserID, int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_PROFILE_ADD)) {	// from jtsp_insUserGroup
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(GroupID, "@GroupID");
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>
		/// Used to remove a Profile from a User in the Gatekeeper database.
		/// This is similar to DeleteUserGroup, with the exception that all the rights of the group
		/// are removed from the user at the same time.
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <param name="GroupID">The public ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns boolean value, indicating whether the delete was successful.
		/// </returns>
		public bool DeleteUserProfile(int UserID, int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_PROFILE_DEL)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(GroupID, "@GroupID");
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}

		/// <summary>
		/// Used to reset the account locking mechanism for a user.
		///		A date-lock is placed on an account if permissable login attempts are exceeded
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <returns>
		/// Returns boolean value, indicating whether the reset was successful.
		/// </returns>
		public bool ClearLock(string Token) {
			return ClearLock(0, Token);
		}
		public bool ClearLock(int UserID) {
			return ClearLock(UserID, "");
		}
		public bool ClearLock(int UserID, string Token) {
			using (Connect()) {
				try {
					using (Command(PROC_LOCK_DEL)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(Token, "@Token", 65);
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>
		/// Used to set the account locking mechanism for a user by a date-lock is placed on an account.
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <returns>
		/// Returns boolean value, indicating whether the set was successful.
		/// </returns>
		public bool SetLock(int UserID) {
			using (Connect()) {
				try {
					using (Command(PROC_LOCK_ADD)) {
						AddSQLParameter(UserID, "@UserID");
						Execute();
						return true;
					}
				} catch {
					return false;
				}
			}
		}


		/// <summary>
		/// Used to get a user's username
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <returns>
		/// Returns boolean value, indicating whether the set was successful.
		/// </returns>
		public string GetUsername(int UserID) {
			string Username = "";
			using (Connect()) {
				try {
					using (Command(PROC_NAME)) {
						AddSQLParameter(UserID, "@UserID");
						using (Reader()) {
							if (Read()) {
								Username = GetValue("UserName");
							}
						}
					}
				} catch { }
			}
			return Username;
		}

		/// <summary>
		/// Get the services for a user.
		/// Token must be a valid (administrator) token.
		/// </summary>
		/// <param name="UserID">The internal ID of a User for which the service list will be returned.</param>
		/// <param name="ServiceID">The service identifier</param>
		/// <returns>
		/// Returns an XML Document object, indicating the products and services the user has access to, and the relevant permissions on that service,
		/// </returns>
		public XmlDocument GetUserServiceList(int UserID, int ServiceID) {
			using (Connect()) {
				try {
					using (Command(PROC_SERVICES)) {
						AddSQLParameter(UserID, "@PersonID");
						AddSQLParameter(ServiceID, "@ServiceID");
						using (Reader()) {
							XmlElement service, services;
							services = _AddElement("Services");
							while (Read()) {
								service = _AddElement(services, "Service");
								AddAttribute(service, "ServiceID", "ServiceID");
								AddAttribute(service, "Description", "Description");
								AddAttribute(service, "Status", "Status");
								AddAttribute(service, "SecurityLevel", "SecurityLevel");
								AddAttribute(service, "DisplayMessage", "DisplayMessage");
								AddAttribute(service, "ServiceIdentifier", "ServiceIdentifier");
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALID_EXC, "There was an error validating the user", exc);
				}
			return this as XmlDocument;
			}
		}

		/// <summary>
		/// Updates the user's contact details and contact preference
		/// </summary>
		/// <param name="UserID">The public User ID number used to uniquely identify a user.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's personal cellphone number.</param>
		/// <param name="ContactPreferenceID">The user's contact preference identifier (registration defaults this to '1')</param>
		/// <returns></returns>
		public XmlDocument UpdateContact(int UserID, string EMail, string TelNo, string CellNo, int ContactPreferenceID) {
			using (Connect()) {
				try {
					using (Command(PROC_CONTACT)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(EMail, "@Email", 50);
						AddSQLParameter(TelNo, "@TelNo", 35);
						AddSQLParameter(CellNo, "@CellNo", 20);
						AddSQLParameter(ContactPreferenceID, "@ContactPreferenceID");
						using (Reader()) {
							if (Read()) {
								addgotUser();
							} else {
								Error(ERROR_BASE, ERROR_CONTACT, "Could not update the User contacts.");
								_AddAttribute("UserID", UserID.ToString());
							}
						}
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_CONTACT_EXC, "There was an error updating the User contacts.", exc);
					_AddAttribute("UserID", UserID.ToString());
				}
				return this as XmlDocument;
			}
		}

	
		#endregion
	}
}	
