Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO
Imports Drg.Util.DataAccess

Public Class documentHelper
    Public Enum enumDocumentType
        Client = 0
        Creditor = 1
        Note = 3
    End Enum
    Public Shared Function GetDocumentsForRelation(ByVal relationID As Integer, ByVal relationType As String, Optional ByVal url As String = "") As List(Of AttachedDocument)
        Dim docs As New List(Of AttachedDocument)
        Dim final As New List(Of AttachedDocument)
        Dim cmdStr As String = "SELECT dr.DocRelationID, dt.DisplayName, isnull(ds.ReceivedDate, '01/01/1900') as ReceivedDate, " + _
        "isnull(ds.Created, '01/01/1900') as Created, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, '') as CreatedBy FROM tblDocRelation as dr inner join tblDocumentType as dt " + _
        "on dt.TypeID = dr.DocTypeID left join tblDocScan as ds on ds.DocID = dr.DocID left join tblUser as u on u.UserID = ds.CreatedBy left join tblusergroup as ug on ug.usergroupid = u.usergroupid " + _
        "WHERE dr.RelationID = " + relationID.ToString() + " and dr.RelationType = '" + relationType + "' and (DeletedFlag = 0 or DeletedBy = -1) " + _
        "ORDER BY ds.ReceivedDate, ds.Created"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
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
            tempName = BuildDocumentPath(doc.DocRelationID)

            doc.DocumentPath = LocalHelper.GetVirtualDocFullPath(tempName)

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
    Public Shared Function BuildDocumentPath(ByVal docRelID As Integer) As String
        Dim docTypeID As String = String.Empty
        Dim docID As String = String.Empty
        Dim dateStr As String = String.Empty
        Dim clientID As Integer = -1
        Dim subFolder As String = String.Empty
        Dim fExt As String = ".pdf"

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
                        Select Case docTypeID
                            Case "C1001"
                                fExt = ".tif"
                            Case Else
                                fExt = ".pdf"
                        End Select
                    End If
                End Using
            End Using
        End Using

        Return BuildDocumentPath(docTypeID, docID, dateStr, clientID, subFolder, fExt)
    End Function
    Public Shared Function BuildDocumentPath(ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, _
                                             Optional ByVal subFolder As String = "", _
                                             Optional ByVal fileExtension As String = ".pdf") As String
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

        Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" + IIf(subFolder.Length > 0, subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + fileExtension
    End Function
    Public Shared Function getDocuments(ByVal dataclientid As Integer, ByVal creditoraccountid As Integer, ByVal noteid As Integer, ByVal documenttype As enumDocumentType) As DataTable
        Dim dt As DataTable = Nothing
        Try
            Dim ssql As String
            Dim params As New List(Of SqlParameter)

            Select Case documenttype
                Case enumDocumentType.Client
                    ssql = "stp_documents_getClientDocumentsInfo"
                    params.Add(New SqlParameter("clientid", dataclientid.ToString))

                Case enumDocumentType.Creditor
                    ssql = "stp_documents_getClientCreditorDocumentsInfo"
                    params.Add(New SqlParameter("clientid", dataclientid.ToString))
                    params.Add(New SqlParameter("credAcctID", creditoraccountid.ToString))

                Case enumDocumentType.Note
                    ssql = "stp_documents_getClientNoteDocumentsInfo"
                    params.Add(New SqlParameter("noteid", noteid.ToString))
            End Select

            dt = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)

        Catch ex As Exception
            Throw
        End Try
        Return dt

    End Function
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
End Class
