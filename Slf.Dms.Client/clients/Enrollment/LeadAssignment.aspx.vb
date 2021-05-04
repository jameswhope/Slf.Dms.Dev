Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports Infragistics.WebUI.UltraWebGrid

Partial Class Clients_Enrollment_LeadAssignment
    Inherits System.Web.UI.Page

#Region "Variables"

   Private UserID As Integer
   Private c_cnDatabase As New OleDb.OleDbConnection()
   Private c_blnSortColumnName As String = ""
   Private c_blnSortAscending As Boolean = True

#End Region

#Region "Page routines"

   Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.PreRender

      With Me.grdLeadAssignment.DisplayLayout.Bands(0)
         If c_blnSortColumnName <> "" Then
            If c_blnSortColumnName = "u.LastName" Then
               c_blnSortColumnName = "Rep"
            End If
            If c_blnSortAscending = True Then
               .Columns.FromKey(c_blnSortColumnName).SortIndicator = Infragistics.WebUI.UltraWebGrid.SortIndicator.Ascending
            Else
               .Columns.FromKey(c_blnSortColumnName).SortIndicator = Infragistics.WebUI.UltraWebGrid.SortIndicator.Descending
            End If
         Else
            Dim i As Integer
            For i = 2 To .Columns.Count - 1
               .Columns.Item(i).SortIndicator = SortIndicator.None
            Next
         End If
      End With

   End Sub

   Protected Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                  GlobalFiles.JQuery.UI, _
                                                  "~/jquery/json2.js", _
                                                  "~/jquery/jquery.modaldialog.js" _
                                                  })
      ' Who's making the changes
      UserID = DataHelper.Nz_int(Page.User.Identity.Name)
      c_blnSortColumnName = CStr(Session("SortColumnName"))
      c_blnSortAscending = CType(Session("SortAscending"), Boolean)

      ' On postback don't do anything yet else inatilize the data
      If IsPostBack Then
         PerformSearch("", True)
      Else
         InitalizeData()
      End If

      ckAll.Attributes.Add("onClick", "CheckAll();")
      'grdLeadAssignment.Attributes.Add("OnDataFiltered", "Data_Filtered")
      Me.ckAll.Checked = False

   End Sub

#End Region

#Region "Grid and DropDown routines"

   Protected Sub grdLeadAssignment_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles grdLeadAssignment.InitializeLayout

      e.Layout.ViewType = ViewType.OutlookGroupBy
      e.Layout.Bands(0).Columns(0).IsGroupByColumn = True

      With e.Layout.Bands(0)
         Dim uwgcol As Infragistics.WebUI.UltraWebGrid.UltraGridColumn
         For Each uwgcol In .Columns
            If uwgcol.SortIndicator <> SortIndicator.None Then
               uwgcol.SortIndicator = SortIndicator.None
            End If
         Next

         .RowSelectors = RowSelectors.No
         .CellClickAction = CellClickAction.RowSelect
         .AllowSorting = AllowSorting.Yes
         .HeaderClickAction = HeaderClickAction.SortSingle
      End With

   End Sub

   Protected Sub grdLeadAssignment_SortColumn(ByVal sender As Object, ByVal e As SortColumnEventArgs) Handles grdLeadAssignment.SortColumn

      e.Cancel = True

      Select Case e.BandNo
         Case (0)
            If c_blnSortColumnName = grdLeadAssignment.Bands(e.BandNo).SortedColumns.Item(0).Key Then
               grdLeadAssignment.Bands(e.BandNo).SortedColumns.Clear()
               If c_blnSortAscending = True Then
                  grdLeadAssignment.DisplayLayout.Bands(0).Columns(e.ColumnNo).SortIndicator = Infragistics.WebUI.UltraWebGrid.SortIndicator.Ascending
                  PerformSearch(grdLeadAssignment.Bands(e.BandNo).Columns.Item(0).Key, False)
               Else
                  grdLeadAssignment.DisplayLayout.Bands(0).Columns(e.ColumnNo).SortIndicator = Infragistics.WebUI.UltraWebGrid.SortIndicator.Descending
                  PerformSearch(grdLeadAssignment.Bands(e.BandNo).Columns.Item(0).Key, True)
               End If
            Else
               PerformSearch(grdLeadAssignment.Bands(e.BandNo).Columns.Item(0).Key, True)
            End If
      End Select

   End Sub

   Protected Sub InitalizeData()

      Me.SqlDataSource2.ConnectionString = ConfigurationManager.AppSettings("connectionstring").ToString()
      Me.SqlDataSource2.SelectCommand = LeadHelper.GetReps1SQL

      'Applicants
      Me.ddlSelApplicant.DataSource = Nothing
      Me.ddlSelApplicant.DataSource = LeadHelper.getReportDataSet(LeadHelper.GetApplicantSQL, "Applicants")
      Me.ddlSelApplicant.DataBind()
      'State
      Me.ddlSelState.DataSource = Nothing
      Me.ddlSelState.DataSource = LeadHelper.getReportDataSet(LeadHelper.GetStateSQL, "State")
      Me.ddlSelState.DataBind()
      'Status
      Me.ddlSelStatus.DataSource = Nothing
      Me.ddlSelStatus.DataSource = LeadHelper.getReportDataSet(LeadHelper.GetStatusSQL, "Status")
      Me.ddlSelStatus.DataBind()
      'Reps
      Me.ddlSelReps.DataSource = Nothing
      Me.ddlSelReps.DataSource = LeadHelper.getReportDataSet(LeadHelper.GetReps2SQL, "Reps2")
      Me.ddlSelReps.DataBind()
      'Aging
      Me.ddlSelAging.DataSource = Nothing
      Me.ddlSelAging.DataSource = LeadHelper.getReportDataSet(LeadHelper.GetAgingSQL, "Aging")
      Me.ddlSelAging.DataBind()

   End Sub

    Public Sub Check_All(ByVal sender As Object, ByVal e As System.EventArgs) 'Handles lnkCkBox.Click
        Dim grd As UltraWebGrid = Me.grdLeadAssignment
        Dim row As Infragistics.WebUI.UltraWebGrid.UltraGridRow

        'Select all
        If Me.hdnChecked.Value = True Then
            For Each row In grdLeadAssignment.Rows
                row.Cells.Item(2).Value = 1
            Next
        Else
            For Each row In grdLeadAssignment.Rows
                row.Cells.Item(2).Value = 0
            Next
        End If

    End Sub

#End Region

#Region "View and Run Routines"

   Private Sub PerformSearch(ByVal v_strOrderByColumnName As String, ByVal v_blnSortAscending As Boolean)

      If v_strOrderByColumnName <> "" Then

         Dim sbSQL As New System.Text.StringBuilder(4096)
         Dim Flags As Boolean = False
         Dim intApplicantID As Integer = -1
         Dim intStateID As Integer = -1
         Dim intStatusID As Integer = -1
         Dim intRepID As Integer = -1
         Dim strAging As String = ""
         Dim dsSorted As DataSet = Nothing
         Dim i As Integer = 0

         'Assign the variables for the SQL statement
         If CInt(Me.hdnApplicantID.Value) > 0 Then
            intApplicantID = CInt(Me.hdnApplicantID.Value)
         End If
         If intApplicantID > 0 Then Flags = True

         If CInt(Me.hdnStateID.Value) > 0 Then
            intStateID = CInt(Me.hdnStateID.Value)
         End If
         If intStateID > 0 Then Flags = True

         If CInt(Me.hdnStatusID.Value) > 0 Then
            intStatusID = CInt(Me.hdnStatusID.Value)
         End If
         If intStatusID > 0 Then Flags = True

         If CInt(Me.hdnRepID.Value) > 0 Then
            intRepID = CInt(Me.hdnRepID.Value)
         End If
         If intRepID > 0 Then Flags = True

         If Me.hdnAging.Value.ToString() <> "" Then
            strAging = Me.hdnAging.Value
         End If
         If strAging <> "" Then Flags = True

         sbSQL.Append(LeadHelper.BuildReportSQL(intApplicantID, intStateID, intStatusID, intRepID, strAging, Flags))

         ' save sort details
         c_blnSortColumnName = v_strOrderByColumnName
         c_blnSortAscending = v_blnSortAscending
         Session("SortColumnName") = c_blnSortColumnName
         Session("SortAscending") = c_blnSortAscending

         ' build select part of SQL
         If v_strOrderByColumnName = "Rep" Then
            sbSQL.Append(" ORDER BY u.LastName, u.UserID")
         ElseIf v_strOrderByColumnName = "LeadApplicantID" Then
            sbSQL.Append(" ORDER BY la.LeadApplicantID")
         ElseIf v_strOrderByColumnName = "Applicant" Then
            sbSQL.Append(" ORDER BY la.LastName")
         ElseIf v_strOrderByColumnName = "State" Then
            sbSQL.Append(" ORDER BY s.Abbreviation")
         ElseIf v_strOrderByColumnName = "Home" Then
            sbSQL.Append(" ORDER BY la.HomePhone")
         ElseIf v_strOrderByColumnName = "Business" Then
            sbSQL.Append(" ORDER BY la.BusinessPhone")
         ElseIf v_strOrderByColumnName = "Aging" Then
            sbSQL.Append(" ORDER BY Aging")
         ElseIf v_strOrderByColumnName = "Status" Then
            sbSQL.Append(" ORDER BY rm.reason")
         End If

         ' test for descending sort
         If v_blnSortAscending = False And v_strOrderByColumnName <> "" Then
            sbSQL.Append(" DESC")
         End If

         Try
            ' build data table and assign it
            dsSorted = LeadHelper.getReportDataSet(sbSQL.ToString, "Sorted")

         Catch ex As Exception
            Alert.Show(ex.Message)
         End Try

         ' bind table to grid
         With grdLeadAssignment
            .Clear()
            .ResetColumns()
            .DataSource = Nothing
            .DataSource = dsSorted
            .DataKeyField = "LeadApplicantID"
            .DataBind()

            ' Setup the columns
            .Columns(0).Hidden = True
            .Columns(0).Key = "LeadApplicantID"
            .Columns(1).Hidden = True
            .Columns(1).Key = "LastName"

            For i = 2 To .Columns.Count - 1
               .Columns(i).Header.Style.Font.Bold = True
            Next

            For i = 3 To .Columns.Count - 1
               .Columns(i).AllowUpdate = AllowUpdate.No
            Next

            .Columns(2).AllowGroupBy = AllowGroupBy.No
            .Columns(2).Type = ColumnType.CheckBox
            .Columns(2).CellStyle.HorizontalAlign = HorizontalAlign.Center
            .Columns(2).CellButtonStyle.HorizontalAlign = HorizontalAlign.Center
            .Columns(2).Header.Style.HorizontalAlign = HorizontalAlign.Center
            .Columns(2).Width = "65"
            .Columns(2).IsBound = False
            .Columns(2).Key = "Selected"

            .Columns(3).Width = "150"
            .Columns(3).Key = ""

            .Columns(4).AllowGroupBy = AllowGroupBy.Yes
            .Columns(4).CellStyle.HorizontalAlign = HorizontalAlign.Center
            .Columns(4).CellButtonStyle.HorizontalAlign = HorizontalAlign.Center
            .Columns(4).Header.Style.HorizontalAlign = HorizontalAlign.Center
            .Columns(4).Width = "65"

            .Columns(7).Width = "220"

            .Columns(8).Width = "65"

            .Columns(9).Width = "220"
            .Columns(9).CellStyle.HorizontalAlign = HorizontalAlign.Left

            .Columns(10).AllowGroupBy = AllowGroupBy.Yes
            .Columns(10).CellStyle.HorizontalAlign = HorizontalAlign.Center
            .Columns(10).CellButtonStyle.HorizontalAlign = HorizontalAlign.Center
            .Columns(10).Header.Style.HorizontalAlign = HorizontalAlign.Center
            .Columns(10).Width = "65"

            .DisplayLayout.ViewType = ViewType.Flat
         End With
         Me.lblCount.Text = "Selection Count: " & grdLeadAssignment.Rows.Count
      End If

   End Sub

   Public Sub AssignRep(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAssignRep.Click
      Dim y As Integer = 0
      Dim RepID As Integer = 0
      Dim AssignedLeads(0) As Integer
      Dim grd As UltraWebGrid = Me.grdLeadAssignment
      Dim rows As RowsCollection = Me.grdLeadAssignment.Rows
      Dim OldAssignments(0) As LeadHelper.OldAssignments
      Dim row As Infragistics.WebUI.UltraWebGrid.UltraGridRow
      Dim grprow As GroupByRow

      If Me.ddlReps.SelectedValue <> 0 Then
         ' Get the new lawfirm rep
         RepID = Me.ddlReps.SelectedValue
      Else
         Alert.Show("You need to choose a new Law Firm Rep. to assign the lead(s) to.")
         Exit Sub
      End If

        ''Attempt to loop through the children
        'For Each row In rows
        '   grprow = TryCast(row, GroupByRow)
        '   If grprow Is Nothing Then
        '      Response.Write(row.Cells(0).Value.ToString() + " is not a GroupByRow")
        '   Else
        '      If grprow.HasChildRows Then
        '         Dim Crow As Infragistics.WebUI.UltraWebGrid.UltraGridRow
        '         For Each Crow In grprow.Rows
        '            Response.Write(Crow.Cells(0).Value.ToString() + " Row Index " + Crow.Index.ToString())
        '         Next
        '      End If
        '   End If
        'Next

        ' loop through the entire collection of rows and assign values to the call
        For Each row In grdLeadAssignment.Rows
            If row.Cells.Item(2).Value = 1 Then
                AssignedLeads(y) = row.Cells(0).Value
                OldAssignments(y).LeadApplicantID = row.Cells(0).Value
                OldAssignments(y).TableName = "tblLeadApplicants"
                OldAssignments(y).FieldName = "RepID"
                OldAssignments(y).OldValue = LeadHelper.GetRepIDFromAppID(row.Cells(0).Value)
                OldAssignments(y).NewValue = RepID.ToString()

                ReDim Preserve AssignedLeads(y + 1)
                ReDim Preserve OldAssignments(y + 1)
                y += 1
                row.Cells.Item(2).Value = 0
            End If

        Next

      ' Re-adjust the array so the length is correct
      If AssignedLeads.Length > y Then
         ReDim Preserve AssignedLeads(y - 1)
         ReDim Preserve OldAssignments(y - 1)
      End If

      ' Reassign the clients to the new rep
      If AssignedLeads.Length > 0 Then 'If we don't have anyone then why do it
         LeadHelper.ReAssignLeads(AssignedLeads, UserID, RepID)
         'Log the assignments to the log
         LeadHelper.LogAssignments(OldAssignments, UserID, RepID)
      End If

      ' Refresh the page
      Response.Redirect("LeadAssignment.aspx")
   End Sub

   Public Sub View_Run(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
      Dim Flags As Boolean = False
      Dim intApplicantID As Integer = -1
      Dim intStateID As Integer = -1
      Dim intStatusID As Integer = -1
      Dim intRepID As Integer = -1
      Dim i As Integer = 0
      Dim strAging As String = ""
      Dim dsSorted As DataSet = Nothing

      'Assign the variables for the SQL statement
      If CInt(Me.hdnApplicantID.Value) > 0 Then
         intApplicantID = CInt(Me.hdnApplicantID.Value)
      End If
      If intApplicantID > 0 Then Flags = True

      If CInt(Me.hdnStateID.Value) > 0 Then
         intStateID = CInt(Me.hdnStateID.Value)
      End If
      If intStateID > 0 Then Flags = True

      If CInt(Me.hdnStatusID.Value) > 0 Then
         intStatusID = CInt(Me.hdnStatusID.Value)
      End If
      If intStatusID > 0 Then Flags = True

      If CInt(Me.hdnRepID.Value) > 0 Then
         intRepID = CInt(Me.hdnRepID.Value)
      End If
      If intRepID > 0 Then Flags = True

      If Me.hdnAging.Value.ToString() <> "" Then
         strAging = Me.hdnAging.Value
      End If
      If strAging <> "" Then Flags = True

      'Make a report
      With grdLeadAssignment
         ' Assign the data source to the grid and bind it.
         .Clear()
         .ResetColumns()
         .DataSourceID = Nothing
         dsSorted = LeadHelper.getReportDataSet(LeadHelper.BuildReportSQL(intApplicantID, intStateID, intStatusID, intRepID, strAging, Flags), "Leads")

         .DataSource = dsSorted
         .DataBind()

         ' Setup the columns
         .Columns(0).Hidden = True
         .Columns(1).Hidden = True

         For i = 2 To .Columns.Count - 1
            .Columns(i).Header.Style.Font.Bold = True
         Next

         For i = 3 To .Columns.Count - 1
            .Columns(i).AllowUpdate = AllowUpdate.No
         Next

         .Columns(2).AllowGroupBy = AllowGroupBy.No
         .Columns(2).Type = ColumnType.CheckBox
         .Columns(2).CellStyle.HorizontalAlign = HorizontalAlign.Center
         .Columns(2).CellButtonStyle.HorizontalAlign = HorizontalAlign.Center
         .Columns(2).Header.Style.HorizontalAlign = HorizontalAlign.Center
         .Columns(2).Width = "65"
         .Columns(2).IsBound = False

         .Columns(3).Width = "150"

         .Columns(4).AllowGroupBy = AllowGroupBy.Yes
         .Columns(4).CellStyle.HorizontalAlign = HorizontalAlign.Center
         .Columns(4).CellButtonStyle.HorizontalAlign = HorizontalAlign.Center
         .Columns(4).Header.Style.HorizontalAlign = HorizontalAlign.Center
         .Columns(4).Width = "65"

         .Columns(7).Width = "220"

         .Columns(8).Width = "65"

         .Columns(9).Width = "150"

         .Columns(10).AllowGroupBy = AllowGroupBy.Yes
         .Columns(10).CellStyle.HorizontalAlign = HorizontalAlign.Center
         .Columns(10).CellButtonStyle.HorizontalAlign = HorizontalAlign.Center
         .Columns(10).Header.Style.HorizontalAlign = HorizontalAlign.Center
         .Columns(10).Width = "65"

         .DisplayLayout.ViewType = ViewType.Flat
      End With

      Me.lblCount.Text = "Selection Count: " & grdLeadAssignment.Rows.Count

   End Sub

#End Region

End Class
