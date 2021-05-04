using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace Drg.Util.DataAccess
{
	/// <summary>
	/// Summary description for ListHelper.
	/// </summary>
	public class ListHelper
	{
		public static void FillList(System.Web.UI.WebControls.ListControl lst, string[] str)
		{
			if (str.Length > 0)
			{
				if (str.Length == 1 && str[0].Trim().Length == 0)
					return;

				lst.DataSource = str;
				lst.DataBind();
			}
		}

		public static void FillList(System.Web.UI.WebControls.ListControl lst, string lookupTable, string dataValueField)
		{
			FillList(lst, lookupTable, dataValueField, dataValueField);
		}

		public static void FillList(System.Web.UI.WebControls.ListControl lst, string lookupTable, string dataTextField, string dataValueField)
		{
			IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

			if (lookupTable.IndexOf("SELECT") == -1)
				cmd.CommandText = "SELECT * FROM " + lookupTable;
			else
				cmd.CommandText = lookupTable;

			FillList(lst, cmd, dataTextField, dataValueField);
		}

		public static void FillList(System.Web.UI.WebControls.ListControl lst, IDbCommand cmd, string dataValueField)
		{
			FillList(lst, cmd, dataValueField, dataValueField);
		}

		public static void FillList(System.Web.UI.WebControls.ListControl lst, IDbCommand cmd, string dataTextField, string dataValueField)
		{
			IDataReader rd = DatabaseHelper.ExecuteReader(cmd);

			lst.DataTextField = dataTextField;
			lst.DataValueField = dataValueField;
			lst.DataSource = rd;

			lst.DataBind();

			rd.Close();

			cmd.Connection.Close();
		}
        public static void SetSelected(DropDownList Ddl, string Value )
        {
            foreach (ListItem li in Ddl.Items)
	        {
		         if (li.Value == Value)
                 {
                     li.Selected = true;
                 }
                 else
                 {
                     li.Selected = false;
                 }
	        }
        }
        public static void SetSelected(HtmlSelect Ddl, string Value)
        {
            foreach (ListItem li in Ddl.Items)
            {
                if (li.Value == Value)
                {
                    li.Selected = true;
                }
                else
                {
                    li.Selected = false;
                }
            }
        }

        public static object GetSelected(DropDownList Ddl)
        {
            if (Ddl.SelectedValue == null || DataHelper.Nz_int(Ddl.SelectedValue, 0) == 0)
            {
                return DBNull.Value;
            }
            else
            {
                return Ddl.SelectedValue;
            }
        }
	}
}