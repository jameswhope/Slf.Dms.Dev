Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System
Imports System.Data
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess

Public Class PendingCancelHelper

    Public Sub PendingCancel(ByVal ClientID As Integer, ByVal UserID As Integer)

        Dim strSQL As String = "SELECT AccountID, AccountStatusID FROM tblAccount WHERE AccountStatusID NOT IN (55,54,157,158,159,160,164,166) 	AND ClientID = " & ClientID

        Try
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandType = CommandType.Text
                    cmd.CommandText = strSQL
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader()
                        While rd.Read
                            strSQL = "UPDATE tblAccount SET PreviousStatus = " & rd.Item("AccountStatusID") & ", AccountStatusID = 170, LastModifiedBy = " & UserID & ", LastModified = '" & Now & "' WHERE AccountID = " & rd.Item("AccountID")
                            Using cmd1 As IDbCommand = ConnectionFactory.Create.CreateCommand
                                Using cmd1.Connection
                                    cmd1.CommandType = CommandType.Text
                                    cmd1.CommandText = strSQL
                                    cmd1.Connection.Open()
                                    cmd1.ExecuteNonQuery()
                                End Using
                            End Using
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception

        End Try

    End Sub

    Public Sub ReActivateClient(ByVal ClientID As Integer, ByVal UserID As Integer)

        Dim strSQL As String = "SELECT AccountID, PreviousStatus FROM tblAccount WHERE AccountStatusID NOT IN (55,54,157,158,159,160,164,166) 	AND ClientID = " & ClientID

        Try
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandType = CommandType.Text
                    cmd.CommandText = strSQL
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader()
                        While rd.Read
                            strSQL = "UPDATE tblAccount SET AccountStatusID = " & rd.Item("PreviousStatus") & ", PreviousStatus = NULL, LastModifiedBy = " & UserID & ", LastModified = '" & Now & "' WHERE AccountID = " & rd.Item("AccountID")
                            Using cmd1 As IDbCommand = ConnectionFactory.Create.CreateCommand
                                Using cmd1.Connection
                                    cmd1.CommandType = CommandType.Text
                                    cmd1.CommandText = strSQL
                                    cmd1.Connection.Open()
                                    cmd1.ExecuteNonQuery()
                                End Using
                            End Using
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception

        End Try

    End Sub

End Class
