Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports Lexxiom.BusinessData

Public Class AgentHelper
    Inherits DataHelperBase


#Region "Get Data"
    Public Overloads Function GetAgents(ByVal AgencyID As Integer) As DataTable
        Return MyBase.ExecuteQuery("SELECT AgentID, FirstName,  LastName FROM tblAgent WHERE AgencyID = " & AgencyID & "ORDER BY FirstName, LastName")
    End Function

    Public Overloads Function GetAgents() As DataTable
        Return MyBase.ExecuteQuery("SELECT AgentID, FirstName, LastName FROM tblAgent ORDER BY FirstName, LastName")
    End Function
#End Region

#Region "Insert"
    Public Function InsertAgent(ByVal FirstName As String, _
                                ByVal LastName As String, _
                                ByVal UserId As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        'DatabaseHelper.AddParameter(cmd, "AgencyId", AgencyId)
        DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", LastName)
        DatabaseHelper.AddParameter(cmd, "Created", Now, DbType.DateTime)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserId))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now, DbType.DateTime)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserId))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblAgent", "AgentId", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@AgentID").Value)
    End Function

#End Region

#Region "Update"
    Public Sub UpdateAgent(ByVal AgentId As Integer, _
                                  ByVal FirstName As String, _
                                  ByVal LastName As String, _
                                  ByVal UserId As Integer)


        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        'DatabaseHelper.AddParameter(cmd, "AgencyId", AgencyId)
        DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", LastName)
        DatabaseHelper.AddParameter(cmd, "Created", Now, DbType.DateTime)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserId))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now, DbType.DateTime)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserId))

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblAgent", " AgentId = " & DataHelper.Nz_int(AgentId, -1))

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

#End Region

#Region "Delete"
    Public Sub DeleteAgent(ByVal AgentId As Integer)
        MyBase.ExecuteNonQuery("Delete From tblAgent Where AgentId = " & AgentId)
    End Sub

#End Region






End Class
