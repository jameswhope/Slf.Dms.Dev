Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_reports_clients_transactions_depositdaysago
    Inherits PermissionPage


#Region "Variables"
    Private Const PageSize As Integer = 30
    Private pager As PagerWrapper
    Private UserID As Integer
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        pager = New PagerWrapper(lnkFirst, lnkPrev, lnkNext, lnkLast, imgFirst, imgPrev, imgNext, imgLast, txtPageNumber, lblPageCount, Context, "p")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Not IsPostBack Then
            LoadValues(GetControls(), Me)
        End If
    End Sub
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        LoadStatuses()
        LoadAgencies()
        Requery()
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

        Refresh()

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()

        'replace check marks
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkAch.ID, "value", True)
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkCheck.ID, "value", True)

        'reload page
        Refresh()

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optClientStatusChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optClientStatusChoice.ID, "value", _
                optClientStatusChoice.SelectedValue)
        End If
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csClientStatusID.ID, "store", csClientStatusID.SelectedStr)

        If optAgencyChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optAgencyChoice.ID, "value", _
                optAgencyChoice.SelectedValue)
        End If
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csAgencyID.ID, "store", csAgencyID.SelectedStr)

        If txtDaysAgo1.Value.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtDaysAgo1.ID, "value", _
                txtDaysAgo1.Value)
        End If

        If txtDaysAgo2.Value.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtDaysAgo2.ID, "value", _
                txtDaysAgo2.Value)
        End If

        If txtStartDate.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtStartDate.ID, "value", _
                txtStartDate.Text)
        End If

        If txtHireDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtHireDate1.ID, "value", _
                txtHireDate1.Text)
        End If

        If txtHireDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtHireDate2.ID, "value", _
                txtHireDate2.Text)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkAch.ID, "value", _
            chkAch.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkCheck.ID, "value", _
            chkCheck.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkBounced.ID, "value", _
            chkBounced.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkVoided.ID, "value", _
            chkVoided.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkOnHold.ID, "value", _
            chkOnHold.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkTransAch.ID, "value", _
            chkTransAch.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkTransCheck.ID, "value", _
            chkTransCheck.Checked)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkNeverDeposited.ID, "value", _
            chkNeverDeposited.Checked)
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

#End Region
#Region "Util"
    Private Sub LoadAgencies()
        csAgencyID.Items.Clear()
        csAgencyID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblAgency order by code"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim AgencyId As Integer = DatabaseHelper.Peel_int(rd, "AgencyID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Code")
                        csAgencyID.AddItem(New ListItem(Name, AgencyId))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csAgencyID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csAgencyID.ID + "'")
        End If
    End Sub
    Private Sub LoadStatuses()
        csClientStatusID.Items.Clear()
        csClientStatusID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblClientStatus"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim ClientStatusId As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        csClientStatusID.AddItem(New ListItem(Name, ClientStatusId))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csClientStatusID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csClientStatusID.ID + "'")
        End If
    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(optClientStatusChoice.ID, optClientStatusChoice)
        c.Add(optAgencyChoice.ID, optAgencyChoice)

        c.Add(txtStartDate.ID, txtStartDate)
        c.Add(txtDaysAgo1.ID, txtDaysAgo1)
        c.Add(txtDaysAgo2.ID, txtDaysAgo2)

        c.Add(chkBounced.ID, chkBounced)
        c.Add(chkVoided.ID, chkVoided)
        c.Add(chkOnHold.ID, chkOnHold)
        c.Add(chkAch.ID, chkAch)
        c.Add(chkCheck.ID, chkCheck)
        c.Add(chkTransCheck.ID, chkTransCheck)
        c.Add(chkTransAch.ID, chkTransAch)
        c.Add(chkNeverDeposited.ID, chkNeverDeposited)

        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)
        c.Add(txtHireDate1.ID, txtHireDate1)
        c.Add(txtHireDate2.ID, txtHireDate2)

        Return c

    End Function
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
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Reports-Clients-Transactions-Deposit Days Ago")
    End Sub
#End Region
#Region "Query"
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        If Not String.IsNullOrEmpty(txtStartDate.Text) Then
            DatabaseHelper.AddParameter(cmd, "startdate", DateTime.Parse(txtStartDate.Text))
        End If
        Dim Criteria As String = GetCriteria()
        Dim TransCriteria As String = GetTransCriteria()
        Dim UnionCriteria As String = GetUnionCriteria()

        If Not String.IsNullOrEmpty(TransCriteria) Then
            DatabaseHelper.AddParameter(cmd, "includeonlytransactions", TransCriteria)
        End If
        If Not String.IsNullOrEmpty(Criteria) Then
            DatabaseHelper.AddParameter(cmd, "criteria", Criteria)
        End If
        If Not String.IsNullOrEmpty(UnionCriteria) Then
            DatabaseHelper.AddParameter(cmd, "unioncriteria", UnionCriteria)
        End If
        DatabaseHelper.AddParameter(cmd, "neverdeposited", chkNeverDeposited.Checked)
    End Sub
    Private Sub Requery()
        Dim Results As New List(Of Result)

        Dim DepositAmountTotal As Single
        Dim AmountTotal As Single
        Dim Total As Integer

        Dim sb As New StringBuilder

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Report_DaysAgo")
            AddStdParams(cmd)
            cmd.CommandTimeout = 180
            Session("rptcmd_report_clients_depositdaysago") = cmd
            Session("xls_DepositDaysAgo_cmd") = cmd
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader


                    While rd.Read()
                        Dim r As New Result

                        r.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                        r.AgencyName = DatabaseHelper.Peel_string(rd, "AgencyName")
                        r.ClientName = DatabaseHelper.Peel_string(rd, "ClientName")
                        r.AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")
                        r.ClientStatusName = DatabaseHelper.Peel_string(rd, "ClientStatusName")
                        r.DepositMethod = DatabaseHelper.Peel_string(rd, "DepositMethod")
                        If String.IsNullOrEmpty(r.DepositMethod) Then r.DepositMethod = "Check"
                        r.DepositDay = DatabaseHelper.Peel_int(rd, "DepositDay")
                        r.DepositAmount = DatabaseHelper.Peel_float(rd, "DepositAmount")

                        r.Street = DatabaseHelper.Peel_string(rd, "Street")
                        r.Street2 = DatabaseHelper.Peel_string(rd, "Street2")
                        r.City = DatabaseHelper.Peel_string(rd, "City")
                        r.State = DatabaseHelper.Peel_string(rd, "StateName")
                        r.Zip = DatabaseHelper.Peel_string(rd, "ZipCode")
                        r.HomePhone = DatabaseHelper.Peel_string(rd, "HomePhone")
                        r.WorkPhone = DatabaseHelper.Peel_string(rd, "WorkPhone")

                        r.NeverDeposited = rd.IsDBNull(rd.GetOrdinal("registerid"))
                        If Not r.NeverDeposited Then
                            r.RegisterID = DatabaseHelper.Peel_int(rd, "RegisterID")
                            r.Amount = DatabaseHelper.Peel_float(rd, "Amount")
                            r.Bounce = Not rd.IsDBNull(rd.GetOrdinal("Bounce"))
                            r.Void = Not rd.IsDBNull(rd.GetOrdinal("Void"))
                            r.ACH = Not rd.IsDBNull(rd.GetOrdinal("AchYear"))
                            r.DaysAgo = DatabaseHelper.Peel_float(rd, "DaysAgo")
                            r.TransactionDate = DatabaseHelper.Peel_date(rd, "TransactionDate")
                        End If

                        Results.Add(r)

                        Total += 1
                        DepositAmountTotal += r.DepositAmount
                        AmountTotal += r.Amount

                    End While
                End Using
            End Using
        End Using

        Dim hr As PagerHelper.HandleResult = PagerHelper.Handle(Results, rpResults, pager, PageSize)

        If hr.LastPage Then
            tdAmountTotal.InnerHtml = AmountTotal.ToString("c")
            tdDepositAmountTotal.InnerHtml = DepositAmountTotal.ToString("c")
        End If

        tdResults.InnerHtml = "Results: " & Total

    End Sub
    Protected Function GetTransactionInfo(ByVal r As Result) As String
        Dim sb As New StringBuilder
        If r.NeverDeposited Then
            sb.Append("<td colspan=""6"" class=""l"" align=""center""><i>Never Deposited</i></td>")
        Else

            sb.Append("<a href=""" & ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & r.ClientID & "&rid=" & r.RegisterID) & """ type=""Trans"">")

            sb.Append("<td align=""center"" class=""l"">")
            sb.Append(Math.Round(CType(r.DaysAgo, Single), 2) & "&nbsp;")
            sb.Append("</td>")

            sb.Append("<td align=""left"">")
            sb.Append(r.TransactionDate.ToString("MM/dd/yyyy") & "&nbsp;")
            sb.Append("</td>")

            sb.Append("<td align=""right"">")
            sb.Append(r.Amount.ToString("c") & "&nbsp;")
            sb.Append("</td>")

            sb.Append("<td align=""center"">")
            sb.Append(LocalHelper.GetBoolString(r.Bounce, Me) & "&nbsp;")
            sb.Append("</td>")

            sb.Append("<td align=""center"">")
            sb.Append(LocalHelper.GetBoolString(r.Void, Me) & "&nbsp;")
            sb.Append("</td>")

            sb.Append("<td align=""center"">")
            sb.Append(LocalHelper.GetBoolString(r.ACH, Me) & "&nbsp;")
            sb.Append("</td>")

            sb.Append("</a>")

        End If
        Return sb.ToString
    End Function
    
    Protected Structure Result
        Dim ClientID As Integer
        Dim RegisterID As Integer
        Dim AgencyName As String
        Dim ClientName As String
        Dim AccountNumber As String
        Dim ClientStatusName As String
        Dim DepositMethod As String
        Dim TransactionDate As DateTime
        Dim DepositDay As Integer
        Dim DepositAmount As Single
        Dim DaysAgo As Single
        Dim NeverDeposited As Boolean
        Dim Amount As Single
        Dim Bounce As Boolean
        Dim Void As Boolean
        Dim ACH As Boolean

        Dim Street As String
        Dim Street2 As String
        Dim City As String
        Dim State As String
        Dim Zip As String
        Dim HomePhone As String
        Dim WorkPhone As String
    End Structure
    Private Function GetCell(ByVal s As String) As String
        Return IIf(String.IsNullOrEmpty(s), "&nbsp;", s)
    End Function
    Private Function GetTransCriteria() As String
        Dim strWhere As String = String.Empty

        If chkBounced.Checked Then
            strWhere = AddCriteria(strWhere, "tblregister.Bounce is null")
        End If
        If chkVoided.Checked Then
            strWhere = AddCriteria(strWhere, "tblregister.Void is null")
        End If
        If chkOnHold.Checked Then
            strWhere = AddCriteria(strWhere, "tblregister.Hold is null or tblregister.Hold <= getdate() or tblregister.[Clear] <= getdate()")
        End If

        If chkTransAch.Checked Then
            strWhere = AddCriteria(strWhere, "tblregister.achyear is null")
        End If
        If chkTransCheck.Checked Then
            strWhere = AddCriteria(strWhere, "not tblregister.achyear is null")
        End If

        Return strWhere
    End Function
    Private Function GetCriteria() As String
        Dim strWhere As String = String.Empty

        If Not txtDaysAgo1.Value.Length = 0 Then
            strWhere = AddCriteria(strWhere, "t.DaysAgo > " & txtDaysAgo1.Value)
        End If
        If Not txtDaysAgo2.Value.Length = 0 Then
            strWhere = AddCriteria(strWhere, "t.DaysAgo < " & txtDaysAgo2.Value)
        End If

        If chkAch.Checked And Not chkCheck.Checked Then
            strWhere = AddCriteria(strWhere, "t.depositmethod = 'ACH'")
        ElseIf Not chkAch.Checked And chkCheck.Checked Then
            strWhere = AddCriteria(strWhere, "t.depositmethod is null or not t.depositmethod = 'ACH'")
        End If

        If csClientStatusID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csClientStatusID.GenerateCriteria("t.ClientStatusID"), optClientStatusChoice.SelectedValue = 0)
        End If

        If csAgencyID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csAgencyID.GenerateCriteria("t.AgencyID"), optAgencyChoice.SelectedValue = 0)
        End If

        If Not txtHireDate1.Text.Length = 0 Then
            strWhere = AddCriteria(strWhere, "t.HireDate > '" & txtHireDate1.Text & "'")
        End If
        If Not txtHireDate2.Text.Length = 0 Then
            strWhere = AddCriteria(strWhere, "t.HireDate < '" & txtHireDate2.Text & "'")
        End If
        Return strWhere
    End Function

    Private Function GetUnionCriteria() As String
        Dim strWhere As String = String.Empty
        If Not txtHireDate1.Text.Length = 0 Then
            strWhere = AddCriteria(strWhere, "c.created > '" & txtHireDate1.Text & "'")
        End If
        If Not txtHireDate2.Text.Length = 0 Then
            strWhere = AddCriteria(strWhere, "c.created < '" & txtHireDate2.Text & "'")
        End If

        If csClientStatusID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csClientStatusID.GenerateCriteria("c.CurrentClientStatusID"), optClientStatusChoice.SelectedValue = 0)
        End If

        If csAgencyID.SelectedList.Count > 0 Then
            strWhere = AddCriteria(strWhere, csAgencyID.GenerateCriteria("c.AgencyID"), optAgencyChoice.SelectedValue = 0)
        End If

        Return strWhere
    End Function

    Protected Sub lnkFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirst.Click
        pager.First()
    End Sub
    Protected Sub lnkLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLast.Click
        pager.Last()
    End Sub
    Protected Sub lnkNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNext.Click
        pager.Next()
    End Sub
    Protected Sub lnkPrev_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrev.Click
        pager.Previous()
    End Sub
    Protected Sub txtPageNumber_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtPageNumber.TextChanged
        pager.SetPage(DataHelper.Nz_int(txtPageNumber.Text))
    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/research/reports/clients/transactions/depositdaysagoxls.ashx"))
    End Sub
#End Region

End Class