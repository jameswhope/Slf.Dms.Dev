Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Reporting.WebForms
Imports Microsoft.ReportingServices
Imports Drg.Util.DataAccess
Imports System.Web.UI.Control

Partial Class Agency_FeesBreakdown
    Inherits System.Web.UI.Page
    Private ReportType As String = ""
    Private ReportPath As String = ""
    Private UserID As String = ""
    Private UserCommRecID As String
    Private UserGroupdID As String
    Private sqlReport As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserGroupdID = DataHelper.FieldLookup("tblUser", "UserGroupID", "Userid = " & UserID)
        UserCommRecID = DataHelper.FieldLookup("tblUser", "CommRecID", "Userid = " & UserID)

        'sender.ddlcompany.text = "TKM"

        Dim cn As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings.Item("connectionstring").ToString)
        cn.open()
        Dim cmd As New SqlCommand("stp_TKM_Fees_Paid", cn)
        Dim dsProd As New DataSet
        Dim drProd As SqlDataReader
        Dim dtProd As New DataTable
        cmd.CommandType = CommandType.StoredProcedure
        drProd = cmd.ExecuteReader()
        dtProd.Load(drProd)
        dsProd.Tables.Add(dtProd)
        dsProd.Tables(0).TableName = "Fees"
        dsProd.Tables(0).Load(drProd)
        cmd.Connection.Close()

        'set viewer mode
        Me.ReportViewer2.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local
        ReportType = Request.QueryString("rpt")

        ReportPath = "TKM_Fees.rdl"

        Me.ReportViewer2.LocalReport.ReportPath = "Agency/" & ReportPath

        Me.ReportViewer2.LocalReport.DisplayName = "rpt"
        'Assign dataset to report datasource
        Dim datasource As ReportDataSource = New ReportDataSource("dsProd", dsProd.Tables(0))

        'Assign datasource to reportviewer control
        ReportViewer2.LocalReport.DataSources.Clear()
        ReportViewer2.LocalReport.DataSources.Add(datasource)
        ReportViewer2.LocalReport.Refresh()
        Me.ReportViewer2.DataBind()
        Me.ReportViewer2.Visible = True
    End Sub

End Class
