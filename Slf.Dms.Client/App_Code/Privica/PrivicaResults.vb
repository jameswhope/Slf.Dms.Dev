Imports Microsoft.VisualBasic

Public Class PrivicaResults
#Region "Fields"
    Dim _userID As Integer
    Dim _iraLoginsUserID As Integer
    Dim _routingNumber As Integer
    Dim _paymentType As String
    Dim _bankID As Integer
    Dim _bankVerificationAmt1 As Double
    Dim _bankVerificationAmt2 As Double
    Dim _transferAmt As Double
    Dim _bankName As String
    Dim _vendorID As Integer
    Dim _accountIDtoTransferTo As Integer
    Dim _transactionID As Integer
    Dim _companyID As Integer
    Dim _question1 As String
    Dim _question2 As String
    Dim _question3 As String
    Dim _question4 As String
    Dim _question5 As String
    Dim _Q1answer1 As String
    Dim _Q1answer2 As String
    Dim _Q1answer3 As String
    Dim _Q1answer4 As String
    Dim _Q1answer5 As String
    Dim _Q2answer1 As String
    Dim _Q2answer2 As String
    Dim _Q2answer3 As String
    Dim _Q2answer4 As String
    Dim _Q2answer5 As String
    Dim _Q3answer1 As String
    Dim _Q3answer2 As String
    Dim _Q3answer3 As String
    Dim _Q3answer4 As String
    Dim _Q3answer5 As String
    Dim _Q4answer1 As String
    Dim _Q4answer2 As String
    Dim _Q4answer3 As String
    Dim _Q4answer4 As String
    Dim _Q4answer5 As String
    Dim _Q5answer1 As String
    Dim _Q5answer2 As String
    Dim _Q5answer3 As String
    Dim _Q5answer4 As String
    Dim _Q5answer5 As String
#End Region 'Fields

#Region "Properties"
    Public Property userID() As Integer
        Get
            Return _userID
        End Get
        Set(value As Integer)
            _userID = value
        End Set
    End Property
    Public Property iraLoginsUserID() As Integer
        Get
            Return _iraLoginsUserID
        End Get
        Set(value As Integer)
            _iraLoginsUserID = value
        End Set
    End Property
    Public Property routingNumber() As Integer
        Get
            Return _routingNumber
        End Get
        Set(value As Integer)
            _routingNumber = value
        End Set
    End Property
    Public Property paymentType() As String
        Get
            Return _paymentType
        End Get
        Set(value As String)
            _paymentType = value
        End Set
    End Property
    Public Property bankID() As Integer
        Get
            Return _bankID
        End Get
        Set(value As Integer)
            _bankID = value
        End Set
    End Property
    Public Property bankVerificationAmt1() As Double
        Get
            Return _bankVerificationAmt1
        End Get
        Set(value As Double)
            _bankVerificationAmt1 = value
        End Set
    End Property
    Public Property bankVerificationAmt2() As Double
        Get
            Return _bankVerificationAmt2
        End Get
        Set(value As Double)
            _bankVerificationAmt2 = value
        End Set
    End Property
    Public Property transferAmt() As Double
        Get
            Return _transferAmt
        End Get
        Set(value As Double)
            _transferAmt = value
        End Set
    End Property
    Public Property bankName() As String
        Get
            Return _bankName
        End Get
        Set(value As String)
            _bankName = value
        End Set
    End Property
    Public Property vendorID() As Integer
        Get
            Return _vendorID
        End Get
        Set(value As Integer)
            _vendorID = value
        End Set
    End Property
    Public Property accountIDtoTransferTo() As Integer
        Get
            Return _accountIDtoTransferTo
        End Get
        Set(value As Integer)
            _accountIDtoTransferTo = value
        End Set
    End Property
    Public Property transactionID() As Integer
        Get
            Return _transactionID
        End Get
        Set(value As Integer)
            _transactionID = value
        End Set
    End Property
    Public Property companyID() As Integer
        Get
            Return _companyID
        End Get
        Set(value As Integer)
            _companyID = value
        End Set
    End Property
    Public Property question1() As String
        Get
            Return _question1
        End Get
        Set(value As String)
            _question1 = value
        End Set
    End Property
    Public Property question2() As String
        Get
            Return _question2
        End Get
        Set(value As String)
            _question2 = value
        End Set
    End Property
    Public Property question3() As String
        Get
            Return _question3
        End Get
        Set(value As String)
            _question3 = value
        End Set
    End Property
    Public Property question4() As String
        Get
            Return _question4
        End Get
        Set(value As String)
            _question4 = value
        End Set
    End Property
    Public Property question5() As String
        Get
            Return _question5
        End Get
        Set(value As String)
            _question5 = value
        End Set
    End Property
    Public Property Q1answer1() As String
        Get
            Return _Q1answer1
        End Get
        Set(value As String)
            _Q1answer1 = value
        End Set
    End Property
    Public Property Q1answer2() As String
        Get
            Return _Q1answer2
        End Get
        Set(value As String)
            _Q1answer2 = value
        End Set
    End Property
    Public Property Q1answer3() As String
        Get
            Return _Q1answer3
        End Get
        Set(value As String)
            _Q1answer3 = value
        End Set
    End Property
    Public Property Q1answer4() As String
        Get
            Return _Q1answer4
        End Get
        Set(value As String)
            _Q1answer4 = value
        End Set
    End Property
    Public Property Q1answer5() As String
        Get
            Return _Q1answer5
        End Get
        Set(value As String)
            _Q1answer5 = value
        End Set
    End Property
    Public Property Q2answer1() As String
        Get
            Return _Q2answer1
        End Get
        Set(value As String)
            _Q2answer1 = value
        End Set
    End Property
    Public Property Q2answer2() As String
        Get
            Return _Q2answer2
        End Get
        Set(value As String)
            _Q2answer2 = value
        End Set
    End Property
    Public Property Q2answer3() As String
        Get
            Return _Q2answer3
        End Get
        Set(value As String)
            _Q2answer3 = value
        End Set
    End Property
    Public Property Q2answer4() As String
        Get
            Return _Q2answer4
        End Get
        Set(value As String)
            _Q2answer4 = value
        End Set
    End Property
    Public Property Q2answer5() As String
        Get
            Return _Q2answer5
        End Get
        Set(value As String)
            _Q2answer5 = value
        End Set
    End Property
    Public Property Q3answer1() As String
        Get
            Return _Q3answer1
        End Get
        Set(value As String)
            _Q3answer1 = value
        End Set
    End Property
    Public Property Q3answer2() As String
        Get
            Return _Q3answer2
        End Get
        Set(value As String)
            _Q3answer2 = value
        End Set
    End Property
    Public Property Q3answer3() As String
        Get
            Return _Q3answer3
        End Get
        Set(value As String)
            _Q3answer3 = value
        End Set
    End Property
    Public Property Q3answer4() As String
        Get
            Return _Q3answer4
        End Get
        Set(value As String)
            _Q3answer4 = value
        End Set
    End Property
    Public Property Q3answer5() As String
        Get
            Return _Q3answer5
        End Get
        Set(value As String)
            _Q3answer5 = value
        End Set
    End Property
    Public Property Q4answer1() As String
        Get
            Return _Q4answer1
        End Get
        Set(value As String)
            _Q4answer1 = value
        End Set
    End Property
    Public Property Q4answer2() As String
        Get
            Return _Q4answer2
        End Get
        Set(value As String)
            _Q4answer2 = value
        End Set
    End Property
    Public Property Q4answer3() As String
        Get
            Return _Q4answer3
        End Get
        Set(value As String)
            _Q4answer3 = value
        End Set
    End Property
    Public Property Q4answer4() As String
        Get
            Return _Q4answer4
        End Get
        Set(value As String)
            _Q4answer4 = value
        End Set
    End Property
    Public Property Q4answer5() As String
        Get
            Return _Q4answer5
        End Get
        Set(value As String)
            _Q4answer5 = value
        End Set
    End Property
    Public Property Q5answer1() As String
        Get
            Return _Q5answer1
        End Get
        Set(value As String)
            _Q5answer1 = value
        End Set
    End Property
    Public Property Q5answer2() As String
        Get
            Return _Q5answer2
        End Get
        Set(value As String)
            _Q5answer2 = value
        End Set
    End Property
    Public Property Q5answer3() As String
        Get
            Return _Q5answer3
        End Get
        Set(value As String)
            _Q5answer3 = value
        End Set
    End Property
    Public Property Q5answer4() As String
        Get
            Return _Q5answer4
        End Get
        Set(value As String)
            _Q5answer4 = value
        End Set
    End Property
    Public Property Q5answer5() As String
        Get
            Return _Q5answer5
        End Get
        Set(value As String)
            _Q5answer5 = value
        End Set
    End Property
#End Region

#Region "Methods"
    Public Function getBetween(ByVal strSource As String, ByVal strStart As String, ByVal strEnd As String) As String
        Dim stringStart As Integer
        Dim stringEnd As Integer

        If strSource.Contains(strStart) AndAlso strSource.Contains(strEnd) Then
            stringStart = strSource.IndexOf(strStart, 0) + strStart.Length
            stringEnd = strSource.IndexOf(strEnd, stringStart)
                Return strSource.Substring(stringStart, stringEnd - stringStart)
            Else
                Return ""
            End If
    End Function
#End Region
End Class
