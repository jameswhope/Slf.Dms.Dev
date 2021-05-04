Imports Drg.Util.DataAccess
Imports SharedFunctions
Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO
Partial Class util_pop_browsealldocuments
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
    Public iParentFolder As Int32
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
        'RelationID = Integer.Parse(Request.QueryString("rel"))
        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString())
        DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
           DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber


        'DocumentRoot = Server.MapPath("~/") + DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber
        
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
            FillDocumentTree()
        End If
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

                        final = New DocScan(reader("DisplayName"), tempReceived, tempCreated, reader("CreatedBy"))
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
        iParentFolder = 1
        If Directory.Exists(DocumentRoot) Then
            Dim rootFolder As New DirectoryInfo(DocumentRoot)
            Dim root As TreeNode = AddNodeAndDescendents(rootFolder, Nothing, 0)

            trvFiles.Nodes.Add(root)
        Else
            tdNoDir.Visible = True
            tdDir.Visible = False
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
            'node = New TreeNode("<table style=""width:100%;""><tr><td align='right'><input type='checkbox'/></td><td align='left'><table style=""width:100%;font-family:tahoma;font-size:11px;""><tr style=""width:100%;""><td style=""width:100%;border-bottom:solid 1px #d1d1d1;"" colspan=""9"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent) + "<img src=""" + ResolveUrl("~/images/16x16_folder2.png") + """ border=""0"" alt="""" />&nbsp;" + folder.Name + "</td></tr></table></td></tr></table> ", virtualFolderPath)
            node = New TreeNode("<table style=""width:100%;font-family:tahoma;font-size:11px;""><tr style=""width:100%;""><td style=""width:5px;"" align=""right""><input type='checkbox'   onclick='javascript: checkAll(" & iParentFolder.ToString() & ")' id='chk_folder_" & iParentFolder.ToString() & "'/></td><td style=""width:100%;border-bottom:solid 1px #d1d1d1;"" colspan=""9"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent) + "<img src=""" + ResolveUrl("~/images/16x16_folder2.png") + """ border=""0"" alt="""" />&nbsp;" + folder.Name + "</td></tr></table>", virtualFolderPath)

        End If

        Dim subFolders As DirectoryInfo() = folder.GetDirectories()

        Dim fileList As FileInfo() = folder.GetFiles()
        Dim tempFile As TreeNode
        Dim tempName As String
        Dim iFileCount As Int32 = 1
        For Each subFile As FileInfo In fileList
            tempName = GetSubDirs(folder) + subFile.Name
            AccountNumber = subFile.Name.Substring(0, subFile.Name.IndexOf("_"))
            tempDoc = LoadDoc(subFile.Name)
            tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" border='0' ><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:5px;"" align=""right""><input type='checkbox' value='" & tempName.Replace("/", "//") & "$" & tempDoc.DocumentName.Replace("'", "\'") & "'  id='chk_file_" & iParentFolder.ToString() & "_" & iFileCount.ToString() & "'/></td><td style=""width:250px;"" align=""left"" onclick=""javascript:OnFileClick('" & tempName.Replace("/", "//") & "','" & tempDoc.DocumentName.Replace("'", "\'") & "');"" >" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:120px;"" align=""left"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") & "','" & tempDoc.DocumentName.Replace("'", "\'") & "');"">" + tempDoc.Received + "</td><td style=""width:120px;"" align=""left"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") & "','" & tempDoc.DocumentName.Replace("'", "\'") & "');"">" + tempDoc.Created + "</td><td align=""left"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") & "','" & tempDoc.DocumentName.Replace("'", "\'") & "');"">" + tempDoc.CreatedBy + "</td></tr></table>")

            '  tempName = subFile.FullName '  GetSubDirs(folder) + subFile.Name
            ' AccountNumber = subFile.Name.Substring(0, subFile.Name.IndexOf("_"))
            'tempDoc = LoadDoc(subFile.Name)
            ' tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" border='0' ><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:5px;"" align=""right""><input type='checkbox' value='" & tempName.Replace("/", "//") & "$" & tempDoc.DocumentName.Replace("'", "\'") & "'  id='chk_file_" & iParentFolder.ToString() & "_" & iFileCount.ToString() & "'/></td><td style=""width:250px;"" align=""left"" onclick=""javascript:OnFileClick('" & tempName.Replace("/", "//") & "','');"" >" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempName + "</td><td style=""width:120px;"" align=""left"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") & "','');"">" + tempDoc.Received + "</td><td style=""width:120px;"" align=""left"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") & "','" & tempDoc.DocumentName.Replace("'", "\'") & "');"">" + tempDoc.Created + "</td><td align=""left"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") & "','" & tempDoc.DocumentName.Replace("'", "\'") & "');"">" + tempDoc.CreatedBy + "</td></tr></table>")


            node.ChildNodes.Add(tempFile)
            iFileCount = iFileCount + 1
        Next

        For Each subFolder As DirectoryInfo In subFolders
            'If subFolder.Name = "LegalDocs" Then
            iParentFolder = iParentFolder + 1
            Dim child As TreeNode = AddNodeAndDescendents(subFolder, node, indent + 1)
            node.ChildNodes.Add(child)
            'End If
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
        'Dim filename As String = hdnDocument.Value
        'Dim subFolder As String = ""
        'Dim idx As Integer = filename.LastIndexOf("/")

        'If idx > -1 Then
        '    subFolder = filename.Substring(0, idx + 1)
        '    filename = filename.Replace(subFolder, "")
        '    subFolder = subFolder.Replace("//", "\")
        'End If

        'If IsTemp Then
        '    'SharedFunctions.DocumentAttachment.AttachDocumentToTemp(RelationType, RelationID, filename, UserID, subFolder)
        '    AttachDocumentToTemp(RelationType, RelationID, filename, UserID, subFolder)
        'Else
        '    'SharedFunctions.DocumentAttachment.AttachDocument(RelationType, RelationID, filename, UserID, subFolder)
        '    AttachDocument(RelationType, RelationID, filename, UserID, subFolder)
        'End If

        'If AddRelationID > 0 Then
        '    'SharedFunctions.DocumentAttachment.AttachDocument(AddRelationType, AddRelationID, filename, UserID, subFolder)
        '    AttachDocument(AddRelationType, AddRelationID, filename, UserID, subFolder)
        'End If
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Public Shared Sub AttachDocument(ByVal relationType As String, ByVal relationID As Integer, ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        Dim cmdStr As String = "INSERT INTO tblDocRelation VALUES (" + clientID.ToString() + ", " + relationID.ToString() + ", '" + _
        relationType + "', '" + docTypeID + "', '" + docID + "', '" + dateStr + "', " + IIf(subFolder.Length > 0, "'" + subFolder + "'", "null") + _
        ", getdate(), " + userID.ToString() + ", 0,  null,0)"
        '", getdate(), " + userID.ToString() + ", 0, null, null,0,null)"
        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Sub AttachDocument(ByVal relationType As String, ByVal relationID As Integer, ByVal documentName As String, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        Dim clientID As Integer
        Dim docTypeID As String
        Dim docID As String
        Dim dateStr As String
        Dim idx1 As Integer = 0
        Dim idx2 As Integer = documentName.IndexOf("_", 0)

        clientID = Integer.Parse(DataHelper.FieldLookup("tblClient", "ClientID", "AccountNumber = " + documentName.Substring(idx1, idx2))) 'Integer.Parse(documentName.Substring(idx1, idx2))
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docTypeID = documentName.Substring(idx1, idx2 - idx1)
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf(".", idx1)

        If idx2 = -1 Then
            dateStr = documentName.Substring(idx1)
        Else
            dateStr = documentName.Substring(idx1, idx2 - idx1)
        End If

        AttachDocument(relationType, relationID, docTypeID, docID, dateStr, clientID, userID, subFolder)
    End Sub

    Public Shared Sub AttachDocumentToTemp(ByVal relationType As String, ByVal relationID As Integer, ByVal documentName As String, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        Dim clientID As Integer

        clientID = Integer.Parse(DataHelper.FieldLookup("tblClient", "ClientID", "AccountNumber = " + documentName.Substring(0, documentName.IndexOf("_", 0))))

        AttachDocument(relationType, relationID, documentName, userID, subFolder)
        MakeAttachmentTemp(relationType, relationID, clientID)
    End Sub

    Public Shared Function GetUniqueTempID() As Integer
        Dim relationID As Integer

        Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_GetNewUniqueID")
            cmd.Connection.Open()

            relationID = Integer.Parse(cmd.ExecuteScalar())
        End Using

        Return relationID
    End Function

    Public Shared Sub MakeAttachmentTemp(ByVal relationType As String, ByVal relationID As Integer, ByVal clientID As Integer)
        Using cmd As New SqlCommand("UPDATE tblDocRelation SET DeletedFlag = 1, DeletedDate = getdate(), DeletedBy = -1 WHERE DeletedFlag = 0 and ClientID = " + clientID.ToString() + " and RelationID = " + relationID.ToString() + " and RelationType = '" + relationType + "'", ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub
End Class
