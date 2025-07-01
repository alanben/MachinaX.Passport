using System;
using System.Xml;
using System.Web.Services;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20070531
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
	
/*	-------------------------------------------------------------------------------------------------
	Development Notes:
	20070531:	Starting point from NMGatekeeper.2.0.2.
	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX.PassportServiceX {
	/// <summary>
	/// This PassportService class is
	/// </summary>
	[WebService(Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX")]
	public class PassportProductX : PassportWebServiceX {
		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor for the NMPortal Web Service
		/// </summary>
		public PassportProductX() : base() {
		}
		#endregion

		#region Service related methods
		[WebMethod] public XmlDocument SaveProduct(string Token, int ProductID, string Description, int ProductStatusID) {
			return _SaveProduct(Token, ProductID, Description, ProductStatusID);
		}

		[WebMethod] public XmlDocument SaveProductNotification(string Token, int ProductID, string URL, string WSDLURL, string Name, string Namespace) {
			return _SaveProductNotification(Token, ProductID, URL, WSDLURL, Name, Namespace);
		}

		[WebMethod] public XmlDocument GetProduct(int ProductID) {
			return _GetProduct(ProductID);
		}

		[WebMethod] public XmlDocument GetProductList() {
			return _GetProductList();
		}

		[WebMethod] public XmlDocument GetProductServiceList(string Token, int ProductID) {
			return _GetProductServiceList(Token, ProductID);
		}

		[WebMethod] public XmlDocument DeleteProduct(string Token, int ProductID) {
			return _DeleteProduct(Token, ProductID);
		}

		[WebMethod] public XmlDocument UndeleteProduct(string Token, int ProductID) {
			return _UndeleteProduct(Token, ProductID);
		}

		[WebMethod] public XmlDocument RemoveProduct(string Token, int ProductID) {
			return _RemoveProduct(Token, ProductID);
		}

		[WebMethod] public bool LockProduct(string Token, int ProductID) {
			return _LockProduct(Token, ProductID);
		}

		[WebMethod] public bool UnlockProduct(string Token, int ProductID) {
			return _UnlockProduct(Token, ProductID);
		}
		#endregion
	}
}
