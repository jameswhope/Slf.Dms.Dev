Imports Infragistics.WebUI.UltraWebGrid
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports System.Data

Partial Class Clients_Enrollment_ExportReport
    Inherits System.Web.UI.Page

#Region "Variables"

    Public UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            Me.wGridPipeline.DataBind()
        End If

    End Sub

    Private Function GetJobs() As DataSet
        Dim ds As New DataSet
        Dim dt As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_enrollment_getExportJobs"
        dt = DatabaseHelper.ExecuteDataset(cmd).Tables(0)
        dt.TableName = "Jobs"
        ds.Tables.Add(dt.Copy)
        cmd.CommandText = "stp_enrollment_getAllExportDetails"
        dt = DatabaseHelper.ExecuteDataset(cmd).Tables(0)
        dt.TableName = "Details"
        ds.Tables.Add(dt.Copy)
        ds.Relations.Add("Jobs", ds.Tables("Jobs").Columns("ExportJobID"), ds.Tables("Details").Columns("ExportJobId"))
        Return ds
    End Function

    Protected Sub wGridPipeline_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles wGridPipeline.dataBinding
        Dim dv As DataView = GetJobs().Tables("Jobs").DefaultView
        Me.wGridPipeline.DataSource = dv
        hPipeline.InnerHtml = "Export Jobs (" & dv.Count & ")"
    End Sub

    Protected Sub wGridPipeline_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGridPipeline.InitializeRow
        Select Case e.Row.Band.Index
            Case 0
                Dim jobID As String = e.Row.Cells(0).Value.ToString
                e.Row.Cells(0).TargetURL = "ExportDetail.aspx?id=" & jobID
            Case 1
                'Dim LeadID As String = e.Row.Cells(0).Value.ToString
                'Dim jobID As String = e.Row.Cells(1).Value.ToString
                'e.Row.Cells(3).TargetURL = "NewEnrollment.aspx?id=" & LeadID & "&pg=fix&fxid=" & jobID
        End Select
    End Sub

    Private Sub uwToolbar_ButtonClicked(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebToolbar.ButtonEvent) Handles uwToolBar.ButtonClicked
        Dim l As New Label
        l.Text = e.Button.Text
        Select Case l.Text
            Case "Back"
            Response.Redirect("Default.aspx")
        End Select
    End Sub

    Protected Sub wGridPipeline_PageIndexChanged(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.PageEventArgs) Handles wGridPipeline.PageIndexChanged
        Me.wGridPipeline.DisplayLayout.Pager.CurrentPageIndex = e.NewPageIndex
        Me.wGridPipeline.DataBind()
    End Sub
End Class
