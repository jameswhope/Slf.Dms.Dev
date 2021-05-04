using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace DailyReportsForManagers
{
    class SQLHelper
    {
        public static void ExecuteNonQuery(String cmdText, CommandType cmdType = CommandType.StoredProcedure, List<SqlParameter> paramList = null)
        {

            SqlCommand cmd = new SqlCommand();

            try
            {
                cmd.CommandType = cmdType;
                cmd.CommandText = cmdText;
                if (paramList != null)
                {
                    cmd.Parameters.AddRange(paramList.ToArray());
                }
                cmd.Connection = new SqlConnection("server= lexxware.westus2.cloudapp.azure.com,1433;uid=401Hr3m487%;pwd=&Dogv@S3lfish$;Database=DMS;connect timeout=180");
                cmd.Connection.Open();
                cmd.ExecuteNonQuery();
            }
            catch (DbException e)
            {
                throw e;
            }
            finally
            {
                if (cmd.Connection.State != ConnectionState.Closed)
                {
                    cmd.Connection.Close();
                }
                cmd.Dispose();
                cmd = null;
            }
        }

        public static DataTable GetDataTable(String cmdText, CommandType cmdType = CommandType.StoredProcedure, List<SqlParameter> paramList = null)
        {

            SqlCommand cmd = new SqlCommand();
            DataTable dtTemp = new DataTable();

            try
            {
                cmd.CommandType = cmdType;
                cmd.CommandText = cmdText;
                if (paramList != null)
                {
                    cmd.Parameters.AddRange(paramList.ToArray());
                }
                cmd.Connection = new SqlConnection("server=lexxware.westus2.cloudapp.azure.com,1433;uid=401Hr3m487%;pwd=&Dogv@S3lfish$;Database=DMS;connect timeout=180");
                cmd.Connection.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                dtTemp.Load(reader);
            }
            catch (DbException e)
            {
                throw e;
            }
            finally
            {
                if (cmd.Connection.State != ConnectionState.Closed)
                {
                    cmd.Connection.Close();
                }
                cmd.Dispose();
                cmd = null;
            }

            return dtTemp;
        }

        public static DataSet GetDataSet(String cmdText, CommandType cmdType = CommandType.StoredProcedure, List<SqlParameter> paramList = null)
        {

            SqlCommand cmd = new SqlCommand();
            DataSet dsTemp = new DataSet();

            try
            {
                cmd.CommandType = cmdType;
                cmd.CommandText = cmdText;
                cmd.CommandTimeout = 360; //6min
                if (paramList != null)
                {
                    cmd.Parameters.AddRange(paramList.ToArray());
                }
                cmd.Connection = new SqlConnection("server=lexxware.westus2.cloudapp.azure.com,1433;uid=401Hr3m487%;pwd=&Dogv@S3lfish$;Database=DMS;connect timeout=180");
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dsTemp);
            }
            catch (DbException e)
            {
                throw e;
            }
            finally
            {
                if (cmd.Connection.State != ConnectionState.Closed)
                {
                    cmd.Connection.Close();
                }
                cmd.Dispose();
                cmd = null;
            }

            return dsTemp;
        }

        public static Object ExecuteScalar(String cmdText, CommandType cmdType = CommandType.StoredProcedure, List<SqlParameter> paramList = null)
        {

            SqlCommand cmd = new SqlCommand();
            Object obj = new Object();

            try
            {
                cmd.CommandType = cmdType;
                cmd.CommandText = cmdText;
                if (paramList != null)
                {
                    cmd.Parameters.AddRange(paramList.ToArray());
                }
                cmd.Connection = new SqlConnection("server=lexxware.westus2.cloudapp.azure.com,1433;uid=401Hr3m487%;pwd=&Dogv@S3lfish$;Database=DMS;connect timeout=180");
                cmd.Connection.Open();
                obj = cmd.ExecuteScalar();
            }
            catch (DbException e)
            {
                throw e;
            }
            finally
            {
                if (cmd.Connection.State != ConnectionState.Closed)
                {
                    cmd.Connection.Close();
                }
                cmd.Dispose();
                cmd = null;
            }
            return obj;
        }
    }
}