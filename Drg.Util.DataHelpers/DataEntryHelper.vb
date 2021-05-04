Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class DataEntryHelper

    Public Shared Sub SetupUnderwriting(ByVal ClientID As Integer, ByVal UserID As Integer)

        'check if already has "started underwriting"
        Dim RoadmapID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblRoadmap", "RoadmapID", _
            "ClientID = " & ClientID & " AND ClientStatusID = " & 10))

        If RoadmapID = 0 Then 'never had "started underwriting"

            'check if already has "received lsa"
            RoadmapID = DataHelper.Nz_int(DataHelper.FieldLookup("tblRoadmap", "RoadmapID", _
                "ClientID = " & ClientID & " AND ClientStatusID = " & 7))

            If Not RoadmapID = 0 Then 'has "received lsa"

                'check if already has "received deposit"
                RoadmapID = DataHelper.Nz_int(DataHelper.FieldLookup("tblRoadmap", "RoadmapID", _
                    "ClientID = " & ClientID & " AND ClientStatusID = " & 8))

                If Not RoadmapID = 0 Then 'has "received deposit"

                    'insert roadmap for "started underwriting"
                    RoadmapHelper.InsertRoadmap(ClientID, 10, Nothing, UserID)

                    'get this client's preferred language
                    Dim LanguageID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", _
                        "LanguageID", "PersonID = " & ClientHelper.GetDefaultPerson(ClientID)))

                    'get the next underwriter who speaks this language
                    Dim UnderwriterUserID As Integer = UserHelper.GetNextUser(LanguageID, 2)

                    'get current roadmap location
                    Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(ClientID, Now, _
                        "RoadmapID"))

                    'insert task for "welcome interview" (tasktype 4) against this client/underwriter
                    Dim TaskTypeID As Integer = 4

                    Dim Description As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", _
                        "TaskTypeID = " & TaskTypeID)

                    TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, _
                        UnderwriterUserID, Now, UserID)

                End If

            End If

        End If

    End Sub
    Public Shared Sub PropogateRoadmaps(ByVal DataEntryID As Integer, ByVal UserID As Integer)

        Dim ClientID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblDataEntry", "ClientID", "DataEntryID = " & DataEntryID))
        Dim DataEntryTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblDataEntry", "DataEntryTypeID", "DataEntryID = " & DataEntryID))

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblDataEntryPropagation WHERE Type = 'Roadmap' AND DataEntryTypeID = @DataEntryTypeID ORDER BY [Order]"

        DatabaseHelper.AddParameter(cmd, "DataEntryTypeID", DataEntryTypeID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim Type As String = DatabaseHelper.Peel_string(rd, "Type")
                Dim TypeID As Integer = DatabaseHelper.Peel_int(rd, "TypeID")

                'simply insert a new roadmap against this client
                RoadmapHelper.InsertRoadmap(ClientID, TypeID, Nothing, UserID)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function InsertDataEntryValue(ByVal DataEntryID As Integer, ByVal Name As String, _
        ByVal Value As String) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "DataEntryID", DataEntryID)
        DatabaseHelper.AddParameter(cmd, "Name", Name)
        DatabaseHelper.AddParameter(cmd, "Value", Value)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblDataEntryValue", "DataEntryValueID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@DataEntryValueID").Value)

    End Function
    Public Shared Function InsertDataEntry(ByVal ClientID As Integer, ByVal DataEntryTypeID As Integer, _
        ByVal Conducted As DateTime, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "DataEntryTypeID", DataEntryTypeID)
        DatabaseHelper.AddParameter(cmd, "Conducted", Conducted)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblDataEntry", "DataEntryID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@DataEntryID").Value)

    End Function
    Public Shared Sub InsertDataEntryDocs(ByVal DataEntryID As Integer, ByVal DocIDs() As Integer)

        For Each DocID As Integer In DocIDs
            InsertDataEntryDoc(DataEntryID, DocID)
        Next

    End Sub
    Public Shared Function InsertDataEntryDoc(ByVal DataEntryID As Integer, ByVal DocID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "DataEntryID", DataEntryID)
        DatabaseHelper.AddParameter(cmd, "DocID", DocID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblDataEntryDoc", "DataEntryDocID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@DataEntryDocID").Value)

    End Function
    Public Shared Sub Delete(ByVal DataEntryID As Integer)

        '(1) find all associated docs (tblDoc) created by this data entry (tblDataEntryDoc)
        Dim DocIDs() As Integer = DataHelper.FieldLookupIDs("tblDataEntryDoc", "DocID", "DataEntryID = " & DataEntryID)

        For Each DocID As Integer In DocIDs
            DocHelper.Delete(DocID)
        Next

        '(2) delete all associated data entry docs (tblDataEntryDoc)
        DataHelper.Delete("tblDataEntryDoc", "DataEntryID = " & DataEntryID)

        '(3) delete all associated data entry values (tblDataEntryValue)
        DataHelper.Delete("tblDataEntryValue", "DataEntryID = " & DataEntryID)

        '(4) delete the record
        DataHelper.Delete("tblDataEntry", "DataEntryID = " & DataEntryID)

    End Sub
    Public Shared Sub Delete(ByVal DataEntryIDs() As Integer)

        'loop through and delete each one
        For Each DataEntryID As Integer In DataEntryIDs
            Delete(DataEntryID)
        Next

    End Sub
    Public Shared Function GetName(ByVal DataEntryID As Integer) As String

        Dim DataEntryTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblDataEntry", "DataEntryTypeID", "DataEntryID = " & DataEntryID))

        Return DataHelper.FieldLookup("tblDataEntryType", "Name", "DataEntryTypeID = " & DataEntryTypeID)

    End Function
End Class