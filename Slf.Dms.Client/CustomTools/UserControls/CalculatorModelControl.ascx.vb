Imports System.Collections.Generic
Imports System.Data

Partial Class CalculatorModelControl
    Inherits System.Web.UI.UserControl

#Region "Fields"

    Private Const MaxMonths As Integer = 2000
    Private _HideAcctPanel As Boolean
    Private _UseLeadData As Boolean
    Private _useFormData As Boolean
    Private _NewModel As Boolean
    Private cProps As CalcProperties

#End Region 'Fields

#Region "Properties"

    Public ReadOnly Property EstimatedDebtBalanceAtTimeOfSettlement() As Integer
        Get
            If Not _NewModel Then
                'Return (TotalDebt * EstimateGrowthPct / 100) + TotalDebt
                Return TotalDebt
            Else
                Return TotalDebt
            End If

        End Get
    End Property

    Public Property ApplicantID() As Integer
        Get
            If ViewState.Count > 0 Then
                Return ViewState("applicantid").ToString
            Else
                Return 0
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("applicantid") = value
        End Set
    End Property

    Public Property DepositCommittment() As Double
        Get
            Return Val(txtDepositComitmment.Text)
        End Get
        Set(ByVal value As Double)
            txtDepositComitmment.Text = value
        End Set
    End Property

    Public Property EstimateGrowthPct() As Double
        Get
            Return Val(txtEstGrowth.Text)
        End Get
        Set(ByVal value As Double)
            txtEstGrowth.Text = value
        End Set
    End Property

    Public Property HideAcctPanel() As Boolean
        Get
            Return _HideAcctPanel
        End Get
        Set(ByVal value As Boolean)
            _HideAcctPanel = value
        End Set
    End Property

    Public Property InitialDeposit() As Double
        Get
            Return Val(txtInitialDeposit.Text)
        End Get
        Set(ByVal value As Double)
            txtInitialDeposit.Text = value
        End Set
    End Property

    Public Property InterestRate() As Double
        Get
            Return Val(txtIntRate.Text)
        End Get
        Set(ByVal value As Double)
            txtIntRate.Text = value
        End Set
    End Property

    Public Property MinPaymentAmt() As Double
        Get
            Return Val(txtMinAmt.Text)
        End Get
        Set(ByVal value As Double)
            txtMinAmt.Text = value
        End Set
    End Property

    Public Property MinPaymentPct() As Double
        Get
            Return Val(txtMinPct.Text)
        End Get
        Set(ByVal value As Double)
            txtMinPct.Text = value
        End Set
    End Property

    Public Property MonthlyFeePerAcct() As Double
        Get
            Return Val(txtMaintFeePerAcct.Text)
        End Get
        Set(ByVal value As Double)
            txtMaintFeePerAcct.Text = value
            txtMaintFeePerAcct1.Text = value
        End Set
    End Property

    Public Property ServiceFeeCap() As Double
        Get
            Return Val(txtMaintFeeCap.Text)
        End Get
        Set(ByVal value As Double)
            txtMaintFeeCap.Text = value
        End Set
    End Property

    Public Property SettlementFeePct() As Double
        Get
            Return Val(txtSettlementFeePct.Text)
        End Get
        Set(ByVal value As Double)
            txtSettlementFeePct.Text = value
        End Set
    End Property

    Public Property TotalDebt() As Integer
        Get
            Return Val(txtTotalDebt.Text)
        End Get
        Set(ByVal value As Integer)
            txtTotalDebt.Text = value
        End Set
    End Property

    Public Property TotalNumberOfAccts() As Integer
        Get
            Return CInt(txtNumAccts.Text)
        End Get
        Set(ByVal value As Integer)
            txtNumAccts.Text = value
        End Set
    End Property

    Public Property UseLeadData() As Boolean
        Get
            Return _UseLeadData
        End Get
        Set(ByVal value As Boolean)
            _UseLeadData = value
        End Set
    End Property

    'Public Property ProductID() As Integer
    '    Get
    '        Return _ProductID
    '    End Get
    '    Set(ByVal value As Integer)
    '        _ProductID = value
    '    End Set
    'End Property

#End Region 'Properties

#Region "Methods"

    Private Sub IsNewModel(ByVal LeadApplicantID As Integer)
        _NewModel = CInt(SqlHelper.ExecuteScalar("select isnull(servicefee,0) from tblleadproducts p join tblleadapplicant l on l.productid = p.productid and l.leadapplicantid = " & LeadApplicantID, CommandType.Text)) > 0
    End Sub

    Public Sub DisplayCalculator(ByVal bShow As Boolean)
        Dim displayStyle As String = "none"

        If bShow Then
            displayStyle = "block"
        End If
        tblBody.Style("display") = displayStyle

        If _HideAcctPanel Then
            tblAcctInfo.Style("display") = "none"
        End If
    End Sub

    Public Sub EnableVariables()
        txtEstGrowth.Enabled = True
        txtIntRate.Enabled = True
        txtMaintFeeCap.Enabled = False
        txtMaintFeePerAcct.Enabled = True
        txtMinAmt.Enabled = True
        txtMinPct.Enabled = True
        txtSettlementFeePct.Enabled = True
    End Sub

    Public Function IsSmartDebtorClient(ByVal DataClientid As Integer) As Boolean
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("Select LeadApplicantId From tblLeadApplicant Where LeadApplicantId = {0}", DataClientid), ConfigurationManager.AppSettings("connectionstring").ToString)
        If dt.Rows.Count > 0 Then
            Dim newdt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("SELECT LeadApplicantID from vw_LeadApplicant_Client WHERE ClientID = {0}", DataClientid), ConfigurationManager.AppSettings("connectionstring").ToString)
            If newdt.Rows.Count > 0 Then
                IsNewModel(CInt(Val(newdt.Rows(0).Item(0))))
                ApplicantID = CInt(Val(newdt.Rows(0).Item(0)))
            End If
        End If
        Return (dt.Rows.Count > 0)
    End Function

    Public Sub ReCalcModel()
        _useFormData = False

        BuildExampleInfo()
        DisplayCalculator(True)
    End Sub

    Public Sub ReCalcModel(ByVal initialDepositAmount As Double, ByVal depositCommitmentAmount As Double, ByVal totalDebtAmount As Double, ByVal totalNumberOfAccounts As Integer, Optional ByVal useFormData As Boolean = False)
        InitialDeposit = initialDepositAmount
        DepositCommittment = depositCommitmentAmount
        TotalDebt = totalDebtAmount
        TotalNumberOfAccts = totalNumberOfAccounts

        _useFormData = useFormData

        BuildExampleInfo()
        DisplayCalculator(True)
    End Sub

    Public Function UsesNewCalculator(ByVal Clientid As Integer) As Boolean
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("Select clientid  From tblClient Where MaintenanceFeeCap is not null and  MaintenanceFeeCap > 0 and clientid = {0}", Clientid), ConfigurationManager.AppSettings("connectionstring").ToString)
        Return (dt.Rows.Count > 0)
    End Function
    Public Function AddHeaderRow(ByVal gridHeaderRow As System.Web.UI.WebControls.GridViewRowEventArgs, ByVal depMessage As String) As GridViewRow
        'Add another Header Row
        Dim row As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        row.BackColor = System.Drawing.Color.Black
        row.ForeColor = System.Drawing.Color.White
        row.CssClass = "entry2"
        row.Style("height") = "25px"
        row.Style("padding") = "3px"

        Dim newCell As New TableCell()
        With newCell
            .Text = depMessage
            .HorizontalAlign = HorizontalAlign.Center
            .Wrap = False
            .Width = 185
            .Font.Bold = True
        End With
        row.Cells.Add(newCell)

        newCell = New TableCell()
        With newCell
            .Text = "If your creditors accept:"
            .HorizontalAlign = HorizontalAlign.Center
            .BackColor = System.Drawing.Color.White
            .ForeColor = System.Drawing.Color.Black
            .Font.Bold = True
            .ColumnSpan = gridHeaderRow.Row.Cells.Count - 1
        End With
        row.Cells.Add(newCell)

        Return row
    End Function
    Protected Sub CustomTools_UserControls_CalculatorModelControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        DisplayCalculator(True)
        If Not Page.IsPostBack Then
            IsSmartDebtorClient(Me.ApplicantID)
            LoadClientData()
            ' jhope 9/23/2010
            With Me
                If _NewModel Or ApplicantID = 0 Then
                    .gvExample.Columns(1).Visible = False 'This is the column that is Estimated Debt Balance at time of settlement.
                    .dvOldCalc.Visible = False
                    .gvExample.Caption = "<div style='text-align:left;background-color:#F0E68C;'><b>Settlement Example<sup>(7)(8)</sup></b></div>"
                    .lblMonthlyFee.Text = "Monthly Fee"
                    .lblContingencyFee.Text = "Contingency Fee"
                    .txtEstGrowth.Text = "0"
                    .txtMaintFeePerAcct.Visible = True
                    .txtMaintFeePerAcct1.Visible = False
                Else
                    .gvExample.Columns(1).Visible = True
                    .dvOldCalc.Visible = True
                    .gvExample.Caption = "<div style='text-align:left;background-color:#F0E68C;'><b>Settlement Example<sup>(7)</sup></b></div>"
                    .lblMonthlyFee.Text = "Monthly Fee Per Acct"
                    .lblContingencyFee.Text = "Settlement Fee"
                    .txtEstGrowth.Text = "31"
                    EstimateGrowthPct = "31"
                    .txtMaintFeePerAcct.Visible = False
                    .txtMaintFeePerAcct1.Visible = True
                    .SettlementFeePct = "33"
                End If
            End With
        End If

    End Sub

    Protected Sub btnCalculate_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnCalculate.Click
        ReCalcModel(txtInitialDeposit.Text, txtDepositComitmment.Text, txtTotalDebt.Text, txtNumAccts.Text, True)
    End Sub
    Protected Sub gv_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                sender.Controls(0).Controls.AddAt(0, AddHeaderRow(e, sender.Attributes("depositMsg")))
            
        End Select
    End Sub
    Protected Sub gv_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Dim gvID As String = ""
        Dim MonthlyDepositCommittmentMsg As String = ""
        Dim ac As AttributeCollection = Nothing
        Using gv As GridView = TryCast(sender, GridView)
            gvID = gv.ID
            ac = gv.Attributes
        End Using

        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Select Case gvID
                    Case "gvExample", "gvMinPayment"
                        For Each tc As TableCell In e.Row.Cells
                            tc.CssClass = "headitem5"
                            Dim tcText As New StringBuilder
                            tcText.Append(tc.Text)
                            Select Case tc.Text
                                Case "Total Principle", "Original Balance"
                                    tcText.Append(" <sup>(2)</sup>")
                                Case "Total Interest"
                                    tcText.Append(" <sup>(3)</sup>")
                                Case "Total Amount Paid"
                                    tcText.Append(" <sup>(4)</sup>")
                                Case "Number of Months"
                                    tcText.Append(" <sup>(5)</sup>")
                                Case "Number of Years"
                                    tcText.Append(" <sup>(6)</sup>")
                                Case "Starting Debt Balance"
                                    tcText.Append(" <sup>(2)</sup>")
                                Case "Estimated Debt Balance at Time of Settlement"
                                    tcText.Append(" <sup>(8)</sup>")
                                Case "Total Represented Accounts", "Target Debts"
                                    tcText.Append(" <sup>(9)</sup>")
                            End Select
                            tc.Text = tcText.ToString
                        Next
                    Case Else
                        e.Row.Cells(0).Text = ac("MonthlyDepositCommittment").ToString
                        e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Right

                        For i As Integer = 0 To e.Row.Cells.Count - 1
                            e.Row.Cells(i).CssClass = "gridHdr"
                        Next
                End Select

            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

        End Select
    End Sub

    Private Sub BuildGoalAmtAndSettPctRows(ByVal lstPct As String(), ByVal withGrowth As Double, ByRef rowGoalAmt As Data.DataRow, ByRef rowSettPct As Data.DataRow)
        Dim goalAmt As Double
        Dim settFee As Double
        rowGoalAmt("col1") = "Goal Amt"
        rowSettPct("col1") = "Settl %"

        For Each pct As String In lstPct
            Dim colName As String = String.Format("{0} %", CInt(Val(pct) * 100))
            goalAmt = withGrowth * Val(pct)
            settFee = (withGrowth - goalAmt) * SettlementFeePct / 100
            goalAmt = goalAmt + settFee
            rowGoalAmt(colName) = FormatCurrency(goalAmt, 0)
            rowSettPct(colName) = FormatPercent(pct, 2, TriState.True, TriState.False, TriState.False) 'Format(pct, "#0.##") & "%"
        Next
    End Sub

    Private Shared Sub BuildHeaderRow(ByVal lstPct As String(), ByRef tbl As Data.DataTable)
        Dim colName As String

        tbl.Columns.Add("col1", GetType(System.String))

        For Each pct As String In lstPct
            colName = String.Format("{0} %", CInt(Val(pct) * 100))
            tbl.Columns.Add(colName, GetType(System.String))
        Next
    End Sub

    Private Sub BuildExampleGrid(ByVal dt As DataTable, ByVal MonthlyDepositCommittment As Double, ByVal depositMsg As String)
        Dim irow As Integer = 0
        Dim numRows As Integer = 0
        If Not IsNothing(dt) Then
            numRows = dt.Rows.Count - 1
        Else
            Exit Sub
        End If

        Using tbl As New Table
            tbl.BorderStyle = BorderStyle.None
            tbl.CssClass = "entry"
            tbl.CellPadding = 0
            tbl.CellSpacing = 0

            Using tr As New TableRow
                Dim td As New TableCell
                'td.CssClass = "InfoMsg"
                'td.Style("width") = "17px"
                'td.Text = String.Format("{0} a month", FormatCurrency(MonthlyDepositCommittment, 2))
                'tr.Cells.Add(td)

                td = New TableCell
                Dim gv As New GridView
                gv.Attributes.Add("MonthlyDepositCommittment", String.Format("${0} a month", MonthlyDepositCommittment))
                gv.Attributes.Add("depositMsg", depositMsg)
                gv.ID = MonthlyDepositCommittment

                gv.CssClass = "entry"
                AddHandler gv.RowDataBound, AddressOf gv_RowDataBound
                AddHandler gv.RowCreated, AddressOf gv_RowCreated
                gv.AutoGenerateColumns = False
                For Each dc As DataColumn In dt.Columns
                    Dim bc As New BoundField
                    bc.DataField = dc.ColumnName
                    bc.HeaderText = dc.ColumnName
                    bc.ItemStyle.HorizontalAlign = HorizontalAlign.Right
                    bc.ItemStyle.Font.Size = New FontUnit("8pt")
                    bc.ItemStyle.Font.Name = "tahoma"
                    If dc.ColumnName = "col1" Then
                        bc.ItemStyle.Wrap = False
                        bc.HeaderStyle.Width = 135
                    End If
                    bc.HtmlEncode = False
                    gv.Columns.Add(bc)
                Next

                gv.DataSource = dt
                gv.DataBind()

                For gvrow As Integer = 2 To 5
                    gv.Rows(gvrow).Cells(0).BackColor = System.Drawing.Color.Black
                    gv.Rows(gvrow).Cells(0).ForeColor = System.Drawing.Color.White
                    If gvrow > 3 Then
                        For gcol As Integer = 1 To gv.Columns.Count - 1
                            gv.Rows(gvrow).Cells(gcol).BackColor = System.Drawing.Color.Silver
                        Next
                    End If
                Next
                
                td.Controls.Add(gv)
                tr.Cells.Add(td)
                tbl.Rows.Add(tr)
            End Using
            phGrids.Controls.Add(tbl)
        End Using
    End Sub

    Private Sub BuildExampleInfo()
        Dim exData As New ExampleData
        Dim MinPayData As New MinimumPaymentData
        Dim tblAccts As New DataTable
        Dim aRow As DataRow
        Dim txtBalance As TextBox
        Dim curBal As Double
        Dim total As Integer
        Dim noAccts As Integer

        tblAccts.Columns.Add("balance", Type.GetType("System.Double"))
        tblAccts.AcceptChanges()

        phGrids.Controls.Clear()

        If IsNothing(cProps) Then
            cProps = CalcProperties.LoadProperties
        End If

        If Not _NewModel Then
            EstimateGrowthPct = "0"
            Me.txtEstGrowth.Text = EstimateGrowthPct
        Else
            EstimateGrowthPct = "0"
            Me.txtEstGrowth.Text = EstimateGrowthPct
        End If

        noAccts = 0

        'NewEnrollment2 uses an ultrawebgrid
        If Not IsNothing(Me.Parent.FindControl("wGrdCreditors")) Then
            Dim wGrdCreditors As Infragistics.WebUI.UltraWebGrid.UltraWebGrid = TryCast(Me.Parent.FindControl("wGrdCreditors"), Infragistics.WebUI.UltraWebGrid.UltraWebGrid)
            Dim col As Infragistics.WebUI.UltraWebGrid.TemplatedColumn
            Dim item As Infragistics.WebUI.UltraWebGrid.CellItem

            For i As Integer = 0 To wGrdCreditors.Rows.Count - 1
                col = wGrdCreditors.Columns(3)
                item = col.CellItems(i)
                txtBalance = CType(item.FindControl("txtBalance"), TextBox)
                aRow = tblAccts.NewRow
                curBal = Val(txtBalance.Text.Replace("$", "").Replace(",", ""))
                aRow(0) = (Val(txtEstGrowth.Text) / 100 * curBal) + curBal
                tblAccts.Rows.Add(aRow)
                total += curBal
            Next

            noAccts = wGrdCreditors.Rows.Count
        ElseIf Not IsNothing(Me.Parent.FindControl("gvCreditors")) Then 'NewerModel uses a gridview
            Dim gvCreditors As GridView = TryCast(Me.Parent.FindControl("gvCreditors"), GridView)

            For Each row As GridViewRow In gvCreditors.Rows
                txtBalance = CType(row.FindControl("txtBalance"), TextBox)
                aRow = tblAccts.NewRow
                curBal = Val(txtBalance.Text.Replace("$", "").Replace(",", ""))
                aRow(0) = (Val(txtEstGrowth.Text) / 100 * curBal) + curBal
                tblAccts.Rows.Add(aRow)
                total += curBal
            Next

            noAccts = gvCreditors.Rows.Count
        ElseIf Not IsNothing(Me.Parent.FindControl("grdAccounts")) Then
            'Dim d As HtmlGenericControl = TryCast(Me.Parent.FindControl("grdAccounts"), HtmlGenericControl)
            Dim stp_GetAccountsForClient As String = String.Format("stp_GetAccountsForClient  {0}", ApplicantID)
            Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(stp_GetAccountsForClient, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each acct As DataRow In dt.Rows
                    aRow = tblAccts.NewRow
                    curBal = Val(acct("currentamount").ToString.Replace("$", "").Replace(",", ""))
                    aRow(0) = (Val(txtEstGrowth.Text) / 100 * curBal) + curBal
                    tblAccts.Rows.Add(aRow)
                    total += curBal
                Next
            End Using

        End If

        If noAccts > 0 Then
            'creditors exist, override fields with results from grid
            txtTotalDebt.Text = total
            txtNumAccts.Text = noAccts
        Else
            'use fields
            Dim avgBal As Double = Val(txtTotalDebt.Text) / CInt(txtNumAccts.Text)
            For i As Integer = 0 To CInt(txtNumAccts.Text) - 1 Step 1
                aRow = tblAccts.NewRow
                aRow(0) = avgBal '(Val(txtEstGrowth.Text) / 100 * avgBal) + avgBal
                tblAccts.Rows.Add(aRow)
            Next
            total = Val(txtTotalDebt.Text)
        End If

        'Min Deposit Committment is either double the initial monthly service fee or 1% of the total debt, whichever is greater
        Dim MinDepositCommittment As Integer
        Dim MonthlyFee As Double
        If Not _NewModel Then
            MonthlyFee = MonthlyFeePerAcct
            If MonthlyFee > ServiceFeeCap Then
                MonthlyFee = ServiceFeeCap
            End If
        Else
            MonthlyFee = MonthlyFeePerAcct * CInt(txtNumAccts.Text)
        End If

        If (TotalDebt * 0.01) > (MonthlyFee * 2) Then
            MinDepositCommittment = TotalDebt * 0.01
        Else
            MinDepositCommittment = MonthlyFee * 2
        End If
        If MinDepositCommittment < 40 Then
            MinDepositCommittment = 40 'floor, absolute minimum
        End If
        If MinDepositCommittment > DepositCommittment Then
            DepositCommittment = MinDepositCommittment
        End If

        'If DepositCommittment > MonthlyFeePerAcct Then
        '    DepositCommittment = DepositCommittment - MonthlyFeePerAcct
        'End If

        'get estimate data to use
        exData.TotalAccts = TotalNumberOfAccts
        exData.StartingDebtBal = FormatCurrency(TotalDebt, 0)
        exData.EstDebtBal = TotalDebt 'EstimatedDebtBalanceAtTimeOfSettlement

        Dim oMinPayExample As Object = CalcABMVar(total)
        MinPayData.TotalPrinciple = oMinPayExample(3).ToString
        MinPayData.TotalInterest = oMinPayExample(4).ToString
        MinPayData.TotalAmountPaid = oMinPayExample(2).ToString
        MinPayData.NumberOfMonths = oMinPayExample(1).ToString
        MinPayData.NumberOfYears = FormatNumber(Double.Parse(oMinPayExample(1).ToString) / 12, 2)

        Dim depHigh As Double = DepositCommittment + cProps.TruthInServiceDepositHighPct
        Dim depLow As Double = DepositCommittment + cProps.TruthInServiceDepositLowPct

        BuildExampleGrid(CalcNewModel(DepositCommittment, exData.EstDebtBal, tblAccts), DepositCommittment, "Your deposit will be:")
        BuildExampleGrid(CalcNewModel(depLow, exData.EstDebtBal, tblAccts), depLow, "If you increase your deposit to:")
        BuildExampleGrid(CalcNewModel(depHigh, exData.EstDebtBal, tblAccts), depHigh, "If you increase your deposit to:")

        Dim lstMinPayExamples As New List(Of MinimumPaymentData)
        lstMinPayExamples.Add(MinPayData)
        AddHandler gvMinPayment.RowDataBound, AddressOf gv_RowDataBound
        gvMinPayment.DataSource = lstMinPayExamples
        gvMinPayment.DataBind()

        Dim lstExamples As New List(Of ExampleData)
        lstExamples.Add(exData)
        AddHandler gvExample.RowDataBound, AddressOf gv_RowDataBound
        gvExample.DataSource = lstExamples
        gvExample.DataBind()
    End Sub

    Private Sub BuildItemRows(ByVal lstPct As String(), ByRef rowTot As Data.DataRow, _
        ByRef rowSett As Data.DataRow, ByRef rowFees As Data.DataRow, ByRef rowServ As Data.DataRow, _
        ByRef rowCost As Data.DataRow, ByRef rowSDA As Data.DataRow, ByRef rowFee2Cost As Data.DataRow, _
        ByRef rowTerm As Data.DataRow, ByRef rowTermYears As Data.DataRow, ByRef rowInitFees As Data.DataRow)

        Dim query As String = "stp_LetterTemplates_GetInitialServiceFee"
        Dim obj As Object = SqlHelper.ExecuteScalar(query, CommandType.StoredProcedure)
        Dim initialFee As String = obj.ToString
        For Each pct As String In lstPct
            Dim settPct As Double
            Dim settFees As Double
            Dim colName As String = String.Format("{0} %", CInt(Val(pct) * 100))
            rowTot(colName) = TotalDebt 'FormatCurrency(EstimatedDebtBalanceAtTimeOfSettlement, 0)
            settPct = TotalDebt * Val(pct) 'EstimatedDebtBalanceAtTimeOfSettlement * Val(pct)
            rowSett(colName) = FormatCurrency(settPct, 0)
            settFees = (EstimatedDebtBalanceAtTimeOfSettlement - settPct) * SettlementFeePct / 100 '(EstimatedDebtBalanceAtTimeOfSettlement - settPct) * SettlementFeePct / 100
            rowFees(colName) = FormatCurrency(settFees, 0)
            rowInitFees(colName) = FormatCurrency(initialFee, 0)
            rowSDA(colName) = FormatCurrency(0, 0)
            rowServ(colName) = "0"
            rowCost(colName) = "0"
            rowTerm(colName) = "0"
            rowTermYears(colName) = "0"
            rowFee2Cost(colName) = "0"
        Next
    End Sub

    Private Function CalcABMVar(ByVal TotalDebtAmt As Double) As Object()
        Dim balance As Double = TotalDebtAmt
        Dim apr As Double = InterestRate / 100
        Dim monthlyAPR As Double = apr / 12
        Dim minPayPct As Double = Double.Parse(MinPaymentPct) / 100
        Dim minPay As Double = Double.Parse(MinPaymentAmt)
        Dim fixedAmt As Double = Double.Parse(DepositCommittment)
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

        col1 = "ABM Variable"

        While balance > 0
            payment = IIf(balance * minPayPct > minPay, balance * minPayPct, minPay)

            row = tbl.NewRow
            row("Month") = String.Format("Month {0}", curMonth)
            row("Balance") = FormatCurrency(balance, 2)

            If payment > balance Then
                payment = balance
            End If
            balance -= payment

            interest = balance * monthlyAPR
            withinterest = balance + interest
            row("Interest") = FormatCurrency(withinterest, 2)

            If interest > payment Then
                Exit While
            End If

            If balance < payment Then
                balance = payment
            End If
            balance = withinterest

            row("Payment") = FormatCurrency(payment, 2)
            row("Remain") = FormatCurrency(balance, 2)
            tbl.Rows.Add(row)

            totalPay += payment
            curMonth += 1

            If curMonth > MaxMonths Then
                Exit While
            End If

        End While

        Return New Object() {col1, (curMonth - 1).ToString, totalPay.ToString("c0"), TotalDebt.ToString("c0"), (totalPay - TotalDebt).ToString("c0")}
    End Function

    Private Function CalcNewModel(ByVal DepositCommittmentAmt As Double, ByVal estimatedDebtAmt As Double, ByVal tblAccts As DataTable) As DataTable
        Dim lstPct() As String = GetListPct()
        Dim initialDeposit As Double = Val(initialDeposit)
        Dim estGrowth As Double = Val(EstimateGrowthPct) / 100
        Dim totalDebtAmt As Double = estimatedDebtAmt
        Dim curMonth As Integer
        Dim acctNum As Integer = 1
        Dim acctsToSettle As Integer
        Dim rowLastSDABal As Data.DataRow
        Dim tblSummary As New Data.DataTable
        Dim rowTot, rowSett, rowFees, rowServ, rowCost, rowSDA, rowFee2Cost, rowTerm, rowTermYears, rowInitFees As Data.DataRow
        Dim bal As Integer = 0
        Dim rowAcct As DataRow = Nothing

        tblSummary.Columns.Add("col1", GetType(System.String))

        For Each pct As String In lstPct
            tblSummary.Columns.Add(String.Format("{0} %", CInt(Val(pct) * 100)), GetType(System.String))
        Next

        rowTot = tblSummary.NewRow
        rowTot("col1") = "Total Debt @ Settlement"
        rowSett = tblSummary.NewRow
        rowSett("col1") = "Settlement Amount<sup>(10)</sup>"
        'rowServ = tblSummary.NewRow
        'rowServ("col1") = "Monthly Legal Fees<sup>(11)</sup>"
        rowFees = tblSummary.NewRow
        rowFees("col1") = "Total Contingency Fees<sup>(11)</sup>"
        rowInitFees = tblSummary.NewRow
        rowInitFees("col1") = "Total Initial Services Fees<sup>(12)</sup>"
        rowServ = tblSummary.NewRow
        rowServ("col1") = "Total Non-Litigation Fees<sup>(13)</sup>"
        rowSDA = tblSummary.NewRow
        rowSDA("col1") = "CDA Service Fees<sup>(13)</sup>"
        rowCost = tblSummary.NewRow
        rowCost("col1") = "Total Settlement Cost<sup>(14)</sup>"
        rowFee2Cost = tblSummary.NewRow
        rowFee2Cost("col1") = "% Fees to Total Cost<sup>(15)</sup>"
        rowTerm = tblSummary.NewRow
        rowTerm("col1") = "Number of Months<sup>(16)</sup>"
        rowTermYears = tblSummary.NewRow
        rowTermYears("col1") = "Number of Years<sup>(17)</sup>"

        BuildItemRows(lstPct, rowTot, rowSett, rowFees, rowServ, rowCost, rowSDA, rowFee2Cost, rowTerm, rowTermYears, rowInitFees)

        tblSummary.Rows.Add(rowSett)
        tblSummary.Rows.Add(rowFees)
        tblSummary.Rows.Add(rowInitFees)
        tblSummary.Rows.Add(rowServ)
        'tblSummary.Rows.Add(rowSDA)
        tblSummary.Rows.Add(rowCost)
        tblSummary.Rows.Add(rowFee2Cost)
        tblSummary.Rows.Add(rowTerm)
        tblSummary.Rows.Add(rowTermYears)

        tblAccts.DefaultView.Sort = "balance asc"

        acctsToSettle = tblAccts.Rows.Count
        For i As Integer = 0 To tblAccts.DefaultView.Count - 1
            Dim withGrowth As Double = Val(tblAccts.DefaultView(i)(0)) 'growth already calculated in
            Dim tbl As New Data.DataTable
            BuildHeaderRow(lstPct, tbl)

            Dim rowGoalAmt As Data.DataRow = tbl.NewRow
            Dim rowSettPct As Data.DataRow = tbl.NewRow
            BuildGoalAmtAndSettPctRows(lstPct, withGrowth, rowGoalAmt, rowSettPct)
            tbl.Rows.Add(rowGoalAmt)
            tbl.Rows.Add(rowSettPct)

            Dim goalAmtRow As Data.DataRow = tbl.Rows(0)
            Dim lastRow As Data.DataRow
            Dim blnNeedsMore As Boolean = True
            Dim sda As Double
            Dim lastRowAmt As String
            Dim goal As Double
            Dim rowSDABal As Data.DataRow = tbl.NewRow
            Dim lastSDABal As Double

            curMonth = 1

            CalculateItemRows(lstPct, CInt(DepositCommittmentAmt), curMonth, acctNum, rowLastSDABal, rowServ, rowTerm, tbl, goalAmtRow, lastRow, blnNeedsMore, sda, lastRowAmt, goal, rowSDABal, lastSDABal, acctsToSettle)

            acctsToSettle -= 1

            rowSDABal("col1") = "SDA bal"
            tbl.Rows.Add(rowSDABal)
            rowLastSDABal = rowSDABal

            acctNum += 1
        Next 'acct

        Dim totalSettCost As Double

        For Each pct As String In lstPct
            Dim colName As String = String.Format("{0} %", CInt(Val(pct) * 100))
            totalSettCost = Val(rowSett(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowFees(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowInitFees(colName).ToString.Replace("$", "").Replace(",", ""))
            rowCost(colName) = FormatCurrency(totalSettCost, 0)
            Dim fee2tot As Double = Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowInitFees(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowFees(colName).ToString.Replace("$", "").Replace(",", ""))
            rowFee2Cost(colName) = FormatPercent(fee2tot / totalSettCost, 2)
        Next

        For Each pct As String In lstPct
            Dim colName As String = String.Format("{0} %", CInt(Val(pct) * 100))
            rowTermYears(colName) = FormatYearMonthTimeframe(Val(rowTerm(colName).ToString))
        Next

        Return tblSummary
    End Function

    Private Sub CalculateItemRows(ByVal lstPct As String(), ByVal depCommittmentAmt As Double, ByRef curMonth As Integer, ByVal acctNum As Integer, ByVal rowLastSDABal As Data.DataRow, ByVal rowServ As Data.DataRow, ByVal rowTerm As Data.DataRow, ByVal tbl As Data.DataTable, ByVal goalAmtRow As Data.DataRow, ByRef lastRow As Data.DataRow, ByRef blnNeedsMore As Boolean, ByRef sda As Double, ByRef lastRowAmt As String, ByRef goal As Double, ByVal rowSDABal As Data.DataRow, ByRef lastSDABal As Double, ByVal numacctstosettle As Integer)
        Dim monthlyDepositAfterFees As Double = 0
        Dim monthlyFee As Double

        'TODO monthly fee per account get the value here.

        If _NewModel Then
            monthlyFee = (MonthlyFeePerAcct)
        Else
            monthlyFee = MonthlyFeePerAcct '* numacctstosettle  'per acct fee x number of accts
        End If

        While blnNeedsMore
            blnNeedsMore = False
            Dim row As DataRow = tbl.NewRow
            row("col1") = String.Format("Month {0}", curMonth)

            For Each pct As String In lstPct
                'get column percentage name
                Dim colName As String = String.Format("{0} %", CInt(Val(pct) * 100))

                ' jhope 9/23/2010
                'If Not _NewModel Then
                '    If monthlyFee > ServiceFeeCap Then      'monthly fee can never be greater than cap
                '        monthlyFee = ServiceFeeCap
                '    End If
                'End If

                'get available deposit amount after fees
                monthlyDepositAfterFees = depCommittmentAmt - monthlyFee

                'exit if fee is more than more than deposit
                If monthlyFee > depCommittmentAmt Then
                    Exit While
                End If

                If curMonth = 1 Then
                    If acctNum > 1 Then
                        'factor in sda bal from prev settlement
                        lastSDABal = Val(rowLastSDABal(colName).ToString.Replace("$", "").Replace(",", ""))
                        sda = monthlyDepositAfterFees + lastSDABal
                    ElseIf acctNum = 1 Then
                        'the first account gets the initial deposit
                        sda = monthlyDepositAfterFees + InitialDeposit
                    Else
                        sda = monthlyDepositAfterFees
                    End If
                    lastRowAmt = ""
                Else
                    lastRow = tbl.Rows(curMonth)
                    lastRowAmt = lastRow(colName).ToString.Replace("$", "").Replace(",", "")
                    sda = monthlyDepositAfterFees + Val(lastRowAmt)
                End If

                goal = Val(goalAmtRow(colName).ToString.Replace("$", "").Replace(",", ""))

                If sda < goal AndAlso lastRowAmt <> "-" Then
                    row(colName) = FormatCurrency(sda, 0)
                    blnNeedsMore = True
                    rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 0)
                Else
                    If lastRowAmt = "-" Then
                        row(colName) = "-"
                    ElseIf Val(lastRowAmt) > goal Then
                        rowSDABal(colName) = FormatCurrency(Val(lastRowAmt) - goal, 0) 'left over sda for next acct to settle
                        row(colName) = "-"
                        rowTerm(colName) = CInt(rowTerm(colName)) + curMonth - 1
                    Else
                        row(colName) = FormatCurrency(sda, 0)
                        blnNeedsMore = True
                        rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 0)
                    End If
                End If
            Next

            tbl.Rows.Add(row)
            curMonth += 1
            If curMonth > MaxMonths Then Exit While
        End While
    End Sub

    Private Function FormatYearMonthTimeframe(ByVal numberOfMonths As Integer) As String
        Dim iYears As Integer = Math.Floor(numberOfMonths / 12)
        Dim iMonths As Integer = numberOfMonths - (iYears * 12)
        Dim tempString As String = String.Format("{0} yrs {1} mos", iYears, iMonths)

        Return tempString
    End Function

    Private Function GetListPct() As String()
        Dim lst As New List(Of String)
        Dim lstVals As String = SqlHelper.ExecuteScalar("select Value from tblProperty where Name = 'EnrollmentPercentages'", CommandType.Text)
        lst.AddRange(lstVals.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries))
        Return lst.ToArray
    End Function

    Public Sub LoadClientData()
        If ApplicantID > 0 Then
            IsNewModel(ApplicantID)
            Dim sb As New System.Text.StringBuilder()

            Select Case _UseLeadData
                Case False
                    sb.AppendLine("select ")
                    sb.AppendLine("TotalDebt = (select sum(a.currentamount) from tblaccount a where a.clientid = c.clientid and a.accountstatusid <> 55 and not (a.accountstatusid = 54 and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))) ")
                    sb.AppendLine(",NumAccts = (select count(*) from tblaccount a where a.clientid = c.clientid and a.accountstatusid <> 55 and not (a.accountstatusid = 54 and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))) ")
                    sb.AppendLine(",c.InitialDraftAmount as InitialDeposit ")
                    sb.AppendLine(",DepositCommittment = Case When c.MultiDeposit = 1 Then ")
                    sb.AppendLine("(Select sum(d.DepositAmount) From tblClientDepositDay d Where d.DeletedDate is Null and d.ClientId=c.ClientId) ")
                    sb.AppendLine("Else c.DepositAmount End ")
                    sb.AppendLine("from tblclient c ")
                    sb.AppendFormat("where c.clientid = {0}", ApplicantID)
                    Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sb.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
                        For Each row As DataRow In dt.Rows
                            If CInt(row("NumAccts")) > 0 Then
                                Double.TryParse(row("InitialDeposit").ToString, InitialDeposit)
                                Double.TryParse(row("DepositCommittment").ToString, DepositCommittment)
                                Double.TryParse(row("TotalDebt").ToString, TotalDebt)
                                Integer.TryParse(row("NumAccts").ToString, TotalNumberOfAccts)
                            End If
                            Exit For
                        Next
                    End Using

                Case True
                    sb.AppendFormat("Select TotalDebt=(SELECT sum(balance) FROM tblLeadcreditorinstance WHERE LeadApplicantID =  lc.LeadApplicantID), TotalAccts=(SELECT count(*) FROM tblLeadcreditorinstance WHERE LeadApplicantID =  lc.LeadApplicantID) ,lc.InitialDeposit, lc.DepositCommittment From tblLeadCalculator lc Where leadapplicantid = {0}", ApplicantID)
                    Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sb.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
                        For Each row As DataRow In dt.Rows
                            If CInt(row("TotalAccts")) > 0 Then
                                Double.TryParse(row("InitialDeposit").ToString, InitialDeposit)
                                Double.TryParse(row("DepositCommittment").ToString, DepositCommittment)
                                Double.TryParse(row("TotalDebt").ToString, TotalDebt)
                                Integer.TryParse(row("TotalAccts").ToString, TotalNumberOfAccts)
                            End If
                            Exit For
                        Next
                    End Using

            End Select
        End If


    End Sub

#End Region 'Methods

#Region "Nested Types"

    Public Structure CalculatorClient

#Region "Fields"

        Public CliendId As Integer
        Public EstimatedGrowth As Double
        Public InitialDeposit As Double
        Public NumberAccounts As Integer
        Public PBMAPR As Double
        Public PBMMinPay As Double
        Public PBMMinPayPct As Double
        Public RegularDeposit As Double
        Public ServiceFeeCap As Double
        Public ServiceFeePerAcct As Double
        Public SettlementFeePercent As Double
        Public TotalDebt As Double
        Public ProuctID As Integer

#End Region 'Fields

    End Structure

    Public Class CalcProperties

#Region "Fields"

        Private _EnrollmentCurrentPct As Double
        Private _EnrollmentInflation As Double
        Private _EnrollmentMaxPct As Double
        Private _EnrollmentMinDeposit As Double
        Private _EnrollmentMinPct As Double
        Private _EnrollmentPBMAPR As Double
        Private _EnrollmentPBMMinimum As Double
        Private _EnrollmentPBMPercentage As Double
        Private _MaxServiceFeeAmt As String
        Private _PerAcctServiceFeeAmt As String
        Private _SettlementFeePct As Double
        Private _TruthInServiceDepositHighPct As Double
        Private _TruthInServiceDepositLowPct As Double

#End Region 'Fields

#Region "Properties"

        Public Property EnrollmentCurrentPct() As Double
            Get
                Return _EnrollmentCurrentPct
            End Get
            Set(ByVal value As Double)
                _EnrollmentCurrentPct = value
            End Set
        End Property

        Public Property EnrollmentInflation() As Double
            Get
                Return _EnrollmentInflation
            End Get
            Set(ByVal value As Double)
                _EnrollmentInflation = value
            End Set
        End Property

        Public Property EnrollmentMaxPct() As Double
            Get
                Return _EnrollmentMaxPct
            End Get
            Set(ByVal value As Double)
                _EnrollmentMaxPct = value
            End Set
        End Property

        Public Property EnrollmentMinDeposit() As Double
            Get
                Return _EnrollmentMinDeposit
            End Get
            Set(ByVal value As Double)
                _EnrollmentMinDeposit = value
            End Set
        End Property

        Public Property EnrollmentMinPct() As Double
            Get
                Return _EnrollmentMinPct
            End Get
            Set(ByVal value As Double)
                _EnrollmentMinPct = value
            End Set
        End Property

        Public Property EnrollmentPBMAPR() As Double
            Get
                Return _EnrollmentPBMAPR
            End Get
            Set(ByVal value As Double)
                _EnrollmentPBMAPR = value
            End Set
        End Property

        Public Property EnrollmentPBMMinimum() As Double
            Get
                Return _EnrollmentPBMMinimum
            End Get
            Set(ByVal value As Double)
                _EnrollmentPBMMinimum = value
            End Set
        End Property

        Public Property EnrollmentPBMPercentage() As Double
            Get
                Return _EnrollmentPBMPercentage
            End Get
            Set(ByVal value As Double)
                _EnrollmentPBMPercentage = value
            End Set
        End Property

        Public Property MaxServiceFeeAmt() As String
            Get
                Return _MaxServiceFeeAmt
            End Get
            Set(ByVal value As String)
                _MaxServiceFeeAmt = value
            End Set
        End Property

        Public Property PerAcctServiceFeeAmt() As String
            Get
                Return _PerAcctServiceFeeAmt
            End Get
            Set(ByVal value As String)
                _PerAcctServiceFeeAmt = value
            End Set
        End Property

        Public Property SettlementFeePct() As Double
            Get
                Return _SettlementFeePct
            End Get
            Set(ByVal value As Double)
                _SettlementFeePct = value
            End Set
        End Property

        Public Property TruthInServiceDepositHighPct() As Double
            Get
                Return _TruthInServiceDepositHighPct
            End Get
            Set(ByVal value As Double)
                _TruthInServiceDepositHighPct = value
            End Set
        End Property

        Public Property TruthInServiceDepositLowPct() As Double
            Get
                Return _TruthInServiceDepositLowPct
            End Get
            Set(ByVal value As Double)
                _TruthInServiceDepositLowPct = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        Public Shared Function LoadProperties() As CalcProperties
            Dim cp As New CalcProperties
            Dim ssql As New StringBuilder
            ssql.Append("select [EnrollmentDepositMinimum] = (select value from tblproperty where [Name] = 'EnrollmentDepositMinimum')")
            ssql.Append(",[EnrollmentDepositPercentage] = (select value from tblproperty where [Name] = 'EnrollmentDepositPercentage')")
            ssql.Append(",[EnrollmentDepositPercentageMax]= (select value from tblproperty where [Name] = 'EnrollmentDepositPercentageMax')")
            ssql.Append(",[EnrollmentDepositCurrentPct]= (select value from tblproperty where [Name] = 'EnrollmentDepositCurrentPct')")
            ssql.Append(",[EnrollmentInflation]= (select value from tblproperty where [Name] = 'EnrollmentInflation')") '*****************************
            ssql.Append(",[EnrollmentPBMAPR]= (select value from tblproperty where [Name] = 'EnrollmentPBMAPR')")
            ssql.Append(",[EnrollmentSettlementPercentage]= (select top 1 value from tblproperty where [Name] = 'EnrollmentSettlementPercentage')")
            ssql.Append(",[EnrollmentPBMMinimum]= (select value from tblproperty where [Name] = 'EnrollmentPBMMinimum')")
            ssql.Append(",[EnrollmentPBMPercentage]= (select value from tblproperty where [Name] = 'EnrollmentPBMPercentage')")
            ssql.Append(",[EnrollmentMaintenanceFeeCap] = (select value from tblproperty where [Name] = 'EnrollmentMaintenanceFeeCap')")
            ssql.Append(",[EnrollmentAddAccountFee2] = (select value from tblproperty where [Name] = 'EnrollmentAddAccountFee2')")
            ssql.Append(",[TruthInServiceDepositHighPct] = (select value from tblproperty where [Name] = 'TruthInServiceDepositHighPct')")
            ssql.Append(",[TruthInServiceDepositLowPct] = (select value from tblproperty where [Name] = 'TruthInServiceDepositLowPct')")

            Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each var As DataRow In dt.Rows
                    cp.EnrollmentMinDeposit = var("EnrollmentDepositMinimum")
                    cp.EnrollmentMinPct = var("EnrollmentDepositPercentage")
                    cp.EnrollmentMaxPct = var("EnrollmentDepositPercentageMax")
                    cp.EnrollmentCurrentPct = var("EnrollmentDepositCurrentPct")
                    cp.EnrollmentInflation = var("EnrollmentInflation")
                    cp.EnrollmentPBMAPR = var("EnrollmentPBMAPR")
                    cp.EnrollmentPBMMinimum = var("EnrollmentPBMMinimum")
                    cp.EnrollmentPBMPercentage = var("EnrollmentPBMPercentage")
                    cp.SettlementFeePct = var("EnrollmentSettlementPercentage")
                    cp.PerAcctServiceFeeAmt = var("EnrollmentAddAccountFee2")
                    cp.MaxServiceFeeAmt = var("EnrollmentMaintenanceFeeCap")
                    cp.TruthInServiceDepositHighPct = var("TruthInServiceDepositHighPct")
                    cp.TruthInServiceDepositLowPct = var("TruthInServiceDepositLowPct")
                    Exit For
                Next
            End Using

            Return cp
        End Function

#End Region 'Methods

    End Class

    Public Class ExampleData

#Region "Fields"

        Private _EstDebtBal As String
        Private _StartingDebtBal As String
        Private _TotalAccts As String

#End Region 'Fields

#Region "Properties"

        Public Property EstDebtBal() As Double
            Get
                Return _EstDebtBal
            End Get
            Set(ByVal value As Double)
                _EstDebtBal = value
            End Set
        End Property

        Public Property StartingDebtBal() As String
            Get
                Return _StartingDebtBal
            End Get
            Set(ByVal value As String)
                _StartingDebtBal = value
            End Set
        End Property

        Public Property TotalAccts() As String
            Get
                Return _TotalAccts
            End Get
            Set(ByVal value As String)
                _TotalAccts = value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class MinimumPaymentData

#Region "Fields"

        Private _NumberOfMonths As Integer
        Private _NumberOfYears As Integer
        Private _TotalAmountPaid As String
        Private _TotalInterest As String
        Private _TotalPrinciple As String

#End Region 'Fields

#Region "Properties"

        Public Property NumberOfMonths() As Integer
            Get
                Return _NumberOfMonths
            End Get
            Set(ByVal value As Integer)
                _NumberOfMonths = value
            End Set
        End Property

        Public Property NumberOfYears() As Integer
            Get
                Return _NumberOfYears
            End Get
            Set(ByVal value As Integer)
                _NumberOfYears = value
            End Set
        End Property

        Public Property TotalAmountPaid() As String
            Get
                Return _TotalAmountPaid
            End Get
            Set(ByVal value As String)
                _TotalAmountPaid = value
            End Set
        End Property

        Public Property TotalInterest() As String
            Get
                Return _TotalInterest
            End Get
            Set(ByVal value As String)
                _TotalInterest = value
            End Set
        End Property

        Public Property TotalPrinciple() As String
            Get
                Return _TotalPrinciple
            End Get
            Set(ByVal value As String)
                _TotalPrinciple = value
            End Set
        End Property

#End Region 'Properties

    End Class

#End Region 'Nested Types

End Class