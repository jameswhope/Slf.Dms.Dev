using System;
using System.Configuration;
using System.Data;
using System.Data.OracleClient;
using System.Data.SqlClient;

namespace Drg.Util.DataAccess
{
	public class ConnectionFactory
	{
		static string _cnString;
		static string _provider;

		private ConnectionFactory()	{}

		public static IDbConnection Create()
		{
			if (_cnString == null)
				_cnString = ConfigurationSettings.AppSettings["connectionstring"];

			if (_provider == null)
				_provider = ConfigurationSettings.AppSettings["dataprovider"];

			return Create(_cnString, _provider);
		}

		public static IDbConnection Create(string cnString)
		{
			return Create(cnString, "sqlserver");
		}
        public static IDbConnection Create(int UserID)
        {
            IDbConnection cn = Create();
            DataHelper.SetConnectionUser(cn, UserID);
            return cn;
        }
		public static IDbConnection Create(string cnString, string provider)
		{
			switch (provider)
			{
				case "sqlserver":
					return new SqlConnection(cnString);
				case "oracle":
					return new OracleConnection(cnString);
				default:
					return null;
			}
		}

		public static IDbCommand CreateCommand(string spName)
		{
			IDbCommand cmd = Create().CreateCommand();

			cmd.CommandText = spName;
			cmd.CommandType = CommandType.StoredProcedure;

			return cmd;
		}
	}
}