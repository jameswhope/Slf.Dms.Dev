Option Explicit On

Imports System.Data.SqlClient

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataHelpers.SettlementHelper

Public Class NegotiationHelper
    Inherits DataHelperBase

    Public Shared Sub Lock(ByVal UserID As Integer)
        PropertyHelper.Update("NegotiationInterfaceLockedBy", UserID.ToString(), UserID)
    End Sub

    Public Shared Sub Unlock(ByVal UserID As Integer)
        PropertyHelper.Update("NegotiationInterfaceLockedBy", "", UserID)
    End Sub

    Public Shared Function IsLocked(ByVal UserID As Integer) As Boolean
        Return False
        'Dim lock As String = PropertyHelper.Value("NegotiationInterfaceLockedBy")

        'Return Not (String.IsNullOrEmpty(lock) Or IsLockedBy() = UserID.ToString())
    End Function

    Public Shared Function IsLockedBy() As Integer
        Dim value As String = PropertyHelper.Value("NegotiationInterfaceLockedBy")

        If String.IsNullOrEmpty(value) Then
            Return -1
        End If

        Return Integer.Parse(value)
    End Function

    Public Shared Function IsAdministrator(ByVal UserID As Integer) As Boolean
        If DataHelper.FieldCount("tblUser", "UserID", "UserGroupID in (6, 11, 20) and UserID = " & UserID) = 1 Then
            Return True
        Else
            'Checking if the user is the root node entity, they also get administrator priveledges
            Using cmd As New SqlCommand("SELECT ParentNegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and UserID = " & UserID, ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using rd As SqlDataReader = cmd.ExecuteReader()
                        If rd.HasRows Then
                            rd.Read()
                            If rd("ParentNegotiationEntityID") Is DBNull.Value Then
                                Return True
                            End If
                        End If
                    End Using

                    If cmd.Connection.State <> ConnectionState.Closed Then
                        cmd.Connection.Close()
                    End If
                End Using
            End Using
        End If

        Return False
    End Function

    Public Shared Sub RegisterClientVisit(ByVal ClientID As Integer, ByVal UserID As Integer)
        Using cmd As New SqlCommand("INSERT INTO tblUserClientVisit (UserID, ClientID, VisitedOn) VALUES (" & UserID & ", " & ClientID & ", getdate())", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

        'TreeTrackHelper.InsertNode(ClientID, TreeTrackHelper.TreeTrackIDType.Settlement, TreeTrackHelper.TreeTrackType.Engaged, UserID)
    End Sub

    Public Shared Sub AddSessionNote(ByVal NoteTextToAdd As String, ByVal SessionUserID As String, ByVal SessionClientID As String, ByVal SessionAccountID As String)
        Dim NoteID As Integer = NoteHelper.InsertNote(NoteTextToAdd, SessionUserID, SessionClientID)
        NoteHelper.RelateNote(NoteID, 2, SessionAccountID)
    End Sub

    Public Shared Sub AddLogText(ByVal SessionGUID As String, ByVal SessionUserID As Integer, ByVal LogText As String, ByVal EntrySubject As String)
        Dim sqlInsert As String
        sqlInsert = "INSERT INTO [tblNegotiationSessionLog] ([NegotiationSessionGUID],[UserID],[LogSubject],[LogText],[CreatedBy]) "
        sqlInsert += "VALUES ('[@NegotiationSessionGUID]',[@UserID],'[@LogSubject]','[@LogText]',[@CreatedBy])"

        sqlInsert = sqlInsert.Replace("[@NegotiationSessionGUID]", SessionGUID)
        sqlInsert = sqlInsert.Replace("[@UserID]", SessionUserID)
        sqlInsert = sqlInsert.Replace("[@LogSubject]", EntrySubject)
        sqlInsert = sqlInsert.Replace("[@LogText]", LogText.Replace("'", "''"))
        sqlInsert = sqlInsert.Replace("[@CreatedBy]", SessionUserID)

        Using sqlCmd = New Data.SqlClient.SqlCommand(sqlInsert, ConnectionFactory.Create())
            If sqlCmd.Connection.State = Data.ConnectionState.Closed Then sqlCmd.Connection.Open()
            sqlCmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub CacheView()
        'CacheHelper.CacheView("vwNegotiationDistributionSource", "AccountID")
    End Sub

    Public Shared Function HoldFunds(ByVal SettlementClient_ID As String, _
                            ByVal SettlementCreditor_AccountID As String, _
                            ByVal SettlementID As String)


        Dim intNegotiationHoldFundDays As Integer = Integer.Parse(DataHelper.FieldLookup("tblproperty", "Value", "Name = 'MediationHoldDays'"))

        'sqlSelect = "select isnull(max(settlementstatusid),0) as CurrectSettlementStatus from tblnegotiationroadmap where settlementid in(select settlementid "
        'sqlSelect += "from tblsettlements where clientid = " & ClientID & " and creditoraccountid = " & accountID & ")"
        'Using sqlCmd = New Data.SqlClient.SqlCommand(sqlSelect, New Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
        '    If sqlCmd.Connection.State = Data.ConnectionState.Closed Then sqlCmd.Connection.Open()
        '    Dim settStatusID As Integer = CInt(sqlCmd.ExecuteScalar())
        '    If settStatusID >= 3 Then
        '        Me.ibtnAccept.Enabled = False
        '        Me.ibtnReject.Enabled = False
        '    End If
        'End Using

        'delete previous funds on hold
        Dim holdCriteria As String = "status = 'A' and settlementregisterholdid is not null and clientid = " & SettlementClient_ID & " and creditoraccountid = " & SettlementCreditor_AccountID
        Dim holdIDS As Integer() = DataHelper.FieldLookupIDs("tblsettlements", "settlementregisterholdid", holdCriteria)
        RegisterHelper.Delete(holdIDS)

        'get current account bal
        Dim CreditorAccountBalance As Double = AccountHelper.GetCurrentAmount(SettlementCreditor_AccountID)

        'get settlement info
        Dim Client_RegisterBalance As Double
        Dim SettlementAmount As Double
        Dim SettlementNegotiatorID As Double
        Dim sqlSelect As String = "Select registerbalance, settlementamount, createdby from tblsettlements where settlementid = " & SettlementID
        Dim cmdInfo As New SqlCommand(sqlSelect, ConnectionFactory.Create())
        If cmdInfo.Connection.State = ConnectionState.Closed Then cmdInfo.Connection.Open()
        Dim rdr As SqlDataReader = cmdInfo.ExecuteReader
        If rdr.HasRows Then
            Do While rdr.Read
                Client_RegisterBalance = Double.Parse(rdr("registerbalance").ToString)
                SettlementAmount = Double.Parse(rdr("settlementamount").ToString)
                SettlementNegotiatorID = Double.Parse(rdr("createdby").ToString)
            Loop
        End If

        Dim regID As Integer
        regID = Drg.Util.DataHelpers.RegisterHelper.InsertDebit(SettlementClient_ID, SettlementCreditor_AccountID, Now, DBNull.Value.ToString, "Settlement Funds Hold", System.Double.Parse(SettlementAmount, System.Globalization.NumberStyles.Currency), SettlementNegotiatorID, 43, SettlementNegotiatorID)
        RegisterHelper.Hold(regID, SettlementNegotiatorID, DateAdd(DateInterval.Day, intNegotiationHoldFundDays, Now), True)

        Return regID

    End Function

    Public Function UpdateCurrentCreditor(ByVal intAccountID As Integer, ByVal intCreditorID As Integer, ByVal intCreatedBy As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_NegotiationUpdateCurrentCreditor")
        Dim intNewCreditorInstanceID As Integer = -1

        DatabaseHelper.AddParameter(cmd, "AccountID", intAccountID)
        DatabaseHelper.AddParameter(cmd, "CreditorID", intCreditorID)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", intCreatedBy)

        Try
            intNewCreditorInstanceID = CType(DatabaseHelper.ExecuteScalar(cmd), Integer)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return intNewCreditorInstanceID
    End Function

    Public Function InsertNewCreditor(ByVal CreditorName As String, ByVal Street1 As String, ByVal Street2 As String, ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String, ByVal intCreatedBy As Integer, ByVal blnValidated As Boolean) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_NegotiationInsertCreditor")
        Dim intCreditorID As Integer = -1

        DatabaseHelper.AddParameter(cmd, "CreditorName", CreditorName)
        DatabaseHelper.AddParameter(cmd, "Street1", Street1)
        DatabaseHelper.AddParameter(cmd, "Street2", Street2)
        DatabaseHelper.AddParameter(cmd, "City", City)
        DatabaseHelper.AddParameter(cmd, "StateID", StateID)
        DatabaseHelper.AddParameter(cmd, "ZipCode", ZipCode)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", intCreatedBy)
        DatabaseHelper.AddParameter(cmd, "Validated", IIf(blnValidated, 1, 0))

        Try
            intCreditorID = CType(DatabaseHelper.ExecuteScalar(cmd), Integer)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return intCreditorID
    End Function

    Public Function InsertSettlement(ByVal CreditorAccountId As Integer, ByVal ClientID As Integer, ByVal RegisterBalance As Nullable(Of Double), _
                    ByVal FrozenAmount As Nullable(Of Double), ByVal CreditorAccountBalance As Nullable(Of Double), ByVal SettlementPercent As Double, _
                    ByVal SettlementAmount As Double, ByVal SettlementAmtAvailable As Nullable(Of Double), ByVal SettlementAmtBeingSent As Nullable(Of Double), _
                    ByVal SettlementAmtStillOwed As Nullable(Of Double), ByVal SettlementDueDate As Nullable(Of DateTime), ByVal SettlementSavings As Nullable(Of Double), _
                    ByVal SettlementFee As Nullable(Of Double), ByVal OvernightDeliveryAmount As Nullable(Of Double), ByVal SettlementCost As Nullable(Of Double), _
                    ByVal SettlementFeeAmtAvailable As Nullable(Of Double), ByVal SettlementFeeAmtBeingPaid As Nullable(Of Double), ByVal SettlementFeeAmtStillOwed As Nullable(Of Double), _
                    ByVal Status As String, ByVal UserId As Integer, ByVal SettlementRegisterHoldID As Nullable(Of Integer), _
                    ByVal OfferDirection As String, ByVal SettlementSessionGuid As String, ByVal SettlementFeeCredit As Nullable(Of Double)) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_NegotiationInsertSettlement")
        Dim intSettlementID As Integer = -1

        DatabaseHelper.AddParameter(cmd, "CreditorAccountID", CreditorAccountId)
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        If RegisterBalance.HasValue Then DatabaseHelper.AddParameter(cmd, "RegisterBalance", RegisterBalance)
        If FrozenAmount.HasValue Then DatabaseHelper.AddParameter(cmd, "FrozenAmount", FrozenAmount)
        If CreditorAccountBalance.HasValue Then DatabaseHelper.AddParameter(cmd, "CreditorAccountBalance", CreditorAccountBalance)
        DatabaseHelper.AddParameter(cmd, "SettlementPercent", SettlementPercent)
        DatabaseHelper.AddParameter(cmd, "SettlementAmount", SettlementAmount)
        If SettlementAmtAvailable.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementAmtAvailable", SettlementAmtAvailable)
        If SettlementAmtBeingSent.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementAmtBeingSent", SettlementAmtBeingSent)
        If SettlementAmtStillOwed.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementAmtStillOwed", SettlementAmtStillOwed)
        If SettlementDueDate.HasValue And Not SettlementDueDate = "1/1/1990" And Not SettlementDueDate = "12:00:00 AM" Then
            DatabaseHelper.AddParameter(cmd, "SettlementDueDate", SettlementDueDate.Value)
        Else
            DatabaseHelper.AddParameter(cmd, "SettlementDueDate", DBNull.Value)
        End If
        If SettlementSavings.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementSavings", SettlementSavings)
        If SettlementFee.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementFee", SettlementFee)
        If OvernightDeliveryAmount.HasValue Then DatabaseHelper.AddParameter(cmd, "OvernightDeliveryAmount", OvernightDeliveryAmount)
        If SettlementCost.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementCost", SettlementCost)
        If SettlementFeeAmtAvailable.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementFeeAmtAvailable", SettlementFeeAmtAvailable)
        If SettlementFeeAmtBeingPaid.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementFeeAmtBeingPaid", SettlementFeeAmtBeingPaid)
        If SettlementFeeAmtStillOwed.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementFeeAmtStillOwed", SettlementFeeAmtStillOwed)
        DatabaseHelper.AddParameter(cmd, "SettlementNotes", IIf(Status = 1, "Settlement Rejected", "Settlement Accepted"))
        If Status.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Status", IIf(Status = 1, "R", "A"))
        DatabaseHelper.AddParameter(cmd, "UserId", UserId)
        If SettlementRegisterHoldID.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementRegisterHoldID", SettlementRegisterHoldID)
        DatabaseHelper.AddParameter(cmd, "OfferDirection", OfferDirection)
        If Not SettlementSessionGuid Is Nothing AndAlso SettlementSessionGuid.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "SettlementSessionGuid", SettlementSessionGuid)
        If SettlementFeeCredit.HasValue Then DatabaseHelper.AddParameter(cmd, "SettlementFeeCredit", CDbl(SettlementFeeCredit) * -1)

        Try
            intSettlementID = CType(DatabaseHelper.ExecuteScalar(cmd), Integer)

            Dim strLogText As String
            strLogText = "[@OriginalCreditorName] #[@CreditorAcctLast4], [@SettlementAction] for [@SettlementAmount] "
            strLogText += "with [@CreditorContact] with [@CurrentCreditorName] @ [@CreditorContactPhone].  [@SettlementDueDate].  [@AdditionalMsg]" & Chr(13)

            'insert session note about offer
            cmd = ConnectionFactory.CreateCommand("stp_NegotiationsSystemNoteInfo")
            DatabaseHelper.AddParameter(cmd, "AccountID", CreditorAccountId)
            Dim rdrNote As SqlDataReader = Drg.Util.DataAccess.DatabaseHelper.ExecuteReader(cmd, CommandBehavior.CloseConnection)
            If rdrNote.HasRows Then
                Do While rdrNote.Read
                    strLogText = strLogText.Replace("[@OriginalCreditorName]", rdrNote("OriginalCreditorName").ToString)
                    strLogText = strLogText.Replace("[@CreditorAcctLast4]", rdrNote("CreditorAcctLast4").ToString)
                    strLogText = strLogText.Replace("[@SettlementAmount]", SettlementAmount)
                    strLogText = strLogText.Replace("[@CreditorContact]", rdrNote("CreditorContact").ToString)
                    strLogText = strLogText.Replace("[@CurrentCreditorName]", rdrNote("CurrentCreditorName").ToString)
                    strLogText = strLogText.Replace("[@CreditorContactPhone]", rdrNote("ContactPhone").ToString)
                    Select Case Status
                        Case 0
                            strLogText = strLogText.Replace("[@SettlementAction]", "Settled account")
                            strLogText = strLogText.Replace("[@SettlementDueDate]", "Due by " & SettlementDueDate.ToString)
                            strLogText = strLogText.Replace("[@AdditionalMsg]", "")
                        Case 1
                            strLogText = strLogText.Replace("[@SettlementAction]", "Rejected settlement " & OfferDirection)
                            strLogText = strLogText.Replace("[@SettlementDueDate]", "")
                            strLogText = strLogText.Replace("[@AdditionalMsg]", "")
                    End Select
                    Exit Do
                Loop

                If SettlementSessionGuid.ToString = "" Then
                    SettlementSessionGuid = NoteHelper.InsertNote(strLogText, UserId, ClientID)
                Else
                    NoteHelper.AppendNote(SettlementSessionGuid, strLogText, UserId)
                End If
            Else
                If SettlementSessionGuid.ToString = "" Then
                    SettlementSessionGuid = NoteHelper.InsertNote("Error generating note text for settlement " & intSettlementID, UserId, ClientID)
                Else
                    NoteHelper.AppendNote(SettlementSessionGuid, "Error generating note text for settlement " & intSettlementID, UserId)
                End If

            End If
            rdrNote.Close()


        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return intSettlementID
    End Function

    Public Sub UpdateSettlement(ByVal RegisterId As Integer, ByVal SettlementId As String)
        Drg.Util.DataAccess.DataHelper.FieldUpdate("tblSettlements", "SettlementRegisterHoldID", RegisterId, "SettlementID = " & SettlementId)
    End Sub

    Public Function GetClientIdbyAccount(ByVal AccountId As Integer) As Integer
        Return Drg.Util.DataAccess.DataHelper.FieldLookup("tblAccount", "ClientId", "AccountID = " & AccountId)
    End Function

    Public Function GetClientFeeInfo(ByVal intClientID As Integer) As DataTable
        Return Me.ExecuteQuery("exec get_ClientFeeInfo " & intClientID)
    End Function

    Public Function GetCreditorInstancesForAccount(ByVal intCreditorAccountID As Integer) As DataTable
        Return Me.ExecuteQuery("exec stp_GetCreditorInstancesForAccount " & intCreditorAccountID)
    End Function

    Public Function GetStatsOverviewForClient(ByVal intClientID As Integer) As DataTable
        Return Me.ExecuteQuery("exec stp_GetStatsOverviewForClient " & intClientID)
    End Function

    Public Function RejectOffer(ByVal NewSettlementInfo As SettlementInformation, ByVal SessionUserID As String) As Integer

        Dim SettID As Integer = InsertSettlement(NewSettlementInfo.AccountID, NewSettlementInfo.ClientID, NewSettlementInfo.RegisterBalance, _
                            NewSettlementInfo.FrozenAmount, NewSettlementInfo.CreditorAccountBalance, NewSettlementInfo.SettlementPercent, _
                            NewSettlementInfo.SettlementAmount, NewSettlementInfo.SettlementAmountAvailable, NewSettlementInfo.SettlementAmountSent, _
                            NewSettlementInfo.SettlementAmountOwed, NewSettlementInfo.SettlementDueDate, NewSettlementInfo.SettlementSavings, _
                            NewSettlementInfo.SettlementFee, NewSettlementInfo.OvernightDeliveryFee, NewSettlementInfo.SettlementCost, _
                            NewSettlementInfo.SettlementFeeAmountAvailable, NewSettlementInfo.SettlementFeeAmountBeingPaid, _
                            NewSettlementInfo.SettlementFeeAmountOwed, NewSettlementInfo.AcceptanceStatus, _
                            SessionUserID, NewSettlementInfo.RegisterHoldID, NewSettlementInfo.OfferDirection, NewSettlementInfo.SettlementSessionGUID, _
                            NewSettlementInfo.SettlementFeeCredit)

        Dim roadmapID As Integer = NegotiationRoadmapHelper.InsertRoadmap(SettID, 1, "Settlement Process", SessionUserID)
        Drg.Util.DataHelpers.NegotiationRoadmapHelper.InsertRoadmap(SettID, 2, roadmapID, "Settlement Rejected", SessionUserID)

        Return SettID
    End Function

    Public Function AcceptOffer(ByVal NewSettlementInfo As SettlementInformation, ByVal SessionUserID As String, Optional ByVal bOver As Boolean = False) As Integer

        Dim SettID As Integer = InsertSettlement(NewSettlementInfo.AccountID, NewSettlementInfo.ClientID, NewSettlementInfo.RegisterBalance, _
                            NewSettlementInfo.FrozenAmount, NewSettlementInfo.CreditorAccountBalance, NewSettlementInfo.SettlementPercent, _
                            NewSettlementInfo.SettlementAmount, NewSettlementInfo.SettlementAmountAvailable, NewSettlementInfo.SettlementAmountSent, _
                            NewSettlementInfo.SettlementAmountOwed, NewSettlementInfo.SettlementDueDate, NewSettlementInfo.SettlementSavings, _
                            NewSettlementInfo.SettlementFee, NewSettlementInfo.OvernightDeliveryFee, NewSettlementInfo.SettlementCost, _
                            NewSettlementInfo.SettlementFeeAmountAvailable, NewSettlementInfo.SettlementFeeAmountBeingPaid, _
                            NewSettlementInfo.SettlementFeeAmountOwed, NewSettlementInfo.AcceptanceStatus, _
                            SessionUserID, NewSettlementInfo.RegisterHoldID, NewSettlementInfo.OfferDirection, NewSettlementInfo.SettlementSessionGUID, _
                            NewSettlementInfo.SettlementFeeCredit)

        Dim roadmapID As Integer = NegotiationRoadmapHelper.InsertRoadmap(SettID, 1, "Settlement Process", SessionUserID)
        NegotiationRoadmapHelper.InsertRoadmap(SettID, 3, roadmapID, "Settlement Accepted", SessionUserID)
        If bOver = False Then
            NegotiationRoadmapHelper.InsertRoadmap(SettID, 5, roadmapID, "Waiting on SIF", SessionUserID)
        End If

        '**Need to do this??
        'Dim registerID As Integer = NegotiationHelper.HoldFunds(NewSettlementInfo.ClientID, NewSettlementInfo.AccountID, SettID)
        'Drg.Util.DataAccess.DataHelper.FieldUpdate("tblSettlements", "SettlementRegisterHoldID", registerID, "SettlementID = " & SettID)

        '*** Uncomment when we roll out the Processing Interface
        '*** Why are we doing this here? Move this into the Accept SIF app
        '*** 2.19.09.ug-moved to attach sif
        'SettlementProcessingHelper.InsertSettlement(SettID)
        'SettlementHelper.DistributeSettlements()



        Return SettID
    End Function

End Class