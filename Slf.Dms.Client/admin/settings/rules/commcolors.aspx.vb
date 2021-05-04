Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class admin_settings_negotiation_commcolors
    Inherits PermissionPage


#Region "Variables"
    Private UserID As Integer
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then
            LoadRecord()
        End If
        SetRollups()
    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddRule();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_add.png") & """ align=""absmiddle""/>Add new rule</a>")
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/settings/rules/")
    End Sub
    Private Sub Save()
        
    End Sub
    Private Sub LoadRecord()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("get_CommColorRules")
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    rpColors.DataSource = rd
                    rpColors.DataBind()
                End Using
            End Using
        End Using
    End Sub
#End Region
#Region "Util"
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
    Public Function GetColorField(ByVal o As Object) As String
        If IsDBNull(o) Then
            Return "&nbsp;"
        Else
            Dim s As String = CType(o, String)
            Return "<span style=""font-size:8px;border:solid 1px gray;width:12px;background-color:" & s & """></span>&nbsp;" & s
        End If

    End Function
#End Region


    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        If txtSelectedIDs.Value.Length > 0 Then
            'get selected "," delimited ID's
            Dim arr() As String = txtSelectedIDs.Value.Split(",")

            'delete array of ID's
            For Each s As String In arr
                DataHelper.Delete("tblRuleCommColor", "RuleCommColorID= " & s)
            Next
        End If

        'reload same page
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
End Class
