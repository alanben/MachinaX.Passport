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
				Was: 218 lines, now 190 including notes and comments
				Class hierarchy as follows:
						x_groupStatus _
								| _ GateKeeperBase _
												|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_groupStatus -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Internal class exposing all methods related to GroupStatus.
	/// </summary>
	public class x_groupStatus : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "GroupStatus";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_ADD	=	"x_GroupStatusAdd";
		private const string PROC_GET	=	"x_GroupStatusGet";
		private const string PROC_LIST	=	"x_GroupStatusList";
		private const string PROC_DEL	=	"x_GroupStatusDelete";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor for the GroupStatus class
		/// </summary>
		public x_groupStatus(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_groupStatus(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Used to add/update a Group Status record in the Gatekeeper database.
		/// </summary>
		/// <param name="GroupStatusID">The public ID of the GroupStatus record in the Gatekeeper database. If the value does not exist in the database, a new record will be added, and the newly generated ID will be returned.</param>
		/// <param name="Description">The text description of the Group Status.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument SaveGroupStatus (int GroupStatusID, string Description) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter statusid = AddSQLParameter(GroupStatusID, "@GroupStatusID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 100);
						Execute();
						if (GroupStatusID == 0) {
							GroupStatusID = GetValue(statusid, 0);
						}
						_AddAttribute("GroupStatusID", GroupStatusID);
					}
				} catch (Exception exc) {
					Error(2033, "There was an error saving the Group Status record", exc);
					_AddAttribute("GroupStatusID", GroupStatusID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to retrieve details for a specific GroupStatus record in the Gatekeeper database, typically for
		/// editing purposes.
		/// </summary>
		/// <param name="GroupStatusID">The public ID of the Group Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the information of the GroupStatus record
		/// </returns>
		public XmlDocument GetGroupStatus(int GroupStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(GroupStatusID, "@GroupStatusID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("GroupStatusID", "GroupStatusID");
								AddElement("Description", "Description");
							} else {
								Error(2011, "Could not retrieve the details for the selected Group Status record.");
								_AddAttribute("GroupStatusID", GroupStatusID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2010, "There was an error retrieving the Group Status record", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Returns a list of all GroupStatus records in the Gatekeeper database, typically for selection on a
		/// user interface.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetGroupStatusList() {
			Tag = "GroupStatusList";	// set the result xml to have a "GroupStatusList" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement group, groups;
							groups = SelectSingleNode("/GroupStatusList") as XmlElement;
							while(Read()) {
								group = _AddElement(groups, "GroupStatus");
								AddAttribute(group, "GroupStatusID", "GroupStatusID");
								AddElement(group, "Description", "Description");
							}
						}
					}
				} catch (Exception exc) {
					Error(2012, "There was an error retrieving the list of Group Status records", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to permanently remove a GroupStatus record from the Gatekeeper database. The system will check that
		/// the record is no longer in use before attempting the delete.
		/// </summary>
		/// <param name="GroupStatusID">The public ID of the GroupStatus record to be deleted.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument RemoveGroupStatus (int GroupStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(GroupStatusID, "@GroupStatusID");
						IDataParameter result = AddSQLParameter("@Result", 100, true);
						Execute();
						if (Test(result)) {
							Error(2005, "There was an error deleting the Group Status record", GetValue(result));
						}
					}
				} catch (Exception exc) {
					Error(2005, "There was an error deleting the Group Status record", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion
	}
}
