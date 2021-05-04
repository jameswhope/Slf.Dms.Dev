Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Imports Slf.Dms.Controls.PermissionHelper
Imports System.Diagnostics
Imports iTextSharp
Imports iTextSharp.text.pdf

Imports ClientFileDocumentHelper
Imports System.Net

Partial Class ArchiveViewer
    Inherits System.Web.UI.Page

    Protected Sub ArchiveViewer_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ArchivedPath As String = Request.QueryString("ap")
        ArchivedPath = "http://web1/" & ArchivedPath.Substring(InStr(ArchivedPath, "ClientArchive") - 1)
        ArchivedPath = ArchivedPath.Replace("\", "/")
        Me.frViewer.Attributes.Add("src", ArchivedPath)
    End Sub
End Class
