Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports LocalHelper

Partial Class Agency_FeesDetail
    Inherits System.Web.UI.Page

    Private UserID As Integer
    Private NetPayments As Double

    Protected Sub Agency_FeesDetail_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim CompanyIDs As String
            Dim da As SqlDataAdapter
            Dim ds As New DataSet

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    CompanyIDs = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

                    cmd.CommandText = "SELECT CompanyID, ShortCoName FROM tblCompany"

                    If Len(CompanyIDs) > 0 Then
                        cmd.CommandText &= " WHERE CompanyID in (" & CompanyIDs & ")"
                    End If

                    cmd.CommandText &= " ORDER BY ShortCoName"

                    da = New SqlDataAdapter(cmd)
                    da.Fill(ds)

                    ddlCompany.DataSource = ds.Tables(0)
                    ddlCompany.DataTextField = "ShortCoName"
                    ddlCompany.DataValueField = "CompanyID"
                    ddlCompany.DataBind()
                End Using
            End Using

            LoadQuickPickDates()
            ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        End If
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_TKM_Fees_Paid")
            Using cmd.Connection
                Dim da As SqlDataAdapter
                Dim ds As New DataSet
                cmd.Connection.ConnectionString = "Data Source=LEXSRVSQLPROD1\LEXSRVSQLPROD;Initial Catalog=DMS;User Id=dms_sql2;Password=j@ckp0t!;"
                cmd.CommandTimeout = 180
                DatabaseHelper.AddParameter(cmd, "StartDate", txtTransDate1.Text)
                DatabaseHelper.AddParameter(cmd, "EndDate", txtTransDate2.Text & " 23:59")
                DatabaseHelper.AddParameter(cmd, "companyid", ddlCompany.SelectedItem.Value)
                da = New SqlDataAdapter(cmd)
                da.Fill(ds)
                gvPayments.DataSource = ds.Tables(0)
                gvPayments.DataBind()
            End Using
        End Using
    End Sub

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex
        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtTransDate1.Text = parts(0)
            txtTransDate2.Text = parts(1)
        End If
    End Sub

    Protected Sub gvPayments_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPayments.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f5f5f5';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                Dim imgNode As Image = CType(e.Row.FindControl("imgNode"), Image)
                Dim imgLeaf As Image = CType(e.Row.FindControl("imgLeaf"), Image)
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                'If CBool(rowView("isgca")) Then
                '    imgNode.ImageUrl = "~/images/arrow_end.png"
                '    imgNode.Style("margin-left") = "10px"
                'ElseIf Not CBool(rowView("istrust")) Then
                '    imgNode.Style("margin-left") = "40px"
                '    imgLeaf.ImageUrl = "~/images/arrow_end.png"
                'End If
                'NetPayments += Val(rowView("net"))
            Case DataControlRowType.Footer
                'e.Row.Cells(1).Text = "&nbsp;"
                'e.Row.Cells(2).Text = FormatCurrency(NetPayments, 2)
        End Select
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim CompanyIDs As String
            Dim da As SqlDataAdapter
            Dim ds As New DataSet

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    CompanyIDs = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

                    cmd.CommandText = "SELECT CompanyID, ShortCoName FROM tblCompany"

                    If Len(CompanyIDs) > 0 Then
                        cmd.CommandText &= " WHERE CompanyID in (" & CompanyIDs & ")"
                    End If

                    cmd.CommandText &= " ORDER BY ShortCoName"

                    da = New SqlDataAdapter(cmd)
                    da.Fill(ds)

                    ddlCompany.DataSource = ds.Tables(0)
                    ddlCompany.DataTextField = "ShortCoName"
                    ddlCompany.DataValueField = "CompanyID"
                    ddlCompany.DataBind()
                End Using
            End Using

            LoadQuickPickDates()
            ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        End If
    End Sub
End Class
