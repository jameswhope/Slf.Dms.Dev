Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data
Imports Drg.Util.DataAccess

Public Class AgencyGridHelper
    Dim _InputGridName As String = ""
    Dim _UserID As Nullable(Of Integer)
    Dim _AgencyID As Nullable(Of Integer)
    Dim _Definitions As List(Of Definition)

    Public ReadOnly Property Definitions() As List(Of Definition)
        Get
            If _Definitions Is Nothing Then
                _Definitions = GetDefinitions()
            End If
            Return _Definitions
        End Get
    End Property
    Public Property InputGridName() As String
        Get
            Return _InputGridName
        End Get
        Set(ByVal value As String)
            _InputGridName = value
        End Set
    End Property
    Public Property UserID() As Integer
        Get
            If Not _UserID.HasValue Then
                _UserID = Integer.Parse(HttpContext.Current.User.Identity.Name)
            End If
            Return _UserID
        End Get
        Set(ByVal value As Integer)
            _UserID = value
        End Set
    End Property
    Public Property AgencyID() As Integer
        Get
            If Not _AgencyID.HasValue Then
                _AgencyID = DataHelper.Nz_int(DataHelper.FieldLookup("tblAgency", "AgencyID", "UserID=" & UserID))
            End If
            Return _AgencyID
        End Get
        Set(ByVal value As Integer)
            _AgencyID = value
        End Set
    End Property
    Public Structure Definition
        Dim Col As Integer
        Dim FieldName As String
        Dim Required As Boolean
        Dim DataType As String
        Dim Length As Integer
    End Structure
    Public Sub New()

    End Sub
    Public Sub New(ByVal InputGridName As String)
        _InputGridName = InputGridName
    End Sub
    Public Function GetDefinitions() As List(Of Definition)
        Dim result As New List(Of Definition)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InputGrid_GetDefinition")
            DatabaseHelper.AddParameter(cmd, "InputGridName", InputGridName)
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While (rd.Read())
                        Dim d As New Definition

                        d.FieldName = DatabaseHelper.Peel_string(rd, "FieldName")
                        d.Col = DatabaseHelper.Peel_int(rd, "Col")
                        d.DataType = DatabaseHelper.Peel_string(rd, "DataType")
                        d.Length = DatabaseHelper.Peel_int(rd, "Length")
                        d.Required = DatabaseHelper.Peel_bool(rd, "Required")

                        result.Add(d)
                    End While
                End Using
            End Using
        End Using
        Return result
    End Function
    Public Function GetContents() As DataTable
        Return GetContents(False)
    End Function
    Public Function GetContents(ByVal Typed As Boolean) As DataTable
        Dim dt As New DataTable

        For Each d As Definition In Definitions
            If Typed Then
                Select Case d.DataType
                    Case "DateTime"
                        dt.Columns.Add(d.FieldName, GetType(DateTime))
                    Case "Money"
                        dt.Columns.Add(d.FieldName, GetType(Single))
                    Case Else
                        dt.Columns.Add(d.FieldName)
                End Select
            Else
                dt.Columns.Add(d.FieldName)
            End If
        Next

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ClientQueue_Get")
            DatabaseHelper.AddParameter(cmd, "AgencyId", AgencyID)
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While (rd.Read())
                        Dim Row As Integer = DatabaseHelper.Peel_int(rd, "Row")
                        Dim Col As Integer = DatabaseHelper.Peel_int(rd, "Col")
                        Dim Value As String = DatabaseHelper.Peel_string(rd, "Value")
                        Dim r As DataRow
                        If dt.Rows.Count < Row Then
                            r = dt.NewRow
                            dt.Rows.Add(r)
                        Else
                            r = dt.Rows(Row - 1)
                        End If

                        If Typed Then
                            Dim d As Definition = Definitions(Col - 1)
                            Select Case d.DataType
                                Case "DateTime"
                                    r(Col - 1) = DateTime.Parse(Value)
                                Case "Money"
                                    r(Col - 1) = Single.Parse(Value.TrimStart("$"))
                                Case Else
                                    r(Col - 1) = Value
                            End Select
                        Else
                            r(Col - 1) = Value
                        End If
                    End While
                End Using
            End Using
        End Using

        Return dt
    End Function
    Public Function Validate(ByVal Value As String, ByVal Col As Integer) As String
        Dim d As Definition = Definitions(Col - 1)
        If Value = "&nbsp;" Then Value = ""

        If String.IsNullOrEmpty(Value) And d.Required Then Return "Field is required"
        If Not d.Length = 0 AndAlso Value.Length > d.Length Then Return "Max length is " & d.Length & " characters"
        If Value.Length > 0 Then
            Select Case d.DataType
                Case "DateTime"
                    If Not DateTime.TryParse(Value, New DateTime) Then
                        Return "Invalid date format"
                    End If
                Case "Money"
                    If Not Single.TryParse(Value.TrimStart("$"), New Single) Then
                        Return "Invalid currency format"
                    End If
            End Select
        End If
        Return "1"
    End Function
End Class
