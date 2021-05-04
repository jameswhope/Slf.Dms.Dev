Option Explicit On

Imports Drg.Util.Helpers

Public Class DataEntry

#Region "Variables"

    Private _dataentryid As Integer
    Private _clientid As Integer
    Private _dataentrytypeid As Integer
    Private _dataentrytypename As String
    Private _conducted As DateTime

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String

#End Region

#Region "Properties"

    ReadOnly Property DataEntryID() As Integer
        Get
            Return _dataentryid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property DataEntryTypeID() As Integer
        Get
            Return _dataentrytypeid
        End Get
    End Property
    ReadOnly Property DataEntryTypeName() As String
        Get
            Return _dataentrytypename
        End Get
    End Property
    ReadOnly Property Conducted() As DateTime
        Get
            Return _conducted
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

#End Region

#Region "Constructor"

    Public Sub New(ByVal DataEntryID As Integer, ByVal ClientID As Integer, ByVal DataEntryTypeID As Integer, _
        ByVal DataEntryTypeName As String, ByVal Conducted As DateTime, ByVal Created As DateTime, _
        ByVal CreatedBy As Integer, ByVal CreatedByName As String)

        _dataentryid = DataEntryID
        _clientid = ClientID
        _dataentrytypeid = DataEntryTypeID
        _dataentrytypename = DataEntryTypeName
        _conducted = Conducted

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName

    End Sub

#End Region

End Class