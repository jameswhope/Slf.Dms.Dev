Imports Infragistics.WebUI.UltraWebGrid
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class util_pop_aging
    Inherits System.Web.UI.Page

   Private UserID As Integer

   Protected Sub grdAging_InitializeDataSource(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.UltraGridEventArgs) Handles grdAging.InitializeDataSource

      Me.grdAging.DataSource = Nothing
      Me.grdAging.DataSource = LeadHelper.getReportDataSet(LeadHelper.GetAgingSQL, "Add/Update")
      Me.grdAging.DataBind()

      grdAging.Columns(0).Hidden = True
      grdAging.Columns(1).Header.Caption = ""

   End Sub

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      ' Who's making the changes
      UserID = DataHelper.Nz_int(Page.User.Identity.Name)
   End Sub

   Protected Sub grdAging_AddRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles grdAging.AddRow
      Dim ds As DataSet = LeadHelper.getReportDataSet(LeadHelper.GetAgingSQL, "AgingTest")
      Dim OldRowCnt As Integer = ds.Tables(0).Rows.Count - 1
      Dim NewRowCnt As Integer = grdAging.Rows.Count - 1
      Dim row As Infragistics.WebUI.UltraWebGrid.UltraGridRow

      If NewRowCnt > OldRowCnt Then
         For Each row In grdAging.Rows
            If row.DataChanged = DataChanged.Added Then
               LeadHelper.AddAging(row, UserID)
            End If
         Next
      Else
         Alert.Show("No new information was added.")
      End If

      'ReloadData()

   End Sub

   Protected Sub grdAging_UpdateRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles grdAging.UpdateRow
      Dim row As Infragistics.WebUI.UltraWebGrid.UltraGridRow

      For Each row In grdAging.Rows
         If row.DataChanged = DataChanged.Modified Then
            LeadHelper.UpdateAging(row, UserID)
         End If
      Next

      'ReloadData()

   End Sub

   Protected Sub grdAging_DeleteRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles grdAging.DeleteRow

      If e.Row.DataChanged = DataChanged.Deleted Then
         LeadHelper.DeleteAging(e.Row, UserID)
      End If

      'ReloadData()

   End Sub

   Protected Sub ReloadData()

      Me.grdAging.DataSource = Nothing
      Me.grdAging.DataSource = LeadHelper.getReportDataSet(LeadHelper.GetAgingSQL, "Add/Update")
      Me.grdAging.DataBind()

   End Sub

End Class
