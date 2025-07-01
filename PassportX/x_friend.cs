using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

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
	20080222:	Starting point. Note that this has been included in the PassportX code in the short
				term and possibly could be refactored into a separate component.
	-------------------------------------------------------------------------------------------------	*/
	
namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// The Friend class implements
	/// 
	/// </summary>
	public class x_friend : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "friend";
		private const string ROOT_NAME_MULTI = "friends";
		private const int FRIEND_STATUS_INVITED = 1;
		private const int FRIEND_STATUS_ACCEPTED = 2;
		private const int FRIEND_STATUS_REJECTED = 3;
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_INSERT = "x_FriendAdd";
		private const string PROC_GET = "x_FriendGet";
		private const string PROC_UPDATE = "x_FriendUpdate";
		private const string PROC_DELETE = "x_FriendDelete";
		private const string PROC_LIST = "x_FriendList";
		private const string PROC_FIND = "x_FriendFind";
		private const string PROC_SEARCH = "x_FriendSearch";
		private const string PROC_FINDID = "x_FriendFindID";
		private const string PROC_COUNT = "x_FriendCount";
		private const string PROC_CONTACTS = "x_FriendContacts";
		// to be implemented...
		private const string PROC_FRIENDS = "x_FriendListPaged";
		private const string PROC_FRIENDSS = "x_FriendListPagedSorted";
		private const string PROC_NAME = "x_FriendGetName";
		private const string PROC_FIND_ADV = "x_FriendFindAdvanced";
		private const string PROC_SEARCH_ADV = "x_FriendSearchAdvanced";
		#endregion

		#region Constants - Error codes
		private const string ERROR_FRIEND = "8000";
		private const string ERROR_FRIEND_ADD = "8001";
		private const string ERROR_FRIEND_GET = "8002";
		private const string ERROR_FRIEND_UPDATE = "8003";
		private const string ERROR_FRIEND_DELETE = "8004";
		private const string ERROR_FRIEND_LIST = "8005";
		private const string ERROR_FRIEND_FIND = "8006";
		private const string ERROR_FRIEND_CONTACTS = "8007";
		#endregion

		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Friend class.
		/// </summary>
		/// <param name="DSN">Data provider connection string</param>
		public x_friend(string DSN) : base(DSN, ROOT_NAME) {
		}
		/// <summary>
		/// Constructor that specifies data provider type
		/// </summary>
		/// <param name="DSN">Data provider connection string</param>
		/// <param name="DBType">Data provider type</param>
		public x_friend(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Get a list of friends and their details
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <returns>The friends xml</returns>
		public XmlDocument Friends(int PersonID) {
			Tag = ROOT_NAME_MULTI;	// set the result xml to have a "Friends" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						AddSQLParameter(PersonID, "PersonID");
						readFriends(true);
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_LIST, "There was an error getting friends list", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Add a friend
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <param name="FriendID">The friend's identifier</param>
		/// <returns>The friend xml</returns>
		public XmlDocument Add(int PersonID, int FriendID) {
			return Add(PersonID, FriendID, FRIEND_STATUS_INVITED);
		}
		/// <summary>
		/// Add a friend
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <param name="FriendID">The friend's identifier</param>
		/// <param name="StatusID">The friend's status identifier</param>
		/// <returns>The friend xml</returns>
		public XmlDocument Add(int PersonID, int FriendID, int StatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_INSERT)) {
						AddSQLParameter(PersonID, "PersonID");
						AddSQLParameter(FriendID, "FriendID");
						AddSQLParameter(StatusID, "StatusID");
						readFriend();
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_ADD, "There was an error adding a friend", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Get a friend
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <param name="FriendID">The friend's identifier</param>
		/// <returns>The friend xml</returns>
		public XmlDocument Get(int PersonID, int FriendID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(PersonID, "PersonID");
						AddSQLParameter(FriendID, "FriendID");
						readFriend();
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_GET, "There was an error getting a friend", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Update a friend
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <param name="FriendID">The friend's identifier</param>
		/// <param name="StatusID">The friend's status identifier</param>
		/// <returns>The friend xml</returns>
		public XmlDocument Update(int PersonID, int FriendID, int StatusID) {
			using (Connect()) {
				try {
					using (Command(PROC_UPDATE)) {
						AddSQLParameter(PersonID, "PersonID");
						AddSQLParameter(FriendID, "FriendID");
						AddSQLParameter(StatusID, "StatusID");
						readFriend();
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_UPDATE, "There was an error updating a friend", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Delete a friend
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <param name="FriendID">The friend's identifier</param>
		/// <returns>The friend xml</returns>
		public XmlDocument Delete(int PersonID, int FriendID) {
			using (Connect()) {
				try {
					using (Command(PROC_DELETE)) {
						AddSQLParameter(PersonID, "PersonID");
						AddSQLParameter(FriendID, "FriendID");
						Execute();
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_DELETE, "There was an error deleting a friend", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Get a list of friends
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <returns>The friends xml</returns>
		public XmlDocument List(int PersonID) {
			Tag = ROOT_NAME_MULTI;	// set the result xml to have a "Friends" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						AddSQLParameter(PersonID, "PersonID");
						readFriends();
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_LIST, "There was an error getting friends list", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Find a friend
		/// </summary>
		/// <param name="FriendEmail">The friend's email</param>
		/// <returns>The friend xml</returns>
		public XmlDocument Find(string FriendEmail) {
			using (Connect()) {
				try {
					using (Command(PROC_FIND)) {
						AddSQLParameter(FriendEmail, "FriendEmail", 128);
						using (Reader()) {
							if (Read()) {
								AddAttribute("id", "UserID");
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_FIND, "There was an error finding a friend", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Find a friend by ID
		/// </summary>
		/// <param name="FriendID">The friend's identifier</param>
		/// <returns>The friend xml</returns>
		public XmlDocument FindID(int FriendID) {
			using (Connect()) {
				try {
					using (Command(PROC_FINDID)) {
						AddSQLParameter(FriendID, "FriendID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("id", "UserID");
								AddAttribute("email", "UserName");
								AddAttribute("altemail", "EMail");
								AddAttribute("fullname", "Name");
								AddAttribute("cellphone", "CellPhone");
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_FIND, "There was an error finding a friend", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Search for a friend
		/// </summary>
		/// <param name="FriendEmail">The friend's partial email</param>
		/// <returns>The friend xml</returns>
		public XmlDocument Search(string FriendEmail) {
			Tag = ROOT_NAME_MULTI;	// set the result xml to have a "Friends" root element
			using (Connect()) {
				try {
					if (FriendEmail == "%%")
						throw new Exception("Search string cannot be empty.");
					using (Command(PROC_SEARCH)) {
						AddSQLParameter(FriendEmail, "Friend", 128);
						using (Reader()) {
							XmlElement friend, friends = this.SelectSingleNode(String.Concat("/", ROOT_NAME_MULTI)) as XmlElement;
							while (Read()) {
								friend = this.CreateElement(ROOT_NAME) as XmlElement;
								friend.SetAttribute("id", GetValue("UserID"));
								friend.SetAttribute("email", GetValue("UserName"));
								friend.SetAttribute("fullname", GetValue("Name"));
								friend.SetAttribute("cellphone", GetValue("CellPhone"));
								friends.AppendChild(friend);
							}
						}
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_FIND, "There was an error finding a friend", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Get a count of friends
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <returns>The friends count</returns>
		public int Count(int PersonID) {
			Tag = ROOT_NAME_MULTI;	// set the result xml to have a "Friends" root element
			int retval = -1;
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						AddSQLParameter(PersonID, "PersonID");
						retval = (int)ExecuteScalar();
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_LIST, "There was an error getting friends list", exc);
				}
				return retval;
			}
		}

		/// <summary>
		/// Get a list of contact friends and their details
		/// </summary>
		/// <param name="PersonID">The person's identifier</param>
		/// <returns>The friends xml</returns>
		public XmlDocument Contacts(int PersonID) {
			Tag = ROOT_NAME_MULTI;	// set the result xml to have a "Friends" root element
			using (Connect()) {
				try {
					using (Command(PROC_CONTACTS)) {
						AddSQLParameter(PersonID, "PersonID");
						readContacts(true);
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_CONTACTS, "There was an error getting friends list", exc);
				}
				return this as XmlDocument;
			}
		}

		/// <summary>
		/// Get a list of contact friends and their details
		/// </summary>
		/// <param name="PersonID">The person's identifier (typically email address)</param>
		/// <returns>The friends xml</returns>
		public XmlDocument Contacts(string PersonID) {
			Tag = ROOT_NAME_MULTI;	// set the result xml to have a "Friends" root element
			using (Connect()) {
				try {
					using (Command(PROC_CONTACTS)) {
						AddSQLParameter(PersonID, "PersonID", 64);
						readContacts(true);
					}
				}
				catch (Exception exc) {
					Error(ERROR_FRIEND_CONTACTS, "There was an error getting friends list", exc);
				}
				return this as XmlDocument;
			}
		}

		#endregion

		#region Private methods
		private void readFriend() {
			using (Reader()) {
				if (Read()) {
					AddAttribute("uid", "PersonID");
					AddAttribute("id", "FriendID");
					AddAttribute("statusid", "StatusID");
					AddAttribute("status", "Status");
				}
			}
		}
		private void readFriends() {
			readFriends(false);
		}
		private void readFriends(bool wantdetails) {
			using (Reader()) {
				XmlElement friend, friends = this.SelectSingleNode(String.Concat("/", ROOT_NAME_MULTI)) as XmlElement;
				while (Read()) {
					friend = this.CreateElement(ROOT_NAME) as XmlElement;
					friend.SetAttribute("uid", GetValue("PersonID"));
					friend.SetAttribute("id", GetValue("FriendID"));
					friend.SetAttribute("statusid", GetValue("StatusID"));
					if (wantdetails) {
						friend.SetAttribute("status", GetValue("Status"));
						friend.SetAttribute("fullname", GetValue("Name"));
						friend.SetAttribute("email", GetValue("UserName"));
						friend.SetAttribute("altemail", GetValue("EMail"));
						friend.SetAttribute("cellphone", GetValue("CellPhone"));
					}
					friends.AppendChild(friend);
				}
			}
		}
		private void readContacts(bool wantdetails) {
			using (Reader()) {
				XmlElement friend, friends = this.SelectSingleNode(String.Concat("/", ROOT_NAME_MULTI)) as XmlElement;
				while (Read()) {
					friend = this.CreateElement(ROOT_NAME) as XmlElement;
					friend.SetAttribute("uid", GetValue("PersonID"));
					//friend.SetAttribute("id", GetValue("FriendID"));
					if (wantdetails) {
						friend.SetAttribute("fullname", GetValue("Name"));
						friend.SetAttribute("email", GetValue("EMail"));
						friend.SetAttribute("nickname", GetValue("NickName"));
					}
					friends.AppendChild(friend);
				}
			}
		}
		#endregion
	}
}