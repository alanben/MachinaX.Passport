using System;
using System.Xml;
using System.Data.SqlClient;
using System.Data;

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
				Was: 367 lines, now 266 including notes and comments
				Class hierarchy as follows:
					 x_activity _
							| _ GateKeeperBase _
											|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_activity -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Internal class exposing all methods related to Activity Logging in the Gatekeeper Web Service.
	/// </summary>
	public class x_activity : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Activity";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_ADD	=	"x_ActivityAdd";
		private const string PROC_DEL	=	"x_ActivityDelete";
		private const string PROC_GET	=	"x_ActivityGet";
		private const string PROC_LIST	=	"x_ActivityList";
		private const string PROC_LOG	=	"x_ActivityLog";
		private const string PROC_LOGS	=	"x_ActivityLogGet";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor for the Activity class.
		/// </summary>
		public x_activity(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_activity(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Add/update an Activity record in the Gatekeeper database.
		/// </summary>
		/// <param name="ActivityID">The public ID of the Activity record in the Gatekeeper database. If the value does not exist in the database, a new record will added, and the newly generated ID returned.</param>
		/// <param name="Description">The text description of the activity.</param>
		/// <returns>Returns an XmlDocument object, indicating the result of the save</returns>
		public XmlDocument SaveActivity(int ActivityID, string Description) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter actid = AddSQLParameter(ActivityID, "@ActivityID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 50);
						Execute();
						if (ActivityID == 0) {
							ActivityID = Convert.ToInt16(actid.Value.ToString());
						}
						_AddAttribute("ActivityID", ActivityID.ToString());
					}
				} catch (Exception exc) {
					Error(2026, "There was an error saving the Activity record", exc);
					_AddAttribute("ActivityID", ActivityID.ToString());
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Used to remove an Activity record from the Gatekeeper database. The system will check that the record
		/// is no longer in use before attempting the delete.
		/// </summary>
		/// <param name="ActivityID">The public ID of the Activity record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument RemoveActivity(int ActivityID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(ActivityID, "@ActivityID");
						IDataParameter parResult = AddSQLParameter("@Result", 100, true);
						using (Reader()) {
							if (parResult.Value != DBNull.Value && parResult.Value != null) {
								Error(2004, "There was an error removing the Activity record");
							}
						}
					}
				} catch (Exception exc) {
					Error(2004, "There was an error removing the Activity record", exc);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Used to retrieve details for a specific Activity record in the Gatekeeper database, typically for editing purposes.
		/// </summary>
		/// <param name="ActivityID">The public ID of the Activity record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object containing all the details of the Activity record
		/// </returns>
		public XmlDocument GetActivity(int ActivityID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(ActivityID, "@ActivityID");
						using (Reader()) {
							if(Read()) {
								AddAttribute("ActivityID", "ActivityID");
								AddElement("Description", "Description");
							} else {
								Error(2024, "Could not retrieve the details for the selected Activity record.");
								_AddAttribute("ActivityID", ActivityID.ToString());
							}
						}
					}
				} catch (Exception exc) {
					Error(2024, "There was an error retrieving the Activity record", exc);
					_AddAttribute("ActivityID", ActivityID.ToString());
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Retrieves a list of all Activity records in the Gatekeeper database, typically for selection purposes
		/// on a user interface.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetActivityList() {
			Tag = "ActivityList";	// set the result xml to have a "ActivityList" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement activity, activities;
							activities = this.SelectSingleNode("/ActivityList") as XmlElement;
							while(Read()) {
								activity = activities.AppendChild(this.CreateElement("Activity")) as XmlElement;
								AddAttribute(activity, "ActivityID", "ActivityID");
								AddElement(activity, "Description", "Description");
							}
						}
					}
				} catch (Exception exc) {
					Error(2025, "There was an error retrieving the Activity List", exc);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Log an activity in the Gatekeeper database.
		/// </summary>
		/// <param name="UserID">The public ID of a User for which the activity will be logged.</param>
		/// <param name="Token">The Token of the user against whom the activity is logged.</param>
		/// <param name="DateTime">The date and time of the activity.</param>
		/// <param name="ActivityID">The public ID of the Activity to which this record is linked.</param>
		/// <param name="ServiceID">The public ID of the Service that is logging the activity.</param>
		public bool LogActivity(int UserID, string Token, string DateTime, int ActivityID, int ServiceID) {
			using (Connect()) {
				try {
					using (Command(PROC_LOG)) {
						AddSQLParameter(ActivityID, "@ActivityID");
						AddSQLParameter(UserID, "@PersonID");
						AddSQLParameter(ServiceID, "@ServiceID");
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
		/// Method used to retrieve activity details. All parameters are optional, but at least the User ID or From Date must be specified.
		/// </summary>
		/// <param name="UserID">The public ID of the User in the Gatekeeper database.</param>
		/// <param name="FromDateTime">The date and time from which to extract the information.</param>
		/// <param name="ToDateTime">The date and time up to which to extract the information. If not specified, records up to the current date and time will be retrieved.</param>
		/// <param name="ProductName">Optional. The name of a Product in the Gatekeeper database, to limit results to only the specified product and its services.</param>
		/// <param name="ServiceName">Optional. The name of a Service in the Gatekeeper database, to limit results to only the specified service.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing all Activity records
		/// </returns>
		public XmlDocument GetActivityLog(int UserID, string FromDateTime, string ToDateTime, string ProductName, string ServiceName) {
			Tag = "ActivityLogs";	// set the result xml to have a "ActivityLogs" root element
			using (Connect()) {
				try {
					using (Command(PROC_LOGS)) {
						AddSQLParameter(UserID, "@UserID");
						AddSQLParameter(FromDateTime, "@FromDateTime", 25);
						AddSQLParameter(ToDateTime, "@ToDateTime", 25);
						AddSQLParameter(ProductName, "@ProductDesc", 50);
						AddSQLParameter(ServiceName, "@ServiceDesc", 50);
						using (Reader()) {
							XmlElement log, logs;
							logs = this.SelectSingleNode("/ActivityLogs") as XmlElement;
							while(Read()) {
								log = logs.AppendChild(this.CreateElement("ActivityLog")) as XmlElement;
								AddAttribute(log, "ActivityID", "ActivityID");
								XmlElement xnUser = _AddElement(log, "User");
								AddElement(xnUser, "FirstName", "FirstName");								
								AddElement(xnUser, "Surname", "Surname");								
								AddElement(xnUser, "Email", "Email");								
								
								AddElement(log, "ActivityDateTime", "ActivityDate");
								AddElement(log, "Activity", "ActivityDescription");
								AddElement(log, "Token", "Token");
								
								XmlElement xnService = _AddElement(log, "Service");
								AddAttribute(xnService, "ServiceID", "ServiceID");
								AddElement(xnService, "Description", "ServiceDescription");								
							}
						}
					}
				} catch (Exception exc) {
					Error(2027, "There was an error retrieving the Activity Log", exc);
				}
			return this as XmlDocument;
			}
		}
		#endregion
	}
}
