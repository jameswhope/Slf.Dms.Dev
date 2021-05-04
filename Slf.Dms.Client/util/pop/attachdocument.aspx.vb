Imports Drg.Util.DataAccess

Imports SharedFunctions

Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO
Imports System.Data

Partial Class util_pop_attachdocument
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private ClientID As Integer
    Private DocumentRoot As String
    Private AccountNumber As String
    Private RelationType As String
    Private RelationID As Integer
    Private IsTemp As Boolean
    Public AddRelationID As Integer
    Public AddRelationType As String
#End Region

#Region "Structures"
    Public Structure DocScan
        Public DocumentName As String
        Public Received As String
        Public Created As String
        Public CreatedBy As String

        Public Sub New(ByVal _DocumentName As String, ByVal _Received As String, ByVal _Created As String, ByVal _CreatedBy As String)
            Me.DocumentName = _DocumentName
            Me.Received = _Received
            Me.Created = _Created
            Me.CreatedBy = _CreatedBy
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        ClientID = Integer.Parse(Request.QueryString("id"))
        RelationType = Request.QueryString("type")
        RelationID = Integer.Parse(Request.QueryString("rel"))
        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString())
        DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
            DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber

        Dim gID As Integer = DataHelper.FieldLookup("tbluser", "usergroupid", String.Format("userid = {0}", UserID))

        If Request.QueryString("temp") Is Nothing Then
            IsTemp = False
        Else
            IsTemp = True
        End If

        If Not Request.QueryString("addrelid") Is Nothing Then
            AddRelationID = Integer.Parse(Request.QueryString("addrelid"))
            AddRelationType = Request.QueryString("addrel")
        Else
            AddRelationID = 0
        End If

        tdNoDir.Visible = False

        If Not IsPostBack Then
            If gID = 11 Then
                fldUploadDoc.Style("display") = "block"
            Else
                fldUploadDoc.Style("display") = "none"
            End If


            FillDocumentTree()
            LoadDocumentsDDL()
        End If
    End Sub
    Private Sub LoadDocumentsDDL()
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync("select distinct typeid, displayname from tbldocumenttype where not typeid like '%scan%' order by displayname", ConfigurationManager.AppSettings("connectionstring").ToString)
            ddlDocuments.DataTextField = "displayname"
            ddlDocuments.DataValueField = "typeid"

            ddlDocuments.DataSource = dt
            ddlDocuments.DataBind()
        End Using


    End Sub
    Private Function LoadDoc(ByVal documentName As String) As DocScan
        Dim final As DocScan
        Dim docID As String
        Dim docTypeID As String
        Dim idx1 As Integer = documentName.IndexOf("_", 0) + 1
        Dim idx2 As Integer = documentName.IndexOf("_", idx1)
        Dim tempReceived As Date
        Dim tempCreated As Date

        docTypeID = documentName.Substring(idx1, idx2 - idx1)

        idx1 = documentName.IndexOf("_", idx2) + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)

        Dim cmdStr As String = "SELECT isnull(dt.DisplayName, '') as DisplayName, isnull(ds.ReceivedDate, '01-01-1900') as Received, isnull(ds.Created, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocScan as ds left join tblUser as u on u.UserID = ds.CreatedBy left join tblDocumentType as dt on dt.TypeID = '" + docTypeID + "' WHERE DocID = '" + docID + "'"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        tempReceived = Date.Parse(reader("Received"))
                        tempCreated = Date.Parse(reader("Created"))

                        final = New DocScan(reader("DisplayName"), "", "", reader("CreatedBy"))
                    Else
                        final = New DocScan(documentName, "", "", "")
                    End If
                End Using
            End Using
        End Using

        Return final
    End Function

    Private Sub FillDocumentTree()
        trvFiles.Nodes.Clear()

        If Directory.Exists(DocumentRoot) Then
            Dim rootFolder As New DirectoryInfo(DocumentRoot)
            Dim root As TreeNode = AddNodeAndDescendents(rootFolder, Nothing, 0)

            trvFiles.Nodes.Add(root)
        Else
            tdNoDir.Visible = True
        End If
    End Sub

    Private Function AddNodeAndDescendents(ByVal folder As DirectoryInfo, ByVal parentNode As TreeNode, ByVal indent As Integer) As TreeNode
        Dim virtualFolderPath As String
        Dim tempDoc As DocScan

        If parentNode Is Nothing Then
            virtualFolderPath = DocumentRoot
        Else
            virtualFolderPath = parentNode.Value & folder.Name & "/"
        End If

        Dim node As New TreeNode

        If virtualFolderPath = DocumentRoot Then
            node = New TreeNode()
        Else
            node = New TreeNode("<table style=""width:100%;font-family:tahoma;font-size:11px;""><tr style=""width:100%;""><td style=""width:100%;border-bottom:solid 1px #d1d1d1;"" colspan=""9"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent) + "<img src=""" + ResolveUrl("~/images/16x16_folder2.png") + """ border=""0"" alt="""" />&nbsp;" + folder.Name + "</td></tr></table>", virtualFolderPath)
        End If

        Dim subFolders As DirectoryInfo() = folder.GetDirectories()

        Dim fileList As FileInfo() = folder.GetFiles()
        Dim tempFile As TreeNode
        Dim tempName As String

        For Each subFile As FileInfo In fileList
            If subFile.Name.ToLower <> "thumbs.db" Then
                tempName = GetSubDirs(folder) + subFile.Name
                tempDoc = LoadDoc(subFile.Name)

                tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") + "');""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:280px;"" align=""left"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:60px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>")
                node.ChildNodes.Add(tempFile)
            End If
        Next

        For Each subFolder As DirectoryInfo In subFolders
            Dim child As TreeNode = AddNodeAndDescendents(subFolder, node, indent + 1)
            node.ChildNodes.Add(child)
        Next

        Return node
    End Function

    Private Function DuplicateStr(ByVal str As String, ByVal num As Integer) As String
        Dim ret As String = ""

        For x As Integer = 0 To num
            ret += str
        Next

        Return ret
    End Function

    Private Function GetSubDirs(ByVal dir As DirectoryInfo) As String
        Dim topFolders As New List(Of String)

        Using cmd As New SqlCommand("SELECT [Name] as DocFolder FROM tblDocFolder", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        topFolders.Add(reader("DocFolder"))
                    End While
                End Using
            End Using
        End Using

        topFolders.Add(AccountNumber)

        Return GetSubDirsRec(dir, topFolders)
    End Function

    Private Function GetSubDirsRec(ByVal dir As DirectoryInfo, ByVal topFolders As List(Of String)) As String
        If Not topFolders.Contains(dir.Name) Then
            Return dir.Name + "/" + GetSubDirsRec(dir.Parent, topFolders)
        End If

        Return ""
    End Function

    Protected Sub lnkDocSelected_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDocSelected.Click
        Dim filename As String = hdnDocument.Value
        Dim subFolder As String = ""
        Dim idx As Integer = filename.LastIndexOf("/")

        If idx > -1 Then
            subFolder = filename.Substring(0, idx + 1)
            filename = filename.Replace(subFolder, "")
            subFolder = subFolder.Replace("//", "\")
        End If

        If IsTemp Then
            SharedFunctions.DocumentAttachment.AttachDocumentToTemp(RelationType, RelationID, filename, UserID, subFolder)
        Else
            SharedFunctions.DocumentAttachment.AttachDocument(RelationType, RelationID, filename, UserID, subFolder)
        End If

        If AddRelationID > 0 Then
            SharedFunctions.DocumentAttachment.AttachDocument(AddRelationType, AddRelationID, filename, UserID, subFolder)
        End If
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click

        Dim fileName As String = SharedFunctions.DocumentAttachment.GetUniqueDocumentName(ddlDocuments.SelectedItem.Value.ToString, ClientID)
        Dim filePath As String = String.Format("{0}\ClientDocs\{1}", DocumentRoot, fileName)
        SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID)

        If fuNewDoc.HasFile Then
            fuNewDoc.SaveAs(filePath)
        End If

        SharedFunctions.DocumentAttachment.AttachDocument("client", ClientID, Path.GetFileName(filePath), UserID, "ClientDocs")
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), UserID, Now)
        hdnDocument.Value = fileName

        ScriptManager.RegisterStartupScript(Me, Me.GetType, "CloseWindow", "window.close", True)

    End Sub
End Class