Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class Agency_Potential_Payments
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadGrid()
        End If
    End Sub

    Private Sub LoadGrid()
        Dim da As New SqlDataAdapter()
        Dim dsResults As New DataSet
        Dim dsOutput As New DataSet
        Dim tblCommrec As New DataTable("Commrec")
        Dim tblCompany As New DataTable("Company")
        Dim tblProjections As New DataTable("Projections")
        Dim newCommrecRow As DataRow
        Dim newCompanyRow As DataRow
        Dim newProjRow As DataRow
        Dim Commrecs() As DataRow
        Dim projections() As DataRow
        Dim rows() As DataRow
        Dim daterow As DataRow
        Dim curProjOn As String

        UltraWebGrid1.Bands.Clear()

        Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_ProjectedPayments")
            Using cmd.Connection
                'DatabaseHelper.AddParameter(cmd, "UserID", UserID)

                da.SelectCommand = cmd
                da.Fill(dsResults)

                tblCommrec.Columns.Add("Commrec")

                tblCompany.Columns.Add("Commrec")
                tblCompany.Columns.Add("Company")

                tblProjections.Columns.Add("Commrec")
                tblProjections.Columns.Add("Company")
                tblProjections.Columns.Add("ProjectedOn")

                'add dates as columns
                For Each row As DataRow In dsResults.Tables(0).Rows
                    tblCommrec.Columns.Add(Format(CDate(row(0)), "M/d/yy"), Type.GetType("System.Decimal"))
                    tblCompany.Columns.Add(Format(CDate(row(0)), "M/d/yy"), Type.GetType("System.Decimal"))
                    tblProjections.Columns.Add(Format(CDate(row(0)), "M/d/yy"), Type.GetType("System.Decimal"))
                Next

                'add amounts into each date column
                For Each Commrec As DataRow In dsResults.Tables(1).Rows
                    Commrecs = dsResults.Tables(3).Select("Commrec = '" & Commrec(0) & "'")

                    newCommrecRow = tblCommrec.NewRow
                    newCommrecRow("Commrec") = Commrec(0)
                    For Each daterow In Commrecs
                        newCommrecRow(Format(CDate(daterow("date")), "M/d/yy")) = daterow("amount")
                    Next
                    tblCommrec.Rows.Add(newCommrecRow)

                    For Each company As DataRow In dsResults.Tables(2).Rows
                        rows = dsResults.Tables(4).Select("Commrec = '" & Commrec(0) & "' and company = '" & company(0) & "'")

                        If rows.Length > 0 Then
                            newCompanyRow = tblCompany.NewRow
                            newCompanyRow("Commrec") = Commrec(0)
                            newCompanyRow("Company") = company(0)

                            For Each daterow In rows
                                newCompanyRow(Format(CDate(daterow("date")), "M/d/yy")) = daterow("amount")
                            Next

                            tblCompany.Rows.Add(newCompanyRow)

                            'get projections for this company, Commrec
                            projections = dsResults.Tables(5).Select("Commrec = '" & Commrec(0) & "' and company = '" & company(0) & "'")

                            For Each projection As DataRow In projections
                                If Format(projection("projectedon"), "M/d/yy") <> curProjOn Then
                                    newProjRow = tblProjections.NewRow
                                    newProjRow("Commrec") = projection("Commrec")
                                    newProjRow("Company") = projection("Company")
                                    newProjRow("ProjectedOn") = Format(CDate(projection("projectedon")), "MM/dd/yyyy")
                                End If
                                If tblProjections.Columns.Contains(Format(CDate(projection("fordate")), "M/d/yy")) Then
                                    newProjRow(Format(CDate(projection("fordate")), "M/d/yy")) = projection("amount")
                                End If
                                If Format(CDate(projection("projectedon")), "M/d/yy") <> curProjOn Then
                                    tblProjections.Rows.Add(newProjRow)
                                    curProjOn = Format(CDate(projection("projectedon")), "M/d/yy")
                                End If
                            Next
                        End If
                    Next 'company
                Next 'Commrec

                Dim parentCols(1) As DataColumn
                Dim childCols(1) As DataColumn

                dsOutput.Tables.Add(tblCommrec)
                dsOutput.Tables.Add(tblCompany)
                dsOutput.Tables.Add(tblProjections)

                dsOutput.Relations.Add("CommrecCompany", dsOutput.Tables("Commrec").Columns("Commrec"), dsOutput.Tables("Company").Columns("Commrec"))

                parentCols(0) = dsOutput.Tables("Company").Columns("Commrec")
                parentCols(1) = dsOutput.Tables("Company").Columns("Company")

                childCols(0) = dsOutput.Tables("Projections").Columns("Commrec")
                childCols(1) = dsOutput.Tables("Projections").Columns("Company")

                dsOutput.Relations.Add("CompanyProjections", parentCols, childCols)

                UltraWebGrid1.DataSource = tblCommrec
                UltraWebGrid1.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub UltraWebGrid1_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles UltraWebGrid1.InitializeLayout
        With UltraWebGrid1
            .DisplayLayout.CellClickActionDefault = Infragistics.WebUI.UltraWebGrid.CellClickAction.RowSelect
            .DisplayLayout.SelectTypeRowDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single
            .DisplayLayout.SelectedRowStyleDefault.BorderStyle = BorderStyle.None
            .DisplayLayout.ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.Hierarchical
            .DisplayLayout.BorderCollapseDefault = Infragistics.WebUI.UltraWebGrid.BorderCollapse.Collapse
            .DisplayLayout.GroupByBox.Hidden = True
            .DisplayLayout.AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None
            .DisplayLayout.RowExpAreaStyleDefault.BackColor = System.Drawing.Color.White
            .DisplayLayout.RowExpAreaStyleDefault.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .DisplayLayout.RowExpAreaStyleDefault.BorderDetails.StyleBottom = BorderStyle.Solid
            '.DisplayLayout.RowSelectorStyleDefault.BackColor = System.Drawing.Color.LightYellow

            .Bands(0).SelectedRowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
            .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(0).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
            .Bands(0).RowStyle.BorderStyle = BorderStyle.None
            .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
            .Bands(0).Columns(0).Width = Unit.Pixel(160)
            .Bands(0).Columns(0).Header.Caption = "Recipient"
            .Bands(0).HeaderStyle.Font.Bold = True
            .Bands(0).HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#C5D9F1")
            .Bands(0).HeaderStyle.BorderStyle = BorderStyle.None
            .Bands(0).HeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black
            .Bands(0).HeaderStyle.BorderDetails.WidthBottom = Unit.Pixel(2)
            For i As Integer = 1 To .Bands(0).Columns.Count - 1
                .Bands(0).Columns(i).Header.Style.HorizontalAlign = HorizontalAlign.Right
                .Bands(0).Columns(i).CellStyle.HorizontalAlign = HorizontalAlign.Right
                .Bands(0).Columns(i).Format = "c"
                .Bands(0).Columns(i).Width = Unit.Pixel(90)
            Next

            '.Bands(1).SelectedRowStyle.BorderWidth = Unit.Pixel(0)
            '.Bands(1).SelectedRowStyle.BorderStyle = BorderStyle.None
            .Bands(1).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
            .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
            .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(1).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#e9e9e9")
            '.Bands(1).RowStyle.BorderStyle = BorderStyle.None
            .Bands(1).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(1).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(1).Columns(1).Width = Unit.Percentage(100)
            .DisplayLayout.Bands(1).Columns(0).Hidden = True
            For i As Integer = 2 To .Bands(1).Columns.Count - 1
                .Bands(1).Columns(i).CellStyle.HorizontalAlign = HorizontalAlign.Right
                .Bands(1).Columns(i).Format = "c"
                .Bands(1).Columns(i).Width = Unit.Pixel(90)
            Next

            .Bands(2).Columns(0).Hidden = True
            .Bands(2).Columns(1).Hidden = True
            .Bands(2).Columns(2).Width = Unit.Percentage(100)
            .Bands(2).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(2).RowStyle.BackColor = System.Drawing.Color.LightYellow
            .Bands(2).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            '.DisplayLayout.Bands(2).Columns(2).Header.Caption = "Projected On"
            For i As Integer = 3 To .Bands(2).Columns.Count - 1
                .Bands(2).Columns(i).CellStyle.HorizontalAlign = HorizontalAlign.Right
                .Bands(2).Columns(i).Format = "c"
                .Bands(2).Columns(i).Width = Unit.Pixel(90)
                .Bands(2).Columns(i).Header.Caption = ""
                .DisplayLayout.Bands(2).Columns(i).Header.Style.HorizontalAlign = HorizontalAlign.Right
            Next

        End With
    End Sub

    Protected Sub UltraWebGrid1_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles UltraWebGrid1.InitializeRow
        For Each cell As Infragistics.WebUI.UltraWebGrid.UltraGridCell In e.Row.Cells
            If IsDate(cell.Column.Header.Caption) Then
                If CDate(cell.Column.Header.Caption) > Now Then
                    cell.Column.Header.Style.ForeColor = System.Drawing.Color.Gray
                    cell.Style.ForeColor = System.Drawing.Color.Gray
                    'Else
                    '    cell.Column.Header.Style.ForeColor = System.Drawing.Color.Black
                    '    cell.Style.ForeColor = System.Drawing.Color.Black
                End If
                'Else
                '    cell.Column.Header.Style.ForeColor = System.Drawing.Color.Black
                '    cell.Style.ForeColor = System.Drawing.Color.Black
            End If
        Next
    End Sub
End Class
