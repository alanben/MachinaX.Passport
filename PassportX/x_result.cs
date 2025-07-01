using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20070527
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

/*	-----------------------------------------------------------------------
	Development Notes:
	==================

	20070220:	This base class was taken from the previous GateKeeper 
				class and split into two (ie this and GateKeeperBase)
				Class hierarchy as follows:
				   GateKeeperResult_
									|_ System.Xml.XmlDocument
	20070527:	Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
					x_result
							|_ System.Xml.XmlDocument
				Note: this class should/could be derived from MachinaX.x_status
	20070703:	Removed net_2_0 directive (from compatibility build)
	20090728:	Changed default tag to be "PassportX" and added Logger and 
				Config properties.
	-----------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX {
	/// <summary>
	/// The NMErorr class implments a universal error handler for the GK*  classes
	/// </summary>
	public class x_result : System.Xml.XmlDocument {
		#region Invisible properties
		#endregion

		#region Constants
		private const string DEFAULT_TAG = "PassportX";
		private const string RESULT_XML = "<{0}><Result><ResultCode>0</ResultCode><Description/></Result></{0}>";
		#endregion

		#region Visible properties
		private string tag = DEFAULT_TAG;
		/// <summary>The tag for the error object</summary>
		/// <value>A string containing a description of the error</value>
		public string Tag {
			get { return tag; }
			set { tag = value; initialise(); }
		}
		private string message;
		/// <summary>The message associated with the error</summary>
		/// <value>A string containing a description of the error</value>
		public string Message {
			get { return message; }
			set { message = value; MessageElem.InnerText = message; }
		}
		private string code;
		/// <summary>The code associated with the error</summary>
		/// <value>A string containing the error code</value>
		public string Code {
			get { return code; }
			set { code = value; CodeElem.InnerText = value; }
		}
		/// <summary>The message XmlElement associated with the error</summary>
		/// <value>An XmlElement containing a description of the error</value>
		public XmlElement MessageElem {
			get { return DocumentElement.SelectSingleNode("//Result/Description") as XmlElement; }
		}
		/// <summary>The code XmlElement associated with the error</summary>
		/// <value>An XmlElement containing the error code</value>
		public XmlElement CodeElem {
			get { return DocumentElement.SelectSingleNode("//Result/ResultCode") as XmlElement; }
		}
		private x_logger logger;
		/// <summary>The logger object</summary>
		/// <value>A x_logger object</value>
		protected x_logger Logger {
			get { return logger; }
		}
		private XXBoom.MachinaX.x_config config;
		/// <summary>The config object</summary>
		/// <value>An MachinaX.x_config object</value>
		protected XXBoom.MachinaX.x_config Config {
			get { return config; }
		}
		#endregion

		#region Constructors/Destructors
		/// <overloads>Constructor</overloads>
		/// <summary>Default constructor</summary>
		public x_result() : base() {
			initialise();
		}
		/// <summary>Constructor with root tag</summary>
		public x_result(string tg) : base() {
			initialise(tg);
		}
		#endregion

		#region Public methods
		/// <summary>
		/// Reset the xml of the document to default state
		/// </summary>
		public void Clear() {
			initialise();
		}
		#endregion
		
		#region Protected methods
		/// <overloads>Load error for a specific error condition</overloads>
		/// <summary>Code and message</summary>
		protected void Error(int cde, string msg) {
			initialise(cde.ToString(), msg);
		}
		protected void Error(int bse, int cde, string msg) {
			initialise((bse + cde).ToString(), msg);
		}
		/// <summary>Code and two messages</summary>
		protected void Error(int cde, string msg, string add) {
			initialise(cde.ToString(), String.Concat(msg, " - ", add));
		}
		/// <summary>Code and message</summary>
		protected void Error(int cde, string msg, Exception exc) {
			initialise(cde.ToString(), msg, exc);
		}
		protected void Error(int bse, int cde, string msg, Exception exc) {
			initialise((bse + cde).ToString(), msg, exc);
		}
		/// <summary>Exception, code and message</summary>
		protected void Error(string cde, string msg, Exception exc) {
			initialise(cde, msg, exc);
		}
		
		/// <overloads>Adds a node to the Document</overloads>
		/// <summary>Adds a child of document element</summary>
		protected XmlElement _AddElement(string name) {
			return DocumentElement.AppendChild(CreateElement(name)) as XmlElement;
		}
		/// <summary>Adds a child to an element</summary>
		protected XmlElement _AddElement(XmlNode parent, string name) {
			return parent.AppendChild(CreateElement(name)) as XmlElement;
		}
		/// <summary>Adds a child to an element</summary>
		protected XmlElement _AddElement(XmlNode parent, string name, string value) {
			XmlElement child = parent.AppendChild(CreateElement(name)) as XmlElement;
			child.InnerText = value;
			return child;
		}
		/// <summary>Adds child of document element</summary>
		protected void _AddElement(string name, string value) {
			DocumentElement.AppendChild(CreateElement(name)).InnerText = value;
		}
		/// <summary>Adds grandchild of document element</summary>
		protected void _AddElement(string parent, string name, string value) {
			XmlNode child = DocumentElement.SelectSingleNode(parent);
			if (child == null)
				child = DocumentElement.AppendChild(CreateElement(parent));
			child.AppendChild(CreateElement(name)).InnerText = value;
		}
		
		/// <overloads>Adds a attribute to the Document</overloads>
		/// <summary>Adds to document element</summary>
		protected void _AddAttribute(string name, string value) {
			XmlAttribute attr = CreateAttribute(name);
			attr.Value = value;
			DocumentElement.SetAttributeNode(attr);
			//DocumentElement.SetAttribute(name,value);
		}
		/// <summary>Adds to document element</summary>
		protected void _AddAttribute(string name, int value) {
			XmlAttribute attr = CreateAttribute(name);
			attr.Value = value.ToString();
			DocumentElement.SetAttributeNode(attr);
			//DocumentElement.SetAttribute(name, value.ToString());
		}
		/// <summary>Adds to child of document element</summary>
		protected void _AddAttribute(string parent, string name, string value) {
			XmlElement child = DocumentElement.SelectSingleNode(parent) as XmlElement;
			if (child == null)
				child = DocumentElement.AppendChild(CreateElement(parent)) as XmlElement;
			child.SetAttribute(name, value);
		}
		#endregion
		
		#region Private methods
		/// <overloads>Initialises the object (called from constructors)</overloads>
		/// <summary></summary>
		private void initialise() {
			LoadXml(string.Format(RESULT_XML, tag));
			logger = new x_logger();
			config = new XXBoom.MachinaX.x_config();
		}
		private void initialise(string tg) {
			tag = tg;
			initialise();
		}
		private void initialise(string cde, string msg) {
			initialise();
			Code = cde;
			Message = msg;
		}
		private void initialise(string tg, string cde, string msg) {
			tag = tg;
			initialise(cde, msg);
		}
		private void initialise(string cde, string msg, Exception exc) {
			initialise(cde, String.Concat(msg, " - ", exc.Source, " - ", exc.Message));
			DocumentElement.AppendChild(CreateElement("StackTrace")).InnerText = exc.StackTrace;
		}
		#endregion
	}
}
