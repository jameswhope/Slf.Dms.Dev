Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class admin_settlementtrackerimport_reports_taskstatistics
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _userid As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property ReportMonth() As Integer
        Get
            Return ViewState("ReportMonth")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportMonth") = value
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

    <Services.WebMethod> _
    Public Shared Function PM_getDetailData(ByVal detailDataTerm As String) As String
        Dim dd As New DetailData

        Dim sbTbl As New StringBuilder
        Dim sqlData As String = ""
        Dim terms As String() = detailDataTerm.Split("_")
        Dim params As New List(Of SqlParameter)

        Select Case terms(2).ToLower
            Case "gvSettlementPipeline".ToLower
                dd.GridViewName = terms(2)
                sqlData = "stp_settlementimport_reports_getPipelineDetailData"
                params.Add(New SqlParameter("year", terms(0)))
                params.Add(New SqlParameter("month", terms(1)))
                params.Add(New SqlParameter("filter", terms(3).ToLower))
            Case "gvSettlementResolution".ToLower
                sqlData = "stp_settlementimport_reports_getResolutionDetailData"
                params.Add(New SqlParameter("year", terms(0)))
                params.Add(New SqlParameter("month", terms(1)))
                params.Add(New SqlParameter("filter", terms(3).ToLower))
        End Select
        Try
            Using dt As DataTable = SqlHelper.GetDataTable(sqlData, CommandType.StoredProcedure, params.ToArray)

                dd.GridCaption = String.Format("<b>Date:</b> {0} {1}&nbsp;&nbsp;<b>Filter:</b> {2}&nbsp;&nbsp;<b>Total Record(s):</b> {3}", MonthName(terms(1)), terms(0), terms(3), dt.Rows.Count)
                If dt.Rows.Count > 0 Then
                    Dim SB As New StringBuilder()
                    Dim SW As New StringWriter(SB)
                    Dim htmlTW As New HtmlTextWriter(SW)
                    sbTbl.Append("<div class=""tableContainer""><table id=""tblDetail"" class=""entry"" cellpadding=""0"" cellspacing=""0"" border=""1"">")
                    sbTbl.Append("<thead><tr style=""background-color: #DCDCDC;border-bottom: solid 1px #d3d3d3; font-weight:normal;color:Black; " & _
                                 "font-size:11px; font-family:tahoma;height:30px;vertical-align:top;"">")
                    For i As Integer = 0 To dt.Columns.Count - 1
                        Dim colName As String = dt.Columns(i).ColumnName
                        Select Case colName.ToLower
                            'Case "settlementid","status", "negotiator", "creditorname"
                            Case "CreditorBal".ToLower, "SettlementAmt".ToLower, "SettlementFee".ToLower, "Client CDA Bal".ToLower
                                colName = colName.Replace("Client", "").Replace("Settlement", "Settlement<br>").Replace("Bal", "<br>Bal")
                                sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:right; width:75px;"">{0}</th>", colName)
                            Case "settlementduedate"
                                sbTbl.Append("<th class=""headitem5"" style=""white-space:nowrap;text-align:center"">Due</th>")
                            Case "paid".ToLower
                                sbTbl.Append("<th class=""headitem5"" style=""white-space:nowrap;text-align:center"">Paid</th>")
                            Case "clientacctnum"
                                sbTbl.Append("<th class=""headitem5"" style=""white-space:nowrap;text-align:left"">Client #</th>")
                            Case "clientname"
                                sbTbl.Append("<th class=""headitem5"" style=""white-space:nowrap;text-align:left;"">Client</th>")
                            Case "client stipulation", "Payment Arrangement".ToLower, "Restrictive Endorsement".ToLower, "LC Approval".ToLower
                                sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:center; width:50px;"">{0}</th>", colName)
                            Case Else
                                sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:left"">{0}</th>", colName)
                        End Select

                    Next
                    sbTbl.Append("</tr></thead><tbody>")
                    For Each Row As DataRow In dt.Rows
                        sbTbl.Append("<tr class=""listItem"" style=""cursor:pointer;border-bottom: solid 1px #d3d3d3;vertical-align:top; "" onmouseover=""this.style.cursor='pointer';this.style.backgroundColor='#C6DEF2'"" onmouseout=""this.style.cursor='default';this.style.backgroundColor=''"" >")
                        For i As Integer = 0 To dt.Columns.Count - 1
                            Select Case dt.Columns(i).ColumnName.ToLower
                                'Case "settlementid","status", "negotiator", "creditorname"
                                Case "settlementduedate", "paid".ToLower
                                    Dim strDate As String = Row.Item(i).ToString
                                    If strDate <> "" Then
                                        strDate = Format(CDate(strDate), "MM/dd/yyyy")
                                    Else
                                        strDate = "NA"
                                    End If
                                    sbTbl.AppendFormat("<td class=""listItem"" style=""white-space:nowrap;text-align:center"">{0}</td>", strDate)
                                Case "CreditorBal".ToLower, "SettlementAmt".ToLower, "SettlementFee".ToLower, "Client CDA Bal".ToLower
                                    Dim strCurrency As String = Row.Item(i).ToString
                                    If strCurrency = "" Then
                                        strCurrency = "0.00"
                                    End If
                                    sbTbl.AppendFormat("<td class=""listItem"" style=""white-space:nowrap;text-align:right"">{0}</td>", FormatCurrency(strCurrency, 2, TriState.True, TriState.False, TriState.True))
                                Case "clientname"
                                    sbTbl.AppendFormat("<td class=""listItem"" style=""text-align:left"">{0}</td>", Row.Item(i).ToString)
                                Case "client stipulation", "Payment Arrangement".ToLower, "Restrictive Endorsement".ToLower, "LC Approval".ToLower
                                    sbTbl.AppendFormat("<td class=""listItem"" style=""font-weight:bold;white-space:nowrap;text-align:center"">{0}</td>", Row.Item(i).ToString)
                                Case Else
                                    sbTbl.AppendFormat("<td class=""listItem"" style=""text-align:left"">{0}</td>", Row.Item(i).ToString)
                            End Select
                        Next
                        sbTbl.Append("</tr>")
                    Next
                    sbTbl.Append("</tbody></table></div>")
                Else
                    sbTbl.Append("<table class=""entry"" cellpadding=""0"" cellspacing=""0""><tr><td style=""height:50px;""><div class=""info"">No Detail Data</div></td></tr></table>")
                End If
                dd.GridviewData = sbTbl.ToString
            End Using
        Catch ex As Exception
            dd.GridCaption = "**Detail Error**"
            dd.GridviewData = String.Format("<table class=""entry""><tr><td>{0}</td></tr><table>", ex.Message)
        End Try
       


        Return jsonHelper.SerializeObjectIntoJson(dd)
    End Function

    Protected Sub admin_settlementtrackerimport_reports_taskstatistics_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If hdnYear.Value = "" Then
            hdnYear.Value = Now.Year
        End If

        ReportYear = hdnYear.Value

        If Not IsPostBack Then
            BindGrids()
        End If

        SetRollups()
    End Sub

    Protected Sub gridView_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow

                Dim gvName As String = TryCast(sender, GridView).ID
                e.Row.Style("cursor") = "hand"
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Select Case gvName.ToLower
                    Case "gvSettlementPipeline".ToLower
                        For i As Integer = 3 To e.Row.Cells.Count - 1
                            e.Row.Cells(i).Attributes.Add("onclick", String.Format("ShowDetailData('{0}_{1}_{2}_{3}');", rowView("YearNumber").ToString, rowView("Monthnumber").ToString, gvName, TryCast(sender, GridView).Columns(i).HeaderText))
                            e.Row.Cells(i).Attributes.Add("onmouseover", "this.style.color = 'green'; this.style.fontWeight = 'bold';this.style.textDecoration = 'underline';")
                            e.Row.Cells(i).Attributes.Add("onmouseout", "this.style.color = 'black';this.style.fontWeight = '';;this.style.textDecoration = 'none'")
                        Next
                    Case "gvSettlementResolution".ToLower
                        For i As Integer = 2 To e.Row.Cells.Count - 1
                            e.Row.Cells(i).Attributes.Add("onclick", String.Format("ShowDetailData('{0}_{1}_{2}_{3}');", rowView("YearNumber").ToString, rowView("Monthnumber").ToString, gvName, TryCast(sender, GridView).Columns(i).HeaderText.Trim))
                            e.Row.Cells(i).Attributes.Add("onmouseover", "this.style.color = 'green'; this.style.fontWeight = 'bold';this.style.textDecoration = 'underline';")
                            e.Row.Cells(i).Attributes.Add("onmouseout", "this.style.color = 'black';this.style.fontWeight = '';;this.style.textDecoration = 'none'")
                        Next
                    Case Else
                        For i As Integer = 0 To e.Row.Cells.Count - 1
                            e.Row.Cells(i).Attributes.Add("onclick", "alert('Not implemented for this grid!')")
                        Next
                End Select
               
             
            Case DataControlRowType.Footer

        End Select
    End Sub

    

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        BindGrids
    End Sub

    Protected Sub sqlDataSource_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs)
        e.Command.CommandTimeout = 60
    End Sub

    Private Shared Function AddPipelineHeaderRow() As GridViewRow
        Dim row As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        row.ForeColor = System.Drawing.Color.Black
        row.Style("vertical-align") = "middle"
        row.Style("font-weight") = "bold"
        row.CssClass = "entry"

        Dim sortcell As New TableCell()
        sortcell.BorderStyle = BorderStyle.None
        row.Cells.Add(sortcell)

        sortcell = New TableCell()
        sortcell.BorderStyle = BorderStyle.None
        row.Cells.Add(sortcell)

        sortcell = New TableCell()
        sortcell.ColumnSpan = 3
        sortcell.BackColor = System.Drawing.ColorTranslator.FromHtml("#E2E2E2")
        sortcell.Text = "Submitted"
        sortcell.Style("border") = "solid 2px black"
        sortcell.HorizontalAlign = HorizontalAlign.Center
        row.Cells.Add(sortcell)

        sortcell = New TableCell()
        sortcell.ColumnSpan = 6
        sortcell.Text = "Waiting"
        sortcell.Style("border") = "solid 2px black"
        sortcell.BackColor = System.Drawing.ColorTranslator.FromHtml("#EAF1DD")
        sortcell.HorizontalAlign = HorizontalAlign.Center
        row.Cells.Add(sortcell)

        sortcell = New TableCell()
        sortcell.ColumnSpan = 3
        sortcell.Text = "Processing"
        sortcell.Style("border") = "solid 2px black"
        sortcell.HorizontalAlign = HorizontalAlign.Center
        row.Cells.Add(sortcell)
        Return row
    End Function

    Private Shared Function AddResolutionHeaderRow() As GridViewRow
        Dim row As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        row.ForeColor = System.Drawing.Color.Black
        row.Style("vertical-align") = "middle"
        row.Style("font-weight") = "bold"
        row.CssClass = "entry"

        Dim sortcell As New TableCell()
        sortcell.BorderStyle = BorderStyle.None
        row.Cells.Add(sortcell)

        sortcell = New TableCell()
        sortcell.ColumnSpan = 4
        sortcell.BackColor = System.Drawing.ColorTranslator.FromHtml("#E6B9B8")
        sortcell.Text = "Rejected/Canceled"
        sortcell.Style("border") = "solid 2px black"
        sortcell.HorizontalAlign = HorizontalAlign.Center
        row.Cells.Add(sortcell)

        sortcell = New TableCell()
        sortcell.ColumnSpan = 6
        sortcell.Text = "Expired"
        sortcell.Style("border") = "solid 2px black"
        sortcell.BackColor = System.Drawing.ColorTranslator.FromHtml("#E6B9B8")
        sortcell.HorizontalAlign = HorizontalAlign.Center
        row.Cells.Add(sortcell)

        sortcell = New TableCell()
        sortcell.ColumnSpan = 3
        sortcell.Text = "Paid"
        sortcell.Style("border") = "solid 2px black"
        sortcell.BackColor = System.Drawing.ColorTranslator.FromHtml("#D7E4BC")
        sortcell.HorizontalAlign = HorizontalAlign.Center
        row.Cells.Add(sortcell)
        Return row
    End Function

    Private Sub BindGrids()
        AddHandler dsSettlementPipeline.Selecting, AddressOf sqlDataSource_Selecting
        AddHandler gvSettlementPipeline.RowDataBound, AddressOf gridView_RowDataBound
        dsSettlementPipeline.SelectParameters("year").DefaultValue = ReportYear
        dsSettlementPipeline.DataBind()
        gvSettlementPipeline.DataBind()

        AddHandler dsSettlementReceivables.Selecting, AddressOf sqlDataSource_Selecting
        AddHandler gvSettlementReceivables.RowDataBound, AddressOf gridView_RowDataBound
        dsSettlementReceivables.SelectParameters("year").DefaultValue = ReportYear
        dsSettlementReceivables.DataBind()
        gvSettlementReceivables.DataBind()

        AddHandler dsSettlementResolution.Selecting, AddressOf sqlDataSource_Selecting
        AddHandler gvSettlementResolution.RowDataBound, AddressOf gridView_RowDataBound
        dsSettlementResolution.SelectParameters("year").DefaultValue = ReportYear
        dsSettlementResolution.DataBind()
        gvSettlementResolution.DataBind()
    End Sub

    Private Function BuildDateSelectionsHTMLControlString() As StringBuilder
        Dim selectCode As New StringBuilder
        'selectCode.Append("Select Year<br/>")
        'selectCode.Append("<select id=""cboYear"" runat=""server"" class=""entry"" onchange=""YearChanged(this);"">")
        'For i As Integer = Now.AddYears(-3).Year To Now.Year
        '    Dim optText As String = ""
        '    If i = ReportYear Then
        '        optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", i, i)
        '    Else
        '        optText = String.Format("<option label=""{0}"" value=""{1}"" />", i, i)
        '    End If
        '    selectCode.Append(optText)
        'Next
        'selectCode.Append("</select><br/>")
        selectCode.AppendFormat("<br/><a href=""{0}"">Home</a>", ResolveUrl("../../settlementtrackerimport/default.aspx"))
        Return selectCode
    End Function

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settlementtrackerimport_trackerimport).CommonTasks

        Dim selectCode As StringBuilder = BuildDateSelectionsHTMLControlString()

        CommonTasks.Add(selectCode.ToString)
    End Sub


    #End Region 'Methods

    #Region "Nested Types"

    Public Class DetailData

        #Region "Fields"

        Private _GridCaption As String
        Private _GridViewName As String
        Private _GridviewData As String

        #End Region 'Fields

        #Region "Properties"

        Public Property GridCaption() As String
            Get
                Return _GridCaption
            End Get
            Set(ByVal value As String)
                _GridCaption = value
            End Set
        End Property

        Public Property GridViewName() As String
            Get
                Return _GridViewName
            End Get
            Set(ByVal value As String)
                _GridViewName = value
            End Set
        End Property

        Public Property GridviewData() As String
            Get
                Return _GridviewData
            End Get
            Set(ByVal value As String)
                _GridviewData = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    #End Region 'Nested Types

End Class