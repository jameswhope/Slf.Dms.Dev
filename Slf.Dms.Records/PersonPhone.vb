Option Explicit On

Imports Drg.Util.Helpers

Public Class PersonPhone

#Region "Variables"

    Private _personphoneid As Integer
    Private _personid As Integer
    Private _phoneid As Integer

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

#End Region

#Region "Properties"

    ReadOnly Property PersonPhoneID() As Integer
        Get
            Return _personphoneid
        End Get
    End Property
    ReadOnly Property PersonID() As Integer
        Get
            Return _personid
        End Get
    End Property
    ReadOnly Property PhoneID() As Integer
        Get
            Return _phoneid
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

    Public Sub New(ByVal PersonPhoneID As Integer, ByVal PersonID As Integer, ByVal PhoneID As Integer, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String)

        _PersonPhoneID = PersonPhoneID
        _personid = PersonID
        _phoneid = PhoneID

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub

#End Region

End Class