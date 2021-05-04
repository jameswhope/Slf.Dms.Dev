Imports Microsoft.VisualBasic

Public Class CreditorScore

#Region "Fields"
    Protected _score_product_code As String
    Protected _score_sign As String
    Protected _score_score As String
    Protected _score_indicator_flag As String
    Protected _score_derogatory_alert_flag As String
    Protected _score_factor1 As String
    Protected _score_factor2 As String
    Protected _score_factor3 As String
    Protected _score_factor4 As String
    Protected _score_score_card_indicator As String
#End Region

#Region "Properties"
    Public Property score_product_code() As String
        Get
            Return _score_product_code
        End Get
        Set(value As String)
            _score_product_code = value
        End Set
    End Property
    Public Property score_sign() As String
        Get
            Return _score_sign
        End Get
        Set(value As String)
            _score_sign = value
        End Set
    End Property
    Public Property score_score() As String
        Get
            Return _score_score
        End Get
        Set(value As String)
            _score_score = value
        End Set
    End Property
    Public Property score_indicator_flag() As String
        Get
            Return _score_indicator_flag
        End Get
        Set(value As String)
            _score_indicator_flag = value
        End Set
    End Property
    Public Property score_derogatory_alert_flag() As String
        Get
            Return _score_derogatory_alert_flag
        End Get
        Set(value As String)
            _score_derogatory_alert_flag = value
        End Set
    End Property
    Public Property score_factor1() As String
        Get
            Return _score_factor1
        End Get
        Set(value As String)
            _score_factor1 = value
        End Set
    End Property
    Public Property score_factor2() As String
        Get
            Return _score_factor2
        End Get
        Set(value As String)
            _score_factor2 = value
        End Set
    End Property
    Public Property score_factor3() As String
        Get
            Return _score_factor3
        End Get
        Set(value As String)
            _score_factor3 = value
        End Set
    End Property
    Public Property score_factor4() As String
        Get
            Return _score_factor4
        End Get
        Set(value As String)
            _score_factor4 = value
        End Set
    End Property
    Public Property score_score_card_indicator() As String
        Get
            Return _score_score_card_indicator
        End Get
        Set(value As String)
            _score_score_card_indicator = value
        End Set
    End Property

#End Region
End Class
