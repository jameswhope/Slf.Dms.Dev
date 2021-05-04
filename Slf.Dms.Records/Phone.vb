Option Explicit On

Imports Drg.Util.Helpers

Public Class Phone

#Region "Variables"

    Private _phoneid As Integer
    Private _phonetypeid As Integer
    Private _phonetypename As String
    Private _areacode As String
    Private _number As String
    Private _extension As String

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

#End Region

#Region "Properties"

    ReadOnly Property PhoneID() As Integer
        Get
            Return _phoneid
        End Get
    End Property
    ReadOnly Property PhoneTypeID() As Integer
        Get
            Return _phonetypeid
        End Get
    End Property
    ReadOnly Property PhoneTypeName() As String
        Get
            Return _phonetypename
        End Get
    End Property
    ReadOnly Property AreaCode() As String
        Get
            Return _areacode
        End Get
    End Property
    ReadOnly Property Number() As String
        Get
            Return _number
        End Get
    End Property
    ReadOnly Property NumberFormatted() As String
        Get

            Return StringHelper.PlaceInMask(_areacode & _number, "(___) ___-____", "_", _
                StringHelper.Filter.AphaNumericOnly, False)

        End Get
    End Property
    ReadOnly Property Extension() As String
        Get
            Return _extension
        End Get
    End Property
    ReadOnly Property Created() As DateTime
        Get
            Return _created
        End Get
    End Property
    ReadOnly Property CreatedBy() As Integer
        Get
            Return _createdby
        End Get
    End Property
    ReadOnly Property CreatedByName() As String
        Get
            Return _createdbyname
        End Get
    End Property
    ReadOnly Property LastModified() As DateTime
        Get
            Return _lastmodified
        End Get
    End Property
    ReadOnly Property LastModifiedBy() As Integer
        Get
            Return _lastmodifiedby
        End Get
    End Property
    ReadOnly Property LastModifiedByName() As String
        Get
            Return _lastmodifiedbyname
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal PhoneID As Integer, ByVal PhoneTypeID As Integer, ByVal PhoneTypeName As String, _
        ByVal AreaCode As String, ByVal Number As String, ByVal Extension As String, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String)

        _phoneid = PhoneID
        _phonetypeid = PhoneTypeID
        _phonetypename = PhoneTypeName
        _areacode = AreaCode
        _number = Number
        _extension = Extension

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub

#End Region

End Class