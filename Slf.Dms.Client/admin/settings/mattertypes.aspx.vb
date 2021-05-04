Option Explicit On

Imports Drg.Util.DataAccess

Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class admin_settings_mattertypes
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public SortImage As String
    Public SortImagePath As String
#End Region

#Region "Structures"
    Public Structure MatterType
        Public MatterTypeID As Integer
        Public MatterTypeCode As String
        Public MatterTypeShortDescr As String
        Public IsActive As Boolean
        Public MatterGroup As String

        Public Sub New(ByVal _MatterTypeID As Integer, ByVal _MatterTypeCode As String, ByVal _MatterTypeShortDescr As String, ByVal _IsActive As Boolean, ByVal _MatterGroup As String)
            Me.MatterTypeID = _MatterTypeID
            Me.MatterTypeCode = _MatterTypeCode
            Me.MatterTypeShortDescr = _MatterTypeShortDescr
            Me.IsActive = _IsActive
            Me.MatterGroup = _MatterGroup
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        SetDisplay()

        If Not IsPostBack Then
            Session("SortField") = "MatterTypeCode"
            Session("SortOrder") = "ASC"
            LoadMatterTypes(GetSortString())
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/admin/settings/references") & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_book.png") & """ align=""absmiddle""/>Back to all references</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""AddMatterType();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_new.png") & """ align=""absmiddle""/>Add New Mattertype</a>")

        lblTitle.Text = "Matter Types"
    End Sub

    Public Sub LoadMatterTypes(Optional ByVal SortString As String = "")
        Dim mattertypes As New List(Of MatterType)

        Using cmd As New SqlCommand("SELECT MatterTypeId, MatterTypeCode, MatterTypeShortDescr, IsActive, MatterGroup FROM tblMatterType T left outer join tblMatterGroup G on T.MatterGroupId=G.MatterGroupId" & SortString, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        mattertypes.Add(New MatterType(Integer.Parse(reader("MatterTypeId")), reader("MatterTypeCode"), reader("MatterTypeShortDescr"), Boolean.Parse(reader("IsActive")), DataHelper.Nz_string(reader("MatterGroup"))))
                    End While
                End Using
            End Using
        End Using

        rptDocuments.DataSource = mattertypes
        rptDocuments.DataBind()
    End Sub

    Protected Sub lnkDeleteDoc_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDoc.Click
        Using cmd As New SqlCommand("DELETE tblMatterType WHERE MatterTypeID in (" & txtSelected.Value & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

            End Using
        End Using

        LoadMatterTypes()
    End Sub

    Protected Sub lnkResort_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadMatterTypes(GetSortString(txtSortField.Value))
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