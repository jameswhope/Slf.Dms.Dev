Option Explicit On

Public Class CommChargeback

#Region "Variables"

    Private _commchargebackid As Integer
    Private _commpayid As Nullable(Of Integer)
    Private _chargebackdate As DateTime
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

    ReadOnly Property CommChargebackID() As Integer
        Get
            Return _commchargebackid
        End Get
    End Property
    ReadOnly Property CommPayID() As Nullable(Of Integer)
        Get
            Return _commpayid
        End Get
    End Property
    ReadOnly Property ChargebackDate() As DateTime
        Get
            Return _chargebackdate
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

    Public Sub New(ByVal CommChargebackID As Integer, ByVal CommPayID As Nullable(Of Integer), _
        ByVal ChargebackDate As DateTime, ByVal RegisterPaymentID As Integer, ByVal CommStructID As Integer, _
        ByVal Percent As Double, ByVal Amount As Double, ByVal CommBatchID As Nullable(Of Integer), _
        ByVal CommScenID As Integer, ByVal CommRecID As Integer, ByVal ParentCommRecID As Integer, _
        ByVal CommStructOrder As Integer, ByVal CommRecTypeID As Integer, ByVal Display As String, _
        ByVal CommRecTypeName As String)

        _commchargebackid = CommChargebackID
        _commpayid = CommPayID
        _chargebackdate = ChargebackDate
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