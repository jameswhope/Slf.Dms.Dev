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

Partial Class research_reports_financial_servicefees_my
    Inherits PermissionPage


#Region "Variables"

    Private CommRecId As Integer
    Private CommRecTypeId As Integer
    Private AllCommScenIds As String

    Private UserID As Integer
    Private qs As QueryStringCollection

    Private day As DateTime
    Private SortFieldA As String
    Private SortOrderA As String
    Private SortFieldB As String
    Private SortOrderB As String

    Private HeadersA As Dictionary(Of String, HtmlTableCell)
    Private HeadersB As Dictionary(Of String, HtmlTableCell)
#End Region
#Region "Util"
    ReadOnly Property AgencyNavigator() As Navigator
        Get

            If Session("AgencyNavigator") Is Nothing Then
                Session("AgencyNavigator") = New Navigator
            End If

            Return Session("AgencyNavigator")

        End Get
    End Property
    Private Function GetQueryString(ByVal key As String, ByVal [default] As String) As String
        Dim result As String = DataHelper.Nz_string(Request.QueryString(key))
        If String.IsNullOrEmpty(result) Then
            result = [default]
        End If
        Return result
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
    
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Reports-Financial-Service Fees-My Service Fees")
    End Sub
    
#End Region
#Region "Sorting"

    Protected Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadHeaders()

        If txtSortFieldA.Text = Setting("SortFieldA") Then
            'toggle sort order
            If Setting("SortOrderA") = "ASC" Then
                SortOrderA = "DESC"
            Else
                SortOrderA = "ASC"
            End If
        Else
            SortFieldA = txtSortFieldA.Text
            SortOrderA = "ASC"
        End If

        If txtSortFieldB.Text = Setting("SortFieldB") Then
            'toggle sort order
            If Setting("SortOrderB") = "ASC" Then
                SortOrderB = "DESC"
            Else
                SortOrderB = "ASC"
            End If
        Else
            SortFieldB = txtSortFieldB.Text
            SortOrderB = "ASC"
        End If
        SortFieldA = txtSortFieldA.Text
        SortFieldB = txtSortFieldB.Text

        Setting("SortFieldA") = SortFieldA
        Setting("SortOrderA") = SortOrderA
        Setting("SortFieldB") = SortFieldB
        Setting("SortOrderB") = SortOrderB

    End Sub

    Public Sub SetSortImage()
        HeadersA(SortFieldA).Controls.Add(GetSortImage(SortOrderA))
        HeadersB(SortFieldB).Controls.Add(GetSortImage(SortOrderB))
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
        HeadersA = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersA, tdAccountNumber)
        AddHeader(HeadersA, tdHireDate)
        AddHeader(HeadersA, tdFirstName)
        AddHeader(HeadersA, tdLastName)
        AddHeader(HeadersA, tdFeeCategory)
        AddHeader(HeadersA, tdSettlementNumber)
        AddHeader(HeadersA, tdOriginalBalance)
        AddHeader(HeadersA, tdBeginningBalance)
        AddHeader(HeadersA, tdPaymentAmount)
        AddHeader(HeadersA, tdEndingBalance)
        AddHeader(HeadersA, tdRate)
        AddHeader(HeadersA, tdAmount)

        HeadersB = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersB, tdAccountNumber2)
        AddHeader(HeadersB, tdHireDate2)
        AddHeader(HeadersB, tdFirstName2)
        AddHeader(HeadersB, tdLastName2)
        AddHeader(HeadersB, tdFeeCategory2)
        AddHeader(HeadersB, tdAmount2)
    End Sub
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub
    Private Function GetFullyQualifiedName(ByVal s As String) As String
        Select Case s
            Case "tdAccountNumber"
                Return "tblClient.AccountNumber"
            Case "tdHireDate"
                Return "HireDate"
            Case "tdFirstName"
                Return "tblPrimaryPerson.FirstName"
            Case "tdLastName"
                Return "tblPrimaryPerson.LastName"
            Case "tdFeeCategory"
                Return "tblEntryType.[Name]"
            Case "tdSettlementNumber"
                Return "tblPrimaryPerson.LastName"  'to be changed
            Case "tdOriginalBalance"
                Return "OriginalBalance"
            Case "tdBeginningBalance"
                Return "BeginningBalance"
            Case "tdPaymentAmount"
                Return "tblRegisterPayment.Amount"
            Case "tdEndingBalance"
                Return "EndingBalance"
            Case "tdRate"
                Return "tblCommPay.[Percent]"
            Case "tdAmount"
                Return "tblCommPay.Amount"

                'for second grid
            Case "tdAccountNumber2"
                Return "tblClient.AccountNumber"
            Case "tdHireDate2"
                Return "HireDate"
            Case "tdFirstName2"
                Return "tblPrimaryPerson.FirstName"
            Case "tdLastName2"
                Return "tblPrimaryPerson.LastName"
            Case "tdFeeCategory2"
                Return "tblEntryType.[Name]"
            Case "tdAmount2"
                Return "tblCommPay.Amount"
        End Select
        Return "Unknown"
    End Function

#End Region
#Region "Dates"
    Private Function GetPeriod() As String
        Return day.ToString("MMMM dd yyyy")
    End Function
    Private Function GetFirstDateAvailable() As DateTime
        Dim defaultDate As New DateTime(2006, 6, 5)
        Dim firstDate As DateTime
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT TOP 1 tblRegister.TransactionDate FROM tblRegister INNER JOIN tblClient ON tblRegister.Clientid=tblClient.ClientId INNER JOIN tblCommScen on tblClient.AgencyId=tblCommScen.AgencyId WHERE tblCommScen.CommScenId IN (" & AllCommScenIds & ") ORDER BY tblRegister.TransactionDate ASC"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    If rd.Read() Then
                        If rd.IsDBNull(0) Then
                            firstDate = defaultDate
                        Else
                            firstDate = rd.GetDateTime(0)
                        End If
                    Else
                        firstDate = defaultDate
                    End If
                End Using
            End Using
        End Using
        If firstDate < defaultDate Then
            Return defaultDate
        Else
            Return firstDate
        End If
    End Function
    Private Function GetLastDateAvailable() As DateTime
        Return Now
    End Function
    Private Sub GetDay()
        day = New DateTime(ddlYear.SelectedValue, ddlMonth.SelectedValue, ddlDay.SelectedValue)
    End Sub
    Private Sub SetAttributes()
        ddlYear.Attributes("onchange") = "Year_Change();"
        ddlMonth.Attributes("onchange") = "Month_Change();"
    End Sub
    Private Function GetMonthName(ByVal i As Integer) As String
        Select Case i
            Case 1
                Return "January"
            Case 2
                Return "February"
            Case 3
                Return "March"
            Case 4
                Return "April"
            Case 5
                Return "May"
            Case 6
                Return "June"
            Case 7
                Return "July"
            Case 8
                Return "August"
            Case 9
                Return "September"
            Case 10
                Return "October"
            Case 11
                Return "November"
            Case Else
                Return "December"
        End Select
    End Function
    Private Sub PopulateDates()
        ddlMonth.Items.Clear()
        ddlYear.Items.Clear()
        ddlDay.Items.Clear()

        Dim d1 As DateTime = GetFirstDateAvailable()
        Dim d2 As DateTime = GetLastDateAvailable()

        'Populate the years
        For i As Integer = d1.Year To d2.Year
            ddlYear.Items.Add(i)
        Next
        If ddlYear.Items.Count = 0 Then ddlYear.Items.Add(Now.Year)

        'Populate the months
        For i As Integer = 1 To 12
            ddlMonth.Items.Add(New ListItem(GetMonthName(i), i))
        Next

        'Populate the days
        For i As Integer = 1 To 31
            ddlDay.Items.Add(i)
        Next

    End Sub
#End Region
#Region "Events"
    Private Function GetSetting(ByVal s As String, ByVal d As String) As String
        Dim v As String = Setting(s)
        If String.IsNullOrEmpty(v) Then
            Return d
        Else
            Return v
        End If
    End Function
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        qs = LoadQueryString()
        AgencyNavigator.Store("Service Fees - Agency", Request.Url.AbsoluteUri, "Service Fees - Agency")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then
            Setting("commrecid") = Nothing
            LoadCommRecs()
        End If
        If Not String.IsNullOrEmpty(Setting("commrecid")) Then
            Integer.TryParse(Setting("commrecid"), CommRecId)
        Else
            Integer.TryParse(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId=" & UserID), CommRecId)
        End If
        Integer.TryParse(DataHelper.FieldLookup("tblCommRec", "CommRecTypeId", "CommRecId=" & CommRecId), CommRecTypeId)

        LoadAgencies()

        LoadHeaders()


        SortFieldA = GetSetting("SortFieldA", "tdLastName")
        SortOrderA = GetSetting("SortOrderA", "ASC")
        SortFieldB = GetSetting("SortFieldB", "tdLastName2")
        SortOrderB = GetSetting("SortOrderB", "ASC")

        If Not IsPostBack Then
            PopulateDates()

            If Not String.IsNullOrEmpty(Setting("y")) Then
                ListHelper.SetSelected(ddlDay, Integer.Parse(Setting("d")))
                ListHelper.SetSelected(ddlMonth, Integer.Parse(Setting("m")))
                ListHelper.SetSelected(ddlYear, Integer.Parse(Setting("y")))
            Else
                ListHelper.SetSelected(ddlDay, Now.Day)
                ListHelper.SetSelected(ddlMonth, Now.Month)
                ListHelper.SetSelected(ddlYear, Now.Year)
            End If


            SetAttributes()
        End If
        GetDay()
        SetSortImage()



    End Sub
    Private Property Setting(ByVal s As String) As String
        Get
            Return Session(Me.UniqueID & "_" & s)
        End Get
        Set(ByVal value As String)
            Session(Me.UniqueID & "_" & s) = value
        End Set
    End Property
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        GetDay()

        'Setting("SortFieldA") = SortFieldA
        'Setting("SortOrderA") = SortOrderA
        'Setting("SortFieldB") = SortFieldB
        'Setting("SortOrderB") = SortOrderB
        Setting("d") = day.Day
        Setting("m") = day.Month
        Setting("y") = day.Year
        Setting("commrecid") = ddlCommRecId.SelectedValue


    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/research/reports/financial/servicefees/myxls.ashx"))
    End Sub
#End Region
#Region "Query"
    Private Sub Requery()
        GetDay()
        RequeryPayments()

        If (RequiresCharges()) Then
            RequeryCharges()
            RequeryTotals()
        Else
            Session.Remove("rptcmd_report_servicefee_agency_charges")
            Session.Remove("xls_servicefeemycharges_list")
            Session.Remove("xls_servicefeemytotals_list")
            pnlCharges.Visible = False
            pnlTotals.Visible = False
        End If

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeeTotals")
            AddStdParams(cmd)
            Session("rptcmd_report_servicefee_agency") = cmd
        End Using

    End Sub
    Private Sub RequeryPayments()
        Dim payments As New List(Of Payment)
        Dim SumAmount As Double
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeePayments")
            Using cmd.Connection
                Dim CompanyIDs As String = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

                cmd.CommandTimeout = 180
                AddStdParams(cmd)

                If Len(CompanyIDs) > 0 Then
                    DatabaseHelper.AddParameter(cmd, "where", " and tblClient.CompanyID in (" & CompanyIDs & ")")
                End If
                DatabaseHelper.AddParameter(cmd, "orderby", GetFullyQualifiedName(SortFieldA) & " " & SortOrderA)

                Session("rptcmd_report_servicefee_agency_payments") = cmd

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim p As New Payment
                        p.RegisterPaymentId = DatabaseHelper.Peel_int(rd, "RegisterPaymentId")
                        p.ClientId = DatabaseHelper.Peel_int(rd, "ClientId")
                        p.CommPayId = DatabaseHelper.Peel_int(rd, "CommPayId")
                        p.AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")
                        p.HireDate = DatabaseHelper.Peel_date(rd, "HireDate")
                        p.FirstName = DatabaseHelper.Peel_string(rd, "FirstName")
                        p.LastName = DatabaseHelper.Peel_string(rd, "LastName")
                        p.FeeCategory = DatabaseHelper.Peel_string(rd, "FeeCategory")
                        p.SettlementNumber = DatabaseHelper.Peel_string(rd, "SettlementNumber")
                        p.PaymentDate = DatabaseHelper.Peel_date(rd, "PaymentDate")
                        p.OriginalBalance = DatabaseHelper.Peel_float(rd, "OriginalBalance")
                        p.BeginningBalance = DatabaseHelper.Peel_float(rd, "BeginningBalance")
                        p.PaymentAmount = DatabaseHelper.Peel_float(rd, "PaymentAmount")
                        p.EndingBalance = p.BeginningBalance - p.PaymentAmount
                        p.Rate = DatabaseHelper.Peel_float(rd, "Rate")
                        p.Amount = DatabaseHelper.Peel_float(rd, "Amount")
                        SumAmount += p.Amount
                        payments.Add(p)
                    End While
                End Using
            End Using

            Session("xls_servicefeemy_list") = payments

            tdPaymentsTotal.InnerHtml = "Total: " & payments.Count
            tdPaymentsAmountSum.InnerHtml = SumAmount.ToString("c")
        End Using

        rpPayments.DataSource = payments
        rpPayments.DataBind()
    End Sub

    Private Sub RequeryCharges()
        Dim payments As New List(Of Payment)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeeNewCharges")
            Using cmd.Connection
                cmd.CommandTimeout = 180
                AddStdParams(cmd)
                DatabaseHelper.AddParameter(cmd, "orderby", GetFullyQualifiedName(SortFieldB) & " " & SortOrderB)
                Session("rptcmd_report_servicefee_agency_charges") = cmd
                cmd.Connection.Open()
                Dim SumAmount As Double
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim p As New Payment
                        p.RegisterId = DatabaseHelper.Peel_int(rd, "RegisterId")
                        p.ClientId = DatabaseHelper.Peel_int(rd, "ClientId")
                        p.AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")
                        p.HireDate = DatabaseHelper.Peel_date(rd, "HireDate")
                        p.FirstName = DatabaseHelper.Peel_string(rd, "FirstName")
                        p.LastName = DatabaseHelper.Peel_string(rd, "LastName")
                        p.FeeCategory = DatabaseHelper.Peel_string(rd, "FeeCategory")
                        p.Amount = DatabaseHelper.Peel_float(rd, "Amount")
                        SumAmount += p.Amount
                        payments.Add(p)
                    End While
                End Using

                tdChargesTotal.InnerHtml = "Total: " & payments.Count
                tdChargesAmountSum.InnerHtml = SumAmount.ToString("c")

                Session("xls_servicefeemycharges_list") = payments

                rpCharges.DataSource = payments
                rpCharges.DataBind()
            End Using
        End Using
    End Sub
    Private Sub RequeryTotals()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetServiceFeeTotals")
            Using cmd.Connection
                cmd.CommandTimeout = 180
                AddStdParams(cmd)
                Session("rptcmd_report_servicefee_agency") = cmd

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    If rd.Read() Then
                        Dim PreviousBalance As Single = DatabaseHelper.Peel_float(rd, "PreviousBalance")
                        Dim NewChargesTotal As Single = DatabaseHelper.Peel_float(rd, "NewChargesTotal")
                        Dim FeePaymentsTotal As Single = DatabaseHelper.Peel_float(rd, "FeePaymentsTotal")
                        tdTotalPreviousBalance.InnerHtml = PreviousBalance.ToString("c")
                        tdTotalNewCharges.InnerHtml = NewChargesTotal.ToString("c")
                        tdTotalPayments.InnerHtml = FeePaymentsTotal.ToString("c")
                        tdTotalEndingBalance.InnerHtml = (PreviousBalance + NewChargesTotal - FeePaymentsTotal).ToString("c")

                        Dim l As New List(Of Single)
                        l.Add(PreviousBalance)
                        l.Add(NewChargesTotal)
                        l.Add(FeePaymentsTotal)
                        l.Add(PreviousBalance + NewChargesTotal - FeePaymentsTotal)
                        Session("xls_servicefeemytotals_list") = l
                    End If
                End Using
            End Using
        End Using
    End Sub
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        DatabaseHelper.AddParameter(cmd, "Date1", day)
        DatabaseHelper.AddParameter(cmd, "Date2", day)
        DatabaseHelper.AddParameter(cmd, "Period", GetPeriod())
        DatabaseHelper.AddParameter(cmd, "CommRecId", CommRecId)
        DatabaseHelper.AddParameter(cmd, "CommScenIds", AllCommScenIds)
    End Sub
    Private Sub LoadAgencies()
        Dim lstAllCommScenIds As New List(Of String)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT tblAgency.Name, tblCommScen.CommScenId FROM tblCommStruct INNER JOIN tblCommScen ON tblCommStruct.CommScenId=tblCommScen.CommScenId INNER JOIN tblAgency ON tblCommScen.AgencyId=tblAgency.AgencyId WHERE tblCommStruct.CommRecId=@CommRecId"
                DatabaseHelper.AddParameter(cmd, "CommRecId", CommRecId)
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim iCommScenId As Integer = DatabaseHelper.Peel_int(rd, "CommScenId")
                        lstAllCommScenIds.Add(iCommScenId)
                    End While
                End Using
            End Using
        End Using

        AllCommScenIds = String.Join(",", lstAllCommScenIds.ToArray())

        If String.IsNullOrEmpty(AllCommScenIds) Then
            AllCommScenIds = "-1"
        End If
    End Sub
    Private Sub LoadCommRecs()
        ddlCommRecId.Items.Clear()
        Dim iCommRecId As Integer
        If Integer.TryParse(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId=" & UserID), iCommRecId) Then
            ddlCommRecId.Items.Add(New ListItem("-- Me --", iCommRecId))
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "select * from tblcommrec order by abbreviation"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim commrecid As Integer = DatabaseHelper.Peel_int(rd, "commrecid")
                        Dim name As String = DatabaseHelper.Peel_string(rd, "abbreviation")
                        If Not commrecid = iCommRecId Then
                            ddlCommRecId.Items.Add(New ListItem(name, commrecid))
                        End If
                    End While
                End Using
            End Using
        End Using
    End Sub
    Private Function RequiresCharges() As Boolean
        Dim result As Integer
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
            Using cmd.Connection
                cmd.CommandText = "SELECT Case When 1 IN (SELECT CommRecTypeId FROM tblCommRec WHERE CommRecId in (SELECT ParentCommRecId FROM tblCommStruct WHERE CommRecId=" & CommRecId & " AND CommScenId in (" & AllCommScenIds & "))) Then 1 Else 0 end HasAttorney"
                DatabaseHelper.AddParameter(cmd, "CommRecId", Integer.Parse(CommRecId))

                cmd.Connection.Open()
                result = cmd.ExecuteScalar()
            End Using
        End Using

        Return Not CommRecTypeId = 1 And result = 1
        Return True
    End Function

#End Region

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        ListHelper.SetSelected(ddlCommRecId, CommRecId)
        Requery()
    End Sub
End Class
