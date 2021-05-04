Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Partial Class processing_popups_FeeAdjustment
    Inherits System.Web.UI.Page

#Region "Declaration"
    Public SettlementID As Integer = 0
    Public DeliveryFee As Double = 0
    Public SettlementFee As Double = 0
    Public UserID As Integer = 0
    Private Information As SettlementMatterHelper.SettlementInformation
#End Region

#Region "Events"
    ''' <summary>
    ''' Loads the content of the page
    ''' </summary>    
    ''' <remarks>sid is the settlementId</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not Request.QueryString("sid") Is Nothing Then
            SettlementID = Integer.Parse(Request.QueryString("sid"))
        End If

        If Not Request.QueryString("delfee") Is Nothing AndAlso Request.QueryString("delfee").Trim.Length > 0 Then
            DeliveryFee = Request.QueryString("delfee")
        End If

        If Not Request.QueryString("settfee") Is Nothing AndAlso Request.QueryString("settfee").Trim.Length > 0 Then
            SettlementFee = Request.QueryString("settfee")
        End If

        If Not IsPostBack Then
            LoadSettlementInfo(SettlementID)
        End If
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim UserName As String = txtManager.Text
        Dim Password As String = DataHelper.GenerateSHAHash(txtAuthCode.Text)
        dvError.Style.Item("display") = "none"
        tdError.InnerText = ""

        Dim serverCode = DataHelper.FieldLookup("tblUser", "Password", "UserName='" & UserName & "'")
        Dim ManagerId As Integer = CInt(DataHelper.FieldLookup("tblUser", "UserId", "UserName='" & UserName & "'"))
        Dim isApproved As Boolean = False

        If String.IsNullOrEmpty(serverCode) Then
            dvError.Style.Item("display") = "inline"
            tdError.InnerText = "Enter a Valid UserName"
            Exit Sub
        End If

        If Not PermissionHelperLite.HasPermission(ManagerId, "Settlement Processing-Payments Override") Then
            dvError.Style.Item("display") = "inline"
            tdError.InnerText = "You do not have permission to authorize. Please contact your Manager."
            Exit Sub
        End If

        If Not serverCode.Equals(Password) Then
            dvError.Style.Item("display") = "inline"
            tdError.InnerText = "The confirmation code is incorrect."
            Exit Sub
        End If

        If radAccept.Checked Then
            isApproved = True
        End If

        SettlementMatterHelper.AdjustSettlementFee(SettlementID, UserID, CDbl(txtDeliveryFees.Text), CDbl(txtsettFeeMask.Text), isApproved, ManagerId, False, Nothing)
        ClientScript.RegisterClientScriptBlock(GetType(Page), "FeeAdjustments", "<script> window.onload = function() { CloseFeeAdjustment(); } </script>")

    End Sub

#End Region

#Region "Utilities"
    ''' <summary>
    ''' Loads the fee structure for the settlement
    ''' </summary>
    ''' <param name="_SettlementId">Integer to uniquely identify the Settlement</param>
    ''' <remarks>Depending on the Delivery method, either OvernightFees or Check By Phone Fees is applied</remarks>
    Public Sub LoadSettlementInfo(ByVal _SettlementId As Integer)
        Information = SettlementMatterHelper.GetSettlementInformation(_SettlementId)

        Dim DataClientid As Integer = Information.ClientID

        txtsettFeeMask.Text = FormatCurrency(SettlementFee, 2)
        lblDelFees.Text = FormatCurrency(Information.DeliveryAmount, 2)
        lblSettlementFee.Text = FormatCurrency(Information.SettlementFee, 2)
        lblDelMethod.Text = Information.DeliveryMethod
        txtDeliveryFees.Text = FormatCurrency(DeliveryFee, 2)
        lblSettDiff.Text = FormatCurrency((SettlementFee - Information.SettlementFee), 2)
        lblDelDiff.Text = FormatCurrency((DeliveryFee - Information.DeliveryAmount), 2)

        Dim ds As DataSet = ClientHelper2.ExpectedDeposits(DataClientid, DateAdd(DateInterval.Day, 90, Now))
        If ds.Tables(1).Rows.Count > 0 Then
            Me.lblNextDepositDate.Text = Format(CDate(ds.Tables(1).Rows(0)("depositdate")), "MMM d")
            Me.lblDepositAmount.Text = FormatCurrency(Val(ds.Tables(1).Rows(0)("depositamount")), 2)
        End If
    End Sub

#End Region

End Class
