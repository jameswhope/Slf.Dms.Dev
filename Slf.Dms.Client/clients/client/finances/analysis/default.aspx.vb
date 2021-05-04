Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_analysis_default
    Inherits PermissionPage

#Region "Variables"

    Private qs As QueryStringCollection

    Public Shadows ClientID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = StringHelper.ParseInt(qs("id"), 0)

            If Not IsPostBack Then

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/?id=" & ClientID

            End If

            SetRollups()

        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit() Then
            'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""Record_AddTransaction();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_entrytype.png") & """ align=""absmiddle""/>Add transaction</a>")
            'CommonTasks.Add("<hr size=""1""/>")
        End If

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
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
End Class