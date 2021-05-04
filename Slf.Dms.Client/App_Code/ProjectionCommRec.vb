Imports Microsoft.VisualBasic

Public Class ProjectionCommRec

#Region "Fields"

    Dim _CommRecId As Integer
    Public _Months() As Double

#End Region 'End Fields

#Region "Properties"

    Public Property CommRecId As Integer
        Get
            Return _CommRecId
        End Get
        Set(value As Integer)
            _CommRecId = value
        End Set
    End Property

#End Region 'End Properties

#Region "Constructors"

    Sub New(CommRecId As Integer)
        _CommRecId = CommRecId
        _Months(0) = 0.0
        _Months(1) = 0.0
        _Months(2) = 0.0
        _Months(3) = 0.0
        _Months(4) = 0.0
        _Months(5) = 0.0
        _Months(6) = 0.0
        _Months(7) = 0.0
        _Months(8) = 0.0
        _Months(9) = 0.0
        _Months(10) = 0.0
        _Months(11) = 0.0
    End Sub

#End Region 'End Constructors

#Region "Methods"

    'Public Sub SendTextMessage()

    'End Sub

#End Region

End Class
