using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Net.Mail;

using XXBoom.MachinaX.DataX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	4.0.3
	Build:		20140831
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Note re MachinaX.PassportX:
	------------------------------------
	The refactoring mentioned below is intended to result in a code base that can be migrated into the MachinaX 
	framework as follows:
	- Base classes migrated to the MachinaX.PassportX namespace.
	- Web Service classes migrated to the MachinaX.PassportServiceX namespace.
	- Web service classes can remain in an implementation class (eg NashuaMobile.Gatekeeper)
	Note: Once this is completed the Gatekeeper code will become dependant on PassportX base classes.
		  If this is not desired, a fork in the codebase will be created at that stage.
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

/*	-----------------------------------------------------------------------	
	Development Notes:
	==================
	20070524:	Modification for .Net 2.0
	20070527:	Starting point from NMGatekeeper.2.0.2.
	20071226:	Added support for multiple databases using DataX
	20140831:	Commented code to send SMS via SMSService.dll
	-----------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// The Message class implements messaging (via sms/email) to users.
	/// <p>Access to the User class is limited to the Gatekeeper Web Service only.</p>
	/// </summary>
	public class x_message : x_passport {
		#region Invisible properties
		private static bool PasswordBySMS = true;
		private static bool PasswordTest = false;
		
		private string imsUsername;
		private string imsPassword;
		private string imsRefNo;
		private string imsMsgType;
		private string imsGateway;
		private int	imsCostClass;
		private int	imsPriority;
		#endregion

		#region String constants
		private const string IMS_USERNAME	= "8880000194";
		private const string IMS_PASSWORD	= "as3232sms";
		private const string IMS_REFNO 		= "";
		private const string IMS_MSGTYPE	= "DEF";
		private const int IMS_COSTCLASS		= 1;
		private const int IMS_PRIORITY		= 1;
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_PASSWORD	=	"x_UserPassword";
		#endregion
		
		#region Visible properties
		private string property;
		/// <summary>Definiton of the property</summary>
		/// <value>Description of the value of the property</value>
		public string Property {
			get { return property; }
			set { property = value; }
		}
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Message class.
		/// </summary>
		public x_message(string DSN) : base(DSN) {
			initialise();
		}
		public x_message(string DSN, DataProviderType DBType) : base(DBType, DSN) {
			initialise();
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Function to send the user's password.
		/// </summary>
		public bool SendPassword(int UserID, string UserName) {
			if (PasswordBySMS)
				return(SendPasswordBySMS(UserID, UserName));
			else
				return(SendPasswordByEmail(UserID, UserName));
		}
		
		/// <summary>
		/// Function to send a SMS message to a cellphone number.
		/// </summary>
		public bool SendSMS(string CellPhone, string Message) {
			return sendMessage(true, CellPhone, Message);
		}
		
		/// <summary>
		/// Function to send an email message to an email address.
		/// </summary>
		public bool SendEmail(string Email, string Message) {
			return sendMessage(false, Email, Message);
		}
		#endregion
				
		#region Private methods
		private void initialise() {
			imsGateway = getConfig("MPGgatewayUrl", "");
			imsUsername = getConfig("IMS_USERNAME", IMS_USERNAME);
			imsPassword = getConfig("IMS_PASSWORD", IMS_PASSWORD);
			imsRefNo = getConfig("IMS_REFNO", IMS_REFNO);
			imsMsgType = getConfig("IMS_MSGTYPE", IMS_MSGTYPE);
			imsCostClass = getConfig("IMS_COSTCLASS", IMS_COSTCLASS);
			imsPriority = getConfig("IMS_PRIORITY", IMS_PRIORITY);
		}

		/// <overloads>Get a configuration setting, else return default</overloads>>
		/// <summary>
		/// A string configuration value
		/// </summary>
		private string getConfig(string name, string defvalue) {
			return (ConfigurationManager.AppSettings[name] != null)? ConfigurationManager.AppSettings[name] : defvalue;
		}
		private int getConfig(string name, int defvalue) {
			return (ConfigurationManager.AppSettings[name] != null)? Convert.ToInt32(ConfigurationManager.AppSettings[name]) : defvalue;
		}
		/// <summary>
		/// Function to send the user's password by SMS.
		/// </summary>
		private bool SendPasswordBySMS(int UserID, string UserName) {
			// Set the local variables to be used in the IMS soap call...
			string iq_RefNo = "";		// reference number for the message (use the username for now)
			string iq_PhoneNo = "0828554799";		// the destination cellphone
			string iq_Message = "";		// the sms message itself
			//string iq_Username = "8880000194";
			//string iq_Password = "as3232sms";
			//string iq_MsgType = "DEF";
			//int	iq_CostClass = 1;
			//int	iq_Priority	 = 1;

			bool bReturn = false;
			using (Connect()) {
				try {
					using (Command(PROC_PASSWORD)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						using (Reader()) {
							if (Read()) {
								iq_Message = GetValue("PersonName");
								iq_Message += ", your logon to Nashua Mobile is:: username: ";
								iq_Message += GetValue("UserName");
								iq_Message += "  password: ";
								iq_Message += GetValue("Password");
								iq_PhoneNo = (PasswordTest)? iq_PhoneNo : GetValue("CellPhone");
								if (iq_PhoneNo != "" && iq_Message != null) {
									try	{
										iq_RefNo = UserName;
										//SMSService.com.nashuamobile.gateway.ISMSservice oSMS = new SMSService.com.nashuamobile.gateway.ISMSservice();
										////ISMSservice oSMS = new ISMSservice();
										//oSMS.Url = ConfigurationManager.AppSettings["MPGgatewayUrl"];
										//oSMS.SendMessageNS(iq_Username, iq_Password, iq_RefNo, iq_PhoneNo, iq_MsgType, iq_Message, iq_CostClass, iq_Priority);
										bReturn = true;
									} catch  {}
								}
							}
						}
					}
				} catch {}
			}
			return bReturn;
		}
		
		/// <summary>
		/// Function to send the user's password by email.
		/// </summary>
		private bool SendPasswordByEmail(int UserID, string UserName) {
			string email_from = "webadmin@nashuamobile.com";
			string email_to = "alanben@clickclickBOOM.com";
			string email_subject = "Nashua Mobile Password";
			string email_body = "<html><body>";
			
			bool bReturn = false;
			using (Connect()) {
				try {
					using (Command(PROC_PASSWORD)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(UserName, "@UserName", 50);
						using (Reader()) {
							if (Read()) {
								email_body = GetValue("PersonName");
								email_body += ", here is your Nashua Mobile password: ";
								email_body += GetValue("Password");
								email_body += "</body></html>";
								email_to = (PasswordTest)? email_to : GetValue("EMail");
								if (email_to != "") {
									try	{
										SmtpClient smtp = new SmtpClient();
										smtp.Send(email_from, email_to, email_subject, email_body);			
										bReturn = true;
									} catch {}
								}
							}
						}
					}
				} catch {}
			}
			return bReturn;
		}
		
		/// <summary>
		/// Function to send message to a cellphone number.
		/// </summary>
		private bool sendMessage(bool isSMS, string Recipient, string Message) {
			if (isSMS)
				return(sendSMS(Recipient, Message));
			else
				return(sendEmail(Recipient, Message));
		}
		private bool sendSMS(string cell, string message) {
			bool ret = false;
			try	{
				if (cell == "" || message =="")
					throw new Exception("no destination or message");
				//SMSService.com.nashuamobile.gateway.ISMSservice oSMS = new SMSService.com.nashuamobile.gateway.ISMSservice();
				////ISMSservice oSMS = new ISMSservice();
				//oSMS.Url = imsGateway;
				//oSMS.SendMessageNS(imsUsername, imsPassword, imsRefNo, cell, imsMsgType, message, imsCostClass, imsPriority);
				//oSMS = null;
				ret = true;
			} catch {}
			return ret;
		}
		private bool sendEmail(string email, string message) {
			bool ret = false;
			return ret;
		}
		#endregion
				
	}
}
