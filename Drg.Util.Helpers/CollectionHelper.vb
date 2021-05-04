Option Explicit On 

Imports System.Collections

Public Class CollectionHelper
    Public Shared Function Contains(ByVal cln As ICollection, ByVal value As Object) As Boolean
        Return Contains(cln, value, True)
    End Function

    Public Shared Function Contains(ByVal cln As ICollection, ByVal value As Object, ByVal caseSensitive As Boolean) As Boolean
        Dim o As Object

        For Each o In cln
            If o = value OrElse o Is value Then
                Return True
            ElseIf TypeOf o Is String Then
                If caseSensitive = False Then
                    If CStr(o).ToLower = CStr(value).ToLower Then
                        Return True
                    End If
                End If
            End If
        Next

        Return False
    End Function

    Public Shared Function ContainsName(ByVal cln As ICollection, ByVal name As string, ByVal caseSensitive As Boolean) As Boolean
        Dim o As Object

        For Each o In cln
            If o.Name = name OrElse o.Name Is name Then
                Return True
            ElseIf TypeOf o Is String Then
                If caseSensitive = False Then
                    If CStr(o.Name).ToLower = name.ToLower Then
                        Return True
                    End If
                End If
            End If
        Next

        Return False
    End Function
End Class
