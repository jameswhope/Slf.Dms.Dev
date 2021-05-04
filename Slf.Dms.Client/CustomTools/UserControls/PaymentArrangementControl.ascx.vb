Imports System.Collections.Generic
Imports System.Data
Imports System.Data.Common
Imports System.Data.SqlClient

Partial Class CustomTools_UserControls_PaymentArrangementControl
    Inherits System.Web.UI.UserControl

#Region "Fields"

    Private _InstallmentTotal As Double

#End Region 'Fields

    #Region "Events"

    Public Event PaymentPlanNeeded(ByVal SettlementID As Integer, ByVal IsPlanNeeded As Boolean)

    #End Region 'Events

#Region "Properties"

    ''' <summary>
    ''' creditor accountid in tblAccounts
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property AccountID() As Integer
        Get
            Return hdnAccountID.Value
        End Get
        Set(ByVal value As Integer)
            hdnAccountID.Value = value
        End Set
    End Property

    ''' <summary>
    ''' clientid from tblclient
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property DataClientID() As Integer
        Get
            Return hdnClientID.Value
        End Get
        Set(ByVal value As Integer)
            hdnClientID.Value = value
        End Set
    End Property

    ''' <summary>
    ''' Payment schedule unique id in tblPaymentSchedule
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property PmtScheduleID() As Integer
        Get
            Return hdnPmtScheduleID.Value
        End Get
        Set(ByVal value As Integer)
            hdnPmtScheduleID.Value = value
        End Set
    End Property

    ''' <summary>
    ''' stores the settlement amount
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property SettlementAmount() As Double
        Get
            If String.IsNullOrEmpty(hdnSettlementAmount.Value) Then
                hdnSettlementAmount.Value = 0
            End If
            Return hdnSettlementAmount.Value
        End Get
        Set(ByVal value As Double)
            hdnSettlementAmount.Value = value
        End Set
    End Property

    Public Property SettlementFee() As Double
        Get
            If String.IsNullOrEmpty(hdnSettlementFee.Value) Then
                hdnSettlementFee.Value = 0
            End If
            Return hdnSettlementFee.Value
        End Get
        Set(ByVal value As Double)
            hdnSettlementFee.Value = value
        End Set
    End Property

    ''' <summary>
    ''' holds the settlement id
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property SettlementID() As Integer
        Get
            If String.IsNullOrEmpty(hdnSettlementID.Value) Then
                hdnSettlementID.Value = -1
            End If
            Return hdnSettlementID.Value
        End Get
        Set(ByVal value As Integer)
            hdnSettlementID.Value = value
        End Set
    End Property

    ''' <summary>
    ''' holds current userid
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property UserID() As Integer
        Get
            Return ViewState("_UserID")
        End Get
        Set(ByVal value As Integer)
            ViewState("_UserID") = value
        End Set
    End Property

#End Region 'Properties

    #Region "Methods"

    Public Function DoesSettlementNeedPaymentPlan(ByVal dataclientid As Integer, ByVal accountid As Integer) As Boolean
        Dim bNeeds As Boolean = False
        Dim settid As Integer = PaymentScheduleHelper.GetActivePASettlement(dataclientid, accountid)
        If settid > 0 Then
            Using dt As DataTable = PaymentScheduleHelper.GetPaymentScheduleData(settid)
                If dt.Rows.Count < 1 Then
                    bNeeds = True
                    ShowStatus("<span noresults=""true"" style=""font-weight:bold;font-size:12px;"">This settlement is a Payment Arrangement.  Please <a href=""#"" onclick=""return togglePlans();"">set-up</a> a payment plan!</span>", "error", False)
                    divGrid.Style("display") = "none"
                    RaiseEvent PaymentPlanNeeded(SettlementID, bNeeds)
                Else
                    divGrid.Style("display") = ""
                    For Each dr As DataRow In dt.Rows
                        SettlementAmount = dr("settlementamount").ToString
                        _InstallmentTotal = dr("InstallmentTotal").ToString
                        Exit For
                    Next
                    CheckTotals()
                End If
            End Using
        Else
            RaiseEvent PaymentPlanNeeded(-1, bNeeds)
        End If
        Return bNeeds
    End Function

    Public Function GetActiveSettlementID(ByVal dataclientid As Integer, ByVal accountid As Integer) As Integer
        Dim settid As Integer = PaymentScheduleHelper.GetActivePASettlement(dataclientid, accountid)
        If settid = 0 Then settid = -1
        Return settid
    End Function

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        Refresh()
    End Sub

    Public Sub Refresh()
        ShowStatus("", "")
        DoesSettlementNeedPaymentPlan(DataClientID, AccountID)
        BindData()
    End Sub

    Public Sub Show(Optional ByVal bShow As Boolean = True)
        Select Case bShow
            Case True
                divResults.Style("display") = "block"
                divControl.Style("display") = "block"
            Case Else
                divResults.Style("display") = "none"
                divControl.Style("display") = "none"
        End Select
    End Sub

    Public Sub ViewClientInfo(Optional ByVal bView As Boolean = True)
        Select Case bView
            Case True
                divClientInfo.Style("display") = "block"
            Case Else
                divClientInfo.Style("display") = "none"
        End Select
    End Sub

    Public Sub ViewCreditorInfo(Optional ByVal bView As Boolean = True)
        Select Case bView
            Case True
                divCreditorInfo.Style("display") = "block"
            Case Else
                divCreditorInfo.Style("display") = "none"
        End Select
    End Sub

    Public Sub ViewInfoBlock(Optional ByVal bView As Boolean = True)
        Select Case bView
            Case True
                divInfo.Style("display") = "block"
            Case Else
                divInfo.Style("display") = "none"
        End Select
    End Sub

    Public Sub ViewSettlementInfo(Optional ByVal bView As Boolean = True)
        Select Case bView
            Case True
                divSettInfo.Style("display") = "block"
            Case Else
                divSettInfo.Style("display") = "none"
        End Select
    End Sub

    Protected Sub CustomTools_UserControls_PaymentArrangementControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        If Not IsPostBack Then
            If Me.DataClientID <> -1 Then
                lblClient.Text = PaymentScheduleHelper.GetAccountNumber(Me.DataClientID)
                lblClientName.Text = Drg.Util.DataHelpers.ClientHelper.GetDefaultPersonName(DataClientID)
            End If
            If Me.AccountID <> -1 Then
                lblCreditor.Text = CreditorGroupHelper.GetCreditorName(AccountID)
                lblAcctBal.Text = FormatCurrency(Drg.Util.DataHelpers.AccountHelper.GetCurrentAmount(AccountID), 2, TriState.False, TriState.False, TriState.True)
            End If
            If Me.SettlementID <> -1 Then
                Using dt As DataTable = PaymentScheduleHelper.GetSettlementData(DataClientID, AccountID)
                    For Each dr As DataRow In dt.Rows
                        lblSettDue.Text = FormatDateTime(dr("SettlementDueDate").ToString, DateFormat.ShortDate)
                        SettlementAmount = dr("SettlementAmount").ToString
                        SettlementFee = dr("SettlementFee").ToString
                        lblSettAmt.Text = FormatCurrency(SettlementAmount, 2, TriState.False, TriState.False, TriState.True)
                        lblSettFee.Text = FormatCurrency(SettlementFee, 2, TriState.False, TriState.False, TriState.True)
                        Exit For
                    Next
                End Using
            End If
        End If
        BindData()
    End Sub

    Protected Sub gvReport_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvReport.DataBound
        CheckTotals()
    End Sub

    Protected Sub gvReport_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvReport.RowCommand
        Select Case e.CommandName.ToLower
            Case "EditPayment".ToLower
                Dim gv As GridViewRow = DirectCast(sender, GridView).Rows(e.CommandArgument)
                txtPaymentAmt.Text = gv.Cells(9).Text
                txtPaymentDate.Text = gv.Cells(8).Text
                PmtScheduleID = DirectCast(sender, GridView).DataKeys(e.CommandArgument).Values("PmtScheduleID").ToString
                DataClientID = DirectCast(sender, GridView).DataKeys(e.CommandArgument).Values("ClientID").ToString
                SettlementID = DirectCast(sender, GridView).DataKeys(e.CommandArgument).Values("SettlementID").ToString
                Dim accountid As String = DirectCast(sender, GridView).DataKeys(e.CommandArgument).Values("AccountID").ToString
                lnkSave.Style("display") = "block"
                lnkAdd.Style("display") = "none"
                divAdd.Style("display") = "block"
        End Select
    End Sub

    Protected Sub gvReport_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvReport.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim lnk As LinkButton = e.Row.FindControl("lnkEdit")
                lnk.OnClientClick = String.Format("return ShowEdit('{0}','{1}',{2});", _
                                                  FormatDateTime(rowView("PmtDate").ToString, DateFormat.ShortDate), _
                                                  FormatCurrency(rowView("PmtAmount").ToString, 2, TriState.False, TriState.False, TriState.True), _
                                                  rowView("PmtScheduleID").ToString)

                If FormatNumber(_InstallmentTotal, 2) <> FormatNumber(SettlementAmount, 2) Then
                    '_InstallmentTotal += rowView("PmtAmount").ToString
                End If

                If FormatNumber(_InstallmentTotal, 2) > FormatNumber(SettlementAmount, 2) Then
                    e.Row.Style("background-color") = "#FFBABA"
                Else
                    GridViewHelper.styleGridviewRows(e, , "#F7F6F3")
                End If
            Case DataControlRowType.Footer
                CheckTotals()
        End Select
    End Sub

    Private Sub BindData()
        dsReport.SelectParameters("settlementid").DefaultValue = SettlementID
        dsReport.DataBind()
        gvReport.DataBind()
    End Sub

    Private Sub CheckTotals()
        If FormatNumber(_InstallmentTotal, 2) > FormatNumber(SettlementAmount, 2) Then
            Dim aDiff As Double = _InstallmentTotal - SettlementAmount
            ShowStatus(String.Format("The total of installments is greater than the settlement amount by {0}, please correct!", FormatCurrency(aDiff, 2)), "error")
            divTotal.InnerHtml = String.Format("TOTAL OF INSTALLMENT PAYMENTS&nbsp;&nbsp;:&nbsp;&nbsp;<span style=""color:#FFB2B2"">{0}<span>", FormatCurrency(_InstallmentTotal, 2, TriState.True, TriState.False, TriState.True))
            'tdAddNew.Style("display") = "none"
        ElseIf FormatNumber(SettlementAmount, 2) > FormatNumber(_InstallmentTotal, 2) AndAlso _InstallmentTotal > 0 Then
            Dim aDiff As Double = SettlementAmount - _InstallmentTotal
            ShowStatus(String.Format("The total of installments is less than the settlement amount by {0}, please correct!", FormatCurrency(aDiff, 2)), "error")
            divTotal.InnerHtml = String.Format("TOTAL OF INSTALLMENT PAYMENTS&nbsp;&nbsp;:&nbsp;&nbsp;<span style=""color:#FFB2B2"">{0}<span>", FormatCurrency(_InstallmentTotal, 2, TriState.True, TriState.False, TriState.True))
            tdAddNew.Style("display") = "block"
        Else
            divTotal.InnerHtml = String.Format("TOTAL OF INSTALLMENT PAYMENTS&nbsp;&nbsp;:&nbsp;&nbsp;{0}", FormatCurrency(_InstallmentTotal, 2, TriState.True, TriState.False, TriState.True))
        End If
    End Sub

    Private Sub ShowStatus(ByVal statusMsg As String, ByVal msgType As String, Optional ByVal ShowClose As Boolean = True)
        If Not String.IsNullOrEmpty(statusMsg) Then
            divResults.Attributes("class") = msgType
            divResults.InnerHtml = statusMsg
            If ShowClose Then
                divResults.InnerHtml += "&nbsp;<a href=""#"" onclick=""this.parentNode.style.display='none';"" >Close</a>"
            End If
            divResults.Style("display") = "block"
        Else
            divResults.Style("display") = "none"
        End If
    End Sub

    #End Region 'Methods

End Class