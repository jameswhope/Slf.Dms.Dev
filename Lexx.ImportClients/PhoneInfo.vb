Public Enum PhoneType
    home = 27
    cell = 31
    business = 21
    homefax = 29
    businessfax = 32
    other = 32
End Enum

Public Class PhoneInfo
    Private _type As PhoneType = PhoneType.home
    Private _number As String = String.Empty
    Private _extension As String = String.Empty

    Public Sub New(ByVal PType As PhoneType, ByVal Number As String)
        Me.Type = PType
        Me.Number = Number
    End Sub

    Public Property Type() As PhoneType
        Get
            Return _type
        End Get
        Set(ByVal value As PhoneType)
            If System.Array.IndexOf([Enum].GetValues(GetType(PhoneType)), value) = -1 Then Throw New Exception("phone type is not valid")
            _type = value
        End Set
    End Property

    Public Property Number() As String
        Get
            Return _number
        End Get
        Set(ByVal value As String)
            _number = value.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
            If _number = "" Then Throw New Exception("Phone number is invalid")
        End Set
    End Property

    Public ReadOnly Property AreaCode() As String
        Get
            Select Case _number.Length
                Case 10
                    Return _number.Substring(0, 3)
                Case 11
                    Return _number.Substring(1, 3)
                Case Else
                    Return ""
            End Select
        End Get
    End Property

    Public ReadOnly Property LocalNumber() As String
        Get
            Return Right(_number, 7).Trim
        End Get
    End Property

    Public Property Extension() As String
        Get
            Return _extension
        End Get
        Set(ByVal value As String)
            _extension = value
        End Set
    End Property

End Class
