Option Explicit On

Imports Drg.Util.DataAccess

Public Class CommandHelper

    Public Shared Function DeepClone(ByVal Original As IDbCommand) As IDbCommand

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = Original.CommandText
        cmd.CommandType = Original.CommandType

        For Each param As SqlClient.SqlParameter In Original.Parameters

            Dim newParam As New SqlClient.SqlParameter()

            newParam.DbType = param.DbType
            newParam.Direction = param.Direction
            newParam.IsNullable = param.IsNullable
            newParam.ParameterName = param.ParameterName
            newParam.Precision = param.Precision
            newParam.Size = param.Size
            newParam.SourceColumn = param.SourceColumn
            newParam.SourceColumnNullMapping = param.SourceColumnNullMapping
            newParam.SourceVersion = param.SourceVersion
            newParam.Value = param.Value

            cmd.Parameters.Add(newParam)

        Next

        Return cmd

    End Function
End Class