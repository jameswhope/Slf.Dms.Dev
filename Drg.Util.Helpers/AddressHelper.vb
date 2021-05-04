Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Xml

Public Class AddressHelper

    Public Class AddressInfo

#Region "Variables"

        Private _city As String
        Private _state As String
        Private _stateid As Integer
        Private _zipcode As String
        Private _areacode As String
        Private _timezone As String
        Private _timezoneid As Integer

#End Region

#Region "Properties"

        ReadOnly Property City() As String
            Get
                Return _city
            End Get
        End Property
        ReadOnly Property State() As String
            Get
                Return _state
            End Get
        End Property
        ReadOnly Property StateID() As Integer
            Get
                Return _stateid
            End Get
        End Property
        ReadOnly Property ZipCode() As String
            Get
                Return _zipcode
            End Get
        End Property
        ReadOnly Property AreaCode() As String
            Get
                Return _areacode
            End Get
        End Property
        ReadOnly Property TimeZone() As String
            Get
                Return _timezone
            End Get
        End Property
        ReadOnly Property TimeZoneID() As Integer
            Get
                Return _timezoneid
            End Get
        End Property

#End Region

        Public Sub New(ByVal City As String, ByVal State As String, ByVal ZipCode As String, _
            ByVal AreaCode As String, ByVal TimeZone As String)

            _city = City
            _state = State
            _zipcode = ZipCode
            _areacode = AreaCode
            _timezone = TimeZone

            _stateid = DataHelper.Nz_int(DataHelper.FieldLookup("tblState", "StateID", "Abbreviation = '" & _state & "'"))
            _timezoneid = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", "TimeZoneID", "Abbreviation = '" & _timezone & "'"))

        End Sub

    End Class

    Public Shared Function GetInfoForZip(ByVal ZipCode As String) As AddressInfo

        Try

            Dim Input As New Webservicex_USZip.USZip

            Dim Output As XmlNode = Input.GetInfoByZIP(ZipCode)

            Return ParseAddressInfo(Output)

        Catch ex As Exception
            Return Nothing
        End Try

    End Function
    Private Shared Function ParseAddressInfo(ByVal Output As XmlNode) As AddressInfo

        Dim StartingPoint As XmlNode = Output.ChildNodes(0)

        If Not StartingPoint Is Nothing Then

            Return New AddressInfo(StartingPoint.ChildNodes(0).ChildNodes(0).Value, _
                StartingPoint.ChildNodes(1).ChildNodes(0).Value, _
                StartingPoint.ChildNodes(2).ChildNodes(0).Value, _
                StartingPoint.ChildNodes(3).ChildNodes(0).Value, _
                StartingPoint.ChildNodes(4).ChildNodes(0).Value)

        Else
            Return Nothing
        End If

    End Function
    Public Shared Function GetProper(ByVal Street1 As String, ByVal Street2 As String, ByVal City As String, _
        ByVal State As String, ByVal ZipCode As String) As String

        GetProper = String.Empty

        If Street1.Length > 0 Then
            GetProper += Street1
        End If

        If Street2.Length > 0 Then
            If GetProper.Length > 0 Then
                GetProper += vbCrLf & Street2
            Else
                GetProper += Street2
            End If
        End If

        If City.Length > 0 Then
            If GetProper.Length > 0 Then
                GetProper += vbCrLf & City
            Else
                GetProper += City
            End If
        End If

        If State.Length > 0 Then
            If City.Length > 0 Then
                GetProper += ", " & State
            Else
                If GetProper.Length > 0 Then
                    GetProper += vbCrLf & State
                Else
                    GetProper += State
                End If
            End If
        End If

        If ZipCode.Length > 0 Then
            If State.Length > 0 Then
                GetProper += " " & ZipCode
            ElseIf City.Length > 0 Then
                GetProper += ", " & ZipCode
            Else
                If GetProper.Length > 0 Then
                    GetProper += vbCrLf & ZipCode
                Else
                    GetProper += ZipCode
                End If
            End If
        End If

    End Function
End Class