Imports System.Collections.Generic

Partial Class newmodel
    Inherits System.Web.UI.Page

    Dim lstAccts As New List(Of Double)
    Dim total As Double = 0.0

    Private Enum ModelType
        CURRENT
        NEWMODEL
        CURRENTRETFEE
        PBM
        PBM1
    End Enum

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            DoCalcs()
        End If
    End Sub

    Protected Sub btnCalc_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCalc.Click
        DoCalcs()
    End Sub

    Private Sub DoCalcs()
        GetAcctTextboxes(Me)
        lblAccts.Text = lstAccts.Count
        lbltotaldebtamt.Text = Format(total, "###,##0.00")

        'Dim containerNew As New AjaxControlToolkit.TabContainer
        Dim containerNewLifecycle As New AjaxControlToolkit.TabContainer
        'Dim containerCur As New AjaxControlToolkit.TabContainer
        Dim containerCurLifeycle As New AjaxControlToolkit.TabContainer
        Dim containerRet As New AjaxControlToolkit.TabContainer
        Dim containerPBMV As New AjaxControlToolkit.TabContainer
        Dim containerPBMV1 As New AjaxControlToolkit.TabContainer
        Dim tblNewModel As Data.DataTable

        ''new model summary
        'tblNewModel = CalcModel(ModelType.NEWMODEL, containerNew)
        'gvNewSummary.DataSource = tblNewModel
        'gvNewSummary.ShowHeader = False
        'gvNewSummary.DataBind()
        'gvNewSummary.Rows(0).Style.Item("background-color") = "#CEE3FF"
        'For i As Integer = 1 To gvNewSummary.Rows.Count - 1
        '    gvNewSummary.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        'Next

        ''new model acct detail tabs
        'phNewDetail.Controls.Add(containerNew)


        '***************************
        'new model summary LIFECYCLE
        tblNewModel = CalcModel(ModelType.NEWMODEL, containerNewLifecycle, True)
        gvNewLifecycle.DataSource = tblNewModel
        gvNewLifecycle.ShowHeader = False
        gvNewLifecycle.DataBind()
        gvNewLifecycle.Rows(0).Style.Item("background-color") = "#CEE3FF"
        For i As Integer = 1 To gvNewLifecycle.Rows.Count - 1
            gvNewLifecycle.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        Next

        'new model acct detail tabs LIFECYCLE
        phNewLifecycle.Controls.Add(containerNewLifecycle)


        'total settlement cost comparison at different deposit commitments
        Dim monthlyDeposit As Double = Val(txtdepcommit.Text)
        Dim tblSummary As Data.DataTable
        Dim tblCompare As New Data.DataTable
        Dim row As Data.DataRow
        Dim rowPct As Data.DataRow
        Dim settFrom As Double = Val(txtSettFrom.Text)
        Dim settTo As Double = Val(txtSettTo.Text)
        Dim incr As Double = Val(txtIncr.Text)
        Dim colName As String

        tblCompare = tblNewModel.Clone
        rowPct = tblCompare.NewRow
        rowPct("col1") = ""

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            rowPct(colName) = Format(pct, "#0.##") & "%"
        Next

        tblCompare.Rows.Add(rowPct)

        For deposit As Double = (monthlyDeposit - 100) To (monthlyDeposit + 100) Step 50
            txtdepcommit.Text = deposit
            tblSummary = CalcModel(ModelType.NEWMODEL, Nothing, True)
            row = tblSummary.Rows(5)
            row("col1") = FormatCurrency(deposit, 2)
            tblCompare.ImportRow(row)
        Next

        txtdepcommit.Text = monthlyDeposit
        gvCompare.DataSource = tblCompare
        gvCompare.ShowHeader = False
        gvCompare.DataBind()
        gvCompare.Rows(0).Style.Item("background-color") = "#CEE3FF"
        For i As Integer = 1 To gvCompare.Rows.Count - 1
            gvCompare.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        Next


        ''*********************
        ''current model summary
        'gvCurrentSummary.DataSource = CalcModel(ModelType.CURRENT, containerCur)
        'gvCurrentSummary.ShowHeader = False
        'gvCurrentSummary.DataBind()
        'gvCurrentSummary.Rows(0).Style.Item("background-color") = "#CEE3FF"
        'For i As Integer = 1 To gvCurrentSummary.Rows.Count - 1
        '    gvCurrentSummary.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        'Next

        ''new model acct detail tabs
        'phCurrentDetail.Controls.Add(containerCur)


        '*********************
        'current model summary LIFECYCLE
        gvCurrentLifecycle.DataSource = CalcModel(ModelType.CURRENT, containerCurLifeycle, True)
        gvCurrentLifecycle.ShowHeader = False
        gvCurrentLifecycle.DataBind()
        gvCurrentLifecycle.Rows(0).Style.Item("background-color") = "#CEE3FF"
        For i As Integer = 1 To gvCurrentLifecycle.Rows.Count - 1
            gvCurrentLifecycle.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        Next

        'new model acct detail tabs LIFECYCLE
        phCurrentLifecycle.Controls.Add(containerCurLifeycle)


        '**********************
        'retainer model summary
        GridView3.DataSource = CalcModelRet(containerRet)
        GridView3.ShowHeader = False
        GridView3.DataBind()
        GridView3.Rows(0).Style.Item("background-color") = "#CEE3FF"
        For i As Integer = 1 To GridView3.Rows.Count - 1
            GridView3.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        Next

        'retainer model detail tabs
        PlaceHolder3.Controls.Add(containerRet)


        'PBM variable
        GridView4.DataSource = Me.CalcPBMVar(ModelType.PBM, containerPBMV)
        GridView4.ShowHeader = False
        GridView4.DataBind()
        GridView4.Rows(0).Style.Item("background-color") = "#CEE3FF"
        For i As Integer = 1 To GridView4.Rows.Count - 1
            GridView4.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        Next

        PlaceHolder4.Controls.Add(containerPBMV)


        'PBM 1-pymt
        GridView5.DataSource = Me.CalcPBMVar(ModelType.PBM1, containerPBMV1)
        GridView5.ShowHeader = False
        GridView5.DataBind()
        GridView5.Rows(0).Style.Item("background-color") = "#CEE3FF"
        For i As Integer = 1 To GridView5.Rows.Count - 1
            GridView5.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        Next

        PlaceHolder5.Controls.Add(containerPBMV1)

    End Sub

    Private Function CalcModel(ByVal modeType As ModelType, ByRef container As AjaxControlToolkit.TabContainer, Optional ByVal blnLifecycle As Boolean = False) As Data.DataTable
        Dim settFrom As Double = Val(txtSettFrom.Text)
        Dim settTo As Double = Val(txtSettTo.Text)
        Dim incr As Double = Val(txtIncr.Text)
        Dim monthlyDeposit As Double = Val(txtdepcommit.Text)
        Dim estGrowth As Double = Val(txtestgrowth.Text) / 100
        Dim totalDebtAtSettl As Double = (estGrowth * total) + total
        Dim settFeePct As Double = Val(txtSettlementFee.Text) / 100
        Dim panel As AjaxControlToolkit.TabPanel
        Dim gv As GridView
        Dim curMonth As Integer
        Dim monthlyFee As Double
        Dim monthlyDepositAfterFees As Double
        Dim colName As String
        Dim acctNum As Integer = 1
        Dim acctsToSettle As Integer = lstAccts.Count
        Dim cap As Double = Val(txtcap.Text)
        Dim perAcctFee As Double = Val(txtfeeperacct.Text)
        Dim rowLastSDABal As Data.DataRow
        Dim tblSummary As New Data.DataTable
        Dim rowPct, rowTot, rowSett, rowFees, rowServ, rowCost, rowTerm As Data.DataRow
        Dim settPct, settFees, settFee As Double
        Dim firstYrMaintFee As Double = Val(txtFirstYrMaintFee.Text)
        Dim subseqMaintFee As Double = Val(txtSubMaintFee.Text)


        tblSummary.Columns.Add("col1", GetType(System.String))

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            tblSummary.Columns.Add(colName, GetType(System.String))
        Next

        'new model summary rows
        rowPct = tblSummary.NewRow
        rowPct("col1") = "" 'Service Fee Per Acct
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
        rowTerm("col1") = "Term (months)"

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            rowPct(colName) = Format(pct, "#0.##") & "%"
            rowTot(colName) = FormatCurrency(totalDebtAtSettl, 2)
            settPct = totalDebtAtSettl * (pct / 100)
            rowSett(colName) = FormatCurrency(settPct, 2)
            settFees = (totalDebtAtSettl - settPct) * settFeePct
            rowFees(colName) = FormatCurrency(settFees, 2)
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

        ' **should be sorted smallest acct first
        For Each acct As Double In lstAccts
            Dim lbl As New Label
            Dim withGrowth As Double = (estGrowth * acct) + acct
            Dim tbl As New Data.DataTable

            lbl.Text = String.Format("Acct {0} ${1} (with est growth)", acctNum, Format(withGrowth, "###,##0.00"))

            panel = New AjaxControlToolkit.TabPanel
            panel.HeaderText = String.Format("Acct {0}", acctNum)
            panel.Controls.Add(lbl)
            panel.Controls.Add(New LiteralControl("<br/><br/>Goal Amt = Settl % of Acct Amt w/ est growth + Settlement Fee<br/>"))
            panel.Controls.Add(New LiteralControl("Month 1 = Deposit commitment after fees + carryover SDA bal<br/><br/>"))

            tbl.Columns.Add("col1", GetType(System.String))

            For pct As Double = settFrom To settTo Step incr
                colName = String.Format("col{0}", CInt(pct))
                tbl.Columns.Add(colName, GetType(System.String))
            Next

            Dim rowGoalAmt As Data.DataRow = tbl.NewRow
            Dim rowSettPct As Data.DataRow = tbl.NewRow
            Dim goalAmt As Double

            rowGoalAmt("col1") = "Goal Amt"
            rowSettPct("col1") = "Settl %"

            For pct As Double = settFrom To settTo Step incr
                colName = String.Format("col{0}", CInt(pct))
                goalAmt = withGrowth * (pct / 100)
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

                For pct As Double = settFrom To settTo Step incr
                    colName = String.Format("col{0}", CInt(pct))

                    '*** this is the only difference between the two models
                    Select Case modeType
                        Case ModelType.NEWMODEL
                            monthlyFee = (perAcctFee * acctsToSettle)
                            If monthlyFee > cap Then
                                monthlyFee = cap
                            End If

                            monthlyDepositAfterFees = monthlyDeposit - monthlyFee
                        Case ModelType.CURRENT
                            If curMonth < 13 Then
                                monthlyFee = firstYrMaintFee
                            Else
                                monthlyFee = subseqMaintFee
                            End If

                            monthlyDepositAfterFees = monthlyDeposit - monthlyFee
                    End Select
                    '***

                    If monthlyFee > monthlyDeposit Then
                        panel.Controls.Add(New LiteralControl(String.Format("<font color='red'>MONTHLY FEE {0} IS GREATER THAN DEPOSIT {1}</font><br/>", monthlyFee, monthlyDeposit)))
                        Exit While
                    End If

                    If curMonth = 1 Then
                        If blnLifecycle And acctNum > 1 Then
                            'factor in sda bal from prev settlement
                            lastSDABal = Val(rowLastSDABal(colName).ToString.Replace("$", "").Replace(",", ""))
                            sda = monthlyDepositAfterFees + lastSDABal
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
                        row(colName) = FormatCurrency(sda, 2)
                        blnNeedsMore = True
                        rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 2)
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
                            rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 2)
                        End If
                    End If
                Next

                tbl.Rows.Add(row)
                curMonth += 1
                If curMonth > 400 Then
                    Exit While
                End If
            End While

            acctsToSettle -= 1

            rowSDABal("col1") = "SDA bal"
            tbl.Rows.Add(rowSDABal)
            rowLastSDABal = rowSDABal

            gv = New GridView
            gv.DataSource = tbl
            gv.ShowHeader = False
            gv.DataBind()
            gv.Rows(1).Style.Item("background-color") = "#CEE3FF"
            For i As Integer = 2 To gv.Rows.Count - 1
                gv.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
            Next

            panel.Controls.Add(gv)
            If Not IsNothing(container) Then
                container.Tabs.Add(panel)
            End If

            acctNum += 1
        Next 'acct

        Dim totalSettCost As Double

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            totalSettCost = Val(rowSett(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowFees(colName).ToString.Replace("$", "").Replace(",", ""))
            rowCost(colName) = FormatCurrency(totalSettCost)
        Next

        Return tblSummary
    End Function

    Private Function CalcModelRet(ByRef container As AjaxControlToolkit.TabContainer) As Data.DataTable
        Dim settFrom As Double = Val(txtSettFrom.Text)
        Dim settTo As Double = Val(txtSettTo.Text)
        Dim incr As Double = Val(txtIncr.Text)
        Dim monthlyDeposit As Double = Val(txtdepcommit.Text)
        Dim estGrowth As Double = Val(txtestgrowth.Text) / 100
        Dim totalDebtAtSettl As Double = (estGrowth * total) + total
        Dim settFeePct As Double = Val(txtSettlementFee.Text) / 100
        Dim panel As AjaxControlToolkit.TabPanel
        Dim gv As GridView
        Dim curMonth As Integer
        Dim monthlyFee As Double = Val(txtMaintenceFee.Text)
        Dim monthlyDepositAfterFees As Double
        Dim colName As String
        Dim acctNum As Integer = 1
        Dim acctsToSettle As Integer = lstAccts.Count
        Dim cap As Double = Val(txtcap.Text)
        Dim perAcctFee As Double = Val(txtfeeperacct.Text)
        Dim tblSummary As New Data.DataTable
        Dim rowPct, rowTot, rowSett, rowFees, rowServ, rowCost, rowTerm, rowRetFee As Data.DataRow
        Dim settPct, settFees As Double
        Dim totalRetFee As Double = total * Val(txtRetainerFee.Text) / 100

        tblSummary.Columns.Add("col1", GetType(System.String))

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            tblSummary.Columns.Add(colName, GetType(System.String))
        Next

        'new model summary rows
        rowPct = tblSummary.NewRow
        rowPct("col1") = "" 'Service Fee Per Acct
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
        rowTerm("col1") = "Term (months)"
        rowRetFee = tblSummary.NewRow
        rowRetFee("col1") = "Total Retainer Fees"

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            rowPct(colName) = Format(pct, "#0.##") & "%"
            rowTot(colName) = FormatCurrency(totalDebtAtSettl, 2)
            settPct = totalDebtAtSettl * (pct / 100)
            rowSett(colName) = FormatCurrency(settPct, 2)
            settFees = (totalDebtAtSettl - settPct) * settFeePct
            rowFees(colName) = FormatCurrency(settFees, 2)
            rowServ(colName) = "0"
            rowCost(colName) = "0"
            rowTerm(colName) = "0"
            rowRetFee(colName) = FormatCurrency(totalRetFee, 2)
        Next

        tblSummary.Rows.Add(rowPct)
        tblSummary.Rows.Add(rowTot)
        tblSummary.Rows.Add(rowSett)
        tblSummary.Rows.Add(rowServ)
        tblSummary.Rows.Add(rowFees)
        tblSummary.Rows.Add(rowRetFee)
        tblSummary.Rows.Add(rowCost)
        tblSummary.Rows.Add(rowTerm)

        Dim lbl As New Label
        Dim tbl As New Data.DataTable

        lbl.Text = String.Format("All accts ${0} (with est growth)", Format(totalDebtAtSettl, "###,##0.00"))

        panel = New AjaxControlToolkit.TabPanel
        panel.HeaderText = "Amortization"
        panel.Controls.Add(lbl)
        panel.Controls.Add(New LiteralControl("<br/><br/>Goal Amt = Ret Fees + Settl % of Accts Amt w/ est growth + Settlement Fees<br/><br/>"))


        tbl.Columns.Add("col1", GetType(System.String))

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            tbl.Columns.Add(colName, GetType(System.String))
        Next

        Dim rowGoalAmt As Data.DataRow = tbl.NewRow
        Dim rowSettPct As Data.DataRow = tbl.NewRow
        Dim goalAmt As Double

        rowGoalAmt("col1") = "Goal Amt"
        rowSettPct("col1") = "Settl %"

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            goalAmt = (totalDebtAtSettl * (pct / 100)) + (totalDebtAtSettl - totalDebtAtSettl * (pct / 100)) * settFeePct + totalRetFee
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

        curMonth = 1

        While blnNeedsMore
            blnNeedsMore = False
            row = tbl.NewRow
            row("col1") = String.Format("Month {0}", curMonth)

            For pct As Double = settFrom To settTo Step incr

                colName = String.Format("col{0}", CInt(pct))

                If monthlyFee > monthlyDeposit Then
                    panel.Controls.Add(New LiteralControl(String.Format("<font color='red'>MONTHLY FEE {0} IS GREATER THAN DEPOSIT {1}</font><br/>", monthlyFee, monthlyDeposit)))
                    Exit While
                End If

                monthlyDepositAfterFees = monthlyDeposit - monthlyFee

                If curMonth = 1 Then
                    sda = monthlyDepositAfterFees
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
                    rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 2)
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
                        rowServ(colName) = FormatCurrency(Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) + monthlyFee, 2)
                    End If
                End If

            Next

            tbl.Rows.Add(row)
            curMonth += 1
            If curMonth > 400 Then
                Exit While
            End If
        End While


        rowSDABal("col1") = "SDA bal"
        tbl.Rows.Add(rowSDABal)

        gv = New GridView
        gv.DataSource = tbl
        gv.ShowHeader = False
        gv.DataBind()
        gv.Rows(1).Style.Item("background-color") = "#CEE3FF"
        For i As Integer = 2 To gv.Rows.Count - 1
            gv.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
        Next

        panel.Controls.Add(gv)
        container.Tabs.Add(panel)

        Dim totalSettCost As Double

        For pct As Double = settFrom To settTo Step incr
            colName = String.Format("col{0}", CInt(pct))
            totalSettCost = Val(rowSett(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowServ(colName).ToString.Replace("$", "").Replace(",", "")) _
                            + Val(rowFees(colName).ToString.Replace("$", "").Replace(",", ""))
            rowCost(colName) = FormatCurrency(totalSettCost)
        Next

        Return tblSummary
    End Function

    Private Sub GetAcctTextboxes(ByVal cnt As Control)
        If cnt.GetType().ToString = GetType(TextBox).ToString Then
            If cnt.ID.Contains("txtAcct") Then
                Dim amt As Double = Val(CType(cnt, TextBox).Text)
                If amt > 0 Then
                    lstAccts.Add(amt)
                    total += amt
                End If
            End If
        Else
            For Each childControl As Control In cnt.Controls
                GetAcctTextboxes(childControl)
            Next
        End If
    End Sub

    Private Function CalcPBMVar(ByVal modelType As ModelType, ByVal container As AjaxControlToolkit.TabContainer) As Data.DataTable
        Dim accNum As Integer = 1

        Dim tblSummary As New Data.DataTable
        tblSummary.Columns.Add(New Data.DataColumn("Col1", GetType(System.String)))
        tblSummary.Columns.Add(New Data.DataColumn("Months", GetType(System.String)))
        tblSummary.Columns.Add(New Data.DataColumn("TotalPaid", GetType(System.String)))
        tblSummary.Columns.Add(New Data.DataColumn("Principal", GetType(System.String)))
        tblSummary.Columns.Add(New Data.DataColumn("Interest", GetType(System.String)))
        tblSummary.Rows.Add(New Object() {"", "Months", "Paid", "Principal", "Interest"})

        tblSummary.Rows.Add(CalcPBMVar(modelType, "All Accounts", total, container))

        For Each acct As Double In lstAccts
            CalcPBMVar(modelType, String.Format("Acct {0}", accNum), acct, container)
            accNum += 1
        Next 'acct

        Return tblSummary
    End Function

    Private Function CalcPBMVar(ByVal modelType As ModelType, ByVal Title As String, ByVal TotalDebt As Double, ByVal container As AjaxControlToolkit.TabContainer) As Object()
        Dim balance As Double = TotalDebt
        Dim withgrowth = TotalDebt + (TotalDebt + Val(txtestgrowth.Text) / 100)
        Dim apr As Double = Val(txtinterestrate.Text) / 100
        Dim monthlyAPR As Double = apr / 12
        Dim minPayPct As Double = Val(txtMinPayPct.Text) / 100
        Dim minPay As Double = Val(txtMinPay.Text)
        Dim fixedAmt As Double = Val(txtdepcommit.Text)
        Dim interest As Double
        Dim withinterest As Double
        Dim payment As Double
        Dim curMonth As Integer = 1
        Dim totalPay As Double = 0
        Dim Panel As New AjaxControlToolkit.TabPanel

        Dim tbl As New Data.DataTable
        tbl.Columns.Add(New Data.DataColumn("Month", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Balance", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Interest", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Payment", GetType(System.String)))
        tbl.Columns.Add(New Data.DataColumn("Remain", GetType(System.String)))

        Dim blnNeedsMore As Boolean = True
        Dim row As Data.DataRow

        While balance > 0
            row = tbl.NewRow
            row("Month") = String.Format("Month {0}", curMonth)
            row("Balance") = FormatCurrency(balance, 2)
            interest = balance * monthlyAPR
            withinterest = balance + interest
            row("Interest") = FormatCurrency(withinterest, 2)

            Select Case modelType
                Case newmodel.ModelType.PBM
                    payment = IIf(balance * minPayPct > minPay, balance * minPayPct, minPay)
                Case newmodel.ModelType.PBM1
                    payment = fixedAmt
            End Select

            If interest > payment Then
                Panel.Controls.Add(New LiteralControl(String.Format("<font color='red'>INTEREST {0} IS GREATER THAN PAYMENT {1}</font><br/>", interest, payment)))
                Exit While
            End If

            If balance < payment Then payment = withinterest

            balance = withinterest - payment

            row("Payment") = FormatCurrency(payment, 2)
            row("Remain") = FormatCurrency(balance, 2)
            tbl.Rows.Add(row)

            totalPay += payment
            curMonth += 1
            If curMonth > 400 Then
                Exit While
            End If
        End While

        Dim lbl As New Label

        lbl.Text = String.Format("Total Months: {0} Total Payments: {1:c} = Principal: {2:c} + Interest: {3:c}", curMonth - 1, totalPay, TotalDebt, totalPay - TotalDebt)

        Panel.HeaderText = Title
        Panel.Controls.Add(lbl)
        Panel.Controls.Add(New LiteralControl("<br/><br/><div style='height:300px; overflow:auto'>"))

        If tbl.Rows.Count > 0 Then
            Dim gv As New GridView
            gv.DataSource = tbl
            gv.ShowHeader = True
            gv.DataBind()
            gv.HeaderRow.Style.Item("background-color") = "#CEE3FF"

            For i As Integer = 0 To gv.Rows.Count - 1
                gv.Rows(i).Cells(0).Style.Item("background-color") = "#C4D8F2"
            Next

            Panel.Controls.Add(gv)
        End If
        
        Panel.Controls.Add(New LiteralControl("</div>"))
        container.Tabs.Add(Panel)

        Return New Object() {"Total", (curMonth - 1).ToString, totalPay.ToString("c"), TotalDebt.ToString("c"), (totalPay - TotalDebt).ToString("c")}
    End Function

End Class
