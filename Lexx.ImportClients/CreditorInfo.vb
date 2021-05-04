Public Class CreditorList
    Private _list As New List(Of CreditorInfo)

    Public Property Items() As List(Of CreditorInfo)
        Get
            Return _list
        End Get
        Set(ByVal value As List(Of CreditorInfo))
            _list = value
        End Set
    End Property

    Public Sub Add(ByVal creditor As CreditorInfo)
        _list.Add(creditor)
    End Sub

    Public Function Match(ByVal creditor As CreditorInfo, Optional ByVal IgnoreId As Boolean = False) As Boolean
        Return (Not FindFirstMatch(creditor, IgnoreId) Is Nothing)
    End Function

    Public Function FindFirstMatch(ByVal creditor As CreditorInfo, Optional ByVal IgnoreId As Boolean = False) As CreditorInfo
        Dim fmatch As CreditorInfo = Nothing
        For Each cred In _list
            If cred.Compare(creditor, IgnoreId) Then
                fmatch = cred
                Exit For
            End If
        Next
        Return fmatch
    End Function

End Class


Public Class CreditorInfo
    Private _id As Integer = 0
    Private _groupId As Integer = 0
    Private _name As String = String.Empty
    Private _address As AddressInfo
    Private _phone As PhoneInfo
    Private _CreatedBy As Integer = 0
    Private _LastModifiedBy As Integer = 0
    Private _CreatedDate As DateTime
    Private _LastModifiedDate As DateTime

    Public Property Id() As Integer
        Get
            Return _id
        End Get
        Set(ByVal value As Integer)
            _id = value
        End Set
    End Property

    Public Property GroupId() As Integer
        Get
            Return _groupId
        End Get
        Set(ByVal value As Integer)
            _groupId = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return _name
        End Get
        Set(ByVal value As String)
            _name = value
        End Set
    End Property

    Public Property Address() As AddressInfo
        Get
            Return _address
        End Get
        Set(ByVal value As AddressInfo)
            _address = value
        End Set
    End Property

    Public Property Phone() As PhoneInfo
        Get
            Return _phone
        End Get
        Set(ByVal value As PhoneInfo)
            _phone = value
        End Set
    End Property

    Public Function Compare(ByVal creditor As CreditorInfo, ByVal IgnoreId As Boolean) As Boolean
        Dim found As Boolean = False
        If IgnoreId OrElse Me.Id = creditor.Id Then
            If Me.Name.Trim.ToLower = creditor.Name.Trim.ToLower Then
                If Me.Address Is Nothing AndAlso creditor.Address Is Nothing Then
                    found = True
                ElseIf Not Me.Address Is Nothing AndAlso Not creditor.Address Is Nothing Then
                    If Me.Address.FullStreet.ToLower = creditor.Address.FullStreet.ToLower _
                        AndAlso Me.Address.City.Trim.ToLower = creditor.Address.City.Trim.ToLower _
                        AndAlso Me.Address.ZipCode.Trim.ToLower = creditor.Address.ZipCode.Trim.ToLower Then
                        If Me.Address.USState Is Nothing AndAlso creditor.Address.USState Is Nothing Then
                            found = True
                        ElseIf Not Me.Address.USState Is Nothing AndAlso Not creditor.Address.USState Is Nothing AndAlso Me.Address.USState.Id = creditor.Address.USState.Id Then
                            found = True
                        End If
                    End If
                End If
            End If
        End If
        Return found
    End Function

    Public Shared Function GetDBMatch(ByVal creditor As CreditorInfo) As CreditorInfo
        Dim fmatch As CreditorInfo = Nothing
        Dim dh As New DataHelper
        Dim dt As DataTable = dh.GetCreditor(creditor)
        If dt.Rows.Count > 0 Then
            creditor.Id = dt.Rows(0)("CreditorId")
            fmatch = creditor
        End If
        Return fmatch
    End Function

    Public Shared Function GetDBMatchId(ByVal creditor As CreditorInfo) As Integer
        Dim creditorid As Integer = 0
        If creditor.Id > 0 Then
            Dim dh As New DataHelper
            Dim dt As DataTable = dh.GetCreditor(creditor.Id)
            If dt.Rows.Count > 0 Then creditorid = creditor.Id
        End If
        Return creditorid
    End Function

    Public Property CreatedBy() As Integer
        Get
            Return _CreatedBy
        End Get
        Set(ByVal value As Integer)
            _CreatedBy = value
        End Set
    End Property

    Public Property LastModifiedBy() As Integer
        Get
            Return _LastModifiedBy
        End Get
        Set(ByVal value As Integer)
            _LastModifiedBy = value
        End Set
    End Property

    Public Property CreatedDate() As DateTime
        Get
            Return _CreatedDate
        End Get
        Set(ByVal value As DateTime)
            _CreatedDate = value
        End Set
    End Property

    Public Property LastModifiedDate() As DateTime
        Get
            Return _LastModifiedDate
        End Get
        Set(ByVal value As DateTime)
            _LastModifiedDate = value
        End Set
    End Property
End Class
