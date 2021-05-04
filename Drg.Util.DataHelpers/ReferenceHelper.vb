Option Explicit On

Imports Slf.Dms.Records

Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Reflection
Imports System.Collections.Generic

Public Class ReferenceHelper

    Public Shared Sub [RaiseEvent](ByVal EventName As String, ByVal Table As String, ByVal ID As Integer)

        Dim NewType As Type = Assembly.Load("app_code").GetType("DBObjects." & Table)

        If Not NewType Is Nothing Then

            Dim ConstructorTypes(0) As Type

            ConstructorTypes(0) = GetType(Integer)

            'setup the constructor
            Dim ci As ConstructorInfo = NewType.GetConstructor(BindingFlags.Instance Or _
                BindingFlags.Public, Nothing, CallingConventions.HasThis, ConstructorTypes, Nothing)

            If Not ci Is Nothing Then

                'invoke the constructor after passing in the ID
                Dim NewObject As Object = ci.Invoke(New Object() {ID})

                Dim mi As MethodInfo = NewType.GetMethod(EventName)

                If Not mi Is Nothing Then
                    mi.Invoke(NewObject, Nothing)
                End If

            End If

        End If

    End Sub
    Public Shared Function GetRecords(ByVal CommandText As String) As DataTable

        GetRecords = New DataTable

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = CommandText

        Dim da As New SqlClient.SqlDataAdapter(cmd)

        da.Fill(GetRecords)

    End Function
    Public Shared Function GetCommandText(ByVal Table As String, ByVal Fields As List(Of ReferenceField)) As String
        Return GetCommandText(Table, Fields, Nothing)
    End Function
    Public Shared Function GetCommandText(ByVal Table As String, ByVal Fields As List(Of ReferenceField), _
        ByVal Where As String) As String

        Dim Text As String = String.Empty

        Dim FieldList As New List(Of String)
        Dim SourceList As New List(Of String)

        FieldList.Add(Table & ".*")
        SourceList.Add(Table)

        For Each Field As ReferenceField In Fields

            If Field.Join.Length > 0 AndAlso Not SourceList.Contains(Field.Join) Then 'build a new join
                SourceList.Add(Field.Join)
            End If

            If Field.Definition.Length > 0 Then
                FieldList.Add(Field.Definition)
            End If

        Next

        If Where Is Nothing Then
            Where = String.Empty
        Else
            If Where.Length > 0 Then
                Where = " WHERE " & Where
            End If
        End If

        Return "SELECT " & String.Join(",", FieldList.ToArray()) _
            & " FROM " & String.Join(" ", SourceList.ToArray()) _
            & Where

    End Function
    Public Shared Function Exists(ByVal ReferenceID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT [Table] FROM tblReference WHERE ReferenceID = @ReferenceID"

        DatabaseHelper.AddParameter(cmd, "ReferenceID", ReferenceID)

        Using cmd
            Using cmd.Connection
                Using rd

                    cmd.Connection.Open()

                    Dim Table As String = DataHelper.Nz_string(cmd.ExecuteScalar())

                    If Table.Length > 0 Then
                        Return TableHelper.Exists(Table)
                    Else
                        Return False
                    End If

                End Using
            End Using
        End Using

    End Function
End Class