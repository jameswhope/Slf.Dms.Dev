Imports Microsoft.VisualBasic
Imports System.Collections.Specialized
Imports System.Collections.Generic
Public Structure Batch
    Dim CommBatchId As Integer
    Dim [Date] As DateTime
    Dim Amount As Single
    Dim AgencyName As String
End Structure
Public Class BatchPaymentsSummary_FeeTypeAmount
    Private _EntryTypeId As Integer
    Private _Amount As Single
    Private _TransferAmount As Single

    Public Property TransferAmount() As Single
        Get
            Return _TransferAmount
        End Get
        Set(ByVal value As Single)
            _TransferAmount = value
        End Set
    End Property
    Public Property Amount() As Single
        Get
            Return _Amount
        End Get
        Set(ByVal value As Single)
            _Amount = value
        End Set
    End Property
    Public Property EntryTypeId() As Integer
        Get
            Return _EntryTypeId
        End Get
        Set(ByVal value As Integer)
            _EntryTypeId = value
        End Set
    End Property
    Public Sub New()

    End Sub
End Class
Public Class BatchPaymentsSummary_FeeType
    Private _EntryTypeId As Integer
    Private _Name As String

    Public Property EntryTypeId() As Integer
        Get
            Return _EntryTypeId
        End Get
        Set(ByVal value As Integer)
            _EntryTypeId = value
        End Set
    End Property
    Public Property Name() As String
        Get
            Return _Name
        End Get
        Set(ByVal value As String)
            _Name = value
        End Set
    End Property
    Public Sub New()

    End Sub
End Class
Public Class BatchPaymentsSummary_Recipient
    Private _Name As String
    Private _FeeTypes As New Dictionary(Of Integer, BatchPaymentsSummary_FeeTypeAmount)
    Private _CommRecId As Integer
    Private _ParentCommRecId As Nullable(Of Integer)
    Private _Level As Integer
    Private _Parent As BatchPaymentsSummary_Recipient
    Private _Children As New List(Of BatchPaymentsSummary_Recipient)
    Private _IsLast As Boolean
    Private _GrossAmount As Single
    Private _NetAmount As Single

    Public Property IsLast() As Boolean
        Get
            Return _IsLast
        End Get
        Set(ByVal value As Boolean)
            _IsLast = value
        End Set
    End Property
    Public Property Level() As Integer
        Get
            Return _Level
        End Get
        Set(ByVal value As Integer)
            _Level = value
        End Set
    End Property
    Public Property Parent() As BatchPaymentsSummary_Recipient
        Get
            Return _Parent
        End Get
        Set(ByVal value As BatchPaymentsSummary_Recipient)
            _Parent = value
        End Set
    End Property
    Public Property Children() As List(Of BatchPaymentsSummary_Recipient)
        Get
            Return _Children
        End Get
        Set(ByVal value As List(Of BatchPaymentsSummary_Recipient))
            _Children = value
        End Set
    End Property
    Public Sub Add(ByVal Recipient As BatchPaymentsSummary_Recipient)
        'Add (combine) the fee type amounts
        For Each f As BatchPaymentsSummary_FeeTypeAmount In Recipient.FeeTypeAmounts.Values
            Dim FeeTypeAmount As BatchPaymentsSummary_FeeTypeAmount = Nothing
            If Not FeeTypeAmounts.TryGetValue(f.EntryTypeId, FeeTypeAmount) Then
                FeeTypeAmounts.Add(f.EntryTypeId, f)
            Else
                'combine with existing fee type amount
                FeeTypeAmount.Amount += f.Amount
                FeeTypeAmount.TransferAmount += f.TransferAmount
            End If
        Next
    End Sub
    Public Property CommRecId() As Integer
        Get
            Return _CommRecId
        End Get
        Set(ByVal value As Integer)
            _CommRecId = value
        End Set
    End Property
    Public Property ParentCommRecId() As Nullable(Of Integer)
        Get
            Return _ParentCommRecId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            _ParentCommRecId = value
        End Set
    End Property
    Public Property FeeTypeAmounts() As Dictionary(Of Integer, BatchPaymentsSummary_FeeTypeAmount)
        Get
            Return _FeeTypes
        End Get
        Set(ByVal value As Dictionary(Of Integer, BatchPaymentsSummary_FeeTypeAmount))
            _FeeTypes = value
        End Set
    End Property
    Public Property Name() As String
        Get
            Return _Name
        End Get
        Set(ByVal value As String)
            _Name = value
        End Set
    End Property
    Public Property NetAmount() As Single
        Get
            Return _NetAmount
        End Get
        Set(ByVal value As Single)
            _netAmount = value
        End Set
    End Property
    Public Property GrossAmount() As Single
        Get
            Return _GrossAmount
        End Get
        Set(ByVal value As Single)
            _GrossAmount = value
        End Set
    End Property
    Public Function TotalNet() As Double
        Dim Total As Double = 0
        For Each f As BatchPaymentsSummary_FeeTypeAmount In FeeTypeAmounts.Values
            Total += f.Amount
        Next
        Return Total
    End Function
    Public Function TotalGross() As Double
        Dim Total As Double = TotalNet()
        For Each c As BatchPaymentsSummary_Recipient In Children
            Total += c.TotalGross()
        Next
        Return Total
    End Function
    Public Sub New()

    End Sub
End Class
Public Class BatchPaymentsSummary_Agency
    Private _Recipients As New Dictionary(Of Integer, BatchPaymentsSummary_Recipient)
    Private _FeeTypes As New Dictionary(Of Integer, BatchPaymentsSummary_FeeType)
    Private _Name As String
    Private _AgencyId As Integer

    Public Sub Add(ByVal Agency As BatchPaymentsSummary_Agency)
        'Add all the fee type definitions
        For Each f As BatchPaymentsSummary_FeeType In Agency.FeeTypes.Values
            If Not FeeTypes.ContainsKey(f.EntryTypeId) Then
                FeeTypes.Add(f.EntryTypeId, f)
            End If
        Next

        'Add (combine) the recipients
        For Each r As BatchPaymentsSummary_Recipient In Agency.Recipients.Values
            Dim Recipient As BatchPaymentsSummary_Recipient = Nothing
            If Not Recipients.TryGetValue(r.CommRecId, Recipient) Then
                Recipients.Add(r.CommRecId, r)
            Else
                'combine with existing recipient
                Recipient.Add(r)
            End If
        Next
    End Sub
    Public Function TotalFeeTypeAmounts(ByVal EntryTypeId As Integer) As Double
        Dim Total As Double = 0
        For Each Recipient As BatchPaymentsSummary_Recipient In Recipients.Values
            If Recipient.FeeTypeAmounts.ContainsKey(EntryTypeId) Then
                Total += Recipient.FeeTypeAmounts(EntryTypeId).Amount
            End If
        Next
        Return Total
    End Function
    Public Property AgencyId() As Integer
        Get
            Return (_AgencyId)
        End Get
        Set(ByVal value As Integer)
            _AgencyId = value
        End Set
    End Property
    Public Property FeeTypes() As Dictionary(Of Integer, BatchPaymentsSummary_FeeType)
        Get
            Return _FeeTypes
        End Get
        Set(ByVal value As Dictionary(Of Integer, BatchPaymentsSummary_FeeType))
            _FeeTypes = value
        End Set
    End Property
    Public Property Name() As String
        Get
            Return _Name
        End Get
        Set(ByVal value As String)
            _Name = value
        End Set
    End Property
    Public Property Recipients() As Dictionary(Of Integer, BatchPaymentsSummary_Recipient)
        Get
            Return _Recipients
        End Get
        Set(ByVal value As Dictionary(Of Integer, BatchPaymentsSummary_Recipient))
            _Recipients = value
        End Set
    End Property
    Public Sub New()

    End Sub
End Class
Public Enum DateUnit
    Day = 1
    Week = 2
    Month = 3
    Year = 4
End Enum
Public Structure Receivable
    Dim RegisterId As Integer
    Dim ClientId As Integer
    Dim AccountNumber As String
    Dim HireDate As DateTime
    Dim CompanyName As String
    Dim MyCompanyName As String
    Dim FirstName As String
    Dim LastName As String
    Dim FeeCategory As String
    Dim LastDepositDate As Nullable(Of DateTime)
    Dim OriginalBalance As Single
    Dim TotalPayments As Single
    Dim RemainingBalance As Single
    Dim Rate As Single
    Dim RemainingReceivables As Single

End Structure
Public Structure Payment
    Dim CommPayId As Integer
    Dim RegisterPaymentId As Integer
    Dim RegisterId As Integer
    Dim ClientId As Integer
    Dim AccountNumber As String
    Dim HireDate As DateTime
    Dim AgencyName As String
    Dim FirstName As String
    Dim LastName As String
    Dim FeeCategory As String
    Dim SettlementNumber As String
    Dim OriginalBalance As Single
    Dim BeginningBalance As Single
    Dim PaymentAmount As Single
    Dim PaymentDate As DateTime
    Dim EndingBalance As Single
    Dim Rate As Single
    Dim Amount As Single
    Dim CommRecipName As String
End Structure
Public Structure ClearingAccountTransaction
    Dim RegisterId As Integer
    Dim AccountNumber As String
    Dim HireDate As DateTime
    Dim AgencyName As String
    Dim FirstName As String
    Dim LastName As String
    Dim FeeCategory As String
    Dim Amount As Single
End Structure
Public Class BatchTransfer
    Private _CommBatchTransferId As Integer
    Private _CommRecName As String
    Private _ParentCommRecName As String
    Private _CommRecId As Integer
    Private _ParentCommRecId As Nullable(Of Integer)
    Private _TotalAmount As Single
    Private _TransferAmount As Single
    Private _ACHTries As Integer
    Private _Level As Integer
    Private _IsLast As Boolean
    Private _CheckNumber As String
    Private _CheckDate As Nullable(Of DateTime)
    Private _Children As List(Of BatchTransfer)
    Private _Parent As BatchTransfer
    Private _BatchDate As DateTime
    Private _BatchId As Integer

    Public Property BatchId() As Integer
        Get
            Return _BatchId
        End Get
        Set(ByVal value As Integer)
            _BatchId = value
        End Set
    End Property

    Public Property BatchDate() As DateTime
        Get
            Return _BatchDate
        End Get
        Set(ByVal value As DateTime)
            _BatchDate = value
        End Set
    End Property

    Public Property CheckDate() As Nullable(Of DateTime)
        Get
            Return _CheckDate
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            _CheckDate = value
        End Set
    End Property
    Public Property Parent() As BatchTransfer
        Get
            Return _Parent
        End Get
        Set(ByVal value As BatchTransfer)
            _Parent = value
        End Set
    End Property
    Public ReadOnly Property Children() As List(Of BatchTransfer)
        Get
            If _Children Is Nothing Then
                _Children = New List(Of BatchTransfer)
            End If
            Return _Children
        End Get
    End Property
    Public Property IsLast() As Boolean
        Get
            Return _IsLast
        End Get
        Set(ByVal value As Boolean)
            _IsLast = value
        End Set
    End Property
    Public Property Level() As Integer
        Get
            Return _Level
        End Get
        Set(ByVal value As Integer)
            _Level = value
        End Set
    End Property
    Public Property CommRecId() As Integer
        Get
            Return _CommRecId
        End Get
        Set(ByVal value As Integer)
            _CommRecId = value
        End Set
    End Property
    Public Property ParentCommRecId() As Nullable(Of Integer)
        Get
            Return _ParentCommRecId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            _ParentCommRecId = value
        End Set
    End Property
    Public Property CommBatchTransferId() As Integer
        Get
            Return _CommBatchTransferId
        End Get
        Set(ByVal value As Integer)
            _CommBatchTransferId = value
        End Set
    End Property
    Public Property ACHTries() As Integer
        Get
            Return _ACHTries
        End Get
        Set(ByVal value As Integer)
            _ACHTries = value
        End Set
    End Property
    Public Property CommRecName() As String
        Get
            Return _CommRecName
        End Get
        Set(ByVal value As String)
            _CommRecName = value
        End Set
    End Property
    Public Property ParentCommRecName() As String
        Get
            Return _ParentCommRecName
        End Get
        Set(ByVal value As String)
            _ParentCommRecName = value
        End Set
    End Property
    Public Property CheckNumber() As String
        Get
            Return _CheckNumber
        End Get
        Set(ByVal value As String)
            _CheckNumber = value
        End Set
    End Property
    Public Property TotalAmount() As Single
        Get
            Return _TotalAmount
        End Get
        Set(ByVal value As Single)
            _TotalAmount = value
        End Set
    End Property
    Public Property TransferAmount() As Single
        Get
            Return _TransferAmount
        End Get
        Set(ByVal value As Single)
            _TransferAmount = value
        End Set
    End Property

End Class