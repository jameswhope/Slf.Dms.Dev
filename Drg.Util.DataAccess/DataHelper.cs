using System;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Data.SqlClient;

namespace Drg.Util.DataAccess
{
	/// <summary>
	/// Summary description for DataHelper.
	/// </summary>
	public class DataHelper
	{
        public class NonexistentTableException : Exception
        {
            string _message;

            public override string ToString()
            {
                return _message;
            }
            public NonexistentTableException(string Message)
            {
                _message = Message;
            }
        }   
        public static void SetConnectionUser(IDbConnection cn, int UserID)
        {
            if (cn.State == ConnectionState.Closed)
                cn.Open();

            using (IDbCommand cmd = cn.CreateCommand())
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stp_Audit_SetCurrentUser";
                DatabaseHelper.AddParameter(cmd, "userid", UserID);
                cmd.ExecuteNonQuery();
            }
        }
        public class FieldValue
        {
            string _field;
            object _value;

            public FieldValue()
            {
            }
            public FieldValue(string Field, object Value)
            {
                _field = Field;
                _value = Value;
            }
            public string Field
            {
                get
                {
                    return _field;
                }
                set
                {
                    _field = value;
                }
            }
            public object Value
            {
                get
                {
                    return _value;
                }
                set
                {
                    _value = value;
                }
            }
        }

    #region Audit Utils
        protected static void FillDataTable(IDbCommand cmd, DataTable dt)
        {
            IDbConnection cn = cmd.Connection;
            using (cmd)
            {
                if (cn.State == ConnectionState.Closed)
                    cn.Open();

                using (IDataReader rd = cmd.ExecuteReader())
                {
                    bool FirstTime = true;
                    while (rd.Read())
                    {
                        if (FirstTime)
                        {
                            //ensure all columns are there
                            for (int i = 0; i < rd.FieldCount; i++)
                            {
                                string colName = rd.GetName(i);
                                if (!dt.Columns.Contains(colName))
                                {
                                    dt.Columns.Add(colName, rd.GetFieldType(i));
                                }
                            }
                            FirstTime = false;
                        }
                        
                        //add the record for this row
                        DataRow dr = dt.NewRow();
                        for (int i = 0; i < rd.FieldCount; i++)
                        {
                            dr[rd.GetName(i)] = rd[i];
                        }
                        dt.Rows.Add(dr);
                    }
                }
            }
        }
        protected static void InsertAudit(int AuditColumnID, int PrimaryKey, object Value, int UC, DateTime DC, bool Deleted, bool IsBigValue, IDbConnection cn)
        {
            using (IDbCommand cmd = cn.CreateCommand())
            {
                cmd.CommandText = "insert into tblaudit(auditcolumnid, pk, [value], dc, uc, deleted) values (@AuditColumnID,@PK," + (IsBigValue ? "null" : "@value") + ",@DC, @UC, @deleted);select scope_identity()";
                if (!IsBigValue)
                    DatabaseHelper.AddParameter(cmd, "value", Value);

                DatabaseHelper.AddParameter(cmd, "AuditColumnID", AuditColumnID);
                DatabaseHelper.AddParameter(cmd, "PK", PrimaryKey);
                DatabaseHelper.AddParameter(cmd, "DC", DC);
                DatabaseHelper.AddParameter(cmd, "UC", UC);
                DatabaseHelper.AddParameter(cmd, "Deleted", Deleted);

                int AuditID = DataHelper.Nz_int(cmd.ExecuteScalar());

                if (IsBigValue)
                {
                    //insert into tblAuditBigValue
                    cmd.Parameters.Clear();
                    cmd.CommandText = "insert into tblauditbigvalue(auditid,[value]) values (@auditid, @value)";
                    DatabaseHelper.AddParameter(cmd, "auditid", AuditID);
                    DatabaseHelper.AddParameter(cmd, "value", Value);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected static void GetAuditTableInfo(IDbConnection cn, string Table, out int AuditTableID, out string PKColumn)
        {
            using (IDbCommand cmd = cn.CreateCommand())
            {
                cmd.CommandText = "select pkcolumn, audittableid from tblaudittable where [name]='" + Table + "'";
                using (IDataReader rd = cmd.ExecuteReader(CommandBehavior.SingleRow))
                {
                    if (rd.Read())
                    {
                        AuditTableID = DatabaseHelper.Peel_int(rd, "audittableid");
                        PKColumn = DatabaseHelper.Peel_string(rd, "pkcolumn");
                    }
                    else
                    {
                        throw new NonexistentTableException("Table does not exist: " + Table);
                    }
                }
            }
        }
        protected static bool AuditExists(IDbConnection cn, int AuditColumnID, int PrimaryKey)
        {
            using (IDbCommand cmd = cn.CreateCommand())
            {
                cmd.CommandText = "select case when exists (select auditid from tblaudit where auditcolumnid=" + AuditColumnID.ToString() + " and pk=" + PrimaryKey + ") then convert(bit,1) else convert(bit,0) end";
                return DataHelper.Nz_bool(cmd.ExecuteScalar());
            }
        }
        protected static DataTable FillAuditDataTable(DataTable dt, IDbConnection cn, string FieldList, string Table, String PKColumn, int PrimaryKey)
        {
            using (IDbCommand cmd = cn.CreateCommand())
            {
                cmd.CommandText = "select " + FieldList + ",created,createdby from " + Table + " where " + PKColumn + "=" + PrimaryKey.ToString();
                FillDataTable(cmd, dt);
            }
            return dt;
        }
        protected static DataTable GetAuditDataTable(IDbConnection cn, string FieldList, string Table, String PKColumn, int PrimaryKey)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("created", typeof(DateTime));
            dt.Columns.Add("createdby", typeof(int));

            return FillAuditDataTable(dt, cn, FieldList, Table, PKColumn, PrimaryKey);
        }
        protected static String GetFieldList(List<FieldValue> Updates)
        {
            string FieldList = "";
            for (int i = 0; i < Updates.Count; i++)
            {
                if (FieldList.Length > 0)
                    FieldList += ",";
                FieldList += "[" + Updates[i].Field + "]";
            }

            //add created and createdby fields if necessary
            bool hasCreated = false;
            bool hasCreatedBy = false;
            for (int i = 0; i < Updates.Count; i++)
            {
                string s = Updates[i].Field;
                if (s.ToLower() == "created")
                    hasCreated = true;
                if (s.ToLower() == "createdby")
                    hasCreatedBy = true;
            }
            if (!hasCreated) FieldList = "created," + FieldList;
            if (!hasCreatedBy) FieldList = "createdby," + FieldList;

            return FieldList;
        }
        protected static String GetFieldList(DataTable dtFields)
        {
            string FieldList = "";
            for (int i = 0; i < dtFields.Rows.Count; i++)
            {
                if (FieldList.Length > 0)
                    FieldList += ",";
                FieldList += "[" + dtFields.Rows[i]["ColumnName"] + "]";
            }

            //add created and createdby fields if necessary
            bool hasCreated = false;
            bool hasCreatedBy = false;
            for (int i = 0; i < dtFields.Rows.Count; i++)
            {
                string s = (string)dtFields.Rows[i]["ColumnName"];
                if (s.ToLower() == "created")
                    hasCreated = true;
                if (s.ToLower() == "createdby")
                    hasCreatedBy = true;
            }
            if (!hasCreated) FieldList = "created," + FieldList;
            if (!hasCreatedBy) FieldList = "createdby," + FieldList;

            return FieldList;
        }
        protected static String GetFieldList(List<String> fields)
        {
            string FieldList = "";
            for (int i = 0; i < fields.Count; i++)
            {
                if (FieldList.Length > 0)
                    FieldList += ",";
                FieldList += "[" + fields[i] + "]";
            }

            //add created and createdby fields if necessary
            bool hasCreated = false;
            bool hasCreatedBy = false;
            foreach (string s in fields)
            {
                if (s.ToLower() == "created")
                    hasCreated = true;
                if (s.ToLower() == "createdby")
                    hasCreatedBy = true;
            }
            if (!hasCreated) FieldList = "created," + FieldList;
            if (!hasCreatedBy) FieldList = "createdby," + FieldList;
            
            return FieldList;
        }
        protected static DataTable GetFieldsDescription(IDbConnection cn, int AuditTableID)
        {
            using (IDbCommand cmd = cn.CreateCommand())
            {
                DataTable dtFields = new DataTable();
                dtFields.Columns.Add("IsBigValue", typeof(bool));
                cmd.CommandText = "select AuditColumnID, [Name] as ColumnName, IsBigValue from tblauditcolumn where audittableid=" + AuditTableID;
                FillDataTable(cmd, dtFields);
                return dtFields;
            }
        }
        
    #endregion
    #region Audited Transactions
        public static void AuditedUpdate(IDbCommand cmd, string Table, int PrimaryKey, int UserID)
        {
            List<FieldValue> fields = new List<FieldValue>();
            foreach (IDataParameter p in cmd.Parameters)
            {
                fields.Add(new FieldValue(p.ParameterName.Replace("@",""), p.Value));
            }
            AuditedUpdate(fields, Table, PrimaryKey, UserID);
        }
        public static void AuditedUpdate(List<FieldValue> Updates, string Table, int PrimaryKey, int UserID)
        {
            using (IDbConnection cn = ConnectionFactory.Create(UserID))
            {
                //Get AuditTableID and PKColumn
                int AuditTableID = -1;
                string PKColumn = "";
                GetAuditTableInfo(cn, Table, out AuditTableID, out PKColumn);

                //Get fields description table
                DataTable dtFields = GetFieldsDescription(cn, AuditTableID);

                //Create audit table with old values in first row
                DataTable dtValues = GetAuditDataTable(cn, GetFieldList(Updates), Table, PKColumn, PrimaryKey);

                //Fill new values into second row of audit table
                DataRow drNew = dtValues.NewRow();
                foreach (FieldValue uv in Updates)
                    drNew[uv.Field] = uv.Value;
                dtValues.Rows.Add(drNew);

                List<string> FieldsToUpdate = new List<string>();

                //Audit where values differ
                for (int i = 2; i < dtValues.Columns.Count; i++)
                {
                    DataColumn c = dtValues.Columns[i];
                    DataRow[] drField = dtFields.Select("columnname='" + c.ColumnName + "'");
                    
                    //If this is a specified column
                    if (drField.Length > 0)
                    {
                        if (!dtValues.Rows[0][c].Equals(dtValues.Rows[1][c]))
                        {
                            int AuditColumnID = (int)drField[0]["AuditColumnID"];

                            if (!AuditExists(cn, AuditColumnID, PrimaryKey))
                                InsertAudit(AuditColumnID, PrimaryKey, dtValues.Rows[0][c.ColumnName], (int)dtValues.Rows[0]["CreatedBy"], (DateTime)dtValues.Rows[0]["Created"], false, (bool)drField[0]["IsBigValue"], cn);

                            InsertAudit(AuditColumnID, PrimaryKey, dtValues.Rows[1][c.ColumnName], UserID, DateTime.Now, false, (bool)drField[0]["IsBigValue"], cn);

                            FieldsToUpdate.Add(c.ColumnName);
                        }
                    }
                    else
                        FieldsToUpdate.Add(c.ColumnName);
                }

                //Update actual fields
                if (FieldsToUpdate.Count > 0)
                {
                    using (IDbCommand cmd = cn.CreateCommand())
                    {
                        cmd.Parameters.Clear();
                        StringBuilder UpdateCommandText = new StringBuilder();
                        UpdateCommandText.Append("update [" + Table + "] set ");
                        for (int i = 0; i < FieldsToUpdate.Count; i++)
                        {
                            UpdateCommandText.Append((i == 0 ? "[" : ",[") + FieldsToUpdate[i] + "]=@value" + i.ToString());
                            DatabaseHelper.AddParameter(cmd, "value" + i.ToString(), dtValues.Rows[1][FieldsToUpdate[i]]);
                        }
                        UpdateCommandText.Append(" where [" + PKColumn + "]=" + PrimaryKey);
                        cmd.CommandText = UpdateCommandText.ToString();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }
        public static void AuditedDelete(string Table, int PrimaryKey, int UserID)
        {
            using (IDbConnection cn = ConnectionFactory.Create(UserID))
            {
                //Get AuditTableID and PKColumn
                int AuditTableID = -1;
                string PKColumn = "";
                GetAuditTableInfo(cn, Table, out AuditTableID, out PKColumn);

                //Get fields description table
                DataTable dtFields = GetFieldsDescription(cn, AuditTableID);

                //Create audit table with old values in first row
                DataTable dtValues = GetAuditDataTable(cn, GetFieldList(dtFields), Table, PKColumn, PrimaryKey);

                //Audit all specified fields
                foreach (DataColumn c in dtValues.Columns)
                {
                    DataRow[] drField = dtFields.Select("columnname='" + c.ColumnName + "'");

                    //If this is a specified column
                    if (drField.Length > 0)
                    {
                        int AuditColumnID = (int)drField[0]["AuditColumnID"];

                        if (!AuditExists(cn, AuditColumnID, PrimaryKey))
                            InsertAudit(AuditColumnID, PrimaryKey, dtValues.Rows[0][c.ColumnName], (int)dtValues.Rows[0]["CreatedBy"], (DateTime)dtValues.Rows[0]["Created"], false, (bool)drField[0]["IsBigValue"], cn);

                        InsertAudit(AuditColumnID, PrimaryKey, dtValues.Rows[0][c.ColumnName], UserID, DateTime.Now, true, (bool)drField[0]["IsBigValue"], cn);
                    }
                }

                //Delete row
                DataHelper.Delete(Table, PKColumn + "=" + PrimaryKey);
            }
        }
        
        public static void AuditedUpdateCommand(IDbCommand cmdMain, List<string> MonitoredFields, string Table, int PrimaryKey, int UserID)
        {
            using (IDbConnection cn = cmdMain.Connection)
            {
                if (cn.State == ConnectionState.Closed)
                    cn.Open();
                
                //Get AuditTableID and PKColumn
                int AuditTableID = -1;
                string PKColumn = "";
                GetAuditTableInfo(cn, Table, out AuditTableID, out PKColumn);

                //Get fields description table
                DataTable dtFields = GetFieldsDescription(cn, AuditTableID);

                //Create audit table with old values in first row
                DataTable dtValues = GetAuditDataTable(cn, GetFieldList(MonitoredFields), Table, PKColumn, PrimaryKey);

                //Execute command
                cmdMain.ExecuteNonQuery();

                //Fill new values into second row of audit table
                FillAuditDataTable(dtValues, cn, GetFieldList(MonitoredFields), Table, PKColumn, PrimaryKey);

                //Compare and audit where different
                foreach (DataColumn c in dtValues.Columns)
                {
                    DataRow[] drField = dtFields.Select("columnname='" + c.ColumnName + "'");

                    //If this is a specified column, and a change has been made
                    if (drField.Length > 0 && (!dtValues.Rows[0][c.ColumnName].Equals(dtValues.Rows[1][c.ColumnName])))
                    {
                        int AuditColumnID = (int)drField[0]["AuditColumnID"];
                        
                        if (!AuditExists(cn, AuditColumnID, PrimaryKey))
                            InsertAudit(AuditColumnID, PrimaryKey, dtValues.Rows[0][c.ColumnName], (int)dtValues.Rows[0]["CreatedBy"], (DateTime)dtValues.Rows[0]["Created"], false, (bool)drField[0]["IsBigValue"], cn);

                        InsertAudit(AuditColumnID, PrimaryKey, dtValues.Rows[1][c.ColumnName], UserID, DateTime.Now, false, (bool)drField[0]["IsBigValue"], cn);
                    }
                }
            }
        }
    #endregion

		private DataHelper() {}

		#region Null to zero
		public static object Nz(object value)
		{
			return Nz(value, string.Empty);
		}

		public static object Nz(object value, object defaultValue)
		{
			if (value is DBNull || value == null)
				return defaultValue;
			else
				return value;
		}

		public static string Nz(object value, string defaultValue)
		{
			return Nz(value, (object)defaultValue).ToString();
		}

		public static string Nz_string(object value)
		{
			return Nz(value, string.Empty);
		}

		public static float Nz_float(object value)
		{
			return Nz_float(value, 0);
		}

		public static float Nz_float(object value, float defaultValue)
		{
			if (value is DBNull || value == null)
				return defaultValue;
			else
				return (float)value;
		}

		public static double Nz_double(object value)
		{
			return Nz_double(value, 0.0);
		}

		public static double Nz_double(object value, double defaultValue)
		{
			if (value is DBNull || value == null)
				return defaultValue;
			else
			{
				if (value is string)
				{
					if (value.ToString() == string.Empty)
						return defaultValue;
					else
						return double.Parse(value.ToString());
				}
				else
					return System.Convert.ToDouble(value);
			}
		}

		public static int Nz_int(object value)
		{
			return Nz_int(value, 0);
		}

		public static int Nz_int(object value, int defaultValue)
		{
			if (value is DBNull || value == null)
				return defaultValue;
			else
			{
				if (value is string)
				{
					if (value.ToString() == string.Empty)
						return defaultValue;
					else
						return int.Parse(value.ToString());
				}
				else
					return System.Convert.ToInt32(value);
			}
		}

		public static long Nz_long(object value)
		{
			return Nz_long(value, 0);
		}

		public static long Nz_long(object value, long defaultValue)
		{
			if (value is DBNull || value == null)
				return defaultValue;
			else
			{
				if (value is string)
				{
					if (value.ToString() == string.Empty)
						return defaultValue;
					else
						return long.Parse(value.ToString());
				}
				else
					return System.Convert.ToInt64(value);
			}
		}

		public static bool Nz_bool(object value)
		{
			return Nz_bool(value, false);
		}

		public static bool Nz_bool(object value, bool defaultValue)
		{
			if (value is DBNull || value == null)
				return defaultValue;
			else
			{
				if (value is string)
				{
					if (value.ToString() == string.Empty)
						return defaultValue;
					else
						return bool.Parse(value.ToString());
				}
				else
					return System.Convert.ToBoolean(value);
			}
		}

        public static Nullable<DateTime> Nz_ndate(object value)
        {
            return Nz_ndate(value, null);
        }

        public static Nullable<DateTime> Nz_ndate(object value, Nullable<DateTime> defaultValue)
        {
            if (value is DBNull || value == null)
            {
                return defaultValue;
            }
            else
            {
                if (value is string)
                {
                    if (value.ToString() == string.Empty)
                        return defaultValue;
                    else
                        return DateTime.Parse(value.ToString());
                }
                else
                {
                    return (DateTime)value;
                }
            }
        }

        public static DateTime Nz_date(object value)
		{
			return Nz_date(value, DateTime.MinValue);
		}

		public static DateTime Nz_date(object value, DateTime defaultValue)
		{
			if (value is DBNull || value == null)
			{
				return defaultValue;
			}
			else
			{
				if (value is string)
				{
					if (value.ToString() == string.Empty)
						return defaultValue;
					else
						return DateTime.Parse(value.ToString());
				}
				else
				{
					return (DateTime)value;
				}
			}
		}

		public static string Nz_datestring(object value)
		{
			return Nz_datestring(value, "", "MM/dd/yyyy");
		}

		public static string Nz_datestring(object value, string defaultValue, string format)
		{
			if (value is DBNull || value == null)
				return defaultValue;
			else
				return ((DateTime)value).ToString(format);
		}

		#endregion

        public static void Delete(string Table)
        {
            Delete(Table, "1=1");
        }
        public static void Delete(string Table, string Criteria)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            cmd.CommandText = "DELETE FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
        public static void FieldUpdate(string Table, string Field, object Value)
        {
            FieldUpdate(Table, Field, Value, "1=1");
        }
        public static void FieldUpdate(string Table, string Field, object Value, string Criteria)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            DatabaseHelper.AddParameter(cmd, Field, Value);

            DatabaseHelper.BuildUpdateCommandText(ref cmd, Table, Criteria);

            try
            {
                cmd.Connection.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
        public static int[] FieldLookupIDs(string Table, string Field, string Criteria)
        {
            IDataReader rd = null;
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            List<int> Ids = new List<int>();

            cmd.CommandText = "SELECT [" + Field + "] FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    Ids.Add(DatabaseHelper.Peel_int(rd, Field));
                }
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }

            return Ids.ToArray();
        }

        public static string[] FieldLookupIDs_string(string Table, string Field, string Criteria)
        {
            IDataReader rd = null;
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            List<string> Ids = new List<string>();

            cmd.CommandText = "SELECT [" + Field + "] FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    Ids.Add(DatabaseHelper.Peel_int(rd, Field).ToString());
                }
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }

            return Ids.ToArray();
        }
        
        public static string FieldLookup(string Table, string Field, string Criteria)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            cmd.CommandText = "SELECT [" + Field + "] FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                return DataHelper.Nz_string(cmd.ExecuteScalar());
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
        public static bool TableExists(string Table)
        {
            return RecordExists(Table, null);
        }
        public static bool RecordExists(string Table, string Criteria)
        {
            using (IDbCommand cmd = ConnectionFactory.Create().CreateCommand())
            {
                if (Criteria != null && Criteria.Length > 0)
                {
                    cmd.CommandText = "SELECT COUNT(*) FROM [" + Table + "] WHERE " + Criteria;
                }
                else
                {
                    cmd.CommandText = "SELECT COUNT(*) FROM [" + Table + "]";
                }

                using (cmd.Connection)
                {
                    cmd.Connection.Open();
                    return Nz_int(cmd.ExecuteScalar()) != 0;
                }
            }
        }
        public static double FieldSum(string Table, string Field)
        {
            return FieldSum(Table, Field, "1=1");
        }
        public static double FieldSum(string Table, string Field, string Criteria)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            cmd.CommandText = "SELECT SUM([" + Field + "]) FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                return DataHelper.Nz_double(cmd.ExecuteScalar());
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
        public static int FieldCount(string Table, string Field)
        {
            return FieldCount(Table, Field, "1=1");
        }
        public static int FieldCount(string Table, string Field, string Criteria)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            cmd.CommandText = "SELECT COUNT([" + Field + "]) FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                return DataHelper.Nz_int(cmd.ExecuteScalar());
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
        public static string FieldMax(string Table, string Field)
        {
            return FieldMax(Table, Field, "1=1");
        }
        public static string FieldMax(string Table, string Field, string Criteria)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            cmd.CommandText = "SELECT MAX([" + Field + "]) FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                return DataHelper.Nz_string(cmd.ExecuteScalar());
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
        public static string FieldTop1(string Table, string Field)
        {
            return FieldTop1(Table, Field, null, null);
        }
        public static string FieldTop1(string Table, string Field, string Criteria)
        {
            return FieldTop1(Table, Field, Criteria, null);
        }
        public static string FieldTop1(string Table, string Field, string Criteria, string OrderBy)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            if (Criteria != null && Criteria.Length > 0)
            {
                Criteria = " WHERE " + Criteria;
            }

            if (OrderBy != null && OrderBy.Length > 0)
            {
                OrderBy = " ORDER BY " + OrderBy;
            }

            cmd.CommandText = "SELECT TOP 1 [" + Field + "] FROM [" + Table + "]" + Criteria + OrderBy;

            try
            {
                cmd.Connection.Open();
                return DataHelper.Nz_string(cmd.ExecuteScalar());
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
        public static string FieldMin(string Table, string Field)
        {
            return FieldMin(Table, Field, "1=1");
        }
        public static string FieldMin(string Table, string Field, string Criteria)
        {
            IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

            cmd.CommandText = "SELECT MIN([" + Field + "]) FROM [" + Table + "] WHERE " + Criteria;

            try
            {
                cmd.Connection.Open();
                return DataHelper.Nz_string(cmd.ExecuteScalar());
            }
            finally
            {
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
            }
        }
		public static string GenerateSHAHash(string Password)
		{
			byte[] data;
			SHA1 hasher = SHA1.Create();

			data = hasher.ComputeHash(Encoding.ASCII.GetBytes(Password.Trim()));

			StringBuilder sb = new StringBuilder(data.Length * 2, data.Length * 2);

			for (int i = 0; i < data.Length; i++)
				sb.Append(data[i].ToString("x").PadLeft(2, '0'));

			return sb.ToString();
		}

		public static string StripTime(string Field)
		{
			return "CAST(CONVERT(char(10), " + Field + ", 101) AS datetime)";
		}

		public static object Zn(string value)
		{
			if (value == null || value.Length == 0)
				return DBNull.Value;
			else
				return value;
		}

		public static object Zn(int value)
		{
			if (value == 0)
				return DBNull.Value;
			else
				return value;
		}

        public static object Zn(double value)
        {
            if (value == 0.0)
                return DBNull.Value;
            else
                return value;
        }

        public static object Zn_double(string value)
        {
            if (value == null || value.Length == 0)
                return DBNull.Value;
            else
                return double.Parse(value);
        }
        #region String manipulation
		public static string Format(string value, string format)
		{
			if (value.Length > 0)
			{
				string[] parts = format.Split('@');

				string actualFormat = null;

				if (parts.Length > 1)
					actualFormat = string.Join("@", parts, 1, parts.Length - 1).Replace('@', ':');

				string dataType = parts[0];

				switch (dataType)
				{
					case "date":
						if (actualFormat == null)
							actualFormat = "dd MMM yyyy";

						DateTime dt = DateTime.Parse(value);

						return dt.ToString(actualFormat);
					case "number":
						if (actualFormat == null)
							actualFormat = "#";

						double d = double.Parse(value);

						return string.Format(actualFormat, d);
					case "bool":
						bool b = bool.Parse(value);

						if (b)
							return "Yes";
						else
							return "No";
					default:
						return value;
				}
			} 
			else
			{
				return string.Empty;
			}
		}

		public static string DelimitField(string value, string fieldType)
		{
			if (value.Length == 0)
				return "NULL";

			switch (fieldType)
			{
				case "string":
				case "date":
					return "'" + value + "'";
				case "bit":
					return bool.Parse(value) ? "1" : "0";
				default:
					return value;
			}
		}

		public static string GetFieldType(object value)
		{
			if (value is string || value is char)
				return "string";
			else if (value is DateTime)
				return "date";
			else if (value is bool)
				return "bit";
			else
				return "number";
		}

		public static string SqlEncode(string value)
		{
			return HttpUtility.HtmlEncode(value.Replace("'", "''"));
		}

		public static string Truncate(string value, int length)
		{
			if (value == null)
				return null;
			else if (value.Length <= length)
				return value;
			else
				return value.Substring(0, length);
		}
		#endregion
	}
}
