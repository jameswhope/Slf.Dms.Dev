Public Class RepresentativeInfo
    Private _Id As Integer = 0
    Private _firstName As String = String.Empty
    Private _lastName As String = String.Empty

    Friend Sub New()

    End Sub

    Public Property Id() As Integer
        Get
            Return _Id
        End Get
        Set(ByVal value As Integer)
            _Id = value
        End Set
    End Property

    Public Property FirstName() As String
        Get
            Return _firstName
        End Get
        Set(ByVal value As String)
            _firstName = value
        End Set
    End Property

    Public Property LastName() As String
        Get
            Return _lastName
        End Get
        Set(ByVal value As String)
            _lastName = value
        End Set
    End Property

    Public ReadOnly Property FullName() As String
        Get
            Return String.Format("{0} {1}", _firstName, _lastName).Trim
        End Get
    End Property

    Public Shared Function GetRepresentativeById(ByVal RepId As Integer) As RepresentativeInfo
        Dim dh As New DataHelper
        Dim dt As DataTable = dh.GetUserById(RepId)
        Dim rep As RepresentativeInfo = Nothing
        If dt.Rows.Count > 0 Then
            rep = New RepresentativeInfo
            rep.Id = dt.Rows(0)("UserId")
            rep.FirstName = dt.Rows(0)("FirstName").ToString
            rep.LastName = dt.Rows(0)("LastName").ToString
        End If
        Return rep
    End Function
End Class
