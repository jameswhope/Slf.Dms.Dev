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

Partial Class research_reports_clients_mediation_myassignments_bycreditor
    Inherits PermissionPage


#Region "Variables"
    Private Const PageSize As Integer = 30
    Private pager As PagerWrapper
    Private UserID As Integer
    Private ThresholdPercent As Single

    Private SortField As String
    Private SortOrder As String

    Private Headers As Dictionary(Of String, HtmlTableCell)
    Private Property Setting(ByVal s As String) As String
        Get
            Return Session(Me.UniqueID & "_" & s)
        End Get
        Set(ByVal value As String)
            Session(Me.UniqueID & "_" & s) = value
        End Set
    End Property
    Private Function GetSetting(ByVal s As String, ByVal d As String) As String
        Dim v As String = Setting(s)
        If String.IsNullOrEmpty(v) Then
            Return d
        Else
            Return v
        End If
    End Function
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        pager = New PagerWrapper(lnkFirst, lnkPrev, lnkNext, lnkLast, imgFirst, imgPrev, imgNext, imgLast, txtPageNumber, lblPageCount, Context, "p")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Not IsPostBack Then
            LoadValues(GetControls(), Me)
        End If
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadHeaders()
        SortField = GetSetting("SortField", "tdCreditorName")
        SortOrder = GetSetting("SortOrder", "ASC")

        Requery()

        SetSortImage()
    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click

        'insert settings to table
        Save()

        Refresh()

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        'If txtThresholdPercent1.Value.Length > 0 Then
        '    QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtThresholdPercent1.ID, "value", _
        '        txtThresholdPercent1.Value)
        'Else
        '    QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtThresholdPercent1.ID, "value", "10")
        'End If

        'If txtThresholdPercent2.Value.Length > 0 Then
        '    QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtThresholdPercent2.ID, "value", _
        '        txtThresholdPercent2.Value)
        'End If

    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

    End Sub
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
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub
#End Region
#Region "Sorting"
    Protected Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadHeaders()

        If txtSortField.Text = Setting("SortField") Then
            'toggle sort order
            If Setting("SortOrder") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortField.Text
            SortOrder = "ASC"
        End If
        SortField = txtSortField.Text

        Setting("SortField") = SortField
        Setting("SortOrder") = SortOrder

    End Sub
    Public Sub SetSortImage()
        Headers(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub
    Private Function GetSortImage(ByVal SortOrder As String) As HtmlImage
        Dim img As HtmlImage = New HtmlImage()
        img.Src = ResolveUrl("~/images/sort-" & SortOrder & ".png")
        img.Align = "absmiddle"
        img.Border = 0
        img.Style("margin-left") = "5px"
        Return img
    End Function
    Private Sub LoadHeaders()
        Headers = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(Headers, tdAccountNumber)
        AddHeader(Headers, tdCreditorAccountNumber)
        AddHeader(Headers, tdCreditorBalance)
        AddHeader(Headers, tdCreditorMinAvailable)
        AddHeader(Headers, tdCreditorName)
        AddHeader(Headers, tdCreditorPhone)
        AddHeader(Headers, tdLastName)
        AddHeader(Headers, tdSDABalance)
        AddHeader(Headers, tdSSN)
    End Sub
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub
    Private Function GetFullyQualifiedName(ByVal s As String) As String
        Select Case s
            Case "tdAccountNumber"
                Return "c.AccountNumber"
            Case "tdCreditorAccountNumber"
                Return "ci.AccountNumber"
            Case "tdCreditorBalance"
                Return "c.AccountBalance"
            Case "tdCreditorMinAvailable"
                Return "c.AccountBalance"
            Case "tdCreditorName"
                Return "cr.Name"
            Case "tdCreditorPhone"
                Return "creditorphone"  'to be changed
            Case "tdLastName"
                Return "c.LastName1"
            Case "tdSDABalance"
                Return "c.sdaBalance"
            Case "tdSSN"
                Return "c.SSN1"
        End Select
        Return "Unknown"
    End Function
#End Region
#Region "Util"
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        'c.Add(txtThresholdPercent1.ID, txtThresholdPercent1)
        'c.Add(txtThresholdPercent2.ID, txtThresholdPercent2)

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
        AddControl(pnlBody, c, "Research-Reports-Clients-Mediation-My Assignments")
    End Sub
    Private Function GetCell(ByVal s As String) As String
        Return IIf(String.IsNullOrEmpty(s), "&nbsp;", s)
    End Function
#End Region
#Region "Query"
    Protected Structure Creditor
        Dim CreditorID As Integer
        Dim Name As String
        Dim Phone As String
        Dim Accounts As List(Of CreditorAccount)
    End Structure
    Protected Structure CreditorAccount
        Dim PersonID As Integer
        Dim FirstName As String
        Dim LastName As String
        Dim SSN As String
        Dim SDABalance As Single
        Dim ClientID As Integer
        Dim AccountNumber As String

        Dim CreditorInstanceID As Integer
        Dim AccountId As Integer
        Dim ReferenceNumber As String
        Dim CreditorAccountNumber As String
        Dim Balance As Single
        Dim MinAvailable As Single
    End Structure
    Private Function ParseBool(ByVal s As String) As Boolean
        If s = "0" Then
            Return False
        ElseIf s = "1" Then
            Return True
        Else
            Return Boolean.Parse(s)
        End If
    End Function

    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        'If Not String.IsNullOrEmpty(txtThresholdPercent1.Value) Then
        '    DatabaseHelper.AddParameter(cmd, "Percent1", Single.Parse(txtThresholdPercent1.Value) / 100)
        'End If
        'If Not String.IsNullOrEmpty(txtThresholdPercent2.Value) Then
        '    DatabaseHelper.AddParameter(cmd, "Percent2", Single.Parse(txtThresholdPercent2.Value) / 100)
        'End If
        DatabaseHelper.AddParameter(cmd, "accountstatusids", "55,56")
        DatabaseHelper.AddParameter(cmd, "accountstatusidsop", "not")
        DatabaseHelper.AddParameter(cmd, "orderby", GetFullyQualifiedName(SortField) & " " & SortOrder)
        DatabaseHelper.AddParameter(cmd, "mediator", UserID)
    End Sub

    Private Sub Requery()
        Dim Results As New Dictionary(Of Integer, Creditor)

        ThresholdPercent = 0.1

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Report_AccountsOverPercentage")
            AddStdParams(cmd)
            cmd.CommandTimeout = 180
            Session("rptcmd_report_clients_AccountsOverPercentage_ByCreditor") = cmd

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read()
                        Dim CreditorID As Integer = DatabaseHelper.Peel_int(rd, "CreditorID")

                        Dim c As Creditor = Nothing
                        If Not Results.TryGetValue(CreditorID, c) Then
                            c = New Creditor
                            c.CreditorID = CreditorID
                            c.Name = DatabaseHelper.Peel_string(rd, "CreditorName")
                            c.Phone = LocalHelper.FormatPhone(DatabaseHelper.Peel_string(rd, "CreditorPhone"))

                            c.Accounts = New List(Of CreditorAccount)

                            Results.Add(c.CreditorID, c)
                        End If

                        Dim ca As New CreditorAccount

                        ca.AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")
                        ca.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                        ca.PersonID = DatabaseHelper.Peel_int(rd, "PersonID1")
                        ca.FirstName = DatabaseHelper.Peel_string(rd, "FirstName1")
                        ca.LastName = DatabaseHelper.Peel_string(rd, "LastName1")
                        ca.SSN = LocalHelper.FormatSSN(DatabaseHelper.Peel_string(rd, "SSN1"))
                        ca.SDABalance = DatabaseHelper.Peel_float(rd, "SDABalance")

                        ca.AccountId = DatabaseHelper.Peel_int(rd, "AccountId")
                        ca.CreditorInstanceID = DatabaseHelper.Peel_int(rd, "CreditorInstanceID")
                        ca.CreditorAccountNumber = DatabaseHelper.Peel_string(rd, "CreditorAccountNumber")
                        ca.ReferenceNumber = DatabaseHelper.Peel_string(rd, "CreditorReferenceNumber")
                        ca.Balance = DatabaseHelper.Peel_float(rd, "AccountBalance")
                        ca.MinAvailable = ca.Balance * ThresholdPercent

                        c.Accounts.Add(ca)
                    End While
                End Using
            End Using
        End Using

        Dim hr As PagerHelper.HandleResult = PagerHelper.Handle(ConvertToList(Of Creditor)(Results), rpResults, pager, PageSize)

        lblResults.Text = "Results: " & Results.Count
        Session("xls_" & Me.GetType.Name) = GetXlsHtml(Results)
    End Sub
    Private Function GetXlsHtml(ByVal Results As Dictionary(Of Integer, Creditor)) As String
        Dim sb As New StringBuilder
        sb.Append("<table border=""1""><tr><td><img src=""" & ResolveUrl("~/images/16x16_icon.png") & """ border=""0"" align=""absmiddle""/></td><td>Creditor</td><td>Phone</td><td><img src=""" & ResolveUrl("~/images/16x16_icon.png") & """ border=""0"" align=""absmiddle""/></td><td>Acct No.</td><td>Full Name</td><td>SSN</td><td>SDA Bal</td><td>Account No.</td><td>Balance</td><td>Min Ava.</td></tr>")

        For Each c As Creditor In Results.Values
            For i As Integer = 0 To c.Accounts.Count - 1
                sb.Append("<tr>")

                If i = 0 Then
                    sb.Append(AddCell("<img src=""" & ResolveUrl("~/images/16x16_accounts.png") & """/>", c.Accounts.Count, ""))
                    sb.Append(AddCell(c.Name, c.Accounts.Count, ""))
                    sb.Append(AddCell(c.Phone, c.Accounts.Count, ""))
                End If

                Dim a As CreditorAccount = c.Accounts(i)

                sb.Append(AddCell("<img src=""" & ResolveUrl("~/images/16x16_person.png") & """/>", 0, ""))
                sb.Append(AddCell(a.AccountNumber, 0, ""))
                sb.Append(AddCell(a.FirstName + " " + a.LastName, 0, ""))
                sb.Append(AddCell(a.SSN, 0, ""))
                sb.Append(AddCell(a.SDABalance.ToString("c"), 0, ""))


                sb.Append(AddCell(a.CreditorAccountNumber, 0, ""))
                sb.Append(AddCell(a.Balance.ToString("c"), 0, ""))
                sb.Append(AddCell(a.MinAvailable.ToString("c"), 0, ""))

                sb.Append("</tr>")
            Next
        Next
        Return sb.ToString
    End Function
    Protected Function AddCell(ByVal s As String, ByVal Rowspan As Integer, ByVal attr As String) As String
        Dim result As String = ""
        result += "<td " + result & IIf(Rowspan > 1, "valign=""top"" rowspan=""" & Rowspan & """", "") + " " + attr + ">"
        result += GetCell(s)
        result += "</td>"
        Return result
    End Function
    Protected Function GetClientInfo(ByVal c As Creditor) As String
        Dim sb As New StringBuilder

        For i As Integer = 0 To c.Accounts.Count - 1
            sb.Append("<tr>")

            If i = 0 Then
                sb.Append("<a type=""Creditor"" href=""" & ResolveUrl("~/admin/settings/references/single.aspx?id=14&rid=" & c.CreditorID) & """>")
                sb.Append(AddCell("<img src=""" & ResolveUrl("~/images/16x16_accounts.png") & """/>", c.Accounts.Count, ""))
                sb.Append(AddCell(c.Name, c.Accounts.Count, ""))
                sb.Append(AddCell(c.Phone, c.Accounts.Count, ""))
                sb.Append("</a>")
            End If

            Dim a As CreditorAccount = c.Accounts(i)

            sb.Append("<a type=""Client"" href=""" & ResolveUrl("~/clients/client/") & "?id=" & a.ClientID & """>")
            sb.Append(AddCell("<img src=""" & ResolveUrl("~/images/16x16_person.png") & """/>", 0, ""))
            sb.Append(AddCell(a.AccountNumber, 0, ""))
            sb.Append(AddCell(a.FirstName + " " + a.LastName, 0, ""))
            sb.Append(AddCell(a.SSN, 0, ""))
            sb.Append(AddCell(a.SDABalance.ToString("c"), 0, ""))
            sb.Append("</a>")

            sb.Append("<a type=""Account"" href=""" & ResolveUrl("~/clients/client/creditors/accounts/account.aspx") & "?id=" & a.ClientID & "&aid=" & a.AccountId & """>")
            sb.Append(AddCell(a.CreditorAccountNumber, 0, ""))
            sb.Append(AddCell(a.Balance.ToString("c"), 0, ""))
            sb.Append(AddCell(a.MinAvailable.ToString("c"), 0, ""))
            sb.Append("</a>")

            sb.Append("</tr>")
        Next

        Return sb.ToString
    End Function

#End Region

End Class