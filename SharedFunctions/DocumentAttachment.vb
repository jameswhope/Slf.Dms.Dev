Imports Drg.Util.DataAccess

Imports System.Data.SqlClient
Imports System.IO

#Region "Structures"
Public Structure DocRelation
    Public RelationID As Integer
    Public RelationType As String

    Public Sub New(ByVal id As Integer, ByVal type As String)
        Me.RelationID = id
        Me.RelationType = type
    End Sub
End Structure

Public Structure AttachedDocument
    Public DocRelationID As Integer
    Public DocumentName As String
    Public DocumentType As String
    Public DocumentPath As String
    Public Existence As Boolean
    Public Origin As String
    Public Received As String
    Public Created As String
    Public CreatedBy As String

    Public Sub New(ByVal _DocRelationID As Integer, ByVal _DocumentName As String, ByVal _DocumentType As String, ByVal _DocumentPath As String, _
    ByVal _Existence As Boolean, ByVal _Origin As String, ByVal _Received As String, ByVal _Created As String, ByVal _CreatedBy As String)
        Me.DocRelationID = _DocRelationID
        Me.DocumentName = _DocumentName
        Me.DocumentType = _DocumentType
        Me.DocumentPath = _DocumentPath
        Me.Existence = _Existence
        Me.Origin = _Origin
        Me.Received = _Received
        Me.Created = _Created
        Me.CreatedBy = _CreatedBy
    End Sub
End Structure
#End Region

Public Class DocumentAttachment

#Region "Methods"
    Public Shared Sub AttachDocument(ByVal relationType As String, ByVal relationID As Integer, ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        Dim cmdStr As String = "INSERT INTO tblDocRelation VALUES (" + clientID.ToString() + ", " + relationID.ToString() + ", '" + _
        relationType + "', '" + docTypeID + "', '" + docID + "', '" + dateStr + "', " + IIf(subFolder.Length > 0, "'" + subFolder + "'", "null") + _
        ", getdate(), " + userID.ToString() + ", 0, null, null)"

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

    Public Shared Sub SolidifyTempRelation(ByVal relationID As Integer, ByVal relationType As String, ByVal clientID As Integer, ByVal newID As Integer)
        Dim credFolder As String = ""
        Dim needsFolder As Boolean = False

        If relationType = "account" Then
            credFolder = GetCreditorDir(newID)
        End If

        Dim docTypeID As String = ""
        Dim docID As String = ""
        Dim dateStr As String = ""

        Dim cmdStr As String

        Using cmd As New SqlCommand("SELECT DocTypeID, DocID, DateString FROM tblDocRelation WHERE RelationID = " + relationID.ToString() + " and RelationType = '" + relationType + "' and ClientID = " + clientID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=srv-sql-31;uid=sa;pwd=sql1login;database=DMS;connect timeout=99999")) '
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        If reader("DocTypeID") Is Nothing Then
                            Return
                        End If

                        docTypeID = reader("DocTypeID").ToString()
                        docID = reader("DocID").ToString()
                        dateStr = reader("DateString").ToString()
                    Else
                        Return
                    End If
                End Using
            End Using
        End Using

        Dim oldFile As String = BuildAttachmentPath(docTypeID, docID, dateStr, clientID)

        If relationType = "account" And File.Exists(oldFile) Then
            needsFolder = True
            CreateDirForClient(clientID)
            File.Move(oldFile, BuildAttachmentPath(docTypeID, docID, dateStr, clientID, credFolder))
        End If

        cmdStr = "UPDATE tblDocRelation SET RelationID = " + newID.ToString() + ", DeletedFlag = 0, DeletedDate = null, " + _
        "DeletedBy = null " + IIf(credFolder.Length > 0 And needsFolder, ", SubFolder = '" + credFolder + "' ", "") + "WHERE DeletedBy = -1 and RelationID = " + relationID.ToString() + " and RelationType = '" + relationType + "' and ClientID = " + clientID.ToString()

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=srv-sql-31;uid=sa;pwd=sql1login;database=DMS;connect timeout=99999")) '
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Sub MakeAttachmentTemp(ByVal relationType As String, ByVal relationID As Integer, ByVal clientID As Integer)
        Using cmd As New SqlCommand("UPDATE tblDocRelation SET DeletedFlag = 1, DeletedDate = getdate(), DeletedBy = -1 WHERE DeletedFlag = 0 and ClientID = " + clientID.ToString() + " and RelationID = " + relationID.ToString() + " and RelationType = '" + relationType + "'", ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Sub DeleteAttachment(ByVal docRelationID As Integer, ByVal userID As Integer)
        Using cmd As New SqlCommand("UPDATE tblDocRelation SET DeletedFlag = 1, DeletedDate = getdate(), DeletedBy = " + userID.ToString() + " WHERE DocRelationID = " + docRelationID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Sub DeleteAllForItem(ByVal relID As Integer, ByVal relType As String, ByVal userID As Integer)
        Dim docs As New List(Of Integer)

        Using cmd As New SqlCommand("SELECT DocRelationID FROM tblDocRelation WHERE RelationID = " + relID.ToString() + " and RelationType = '" + relType + "'", ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        docs.Add(Integer.Parse(reader("DocRelationID")))
                    End While
                End Using
            End Using
        End Using

        For Each docRelID As Integer In docs
            DeleteAttachment(docRelID, userID)
        Next
    End Sub

    Public Shared Sub DeleteAllDocumentRelations(ByVal documentName As String, ByVal userID As Integer)
        Dim docID As String
        Dim idx1 As Integer = 0
        Dim idx2 As Integer = documentName.IndexOf("_", 0)

        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)

        Using cmd As New SqlCommand("UPDATE tblDocRelation SET DeletedFlag = 1, DeletedDate = getdate(), DeletedBy = " + userID.ToString() + " WHERE DocID = '" + docID + "'", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function BuildAttachmentPath(ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, Optional ByVal subFolder As String = "") As String
        Dim acctNo As String
        Dim server As String
        Dim storage As String
        Dim folder As String

        Using cmd As New SqlCommand("SELECT AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + clientID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999")) '
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        acctNo = reader("AccountNumber").ToString()
                        server = reader("StorageServer").ToString()
                        storage = reader("StorageRoot").ToString()
                    End If
                End Using

                cmd.CommandText = "SELECT DocFolder FROM tblDocumentType WHERE TypeID = '" + docTypeID + "'"
                folder = cmd.ExecuteScalar().ToString()
            End Using
        End Using

        'Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" + IIf(subFolder.Length > 0, subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + ".pdf"
        Return "C:\settlementchecks\" + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + ".pdf"
    End Function

    Public Shared Function BuildAttachmentPath(ByVal docRelID As Integer) As String
        Dim docTypeID As String
        Dim docID As String
        Dim dateStr As String
        Dim clientID As Integer
        Dim subFolder As String

        Using cmd As New SqlCommand("SELECT ClientID, DocTypeID, DocID, DateString, isnull(SubFolder, '') as SubFolder FROM tblDocRelation WHERE DocRelationID = " + docRelID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        docTypeID = reader("DocTypeID").ToString()
                        docID = reader("DocID").ToString()
                        dateStr = reader("DateString").ToString()
                        clientID = Integer.Parse(reader("ClientID"))
                        subFolder = reader("SubFolder").ToString()
                    End If
                End Using
            End Using
        End Using

        Return BuildAttachmentPath(docTypeID, docID, dateStr, clientID, subFolder)
    End Function

    Public Shared Function GetRelationsForClient(ByVal clientID As Integer) As List(Of DocRelation)
        Dim relations As New List(Of DocRelation)

        Using cmd As New SqlCommand("SELECT RelationID, RelationType FROM tblDocRelation WHERE DeletedFlag = 0 and ClientID = " + clientID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        relations.Add(New SharedFunctions.DocRelation(Integer.Parse(reader("RelationID")), reader("RelationType").ToString()))
                    End While
                End Using
            End Using
        End Using

        Return relations
    End Function

    Public Shared Function GetAttachmentsForRelation(ByVal relationID As Integer, ByVal relationType As String, Optional ByVal url As String = "") As List(Of AttachedDocument)
        Dim docs As New List(Of AttachedDocument)
        Dim final As New List(Of AttachedDocument)
		Dim cmdStr As String = "SELECT dr.DocRelationID, dt.DisplayName, isnull(ds.ReceivedDate, '01/01/1900') as ReceivedDate, " + _
  "isnull(ds.Created, '01/01/1900') as Created, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, '') as CreatedBy FROM tblDocRelation as dr inner join tblDocumentType as dt " + _
  "on dt.TypeID = dr.DocTypeID left join tblDocScan as ds on ds.DocID = dr.DocID left join tblUser as u on u.UserID = ds.CreatedBy inner join tblusergroup as ug on ug.usergroupid = u.usergroupid " + _
  "WHERE dr.RelationID = " + relationID.ToString() + " and dr.RelationType = '" + relationType + "' and (DeletedFlag = 0 or DeletedBy = -1) " + _
  "ORDER BY ds.ReceivedDate, ds.Created"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        docs.Add(New AttachedDocument(reader("DocRelationID"), "", reader("DisplayName"), "", False, "", Date.Parse(reader("ReceivedDate")).ToString("d"), Date.Parse(reader("Created")).ToString("g"), IIf(reader("CreatedBy") Is Nothing, "", reader("CreatedBy").ToString())))
                    End While
                End Using
            End Using
        End Using

        Dim tempName As String

        For Each doc As AttachedDocument In docs
            tempName = BuildAttachmentPath(doc.DocRelationID)

            If url.ToLower().Contains(".com") Then
                doc.DocumentPath = "http://service.dmsisupport.com" & tempName.Substring(tempName.IndexOf("\", 2))
            Else
                doc.DocumentPath = "file:///" & tempName
            End If

            doc.DocumentName = Path.GetFileName(doc.DocumentPath)

            If File.Exists(tempName) Then
                doc.Existence = True
            End If

            If doc.Received = "1/1/1900" Then
                doc.Received = ""
            End If

            If doc.Created.Contains("1/1/1900") Then
                doc.Created = ""
            End If

            final.Add(doc)
        Next

        Return final
    End Function

    Public Shared Sub CreateScan(ByVal documentName As String, ByVal userID As Integer, Optional ByVal received As Date = Nothing, Optional ByVal origin As String = "")
        Dim docID As String
        Dim idx1 As Integer = 0
        Dim idx2 As Integer = documentName.IndexOf("_", 0)

        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)

        Dim cmdStr As String = "INSERT INTO tblDocScan VALUES ('" + docID.ToString() + "', " + IIf(origin.Length = 0, "null", "'" + origin + "'") + _
        ", " + IIf(received = Nothing, "null", "'" + received.ToString() + "'") + ", getdate(), " + userID.ToString() + ")"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function GetCreditorDir(ByVal accountID As Integer) As String
        Dim creditor As String

        Dim strSQL As String = "SELECT cr1.[Name] " _
                + "FROM tblAccount a INNER JOIN " _
                + "tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN " _
                + "tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN " _
                + "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN " _
                + "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID " _
                + "WHERE a.AccountID = " + accountID.ToString()

        Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                creditor = DataHelper.Nz(cmd.ExecuteScalar(), "").ToString()
            End Using
        End Using

        Return accountID.ToString() + "_" + creditor.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim() + "\"
    End Function

    Public Shared Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String
        Dim tempDir As String

        Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    reader.Read()
                    rootDir = "\\" + DatabaseHelper.Peel_string(reader, "StorageServer") + "\" + DatabaseHelper.Peel_string(reader, "StorageRoot") + "\" + DatabaseHelper.Peel_string(reader, "AccountNumber") + "\"
                End Using

                If Not Directory.Exists(rootDir) Then
                    Directory.CreateDirectory(rootDir)
                End If

                cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder "

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = rootDir + DatabaseHelper.Peel_string(reader, "Name")

                        If Not Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using

                cmd.CommandText = "SELECT a.AccountID, cr1.[Name], cr2.[Name] as Original " _
                    + "FROM  tblAccount a INNER JOIN " _
                    + "tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN " _
                    + "tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN " _
                    + "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN " _
                    + "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID " _
                    + "WHERE a.ClientID = " + ClientID.ToString() + " ORDER BY cr1.[Name] ASC"

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = reader.Item("AccountID").ToString() + "_" + reader.Item("Name").ToString()
                        tempDir = rootDir + "CreditorDocs\" + tempDir.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")

                        If Not System.IO.Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using
            End Using
        End Using

        Return rootDir
    End Function

    Public Shared Function GetUniqueDocumentName(ByVal docTypeID As String, ByVal DataClientID As String) As String
        Dim ret As String
        Dim obj As New DocumentAttachment
        Using conn As SqlConnection = ConnectionFactory.Create()
            conn.Open()
            ret = obj.GetAccountNumber(conn, DataClientID) + "_" + docTypeID + "_" + obj.GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using
        obj = Nothing
        Return ret
    End Function

    Public Function GetDocID(ByVal conn As SqlConnection) As String
        Dim docID As String

        Using cmd As New SqlCommand("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", conn)
            docID = cmd.ExecuteScalar().ToString()

            cmd.CommandText = "stp_GetDocumentNumber"
            docID += cmd.ExecuteScalar().ToString()
        End Using

        Return docID
    End Function

    Public Function GetAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String

        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
            accountno = cmd.ExecuteScalar().ToString()
        End Using

        Return accountno
    End Function

#End Region
End Class