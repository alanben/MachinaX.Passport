using System;
using System.Configuration;
using System.Xml;
using System.Data;
using System.Data.SqlClient;

using XXBoom.MachinaX.DataX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2008-10-06	
	Status:		alpha	
	Version:	2.0.1
	Build:		20081006
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20071006:	Start of this new old, somewhat a simplification of the x_group class, 
				but also to map directly to the "pattern" concept in blogX menu patterns.
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation of all Profile-related methods in the Nashua Mobile Gatekeeper Web Service.
	/// Note: This class is deprecated, use x_group
	/// </summary>
	public class x_pattern : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Pattern";
		#endregion

		#region Constants - Stored procedure names
		// Procedures to list, add, edit, delete patterns
		private const string PROC_GET	=	"x_PatternGet";
		private const string PROC_LIST	=	"x_PatternList";
		private const string PROC_ADD	=	"x_PatternAdd";
		private const string PROC_UPD	=	"x_PatternUpdate";
		private const string PROC_DEL	=	"x_PatternDelete";
		// Procedures to list, add, edit, delete values to patterns
		private const string PROC_VALUE_LIST	= "x_PatternValueList";
		private const string PROC_VALUE_ADD		= "x_PatternValueAdd";
		private const string PROC_VALUE_DEL		= "x_PatternValueDelete";
		// Procedures to list, add, edit, delete patterns to users
		private const string PROC_USER_LIST		= "x_PatternUserList";
		private const string PROC_USER_ADD		= "x_PatternUserAdd";
		private const string PROC_USER_DEL		= "x_PatternUserDelete";
		// Procedures to list, add, edit, delete users with patterns
		private const string PROC_USERPATT_LIST	= "x_UserPatternList";
		private const string PROC_USERPATT_GET	= "x_UserPatternGet";
		private const string PROC_USERPATT_ADD	= "x_UserPatternAdd";
		private const string PROC_USERPATT_UPD	= "x_UserPatternUpdate";
		private const string PROC_USERPATT_DEL	= "x_UserPatternDelete";
		#endregion

		#region Constants - Error Codes
		private const int ERROR_BASE = 9000;
		private const int ERROR_GET = 1;
		private const int ERROR_LIST = 2;
		private const int ERROR_ADD = 3;
		private const int ERROR_UPD = 4;
		private const int ERROR_DEL = 5;
		private const int ERROR_VALUE_LIST = 6;
		private const int ERROR_VALUE_ADD = 7;
		private const int ERROR_VALUE_DEL = 8;
		private const int ERROR_USER_LIST = 9;
		private const int ERROR_USER_ADD = 10;
		private const int ERROR_USER_DEL = 11;
		private const int ERROR_USERPATT_LIST = 12;
		#endregion

		#region Visible properties
		#endregion

		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Group class.
		/// </summary>
		public x_pattern(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_pattern(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public Pattern methods
		/// <summary>
		/// Return details for a specific Pattern in the Gatekeeper database.
		/// </summary>
		/// <param name="PatternID">The Pattern ID</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument Get(int PatternID) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(PatternID, "PatternID");
						writePattern();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_GET, "There was an error retrieving the Pattern details", exc);
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
		public XmlDocument List() {
			Tag = "Patterns";
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						writePatterns();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_LIST , "There was an error retrieving the Pattern List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Add a Pattern.
		/// </summary>
		/// <param name="Description">The Pattern description. All descriptions in the should be unique.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument Add(string Description) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						AddSQLParameter(Description, "Description", 50);
						writePattern();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_ADD, "There was an error adding the Pattern", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Update a Pattern.
		/// </summary>
		/// <param name="PatternID">The Pattern ID</param>
		/// <param name="Description">The Pattern description. All descriptions in the should be unique.</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument Add(int PatternID, string Description) {
			using (Connect()) {
				try {
					using (Command(PROC_UPD)) {
						AddSQLParameter(PatternID, "PatternID");
						AddSQLParameter(Description, "Description", 50);
						writePattern();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_UPD, "There was an error updating the Pattern", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Delete a Pattern. This will not remove all the values linked to a Pattern (yet)
		/// </summary>
		/// <param name="PatternID">The Pattern ID</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument Remove(int PatternID) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(PatternID, "PatternID");
						Execute();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_DEL, "There was an error Removing the Pattern", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion

		#region Public Pattern-Value methods
		/// <summary>
		/// Lists the values for a pattern
		/// </summary>
		/// <param name="PatternID">The Pattern ID</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument ListValues(int PatternID) {
			using (Connect()) {
				try {
					Tag = "Values";
					using (Command(PROC_VALUE_LIST)) {
						AddSQLParameter(PatternID, "PatternID");
						writeValues(PatternID);
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALUE_LIST, "There was an error retrieving the Pattern-Value List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Add a Pattern-Value.
		/// </summary>
		/// <param name="PatternID">The Pattern ID</param>
		/// <param name="Description">The Value's description. All descriptions should be unique for a given Pattern.</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument AddValue(int PatternID, string Description) {
			using (Connect()) {
				try {
					Tag = "Values";
					using (Command(PROC_VALUE_ADD)) {
						AddSQLParameter(PatternID, "PatternID");
						AddSQLParameter(Description, "Description", 50);
						writeValues(PatternID);
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALUE_ADD, "There was an error adding the Pattern-Value", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Delete a Value.
		/// </summary>
		/// <param name="ValueID">The Value ID.</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument RemoveValue(int ValueID) {
			using (Connect()) {
				try {
					using (Command(PROC_VALUE_DEL)) {
						AddSQLParameter(ValueID, "ValueID");
						Execute();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_VALUE_DEL, "There was an error removing the Pattern-Value", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion


		#region Public Pattern-User methods
		/// <summary>
		/// Lists the values for a user
		/// </summary>
		/// <param name="PersonID">The User ID</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument ListUserValues(int PersonID) {
			using (Connect()) {
				try {
					Tag = "Values";
					using (Command(PROC_USER_LIST)) {
						AddSQLParameter(PersonID, "PersonID");
						writeValues();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_USER_LIST, "There was an error retrieving the User-Value List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Add a User-Value.
		/// </summary>
		/// <param name="PersonID">The User ID</param>
		/// <param name="ValueID">The Value ID</param>
		/// <returns>
		/// Returns an XmlDocument object
		/// </returns>
		public XmlDocument AddUserValue(int PersonID, int ValueID) {
			using (Connect()) {
				try {
					Tag = "Values";
					using (Command(PROC_USER_ADD)) {
						AddSQLParameter(PersonID, "PersonID");
						AddSQLParameter(ValueID, "ValueID");
						writeValues();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_USER_ADD, "There was an error adding the User-Value", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Delete a Value.
		/// </summary>
		/// <param name="PersonID">The User ID</param>
		/// <param name="ValueID">The Value ID.</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument RemoveUserValue(int PersonID, int ValueID) {
			using (Connect()) {
				try {
					using (Command(PROC_USER_DEL)) {
						AddSQLParameter(PersonID, "PersonID");
						AddSQLParameter(ValueID, "ValueID");
						Execute();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_USER_DEL, "There was an error removing the User-Value", exc);
				}
			}
			return this as XmlDocument;
		}
		#endregion


		#region Public User-Pattern methods
		/// <summary>
		/// Lists the users for a value
		/// </summary>
		/// <param name="ValueID">The value ID</param>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument ListUsers(int ValueID) {
			using (Connect()) {
				try {
					Tag = "Users";
					using (Command(PROC_USERPATT_LIST)) {
						AddSQLParameter(ValueID, "ValueID");
						writeUsers();
					}
				} catch (Exception exc) {
					Error(ERROR_BASE, ERROR_USERPATT_LIST, "There was an error retrieving the Value-User List", exc);
				}
			}
			return this as XmlDocument;
		}


		#endregion


		#region Private methods
		private void writePattern() {
			using (Reader()) {
				XmlElement pattern, patterns;
				patterns = this.SelectSingleNode(Tag) as XmlElement;
				if (Read()) {
					pattern = _AddElement(patterns, "Pattern", GetValue("Description"));
					AddAttribute(pattern, "id", "PatternID");
				} else {
					throw new Exception("could not find Pattern with the requested ID");
				}
			}
		}
		private void writePatterns() {
			using (Reader()) {
				XmlElement pattern, patterns;
				patterns = this.SelectSingleNode(Tag) as XmlElement;
				while (Read()) {
					pattern = _AddElement(patterns, "Pattern", GetValue("Description"));
					AddAttribute(pattern, "id", "PatternID");
				}
			}
		}
		private void writeValues(int patternID) {
			using (Reader()) {
				XmlElement pattern, value;
				pattern = this.SelectSingleNode(Tag) as XmlElement;
				pattern.SetAttribute("patternid", patternID.ToString());
				while (Read()) {
					value = _AddElement(pattern, "Value", GetValue("Value"));
					AddAttribute(value, "id", "ID");
				}
			}
		}
		private void writeValues() {
			using (Reader()) {
				XmlElement pattern, value;
				pattern = this.SelectSingleNode(Tag) as XmlElement;
				while (Read()) {
					value = _AddElement(pattern, "Value", GetValue("Value"));
					AddAttribute(value, "id", "ID");
					AddAttribute(value, "pattern", "Pattern");
					AddAttribute(value, "patternid", "PatternID");
				}
			}
		}
		private void writeUsers() {
			using (Reader()) {
				XmlElement pattern, value;
				pattern = this.SelectSingleNode(Tag) as XmlElement;
				while (Read()) {
					value = _AddElement(pattern, "User", GetValue("PersonName"));
					AddAttribute(value, "id", "PersonID");
					AddAttribute(value, "email", "EMail");
					AddAttribute(value, "firstname", "FirstName");
					AddAttribute(value, "surname", "Surname");
					AddAttribute(value, "value", "Description");
					AddAttribute(value, "valueid", "ValueID");
				}
			}
		}
		#endregion


	}
}
