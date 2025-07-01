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
				Was: 228 lines, now 195 including notes and comments
				Class hierarchy as follows:
					 x_productStatus _
								| _ GateKeeperBase _
												|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_productStatus -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation of all methods related to ProductStatus in the Gatekeeper Web Service
	/// <p>Access to the ProductStatus class is limited to the Gatekeeper Web Service only.</p>
	/// </summary>
	public class x_productStatus : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "ProductStatus";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_LIST	=	"x_ProductStatusList";
		private const string PROC_GET	=	"x_ProductStatusGet";
		private const string PROC_ADD	=	"x_ProductStatusAdd";
		private const string PROC_DEL	=	"x_ProductStatusDelete";
		private const string PROC_UPD	=	"x_ProductStatusUpdate";	// not used?
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the ProductStatus class.
		/// </summary>
		public x_productStatus(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_productStatus(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Used to add/update a ProductStatus record in the Gatekeeper database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="ProductStatusID">The public ID of the Product Status record, used to uniquely identify the record in the Gatekeeper database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Product Status. This must be unqiue in the Gatekeeper database.</param>
		/// <param name="DisplayMessage">A text description that can be used to display a message to users when the system is offline, or unavailable, that contains more detailed information on the status of product.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save
		/// </returns>
		public XmlDocument SaveProductStatus(int ProductStatusID, string Description, string DisplayMessage) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter statusid = AddSQLParameter(ProductStatusID, "@ProductStatusID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 50);
						AddSQLParameter(DisplayMessage, "@DisplayMessage", 300);
						Execute();
						if (ProductStatusID == 0) {
							ProductStatusID = Convert.ToInt16(GetValue(statusid));
						}
						_AddAttribute("ProductStatusID", ProductStatusID);
					}
				} catch (Exception exc) {
					Error(2043, "There was an error saving the Product Status record", exc);
					_AddAttribute("ProductStatusID", ProductStatusID);
				}
			return this as XmlDocument;
			}
		}
		/// <summary>
		/// Return details for a specific Product Status in the Gatekeeper database.
		/// </summary>
		/// <param name="ProductStatusID">The public ID of the Product Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object 
		/// </returns>
		public XmlDocument GetProductStatus(int ProductStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(ProductStatusID, "@ProductStatusID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("ProductStatusID", "ProductStatusID");
								AddElement("Description", "Description");
								AddElement("DisplayMessage", "DisplayMessage");
							} else {
								Error(2016, "Could not retrieve the data for the selected Product Status record.");
								_AddAttribute("ProductStatusID", ProductStatusID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2016, "There was an error retrieving the Product Status record", exc);
					_AddAttribute("ProductStatusID", ProductStatusID);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Returns a list of all product status' in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetProductStatusList() {
			Tag = "ProductStatusList";	// set the result xml to have a "ProductStatusList" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement product, products;
							products = SelectSingleNode("/ProductStatusList") as XmlElement;
							while (Read()) {
								product = _AddElement(products, "ProductStatus");
								AddAttribute(product, "ProductStatusID", "ProductStatusID");
								AddElement(product, "Description", "Description");
								if (Test("DisplayMessage")) {
									AddElement(product, "DisplayMessage", "DisplayMessage");
								}
							}
						}
					}
				} catch (Exception exc) {
					Error(2017, "There was an error retrieving the Product Status List", exc);
				}
			}
			return this as XmlDocument;
		}

		/// <summary>
		/// Used to delete a ProductStatus record from the database. Validation will be done that the Product Status is not
		/// in use any more, before the deletion will take place.
		/// </summary>
		/// <param name="ProductStatusID">The public Product Status ID of the Product Status record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument DeleteProductStatus(int ProductStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(ProductStatusID, "@ProductStatusID");
						IDataParameter result = AddSQLParameter("", "@Status", 25, true);
						Execute();
						if (Test(result)) {
							Error(2007, "There was an error deleting the Product Status record.");
						}
					}
				} catch (Exception exc) {
					Error(2007, "There was an error deleting the Product Status record", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion
	}
}
