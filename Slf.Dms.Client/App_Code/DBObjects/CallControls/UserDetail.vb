Imports ININ.IceLib.People
Imports System.Data

Public Class UserDetail
    Private _ext As String
    Private _firstname As String
    Private _lastname As String
    Private _userstat As UserStatus

    Public Sub New(ByVal userstat As UserStatus)
        _userstat = userstat
        If Not userstat Is Nothing Then
            Dim dt As DataTable = ConnectionContext.GetUserDetails(_userstat.UserId)
            If dt.Rows.Count > 0 Then
                _firstname = dt.Rows(0)("FirstName").ToString
                _lastname = dt.Rows(0)("LastName").ToString
                _ext = dt.Rows(0)("BusinessPhone").ToString.Replace("/", "")
            End If
        End If
    End Sub

    Public Sub New(ByVal FName As String, ByVal LName As String, ByVal Ext As String, ByVal userstat As UserStatus)
        _userstat = userstat
        _firstname = FName
        _lastname = LName
        _ext = Ext
    End Sub

    Public ReadOnly Property FirstName() As String
        Get
            Return _firstname
        End Get
    End Property

    Public ReadOnly Property LastName() As String
        Get
            Return _lastname
        End Get
    End Property

    Public ReadOnly Property Extension() As String
        Get
            Return _ext
        End Get
    End Property

    Public ReadOnly Property Status() As UserStatus
        Get
            Return _userstat
        End Get
    End Property

End Class