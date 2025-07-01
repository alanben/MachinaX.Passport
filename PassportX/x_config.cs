using System;
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
	20070305:	Refactoring using the model in GKUser, ie: use of AddSQLParameter, GetSqlString, GetSqlYesNo etc
				Was: 179 lines, now 173 including notes and comments
				Class hierarchy as follows:
						x_config _
							| _ GateKeeperBase _
											|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_config -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Implementation of all System Configuration-related methods
	/// </summary>
	public class x_config : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Configuration";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_LIST	=	"x_ConfigList";
		private const string PROC_GET	=	"x_ConfigGet";
		private const string PROC_ADD	=	"x_ConfigAdd";
		private const string PROC_DEL	=	"x_ConfigDelete";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor of the Config class
		/// </summary>
		/// <param name="DSN">The Data Source to be used for database connections</param>
		public x_config(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_config(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Method used to change the value of a system setting.
		/// </summary>
		/// <param name="Key">The name of the system setting to change</param>
		/// <param name="Value">The value of the system setting</param>
		/// <returns>
		/// Returns an XmlDocument object, indicating the result of the save
		/// </returns>
		public XmlDocument SaveConfigValue(string Key, string Value) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						AddSQLParameter(Key, "@Description", 100);
						AddSQLParameter(Value, "@RetValue", 50);
						Execute();
					}
				} catch (Exception exc) {
					Error(2055, "There was an error saving the Configuration value", exc);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Method used to return the value of a system setting.
		/// </summary>
		/// <param name="Key">The name of the Configuration value to return</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the details of the system setting
		/// </returns>
		public XmlDocument GetConfigValue(string Key) {
			using (Connect()) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(Key, "@Description", 100);
						using (Reader()) {
							if (Read()) {
								AddAttribute("Key", "Description");
								AddElement("Value", "RetValue");
							} else {
								Error(2056, "Could not retrieve data for the selected Configuration record.");
							}
						}
					}
				} catch (Exception exc) {
					Error(2056, "There was an error retrieving the Configuration value", exc);
					_AddAttribute("Key", Key);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Method used to retrieve a list of all System Configuration values.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument object containing all System Configuration values
		/// </returns>
		public XmlDocument GetConfigValueList() {
			Tag = "ConfigurationList";	// set the result xml to have a "ConfigurationList" root element
			using (Connect()) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement config, configs;
							configs = this.SelectSingleNode("/ConfigurationList") as XmlElement;
							while (Read()) {
								config = configs.AppendChild(this.CreateElement("Configuration")) as XmlElement;
								AddAttribute(config, "Key", "Description");
								AddElement(config, "Value", "RetValue");
							}
						}
					}
				} catch (Exception exc) {
					Error(2057, "There was an error retrieving the Configuration list", exc);
				}
			return this as XmlDocument;
			}
		}


		/// <summary>
		/// Method used to remove a System Configuration value. This method does not return any values.
		/// </summary>
		/// <param name="Key">The name of the Configuration value to delete.</param>
		public void DeleteConfigValue(string Key) {
			using (Connect()) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(Key, "@Description", 100);
						Execute();
					}
				} catch {}
			}
		}
		#endregion
	}
}
