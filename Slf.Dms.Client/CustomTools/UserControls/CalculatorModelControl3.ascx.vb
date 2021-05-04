Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Partial Class CalculatorModelControl3
    Inherits System.Web.UI.UserControl

#Region "Fields"

    Private Const MaxMonths As Integer = 2000
    Private _HideAcctPanel As Boolean
    Private _UseLeadData As Boolean
    Private _useFormData As Boolean
    Private cProps As CalcProperties

    Private _Applicant As New Applicant
    Private _Results As New List(Of Results)
    Private _Calculator As SettlementCalculator

#End Region 'Fields

#Region "Properties"

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

    Public Property FixedFeePercentage() As String
        Get
            Return Val(ddlFixedFee.SelectedValue)
        End Get
        Set(value As String)
            Dim li As ListItem
            li = ddlFixedFee.Items.FindByValue(value)
            If Not li Is Nothing Then
                li.Selected = True
            End If
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
            Return CInt(txtTotalDebt.Text)
        End Get
        Set(ByVal value As Integer)
            txtTotalDebt.Text = _Applicant.TotalDebt
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

#End Region 'Properties

#Region "Methods"

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

    Public Function IsClient(ByVal DataClientid As Integer) As Boolean
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("Select LeadApplicantId From tblLeadApplicant Where LeadApplicantId = {0}", DataClientid), ConfigurationManager.AppSettings("connectionstring").ToString)
        If dt.Rows.Count > 0 Then
            Dim newdt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("SELECT LeadApplicantID from vw_LeadApplicant_Client WHERE ClientID = {0}", DataClientid), ConfigurationManager.AppSettings("connectionstring").ToString)
            Return (newdt.Rows.Count > 0)
        End If
        Return False
    End Function

    Public Sub ReCalcModel(Optional ByVal LeadApplicantId As Integer = 0, Optional ByVal useFormData As Boolean = False)
        _useFormData = useFormData
        LoadClientData(LeadApplicantId)
        BuildExampleInfo()
        DisplayCalculator(True)
    End Sub

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
            IsClient(Me.ApplicantID)
            LoadClientData(Me.ApplicantID)
            LoadFixedFeePercentages()

            Dim version As String
            If ApplicantID > 0 Then
                _Applicant = BuildExistingLead(ApplicantID)
                version = GetLSAVersion(Me.ApplicantID)
            Else
                _Applicant = CreateTemporaryLead()
                version = GetLSAVersionDefault()
            End If

            version = GetLSAVersion(Me.ApplicantID)

            _Calculator = SettlementCalculator.Create(version.ToString())
            _Calculator.Applicant = _Applicant
            _Results = _Calculator.Calculate()

            With Me
                .gvExample.Columns(1).Visible = False 'This is the column that is Estimated Debt Balance at time of settlement.
                .dvOldCalc.Visible = False
                .gvExample.Caption = "<div style='text-align:left;background-color:#F0E68C;'><b>Settlement Example<sup>(7)(8)</sup></b></div>"
                .lblMonthlyFee.Text = "Monthly Fee"
                .txtEstGrowth.Text = "0"
                .txtMaintFeePerAcct.Visible = True
                .txtMaintFeePerAcct1.Visible = False
            End With
        End If

    End Sub

    Protected Sub btnCalculate_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnCalculate.Click
        ReCalcModel(Request.QueryString("id"), True)
    End Sub

    Protected Sub ddlFixedFee_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlFixedFee.SelectedIndexChanged
        ReCalcModel(Request.QueryString("id"), True)
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

            If wGrdCreditors.Rows.Count = 0 Then
                total = Val(txtTotalDebt.Text)
            End If

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

        BuildExampleGrid(CalcNewModel(DepositCommittment), DepositCommittment, "Your deposit will be:")
        BuildExampleGrid(CalcNewModel(depLow), depLow, "If you increase your deposit to:")
        BuildExampleGrid(CalcNewModel(depHigh), depHigh, "If you increase your deposit to:")

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

    Private Function CalcNewModel(ByVal DepositCommittmentAmt As Double) As DataTable
        Dim lstPct() As String = GetListPct(_Applicant.LawFirm)
        Dim tblSummary As New Data.DataTable
        Dim rowSett, rowFees, rowCost, rowFee2Cost, rowTerm, rowTermYears As Data.DataRow

        tblSummary.Columns.Add("col1", GetType(System.String))

        For Each pct As String In lstPct
            tblSummary.Columns.Add(String.Format("{0} %", CInt(Val(pct) * 100)), GetType(System.String))
        Next

        rowSett = tblSummary.NewRow
        rowFees = tblSummary.NewRow
        rowCost = tblSummary.NewRow
        rowFee2Cost = tblSummary.NewRow
        rowTerm = tblSummary.NewRow
        rowTermYears = tblSummary.NewRow

        rowSett("col1") = "Resolution Amount<sup>(10)</sup>"
        rowFees("col1") = "Fixed Legal Fee<sup>(11)</sup>"
        rowCost("col1") = "Total Resolution Cost<sup>(12)</sup>"
        rowFee2Cost("col1") = "% Fees to Total Cost<sup>(13)</sup>"
        rowTerm("col1") = "Number of Months<sup>(14)</sup>"
        rowTermYears("col1") = "Number of Years<sup>(15)</sup>"

        tblSummary.Rows.Add(rowSett)
        tblSummary.Rows.Add(rowFees)
        tblSummary.Rows.Add(rowCost)
        tblSummary.Rows.Add(rowFee2Cost)
        tblSummary.Rows.Add(rowTerm)
        tblSummary.Rows.Add(rowTermYears)

        For Each pct As String In lstPct
            Dim colName As String = String.Format("{0} %", CInt(Val(pct) * 100))
            For Each record As Results In _Results
                If record.PercentageOfSettlement = pct AndAlso record.MonthlyDeposit = DepositCommittmentAmt AndAlso DepositCommittment <> 0 Then
                    rowSett(colName) = FormatCurrency(record.SettlementAmount)
                    rowFees(colName) = FormatCurrency(record.SettleFeeAmount)
                    rowCost(colName) = FormatCurrency(record.TotalAmountFees)
                    rowFee2Cost(colName) = record.PercentFeesToCost
                    rowTerm(colName) = record.Months
                    rowTermYears(colName) = record.Years
                End If
            Next
        Next

        Return tblSummary
    End Function

    Private Function GetListPct(ByVal LawFirm As String) As String()
        Dim lst As New List(Of String)
        Dim lstVals As String = ""

        'If LawFirm = "Consumer Law Group" Then
        lstVals = SqlHelper.ExecuteScalar("select Value from tblProperty where Name = 'CLGEnrollmentPercentages'", CommandType.Text)
        'Else
        'lstVals = SqlHelper.ExecuteScalar("select Value from tblProperty where Name = 'EnrollmentPercentages'", CommandType.Text)
        'End If
        lst.AddRange(lstVals.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries))
        Return lst.ToArray
    End Function

    Private Function GetFixedFeeListPct() As String()
        Dim lst As New List(Of String)
        Dim lstVals As String = SqlHelper.ExecuteScalar("select Value from tblProperty where Name = 'EnrollmentFixedFeePercentages'", CommandType.Text)
        lst.AddRange(lstVals.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries))
        Return lst.ToArray
    End Function

    Public Sub LoadClientData(ApplicantID As Integer) 'GetLSAVersionDefault
        'Create An Applicant Class Instance
        Dim version As String
        If ApplicantID > 0 Then
            _Applicant = BuildExistingLead(ApplicantID)
            version = GetLSAVersion(Me.ApplicantID)
        Else
            _Applicant = CreateTemporaryLead()
            version = GetLSAVersionDefault()
        End If

        version = GetLSAVersion(Me.ApplicantID)

        _Calculator = SettlementCalculator.Create(version)
        _Calculator.Applicant = _Applicant
        _Results = _Calculator.Calculate()

        'If Not ApplicantID > 0 Then
        txtMaintFeePerAcct.Text = CInt(_Results(0).MonthlyRecurringFee)
        txtSettlementFeePct.Text = CDbl(_Results(0).SettlementFeePercentage) * 100
        'End If

    End Sub

    Public Sub LoadFixedFeePercentages()
        Dim lstPct() As String = GetFixedFeeListPct()
        For Each pct As String In lstPct
            ddlFixedFee.Items.Add(New ListItem(Integer.Parse((Double.Parse(pct)) * 100).ToString(), pct.ToString))
        Next

        If Me.ApplicantID > 0 Then
            SelectFixedFeePercentage()
        End If
    End Sub

    Public Sub SelectFixedFeePercentage()
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("Select isnull(FixedFeePercentage,'0.50') From tblLeadCalculator Where LeadApplicantId = {0}", Me.ApplicantID), ConfigurationManager.AppSettings("connectionstring").ToString)
        If dt.Rows.Count > 0 Then
            Dim li As ListItem
            li = ddlFixedFee.Items.FindByValue(dt.Rows.Item(0)(0).ToString())
            If Not li Is Nothing Then
                li.Selected = True
            End If
        End If
    End Sub

    Public Function BuildExistingLead(ApplicantID As Integer) As Applicant
        Return New Applicant(ApplicantID)
    End Function

    Public Function CreateTemporaryLead() As Applicant
        Dim temporary As New Applicant()
        temporary.IntitialDeposit = IIf(IsDBNull(txtInitialDeposit.Text), "0.00", txtInitialDeposit.Text)
        temporary.MonthlyDeposit = IIf(IsDBNull(txtDepositComitmment.Text), "0.00", txtDepositComitmment.Text)
        temporary.TotalDebt = IIf(IsDBNull(txtTotalDebt.Text), "0.00", txtTotalDebt.Text)
        Return temporary
    End Function

    Public Function GetLSAVersion(LeadApplicant As Integer) As String
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadApplicantID", LeadApplicant))
        Dim obj As Object = SqlHelper.ExecuteScalar("stp_GetLSAVersionPerClient", CommandType.StoredProcedure, params.ToArray)
        If IsDBNull(obj) Then
            Return "Mossler_20150427"
        Else
            Return CStr(obj)
        End If

    End Function

    Private Function GetLSAVersionDefault() As String
        Return "Mossler_20150427"
    End Function

#End Region 'Methods

#Region "Nested Types"

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
            ssql.Append(",[EnrollmentSettlementPercentage]= (select value from tblproperty where [PropertyId] = 10)")
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