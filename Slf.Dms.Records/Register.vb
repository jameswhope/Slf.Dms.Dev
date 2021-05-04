Option Explicit On

Public Class Register

#Region "Variables"

    Private _registerid As Integer
    Private _clientid As Integer
    Private _accountid As Integer
    Private _transactiondate As DateTime
    Private _checknumber As String
    Private _description As String
    Private _amount As Double
    Private _balance As Double
    Private _entrytypeid As Integer
    Private _entrytypename As String
    Private _isfullypaid As Boolean

    Private _void As Nullable(Of DateTime)
    Private _voidby As Nullable(Of Integer)
    Private _bounce As Nullable(Of DateTime)
    Private _bounceby As Nullable(Of Integer)
    Private _hold As Nullable(Of DateTime)
    Private _holdby As Nullable(Of Integer)
    Private _clear As Nullable(Of DateTime)
    Private _clearby As Nullable(Of Integer)
    Private _importid As Nullable(Of Integer)

#End Region

#Region "Properties"

    ReadOnly Property RegisterID() As Integer
        Get
            Return _registerid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property AccountID() As Integer
        Get
            Return _accountid
        End Get
    End Property
    ReadOnly Property TransactionDate() As DateTime
        Get
            Return _transactiondate
        End Get
    End Property
    ReadOnly Property TransactionDateFormatted() As String
        Get

            Dim Value As String = _transactiondate.ToString("MM/dd/yyyy")

            If _void.HasValue Or _bounce.HasValue Then
                Value = "<font class=""voidTran"">" & Value & "</font>"
            End If

            Return Value

        End Get
    End Property
    ReadOnly Property EntryTypeID() As Integer
        Get
            Return _entrytypeid
        End Get
    End Property
    ReadOnly Property EntryTypeName() As String
        Get
            Return _entrytypename
        End Get
    End Property
    ReadOnly Property CheckNumber() As String
        Get
            Return _checknumber
        End Get
    End Property
    ReadOnly Property Description() As String
        Get
            Return _description
        End Get
    End Property
    ReadOnly Property DescriptionFormatted() As String
        Get

            Dim Value As String = String.Empty

            If _description.Length > 0 Then
                Value = _description
            Else
                If _entrytypename.Length > 1 Then

                    Value = _entrytypename.Substring(0, 1).ToUpper & _entrytypename.Substring(1).ToLower

                End If
            End If

            If _void.HasValue Then
                If Value.Length > 0 Then
                    Value = "VOID - <font class=""voidTran"">" & Value & "</font>"
                Else
                    Value = "VOID"
                End If
            Else
                If _bounce.HasValue Then
                    If Value.Length > 0 Then
                        Value = "BOUNCE - <font class=""voidTran"">" & Value & "</font>"
                    Else
                        Value = "BOUNCE"
                    End If
                Else
                    If Value.Length = 0 Then
                        Value = "&nbsp;"
                    End If
                End If
            End If

            Return Value

        End Get
    End Property
    ReadOnly Property Amount() As Double
        Get
            Return _amount
        End Get
    End Property
    ReadOnly Property Debit() As Double
        Get

            If _amount < 0 Then
                Return Math.Abs(_amount)
            Else
                Return 0.0
            End If

        End Get
    End Property
    ReadOnly Property DebitFormatted() As String
        Get

            If Debit > 0 Then
                Return Debit.ToString("$#,##0.00")
            Else
                Return "&nbsp;"
            End If

        End Get
    End Property
    ReadOnly Property DebitDisplay() As String
        Get

            If _void.HasValue Or _bounce.HasValue Then
                Return "none"
            Else
                Return "inline"
            End If

        End Get
    End Property
    ReadOnly Property Credit() As Double
        Get

            If _amount >= 0 Then
                Return _amount
            Else
                Return 0.0
            End If

        End Get
    End Property
    ReadOnly Property CreditFormatted() As String
        Get

            If Credit > 0 Then
                Return Credit.ToString("$#,##0.00")
            Else
                Return "&nbsp;"
            End If

        End Get
    End Property
    ReadOnly Property CreditDisplay() As String
        Get

            If _void.HasValue Or _bounce.HasValue Then
                Return "none"
            Else
                Return "inline"
            End If

        End Get
    End Property
    ReadOnly Property DescriptionColSpan() As Integer
        Get

            If _void.HasValue Or _bounce.HasValue Then
                Return 3
            Else
                Return 1
            End If

        End Get
    End Property
    ReadOnly Property Balance() As Double
        Get
            Return _balance
        End Get
    End Property
    ReadOnly Property BalanceFormatted() As String
        Get

            Dim _balanceformatted As String = _balance.ToString("$#,##0.00")

            If _balance < 0 Then
                _balanceformatted = "<font style=""color:red;"">" & _balanceformatted & "</font>"
            End If

            Return _balanceformatted

        End Get
    End Property
    ReadOnly Property Void() As Nullable(Of DateTime)
        Get
            Return _void
        End Get
    End Property
    ReadOnly Property VoidBy() As Nullable(Of Integer)
        Get
            Return _voidby
        End Get
    End Property
    ReadOnly Property Bounce() As Nullable(Of DateTime)
        Get
            Return _bounce
        End Get
    End Property
    ReadOnly Property BounceBy() As Nullable(Of Integer)
        Get
            Return _bounceby
        End Get
    End Property
    ReadOnly Property Hold() As Nullable(Of DateTime)
        Get
            Return _hold
        End Get
    End Property
    ReadOnly Property HoldBy() As Nullable(Of Integer)
        Get
            Return _holdby
        End Get
    End Property
    ReadOnly Property Clear() As Nullable(Of DateTime)
        Get
            Return _clear
        End Get
    End Property
    ReadOnly Property ClearBy() As Nullable(Of Integer)
        Get
            Return _clearby
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal RegisterID As Integer, ByVal ClientID As Integer, ByVal AccountID As Integer, _
        ByVal TransactionDate As DateTime, ByVal CheckNumber As String, _
        ByVal Description As String, ByVal Amount As Double, ByVal Balance As Double, _
        ByVal EntryTypeID As Integer, ByVal EntryTypeName As String, ByVal IsFullyPaid As Boolean, _
        ByVal Void As Nullable(Of DateTime), ByVal VoidBy As Nullable(Of Integer), _
        ByVal Bounce As Nullable(Of DateTime), ByVal BounceBy As Nullable(Of Integer), _
        ByVal Hold As Nullable(Of DateTime), ByVal HoldBy As Nullable(Of Integer), _
        ByVal Clear As Nullable(Of DateTime), ByVal ClearBy As Nullable(Of Integer), _
        ByVal ImportID As Nullable(Of Integer))

        _registerid = RegisterID
        _clientid = ClientID
        _accountid = AccountID
        _transactiondate = TransactionDate
        _checknumber = CheckNumber
        _description = Description
        _amount = Amount
        _balance = Balance
        _entrytypeid = EntryTypeID
        _entrytypename = EntryTypeName
        _isfullypaid = IsFullyPaid

        _void = Void
        _voidby = VoidBy
        _bounce = Bounce
        _bounceby = BounceBy
        _hold = Hold
        _holdby = HoldBy
        _clear = Clear
        _clearby = ClearBy
        _importid = ImportID

    End Sub

#End Region

End Class