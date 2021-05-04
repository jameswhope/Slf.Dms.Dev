Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic
Imports Slf.Dms.Controls

Partial Class admin_users_group_members_default
    Inherits PermissionPage

#Region "Variables"

    Private UserID As Integer
    Protected UserGroupId As Integer
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            UserGroupId = DataHelper.Nz_int(qs("id"))
        End If

        If Not IsPostBack Then
            lnkUser.InnerHtml = DataHelper.FieldLookup("tblUserGroup", "Name", "UserGroupId=" & UserGroupId)
            lnkUser.HRef = ResolveUrl("~/admin/users/group/?id=" & UserGroupId)
        End If

        SetRollups()

        Requery()
    End Sub
    Private Sub Requery()
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetUsers")
        DatabaseHelper.AddParameter(cmd, "where", "tbluser.usergroupid=" & UserGroupId)
        grdMembers.DataCommand = cmd
    End Sub
    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_users_group_group).CommonTasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
    End Sub
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/users/")
    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Admin-Users-Group Single Record-Members")
    End Sub

End Class