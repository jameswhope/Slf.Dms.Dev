Imports Microsoft.VisualBasic

Public Class ReportPage
    Inherits System.Web.UI.Page


    Protected Overrides Sub OnInit(ByVal e As System.EventArgs)
        MyBase.OnInit(e)
        If (Not HttpContext.Current.Session Is Nothing) Then
            If (HttpContext.Current.Session.IsNewSession) Then
                Dim cookieHeader As String = Request.Headers("Cookie")
                If ((cookieHeader IsNot Nothing) AndAlso (cookieHeader.IndexOf("ASP.NET_SessionId") >= 0)) Then
                    Response.Redirect(Request.Url.ToString())
                End If
            End If
        End If

    End Sub

    Private Function GetSessionTimeoutInMs() As Integer
        Return (Me.Session.Timeout * 60000) - 10000
    End Function

End Class
