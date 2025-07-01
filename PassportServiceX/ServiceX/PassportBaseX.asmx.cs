#define USE_X_RESULT

using System;
using System.Configuration;
using System.Collections;
using System.ComponentModel;
using System.Diagnostics;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Xml;

using XXBoom.MachinaX.PassportX;
using XXBoom.MachinaX.DataX;

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
	20070613:	Ammended the xml schema to allow for alternatives, ie:
				- older style "nm_service" or "Transaction_Result" schema
				- newer [name] or "Result" schema
	20070911:	Split the original PassportBaseX into this and PassportRootX
				- db methods/properties in PassportBaseX
				- xml and core methods/properties in PassportRootX
	20071220:	Made some WebMethods virtual to allow them to be overridden (ie hidden)
	20071226:	Added support for multiple databases using DataX
	20081015:	Added _Pattern property
	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX.PassportServiceX {
	/// <summary>
	/// This PassportService class is the base class for all web services that utilise the PassportX classes 
	/// </summary>
	[WebService(Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX")]
	public class PassportBaseX : PassportRootX {
		#region Invisible properties
		private XXBoom.MachinaX.x_config webconfig;
		#endregion
		
		#region Constants
		private const string CONFIG_ROOT = "PassportX";
		private const string SELECT_VALID_RESULT = "/Result";
		private const string SELECT_VALID_DESC = "/Result/Description";
		private const string SELECT_VALID_CODE = "/Result/ResultCode";
		private const string VALID_RESULT = "Result";
		private const string VALID_DESC = "Description";
		private const string VALID_CODE = "ResultCode";
		#endregion

		#region Visible properties
		private string dsn;
		/// <summary>PassportX database connection string</summary>
		/// <value>Standard MsSQL connection string</value>
		public string DSN {
			get { return dsn; }
			set { dsn = value; }
		}

		private DataProviderType dbType;
		/// <summary>DataX database provider type</summary>
		/// <value>DataProviderType enumeration value</value>
		public DataProviderType DBType {
			get { return dbType; }
			set { dbType = value; }
		}

		private x_activity activity;
		/// <summary>PassportX activity</summary>
		/// <value>A PassportX activity object</value>
		protected x_activity _Activity {	get { return activity; }	set { activity = value;}}
		
		private x_config config;
		/// <summary>PassportX config</summary>
		/// <value>A PassportX config object</value>
		protected x_config _Config {	get { return config; }	set { config = value;}}
		
		private x_group group;
		/// <summary>PassportX group</summary>
		/// <value>A PassportX group object</value>
		protected x_group _Group {	get { return group; }	set { group = value;}}
		
		private x_groupStatus groupStatus;
		/// <summary>PassportX groupStatus</summary>
		/// <value>A PassportX groupStatus object</value>
		protected x_groupStatus _GroupStatus {	get { return groupStatus; }	set { groupStatus = value;}}
		
		private x_message message;
		/// <summary>PassportX messages</summary>
		/// <value>A PassportX message object</value>
		protected x_message _Message {	get { return message; }	set { message = value;}}
		
		private x_product product;
		/// <summary>PassportX products</summary>
		/// <value>A PassportX product object</value>
		protected x_product _Product {	get { return product; }	set { product = value;}}
		
		private x_productStatus productStatus;
		/// <summary>PassportX productStatuss</summary>
		/// <value>A PassportX productStatus object</value>
		protected x_productStatus _ProductStatus {	get { return productStatus; }	set { productStatus = value;}}
		
		/* Deprecated object that has been marked for imminent removal... */
		private x_oldprofile profile;
		/// <summary>PassportX profile</summary>
		/// <value>A PassportX profile object</value>
		protected x_oldprofile _Profile {	get { return profile; }	set { profile = value;}}
		
		private x_questions questions;
		/// <summary>PassportX questions</summary>
		/// <value>A PassportX questions object</value>
		protected x_questions _Questions {	get { return questions; }	set { questions = value;}}
		
		private x_securityLevel securityLevel;
		/// <summary>PassportX securityLevels</summary>
		/// <value>A PassportX securityLevel object</value>
		protected x_securityLevel _SecurityLevel {	get { return securityLevel; }	set { securityLevel = value;}}
		
		private x_service service;
		/// <summary>PassportX services</summary>
		/// <value>A PassportX service object</value>
		protected x_service _Service {	get { return service; }	set { service = value;}}
		
		private x_serviceStatus serviceStatus;
		/// <summary>PassportX serviceStatuss</summary>
		/// <value>A PassportX serviceStatus object</value>
		protected x_serviceStatus _ServiceStatus {	get { return serviceStatus; }	set { serviceStatus = value;}}
		
		private x_user user;
		/// <summary>PassportX user</summary>
		/// <value>A PassportX user object</value>
		protected x_user _User {	get { return user; }	set { user = value;}}
		
		private x_userStatus userStatus;
		/// <summary>PassportX userStatus</summary>
		/// <value>A PassportX userStatus object</value>
		protected x_userStatus _UserStatus {	get { return userStatus; }	set { userStatus = value;}}

		private x_recruit recruit;
		/// <summary>PassportX user</summary>
		/// <value>A PassportX user object</value>
		protected x_recruit _Recruit { get { return recruit; } set { recruit = value; } }

		private x_member member;
		/// <summary>PassportX member</summary>
		/// <value>A PassportX member object</value>
		protected x_member _Member { get { return member; } set { member = value; } }

		private x_pattern pattern;
		/// <summary>PassportX member</summary>
		/// <value>A PassportX member object</value>
		protected x_pattern _Pattern { get { return pattern; } set { pattern = value; } }
		#endregion

		#region Constructors/Destructors
		/// <overloads>Constructors</overloads>
		/// <summary>Default Constructor for older style schemas</summary>
		public PassportBaseX() : base() {
			initialise();
		}
		/// <summary>Constructor for newer style schemas</summary>
		public PassportBaseX(string root) : base(root) {
			initialise();
		}
		#endregion

		#region Protected methods
		protected string LoginSMS() {
			XmlDocument login = _User.Login("sa", "password");
			string token = "";
			// test for success
			if (login.SelectSingleNode("/User/Result/ResultCode").InnerText == "0")
				token = login.SelectSingleNode("/User/@Token").InnerText;
			return token;
		}
		protected void LogoutSMS(string Token) {
			_User.Logout(Token);
		}
		protected bool LogEvent(int UserID, string Token, int ActivityID, int ServiceID) {
			// System.IFormatProvider format = System.Globalization.DateTimeFormatInfo.InvariantInfo;	// ie use invariant culture
			DateTime rightnow = DateTime.Now;
			string dt = rightnow.ToString();
			return(_Activity.LogActivity(UserID, Token, dt, ActivityID, ServiceID));
		}
		#endregion

		#region Public Web methods
		/// <summary>
		/// Method to test the database connection defined by the PassportXDSN.
		/// </summary>
		/// <returns>
		/// </returns>
		[WebMethod(Description = "Tests the connection to the PassportX database")] 
		public virtual XmlDocument TestConnection() {
			try {
				x_user usr = new x_user(DSN);
				XmlDocument doc = usr.Connection();
				return doc;
			} catch (Exception exc) {
#if (!USE_X_RESULT)
				XmlDocument testXml = new XmlDocument();
				AddFailure(testXml exc, 1);
				return testXml;
#else
				AddError(exc);
				return Result;
#endif
			}
		}
		/// <summary>
		/// Validate a user's login information, and returns an XML document containing a Token to the user which must be used 
		/// throughout the session to validate the user when accessing any system the Gatekeeper controls access to.
		/// </summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <returns>
		/// XmlDocument object, containing information on the resultxml of the login, and any related error messages.
		/// If the login is successful, the ResultCode will be 0 (zero), and the Token will contain the value that must
		/// be used for the session to validate the user for any functionality. If not, the ResultCode will contain
		/// a non-zero number indicating the error code and Description any related message.
		/// </returns>
		[WebMethod(Description = "Basic user login")] 
		public virtual XmlDocument Login(string UserName, string Password) {
			string log = String.Concat("Login, ", UserName, Password);
			_Logger.Info(log);
			try {
				x_user usr = new x_user(DSN, DBType);
				return usr.Login(UserName, Password);
			} catch (Exception exc) {
#if (!USE_X_RESULT)
				XmlDocument loginXml = new XmlDocument();
				AddFailure(loginXml, exc, 1);
				return loginXml;
#else
				AddError(exc);
				return Result;
#endif
			}
		}
		/// <summary>
		/// Internal method used to validate that a user calling a method has permissions to call that method.
		/// All methods will be validated against the service 'Gatekeeper', and the RequiredPermission will
		/// be the name of the method.
		/// </summary>
		/// <param name="Token">The Token of the user calling the method.</param>
		/// <param name="Service">The name of the service - for internal validations, this should be 'Gatekeeper'.</param>
		/// <param name="RequiredPermission">The permission to check for the user, eg. SaveUser.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating whether the user has permission to execute the method. If the
		/// user has permissions, the method will return 'null'. 
		/// </returns>
		// [WebMethod(Description = "Validates a token")] public
		public virtual XmlDocument ValidateToken(string Token, string RequiredPermission, string Service) {
			x_user usr = new x_user(DSN);
			try {
				XmlDocument validateToken = usr.Validate(Token, Service);
				if(validateToken == null) {
					validateToken = new XmlDocument();
					validateToken.AppendChild(validateToken.CreateElement(VALID_RESULT));
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_CODE));
					validateToken.SelectSingleNode(SELECT_VALID_CODE).InnerText = "1000";
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_DESC));
					validateToken.SelectSingleNode(SELECT_VALID_DESC).InnerText = "User is not authorised to use this functionality.";
					return validateToken;
				} else if(validateToken.SelectSingleNode("/User/Result/ResultCode").InnerText != "0") {
					string strResCode = validateToken.SelectSingleNode("/User/Result/ResultCode").InnerText;
					string strResDesc = validateToken.SelectSingleNode("/User/Result/Description").InnerText;
					validateToken = new XmlDocument();
					validateToken.AppendChild(validateToken.CreateElement(VALID_RESULT));
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_CODE));
					validateToken.SelectSingleNode(SELECT_VALID_CODE).InnerText = strResCode;
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_DESC));
					validateToken.SelectSingleNode(SELECT_VALID_DESC).InnerText = strResDesc;
					return validateToken;
				} else if (validateToken.SelectSingleNode("/User/Services/Service [./@Description = '" + Service + "']") == null) {
					validateToken = new XmlDocument();
					validateToken.AppendChild(validateToken.CreateElement(VALID_RESULT));
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_CODE));
					validateToken.SelectSingleNode(SELECT_VALID_CODE).InnerText = "1001";
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_DESC));
					validateToken.SelectSingleNode(SELECT_VALID_DESC).InnerText = "User is not authorised to use this functionality.";
					return validateToken;
				} else if (validateToken.SelectSingleNode("/User/Services/Service [@Description = '" + Service + "' and @SecurityLevel = '" + RequiredPermission + "']") == null) {
					validateToken = new XmlDocument();
					validateToken.AppendChild(validateToken.CreateElement(VALID_RESULT));
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_CODE));
					validateToken.SelectSingleNode(SELECT_VALID_CODE).InnerText = "1002";
					validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_DESC));
					validateToken.SelectSingleNode(SELECT_VALID_DESC).InnerText = "User is not authorised to use this functionality within the requested service.";
					return validateToken;
				}
				return null;
			} catch (Exception e) {
				XmlDocument validateToken = new XmlDocument();
				validateToken.AppendChild(validateToken.CreateElement(VALID_RESULT));
				validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_CODE));
				validateToken.SelectSingleNode(SELECT_VALID_CODE).InnerText = "1004";
				validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_DESC));
				validateToken.SelectSingleNode(SELECT_VALID_DESC).InnerText = string.Format("User is not authorised to use this functionality within the requested service. Error in authorisation routine - {0}", e.Message);
				return validateToken;
			}
		}
		/*
		protected XmlDocument _Validate(string Token, string Service) {
			x_user usr = new x_user(DSN);
			XmlDocument validateToken;
			try {
				validateToken = usr.Validate(Token, Service);
			} catch (Exception e) {
				validateToken = new XmlDocument();
				validateToken.AppendChild(validateToken.CreateElement(VALID_RESULT));
				validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_CODE));
				validateToken.SelectSingleNode(SELECT_VALID_CODE).InnerText = "1004";
				validateToken.SelectSingleNode(SELECT_VALID_RESULT).AppendChild(validateToken.CreateElement(VALID_DESC));
				validateToken.SelectSingleNode(SELECT_VALID_DESC).InnerText = string.Format("User is not authorised to use this functionality within the requested service. Error in authorisation routine - {0}", e.Message);
			}
			return validateToken;
		}
		*/
		/// <summary>
		/// Log the result to the log file
		/// </summary>
		/// <param name="Method">The label of the method</param>
		protected void _LogResult(string Method) {
			Log(String.Concat(Name, ":", Method));
		}
		#endregion

		#region Private methods
		private void initialise() {
			webconfig = new XXBoom.MachinaX.x_config();
			dsn = webconfig.Value(String.Concat(CONFIG_ROOT, "/", "DSN"));
			string type = webconfig.Value(String.Concat(CONFIG_ROOT, "/", "DBType"));
			dbType = DataProviderX.GetDataProviderType(type);
		}
		#endregion
	}
}
