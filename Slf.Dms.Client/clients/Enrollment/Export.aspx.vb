Imports Infragistics.WebUI.UltraWebGrid
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports System.Data
Imports System.Collections.Generic
Imports Lexxiom.ImportClients
Imports SmartDebtorHelper

Partial Class Clients_Enrollment_Export
    Inherits System.Web.UI.Page

    Public UserID As Integer
    Private RowCounter As Int16
    Private x As Integer = 1
    Private SmartDebtorSourceId As Integer = 1
    Private _url As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)
        Me.btnTransfer.Attributes.Add("onmouseout", "this.className='transferButton'")
        Me.btnTransfer.Attributes.Add("onmouseover", "this.className='transferButtonHover'")

        If Not Page.IsPostBack Then
            dsPipe.SelectParameters("userid").DefaultValue = UserID
            dsPipe.SelectParameters("Manager").DefaultValue = Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID)
            dsPipe.DataBind()
            Try
                ViewState("URL") = Request.UrlReferrer.ToString
                _url = ViewState("URL")
            Catch ex As Exception

            End Try
        End If

    End Sub

    Public Function ReferrerURLPageOnly() As String
        Dim pages As Array
        pages = _url.Split("/")
        Return pages(pages.GetUpperBound(0))
    End Function

    Public Function ReferrerURL() As String
        Return _url
    End Function

    Protected Sub wGridPipeline_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGridPipeline.InitializeRow
        Dim leadID As String = e.Row.Cells(0).Value.ToString
        e.Row.Cells(3).TargetURL = e.Row.Cells.FromKey("EnrollmentPage").Value.ToString.Trim & "?id=" & leadID
        x += 1
    End Sub

    Private Sub uwToolbar_ButtonClicked(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebToolbar.ButtonEvent) Handles uwToolBar.ButtonClicked
        Dim l As New Label
        l.Text = e.Button.Text
        Select Case l.Text
            Case "Back"
                If _url <> "" Then
                    Response.Redirect(_url)
                Else
                    Response.Redirect("Default.aspx")
                End If
        End Select
    End Sub

    Protected Sub btnTransfer_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTransfer.Click
        BeginTheTransfer(UserID)
    End Sub
    Protected Sub dsPipe_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsPipe.Selected
        lblHeader.Text = "Select applicants to export (" & e.AffectedRows & ")"
        RowCounter = e.AffectedRows
    End Sub

    Private Sub BeginTheTransfer(ByVal UserID As Integer)
        'Prepare transfer
        Dim LeadIds As New List(Of Integer)
        Try
            For Each row As UltraGridRow In wGridPipeline.Rows
                Dim sTest As String = row.Cells(1).Value.ToString()
                If sTest.ToLower.Equals("true") Then
                    LeadIds.Add(row.Cells(0).Value)
                End If
            Next
            If LeadIds.Count = 0 Then Throw New Exception("There are no selected applicants to export.")
        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "PreExportError", String.Format("alert(""{0}"");", "There are no selected applicants to export."), True)
            Return
        End Try

        Dim ToShip As New List(Of ClientInfo)
        Dim JobId As Integer = 0
        Try
            'Create Export Job
            JobId = CreateExportJob(UserID)
            CreateExportDetails(JobId, LeadIds)
            LockClients(JobId)
            'Load the list of Applicant IDs selected for transfer to Lexxiom
            For Each LeadId As Integer In LeadIds
                Try
                    ToShip.Add(CreateClient(LeadId))
                Catch ex As Exception
                    UpdateLeadStatusForExport(JobId, LeadId, ClientImportStatus.failed, ex.Message)
                End Try
            Next
            If ToShip.Count = 0 Then Throw New Exception("There are no applicants with valid information to import.")
            Dim report As ImportReport = ProcessManager.ImportClients(ToShip, SmartDebtorSourceId)
            SaveReport(JobId, report, UserID)
            UnLockClients(JobId)
        Catch ex As Exception
            UnLockClients(JobId)
            UpdateReportStatus(JobId, ProcessStatus.failed, ex.Message)
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "ExportError", String.Format("alert(""{0}"");", ex.Message), True)
        End Try

        'end transfer
        If JobId > 0 Then Response.Redirect(String.Format("ExportDetail.aspx?id={0}", JobId))
    End Sub

    'Private Sub LockExportDetails(ByVal JobId As Integer, ByVal clients As List(Of ClientInfo), ByVal lock As Boolean)
    '    Dim lockflag As Integer = 0
    '    If lock Then lockflag = 3
    '    For Each client As ClientInfo In clients
    '        UpdateLeadStatusForExport(JobId, client.ExternalID, lockflag, String.Empty)
    '    Next
    'End Sub

    'Private Function GetSubseqMaintenanceFeeStartDate(ByVal client As ClientInfo) As DateTime
    '    Dim subdate As Date
    '    If client.SetupData.FirstDepositDate <> New Date() Then
    '        subdate = client.SetupData.FirstDepositDate
    '    ElseIf client.SetupData.DepositsStartDate <> New Date() Then
    '        subdate = client.SetupData.DepositsStartDate
    '    Else
    '        'Get the next maintenance fee day and add a year
    '        Dim monthlyfeeday As Integer = catalog.DefaultValues.MonthlyFeeDay
    '        Dim datetouse As DateTime = Now
    '        If monthlyfeeday < Now.Day Then datetouse = Now.AddMonths(1)
    '        Dim lastdayofmonth As Integer = DateTime.DaysInMonth(datetouse.Year, datetouse.Month)
    '        If monthlyfeeday > lastdayofmonth Then monthlyfeeday = lastdayofmonth
    '        subdate = New Date(datetouse.Year, datetouse.Month, monthlyfeeday)
    '    End If
    '    Return subdate.AddYears(1)
    'End Function

End Class
