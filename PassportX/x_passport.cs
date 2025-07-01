using System;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

using XXBoom.MachinaX.DataX;

/*	-----------------------------------------------------------------------	
	Copyright:	clickclickBOOM cc
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		release	
	Version:	2.6.0
	Build:		20111003
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/

/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Note re MachinaX.PassportX:
	------------------------------------
	The refactoring mentioned below is intended to result in a code base that can be migrated into the MachinaX 
	framework as follows:
	- Base classes migrated to the MachinaX.PassportX namespace.
	- Web Service classes migrated to the MachinaX.PassportServiceX namespace.
	- Web service classes can remain in an implementation class (eg NashuaMobile.Gatekeeper)
	Note: Once this is completed the Gatekeeper code will become dependant on PassportX base classes.
		  If this is not desired, a fork in the codebase will be created at that stage.
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	Development Notes:
	==================
	20070220:	This base class was taken from the previous GateKeeper 
				class and split into two (ie this and GateKeeperResult)
				Class hierarchy as follows:
					GateKeeperBase _
									|_ GateKeeperResult
	20070425:	Fixed getSqlString to be safe when column is not string
	20070527:	- Starting point from NMGatekeeper.2.0.2.
				Class hierarchy now becomes:
					_x_passport_
								|_x_result (could later utilise MachinaX.x_status)
	20071226:	Added support for multiple databases using DataX database
				provider manager in the XXBoom.MachinaX.DataX namespace.
	20111003:	Added Schema field (tables, view and procs are now in the 'passport' schema
	-----------------------------------------------------------------------	*/
	
namespace XXBoom.MachinaX.PassportX {
	/// <summary>Description of the enumeration</summary>
	public enum SqlType {
		/// <summary>A string</summary>
	    String = 0,
		/// <summary>An integer</summary>
	    Integer = 1,
		/// <summary>A boolean string ie 'yes' or 'no'</summary>
	    YesNo = 2,
		/// <summary>A guid ie the token</summary>
	    Guid = 3
	}
	/// <summary>
	/// Base class for Gatekeeper classes.
	/// </summary>
	public class x_passport : x_result {
		#region Visible properties
		private const string DEFAULT_SCHEMA = "passport";

		/// <summary>
		/// The schema used for the Passport Tables, Views and Procedures
		/// </summary>
		public string Schema { get; set; }
		
		/// <summary>GateKeeper database connection string</summary>
		/// <value>Standard MsSQL connection string</value>
		public string DSN { get; set; }

		/// <summary>Database manager object</summary>
		/// <value>IDataXManager manager object</value>
		public DataXManager DataXManager { get; set; }

		/// <summary>Database connection object</summary>
		/// <value>MsSQL connection object</value>
		public IDbConnection DBConnection { get; set; }

		/// <summary>Database connection object</summary>
		/// <value>MsSQL connection object</value>
		public IDbCommand DBCommand { get; set; }

		/// <summary>Database data reader object</summary>
		/// <value>MsSQL DataReader object</value>
		public IDataReader DBReader { get; set; }
		#endregion

		#region Constructors/Destructors
		/// <overloads>Constructor</overloads>
		/// <summary>Default constructor</summary>
		public x_passport() : base() {
			initialise(String.Empty, DataProviderType.SqlServer);
		}
		/// <summary>Normal constructor</summary>
		/// <param name="DSN">DB connection string</param>
		protected x_passport(string dsn) : base() {
			initialise(dsn, DataProviderType.SqlServer);
		}
		/// <summary>Normal constructor</summary>
		/// <param name="DSN">DB connection string</param>
		/// <param name="id">the object identifier</param>
		protected x_passport(string dsn, string id) : base(id) {
			initialise(dsn, DataProviderType.SqlServer);
		}
		/// <summary>Normal constructor</summary>
		/// <param name="dbType">The data provider type</param>
		/// <param name="DSN">DB connection string</param>
		protected x_passport(DataProviderType dbType, string dsn) : base() {
			initialise(dsn, dbType);
		}
		/// <summary>Normal constructor</summary>
		/// <param name="dbType">The data provider type</param>
		/// <param name="DSN">DB connection string</param>
		/// <param name="id">the object identifier</param>
		protected x_passport(DataProviderType dbType, string dsn, string id) : base(id) {
			initialise(dsn, dbType);
		}
		private void initialise(string dsn, DataProviderType dbType) {
			DSN = dsn;
			DataXManager = new DataXManager(dbType, DSN);
			Schema = Config.Value("PassportX/Schema", DEFAULT_SCHEMA);
		}
		#endregion

		#region Public methods
		/// <summary>Connect to the database using the connection string</summary>
		public IDbConnection Connect() {
			DBConnection = DataXManager.Connect();
			return DBConnection;
		}
		/// <summary>Create a command to be executed with connection</summary>
		public IDbCommand Command(string storedproc) {
			string schemaproc = String.Concat(Schema, String.IsNullOrEmpty(Schema) ? "" : ".", storedproc);
			DBCommand = DataXManager.GetCommand(schemaproc);
			return DBCommand;
		}
		/// <overloads>Open a reader onto a dataset - ie execute a stored proc and get a dataset</overloads>
		/// <summary></summary>
		public IDataReader Reader() {
			DBReader = DBCommand.ExecuteReader(CommandBehavior.CloseConnection);
			return DBReader;
		}
		/// <summary></summary>
		public IDataReader Reader(CommandBehavior type) {
			DBReader = DBCommand.ExecuteReader(type);
			return DBReader;
		}
		/// <summary>Read from the dataset</summary>
		public bool Read() {
			return DBReader.Read();
		}
		/// <summary>Execute a stored proc that doesn't return a dataset</summary>
		public int Execute() {
			return DBCommand.ExecuteNonQuery();
		}
		/// <summary>Execute a stored proc returns a single value</summary>
		public object ExecuteScalar() {
			return DBCommand.ExecuteScalar();
		}
		/// <summary>Read from the dataset</summary>
		public void Next() {
			DBReader.NextResult();
		}
		#endregion
		
		#region Protected methods
		/// <overloads>Adds an parameter to a stored procedure call</overloads>
		/// <summary>Integer parameter</summary>
		protected IDataParameter AddSQLParameter(int parval, string parname) {
			return AddSQLParameter(DBCommand, parval, parname, false);
		}
		/// <summary>Integer parameter</summary>
		protected IDataParameter AddSQLParameter(SqlCommand parcmd, int parval, string parname) {
			return AddSQLParameter(parcmd, parval, parname, false);
		}
		/// <summary>Integer parameter</summary>
		protected IDataParameter AddSQLParameter(string parname) {
			return AddSQLParameter(DBCommand, parname);
		}
		/// <summary>Integer parameter</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, string parname) {
			IDataParameter par = DataXManager.CreateParameter(parname, DbType.Int32);
			par.Direction = ParameterDirection.Output;
			parcmd.Parameters.Add(par);
			return(par);
		}
		/// <summary>Integer parameter with output flag</summary>
		protected IDataParameter AddSQLParameter(int parval, string parname, bool isout) {
			return AddSQLParameter(DBCommand, parval, parname, isout);
		}
		/// <summary>Integer parameter with output flag</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, int parval, string parname, bool isout) {
			try {
				IDataParameter par = DataXManager.CreateParameter(parname, DbType.Int32);
				if (isout)
					par.Direction = ParameterDirection.Output;
				par.Value = parval;
				parcmd.Parameters.Add(par);
				return(par);
			} catch {
				return(null);
			}
		}
		/// <summary>Integer parameter with direction</summary>
		protected IDataParameter AddSQLParameter(int parval, string parname, ParameterDirection dirtn) {
			return AddSQLParameter(DBCommand, parval, parname, dirtn);
		}
		/// <summary>Integer parameter with direction</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, int parval, string parname, ParameterDirection dirtn) {
			try {
				IDataParameter par = DataXManager.CreateParameter(parname, DbType.Int32);
				par.Direction = ParameterDirection.Output;
				par.Value = parval;
				parcmd.Parameters.Add(par);
				return(par);
			} catch {
				return(null);
			}
		}
		/// <summary>String parameter</summary>
		protected IDataParameter AddSQLParameter(string parval, string parname, int parlen) {
			return AddSQLParameter(DBCommand, parval, parname, parlen, false);
		}
		/// <summary>String parameter</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, string parval, string parname, int parlen) {
			return AddSQLParameter(parcmd, parval, parname, parlen, false);
		}
		/// <summary>String parameter</summary>
		protected IDataParameter AddSQLParameter(string parname, int parlen, bool isout) {
			return AddSQLParameter(DBCommand, parname, parlen, isout);
		}
		/// <summary>String parameter</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, string parname, int parlen, bool isout) {
			try {
				IDataParameter par = DataXManager.CreateParameter(parname, DbType.String, parlen);
				if (isout)
					par.Direction = ParameterDirection.Output;
				parcmd.Parameters.Add(par);
				return(par);
			} catch {
				return(null);
			}
		}
		/// <summary>String parameter</summary>
		protected IDataParameter AddSQLParameter(string parval, string parname, int parlen, bool isout) {
			return AddSQLParameter(DBCommand, parval, parname, parlen, isout);
		}
		/// <summary>String parameter</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, string parval, string parname, int parlen, bool isout) {
			try {
				IDataParameter par = DataXManager.CreateParameter(parname, DbType.String, parlen);
				par.Direction = (isout)? ParameterDirection.Output : ParameterDirection.Input;
				par.Value = parval;
				parcmd.Parameters.Add(par);
				return(par);
			} catch {
				return(null);
			}
		}
		/*
		/// <summary>Spefified type of  parameter</summary>
		protected IDataParameter AddSQLParameter(string parval, string parname, DbType type) {
			return AddSQLParameter(DBCommand, parval, parname, type);
		}
		/// <summary>Spefified type of  parameter</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, string parval, string parname, DbType type) {
			try {
				IDataParameter par = DataXManager.CreateParameter(parname, type);
				par.Direction = ParameterDirection.Output;
				par.Value = parval;
				parcmd.Parameters.Add(par);
				return(par);
			} catch {
				return(null);
			}
		}
		*/
		/// <summary>Specified type of  parameter</summary>
		protected IDataParameter AddSQLParameter(object parval, string parname, DbType type) {
			return AddSQLParameter(DBCommand, parval, parname, type);
		}
		/// <summary>Specified type of  parameter</summary>
		protected IDataParameter AddSQLParameter(IDbCommand parcmd, object parval, string parname, DbType type) {
			try {
				IDataParameter par = DataXManager.CreateParameter(parname, type);
				par.Direction = ParameterDirection.InputOutput;
				par.Value = parval;
				parcmd.Parameters.Add(par);
				return (par);
			} catch {
				return (null);
			}
		}
		protected IDataParameter AddSQLParameter(DateTime parval, string parname, DbType type) {
			try {
				IDataParameter par = DataXManager.CreateParameter(parname, type);
				par.Direction = ParameterDirection.Input;
				par.Value = parval;
				DBCommand.Parameters.Add(par);
				return (par);
			}
			catch {
				return (null);
			}
		}
		
		
		/// <overloads>Adds an element</overloads>
		/// <summary>Adds a column value using the local data reader</summary>
		protected void AddElement(string name, string thiscol) {
			_AddElement(name, getSqlString(DBReader, thiscol));
		}
		/// <summary></summary>
		protected void AddElement(string name, string thiscol,DbType thistyp) {
			_AddElement(name, GetValue(DBReader, thiscol, thistyp));
		}
		/// <summary></summary>
		protected void AddElement(string parent, string name, string thiscol) {
			_AddElement(parent, name, getSqlString(DBReader, thiscol));
		}
		/// <summary></summary>
		protected void AddElement(string parent, string name, string thiscol, DbType thistyp) {
			_AddElement(parent, name, GetValue(DBReader, thiscol, thistyp));
		}
		/// <summary></summary>
		protected void AddElement(XmlNode parent, string name, string thiscol) {
			XmlNode child = _AddElement(parent, name);
			child.InnerText = getSqlString(DBReader, thiscol);
		}
		
		/// <overloads>Adds a column value using a data reader</overloads>
		/// <summary></summary>
		protected void AddElement(string name, IDataReader thisrdr, string thiscol) {
			_AddElement(name, getSqlString(thisrdr, thiscol));
		}
		/// <summary></summary>
		protected void AddElement(string name, IDataReader thisrdr, string thiscol, DbType thistyp) {
			_AddElement(name, GetValue(thisrdr, thiscol, thistyp));
		}
		/// <summary></summary>
		protected void AddElement(string parent, string name, IDataReader thisrdr, string thiscol) {
			_AddElement(parent, name, getSqlString(thisrdr, thiscol));
		}
		/// <summary></summary>
		protected void AddElement(string parent, string name, IDataReader thisrdr, string thiscol, DbType thistyp) {
			_AddElement(parent, name, GetValue(thisrdr, thiscol, thistyp));
		}
		
		/// <overloads>Adds an attribute</overloads>
		/// <summary>Adds a column value using the local data reader</summary>
		protected void AddAttribute(string name, string thiscol) {
			_AddAttribute(name, getSqlString(DBReader, thiscol));
		}
		/// <summary></summary>
		protected void AddAttribute(string name, string thiscol, DbType thistyp) {
			_AddAttribute(name, GetValue(DBReader, thiscol, thistyp));
		}
		/// <summary></summary>
		protected void AddAttribute(string parent, string name, string thiscol) {
			_AddAttribute(parent, name, getSqlString(DBReader, thiscol));
		}
		/// <summary></summary>
		protected void AddAttribute(string parent, string name, string thiscol, DbType thistyp) {
			_AddAttribute(parent, name, GetValue(DBReader, thiscol, thistyp));
		}
		
		/// <overloads>Adds a column value using a data reader</overloads>
		/// <summary></summary>
		protected void AddAttribute(string name, IDataReader thisrdr, string thiscol) {
			_AddAttribute(name, getSqlString(thisrdr, thiscol));
		}
		/// <summary></summary>
		protected void AddAttribute(string name, IDataReader thisrdr, string thiscol, DbType thistyp) {
			_AddAttribute(name, GetValue(thisrdr, thiscol, thistyp));
		}
		/// <summary></summary>
		protected void AddAttribute(string parent, string name, IDataReader thisrdr, string thiscol) {
			_AddAttribute(parent, name, getSqlString(thisrdr, thiscol));
		}
		/// <summary></summary>
		protected void AddAttribute(string parent, string name, IDataReader thisrdr, string thiscol, DbType thistyp) {
			_AddAttribute(parent, name, GetValue(thisrdr, thiscol, thistyp));
		}
		
		/// <overloads>Adds a column value to an element using the local data reader</overloads>
		/// <summary></summary>
		protected void AddAttribute(XmlElement elem, string name, string thiscol) {
			elem.SetAttribute(name, getSqlString(DBReader, thiscol));
		}
		/// <summary></summary>
		protected void AddAttribute(XmlElement elem, string name, string thiscol, DbType thistyp) {
			elem.SetAttribute(name, GetValue(DBReader, thiscol, thistyp));
		}
		
		/// <overloads>Adds an attribute to a node of a document</overloads>
		/// <summary>Adds from a field in a recordset</summary>
		protected bool AddAttr(XmlDocument xmlThis, XmlNode xnThis, IDataReader rdrThis, string attname, string fldname) {
			try {
				XmlAttribute xaThis = xmlThis.CreateAttribute(attname);
				xaThis.InnerText = rdrThis.GetValue(rdrThis.GetOrdinal(fldname)).ToString();
				xnThis.Attributes.Append(xaThis);
				return(true);
			} catch {
				return(false);
			}
		}
		/// <overloads>Adds an attribute to a node of a document</overloads>
		/// <summary>Adds from a field in a recordset</summary>
		protected bool AddAttr(XmlNode xnThis, IDataReader rdrThis, string attname, string fldname) {
			return AddAttr(this, xnThis, rdrThis, attname, fldname);
		}
		/// <summary>Adds by supplied name and value</summary>
		protected bool AddAttr(XmlDocument xmlThis, XmlNode xnThis, string attname, string attval) {
			try {
				XmlAttribute xaThis = xmlThis.CreateAttribute(attname);
				xaThis.InnerText = attval;
				xnThis.Attributes.Append(xaThis);
				return(true);
			} catch {
				return(false);
			}
		}
		/// <summary>Adds by supplied name and value</summary>
		protected bool AddAttr(XmlNode xnThis, string attname, string attval) {
			return AddAttr(this, xnThis, attname, attval);
		}
		
		/// <overloads>A safe method of getting a string from a IDataReader column when the value could be null</overloads>
		/// <summary>Uses local DataReader</summary>
		protected string GetValue(string thiscol) {
			return getSqlString(DBReader, thiscol);
		}
		/// <summary>String type assumed</summary>
		protected string GetValue(IDataReader thisrdr, string thiscol) {
			return getSqlString(thisrdr, thiscol);
		}
		/// <summary>Type specified</summary>
		protected string GetValue(string thiscol, DbType thistyp) {
			return GetValue(DBReader, thiscol, thistyp);
		}
		/// <summary>Type specified</summary>
		protected string GetValue(IDataReader thisrdr, string thiscol, DbType thistyp) {
			string thisval;
			switch (thistyp) {
				case DbType.Guid:		thisval = getSqlGuid(thisrdr, thiscol);		break;
				case DbType.Boolean:	thisval = getSqlYesNo(thisrdr, thiscol);	break;
				case DbType.Int32:		thisval = getSqlInteger(thisrdr, thiscol);	break;
				case DbType.String:	
				default:				thisval = getSqlString(thisrdr, thiscol);	break;
			}
			return thisval;
		}
		/// <summary>Parameter value - string</summary>
		protected string GetValue(IDataParameter thispar) {
			return (thispar.Value == null)? "" : thispar.Value.ToString();
		}
		/// <summary>Parameter value - string</summary>
		protected int GetValue(string thiscol, int defvalue) {
			string thisval = getSqlString(DBReader, thiscol);
			return (thisval == "")? defvalue : Convert.ToInt32(thisval);
		}
		/// <summary>Parameter value - int</summary>
		protected int GetValue(IDataParameter thispar, int defvalue) {
			return (thispar.Value == null)? defvalue : Convert.ToInt32(thispar.Value.ToString());
		}
		
		/// <overloads>Tests a value of a column for null condition</overloads>
		/// <summary>Local DataReader></summary>
		protected bool Test(string thiscol) {
			return !DBReader.IsDBNull(DBReader.GetOrdinal(thiscol));
		}
		/// <summary>Arbitary DataReader></summary>
		protected bool Test(IDataReader thisrdr, string thiscol) {
			return !thisrdr.IsDBNull(thisrdr.GetOrdinal(thiscol));
		}
		/// <summary>Tests IDataParameter for non null result</summary>
		protected bool Test(IDataParameter thispar) {
			return (thispar.Value != DBNull.Value) && (thispar.Value.ToString() != "");
		}
		#endregion
		
		#region Private methods
		/// <summary>
		/// A safe method of getting a string from a IDataReader column when the value could be null
		/// </summary>
		private string getSqlString(IDataReader thisrdr, string thiscol) {
			int thisord = thisrdr.GetOrdinal(thiscol);
			return (thisrdr.IsDBNull(thisord))? "null" : thisrdr.GetValue(thisord).ToString();
			//return (thisrdr.IsDBNull(thisord))? "" : thisrdr.GetString(thisord);
		}
		
		/// <summary>
		/// A safe method of getting a string from a IDataReader column when the value could be null
		/// </summary>
		private string getSqlInteger(IDataReader thisrdr, string thiscol) {
			int thisord = thisrdr.GetOrdinal(thiscol);
			return (thisrdr.IsDBNull(thisord))? "null" : thisrdr.GetValue(thisord).ToString();
		}
		
		/// <summary>
		/// A safe method of getting a boolean result from a IDataReader column when the value could be null
		/// </summary>
		private string getSqlYesNo(IDataReader thisrdr, string thiscol) {
			int thisord = thisrdr.GetOrdinal(thiscol);
			return (thisrdr.IsDBNull(thisord))? "no" : "yes";
		}
		
		/// <summary>
		/// A safe method of getting a guid string from a IDataReader column when the value could be null
		/// </summary>
		private string getSqlGuid(IDataReader thisrdr, string thiscol) {
			int thisord = thisrdr.GetOrdinal(thiscol);
			return (thisrdr.IsDBNull(thisord))? "" : thisrdr.GetGuid(thisord).ToString();
		}
		
		#endregion
	}
}
