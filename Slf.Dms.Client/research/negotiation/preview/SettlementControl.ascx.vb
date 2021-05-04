Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class research_negotiation_preview_SettlementControl
    Inherits System.Web.UI.UserControl

#Region "Declares"
    Dim sqlInsert As New StringBuilder
    Private Settlement As SettlementOfferInfo
    Public Event PostBack(ByVal sender As Object, ByVal e As EventArgs)

#Region "Properties"
    Private _CreditorAccountID As String
    Public Property SettlementCreditorAccountID() As String
        Get
            _CreditorAccountID = ViewState("_CreditorAccountID")
            Return _CreditorAccountID
        End Get
        Set(ByVal value As String)
            ViewState("_CreditorAccountID") = value
            _CreditorAccountID = value
        End Set
    End Property
    Private _ClientID As String
    Public Property SettlementClientID() As String
        Get
            _ClientID = ViewState("_ClientID")
            Return _ClientID
        End Get
        Set(ByVal value As String)
            ViewState("_ClientID") = value
            _ClientID = value
        End Set
    End Property
    Private _userid As String
    Public Property SettlementUserID() As String
        Get
            _userid = ViewState("_userid")
            Return _userid
        End Get
        Set(ByVal value As String)
            ViewState("_userid") = value
            _userid = value
        End Set
    End Property
#End Region
    <Serializable()> Public Structure SettlementOfferInfo
        Public Settlement_ID As Integer
        Public Settlement_AmountPercentage As Integer
        Public Settlement_Amount As Double
        Public Settlement_AmountAvailable As Double
        Public Settlement_AmountBeingSent As Double
        Public Settlement_AmountStillOwed As Double
        Public Settlement_DueDate As String
        Public Settlement_Fee As Double
        Public Settlement_Savings As Double
        Public Settlement_Cost As Double
        Public Settlement_FeeAvailAmt As Double
        Public Settlement_FeePaidAmt As Double
        Public Settlement_FeeOwedAmt As Double
        Public Settlement_Notes As String
        Public Settlement_MediatorID As Integer
        Public Settlement_Direction As String

        Public Creditor_AccountNumber As String
        Public Creditor_AccountID As String
        Public Creditor_CurrentName As String
        Public Creditor_OriginalName As String
        Public Creditor_AccountBalance As Double
        Public Creditor_ReferenceNumber As String

        Public Client_ID As String
        Public Client_Name As String
        Public Client_SSN As String
        Public Client_CoAppName As String
        Public Client_CoAppSSN

        Public Client_RegisterBalance As Double
        Public Client_FrozenBalance As Double

        Public Client_SetupFee As Double
        Public Client_SettlementFeePercentage As Double
        Public Client_OvernightDeliveryFee As Double
        Public Sub New(ByVal AccountID As String, ByVal ClientID As String)
            LoadCreditor_ClientInfo(AccountID, ClientID)

            'LoadData()
        End Sub
        Public Sub New(ByVal SettlementID As Integer)
            Me.Settlement_ID = SettlementID

            Dim sqlSelect As String = "Select cast(CreditorAccountID as varchar) + ':' + cast(ClientID as varchar) from tblSettlements where settlementid = " & SettlementID
            Dim sqlCMD As New SqlCommand(sqlSelect, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
            sqlCMD.Connection.Open()
            Dim strPair As String() = sqlCMD.ExecuteScalar.ToString.Split(":")

            LoadCreditor_ClientInfo(strPair(0), strPair(1))
            LoadSettlementData(SettlementID)

        End Sub
        Private Sub LoadCreditor_ClientInfo(ByVal sCreditorAcctID As String, ByVal sCientID As String)

            Me.Creditor_AccountID = sCreditorAcctID
            Me.Client_ID = sCientID


            Dim dtData As Data.DataTable = Nothing
            Dim sqlText As String = "stp_GetCreditorInstancesForAccount " & Me.Creditor_AccountID

            Try

                Using saTemp = New SqlDataAdapter(sqlText, System.Configuration.ConfigurationManager.AppSettings("Connectionstring").ToString)

                    'creditor data
                    dtData = New Data.DataTable
                    saTemp.Fill(dtData)

                    If dtData.Rows.Count > 0 Then
                        For Each dRow As Data.DataRow In dtData.Rows
                            If dRow("iscurrent") = True Then
                                Me.Creditor_CurrentName = dRow("creditorname").ToString
                                Me.Creditor_AccountNumber = dRow("AccountNumber").ToString
                                Me.Creditor_AccountBalance = dRow("CurrentAmount").ToString
                                Me.Creditor_OriginalName = dRow("forcreditorname").ToString
                                Me.Creditor_ReferenceNumber = dRow("ReferenceNumber").ToString
                            End If
                        Next
                    End If

                    'client data
                    saTemp.SelectCommand.CommandText = "stp_GetPersonsForClient " & Me.Client_ID
                    dtData = New Data.DataTable
                    saTemp.Fill(dtData)

                    If dtData.Rows.Count >= 1 Then
                        Dim dr As Data.DataRow = dtData.Rows(0)
                        Me.Client_Name = dr("FirstName").ToString & Space(1) & dr("LastName").ToString
                        Me.Client_SSN = FormatSSN(dr("SSN").ToString)
                        If dtData.Rows.Count > 1 Then
                            dtData.Rows.RemoveAt(0)
                            For Each dRow As Data.DataRow In dtData.Rows
                                Me.Client_CoAppName += dRow("FirstName").ToString & Space(1) & dRow("LastName").ToString & ", "
                            Next
                            Me.Client_CoAppName = Me.Client_CoAppName.Trim
                            Me.Client_CoAppName = Me.Client_CoAppName.Substring(0, Me.Client_CoAppName.Length - 1)
                        End If
                    End If


                    saTemp.SelectCommand.CommandText = "stp_GetStatsOverviewForClient " & Me.Client_ID
                    dtData = New Data.DataTable
                    saTemp.Fill(dtData)

                    If dtData.Rows.Count > 0 Then
                        Dim dr As Data.DataRow = dtData.Rows(0)
                        Me.Client_RegisterBalance = dr("registerbalance").ToString
                        Me.Client_FrozenBalance = dr("frozenbalance").ToString
                    End If

                    saTemp.SelectCommand.CommandText = "get_ClientFeeInfo " & Me.Client_ID
                    dtData = New Data.DataTable
                    saTemp.Fill(dtData)

                    If dtData.Rows.Count > 0 Then
                        Dim dr As Data.DataRow = dtData.Rows(0)
                        Me.Client_SettlementFeePercentage = dr("SettlementFeePercentage").ToString
                        Me.Client_OvernightDeliveryFee = dr("OvernightDeliveryFee").ToString
                    End If

                    saTemp.SelectCommand.CommandText = "SELECT IDENT_CURRENT('tblsettlements') as 'SettlementID'"
                    dtData = New Data.DataTable
                    saTemp.Fill(dtData)

                    If dtData.Rows.Count > 0 Then
                        Me.Settlement_ID = CInt(dtData.Rows(0).Item("SettlementID")) + 1
                    End If

                End Using
            Catch ex As Exception
            Finally
                dtData.Dispose()
            End Try

        End Sub
        Private Sub LoadSettlementData(ByVal settlementID As String)

            Dim dtData As Data.DataTable = Nothing
            Dim sqlText As String = "stp_GetSettlement " & settlementID

            Try

                Using saTemp = New SqlDataAdapter(sqlText, System.Configuration.ConfigurationManager.AppSettings("Connectionstring").ToString)

                    'creditor data
                    dtData = New Data.DataTable
                    saTemp.Fill(dtData)

                    For Each dRow As Data.DataRow In dtData.Rows
                        Me.Settlement_ID = dRow("SettlementID").ToString
                        Me.Settlement_AmountPercentage = dRow("SettlementPercent").ToString
                        Me.Settlement_Amount = Math.Round(CDbl(dRow("SettlementAmount").ToString), 2)
                        Me.Settlement_AmountAvailable = dRow("SettlementAmtAvailable").ToString
                        Me.Settlement_AmountBeingSent = dRow("SettlementAmtBeingSent").ToString
                        Me.Settlement_AmountStillOwed = dRow("SettlementAmtStillOwed").ToString
                        Me.Settlement_Savings = dRow("SettlementSavings").ToString
                        Me.Settlement_Fee = dRow("SettlementFee").ToString
                        Me.Settlement_Cost = dRow("SettlementCost").ToString
                        Me.Settlement_FeeAvailAmt = dRow("SettlementFeeAmtAvailable").ToString
                        Me.Settlement_FeeOwedAmt = dRow("SettlementFeeAmtStillOwed").ToString
                        Me.Settlement_FeePaidAmt = dRow("SettlementFeeAmtBeingPaid").ToString
                        Me.Settlement_DueDate = dRow("SettlementDueDate").ToString
                        Me.Settlement_Direction = dRow("OfferDirection").ToString

                    Next

                End Using

            Catch ex As Exception

            Finally
                dtData.Dispose()
            End Try
        End Sub
        Private Function FormatSSN(ByVal SSN As String) As String
            Dim strTemp As String
            strTemp = SSN.Substring(0, 3) & "-" & SSN.Substring(3, 2) & "-" & SSN.Substring(5, 4)
            Return strTemp
        End Function
    End Structure
#End Region
#Region "Events"
    Protected Sub GridView1_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        Me.GridView1.PageIndex = e.NewPageIndex
        BindGrid()
        RaiseEvent PostBack(sender, e)
    End Sub
    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand
        Select Case e.CommandName.ToLower
            Case "select"
                Dim settID As String = e.CommandArgument

                Settlement = New SettlementOfferInfo(settID)

                With Settlement

                    Me.lblSettlementNum.Text = .Settlement_ID

                    'client info
                    Me.lblClientSSN.Text = .Client_SSN
                    Me.lblClientCoAppSSN.Text = .Client_CoAppSSN
                    Me.lblClientName.Text = .Client_Name
                    Me.lblClientCoAppName.Text = .Client_CoAppName


                    'creditor info
                    Me.lblOriginalCreditor.Text = .Creditor_OriginalName
                    Me.lblCreditorAcctNum.Text = .Creditor_AccountNumber
                    Me.lblCurrentCreditor.Text = .Creditor_CurrentName
                    Me.lblCreditorRefNum.Text = .Creditor_ReferenceNumber

                    'balance info
                    'Me.lblBankBal.Text = Math.Round("0.00", 2)
                    Me.lblAsOfDate.Text = Format(Now, "MM/dd/yyyy") & " : "
                    Me.lblRegisterBal.Text = FormatCurrency(.Client_RegisterBalance, 2)
                    Me.lblFrozenAmt.Text = FormatCurrency(.Client_FrozenBalance, 2)

                    'settlement info
                    'acct being settled
                    Me.lblAvailRegisterBal.Text = Math.Round(.Client_RegisterBalance, 2)
                    Me.txtCurrentBalance.Text = Math.Round(.Creditor_AccountBalance, 2)

                    Me.txtSettlementPercent.Text = .Settlement_AmountPercentage
                    Me.txtSettlementAmt.Text = Math.Round(.Settlement_Amount, 2)

                    Me.lblAmtAvailable.Text = Math.Round(.Settlement_AmountAvailable, 2)
                    Me.lblAmtBeingSent.Text = Math.Round(.Settlement_AmountBeingSent, 2)
                    Me.lblAmtStillOwed.Text = Math.Round(.Settlement_AmountStillOwed, 2)
                    Me.txtDueDate.Text = .Settlement_DueDate

                    'settlement fees
                    Me.lblSettlementSavings.Text = Math.Round(.Settlement_Savings, 2)
                    Me.lblSettlementFeePercentage.Text = .Client_SettlementFeePercentage * 100

                    Me.lblSettlementFee.Text = Math.Round(.Settlement_Fee, 2)
                    Me.lblOvernightDeliveryCost.Text = Math.Round(.Client_OvernightDeliveryFee, 2)
                    Me.lblSettlementCost.Text = Math.Round(.Settlement_Cost, 2)

                    Me.lblSettlementFee_AmtAvailable.Text = Math.Round(.Settlement_FeeAvailAmt, 2)
                    Me.lblSettlementFee_AmtStillOwed.Text = Math.Round(.Settlement_FeeOwedAmt, 2)
                    Me.lblSettlementFee_AmtBeingPaid.Text = Math.Round(.Settlement_FeePaidAmt, 2)

                    Me.txtDueDate.Text = Format(DateAdd(DateInterval.Day, 7, Now), "MM/dd/yyyy")

                    Session("SettlementObj") = Settlement

                    BindGrid()

                End With


        End Select
    End Sub
    Protected Sub GridView1_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles GridView1.Sorting

        BindGrid()
        RaiseEvent PostBack(sender, e)

    End Sub
    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Try
            Settlement = Session("SettlementObj")

            Dim sqlUpdate As String = "Update tblSettlements set status = 'C' "
            sqlUpdate += "OUTPUT Inserted.SettlementRegisterHoldID "
            sqlUpdate += "where Settlementid = " & Me.lblSettlementNum.Text

            Dim sCMD As New SqlCommand(sqlUpdate, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
            sCMD.Connection.Open()

            Dim intRegid As Object = sCMD.ExecuteScalar

            If intRegid.Equals(DBNull.Value) = False Then
                Dim sqlVoid As String = "update tblregister set void = '" & Now & "', voidby = " & Me.SettlementUserID
                sqlVoid += " Where registerid = " & intRegid

                sCMD.CommandText = sqlVoid
                sCMD.ExecuteNonQuery()

            End If
            tdError.Style("display") = ""
            tdError.InnerText = " Settlement Cancelled!"
            InsertNote("C")

            sCMD.Dispose()
            sCMD = Nothing

            BindGrid()

        Catch x As InvalidCastException

        Catch ex As Exception

        End Try

    End Sub
    Protected Sub lnkHold_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkHold.Click

        Settlement = Session("SettlementObj")

        If bAreFundsAvailable() = False Then
            tdError.Style("display") = ""
            tdError.InnerText = "Settlement Hold is more than funds available!"
            Exit Sub
        Else
            tdError.Style("display") = "none"
            tdError.InnerText = ""
            InsertOffer("H")

            Me.lblFrozenAmt.Text = FormatCurrency(Me.txtSettlementAmt.Text, 2)
            BindGrid()

        End If

    End Sub
    Protected Sub imgAccept_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        'accept
        Settlement = Session("SettlementObj")
        If bAreFundsAvailable() = False Then
            tdError.Style("display") = ""
            tdError.InnerText = "Settlement Hold is more than funds available!"
            Exit Sub
        Else
            tdError.Style("display") = "none"
            tdError.InnerText = ""
            InsertOffer("A")
            Me.lblFrozenAmt.Text = FormatCurrency(Me.txtSettlementAmt.Text, 2)
            BindGrid()
        End If
    End Sub
    Protected Sub imgReject_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        'reject
        Settlement = Session("SettlementObj")
        InsertOffer("R")
        BindGrid()
    End Sub

#End Region
#Region "subs/funcs"
    Private Function bAreFundsAvailable() As Boolean
        Dim sqlselect As String = "select fundsavailable from vwNegotiationDistributionSource where clientid = @clientid and accountid = @accountid"
        sqlselect = sqlselect.Replace("@clientid", Settlement.Client_ID).Replace("@accountid", Settlement.Creditor_AccountID)


        Dim sCMD As New SqlCommand(sqlselect, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
        sCMD.Connection.Open()

        Dim dFunds As Double = sCMD.ExecuteScalar
        sCMD.Dispose()
        sCMD = Nothing

        If System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency) > dFunds Then
            Return False
        Else
            Return True
        End If
    End Function
    Public Sub InsertNote(ByVal OfferStatus As String)

        Dim strNote As String = ""
        Select Case OfferStatus
            Case "A"
                strNote = "Settlement Accepted.  "
            Case "R"
                strNote = "Settlement Rejected.  "
            Case "H"
                strNote = "Settlement Hold.  "
            Case "C"
                strNote = "Settlement Cancel.  "
        End Select

        Dim intNote As Integer = NoteHelper.InsertNote(strNote, Settlement.Settlement_MediatorID, Settlement.Client_ID)
        NoteHelper.RelateNote(intNote, 2, Settlement.Creditor_AccountID)

    End Sub
    Public Sub InsertOffer(ByVal OfferStatus As String)
        Dim sqlInsert As String = ""
        Dim sqlCmd As SqlCommand
        Dim regID As String = ""

        Select Case OfferStatus
            Case "H", "A"

                sqlInsert = "INSERT INTO tblRegister(ClientId,AccountID,TransactionDate,Description,Amount"
                sqlInsert += ",Balance,EntryTypeId,IsFullyPaid,Hold,HoldBy,MediatorID,Created,CreatedBy,SDABalance) "
                sqlInsert += " OUTPUT Inserted.RegisterID "
                sqlInsert += "VALUES([@ClientId],[@AccountID],'[@TransactionDate]','[@Description]',[@Amount],[@Balance]"
                sqlInsert += ",[@EntryTypeId],'[@IsFullyPaid]','[@Hold]',[@HoldBy],[@MediatorID],'[@Created]',[@CreatedBy],[@SDABalance])"

                sqlInsert = sqlInsert.Replace("[@ClientId]", Settlement.Client_ID)
                sqlInsert = sqlInsert.Replace("[@AccountID]", Settlement.Creditor_AccountID)
                sqlInsert = sqlInsert.Replace("[@TransactionDate]", Now)
                sqlInsert = sqlInsert.Replace("[@Description]", DBNull.Value.ToString)
                sqlInsert = sqlInsert.Replace("[@Amount]", System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency))
                sqlInsert = sqlInsert.Replace("[@Balance]", Me.txtCurrentBalance.Text)
                sqlInsert = sqlInsert.Replace("[@EntryTypeId]", "43")
                sqlInsert = sqlInsert.Replace("[@IsFullyPaid]", IIf(CDbl(Me.txtCurrentBalance.Text) - CDbl(System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency)) <= 0, True, False))
                sqlInsert = sqlInsert.Replace("[@Hold]", Now)
                sqlInsert = sqlInsert.Replace("[@HoldBy]", Settlement.Settlement_MediatorID)
                sqlInsert = sqlInsert.Replace("[@MediatorID]", Settlement.Settlement_MediatorID)
                sqlInsert = sqlInsert.Replace("[@Created]", Now)
                sqlInsert = sqlInsert.Replace("[@CreatedBy]", Settlement.Settlement_MediatorID)
                sqlInsert = sqlInsert.Replace("[@SDABalance]", System.Double.Parse(Settlement.Client_RegisterBalance))

                sqlCmd = New SqlCommand(sqlInsert, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
                sqlCmd.Connection.Open()
                regID = sqlCmd.ExecuteScalar

        End Select

        sqlInsert = "INSERT INTO tblSettlements "
        sqlInsert += "(CreditorAccountID,ClientID,RegisterBalance,FrozenAmount,CreditorAccountBalance,SettlementPercent,SettlementAmount"
        sqlInsert += ",SettlementAmtAvailable,SettlementAmtBeingSent,SettlementAmtStillOwed,SettlementDueDate,SettlementSavings,SettlementFee,OvernightDeliveryAmount,SettlementCost"
        sqlInsert += ",SettlementFeeAmtAvailable,SettlementFeeAmtBeingPaid,SettlementFeeAmtStillOwed,SettlementNotes,Status,CreatedBy,LastModifiedBy,SettlementRegisterHoldID, OfferDirection)"
        sqlInsert += "VALUES "
        sqlInsert += "([@CreditorAccountID],[@ClientID],[@RegisterBalance],[@FrozenAmount],[@CreditorAccountBalance"
        sqlInsert += "],[@SettlementPercent],[@SettlementAmount],[@SettlementAmtAvailable],[@SettlementAmtBeingSent],[@SettlementAmtSillOwed"
        sqlInsert += "],'[@SettlementDueDate]',[@SettlementSavings],[@SettlementFee],[@OvernightDeliveryAmount],[@SettlementCost],[@SettlementFeeAmtAvailable"
        sqlInsert += "],[@SettlementAmtBeingPaid],[@SettlementAmtStillOwed],'[@SettlementNotes]','[@Status]',[@CreatedBy],[@LastModifiedBy],[@SettlementRegisterHoldID], '[@OfferDirection]')"

        sqlInsert = sqlInsert.Replace("[@CreditorAccountID]", Settlement.Creditor_AccountID)
        sqlInsert = sqlInsert.Replace("[@ClientID]", Settlement.Client_ID)
        sqlInsert = sqlInsert.Replace("[@RegisterBalance]", System.Double.Parse(Settlement.Client_RegisterBalance))
        sqlInsert = sqlInsert.Replace("[@FrozenAmount]", System.Double.Parse(Settlement.Client_FrozenBalance))
        sqlInsert = sqlInsert.Replace("[@CreditorAccountBalance]", Me.txtCurrentBalance.Text)
        sqlInsert = sqlInsert.Replace("[@SettlementPercent]", Math.Round(CDbl(Me.txtSettlementPercent.Text), 2))
        sqlInsert = sqlInsert.Replace("[@SettlementAmount]", System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementAmtAvailable]", System.Double.Parse(Me.lblAmtAvailable.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementAmtBeingSent]", System.Double.Parse(Me.lblAmtBeingSent.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementAmtSillOwed]", System.Double.Parse(Me.lblAmtStillOwed.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementDueDate]", Me.txtDueDate.Text)
        sqlInsert = sqlInsert.Replace("[@SettlementSavings]", System.Double.Parse(Me.lblSettlementSavings.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementFee]", System.Double.Parse(Me.lblSettlementFee.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@OvernightDeliveryAmount]", System.Double.Parse(Settlement.Client_OvernightDeliveryFee, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementCost]", System.Double.Parse(Me.lblSettlementCost.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementFeeAmtAvailable]", System.Double.Parse(Me.lblSettlementFee_AmtAvailable.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementAmtBeingPaid]", System.Double.Parse(Me.lblSettlementFee_AmtBeingPaid.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementAmtStillOwed]", System.Double.Parse(Me.lblSettlementFee_AmtStillOwed.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementNotes]", "")
        sqlInsert = sqlInsert.Replace("[@Status]", OfferStatus)
        sqlInsert = sqlInsert.Replace("[@CreatedBy]", Settlement.Settlement_MediatorID)
        sqlInsert = sqlInsert.Replace("[@LastModifiedBy]", Settlement.Settlement_MediatorID)
        If regID.ToString = "" Then
            sqlInsert = sqlInsert.Replace("[@SettlementRegisterHoldID]", "null")
        Else
            sqlInsert = sqlInsert.Replace("[@SettlementRegisterHoldID]", regID)
        End If
        sqlInsert = sqlInsert.Replace("[@OfferDirection]", Me.radDirection.SelectedValue)

        sqlCmd = New SqlCommand(sqlInsert, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
        sqlCmd.CommandText = sqlInsert
        If sqlCmd.Connection.State = Data.ConnectionState.Closed Then sqlCmd.Connection.Open()
        sqlCmd.ExecuteNonQuery()

        InsertNote(OfferStatus)

      
        sqlCmd.Dispose()
        sqlCmd = Nothing

    End Sub
    Public Sub LoadSettlementInfo()
        Settlement = New SettlementOfferInfo(Me._CreditorAccountID, Me._ClientID)

        With Settlement
            .Settlement_MediatorID = _userid
            .Client_ID = Me._ClientID
            .Creditor_AccountID = Me._CreditorAccountID

            Me.lblSettlementNum.Text = .Settlement_ID

            'client info
            Me.lblClientSSN.Text = .Client_SSN
            Me.lblClientCoAppSSN.Text = .Client_CoAppSSN
            Me.lblClientName.Text = .Client_Name
            Me.lblClientCoAppName.Text = .Client_CoAppName


            'creditor info
            Me.lblOriginalCreditor.Text = .Creditor_OriginalName
            Me.lblCreditorAcctNum.Text = .Creditor_AccountNumber
            Me.lblCurrentCreditor.Text = .Creditor_CurrentName
            Me.lblCreditorRefNum.Text = .Creditor_ReferenceNumber

            'balance info
            'Me.lblBankBal.Text = Math.Round("0.00", 2)
            Me.lblAsOfDate.Text = Format(Now, "MM/dd/yyyy") & " : "
            Me.lblRegisterBal.Text = FormatCurrency(.Client_RegisterBalance, 2)
            Me.lblFrozenAmt.Text = FormatCurrency(.Client_FrozenBalance, 2)

            'settlement info
            'acct being settled
            Me.lblAvailRegisterBal.Text = Math.Round(.Client_RegisterBalance, 2)
            Me.txtCurrentBalance.Text = .Creditor_AccountBalance

            Me.txtSettlementPercent.Text = .Settlement_AmountPercentage
            Me.txtSettlementAmt.Text = Math.Round(.Settlement_Amount, 2)

            Me.lblAmtAvailable.Text = Math.Round(.Settlement_AmountAvailable, 2)
            Me.lblAmtBeingSent.Text = Math.Round(.Settlement_AmountBeingSent, 2)
            Me.lblAmtStillOwed.Text = Math.Round(.Settlement_AmountStillOwed, 2)
            Me.txtDueDate.Text = .Settlement_DueDate

            'settlement fees
            Me.lblSettlementSavings.Text = Math.Round(.Settlement_Savings, 2)
            Me.lblSettlementFeePercentage.Text = .Client_SettlementFeePercentage * 100

            Me.lblSettlementFee.Text = Math.Round(.Settlement_Fee, 2)
            Me.lblOvernightDeliveryCost.Text = Math.Round(.Client_OvernightDeliveryFee, 2)
            Me.lblSettlementCost.Text = Math.Round(.Settlement_Cost, 2)

            Me.lblSettlementFee_AmtAvailable.Text = Math.Round(.Settlement_FeeAvailAmt, 2)
            Me.lblSettlementFee_AmtStillOwed.Text = Math.Round(.Settlement_FeeOwedAmt, 2)
            Me.lblSettlementFee_AmtBeingPaid.Text = Math.Round(.Settlement_FeePaidAmt, 2)

            Me.txtDueDate.Text = Format(DateAdd(DateInterval.Day, 7, Now), "MM/dd/yyyy")

            For Each l As ListItem In Me.radDirection.Items
                If l.Text = .Settlement_Direction Then
                    l.Selected = True
                End If
            Next

            Session("SettlementObj") = Settlement

            BindGrid()

        End With
    End Sub
    Private Sub BindGrid()

        Settlement = DirectCast(Session("SettlementObj"), SettlementOfferInfo)

        Dim sqlSelect As String = "SELECT [SettlementID], [CreditorAccountBalance], [SettlementPercent], [SettlementAmount], [SettlementDueDate], [SettlementSavings], [SettlementFee], [SettlementCost], [SettlementNotes], [Status], [Created], [OfferDirection] FROM [tblSettlements] "
        sqlSelect += "WHERE CreditorAccountID = " & Settlement.Creditor_AccountID & " and clientid = " & Settlement.Client_ID
        sqlSelect += " ORDER BY [Created] Desc"


        Me.SqlDataSource1.SelectCommand = sqlSelect
        Me.SqlDataSource1.DataBind()

        Me.GridView1.DataBind()

    End Sub
#End Region
End Class

