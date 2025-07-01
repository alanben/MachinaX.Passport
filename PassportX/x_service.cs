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
	20070306:	Refactoring using the model in GKUser, ie: use of AddSQLParameter, GetSqlString, GetSqlYesNo etc
				Was: 362 lines, now 273 including notes and comments
				Class hierarchy as follows:
					  x_service _
							| _ GateKeeperBase _
											|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_service -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation of all Service related methods for the Gatekeeper Web Service.
	/// <p>Access to the Service class is limited to the Gatekeeper Web Service only.</p>
	/// </summary>
	public class x_service : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Service";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_ADD	=	"x_ServiceAdd";
		private const string PROC_DEL	=	"x_ServiceDelete";
		private const string PROC_GET	=	"x_ServiceGet";
		private const string PROC_LIST	=	"x_ServiceList";
		private const string PROC_UPD	=	"x_ServiceUpdate";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Service class
		/// </summary>
		public x_service(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_service(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Method to save the details of a Service.
		/// </summary>
		/// <param name="ServiceID">The public Service ID of the Service record.</param>
		/// <param name="ProductID">The public ID of the Product to which the service is linked.</param>
		/// <param name="Description">The description of the service, used to reference the service in other methods.</param>
		/// <param name="ServiceStatusID">The public ID of the Service Status record, which identifies the status of the service.</param>
		/// <returns>Returns an XmlDocument object indicating the result of the Save method</returns>
		public XmlDocument SaveService(int ServiceID, int ProductID, string Description, int ServiceStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter serviceid = AddSQLParameter(ServiceID, "@ServiceID", true);
						AddSQLParameter(ProductID, "@ProductID");
						AddSQLParameter(ServiceStatusID, "@ServiceStatusID");
						AddSQLParameter(Description, "@Description", 100);
						Execute();
						if (ServiceID == 0) {
							ServiceID = Convert.ToInt16(serviceid.Value.ToString());
						}
						_AddAttribute("ServiceID", ServiceID.ToString());
					}
				} catch (Exception exc) {
					Error(2045, "There was an error trying to save the Service record", exc);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Retrieves details of a selected Service in the Gatekeeper database, usually for editing purposes.
		/// </summary>
		/// <param name="ServiceID">The public ID of the Service record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the information on the Service
		/// </returns>
		public XmlDocument GetService(int ServiceID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(ServiceID, "@ServiceID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("ServiceID", "ServiceID");
								AddAttribute("ProductID", "ProductID");
								AddElement("Description", "ServiceDesc");
								AddAttribute("Status", "ServiceStatusID", "ServiceStatusID");
								AddElement("Status", "Description", "ServiceStatusDesc");
								AddElement("Status", "DisplayMessage", "DisplayMessage");
							} else {
								Error(2047, "Could not retrieve the Service record details.");
								_AddAttribute("ServiceID", ServiceID.ToString());
							}
						}
					}
				} catch (Exception exc) {
					Error(2046, "There was an error trying to save the Service record", exc);
					_AddAttribute("ServiceID", ServiceID.ToString());
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Retrieves a list of all Services in the Gatekeeper database.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetServiceList() {
			Tag = "Services";	// set the result xml to have a "Services" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement service, services;
							services = SelectSingleNode("/Services") as XmlElement;
							while (Read()) {
								service = _AddElement(services, "Service");
								AddAttribute(service, "ServiceID", "ServiceID");
								AddAttribute(service, "ProductID", "ProductID");
								AddElement(service, "Description", "ServiceDesc");
								XmlElement status = _AddElement(service, "Status");
								AddAttribute(status, "ServiceStatusID", "ServiceStatusID");
								AddElement(status, "Description", "ServiceStatusDesc");	
								AddElement(status, "DisplayMessage", "DisplayMessage");
							}
						}
					}
				} catch (Exception exc) {
					Error(2048, "There was an error retrieving the Services List", exc);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Used to mark a Service record as inactive on the Gatekeeper database. The system will check that the Service is
		/// no longer in use before attempting the delete of the record.
		/// </summary>
		/// <param name="ServiceID">The public ID of the Service record, used to uniquely identify the record in the Gatekeeper database.</param>
		/// <returns>Returns an XmlDocument object, indicating the result of the delete</returns>
		public XmlDocument DeleteService(int ServiceID) {
			try {
				UpdateServiceStatus(ServiceID, "Inactive");
			} catch (Exception exc) {
				Error(2049, "There was an error deleting the Service", exc);
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to restore a Service record on the Gatekeeper database that was previously marked as inactive.
		/// </summary>
		/// <param name="ServiceID">The public ID of the Service record, used to uniquely identify the record in the Gatekeeper database.</param>
		/// <returns>Returns an XmlDocument object, indicating the result of the restore</returns>
		public XmlDocument UndeleteService(int ServiceID) {
			try {
				UpdateServiceStatus(ServiceID, "Active");
			} catch (Exception exc) {
				Error(2050, "There was an error undeleting the Service record", exc);
			}
			return this as XmlDocument;
		}

		
		/// <summary>
		/// Used to completely remove a Service record from the Gatekeeper database. Any links from Users to the service
		/// will also be removed.
		/// </summary>
		/// <param name="ServiceID">The public ID of the Service record, used to uniquely identify the record in the Gatekeeper database.</param>
		/// <returns>Returns an XmlDocument object, indicating the result of the delete</returns>
		public XmlDocument RemoveService(int ServiceID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(ServiceID, "@ServiceID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2051, "There was an error removing the Service record", exc);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Used to lock a service in the Gatekeeper database. This will not prevent access to the Service,
		/// but will inform the Service when a user is validated that the Service should not allow any
		/// transactional processing to occur.
		/// </summary>
		/// <param name="ServiceID">The public ID of the Service record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value indicating whether the unlock was successful.
		/// </returns>
		public bool LockService(int ServiceID) {
			try {
				UpdateServiceStatus(ServiceID, "Locked");
				return true;
			} catch {
				return false;
			}
		}

		
		/// <summary>
		/// Used to unlock a service in the Gatekeeper database that was previously locked.
		/// </summary>
		/// <param name="ServiceID">The public ID of the Service record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns a boolean value indicating whether the unlock was successful.
		/// </returns>
		public bool UnlockService(int ServiceID) {
			try {
				UpdateServiceStatus(ServiceID, "Active");
				return true;
			} catch {
				return false;
			}
		}


		private void UpdateServiceStatus(int ServiceID, string Status) {
			using (Connect()) {
				using (Command("x_ServiceUpdate")) {
					AddSQLParameter(ServiceID, "@ServiceID");
					AddSQLParameter(Status, "@Status", 25);
					Execute();
				}
			}
		}
		#endregion
	}
}
