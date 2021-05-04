Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class Agency_Potential_Outlook
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
        Dim tblCommRec As New DataTable("CommRec")
        Dim tblCompany As New DataTable("Company")
        Dim tblDetail As New DataTable("Detail")
        Dim tblPayments As New DataTable("Payments")
        Dim tblChargebacks As New DataTable("Chargebacks")
        Dim tblPotential As New DataTable
        Dim rows() As DataRow
        Dim payments() As DataRow
        Dim newCommrecRow As DataRow
        Dim newCompanyRow As DataRow
        Dim newDetailRow As DataRow
        Dim newPaymentRow As DataRow

        UltraWebGrid1.Bands.Clear()

        Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_RunningBalance2")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "StartDate", Format(DateAdd(DateInterval.Day, -30, Now), "M/dd/yyyy"))
                DatabaseHelper.AddParameter(cmd, "EndDate", Format(Now, "M/dd/yyyy"))

                da.SelectCommand = cmd
                da.Fill(dsResults)

                tblCommRec.Columns.Add("CommRec")

                tblCompany.Columns.Add("CommRec")
                tblCompany.Columns.Add("Company")

                tblDetail.Columns.Add("CommRec")
                tblDetail.Columns.Add("Company")
                tblDetail.Columns.Add("Type") 'Payments, Chargebacks, Daily Net, etc

                tblPayments.Columns.Add("CommRec")
                tblPayments.Columns.Add("Company")
                tblPayments.Columns.Add("Type") 'Payments, Chargebacks
                tblPayments.Columns.Add("FeeType")

                'add dates as columns
                For Each row As DataRow In dsResults.Tables(0).Rows
                    tblCommRec.Columns.Add(Format(row(0), "M/d/yy"), Type.GetType("System.Decimal"))
                    tblCompany.Columns.Add(Format(row(0), "M/d/yy"), Type.GetType("System.Decimal"))
                    tblDetail.Columns.Add(Format(row(0), "M/d/yy"), Type.GetType("System.Decimal"))
                    tblPayments.Columns.Add(Format(row(0), "M/d/yy"), Type.GetType("System.Decimal"))
                Next

                'add amounts into each date column
                For Each commrec As DataRow In dsResults.Tables(1).Rows
                    newCommrecRow = tblCommRec.NewRow
                    newCommrecRow("Commrec") = commrec(0)
                    'do add any sums in this row yet
                    tblCommRec.Rows.Add(newCommrecRow)

                    For Each company As DataRow In dsResults.Tables(2).Rows
                        rows = dsResults.Tables(3).Select("commrec = '" & commrec(0) & "' and company = '" & company(0) & "'") 'get all dates for this commrec, company

                        If rows.Length > 0 Then
                            newCompanyRow = tblCompany.NewRow
                            newCompanyRow("Commrec") = commrec(0)
                            newCompanyRow("Company") = company(0)

                            'For Each daterow In rows
                            '   newCompanyRow(Format(daterow("date"), "M/d/yy")) = daterow("daily net")
                            'Next

                            tblCompany.Rows.Add(newCompanyRow)

                            For i As Integer = 3 To dsResults.Tables(3).Columns.Count - 1
                                newDetailRow = tblDetail.NewRow
                                newDetailRow("Commrec") = commrec(0)
                                newDetailRow("Company") = company(0)
                                newDetailRow("Type") = dsResults.Tables(3).Columns(i).ColumnName

                                For Each daterow As DataRow In rows
                                    newDetailRow(Format(daterow("date"), "M/d/yy")) = daterow(dsResults.Tables(3).Columns(i).ColumnName)
                                Next

                                Select Case dsResults.Tables(3).Columns(i).ColumnName.ToLower
                                    Case "payments", "chargebacks"
                                        For Each feetype As DataRow In dsResults.Tables(6).Rows
                                            If dsResults.Tables(3).Columns(i).ColumnName.ToLower = "payments" Then
                                                payments = dsResults.Tables(4).Select("commrec = '" & commrec(0) & "' and company = '" & company(0) & "' and feetype = '" & feetype(0) & "'")
                                            Else 'chargebacks
                                                payments = dsResults.Tables(5).Select("commrec = '" & commrec(0) & "' and company = '" & company(0) & "' and feetype = '" & feetype(0) & "'")
                                            End If

                                            If payments.Length > 0 Then
                                                newPaymentRow = tblPayments.NewRow
                                                newPaymentRow("Commrec") = commrec(0)
                                                newPaymentRow("Company") = company(0)
                                                newPaymentRow("Type") = dsResults.Tables(3).Columns(i).ColumnName

                                                For Each payment As DataRow In payments
                                                    newPaymentRow("FeeType") = payment("feetype")

                                                    If Not IsNothing(tblPayments.Columns(Format(CDate(payment("date")), "M/d/yy"))) Then
                                                        newPaymentRow(Format(CDate(payment("date")), "M/d/yy")) = payment("amount")
                                                    End If
                                                Next

                                                tblPayments.Rows.Add(newPaymentRow)
                                            End If
                                        Next

                                End Select

                                tblDetail.Rows.Add(newDetailRow)
                            Next 'detail
                        End If
                    Next 'company
                Next 'commrec

                Dim parentCol(1) As DataColumn
                Dim childCol(1) As DataColumn

                dsOutput.Tables.Add(tblCommRec)
                dsOutput.Tables.Add(tblCompany)
                dsOutput.Tables.Add(tblDetail)
                dsOutput.Tables.Add(tblPayments)

                parentCol(0) = dsOutput.Tables("Company").Columns("Commrec")
                parentCol(1) = dsOutput.Tables("Company").Columns("Company")

                childCol(0) = dsOutput.Tables("Detail").Columns("Commrec")
                childCol(1) = dsOutput.Tables("Detail").Columns("Company")

                dsOutput.Relations.Add("CommrecCompany", dsOutput.Tables("Commrec").Columns("Commrec"), dsOutput.Tables("Company").Columns("Commrec"))
                dsOutput.Relations.Add("CompanyDetail", parentCol, childCol)

                ReDim parentCol(2)
                ReDim childCol(2)

                parentCol(0) = dsOutput.Tables("Detail").Columns("Commrec")
                parentCol(1) = dsOutput.Tables("Detail").Columns("Company")
                parentCol(2) = dsOutput.Tables("Detail").Columns("Type")

                childCol(0) = dsOutput.Tables("Payments").Columns("Commrec")
                childCol(1) = dsOutput.Tables("Payments").Columns("Company")
                childCol(2) = dsOutput.Tables("Payments").Columns("Type")

                dsOutput.Relations.Add("DetailPayments", parentCol, childCol)

                UltraWebGrid1.DataSource = tblCommRec
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
            '.DisplayLayout.RowExpAreaStyleDefault.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            '.DisplayLayout.RowExpAreaStyleDefault.BorderDetails.StyleBottom = BorderStyle.Solid
            '.DisplayLayout.RowSelectorStyleDefault.BackColor = System.Drawing.Color.LightYellow

            .Bands(0).SelectedRowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
            .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(0).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
            .Bands(0).RowStyle.BorderStyle = BorderStyle.None
            .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
            .Bands(0).Columns(0).Width = Unit.Pixel(250)
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
                .Bands(0).Columns(i).Width = Unit.Pixel(75)
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
                .Bands(1).Columns(i).Width = Unit.Pixel(75)
            Next

            .Bands(2).Columns(0).Hidden = True
            .Bands(2).Columns(1).Hidden = True
            .Bands(2).Columns(2).Width = Unit.Percentage(100)
            .Bands(2).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(2).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(2).RowStyle.BackColor = System.Drawing.Color.White
            .Bands(2).RowStyle.BorderStyle = BorderStyle.None
            .Bands(2).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted
            .Bands(2).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            For i As Integer = 3 To .Bands(2).Columns.Count - 1
                .Bands(2).Columns(i).CellStyle.HorizontalAlign = HorizontalAlign.Right
                .Bands(2).Columns(i).Format = "c"
                .Bands(2).Columns(i).Width = Unit.Pixel(75)
            Next

            ' payments and chargebacks detail
            .Bands(3).Columns(0).Hidden = True
            .Bands(3).Columns(1).Hidden = True
            .Bands(3).Columns(2).Hidden = True
            .Bands(3).Columns(3).Width = Unit.Percentage(100)
            .Bands(3).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(3).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(3).RowStyle.BackColor = System.Drawing.Color.LightYellow
            .Bands(3).RowStyle.BorderStyle = BorderStyle.None
            .Bands(3).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted
            .Bands(3).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            For i As Integer = 4 To .Bands(3).Columns.Count - 1
                .Bands(3).Columns(i).CellStyle.HorizontalAlign = HorizontalAlign.Right
                .Bands(3).Columns(i).Format = "c"
                .Bands(3).Columns(i).Width = Unit.Pixel(75)
            Next

        End With
    End Sub

    Protected Sub UltraWebGrid1_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles UltraWebGrid1.InitializeRow
        For Each cell As Infragistics.WebUI.UltraWebGrid.UltraGridCell In e.Row.Cells
            If e.Row.Cells(2).Text = "Running Balance" Then
                e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
                If Val(cell.Text) < 0 Then
                    cell.Style.ForeColor = System.Drawing.Color.Red
                ElseIf IsDate(cell.Column.Header.Caption) Then
                    If CDate(cell.Column.Header.Caption) > Now Then
                        cell.Style.ForeColor = System.Drawing.Color.Gray
                    End If
                End If
            Else
                If IsDate(cell.Column.Header.Caption) Then
                    If CDate(cell.Column.Header.Caption) > Now Then
                        cell.Column.Header.Style.ForeColor = System.Drawing.Color.Gray
                        cell.Style.ForeColor = System.Drawing.Color.Gray
                    Else
                        cell.Column.Header.Style.ForeColor = System.Drawing.Color.Black
                        cell.Style.ForeColor = System.Drawing.Color.Black
                    End If
                Else
                    cell.Column.Header.Style.ForeColor = System.Drawing.Color.Black
                    cell.Style.ForeColor = System.Drawing.Color.Black
                End If

                Select Case e.Row.Cells(2).Text
                    Case "Calculated Net"
                        e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#d4ecfa")
                    Case "Batched"
                        e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#c5e2f7")
                End Select
            End If
        Next
    End Sub
End Class
