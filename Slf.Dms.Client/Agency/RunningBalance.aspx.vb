Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports Drg.Util.DataAccess

Partial Class Agency_RunningBalance
    Inherits System.Web.UI.Page

    Private UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If
        If Not Page.IsPostBack Then
            txtStartDate.Value = Format(DateAdd(DateInterval.Day, -10, Now), "M/dd/yyyy")
            txtEndDate.Value = Format(Now, "M/dd/yyyy")
            If DataHelper.FieldLookup("tblUser", "UserTypeID", "UserID=" & UserID) = "2" Then
                LoadGrid()
            Else
                Label1.Text = "Please log in as an Agency user."
            End If
        End If
    End Sub

    Private Sub LoadGrid(Optional ByVal bExport As Boolean = False)
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
                DatabaseHelper.AddParameter(cmd, "startdate", txtStartDate.Text)
                DatabaseHelper.AddParameter(cmd, "enddate", txtEndDate.Text)
                DatabaseHelper.AddParameter(cmd, "userid", UserID)

                cmd.CommandTimeout = 180
                da.SelectCommand = cmd
                da.Fill(dsResults)

                tblCompany.Columns.Add("Company")

                tblCommRec.Columns.Add("Company")
                tblCommRec.Columns.Add("CommRec")

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
                For Each company As DataRow In dsResults.Tables(2).Rows
                    newCompanyRow = tblCompany.NewRow
                    newCompanyRow("Company") = company(0)
                    tblCompany.Rows.Add(newCompanyRow)

                    For Each commrec As DataRow In dsResults.Tables(1).Rows
                        rows = dsResults.Tables(3).Select("commrec = '" & commrec(0) & "' and company = '" & company(0) & "'") 'get all dates for this commrec, company

                        If rows.Length > 0 Then
                            newCommrecRow = tblCommRec.NewRow
                            newCommrecRow("Commrec") = commrec(0)
                            newCommrecRow("Company") = company(0)
                            tblCommRec.Rows.Add(newCommrecRow)

                            For i As Integer = 3 To dsResults.Tables(3).Columns.Count - 1
                                newDetailRow = tblDetail.NewRow
                                newDetailRow("Commrec") = commrec(0)
                                newDetailRow("Company") = company(0)
                                newDetailRow("Type") = dsResults.Tables(3).Columns(i).ColumnName

                                For Each daterow As DataRow In rows
                                    newDetailRow(Format(daterow("date"), "M/d/yy")) = daterow(dsResults.Tables(3).Columns(i).ColumnName)
                                Next

                                Select Case dsResults.Tables(3).Columns(i).ColumnName.ToLower
                                    Case "payments"
                                        For Each feetype As DataRow In dsResults.Tables(6).Rows
                                            payments = dsResults.Tables(4).Select("commrec = '" & commrec(0) & "' and company = '" & company(0) & "' and feetype = '" & feetype(0) & "'")

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

                                    Case "chargebacks" 'note: var names used here are a little misleading
                                        For Each cbtype As DataRow In dsResults.Tables(7).Rows
                                            payments = dsResults.Tables(5).Select("commrec = '" & commrec(0) & "' and company = '" & company(0) & "' and detail = '" & cbtype(0) & "'")

                                            If payments.Length > 0 Then
                                                newPaymentRow = tblPayments.NewRow
                                                newPaymentRow("Commrec") = commrec(0)
                                                newPaymentRow("Company") = company(0)
                                                newPaymentRow("Type") = dsResults.Tables(3).Columns(i).ColumnName

                                                For Each payment As DataRow In payments
                                                    newPaymentRow("FeeType") = payment("detail")

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

                dsOutput.Tables.Add(tblCompany)
                dsOutput.Tables.Add(tblCommRec)
                dsOutput.Tables.Add(tblDetail)
                dsOutput.Tables.Add(tblPayments)

                dsOutput.Relations.Add("CompanyCommrec", dsOutput.Tables("Company").Columns("Company"), dsOutput.Tables("Commrec").Columns("Company"))

                parentCol(0) = dsOutput.Tables("Commrec").Columns("Commrec")
                parentCol(1) = dsOutput.Tables("Commrec").Columns("Company")

                childCol(0) = dsOutput.Tables("Detail").Columns("Commrec")
                childCol(1) = dsOutput.Tables("Detail").Columns("Company")

                dsOutput.Relations.Add("CommrecDetail", parentCol, childCol)

                ReDim parentCol(2)
                ReDim childCol(2)

                parentCol(0) = dsOutput.Tables("Detail").Columns("Commrec")
                parentCol(1) = dsOutput.Tables("Detail").Columns("Company")
                parentCol(2) = dsOutput.Tables("Detail").Columns("Type")

                childCol(0) = dsOutput.Tables("Payments").Columns("Commrec")
                childCol(1) = dsOutput.Tables("Payments").Columns("Company")
                childCol(2) = dsOutput.Tables("Payments").Columns("Type")

                dsOutput.Relations.Add("DetailPayments", parentCol, childCol)

                If bExport Then
                    Export(dsOutput)
                Else
                    UltraWebGrid1.DataSource = tblCompany
                    UltraWebGrid1.DataBind()
                End If
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
            .Bands(0).Columns(0).Width = Unit.Pixel(300)
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
                e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#e1e1e1")

                If IsDate(cell.Column.Header.Caption) Then
                    If CDate(cell.Column.Header.Caption).DayOfWeek = DayOfWeek.Saturday Or _
                         CDate(cell.Column.Header.Caption).DayOfWeek = DayOfWeek.Sunday Or _
                           CDate(cell.Column.Header.Caption) > Now Then
                        cell.Style.ForeColor = System.Drawing.Color.Gray
                    ElseIf Val(cell.Text) < 0 Then
                        cell.Style.ForeColor = System.Drawing.Color.Red
                    End If
                End If
            Else
                If IsDate(cell.Column.Header.Caption) Then
                    If CDate(cell.Column.Header.Caption) > Now Or _
                        CDate(cell.Column.Header.Caption).DayOfWeek = DayOfWeek.Saturday Or _
                         CDate(cell.Column.Header.Caption).DayOfWeek = DayOfWeek.Sunday Then
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

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        If DateDiff(DateInterval.Day, CDate(txtStartDate.Text), CDate(txtEndDate.Text)) <= 30 Then
            LoadGrid()
        Else
            Me.ClientScript.RegisterStartupScript(Me.GetType, "toobig", "alert('Please select a shorter date range. Max days to query is 30.');", True)
        End If
    End Sub

    Private Sub Export(ByVal dsOutput As DataSet)
        'Dim sw As New StringWriter
        'Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell
        Dim expr As String
        Dim r As Integer = 0

        For i As Integer = 0 To dsOutput.Tables(3).Columns.Count - 1
            cell = New TableCell
            Select Case i
                Case 0
                    cell.Text = "Group"
                Case 1
                    cell.Text = "Attorney"
                Case 2, 3
                    cell.Text = ""
                Case Else 'dates
                    cell.Text = dsOutput.Tables(3).Columns(i).ColumnName
            End Select
            cell.Attributes.Add("class", "hdr")
            tr.Cells.Add(cell)
        Next
        table.Rows.Add(tr)

        For Each row As DataRow In dsOutput.Tables(2).Rows
            tr = New TableRow
            For i As Integer = 0 To dsOutput.Tables(2).Columns.Count - 1
                cell = New TableCell
                If r > 0 AndAlso i < 2 Then
                    cell.Text = "" 'dont show commrec, company
                Else
                    'style
                    Select Case row("Type")
                        Case "Batched"
                            cell.Attributes.Add("class", "batched")
                        Case "Running Balance"
                            If IsNumeric(row.Item(i)) Then
                                If CInt(row.Item(i)) < 0 Then
                                    cell.Attributes.Add("class", "balneg")
                                Else
                                    cell.Attributes.Add("class", "balpos")
                                End If
                            Else
                                cell.Attributes.Add("class", "balpos")
                            End If
                        Case Else
                            cell.Attributes.Add("class", "norm")
                    End Select

                    'text
                    If IsNumeric(row.Item(i)) Then
                        cell.Text = FormatCurrency(Val(row.Item(i)), 2)
                    Else
                        cell.Text = row.Item(i).ToString
                    End If
                End If
                tr.Cells.Add(cell)

                If dsOutput.Tables(2).Columns(i).ColumnName = "Type" Then
                    cell = New TableCell
                    cell.Text = ""
                    Select row("Type")
                        Case "Batched"
                            cell.Attributes.Add("class", "batched")
                        Case "Running Balance"
                            cell.Attributes.Add("class", "balpos")
                        Case Else
                            cell.Attributes.Add("class", "norm")
                    End Select
                    tr.Cells.Add(cell)
                End If
            Next
            table.Rows.Add(tr)

            If row("Type") = "Batched" Then
                r = 0 'reset

                'add 5 blank rows
                For x As Integer = 0 To 4
                    tr = New TableRow
                    cell = New TableCell
                    cell.Text = ""
                    table.Rows.Add(tr)
                Next

                'add header
                For i As Integer = 0 To dsOutput.Tables(3).Columns.Count - 1
                    cell = New TableCell
                    Select Case i
                        Case 0
                            cell.Text = "Group"
                        Case 1
                            cell.Text = "Attorney"
                        Case 2, 3
                            cell.Text = ""
                        Case Else 'dates
                            cell.Text = dsOutput.Tables(3).Columns(i).ColumnName
                    End Select
                    cell.Attributes.Add("class", "hdr")
                    tr.Cells.Add(cell)
                Next
                table.Rows.Add(tr)
            Else
                r = 1
            End If

            'get payment/cb detail
            expr = String.Concat("type='", row("type"), "' and commrec='", row("commrec"), "' and company='", row("company"), "'")
            Dim rows() As DataRow = dsOutput.Tables(3).Select(expr)
            For k As Integer = 0 To rows.Length - 1
                tr = New TableRow
                For i As Integer = 0 To dsOutput.Tables(3).Columns.Count - 1
                    cell = New TableCell
                    If i < 3 Then
                        cell.Text = ""
                    Else
                        cell.Attributes.Add("class", "tdpaycb")
                        If IsNumeric(rows(k).Item(i)) Then
                            cell.Text = FormatCurrency(Val(rows(k).Item(i)), 2)
                        Else
                            cell.Text = rows(k).Item(i).ToString
                        End If
                    End If
                    tr.Cells.Add(cell)
                Next
                table.Rows.Add(tr)
            Next
        Next

        Response.Clear()
        Response.Charset = ""
        Response.ContentEncoding = System.Text.Encoding.UTF8
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.ContentType = "application/ms-excel.xls"
        Response.AddHeader("content-disposition", "attachment;filename=RunningBal.xls")

        Dim sw As New System.IO.StringWriter
        Dim htw As New HtmlTextWriter(sw)

        table.RenderControl(htw)

        'Appendg CSS file
        Dim fi As FileInfo = New FileInfo(Server.MapPath("runningbal.css"))
        Dim sb As New System.Text.StringBuilder
        Dim sr As StreamReader = fi.OpenText()
        Do While sr.Peek() >= 0
            sb.Append(sr.ReadLine())
        Loop
        sr.Close()

        Response.Write("<html><head><style type='text/css'>" & sb.ToString() & "</style><head>" & sw.ToString() & "</html>")
        sw = Nothing
        htw = Nothing
        Response.Flush()
        Response.End()


        'HttpContext.Current.Response.Clear()
        'HttpContext.Current.Response.ContentType = "application/ms-excel"
        'HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=RunningBalance.xls")
        'HttpContext.Current.Response.Write("<style>.text { mso-number-format:\@; } </style>")
        'HttpContext.Current.Response.Write(sw.ToString)
        'HttpContext.Current.Response.End()
    End Sub

    Protected Sub btnExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnExport.Click
        LoadGrid(True)
        'Dim da As New SqlDataAdapter()
        'Dim dsResults As New DataSet
        'Dim sw As New StringWriter
        'Dim htw As New HtmlTextWriter(sw)
        'Dim table As New System.Web.UI.WebControls.Table
        'Dim tr As New System.Web.UI.WebControls.TableRow
        'Dim cell As TableCell

        'Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_RunningBalance2")
        '    Using cmd.Connection
        '        DatabaseHelper.AddParameter(cmd, "startdate", txtStartDate.Text)
        '        DatabaseHelper.AddParameter(cmd, "enddate", txtEndDate.Text)
        '        DatabaseHelper.AddParameter(cmd, "userid", UserID)

        '        da.SelectCommand = cmd
        '        da.Fill(dsResults)
        '    End Using
        'End Using

        'For i As Integer = 0 To dsResults.Tables(3).Columns.Count - 1
        '    cell = New TableCell
        '    cell.Text = dsResults.Tables(3).Columns(i).ColumnName
        '    tr.Cells.Add(cell)
        'Next
        'table.Rows.Add(tr)

        'For Each row As DataRow In dsResults.Tables(3).Rows
        '    tr = New TableRow
        '    For i As Integer = 0 To dsResults.Tables(3).Columns.Count - 1
        '        cell = New TableCell
        '        cell.Attributes.Add("class", "text")
        '        cell.Text = row.Item(i).ToString
        '        tr.Cells.Add(cell)
        '    Next
        '    table.Rows.Add(tr)
        'Next

        'table.RenderControl(htw)

        'HttpContext.Current.Response.Clear()
        'HttpContext.Current.Response.ContentType = "application/ms-excel"
        'HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=RunningBalance.xls")
        ''HttpContext.Current.Response.Write("<style>.text { mso-number-format:\@; } </style>")
        'HttpContext.Current.Response.Write(sw.ToString)
        'HttpContext.Current.Response.End()
    End Sub

End Class
