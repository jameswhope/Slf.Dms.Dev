Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class clients_client_creditors_accounts_action_collect
    Inherits System.Web.UI.Page

    Public CurrentFee As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Dim ClientID As Integer = StringHelper.ParseInt(Request.QueryString("id"))
        'Dim Amount As Double = StringHelper.ParseDouble(Request.QueryString("a"))
        'Dim Percent As Double = StringHelper.ParseDouble(Request.QueryString("pr"))

        'Dim RetainerFee As Double = Math.Round(Amount * Percent, 2)
        'Dim AddAccountFee As Double = StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", _
        '    "AdditionalAccountFee", "ClientID = " & ClientID))

        ''lblAddDefault.Text = AddAccountFee.ToString("c")
        ''lblRetainerDefault.Text = (Amount * Percent).ToString("c")

        'If AddAccountFee > RetainerFee Then
        '    lblInfo.Text = "Since the retainer fee for this new account is less than the minimum amount," _
        '        & " a new Additional Account Fee of " & AddAccountFee.ToString("c") & " will be added."
        'Else
        '    lblInfo.Text = "A new Retainer Fee of " & RetainerFee.ToString("c") & " will be added."
        'End If

    End Sub
End Class