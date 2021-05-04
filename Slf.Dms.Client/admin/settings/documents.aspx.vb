Option Explicit On

Imports Drg.Util.DataAccess

Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class admin_settings_documents
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public SortImage As String
    Public SortImagePath As String
#End Region

#Region "Structures"
    Public Structure DocType
        Public DocumentTypeID As Integer
        Public DocumentName As String
        Public DocType As String
        Public DocFolder As String

        Public Sub New(ByVal _DocumentTypeID As Integer, ByVal _DocumentName As String, ByVal _DocType As String, ByVal _DocFolder As String)
            Me.DocumentTypeID = _DocumentTypeID
            Me.DocumentName = _DocumentName
            Me.DocType = _DocType
            Me.DocFolder = _DocFolder
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        SetDisplay()

        If Not IsPostBack Then
            Session("SortField") = "TypeName"
            Session("SortOrder") = "ASC"
            LoadDocuments(GetSortString())
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/admin/settings/references") & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_book.png") & """ align=""absmiddle""/>Back to all references</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""AddDocument();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_new.png") & """ align=""absmiddle""/>Add new Document</a>")
    End Sub

    Public Sub LoadDocuments(Optional ByVal SortString As String = "")
        Dim docs As New List(Of DocType)

        Using cmd As New SqlCommand("SELECT DocumentTypeID, DisplayName, TypeID, DocFolder FROM tblDocumentType" & SortString, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        docs.Add(New DocType(Integer.Parse(reader("DocumentTypeID")), reader("DisplayName"), reader("TypeID"), reader("DocFolder")))
                    End While
                End Using
            End Using
        End Using

        rptDocuments.DataSource = docs
        rptDocuments.DataBind()
    End Sub

    Protected Sub lnkDeleteDoc_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDoc.Click
        Using cmd As New SqlCommand("DELETE tblDocumentType WHERE DocumentTypeID in (" & txtSelected.Value & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

                cmd.CommandText = "DELETE tblScanRelation WHERE DocumentTypeID in (" & txtSelected.Value & ")"

                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadDocuments()
    End Sub

    Protected Sub lnkResort_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadDocuments(GetSortString(txtSortField.Value))
    End Sub

    Private Function GetSortString(Optional ByVal NewSortField As String = "") As String
        If Session("SortField") = NewSortField Then
            If Session("SortOrder") = "ASC" Then
                Session("SortOrder") = "DESC"
            Else
                Session("SortOrder") = "ASC"
            End If
        Else
            Session("SortOrder") = "ASC"
        End If

        If NewSortField.Length > 0 Then
            Session("SortField") = NewSortField
        End If

        SortImage = "imgSort_" & Session("SortField")
        SortImagePath = ResolveUrl("~/images/sort-" & Session("SortOrder") & ".png")

        Return " ORDER BY " & Session("SortField") & " " & Session("SortOrder")
    End Function

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlDelete, c, "Clients-Client-Documents-Admin Controls")
    End Sub
End Class