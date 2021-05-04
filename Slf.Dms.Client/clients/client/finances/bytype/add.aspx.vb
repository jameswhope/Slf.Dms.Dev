Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Partial Class clients_client_finances_register_add
    Inherits PermissionPage

#Region "Variables"

    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            SetupCommonTasks()

            trInfoBox.Visible = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
                "UserID = " & UserID & " AND InfoBoxID = " & 8) = 0

        End If

    End Sub
    Private Sub SetupCommonTasks()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then

            If Permission.UserEdit(Master.IsMy) Then
                'add applicant tasks
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If

            'add normal tasks

        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinanceRegister.HRef = "~/clients/client/finances/register/?id=" & ClientID

        aAddDeposit.HRef = "adddep.aspx?id=" & ClientID
        aAddFee.HRef = "addf.aspx?id=" & ClientID
        aAddFeeAdjustment.HRef = "addfa.aspx?id=" & ClientID
        aAddDebit.HRef = "adddeb.aspx?id=" & ClientID

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()

        'get last page referrer by cycling backwards
        Dim Navigator As Navigator = CType(Page.Master, clients_client).MasterNavigator

        Dim i As Integer = Navigator.Pages.Count - 1

        While i >= 0 AndAlso Navigator.Pages(i).Url.IndexOf("bytype/add.aspx") 'not found

            'decrement i
            i -= 1

        End While

        If i >= 0 Then
            Response.Redirect(Navigator.Pages(i).Url)
        Else
            Response.Redirect("~/clients/client/finances/register/?id=" & ClientID)
        End If

    End Sub
    Protected Sub lnkCloseInformation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformation.Click

        'insert flag record
        UserInfoBoxHelper.Insert(8, UserID)

        'reload
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
End Class