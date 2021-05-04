Option Explicit On

Imports Drg.Util.DataAccess

Imports System
Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class admin_settings_tasktypes
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public SortImage As String
    Public SortImagePath As String
#End Region

#Region "Structures"
    Public Structure TaskType
        Public TaskTypeID As Integer
        Public TaskTypeCategoryID As Integer
        Public TaskTypeCategory As String
        Public TaskType As String
        Public DefaultDescription As String
        Public TaskInstruction As String

        Public Sub New(ByVal _TaskTypeID As Integer, ByVal _TaskTypeCategory As String, ByVal _TaskTypeCategoryID As Integer, ByVal _TaskType As String, ByVal _DefaultDescription As String, ByVal _TaskInstruction As String)
            Me.TaskTypeID = _TaskTypeID
            Me.TaskTypeCategoryID = _TaskTypeCategoryID
            Me.TaskTypeCategory = _TaskTypeCategory
            Me.TaskType = _TaskType
            Me.DefaultDescription = _DefaultDescription
            Me.TaskInstruction = _TaskInstruction
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        SetDisplay()

        If Not IsPostBack Then
            Session("SortField") = "TaskTypeID"
            Session("SortOrder") = "ASC"
            LoadTaskTypes(GetSortString())
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/admin/settings/references") & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_book.png") & """ align=""absmiddle""/>Back to all references</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""AddTaskType();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_new.png") & """ align=""absmiddle""/>Add New Tasktype</a>")

        lblTitle.Text = "Task Types"
    End Sub

    Public Sub LoadTaskTypes(Optional ByVal SortString As String = "")
        Dim tasktypes As New List(Of TaskType)
        'ByVal _TaskTypeID As Integer, ByVal _TaskTypeCategory As String, ByVal _TaskTypeCategoryID As Integer, ByVal _TaskType As String, ByVal _DefaultDescription As String, ByVal _TaskInstruction As String
        Using cmd As New SqlCommand("SELECT TaskTypeId, T.TaskTypeCategoryID, T.Name As TaskType, DefaultDescription, TaskInstruction, C.Name TaskTypeCategory FROM tblTaskType T, tblTaskTypeCategory C Where C.TaskTypeCategoryID=T.TaskTypeCategoryID " & SortString, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tasktypes.Add(New TaskType(Integer.Parse(reader("TaskTypeId")), reader("TaskTypeCategory"), Integer.Parse(reader("TaskTypeCategoryID")), reader("TaskType"), reader("DefaultDescription"), reader("TaskInstruction")))
                    End While
                End Using
            End Using
        End Using

        rptDocuments.DataSource = tasktypes
        rptDocuments.DataBind()
    End Sub

    Protected Sub lnkDeleteDoc_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDoc.Click
        Using cmd As New SqlCommand("DELETE tblTaskType WHERE TaskTypeID in (" & txtSelected.Value & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()

            End Using
        End Using

        LoadTaskTypes()
    End Sub

    Protected Sub lnkResort_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadTaskTypes(GetSortString(txtSortField.Value))
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