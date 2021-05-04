Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class util_pop_PaymentArrangementInfo
    Inherits System.Web.UI.Page

#Region "Variables"

    Private Shadows ClientID As Integer
    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Dim SettlementId As Integer = Request.QueryString("sid")
        If Not IsPostBack Then
            LoadPA(SettlementId)
        End If

    End Sub

    Private Sub LoadPA(ByVal SettlementId As Integer)
        Dim ds As DataSet = PaymentScheduleHelper.GetPaymentScheduleReportBySettlement(SettlementId)
        Me.gdPaymentSchedule.DataSource = ds.Tables(0)
        Me.gdPaymentSchedule.DataBind()
    End Sub

    Protected Sub gdPaymentSchedule_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gdPaymentSchedule.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim status As String = DataBinder.Eval(e.Row.DataItem, "status").ToString.Trim.ToLower
            Select Case status
                Case "open"
                    e.Row.CssClass = "openRow"
                Case "past due"
                    e.Row.CssClass = "expiredRow"
                Case "closed"
                    e.Row.CssClass = "closedRow"
                Case "by client"
                    e.Row.CssClass = "byclientRow"
                Case Else
                    If status.StartsWith("paid on") Then
                        e.Row.CssClass = "paidRow"
                    Else
                        e.Row.CssClass = ""
                    End If
            End Select

        End If
    End Sub
End Class