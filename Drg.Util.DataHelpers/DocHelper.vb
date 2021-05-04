Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports AssistedSolutions.SlickUpload
Imports AssistedSolutions.SlickUpload.Providers

Imports System.Data
Imports System.Configuration

Public Class DocHelper

    Public Shared Function UploadFileIntoDoc(ByVal Part As UploadedFile, _
        ByVal DocFolderID As Integer, ByVal UserID As Integer) As Integer

        Dim location As SqlClientUploadLocation = Part.Location

        'update the file table in the repository with it's other values
        UpdateFile(Part.ClientName, Part.ContentLength, Part.ContentType, location.Criteria)

        Dim FileID As Integer = DataHelper.Nz_int(location.Criteria.Replace("FileID", _
            String.Empty).Replace("=", String.Empty).Trim)

        'insert a doc record matching this file
        Return InsertDoc(Part.ClientName, DocFolderID, Part.ContentLength, Part.ContentType, FileID, UserID)

    End Function
    Private Shared Sub UpdateFile(ByVal Name As String, ByVal Size As Long, ByVal Type As String, ByVal Criteria As String)

        Dim cmd As IDbCommand = ConnectionFactory.Create(ConfigurationManager.AppSettings("connectionstringrepository")).CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Size", Size)
        DatabaseHelper.AddParameter(cmd, "Type", Type)
        DatabaseHelper.AddParameter(cmd, "TypeOpener", FileHelper.TypeOpener(IO.Path.GetExtension(Name)))

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblFile", Criteria)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function InsertDoc(ByVal Name As String, ByVal DocFolderID As Integer, ByVal Size As Long, _
        ByVal Type As String, ByVal FileID As Integer, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Name", Name)
        DatabaseHelper.AddParameter(cmd, "DocFolderID", DocFolderID)
        DatabaseHelper.AddParameter(cmd, "Size", Size)
        DatabaseHelper.AddParameter(cmd, "Type", Type)
        DatabaseHelper.AddParameter(cmd, "FileID", FileID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblDoc", "DocID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@DocID").Value)

    End Function
    Public Shared Sub Delete(ByVal DocIDs() As Integer)

        'loop through and delete each one
        For Each DocID As Integer In DocIDs
            Delete(DocID)
        Next

    End Sub
    Public Shared Sub Delete(ByVal DocID As Integer)

        '(1) find the associated file (tblFile) from this doc (tblDoc) and delete
        DeleteFile(DocID)

        '(2) delete all associated data entry docs (tblDataEntryDoc)
        DataHelper.Delete("tblDataEntryDoc", "DocID = " & DocID)

        '(3) delete the record
        DataHelper.Delete("tblDoc", "DocID = " & DocID)

    End Sub
    Public Shared Sub DeleteFile(ByVal DocID As Integer)

        Dim FileID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblDoc", "FileID", "DocID = " & DocID))

        'access the file repository (unique connection string)
        Dim cmd As IDbCommand = ConnectionFactory.Create(ConfigurationManager.AppSettings("connectionstringrepository")).CreateCommand()

        cmd.CommandText = "DELETE FROM tblFile WHERE FileID = " & FileID

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
End Class