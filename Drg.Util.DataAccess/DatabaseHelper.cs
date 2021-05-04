using System;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NullableTypes;

namespace Drg.Util.DataAccess
{
	public class DatabaseHelper
	{
		private DatabaseHelper() {}

		#region Readers
		public static void EnsureReaderClosed(IDataReader rd)
		{
			if (rd != null)
				//if (!rd.IsClosed)
					rd.Dispose();
		}

		public static void EnsureConnectionClosed(IDbConnection cn)
		{
			if (cn != null)
				if (cn.State == ConnectionState.Open)
					cn.Close();
		}

		public static string Peel_string(IDataReader rd, string field)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return string.Empty;
			else
				return rd.GetString(i);
		}
			
		public static int Peel_int(IDataReader rd, string field)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return 0;
			else
			{
				switch (rd.GetDataTypeName(i))
				{
					case "int":
						return rd.GetInt32(i);
					case "smallint":
						return rd.GetInt16(i);
					default:
						return (int)rd.GetInt64(i);
				}
			}
		}

        public static Nullable<int> Peel_nint(IDataReader rd, string field)
        {
            int i = rd.GetOrdinal(field);

            if (rd.IsDBNull(i))
                return null;
            else
                switch (rd.GetDataTypeName(i))
                {
                    case "int":
                        return rd.GetInt32(i);
                    case "smallint":
                        return rd.GetInt16(i);
                    default:
                        return (int)rd.GetInt64(i);
                }
        }

        public static Nullable<bool> Peel_nbool(IDataReader rd, string field)
        {
            int i = rd.GetOrdinal(field);

            if (rd.IsDBNull(i))
                return null;
            else
                return rd.GetBoolean(i);
        }

		public static short Peel_short(IDataReader rd, string field)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return 0;
			else
			{
				return rd.GetInt16(i);
			}
		}

		public static byte Peel_byte(IDataReader rd, string field)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return 0;
			else
			{
				return rd.GetByte(i);
			}
		}

		public static float Peel_float(IDataReader rd, string field)
		{
			return Peel_float(rd, field, 0);
		}
		
		public static float Peel_float(IDataReader rd, string field, float defaultValue)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return defaultValue;
			else
				// TODO: fix this
				return float.Parse(rd.GetValue(i).ToString());
		}

        public static Nullable<float> Peel_float_nullable(IDataReader rd, string field)
        {
            int i = rd.GetOrdinal(field);

            if (rd.IsDBNull(i))
                return null;
            else
                // TODO: fix this
                return float.Parse(rd.GetValue(i).ToString());
        }

		public static double Peel_double(IDataReader rd, string field)
		{
			return Peel_double(rd, field, 0.0);
		}
		
		public static double Peel_double(IDataReader rd, string field, double defaultValue)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return defaultValue;
			else
				// TODO: fix this
				return double.Parse(rd.GetValue(i).ToString());
		}

		public static bool Peel_bool(IDataReader rd, string field)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return false;
			else
				return rd.GetBoolean(i);
		}

        public static Nullable<DateTime> Peel_ndate(IDataReader rd, string field)
        {
            int i = rd.GetOrdinal(field);

            if (rd.IsDBNull(i))
                return null;
            else
                return rd.GetDateTime(i);
        }
        
        public static DateTime Peel_date(IDataReader rd, string field)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return DateTime.MinValue;
			else
				return rd.GetDateTime(i);
		}

		public static string Peel_datestring(IDataReader rd, string field)
		{
			return Peel_datestring(rd, field, "MM/dd/yyyy");
		}

		public static string Peel_datestring(IDataReader rd, string field, string format)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return string.Empty;
			else
				return rd.GetDateTime(i).ToString(format);
		}

		public static decimal Peel_decimal(IDataReader rd, string field)
		{
			int i = rd.GetOrdinal(field);

			if (rd.IsDBNull(i))
				return 0;
			else
				return rd.GetDecimal(i);
		}
		#endregion

		#region Commands
        public static IDataParameter CreateAndAddParamater(IDbCommand cmd, string name, DbType type)
        {
            IDataParameter parm = cmd.CreateParameter();

            parm.DbType = type;
            parm.ParameterName = "@" + name;

            cmd.Parameters.Add(parm);

            return parm;
        }

		public static void AddParameter(IDbCommand cmd, string name, object value)
		{
			AddParameter(cmd, name, value, false, DbType.Boolean, false);
		}
        public static void AddParameter(IDbCommand cmd, string name, object value, DbType Type)
        {
            AddParameter(cmd, name, value, false, Type, true);
        }
        public static void AddParameter(IDbCommand cmd, string name, object value, bool encode, DbType Type, bool HasType)
		{
			IDbDataParameter param = cmd.CreateParameter();

			param.Direction = ParameterDirection.Input;
			param.SourceColumn = "[" + name + "]";

			param.ParameterName = "@" + name;

            if (value is string)
            {
                param.DbType = DbType.String;

                if (encode)
                    param.Value = DataHelper.SqlEncode((string)value);
                else
                    param.Value = value;
            }
            else
            {
                if (value is NullableByte)
                {
                    if (((NullableByte)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableByte)value).Value;
                }
                else if (value is NullableInt16)
                {
                    if (((NullableInt16)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableInt16)value).Value;
                }
                else if (value is NullableInt32)
                {
                    if (((NullableInt32)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableInt32)value).Value;
                }
                else if (value is NullableInt64)
                {
                    if (((NullableInt64)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableInt64)value).Value;
                }
                else if (value is NullableSingle)
                {
                    if (((NullableSingle)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableSingle)value).Value;
                }
                else if (value is NullableDouble)
                {
                    if (((NullableDouble)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableDouble)value).Value;
                }
                else if (value is NullableDateTime)
                {
                    if (((NullableDateTime)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableDateTime)value).Value;
                }
                else if (value is NullableDecimal)
                {
                    if (((NullableDecimal)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableDecimal)value).Value;
                }
                else if (value is NullableBoolean)
                {
                    if (((NullableBoolean)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableBoolean)value).Value;
                }
                else if (value is NullableDateTime)
                {
                    if (((NullableDateTime)value).IsNull)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((NullableDateTime)value).Value;
                }
                else if (value is Nullable<DateTime>)
                {
                    if (!((Nullable<DateTime>)value).HasValue)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((Nullable<DateTime>)value).Value;
                }
                else if (value is Nullable<int>)
                {
                    if (!((Nullable<int>)value).HasValue)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((Nullable<int>)value).Value;
                }
                else if (value is Nullable<double>)
                {
                    if (!((Nullable<double>)value).HasValue)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((Nullable<double>)value).Value;
                }
                else if (value is Nullable<bool>)
                {
                    if (!((Nullable<bool>)value).HasValue)
                        param.Value = DBNull.Value;
                    else
                        param.Value = ((Nullable<bool>)value).Value;
                }
                else
                {
                    if (value == null)
                        param.Value = DBNull.Value;
                    else
                        param.Value = value;
                }
            }

            if (!HasType)
            {
                if (value is NullableByte || value is Nullable<byte>)
                    param.DbType = DbType.Byte;
                else if (value is short || value is NullableInt16 || value is Nullable<Int16>)
                    param.DbType = DbType.Int16;
                else if (value is int || value is NullableInt32 || value is Nullable<Int32>)
                    param.DbType = DbType.Int32;
                else if (value is long || value is NullableInt64 || value is Nullable<Int64>)
                    param.DbType = DbType.Int64;
                else if (value is float || value is NullableSingle || value is Nullable<Single>)
                    param.DbType = DbType.Single;
                else if (value is double || value is NullableDouble || value is Nullable<double>)
                    param.DbType = DbType.Double;
                else if (value is decimal || value is NullableDecimal || value is Nullable<decimal>)
                    param.DbType = DbType.Decimal;
                else if (value is bool || value is NullableBoolean || value is Nullable<Boolean>)
                    param.DbType = DbType.Boolean;
                else if (value is DateTime || value is NullableDateTime || value is Nullable<DateTime>)
                    param.DbType = DbType.DateTime;
                //else if (value is String)
                //	param.DbType = DbType.String;
            }
            else
            {
                param.DbType = Type;
            }

			cmd.Parameters.Add(param);
		}

		public static void BuildInsertCommandText(ref IDbCommand cmd, string Table)
		{
			BuildInsertCommandText(ref cmd, Table, "", SqlDbType.Int);
		}

		public static void BuildInsertCommandText(ref IDbCommand cmd, string Table, string KeyField, SqlDbType KeyType)
		{

			//Build an insert command. Should look like:
			//INSERT INTO <tableName> ([f1], [f2], ... [fn]) VALUES ([[f1], [f2], ... [fn])

			StringBuilder sql = new StringBuilder("INSERT INTO ");

			sql.Append(Table);
			sql.Append(" (");

			bool initial = true;

			for (int i = 0; i < cmd.Parameters.Count; i++) 
			{
				IDbDataParameter param = (IDbDataParameter)cmd.Parameters[i];

				if (initial)
					initial = false;
				else
					sql.Append(",");

				if (param.Direction == ParameterDirection.Input || param.Direction == ParameterDirection.InputOutput)
					sql.Append(param.SourceColumn);
			}

			sql.Append(") VALUES (");

			initial = true;

			for (int i = 0; i < cmd.Parameters.Count; i++) 
			{
				IDbDataParameter param = (IDbDataParameter)cmd.Parameters[i];

				if (initial)
					initial = false;
				else
					sql.Append(",");

				if (param.Direction == ParameterDirection.Input || param.Direction == ParameterDirection.InputOutput)
					sql.Append(param.ParameterName);
			}

			sql.Append(")");

			if (KeyField.Length > 0)
			{
				cmd.Parameters.Add(new System.Data.SqlClient.SqlParameter("@" + KeyField, KeyType));
				((IDbDataParameter)cmd.Parameters["@" + KeyField]).Direction = ParameterDirection.Output;

				sql.Append("; SELECT @" + KeyField + " = SCOPE_IDENTITY()");
			}

			cmd.CommandText = sql.ToString();

		}

		public static void BuildUpdateCommandText(ref IDbCommand cmd, string Table)
		{
			BuildUpdateCommandText(ref cmd, Table, "");
		}

		public static void BuildUpdateCommandText(ref IDbCommand cmd, string Table, string Criteria)
		{

			//Build an update command. Should look like:
			//UPDATE <table> SET [f1]=[f1], SET [f2]=[f2], ... SET [fn]=[fn] WHERE <criteria>

			StringBuilder sql = new StringBuilder("UPDATE ");

			sql.Append(Table);
			sql.Append(" SET ");

			bool initial = true;

			for (int i = 0; i < cmd.Parameters.Count; i++) 
			{
				IDbDataParameter param = (IDbDataParameter)cmd.Parameters[i];

				if (initial)
					initial = false;
				else
					sql.Append(",");

				if (param.Direction == ParameterDirection.Input || param.Direction == ParameterDirection.InputOutput)
					sql.Append(param.SourceColumn + "=" + param.ParameterName);
			}

			if (Criteria.Length > 0)
				sql.Append(" WHERE " + Criteria);

			cmd.CommandText = sql.ToString();
		}
			
		public static void ExecuteNonQuery(IDbCommand cmd)
		{
			bool opened = true;

			try
			{
				if (cmd.Connection.State != ConnectionState.Open)
					cmd.Connection.Open();
				else
					opened = false;

				cmd.ExecuteNonQuery();
			}
			finally
			{
				if (opened)
					cmd.Connection.Close();
			}
		}

		public static object ExecuteScalar(IDbCommand cmd)
		{
			bool opened = true;

			try
			{
				if (cmd.Connection.State != ConnectionState.Open)
					cmd.Connection.Open();
				else
					opened = false;

				return cmd.ExecuteScalar();
			}
			finally
			{
				if (opened)
					cmd.Connection.Close();
			}
		}

		public static IDataReader ExecuteReader(IDbCommand cmd)
		{
			return ExecuteReader(cmd, CommandBehavior.Default);
        }
              
        public static IDataReader ExecuteReader(IDbCommand cmd, CommandBehavior behavior)
		{
			bool opened = false;

			try
			{
				if (cmd.Connection.State != ConnectionState.Open)
				{
					cmd.Connection.Open();

					opened = true;
				}

				return cmd.ExecuteReader(behavior);
			}
			catch //(Exception e)
			{
				// TODO: log error
				if (opened)
					cmd.Connection.Close();

				throw;
			}
		}
		#endregion


        #region DATASET IMPLEMENTATION

        /// <summary>
        /// Returns DataSet. This implementation is added by Bereket S. Data
        /// </summary>
        /// <param name="cmd"></param>
        /// <returns></returns>
        public static DataSet ExecuteDataset(IDbCommand cmd)
        {
            DataSet dsObj = new DataSet();
            try
            {
                ExecuteDataset(cmd, ref dsObj);
                return dsObj;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (cmd != null) { cmd.Dispose(); }
            }
        }

        /// <summary>
        /// Returns DataSet. This implementation is added by Bereket S. Data
        /// </summary>
        /// <param name="cmd"></param>
        /// <returns></returns>
        public static void ExecuteDataset(IDbCommand cmd, ref DataSet dsObj)
        {
            bool opened = true;
            SqlDataAdapter adpObj = null; 
            try
            {
                if (cmd.Connection.State != ConnectionState.Open)
                {
                    cmd.Connection.Open();
                }
                else
                {
                    opened = false;
                }                
                adpObj = new SqlDataAdapter((SqlCommand)cmd);
                adpObj.Fill(dsObj);                
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (opened) { cmd.Connection.Close(); }
                if (cmd != null) { cmd.Dispose(); }
                if (adpObj != null) { adpObj.Dispose(); }
            }
        }

        #endregion

	}
}