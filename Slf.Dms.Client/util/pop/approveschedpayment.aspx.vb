Imports System.Data
Imports Drg.Util.DataAccess

Partial Class util_pop_approveschedpayment
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            LoadData()
        End If
    End Sub

    Private Sub LoadData()
        Dim dt As DataTable = PaymentScheduleHelper.GetSettlementScheduledPayments(Me.Request.QueryString("sid"), Nothing, Nothing, Nothing)
        If dt.Rows.Count > 0 Then
            Me.lblAccoutNumber.Text = dt.Rows(0)("AccountNumber")
            Me.lblCreditorName.Text = dt.Rows(0)("CurrentCreditor")
            Me.lblCheckAmount.Text = String.Format("{0:c}", dt.Rows(0)("CheckAmount"))
        End If
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If txtCheckNumber.Text.Trim.Length = 0 Then
            ClientScript.RegisterStartupScript(GetType(Page), "approveechederror", "ShowMessage('Enter Check Number.');", True)
        Else
            Try
                PaymentScheduleHelper.ApprovePayment(Me.Request.QueryString("sid"), txtCheckNumber.Text.Trim, UserID)
                'Success
                ClientScript.RegisterStartupScript(GetType(Page), "closedlgsucccess", "window.top.dialogArguments." & Request.QueryString("f") & "();window.close();", True)
            Catch ex As Exception
                'Error
                ClientScript.RegisterStartupScript(GetType(Page), "approveechederror", "ShowMessage('There was an error trying to approve the payment.');", True)
            End Try
        End If


    End Sub

    
End Class
