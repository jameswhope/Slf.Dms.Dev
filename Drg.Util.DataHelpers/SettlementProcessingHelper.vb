Imports Drg.Util.DataAccess

Imports System.Data.SqlClient

Public Class SettlementProcessingHelper
    Public Shared Function InsertSettlement(ByVal settlementID As Integer) As Integer
        Using cmd As New SqlCommand("INSERT INTO tblSettlementProcessing (SettlementID, UserID) VALUES (" & settlementID & ", null) SELECT scope_identity()", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function

    'Public Shared Function IsInApproval(ByVal settlementID As Integer) As Boolean
    '    Using cmd As New SqlCommand("SELECT count(*) FROM tblSettlementProcessingApproval WHERE SettlementID = " & settlementID, ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            Return CBool(cmd.ExecuteScalar() > 0)
    '        End Using
    '    End Using
    'End Function

    'Public Shared Function IsApproved(ByVal settlementID As Integer) As Boolean
    '    Using cmd As New SqlCommand("SELECT Approved FROM tblSettlementProcessingApproval WHERE SettlementID = " & settlementID, ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            Return CBool(cmd.ExecuteScalar())
    '        End Using
    '    End Using
    'End Function

    Public Shared Function IsInApproval(ByVal settlementID As Integer) As Boolean
        Return CBool(SettlementHelper.GetSettlementInformation(settlementID).CurrentSettlementStatusID = 14)
    End Function

    Public Shared Function IsApproved(ByVal settlementID As Integer) As Boolean
        Dim information As SettlementHelper.SettlementInformation = SettlementHelper.GetSettlementInformation(settlementID)
        Return CBool(information.Roadmap.ContainsKey(14) AndAlso Not information.CurrentSettlementStatusID = 14)
    End Function

    Public Shared Sub RequireManagerApproval(ByVal settlementID As Integer, ByVal amount As Double)
        Using cmd As New SqlCommand("INSERT INTO tblSettlementProcessingApproval (SettlementID, PendingAmount) VALUES (" & settlementID & _
        ", " & amount & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function IsManager(ByVal userID As Integer) As Boolean

        If DataHelper.FieldLookup("tblUser", "Manager", "UserID = " & userID) = True Then
            Return True
        Else
         Return CBool(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserID = " & userID) = 11)
        End If

    End Function
End Class