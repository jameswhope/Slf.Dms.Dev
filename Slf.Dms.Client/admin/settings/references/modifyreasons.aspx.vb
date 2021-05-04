Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Controls
Imports Slf.Dms.Records

Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Reflection

Partial Class admin_settings_references_modifyreasons
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Private currentParent As String
#End Region

    Public Structure ReasonDesc
        Public id As Integer
        Public order As String
        Public desc As String
        Public parent As String

        Public Sub New(ByVal reasonid As Integer, ByVal reasonorder As String, ByVal description As String, ByVal par As String)
            Me.id = reasonid
            Me.order = reasonorder
            Me.desc = description
            Me.parent = par
        End Sub
    End Structure

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim parent As String

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Request.QueryString("parent") Is Nothing Then
            parent = "null"
        Else
            parent = Request.QueryString("parent")
        End If

        currentParent = parent

        FillReasons(parent)
        CreateBreadcrumbs(parent)

        If Not IsPostBack Then
            SetRollups()
        End If
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:ShowAddReason();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_file_add.png") + """ align=""absmiddle""/>Add Reason</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:RemoveReason();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_delete.png") + """ align=""absmiddle""/>Remove Reason</a>")
    End Sub

    Protected Sub lnkAddReason_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddReason.Click
        Dim tempID As Integer
        Dim cmdStr As String = "SELECT count(*) FROM tblReasonsDesc WHERE DisplayOrder = " + txtOrder.Text + " and (Deleted is null or Deleted = 0) and ParentReasonsDescID " + IIf(currentParent = "null", "is null", "= " + currentParent)
        Dim desc As String = txtDesc.Text.Replace("'", "''")

        If desc.Trim().ToLower() = "other" Then
            desc = "<other>"
        End If

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If cmd.ExecuteScalar() > 0 Then
                    cmd.CommandText = "UPDATE tblReasonsDesc SET DisplayOrder = DisplayOrder + 1 WHERE ParentReasonsDescID " _
                        + IIf(currentParent = "null", "is null", "= " + currentParent) + " and DisplayOrder >= " + txtOrder.Text
                    cmd.ExecuteNonQuery()
                End If

                cmd.CommandText = "INSERT INTO tblReasonsDesc VALUES (" + txtOrder.Text + ", '" + desc + "', null, null, null, null, null, null, null, null, " + currentParent + ", null, null)"

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Response.Redirect("modifyreasons.aspx?parent=null")
    End Sub

    Protected Sub lnkRemoveReason_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemoveReason.Click
        Using cmd As New SqlCommand("UPDATE tblReasonsDesc SET Deleted = 1, DeletedBy = " + UserID.ToString() + " WHERE ReasonsDescID = " + currentParent.ToString() + " or ParentReasonsDescID = " + currentParent.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        Response.Redirect("modifyreasons.aspx?parent=null")
    End Sub

    Private Sub CreateBreadcrumbs(ByVal parent As String)
        Dim crumbs As String = ""
        Dim curID As String = parent

        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                While Not curID = "null"
                    cmd.CommandText = "SELECT TOP 1 Description, isnull(ParentReasonsDescID, -1) as Parent FROM tblReasonsDesc WHERE (Deleted is null or Deleted = 0) and ReasonsDescID = " + curID
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        reader.Read()
                        crumbs = "<a href=""modifyreasons.aspx?parent=" + curID + """>" + reader("Description").ToString() + "</a> > " + crumbs
                        curID = IIf(reader("Parent") = -1, "null", reader("Parent").ToString())
                    End Using
                End While
            End Using
        End Using

        lblTree.Text = "<a href=""modifyreasons.aspx?parent=null"">Home</a> > " + crumbs
    End Sub

    Private Sub FillReasons(ByVal parent As String)
        Dim reasonsList As New List(Of ReasonDesc)
        Dim cmdStr As String = "SELECT ReasonsDescID, DisplayOrder, Description " _
            + "FROM tblReasonsDesc WHERE (Deleted is null or Deleted = 0) and ParentReasonsDescID = " + parent + " ORDER BY DisplayOrder"

        If parent = "null" Then
            cmdStr = "SELECT ReasonsDescID, DisplayOrder, Description " _
            + "FROM tblReasonsDesc WHERE (Deleted is null or Deleted = 0) and ParentReasonsDescID is null ORDER BY DisplayOrder"
        End If

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        reasonsList.Add(New ReasonDesc(CInt(reader("ReasonsDescID")), reader("DisplayOrder").ToString(), reader("Description").ToString().Replace("<other>", "OTHER"), parent))
                    End While
                End Using
            End Using
        End Using

        rptReasons.DataSource = reasonsList
        rptReasons.DataBind()
    End Sub
End Class