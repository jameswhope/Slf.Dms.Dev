Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports LocalHelper

Structure sAgency
    Public AgencyName As String
    Public ParentCommRec As Dictionary(Of Integer, sParentCommRec)
End Structure

Structure sParentCommRec
    Public CommRec As Dictionary(Of Integer, sCommRec)
End Structure

Structure sCommRec
    Public Level As Integer
    Public IsLast As Boolean
    Public CommRec As String
    Public EntryType As Dictionary(Of Integer, sEntryType)
End Structure

Structure sEntryType
    Public Amount As Single
    Public TransferAmount As Single
    Public AmountPaid As Single
End Structure

Partial Class research_reports_financial_commission_batchpaymentssummary
    Inherits PermissionPage


#Region "Variables"

    Private UserID As Integer
    Private qs As QueryStringCollection
    Private company As String
    Private trust As Integer

#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()

        If Not IsPostBack Then
            Dim da As SqlDataAdapter
            Dim ds As New DataSet
            Dim CompanyIDs As String

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    CompanyIDs = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

                    cmd.CommandText = "SELECT CompanyID, ShortCoName FROM tblCompany"

                    If Len(CompanyIDs) > 0 Then
                        cmd.CommandText &= " WHERE CompanyID in (" & CompanyIDs & ")"
                    End If

                    cmd.CommandText &= " ORDER BY ShortCoName"

                    da = New SqlDataAdapter(cmd)
                    da.Fill(ds)

                    ddlCompany.DataSource = ds.Tables(0)
                    ddlCompany.DataTextField = "ShortCoName"
                    ddlCompany.DataValueField = "CompanyID"
                    ddlCompany.DataBind()
                End Using
            End Using

            company = Request.QueryString("company")

            If Len(company) > 0 Then
                ddlCompany.Items.FindByValue(company).Selected = True
            Else
                company = ddlCompany.Items(0).Value
            End If
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT CommRecID FROM tblCommRec WHERE isTrust = 1 AND CompanyID = (SELECT TOP 1 CompanyID FROM tblCompany WHERE CompanyID = " + ddlCompany.SelectedValue.ToString() + ")"
                cmd.Connection.Open()
                trust = CInt(cmd.ExecuteScalar())
            End Using
        End Using

        If Not qs Is Nothing Then

            LoadCommRecips()

            If Not IsPostBack Then

                LoadValues(GetControls(), Me)
                LoadQuickPickDates()

                Requery()

            End If

            SetAttributes()

        End If

    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/research/reports/financial/commission/batchpaymentssummaryxls.ashx"))
    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optCommRecChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optCommRecChoice.ID, "value", _
                optCommRecChoice.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csCommRecID.ID, "store", csCommRecID.SelectedStr)

        If txtTransDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate1.ID, "value", _
                txtTransDate1.Text)
        End If

        If txtTransDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate2.ID, "value", _
                txtTransDate2.Text)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlQuickPickDate.ID, "index", _
                    ddlQuickPickDate.SelectedIndex)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkBreakdownFeeTypes.ID, "value", _
                    chkBreakdownFeeTypes.Checked)
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkGroupByAgency.ID, "value", _
                    chkGroupByAgency.Checked)


    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If Not lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        End If

    End Sub
    Protected Sub lnkShowFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowFilter.Click

        If lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        Else 'is NOT selected

            'just delete the settings  - which will select on refresh
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name _
                & "' AND [Object] IN ('tdFilter', 'lnkShowFilter')")

        End If

        Refresh()

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click

        'insert settings to table
        Save()

        'reload page
        Refresh()

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()

        'reload page
        Refresh()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

        AddControl(pnlBody, c, "Research-Reports-Financial-Commission-Batch Payments Summary")

    End Sub
#End Region
#Region "Util"
    Private Sub SetAttributes()

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Private Sub Refresh()
        'Dim redir As String = "http://" + Request.ServerVariables("SERVER_NAME") + Request.ServerVariables("URL") + "?company=" + ddlCompany.SelectedItem.Value
        Dim redir As String = Request.ServerVariables("URL") + "?company=" + ddlCompany.SelectedItem.Value


        Response.Redirect(redir)
    End Sub
    Protected Function GetArrowImg(ByVal b As BatchPaymentsSummary_Recipient) As String
        Dim result As String = ""

        Dim parent As BatchPaymentsSummary_Recipient = b.Parent
        While Not parent Is Nothing
            If parent.Parent IsNot Nothing Then
                If Not parent.IsLast Then
                    result = "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/arrow_vertical.png") & """ border=""0""/>" & result
                Else
                    result = "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/blank.png") & """ border=""0""/>" & result
                End If
            End If
            parent = parent.Parent

        End While


        If b.ParentCommRecId.HasValue And b.Parent IsNot Nothing Then
            result += "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/arrow_" & IIf(b.IsLast, "end", "connector")) & ".png"" border=""0""/>"
        End If

        Return result
    End Function

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex
        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtTransDate1.Text = parts(0)
            txtTransDate2.Text = parts(1)
        End If


    End Sub
    Private Sub LoadCommRecips()

        csCommRecID.Items.Clear()
        csCommRecID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT CommRecId, Abbreviation + ' (' + Display + ')' as Name FROM tblCommRec ORDER BY Abbreviation"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim CommRecID As Integer = DatabaseHelper.Peel_int(rd, "CommRecId")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        csCommRecID.AddItem(New ListItem(Name, CommRecID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csCommRecID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csCommRecID.ID + "'")
        End If
    End Sub

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(optCommRecChoice.ID, optCommRecChoice)
        c.Add(chkBreakdownFeeTypes.ID, chkBreakdownFeeTypes)
        c.Add(chkGroupByAgency.ID, chkGroupByAgency)
        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)
        c.Add(txtTransDate1.ID, txtTransDate1)
        c.Add(txtTransDate2.ID, txtTransDate2)

        Return c

    End Function
#End Region
#Region "Query"
    Private Sub Requery()
        Dim Agencies As New Dictionary(Of Integer, sAgency)
        Dim EntryTypeNames As New Dictionary(Of Integer, String)
        Dim agency As sAgency
        Dim parentCommRec As sParentCommRec
        Dim commRec As sCommRec
        Dim entryType As sEntryType
        Dim majorParentID As Integer = 0
        Dim sb As New StringBuilder

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetCommissionBatchPaymentsSummary")
            Using cmd.Connection
                cmd.CommandTimeout = 180
                AddStdParams(cmd)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim AgencyID As Integer = DatabaseHelper.Peel_int(rd, "AgencyId")
                        Dim AgencyName As String = DatabaseHelper.Peel_string(rd, "Agency")
                        Dim EntryTypeName As String = DatabaseHelper.Peel_string(rd, "FeeType")
                        Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "EntryTypeId")
                        Dim AmountPaid As Single = DatabaseHelper.Peel_float(rd, "AmountPaid")
                        Dim CommRecName As String = DatabaseHelper.Peel_string(rd, "CommRec")
                        Dim CommRecID As Integer = DatabaseHelper.Peel_int(rd, "CommRecId")
                        Dim ParentCommRecID As Integer = DatabaseHelper.Peel_int(rd, "ParentCommRecId")
                        Dim Amount As Single = DatabaseHelper.Peel_float(rd, "Amount")
                        Dim TransferAmount As Single = DatabaseHelper.Peel_float(rd, "TransferAmount")

                        If Not Agencies.ContainsKey(AgencyID) Then
                            agency = New sAgency
                            agency.AgencyName = AgencyName
                            agency.ParentCommRec = New Dictionary(Of Integer, sParentCommRec)
                            Agencies.Add(AgencyID, agency)
                        End If

                        If Not Agencies(AgencyID).ParentCommRec.ContainsKey(ParentCommRecID) Then
                            parentCommRec = New sParentCommRec
                            parentCommRec.CommRec = New Dictionary(Of Integer, sCommRec)
                            Agencies(AgencyID).ParentCommRec.Add(ParentCommRecID, parentCommRec)
                        End If

                        If Not Agencies(AgencyID).ParentCommRec(ParentCommRecID).CommRec.ContainsKey(CommRecID) Then
                            commRec = New sCommRec
                            commRec.CommRec = CommRecName
                            commRec.Level = 0
                            commRec.IsLast = False
                            commRec.EntryType = New Dictionary(Of Integer, sEntryType)
                            Agencies(AgencyID).ParentCommRec(ParentCommRecID).CommRec.Add(CommRecID, commRec)
                        End If

                        entryType = New sEntryType
                        entryType.Amount = Amount
                        entryType.AmountPaid = AmountPaid
                        entryType.TransferAmount = TransferAmount

                        If Not EntryTypeNames.ContainsKey(EntryTypeID) Then
                            EntryTypeNames.Add(EntryTypeID, EntryTypeName)
                        End If

                        Agencies(AgencyID).ParentCommRec(ParentCommRecID).CommRec(CommRecID).EntryType.Add(EntryTypeID, entryType)
                    End While
                End Using
            End Using
        End Using

        If Not chkGroupByAgency.Checked Then
            GroupAsOne(Agencies)
            OrderTree(Agencies)
        End If

        RenderGrid(sb, Agencies, EntryTypeNames)

        ltrGrid.Text += sb.ToString()
        Session("xls_BatchPaymentsSummary_list") = sb.ToString()

    End Sub
    Private Sub GroupAsOne(ByRef Agencies As Dictionary(Of Integer, sAgency))
        Dim finalAgencies As New Dictionary(Of Integer, sAgency)
        Dim newAgency As New sAgency
        Dim newParentCommRec As sParentCommRec
        Dim newCommRec As sCommRec
        Dim newEntryType As sEntryType

        newAgency.AgencyName = "All Agencies"
        newAgency.ParentCommRec = New Dictionary(Of Integer, sParentCommRec)
        finalAgencies.Add(0, newAgency)

        For Each agency As sAgency In Agencies.Values
            For Each parentcommrecid As Integer In agency.ParentCommRec.Keys
                If Not finalAgencies(0).ParentCommRec.TryGetValue(parentcommrecid, Nothing) Then
                    newParentCommRec = New sParentCommRec
                    newParentCommRec.CommRec = New Dictionary(Of Integer, sCommRec)
                    finalAgencies(0).ParentCommRec.Add(parentcommrecid, newParentCommRec)
                End If
                For Each commrecid As Integer In agency.ParentCommRec(parentcommrecid).CommRec.Keys
                    If Not finalAgencies(0).ParentCommRec(parentcommrecid).CommRec.TryGetValue(commrecid, Nothing) Then
                        newCommRec = New sCommRec
                        newCommRec.CommRec = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).CommRec
                        newCommRec.EntryType = New Dictionary(Of Integer, sEntryType)
                        newCommRec.Level = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level
                        newCommRec.IsLast = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).IsLast
                        finalAgencies(0).ParentCommRec(parentcommrecid).CommRec.Add(commrecid, newCommRec)
                    End If
                    For Each entrytypeid As Integer In agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Keys
                        If Not finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.TryGetValue(entrytypeid, Nothing) Then
                            newEntryType = New sEntryType
                            newEntryType.Amount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).Amount
                            newEntryType.TransferAmount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).TransferAmount
                            newEntryType.AmountPaid = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).AmountPaid
                            finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Add(entrytypeid, newEntryType)
                        Else
                            newEntryType = New sEntryType
                            newEntryType.Amount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).Amount
                            newEntryType.TransferAmount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).TransferAmount
                            newEntryType.AmountPaid = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).AmountPaid + finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).AmountPaid
                            finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Remove(entrytypeid)
                            finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Add(entrytypeid, newEntryType)
                        End If
                    Next
                Next
            Next
        Next

        Agencies.Clear()
        Agencies = finalAgencies
    End Sub
    Private Sub OrderTree(ByRef Agencies As Dictionary(Of Integer, sAgency))
        Dim newAgency As New sAgency
        Dim newAgencies As New Dictionary(Of Integer, sAgency)
        Dim newParent As New sParentCommRec

        newAgency.AgencyName = "All Agencies"
        newAgency.ParentCommRec = New Dictionary(Of Integer, sParentCommRec)
        newAgencies.Add(0, newAgency)

        newParent.CommRec = New Dictionary(Of Integer, sCommRec)
        newAgencies(0).ParentCommRec.Add(0, newParent)

        For Each agency As sAgency In Agencies.Values
            AddRecursive(agency, newAgencies, trust, 0)
        Next

        Agencies.Clear()
        Agencies = newAgencies
    End Sub
    Private Sub AddRecursive(ByVal agency As sAgency, ByRef newAgencies As Dictionary(Of Integer, sAgency), ByVal parentcommrecid As Integer, ByVal level As Integer)
        If agency.ParentCommRec.TryGetValue(parentcommrecid, Nothing) Then
            Dim newRec As New sCommRec
            Dim count As Integer = 0
            level += 1
            For Each commrecid As Integer In agency.ParentCommRec(parentcommrecid).CommRec.Keys
                count += 1
                newRec = agency.ParentCommRec(parentcommrecid).CommRec(commrecid)
                newRec.Level = level
                If count = agency.ParentCommRec(parentcommrecid).CommRec.Count Then
                    newRec.IsLast = True
                End If
                newAgencies(0).ParentCommRec(0).CommRec.Add(newAgencies(0).ParentCommRec(0).CommRec.Count, newRec)
                AddRecursive(agency, newAgencies, commrecid, level)
            Next
        End If
    End Sub
    Private Sub RenderGrid(ByRef sb As StringBuilder, ByVal Agencies As Dictionary(Of Integer, sAgency), ByVal entryTypeNames As Dictionary(Of Integer, String))
        Dim netPayments As Single
        Dim grossDeposits As Single
        Dim entryTypeAmounts As sEntryType
        Dim totalFees As Dictionary(Of Integer, Single)
        Dim totalNet As Single
        Dim tempTotal As Single
        Dim lastLevel As Integer
        Dim even As Boolean

        sb = New StringBuilder

        For Each agency As sAgency In Agencies.Values
            If Not agency.AgencyName Is Nothing And agency.AgencyName.Length > 0 Then
                totalFees = New Dictionary(Of Integer, Single)
                If chkGroupByAgency.Checked = True Then
                    sb.Append("<tr><td>&nbsp;</td></tr>")
                    sb.Append("<tr><td><b>Agency: <u>" + agency.AgencyName + "</u></b></td></tr>")
                End If

                sb.Append("<tr><td>")

                sb.Append("<table class=""fixedlist"" onselectstart=""return false;"" style=""font-size:11px;font-family:tahoma"" cellspacing=""0"" cellpadding=""3"" width=""100%"" border=""0"">")
                sb.Append("<thead>")
                sb.Append("<tr><th style=""width:150px"">&nbsp;</th>")

                If chkBreakDownFeeTypes.Checked = True Then
                    For Each feetype As String In entryTypeNames.Values
                        sb.Append("<th align=""right"" style=""width:80px""><b>" + feetype + "</b></th>")
                    Next
                End If

                sb.Append("<th align=""right""><b>Gross Deposits</b></th>")
                sb.Append("<th style=""width:70px"" align=""right""><b>Net Payments</b></th>")
                sb.Append("</tr>")
                sb.Append("</thead>")
                sb.Append("<tbody>")

                even = True
                totalNet = 0

                For Each parentcommrecid As Integer In agency.ParentCommRec.Keys
                    For Each commrecid As Integer In agency.ParentCommRec(parentcommrecid).CommRec.Keys
                        netPayments = 0
                        grossDeposits = 0
                        even = Not even
                        sb.Append("<tr " + IIf(even, "style=""background-color:#f1f1f1;""", "") + "><td>")
                        If agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level > 1 Then
                            lastLevel = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level
                            For i As Integer = 1 To agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level - 1
                                sb.Append("&nbsp;")
                            Next
                            If Not agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level > lastLevel And lastLevel > 2 Then
                                sb.Append("<img src=""" + ResolveUrl("~/images/arrow_vertical.png") + """ border=""0""/>")
                            End If
                            sb.Append("&nbsp;<img src=""" & ResolveUrl("~/images/arrow_" + IIf(agency.ParentCommRec(parentcommrecid).CommRec(commrecid).IsLast, "end", "connector")) + ".png"" border=""0""/>")
                        End If
                        sb.Append(agency.ParentCommRec(parentcommrecid).CommRec(commrecid).CommRec + "</td>")
                        For Each entrytypeid As Integer In entryTypeNames.Keys
                            If agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.TryGetValue(entrytypeid, entryTypeAmounts) Then
                                If chkBreakDownFeeTypes.Checked = True Then
                                    sb.Append("<td align=""right"">" + entryTypeAmounts.AmountPaid.ToString("c") + "</td>")
                                End If
                                netPayments += entryTypeAmounts.AmountPaid
                                If totalFees.TryGetValue(entrytypeid, Nothing) Then
                                    tempTotal = totalFees.Item(entrytypeid) + entryTypeAmounts.AmountPaid
                                    totalFees.Remove(entrytypeid)
                                    totalFees.Add(entrytypeid, tempTotal)
                                Else
                                    totalFees.Add(entrytypeid, entryTypeAmounts.AmountPaid)
                                End If
                                grossDeposits = entryTypeAmounts.TransferAmount
                            Else
                                If chkBreakDownFeeTypes.Checked = True Then
                                    sb.Append("<td align=""right"">$0.00</td>")
                                End If
                                If Not totalFees.TryGetValue(entrytypeid, Nothing) Then
                                    totalFees.Add(entrytypeid, 0.0)
                                End If
                            End If
                        Next

                        totalNet += netPayments
                        sb.Append("<td align=""right"">")
                        sb.Append(grossDeposits.ToString("c"))
                        sb.Append("</td><td align=""right"">")
                        sb.Append(netPayments.ToString("c"))
                        sb.Append("</td></tr>")
                    Next
                Next

                sb.Append("</tbody><tfoot>")
                sb.Append("<tr><td><b>Total</b></td>")

                If chkBreakDownFeeTypes.Checked = True Then
                    For Each totalfee As Single In totalFees.Values
                        sb.Append("<td align=""right""><b>" + totalfee.ToString("c") + "</b></td>")
                    Next
                End If

                sb.Append("<td align=""right"">&nbsp;</td>")
                sb.Append("<td align=""right""><b>" + totalNet.ToString("c") + "</b></td>")

                sb.Append("</tfoot>")
                sb.Append("</table></td></tr>")
            End If
        Next
    End Sub
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        If txtTransDate1.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtTransDate1.Text))
        If txtTransDate2.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtTransDate2.Text))

        Dim l As List(Of String) = csCommRecID.SelectedList
        If l.Count <= 0 Then l = csCommRecID.EntireList
        DatabaseHelper.AddParameter(cmd, "CommRecIDs", String.Join(",", l.ToArray()))
        DatabaseHelper.AddParameter(cmd, "CompanyID", ddlCompany.SelectedItem.Value)
    End Sub

#End Region
End Class