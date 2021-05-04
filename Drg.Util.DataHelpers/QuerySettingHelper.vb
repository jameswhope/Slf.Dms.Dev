Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class QuerySettingHelper

    Public Shared Sub Delete(ByVal QuerySettingID As Integer)

        '(1) delete the record
        DataHelper.Delete("tblQuerySetting", "QuerySettingID = " & QuerySettingID)

    End Sub
    Public Shared Sub Delete(ByVal Criteria As String)

        Dim QuerySettingIDs() As Integer = DataHelper.FieldLookupIDs("tblQuerySetting", _
            "QuerySettingID", Criteria)

        Delete(QuerySettingIDs)

    End Sub
    Public Shared Sub DeleteForUser(ByVal UserID As Integer)

        Dim QuerySettingIDs() As Integer = DataHelper.FieldLookupIDs("tblQuerySetting", _
            "QuerySettingID", "UserID = " & UserID)

        Delete(QuerySettingIDs)

    End Sub
    Public Shared Sub Delete(ByVal QuerySettingIDs() As Integer)

        'loop through and delete each one
        For Each QuerySettingID As Integer In QuerySettingIDs
            Delete(QuerySettingID)
        Next

    End Sub
    Public Shared Function Insert(ByVal ClassName As String, ByVal UserID As Integer, ByVal [Object] As String, _
        ByVal SettingType As String, ByVal Value As String) As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "ClassName", ClassName)
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)
            DatabaseHelper.AddParameter(cmd, "Object", [Object])
            DatabaseHelper.AddParameter(cmd, "SettingType", SettingType)
            DatabaseHelper.AddParameter(cmd, "Value", Value)

            DatabaseHelper.AddParameter(cmd, "Created", Now)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblQuerySetting", "QuerySettingID", SqlDbType.Int)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Return DataHelper.Nz_int(cmd.Parameters("@QuerySettingID").Value)

            End Using
        End Using

    End Function
    Public Shared Function Lookup(ByVal ClassName As String, ByVal UserID As Integer, ByVal [Object] As String) As String

        Return DataHelper.FieldLookup("tblQuerySetting", "Value", "[Object]='" & [Object] & "' and userid=" & UserID & " and classname='" & ClassName & "'")

    End Function
End Class