Imports Microsoft.VisualBasic

Public MustInherit Class TextMessage

#Region "Fields"
    Protected _TextMessage As String
    Protected _FromPhoneNumber As String
    Protected _ToPhoneNumber As String
#End Region 'Fields

#Region "Properties"
    Public Property TextMessage As String
        Get
            Return _TextMessage
        End Get
        Set(value As String)
            _TextMessage = value
        End Set
    End Property

    Public Property FromPhoneNumber As String
        Get
            Return _FromPhoneNumber
        End Get
        Set(value As String)
            _FromPhoneNumber = value
        End Set
    End Property

    Public Property ToPhoneNumber As String
        Get
            Return _ToPhoneNumber
        End Get
        Set(value As String)
            _ToPhoneNumber = value
        End Set
    End Property
#End Region 'Properties

#Region "Methods - Must Override"

    Public MustOverride Sub SendTextMessage()

#End Region 'Methods

End Class
