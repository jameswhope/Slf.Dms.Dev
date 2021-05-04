Option Explicit On

Imports Drg.Util.DataAccess

Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class admin_settings_mattergroups
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public SortImage As String
    Public SortImagePath As String
#End Region

#Region "Structures"
    Public Structure MatterGroup
        Public MatterGroupID As Integer
        Public MatterGroup As String
        Public MatterGroupDescr As String

        Public Sub New(ByVal _MatterGroupID As Integer, ByVal _MatterGroup As String, ByVal _MatterGroupDescr As String)
            Me.MatterGroupID = _MatterGroupID
            Me.MatterGroup = _MatterGroup
            Me.MatterGroupDescr = _MatterGroupDescr
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        SetDisplay()

        If Not IsPostBack Then
            Session("SortField") = "MatterGroup"
            Session("SortOrder") = "ASC"
            LoadMatterGroups(GetSortString())
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/admin/settings/references") & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_book.png") & """ align=""absmiddle""/>Back to references</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""AddMatterGroup();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_new.png") & """ align=""absmiddle""/>Add Mattergroup</a>")

        lblTitle.Text = "Matter Groups"
    End Sub

    Public Sub LoadMatterGroups(Optional ByVal SortString As String = "")
        Dim mattergroups As New List(Of MatterGroup)

        Using cmd As New SqlCommand("SELECT MatterGroupId, MatterGroup, MatterGroupDescr FROM tblMatterGroup" & SortString, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        mattergroups.Add(New MatterGroup(Integer.Parse(reader("MatterGroupId")), reader("MatterGroup"), reader("MatterGroupDescr")))
                    End While
                End Using
            End Using
        End Using

        rptDocuments.DataSource = mattergroups
        rptDocuments.DataBind()
    End Sub

    Protected Sub lnkDeleteDoc_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDoc.Click
        Using cmd As New SqlCommand("DELETE tblMatterGroup WHERE MatterGroupId in (" & txtSelected.Value & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

            End Using
        End Using

        LoadMatterGroups()
    End Sub

    Protected Sub lnkResort_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadMatterGroups(GetSortString(txtSortField.Value))
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