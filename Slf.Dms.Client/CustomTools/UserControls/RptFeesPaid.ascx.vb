Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.Linq

Partial Class CustomTools_UserControls_RptFeesPaid
    Inherits System.Web.UI.UserControl

#Region "Declarations"

    Private Enum GridSection
        First = 0
        Second = 1
    End Enum

    Private Enum GridRowType
        Fee = 0
        FeeTotal = 1
        ChargeBack = 2
        ChargeBackTotal = 3
    End Enum

    Private Class GridZone
        Public StartDate As DateTime
        Public EndDate As DateTime
        Public Fees As DataTable
        Public ChargeBacks As DataTable
        Public ColumnsToShow As New List(Of String)
        Public Ctrl As GridView
        Public Section As GridSection
    End Class

    Private _commRecIds As String()
    Private _grids(1) As GridZone

#End Region

#Region "Private"

    Private Sub LoadGrid(ByVal grid As GridView, ByVal DataSource As DataTable)
        Dim dv As New DataView(DataSource)
        dv.Sort = "rowtype,feename"
        grid.DataSource = dv
        grid.DataBind()
        AddFooter(grid, dv.Table)
        grid.CaptionAlign = TableCaptionAlign.Left
    End Sub

    Private Sub MergeFeeRows()
        MergeTableRows(_grids(GridSection.First).Fees, _grids(GridSection.Second).Fees, GridRowType.Fee)
        MergeTableRows(_grids(GridSection.Second).Fees, _grids(GridSection.First).Fees, GridRowType.Fee)
    End Sub

    Private Sub MergeChargeBackRows()
        MergeTableRows(_grids(GridSection.First).ChargeBacks, _grids(GridSection.Second).ChargeBacks, GridRowType.ChargeBack)
        MergeTableRows(_grids(GridSection.Second).ChargeBacks, _grids(GridSection.First).ChargeBacks, GridRowType.ChargeBack)
    End Sub

    Private Sub MergeTableRows(ByRef Dt1 As DataTable, ByRef dt2 As DataTable, ByVal rowType As Integer)
        'Get Rows in Table1 not in Table2
        Dim excpt = (From dr As DataRow In dt2.AsEnumerable _
                   Select dr.Field(Of String)("feename")).Except(From dr As DataRow In Dt1.AsEnumerable _
                   Select dr.Field(Of String)("feename")).Distinct().ToList

        Dim r As DataRow
        For Each f As String In excpt
            r = Dt1.NewRow
            r("feename") = f
            r("rowtype") = rowType
            For Each c As DataColumn In Dt1.Columns
                If c.ColumnName.ToLower <> "feename" AndAlso c.ColumnName.ToLower <> "rowtype" Then
                    r(c) = 0
                End If
            Next
            Dt1.Rows.Add(r)
        Next
    End Sub

    Private Sub HideRowIfEmpty(ByRef dt As DataTable)
        'If initial fees is the only row and is empty then hide it
        If dt.Rows.Count = 1 AndAlso dt.Rows(0)("Paid") = 0 Then
            If dt.Rows(0)("feename").ToString.Trim.ToLower = "initial fees" Then
                dt.Rows.Remove(dt.Rows(0))
            End If
        End If
    End Sub

    Private Function GetDifferences(ByVal Dt1 As DataTable, ByVal Dt2 As DataTable) As DataTable
        If Dt1.Rows.Count = 0 AndAlso Dt2.Rows.Count = 0 Then Return Dt1.Clone
        If Dt1.Rows.Count = 0 Then Return Dt2
        If Dt2.Rows.Count = 0 Then Return Dt1

        Dim dtt As DataTable = Dt1.Clone
        Dim dtc1 = From dr1 In Dt1.AsEnumerable() _
                   Join dr2 In Dt2.AsEnumerable() _
                   On dr1.Field(Of String)("FeeName") Equals dr2.Field(Of String)("FeeName") And _
                    dr1.Field(Of Integer)("RowType") Equals dr2.Field(Of Integer)("RowType") _
                   Select CreateDiffRow(dtt, dr1, dr2)

        Return dtc1.CopyToDataTable
    End Function

    Private Function CreateDiffRow(ByVal dt As DataTable, ByVal dr1 As DataRow, ByVal dr2 As DataRow) As DataRow
        Dim dr As DataRow = dt.NewRow
        For Each col As DataColumn In dt.Columns
            If col.ColumnName.Trim.ToLower = "feename" OrElse col.ColumnName.Trim.ToLower = "rowtype" Then
                dr(col.ColumnName) = dr1(col.ColumnName)
            Else
                dr(col.ColumnName) = IIf(dr2(col.ColumnName) Is DBNull.Value, 0, dr2(col.ColumnName)) - IIf(dr1(col.ColumnName) Is DBNull.Value, 0, dr1(col.ColumnName))
            End If
        Next
        Return dr
    End Function

    Private Sub HideColumn(ByVal grid As GridView, ByVal index As Integer)
        For Each row As GridViewRow In grid.Rows
            row.Cells(index).Visible = False
        Next
        grid.HeaderRow.Cells(index).Visible = False
        grid.FooterRow.Cells(index).Visible = False
    End Sub

    Private Sub EmptyColumn(ByVal grid As GridView, ByVal index As Integer)
        For Each row As GridViewRow In grid.Rows
            row.Cells(index).Text = " "
        Next
        grid.HeaderRow.Cells(index).Text = " "
        grid.FooterRow.Cells(index).Text = " "
        grid.HeaderRow.Cells(index).Width = "50"
    End Sub

    Private Sub HideColumns(ByVal grid As GridView, ByVal ExcludeColumns As String())
        If Not grid.HeaderRow Is Nothing AndAlso grid.HeaderRow.Cells.Count > 0 Then
            For index As Integer = 0 To grid.FooterRow.Cells.Count - 1
                Dim colname As String = grid.HeaderRow.Cells(index).Text
                If colname.Trim.ToLower <> "feename" AndAlso colname.Trim.ToLower <> "rowtype" Then
                    Dim cell As TableCell = grid.FooterRow.Cells(index)
                    If colname.Trim.ToLower <> "paid" Then
                        If Not ExcludeColumns.Contains(colname.Trim.ToLower) Then
                            HideColumn(grid, index)
                        Else
                            If Not _commRecIds.Contains(GetCommRecIdFromColumnName(colname)) Then
                                EmptyColumn(grid, index)
                            End If
                        End If
                    End If
                ElseIf colname.Trim.ToLower = "rowtype" Then
                    HideColumn(grid, index)
                Else
                    grid.HeaderRow.Cells(index).Text = ""
                End If
            Next
        End If
    End Sub

    Private Function GetColumnsToShow(ByVal grid As GridView, ByVal dt As DataTable) As String()
        Dim columnsToShow As New List(Of String)
        If Not grid.HeaderRow Is Nothing AndAlso grid.HeaderRow.Cells.Count > 0 Then
            For index As Integer = 0 To grid.FooterRow.Cells.Count - 1
                Dim colname As String = grid.HeaderRow.Cells(index).Text
                If colname.Trim.ToLower <> "feename" AndAlso colname.Trim.ToLower <> "rowtype" AndAlso colname.Trim.Length > 0 Then
                    Dim cell As TableCell = grid.FooterRow.Cells(index)
                    Dim HasNotZeroRow As Boolean = dt.AsEnumerable.Count(Function(c) c.Field(Of Decimal?)(colname) <> 0)
                    If Not HasNotZeroRow And colname.Trim.ToLower <> "paid" Then
                        'Do not include column
                    Else
                        If Not columnsToShow.Contains(colname.Trim.ToLower) Then
                            'Include column
                            columnsToShow.Add(colname.Trim.ToLower)
                        End If
                    End If
                End If
            Next
        End If
        'return included columns
        Return columnsToShow.ToArray
    End Function

    Private Function GetCommRecIdFromColumnName(ByVal columnname As String) As String
        Return columnname.Substring(columnname.LastIndexOf("(")).Replace(")", "").Replace("(", "")
    End Function

    Private Sub AddTotal(ByRef dt As DataTable, ByVal rowType As Integer)
        If dt.Rows.Count > 0 Then
            Dim r As DataRow = dt.NewRow
            r("RowType") = rowType
            r("FeeName") = IIf(rowType = GridRowType.FeeTotal, "Total Fees", "Total Chargebacks")
            For Each col As DataColumn In dt.Columns
                Dim columnname As String = col.ColumnName.Trim.ToLower
                If columnname <> "feename" AndAlso columnname <> "rowtype" Then
                    Dim total As Decimal = dt.AsEnumerable().Select(Function(c) c.Field(Of Decimal?)(columnname)).Sum()
                    r(columnname) = total
                End If
            Next
            dt.Rows.Add(r)
        End If
    End Sub

    Private Sub AddFooter(ByVal grid As GridView, ByVal dt As DataTable)
        If Not grid.FooterRow Is Nothing AndAlso grid.FooterRow.Cells.Count > 0 Then
            For index As Integer = 0 To grid.FooterRow.Cells.Count - 1
                Dim colname As String = grid.HeaderRow.Cells(index).Text
                Select Case colname.Trim.ToLower
                    Case "rowtype"
                    Case "feename"
                        grid.FooterRow.Cells(index).Text = "Net"
                        grid.FooterRow.Cells(index).CssClass = "gridFooter"
                    Case Else
                        Dim cell As TableCell = grid.FooterRow.Cells(index)
                        Dim total As Decimal = dt.AsEnumerable().Where(Function(c) c.Field(Of Integer)("rowtype") = GridRowType.FeeTotal).Select(Function(c) c.Field(Of Decimal?)(colname)).Single - _
                                               dt.AsEnumerable().Where(Function(c) c.Field(Of Integer)("rowtype") = GridRowType.ChargeBackTotal).Select(Function(c) c.Field(Of Decimal?)(colname)).Single
                        cell.Text = total.ToString("c")
                        cell.HorizontalAlign = HorizontalAlign.Right
                        If total < 0 Then cell.ForeColor = System.Drawing.Color.Red
                        cell.CssClass = "gridFooter"
                End Select
            Next
        End If
    End Sub

    Protected Sub grdFeesPaid_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdFeesPaid1.RowDataBound, grdFeesPaid2.RowDataBound, grdFeesPaidDiff.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            For index As Integer = 0 To e.Row.Cells.Count - 1
                Dim colname As String = CType(e.Row.NamingContainer, GridView).HeaderRow.Cells(index).Text
                If colname.Trim.ToLower <> "feename" AndAlso colname.Trim.ToLower <> "rowtype" Then
                    Dim cell As TableCell = e.Row.Cells(index)
                    If Decimal.TryParse(e.Row.Cells(index).Text, Nothing) Then
                        Dim val As Decimal = CDec(e.Row.Cells(index).Text.Replace("&nbsp;", ""))
                        If val < 0 Then
                            cell.ForeColor = System.Drawing.Color.Red
                        Else
                            cell.ForeColor = System.Drawing.Color.Black
                        End If
                        cell.Text = String.Format("{0:c}", val)
                    End If
                    cell.HorizontalAlign = HorizontalAlign.Right
                End If
                Select Case CType(e.Row.DataItem, DataRowView)("rowtype")
                    Case 1, 3
                        e.Row.Cells(index).CssClass = "gridFooter"
                End Select
            Next
        End If
    End Sub

    Private Function GetData(ByVal StartDate As DateTime, ByVal EndDate As DateTime, ByVal CompanyIds As String, ByVal AgencyIds As String, ByVal CommRecIds As String, ByVal CombineIniFees As Boolean) As DataTable
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@startdate", SqlDbType.DateTime)
        param.Value = StartDate
        params.Add(param)

        param = New SqlParameter("@enddate", SqlDbType.DateTime)
        param.Value = EndDate
        params.Add(param)

        param = New SqlParameter("@companyids", SqlDbType.VarChar)
        param.Value = CompanyIds.Trim
        params.Add(param)

        param = New SqlParameter("@agencyids", SqlDbType.VarChar)
        param.Value = AgencyIds.Trim
        params.Add(param)

        param = New SqlParameter("@comrecids", SqlDbType.VarChar)
        param.Value = CommRecIds.Trim
        params.Add(param)

        param = New SqlParameter("@combineinifees", SqlDbType.Bit)
        param.Value = IIf(CombineIniFees, 1, 0)
        params.Add(param)

        Return SqlHelper.GetDataTable("stp_FeeComparisonReport_GetData", CommandType.StoredProcedure, params.ToArray)
    End Function

    Private Function GetChargeBacks(ByVal StartDate As DateTime, ByVal EndDate As DateTime, ByVal CompanyIds As String, ByVal AgencyIds As String, ByVal CommRecIds As String, ByVal CombineIniFees As Boolean) As DataTable
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@startdate", SqlDbType.DateTime)
        param.Value = StartDate
        params.Add(param)

        param = New SqlParameter("@enddate", SqlDbType.DateTime)
        param.Value = EndDate
        params.Add(param)

        param = New SqlParameter("@companyids", SqlDbType.VarChar)
        param.Value = CompanyIds.Trim
        params.Add(param)

        param = New SqlParameter("@agencyids", SqlDbType.VarChar)
        param.Value = AgencyIds.Trim
        params.Add(param)

        param = New SqlParameter("@comrecids", SqlDbType.VarChar)
        param.Value = CommRecIds.Trim
        params.Add(param)

        param = New SqlParameter("@combineinifees", SqlDbType.Bit)
        param.Value = IIf(CombineIniFees, 1, 0)
        params.Add(param)

        Return SqlHelper.GetDataTable("stp_FeeComparisonReport_GetChargeBacks", CommandType.StoredProcedure, params.ToArray)
    End Function

#End Region

#Region "Public"

    Public ReadOnly Property ColumnsToShow(ByVal Index As Integer) As List(Of String)
        Get
            Return _grids(Index).ColumnsToShow
        End Get
    End Property

    Public Sub LoadData(ByVal StartDate1 As DateTime, ByVal EndDate1 As DateTime, ByVal StartDate2 As DateTime, ByVal EndDate2 As DateTime, ByVal CompanyIds As String, ByVal AgencyIds As String, ByVal CommRecIds As String, ByVal CommRecIdsToQuery As String, ByVal CombineIniFees As Boolean)
        _grids(GridSection.First) = New GridZone With {.StartDate = StartDate1, .EndDate = EndDate1, .Ctrl = grdFeesPaid1, .Section = GridSection.First}
        _grids(GridSection.Second) = New GridZone With {.StartDate = StartDate2, .EndDate = EndDate2, .Ctrl = grdFeesPaid2, .Section = GridSection.Second}
        _commRecIds = CommRecIds.Split(",")

        For Each grid As GridZone In _grids
            grid.Fees = GetData(grid.StartDate, grid.EndDate.AddDays(1).AddSeconds(-1), CompanyIds, AgencyIds, CommRecIdsToQuery, CombineIniFees)
            grid.ChargeBacks = GetChargeBacks(grid.StartDate, grid.EndDate.AddDays(1).AddSeconds(-1), CompanyIds, AgencyIds, CommRecIdsToQuery, CombineIniFees)
            If CombineIniFees Then
                HideRowIfEmpty(grid.Fees)
                HideRowIfEmpty(grid.ChargeBacks)
            End If
        Next

        MergeFeeRows()
        MergeChargeBackRows()

        For Each grid As GridZone In _grids
            AddTotal(grid.Fees, GridRowType.FeeTotal)
            AddTotal(grid.ChargeBacks, GridRowType.ChargeBackTotal)
            grid.Fees.Merge(grid.ChargeBacks)
            LoadGrid(grid.Ctrl, grid.Fees)
            grid.ColumnsToShow.AddRange(GetColumnsToShow(grid.Ctrl, grid.Fees))
            grid.Ctrl.Caption = String.Format("{0:MMM dd yyyy} - {1:MMM dd yyyy}", grid.StartDate, grid.EndDate)
        Next

        Dim dtDiff As DataTable = GetDifferences(_grids(GridSection.First).Fees, _grids(GridSection.Second).Fees)
        LoadGrid(Me.grdFeesPaidDiff, dtDiff)
        Me.grdFeesPaidDiff.Caption = "Differences"

    End Sub

    Public Sub RepaintGridColumns(ByVal ExcludeColumns As List(Of String)())
        Dim ExcludeDiffColumns As New List(Of String)
        For Each grid In _grids
            HideColumns(grid.Ctrl, ExcludeColumns(grid.Section).ToArray)
            ExcludeDiffColumns.AddRange(ExcludeColumns(grid.Section))
        Next
        HideColumns(grdFeesPaidDiff, ExcludeDiffColumns.Distinct.ToArray)
    End Sub

#End Region

End Class
