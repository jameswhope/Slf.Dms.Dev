Imports System.Collections.Generic
Imports System.Data
Imports System.Data.Common
Imports System.Data.SqlClient

Partial Class CustomTools_UserControls_PaymentArrangementCalc
    Inherits System.Web.UI.UserControl

    Public Enum Mode
        NoPlan = 0
        [Default] = 1
        Custom = 2
    End Enum

#Region "Fields"

    Private _InstallmentTotal As Double

#End Region 'Fields

#Region "Events"
#End Region 'Events

#Region "Properties"

    Public Property PAMode() As Mode
        Get
            Return Me.hdnMode.Value
        End Get
        Set(ByVal value As Mode)
            Me.hdnMode.Value = value
        End Set
    End Property

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
    Public Property PADetailID() As Integer
        Get
            Return hdnPADetailID.Value
        End Get
        Set(ByVal value As Integer)
            hdnPADetailID.Value = value
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

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        Refresh()
    End Sub

    Public Sub Refresh()
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

    Protected Sub CustomTools_UserControls_PaymentArrangementControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        If Not IsPostBack Then
            BindData()
        End If
    End Sub

    Protected Sub gvCustomPADetails_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCustomPADetails.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim lnk As LinkButton = e.Row.FindControl("lnkEdit")
                lnk.OnClientClick = String.Format("return ShowEdit('{0}','{1}',{2});", _
                                                  FormatDateTime(rowView("PaymentDueDate").ToString, DateFormat.ShortDate), _
                                                  FormatCurrency(rowView("PaymentAmount").ToString, 2, TriState.False, TriState.False, TriState.True), _
                                                  rowView("PAdetailid").ToString)
                If e.Row.RowIndex = 0 Then
                    Dim a As Integer = 1
                End If
            Case DataControlRowType.Footer
                'CheckTotals()
        End Select
    End Sub

    Private Sub LoadCalculatorSet(ByVal dr As DataRow)
        'use viewstate settlement amount is present. Otherwise use the saved value.
        Dim settAmount As Decimal
        If Val(Me.hdnSettlementAmount.Value) = 0 Then
            settAmount = CDec(dr("SettlementAmount"))
            Me.hdnSettlementAmount.Value = String.Format("{0:N2}", settAmount).Replace(",", "")
        Else
            settAmount = Me.hdnSettlementAmount.Value
        End If

        Me.txtLSumAmount.Text = String.Format("{0:N2}", settAmount)

        If Not dr("startDate") Is DBNull.Value Then
            Me.txtStartDate.Text = CDate(dr("startDate"))
        Else
            Me.txtStartDate.Text = ""
        End If
        Me.ddlPlanType.SelectedIndex = Me.ddlPlanType.Items.IndexOf(Me.ddlPlanType.Items.FindByValue(dr("plantype")))
        If Not dr("lumpsumamount") Is DBNull.Value Then
            Me.txtPmtAmount.Text = String.Format("{0:N2}", dr("lumpsumamount"))
            Me.txtPmtAmountPct.Text = String.Format("{0:N2}", (100 * dr("lumpsumamount") / settAmount))
        Else
            Me.txtLSumAmount.Text = ""
            Me.txtPmtAmount.Text = ""
            Me.txtPmtAmountPct.Text = ""
        End If
        If Not dr("installmentmethod") Is DBNull.Value Then
            Me.ddlInstallmentType.SelectedIndex = Me.ddlInstallmentType.Items.IndexOf(Me.ddlInstallmentType.Items.FindByValue(dr("installmentmethod")))
        Else
            Me.ddlInstallmentType.SelectedIndex = 0
        End If
        If Not dr("installmentamount") Is DBNull.Value Then
            Me.txtInstallmentAmount.Text = String.Format("{0:N2}", dr("installmentamount"))
        Else
            Me.txtInstallmentAmount.Text = ""
        End If
        If Not dr("installmentcount") Is DBNull.Value Then
            Me.txtInstallmentCount.Text = dr("installmentcount")
        Else
            Me.txtInstallmentCount.Text = ""
        End If
        Me.lblPACreated.Text = String.Format("{0:g}", CDate(dr("created")))
        Me.lblPACreatedBy.Text = DialerHelper.GetUserFullName(dr("createdby"))
        If Not dr("lastmodified") Is DBNull.Value Then
            Me.lblPAModified.Text = String.Format("{0:g}", CDate(dr("lastmodified")))
        Else
            Me.lblPAModified.Text = ""
        End If
        If Not dr("lastmodifiedby") Is DBNull.Value Then
            Me.lblPAModifiedBy.Text = DialerHelper.GetUserFullName(dr("lastmodifiedby"))
        Else
            Me.lblPAModifiedBy.Text = ""
        End If
    End Sub

    Private Sub LoadCustomHeader(ByVal SettAmt As Decimal, ByVal dtdetails As DataTable)
        Me.lblCustomSettAmount.Text = String.Format("{0:c}", SettAmt)
        Dim usedamount As Decimal = 0
        If dtdetails.Rows.Count > 0 Then usedamount = dtdetails.Compute("Sum(paymentamount)", String.Empty)
        Me.lblCustomAmountUsed.Text = String.Format("{0:c}", usedamount)
        Me.lblCustomNumberOfPmts.Text = dtdetails.Rows.Count
        Me.lblCustomAmountLeft.Text = String.Format("{0:c}", SettAmt - usedamount)
    End Sub

    Private Sub BindData()
        hdnPASessionId.Value = 0
        Dim dt As DataTable = PaymentScheduleHelper.GetPACalculatorSet(Me.DataClientID, Me.AccountID)
        Dim customized As Boolean = False

        Dim planid As Integer = 0
        If dt.Rows.Count > 0 Then
            planid = dt.Rows(0)("pasessionid")
            customized = dt.Rows(0)("custom")
            hdnPASessionId.Value = planid
            LoadCalculatorSet(dt.Rows(0))
        End If

        Dim dtdetails As DataTable = PaymentScheduleHelper.GetPACalculatorDetails(planid)
        gvCustomPADetails.DataSource = dtdetails
        gvCustomPADetails.DataBind()

        If planid = 0 Then
            PAMode = Mode.NoPlan
        ElseIf customized OrElse dtdetails.Rows.Count > 0 Then
            PAMode = Mode.Custom
            LoadCustomHeader(SettlementAmount, dtdetails)
        Else
            PAMode = Mode.Default
        End If

    End Sub

#End Region 'Methods

End Class