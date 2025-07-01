using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Xml;

using XXBoom.MachinaX.PassportX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2012-06-15	
	Status:		release	
	Version:	4.0.2
	Build:		20130715
	Target:		Microsoft SQL Server 2008
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20120615:	Starting point from Ididthatad.
	20130715:	Moved implementation from XXService (common to XXService implmentations)
				Set namespace to MachinaX.PassportX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace MachinaX.PassportX {
	/// <summary>MachinaX common implementation</summary>
	[WebService(Name = "PassportX Admin Services",
				Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX",	// NB: Needs to be constant accross implementations - called from cmsX.dll
				Description = "PassportX Authentication Web Service")]
	public class Admin : XXBoom.MachinaX.PassportX.PassportServiceX.PassportX {
		#region Invisible properties
		#endregion

		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default Constructor 
		/// </summary>
		public Admin() : base() {
			_Group = new x_group(DSN);
			_UserStatus = new x_userStatus(DSN);
			_Profile = new x_oldprofile(DSN);
		}
		#endregion

		#region User web methods
		/// <summary>
		/// Validate a user's login information, and returns an XML document containing a Token to the user which must be used 
		/// throughout the session to validate the user when accessing any system the PassportX controls access to.
		/// </summary>
		/// <param name="UserName">The user's login name.</param>
		/// <param name="Password">The user's password.</param>
		/// <returns>
		/// XmlDocument object, containing information on the result of the login, and any related error messages.
		/// <p>XML Document returned is in the following format:<br>
		/// &lt;User Token=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/User&gt;<br><br>
		/// If the login is successful, the ResultCode will be 0 (zero), and the Token will contain the value that must
		/// be used for the session to validate the user for any functionality. If not, the ResultCode will contain
		/// a non-zero number indicating the error code and Description any related message.
		/// </returns>
		[WebMethod] public override XmlDocument Login(string UserName, string Password) {
			XmlDocument login = null;
			try {
				login = _User.Login(UserName, Password);
				XmlElement user = (XmlElement) login.SelectSingleNode("/User");
				if (user != null) {
					int userid = Convert.ToInt32(user.GetAttribute("UserID"));
					XmlDocument groupdoc = _User.GetUserGroups(userid, false);
					user.InnerXml = user.InnerXml + groupdoc.SelectSingleNode("/User/Groups").OuterXml;
				}
				return login;
			} catch {
				return login;
			}
		}
		
		
		/// <summary>
		/// Used to register a user on the PassportX system. This method will only be called once for a user, when
		/// they register to use the system. The system will assign a User ID to the user, which will be returned,
		/// but which the user should not know - it is for internal referencing only. All updates associated with
		/// the user will be done using the User ID. This method will most likely be called by a user interface
		/// where the user has the option to register to make use of the online services which the PassportX controls
		/// access to.
		/// </summary>
		/// <param name="UserName">The login name the user has chosen. This name must be unique in the system. The Register routine will check for this, and if it is not unique, will return an appropriate error message.</param>
		/// <param name="Password">The password or PIN the user has chosen. No rules have been associated with this field, although it cannot be empty.</param>
		/// <param name="FirstName">The user's firstname.</param>
		/// <param name="Surname">The user's surname.</param>
		/// <param name="EMail">The user's personal e-mail address.</param>
		/// <param name="TelNo">The user's personal telephone number.</param>
		/// <param name="CellNo">The user's mobile telephone number.</param>
		/// <returns>
		/// Returns an XmlDocument object, with the following layout:<br>
		/// &lt;User UserID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/User&gt;<br><br>
		/// If the save is successful, the ResultCode will be 0 (zero) and the UserID attribute will contain the value assigned
		/// to the user by the PassportX system. If not, the Result will contain the error code and message or reason the
		/// save failed, as well as all the details the user supplied, except for the password.
		/// </returns>
		[WebMethod] public XmlDocument RegisterUser(string Token, string UserName, string Password, string FirstName, string Surname, string EMail, string TelNo, string CellNo) {
			XmlDocument registerUser, getProfiles, validUser;
			XmlNode xnUser;
			validUser = ValidateToken(Token, "administer", "RegisterUser");
			if (validUser == null) {
				registerUser = _User.RegisterUser(UserName, Password, FirstName, Surname, EMail, TelNo, CellNo);
				if (registerUser.SelectSingleNode("/User/Result/ResultCode").InnerText == "0") {
					xnUser = registerUser.SelectSingleNode("/User");
					getProfiles = GetProfileList();
					xnUser.InnerXml = xnUser.InnerXml + getProfiles.OuterXml;
				}
			} else {
				registerUser = new XmlDocument();
				registerUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return registerUser;
		}
		
		
		/// <summary>
		/// Retrieves a specific user's details for display or editing on a user interface.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument GetUser(string Token, int UserID) {
			XmlDocument getUser;
			XmlDocument validUser;
			XmlNode xnUser, xnStat;
			XmlAttribute xaPersonStatusID;
			validUser = ValidateToken(Token, "administer", "GetUser");
			if (validUser == null)
			{
				getUser = _User.GetUser(UserID);
				xnUser = getUser.SelectSingleNode("/User");
				xnUser.InnerXml = "<Result><ResultCode>0</ResultCode><Description/></Result>" + xnUser.InnerXml;
				xnStat = getUser.SelectSingleNode("/User/Status");
				xnStat.InnerText = getUser.SelectSingleNode("/User/Status/Description").InnerText;
				xaPersonStatusID = (XmlAttribute)xnStat.Attributes.GetNamedItem("PersonStatusID");
				xnUser.Attributes.Append(xaPersonStatusID);
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return getUser;
		}

        /// <summary>
        /// Used to update a User in the PassportX database.
        /// </summary>
        /// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
        /// <param name="Others..."></param>
        /// <returns>
        /// </returns>
        [WebMethod]
        public XmlDocument UpdateUserPassword(int UserID, string Password) {
            XmlDocument updateUser, savePass;
            updateUser = new XmlDocument();
            savePass = _User.UpdatePassword(UserID, Password);
            if (savePass.SelectSingleNode("//Result/ResultCode").InnerText == "0")
                updateUser = _User.GetUser(UserID);//GetUserRights(Token, UserID, "no");
            else
                updateUser = savePass;
            return updateUser;
        }
        /// <summary>
        /// Used to update a User in the PassportX database.
        /// </summary>
        /// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
        /// <param name="Others..."></param>
        /// <returns>
        /// </returns>
        [WebMethod]
        public XmlDocument UpdateUserDetails(int UserID, string UserName, string FirstName,
                                      string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID, string Safeguard) {
            XmlDocument updateUser, saveUser;
            updateUser = new XmlDocument();
            saveUser = _User.SaveUser(UserID, UserName, FirstName, Surname, EMail, TelNo, CellNo, PersonStatusID);
            if (saveUser.SelectSingleNode("//Result/ResultCode").InnerText == "0") {
                if (Safeguard == "no")
                    _User.ClearLock(UserID);
                else
                    _User.SetLock(UserID);
                updateUser = _User.GetUser(UserID);
            } else
                updateUser = saveUser;
            return updateUser;
        }
		
		/// <summary>
		/// Used to update a User in the PassportX database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="Others..."></param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument UpdateUser(string Token, int UserID, string UserName, string FirstName,
												  string Surname, string EMail, string TelNo, string CellNo, int PersonStatusID, string Safeguard) {
			XmlDocument updateUser, validUser, saveUser;
			updateUser = new XmlDocument();
			validUser = ValidateToken(Token, "administer", "UpdateUser");
			if (validUser == null) {
				saveUser = _User.SaveUser(UserID, UserName,  FirstName, Surname, EMail, TelNo, CellNo, PersonStatusID);
				if (saveUser.SelectSingleNode("//Result/ResultCode").InnerText == "0") {
					if (Safeguard == "no")
						_User.ClearLock(UserID);
					else
						_User.SetLock(UserID);
					updateUser = GetUserRights(Token, UserID, "no");
				}
				else
					updateUser = saveUser;
			}
			else
				updateUser.LoadXml("<User>" + validUser.OuterXml + "</User>");
			return updateUser;
		}
		
		
		/// <summary>
		/// Remove a user from the PassportX database. All records associated with the user will also be removed
		/// ie. all service and product links, group links and activity logged.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID, used to uniquely identify a user.</param>
		/// <returns>A boolean value indicating whether the Delete was successful or not.</returns>
		[WebMethod] public XmlDocument RemoveUser(string Token, int UserID) {
			XmlDocument removeUser = new XmlDocument();
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveUser");
			if (validUser == null) {
				removeUser.LoadXml("<User><Result><ResultCode>0</ResultCode><Description/></Result></User>");
				if (!_User.RemoveUser(UserID)) {
					removeUser.SelectSingleNode("/User/Result/ResultCode").InnerText = "2201";
					removeUser.SelectSingleNode("/User/Result/Description").InnerText = "There was an error removing the User";
				}
			} else {
				removeUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return removeUser;
		}
		
		
		/// <summary>
		/// Used to add a User to a Group in the PassportX database. The system will check that the user is not
		/// already a member of the Group before adding the record. This will not cause the method to fail.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the User in the PassportX database.</param>
		/// <param name="GroupID">The internal ID of the Group in the PassportX database.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument AddUserProfile(string Token, int UserID, int GroupID, string WantItems) {
			XmlDocument saveUserGroup, validUser;
			saveUserGroup = new XmlDocument();
			validUser = ValidateToken(Token, "administer", "AddUserProfile");
			if (validUser == null) {
				if (_User.SaveUserProfile(UserID, GroupID))
					GetUserRights(Token, UserID, WantItems);
				else
					saveUserGroup.LoadXml("<User><Result><ResultCode>2203</ResultCode><Description/></Result></User>");
			}
			else
				saveUserGroup.LoadXml("<User>" + validUser.OuterXml + "</User>");
			return saveUserGroup;
		}

		/// <summary>
		/// Used to remove a User from a Group in the PassportX database.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal ID of the User in the PassportX database.</param>
		/// <param name="GroupID">The internal ID of the Group in the PassportX database.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument RemoveUserProfile(string Token, int UserID, int GroupID, string WantItems) {
			XmlDocument deleteUserGroup, validUser;
			deleteUserGroup = new XmlDocument();
			validUser = ValidateToken(Token, "administer", "RemoveUserProfile");
			if (validUser == null) {
				if (_User.DeleteUserProfile(UserID, GroupID))
					deleteUserGroup = GetUserRights(Token, UserID, WantItems);
				else
					deleteUserGroup.LoadXml("<User><Result><ResultCode>2206</ResultCode><Description/></Result></User>");
			}
			else
				deleteUserGroup.LoadXml("<User>" + validUser.OuterXml + "</User>");
			return deleteUserGroup;
		}
		
		
		/// <summary>
		/// Returns a list of all person status' in the PassportX database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;PersonStatusList&gt;<br>
		/// &nbsp;&lt;PersonStatus PersonStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/PersonStatus&gt;<br>
		/// &lt;/PersonStatusList&gt;
		/// </returns>
		[WebMethod] public XmlDocument GetPersonStatusList() {
			XmlDocument GetPersonStatusList = new XmlDocument();
			XmlDocument StatusList = _UserStatus.GetPersonStatusList();
			if (StatusList.SelectSingleNode("//Result/ResultCode") == null) {	// null indicates OK
				GetPersonStatusList.LoadXml("<Status><Result><ResultCode>0</ResultCode><Description/>" + StatusList.InnerXml + "</Result></Status>");
			} else {
				GetPersonStatusList.LoadXml("<Status>" + StatusList.InnerXml + "</Status>");
			}
			_UserStatus = null;
			return GetPersonStatusList;
		}


        /// <summary>
        /// Retrieves a groups for a user.
        /// </summary>
        /// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
        /// <param name="UserID">The User ID.</param>
        /// <param name="WantItems">Flag to indicate if profiles returned in item nodes (or as elements).</param>
        /// <returns>
        /// </returns>
        [WebMethod]
        public XmlDocument GetUserProfile(int UserID) {
            XmlDocument getUser = _User.GetUserGroups(UserID, true);
            return getUser;
        }

		/// <summary>
		/// Retrieves a groups for a user.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The User ID.</param>
		/// <param name="WantItems">Flag to indicate if profiles returned in item nodes (or as elements).</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument GetUserProfiles(string Token, int UserID, string WantItems) {
			XmlDocument getUser;
			XmlDocument validUser = ValidateToken(Token, "administer", "GetUserProfiles");
			if (validUser == null) {
				getUser = _User.GetUserGroups(UserID, (WantItems=="yes"));
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return getUser;
		}
		
		
		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument SearchUserList(string Token, int GroupID, string SearchName, string SearchNo) {
			XmlDocument getUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SearchUserList");
			if (validUser == null) {
				string thisname = (SearchName != "")? SearchName : "<none>";
				string thisno = (SearchNo != "")? SearchNo : "<none>";
				getUser = _User.SearchUserList(GroupID, thisname, thisno);
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<Users>" + validUser.OuterXml + "</Users>");
				validUser = null;
			}
			return getUser;
		}
		
		
		/// <summary>
		/// Retrieves a users from a group (or all).
		/// Like SearchUserList, but returns an item list
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument FindUsers(string Token, int GroupID, string SearchName, string SearchNo) {
			XmlDocument getUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SearchUserList");
			if (validUser == null) {
				string thisname = (SearchName != "")? SearchName : "<none>";
				string thisno = (SearchNo != "")? SearchNo : "<none>";
				getUser = _User.FindUsers(GroupID, thisname, thisno);
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<Users>" + validUser.OuterXml + "</Users>");
				validUser = null;
			}
			return getUser;
		}
		
		
		/// <summary>
		/// Retrieves a users from a group (or all). Similar to SearchUserList, but searches on more fields
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument SearchUserListAll(string Token, int GroupID, string SearchUserID, string SearchUserName, string SearchFirstName, string SearchSurname, string SearchCellNo, string SearchTelNo, string SearchEmail) {
			XmlDocument getUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SearchUserList");
			if (validUser == null) {
				string thisuserid = (SearchUserID != "")? SearchUserID : "<none>";
				string thisusername = (SearchUserName != "")? SearchUserName : "<none>";
				string thisfirstname = (SearchFirstName != "")? SearchFirstName : "<none>";
				string thissurname = (SearchSurname != "")? SearchSurname : "<none>";
				string thiscellno = (SearchCellNo != "")? SearchCellNo : "<none>";
				string thistelno = (SearchTelNo != "")? SearchTelNo : "<none>";
				string thisemail = (SearchEmail != "")? SearchEmail : "<none>";
				getUser = _User.SearchUserList(GroupID, thisuserid, thisusername, thisfirstname, thissurname, thiscellno, thistelno, thisemail);
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<Users>" + validUser.OuterXml + "</Users>");
				validUser = null;
			}
			return getUser;
		}
		
		/// <summary>
		/// Retrieves a users from a group (or all). Similar to SearchUserList, but searches on more fields
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument FindUsersAll(string Token, int GroupID, string SearchUserID, string SearchUserName, string SearchFirstName, string SearchSurname, string SearchCellNo, string SearchTelNo, string SearchEmail) {
			XmlDocument getUser;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SearchUserList");
			if (validUser == null) {
				string thisuserid = (SearchUserID != "")? SearchUserID : "<none>";
				string thisusername = (SearchUserName != "")? SearchUserName : "<none>";
				string thisfirstname = (SearchFirstName != "")? SearchFirstName : "<none>";
				string thissurname = (SearchSurname != "")? SearchSurname : "<none>";
				string thiscellno = (SearchCellNo != "")? SearchCellNo : "<none>";
				string thistelno = (SearchTelNo != "")? SearchTelNo : "<none>";
				string thisemail = (SearchEmail != "")? SearchEmail : "<none>";
				getUser = _User.FindUsers(GroupID, thisuserid, thisusername, thisfirstname, thissurname, thiscellno, thistelno, thisemail);
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<Users>" + validUser.OuterXml + "</Users>");
				validUser = null;
			}
			return getUser;
		}
		
		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="StartRow">The row number of the first row.</param>
		/// <param name="NumberRows">The number of rows to return.</param>
		/// <param name="SortCol">The name of the column to sort by.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument GetUsers(string Token, int GroupID, int StartRow, int PageRows, string SortCol) {
			XmlDocument getUsers;
			XmlDocument validUser;
			int RowTotal, PageNumber = StartRow/PageRows + 1;
			validUser = ValidateToken(Token, "administer", "GetUsersSort");
			if (validUser == null) {
				getUsers = (SortCol == "")? _User.GetUsers(GroupID, StartRow, PageRows) : _User.GetUsers(GroupID, StartRow, PageRows, SortCol);
				if (getUsers.SelectSingleNode("//ResultCode").InnerText == "0") {
					AddGroups(getUsers);
					RowTotal = System.Convert.ToInt32(getUsers.SelectSingleNode("/Users/@TotalRows").InnerText);
					AddPageResults(getUsers, GroupID, PageNumber, PageRows, RowTotal, SortCol);
				}
			} else {
				getUsers = new XmlDocument();
				getUsers.LoadXml ("<Users>" + validUser.OuterXml + "</Users>");
				validUser = null;
			}
			return getUsers;
		}
		/// <summary>
		/// Retrieves a users from a group (or all).
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The Group ID, or 0 if all.</param>
		/// <param name="StartRow">The row number of the first row.</param>
		/// <param name="NumberRows">The number of rows to return.</param>
		/// <param name="SortCol">The name of the column to sort by.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument GetUsersSort(string Token, int GroupID, int PageNumber, int PageRows, string SortCol) {
			XmlDocument getUsers;
			XmlDocument validUser;
			int StartRow, RowTotal;
			validUser = ValidateToken(Token, "administer", "GetUsersSort");
			if (validUser == null)
			{
				StartRow = ((PageNumber-1) * PageRows) + 1;
				getUsers = _User.GetUsers(GroupID, StartRow, PageRows, SortCol);
				if (getUsers.SelectSingleNode("//ResultCode").InnerText == "0") {
					AddGroups(getUsers);
					RowTotal = System.Convert.ToInt32(getUsers.SelectSingleNode("/Users/@TotalRows").InnerText);
					AddPageResults(getUsers, GroupID, PageNumber, PageRows, RowTotal, SortCol);
					}
			} else {
				getUsers = new XmlDocument();
				getUsers.LoadXml ("<Users>" + validUser.OuterXml + "</Users>");
				validUser = null;
			}
			return getUsers;
		}
		private void AddGroups(XmlDocument getUsers){
			XmlDocument getGroups = _Group.GetGroups();
			// now add groups node
			if (getGroups.SelectSingleNode("//ResultCode").InnerText == "0") {
				XmlNode thisGrp = getGroups.SelectSingleNode("//Groups");
				thisGrp.RemoveChild(thisGrp.SelectSingleNode("Result"));
				XmlNode xnGroups = getUsers.ImportNode(thisGrp, true);
				XmlNode xnUsers = getUsers.SelectSingleNode("//Users");
				xnUsers.AppendChild(xnGroups);
			}
		}
		private void AddPageResults(XmlDocument getUsers, int GroupID, int PageNumber, int PageRows, int RowTotal, string SortCol){
			int PageTotal = RowTotal / PageRows + ((RowTotal % PageRows > 0)? 1 :0);
			/*
			XmlNode xnPages = getUsers.CreateElement("pages");
			AddAttr(getUsers, xnPages, "GroupID", GroupID.ToString());
			AddAttr(getUsers, xnPages, "pageNumber", PageNumber.ToString());
			AddAttr(getUsers, xnPages, "pageLength", PageRows.ToString());
			AddAttr(getUsers, xnPages, "pageTotal", PageTotal.ToString());
			AddAttr(getUsers, xnPages, "orderColumn", SortCol);
			*/
			XmlElement xnPages = getUsers.CreateElement("pages");
			xnPages.SetAttribute("GroupID", GroupID.ToString());
			xnPages.SetAttribute("pageNumber", PageNumber.ToString());
			xnPages.SetAttribute("pageLength", PageRows.ToString());
			xnPages.SetAttribute("pageTotal", PageTotal.ToString());
			xnPages.SetAttribute("orderColumn", SortCol);

			XmlNode xnUsers = getUsers.SelectSingleNode("//Users");
			xnUsers.AppendChild(xnPages);
		}
		
		
		/// <summary>
		/// Retrieves a specific user's details and rights.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="UserID">The internal User ID, which is used to uniquely identify a user.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument GetUserRights(string Token, int UserID, string WantItems) {
			XmlDocument getUser, getProfiles, getGroups, validUser;
			XmlNode xnUser, xnGroups;
			validUser = ValidateToken(Token, "administer", "GetUserRights");
			if (validUser == null) {
				getUser = _User.GetUserRights(UserID);
				
				// need to do some error handling at this point...
				xnUser = getUser.SelectSingleNode("/User");
				getProfiles = GetProfileList();
				getGroups = GetUserProfiles(Token, UserID, WantItems);
				xnGroups = getGroups.SelectSingleNode("/User/Groups");
				xnUser.InnerXml = xnUser.InnerXml + xnGroups.OuterXml + getProfiles.OuterXml;
			} else {
				getUser = new XmlDocument();
				getUser.LoadXml ("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return getUser;
		}
		
		
		/// <summary>
		/// Sends the user's pin/password to their cellphone. This is the only method that implements any
		/// external system, and is dependant on that service to run correctly.
		/// </summary>
		/// <param name="Token">The Token of the Service/Application calling the method, which has already logged on, and has a valid session. The SMS Gateway will validate this token when the SMS is sent.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <returns>A boolean value indicating whether the SMS was sent successfully.</returns>
		[WebMethod]	public XmlDocument SendPassword(string Token, int UserID) {
			XmlDocument validUser;
			XmlDocument sendPassword = new XmlDocument();
			validUser = ValidateToken(Token, "administer", "SendPassword");
			if (validUser == null) {
				try {
					sendPassword = GetUser(Token, UserID);
					if (sendPassword.SelectSingleNode("/User/Result/ResultCode").InnerText == "0") {
						if (!_User.SendPassword(Token, UserID)) {
							sendPassword.SelectSingleNode("/User/Result/ResultCode").InnerText = "3000";
							sendPassword.SelectSingleNode("/User/Result/Description").InnerText = "Error sending the password";
						}
					}
				}
				catch (Exception) {
					sendPassword.LoadXml("<Users><Result><ResultCode>0</ResultCode><Description/></Result></Users>");
					sendPassword.SelectSingleNode("/Users/Result/ResultCode").InnerText = "3001";
					sendPassword.SelectSingleNode("/Users/Result/Description").InnerText = "Error sending the password";
				}
			} else {
				sendPassword.LoadXml("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return sendPassword;
		}
		
		/// <summary>
		/// Sends a SMS message to the user's cellphone.
		/// </summary>
		/// <param name="Token">The user Token from the Service/Application calling the method. The SMS Gateway will validate this token when the SMS is sent.</param>
		/// <param name="UserID">The internal User ID of the user.</param>
		/// <param name="Message">The message to be sent to the user.</param>
		/// <returns>A boolean value indicating whether the SMS was sent successfully.</returns>
		[WebMethod]	public XmlDocument SendMessage(string Token, int UserID, string Message) {
			XmlDocument validUser, userXml;
			validUser = ValidateToken(Token, "administer", "SendPassword");
			if (validUser == null) {
				userXml = _User.SendMessage(UserID, "", Message);
			} else {
				userXml = new XmlDocument();
				userXml.LoadXml("<User>" + validUser.OuterXml + "</User>");
				validUser = null;
			}
			return userXml;
		}
		
		#endregion

		#region Profile web methods
		/// <summary>
		/// Used to add/update a Group record in the PassportX database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group record, used to uniquely identify the record in the PassportX database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Group. This must be unqiue in the PassportX database.</param>
		/// <param name="GroupStatusID">The ID of the GroupStatus indicating the status of this Group record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save, in the following format:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 (zero) and the GroupID will contain the
		/// value assigned to the record by the PassportX. If not, the Result will contain the error code and description or
		/// reason the save failed.
		/// </returns>
		[WebMethod] public XmlDocument SaveProfile(string Token, int GroupID, string Description, int GroupStatusID) {
			XmlDocument SaveProfile;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveProfile");
			if (validUser == null) {
				SaveProfile = _Profile.SaveProfile(GroupID, Description, GroupStatusID);
			} else {
				SaveProfile = new XmlDocument();
				SaveProfile.LoadXml ("<Profile>" + validUser.OuterXml + "</Profile>");
				validUser = null;
			}
			if (SaveProfile.SelectSingleNode("/Profile/Result/ResultCode").InnerText != "0")
				return SaveProfile;
			else
				return GetProfileList();
		}


		/// <summary>
		/// Return details for a specific Group in the PassportX database.
		/// </summary>
		/// <param name="GroupID">The internal ID of the Group record in the PassportX database.</param>
		/// <returns>
		/// Returns an XmlDocument object with the following layout:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;Status GroupStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &lt;/Group&gt;
		/// </returns>
		[WebMethod] public XmlDocument GetProfile(string Token, int GroupID) {
			XmlDocument getProfile, getProfileRights;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetProfile");
			if (validUser == null) {
				XmlNode xnRights, xnProfile;
				getProfile = _Profile.GetProfile(GroupID);
				if (getProfile.SelectSingleNode("/Profile/Result/ResultCode").InnerText == "0") {
					getProfileRights = _Profile.GetProfileRightsList(GroupID);
					if (getProfileRights.SelectSingleNode("/Profiles/Result/ResultCode").InnerText == "0") {
						xnRights = getProfileRights.SelectSingleNode("/Profiles/Profile");
						xnProfile = getProfile.SelectSingleNode("/Profile");
						if (xnRights != null && xnProfile != null)
							xnProfile.InnerXml = xnProfile.InnerXml + xnRights.InnerXml;
					}
				}
			} else {
				getProfile = new XmlDocument();
				getProfile.LoadXml("<Profile>" + validUser.OuterXml + "</Profile>");
				validUser = null;
			}
			return getProfile;
		}

		/// <summary>
		/// Returns a list of all groups in the PassportX database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;Groups&gt;<br>
		/// &nbsp;&lt;Group GroupID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;Status GroupStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;/Status&gt;<br>
		/// &nbsp;&lt;/Group&gt;<br>
		/// &lt;/Groups&gt;
		/// </returns>
		[WebMethod] public XmlDocument GetProfileList() {
			XmlDocument getProfileList = _Profile.GetProfileList();
			return getProfileList;
		}

		/// <summary>
		/// Used to completely delete a Group from the PassportX database. The system will also remove any links
		/// between any users and the group, and remove them as well.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group record in the PassportX database.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the remove, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the delete is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the delete failed.
		/// </returns>
		[WebMethod] public XmlDocument RemoveProfile(string Token, int GroupID) {
			XmlDocument removeProfile;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "RemoveProfile");
			if (validUser == null) {
				removeProfile = _Profile.RemoveProfile(GroupID);
			} else {
				removeProfile = new XmlDocument();
				removeProfile.LoadXml ("<Profile>" + validUser.OuterXml + "</Profile>");
			}
			if (removeProfile.SelectSingleNode("/Profile/Result/ResultCode").InnerText != "0")
				return removeProfile;
			else
				return GetProfileList();
		}

		/// <summary>
		/// Method used to link a Profile to a Service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <param name="ServiceID">The internal ID of the Service to which the link is to be created.</param>
		/// <param name="SecurityLevelID">The internal ID of the Security Level that is to be set for all users linked to the Service.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save, in the following format:<br>
		/// &lt;Group&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the save is successful, the Result will be 0 (zero). If not, the ResultCode will contain the error code and message
		/// or reason the undelete failed.
		/// </returns>
		[WebMethod] public XmlDocument SaveProfileService(string Token, int GroupID, int ServiceID, int SecurityLevelID) {
			XmlDocument saveProfileService;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "SaveProfileService");
			if (validUser == null)
			{
				saveProfileService = _Profile.SaveProfileService(GroupID, ServiceID, SecurityLevelID);
			} else {
				saveProfileService = new XmlDocument();
				saveProfileService.LoadXml ("<Profile>" + validUser.OuterXml + "</Profile>");
				validUser = null;
			}
			return saveProfileService;
		}
		

		/// <summary>
		/// Method used to remove the link between a Profile and a Service.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group to be used.</param>
		/// <param name="ServiceID">The internal ID of the Service to which the link is to be created.</param>
		/// <param name="SecurityLevelID">The internal ID of the SecurityLevel to which the link is to be created.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument DeleteProfileService(string Token, int GroupID, int ServiceID, int SecurityLevelID) {
			XmlDocument validUser, deleteProfileService, getProfileRights;
			validUser = ValidateToken(Token, "administer", "DeleteProfileService");
			if (validUser == null) {
				XmlNode xnRights, xnProfile;
				deleteProfileService = _Profile.DeleteProfileService(GroupID, ServiceID, SecurityLevelID);
				if (deleteProfileService.SelectSingleNode("/Profile/Result/ResultCode").InnerText == "0") {
					deleteProfileService = _Profile.GetProfile(GroupID);
					if (deleteProfileService.SelectSingleNode("/Profile/Result/ResultCode").InnerText == "0") {
						getProfileRights = _Profile.GetProfileRightsList(GroupID);
						if (getProfileRights.SelectSingleNode("/Profiles/Result/ResultCode").InnerText == "0") {
							xnRights = getProfileRights.SelectSingleNode("/Profiles/Profile");
							xnProfile = deleteProfileService.SelectSingleNode("/Profile");
							if (xnRights != null && xnProfile != null)
								xnProfile.InnerXml = xnProfile.InnerXml + xnRights.InnerXml;
						}
					}
				}
			} else {
				deleteProfileService = new XmlDocument();
				deleteProfileService.LoadXml ("<Profile>" + validUser.OuterXml + "</Profile>");
				validUser = null;
			}
			return deleteProfileService;
		}
		
		/// <summary>
		/// Used to retrieve a list of all services related to a selected product.
		/// </summary>
		/// <param name="ProductID">The internal ID of the Product record in the PassportX database.</param>
		/// <returns>
		/// </returns>
		[WebMethod] public XmlDocument GetProductServiceList(string Token, int ProductID) {
			XmlDocument getServiceList;
			XmlDocument validUser;
			validUser = ValidateToken(Token, "administer", "GetProductServiceList");
			if (validUser == null) {
				getServiceList = GetServiceList(ProductID);
			} else {
				getServiceList = new XmlDocument();
				getServiceList.LoadXml ("<Products>" + validUser.OuterXml + "</Products>");
				validUser = null;
			}
			return getServiceList;
		}

		/// <summary>
		/// Used to retrieve a list of all services related to a selected product.
		/// </summary>
		/// <param name="ProductID">The internal ID of the Product record in the PassportX database.</param>
		/// <returns>
		/// </returns>
		internal XmlDocument GetServiceList(int ProductID) {
			XmlDocument getServiceList = new XmlDocument();
			getServiceList.LoadXml("<Products><Result><ResultCode>0</ResultCode><Description/></Result></Products>");
			using (SqlConnection gkdb = new SqlConnection(DSN)) {
				try {
					gkdb.Open();
					SqlCommand cmdProduct = new SqlCommand("um_GetProductServiceRightList", gkdb);
					cmdProduct.CommandType = CommandType.StoredProcedure;
					SqlParameter parProductID = new SqlParameter("@ProductID", SqlDbType.Int);
					parProductID.Value = ProductID;
					cmdProduct.Parameters.Add(parProductID);
					SqlDataReader rdrProduct = cmdProduct.ExecuteReader(CommandBehavior.CloseConnection);
					
					int lastproduct = -1, thisproduct = ProductID;
					int lastservice = -1, thisservice = 0;
					
					XmlNode xnProducts, xnProduct, xnService, xnStatus;
					XmlAttribute xaName, xaId, xaType;
					xnProducts = getServiceList.SelectSingleNode("/Products");
					xnService = xnProduct = xnProducts;
					while (rdrProduct.Read()) {
						thisproduct = System.Convert.ToInt32(rdrProduct.GetSqlValue(rdrProduct.GetOrdinal("ProductID")).ToString());
						thisservice = System.Convert.ToInt32(rdrProduct.GetSqlValue(rdrProduct.GetOrdinal("ServiceID")).ToString());
						// add new product parent
						if (thisproduct != lastproduct) {
							xnProduct = getServiceList.CreateElement("part");
							xaType = getServiceList.CreateAttribute("type");
							xaType.InnerText = "Product";
							xaId = getServiceList.CreateAttribute("id");
							xaId.InnerText = thisproduct.ToString();
							xaName = getServiceList.CreateAttribute("name");
							xaName.InnerText = rdrProduct.GetString(rdrProduct.GetOrdinal("ProductDesc"));
							
							xnProduct.Attributes.Append(xaId);
							xnProduct.Attributes.Append(xaType);
							xnProduct.Attributes.Append(xaName);
							xnProduct = xnProducts.AppendChild(xnProduct);
							lastproduct = thisproduct;
							lastservice = -1;
						}
						if (thisservice != lastservice) {
							xnService = getServiceList.CreateElement("part");
							xaType = getServiceList.CreateAttribute("type");
							xaType.InnerText = "Service";
							xaId = getServiceList.CreateAttribute("id");
							xaId.InnerText = thisservice.ToString();
							xaName = getServiceList.CreateAttribute("name");
							xaName.InnerText = rdrProduct.GetString(rdrProduct.GetOrdinal("ServiceDesc"));
							xnService.Attributes.Append(xaType);
							xnService.Attributes.Append(xaId);
							xnService.Attributes.Append(xaName);
							xnProduct.AppendChild(xnService);
							lastservice = thisservice;
						}
						xnStatus = getServiceList.CreateElement("part");
						xaType = getServiceList.CreateAttribute("type");
						xaType.InnerText = "SecurityLevel";
						xaId = getServiceList.CreateAttribute("id");
						xaId.InnerText = rdrProduct.GetSqlValue(rdrProduct.GetOrdinal("SecurityLevelID")).ToString();
						xaName = getServiceList.CreateAttribute("name");
						xaName.InnerText = rdrProduct.GetString(rdrProduct.GetOrdinal("SecurityLevelDesc"));
	
						xnStatus.Attributes.Append(xaType);
						xnStatus.Attributes.Append(xaId);
						xnStatus.Attributes.Append(xaName);
						xnService.AppendChild(xnStatus);
					}
					rdrProduct.Close();
					rdrProduct = null;
					parProductID = null;
					cmdProduct = null;
					gkdb.Close();
				}
				catch (Exception exc) {
					getServiceList.SelectSingleNode("/Products/Result/ResultCode").InnerText = "2039";
					getServiceList.SelectSingleNode("/Products/Result/Description").InnerText = "There was an error retrieving the Product Service list - " + exc.Source + " - " + exc.Message + "[" + exc.StackTrace + "]";
				}
			}	
			return getServiceList;
		}

		#endregion
		
		#region Group web methods
		/// <summary>
		/// Used to add/update a Group record in the PassportX database. Will check for the existence
		/// of a record, before adding a new record.
		/// </summary>
		/// <param name="Token">The login Token of the user executing the method, used to validate that the user is allowed to execute the method.</param>
		/// <param name="GroupID">The internal ID of the Group record, used to uniquely identify the record in the PassportX database. If the value is 0 (zero), a new record will be created.</param>
		/// <param name="Description">The text description of the Group. This must be unqiue in the PassportX database.</param>
		/// <param name="GroupStatusID">The ID of the GroupStatus indicating the status of this Group record.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the outcome of the save, in the following format:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Result&gt;<br>
		/// &nbsp;&nbsp;&lt;ResultCode/&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Result&gt;<br>
		/// &lt;/Group&gt;<br><br>
		/// If the save was successful, the value of ResultCode will be 0 (zero) and the GroupID will contain the
		/// value assigned to the record by the PassportX. If not, the Result will contain the error code and description or
		/// reason the save failed.
		/// </returns>
		[WebMethod] public XmlDocument SaveGroup(string Token, int GroupID, string Description, int GroupStatusID) {
			XmlDocument saveGroup;
			XmlDocument validUser = ValidateToken(Token, "administer", "SaveGroup");
			if (validUser == null) {
				saveGroup = _Group.SaveGroup(GroupID, Description, GroupStatusID);
			} else {
				saveGroup = new XmlDocument();
				saveGroup.LoadXml ("<Group>" + validUser.OuterXml + "</Group>");
			}
			return saveGroup;
		}


		/// <summary>
		/// Return details for a specific Group in the PassportX database.
		/// </summary>
		/// <param name="GroupID">The internal ID of the Group record in the PassportX database.</param>
		/// <returns>
		/// Returns an XmlDocument object with the following layout:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;Status GroupStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;/Status&gt;<br>
		/// &lt;/Group&gt;
		/// </returns>
		[WebMethod] public XmlDocument GetGroup(int GroupID) {
			XmlDocument getGroup = _Group.GetGroup(GroupID);
			return getGroup;
		}


		/// <summary>
		/// Returns a list of all groups in the PassportX database, commonly used to generate a list on a user
		/// interface for selection purposes.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;Groups&gt;<br>
		/// &nbsp;&lt;Group GroupID=""&gt;<br>
		/// &nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;Status GroupStatusID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&nbsp;&lt;/Status&gt;<br>
		/// &nbsp;&lt;/Group&gt;<br>
		/// &lt;/Groups&gt;
		/// </returns>
		[WebMethod] public XmlDocument GetGroupList() {
			XmlDocument getGroupList = _Group.GetGroupList();
			return getGroupList;
		}


		/// <summary>
		/// Returns a list of users in a _Group
		/// </summary>
		/// <param name="GroupID">The internal ID of the Group in the PassportX database.</param>
		/// <returns>
		/// Returns an XmlDocument object in the following layout:<br>
		/// &lt;Group GroupID=""&gt;<br>
		/// &nbsp;&lt;Description/&gt;<br>
		/// &nbsp;&lt;Users&gt;<br>
		/// &nbsp;&nbsp;&lt;User UserID=""&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;FirstName/&gt;<br>
		/// &nbsp;&nbsp;&nbsp;&lt;Surname/&gt;<br>
		/// &nbsp;&nbsp;&lt;/User&gt;<br>
		/// &nbsp;&lt;/Users&gt;<br>
		/// &lt;/Group&gt;
		/// </returns>
		[WebMethod] public XmlDocument GetGroupMemberList(int GroupID) {
			XmlDocument getGroupMemberList = _Group.GetGroupMemberList(GroupID);
			return getGroupMemberList;
		}
		#endregion
		
		#region Cactus methods
		/*
		[WebMethod] public bool IsCactus(int UserID) {
			return(IsCactusLogin(UserID));
		}
		
		// Get Cactus information (if user on cactus)
		private XmlDocument GetCactusLogin(XmlDocument user, bool grpchk) {
			XmlDocument cacdoc = null;
			try {
				XmlNodeList cacgrps = user.SelectNodes("//Group[number(@GroupID)>6 and number(@GroupID)<15]");
				if (cacgrps.Count > 0 || !grpchk) {
					string username = user.SelectSingleNode("/User/UserName").InnerText;
					string usergkid = user.SelectSingleNode("/User/@UserID").InnerText;
					GKCactus cactus = new GKCactus();
					if(cactus.DoCactus()){
						XmlDocument usrdoc = cactus.Login(username, usergkid);
						XmlNode resnode = usrdoc.SelectSingleNode("//Transaction_Result/Result_Code");
						if (resnode.InnerText == "0") {
							XmlNode transnode = usrdoc.SelectSingleNode("//Transaction_Result");
							cacdoc = GetCactusDoc();
							XmlNode cacnode = cacdoc.SelectSingleNode("Cactus");
							cacnode.InnerXml = transnode.InnerXml;
							// v.1.0.4 : add check for multiple profiles
							usrdoc = cactus.Get(usergkid);
							resnode = usrdoc.SelectSingleNode("//Transaction_Result/Result_Code");
							if (resnode.InnerText == "0") {
								transnode = usrdoc.SelectSingleNode("//Transaction_Result");
								cacnode = cacdoc.SelectSingleNode("Profiles");
								cacnode.InnerXml = cacnode.InnerXml + transnode.InnerXml;
							}
						}
					}
				}
			} catch (System.Exception) {
			}
			return(cacdoc); 
		}
		// Check if the user login valid on Cactus
		private bool IsCactusLogin(int UserID) {
			string usergkid = UserID.ToString();
			string username = _User.GetUsername(UserID);
			
			GKCactus cactus = new NashuaMobile.GKCactus();
			XmlDocument usrdoc = cactus.Login(username, usergkid);
			XmlNode resnode = usrdoc.SelectSingleNode("//Transaction_Result/Result_Code");
			return(resnode.InnerText == "0");
		}
		// Update user's profile on Cactus
		private string UpdateCactusProfile(int UserID, int GroupID) {
			string result = "ok";
			XmlDocument getUser, getCactus, usrdoc;
			string telno, accno, cname, email, gkid, update, profstat;
			if (GroupID > 6 && GroupID < 15) {
				GKCactus cactus = new NashuaMobile.GKCactus();
				if (IsCactusLogin(UserID)) {
					getUser = _User.GetUserRights(UserID);
					getCactus = GetCactusLogin(getUser, false);
					if (getCactus != null) {
						update = "Y";
						email = getCactus.SelectSingleNode("//Email").InnerText;
						gkid = UserID.ToString();
						if (GroupID >= 9 && GroupID <= 11) {	// individual (includes corporate users)
							if (GroupID == 9)	// corporate users
								profstat = "1";
							else
								profstat = (GroupID == 10 )? "0" : "1";
							telno = getUser.SelectSingleNode("/User/CellNo").InnerText;
							usrdoc = cactus.Register_Individual(update, profstat, telno, gkid, email);
						}
						else {
							profstat = (GroupID == 7 )? "0" : "1";
							telno = getCactus.SelectSingleNode("//Tel_No_Work").InnerText;
							accno = getCactus.SelectSingleNode("//Account_No").InnerText;
							cname = getCactus.SelectSingleNode("//Name").InnerText;
							usrdoc = cactus.Register_Corporate(accno, cname, telno, email, "", profstat, update, gkid);
						}
						XmlNode resnode = usrdoc.SelectSingleNode("Result_Code");
						if (resnode != null) {
							if (resnode.InnerText == "0")
								result += " profstat:" + profstat;
							else
								result = resnode.InnerText;
						}
						else
							result = "cactus failed: " + update+":"+profstat+":"+telno+":"+gkid+":"+email;
					}
					else
						result = "no cactus login: " + getUser.SelectSingleNode("/User/UserName").InnerText;
				}
				else
					result = "not cactus user";
			}
			return(result);
		}
		
		private XmlDocument GetCactusDoc() {
			XmlDocument thisdoc = new XmlDocument();
			thisdoc.LoadXml("<Cactus></Cactus>");
			return(thisdoc);
		}
		*/
		#endregion
	}
}
