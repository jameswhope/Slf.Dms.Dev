Option Explicit On

Imports Slf.Dms.Records

Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Collections.Generic

Public Class ReferenceFieldHelper

    Public Shared Function GetFieldsForReference(ByVal ReferenceID As Integer, ByVal OrderBy As String) As List(Of ReferenceField)

        GetFieldsForReference = New List(Of ReferenceField)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblReferenceField WHERE ReferenceID = @ReferenceID ORDER BY " & OrderBy

        DatabaseHelper.AddParameter(cmd, "ReferenceID", ReferenceID)

        Using cmd
            Using cmd.Connection
                Using rd

                    cmd.Connection.Open()
                    rd = cmd.ExecuteReader()

                    While rd.Read()

                        GetFieldsForReference.Add(New ReferenceField( _
                            DatabaseHelper.Peel_int(rd, "ReferenceFieldID"), _
                            DatabaseHelper.Peel_int(rd, "ReferenceID"), _
                            DatabaseHelper.Peel_string(rd, "Category"), _
                            DatabaseHelper.Peel_string(rd, "Caption"), _
                            DatabaseHelper.Peel_string(rd, "Field"), _
                            DatabaseHelper.Peel_string(rd, "Definition"), _
                            DatabaseHelper.Peel_string(rd, "Join"), _
                            DatabaseHelper.Peel_string(rd, "Type"), _
                            DatabaseHelper.Peel_bool(rd, "Multi"), _
                            DatabaseHelper.Peel_int(rd, "MultiOrder"), _
                            DatabaseHelper.Peel_string(rd, "MultiFormat"), _
                            DatabaseHelper.Peel_string(rd, "Width"), _
                            DatabaseHelper.Peel_string(rd, "Align"), _
                            DatabaseHelper.Peel_bool(rd, "Single"), _
                            DatabaseHelper.Peel_string(rd, "SingleFormat"), _
                            DatabaseHelper.Peel_bool(rd, "Editable"), _
                            DatabaseHelper.Peel_bool(rd, "Required"), _
                            DatabaseHelper.Peel_string(rd, "Validate"), _
                            DatabaseHelper.Peel_string(rd, "Attributes"), _
                            DatabaseHelper.Peel_string(rd, "Input"), _
                            DatabaseHelper.Peel_string(rd, "IMMask"), _
                            DatabaseHelper.Peel_string(rd, "DDLSource"), _
                            DatabaseHelper.Peel_string(rd, "DDLValue"), _
                            DatabaseHelper.Peel_string(rd, "DDLText"), _
                            DatabaseHelper.Peel_string(rd, "FieldToSave")))

                    End While

                End Using
            End Using
        End Using

    End Function
End Class