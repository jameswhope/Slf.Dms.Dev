Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Public Structure Client_ServiceCapCalculator
    Public CliendId As Integer
    Public NumberAccounts As Integer
    Public TotalDebt As Double
    Public RegularDeposit As Double
    Public ServiceFeeCap As Double
    Public ServiceFeePerAcct As Double
    Public SettlementFeePercent As Double
    Public InitialDeposit As Double
    Public EstimatedGrowth As Double
    Public PBMAPR As Double
    Public PBMMinPay As Double
    Public PBMMinPayPct As Double
End Structure

Partial Class Clients_client_ServiceCapCalculator
    Inherits System.Web.UI.UserControl

    Private Const maxMonths As Integer = 400

    Private Enum ModelType
        Variable
        OnePayment
    End Enum

    Private _client As Client_ServiceCapCalculator


    Private lstPct() As String
    Private tblAccounts As DataTable

    Public Sub LoadData(ByVal Clientid As Integer, ByVal UseSmartDebtor As Boolean)
        hdnClientId.Value = Clientid
        hdnUseSD.Value = IIf(UseSmartDebtor, "1", "0")

        If UseSmartDebtor Then
            LoadClientDataFromLeadInfo(Clientid)
        Else
            LoadClientDataFromClientInfo(Clientid)
        End If
        SetProperties()
        PopulateFields()
        ReCalc()
    End Sub

    Private Sub LoadClientDataFromLeadInfo(ByVal ClientId As Integer)
        _client = New Client_ServiceCapCalculator
        _client.CliendId = ClientId
        Dim dt As DataTable = GetData(String.Format("Select l.TotalDebt, l.SettlementFeePct, l.InitialDeposit, l.ServiceFeePerAcct, l.MaintenanceFeeCap as ServiceFeeCap, l.DepositCommittment, l.EstGrowth, l.PBMIntRate, l.PBMMinAmt, l.PBMMinPct, totalaccts = l.NoAccts From tblLeadCalculator l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = {0}", ClientId))

        If Not dt Is Nothing And dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            If Not dr("TotalDebt") Is DBNull.Value Then _client.TotalDebt = dr("TotalDebt")
            If Not dr("SettlementFeePct") Is DBNull.Value Then _client.SettlementFeePercent = dr("SettlementFeePct")
            If Not dr("InitialDeposit") Is DBNull.Value Then _client.InitialDeposit = dr("InitialDeposit")
            If Not dr("ServiceFeeCap") Is DBNull.Value Then _client.ServiceFeeCap = dr("ServiceFeeCap")
            If Not dr("ServiceFeePerAcct") Is DBNull.Value Then _client.ServiceFeePerAcct = dr("ServiceFeePerAcct")
            If Not dr("DepositCommittment") Is DBNull.Value Then _client.RegularDeposit = dr("DepositCommittment")
            If Not dr("TotalAccts") Is DBNull.Value Then _client.NumberAccounts = dr("TotalAccts")
            'If Not dr("EstGrowth") Is DBNull.Value Then _client.EstimatedGrowth = dr("EstGrowth") / 100
            If Not dr("PBMIntRate") Is DBNull.Value Then _client.PBMAPR = dr("PBMIntRate") / 100
            If Not dr("PBMMinAmt") Is DBNull.Value Then _client.PBMMinPay = dr("PBMMinAmt")
            If Not dr("PBMMinPct") Is DBNull.Value Then _client.PBMMinPayPct = dr("PBMMinPct") / 100
        End If

    End Sub

    Private Sub LoadClientDataFromClientInfo(ByVal ClientId As Integer)
        _client = New Client_ServiceCapCalculator
        _client.CliendId = ClientId
        Dim sb As New System.Text.StringBuilder()
        sb.AppendLine("select ")
        sb.AppendLine("TotalAccts = (select count(a.accountid) from tblaccount a ")
        sb.AppendLine("where a.clientid = c.clientid ")
        sb.AppendLine("and a.accountstatusid <> 55 ")
        sb.AppendLine("and not (a.accountstatusid = 54 ")
        sb.AppendLine("and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))), ")
        sb.AppendLine("TotalDebt = (select sum(a.currentamount) from tblaccount a ")
        sb.AppendLine("where a.clientid = c.clientid ")
        sb.AppendLine("and a.accountstatusid <> 55 ")
        sb.AppendLine("and not (a.accountstatusid = 54 ")
        sb.AppendLine("and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))), ")
        sb.AppendLine("100 * c.SettlementFeePercentage as SettlementFeePct, ")
        sb.AppendLine("c.MonthlyFee as ServiceFeePerAcct, ")
        sb.AppendLine("c.MaintenanceFeeCap as ServiceFeeCap, ")
        sb.AppendLine("c.InitialDraftAmount as InitialDeposit, ")
        sb.AppendLine("DepositCommittment = Case When c.MultiDeposit = 1 Then ")
        sb.AppendLine("(Select sum(d.DepositAmount) From tblClientDepositDay d Where d.DeletedDate is Null and d.ClientId=c.ClientId) ")
        sb.AppendLine("Else c.DepositAmount End ")
        sb.AppendLine("from tblclient c ")
        sb.AppendFormat("where c.clientid = {0}", ClientId)

        Dim dt As DataTable = GetData(sb.ToString)
        If Not dt Is Nothing And dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            If Not dr("TotalDebt") Is DBNull.Value Then _client.TotalDebt = dr("TotalDebt")
            If Not dr("SettlementFeePct") Is DBNull.Value Then _client.SettlementFeePercent = dr("SettlementFeePct")
            If Not dr("InitialDeposit") Is DBNull.Value Then _client.InitialDeposit = dr("InitialDeposit")
            If Not dr("ServiceFeeCap") Is DBNull.Value Then _client.ServiceFeeCap = dr("ServiceFeeCap")
            If Not dr("ServiceFeePerAcct") Is DBNull.Value Then _client.ServiceFeePerAcct = dr("ServiceFeePerAcct")
            If Not dr("DepositCommittment") Is DBNull.Value Then _client.RegularDeposit = dr("DepositCommittment")
            If Not dr("TotalAccts") Is DBNull.Value Then _client.NumberAccounts = dr("TotalAccts")
        End If

        If _client.SettlementFeePercent = 0 Then
            'Get settlement percent from SD
            dt = GetData(String.Format("Select l.SettlementPct From tblLeadCalculator l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = {0}", ClientId))
            If Not dt Is Nothing And dt.Rows.Count > 0 Then
                If Not dt.Rows(0)("SettlementPct") Is DBNull.Value Then _client.SettlementFeePercent = dt.Rows(0)("SettlementPct")
            End If
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Dim clientid As Integer = Me.Request.QueryString("id")
            LoadData(clientid, False)
        End If
    End Sub

    Public Function IsSmartDebtorClient(ByVal Clientid As Integer) As Boolean
        Dim dt As DataTable = GetData(String.Format("Select l.LeadApplicantId From tblLeadApplicant l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = {0}", Clientid))
        Return (dt.Rows.Count > 0)
    End Function

    Public Function UsesNewCalculator(ByVal Clientid As Integer) As Boolean
        Dim dt As DataTable = GetData(String.Format("Select clientid  From tblClient Where MaintenanceFeeCap is not null and  MaintenanceFeeCap > 0 and clientid = {0}", Clientid))
        Return (dt.Rows.Count > 0)
    End Function

    Private Function GetData(ByVal cmdText As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = cmdText
        Dim ds As DataSet = DatabaseHelper.ExecuteDataset(cmd)
        Return ds.Tables(0)
    End Function

    Private Sub PopulateFields()
        Me.txtNumAccts.Text = _client.NumberAccounts
        Me.txtTotalDebt.Text = _client.TotalDebt
        Me.txtInitialDeposit.Text = _client.InitialDeposit
        Me.txtMaintFeeCap.Text = Format(_client.ServiceFeeCap, "#.00")
        Me.txtDepositComitmment.Text = _client.RegularDeposit
        Me.txtMaintFeePerAcct.Text = Format(_client.ServiceFeePerAcct, "#.00")
        Me.txtEstGrowth.Text = _client.EstimatedGrowth * 100
        Me.txtSettlementFeePct.Text = _client.SettlementFeePercent
        Me.txtIntRate.Text = _client.PBMAPR * 100
        Me.txtMinAmt.Text = Format(_client.PBMMinPay, "#.00")
        Me.txtMinPct.Text = _client.PBMMinPayPct * 100
    End Sub

    Public Sub ReCalc()
        gvEstimates.DataSource = CalcNewModel()
        gvEstimates.DataBind()
        StyleGridView(gvEstimates)
        CalcPBM()
        CalcComparisons()
    End Sub

    Private Function CalcNewModel() As DataTable
        Dim tblAccts As DataTable
        lstPct = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentPercentages'").Split("|")
        Dim depositCommittment As Double
        Dim initialDeposit As Double = Val(txtInitialDeposit.Text)
        Dim estGrowth As Double = Val(txtEstGrowth.Text) / 100
        Dim totalDebt As Double
        Dim totalDebtAtSettl As Double
        Dim settFeePct As Double = Val(txtSettlementFeePct.Text) / 100
        Dim curMonth As Integer
        Dim monthlyFee As Double
        Dim monthlyDepositAfterFees As Double
        Dim colName As String
        Dim acctNum As Integer = 1
        Dim acctsToSettle As Integer = 0
        Dim cap As Double = Val(txtMaintFeeCap.Text)
        Dim perAcctFee As Double = Val(txtMaintFeePerAcct.Text)
        Dim rowLastSDABal As Data.DataRow
        Dim tblSummary As New Data.DataTable
        Dim rowPct, rowTot, rowSett, rowFees, rowServ, rowCost, rowTerm As Data.DataRow
        Dim settPct, settFees, settFee As Double
        Dim bal As Double
        Dim rowAcct As DataRow

        If Not tblAccounts Is Nothing Then tblAccts = tblAccounts.Copy()

        If Not tblAccts Is Nothing Then
            For Each acct As DataRow In tblAccts.Rows
                totalDebt += Val(acct(0))
                totalDebtAtSettl += (estGrowth * Val(acct(0))) + Val(acct(0))
                acctsToSettle += 1
            Next
        Else
            tblAccts = New DataTable
            tblAccts.Columns.Add("bal")
        End If

        If acctsToSettle > 0 Then
            txtNumAccts.Text = acctsToSettle
            txtTotalDebt.Text = Format(totalDebt, "0.00")
            'txtNumAccts.Enabled = False
            'txtTotalDebt.Enabled = False
        Else
            'try using # of Accounts and Total Debt fields instead
            'txtNumAccts.Enabled = True
            'txtTotalDebt.Enabled = True
            If Not Val(txtNumAccts.Text) > 0 And Val(txtTotalDebt.Text) > 0 Then txtNumAccts.Text = "1"
            acctsToSettle = CInt(txtNumAccts.Text)
            totalDebt = Val(txtTotalDebt.Text)
            totalDebtAtSettl = (estGrowth * totalDebt) + totalDebt
            'and just have each indiv account with the same balance
            If acctsToSettle = 0 Then
                bal = 0
            Else
                bal = totalDebt / acctsToSettle
            End If
            For i As Integer = 1 To acctsToSettle
                rowAcct = tblAccts.NewRow
                rowAcct(0) = bal
                tblAccts.Rows.Add(rowAcct)
            Next
        End If

        'Deposit Committment is either double the initial monthly service fee or 1% of the total debt, whichever is greater
        monthlyFee = (perAcctFee * acctsToSettle)
        If monthlyFee > cap Then
            monthlyFee = cap
        End If
        If (totalDebt * 0.01) > (monthlyFee * 2) Then
            depositCommittment = totalDebt * 0.01
        Else
            depositCommittment = monthlyFee * 2
        End If
        'If Val(txtDepositComitmment.Text) > depositCommittment Then
        'if the user changed the deposit committment, only use it if it's more than the min 
        'dep commit allowed (currently depositCommittment)
        'depositCommittment = Val(txtDepositComitmment.Text)
        'End If
        'txtDepositComitmment.Text = CInt(depositCommittment)

        tblSummary.Columns.Add("col1", GetType(System.String))

        For Each pct As String In lstPct
            colName = String.Format("col{0}", CInt(Val(pct) * 100))
            tblSummary.Columns.Add(colName, GetType(System.String))
        Next

        rowPct = tblSummary.NewRow
        rowPct("col1") = ""
        rowTot = tblSummary.NewRow
        rowTot("col1") = "Total Debt @ Settlement"
        rowSett = tblSummary.NewRow
        rowSett("col1") = "Settlement %"
        rowServ = tblSummary.NewRow
        rowServ("col1") = "Total Service Fees"
        rowFees = tblSummary.NewRow
        rowFees("col1") = "Settlement Fees"
        rowCost = tblSummary.NewRow
        rowCost("col1") = "Total Settlement Cost"
        rowTerm = tblSummary.NewRow
        rowTerm("col1") = "# of Deposits"

        For Each pct As String In lstPct
            colName = String.Format("col{0}", CInt(Val(pct) * 100))
            rowPct(colName) = FormatPercent(Val(pct), 0)
            rowTot(colName) = FormatCurrency(totalDebtAtSettl, 0)
            settPct = totalDebtAtSettl * Val(pct)
            rowSett(colName) = FormatCurrency(settPct, 0)
            settFees = (totalDebtAtSettl - settPct) * settFeePct
            rowFees(colName) = FormatCurrency(settFees, 0)
            rowServ(colName) = "0"
            rowCost(colName) = "0"
            rowTerm(colName) = "0"
        Next

        tblSummary.Rows.Add(rowPct)
        tblSummary.Rows.Add(rowTot)
        tblSummary.Rows.Add(rowSett)
        tblSummary.Rows.Add(rowServ)
        tblSummary.Rows.Add(rowFees)
        tblSummary.Rows.Add(rowCost)
        tblSummary.Rows.Add(rowTerm)

        For Each acct As DataRow In tblAccts.Rows
            Dim withGrowth As Double = (estGrowth * Val(acct(0))) + Val(acct(0))
            Dim tbl As New Data.DataTable

            tbl.Columns.Add("col1", GetType(System.String))

            For Each pct As String In lstPct
                colName = String.Format("col{0}", CInt(Val(pct) * 100))
                tbl.Columns.Add(colName, GetType(System.String))
            Next

            Dim rowGoalAmt As Data.DataRow = tbl.NewRow
            Dim rowSettPct As Data.DataRow = tbl.NewRow
            Dim goalAmt As Double

            rowGoalAmt("col1") = "Goal Amt"
            rowSettPct("col1") = "Settl %"

            For Each pct As String In lstPct
                colName = String.Format("col{0}", CInt(Val(pct) * 100))
                goalAmt = withGrowth * Val(pct)
                settFee = (withGrowth - goalAmt) * settFeePct
                goalAmt = goalAmt + settFee
                rowGoalAmt(colName) = FormatCurrency(goalAmt, 2)
                rowSettPct(colName) = Format(pct, "#0.##") & "%"
            Next

            tbl.Rows.Add(rowGoalAmt)
            tbl.Rows.Add(rowSettPct)

            Dim row As Data.DataRow
            Dim goalAmtRow As Data.DataRow = tbl.Rows(0)
            Dim lastRow As Data.DataRow
            Dim blnNeedsMore As Boolean = True
            Dim sda As Double
            Dim lastRowAmt As String
            Dim goal As Double
            Dim rowSDABal As Data.DataRow = tbl.NewRow
            Dim lastSDABal As Double

            curMonth = 1

            While blnNeedsMore
                blnNeedsMore = False
                row = tbl.NewRow
                row("col1") = String.Format("Month {0}", curMonth)

                For Each pct As String In lstPct
                    colName = String.Format("col{0}", CInt(Val(pct) * 100))

                    monthlyFee = (perAcctFee * acctsToSettle)
                    If monthlyFee > cap Then
                        monthlyFee = cap
                    End If

                    monthlyDepositAfterFees = depositCommittment - monthlyFee

                    If monthlyFee > depositCommittment Then
                        Exit While
                    End If

                    If curMonth = 1 Then
                        If acctNum > 1 Then
                            'factor in sda bal from prev settlement
                            lastSDABal = Val(rowLastSDABal(colName).ToString.Replace("$", "").Replace(",", ""))
                            sda = monthlyDepositAfterFees + lastSDABal
                        Else
                            If acctsToSettle = tblAccts.Rows.Count Then
                                'the first account gets the initial deposit
                                sda = monthlyDepositAfterFees + initialDeposit
                            Else
                                sda = monthlyDepositAfterFees
                            End If
                        End If
                        lastRowAmt = ""
                    Else
                        lastRow = tbl.Rows(curMonth)
                        lastRowAmt = lastRow(colName).ToString.Replace("$", "").Replace(",", "")
                        sda = monthlyDepositAfterFees + Val(lastRowAmt)
                    End If

                    goal = Val(goalAmtRow(colName).ToString.Replace("$", "").Replace(",", ""))

                    If sda < goal AndAlso lastRowAmt <> "-" Then
                        row(colName) = FormatCurrency(sda, 2)
                        blnNeedsMore = True
                        rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 0)
                    Else
                        If lastRowAmt = "-" Then
                            row(colName) = "-"
                        ElseIf Val(lastRowAmt) > goal Then
                            rowSDABal(colName) = FormatCurrency(Val(lastRowAmt) - goal, 2) 'left over sda for next acct to settle
                            row(colName) = "-"
                            rowTerm(colName) = CInt(rowTerm(colName)) + curMonth - 1
                        Else
                            row(colName) = FormatCurrency(sda, 2)
                            blnNeedsMore = True
                            rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 0)
                        End If
                    End If
                Next

                tbl.Rows.Add(row)
                curMonth += 1
                If curMonth > maxMonths Then Exit While
            End While

            acctsToSettle -= 1

            rowSDABal("col1") = "SDA bal"
            tbl.Rows.Add(rowSDABal)
            rowLastSDABal = rowSDABal

            acctNum += 1
        Next 'acct

        Dim totalSettCost As Double

        For Each pct As String In lstPct
            colName = String.Format("col{0}", CInt(Val(pct) * 100))
            totalSettCost = Val(rowSett(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowFees(colName).ToString.Replace("$", "").Replace(",", ""))
            rowCost(colName) = FormatCurrency(totalSettCost, 0)
        Next

        Return tblSummary
    End Function

    Private Sub CalcPBM()
        Dim tblPBM As New Data.DataTable
        Dim totalDebt As Double = Val(txtTotalDebt.Text)

        tblPBM.Columns.Add(New Data.DataColumn("Col1", GetType(System.String)))
        tblPBM.Columns.Add(New Data.DataColumn("Months", GetType(System.String)))
        tblPBM.Columns.Add(New Data.DataColumn("TotalPaid", GetType(System.String)))
        tblPBM.Columns.Add(New Data.DataColumn("Principal", GetType(System.String)))
        tblPBM.Columns.Add(New Data.DataColumn("Interest", GetType(System.String)))

        tblPBM.Rows.Add(New Object() {"", "Deposits", "Paid", "Principal", "Interest"})
        tblPBM.Rows.Add(CalcPBMVar(ModelType.Variable, totalDebt))

        gvPBM.DataSource = tblPBM
        gvPBM.DataBind()
        StyleGridView(gvPBM)
    End Sub

    Private Sub CalcComparisons()
        lstPct = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentPercentages'").Split("|")
        Dim depositIncr As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDepositIncrease"))
        Dim depositCommittment As Double = Val(txtDepositComitmment.Text)
        Dim tempDeposit As Double
        Dim tblSummary As DataTable
        Dim tblCompare As New DataTable
        Dim row As Data.DataRow
        Dim rowPct As Data.DataRow
        Dim colName As String

        tblCompare.Columns.Add("col1", GetType(System.String))

        For Each pct As String In lstPct
            colName = String.Format("col{0}", CInt(Val(pct) * 100))
            tblCompare.Columns.Add(colName, GetType(System.String))
        Next

        rowPct = tblCompare.NewRow
        rowPct("col1") = ""

        For Each pct As String In lstPct
            colName = String.Format("col{0}", CInt(Val(pct) * 100))
            rowPct(colName) = FormatPercent(Val(pct), 0)
        Next

        tblCompare.Rows.Add(rowPct)

        For i As Double = 0 To (depositIncr * 4) Step depositIncr '4 iterations
            tempDeposit = depositCommittment + (depositCommittment * i)
            txtDepositComitmment.Text = tempDeposit
            tblSummary = CalcNewModel()
            If Not IsNothing(tblSummary) Then
                row = tblSummary.Rows(5)
                row("col1") = FormatCurrency(tempDeposit, 0)
                tblCompare.ImportRow(row)
            End If
        Next

        txtDepositComitmment.Text = depositCommittment

        gvCompare.DataSource = tblCompare
        gvCompare.DataBind()
        StyleGridView(gvCompare)
    End Sub

    Private Function CalcPBMVar(ByVal modelType As ModelType, ByVal TotalDebt As Double) As Object()
        Dim balance As Double = TotalDebt
        Dim withgrowth = TotalDebt + (TotalDebt + Val(txtEstGrowth.Text) / 100)
        Dim apr As Double = Val(txtIntRate.Text) / 100
        Dim monthlyAPR As Double = apr / 12
        Dim minPayPct As Double = Val(txtMinPct.Text) / 100
        Dim minPay As Double = Val(txtMinAmt.Text)
        Dim fixedAmt As Double = Val(txtDepositComitmment.Text)
        Dim interest As Double
        Dim withinterest As Double
        Dim payment As Double
        Dim curMonth As Integer = 1
        Dim totalPay As Double = 0
        Dim tbl As New Data.DataTable
        Dim blnNeedsMore As Boolean = True
        Dim row As Data.DataRow
        Dim col1 As String = ""

        tbl.Columns.Add(New Data.DataColumn("Month", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Balance", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Interest", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Payment", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Remain", GetType(System.String)))

        Select Case modelType
            Case modelType.Variable
                col1 = "PBM Variable"
            Case modelType.OnePayment
                col1 = "PBM 1-Payment"
        End Select

        While balance > 0
            row = tbl.NewRow
            row("Month") = String.Format("Month {0}", curMonth)
            row("Balance") = FormatCurrency(balance, 2)
            interest = balance * monthlyAPR
            withinterest = balance + interest
            row("Interest") = FormatCurrency(withinterest, 2)

            Select Case modelType
                Case modelType.Variable
                    payment = IIf(balance * minPayPct > minPay, balance * minPayPct, minPay)
                Case modelType.OnePayment
                    payment = fixedAmt
            End Select

            If interest > payment Then
                Exit While
            End If

            If balance < payment Then payment = withinterest
            balance = withinterest - payment

            row("Payment") = FormatCurrency(payment, 2)
            row("Remain") = FormatCurrency(balance, 2)
            tbl.Rows.Add(row)

            totalPay += payment
            curMonth += 1
            If curMonth > maxMonths Then Exit While
        End While

        Return New Object() {col1, (curMonth - 1).ToString, FormatCurrency(totalPay, 0), FormatCurrency(TotalDebt, 0), FormatCurrency(totalPay - TotalDebt, 0)}
    End Function

    Private Sub StyleGridView(ByVal gv As GridView)
        For r As Integer = 0 To gv.Rows.Count - 1
            For c As Integer = 0 To gv.Rows(r).Cells.Count - 1
                If c = 0 Then
                    gv.Rows(r).Cells(c).Width = Unit.Pixel(130)
                End If

                If r = 0 And c > 0 Then
                    gv.Rows(r).Cells(c).CssClass = "top-col"
                ElseIf r > 0 And c = 0 Then
                    gv.Rows(r).Cells(c).CssClass = "left-col"
                ElseIf r > 0 And c > 0 Then
                    gv.Rows(r).Cells(c).CssClass = "center-col"
                End If
            Next
        Next
    End Sub

    Private Sub SetProperties()
        'If _client.EstimatedGrowth = 0 Then _client.EstimatedGrowth = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentInflation'")
        If _client.PBMAPR = 0 Then _client.PBMAPR = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentPBMAPR'")
        If _client.PBMMinPay = 0 Then _client.PBMMinPay = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentPBMMinimum'")
        If _client.PBMMinPayPct = 0 Then _client.PBMMinPayPct = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentPBMPercentage'")
        tblAccounts = GetAccounts()
    End Sub

    Protected Sub txtInitialDeposit_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        ReCalc()
        'txtInitialDeposit.Text = CInt(Val(txtInitialDeposit.Text))
        'txtInitialDeposit.Focus()
    End Sub

    Protected Sub txtDepositComitmment_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        ReCalc()
        'txtDepositComitmment.Focus()
    End Sub

    Protected Sub txtNumAccts_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtNumAccts.TextChanged
        ReCalc()
    End Sub

    Protected Sub txtTotalDebt_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtTotalDebt.TextChanged
        ReCalc()
    End Sub

    Public Sub Update()
        Me.upd.Update()
    End Sub

    Private Function GetAccounts() As DataTable
        Dim sb As New System.Text.StringBuilder
        If Me.hdnUseSD.Value = "1" Then
            sb.AppendFormat("Select isnull(l.balance,0) as balance from tblleadcreditorinstance l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = {0} order by l.balance", Me.hdnClientId.Value)
        Else
            sb.AppendLine("select isnull(a.currentamount, 0) as balance from tblaccount a ")
            sb.AppendFormat("where a.clientid = {0} ", Me.hdnClientId.Value)
            sb.AppendLine("and a.accountstatusid <> 55 ")
            sb.AppendLine("and not (a.accountstatusid = 54 ")
            sb.AppendLine("and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1)) ")
            sb.AppendLine("order by a.currentamount")
        End If

        Return GetData(sb.ToString)
    End Function


End Class
