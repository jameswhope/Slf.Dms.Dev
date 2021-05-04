Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data.SqlClient


Partial Class util_pop_RebalClient
    Inherits System.Web.UI.Page

   Private PFlag As String = "S"

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

      Me.Title = "Rebalance Client " & Request.QueryString("t")
      Me.lblMessage.Text = "You are about to Re-Balance a client or clients" & Request.QueryString("p") & "." & " You can either Re-Balance ALL the clients or a Single client. Using the buttons below to select which. if you have selected ALL then just click Re-Balance at the bottom right of this page. Otherwise enter the client's Account Number, click Confirm and then click Re-Balance."

    End Sub

   Private Sub btnConfirm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirm.Click
      Dim strSQL As String = ""

      strSQL = "SELECT p.FirstName, p.LastName, c.ClientID FROM tblPerson AS p INNER JOIN tblClient AS c ON c.ClientID = p.ClientID WHERE p.Relationship = 'Prime' AND c.AccountNumber = " & Me.txtAcctNo.Text.ToString

      Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
         Using cmd.Connection
            cmd.Connection.Open()

            Using reader As SqlDataReader = cmd.ExecuteReader()
               While reader.Read()
                  Me.lblName.Text = reader.Item("FirstName").ToString & " " & reader.Item("LastName").ToString
                  Me.lblClientID.Text = reader.Item("ClientID").ToString
               End While
            End Using
         End Using
      End Using

      If Me.lblClientID.Text <> "" Then
            Me.lnkReBalanceClient.InnerHtml = "Re-Balance Client " & Request.QueryString("t") & "<img style=""margin-left:6px;"" src=""" & ResolveUrl("~/images/16x16_forward.png") & """ border=""0"" align=""absmiddle"" />"
        End If
   End Sub

   Private Sub RebalanceClient(Optional ByVal ClientID As Integer = 0)
      Dim strSQL As String

      If PFlag = "S" Then
         strSQL = "exec stp_DoRegisterRebalanceClient " & ClientID
      Else
         strSQL = "exec job_MorningRebalanceClients"
      End If

      Using cmd As New SqlCommand(strSQL, New SqlConnection(ConfigurationSettings.AppSettings.Item("connectionstring")))
         Using cmd.Connection
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
         End Using
      End Using
   End Sub

   Private Sub lnkRebalance_OnClick(ByVal sendere As Object, ByVal e As System.EventArgs) Handles lnkRebalance.Click
      RebalanceClient(CInt(Trim(Me.lblClientID.Text.ToString)))
   End Sub

   Protected Sub radRebal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles radRebal.SelectedIndexChanged
      If Me.radRebal.SelectedValue = "A" Then
         Me.lblEnter.Visible = False
         Me.txtAcctNo.Visible = False
         Me.lblAccount.Visible = False
         Me.lblName.Visible = False
         Me.lblClientID.Visible = False
         Me.lblNameA.Visible = False
         Me.lblClientIDA.Visible = False
         Me.btnConfirm.Visible = False
      Else
         Me.lblEnter.Visible = True
         Me.txtAcctNo.Visible = True
         Me.lblAccount.Visible = True
         Me.lblName.Visible = True
         Me.lblClientID.Visible = True
         Me.lblNameA.Visible = True
         Me.lblClientIDA.Visible = True
         Me.btnConfirm.Visible = True
      End If
      PFlag = radRebal.SelectedValue
   End Sub
End Class
