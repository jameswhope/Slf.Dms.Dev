Imports System
Imports System.Text
Imports System.Collections.Generic

Friend Class RegisterEntry
    Private _registerId As Integer
    Private _amount As Decimal

    Public ReadOnly Property RegisterId() As Integer
        Get
            Return _registerId
        End Get
    End Property

    Public ReadOnly Property Amount() As Decimal
        Get
            Return _amount
        End Get
    End Property

    'INSTANT VB NOTE: The parameter registerId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
    'INSTANT VB NOTE: The parameter amount was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
    Public Sub New(ByVal registerId_Renamed As Integer, ByVal amount_Renamed As Decimal)
        _registerId = registerId_Renamed
        _amount = amount_Renamed
    End Sub
End Class