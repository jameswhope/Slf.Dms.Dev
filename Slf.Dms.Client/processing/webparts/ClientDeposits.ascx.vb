Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data.SqlClient

Partial Class negotiation_webparts_ClientDeposits
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Private UserID As Integer
    Private SettlementID As Integer
    Private Information As SettlementHelper.SettlementInformation
    Public DataClientID As Integer
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not IsPostBack Then
            LoadDeposits()
        End If
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lnkLoadDeposits_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoadDeposits.Click
        LoadDeposits()
    End Sub
    Public Sub getClientDepositHistory()
        LoadDeposits()
    End Sub
#End Region

#Region "Utilities"
    Private Sub LoadDeposits()
        If Not Request.QueryString("sid") Is Nothing Then
            SettlementID = Integer.Parse(Request.QueryString("sid"))

            Information = SettlementHelper.GetSettlementInformation(SettlementID)

            DataClientID = Information.ClientID
        End If

        Using cmd As New SqlCommand("stp_GetClientDepositHistory", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.CommandType = Data.CommandType.StoredProcedure

                DatabaseHelper.AddParameter(cmd, "clientid", DataClientID)
                DatabaseHelper.AddParameter(cmd, "top", 12)

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    rpDeposits.DataSource = reader
                    rpDeposits.DataBind()

                    pnlDeposits.Visible = rpDeposits.Items.Count > 0
                    pnlNone.Visible = Not pnlDeposits.Visible
                End Using
            End Using
        End Using
    End Sub
#End Region


End Class