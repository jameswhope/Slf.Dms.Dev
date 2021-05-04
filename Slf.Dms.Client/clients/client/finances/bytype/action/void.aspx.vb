Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient

Partial Class clients_client_finances_bytype_action_void
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim UserID As Integer = DataHelper.Nz_int(User.Identity.Name)
        Dim ClientID As Integer = DataHelper.Nz_int(Request.QueryString("id"))

        lblBy.Text = UserHelper.GetName(UserID)
        imVoid.Text = DateTime.Now.ToString("MM/dd/yyyy hh:mm tt")

        LoadReasons()
    End Sub

    Private Sub LoadReasons()
        Using cmd As New SqlCommand("SELECT DisplayName, Reason FROM tblTranVoidReason", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlReason.Items.Add(New ListItem(reader("DisplayName"), reader("Reason")))
                    End While
                End Using
            End Using
        End Using

        ddlReason.Items.Add(New ListItem("-- SELECT --", "SELECT"))
        ddlReason.SelectedValue = "SELECT"
    End Sub
End Class