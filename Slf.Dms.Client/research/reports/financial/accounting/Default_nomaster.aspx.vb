Imports System.Collections.Generic
Imports Microsoft.Reporting
Imports Microsoft.Reporting.WebForms
Imports Drg.Util.DataAccess
Imports LocalHelper
Imports System.Data.SqlClient

Partial Class research_reports_financial_accounting_Default_nomaster
    Inherits System.Web.UI.Page

    Private ReportType As String = ""
    Private ReportPath As String = ""
    Private UserID As String = ""
    Private CompanyID As Integer = -1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If

        If IsNumeric(Request.QueryString("c")) Then
            CompanyID = CInt(Request.QueryString("c"))
        End If

        ReportType = Request.QueryString("rpt")

        'set viewer mode
        Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local

        Select Case ReportType
            Case "disb_2"
                lblMsg.Text = "Disbursement Report"
                lblMsg.Visible = False

                Me.tblDates.Style("display") = ""
                ReportPath = "Disbursement_Report_2.rdlc"
        End Select

        If Not IsPostBack Then
            LoadQuickPickDates()
            ViewReport()
        End If

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
            txtStart.Text = parts(0)
            txtEnd.Text = parts(1)
        End If

    End Sub

    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        ViewReport()
    End Sub

    Private Sub ViewReport()
        Dim dtD As New Data.DataTable
        Dim StartDate As Date
        Dim EndDate As Date
        Dim firmid As String

        'set report 
        Me.ReportViewer1.LocalReport.ReportPath = "research/reports/financial/accounting/" & ReportPath

        If Me.tblFirm.Style("display") <> "none" Then
            'cpa reports
            firmid = ddlFirm.SelectedValue.ToString
        Else
            Select Case Me.ReportType
                Case "disb_2"
                    StartDate = CDate(Me.txtStart.Text.ToString)
                    EndDate = CDate(Me.txtEnd.Text.ToString & " 23:59:59")
            End Select
        End If

        Try
            Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_DisbursementReport")
                Using cmd.Connection
                    DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                    DatabaseHelper.AddParameter(cmd, "StartDate", StartDate)
                    DatabaseHelper.AddParameter(cmd, "EndDate", EndDate)
                    DatabaseHelper.AddParameter(cmd, "CompanyID", CompanyID)

                    cmd.CommandTimeout = 360

                    Using da As SqlDataAdapter = New Data.SqlClient.SqlDataAdapter(cmd)
                        da.Fill(dtD)
                    End Using
                End Using
            End Using

            'Assign dataset to report datasource
            Dim datasource As ReportDataSource = New ReportDataSource("dsReportData", dtD)

            'Assign datasource to reportviewer control
            ReportViewer1.LocalReport.DataSources.Clear()
            ReportViewer1.LocalReport.DataSources.Add(datasource)
            ReportViewer1.LocalReport.Refresh()
            ReportViewer1.DataBind()
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message & vbCrLf & ex.InnerException.ToString
        End Try

    End Sub

    Private Function GetColValue(ByVal dr As System.Data.DataRow) As String
        Return dr(0).ToString
    End Function

    Protected Sub ddlQuickPickDate_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = DirectCast(sender, DropDownList)

        If ddl.SelectedValue.ToString <> "Custom" Then
            Dim parts As String() = ddl.SelectedValue.Split(",")
            txtStart.Text = parts(0)
            txtEnd.Text = parts(1)
        End If
    End Sub

End Class
