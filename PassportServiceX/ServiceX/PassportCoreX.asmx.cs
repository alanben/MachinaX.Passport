using System;
using System.Collections;
using System.ComponentModel;
using System.Xml;
using System.Diagnostics;
using System.Web;
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
	20061012:	Added GetUser overload - does not require token 
				for use in applications (eg NMTracker)
	20070531:	Starting point from NMGatekeeper.2.0.2.
	20071226:	Added support for multiple databases using DataX
	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX.PassportServiceX {
	/// <summary>
	/// This PassportService class is
	/// </summary>
	[WebService(Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX")]
	public class PassportCoreX : PassportX {
		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor for the NMPortal Web Service
		/// </summary>
		public PassportCoreX() : base() {
			//_User = new x_user(DSN);
			//_Activity = new x_activity(DSN);
		}
		#endregion

		#region Exposed web methods
		/// <overloads>Retrieves a specific user's details for display or editing on a user interface.</overloads>
		/// <summary>
		/// Requires token for validation purposes
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		//[WebMethod] 
		public XmlDocument GetUser(string Token, int UserID) {
			XmlDocument userXml, validXml;
			try {
				validXml = ValidateToken(Token, "administer", "GetUser");
				if (validXml == null) {
					userXml = _User.GetUser(UserID);
				} else {
					userXml = validXml;
				}
			} catch {
				userXml = null;
			}
			return userXml;
		}
		/// <summary>
		/// Does not require token - used for system acces to the user details.
		/// </summary>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		[WebMethod] public XmlDocument GetUser(int UserID) {
			XmlDocument userXml;
			try {
				userXml = _User.GetUser(UserID);
			} catch {
				userXml = null;
			}
			return userXml;
		}
		/// <summary>
		/// Finds a user
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument FindUser(string SearchName, string SearchNo) {
			XmlDocument getUser;
			string thisname = (SearchName != "")? SearchName : "<none>";
			string thisno = (SearchNo != "")? SearchNo : "<none>";
			getUser = _User.FindUser(thisname, thisno);
			return getUser;
		}
		#endregion
	}
}
