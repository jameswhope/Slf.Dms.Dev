Imports System.Data

Partial Class Clients_Enrollment_NewerModel
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim tbl As New DataTable
            Dim row As DataRow

            tbl.Columns.Add("balance")
            tbl.AcceptChanges()

            For i As Integer = 0 To 5 Step 1
                row = tbl.NewRow
                row(0) = 1666.67
                tbl.Rows.Add(row)
            Next

            gvCreditors.DataSource = tbl
            gvCreditors.DataBind()

            ViewState.Add("tbl", tbl)

            With CalculatorModelControl1
                .EnableVariables()
                .InitialDeposit = 0
                .DepositCommittment = 120
                .ServiceFeeCap = 60
                .MonthlyFeePerAcct = 10
                .SettlementFeePct = 33
                .EstimateGrowthPct = 31
                .InterestRate = 15.27
                .MinPaymentAmt = 15
                .MinPaymentPct = 2.5
                .ApplicantID = -1
                .UseLeadData = True
                .ReCalcModel()
            End With
        End If
    End Sub

    Protected Sub gvCreditors_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCreditors.RowCommand
        Select Case e.CommandName
            Case "Delete"
                Dim tbl As New DataTable
                Dim row As DataRow
                Dim txtBalance As TextBox
                Dim i As Integer

                tbl.Columns.Add("balance")
                tbl.AcceptChanges()

                For Each r As GridViewRow In gvCreditors.Rows
                    If i <> e.CommandArgument Then 'skip the deleted row
                        txtBalance = TryCast(r.FindControl("txtBalance"), TextBox)
                        row = tbl.NewRow
                        row(0) = Val(txtBalance.Text)
                        tbl.Rows.Add(row)
                    End If
                    i += 1
                Next


                gvCreditors.DataSource = tbl
                gvCreditors.DataBind()

                ViewState("tbl") = tbl
                CalculatorModelControl1.ReCalcModel()
        End Select
    End Sub

    Protected Sub lnkAddCreditor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddCreditor.Click
        Dim tbl As New DataTable
        Dim row As DataRow
        Dim txtBalance As TextBox

        tbl.Columns.Add("balance")
        tbl.AcceptChanges()

        For Each r As GridViewRow In gvCreditors.Rows
            txtBalance = TryCast(r.FindControl("txtBalance"), TextBox)
            row = tbl.NewRow
            row(0) = Val(txtBalance.Text)
            tbl.Rows.Add(row)
        Next

        row = tbl.NewRow
        row(0) = 0
        tbl.Rows.Add(row)

        gvCreditors.DataSource = tbl
        gvCreditors.DataBind()

        ViewState("tbl") = tbl
        CalculatorModelControl1.ReCalcModel()
    End Sub

    Protected Sub gvCreditors_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles gvCreditors.RowDeleting

    End Sub
End Class
