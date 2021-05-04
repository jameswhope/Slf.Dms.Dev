Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class DocFolderHelper

    Public Shared Sub Delete(ByVal DocFolderIDs() As Integer, ByVal IfEmpty As Boolean)

        'loop through and delete each one
        For Each DocFolderID As Integer In DocFolderIDs
            Delete(DocFolderID, IfEmpty)
        Next

    End Sub
    Public Shared Function Delete(ByVal DocFolderID As Integer, ByVal IfEmpty As Boolean) As Boolean

        'recursively walk down all child doc folders
        Dim ChildDocFolderIDs() As Integer = DataHelper.FieldLookupIDs("tblDocFolder", "DocFolderID", "ParentDocFolderID = " & DocFolderID)

        If ChildDocFolderIDs.Length > 0 Then
            Delete(ChildDocFolderIDs, IfEmpty)
        End If

        'check if only suppose to delete if empty OR truly IS empty
        Dim NumDocs As Integer = DataHelper.FieldCount("tblDoc", "DocID", "DocFolderID = " & DocFolderID)
        Dim NumDocFolders As Integer = DataHelper.FieldCount("tblDocFolder", "DocFolderID", "ParentDocFolderID = " & DocFolderID)

        If Not IfEmpty Then 'doesn't have to be empty, just delete it

            If NumDocs > 0 Then

                'delete all associated docs (tblDoc)
                Dim DocIDs() As Integer = DataHelper.FieldLookupIDs("tblDoc", "DocID", "DocFolderID = " & DocFolderID)

                DocHelper.Delete(DocIDs)

            End If

            'delete the record
            DataHelper.Delete("tblDocFolder", "DocFolderID = " & DocFolderID)

        Else 'has to be empty before deleting

            If NumDocs = 0 And NumDocFolders = 0 Then 'IS empty, so delete it

                'delete the record
                DataHelper.Delete("tblDocFolder", "DocFolderID = " & DocFolderID)

            End If

        End If

    End Function
    Public Shared Sub DeleteEmptyFolders(ByVal ClientID As Integer)

        'start with root folders for client
        Dim RootDocFolderIDs() As Integer = DataHelper.FieldLookupIDs("tblDocFolder", _
            "DocFolderID", "[Table] = 'tblClient' AND Field = 'ClientID' AND FieldID = " & ClientID _
            & " AND ParentDocFolderID IS NULL")

        Delete(RootDocFolderIDs, True)

    End Sub
    Public Shared Function ForceValidate(ByVal DocFolderTypeID As Integer, ByVal ClientID As Integer, ByVal UserID As Integer) As Integer

        'search for this docfoldertypeid
        Dim DocFolderID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblDocFolder", _
            "DocFolderID", "[Table] = 'tblClient' AND Field = 'ClientID' AND FieldID = " & ClientID _
            & " AND DocFolderTypeID = " & DocFolderTypeID))

        If DocFolderID = 0 Then 'does NOT exist

            'before creating that folder, look up to grab it's parent
            Dim ParentDocFolderTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblDocFolderType", _
                "ParentDocFolderTypeID", "DocFolderTypeID = " & DocFolderTypeID))

            If ParentDocFolderTypeID = 0 Then

                Return InsertDocFolder(DocFolderTypeID, "tblClient", "ClientID", ClientID, Nothing, UserID)

            Else 'structure continues upward

                'check to make sure the parent has been created - this will be recursive
                Dim ParentDocFolderID As Integer = ForceValidate(ParentDocFolderTypeID, ClientID, UserID)

                'create the folder
                If ParentDocFolderID = 0 Then
                    Return InsertDocFolder(DocFolderTypeID, "tblClient", "ClientID", ClientID, Nothing, UserID)
                Else
                    Return InsertDocFolder(DocFolderTypeID, "tblClient", "ClientID", ClientID, ParentDocFolderID, UserID)
                End If

            End If

        Else
            Return DocFolderID
        End If

    End Function
    Private Shared Function InsertDocFolder(ByVal DocFolderTypeID As Nullable(Of Integer), ByVal Table As String, _
        ByVal Field As String, ByVal FieldID As Integer, ByVal ParentDocFolderID As Nullable(Of Integer), _
        ByVal UserID As Integer) As Integer

        Dim Name As String = Nothing

        If DocFolderTypeID.HasValue Then
            Name = DataHelper.FieldLookup("tblDocFolderType", "Name", "DocFolderTypeID = " & DocFolderTypeID.Value)
        End If

        Return InsertDocFolder(DocFolderTypeID, Table, Field, FieldID, ParentDocFolderID, Name, UserID)

    End Function
    Private Shared Function InsertDocFolder(ByVal DocFolderTypeID As Nullable(Of Integer), ByVal Table As String, _
        ByVal Field As String, ByVal FieldID As Integer, ByVal ParentDocFolderID As Nullable(Of Integer), _
        ByVal Name As String, ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        If DocFolderTypeID.HasValue Then
            DatabaseHelper.AddParameter(cmd, "DocFolderTypeID", DocFolderTypeID.Value)
        End If

        DatabaseHelper.AddParameter(cmd, "Table", Table)
        DatabaseHelper.AddParameter(cmd, "Field", Field)
        DatabaseHelper.AddParameter(cmd, "FieldID", FieldID)

        If ParentDocFolderID.HasValue Then
            DatabaseHelper.AddParameter(cmd, "ParentDocFolderID", ParentDocFolderID.Value)
        End If

        DatabaseHelper.AddParameter(cmd, "Name", Name)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblDocFolder", "DocFolderID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@DocFolderID").Value)

    End Function
End Class