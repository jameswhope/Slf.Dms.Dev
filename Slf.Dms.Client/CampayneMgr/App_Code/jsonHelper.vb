Imports System.IO
Imports System.Runtime.Serialization.Json
Imports System.Data

Public Class jsonHelper
    Public Shared Function SerializeObjectIntoJson(ByVal s As Object) As String
        Dim serializer As New DataContractJsonSerializer(s.[GetType]())
        Using ms As New MemoryStream()
            serializer.WriteObject(ms, s)
            ms.Flush()
            Dim bytes As Byte() = ms.GetBuffer()
            Dim jsonString As String = Encoding.UTF8.GetString(bytes, 0, bytes.Length).Trim(ControlChars.NullChar)
            Return jsonString
        End Using
    End Function
    Public Shared Function ConvertDataTableToJSON(Dt As DataTable) As String

        Dim StrDc As String() = New String(Dt.Columns.Count) {}
        Dim HeadStr As String = String.Empty
        Dim hdrLst As New List(Of String)
        For i As Integer = 0 To Dt.Columns.Count - 1
            StrDc(i) = Dt.Columns(i).Caption
            hdrLst.Add("""" + StrDc(i) + """ : """ + StrDc(i) + i.ToString() + "¾" + """")
        Next
        HeadStr = Join(hdrLst.ToArray, ",")
        Dim Sb As New StringBuilder()
        Sb.Append("{""" + Dt.TableName + """ : [")
        For i As Integer = 0 To Dt.Rows.Count - 1
            Dim TempStr As String = HeadStr
            Sb.Append("{")
            For j As Integer = 0 To Dt.Columns.Count - 1
                Dim replaceString As String = Dt.Columns(j).ToString & j.ToString() & "¾"
                Dim newString As String = Dt.Rows(i)(j).ToString()
                TempStr = TempStr.Replace(replaceString, newString)
            Next
            Sb.Append(TempStr + "},")
        Next

        Sb = New StringBuilder(Sb.ToString().Substring(0, Sb.ToString().Length - 1))
        Sb.Append("]}")

        Return Sb.ToString()
    End Function
End Class