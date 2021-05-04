Imports Drg.Util.DataAccess

Imports SharedFunctions
Imports System.Data

Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO

Partial Class util_pop_attachmatterdocument
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private Shadows ClientID As Integer
    Private DocumentRoot As String
    Private LegacyDocumentRoot As String
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
        Public CreditorAccountNumber As String
        Public Received As String
        Public Created As String
        Public CreatedBy As String

        Public Sub New(ByVal _DocumentName As String, ByVal _CreditorAccountNumber As String, ByVal _Received As String, ByVal _Created As String, ByVal _CreatedBy As String)
            Me.DocumentName = _DocumentName
            Me.CreditorAccountNumber = _CreditorAccountNumber
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
        '***** Production/QA path *****
        DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
           DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber
 
	''TimeMatter Legacy Doc path
        LegacyDocumentRoot = "\\litsvr1\Worldox\TMW8E2\DATA\files" + "\" + AccountNumber

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

        'Dim cmdStr As String = "SELECT isnull(dt.DisplayName, '') as DisplayName, isnull(ds.ReceivedDate, '01-01-1900') as Received, isnull(ds.Created, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocScan as ds left join tblUser as u on u.UserID = ds.CreatedBy left join tblDocumentType as dt on dt.TypeID = '" + docTypeID + "' WHERE DocID = '" + docID + "'"
        '04.02.2010
        Dim cmdStr As String = "SELECT isnull(dt.DisplayName, '') as DisplayName, CASE WHEN ci.AccountNumber is null THEN '' ELSE ci.AccountNumber END as CreditorAccountNumber, isnull(ds.ReceivedDate, '01-01-1900') as Received, isnull(ds.Created, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocScan as ds left join tblUser as u on u.UserID = ds.CreatedBy left join tblDocumentType as dt on dt.TypeID = '" + docTypeID + _
"' left join tblDocRelation dr on dr.DocId=ds.DocId left join tblMatter m on m.MatterId= " + _
"(CASE WHEN dr.RelationType='matter' then RelationId ELSE ' ' END) left join tblCreditorInstance ci on ci.CreditorInstanceId=m.CreditorInstanceId " + _
" WHERE ds.DocID = '" + docID + "'"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        tempReceived = Date.Parse(reader("Received"))
                        tempCreated = Date.Parse(reader("Created"))

                        final = New DocScan(reader("DisplayName"), reader("CreditorAccountNumber"), tempReceived, tempCreated, reader("CreatedBy"))

                    Else
                        final = New DocScan(documentName, "", "", "", "")
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
            Dim root As TreeNode = AddNodeAndDescendents(rootFolder, Nothing, 0, 0)

            trvFiles.Nodes.Add(root)

            If Directory.Exists(LegacyDocumentRoot) Then

                Dim rootLegacyFolder As New DirectoryInfo(LegacyDocumentRoot)

                Dim rootLegacy As TreeNode = AddNodeForLegacy(rootLegacyFolder, Nothing, 0, 0)

                trvFiles.Nodes.Add(rootLegacy)

            End If
            
        Else
            tdNoDir.Visible = True
        End If
    End Sub

    Private Function AddNodeForLegacy(ByVal folder As DirectoryInfo, ByVal parentNode As TreeNode, ByVal indent As Integer, ByVal level As Integer) As TreeNode

        Dim virtualFolderPath As String
        Dim tempDoc As DocScan
        If parentNode Is Nothing Then
            virtualFolderPath = LegacyDocumentRoot
        Else
            virtualFolderPath = parentNode.Value & folder.Name & "/"
        End If

        Dim node As New TreeNode
        Dim strFolderName As String = folder.Name
        If virtualFolderPath = LegacyDocumentRoot Then
            node = New TreeNode()
        Else
            node = New TreeNode("<table style=""width:100%;font-family:tahoma;font-size:11px;""><tr style=""width:100%;""><td style=""width:100%;border-bottom:solid 1px #d1d1d1;"" colspan=""9"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent) + "<img src=""" + ResolveUrl("~/images/16x16_folder2.png") + """ border=""0"" alt="""" />&nbsp;" + folder.Name + "</td></tr></table>", virtualFolderPath)
        End If

        Dim subFolders As DirectoryInfo() = folder.GetDirectories()

        Dim fileList As FileInfo() = folder.GetFiles()
        Dim tempFile As TreeNode
        Dim tempName As String

        For Each subFile As FileInfo In fileList
            'tempName = GetSubDirs(folder) + subFile.Name
            tempName = subFile.FullName
            ' tempDoc = LoadDoc(subFile.Name)

            'tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") + "');""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:280px;"" align=""left"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>")
            tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" onclick=""javascript:OnFileClick(-1,'" + tempName.Replace("\", "\\").Replace("'", "\'") + "');""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:280px;"" align=""left"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + subFile.Name + "</td><td style=""width:130px;"" align=""left"">" + "" + "</td><td style=""width:130px;"" align=""left"">" + "" + "</td><td align=""left"">" + "" + "</td></tr></table>")

            node.ChildNodes.Add(tempFile)
        Next
        For Each subFolder As DirectoryInfo In subFolders

            Dim child As TreeNode = AddNodeForLegacy(subFolder, node, indent + 1, 1)
            node.ChildNodes.Add(child)

        Next
        Return node
    End Function

    Private Function AddNodeAndDescendents(ByVal folder As DirectoryInfo, ByVal parentNode As TreeNode, ByVal indent As Integer, ByVal level As Integer) As TreeNode
        Dim virtualFolderPath As String
        Dim tempDoc As DocScan
        If parentNode Is Nothing Then
            virtualFolderPath = DocumentRoot
        Else
            virtualFolderPath = parentNode.Value & folder.Name & "/"
        End If

        Dim node As New TreeNode
        Dim strFolderName As String = folder.Name
        If virtualFolderPath = DocumentRoot Then
            node = New TreeNode()
        Else
            node = New TreeNode("<table style=""width:100%;font-family:tahoma;font-size:11px;""><tr style=""width:100%;""><td style=""width:100%;border-bottom:solid 1px #d1d1d1;"" colspan=""9"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent) + "<img src=""" + ResolveUrl("~/images/16x16_folder2.png") + """ border=""0"" alt="""" />&nbsp;" + folder.Name + "</td></tr></table>", virtualFolderPath)
        End If

        Dim subFolders As DirectoryInfo() = folder.GetDirectories()

        Dim fileList As FileInfo() = folder.GetFiles()
        Dim tempFile As TreeNode
        Dim tempName As String
        'If Not (strFolderName.ToLower().Equals("legaldocs") Or level = 1) Then 'legacydocs
        If True Then 'legacydocs
            For Each subFile As FileInfo In fileList
                tempName = GetSubDirs(folder) + subFile.Name
                tempDoc = LoadDoc(subFile.Name)

                'tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" onclick=""javascript:OnFileClick(0,'" + tempName.Replace("/", "//") + "');""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:280px;"" align=""left"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>")

                tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" onclick=""javascript:OnFileClick(0,'" + tempName.Replace("/", "//") + "');""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:280px;"" align=""left"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.CreditorAccountNumber + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>")
                node.ChildNodes.Add(tempFile)
            Next
            For Each subFolder As DirectoryInfo In subFolders

                Dim child As TreeNode = AddNodeAndDescendents(subFolder, node, indent + 1, 0)
                node.ChildNodes.Add(child)

            Next
            Return node
        Else
            'if level =1 means it is inner directory of legacy folder

            For Each subFile As FileInfo In fileList
                'tempName = GetSubDirs(folder) + subFile.Name
                tempName = subFile.FullName
                ' tempDoc = LoadDoc(subFile.Name)

                'tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" onclick=""javascript:OnFileClick('" + tempName.Replace("/", "//") + "');""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:280px;"" align=""left"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + tempDoc.DocumentName + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Received + "</td><td style=""width:130px;"" align=""left"">" + tempDoc.Created + "</td><td align=""left"">" + tempDoc.CreatedBy + "</td></tr></table>")
                tempFile = New TreeNode("<table style=""width:100%;border-bottom:solid 1px #d1d1d1;"" onclick=""javascript:OnFileClick(1,'" + tempName.Replace("\", "\\") + "');""><tr style=""width:100%;font-family:tahoma;font-size:11px;""><td style=""width:280px;"" align=""left"">" + DuplicateStr("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", indent + 1) + "<img src=""" + ResolveUrl("~/images/16x16_file_new.png") + """ border=""0"" alt="""" />&nbsp;" + subFile.Name + "</td><td style=""width:130px;"" align=""left"">" + "" + "</td><td style=""width:130px;"" align=""left"">" + "" + "</td><td align=""left"">" + "" + "</td></tr></table>")

                node.ChildNodes.Add(tempFile)
            Next
            For Each subFolder As DirectoryInfo In subFolders

                Dim child As TreeNode = AddNodeAndDescendents(subFolder, node, indent + 1, 1)
                node.ChildNodes.Add(child)

            Next
            Return node

        End If
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
            'Return dir.Name + "/" + GetSubDirsRec(dir.Parent, topFolders)
            Return GetSubDirsRec(dir.Parent, topFolders) + dir.Name + "/"
        End If

        Return ""
    End Function

    Protected Sub lnkDocSelected_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDocSelected.Click
        Dim filename As String = hdnDocument.Value
        Dim type As String = hdnType.Value
        If type = "0" Then
            Dim subFolder As String = ""
            Dim idx As Integer = filename.LastIndexOf("/")
            If idx > -1 Then
                subFolder = filename.Substring(0, idx + 1)
                filename = filename.Replace(subFolder, "")
                subFolder = subFolder.Replace("//", "\")
            End If

            If IsTemp Then
                'SharedFunctions.DocumentAttachment.AttachDocumentToTemp(RelationType, RelationID, filename, UserID, subFolder)
                AttachDocumentToTemp(RelationType, RelationID, filename, UserID, subFolder)
            Else
                'SharedFunctions.DocumentAttachment.AttachDocument(RelationType, RelationID, filename, UserID, subFolder)
                AttachDocument(RelationType, RelationID, filename, UserID, subFolder)
            End If

            If AddRelationID > 0 Then
                'SharedFunctions.DocumentAttachment.AttachDocument(AddRelationType, AddRelationID, filename, UserID, subFolder)
                AttachDocument(AddRelationType, AddRelationID, filename, UserID, subFolder)
            End If

        ElseIf type = "-1" Then

            'filename = filename.Substring(filename.ToLower().IndexOf("legaldocs") + 10) 'legacydocs
            Dim strDocId As String = "A" & System.DateTime.Now.ToString("yyMMddhhmm")
            Dim cmdStr As String = "INSERT INTO tblDocScan(DocID,ReceivedDate, Created,CreatedBy) VALUES ('" & strDocId & "',getdate(),getdate()," & UserID.ToString() & ")"

            Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.ExecuteNonQuery()
                End Using
            End Using


            cmdStr = "INSERT INTO tblDocRelation(ClientID, RelationID, RelationType, DocTypeID, DocID, DateString, SubFolder,RelatedDate, RelatedBy, DeletedFlag, deleteddate, deletedby)  VALUES (" & _
            ClientID.ToString() + ", " + RelationID.ToString() + ", '" + RelationType + "', 'M030', '" + strDocId + "', '', '" + filename.Replace("'", "''") + "', getdate(), " + UserID.ToString() + ", 0,  null,0)" 'X001
            Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.ExecuteNonQuery()
                End Using
            End Using

        Else
            filename = filename.Substring(filename.ToLower().IndexOf("legaldocs") + 10) 'legacydocs
            Dim strDocId As String = "A" & System.DateTime.Now.ToString("yyMMddhhmm")
            Dim cmdStr As String = "INSERT INTO tblDocScan(DocID,ReceivedDate, Created,CreatedBy) VALUES ('" & strDocId & "',getdate(),getdate()," & UserID.ToString() & ")"

            Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.ExecuteNonQuery()
                End Using
            End Using


            cmdStr = "INSERT INTO tblDocRelation(ClientID, RelationID, RelationType, DocTypeID, DocID, DateString, SubFolder,RelatedDate, RelatedBy, DeletedFlag, deleteddate, deletedby)  VALUES (" & _
            ClientID.ToString() + ", " + RelationID.ToString() + ", '" + RelationType + "', 'M030', '" + strDocId + "', '', '" + filename + "', getdate(), " + UserID.ToString() + ", 0,  null,0)" 'X001
            Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.ExecuteNonQuery()
                End Using
            End Using

        End If
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Public Sub AttachDocument(ByVal relationType As String, ByVal relationID As Integer, ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, ByVal userID As Integer, Optional ByVal subFolder As String = "")
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

    Public Sub AttachDocument(ByVal relationType As String, ByVal relationID As Integer, ByVal documentName As String, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        'Dim clientID As Integer
        Dim docTypeID As String
        Dim docID As String
        Dim dateStr As String
        Dim idx1 As Integer = 0
        Dim idx2 As Integer = documentName.IndexOf("_", 0)

        'clientID = Integer.Parse(DataHelper.FieldLookup("tblClient", "ClientID", "AccountNumber = " + documentName.Substring(idx1, idx2))) 'Integer.Parse(documentName.Substring(idx1, idx2))
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docTypeID = documentName.Substring(idx1, idx2 - idx1)
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf(".", idx1)
        dateStr = docID.Substring(1, 6)

        'If idx2 = -1 Then
        '    dateStr = documentName.Substring(idx1).Substring(1, 6)
        'Else
        '    dateStr = documentName.Substring(idx1, idx2 - idx1).Substring(1, 6)
        'End If

        AttachDocument(relationType, relationID, docTypeID, docID, dateStr, ClientID, userID, subFolder)
    End Sub

    Public Sub AttachDocumentToTemp(ByVal relationType As String, ByVal relationID As Integer, ByVal documentName As String, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        'Dim clientID As Integer

        'clientID = Integer.Parse(DataHelper.FieldLookup("tblClient", "ClientID", "AccountNumber = " + documentName.Substring(0, documentName.IndexOf("_", 0))))

        AttachDocument(relationType, relationID, documentName, userID, subFolder)
        MakeAttachmentTemp(relationType, relationID, ClientID)
    End Sub

    Public Shared Function GetUniqueTempID() As Integer
        Dim relationID As Integer

        Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_GetNewUniqueID")
            cmd.Connection.Open()

            relationID = Integer.Parse(cmd.ExecuteScalar())
        End Using

        Return relationID
    End Function

    Public Sub MakeAttachmentTemp(ByVal relationType As String, ByVal relationID As Integer, ByVal clientID As Integer)
        Using cmd As New SqlCommand("UPDATE tblDocRelation SET DeletedFlag = 0, DeletedDate = getdate(), DeletedBy = -1 WHERE DeletedFlag = 0 and ClientID = " + clientID.ToString() + " and RelationID = " + relationID.ToString() + " and RelationType = '" + relationType + "'", ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

End Class