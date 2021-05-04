Public Class NoteInfo
    Private _Id As Integer = 0
    Private _subject As String = String.Empty
    Private _text As String = String.Empty
    Private _createdBy As RepresentativeInfo
    Private _datecreated As DateTime
    Private _lastmodifiedBy As RepresentativeInfo
    Private _lastmodifieddate As DateTime
    Private _externalId As Integer = 0
    Private _externalsource As String = String.Empty

    Friend Property ID() As Integer
        Get
            Return _Id
        End Get
        Set(ByVal value As Integer)
            _Id = value
        End Set
    End Property

    Public Property Subject() As String
        Get
            Return _subject
        End Get
        Set(ByVal value As String)
            _subject = value
        End Set
    End Property

    Public Property Text() As String
        Get
            Return _text
        End Get
        Set(ByVal value As String)
            _text = value
        End Set
    End Property

    Public Property CreatedBy() As RepresentativeInfo
        Get
            Return _createdBy
        End Get
        Set(ByVal value As RepresentativeInfo)
            _createdBy = value
        End Set
    End Property

    Public Property DateCreated() As DateTime
        Get
            Return _datecreated
        End Get
        Set(ByVal value As DateTime)
            _datecreated = value
        End Set
    End Property

    Public Property LastModifiedBy() As RepresentativeInfo
        Get
            Return _lastmodifiedBy
        End Get
        Set(ByVal value As RepresentativeInfo)
            _lastmodifiedBy = value
        End Set
    End Property

    Public Property LastModifiedDate() As DateTime
        Get
            Return _lastmodifieddate
        End Get
        Set(ByVal value As DateTime)
            _lastmodifieddate = value
        End Set
    End Property

    Public Property ExternalId() As Integer
        Get
            Return _externalId
        End Get
        Set(ByVal value As Integer)
            _externalId = value
        End Set
    End Property

    Public Property ExternalSource() As String
        Get
            Return _externalsource
        End Get
        Set(ByVal value As String)
            _externalsource = value
        End Set
    End Property
End Class
