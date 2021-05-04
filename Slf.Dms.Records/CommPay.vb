Option Explicit On

Public Class CommPay

#Region "Variables"

    Private _commpayid As Integer
    Private _registerpaymentid As Integer
    Private _commstructid As Integer
    Private _percent As Double
    Private _amount As Double
    Private _commbatchid As Nullable(Of Integer)

    Private _commscenid As Integer
    Private _commrecid As Integer
    Private _parentcommrecid As Integer
    Private _commstructorder As Integer
    Private _commrectypeid As Integer
    Private _display As String
    Private _commrectypename As String

#End Region

#Region "Properties"

    ReadOnly Property CommPayID() As Integer
        Get
            Return _commpayid
        End Get
    End Property
    ReadOnly Property RegisterPaymentID() As Integer
        Get
            Return _registerpaymentid
        End Get
    End Property
    ReadOnly Property CommStructID() As Integer
        Get
            Return _commstructid
        End Get
    End Property
    ReadOnly Property Percent() As Double
        Get
            Return _percent
        End Get
    End Property
    ReadOnly Property Amount() As Double
        Get
            Return _amount
        End Get
    End Property
    ReadOnly Property CommBatchID() As Nullable(Of Integer)
        Get
            Return _commbatchid
        End Get
    End Property
    ReadOnly Property CommScenID() As Integer
        Get
            Return _commscenid
        End Get
    End Property
    ReadOnly Property CommRecID() As Integer
        Get
            Return _commrecid
        End Get
    End Property
    ReadOnly Property ParentCommRecID() As Integer
        Get
            Return _parentcommrecid
        End Get
    End Property
    ReadOnly Property CommStructOrder() As Integer
        Get
            Return _commstructorder
        End Get
    End Property
    ReadOnly Property CommRecTypeID() As Integer
        Get
            Return _commrectypeid
        End Get
    End Property
    ReadOnly Property Display() As String
        Get
            Return _display
        End Get
    End Property
    ReadOnly Property CommRecTypeName() As String
        Get
            Return _commrectypename
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal CommPayID As Integer, ByVal RegisterPaymentID As Integer, _
        ByVal CommStructID As Integer, ByVal Percent As Double, ByVal Amount As Double, _
        ByVal CommBatchID As Nullable(Of Integer), ByVal CommScenID As Integer, ByVal CommRecID As Integer, _
        ByVal ParentCommRecID As Integer, ByVal CommStructOrder As Integer, ByVal CommRecTypeID As Integer, _
        ByVal Display As String, ByVal CommRecTypeName As String)

        _commpayid = CommPayID
        _registerpaymentid = RegisterPaymentID
        _commstructid = CommStructID
        _percent = Percent
        _amount = Amount
        _commbatchid = CommBatchID

        _commscenid = CommScenID
        _commrecid = CommRecID
        _parentcommrecid = ParentCommRecID
        _commstructorder = CommStructOrder
        _commrectypeid = CommRecTypeID
        _display = Display
        _commrectypename = CommRecTypeName

    End Sub

#End Region

End Class