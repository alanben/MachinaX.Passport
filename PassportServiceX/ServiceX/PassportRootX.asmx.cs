using System;
using System.Configuration;
using System.Collections;
using System.ComponentModel;
using System.Diagnostics;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Xml;

using XXBoom.MachinaX.PassportX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		release	
	Version:	2.0.1
	Build:		20081015
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
	20070911:	Starting point.
				Split the original PassportBaseX into this and PassportRootX
				- db methods/properties in PassportBaseX
				- xml and core methods/properties in PassportRootX
	20071220:	Made some WebMethods virtual to allow them to be overridden (ie hidden)
	20081006:	Removed the #define that was used for backward compatibility with GateKeeper
 	-------------------------------------------------------------------------------------------------	*/

namespace XXBoom.MachinaX.PassportX.PassportServiceX {
	/// <summary>
	/// This PassportService class is
	/// </summary>
	[WebService(Namespace="http://www.clickclickBOOM.com/MachinaX/PassportX")]
	public class PassportRootX : XXBoom.MachinaX.x_result {
		#region Invisible properties
		#endregion

		#region Constants
		private const string DEFAULT_TAG = "nm_service";
		#endregion

		#region Visible properties
		protected bool want_sms = true;
		private XmlDocument resultdoc;
		/// <summary>The result document</summary>
		/// <value>An XmlDocument containing the result xml/value>
		public XmlDocument Doc {
			get { return resultdoc; }
			set { resultdoc = value; }
		}

		private x_pseudo pseudo;
		/// <summary>PassportX pseudo</summary>
		/// <value>A PassportX pseudo object</value>
		protected x_pseudo _Pseudo { get { return pseudo; } set { pseudo = value; } }
		#endregion

		#region Constructors/Destructors
		protected x_logger _Logger;

		/// <overloads>Constructors</overloads>
		/// <summary>Default Constructor for older style schemas</summary>
		public PassportRootX() : base("X", DEFAULT_TAG, typeof(PassportRootX)) {
			_Logger = Logger;
		}
		/// <summary>Constructor for newer style schemas</summary>
		public PassportRootX(string root) : base("X", root, typeof(PassportRootX)) {
			_Logger = Logger;
		}
		#endregion

		#region Protected methods
		#endregion

		#region Public Web methods
		#endregion

		#region Private methods
		private string getRequest(Stream receiveStream) {
			StringBuilder thisinp = new StringBuilder();
			try {
	            Encoding encode = Encoding.GetEncoding("utf-8");
	            StreamReader readStream = new StreamReader(receiveStream, encode);
				
	            Char[] read = new Char[1024];
	              // Reads 1024 characters at a time
	            int count = 1, thiscnt = 0;
	            while (count > 0) {
					count = readStream.Read(read, 0, 1024);
					thisinp.Append(read, 0, count);
					thiscnt += count;
            	}
				return thisinp.ToString();
			} catch (Exception e) {
				return String.Concat("Error (getRequest):", e.Message);
			}
		}
		#endregion
	}
}
