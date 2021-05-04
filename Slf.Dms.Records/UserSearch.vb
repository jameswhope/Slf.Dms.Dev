Option Explicit On

Public Class UserSearch

#Region "Variables"

    Private _usersearchid As Integer
    Private _userid As Integer
    Private _search As DateTime
    Private _terms As String
    Private _results As Integer
    Private _resultsclients As Integer
    Private _resultsnotes As Integer
    Private _resultscalls As Integer
    Private _resultstasks As Integer
    Private _resultsemail As Integer
    Private _resultspersonnel As Integer

#End Region

#Region "Properties"

    ReadOnly Property UserSearchID() As Integer
        Get
            Return _usersearchid
        End Get
    End Property
    ReadOnly Property UserID() As Integer
        Get
            Return _userid
        End Get
    End Property
    ReadOnly Property Search() As DateTime
        Get
            Return _search
        End Get
    End Property
    ReadOnly Property Terms() As String
        Get
            Return _terms
        End Get
    End Property
    ReadOnly Property Results() As Integer
        Get
            Return _results
        End Get
    End Property
    ReadOnly Property ResultsClients() As Integer
        Get
            Return _resultsclients
        End Get
    End Property
    ReadOnly Property ResultsNotes() As Integer
        Get
            Return _resultsnotes
        End Get
    End Property
    ReadOnly Property ResultsCalls() As Integer
        Get
            Return _resultscalls
        End Get
    End Property
    ReadOnly Property ResultsTasks() As Integer
        Get
            Return _resultstasks
        End Get
    End Property
    ReadOnly Property ResultsEmail() As Integer
        Get
            Return _resultsemail
        End Get
    End Property
    ReadOnly Property ResultsPersonnel() As Integer
        Get
            Return _resultspersonnel
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal UserSearchID As Integer, ByVal UserID As Integer, ByVal Search As DateTime, _
        ByVal Terms As String, ByVal Results As Integer, ByVal ResultsClients As Integer, _
        ByVal ResultsNotes As Integer, ByVal ResultsCalls As Integer, ByVal ResultsTasks As Integer, _
        ByVal ResultsEmail As Integer, ByVal ResultsPersonnel As Integer)

        _usersearchid = UserSearchID
        _userid = UserID
        _search = Search
        _terms = Terms
        _results = Results
        _resultsclients = ResultsClients
        _resultsnotes = ResultsNotes
        _resultscalls = ResultsCalls
        _resultstasks = ResultsTasks
        _resultsemail = ResultsEmail
        _resultspersonnel = ResultsPersonnel

    End Sub

#End Region

End Class