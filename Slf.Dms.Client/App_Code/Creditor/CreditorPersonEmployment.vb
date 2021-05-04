Imports Microsoft.VisualBasic

Public Class CreditorPersonEmployment
#Region "Fields"
    Protected _employer_name As String
    Protected _source_indicator As String
    Protected _occupation As String
    Protected _date_hired As String
    Protected _date_separated As String
    Protected _date_verified_or_reported As String
    Protected _date_verified_or_reported_code As String
    Protected _income As String
    Protected _pay_basis As String
#End Region

#Region "Properties"
    Public Property employer_name() As String
        Get
            Return _employer_name
        End Get
        Set(value As String)
            _employer_name = value
        End Set
    End Property
    Public Property source_indicator() As String
        Get
            Return _source_indicator
        End Get
        Set(value As String)
            _source_indicator = value
        End Set
    End Property
    Public Property occupation() As String
        Get
            Return _occupation
        End Get
        Set(value As String)
            _occupation = value
        End Set
    End Property
    Public Property date_hired() As String
        Get
            Return _date_hired
        End Get
        Set(value As String)
            _date_hired = value
        End Set
    End Property
    Public Property date_separated() As String
        Get
            Return _date_separated
        End Get
        Set(value As String)
            _date_separated = value
        End Set
    End Property
    Public Property date_verified_or_reported() As String
        Get
            Return _date_verified_or_reported
        End Get
        Set(value As String)
            _date_verified_or_reported = value
        End Set
    End Property
    Public Property date_verified_or_reported_code() As String
        Get
            Return _date_verified_or_reported_code
        End Get
        Set(value As String)
            _date_verified_or_reported_code = value
        End Set
    End Property
    Public Property income() As String
        Get
            Return _income
        End Get
        Set(value As String)
            _income = value
        End Set
    End Property
    Public Property pay_basis() As String
        Get
            Return _pay_basis
        End Get
        Set(value As String)
            _pay_basis = value
        End Set
    End Property

#End Region
End Class


