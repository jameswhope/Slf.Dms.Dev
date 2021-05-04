Imports Drg.Util.DataAccess
Imports System.Data

Partial Class Agency_agency
    Inherits System.Web.UI.MasterPage

    Private UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If

        If Not Page.IsPostBack Then
            Dim intCompanyID As Integer
            Dim intUserGroup As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserID=" & UserID))
            Dim objUser As New Drg.Util.DataHelpers.UserHelper
            Dim tblCompany As New Data.DataTable
            Dim row As Data.DataRow
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Dim da As New Data.SqlClient.SqlDataAdapter
            Dim li As ListItem

            Select Case intUserGroup
                Case 11 'Admin, Sys Admin
                    ddlUsers.DataSource = objUser.GetCommRecAccessUsers
                    ddlUsers.DataTextField = "user"
                    ddlUsers.DataValueField = "userid"
                    ddlUsers.DataBind()
                    ddlUsers.Visible = True

                    li = ddlUsers.Items.FindByValue(UserID)
                    If Not IsNothing(li) Then
                        li.Selected = True
                    End If

            End Select

            'Load user's companies
            cmd.CommandText = "select c.companyid, c.shortconame from tblcompany c join tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = @UserID order by c.shortconame"
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)
            da.SelectCommand = cmd
            da.Fill(tblCompany)

            row = tblCompany.NewRow
            row("companyid") = "-1"
            row("shortconame") = "All"
            tblCompany.Rows.InsertAt(row, 0)
            ddlCompany.DataSource = tblCompany
            ddlCompany.DataTextField = "shortconame"
            ddlCompany.DataValueField = "companyid"
            ddlCompany.DataBind()

            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)

            If IsNumeric(Request.QueryString("c")) Then
                intCompanyID = CInt(Request.QueryString("c"))
            End If

            li = ddlCompany.Items.FindByValue(intCompanyID)
            If Not IsNothing(li) Then
                li.Selected = True
            End If

            aDefault.HRef = "default.aspx?id=" & UserID & "&c=" & ddlCompany.SelectedItem.Value
            'aPaymentSummary.HRef = "paymentsummary.aspx?id=" & UserID & "&c=" & ddlCompany.SelectedItem.Value
            aComparison.HRef = "comparison.aspx?id=" & UserID & "&c=" & ddlCompany.SelectedItem.Value
            aRetention.HRef = "client_retention.aspx?id=" & UserID & "&c=" & ddlCompany.SelectedItem.Value

            objUser = Nothing
        End If
    End Sub

    Protected Sub ddlUsers_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlUsers.SelectedIndexChanged
        If ddlUsers.SelectedIndex > 0 Then
            Redirect("id", ddlUsers.SelectedItem.Value)
        End If
    End Sub

    Protected Sub ddlCompany_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCompany.SelectedIndexChanged
        Redirect("c", ddlCompany.SelectedItem.Value)
    End Sub

    Private Sub Redirect(ByVal name As String, ByVal newvalue As String)
        Dim uri As String = Page.Request.Url.AbsoluteUri
        Dim cur As String = "?" & name & "=" & Request.QueryString(name)
        Dim [new] As String = "?" & name & "=" & newvalue

        If Page.Request.Url.Query = "" Then
            uri &= "?id=" & UserID & "&c=" & ddlCompany.SelectedItem.Value
        Else
            If InStr(uri, cur) > 0 Then
                uri = Replace(Page.Request.Url.AbsoluteUri, cur, [new])
            Else
                uri = Replace(Page.Request.Url.AbsoluteUri, cur.Replace("?", "&"), [new].Replace("?", "&"))
            End If
        End If

        Response.Redirect(uri)
    End Sub
End Class

