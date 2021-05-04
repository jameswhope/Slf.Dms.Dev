Option Explicit On

Imports Drg.Util.DataAccess
Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class admin_settings_matterPhoneNotes
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public SortImage As String
    Public SortImagePath As String
#End Region

#Region "Structures"
 
    Public Structure MatterPhoneNoteTemplate

        Public MatterPhoneEntryId As Integer
        Public PhoneEntry As String
        Public PhoneEntryDesc As String
        Public PhoneEntryBody As String
        Public IsActive As Boolean

        Public Sub New(ByVal _MatterPhoneId As Integer, ByVal _PhoneEntry As String, ByVal _PhoneEntryDesc As String, ByVal _PhoneEntryBody As String, ByVal _IsActive As Boolean)
            Me.MatterPhoneEntryId = _MatterPhoneId
            Me.PhoneEntry = _PhoneEntry
            Me.PhoneEntryDesc = _PhoneEntryDesc
            Me.PhoneEntryBody = _PhoneEntryBody
            Me.IsActive = _IsActive
        End Sub

    End Structure

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        SetDisplay()

        If Not IsPostBack Then
            Session("SortField") = "PhoneEntry"
            Session("SortOrder") = "ASC"
            LoadMatterPhoneNoteTemplates(GetSortString())
        End If
    End Sub

    Private Sub SetDisplay()
        lblTitle.Text = "Matter Phone Note Templates"

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/admin/settings/references") & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_book.png") & """ align=""absmiddle""/>References</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""AddTemplate();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_new.png") & """ align=""absmiddle""/>Add new Template</a>")
    End Sub



    Public Sub LoadMatterPhoneNoteTemplates(Optional ByVal SortString As String = "")
        Dim PhoneNotes As New List(Of MatterPhoneNoteTemplate)

        Using cmd As New SqlCommand("Select MatterPhoneEntryId,PhoneEntry,PhoneEntryDesc,PhoneEntryBody,IsActive from dbo.tblMatterPhoneEntry " & SortString, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        PhoneNotes.Add(New MatterPhoneNoteTemplate(Integer.Parse(reader("MatterPhoneEntryId")), reader("PhoneEntry"), reader("PhoneEntryDesc"), reader("PhoneEntryBody"), DataHelper.Nz_string(reader("IsActive"))))
                    End While
                End Using
            End Using
        End Using

        rptMatterPhoneNotes.DataSource = PhoneNotes
        rptMatterPhoneNotes.DataBind()
    End Sub

    Protected Sub lnkDeleteDoc_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDoc.Click
        Using cmd As New SqlCommand("Update tblMatterPhoneEntry ID SET IsActive = 0  Where MatterPhoneEntryId ='" & txtSelected.Value & "')", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

            End Using
        End Using
        LoadMatterPhoneNoteTemplates(GetSortString())
    End Sub

    Protected Sub lnkResort_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadMatterPhoneNoteTemplates(GetSortString(txtSortField.Value))
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
    End Sub
End Class