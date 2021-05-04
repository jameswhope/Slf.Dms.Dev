Option Explicit On 

Imports System.Collections.Specialized
Imports System.Text

Public Class QueryStringBuilder
    'Implements IDictionary

    Protected nameList As StringCollection = New StringCollection()
    Protected valueList As StringCollection = New StringCollection()

    Public Sub New()

    End Sub

    Public Sub Add(ByVal name As String, ByVal value As String)
        Dim I As Long

        For I = 0 To nameList.Count - 1
            If String.Compare(nameList(I), name, True) = 0 Then
                valueList(I) = value
                Exit Sub
            End If
        Next I

        nameList.Add(name)
        valueList.Add(value)
    End Sub

    Public Sub Remove(ByVal name As String)
        Dim I As Long

        For I = 0 To nameList.Count - 1
            If String.Compare(nameList(I), name, True) = 0 Then
                nameList.RemoveAt(I)
                valueList.RemoveAt(I)
                Exit Sub
            End If
        Next I
    End Sub

    Public Sub New(ByVal existingQueryString As String)
        If Not existingQueryString.Length = 0 Then
            If existingQueryString.StartsWith("?") Then
                existingQueryString = existingQueryString.Substring(1)
            End If

            Dim str() As String = existingQueryString.Split("&"c)

            Dim I As Integer
            '******************************************************************
            ' BUG ID: 558
            ' Fixed By: Bereket S. Data
            ' Check to see if the array has values before using it
            '******************************************************************
            If (str.Length > 0) Then
                For I = 0 To str.Length - 1
                    Dim pos As Integer

                    pos = str(I).IndexOf("="c)

                    Me.Add(str(I).Substring(0, pos), str(I).Substring(pos + 1))
                Next I
            End If
        End If
    End Sub

    Public ReadOnly Property QueryString() As String
        Get
            Dim str As StringBuilder = New StringBuilder

            Dim initial As Boolean = True

            Dim I As Long

            For I = 0 To nameList.Count - 1
                If initial Then
                    initial = False
                Else
                    str.Append("&"c)
                End If

                str.Append(nameList(I))
                str.Append("="c)
                str.Append(valueList(I))
            Next I

            Return str.ToString()
        End Get
    End Property

    Default Public Property Item(ByVal name As String) As String
        Get

            Dim I As Long = 0

            Item = Nothing

            For I = 0 To nameList.Count - 1
                If String.Compare(nameList(I), name, True) = 0 Then
                    Return valueList(I)
                End If
            Next I

        End Get
        Set(ByVal value As String)

            Dim I As Long

            For I = 0 To nameList.Count - 1
                If String.Compare(nameList(I), name, True) = 0 Then
                    valueList(I) = value
                    Exit Property
                End If
            Next I

            Add(name, value)

        End Set
    End Property

    Public Function ContainsKey(ByVal name As String) As Boolean
        Dim I As Long

        For I = 0 To nameList.Count - 1
            If String.Compare(nameList(I), name, True) = 0 Then
                Return True
            End If
        Next I

        Return False
    End Function

    Public Function ContainsValue(ByVal value As String) As Boolean
        Dim I As Long

        For I = 0 To valueList.Count - 1
            If valueList(I) = value Then
                Return True
            End If
        Next I

        Return False
    End Function
End Class
