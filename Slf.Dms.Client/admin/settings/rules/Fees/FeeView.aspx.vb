Option Explicit On
'Option Strict On

Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Data

Partial Class admin_settings_rules_Fees_Default
    Inherits System.Web.UI.Page

   Protected Sub Page_PreLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreLoad
      AddTasks()
   End Sub

   Private Sub AddTasks()
      Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks
      'CommonTasks.Add("<td><img src=""../../../../images/48x48_users.png"" ""class=""drag"" ""title=""Settlement Entity""></td>")
      'CommonTasks.Add("<td><asp:DropDownList ID=""ddl"" Width=""100%"" runat=""server""></asp:DropDownList></td>")
      CommonTasks.Add("<td><img src=""../../../../images/48x48_reports.png"" ""class=""drag"" ""title=""Agencys"">Agencys<br></td>")
      CommonTasks.Add("<td><img src=""../../../../images/email.jpg"" ""class=""drag"" ""title=""Fees"">Fees<br></td>")
      'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Changes</a>")
      'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""default.aspx""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_book.png") & """ align=""absmiddle""/>Return to Settings</a>")
   End Sub
End Class
