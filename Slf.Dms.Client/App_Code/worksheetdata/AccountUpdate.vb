Option Explicit On

Namespace WorksheetData

    Public Class AccountUpdate

#Region "Variables"

        Private _accountid As Integer
        Private _field As String
        Private _type As String
        Private _value As String

#End Region

#Region "Properties"

        ReadOnly Property AccountID() As Integer
            Get
                Return _accountid
            End Get
        End Property
        ReadOnly Property Field() As String
            Get
                Return _field
            End Get
        End Property
        ReadOnly Property Type() As String
            Get
                Return _type
            End Get
        End Property
        ReadOnly Property Value() As String
            Get
                Return _value
            End Get
        End Property

#End Region

#Region "Constuctor"

        Public Sub New(ByVal AccountID As Integer, ByVal Field As String, ByVal Type As String, _
            ByVal Value As String)

            _accountid = AccountID
            _field = Field
            _type = Type
            _value = Value

        End Sub

#End Region

    End Class

End Namespace