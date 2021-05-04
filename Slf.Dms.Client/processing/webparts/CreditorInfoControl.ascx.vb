Imports Drg.Util.DataHelpers

Partial Class negotiation_webparts_CreditorInfoControl
    Inherits System.Web.UI.UserControl

#Region "Declares"
    Private UserID As Integer
    Private SettlementID As Integer
    Private Information As SettlementMatterHelper.SettlementInformation
    Public DataClientid As String
    Public CreditorAccountID As String
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not IsPostBack Then
            If Not Request.QueryString("sid") Is Nothing Then
                SettlementID = Integer.Parse(Request.QueryString("sid"))

                Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)

                DataClientid = Information.ClientID
                CreditorAccountID = Information.AccountID
            End If

            If Not DataClientid Is Nothing And Not CreditorAccountID Is Nothing Then
                LoadCreditorInfo(CreditorAccountID)
            End If
        End If
    End Sub
#End Region

#Region "LoadCreditorInfo"
    Public Sub LoadCreditorInfo(ByVal accountID As String)
        Me.tblView.Style("display") = "block"

        Dim dtCreditor As New Data.DataTable
        Using saTemp = New Data.SqlClient.SqlDataAdapter("stp_GetSettlementCreditorInfo " & accountID, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            saTemp.fill(dtCreditor)
        End Using

        If dtCreditor.Rows.Count > 0 Then
            For Each dRow As Data.DataRow In dtCreditor.Rows
                Me.lblViewForCreditorName.Text = dRow("forcreditorname").ToString
                Me.lblViewCurrCreditorName.Text = dRow("creditorname").ToString
                Me.lblViewAcctNum.Text = dRow("accountnumber").ToString
                Me.lblViewRefNum.Text = dRow("referencenumber").ToString
                Me.lblViewOrigAmt.Text = FormatCurrency(dRow("originalamount").ToString, 2)
                Me.lblViewCurrAmt.Text = FormatCurrency(dRow("currentamount").ToString, 2)
                Me.lblViewAcquired.Text = Format(dRow("Acquired"), "MM/dd/yyyy")
            Next
        End If

    End Sub

#End Region
    
End Class