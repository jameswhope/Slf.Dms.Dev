Option Explicit On
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SettlementMatterHelper

Public Class NegotiationCalcHelper

    #Region "Enumerations"

    Public Enum OfferAcceptanceStatus
        Accepted
        Rejected
    End Enum

    #End Region 'Enumerations

    #Region "Methods"

    Public Shared Sub AddLogText(ByVal SessionGUID As String, ByVal SessionUserID As Integer, ByVal LogText As String, ByVal EntrySubject As String)
        Dim sqlInsert As New StringBuilder
        sqlInsert.Append("INSERT INTO [tblNegotiationSessionLog] ([NegotiationSessionGUID],[UserID],[LogSubject],[LogText],[CreatedBy]) VALUES (")
        sqlInsert.AppendFormat("'{0}',{1},'{2}','{3}',{4})", SessionGUID, SessionUserID, EntrySubject, LogText.Replace("'", "''"), SessionUserID)
        SqlHelper.ExecuteNonQuery(sqlInsert.ToString)
    End Sub

    Public Shared Sub AddSessionNote(ByVal NoteTextToAdd As String, ByVal SessionUserID As String, ByVal SessionClientID As String, ByVal SessionAccountID As String)
        Dim NoteID As Integer = NoteHelper.InsertNote(NoteTextToAdd, SessionUserID, SessionClientID)
        NoteHelper.RelateNote(NoteID, 2, SessionAccountID)
    End Sub

    Public Shared Sub CacheView()
        'CacheHelper.CacheView("vwNegotiationDistributionSource", "AccountID")
    End Sub

    Public Shared Function GetPropertyValueByID(ByVal PropertyID As Integer) As String
        Dim ssql As String = String.Format("Select Value from tblproperty where [PropertyID] = {0}", PropertyID)
        Return SqlHelper.ExecuteScalar(ssql, CommandType.Text)
    End Function

    Public Shared Function GetPropertyValueByName(ByVal Name As String) As String
        Dim ssql As String = String.Format("Select Value from tblproperty where [Name] = '{0}'", Name)
        Return SqlHelper.ExecuteScalar(ssql, CommandType.Text)
    End Function

    Public Shared Function IsAdministrator(ByVal UserID As Integer) As Boolean
        Dim sqlUser As String = String.Format("select userid from tbluser where UserGroupID in (6, 11, 20) and UserID = {0}", UserID)
        If SqlHelper.ExecuteScalar(sqlUser, CommandType.Text) = 1 Then
            Return True
        Else
            'Checking if the user is the root node entity, they also get administrator priveledges
            sqlUser = String.Format("SELECT ParentNegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and UserID = {0}", UserID)
            Using rd As SqlDataReader = SqlHelper.GetDataReader(sqlUser, CommandType.Text)
                If rd.HasRows Then
                    rd.Read()
                    If rd("ParentNegotiationEntityID") Is DBNull.Value Then
                        Return True
                    End If
                End If
            End Using
        End If

        Return False
    End Function

    Public Shared Function IsLocked(ByVal UserID As Integer) As Boolean
        Return False
        'Dim lock As String = PropertyHelper.Value("NegotiationInterfaceLockedBy")

        'Return Not (String.IsNullOrEmpty(lock) Or IsLockedBy() = UserID.ToString())
    End Function

    Public Shared Function IsLockedBy() As Integer
        Dim value As String = GetPropertyValueByName("NegotiationInterfaceLockedBy")

        If String.IsNullOrEmpty(value) Then
            Return -1
        End If

        Return Integer.Parse(value)
    End Function

    Public Shared Sub Lock(ByVal UserID As Integer)
        UpdateProperty("NegotiationInterfaceLockedBy", UserID.ToString(), UserID)
    End Sub

    Public Shared Sub RegisterClientVisit(ByVal ClientID As Integer, ByVal UserID As Integer)
        SqlHelper.ExecuteNonQuery("INSERT INTO tblUserClientVisit (UserID, ClientID, VisitedOn) VALUES (" & UserID & ", " & ClientID & ", getdate())", CommandType.Text)
    End Sub

    Public Shared Sub Unlock(ByVal UserID As Integer)
        UpdateProperty("NegotiationInterfaceLockedBy", "", UserID)
    End Sub

    Public Function AcceptOffer(ByVal NewSettlementInfo As OfferInformation, ByVal SessionUserID As String, Optional ByVal bOver As Boolean = False) As Integer
        Dim SettID As Integer = InsertSettlement(NewSettlementInfo, SessionUserID)

        Dim roadmapID As Integer = NegotiationRoadmapHelper.InsertRoadmap(SettID, 1, "Settlement Process", SessionUserID)
        NegotiationRoadmapHelper.InsertRoadmap(SettID, 3, roadmapID, "Settlement Accepted", SessionUserID)
        If bOver = False Then
            'If Not NewSettlementInfo.IsClientStipulation Then
            NegotiationRoadmapHelper.InsertRoadmap(SettID, 5, roadmapID, "Waiting on SIF", SessionUserID)
            'End If
        End If

        Return SettID
    End Function

    Public Function RejectOffer(ByVal NewSettlementInfo As OfferInformation, ByVal SessionUserID As String) As Integer
        Dim SettID As Integer = InsertSettlement(NewSettlementInfo, SessionUserID)

        Dim roadmapID As Integer = NegotiationRoadmapHelper.InsertRoadmap(SettID, 1, "Settlement Process", SessionUserID)
        Drg.Util.DataHelpers.NegotiationRoadmapHelper.InsertRoadmap(SettID, 2, roadmapID, "Settlement Rejected", SessionUserID)

        Return SettID
    End Function

    Public Function GetClientFeeInfo(ByVal intClientID As Integer) As DataTable
        Return SqlHelper.ExecuteScalar("exec get_ClientFeeInfo " & intClientID, CommandType.Text)
    End Function

    Public Function GetClientIdbyAccount(ByVal AccountId As Integer) As Integer
        Return Drg.Util.DataAccess.DataHelper.FieldLookup("tblAccount", "ClientId", "AccountID = " & AccountId)
    End Function

    Public Function GetCreditorInstancesForAccount(ByVal intCreditorAccountID As Integer) As DataTable
        Return SqlHelper.ExecuteScalar("exec stp_GetCreditorInstancesForAccount " & intCreditorAccountID, CommandType.Text)
    End Function

    Public Function GetStatsOverviewForClient(ByVal intClientID As Integer) As DataTable
        Return SqlHelper.ExecuteScalar("exec stp_GetStatsOverviewForClient " & intClientID, CommandType.Text)
    End Function

    Public Function InsertNewCreditor(ByVal CreditorName As String, ByVal Street1 As String, ByVal Street2 As String, ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String, ByVal intCreatedBy As Integer, ByVal blnValidated As Boolean) As Integer
        'Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_NegotiationInsertCreditor")
        Dim intCreditorID As Integer = -1
        Dim myParams As New List(Of SqlParameter)

        myParams.Add(New SqlParameter("CreditorName", CreditorName))
        myParams.Add(New SqlParameter("Street1", Street1))
        myParams.Add(New SqlParameter("Street2", Street2))
        myParams.Add(New SqlParameter("City", City))
        myParams.Add(New SqlParameter("StateID", StateID))
        myParams.Add(New SqlParameter("ZipCode", ZipCode))
        myParams.Add(New SqlParameter("CreatedBy", intCreatedBy))
        myParams.Add(New SqlParameter("Validated", IIf(blnValidated, 1, 0)))

        Try
            intCreditorID = SqlHelper.ExecuteScalar("stp_NegotiationInsertCreditor", CommandType.StoredProcedure, myParams.ToArray)
        Catch ex As Exception
            Throw ex
        End Try
        Return intCreditorID
    End Function

    Public Function InsertSettlement(ByVal offer As OfferInformation, ByVal SessionUserID As String) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_settlements_insertSettlementOffer")
        Dim intSettlementID As Integer = -1

        DatabaseHelper.AddParameter(cmd, "CreditorAccountID", offer.AccountID)
        DatabaseHelper.AddParameter(cmd, "ClientID", offer.ClientID)
        DatabaseHelper.AddParameter(cmd, "RegisterBalance", offer.RegisterBalance)
        DatabaseHelper.AddParameter(cmd, "FrozenAmount", offer.FrozenAmount)

        DatabaseHelper.AddParameter(cmd, "SDABalance", offer.SDABalance)
        DatabaseHelper.AddParameter(cmd, "BankReserve", offer.BankReserve)
        DatabaseHelper.AddParameter(cmd, "AvailSDA", offer.AvailSDA)
        DatabaseHelper.AddParameter(cmd, "PFOBalance", offer.PFOBalance)
        DatabaseHelper.AddParameter(cmd, "CreditorAccountBalance", offer.CreditorAccountBalance)

        DatabaseHelper.AddParameter(cmd, "SettlementPercent", offer.SettlementPercent)
        DatabaseHelper.AddParameter(cmd, "SettlementAmount", offer.SettlementAmount)
        DatabaseHelper.AddParameter(cmd, "SettlementAmtAvailable", offer.SettlementAmountAvailable)
        DatabaseHelper.AddParameter(cmd, "SettlementAmtBeingSent", offer.SettlementAmountSent)
        DatabaseHelper.AddParameter(cmd, "SettlementAmtStillOwed", offer.SettlementAmountOwed)

        DatabaseHelper.AddParameter(cmd, "SettlementSavings", offer.SettlementSavings)
        DatabaseHelper.AddParameter(cmd, "SettlementFee", offer.SettlementFee)
        DatabaseHelper.AddParameter(cmd, "SettlementFeeCredit", offer.SettlementFeeCredit)
        DatabaseHelper.AddParameter(cmd, "OvernightDeliveryAmount", offer.OvernightDeliveryFee)
        DatabaseHelper.AddParameter(cmd, "SettlementCost", offer.SettlementCost)

        DatabaseHelper.AddParameter(cmd, "SettlementFeeAmtAvailable", offer.SettlementFeeAmountAvailable)
        DatabaseHelper.AddParameter(cmd, "SettlementFeeAmtBeingPaid", offer.SettlementFeeAmountBeingPaid)
        DatabaseHelper.AddParameter(cmd, "SettlementFeeAmtStillOwed", offer.SettlementFeeAmountOwed)

        DatabaseHelper.AddParameter(cmd, "SettlementRegisterHoldID", offer.RegisterHoldID)
        DatabaseHelper.AddParameter(cmd, "OfferDirection", offer.OfferDirection)
        If Not offer.SettlementSessionGUID Is Nothing AndAlso offer.SettlementSessionGUID.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "SettlementSessionGuid", offer.SettlementSessionGUID)
        DatabaseHelper.AddParameter(cmd, "UserId", SessionUserID)

        If offer.AcceptanceStatus = OfferAcceptanceStatus.Accepted Then
            DatabaseHelper.AddParameter(cmd, "SettlementNotes", "Settlement Accepted")
            DatabaseHelper.AddParameter(cmd, "Status", "A")
            DatabaseHelper.AddParameter(cmd, "SettlementDueDate", offer.SettlementDueDate)
            DatabaseHelper.AddParameter(cmd, "DeliveryMethod", offer.DeliveryMethod)
            DatabaseHelper.AddParameter(cmd, "DeliveryAmt", offer.DeliveryAmount)
            DatabaseHelper.AddParameter(cmd, "IsClientStipulation", offer.IsClientStipulation)
            DatabaseHelper.AddParameter(cmd, "IsRestrictiveEndorsement", offer.IsRestrictiveEndorsement)
            DatabaseHelper.AddParameter(cmd, "IsPaymentArrangement", offer.IsPaymentArrangement)
        Else
            DatabaseHelper.AddParameter(cmd, "SettlementNotes", "Settlement Rejected")
            DatabaseHelper.AddParameter(cmd, "Status", "R")
        End If

        Try
            intSettlementID = CType(DatabaseHelper.ExecuteScalar(cmd), Integer)

            Dim strLogText As String
            strLogText = "[@OriginalCreditorName] #[@CreditorAcctLast4], [@SettlementAction] for [@SettlementAmount] "
            strLogText += "with [@CreditorContact] with [@CurrentCreditorName] @ [@CreditorContactPhone].  [@SettlementDueDate].  [@AdditionalMsg]" & Chr(13)

            'insert session note about offer
            cmd = ConnectionFactory.CreateCommand("stp_NegotiationsSystemNoteInfo")
            DatabaseHelper.AddParameter(cmd, "AccountID", offer.AccountID)
            Dim rdrNote As SqlDataReader = Drg.Util.DataAccess.DatabaseHelper.ExecuteReader(cmd, CommandBehavior.CloseConnection)
            If rdrNote.HasRows Then
                Do While rdrNote.Read
                    strLogText = strLogText.Replace("[@OriginalCreditorName]", rdrNote("OriginalCreditorName").ToString)
                    strLogText = strLogText.Replace("[@CreditorAcctLast4]", rdrNote("CreditorAcctLast4").ToString)
                    strLogText = strLogText.Replace("[@SettlementAmount]", offer.SettlementAmount)
                    strLogText = strLogText.Replace("[@CreditorContact]", rdrNote("CreditorContact").ToString)
                    strLogText = strLogText.Replace("[@CurrentCreditorName]", rdrNote("CurrentCreditorName").ToString)
                    strLogText = strLogText.Replace("[@CreditorContactPhone]", rdrNote("ContactPhone").ToString)
                    Select Case offer.AcceptanceStatus
                        Case 0
                            strLogText = strLogText.Replace("[@SettlementAction]", "Settled account")
                            strLogText = strLogText.Replace("[@SettlementDueDate]", "Due by " & offer.SettlementDueDate.ToString)
                            strLogText = strLogText.Replace("[@AdditionalMsg]", "")
                        Case 1
                            strLogText = strLogText.Replace("[@SettlementAction]", "Rejected settlement " & offer.OfferDirection)
                            strLogText = strLogText.Replace("[@SettlementDueDate]", "")
                            strLogText = strLogText.Replace("[@AdditionalMsg]", "")
                    End Select
                    Exit Do
                Loop

                If offer.SettlementSessionGUID.ToString = "" Then
                    offer.SettlementSessionGUID = NoteHelper.InsertNote(strLogText, SessionUserID, offer.ClientID)
                Else
                    NoteHelper.AppendNote(offer.SettlementSessionGUID, strLogText, SessionUserID)
                End If
            Else
                If offer.SettlementSessionGUID.ToString = "" Then
                    offer.SettlementSessionGUID = NoteHelper.InsertNote("Error generating note text for settlement " & intSettlementID, SessionUserID, offer.ClientID)
                Else
                    NoteHelper.AppendNote(offer.SettlementSessionGUID, "Error generating note text for settlement " & intSettlementID, SessionUserID)
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

    Public Function UpdateCurrentCreditor(ByVal intAccountID As Integer, ByVal intCreditorID As Integer, ByVal intCreatedBy As Integer) As Integer
        'Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_NegotiationUpdateCurrentCreditor")
        Dim intNewCreditorInstanceID As Integer = -1
        Dim myParams As New List(Of SqlParameter)
        myParams.Add(New SqlParameter("AccountID", intAccountID))
        myParams.Add(New SqlParameter("CreditorID", intCreditorID))
        myParams.Add(New SqlParameter("CreatedBy", intCreatedBy))

        Try
            intNewCreditorInstanceID = SqlHelper.ExecuteScalar("stp_NegotiationUpdateCurrentCreditor", CommandType.StoredProcedure, myParams.ToArray)
        Catch ex As Exception
            Throw ex
        End Try

        Return intNewCreditorInstanceID
    End Function

    Public Sub UpdateSettlement(ByVal RegisterId As Integer, ByVal SettlementId As String)
        Drg.Util.DataAccess.DataHelper.FieldUpdate("tblSettlements", "SettlementRegisterHoldID", RegisterId, "SettlementID = " & SettlementId)
    End Sub

    Private Shared Sub UpdateProperty(ByVal Name As String, ByVal Value As String, ByVal UserID As Integer)
        Dim sqlUpdate As New StringBuilder
        sqlUpdate.Append("Update tblProperty SET ")
        sqlUpdate.AppendFormat("Value = '{0}',", Value)
        sqlUpdate.AppendFormat("LastModified = '{0}',", Now)
        sqlUpdate.AppendFormat("LastModifiedBy = '{0}' ", UserID)
        sqlUpdate.AppendFormat("WHERE Name = '{0}'", Name)
        SqlHelper.ExecuteNonQuery(sqlUpdate.ToString, CommandType.Text)
    End Sub

    ''' <summary>
    ''' Inserts a Matter of Type Settlement, adds a Task of Type Client Approval 
    ''' Make Fee Adjustments
    ''' </summary>
    ''' <param name="clientId">Client associated with the settlement</param>
    ''' <param name="settlementId">An Integer to uniquely identify the settlement</param>
    ''' <param name="creditorAcctId">Creditor AccountId of the settlement</param>
    ''' <returns>An Integer representing if the transaction was successful</returns>
    ''' <remarks>Puts the settlement in ClientAlerts queue.Assigns AttorneyId for Attorney Portal</remarks>
    ''' Private Function InsertMatterAndTask(ByVal clientId As Integer, ByVal settlementId As Integer, ByVal creditorAcctId As Integer, Optional ByVal TaskTypeText As String = "Client Approval") As Integer
    Public Shared Function InsertMatterAndTask(ByVal clientId As Integer, ByVal settlementId As Integer, ByVal creditorAcctId As Integer, ByVal CurrentUserID As Integer) As Integer
        Return InsertMatterAndTask(clientId, settlementId, creditorAcctId, 51, "Client Approval", CurrentUserID)
    End Function

    Public Shared Function InsertMatterAndTask(ByVal clientId As Integer, ByVal settlementId As Integer, ByVal creditorAcctId As Integer, ByVal MatterSubStatusId As Integer, ByVal TaskTypeText As String, ByVal CurrentUserID As Integer) As Integer
        'Adjust settlement Fee
        Dim settDesc As String = "Settlement - "
        Dim settFeeDesc As String = "Settlement Fee - "
        Dim adjustedDesc As String = "Fee Adjustment - "
        Dim DelDesc As String = "Delivery Fee - "
        Dim Desc As String
        Dim ssqlDesc As String = String.Format("Select SettlementAmount,SettlementFee,DeliveryAmount,DeliveryMethod,AdjustedSettlementFee,SettlementDueDate,isclientstipulation from tblsettlements where settlementid = {0}", settlementId)
        Dim settAMount As Double = 0
        Dim settFee As Double = 0
        Dim delAmount As Double = 0
        Dim delMethod As String = ""
        Dim adjustedFee As Double = 0
        Using dt As DataTable = SqlHelper.GetDataTable(ssqlDesc, CommandType.Text)
            For Each Row As DataRow In dt.Rows
                settAMount = CDbl(Row("SettlementAmount").ToString)
                settFee = CDbl(Row("SettlementFee").ToString)
                delAmount = CDbl(Row("DeliveryAmount").ToString)
                delMethod = Row("DeliveryMethod").ToString
                adjustedFee = CDbl(Row("AdjustedSettlementFee").ToString)
                Exit For
            Next
        End Using

        Desc = SettlementMatterHelper.GetSettRegisterEntryDesc(creditorAcctId)
        settDesc += Desc
        settFeeDesc += Desc
        adjustedDesc += Desc
        DelDesc += Desc

        SettlementFeeHelper.AdjustSettlementFee(settlementId, clientId, CurrentUserID, creditorAcctId)

        SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, 18, settDesc, (Math.Abs(settAMount) * -1), CurrentUserID, True, -1, False, Nothing)
        SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, 4, settFeeDesc, (Math.Abs(settFee) * -1), CurrentUserID, True, -1, False, Nothing)

        If delAmount <> 0 Then
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, IIf(delMethod.Equals("chk"), 6, 28), DelDesc, (Math.Abs(delAmount) * -1), CurrentUserID, True, -1, False, Nothing)
        End If

        If adjustedFee <> 0 Then
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, -2, adjustedDesc, (adjustedFee * -1), CurrentUserID, True, -1, False, Nothing)
        End If

        'Add Matter
        Dim ret As Integer

        Using settinfo As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(settlementId)
            '*******************************************
            Dim currentMatterID As Integer
            Dim userName As String = UserHelper.GetName(CurrentUserID)

            'close existing matters
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("clientid", settinfo.SettlementClientID))
            params.Add(New SqlParameter("accountid", settinfo.SettlementCreditorAccountID))
            SqlHelper.ExecuteNonQuery("stp_settlements_CloseExistingMattersForAccount", CommandType.StoredProcedure, params.ToArray)

            'update calc
            ret = matter_UpdateSettlementCalculations(delAmount, delMethod, adjustedFee, settinfo.SettlementID, CurrentUserID)

            'create matter
            currentMatterID = matter_CreateMatterForSettlement(settinfo.SettlementID, settinfo.SettlementCreditorAccountID, MatterSubStatusId, settinfo.SettlementClientID, userName, CurrentUserID)

            'create task
            Dim newTaskID As Integer = matter_InsertTasksForMatter(settinfo.SettlementClientID, settinfo.SettlementDueDate, TaskTypeText, currentMatterID, CurrentUserID)

            matter_InsertAlertsForMatter(settinfo.SettlementID, settinfo.SettlementCreditorAccountID, settinfo.SettlementClientID, TaskTypeText, currentMatterID, userName, CurrentUserID)
            '*******************************************

        End Using

        Return ret 'returnParam.Value
    End Function


    Private Shared Function matter_CreateMatterForSettlement(ByVal settlementID As Integer, ByVal SettlementCreditorAccountID As Integer, _
        ByVal MatterSubStatusId As Integer, ByVal dataClientID As Integer, ByRef userName As String, ByVal CurrentUserID As Integer) As Integer
        Dim attID As String = SqlHelper.ExecuteScalar(String.Format("SELECT isnull(a.AttorneyId,-1)[AttorneyId] FROM tblClient c with(nolock) " & _
                                                                     "Inner Join tblPerson p with(nolock) ON c.PrimaryPersonId = p.PersonId " & _
                                                                     "Inner Join tblState s with(nolock) ON s.StateId = p.StateId " & _
                                                                     "left Join tblCompanyStatePrimary a with(nolock) ON a.CompanyId = c.CompanyId " & _
                                                                     "And s.Abbreviation = a.State Where c.ClientId = {0}", dataClientID), CommandType.Text)
        '5.10.12.ug
        'if no attorneyid set to -1
        If String.IsNullOrEmpty(attID) Then
            attID = -1
        End If
        'insert matter
        Dim currentMatterID As Integer = -1
        Dim NewMatterID As Double = SqlHelper.ExecuteScalar("SELECT max(MatterId)+1 FROM tblMatter with(nolock)", CommandType.Text)
        Dim sqlMatter As String = "INSERT INTO tblMatter(ClientId, MatterStatusCodeId, MatterNumber,MatterDate, MatterMemo, CreatedDateTime, CreatedBy, " & _
        "CreditorInstanceId, AttorneyId, MatterTypeId, IsDeleted, MatterStatusId, MatterSubStatusId) VALUES ("
        sqlMatter += String.Format("{0},23,", dataClientID)
        sqlMatter += String.Format("{0},", FormatNumber(NewMatterID, 0, TriState.False, TriState.False, TriState.False))
        sqlMatter += String.Format("'{0}','Generating a matter for the settlement',", Now)
        sqlMatter += String.Format("'{0}',{1},", Now, CurrentUserID)
        sqlMatter += String.Format("{0},{1},3,0,3,{2}); select SCOPE_IDENTITY();", AccountHelper.GetCurrentCreditorInstanceID(SettlementCreditorAccountID), attID, MatterSubStatusId)
        currentMatterID = SqlHelper.ExecuteScalar(sqlMatter, CommandType.Text)
        SqlHelper.ExecuteNonQuery(String.Format("UPDATE tblmatter SET matternumber = matterid where matterid = {0}", currentMatterID), CommandType.Text)

        'associate matter w/ sett
        Dim sqlUpdate As String = String.Format("UPDATE tblSettlements SET MatterId = {0},LocalCounselId = {1},LastModified = getdate(),LastModifiedBy = {2} WHERE SettlementId = {3}", currentMatterID, attID, CurrentUserID, settlementID)
        SqlHelper.ExecuteNonQuery(sqlUpdate, CommandType.Text)

        'insert note
        Dim CredName As String = ""
        Using si As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(settlementID)
            CredName = SqlHelper.ExecuteScalar(String.Format("select name from tblcreditor where creditorid = {0}", si.SettlementCreditorID), CommandType.Text)
        End Using

        Dim sNote As String = String.Format("Generated a Matter for the settlement with {0} by {1} on {2}", CredName, userName, Now)
        Dim noteID As Integer = NoteHelper.InsertNote(sNote, CurrentUserID, dataClientID)
        NoteHelper.RelateNote(noteID, 1, dataClientID)
        NoteHelper.RelateNote(noteID, 2, SettlementCreditorAccountID)
        NoteHelper.RelateNote(noteID, 19, currentMatterID)

        'insert roadmap
        Dim sqlRoad As String = "INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created) VALUES("
        sqlRoad += String.Format("{0}, {1}, {2}, {3}, getdate())", settlementID, "23", noteID, CurrentUserID)
        SqlHelper.ExecuteNonQuery(sqlRoad, CommandType.Text)

        Return currentMatterID
    End Function

    Private Shared Sub matter_InsertAlertsForMatter(ByVal SettlementID As Integer, ByVal SettlementCreditorAccountID As Integer, ByVal dataClientID As Integer, ByVal TaskTypeText As String, ByVal currentMatterID As Integer, ByVal userName As String, ByVal CurrentUserID As Integer)
        'insert client alerts
        Dim aNote As String = String.Format("{0} created a task of type {1} on {2}", userName, TaskTypeText, Now)
        Dim aNoteID As Integer = NoteHelper.InsertNote(aNote, CurrentUserID, dataClientID)
        NoteHelper.RelateNote(aNoteID, 1, dataClientID)
        NoteHelper.RelateNote(aNoteID, 2, SettlementCreditorAccountID)
        NoteHelper.RelateNote(aNoteID, 19, currentMatterID)
    End Sub

    Private Shared Function matter_InsertTasksForMatter(ByVal dataClientid As Integer, ByVal SettlementDueDate As String, _
                                                        ByVal TaskTypeText As String, ByVal currentMatterID As Integer, _
                                                        ByVal CurrentUserID As Integer) As Integer
        Dim TaskTypeId As Integer = DataHelper.FieldLookupIDs("tblTaskType", "TaskTypeId", String.Format("[Name] = '{0}'", TaskTypeText))(0)
        'insert task for matter

        Dim sqlTask As String = "INSERT INTO tblTask(TaskTypeId, [Description], Due, TaskResolutionId, Created,CreatedBy, LastModified, " & _
                                "LastModifiedBy, AssignedTo,matterid) VALUES("
        sqlTask += String.Format("{0},", TaskTypeId)
        sqlTask += String.Format("'{0}',", TaskTypeText)
        sqlTask += String.Format("'{0}',", SettlementDueDate)
        sqlTask += String.Format("NULL,getdate(),{0},getdate(),{0},0,{1}); select SCOPE_IDENTITY();", CurrentUserID, currentMatterID)
        Dim newTaskID As Integer = SqlHelper.ExecuteScalar(sqlTask, CommandType.Text)

        'insert client task
        Dim sqlCT As String = String.Format("INSERT INTO tblClientTask(ClientId,TaskId,Created,CreatedBy,LastModified,LastModifiedBy) " & _
                                            "VALUES({0}, {1}, getdate(), {2}, getdate(), {2})", dataClientid, newTaskID, CurrentUserID)
        SqlHelper.ExecuteNonQuery(sqlCT, CommandType.Text)

        'associate with matter still
        Dim sqlMT As String = String.Format("Select * from tblmattertask where matterid = {0}", currentMatterID)
        Dim dtMT As DataTable = SqlHelper.GetDataTable(sqlMT, CommandType.Text)
        If dtMT.Rows.Count > 0 Then
            Dim sqlAssoc As String = String.Format("update tblMatterTask set taskid = {0} where matterid = {1}", newTaskID, currentMatterID)
            SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
        Else
            Dim sqlAssoc As String = String.Format("INSERT INTO tblMatterTask(MatterId, TaskId) VALUES({0}, {1})", currentMatterID, newTaskID)
            SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
        End If
        SettlementMatterHelper.UpdateMatterCurrentTaskID(currentMatterID, newTaskID)
        Return newTaskID
    End Function

    Private Shared Function matter_UpdateSettlementCalculations(ByVal delAmount As Double, ByVal delMethod As String, _
                                                                ByVal adjustedFee As Double, ByVal SettlementID As Integer, _
                                                                ByVal CurrentUserID As Integer) As Integer
        Dim ret As Integer
        Dim sqlCalc As String = "stp_UpdateSettlementCalculations"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("settlementid", SettlementID))
        params.Add(New SqlParameter("CreatedBy", CurrentUserID))
        params.Add(New SqlParameter("DeliveryMethod", delMethod))
        params.Add(New SqlParameter("DeliveryAmount", delAmount))
        params.Add(New SqlParameter("AdjustedFee", adjustedFee))
        ret = SqlHelper.ExecuteScalar(sqlCalc, CommandType.StoredProcedure, params.ToArray)
        Return ret
    End Function
    #End Region 'Methods

    #Region "Nested Types"

    Public Structure OfferInformation

        #Region "Fields"

        Public AcceptanceStatus As OfferAcceptanceStatus
        Public AccountID As Integer
        Public AvailSDA As Double
        Public AdjustedSettlementFee As Double
        Public BankReserve As Double
        Public ClientID As Integer
        Public IsClientStipulation As Boolean
        Public CreditorAccountBalance As Double
        Public CurrentSettlementStatusID As Integer
        Public DeliveryAmount As Double
        Public DeliveryMethod As String
        Public FrozenAmount As Double
        Public IsRestrictiveEndorsement As Boolean
        Public MatterId As Integer
        Public MatterStatusCode As String
        Public MatterStatusCodeId As Integer
        Public MatterSubStatus As String
        Public MatterSubStatusId As Integer
        Public OfferDirection As String
        Public OvernightDeliveryFee As Double
        Public PFOBalance As Double
        Public RegisterBalance As Double
        Public RegisterHoldID As Integer
        Public Roadmap As Dictionary(Of Integer, OfferRoadmap)
        Public SDABalance As Double
        Public SettlementAmount As Double
        Public SettlementAmountAvailable As Double
        Public SettlementAmountOwed As Double
        Public SettlementAmountSent As Double
        Public SettlementCost As Double
        Public SettlementDueDate As DateTime
        Public SettlementFee As Double
        Public SettlementFeeAmountAvailable As Double
        Public SettlementFeeAmountBeingPaid As Double
        Public SettlementFeeAmountOwed As Double
        Public SettlementFeeCredit As Double
        Public SettlementID As Integer
        Public SettlementNotes As String
        Public SettlementPercent As Single
        Public SettlementSavings As Double
        Public SettlementSessionGUID As String
        Public IsPaymentArrangement As Boolean
        Public DownPaymentAmount As Double
        #End Region 'Fields

        #Region "Constructors"

        'Public Sub New(ByVal _SettlementID As Integer, ByVal _AccountID As Integer, ByVal _ClientID As Integer, _
        '               ByVal _RegisterBalance As Double, ByVal _AvailSDA As Double, ByVal _SDABalance As Double, ByVal _PFOBalance As Double, _
        '               ByVal _CreditorAccountBalance As Double, ByVal _SettlementPercent As Single, _
        '               ByVal _SettlementAmount As Double, ByVal _SettlementAmountAvailable As Double, _
        '               ByVal _SettlementAmountSent As Double, ByVal _SettlementAmountOwed As Double, ByVal _SettlementDueDate As DateTime, _
        '               ByVal _SettlementSavings As Double, ByVal _SettlementFee As Double, ByVal _AdjustedFee As Double, ByVal _SettlementFeeCredit As Double, _
        '               ByVal _OvernightDeliveryFee As Double, ByVal _DeliveryAmount As Double, ByVal _DeliveryMethod As String, _
        '               ByVal _SettlementCost As Double, ByVal _SettlementFeeAmountAvailable As Double, _
        '               ByVal _SettlementFeeAmountBeingPaid As Double, ByVal _SettlementFeeAmountOwed As Double, _
        '               ByVal _IsRestrictiveEndorsement As Boolean, ByVal _BankReserve As Double, ByVal _SettlementNotes As String, _
        '               ByVal _AcceptanceStatus As OfferAcceptanceStatus, ByVal _RegisterHoldID As Integer, _
        '    ByVal _OfferDirection As String, ByVal _SettlementSessionGUID As String, ByVal _CurrentSettlementStatusID As Integer)

        '    Me.SettlementID = _SettlementID
        '    Me.AccountID = _AccountID
        '    Me.ClientID = _ClientID
        '    Me.RegisterBalance = _RegisterBalance
        '    Me.AvailSDA = _AvailSDA
        '    Me.SDABalance = _SDABalance
        '    Me.PFOBalance = _PFOBalance
        '    Me.CreditorAccountBalance = _CreditorAccountBalance
        '    Me.SettlementPercent = _SettlementPercent
        '    Me.SettlementAmount = _SettlementAmount
        '    Me.SettlementAmountAvailable = _SettlementAmountAvailable
        '    Me.SettlementAmountSent = _SettlementAmountSent
        '    Me.SettlementAmountOwed = _SettlementAmountOwed
        '    Me.SettlementDueDate = _SettlementDueDate
        '    Me.SettlementSavings = _SettlementSavings
        '    Me.SettlementFee = _SettlementFee
        '    Me.AdjustedSettlementFee = _AdjustedFee
        '    Me.SettlementFeeCredit = _SettlementFeeCredit
        '    Me.OvernightDeliveryFee = _OvernightDeliveryFee
        '    Me.DeliveryMethod = _DeliveryMethod
        '    Me.DeliveryAmount = _DeliveryAmount
        '    Me.SettlementCost = _SettlementCost
        '    Me.SettlementFeeAmountAvailable = _SettlementFeeAmountAvailable
        '    Me.SettlementFeeAmountBeingPaid = _SettlementFeeAmountBeingPaid
        '    Me.SettlementFeeAmountOwed = _SettlementFeeAmountOwed
        '    Me.SettlementNotes = _SettlementNotes
        '    Me.AcceptanceStatus = _AcceptanceStatus
        '    Me.RegisterHoldID = _RegisterHoldID
        '    Me.OfferDirection = _OfferDirection
        '    Me.SettlementSessionGUID = _SettlementSessionGUID
        '    Me.CurrentSettlementStatusID = _CurrentSettlementStatusID
        '    Me.IsRestrictiveEndorsement = _IsRestrictiveEndorsement
        '    Me.BankReserve = _BankReserve
        '    Me.Roadmap = New Dictionary(Of Integer, OfferRoadmap)()
        'End Sub

        'Public Sub New(ByVal _AccountID As Integer, ByVal _ClientID As Integer, ByVal _RegisterBalance As Double, _
        '    ByVal _FrozenAmount As Double, ByVal _CreditorAccountBalance As Double, ByVal _SettlementPercent As Single, _
        '    ByVal _SettlementAmount As Double, ByVal _SettlementDueDate As String, ByVal _SettlementFee As Double, ByVal _OvernightDeliveryFee As Double, ByVal _SettlementCost As Double, _
        '    ByVal _SettlementFeeAmountAvailable As Double, ByVal _SettlementFeeAmountBeingPaid As Double, ByVal _SettlementFeeAmountOwed As Double, _
        '    ByVal _AcceptanceStatus As OfferAcceptanceStatus, _
        '    ByVal _OfferDirection As String, ByVal _SettlementSessionGUID As String, ByVal _CurrentSettlementStatusID As Integer, Optional ByVal _SettlementFeeCredit As Double = 0)
        '    Dim AmtAvail As Double = 0
        '    Dim AmtSent As Double = 0
        '    Dim AmtOwed As Double = 0
        '    If _RegisterBalance - _SettlementAmount > 0 Then
        '        AmtAvail = _SettlementAmount
        '        AmtSent = _SettlementAmount
        '        AmtOwed = 0
        '    Else
        '        AmtAvail = _RegisterBalance
        '        AmtSent = _RegisterBalance
        '        AmtOwed = _RegisterBalance - _SettlementAmount
        '    End If

        '    Me.AccountID = _AccountID
        '    Me.ClientID = _ClientID
        '    Me.RegisterBalance = _RegisterBalance
        '    Me.FrozenAmount = _FrozenAmount
        '    Me.CreditorAccountBalance = _CreditorAccountBalance
        '    Me.SettlementPercent = _SettlementPercent
        '    Me.SettlementAmount = _SettlementAmount
        '    Me.SettlementAmountAvailable = AmtAvail
        '    Me.SettlementAmountSent = AmtSent
        '    Me.SettlementAmountOwed = AmtOwed
        '    If IsDate(_SettlementDueDate) Then
        '        Me.SettlementDueDate = _SettlementDueDate
        '    Else
        '        Me.SettlementDueDate = CDate("1/1/1990")
        '    End If

        '    Me.SettlementSavings = _CreditorAccountBalance - _SettlementAmount
        '    Me.SettlementFee = _SettlementFee
        '    Me.OvernightDeliveryFee = _OvernightDeliveryFee
        '    Me.SettlementCost = _SettlementCost
        '    Me.SettlementFeeAmountAvailable = _SettlementFeeAmountAvailable
        '    Me.SettlementFeeAmountBeingPaid = _SettlementFeeAmountBeingPaid
        '    Me.SettlementFeeAmountOwed = _SettlementFeeAmountOwed
        '    Me.AcceptanceStatus = _AcceptanceStatus
        '    Me.OfferDirection = _OfferDirection
        '    Me.SettlementSessionGUID = _SettlementSessionGUID
        '    Me.CurrentSettlementStatusID = _CurrentSettlementStatusID
        '    Me.Roadmap = New Dictionary(Of Integer, OfferRoadmap)()
        '    Me.SettlementFeeCredit = _SettlementFeeCredit
        'End Sub

        #End Region 'Constructors

    End Structure

    Public Structure OfferRoadmap

        #Region "Fields"

        Public Reason As String
        Public RoadmapID As Integer
        Public SettlementStatusID As Integer
        Public StatusName As String

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal _RoadmapID As Integer, ByVal _SettlementStatusID As Integer, ByVal _Reason As String, ByVal _StatusName As String)
            Me.RoadmapID = _RoadmapID
            Me.SettlementStatusID = _SettlementStatusID
            Me.Reason = _Reason
            Me.StatusName = _StatusName
        End Sub

        #End Region 'Constructors

    End Structure

    #End Region 'Nested Types

End Class