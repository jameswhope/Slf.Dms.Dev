Imports Microsoft.VisualBasic
Imports System.Web
Imports System.Collections.Generic

Public Class GlobalFiles
    Public Class JQuery
        Public Shared JQuery As String = "~/jquery/jquery-1.7.2.min.js"
        Public Shared UI As String = "~/jquery/jquery-ui-1.9.0.custom.min.js"
        Public Shared CSS As String = "~/jquery/css/redmond/jquery-ui-1.9.0.custom.css"
    End Class

    Public Shared Function ResolveUrl(ByVal url As String) As String
        Return VirtualPathUtility.ToAbsolute(url)
        'Return New System.Web.UI.Control().ResolveUrl(url)
    End Function

    Public Shared Sub AddScriptFiles(ByVal paths As String())
        AddScriptFiles(ScriptManager.GetCurrent(HttpContext.Current.Handler), paths)
    End Sub

    Public Shared Sub AddScriptFiles(ByVal page As UI.Page, ByVal paths As String())
        AddScriptFiles(ScriptManager.GetCurrent(page), paths)
    End Sub

    Public Shared Sub AddScriptFiles(ByVal sm As ScriptManager, ByVal paths As String())
        For Each p As String In paths
            sm.Scripts.Add(New ScriptReference(p))
        Next
    End Sub

End Class
