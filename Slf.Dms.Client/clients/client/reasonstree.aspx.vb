Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Web.Configuration
Imports Slf.Dms.Records

Partial Class Clients_client_reasonsTree
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Private ClientID As Integer
    Private dateStr As String
    Public Expanding As Boolean
    Public Saved As Boolean
    Public Allowed As Boolean
#End Region

#Region "Structures"
    Private Structure ReasonsNode
        Public Description As String
        Public ParentReasonsID As Integer

        Public Sub New(ByVal desc As String, ByVal parentid As Integer)
            Me.Description = desc
            Me.ParentReasonsID = parentid
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        ClientID = CInt(Request.QueryString("id"))
        dateStr = Request.QueryString("date").ToString()

        SetRollups()

        If Not IsPostBack Then
            BuildReasonsTree()
            Expanding = False
            Allowed = False
        End If

        lblNote.Text = ""
    End Sub

    Private Sub BuildReasonsTree()
        Dim reasonsTree As New Dictionary(Of Integer, ReasonsNode)

        trvReasons.Nodes.Clear()

        Using cmd As New SqlCommand("SELECT ReasonsDescID, Description, isnull(ParentReasonsDescID, -1) as ParentReasonsDescID FROM tblReasonsDesc WHERE Deleted is null or Deleted = 0 ORDER BY ParentReasonsDescID, DisplayOrder", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        reasonsTree.Add(DatabaseHelper.Peel_int(reader, "ReasonsDescID"), New ReasonsNode(DatabaseHelper.Peel_string(reader, "Description"), DatabaseHelper.Peel_int(reader, "ParentReasonsDescID")))
                    End While
                End Using
            End Using
        End Using

        Dim reasonsNode As ReasonsNode

        For Each reasonsID As Integer In reasonsTree.Keys
            reasonsNode = reasonsTree(reasonsID)
            If reasonsNode.ParentReasonsID < 0 Then
                If reasonsNode.Description.ToLower().Contains("<other>") Then
                    trvReasons.Nodes.Add(New TreeNode("<img id=""extraIMG"" align=""absmiddle"" src=""" + ResolveURL("~/images/ReasonsIcon.jpg") + """ style=""border:0px;"" alt="""" />&nbsp;&nbsp;Other:&nbsp;&nbsp;<input id=""txtOther" + reasonsID.ToString() + """ type=""text"" maxlength=""500"" size=""45"" style=""height:17px;font-size:10px;"" enableviewstate=""true"" onblur=""javascript:OnOtherChange(this);""></input>" + reasonsNode.Description, reasonsID))
                Else
                    trvReasons.Nodes.Add(New TreeNode("<img id=""extraIMG"" align=""absmiddle"" src=""" + ResolveURL("~/images/ReasonsIcon.jpg") + """ style=""border:0px;"" alt="""" />&nbsp;&nbsp;" + reasonsNode.Description, reasonsID))
                End If
            Else
                AddNodeRec(reasonsNode, trvReasons.Nodes, reasonsID)
            End If
        Next

    End Sub

    Private Sub AddNodeRec(ByVal reasonsNode As ReasonsNode, ByRef nodeCol As TreeNodeCollection, ByVal reasonsID As Integer)
        For Each node As TreeNode In nodeCol
            If node.Value = reasonsNode.ParentReasonsID Then
                If reasonsNode.Description.ToLower().Contains("<other>") Then
                    node.ChildNodes.Add(New TreeNode("Other:&nbsp;&nbsp;<input id=""txtOther" + reasonsID.ToString() + """ type=""text"" maxlength=""500"" size=""45"" style=""height:17px;font-size:10px;"" enableviewstate=""true"" onblur=""javascript:OnOtherChange(this);""></input>", -1))
                Else
                    node.ChildNodes.Add(New TreeNode(reasonsNode.Description, reasonsID))
                End If

                Return
            Else
                AddNodeRec(reasonsNode, node.ChildNodes, reasonsID)
            End If
        Next
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:SaveReasons();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_save.png") + """ align=""absmiddle""/>Save Reasons</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:Cancel();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_back.png") + """ align=""absmiddle""/>Cancel</a>")
    End Sub

    Protected Sub trvReasons_OnTreeNodeExpanded(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles trvReasons.TreeNodeExpanded
        If e.Node.depth = 0 And Not Expanding Then
            Expanding = True
            trvReasons.CollapseAll()
            e.Node.Expand()
            Expanding = False
        End If

    End Sub

    Private Sub lnkCancel_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Allowed = True
        Response.Redirect("roadmap.aspx?id=" + ClientID.ToString())
    End Sub

    Private Sub lnkSaveReasons_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveReasons.Click
        Saved = False
        SaveReasonsRec(trvReasons.Nodes)

        If Saved = True Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                    DatabaseHelper.AddParameter(cmd, "ClientStatusId", 17)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                    DatabaseHelper.AddParameter(cmd, "Reason", "Manually created")
                    DatabaseHelper.AddParameter(cmd, "Created", DateTime.Parse(dateStr))
                    DatabaseHelper.AddParameter(cmd, "LastModified", DateTime.Parse(dateStr))
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                    DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmap")
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()

                    cmd.CommandText = "UPDATE tblClient SET CurrentClientStatusID = 17 WHERE ClientID = " + ClientID.ToString()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            Response.Redirect("~/clients/client/?id=" + ClientID.ToString())
        Else
            lblNote.Visible = True
            lblNote.Text = "Please select a reason or hit Cancel to go back..."
        End If
    End Sub

    Private Sub SaveReasonsRec(ByRef nodeCol As TreeNodeCollection)
        For Each reason As TreeNode In nodeCol
            If reason.Checked = True Then
                If reason.Text.Contains("Other:") Then
                    Dim otherReason As String = reason.Text
                    RemoveHTML(otherReason)

                    SaveReason(reason.Value, otherReason)
                Else
                    SaveReason(reason.Value)
                End If
            Else
                SaveReasonsRec(reason.ChildNodes)
            End If
        Next
    End Sub

    Private Sub SaveReason(ByVal reasonID As Integer, Optional ByVal otherReason As String = "")
        Dim cmdStr As String = "INSERT INTO tblReasons VALUES (" + ClientID.ToString() + ", 'ClientID', " + reasonID.ToString() + ", " + IIf(otherReason.Length > 0, "'" + otherReason + "'", "null") + ", getdate(), " + UserID.ToString() + ")"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Saved = True
    End Sub

#Region "RemoveHTML"
    Private Sub RemoveHTML(ByRef str As String)
        RemoveIMG(str)
        RemoveNBSP(str)
        ReplaceINPUT(str)
    End Sub

    Private Sub RemoveIMG(ByRef str As String)
        Dim startIdx As Integer = str.IndexOf("<img")
        Dim endIdx As Integer = str.IndexOf("/>")

        If startIdx > -1 And endIdx > -1 Then
            str = str.Remove(startIdx, (endIdx - startIdx) + 2)
        End If
    End Sub

    Private Sub RemoveNBSP(ByRef str As String)
        str = str.Replace("&nbsp;", "")
    End Sub

    Private Sub ReplaceINPUT(ByRef str As String)
        Dim others As Dictionary(Of Integer, String) = ParseOthers()
        Dim strIndex As String
        Dim idxInput As Integer = str.IndexOf("<input")
        Dim idxInputEnd As Integer
        Dim idxID As Integer
        Dim idxIDEnd As Integer

        While idxInput > -1
            idxInputEnd = str.IndexOf("</input>", idxInput) + 8
            idxID = str.IndexOf("txtOther", idxInput) + 8
            idxIDEnd = str.IndexOf("""", idxID)
            strIndex = str.Substring(idxID, idxIDEnd - idxID)
            str = "Other: " + others(Integer.Parse(strIndex))
            idxInput = str.IndexOf("<input", idxInput + 1)
        End While
    End Sub

    Private Function ParseOthers() As Dictionary(Of Integer, String)
        Dim others As New Dictionary(Of Integer, String)
        Dim pairs() As String
        Dim key() As String
        Dim intKey As Integer

        If Not (hdnOthers.Value Is Nothing And hdnOthers.Value.ToString().Length < 0) Then
            pairs = hdnOthers.Value.ToString().Split(";")

            For Each keypair As String In pairs
                key = keypair.Split(",")

                If key.Length = 2 AndAlso (key(0).Length > 0 And key(1).Length > 0) Then
                    intKey = Integer.Parse(key(0).Substring(8))
                    If others.ContainsKey(intKey) Then
                        others(intKey) += ", " + key(1)
                    Else
                        others.Add(intKey, key(1))
                    End If
                End If
            Next
        End If

        Return others
    End Function
#End Region
End Class