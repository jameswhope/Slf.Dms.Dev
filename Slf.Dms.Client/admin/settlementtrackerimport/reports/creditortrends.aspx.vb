Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Partial Class admin_settlementtrackerimport_reports_creditortrends
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _Team As String
    Private _TrendType As String
    Private _userid As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property ReportMonth() As Integer
        Get
            Return hdnMonth.Value
        End Get
        Set(ByVal value As Integer)
            hdnMonth.Value = value
        End Set
    End Property

    Public Property ReportTeam() As String
        Get
            Return hdnTeam.Value
        End Get
        Set(ByVal value As String)
            hdnTeam.Value = value
        End Set
    End Property

    Public Property ReportTrendType() As String
        Get
            Return _TrendType
        End Get
        Set(ByVal value As String)
            _TrendType = value
        End Set
    End Property

    Public Property ReportYear() As Integer
        Get
            Return ViewState("ReportYear")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportYear") = value
        End Set
    End Property

    Public Property TrendTotalUnits() As Integer
        Get
            Return ViewState("_TrendTotalUnits")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TrendTotalUnits") = value
        End Set
    End Property

    Public Property TrendUniqueCreditors() As Integer
        Get
            Return ViewState("_TrendUniqueCreditors")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TrendUniqueCreditors") = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return _userid
        End Get
        Set(ByVal value As Integer)
            _userid = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Function AddHeaderRow(ByVal gridHeaderRow As System.Web.UI.WebControls.GridViewRowEventArgs, Optional ByVal bShowExtraData As Boolean = False) As GridViewRow
        'Add another Header Row
        Dim row As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        row.BackColor = System.Drawing.ColorTranslator.FromHtml("#3376AB")
        row.ForeColor = System.Drawing.Color.White
        row.Style("vertical-align") = "middle"
        row.CssClass = "entry"
        'row.Style("height") = "30px"
        'row.Style("padding") = "3px"

        Dim sortcell As New TableCell()
        sortcell.ColumnSpan = gridHeaderRow.Row.Cells.Count

        If bShowExtraData Then
            Try
                Using dt As DataTable = TryCast(dsCreditorTrends.Select(DataSourceSelectArguments.Empty), DataView).ToTable
                    TrendTotalUnits = dt.Compute("sum(totalunits)", Nothing)
                    TrendUniqueCreditors = dt.Rows.Count
                End Using
            Catch ex As Exception
                TrendTotalUnits = 0
                TrendUniqueCreditors = 0
            End Try

            Dim dvleft As New HtmlGenericControl("div style=""float:left; padding:3px;"" ")
            Dim lbltot As New Label
            With lbltot
                .Text = String.Format("Total Units: {0}", TrendTotalUnits)
            End With
            dvleft.Controls.Add(lbltot)

            dvleft.Controls.Add(New LiteralControl() With {.Text = "<br>"})

            Dim lblUniq As New Label
            With lblUniq
                .Text = String.Format("Unique Creditors: {0}", TrendUniqueCreditors)
            End With
            dvleft.Controls.Add(lblUniq)
            sortcell.Controls.Add(dvleft)
        End If

        Dim lnkExportExcel As New LinkButton() With {.Text = "Export to Excel", .ID = "lnkExportExcel", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        AddHandler lnkExportExcel.Click, AddressOf lnkExportExcel_Click
        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me.Page)
        sm.RegisterPostBackControl(lnkExportExcel)
        Dim dv As New HtmlGenericControl("div style=""float:right; padding:3px;"" ")
        dv.Controls.Add(New HtmlImage() With {.Src = ResolveUrl("~/images/16x16_edit.gif")})
        dv.Controls.Add(lnkExportExcel)
        sortcell.Controls.Add(dv)

        row.Cells.Add(sortcell)

        Return row
    End Function

    Protected Sub admin_settlementtrackerimport_reports_creditortrends_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If hdnMonth.Value = "" Then
            hdnMonth.Value = Now.Month
        End If
        If hdnYear.Value = "" Then
            hdnYear.Value = Now.Year
        End If
        If hdnTrend.Value = "" Then
            hdnTrend.Value = "all"
        End If

        ReportMonth = hdnMonth.Value
        ReportYear = hdnYear.Value
        ReportTrendType = hdnTrend.Value

        If Not IsPostBack Then
            ReportTeam = ""
            BindGrid(ReportTrendType)
        End If

        SetRollups()
    End Sub

    Protected Sub gridview_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCreditorTrends.RowCreated
        Select Case e.Row.RowType

            Case DataControlRowType.Header

                TryCast(sender, GridView).Controls(0).Controls.AddAt(0, AddHeaderRow(e, True))
                GridViewHelper.AddSortImage(sender, e)
        End Select
    End Sub

    Protected Sub lnkChangeMonth_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeMonth.Click
        BindGrid(ReportTrendType)
    End Sub

    Protected Sub lnkChangeTeam_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeTeam.Click
        BindGrid(ReportTrendType)
    End Sub

    Protected Sub lnkChangeTrend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeTrend.Click
        BindGrid(ReportTrendType)
    End Sub

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        BindGrid(ReportTrendType)
    End Sub

    Private Sub BindGrid(ByVal trendType As String)
        Select Case hdnTrend.Value.ToLower
            Case "all"
                Dim colNames As String() = "CreditorName,TotalUnits,TotalSettlementAmt,AvgSettlementPct,TotalSettlementFee".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                CreateGridViewColumns(colNames, gvCreditorTrends)
                With dsCreditorTrends
                    .SelectParameters.Clear()
                    .SelectCommandType = SqlDataSourceCommandType.StoredProcedure
                    .SelectCommand = "stp_settlementimport_reports_getCreditorTrendsByYearAndMonth"
                    .SelectParameters.Add("year", ReportYear)
                    .SelectParameters.Add("month", ReportMonth)
                    .SelectParameters.Add("top", "TOP 100 PERCENT")
                End With

            Case "top 20"
                Dim colNames As String() = "CreditorName,TotalUnits,AvgSettlementPct".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                CreateGridViewColumns(colNames, gvCreditorTrends)
                With dsCreditorTrends
                    .SelectParameters.Clear()
                    .SelectCommandType = SqlDataSourceCommandType.StoredProcedure
                    .SelectCommand = "stp_settlementimport_reports_getCreditorTrendsByYearAndMonth"
                    .SelectParameters.Add("year", ReportYear)
                    .SelectParameters.Add("month", ReportMonth)
                    .SelectParameters.Add("top", "TOP 20")

                End With

            Case "by team"

                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("year", ReportYear))
                params.Add(New SqlParameter("month", ReportMonth))
                params.Add(New SqlParameter("team", hdnTeam.Value))

                Dim colNames As New List(Of String)
                Using dt As DataTable = SqlHelper.GetDataTable("stp_settlementimport_reports_getCreditorTrendsByYearAndMonth", CommandType.StoredProcedure, params.ToArray)
                    For Each col As DataColumn In dt.Columns
                        colNames.Add(col.ColumnName)
                    Next
                End Using

                CreateGridViewColumns(colNames.ToArray, gvCreditorTrends)

                With dsCreditorTrends
                    .SelectCommandType = SqlDataSourceCommandType.StoredProcedure
                    .SelectCommand = "stp_settlementimport_reports_getCreditorTrendsByYearAndMonth"
                    .SelectParameters.Clear()
                    .SelectParameters.Add("year", ReportYear)
                    .SelectParameters.Add("month", ReportMonth)
                    .SelectParameters.Add("team", hdnTeam.Value)
                End With

        End Select

        dsCreditorTrends.DataBind()
        gvCreditorTrends.DataBind()
    End Sub

    Private Function BuildDateSelectionsHTMLControlString() As StringBuilder
        Dim selectCode As New StringBuilder
        selectCode.Append("Select Trend Type <br/>")
        selectCode.Append("<select id=""cboTrendType"" runat=""server"" class=""entry"" onchange=""TrendChanged(this);"">")

        For Each trend As String In ";all;top 20;by team".Split(";")
            Dim selectedText As String = ""
            If trend.ToLower = hdnTrend.Value.ToLower Then
                selectedText = "selected=""selected"""
            Else
                selectedText = ""
            End If
            selectCode.AppendFormat("<option label=""{0}"" value=""{1}"" {2}/>", StrConv(trend, VbStrConv.ProperCase), trend.ToLower, selectedText)
        Next
        selectCode.Append("</select><br/>")
        Dim bShowTeam As String = "none"
        If hdnTeam.value <> "" Then
            bShowTeam = "block"
        End If
        selectCode.AppendFormat("<fieldset style=""display:{0};"" id=""fldTeam""><legend>Select Team</legend>", bShowTeam)
        selectCode.Append("<select id=""cboTeam"" runat=""server"" class=""entry"" onchange=""TeamChanged(this);"">")
        dsTeams.SelectParameters("year").DefaultValue = ReportYear
        dsTeams.SelectParameters("month").DefaultValue = ReportMonth
        Using dt As DataTable = TryCast(dsTeams.Select(DataSourceSelectArguments.Empty), DataView).ToTable
            For Each dr As DataRow In dt.Rows
                Dim selectedText As String = ""
                If dr("team").ToString.ToLower = hdnTeam.Value.ToLower Then
                    selectedText = "selected=""selected"""
                Else
                    selectedText = ""
                End If
                selectCode.AppendFormat("<option label=""{0}"" value=""{1}"" {2}/>", StrConv(dr("team").ToString, VbStrConv.ProperCase), dr("team").ToString.ToLower, selectedText)
            Next
        End Using
        selectCode.Append("</select></fieldset><br/><br/>")

        selectCode.Append("Select Month <br/>")
        selectCode.Append("<select id=""cboMonth"" runat=""server"" class=""entry"" onchange=""MonthChanged(this);"">")
        For i As Integer = 1 To 12
            Dim optText As String = ""
            If i = ReportMonth Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", MonthName(i, False), i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", MonthName(i, False), i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/>")
        selectCode.Append("Select Year<br/>")
        selectCode.Append("<select id=""cboYear"" runat=""server"" class=""entry"" onchange=""YearChanged(this);"">")
        For i As Integer = Now.AddYears(-3).Year To Now.Year
            Dim optText As String = ""
            If i = ReportYear Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", i, i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", i, i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/>")
        selectCode.AppendFormat("<br/><a href=""{0}"">Home</a>", ResolveUrl("../../settlementtrackerimport/default.aspx"))
        Return selectCode
    End Function

    Private Sub CreateGridViewColumns(ByVal colNames As String(), ByVal gvToUse As GridView)
        gvToUse.AutoGenerateColumns = False
        gvToUse.Columns.Clear()
        gvToUse.GridLines = GridLines.None
        gvToUse.AllowSorting = True
        gvToUse.ShowFooter = False

        For Each col As String In colNames
            Dim bc As New BoundField
            If col.ToLower.Contains("name") Then
                bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
                bc.ItemStyle.HorizontalAlign = HorizontalAlign.Left
            ElseIf col.ToLower.Contains("units") Then
                bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
                bc.ItemStyle.HorizontalAlign = HorizontalAlign.Center
            ElseIf col.ToLower.Contains("amt") Or col.Contains("Fee") Or col.Contains("$") Then
                bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Right
                bc.ItemStyle.HorizontalAlign = HorizontalAlign.Right
                bc.DataFormatString = "{0:c}"
            ElseIf col.ToLower.Contains("pct") Or col.Contains("%") Then
                bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
                bc.ItemStyle.HorizontalAlign = HorizontalAlign.Center
                bc.DataFormatString = "{0:p2}"
            Else
                bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
                bc.ItemStyle.HorizontalAlign = HorizontalAlign.Center
                bc.HeaderStyle.Wrap = True
                bc.HeaderStyle.Width = New Unit("50 px")
            End If
            bc.DataField = col
            bc.SortExpression = col
            bc.HeaderText = ClientFileDocumentHelper.InsertSpaceAfterCap(col)
            bc.HeaderStyle.CssClass = "headitem5"
            bc.ItemStyle.CssClass = "listitem"
            bc.HeaderStyle.VerticalAlign = VerticalAlign.Bottom
            bc.FooterStyle.CssClass = "footeritem"
            gvToUse.Columns.Add(bc)
        Next
    End Sub

    Private Sub PrepareGridViewForExport(ByVal gv As Control)
        Dim lb As New LinkButton()
        Dim l As New Literal()
        Dim name As String = [String].Empty
        Dim i As Integer = 0
        While i < gv.Controls.Count
            If TypeOf gv.Controls(i) Is LinkButton Then
                l.Text = (TryCast(gv.Controls(i), LinkButton)).Text
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            ElseIf TypeOf gv.Controls(i) Is DropDownList Then
                l.Text = (TryCast(gv.Controls(i), DropDownList)).SelectedItem.Text
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            ElseIf TypeOf gv.Controls(i) Is CheckBox Then
                l.Text = If((TryCast(gv.Controls(i), CheckBox)).Checked, "True", "False")
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            End If
            If gv.Controls(i).HasControls() Then
                PrepareGridViewForExport(gv.Controls(i))
            End If
            System.Math.Max(System.Threading.Interlocked.Increment(i), i - 1)
        End While
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settlementtrackerimport_trackerimport).CommonTasks

        Dim selectCode As StringBuilder = BuildDateSelectionsHTMLControlString()

        CommonTasks.Add(selectCode.ToString)
    End Sub

    Private Sub lnkExportExcel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        'Dim dv As DataView = dsSearch.Select(DataSourceSelectArguments.Empty)
        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=tracker.xls")
        Response.Charset = ""
        ' If you want the option to open the Excel file without saving then
        ' comment out the line below
        ' Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.ContentType = "application/ms-excel"

        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        Dim gv As GridView = TryCast(lnk.NamingContainer.NamingContainer, GridView)

        'gv.DataSourceID = dsCreditorTrends.ID

        gv.AllowPaging = False
        gv.DataBind()

        PrepareGridViewForExport(gv)
        gv.RenderControl(htmlWrite)

        Response.Write(stringWrite.ToString())
        Response.End()

        Response.Write(stringWrite.ToString())
        Response.End()
    End Sub

    #End Region 'Methods

End Class