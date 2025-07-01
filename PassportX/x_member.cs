using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

using XXBoom.MachinaX.DataX;
//using Npgsql;
//using CoreLab.PostgreSql;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2008-06-23	
	Status:		redev	
	Version:	2.0.0
	Build:		20080623
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	-------------------------------------------------------------------------------------------------
	Note re MachinaX.PassportX:
	------------------------------------
	-------------------------------------------------------------------------------------------------	*/

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20080623:	Started.
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// The x_member class does the implementation of the data access layer required for members in the .Net MemberProvider model.
	/// This class is typically used by the PassportMembershipX web service class
	/// </summary>
	public class x_member : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Member";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_GETEMAIL = "x_MemberGetEmail";
		#endregion

		#region Constants - Error codes
		#endregion

		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the x_member class.
		/// </summary>
		/// <param name="DSN">Data provider connection string</param>
		public x_member(string DSN) : base(DSN, ROOT_NAME) {
		}
		/// <summary>
		/// Constructor that specifies data provider type
		/// </summary>
		/// <param name="DSN">Data provider connection string</param>
		/// <param name="DBType">Data provider type</param>
		public x_member(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>Member identified by email address.</summary>
		/// <param name="MemberEmail">The user's email address</param>
		public XmlDocument GetMemberByEmail(string MemberEmail) {
			return getMember(MemberEmail, true);
		}
		/// <summary>Member identified by email address.</summary>
		/// <param name="MemberEmail">The user's email address</param>
		/// <param name="WantPassword">Flag to indicate if password is required</param>
		public XmlDocument GetMemberByEmail(string MemberEmail, bool WantPassword) {
			return getMember(MemberEmail, WantPassword);
		}
		#endregion

		#region Private methods
		/// <summary>
		/// getMember
		/// </summary>
		/// <param name="MemberEmail">The user's email address</param>
		/// <param name="WantPassword">Flag to indicate if password is required in the result xml</param>
		/// <returns></returns>
		private XmlDocument getMember(string MemberEmail, bool WantPassword) {
			using (Connect()) {
				try {
					using (Command(PROC_GETEMAIL)) {
						AddSQLParameter(MemberEmail, "@MemberEmail", 50);
						using (Reader()) {
							if (Read()) {
								AddAttribute("Token", "Token");
								AddAttribute("MemberID", "PersonID");
								AddElement("MemberName", "MemberName");
								AddElement("FirstName", "FirstName");
								AddElement("Surname", "Surname");
								AddElement("FullName", "PersonName");
								AddElement("EMail", "Email");
								AddElement("TelNo", "TelNo");
								AddElement("CellPhone", "CellPhone");
								AddElement("Status", "Description", "PersonStatusDesc");
								AddAttribute("Status", "PersonStatusID", "PersonStatusID", DbType.Int32);
								AddElement("Safeguard", "AccLockedDate", DbType.Boolean);
								if (WantPassword)
									AddElement("Password", "Password");
							} else {
								Error(2062, "Could not retrieve the data for the Member record.");
								_AddAttribute("MemberEmail", MemberEmail);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(2062, "There was an error retrieving the Member details", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion
	}
}
