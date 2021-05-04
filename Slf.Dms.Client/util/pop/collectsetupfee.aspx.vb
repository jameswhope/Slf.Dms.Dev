Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Collections.Generic

Partial Class util_pop_collectsetupfee
    Inherits System.Web.UI.Page

#Region "Variables"

    Public Shadows ClientID As Integer
    Private InsertValues As String
    Private UpdateValues As String

#End Region

#Region "Class ModifiedAccountFee"

    Public Class ModifiedAccountFee

#Region "Variables"

        Private _id As Integer
        Private _type As String
        Private _name As String
        Private _action As String
        Private _currentamount As Double
        Private _amount As Double
        Private _percentage As Double
        Private _currentfeeamount As Double
        Private _adjustfeeamount As Double
        Private _newfeeamount As Double
        Private _verified As Boolean

#End Region

#Region "Properties"

        Property ID() As Integer
            Get
                Return _id
            End Get
            Set(ByVal value As Integer)
                _id = value
            End Set
        End Property
        Property Type() As String
            Get
                Return _type
            End Get
            Set(ByVal value As String)
                _type = value
            End Set
        End Property
        Property Name() As String
            Get
                Return _name
            End Get
            Set(ByVal value As String)
                _name = value
            End Set
        End Property
        Property Action() As String
            Get
                Return _action
            End Get
            Set(ByVal value As String)
                _action = value
            End Set
        End Property
        Property CurrentAmount() As Double
            Get
                Return _currentamount
            End Get
            Set(ByVal value As Double)
                _currentamount = value
            End Set
        End Property
        Property Amount() As Double
            Get
                Return _amount
            End Get
            Set(ByVal value As Double)
                _amount = value
            End Set
        End Property
        Property Percentage() As Double
            Get
                Return _percentage
            End Get
            Set(ByVal value As Double)
                _percentage = value
            End Set
        End Property
        Property CurrentFeeAmount() As Double
            Get
                Return _currentfeeamount
            End Get
            Set(ByVal value As Double)
                _currentfeeamount = value
            End Set
        End Property
        Property AdjustFeeAmount() As Double
            Get
                Return _adjustfeeamount
            End Get
            Set(ByVal value As Double)
                _adjustfeeamount = value
            End Set
        End Property
        Property NewFeeAmount() As Double
            Get
                Return _newfeeamount
            End Get
            Set(ByVal value As Double)
                _newfeeamount = value
            End Set
        End Property
        Property Verified() As Boolean
            Get
                Return _verified
            End Get
            Set(ByVal value As Boolean)
                _verified = value
            End Set
        End Property

#End Region

#Region "Constructor"

        Public Sub New()

        End Sub

#End Region

    End Class

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ClientID = StringHelper.ParseInt(Request.QueryString("id"))

        InsertValues = Request.QueryString("i")
        UpdateValues = Request.QueryString("u")

        If Not IsPostBack Then

            chkCollectInsert.Checked = True
            chkCollectUpdate.Checked = True

            LoadRecord()

        End If

    End Sub
    Private Sub LoadRecord()

        Dim NumRetainers As Integer = DataHelper.FieldCount("tblRegister", "RegisterID", "EntryTypeID = 2 AND ClientID = " & ClientID)
        Dim SumRetainers As Double = Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID = 2 AND ClientID = " & ClientID))

        LoadInsertsAndUpdates(InsertValues, UpdateValues, SumRetainers)

        If NumRetainers = 0 Then

            lblInfo.Text = "No retainer fees have ever been collected for this client."

        Else

            If NumRetainers > 1 Then
                lblInfo.Text = NumRetainers & " retainer fees have already been collected for this client in the amount of " _
                    & Math.Abs(SumRetainers).ToString("c") & "."
            Else
                lblInfo.Text = "1 retainer fee has already been collected for this client in the amount of " _
                    & Math.Abs(SumRetainers).ToString("c") & "."
            End If

        End If

        lblCurrentTotal.Text = SumRetainers.ToString("#,##0.00")

    End Sub
    Private Sub LoadInsertsAndUpdates(ByVal InsertValues As String, ByVal UpdateValues As String, ByVal SumRetainers As Double)

        Dim maf As ModifiedAccountFee = Nothing
        Dim mafs As New Dictionary(Of String, ModifiedAccountFee)

        'add inserts
        If chkCollectInsert.Checked Then
            If InsertValues.Length > 0 Then

                Dim Inserts() As String = Regex.Split(InsertValues, "<-\$\$->")

                For Each Insert As String In Inserts

                    Dim Fields() As String = Insert.Split(":")

                    Dim KeyID As Integer = DataHelper.Nz_int(Fields(0))
                    Dim Field As String = Fields(1)
                    Dim Value As String = Insert.Substring(KeyID.ToString().Length + Field.Length + 2)

                    If Not mafs.TryGetValue("insert" & KeyID, maf) Then

                        maf = New ModifiedAccountFee()

                        maf.ID = KeyID
                        maf.Type = "NEW"
                        maf.Action = "Collect new fee"

                        mafs.Add("insert" & KeyID, maf)

                    End If

                    Select Case Field.ToLower()
                        Case "amount"
                            maf.Amount = StringHelper.ParseDouble(Value)
                        Case "creditorname"
                            maf.Name = Value
                    End Select

                Next

            End If
        End If

        'add updates
        If chkCollectUpdate.Checked Then
            If UpdateValues.Length > 0 Then

                Dim Updates() As String = Regex.Split(UpdateValues, "<-\$\$->")

                For Each Update As String In Updates

                    Dim Fields() As String = Update.Split(":")

                    If Fields(0) = "*" Then
                        'Hotfix: Not sure why the new row is trying to get updated. Cannot re-produce
                        'locally.
                        Exit For
                    Else
                        Dim AccountID As Integer = DataHelper.Nz_int(Fields(0))
                        Dim Field As String = Fields(1)
                        Dim Value As String = Update.Substring(AccountID.ToString().Length + Field.Length + 2)

                        If Not mafs.TryGetValue("update" & AccountID, maf) Then

                            maf = New ModifiedAccountFee()

                            maf.ID = AccountID
                            maf.Type = "UPDATED"

                            mafs.Add("update" & AccountID, maf)

                        End If

                        Select Case Field.ToLower()
                            Case "amount"
                                maf.Amount = StringHelper.ParseDouble(Value)
                            Case "creditorname"
                                maf.Name = Value
                        End Select
                    End If
                Next

            End If
        End If

        Update(mafs, SumRetainers)

        rpModifiedAccountFees.DataSource = mafs.Values
        rpModifiedAccountFees.DataBind()

    End Sub
    Private Sub Update(ByVal mafs As Dictionary(Of String, ModifiedAccountFee), ByVal SumRetainers As Double)

        Dim TotalAdjustedAmount As Double

        For Each maf As ModifiedAccountFee In mafs.Values

            'try getting client's default retainer fee percentage
            Dim RetainerFeePercentage As Double = StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " & ClientID))

            If maf.Type = "NEW" Then

                maf.Percentage = RetainerFeePercentage
                maf.NewFeeAmount = maf.Amount * RetainerFeePercentage
                maf.AdjustFeeAmount = maf.NewFeeAmount

            Else

                Dim AccountID As Integer = maf.ID
                Dim Verified As String = Nothing
                Dim CurrentAmount As Double = 0.0
                Dim CurrentPercentage As Double = 0.0
                Dim CurrentCreditorInstanceID As Integer = 0
                Dim CurrentFeeAmount As Double = Math.Abs(AccountHelper.GetSumRetainerFees(AccountID))

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand

                    cmd.CommandText = "SELECT * FROM tblAccount WHERE AccountID = " & AccountID

                    Using cn As IDbConnection = cmd.Connection

                        cn.Open()

                        Using rd As IDataReader = cmd.ExecuteReader()

                            If rd.Read Then

                                Verified = DatabaseHelper.Peel_datestring(rd, "Verified")
                                CurrentAmount = Math.Abs(DatabaseHelper.Peel_double(rd, "CurrentAmount"))
                                CurrentPercentage = Math.Abs(DatabaseHelper.Peel_double(rd, "SetupFeePercentage"))
                                CurrentCreditorInstanceID = DatabaseHelper.Peel_int(rd, "CurrentCreditorInstanceID")

                            End If
                        End Using
                    End Using
                End Using

                Dim CreditorID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblCreditorInstance", "CreditorID", "CreditorInstanceID = " & CurrentCreditorInstanceID))

                maf.Name = DataHelper.FieldLookup("tblCreditor", "Name", "CreditorID = " & CreditorID)

                If Verified.Length > 0 Then

                    maf.Verified = True
                    maf.Action = "Verification has been locked&nbsp;<img src=""" & ResolveUrl("~/images/16x16_lock.png") & """ border=""0"" align=""absmiddle""/>"

                Else

                    If CurrentFeeAmount > 0 Then
                        maf.Action = "Adjust current fee"
                    Else
                        maf.Action = "Collect new fee"
                    End If

                    maf.CurrentAmount = CurrentAmount
                    maf.CurrentFeeAmount = CurrentFeeAmount
                    maf.Percentage = CurrentPercentage
                    maf.NewFeeAmount = Math.Abs(maf.Amount) * CurrentPercentage
                    maf.AdjustFeeAmount = (maf.NewFeeAmount - maf.CurrentFeeAmount)

                End If
            End If

            TotalAdjustedAmount += maf.AdjustFeeAmount

        Next

        lblNew.Text = TotalAdjustedAmount.ToString("#,##0.00")
        lblNewTotal.Text = (TotalAdjustedAmount + SumRetainers).ToString("#,##0.00")

    End Sub
    Protected Sub rpModifiedAccountFees_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpModifiedAccountFees.ItemDataBound

        If e.Item.DataItem.Verified = True Then

            Dim tdAction As HtmlTableCell = e.Item.FindControl("tdAction")
            Dim tdCurrent As HtmlTableCell = e.Item.FindControl("tdCurrent")
            Dim tdNew As HtmlTableCell = e.Item.FindControl("tdNew")
            Dim tdAdjusted As HtmlTableCell = e.Item.FindControl("tdAdjusted")

            tdAction.ColSpan = 4
            tdAction.Align = "center"
            tdAction.Style("color") = "red"

            tdCurrent.Visible = False
            tdNew.Visible = False
            tdAdjusted.Visible = False

        End If

    End Sub
    Protected Sub chkCollectInsert_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkCollectInsert.CheckedChanged
        LoadRecord()
    End Sub
    Protected Sub chkCollectUpdate_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkCollectUpdate.CheckedChanged
        LoadRecord()
    End Sub
End Class