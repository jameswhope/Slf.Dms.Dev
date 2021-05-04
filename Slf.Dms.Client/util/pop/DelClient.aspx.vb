Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Partial Class util_pop_DelClient
    Inherits System.Web.UI.Page

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

      Me.Title = "Delete Client " & Request.QueryString("t")
      Me.lblMessage.Text = "Are you sure you want to DELETE a Client " & Request.QueryString("p") & "?" & " Enter the client ID and click Confirm to validate you have the right client. If the client is the correct one then click Delete at the bottom right of this page."

   End Sub

   Private Sub ConfirmDelete()
      Me.lnkDeleteClient.InnerHtml = "Delete Client " & Request.QueryString("t") & "<img style=""margin-left:6px;"" src=""" & ResolveUrl("~/images/16x16_forward.png") & """ border=""0"" align=""absmiddle"" />"
   End Sub

   Private Sub btnConfirm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirm.Click
      Dim strSQL As String = ""

      strSQL = "SELECT p.FirstName, p.LastName, c.AccountNumber FROM tblPerson AS p INNER JOIN tblClient AS c ON c.ClientID = p.ClientID WHERE p.Relationship = 'Prime' AND c.ClientID = " & CInt(Trim(Me.txtClientID.Text.ToString))

      Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
         Using cmd.Connection
            cmd.Connection.Open()

            Using reader As SqlDataReader = cmd.ExecuteReader()
               While reader.Read()
                  Me.lblName.Text = reader.Item("FirstName").ToString & " " & reader.Item("LastName").ToString
                  Me.lblAcctNo.Text = reader.Item("AccountNumber").ToString
               End While
            End Using
         End Using
      End Using

      If Me.lblAcctNo.Text <> "" Then
         ConfirmDelete()
      End If
   End Sub

   Private Sub DeleteClient(ByVal ClientID As Integer)
      Using cmd As New SqlCommand("exec stp_DeleteClientxxx " & ClientID, New SqlConnection(ConfigurationSettings.AppSettings.Item("connectionstring")))
         Using cmd.Connection
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
         End Using
      End Using
   End Sub

   Private Sub lnkDelete_OnClick(ByVal sendere As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
      DeleteClient(CInt(Trim(Me.txtClientID.Text.ToString)))
   End Sub

End Class
