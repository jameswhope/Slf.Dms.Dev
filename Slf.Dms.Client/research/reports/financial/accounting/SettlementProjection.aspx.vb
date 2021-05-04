Imports Microsoft.Reporting
Imports Microsoft.Reporting.WebForms
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Linq

Partial Class research_reports_financial_accounting_SettlementProjection
    Inherits ReportPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                 GlobalFiles.JQuery.UI, _
                                                 "~/jquery/json2.js", _
                                                 "~/jquery/jquery.multiselect.min.js" _
                                                 })
        If Not Me.IsPostBack Then
            LoadCompanys()
            LoadAgencies()
            LoadMonths()
            Me.hdnFirstLoad.Value = "1"
        Else
            Me.hdnFirstLoad.Value = "0"
            Me.lblMsg.Text = ""
        End If
    End Sub

    Private Sub LoadCompanys()
        Dim co As New Drg.Util.DataHelpers.CompanyHelper
        Me.ddlCompany.DataSource = co.CompanyList()
        Me.ddlCompany.DataValueField = "companyid"
        Me.ddlCompany.DataTextField = "shortconame"
        Me.ddlCompany.DataBind()
    End Sub

    Private Sub LoadAgencies()
        Dim ag As New Drg.Util.DataHelpers.AgencyHelper
        Me.ddlAgency.DataSource = ag.GetAgencies
        Me.ddlAgency.DataValueField = "agencyid"
        Me.ddlAgency.DataTextField = "code"
        Me.ddlAgency.DataBind()
    End Sub

    Private Sub LoadMonths()
        Me.ddlMonths.Items.Clear()
        Me.ddlMonths.Items.Add(New ListItem("6 months", "6"))
        Me.ddlMonths.Items.Add(New ListItem("12 months", "12"))
        Me.ddlMonths.Items.Add(New ListItem("24 months", "24"))
        Me.ddlMonths.Items.Add(New ListItem("36 months", "36"))
        Me.ddlMonths.Items.Add(New ListItem("48 months", "48"))
        Me.ddlMonths.Items.Add(New ListItem("72 months", "72"))
        Me.ddlMonths.SelectedIndex = 1
    End Sub

    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        Try

            Dim reportDate As DateTime = CDate(GetLatestReportDate())
            Dim months As Integer = Me.ddlMonths.SelectedValue
            Dim companies As String = String.Join(",", (From item As ListItem In ddlCompany.Items Where item.Selected Select item.Value).ToArray)
            If companies.Trim.Length = 0 Then Throw New Exception("Please select a law firm.")
            Dim agencies As String = String.Join(",", (From item As ListItem In ddlAgency.Items Where item.Selected Select item.Value).ToArray)
            If agencies.Trim.Length = 0 Then Throw New Exception("Please select an agency")

            Me.ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local

            'set report 
            Me.ReportViewer1.LocalReport.ReportPath = "research/reports/financial/accounting/" & "SettlementProjection.rdl"

            Dim params As New List(Of ReportParameter)
            params.Add(New ReportParameter("reportdate", reportDate))
            params.Add(New ReportParameter("months", months))
            params.Add(New ReportParameter("CompanyIds", companies))
            params.Add(New ReportParameter("AgencyIds", agencies))


            Me.ReportViewer1.LocalReport.SetParameters(params.ToArray)

            Dim dt As DataTable = GetReportData(reportDate, months, companies, agencies)

            'Assign dataset to report datasource
            Dim datasource As ReportDataSource = New ReportDataSource("ReportDataDS", dt)

            'Assign datasource to report viewer control
            ReportViewer1.LocalReport.DataSources.Clear()
            ReportViewer1.LocalReport.DataSources.Add(datasource)
            ReportViewer1.LocalReport.Refresh()


            ReportViewer1.DataBind()
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
        End Try

    End Sub

    Private Function GetReportData(ByVal ReportDate As DateTime, ByVal Months As Integer, ByVal CompanyIds As String, ByVal AgencyIds As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("reportdate", SqlDbType.DateTime)
        param.Value = ReportDate
        params.Add(param)

        param = New SqlParameter("months", SqlDbType.Int)
        param.Value = Months
        params.Add(param)

        param = New SqlParameter("companyids", SqlDbType.VarChar)
        param.Value = CompanyIds
        params.Add(param)

        Dim selectedagencies As String() = (From item As ListItem In ddlAgency.Items Where item.Selected Select item.Value).ToArray
        param = New SqlParameter("agencyids", SqlDbType.VarChar)
        param.Value = AgencyIds
        params.Add(param)

        Return SqlHelper.GetDataTable("stp_Settlement_Projection_Data", CommandType.StoredProcedure, params.ToArray)
    End Function

    Private Function GetLatestReportDate() As DateTime
        Try
            Return SqlHelper.ExecuteScalar("select max(reportdate) from tblSettlementDailyProjection", CommandType.Text)
        Catch ex As Exception
            Return Today
        End Try
    End Function

End Class
