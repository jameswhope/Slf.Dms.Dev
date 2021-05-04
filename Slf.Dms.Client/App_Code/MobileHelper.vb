Imports Microsoft.VisualBasic

Public Class MobileHelper

    Public Shared Function IsMobileDevice(ByVal userAgent As String) As Boolean
        userAgent = userAgent.ToLower
        Return userAgent.Contains("iphone") _
            Or userAgent.Contains("ppc") _
            Or userAgent.Contains("windows ce") _
            Or userAgent.Contains("blackberry") _
            Or userAgent.Contains("opera mini") _
            Or userAgent.Contains("mobile") _
            Or userAgent.Contains("palm") _
            Or userAgent.Contains("portable")
    End Function

End Class
