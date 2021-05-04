Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls
Imports system.Data.SqlClient
Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class util_pop_addrelation
    Inherits System.Web.UI.Page

    Dim RelationTable As String
    Dim ObjIDField As String
    Dim ObjID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            PopulateRelationTypes()
        End If

        Dim ToType As String = Request.QueryString("to")
        ObjID = Integer.Parse(Request.QueryString("toid"))
        RelationTable = "tbl" + ToType + "relation"
        ObjIDField = ToType + "id"

        Requery()
    End Sub
    Private Sub PopulateRelationTypes()
        ListHelper.FillList(ddlRelationType, "tblRelationType", "Name", "RelationTypeID")
    End Sub

    Private Sub Requery()
        Dim sb As New StringBuilder()

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_getrelatables")
        DatabaseHelper.AddParameter(cmd, "relationtypeid", ddlRelationType.SelectedValue)
        DatabaseHelper.AddParameter(cmd, "dependencyid", Integer.Parse(Request.QueryString("dependencyid")))
        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable()

        da.Fill(dt)

        Dim sbHeaders As New StringBuilder
        For i As Integer = 1 To dt.Columns.Count - 1
            sbHeaders.Append("<th align=""left"">")
            sbHeaders.Append(dt.Columns(i).ColumnName)
            sbHeaders.Append("</th>")
        Next
        ltrHeaders.Text = sbHeaders.ToString

        If dt.Rows.Count > 0 Then
            For Each r As DataRow In dt.Rows
                sb.Append("<a href=""#"" onclick=""RowClick(this.childNodes(0), " & r(0) & ");""><tr>")
                For i As Integer = 1 To dt.Columns.Count - 1
                    sb.Append("<td>")
                    Dim o As Object = r(i)
                    sb.Append(o.ToString())
                    sb.Append("&nbsp;</td>")
                Next
                sb.Append("</tr></a>")
            Next
            ltrGrid.Text = sb.ToString
        Else
            ltrGrid.Text = ""
        End If

    End Sub

    Protected Sub lnkAction_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAction.Click
        Dim RelationID As Integer = DataHelper.Nz_int(txtRelationID.Value, 0)
        Dim RelationTypeID As Integer = Integer.Parse(ddlRelationType.SelectedValue)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
            Using cmd.Connection
                cmd.CommandText = "insert into " & RelationTable & "(" & ObjIDField & ",relationtypeid,relationid) values (@objidfield,@relationtypeid,@relationid)"

                DatabaseHelper.AddParameter(cmd, ObjIDField, ObjID)
                DatabaseHelper.AddParameter(cmd, "relationtypeid", RelationTypeID)
                DatabaseHelper.AddParameter(cmd, "relationid", RelationID)

                DatabaseHelper.BuildInsertCommandText(cmd, RelationTable)

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Page.ClientScript.RegisterStartupScript(Me.GetType, "exit", "DoRefresh();", True)
    End Sub
End Class