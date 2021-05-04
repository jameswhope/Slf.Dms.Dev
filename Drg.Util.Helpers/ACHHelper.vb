Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Xml

Public Class ACHHelper

    Public Class ACHInfo

#Region "Variables"

        Private _address As String
        Private _changedate As String
        Private _city As String
        Private _customername As String
        Private _institutionstatuscode As String
        Private _newroutingnumber As String
        Private _officecode As String
        Private _recordtypecode As String
        Private _routingnumber As String
        Private _servicingfrbnumber As String
        Private _statecode As String
        Private _telephoneareacode As String
        Private _telephoneprefixnumber As String
        Private _telephonesuffixnumber As String
        Private _zipcode As String
        Private _zipcodeextension As String

#End Region

#Region "Properties"

        ReadOnly Property Address() As String
            Get
                Return _address
            End Get
        End Property
        ReadOnly Property ChangeDate() As String
            Get
                Return _changedate
            End Get
        End Property
        ReadOnly Property City() As String
            Get
                Return _city
            End Get
        End Property
        ReadOnly Property CustomerName() As String
            Get
                Return _customername
            End Get
        End Property
        ReadOnly Property InstitutionStatusCode() As String
            Get
                Return _institutionstatuscode
            End Get
        End Property
        ReadOnly Property NewRoutingNumber() As String
            Get
                Return _newroutingnumber
            End Get
        End Property
        ReadOnly Property OfficeCode() As String
            Get
                Return _officecode
            End Get
        End Property
        ReadOnly Property RecordTypeCode() As String
            Get
                Return _recordtypecode
            End Get
        End Property
        ReadOnly Property RoutingNumber() As String
            Get
                Return _routingnumber
            End Get
        End Property
        ReadOnly Property ServicingFRBNumber() As String
            Get
                Return _servicingfrbnumber
            End Get
        End Property
        ReadOnly Property StateCode() As String
            Get
                Return _statecode
            End Get
        End Property
        ReadOnly Property TelephoneAreaCode() As String
            Get
                Return _telephoneareacode
            End Get
        End Property
        ReadOnly Property TelephonePrefixNumber() As String
            Get
                Return _telephoneprefixnumber
            End Get
        End Property
        ReadOnly Property TelephoneSuffixNumber() As String
            Get
                Return _telephonesuffixnumber
            End Get
        End Property
        ReadOnly Property ZipCode() As String
            Get
                Return _zipcode
            End Get
        End Property
        ReadOnly Property ZipCodeExtension() As String
            Get
                Return _zipcodeextension
            End Get
        End Property

#End Region

        Public Sub New(ByVal Address As String, ByVal ChangeDate As String, ByVal City as String, _
            byval CustomerName As String, byval InstitutionStatusCode as String, NewRoutingNumber as String, _
            byval OfficeCode as String, byval RecordTypeCode as String, RoutingNumber as String, _
            byval ServicingFRBNumber as String, StateCode as String, TelephoneAreaCode as String, _
            byval TelephonePrefixNumber as String, TelephoneSuffixNumber as String, ZipCode as String, _
            byval ZipCodeExtension as String)

            _address = Address
            _changedate = ChangeDate
            _city = City
            _customername = CustomerName
            _institutionstatuscode = InstitutionStatusCode
            _newroutingnumber = NewRoutingNumber
            _officecode = OfficeCode
            _recordtypecode = RecordTypeCode
            _routingnumber = RoutingNumber
            _servicingfrbnumber = ServicingFRBNumber
            _statecode = StateCode
            _telephoneareacode = TelephoneAreaCode
            _telephoneprefixnumber = TelephonePrefixNumber
            _telephonesuffixnumber = TelephoneSuffixNumber
            _zipcode = ZipCode
            _zipcodeextension = ZipCodeExtension

        End Sub

    End Class

    Public Shared Function GetInfoForRoutingNumber(ByVal RoutingNumber As String) As ACHInfo

        Dim Engine As New Webservicex_ACH.FedACH
        Dim List As New Webservicex_ACH.FedACHList

        If Engine.getACHByRoutingNumber(RoutingNumber, List) Then

            If List.TotalRecords > 0 Then

                'return the first one
                Dim a As Webservicex_ACH.FedACHData = List.FedACHs(0)

                Return New ACHInfo(a.City, a.ChangeDate, a.StateCode, a.Address, String.Empty, _
                    String.Empty, String.Empty, String.Empty, a.RoutingNumber, String.Empty, a.Zipcode, _
                    a.TelephonePrefixNumber, a.TelephoneSuffixNumber, a.TelephoneAreaCode, _
                    a.ZipcodeExtension, String.Empty)

            End If

        End If

        Return Nothing

    End Function

End Class