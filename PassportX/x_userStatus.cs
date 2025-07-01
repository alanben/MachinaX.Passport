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
	20070305:	Refactoring using the model in GKUser, ie: use of AddSQLParameter, GetSqlString, GetSqlYesNo etc
				Was: 228 lines, now 190 including notes and comments
				Class hierarchy as follows:
						GKGroupStatus _
								| _ GateKeeperBase _
												|_ GateKeeperResult
	20070527:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_user -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	20081006:	Changed the default procedure names.
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation for all PersonStatus-related methods in the Gatekeeper Web Service.
	/// <p>Access to the PersonStatus class is limited to the Gatekeeper Web Service.</p>
	/// </summary>
	public class x_userStatus : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "PersonStatus";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_LIST	=	"x_UserStatusList";		// "jtsp_getPersonStatusList";
		private const string PROC_GET	=	"x_UserStatusGet";		// "jtsp_getPersonStatus";
		private const string PROC_ADD	=	"x_UserStatusAdd";		// "jtsp_insPersonStatus";
		private const string PROC_DEL	=	"x_UserStatusDelete";	// "jtsp_delPersonStatus";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the PersonStatus class.
		/// </summary>
		public x_userStatus(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_userStatus(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Used to add/update a PersonStatus record in the Gatekeeper database. All PersonStatus records must have unique
		/// descriptions.
		/// </summary>
		/// <param name="PersonStatusID">The public ID of the PersonStatus record. This is an identity/auto-number field in the database, and is assigned when a record is first saved. If the value is 0 (zero), the system will attempt to add a new record, as long as the description is unique.</param>
		/// <param name="Description">The text description of the PersonStatus record. All descriptions must be unique.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating whether the save was successful
		/// </returns>
		public XmlDocument SavePersonStatus(int PersonStatusID, string Description) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter statusid = AddSQLParameter(PersonStatusID, "@PersonStatusID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 50);
						Execute();
						if(PersonStatusID == 0) {
							PersonStatusID = Convert.ToInt16(GetValue(statusid));
						}
						_AddAttribute("PersonStatusID", PersonStatusID);
					}
				} catch (Exception exc) {
					Error(2034, "There was an error saving the Person Status record", exc);
					_AddAttribute("PersonStatusID", PersonStatusID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Return details for a specific Person Status in the Gatekeeper database.
		/// </summary>
		/// <param name="PersonStatusID">The public ID of the Person Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetPersonStatus(int PersonStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(PersonStatusID, "@PersonStatusID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("PersonStatusID", "PersonStatusID");
								AddElement("Description", "Description");
							} else {
								Error(2013, "Could not retrieve the details for the selected Person Status record.");
								_AddAttribute("PersonStatusID", PersonStatusID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2014, "There was an error retrieving the Person Status record", exc);
					_AddAttribute("PersonStatusID", PersonStatusID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Returns a list of all person status' in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetPersonStatusList() {
			Tag = "GroupStatusList";	// set the result xml to have a "GroupStatusList" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement person, persons;
							persons = SelectSingleNode("/PersonStatusList") as XmlElement;
							while (Read()) {
								person = _AddElement(persons, "PersonStatus");
								AddAttribute(person, "PersonStatusID", "PersonStatusID");
								AddElement(person, "Description", "Description");
							}
						}
					}
				} catch (Exception exc) {
					Error(2015, "There was an error retrieving the Person Status List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to remove a PersonStatus record from the Gatekeeper database. The system will first check whether the
		/// record is still in use before attempting to delete the record.
		/// </summary>
		/// <param name="PersonStatusID">The public ID of the PersonStatus record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating whether the delete was successful
		/// </returns>
		public XmlDocument DeletePersonStatus(int PersonStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(PersonStatusID, "@PersonStatusID");
						IDataParameter result = AddSQLParameter("@Result", 25, true);
						Execute();
						if (Test(result)) {
							Error(2006, "There was an error deleting the Person Status record", GetValue(result));
						}
					}
				} catch (Exception exc) {
					Error(2006, "There was an error deleting the Person Status record", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion
	}
}
