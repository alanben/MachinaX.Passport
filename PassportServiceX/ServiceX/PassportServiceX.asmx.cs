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
	public class PassportServiceX : PassportWebServiceX {
		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor for the NMPortal Web Service
		/// </summary>
		public PassportServiceX() : base() {
		}
		#endregion

		#region Service related methods
		[WebMethod] public XmlDocument SaveService(string Token, int ServiceID, int ProductID, string Description, int ServiceStatusID) {
			return _SaveService(Token, ServiceID, ProductID, Description, ServiceStatusID);
		}

		[WebMethod] public XmlDocument GetService (string Token, int ServiceID) {
			return _GetService (Token, ServiceID);
		}

		[WebMethod] public XmlDocument GetServiceList (string Token) {
			return _GetServiceList(Token);
		}

		[WebMethod] public XmlDocument DeleteService(string Token, int ServiceID) {
			return _DeleteService(Token, ServiceID);
		}

		[WebMethod] public XmlDocument UndeleteService(string Token, int ServiceID) {
			return _UndeleteService(Token, ServiceID);
		}

		[WebMethod] public XmlDocument RemoveService(string Token, int ServiceID) {
			return _RemoveService(Token, ServiceID);
		}

		[WebMethod] public bool LockService(string Token, int ServiceID) {
			return _LockService(Token, ServiceID);
		}

		[WebMethod] public bool UnlockService(string Token, int ServiceID) {
			return _UnlockService(Token, ServiceID);
		}
		#endregion
	}
}
