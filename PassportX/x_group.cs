using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

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
	20070306:  Refactoring using the model in GKUser, ie: use of AddSQLParameter, GetSqlString, GetSqlYesNo etc
				Was: 667 lines, now 438 including notes and comments
				Class hierarchy as follows:
				x_group _
						| _ GateKeeperBase _
										|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_config -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	20081006:	Some revisions:
				- return statements for methods that return XmlDocument moved to last statement in method (as per other objects)
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Class containing all User Questions-related methods. Questions and answers are stored for reminders of passwords.
	/// </summary>
	public class x_group : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Group";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_ADD	=	"x_GroupAdd";
		private const string PROC_UPD	=	"x_GroupUpdate";
		private const string PROC_DEL	=	"x_GroupDelete";
		private const string PROC_GET	=	"x_GroupGet";
		private const string PROC_GETS	=	"x_GroupGets";
		private const string PROC_LIST	=	"x_GroupList";
		private const string PROC_USER_LIST	=	"x_GroupUserList";
		private const string PROC_SERVICE_ADD	=	"x_GroupServiceAdd";
		private const string PROC_PRODUCT_ADD	=	"x_GroupProductAdd";
		private const string PROC_SERVICE_DEL	=	"x_GroupServiceDelete";
		private const string PROC_PRODUCT_DEL	=	"x_GroupProductDelete";
		private const string PROC_RIGHTS_LIST	=	"x_GroupRightsList";
		private const string PROC_STATUS_ADD	=	"x_GroupStatusAdd";
		
		/* Not sure about the following two (from x_oldprofile) so keep the orginal x_group procs
		private const string PROC_SERVICE_ADD	=	"x_GroupServiceAddAlt";
		private const string PROC_SERVICE_DEL	=	"x_GroupServiceDeleteAlt";
		*/
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Questions class
		/// </summary>
		/// <param name="DSN">The Data Source to be used for database connections</param>
		public x_group(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_group(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Returns a list of all groups in the Gatekeeper database.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetGroups() {
			Tag = "Groups";	// set the result xml to have a "Groups" root element
			using (Connect()) {
				try {
					using (Command(PROC_GETS)) {
						using (Reader()) {
							XmlElement group, groups;
							groups = SelectSingleNode("/Groups") as XmlElement;
							while (Read()) {
								group = _AddElement(groups, "item");
								AddAttribute(group, "GroupID", "GroupID");
								AddAttribute(group, "GroupName", "GroupName");
								AddAttribute(group, "StatusID", "StatusID");
								AddAttribute(group, "Status", "Status");
							}
						}
					}
				} catch (Exception exc) {
					Error(2023, "There was an error retrieving the Group List", exc);
				}
			}
			return this as XmlDocument;
		}
		
		
		/// <summary>
		/// Used to add/update a Group record in the Gatekeeper database. All Group descriptions must be unique. The Group ID is assigned
		/// when the record is created in the database, and will be returned to the user.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group record in the database. If this value is 0 (zero), a new record will be added, provided that it is not a duplicate. The new record's ID will be returned to the calling application.</param>
		/// <param name="Description">The text description of the Group. All descriptions in the Gatekeeper database must be unique.</param>
		/// <param name="GroupStatusID">The ID of the GroupStatus indicating the status of this Group record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument SaveGroup(int GroupID, string Description, int GroupStatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter groupID = AddSQLParameter(GroupID, "@GroupID", true);
						AddSQLParameter(Description, "@Description", 100);
						AddSQLParameter(GroupStatusID, "@GroupStatusID");
						Execute();
						if (GroupID == 0)
							GroupID = Convert.ToInt16(groupID.Value.ToString());
						_AddAttribute("GroupID", GroupID.ToString());
					}
				} catch (Exception exc) {
					Error(2028, "There was an error saving the Group record", exc);
					_AddAttribute("GroupID", GroupID.ToString());
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Return details for a specific Group in the Gatekeeper database.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetGroup(int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(GroupID, "@GroupID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("GroupID", "GroupID");
								AddElement("Description", "GroupDesc");
								AddAttribute("Status", "GroupStatusID", "GroupStatusID");
								AddElement("Status", "Description", "GroupStatusDesc");
							} else {
								Error(2021, "Could not retrieve the details for the selected Group record.");
								_AddAttribute("GroupID", GroupID.ToString());
							}
						}
					}
				} catch (Exception exc) {
					Error(2021, "There was an error retrieving the Group details", exc);
					_AddAttribute("GroupID", GroupID.ToString());
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Returns a list of all groups in the Gatekeeper database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetGroupList() {
			Tag = "Groups";	// set the result xml to have a "Groups" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement group, groups;
							groups = this.SelectSingleNode("/Groups") as XmlElement;
							while (Read()) {
								group = _AddElement(groups, "Group");
								AddAttribute(group, "GroupID", "GroupID");
								AddElement(group, "Description", "Description");
								XmlElement status = _AddElement(group, "Status");
								AddAttribute(status, "GroupStatusID", "GroupStatusID");
								AddElement(status, "Description", "GroupStatusDesc");								
							}
						}
					}
				} catch (Exception exc) {
					Error(2023, "There was an error retrieving the Group List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Returns a list of users in a group.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetGroupMemberList(int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_USER_LIST)) {
						AddSQLParameter(GroupID, "@GroupID");
						using (Reader()) {
							XmlElement user, users;
							users = _AddElement("Users");
							while (Read()) {
								if (SelectSingleNode("/Group/@GroupID") == null) {
									AddAttribute("GroupID", "GroupID");
									AddElement("Description", "GroupDesc");
								}
								user = _AddElement(users, "User");
								AddAttribute(user, "UserID", "PersonID");
								AddElement(user, "FirstName", "FirstName");								
								AddElement(user, "Surname", "Surname");								
							}
						}
					}
				} catch (Exception exc) {
					Error(2029, "There was an error retrieving the Group Member List", exc);
					_AddAttribute("GroupID", GroupID.ToString());
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to mark a Group record as deleted on the Gatekeeper database. The record will NOT be physically removed from
		/// the database, but flagged as deleted/inactive.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument DeleteGroup(int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_UPD)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter("Inactive", "@Status", 25);
						Execute();
					}
				} catch (Exception exc) {
					Error(2030, "There was an error Deleting the Group", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to restore a Group record that was previously deleted on the Gatekeeper database.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the restore
		/// </returns>
		public XmlDocument UndeleteGroup(int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_UPD)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter("Active", "@Status", 25);
						Execute();
					}
				} catch (Exception exc) {
					Error(2031, "There was an error Uneleting the Group", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to completely delete a Group from the Gatekeeper database. The system will also remove any links
		/// between any users and the group, and remove them as well.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the remove
		/// </returns>
		public XmlDocument RemoveGroup(int GroupID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(GroupID, "@GroupID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2032, "There was an error Removing the Group", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Used to retrieve a list of all services related to a selected group.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group record in the Gatekeeper database.</param>
		/// <returns>
		/// </returns>
		public XmlDocument GetGroupRightsList(int GroupID) {
			Tag = "Groups";
			using (Connect()) {
				try {
					using (Command(PROC_RIGHTS_LIST)) {
						AddSQLParameter(GroupID, "@GroupID");
						using (Reader()) {
							int thisgroup, lastgroup = -1;
							XmlElement group = null, groups, right;
							groups = this.SelectSingleNode("/Groups") as XmlElement;
							while (Read()) {
								thisgroup = GetValue("GroupID", 0);
								// add new product parent
								if (thisgroup != lastgroup) {
									group = _AddElement(groups, "Group");
									AddAttribute(group, "GroupID", "GroupID");
									AddAttribute(group, "name", "GroupDesc");
									lastgroup = thisgroup;
								}
								right = _AddElement(group, "Right");
								AddAttribute(group, "ProductID", "ProductID");
								AddAttribute(group, "ServiceID", "ServiceID");
								AddAttribute(group, "SecurityLevelID", "SecurityLevelID");
								AddElement(group, "ProductDesc", "ProductDesc");
								AddElement(group, "ServiceDesc", "ServiceDesc");
								AddElement(group, "SecurityLevelDesc", "SecurityLevelDesc");
							}
						}
					}
				} catch (Exception exc) {
					Error(2039, "There was an error retrieving the Product Service list", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to link all users in a Group to a Service.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group to be used.</param>
		/// <param name="ServiceID">The public ID of the Service to which the link is to be created.</param>
		/// <param name="SecurityLevelID">The public ID of the Security Level that is to be set for all users linked to the Service.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument SaveGroupService(int GroupID, int ServiceID, int SecurityLevelID) {
			using (Connect()) {
				try {
					using (Command(PROC_SERVICE_ADD)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(ServiceID, "@ServiceID");
						AddSQLParameter(SecurityLevelID, "@SecurityLevelID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2070, "There was an error saving the data", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to link all users in a Group to a Product.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group to be used.</param>
		/// <param name="ProductID">The public ID of the Product to which the link is to be created.</param>
		/// <param name="SecurityLevelID">The public ID of the Security Level that is to be set for all users linked to the Product.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument SaveGroupProduct(int GroupID, int ProductID, int SecurityLevelID) {
			using (Connect()) {
				try {
					using (Command(PROC_PRODUCT_ADD)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(ProductID, "@ProductID");
						AddSQLParameter(SecurityLevelID, "@SecurityLevelID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2071, "There was an error saving the data", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to remove the link between all users in a Group and a Service.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group to be used.</param>
		/// <param name="ServiceID">The public ID of the Service to which the link is to be created.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument DeleteGroupService(int GroupID, int ServiceID) {
			using (Connect()) {
				try {
					using (Command(PROC_SERVICE_DEL)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(ServiceID, "@ServiceID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2072, "There was an error saving the data", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to remove the link between all users in a Group and a Service.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group to be used.</param>
		/// <param name="ServiceID">The public ID of the Service to which the link is to be created.</param>
		/// <param name="SecurityLevelID">The public ID of the SecurityLevel to which the link is to be created.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument DeleteGroupService(int GroupID, int ServiceID, int SecurityLevelID) {
			using (Connect()) {
				try {
					using (Command(PROC_SERVICE_DEL)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(ServiceID, "@ServiceID");
						AddSQLParameter(SecurityLevelID, "@SecurityLevelID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2072, "There was an error saving the data", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to remove the link all users in a Group and a Product.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group to be used.</param>
		/// <param name="ProductID">The public ID of the Product to which the link is to be created.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the delete
		/// </returns>
		public XmlDocument DeleteGroupProduct(int GroupID, int ProductID) {
			using (Connect()) {
				try {
					using (Command(PROC_PRODUCT_DEL)) {
						AddSQLParameter(GroupID, "@GroupID");
						AddSQLParameter(ProductID, "@ProductID");
						Execute();
					}
				} catch (Exception exc) {
					Error(2073, "There was an error saving the data", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to lock all users in a Group.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group to be used.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the update
		/// </returns>
		public XmlDocument LockGroup(int GroupID) {
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to unlock all users in a Group.
		/// </summary>
		/// <param name="GroupID">The public ID of the Group to be used.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the update
		/// </returns>
		public XmlDocument UnlockGroup(int GroupID) {
			return this as XmlDocument;
		}
		#endregion
	}
}
