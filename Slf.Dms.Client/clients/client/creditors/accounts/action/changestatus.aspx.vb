Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class clients_client_creditors_accounts_action_changestatus
    Inherits System.Web.UI.Page

    Public CurrentFee As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim ClientID As Integer = StringHelper.ParseInt(Request.QueryString("id"))
        Dim AccountID As Integer = StringHelper.ParseInt(Request.QueryString("aid"))

        Dim AccountStatusID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblAccount", "AccountStatusID", "AccountID = " & AccountID))

        Dim Code As String = DataHelper.FieldLookup("tblAccountStatus", "Code", "AccountStatusID = " & AccountStatusID)
        Dim Description As String = DataHelper.FieldLookup("tblAccountStatus", "Description", "AccountStatusID = " & AccountStatusID)

        If Code.Length > 0 And Description.Length > 0 Then
            lblInfo.Text = "The current status on this account is ""(" & Code & ") " & Description & """"
        Else
            lblInfo.Text = "There is no current status on this account."
        End If

        ddlAccountStatusID.Items.Clear()
        ddlAccountStatusID.Items.Add(New ListItem(String.Empty, 0))

        'load statuses without the current one or system ones
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblAccountStatus WHERE NOT [System] = 1 AND NOT AccountStatusID = " & AccountStatusID

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read

                        Code = DatabaseHelper.Peel_string(rd, "Code")
                        Description = DatabaseHelper.Peel_string(rd, "Description")
                        AccountStatusID = DatabaseHelper.Peel_int(rd, "AccountStatusID")

                        ddlAccountStatusID.Items.Add(New ListItem("(" & Code & ") " & Description, AccountStatusID.ToString()))

                    End While
                End Using
            End Using
        End Using

    End Sub
End Class