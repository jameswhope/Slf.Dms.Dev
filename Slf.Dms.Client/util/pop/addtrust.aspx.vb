Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class util_pop_addtrust
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then

            LoadStates()

            SetAttributes()

        End If

    End Sub
    Private Sub SetAttributes()

        txtRoutingNumber.Attributes("onkeypress") = "onlyDigits();"
        txtAccountNumber.Attributes("onkeypress") = "onlyDigits();"

    End Sub
    Private Sub LoadStates()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblState ORDER BY [Name]"

        cboStateID.Items.Clear()
        cboStateID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboStateID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "StateID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        ' insert trust
        Dim TrustID As Integer = TrustHelper.Insert(txtName.Text, txtCity.Text, _
            cboStateID.SelectedValue, txtRoutingNumber.Text, txtAccountNumber.Text, UserID)

        'flip the main panel off
        pnlMain.Visible = False
        pnlMessage.Visible = True

        ltrJScript.Text = "<script type=""text/javascript"">Record_Propagate(" _
            & TrustID & ",""" & txtName.Text & """);window.close();</script>"

    End Sub
End Class