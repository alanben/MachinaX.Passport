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
				Was: 553 lines, now 373 including notes and comments
				Class hierarchy as follows:
					  x_product _
							| _ GateKeeperBase _
											|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_product -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation of all Product-related methods for the Gatekeeper Web Service.
	/// <p>Access to the Product class is limited to the Gatekeeper Web Service.</p>
	/// </summary>
	public class x_product : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Product";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_LIST	=	"x_ProductList";
		private const string PROC_GET	=	"x_ProductGet";
		private const string PROC_ADD	=	"x_ProductAdd";
		private const string PROC_DEL	=	"x_ProductDelete";
		private const string PROC_UPD	=	"x_ProductUpdate";
		private const string PROC_NOTIFY_ADD	=	"x_ProductNotificationAdd";
		private const string PROC_SERVICE_LIST	=	"x_ProductServiceList";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Product class
		/// </summary>
		public x_product(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_product(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Method to save a Product's details. The database implementation will check for the existince of a record,
		/// and if not present will add it.
		/// </summary>
		/// <param name="ProductID">The public Product ID. This value must be 0 (zero) for a new record.</param>
		/// <param name="Description">The description of the Product.</param>
		/// <param name="ProductStatusID">The public Product Status ID, linked to the ProductStatus lookup.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save 
		/// </returns>
		public XmlDocument SaveProduct(int ProductID, string Description, int ProductStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter productid = AddSQLParameter(ProductID, "@ProductID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 100);
						AddSQLParameter(ProductStatusID, "@ProductStatusID");
						Execute();
						if (ProductID == 0) {
							ProductID = GetValue(productid, 0);
						}
						_AddAttribute("ProductID", ProductID);
					}
				} catch (Exception exc) {
					Error(2035, "There was an error saving the Product", exc);
					_AddAttribute("ProductID", ProductID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Add/update a Product Notification details
		/// </summary>
		/// <param name="ProductID">The public ID of an already existing Product record in the Gatekeeper database.</param>
		/// <param name="URL">The URL of the web service or web page to be called when sending notifications</param>
		/// <param name="WSDLURL">If the application being called is a web service, the URL of the WSDL document of the web service.</param>
		/// <param name="Name">The application name of the web service to be called.</param>
		/// <param name="Namespace">The namespace of the web service to be called.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument SaveProductNotification(int ProductID, string URL, string WSDLURL, string Name, string Namespace) {
			using (Connect()) {
				try {
					using (Command(PROC_NOTIFY_ADD)) {
						IDataParameter productid = AddSQLParameter(ProductID, "@ProductID", ParameterDirection.InputOutput);
						AddSQLParameter(URL, "@URL", 100);
						AddSQLParameter(WSDLURL, "@WSDLURL", 200);
						AddSQLParameter(Name, "@Name", 100);
						AddSQLParameter(Namespace, "@Namespace", 150);
						Execute();
						if (ProductID == 0) {
							ProductID = GetValue(productid, 0);
						}
						_AddAttribute("ProductID", ProductID);
					}
				} catch (Exception exc) {
					Error(2075, "There was an error saving the Product", exc);
					_AddAttribute("ProductID", ProductID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Return details for a specific Product in the Gatekeeper database.
		/// </summary>
		/// <param name="ProductID">The public ID of the Product record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetProduct(int ProductID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(ProductID, "@ProductID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("ProductID", "ProductID");
								AddElement("Description", "ProductDesc");
								if (Test("URL")) {
									XmlElement notify = _AddElement("Notification");
									AddElement(notify, "URL", "URL");								
									if (Test("WSDLURL")) {
										AddElement(notify, "WSDLURL", "WSDLURL");
									}
									if (Test("Name")) {
										AddElement(notify, "Name", "Name");
									}
									if (Test("Namespace")) {
										AddElement(notify, "Namespace", "Namespace");
									}
								}
								XmlElement status = _AddElement("Status");
								AddAttribute(status, "ProductStatusID", "ProductStatusID");
								AddElement(status, "Description", "ProductStatusdesc");								
								AddElement(status, "DisplayMessage", "DisplayMessage");								
							} else {
								Error(2037, "Could not retrieve the data for the selected Product.");
								_AddAttribute("ProductID", ProductID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2036, "There was an error retrieving the Product details", exc);
					_AddAttribute("ProductID", ProductID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Returns a list of all products in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetProductList() {
			Tag = "Products";	// set the result xml to have a "Products" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement product, products;
							products = this.SelectSingleNode("/Products") as XmlElement;
							while (Read()) {
								product = _AddElement(products, "Product");
								AddAttribute(product, "ProductID", "ProductID");
								AddElement(product, "Description", "ProductDesc");
								XmlElement status = _AddElement("Status");
								AddAttribute(status, "ProductStatusID", "ProductStatusID");
								AddElement(status, "Description", "ProductStatusdesc");								
								if (Test("DisplayMessage")) {
									AddElement(status, "DisplayMessage", "DisplayMessage");								
								}
							}
						}
					}
				} catch(Exception exc) {
					Error(2038, "There was an error retrieving the Products List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to retrieve a list of all services related to a selected product.
		/// </summary>
		/// <param name="ProductID">The public ID of the Product record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetServiceList(int ProductID) {
			using (Connect()) {
				try {
					using (Command(PROC_SERVICE_LIST)) {
						AddSQLParameter(ProductID, "@ProductID");
						using (Reader()) {
							XmlElement service;
							//XmlElement services = _AddElement("Services");
							while (Read()) {
								if (SelectSingleNode("/Product/@ProductID") == null) {
									AddAttribute("ProductID", "ProductID");
									AddElement("Description", "ProductDesc");
								}
								//service = _AddElement(services, "Service");
								service = _AddElement("Service");
								AddAttribute(service, "ServiceID", "ServiceID");
								AddAttribute(service, "Description", "ServiceDesc");
								XmlElement status = _AddElement(service, "Status");
								AddAttribute(status, "ServiceStatusID", "ServiceStatusID");
								AddElement(status, "Description", "ServiceStatusDesc");								
								if (Test("DisplayMessage")) {
									AddElement(status, "DisplayMessage", "DisplayMessage");								
								}
							}
						}
					}
				} catch (Exception exc) {
					Error(2039, "There was an error retrieving the Product Service list", exc);
					_AddAttribute("ProductID", ProductID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Marks a product as deleted on the Gatekeeper database. Validation will be done that the product is not in use any more.
		/// </summary>
		/// <param name="ProductID">The public Product ID of the record to be deleted.</param>
		/// <returns>
		/// Returns an XmlDocument object indicating the result of the delete
		/// </returns>
		public XmlDocument DeleteProduct(int ProductID) {
			try {
				UpdateProductStatus(ProductID, "Inactive");
			} catch (Exception exc) {
				Error(2040, "An error occured deleting the Product", exc);
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Restores a product that was previously deleted on the Gatekeeper database.
		/// </summary>
		/// <param name="ProductID">The public Product ID of the record to be restored.</param>
		/// <returns>
		/// Returns an XmlDocument object indicating the result of the undelete
		/// </returns>
		public XmlDocument UndeleteProduct(int ProductID) {
			try {
				UpdateProductStatus(ProductID, "Active");
			} catch (Exception exc) {
					Error(2041, "There was an error Undeleting the Product", exc);
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Permanently removes a product from the Gatekeeper database. Any links between Users 
		/// and the selected product will also be removed. Any services linked to the product will also
		/// be removed, as well as any links to those services.
		/// </summary>
		/// <param name="ProductID">The public Product ID of the record to be deleted.</param>
		/// <returns>
		/// Returns an XmlDocument object indicating the result of the delete
		/// </returns>
		public XmlDocument RemoveProduct(int ProductID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(ProductID, "@ProductID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2042, "There was an error removing the Product", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Lock access to a Product.
		/// </summary>
		/// <param name="ProductID">The public Product ID of the record to lock.</param>
		/// <returns>Returns a boolean value indicating whether the locking process was successful.</returns>
		public bool LockProduct(int ProductID) {
			try {
				UpdateProductStatus(ProductID, "Locked");
				return true;
			} catch {
				return false;
			}
		}


		/// <summary>
		/// Unlock access to a Product.
		/// </summary>
		/// <param name="ProductID">The public Product ID of the record to unlock.</param>
		/// <returns>Returns a boolean value indicating whether the unlocking process was successful.</returns>
		public bool UnlockProduct(int ProductID) {
			try {
				UpdateProductStatus(ProductID, "Active");
				return true;
			} catch {
				return false;
			}
		}


		private void UpdateProductStatus(int ProductID, string Status) {
			using (Connect()) {
				try {
					using (Command(PROC_UPD)) {
						AddSQLParameter(ProductID, "@ProductID");
						AddSQLParameter(Status, "@Status", 25);
						Execute();
					}
				} catch (Exception exc) {
					throw exc;
				}
			}
		}
		#endregion
	}
}
