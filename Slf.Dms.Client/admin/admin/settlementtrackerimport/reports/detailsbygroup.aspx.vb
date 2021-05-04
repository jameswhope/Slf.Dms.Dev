Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class admin_settlementtrackerimport_reports_detailsbygroup
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _DetailType As String
    Private _FooterRow As GridViewRow
    Private _userid As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property ReportGroup() As String
        Get
            Return hdnGroup.Value
        End Get
        Set(ByVal value As String)
            hdnGroup.Value = value
        End Set
    End Property

    Public Property ReportMonth() As Integer
        Get
            Return hdnMonth.Value
        End Get
        Set(ByVal value As Integer)
            hdnMonth.Value = value
        End Set
    End Property

    Public Property ReportYear() As Integer
        Get
            Return hdnYear.Value
        End Get
        Set(ByVal value As Integer)
            hdnYear.Value = value
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

        dd.GridViewName = "gvDetailGroups"
        sqlData = "select s.settlementid,[ClientAcctNum] = c.accountnumber,[ClientName]=p.firstname + ' ' + p.lastname,[Client CDA Bal]=s.availsda "
        sqlData += ",[CreditorName]=cc.name,[CreditorBal]=ci.amount,[SettlementAmt]=s.settlementamount,[SettlementFee]=s.settlementfee "
        sqlData += ",sti.team ,[Negotiator]=uc.firstname + ' ' + uc.lastname "
        sqlData += ",[Client Stipulation] = case when isnull(s.isclientstipulation ,0)=1 then 'Y' else 'N' end "
        sqlData += ",[Payment Arrangement] = case when isnull(s.isPaymentArrangement ,0)=1 then 'Y' else 'N' end "
        sqlData += ",[Restrictive Endorsement]=case when isnull(s.IsRestrictiveEndorsement ,0)=1 then 'Y' else 'N' end "
        sqlData += ",[LC Approval] = case when s.recommend is null then 'Y' else 'N' end ,[Agency]=ag.name "
        sqlData += ",[Status]=Isnull(msc.MatterStatusCodeDescr ,'NONE') "
        sqlData += "from tblsettlementtrackerimports sti inner join tblagency ag on ag.agencyid = sti.agencyid "
        sqlData += "inner join tblsettlements s with(nolock) on s.settlementid = sti.settlementid inner join tblclient c with(nolock) on s.clientid  = c.clientid "
        sqlData += "inner join tblperson p with(nolock) on p.personid = c.primarypersonid inner join tblaccount a with(nolock) on a.accountid = s.creditoraccountid "
        sqlData += "inner join tblcreditorinstance ci with(nolock) on ci.creditorinstanceid = a.currentcreditorinstanceid inner join tblcreditor cc with(nolock) on ci.creditorid = cc.creditorid "
        sqlData += "inner join tbluser uc with(nolock) on uc.userid = s.createdby left join tblmatter m with(nolock) on s.matterid = m.matterid "
        sqlData += "left join tblmatterstatuscode msc with(nolock) on m.matterstatuscodeid = msc.matterstatuscodeid "

        Select Case terms(2).ToLower
            Case "agency"
                sqlData += String.Format("where ag.name = '{0}' and ", terms(3))
            Case "team"
                sqlData += String.Format("where sti.team = '{0}' and ", terms(3))
            Case "negotiator"
                sqlData += String.Format("where uc.firstname + ' ' + uc.lastname = '{0}' and ", terms(3))
        End Select
        If terms(4).ToString.ToLower.Contains("paid") Then
            sqlData += String.Format("year(paid) = {0} and month(paid) = {1} and canceldate is null and expired is null ", terms(0), terms(1))
        Else
            sqlData += String.Format("year(date) = {0} and month(date) = {1} ", terms(0), terms(1))
        End If
        sqlData += "order by s.created option (fast 500) "

        Using dt As DataTable = SqlHelper.GetDataTable(sqlData, CommandType.Text)

            dd.GridCaption = String.Format("<b>Date:</b> {0} {1}&nbsp;&nbsp;<b>Group:</b>&nbsp;{2}&nbsp;&nbsp;<b>Filter:</b> {3}&nbsp;&nbsp;<b>Column:</b>&nbsp;{4}&nbsp;&nbsp;<b>Total Record(s):</b> {5}", MonthName(terms(1)), terms(0), terms(2).ToUpper, terms(3), terms(4), dt.Rows.Count)

            If dt.Rows.Count > 0 Then
                Dim SB As New StringBuilder()
                Dim SW As New StringWriter(SB)
                Dim htmlTW As New HtmlTextWriter(SW)
                sbTbl.Append("<div class=""tableContainer"" ><table id=""tblDetail"" class=""entry"" cellpadding=""0"" cellspacing=""0"" border=""1"">")
                sbTbl.Append("<thead><tr style=""background-color: #DCDCDC;border-bottom: solid 1px #d3d3d3; ")
                sbTbl.Append("font-weight:bold;color:Black; font-size:11px; font-family:tahoma;height:30px;vertical-align:top;"">")
                'grid headers
                For i As Integer = 0 To dt.Columns.Count - 1
                    Dim colName As String = dt.Columns(i).ColumnName
                    Select Case colName.ToLower
                        Case "settlementid" ', "status" ', "negotiator", "creditorname", "agency", "team"
                            'add to this case to not show
                        Case "CreditorBal".ToLower, "SettlementAmt".ToLower, "SettlementFee".ToLower, "Client CDA Bal".ToLower
                            colName = colName.Replace("Client", "").Replace("Settlement", "Settlement<br>").Replace("Bal", "<br>Bal")
                            sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:right; width:75px;"">{0}</th>", colName)
                        Case "ClientAcctNum".ToLower
                            sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:left"">{0}</th>", "Client #")
                        Case "ClientName".ToLower
                            sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:left"">{0}</th>", "Client")
                        Case "client stipulation", "Payment Arrangement".ToLower, "Restrictive Endorsement".ToLower, "LC Approval".ToLower
                            sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:center; width:50px;"">{0}</th>", colName)
                        Case Else
                            sbTbl.AppendFormat("<th class=""headitem5"" style=""text-align:left"">{0}</th>", StrConv(colName, VbStrConv.ProperCase))
                    End Select

                Next
                sbTbl.Append("</tr></thead><tbody>")
                'grid rows
                For Each Row As DataRow In dt.Rows
                    sbTbl.Append("<tr class=""listItem"" style=""cursor:pointer;border-bottom: solid 1px #d3d3d3;vertical-align:top; "" onmouseover=""this.style.cursor='pointer';this.style.backgroundColor='#C6DEF2'"" onmouseout=""this.style.cursor='default';this.style.backgroundColor=''"" >")
                    For i As Integer = 0 To dt.Columns.Count - 1
                        Dim colName As String = dt.Columns(i).ColumnName
                        Select Case colName.ToLower
                            Case "settlementid" ', "status" ', "negotiator", "creditorname", "agency", "team"
                                'add to this case to not show
                            Case "CreditorBal".ToLower, "SettlementAmt".ToLower, "SettlementFee".ToLower, "Client CDA Bal".ToLower
                                sbTbl.AppendFormat("<td class=""listItem"" style=""font-weight:bold;white-space:nowrap;text-align:right"">{0}</td>", FormatCurrency(Row.Item(i).ToString, 2, TriState.True, TriState.False, TriState.True))
                            Case "client stipulation", "Payment Arrangement".ToLower, "Restrictive Endorsement".ToLower, "LC Approval".ToLower
                                sbTbl.AppendFormat("<td class=""listItem"" style=""font-weight:bold;white-space:nowrap;text-align:center"">{0}</td>", Row.Item(i).ToString)

                            Case Else
                                sbTbl.AppendFormat("<td class=""listItem"" style=""font-weight:bold;text-align:left"">{0}</td>", Row.Item(i).ToString)
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

        Return jsonHelper.SerializeObjectIntoJson(dd)
    End Function

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

    Public Overloads Overrides Sub VerifyRenderingInServerForm(ByVal control As System.Web.UI.Control)
        'confirms that an HtmlForm control is rendered for the
        'specified ASP.NET server control at run time.
    End Sub

    Protected Sub admin_settlementtrackerimport_reports_detailsbygroup_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If hdnMonth.Value = "" Then
            ReportMonth = Now.Month
        End If
        If hdnYear.Value = "" Then
            ReportYear = Now.Year
        End If
        If hdnGroup.Value = "" Then
            ReportGroup = "agency"
        End If

        lblGroupInfo.Text = String.Format("Details By {0}", StrConv(ReportGroup, VbStrConv.ProperCase))

        BindGrid()
        SetRollups()
    End Sub

    Protected Sub gridView_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetailGroups.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                e.Row.CssClass = "headitem5"

            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                e.Row.CssClass = "listitem"
                e.Row.Style("cursor") = "hand"
                If e.Row.Cells(0).Text.ToString.ToLower = "total" Then
                    e.Row.CssClass = "footerItem"
                    _FooterRow = e.Row
                    e.Row.Style("display") = "none"
                Else
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If

                For i As Integer = 1 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Attributes.Add("onclick", String.Format("ShowDetailData('{0}_{1}_{2}_{3}_{4}');", ReportYear, ReportMonth, ReportGroup, rowView(0).ToString, gvDetailGroups.Columns(i).HeaderText))
                Next
                e.Row.ToolTip = "Click cell to see detail info."

            Case DataControlRowType.Footer
                For i As Integer = 0 To _FooterRow.Cells.Count - 1
                    e.Row.Cells(i).Text = _FooterRow.Cells(i).Text
                Next

        End Select
    End Sub

    Protected Sub gv_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetailGroups.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                TryCast(sender, GridView).Controls(0).Controls.AddAt(0, AddHeaderRow(e))
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Footer
                For Each tc As TableCell In e.Row.Cells
                    tc.Style("font-weight") = "bold"
                    Dim lbl As New Label
                    lbl.Text = ""
                    tc.Controls.Add(lbl)
                Next

        End Select
    End Sub

    Protected Sub lnkChangeGroup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeGroup.Click
        BindGrid()
    End Sub

    Protected Sub lnkChangeMonth_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeMonth.Click
        BindGrid()
    End Sub

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        BindGrid()
    End Sub

    Private Sub BindGrid()
        Select Case ReportGroup
            Case "team"
                dsDetailGroups.SelectCommand = "stp_settlementimport_reports_getTeamTotals"
                gvDetailGroups.Columns.RemoveAt(0)
                Dim bc As New BoundField
                bc.DataField = "teamname"
                bc.HeaderStyle.CssClass = "headItem5"
                bc.ItemStyle.CssClass = "listItem"
                bc.SortExpression = "teamname"
                bc.HeaderText = "Team"
                gvDetailGroups.Columns.Insert(0, bc)
            Case "agency"
                dsDetailGroups.SelectCommand = "stp_settlementimport_reports_getAgencyTotals"
                gvDetailGroups.Columns.RemoveAt(0)
                Dim bc As New BoundField
                bc.DataField = "agencyname"
                bc.HeaderStyle.CssClass = "headItem5"
                bc.ItemStyle.CssClass = "listItem"
                bc.SortExpression = "agencyname"
                bc.HeaderText = "Agency"
                gvDetailGroups.Columns.Insert(0, bc)
            Case "negotiator"
                dsDetailGroups.SelectCommand = "stp_settlementimport_reports_getNegotiatorTotals"
                gvDetailGroups.Columns.RemoveAt(0)
                Dim bc As New BoundField
                bc.DataField = "NegotiatorName"
                bc.HeaderStyle.CssClass = "headItem5"
                bc.ItemStyle.CssClass = "listItem"
                bc.SortExpression = "NegotiatorName"
                bc.HeaderText = "Negotiator"
                gvDetailGroups.Columns.Insert(0, bc)
        End Select
        dsDetailGroups.SelectParameters("year").DefaultValue = ReportYear
        dsDetailGroups.SelectParameters("month").DefaultValue = ReportMonth
        dsDetailGroups.DataBind()
        gvDetailGroups.DataBind()
    End Sub

    Private Function BuildDateSelectionsHTMLControlString() As StringBuilder
        Dim selectCode As New StringBuilder
        selectCode.Append("Select Detail Group<br/>")
        selectCode.Append("<select id=""cboGroup"" runat=""server"" class=""entry"" onchange=""GroupChanged(this);"">")
        For Each grp As String In "Agency;Team;Negotiator".Split(";")
            Dim optText As String = ""
            If grp.ToLower = hdnGroup.Value.ToLower Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", grp, grp.ToLower)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", grp, grp.ToLower)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/><hr>")

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

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me)
        sm.RegisterPostBackControl(lnkExportExcel)
    End Sub

    Private Sub lnkExportExcel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        Dim dv As DataView = dsDetailGroups.Select(DataSourceSelectArguments.Empty)
        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=tracker.xls")
        Response.Charset = ""
        ' If you want the option to open the Excel file without saving then
        ' comment out the line below
        ' Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.ContentType = "application/ms-excel"

        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        Using gv As GridView = gvDetailGroups '= TryCast(lnk.NamingContainer.NamingContainer, GridView)
            gv.DataSourceID = dsDetailGroups.ID

            gv.AllowPaging = False
            gv.DataBind()

            PrepareGridViewForExport(gv)
            gv.RenderControl(htmlWrite)
        End Using

        Response.Write(stringWrite.ToString())
        Response.End()

        Response.Write(stringWrite.ToString())
        Response.End()

        BindGrid()
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