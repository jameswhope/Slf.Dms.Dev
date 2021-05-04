Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Partial Class util_pop_ReRunStmts
    Inherits System.Web.UI.Page

   Private PFlag As String = "S"

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

      Me.Title = "Re Run Statements " & Request.QueryString("t")
      Me.lblMessage.Text = "You can choose the period" & Request.QueryString("p") & "." & " to re-run for ALL the clients, a Single client or just those clients for a Settlement Attorney. if you have selected ALL then just click Run Statements at the bottom right of this page. Otherwise choose the Single Statement or Settlement Attorney. Enter the appropriate information and click Confirm, then click Run Statements."
      Me.lnkRunStmts.InnerHtml = "Run Statements " & Request.QueryString("t") & "<img style=""margin-left:6px;"" src=""" & ResolveUrl("~/images/16x16_forward.png") & """ border=""0"" align=""absmiddle"" />"

   End Sub

   Private Sub btnConfirm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirm.Click
      Dim strSQL As String = ""

        strSQL = "SELECT p.FirstName, p.LastName FROM tblPerson p INNER JOIN tblClient AS c ON c.ClientID = p.ClientID WHERE p.Relationship = 'Prime' AND c.AccountNumber = " & Me.txtAcctNo.Text.ToString

      Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
         Using cmd.Connection
            cmd.Connection.Open()

            Using reader As SqlDataReader = cmd.ExecuteReader()
               While reader.Read()
                  Me.lblName.Text = reader.Item("FirstName").ToString & " " & reader.Item("LastName").ToString
               End While
            End Using
         End Using
      End Using

      If Me.txtAcctNo.Text <> "" Then
         Me.lnkRunStmts.Visible = True
      End If
   End Sub

   Private Sub ReRunStatements(ByVal RunDate As String, Optional ByVal AccountNo As Integer = 0, Optional ByVal SAttyNo As Integer = 0)
      Dim strSQL As String
      Dim NumbProcessed As Integer
      Dim cnSQL As String = ConfigurationManager.AppSettings.Item("connectionstring").ToString

      Select Case PFlag
         Case "S"
            strSQL = "exec stp_ClientStatementBuilder '" & RunDate & "' " & 15 & " " & 0 & " " & AccountNo
         Case "SA"
            strSQL = "exec stp_ClientStatementBuilder '" & RunDate & "' " & 15 & " " & 0 & " " & SAttyNo
         Case Else
            strSQL = "exec sp_start_job " & "CreateStatements" & " SQL2" & "stp_ClientStatementBuilder"
            cnSQL = ConfigurationManager.AppSettings.Item("AgentConnString").ToString
      End Select

      Using cmd As New SqlCommand(strSQL, New SqlConnection(cnSQL))
         Using cmd.Connection
            cmd.Connection.Open()
            NumbProcessed = cmd.ExecuteNonQuery()
         End Using
      End Using

      If NumbProcessed <> 0 Then
         Shell("\\Lexsrvsqlprod1\G\Services\Client_Statements\CreateStatements.exe True", AppWinStyle.Hide, True)
      End If

   End Sub

   Private Sub lnkStmts_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkStmts.Click
      ReRunStatements(Me.txtStmtDate.Text.ToString, CInt(Trim(Me.txtAcctNo.Text.ToString)))
   End Sub

   Protected Sub radRebal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles radRebal.SelectedIndexChanged
      Select Case radRebal.SelectedValue
         Case "A"
            Me.txtAcctNo.Visible = False
            Me.lblAccount.Visible = False
            Me.lblName.Visible = False
            Me.lblNameA.Visible = False
            Me.btnConfirm.Visible = False
         Case "S"
            Me.lblAccount.Text = "Account Number:"
            Me.txtAcctNo.Visible = True
            Me.lblAccount.Visible = True
            Me.lblName.Visible = True
            Me.lblNameA.Visible = True
            Me.btnConfirm.Visible = True
         Case "SA"
            Me.lblAccount.Text = "Attorney Number:"
            Me.txtAcctNo.Visible = True
            Me.lblAccount.Visible = True
            Me.lblName.Visible = True
            Me.lblNameA.Visible = True
            Me.btnConfirm.Visible = True
      End Select
      PFlag = radRebal.SelectedValue
   End Sub
End Class
