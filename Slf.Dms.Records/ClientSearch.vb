Option Explicit On

Imports Drg.Util.Helpers

Imports System.Web.HttpContext

Public Class ClientSearch

#Region "Variables"

    Private _clientid As Integer
    Private _ClientStatus As String
    Private _type As String
    Private _name As String
    Private _address As String
    Private _contacttype As String
    Private _contactnumber As String
    Private _approot As String
    Private _accountNumber As String
    Private _ssn As String
    Private _searchString As String

#End Region

#Region "Properties"

    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property ClientStatus() As String
        Get
            Return _ClientStatus
        End Get
    End Property
    ReadOnly Property Type() As String
        Get
            Return _type
        End Get
    End Property
    ReadOnly Property TypeDisplay() As String
        Get
            Return _type.Replace(vbCrLf, "<br>")
        End Get
    End Property
    ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property
    ReadOnly Property NameDisplay() As String
        Get

            Dim Value As String = String.Empty

            Dim NameParts() As String = _name.Split(vbCrLf)
            Dim TypeParts() As String = _type.Split(vbCrLf)

            For i As Integer = 0 To NameParts.Length - 1

                Dim Name As String
                Dim Type As String = ""

                If Len(_searchString) > 0 Then
                    Name = NameParts(i).Trim.Replace(_searchString, String.Format("<span style='background-color:Yellow'>{0}</span>", _searchString)).Replace(StrConv(_searchString, VbStrConv.ProperCase), String.Format("<span style='background-color:Yellow'>{0}</span>", StrConv(_searchString, VbStrConv.ProperCase)))
                Else
                    Name = NameParts(i).Trim
                End If

                If i > TypeParts.Length - 1 Then
                    Type = "Other"
                Else
                    Type = TypeParts(i).Trim
                End If

                If i = 0 Then 'first
                    Value = Name

                    If _ClientStatus IsNot Nothing Then
                        Select Case _ClientStatus.ToLower
                            Case "active"
                                Value += " - <font color='green'>" & _ClientStatus & "</font>"
                            Case "cancelled", "suspended"
                                Value += " - <font color='red'>" & _ClientStatus & "</font>"
                            Case "inactive"
                                Value += " - <font color='gray'>" & _ClientStatus & "</font>"
                            Case "completed"
                                Value += " - <font color='blue'>" & _ClientStatus & "</font>"
                            Case Else
                                If Len(_ClientStatus) > 0 Then
                                    Value += " - " & _ClientStatus
                                End If
                        End Select
                    End If

                Else

                    If i = NameParts.Length - 1 Then 'last
                        Value += "<br><img align=""absmiddle"" style=""margin-left:5;margin-right:3;"" src=""" & _approot & "images/rootend3.png"" border=""0"" />"
                    Else 'not first, not last
                        Value += "<br><img align=""absmiddle"" style=""margin-left:5;margin-right:3;"" src=""" & _approot & "images/rootconnector3.png"" border=""0"" />"
                    End If

                    Value += Name & " (" & Type & ")"

                End If

            Next

            Return Value

        End Get
    End Property
    ReadOnly Property Address() As String
        Get
            Return _address
        End Get
    End Property
    ReadOnly Property AddressDisplay() As String
        Get

            Dim Value As String = String.Empty

            Dim AddressParts() As String = _address.Split(vbCrLf)

            For i As Integer = 0 To AddressParts.Length - 1

                Dim AddressPart As String = AddressParts(i).Trim

                If AddressPart.Length > 0 Then

                    If Value.Length > 0 Then
                        Value += "<span style=""width:100%;background-image:url(" & _approot & "images/dot.png);background-position:left center;background-repeat:repeat-x;"">&nbsp;</span><br>"
                    End If

                    If Len(_searchString) > 0 Then
                        Value += AddressPart.Replace("|", "<br>").Replace(_searchString, String.Format("<span style='background-color:Yellow'>{0}</span>", _searchString)).Replace(StrConv(_searchString, VbStrConv.ProperCase), String.Format("<span style='background-color:Yellow'>{0}</span>", StrConv(_searchString, VbStrConv.ProperCase)))
                    Else
                        Value += AddressPart.Replace("|", "<br>")
                    End If

                End If

            Next

            Return Value

        End Get
    End Property
    ReadOnly Property ContactType() As String
        Get
            Return _contacttype
        End Get
    End Property
    ReadOnly Property ContactTypeDisplay() As String
        Get

            Dim Value As String = String.Empty

            Dim ContactTypeParts() As String = _contacttype.Split(vbCrLf)

            For i As Integer = 0 To ContactTypeParts.Length - 1

                Dim ContactTypePart As String = ContactTypeParts(i).Trim

                If ContactTypePart.Length > 0 Then

                    If Value.Length > 0 Then
                        Value += "<br>"
                    End If

                    Value += ContactTypePart

                End If

            Next

            Return Value

        End Get
    End Property
    ReadOnly Property ContactNumber() As String
        Get
            Return _contactnumber
        End Get
    End Property
    ReadOnly Property ContactNumberDisplay() As String
        Get

            Dim Value As String = String.Empty

            Dim ContactTypeParts() As String = _contacttype.Split(vbCrLf)
            Dim ContactNumberParts() As String = _contactnumber.Split(vbCrLf)

            For i As Integer = 0 To ContactNumberParts.Length - 1

                Dim ContactTypePart As String = ContactTypeParts(i).Trim
                Dim ContactNumberPart As String = ContactNumberParts(i).Trim

                If ContactTypePart.Length > 0 Then

                    If Value.Length > 0 Then
                        Value += "<br>"
                    End If

                    Value += ContactTypePart & " - "

                    If Len(_searchString) > 0 Then
                        If StringHelper.Validate(StringHelper.ValidationType.EmailAddress, ContactNumberPart) Then
                            Value += ContactNumberPart.Replace(_searchString, String.Format("<span style='background-color:Yellow'>{0}</span>", _searchString))
                        Else
                            If ContactNumberPart.Contains(_searchString) Then
                                Dim a As Integer = ContactNumberPart.IndexOf(_searchString)
                                Value += ContactNumberPart.Replace(_searchString, String.Format("<span style='background-color:Yellow'>{0}</span>", _searchString))
                            Else
                                Value += StringHelper.PlaceInMask(ContactNumberPart, "(___) ___-____", "_", StringHelper.Filter.AphaNumericOnly, False)
                            End If
                        End If
                    Else
                        If StringHelper.Validate(StringHelper.ValidationType.EmailAddress, ContactNumberPart) Then
                            Value += ContactNumberPart
                        Else
                            Value += StringHelper.PlaceInMask(ContactNumberPart, "(___) ___-____", "_", StringHelper.Filter.AphaNumericOnly, False)
                        End If
                    End If

                End If

            Next

            If Value.Length = 0 Then
                Value = "&nbsp;"
            End If

            Return Value

        End Get
    End Property
    ReadOnly Property AccountNumberDisplay() As String
        Get
            If Len(_searchString) > 0 Then
                Return _accountNumber.Replace(_searchString, String.Format("<span style='background-color:Yellow'>{0}</span>", _searchString))
            Else
                Return _accountNumber
            End If
        End Get
    End Property
    ReadOnly Property SSNDisplay() As String
        Get
            Dim Value As String = String.Empty
            Dim SSNParts() As String = _ssn.Split(vbCrLf)

            For i As Integer = 0 To SSNParts.Length - 1
                Dim SSNPart As String = SSNParts(i).Trim

                If SSNPart.Length > 0 Then
                    If Value.Length > 0 Then
                        Value += "<br>"
                    End If

                    If Len(_searchString) > 0 Then
                        Value += SSNPart.Replace(_searchString, String.Format("<span style='background-color:Yellow'>{0}</span>", _searchString))
                    Else
                        Value += SSNPart
                    End If
                End If
            Next

            If Value.Length = 0 Then
                Value = "&nbsp;"
            End If

            Return Value
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal ClientID As Integer, ByVal Type As String, ByVal Name As String, _
        ByVal Address As String, ByVal ContactType As String, ByVal ContactNumber As String, _
        ByVal AppRoot As String)

        _clientid = ClientID
        _type = Type
        _name = Name
        _address = Address
        _contacttype = ContactType
        _contactnumber = ContactNumber

        _approot = AppRoot

    End Sub

    Public Sub New(ByVal ClientID As Integer, ByVal ClientStatus As String, ByVal Type As String, ByVal Name As String, _
           ByVal Address As String, ByVal ContactType As String, ByVal ContactNumber As String, _
           ByVal AppRoot As String)

        _clientid = ClientID
        _ClientStatus = ClientStatus
        _type = Type
        _name = Name
        _address = Address
        _contacttype = ContactType
        _contactnumber = ContactNumber

        _approot = AppRoot

    End Sub

    Public Sub New(ByVal ClientID As Integer, ByVal ClientStatus As String, ByVal Type As String, ByVal Name As String, _
           ByVal Address As String, ByVal ContactType As String, ByVal ContactNumber As String, _
           ByVal AccountNumber As String, ByVal SSN As String, ByVal AppRoot As String, ByVal SearchString As String)

        _clientid = ClientID
        _ClientStatus = ClientStatus
        _type = Type
        _name = Name
        _address = Address
        _contacttype = ContactType
        _contactnumber = ContactNumber
        _accountNumber = AccountNumber
        _ssn = SSN

        _approot = AppRoot
        _searchString = SearchString

    End Sub
#End Region

End Class