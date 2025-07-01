using System;
using System.Configuration;
using System.Xml;
using System.Data;
using System.Data.SqlClient;

using XXBoom.MachinaX.DataX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2008-02-22	
	Status:		redev	
	Version:	2.0.0
	Build:		20080304
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	-------------------------------------------------------------------------------------------------
	Note re MachinaX.PassportX:	See note in other modules
	-------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------
	Development Notes:
	==================
	20080304:	Starting point. Note that this has been included in the PassportX code in the short
				term and possibly could be refactored into a separate component.
	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation for all FriendStatus-related methods in the Gatekeeper Web Service.
	/// <p>Access to the FriendStatus class is limited to the Gatekeeper Web Service.</p>
	/// </summary>
	public class x_friendStatus : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "FriendStatus";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_LIST	=	"x_FriendStatusList";
		private const string PROC_GET	=	"x_FriendStatusGet";
		private const string PROC_ADD	=	"x_FriendStatusAdd";
		private const string PROC_DEL	=	"x_FriendStatusDelete";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the FriendStatus class.
		/// </summary>
		public x_friendStatus(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_friendStatus(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Used to add/update a FriendStatus record in the Gatekeeper database. All FriendStatus records must have unique
		/// descriptions.
		/// </summary>
		/// <param name="FriendStatusID">The public ID of the FriendStatus record. This is an identity/auto-number field in the database, and is assigned when a record is first saved. If the value is 0 (zero), the system will attempt to add a new record, as long as the description is unique.</param>
		/// <param name="Description">The text description of the FriendStatus record. All descriptions must be unique.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating whether the save was successful
		/// </returns>
		public XmlDocument SaveFriendStatus(int FriendStatusID, string Description) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter statusid = AddSQLParameter(FriendStatusID, "@FriendStatusID", ParameterDirection.InputOutput);
						AddSQLParameter(Description, "@Description", 50);
						Execute();
						if(FriendStatusID == 0) {
							FriendStatusID = Convert.ToInt16(GetValue(statusid));
						}
						_AddAttribute("FriendStatusID", FriendStatusID);

					}
				} catch (Exception exc) {
					Error(2034, "There was an error saving the Friend Status record", exc);
					_AddAttribute("FriendStatusID", FriendStatusID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Return details for a specific Friend Status in the Gatekeeper database.
		/// </summary>
		/// <param name="FriendStatusID">The public ID of the Friend Status record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument GetFriendStatus(int FriendStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(FriendStatusID, "@FriendStatusID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("FriendStatusID", "FriendStatusID");
								AddElement("Description", "Description");
							} else {
								Error(2013, "Could not retrieve the details for the selected Friend Status record.");
								_AddAttribute("FriendStatusID", FriendStatusID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2014, "There was an error retrieving the Friend Status record", exc);
					_AddAttribute("FriendStatusID", FriendStatusID);
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
		public XmlDocument GetFriendStatusList() {
			Tag = "GroupStatusList";	// set the result xml to have a "GroupStatusList" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement person, persons;
							persons = SelectSingleNode("/FriendStatusList") as XmlElement;
							while (Read()) {
								person = _AddElement(persons, "FriendStatus");
								AddAttribute(person, "FriendStatusID", "FriendStatusID");
								AddElement(person, "Description", "Description");
							}
						}
					}
				} catch (Exception exc) {
					Error(2015, "There was an error retrieving the Friend Status List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to remove a FriendStatus record from the Gatekeeper database. The system will first check whether the
		/// record is still in use before attempting to delete the record.
		/// </summary>
		/// <param name="FriendStatusID">The public ID of the FriendStatus record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating whether the delete was successful
		/// </returns>
		public XmlDocument DeleteFriendStatus(int FriendStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(FriendStatusID, "@FriendStatusID");
						IDataParameter result = AddSQLParameter("@Result", 25, true);
						Execute();
						if (Test(result)) {
							Error(2006, "There was an error deleting the Friend Status record", GetValue(result));
						}
					}
				} catch (Exception exc) {
					Error(2006, "There was an error deleting the Friend Status record", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion
	}
}
