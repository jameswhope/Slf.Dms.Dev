Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient

Partial Class clients_client_finances_bytype_action_bounce
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim UserID As Integer = DataHelper.Nz_int(User.Identity.Name)
        Dim ClientID As Integer = DataHelper.Nz_int(Request.QueryString("id"))

        lblBy.Text = UserHelper.GetName(UserID)
        imBounce.Text = DateTime.Now.ToString("MM/dd/yyyy hh:mm tt")

        Dim ReturnedCheckFee As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", _
            "ReturnedCheckFee", "ClientID = " & ClientID))

        lblReturnedCheckFee.Text = ReturnedCheckFee.ToString("c")

        LoadReasons()

    End Sub

    Private Sub LoadReasons()
        Using cmd As New SqlCommand("SELECT BouncedID, BouncedDescription, BouncedCode FROM tblBouncedReasons ORDER BY BouncedCode", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlBReason.Items.Add(New ListItem(reader("BouncedCode") & " - " & reader("BouncedDescription"), reader("BouncedID")))
                    End While
                End Using
            End Using
        End Using

        ddlBReason.SelectedValue = 1
    End Sub
End Class