Imports Infragistics.WebUI.UltraWebGrid
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports System.Data

Partial Class Clients_Enrollment_ExportDetail
    Inherits System.Web.UI.Page

#Region "Variables"

    Public UserID As Integer
    Public JobId As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        JobId = Me.Request.QueryString("Id").ToString

        If Not Page.IsPostBack Then
            LoadSummary()
            LoadDetails()
        End If

    End Sub


    Protected Sub wGridPipeline_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGridPipeline.InitializeRow
        Dim ApplicantID As String = e.Row.Cells(0).Value.ToString
        e.Row.Cells(1).TargetURL = e.Row.Cells.FromKey("EnrollmentPage").Value.ToString.Trim & "?id=" & ApplicantID & "&pg=fix&fxid=" & JobId
        Dim note As String = e.Row.Cells(e.Row.Cells.Count - 1).Text
        If note Is Nothing Then note = String.Empty
        If note.Length > 60 Then e.Row.Cells(e.Row.Cells.Count - 1).Text = note.Substring(0, 60) & " ..."
        e.Row.Cells(e.Row.Cells.Count - 1).Title = note
        e.Row.Cells(e.Row.Cells.Count - 1).TitleMode = CellTitleMode.Always
    End Sub

    Private Sub uwToolbar_ButtonClicked(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebToolbar.ButtonEvent) Handles uwToolBar.ButtonClicked
        Dim l As New Label
        l.Text = e.Button.Text
        Select Case l.Text
            Case "Back"
                Response.Redirect("Default.aspx")
            Case "Export History"
                Response.Redirect("ExportReport.aspx")
            Case "Transfers to Lexxiom"
                Response.Redirect("Export.aspx")
        End Select
    End Sub

    Protected Sub dsPipe_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsPipe.Selected
        hPipeline.InnerHtml = "Export Details"
    End Sub

    Private Sub LoadSummary()
        dsSummary.SelectParameters("exportjobid").DefaultValue = JobId
        Dim dv As DataView = dsSummary.Select(DataSourceSelectArguments.Empty)
        If dv.Count > 0 Then
            Dim dr As DataRowView = dv(0)
            Me.lblApplicantCount.Text = dr("ApplicantCount").ToString
            Me.lblExecutedBy.Text = dr("ExecutedBy").ToString
            Me.lblExportDate.Text = CDate(dr("ExportDate")).ToShortDateString
            Me.lblExportStatus.Text = dr("Status").ToString
            Me.lblFailed.Text = dr("Failed").ToString
            Me.lblLeftPending.Text = dr("LeftPending").ToString
            If dr("Notes").ToString.Trim.Length > 100 Then
                Me.lblNote.Text = dr("Notes").ToString.Trim.Substring(0, 100) & " ..."
            Else
                Me.lblNote.Text = dr("Notes").ToString
            End If
            Me.lblNote.ToolTip = dr("Notes").ToString
            Me.lblReportNumber.Text = dr("ExportJobId").ToString
            Me.lblSucceeded.Text = dr("Succeeded").ToString
        End If
    End Sub

    Private Sub LoadDetails()
        dsPipe.SelectParameters("exportjobid").DefaultValue = JobId
        dsPipe.DataBind()
    End Sub

End Class
