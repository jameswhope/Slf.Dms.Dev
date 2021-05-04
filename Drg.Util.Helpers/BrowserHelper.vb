Option Explicit On 

Imports System.Web
Imports System.Web.UI

Public Enum BrowserProperty
    Type
    Browser
    Version
    MajorVersion
    MinorVersion
    Platform
    Beta
    Crawler
    AOL
    Win16
    Win32
    Frames
    Tables
    Cookies
    VBScript
    JavaScript
    JavaApplets
    ActiveXControls
    CDF
End Enum

Public Class BrowserHelper

    Public Shared Function GetProperty(ByVal pg As Page, ByVal prop As BrowserProperty) As Object

        Dim bc As HttpBrowserCapabilities = pg.Request.Browser

        Return GetType(HttpBrowserCapabilities).GetProperty(prop.ToString).GetValue(bc, Nothing)

    End Function
End Class