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
				Was: 226 lines, now xxx including notes and comments
				Class hierarchy as follows:
					x_serviceStatus _
								| _ GateKeeperBase _
												|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_config -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation of all methods related to ServiceStatus in the Gatekeeper Web Service.
	/// <p>Access to the ServiceStatus class is limited to the Gatekeeper Web Service only.</p>
	/// </summary>
	public class x_serviceStatus : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "ServiceStatus";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_ADD	=	"x_ServiceStatusAdd";
		private const string PROC_GET	=	"x_ServiceStatusGet";
		private const string PROC_LIST	=	"x_ServiceStatusList";
		private const string PROC_DEL	=	"x_ServiceStatusDelete";
		private const string PROC_UPD	=	"x_ServiceStatusUpdate";	// not used?
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the ServiceStatus class.
		/// </summary>
		public x_serviceStatus(string DSN) : base(DSN) {
		}
		public x_serviceStatus(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Used to add/update a Service Status record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="ServiceStatusID">The public ID of the Service Status record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Service Status. This must be unqiue in the Gatekeeper database.</param>
		/// <param name="DisplayMessage">A text description that can be used to display a message to users when the service is unavailable, that contains more detailed information on the status of service.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save
		/// </returns>
		public XmlDocument SaveServiceStatus(int ServiceStatusID, string Description, string DisplayMessage) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter statusid = AddSQLParameter(ServiceStatusID, "@ServiceStatusID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 50);
						AddSQLParameter(DisplayMessage, "@DisplayMessage", 300);
						Execute();
						if (ServiceStatusID == 0) {
							ServiceStatusID = GetValue(statusid, 0);
						}
						_AddAttribute("ServiceStatusID", ServiceStatusID);
					}
				} catch (Exception exc) {
					Error(2052, "There was an error trying to save the Service Status record", exc);
					_AddAttribute("ServiceStatusID", ServiceStatusID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Return details for a specific Service Status in the Gatekeeper database.
		/// </summary>
		/// <param name="ServiceStatusID">The public ID of the Service Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetServiceStatus(int ServiceStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(ServiceStatusID, "@ServiceStatusID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("ServiceStatusID", "ServiceStatusID");
								AddElement("Description", "Description");
								AddElement("DisplayMessage", "DisplayMessage");
							} else {
								Error(2020, "Could not retrieve the details for the selected record.");
								_AddAttribute("ServiceStatusID", ServiceStatusID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2020, "There was an error retrieving the Service Status record", exc);
					_AddAttribute("ServiceStatusID", ServiceStatusID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Returns a list of all service status' in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetServiceStatusList() {
			Tag = "ServiceStatusList";
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement service, services;
							services = SelectSingleNode("/ServiceStatusList") as XmlElement;
							while(Read()) {
								service = _AddElement(services, "ServiceStatus");
								AddAttribute(service, "ServiceStatusID", "ServiceStatusID");
								AddElement(service, "Description", "Description");
								if (Test("DisplayMessage")) {
									AddElement(service, "DisplayMessage", "DisplayMessage");
								}
							}
						}
					}
				} catch (Exception exc) {
					Error(2022, "There was an error retrieving the Service Status List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to delete a Service Status record from the database. Validation will be done that the Service Status is not
		/// in use any more, before the deletion will take place.
		/// </summary>
		/// <param name="ServiceStatusID">The public Service Status ID of the Service Status record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument DeleteServiceStatus(int ServiceStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(ServiceStatusID, "@ServiceStatusID");
						IDataParameter result = AddSQLParameter("@Result", 25, true);
						Execute();
						if (Test(result)) {
							Error(2009, "There was an error deleting the Service Status record", GetValue(result));
						}
					}
				} catch (Exception exc) {
					Error(2009, "There was an error deleting the Service Status record", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion
	}
}
