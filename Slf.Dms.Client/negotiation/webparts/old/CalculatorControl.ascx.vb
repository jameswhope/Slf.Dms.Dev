Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports LexxiomWebPartsControls
Imports System.IO
Imports System.Drawing.Printing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports LexxiomLetterTemplates
Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf
Partial Class negotiation_webparts_CalculatorControl
    Inherits System.Web.UI.UserControl
#Region "Declares"
    Public Event InsertedOffer(ByVal SettlementID As String, ByVal noteID As String)
    Private UserID As String
    Private _DataDataClientID As String
    Public Property DataClientID() As String
        Get
            Return _DataDataClientID
        End Get
        Set(ByVal value As String)
            _DataDataClientID = value
        End Set
    End Property
    Private _accountID As String
    Public Property accountID() As String
        Get
            Return _accountID
        End Get
        Set(ByVal value As String)
            _accountID = value
        End Set
    End Property

    Public Property noteID() As String
        Get
            Return Me.hdnnoteid.value
        End Get
        Set(ByVal value As String)
            Me.hdnnoteid.value = value
        End Set
    End Property

#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not IsPostBack Then
            Me.txtDueDate.Text = String.Format("{0:d}", Now)
            'store the clientid in hidden field
            DataClientID = Request.QueryString("cid")
            accountID = Request.QueryString("crid")
            If accountID Is Nothing And DataClientID Is Nothing Then
                'disable button if no client/account id
                Me.ibtnAccept.Enabled = False
                Me.ibtnReject.Enabled = False
                Exit Sub
            End If

            CheckStatus(DataClientID, accountID)
            Me.LoadAccountInfo(DataClientID, accountID)
            Me.hiddenIDs.Value = DataClientID & ":" & accountID
            Me.rptFrame.Visible = False
            Me.rptFrame.Attributes("src") = ""

            ' Bug fix - 4/14/08 - jhernandez
            ' Client side changes to asp:TextBox controls get ignored in 2.0 when
            ' ReadOnly is set to True. Setting readonly in the Attributes
            ' collection gets around this issue.
            lblSettlementSavings.Attributes.Add("readonly", "readonly")
            lblSettlementFee.Attributes.Add("readonly", "readonly")
            lblOvernightDeliveryCost.Attributes.Add("readonly", "readonly")
            lblSettlementCost.Attributes.Add("readonly", "readonly")
            lblSettlementFee_AmtAvailable.Attributes.Add("readonly", "readonly")
            lblSettlementFee_AmtBeingPaid.Attributes.Add("readonly", "readonly")
            lblSettlementFee_AmtStillOwed.Attributes.Add("readonly", "readonly")
        End If
    End Sub
    Protected Sub ibtnAccept_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Me.txtDueDate.Text = String.Format("{0:d}", Now)
        Me.mpeAccept.Show()
    End Sub
    Protected Sub ibtnReject_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        'insert the offer
        Dim settID As String = Me.InsertOffer("R")

        'raise event
        RaiseEvent InsertedOffer(settID, noteID)
    End Sub
    Protected Sub lnkDueDate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDueDate.Click
        Dim SettID As String = Me.InsertOffer("A")

        Dim ids As String() = Me.hiddenIDs.Value.Split(":") 'DataClientID & ":" & accountID

        LoadSettAcceptanceForm(GenerateAcceptanceForm(SettID, ids(0), ids(1)))
     
        RaiseEvent InsertedOffer(SettID, noteID)


    End Sub
    Protected Sub mpeAccept_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles mpeAccept.Load
        ClearForm()
    End Sub
#End Region

#Region "SUbs/Funcs"
    Public Sub CheckStatus(ByVal ClientID As String, ByVal accountID As String)

        Dim strStatus As String = ClientHelper.GetStatus(ClientID)
        Dim strAcctStatus As String = ""
        Dim sqlInsert As String = "select accountstatusid from tblaccount where accountid = " & accountID

        Using sqlCmd = New Data.SqlClient.SqlCommand(sqlInsert, New Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
            Try
                If sqlCmd.Connection.State = Data.ConnectionState.Closed Then sqlCmd.Connection.Open()
                strAcctStatus = sqlCmd.ExecuteScalar()
            Catch ex As Exception
                strAcctStatus = ex.Message
            End Try
        End Using

        Select Case strStatus
            Case "Inactive", "Suspended", "Cancelled", "Completed"
                Me.ibtnAccept.Enabled = False
                Me.ibtnReject.Enabled = False
            Case Else
                Me.ibtnAccept.Enabled = True
                Me.ibtnReject.Enabled = True
        End Select

        Select Case strAcctStatus
            Case 54, 55
                Me.ibtnAccept.Enabled = False
                Me.ibtnReject.Enabled = False
        End Select

    End Sub

    ''' <summary>
    ''' Insert an offer 
    ''' </summary>
    ''' <param name="OfferStatus"></param>
    ''' <returns>settlement id</returns>
    ''' <remarks>inserts offers accepted/rejected and returns the settlement id</remarks>
    Public Function InsertOffer(ByVal OfferStatus As String) As String
        Dim sqlInsert As String = ""
        'retrieve client and creditor id's
        Dim ids As String() = Me.hiddenIDs.Value.Split(":")
        Dim SettID As String = ""
        Dim oStatus As String

        'build sql insert
        sqlInsert = "INSERT INTO tblSettlements "
        sqlInsert += "(CreditorAccountID,ClientID,SettlementDueDate,RegisterBalance,FrozenAmount,CreditorAccountBalance,SettlementPercent,SettlementAmount"
        sqlInsert += ",SettlementFeeCredit,SettlementAmtAvailable, SettlementAmtBeingSent, SettlementAmtStillOwed"
        sqlInsert += ",SettlementSavings,SettlementFee,OvernightDeliveryAmount,SettlementCost"
        sqlInsert += ",SettlementFeeAmtAvailable,SettlementFeeAmtBeingPaid,SettlementFeeAmtStillOwed,SettlementNotes,Status,CreatedBy,LastModifiedBy,SettlementRegisterHoldID, OfferDirection,SettlementSessionGuid)"
        sqlInsert += " OUTPUT INSERTED.SettlementID "
        sqlInsert += "VALUES "
        sqlInsert += "([@CreditorAccountID],[@ClientID],[@SettlementDueDate],[@RegisterBalance],[@FrozenAmount],[@CreditorAccountBalance],"
        sqlInsert += "[@SettlementPercent],[@SettlementAmount],[@SettlementFeeCredit],[@SettlementAmtAvailable], [@SettlementAmtBeingPaid], [@SettlementAmtStillOwed],[@SettlementSavings],[@SettlementFee],[@OvernightDeliveryAmount],[@SettlementCost],[@SettlementFeeAmtAvailable],"
        sqlInsert += "[@SettlementFeeAmtBeingPaid],[@SettlementFeeAmtStillOwed],'[@SettlementNotes]','[@Status]',[@CreatedBy],[@LastModifiedBy],[@SettlementRegisterHoldID], '[@OfferDirection]','[@SettlementSessionGuid]')"

        'replace params with values
        sqlInsert = sqlInsert.Replace("[@CreditorAccountID]", ids(1))
        sqlInsert = sqlInsert.Replace("[@ClientID]", ids(0))
        Select Case OfferStatus
            Case "A"
                sqlInsert = sqlInsert.Replace("[@SettlementDueDate]", "'" & Me.hdnDueDate.Value & "'")
                oStatus = "Offer Accepted"
            Case Else
                sqlInsert = sqlInsert.Replace("[@SettlementDueDate]", "null")
                oStatus = "Offer Rejected"
        End Select

        sqlInsert = sqlInsert.Replace("[@RegisterBalance]", System.Double.Parse(Me.lblAvailRegisterBal.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@FrozenAmount]", System.Double.Parse(Me.lblFrozenAmt.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@CreditorAccountBalance]", System.Double.Parse(Me.lblCurrentBalance.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementPercent]", Math.Round(CDbl(Me.txtSettlementPercent.Text), 2))
        sqlInsert = sqlInsert.Replace("[@SettlementAmount]", System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency))


        sqlInsert = sqlInsert.Replace("[@SettlementFeeCredit]", -1 * System.Double.Parse(Me.lblSettlementFeeCredit.Text, System.Globalization.NumberStyles.Currency))

        Dim regBal As Double = System.Double.Parse(Me.lblAvailRegisterBal.Text, System.Globalization.NumberStyles.Currency)
        Dim settAmt As Double = System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency)
        Dim AmtAvail As Double = 0
        Dim AmtSent As Double = 0
        Dim AmtOwed As Double = 0

        If regBal - settAmt > 0 Then
            AmtAvail = settAmt
            AmtSent = settAmt
            AmtOwed = 0
        Else
            AmtAvail = regBal
            AmtSent = regBal
            AmtOwed = regBal - settAmt
        End If


        sqlInsert = sqlInsert.Replace("[@SettlementAmtAvailable]", AmtAvail)
        sqlInsert = sqlInsert.Replace("[@SettlementAmtBeingPaid]", AmtSent)
        sqlInsert = sqlInsert.Replace("[@SettlementAmtStillOwed]", AmtOwed)


        Dim settSavings As Double = System.Double.Parse(Me.lblCurrentBalance.Text, System.Globalization.NumberStyles.Currency) - System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency)
        sqlInsert = sqlInsert.Replace("[@SettlementSavings]", settSavings)
        sqlInsert = sqlInsert.Replace("[@SettlementFee]", System.Double.Parse(Me.lblSettlementFee.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@OvernightDeliveryAmount]", System.Double.Parse(Me.lblOvernightDeliveryCost.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementCost]", System.Double.Parse(Me.lblSettlementCost.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementFeeAmtAvailable]", System.Double.Parse(Me.lblSettlementFee_AmtAvailable.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementFeeAmtBeingPaid]", System.Double.Parse(Me.lblSettlementFee_AmtBeingPaid.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementFeeAmtStillOwed]", System.Double.Parse(Me.lblSettlementFee_AmtStillOwed.Text, System.Globalization.NumberStyles.Currency))
        sqlInsert = sqlInsert.Replace("[@SettlementNotes]", "")
        sqlInsert = sqlInsert.Replace("[@Status]", OfferStatus)
        sqlInsert = sqlInsert.Replace("[@CreatedBy]", Session("UserID"))
        sqlInsert = sqlInsert.Replace("[@LastModifiedBy]", Session("UserID"))
        sqlInsert = sqlInsert.Replace("[@SettlementRegisterHoldID]", "null")
        sqlInsert = sqlInsert.Replace("[@OfferDirection]", Me.radDirection.SelectedValue)
        sqlInsert = sqlInsert.Replace("[@SettlementSessionGuid]", Me.hdnNoteID.Value)

        Using sqlCmd = New Data.SqlClient.SqlCommand(sqlInsert, New Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
            Try
                If sqlCmd.Connection.State = Data.ConnectionState.Closed Then sqlCmd.Connection.Open()
                SettID = sqlCmd.ExecuteScalar()
            Catch ex As Exception
                SettID = ex.Message
            End Try

            'insert session note about offer
            Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & IDs(1)
            Dim dtNote As DataTable = GetDataTable(sqlNote)
            If dtNote.Rows.Count > 0 Then
                Dim strLogText As String = "[@OriginalCreditorName] #[@CreditorAcctLast4], [@SettlementAction] for [@SettlementAmount] "
                strLogText += "with [@CreditorContact] with [@CurrentCreditorName] @ [@CreditorContactPhone].  "
                strLogText += "[@SettlementDueDate].  [@AdditionalMsg]" & Chr(13)
                For Each dRow As DataRow In dtNote.Rows
                    strLogText = strLogText.Replace("[@OriginalCreditorName]", dRow("OriginalCreditorName").ToString)
                    strLogText = strLogText.Replace("[@CreditorAcctLast4]", dRow("CreditorAcctLast4").ToString)
                    strLogText = strLogText.Replace("[@SettlementAmount]", Me.txtSettlementAmt.Text)
                    strLogText = strLogText.Replace("[@CreditorContact]", dRow("CreditorContact").ToString)
                    strLogText = strLogText.Replace("[@CurrentCreditorName]", dRow("CurrentCreditorName").ToString)
                    strLogText = strLogText.Replace("[@CreditorContactPhone]", dRow("ContactPhone").ToString)
                    Select Case OfferStatus.ToUpper
                        Case "A"
                            strLogText = strLogText.Replace("[@SettlementAction]", "Settled account")
                            strLogText = strLogText.Replace("[@SettlementDueDate]", "Due by " & Me.hdnDueDate.Value)
                            strLogText = strLogText.Replace("[@AdditionalMsg]", "")
                        Case "R"
                            strLogText = strLogText.Replace("[@SettlementAction]", "Rejected settlement " & Me.radDirection.SelectedValue)
                            strLogText = strLogText.Replace("[@SettlementDueDate]", "")
                            strLogText = strLogText.Replace("[@AdditionalMsg]", "")
                    End Select

                    Exit For
                Next
                dtNote.Dispose()
                dtNote = Nothing

                If noteID.ToString = "" Then
                    noteID = NoteHelper.InsertNote(strLogText, Session("userid"), ids(0))
                Else
                    NoteHelper.AppendNote(noteID, strLogText, Session("userid"))
                End If
            Else
                If noteID.ToString = "" Then
                    noteID = NoteHelper.InsertNote("Error generating note text for settlement " & SettID, Session("userid"), ids(0))
                Else
                    NoteHelper.AppendNote(noteID, "Error generating note text for settlement " & SettID, Session("userid"))
                End If
            End If

        End Using

        Return SettID

    End Function

    ''' <summary>
    ''' loads account info
    ''' </summary>
    ''' <param name="sClientID"></param>
    ''' <param name="sCreditorAccountID"></param>
    ''' <remarks></remarks>
    Public Sub LoadAccountInfo(ByVal sClientID As String, ByVal sCreditorAccountID As String)
        Dim dtData As New Data.DataTable

        Me.hiddenIDs.Value = sClientID & ":" & sCreditorAccountID

        Using saTemp = New Data.SqlClient.SqlDataAdapter("stp_GetStatsOverviewForClient " & sClientID, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            saTemp.fill(dtData)

            If dtData.Rows.Count > 0 Then
                Dim dr As Data.DataRow = dtData.Rows(0)
                Dim regBal As String = CDbl(dr("registerbalance").ToString)
                Dim frozBal As String = CDbl(dr("frozenbalance").ToString)
                Dim availBal As Double = regBal - frozBal

                Me.lblAvailRegisterBal.Text = FormatCurrency(regBal, 2)
                Me.lblFrozenAmt.Text = FormatCurrency(frozBal, 2)
                Me.lblAvailSDABal.Text = FormatCurrency(availBal, 2)
            End If

            saTemp.SelectCommand.CommandText = "get_ClientFeeInfo " & sClientID
            dtData = New Data.DataTable
            saTemp.Fill(dtData)
            If dtData.Rows.Count > 0 Then
                Dim dr As Data.DataRow = dtData.Rows(0)
                Dim odFee As String = CDbl(dr("OvernightDeliveryFee").ToString)
                Me.lblSettlementFeePercentage.Text = CDbl(dr("SettlementFeePercentage").ToString) * 100
                Me.lblOvernightDeliveryCost.Text = FormatCurrency(odFee, 2)
            End If


            'get next deposit info
            Dim sqlSelect As String = "SELECT NextDepositDate, isnull(NextDepositAmount,'0.00') as NextDepositAmount "
            sqlSelect += "FROM vwClientNextDepositSchedule WHERE clientid = " & sClientID

            saTemp.SelectCommand.CommandText = sqlSelect
            dtData = New Data.DataTable
            saTemp.Fill(dtData)
            If dtData.Rows.Count > 0 Then
                Dim dr As Data.DataRow = dtData.Rows(0)
                Dim dteNextDate As Date = dr("NextDepositDate").ToString
                Me.lblNextDepDate.Text = dteNextDate.ToShortDateString
                Me.lblNextDepAmt.Text = FormatCurrency(dr("NextDepositAmount").ToString, 2)
            End If


            saTemp.SelectCommand.CommandText = "stp_GetCreditorInstancesForAccount " & sCreditorAccountID
            dtData = New Data.DataTable
            saTemp.Fill(dtData)
            If dtData.Rows.Count > 0 Then
                For Each dRow As DataRow In dtData.Rows
                    If dRow("iscurrent") = True Then
                        Dim acctBal As String = CDbl(dRow("currentamount").ToString)
                        Me.lblCurrentBalance.Text = FormatCurrency(acctBal, 2)
                        Me.lblSettlementFeeCredit.Text = FormatCurrency(Double.Parse(dRow("settlementfeecredit").ToString, System.Globalization.NumberStyles.Currency) * -1)
                    End If
                Next
            End If


            Me.txtSettlementPercent.Text = "10"
            Me.txtSettlementAmt.Text = Math.Round(CDbl(Me.lblCurrentBalance.Text) * 0.1, 2).ToString("C2").Replace("$", "")
            Me.lblSettlementSavings.Text = FormatCurrency(CDbl(Me.lblCurrentBalance.Text) - CDbl(Me.txtSettlementAmt.Text), 2)
            Me.lblSettlementFee.Text = FormatCurrency(CDbl(Me.lblSettlementFeePercentage.Text) / 100 * CDbl(Me.lblSettlementSavings.Text), 2)

            Me.lblSettlementCost.Text = FormatCurrency(CDbl(Me.lblSettlementFee.Text) + CDbl(Me.lblOvernightDeliveryCost.Text) + CDbl(Me.lblSettlementFeeCredit.Text), 2)

            Dim dBal As Double = CDbl(Me.lblAvailSDABal.Text) - CDbl(Me.txtSettlementAmt.Text)
            If dBal > CDbl(Me.lblSettlementCost.Text) Then
                Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(Me.lblSettlementCost.Text, 2)
                Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(0, 2)
            Else
                Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(dBal, 2)
                Dim owed As Double = CDbl(Me.lblSettlementCost.Text) - dBal
                Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(owed, 2)
            End If
            Me.lblSettlementFee_AmtBeingPaid.Text = Me.lblSettlementFee_AmtAvailable.Text
        End Using

        Me.ibtnAccept.Enabled = True
        Me.ibtnReject.Enabled = True

        dtData.Dispose()
        dtData = Nothing
    End Sub

    ''' <summary>
    ''' load settlement info
    ''' </summary>
    ''' <param name="strSettlementID"></param>
    ''' <remarks></remarks>
    Public Sub LoadSettlementInfo(ByVal strSettlementID As String)

        Dim dtData As Data.DataTable = Nothing
        Dim sqlText As String = "stp_GetSettlement " & strSettlementID
        Try

            Using saTemp = New SqlDataAdapter(sqlText, System.Configuration.ConfigurationManager.AppSettings("Connectionstring").ToString)

                'creditor data
                dtData = New Data.DataTable
                saTemp.Fill(dtData)

                For Each dRow As Data.DataRow In dtData.Rows
                    Me._DataDataClientID = dRow("ClientID").ToString
                    Me._accountID = dRow("CreditorAccountID").ToString

                    LoadAccountInfo(_DataDataClientID, _accountID)

                    'Me.Settlement_ID = dRow("SettlementID").ToString
                    Me.txtSettlementPercent.Text = Math.Round(CDbl(dRow("SettlementPercent").ToString), 2)
                    Me.txtSettlementAmt.Text = Math.Round(CDbl(dRow("SettlementAmount").ToString), 2)
                    Me.lblSettlementSavings.Text = FormatCurrency(dRow("SettlementSavings").ToString, 2)
                    Me.lblSettlementFee.Text = FormatCurrency(dRow("SettlementFee").ToString, 2)
                    Me.lblSettlementCost.Text = FormatCurrency(dRow("SettlementCost").ToString, 2)
                    Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(dRow("SettlementFeeAmtAvailable").ToString, 2)
                    Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(dRow("SettlementFeeAmtStillOwed").ToString, 2)
                    Me.lblSettlementFee_AmtBeingPaid.Text = FormatCurrency(dRow("SettlementFeeAmtBeingPaid").ToString, 2)

                    For Each i As ListItem In Me.radDirection.Items
                        If i.Value = dRow("OfferDirection").ToString Then
                            i.Selected = True
                        Else
                            i.Selected = False
                        End If
                    Next
                    Exit For
                Next
            End Using
 
        Finally
            dtData.Dispose()
        End Try

    End Sub

    ''' <summary>
    ''' clears all text on form
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ClearForm()

        lblHdr.Text = "Accept Offer"
        Me.txtDueDate.Text = String.Format("{0:d}", Now)
        Me.pnlDueDate.Style("Display") = "block"
        Me.pnlSettAcceptForm.Style("Display") = "none"
        Me.rptFrame.Attributes("src") = ""
        Me.mpeAccept.Hide()


    End Sub
    Private Function GetDataTable(ByVal sqlText As String) As DataTable
        Try
            Dim dtData As New DataTable

            Using saTemp = New SqlClient.SqlDataAdapter(sqlText, System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                saTemp.fill(dtData)
            End Using
            Return dtData
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
#Region "Acceptance Report"
    Private Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String
        Dim tempDir As String

        Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString(), New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        rootDir = "\\" + DatabaseHelper.Peel_string(reader, "StorageServer") + "\" + DatabaseHelper.Peel_string(reader, "StorageRoot") + "\" + DatabaseHelper.Peel_string(reader, "AccountNumber") + "\"
                    Else
                        Throw New Exception("Invalid client. Please contact support.")
                    End If
                End Using

                If Not Directory.Exists(rootDir) Then
                    Directory.CreateDirectory(rootDir)
                End If

                cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder "

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = rootDir + DatabaseHelper.Peel_string(reader, "Name")

                        If Not Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using

                Dim strSQL As String = "SELECT CurrentCreditorInstanceID, AccountID, [Name], Original "
                strSQL += "FROM (SELECT a.CurrentCreditorInstanceID, a.AccountID, cr1.[Name], cr2.[Name] as Original "
                strSQL += "FROM  tblAccount a INNER JOIN "
                strSQL += "tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN "
                strSQL += "tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN "
                strSQL += "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN "
                strSQL += "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID "
                strSQL += "WHERE (a.ClientID = " & ClientID.ToString() & ") "
                strSQL += "UNION "
                strSQL += "SELECT a.OriginalCreditorInstanceID, a.AccountID, cr1.[Name], cr2.[Name] as Original "
                strSQL += "FROM  tblAccount a INNER JOIN "
                strSQL += "tblCreditorInstance c1 on a.OriginalCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN "
                strSQL += "tblCreditorInstance c2 on a.OriginalCreditorInstanceID = c2.CreditorInstanceID INNER JOIN "
                strSQL += "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN "
                strSQL += "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID "
                strSQL += "WHERE (a.ClientID = " & ClientID.ToString() & ") "
                strSQL += ") as AllCreditors ORDER BY [Name] ASC "

                cmd.CommandText = strSQL

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempDir = reader.Item("AccountID").ToString() + "_" + reader.Item("Name").ToString() 'Regex.Replace("", "^[a-zA-Z0-9]+$", "", RegexOptions.IgnoreCase)
                        tempDir = rootDir + "CreditorDocs\" + tempDir.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")

                        If Not System.IO.Directory.Exists(tempDir) Then
                            Directory.CreateDirectory(tempDir)
                        End If
                    End While
                End Using
            End Using
        End Using

        Return rootDir
    End Function
    Private Function GetUniqueDocumentName2(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, ByVal UserID As Integer, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ret As String

        Using conn As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
            conn.Open()

            ret = rootDir + subFolder + GetAccountNumber(conn, ClientID) + "_" + strDocTypeID + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using

        Return ret
    End Function
    Private Function GetAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String

        If conn.State = ConnectionState.Closed Then conn.Open()

        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
            accountno = cmd.ExecuteScalar().ToString()
        End Using

        Return accountno
    End Function
    Private Function GetDocID(ByVal conn As SqlConnection) As String
        Dim docID As String

        Using cmd As New SqlCommand("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", conn)
            docID = cmd.ExecuteScalar().ToString()

            cmd.CommandText = "stp_GetDocumentNumber"
            docID += cmd.ExecuteScalar().ToString()
        End Using

        Return docID
    End Function

    ''' <summary>
    ''' Generates the Settlement Acceptance form pdf
    ''' </summary>
    ''' <param name="SettlementID"></param>
    ''' <param name="DataClientID"></param>
    ''' <param name="accountID"></param>
    ''' <returns>path to new pdf in clients folder</returns>
    ''' <remarks></remarks>
    Private Function GenerateAcceptanceForm(ByVal SettlementID As String, ByVal DataClientID As String, ByVal accountID As String) As String
        Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
        Dim report As New GrapeCity.ActiveReports.SectionReport
        Dim pdf As New PdfExport()
        Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing

        Dim filePath As String = ""
        Dim tempName As String
        Dim strDocTypeName As String = "SettlementAcceptanceForm"
        Dim strDocID As String = rptTemplates.GetDocTypeID(strDocTypeName)
        Dim rootDir = CreateDirForClient(DataClientID)
        Dim strCredName As String = AccountHelper.GetCreditorName(accountID)

        tempName = strCredName
        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
        filePath = GetUniqueDocumentName2(rootDir, DataClientID, strDocID, UserID, "CreditorDocs\" + accountID + "_" + tempName + "\")
        If Directory.Exists(rootDir & "CreditorDocs\" + accountID + "_" + tempName + "\") = False Then
            Directory.CreateDirectory(rootDir & "CreditorDocs\" + accountID + "_" + tempName + "\")
        End If

        Dim rArgs As String = "SettlementAcceptanceForm," & SettlementID
        Dim args As String() = rArgs.Split(",")

        rptDoc = rptTemplates.ViewTemplate("SettlementAcceptanceForm", DataClientID, args, False, UserID)

        'add pages to report
        report.Document.Pages.AddRange(rptDoc.Pages)

        Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
            pdf.Export(report.Document, fStream)
        End Using

        Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & accountID
        Dim dtNote As DataTable = GetDataTable(sqlNote)
        Dim strLogText As String = "[@OriginalCreditorName]/[@CurrentCreditorName] #[@CreditorAcctLast4].  "
        If dtNote.Rows.Count > 0 Then
            For Each dRow As DataRow In dtNote.Rows
                strLogText = strLogText.Replace("[@OriginalCreditorName]", dRow("OriginalCreditorName").ToString)
                strLogText = strLogText.Replace("[@CurrentCreditorName]", dRow("CurrentCreditorName").ToString)
                strLogText = strLogText.Replace("[@CreditorAcctLast4]", dRow("CreditorAcctLast4").ToString)
                Exit For
            Next
        End If
        dtNote.Dispose()
        dtNote = Nothing


        'attach client copy of letter
        NoteHelper.AppendNote(noteID, strLogText & "Settlement Acceptance Form generated for " & strCredName & "." & Chr(13), UserID)

        'attach  document

        'relate to client
        NoteHelper.RelateNote(noteID, 1, DataClientID)

        'relate to creditor 
        NoteHelper.RelateNote(noteID, 2, accountID)

        'attach  document
        SharedFunctions.DocumentAttachment.AttachDocument("note", noteID, Path.GetFileName(filePath), UserID, accountID + "_" + tempName & "\")
        SharedFunctions.DocumentAttachment.AttachDocument("account", accountID, Path.GetFileName(filePath), UserID, accountID + "_" + tempName & "\")

        Return filePath
    End Function

    ''' <summary>
    ''' loads new settlement info for accepted offers
    ''' </summary>
    ''' <param name="SettlementID"></param>
    ''' <remarks></remarks>
    ''' 
    Private Sub LoadSettAcceptanceForm(ByVal pdfPath As String)


        Me.rptFrame.Visible = True
        Me.rptFrame.Attributes("src") = pdfPath

        Me.pnlDueDate.Style("Display") = "none"
        Me.pnlSettAcceptForm.Style("Display") = ""
        mpeAccept.Show()
    End Sub
#End Region
#End Region
End Class
