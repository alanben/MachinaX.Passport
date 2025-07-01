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
	20070305:	Refactoring using the model in GKUser, ie: use of AddSQLParameter, GetSqlString, GetSqlYesNo etc
				Was: 189 lines, now xxx including notes and comments
				Class hierarchy as follows:
				  x_questions _
							| _ GateKeeperBase _
											|_ GateKeeperResult
	20070531:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
				x_questions -> x_passport -> x_result
	20071226:	Added support for multiple databases using DataX
	----------------------------------------------------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// Class containing all User Questions-related methods. Questions and answers are stored for reminders of passwords.
	/// </summary>
	public class x_questions : x_passport {
		#region Invisible properties
		#endregion

		#region Constants
		private const string ROOT_NAME = "Question";
		#endregion

		#region Constants - Stored procedure names
		private const string PROC_LIST	=	"x_QuestionList";
		private const string PROC_GET	=	"x_QuestionGet";
		private const string PROC_ADD	=	"x_QuestionAdd";
		private const string PROC_DEL	=	"x_QuestionDelete";
		#endregion

		#region Visible properties
		#endregion
		
		#region Constructors/Destructors
		/// <summary>
		/// Default constructor for the Questions class
		/// </summary>
		/// <param name="DSN">The Data Source to be used for database connections</param>
		public x_questions(string DSN) : base(DSN, ROOT_NAME) {
		}
		public x_questions(string DSN, DataProviderType DBType) : base(DBType, DSN, ROOT_NAME) {
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Method used to add/update a Question record.
		/// </summary>
		/// <param name="QuestionID">The public ID of the Question record. If the value is 0, a new record will be created, and the new ID will be returned.</param>
		/// <param name="Question">The text of the question, eg. 'Mother's maiden name'.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the result of the save
		/// </returns>
		public XmlDocument SaveQuestion(int QuestionID, string Question) {
			using (Connect()) {
				try {
					using (Command(PROC_ADD)) {
						IDataParameter questionid = AddSQLParameter(QuestionID, "@QuestionID", ParameterDirection.InputOutput);
						AddSQLParameter(Question, "@Description", 100);
						Execute();
						if (QuestionID == 0) {
							QuestionID = GetValue(questionid, 0);
						}
						_AddAttribute("QuestionID", QuestionID);
					}
				} catch (Exception exc) {
					Error(2058, "There was an error saving the Question record", exc);
					_AddAttribute("QuestionID", QuestionID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method to retrieve a Question record, typically for editing purposes.
		/// </summary>
		/// <param name="QuestionID">The public ID of the Question record to be retrieved.</param>
		/// <returns>
		/// Returns an XmlDocument object, containing the details of the Question record
		/// </returns>
		public XmlDocument GetQuestion(int QuestionID) {
			using (SqlConnection gkdb = new SqlConnection(DSN)) {
				try {
					using (Command(PROC_GET)) {
						AddSQLParameter(QuestionID, "@QuestionID");
						using (Reader()) {
							if (Read()) {
								AddAttribute("QuestionID", "QuestionID");
								AddElement("Description", "Description");
							} else {
								Error(2059, "Could not retrieve the data for the Question.");
								_AddAttribute("QuestionID", QuestionID);
							}
						}
					}
				} catch (Exception exc) {
					Error(2059, "There was an error retrieving the Question", exc);
					_AddAttribute("QuestionID", QuestionID);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to retrieve a list of all Question records in the database.
		/// </summary>
		/// <returns>
		/// Returns an XmlDocument
		/// </returns>
		public XmlDocument GetQuestionList() {
			Tag = "Questions";
			using (SqlConnection gkdb = new SqlConnection(DSN)) {
				try {
					using (Command(PROC_LIST)) {
						using (Reader()) {
							XmlElement question, questions;
							questions = SelectSingleNode("/Questions") as XmlElement;
							while (Read()) {
								question = _AddElement(questions, "Question");
								AddAttribute(question, "QuestionID", "QuestionID");
								AddElement(question, "Description", "Description");
							}
						}
					}
				} catch (Exception exc) {
					Error(2060, "There was an error retrieving the Question List", exc);
				}
			}
			return this as XmlDocument;
		}


		/// <summary>
		/// Method used to remove a Question and all related records from the database. This method does not return any values.
		/// </summary>
		/// <param name="QuestionID">The public ID of the Question record.</param>
		public void DeleteQuestion(int QuestionID) {
			using (SqlConnection gkdb = new SqlConnection(DSN)) {
				try {
					using (Command(PROC_DEL)) {
						AddSQLParameter(QuestionID, "@QuestionID");
						Execute();
					}
				} catch {}
			}
		}
		#endregion
	}
}
