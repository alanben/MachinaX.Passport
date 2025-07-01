using System;
using System.Configuration;
using System.Xml;
using System.Data;
using System.Data.SqlClient;

using XXBoom.MachinaX.DataX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20071226
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
	20070307:	Refactoring using the model in GKUser, ie: use of AddSQLParameter, GetSqlString, GetSqlYesNo etc
				Was: 218 lines, now 191 including notes and comments
				Class hierarchy as follows:
					 x_securityLevel _
								| _ GateKeeperBase _
												|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_securityLevel -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation of all SecurityLevel methods for the Nashua Mobile Gatekeeper Web Service.
	/// Access to the SecurityClass is only from within the Gatekeeper Web Service.
	/// </summary>
	public class x_securityLevel : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "SecurityLevel";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_ADD	=	"x_SecurityLevelAdd";
		private const string PROC_GET	=	"x_SecurityLevelGet";
		private const string PROC_LIST	=	"x_SecurityLevelList";
		private const string PROC_DEL	=	"x_SecurityLevelDelete";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the SecurityLevel class.
		/// </summary>
		public x_securityLevel(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_securityLevel(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Used to add/update a SecurityLevel record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="SecurityLevelID">The public ID of the Security Level record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Security Level. This must be unqiue in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save
		/// </returns>
		public XmlDocument SaveSecurityLevel(int SecurityLevelID, string Description) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter levelid = AddSQLParameter(SecurityLevelID, "@SecurityLevelID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 100);
						Execute();
						if (SecurityLevelID == 0) {
							SecurityLevelID = GetValue(levelid, 0);
						}
						_AddAttribute("SecurityLevelID", SecurityLevelID);
					}
				} catch (Exception exc) {
					Error(2044, "An error occured saving the Security Level record", exc);
					_AddAttribute("SecurityLevelID", SecurityLevelID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Returns details for a specific Security Level record.
		/// </summary>
		/// <param name="SecurityLevelID">The public ID of the Security Level record</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetSecurityLevel(int SecurityLevelID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(SecurityLevelID, "@SecurityLevelID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("SecurityLevelID", "SecurityLevelID");
								AddElement("Description", "Description");
							} else {
								Error(2018, "Could not retrieve the details for the selected record.");
								_AddAttribute("SecurityLevelID", SecurityLevelID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2018, "There was an error retrieving the Security Level record", exc);
					_AddAttribute("SecurityLevelID", SecurityLevelID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to retrieve a list of all Security Level records in the database.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetSecurityLevelList() {
			Tag = "SecurityLevels";
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement level, levels;
							levels = SelectSingleNode("/SecurityLevels") as XmlElement;
							while (Read()) {
								level = _AddElement(levels, "SecurityLevel");
								AddAttribute(level, "SecurityLevelID", "SecurityLevelID");
								AddElement(level, "Description", "Description");
							}
						}
					}
				} catch (Exception exc) {
					Error(2019, "There was an error retrieving the Security Level List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to remove a Security Level record from the Gatekeeper database. The system will check that the
		/// record is not in use any more before attempting to delete the record.
		/// </summary>
		/// <param name="SecurityLevelID">The public ID of the Security Level record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the delete
		/// </returns>
		public XmlDocument DeleteSecurityLevel(int SecurityLevelID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(SecurityLevelID, "@SecurityLevelID");
						IDataParameter result = AddSQLParameter("@Result", 100, true);
						Execute();
						if (Test(result)) {
							Error(2008, "There was an error deleting the Security Level record", GetValue(result));
						}
					}
				} catch (Exception exc) {
					Error(2008, "There was an error deleting the Security Level record", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion
	}
}
