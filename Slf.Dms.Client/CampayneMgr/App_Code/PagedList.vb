Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Namespace jqGridObjects
    Public Class PagedList
        Private _rows As IEnumerable
        Private _totalRecords As Integer
        Private _pageIndex As Integer
        Private _pageSize As Integer
        Private _userData As Object
        Public Sub New(ByVal rows As IEnumerable, ByVal totalRecords As Integer, ByVal pageIndex As Integer, ByVal pageSize As Integer, ByVal userData As Object)
            _rows = rows
            _totalRecords = totalRecords
            _pageIndex = pageIndex
            _pageSize = pageSize
            _userData = userData
        End Sub
        Public Sub New(ByVal rows As IEnumerable, ByVal totalRecords As Integer, ByVal pageIndex As Integer, ByVal pageSize As Integer)
            Me.New(rows, totalRecords, pageIndex, pageSize, Nothing)
        End Sub
        Public ReadOnly Property total() As Integer
            Get
                Try
                    Return CInt(Math.Ceiling(_totalRecords / _pageSize))
                Catch ex As Exception
                    Return 1
                End Try

            End Get
        End Property
        Public ReadOnly Property page() As Integer
            Get
                Return _pageIndex
            End Get
        End Property
        Public ReadOnly Property records() As Integer
            Get
                Return _totalRecords
            End Get
        End Property
        Public ReadOnly Property rows() As IEnumerable
            Get
                Return _rows
            End Get
        End Property
        Public ReadOnly Property userData() As Object
            Get
                Return _userData
            End Get
        End Property
        Public Overloads Overrides Function ToString() As String
            Return Newtonsoft.Json.JsonConvert.SerializeObject(Me)
        End Function
    End Class
End Namespace