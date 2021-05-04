
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports Drg.Util.DataAccess

Namespace admin.Financial

    Partial Class adminFinancialCommissionPayments
        Inherits Page

        Private UserID As Integer
        Private dtPayee As DataTable

#Region "Methods"

        Private Sub PageLoad(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
            If Not IsPostBack Then
                AssignDataToGrids("AgencyPayouts", GetDailyIncomePayouts("AgencyPayouts", Now))
                AssignDataToGrids("AttorneyPayouts", GetDailyIncomePayouts("AttorneyPayouts", Now))
                AssignDataToGrids("OAHold", GetDailyIncomePayouts("OAHold", Now))
            End If

        End Sub

        Private Shared Function GetDailyIncomePayouts(ByVal dataType As String, ByVal sDate As DateTime, Optional ByVal filterCompanyId As Integer = Nothing) As DataTable
            Dim dt As New DataTable
            Dim sdt As New DataTable

            Select Case dataType.ToLower
                Case "attorneypayouts"
                    sdt = App_Code.HoldbackHelper.GetDailyAttorneyPayouts(Now)
                    dt = CalcNewBalance(sdt)
                    sdt = Nothing
                Case "agencypayouts"
                    sdt = App_Code.HoldbackHelper.GetDailyAgencyPayouts(Now)
                    dt = AssignLexxiomPayouts(sdt)
                    sdt = Nothing
                    AssignOpeningARBalances(dt)
                Case "attorneys"
                    dt = App_Code.HoldbackHelper.GetDailyAttorneyPayouts(Now)
                Case "oahold"
                    dt = App_Code.HoldbackHelper.GetOAHold()
                Case Else
                    Return Nothing
            End Select
            Return dt
        End Function

        Private Function AssignDataToGrids(ByVal dataType As String, ByVal dt As DataTable) As Boolean

            Try
                Select Case dataType
                    Case "AgencyPayouts"
                        gvPayee.DataSource = dt
                        gvPayee.DataBind()
                        dtPayee = dt
                    Case "AttorneyPayouts"
                        gvAttorney.DataSource = dt
                        gvAttorney.DataBind()
                    Case "OAHold"
                        gvOperatingAcct.DataSource = dt
                        gvOperatingAcct.DataBind()
                    Case Else

                End Select
                Return True
            Catch ex As Exception
                Return False
            End Try
        End Function

        Private Shared Function CalcNewBalance(ByVal dt As DataTable) As DataTable
            Dim x As Integer = 0
            If Not dt Is Nothing Then
                Dim CurrentBalance As Double = 0
                Dim Deposits As Double = 0
                Dim PlannedPayout As Double = 0
                Dim NewBalance As Double = 0

                For x = 0 To dt.Rows.Count - 1
                    CurrentBalance = Val(dt.Rows(x).Item("CurrentBalance"))
                    Deposits = Val(dt.Rows(x).Item("Deposits"))
                    PlannedPayout = Val(dt.Rows(x).Item("PlannedPayout"))
                    If CurrentBalance < 0 Then
                        NewBalance = (CurrentBalance - Deposits) + PlannedPayout
                    Else
                        NewBalance = (CurrentBalance + Deposits) - PlannedPayout
                    End If
                    dt.Rows(x).Item("NewBalance") = NewBalance
                    dt.Rows(x).Item("PlannedPayout") = Val(dt.Rows(x).Item("PlannedPayout"))
                    dt.Rows(x).Item("NewBalance") = NewBalance
                Next
            End If

            Return dt
        End Function

        Private Shared Function AssignOpeningARBalances(ByVal dt As DataTable) As DataTable
            Dim x As Integer = 0
            If Not dt Is Nothing Then
                For x = 0 To dt.Rows.Count - 1
                    dt.Rows(x).Item("NewBalance") = dt.Rows(x).Item("ARBalance")
                Next
            End If
            Return dt
        End Function

        Private Shared Function AssignLexxiomPayouts(ByVal dt As DataTable) As DataTable
            If Not dt Is Nothing Then
                Dim NewRow As DataRow
                Dim dtLex As DataTable
                Dim dvLex As DataView
                Dim dtNew As New DataTable
                Dim row As DataRow

                dtLex = App_Code.HoldbackHelper.GetLexxiomDetail()

                For Each row In dtLex.Rows
                    If Val(row.Item("CommDue").ToString.Substring(1)) > 0 Then
                        NewRow = dt.NewRow
                        NewRow("Payee") = row("Agency")
                        NewRow("ARBalance") = 0.0
                        NewRow("AccountNumber") = row("AccountNumber")
                        NewRow("Payout") = row("CommDue")
                        dt.Rows.Add(NewRow)
                        NewRow = Nothing
                    End If
                Next
                dvLex = dt.DefaultView
                dvLex.Sort = "Payee"
                dtNew = dvLex.ToTable
                Return dtNew
            End If

        End Function

        Protected Sub btnGCAClick(ByVal sender As Object, ByVal e As System.EventArgs)
            'Process the changes to the payouts
            ' get the grid row that flags the withholding amount and process it (it's checked)
            Dim dt1 As DataTable
            Dim inserted As Boolean
            Dim chk As CheckBox
            Dim Pct As TextBox
            Dim AttorneyGCA As DropDownList
            Dim AttorneyID As Integer
            Dim Payout As Label
            Dim OpeningBalance As Label
            Dim AccountNumber As Label
            Dim gRow As GridViewRow

            Try
                For Each gRow In gvPayee.Rows
                    chk = gRow.FindControl("ckWithhold")
                    Pct = gRow.FindControl("txtPct")
                    If chk.Checked Then
                        If Val(Pct.Text) > 0 Then
                            AttorneyGCA = gRow.FindControl("ddlAttorneyGCA")
                            AccountNumber = gRow.FindControl("txtAccountNumber")
                            OpeningBalance = gRow.FindControl("lblOpeningBalance")
                            Payout = gRow.FindControl("lblAPayout")
                            AttorneyID = App_Code.HoldbackHelper.GetAttyCompanyNo(AttorneyGCA.SelectedItem.Text)
                            'Get the transactions to modify and their modified amounts and new balances
                            dt1 = App_Code.HoldbackHelper.ProcessPayeeTransactions((Val(Pct.Text) / 100), AccountNumber.Text)
                            'gather the amounts to each transaction (nacha registerID) affected for that payee and move the money
                            inserted = App_Code.HoldbackHelper.InsertWithholding(dt1, AccountNumber.Text, UserID, AttorneyID, 1)
                            If inserted Then
                                If OpeningBalance.Text.Contains("($") Then
                                    OpeningBalance.Text = OpeningBalance.Text.Replace("($", "")
                                    OpeningBalance.Text = OpeningBalance.Text.Replace(")", "")
                                    DirectCast(gRow.FindControl("lblAdjBal"), Label).Text = Format((CDbl(OpeningBalance.Text) - (CDbl(Payout.Text) * (CDbl(Pct.Text) / 100))) * -1, "C")
                                    OpeningBalance.Text = Format(CDbl(OpeningBalance.Text) * -1, "C")
                                Else
                                    DirectCast(gRow.FindControl("lblAdjAbl"), Label).Text = Format((CDbl(OpeningBalance.Text) - (CDbl(Payout.Text) * (CDbl(Pct.Text) / 100))), "C")
                                    OpeningBalance.Text = Format(CDbl(OpeningBalance.Text), "C")
                                End If

                            End If
                        End If
                        chk.Checked = False
                    End If
                Next
            Catch ex As Exception
                Alert.Show("Errors were encountered processing the withholdings. " & ex.Message)
            End Try

        End Sub

        Protected Sub btnOAClick(ByVal sender As Object, ByVal e As System.EventArgs)
            'Process the changes to the payouts
            ' get the grid row that flags the withholding amount and process it (it's checked)
            Dim dt1 As DataTable
            Dim inserted As Boolean
            Dim chk As CheckBox
            Dim Pct As TextBox
            Dim AttorneyOA As Label
            Dim AttorneyID As Integer
            Dim OpeningBalance As Label
            Dim AccountNumber As Label
            Dim gRow As GridViewRow

            Try
                For Each gRow In gvOperatingAcct.Rows
                    chk = gRow.FindControl("ckOAWithhold")
                    Pct = gRow.FindControl("txtOAPct")
                    If chk.Checked Then
                        If Val(Pct.Text) > 0 Then
                            AttorneyOA = gRow.FindControl("lblAttorney")
                            AccountNumber = gRow.FindControl("txtOAAccountNumber")
                            OpeningBalance = gRow.FindControl("lblOAAmount")
                            AttorneyID = App_Code.HoldbackHelper.GetOAAttyCompanyNo(AttorneyOA.Text)
                            'Get the transactions to modify and their modified amounts and new balances
                            dt1 = App_Code.HoldbackHelper.ProcessOATransactions((Val(Pct.Text) / 100), AccountNumber.Text)
                            'gather the amounts to each transaction (nacha registerID) affected for that payee and move the money
                            inserted = App_Code.HoldbackHelper.InsertWithholding(dt1, AccountNumber.Text, UserID, AttorneyID, 2)
                            If inserted Then
                                If OpeningBalance.Text.Contains("$") Then
                                    OpeningBalance.Text = OpeningBalance.Text.Replace("(", "")
                                    OpeningBalance.Text = OpeningBalance.Text.Replace(")", "")
                                    OpeningBalance.Text = OpeningBalance.Text.Replace("$", "")
                                    DirectCast(gRow.FindControl("lblOAAdjBal"), Label).Text = Format((CDbl(OpeningBalance.Text) - (CDbl(OpeningBalance.Text) * (CDbl(Pct.Text) / 100))), "C")
                                    OpeningBalance.Text = Format(CDbl(OpeningBalance.Text), "C")
                                Else
                                    DirectCast(gRow.FindControl("lblOAAdjAbl"), Label).Text = Format((CDbl(OpeningBalance.Text) - (CDbl(OpeningBalance.Text) * (CDbl(Pct.Text) / 100))), "C")
                                    OpeningBalance.Text = Format(CDbl(OpeningBalance.Text), "C")
                                End If
                            End If
                        End If
                        chk.Checked = False
                    End If
                Next
            Catch ex As Exception
                Alert.Show("Errors were encountered processing the holdbacks. " & ex.Message)
            End Try

        End Sub

        Public Sub EnableCheckBox(ByVal sender As Object, ByVal e As System.EventArgs)
            Dim txt As TextBox
            Dim ck As CheckBox
            For Each gRow In gvPayee.Rows
                txt = gRow.FindControl("txtPct")
                ck = gRow.findcontrol("ckWithhold")
                If txt.Text > 0 Then
                    ck.Enabled = "true"
                    Me.btnSubmit.Enabled = True
                End If
            Next
        End Sub

        Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
            Dim ddl As DropDownList
            Dim dt As DataTable
            Dim dr As DataRow()
            Dim i As Integer
            Dim gRow As GridViewRow

            dt = GetDailyIncomePayouts("Attorneys", Now)
            dr = dt.Select("AttorneyGCA <> ''", "AttorneyGCA")

            For Each gRow In gvPayee.Rows
                ddl = gRow.FindControl("ddlAttorneyGCA")
                If ddl.Items.Count <= 0 Then
                    ddl.Items.Add("Lexxiom Escrow Account")
                    ddl.Items(0).Value = "0"
                    'For i = 0 To dr.Length - 1
                    '    ddl.Items.Add(dr(i).Item("AttorneyGCA").ToString)
                    '    ddl.Items(i).Value = dr(i).Item("CompanyID").ToString
                    'Next
                End If
            Next

        End Sub

        Protected Sub btnReport_Click(ByVal sender As Object, ByVal e As ImageClickEventArgs) Handles ibPrint.Click
            Response.Redirect("~/research/reports/financial/commission/withholdingreport.aspx")
        End Sub

        Protected Sub gvPayee_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)

            If e.Row.RowType.Equals(DataControlRowType.DataRow) Then
                Dim ck As CheckBox = TryCast(e.Row.FindControl("ckWithhold"), CheckBox)
                Dim lbl As Label = TryCast(e.Row.FindControl("txtAccountNumber"), Label)
                Dim ddl As DropDownList = TryCast(e.Row.FindControl("ddlAttorneyGCA"), DropDownList)
            End If

        End Sub

        Protected Sub gvOperatingAcct_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
            If e.Row.RowType.Equals(DataControlRowType.DataRow) Then
                Dim ck As CheckBox = TryCast(e.Row.FindControl("OAckWithhold"), CheckBox)
                Dim lbl As Label = TryCast(e.Row.FindControl("txtOAAccountNumber"), Label)
            End If
        End Sub

#End Region 'Methods

    End Class
End Namespace