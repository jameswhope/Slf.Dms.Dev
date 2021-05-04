Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Imports System.Web
Imports System.Web.Script.Serialization

Imports Microsoft.VisualBasic

Public Class PaymentScheduleHelper

    #Region "Methods"

    Public Shared Sub CreatePaymentScheduleItem(ByVal iScheduleID As Integer, _
        ByVal dataclientid As Integer, _
        ByVal accountid As Integer, _
        ByVal SettlementID As Integer, _
        ByVal paymentDate As Date, _
        ByVal amountOfPayment As Double, _
        ByVal currentUserID As Integer)
        'insert payment arrangement schedule item
        Dim payArrangeID As Integer = InsertUpdatePaymentSchedule(iScheduleID, dataclientid, accountid, SettlementID, amountOfPayment, paymentDate, currentUserID)
    End Sub

    Public Shared Sub DeletePaymentPlan(ByVal iSettlementID As Integer)
        'delete all plan entries
        Dim ssql As String = String.Format("delete from tblpaymentschedule where settlementid = {0} and PmtRecdDate is null", iSettlementID)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
    End Sub

    Public Shared Function GetSettlementFee(ByVal settlementid As Integer) As Integer
        Dim ssql As String = String.Format("select top 1 s.settlementfee from tblsettlements s where settlementid = {0} ", settlementid)
        Return SqlHelper.ExecuteScalar(ssql, CommandType.Text)
    End Function

    Public Shared Function InsertUpdatePaymentSchedule(ByVal iPmtScheduleID As Integer, _
        ByVal iDataClientID As Integer, _
        ByVal iAccountID As Integer, _
        ByVal iSettlementID As Integer, _
        ByVal iamountOfPayment As Double, _
        ByVal iPaymentDate As Date, _
        ByVal iUserID As Integer) As Integer
        Try
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("PmtScheduleID", iPmtScheduleID))
            params.Add(New SqlParameter("ClientID", iDataClientID))
            params.Add(New SqlParameter("AccountID", iAccountID))
            params.Add(New SqlParameter("SettlementID", iSettlementID))
            params.Add(New SqlParameter("PmtDate", iPaymentDate))
            params.Add(New SqlParameter("PmtAmount", iamountOfPayment))
            params.Add(New SqlParameter("userid", iUserID))

            Return SqlHelper.ExecuteScalar("stp_paymentarrangement_InsertUpdate", Data.CommandType.StoredProcedure, params.ToArray)

        Catch ex As Exception
            Throw
        End Try
    End Function

    Public Shared Sub UpdatePaymentScheduleRegisterID(ByVal registerid As Integer, ByVal PmtScheduleID As Integer, ByVal UserID As Integer)
        Dim ssql = String.Format("UPDATE tblPaymentSchedule set registerid = {0}, lastmodified = Getdate(), lastmodifiedby = {2} WHERE PmtScheduleID = {1}", registerid, PmtScheduleID, UserID)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
    End Sub

    Public Shared Function GetSettlementScheduledPayments(ByVal SchedPaymentId As Nullable(Of Integer), ByVal DateFrom As Nullable(Of DateTime), ByVal DateTo As Nullable(Of DateTime), ByVal CompanyId As Nullable(Of Integer)) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If DateFrom.HasValue Then
            param = New SqlParameter("@PaymentDateFrom", SqlDbType.DateTime)
            param.Value = DateFrom.Value
            params.Add(param)
        End If

        If DateTo.HasValue Then
            param = New SqlParameter("@PaymentDateTo", SqlDbType.DateTime)
            param.Value = DateTo.Value
            params.Add(param)
        End If

        If CompanyId.HasValue Then
            param = New SqlParameter("@CompanyId", SqlDbType.Int)
            param.Value = CompanyId.Value
            params.Add(param)
        End If

        If SchedPaymentId.HasValue Then
            param = New SqlParameter("@PaymentScheduleId", SqlDbType.Int)
            param.Value = SchedPaymentId.Value
            params.Add(param)
        End If

        Return SqlHelper.GetDataTable("stp_PaymentArrangement_Report", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub UpdateRegisterCheckNumber(ByVal registerid As Integer, ByVal CheckNumber As String)
        Dim ssql = String.Format("UPDATE tblRegister set CheckNumber = '{1}' Where registerid = {0}", registerid, CheckNumber)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
    End Sub

    Public Shared Function AreAllPaymentsDone(ByVal settlementid As Integer) As Boolean
        Dim ssql = String.Format("Select count(PmtScheduleId) from tblPaymentSchedule Where settlementid = {0} and RegisterId is null", settlementid)
        Return (CInt(SqlHelper.ExecuteScalar(ssql, CommandType.Text)) = 0)
    End Function

    Public Shared Sub UpdateAccountStatus(ByVal CreditorAccountId As Integer, ByVal StatusId As Integer, ByVal UserId As Integer)
        Dim ssql = String.Format("UPDATE tblAccount set AccountStatusId = {1}, LastMofified = GetDate(), LastModifiedBy={2} Where AccountId = {0}", CreditorAccountId, StatusId)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
    End Sub

    Public Shared Sub ApprovePayment(ByVal payArrangeID As Integer, ByVal CheckNumber As String, ByVal UserID As Integer)
        'get payment arrangement fee type
        Dim payFeeTypeID As String = SqlHelper.ExecuteScalar("SELECT top 1 EntryTypeId from tblEntryType where Name = 'Payment Arrangement Fee'", CommandType.Text)
        Dim dt As DataTable = GetSettlementScheduledPayments(payArrangeID, Nothing, Nothing, Nothing)
        If dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            'insert tblRegister entry for payment arrangement

            Dim registerID As Integer = Drg.Util.DataHelpers.RegisterHelper.InsertFee(RegisterSetID:=Nothing, _
                                                          ClientID:=dr("ClientId"), _
                                                          AccountID:=dr("AccountID"), _
                                                          TransactionDate:=dr("DueDate"), _
                                                          Description:="Settlement Payment Arrangement - " & dr("CurrentCreditor") & " #" & dr("Last4"), _
                                                          Amount:=dr("CheckAmount"), _
                                                          EntryTypeID:=payFeeTypeID, _
                                                          MediatorID:=UserID, _
                                                          FeeMonth:=CDate(dr("DueDate")).Month, _
                                                          FeeYear:=CDate(dr("DueDate")).Year, _
                                                          CreatedBy:=UserID, _
                                                          DoCleanUp:=True)

            'Update Check NUmber
            UpdateRegisterCheckNumber(registerID, CheckNumber)

            'insert pay arrange fee
            Dim payRegisterID As Integer = Drg.Util.DataHelpers.RegisterHelper.InsertFee(RegisterSetID:=registerID, _
                                                        ClientID:=dr("ClientId"), _
                                                        AccountID:=dr("AccountID"), _
                                                        TransactionDate:=dr("DueDate"), _
                                                        Description:="Settlement Payment Arrangement Fee", _
                                                        Amount:=dr("SettlementFee"), _
                                                        EntryTypeID:=4, _
                                                        MediatorID:=UserID, _
                                                        FeeMonth:=CDate(dr("DueDate")).Month, _
                                                        FeeYear:=CDate(dr("DueDate")).Year, _
                                                        CreatedBy:=UserID, _
                                                        DoCleanUp:=True)

            If dr("OvernightDeliveryFee") > 0 Then

                'Insert Delivery Fee
                Dim delRegisterID As Integer = Drg.Util.DataHelpers.RegisterHelper.InsertFee(RegisterSetID:=registerID, _
                                                           ClientID:=dr("ClientId"), _
                                                           AccountID:=dr("AccountID"), _
                                                           TransactionDate:=dr("DueDate"), _
                                                           Description:="Settlement Payment Arrangement Delivery Fee", _
                                                           Amount:=dr("OvernightDeliveryFee"), _
                                                           EntryTypeID:=6, _
                                                           MediatorID:=UserID, _
                                                           FeeMonth:=CDate(dr("DueDate")).Month, _
                                                           FeeYear:=CDate(dr("DueDate")).Year, _
                                                           CreatedBy:=UserID, _
                                                           DoCleanUp:=True)
            End If

            'update pay schedule
            UpdatePaymentScheduleRegisterID(registerID, payArrangeID, UserID)

            'Change Creditor Account Status
            Dim statusId As Integer

            If AreAllPaymentsDone(dr("settlementId")) Then
                statusId = 54 'Settled Account
            Else
                statusId = 173 'Payment Arrangement
            End If

            UpdateAccountStatus(dr("AccountId"), statusId, UserID)
        Else
            Throw New Exception("Cannot get scheduled payment")
        End If

    End Sub

    Public Shared Function GetSettlementData(ByVal settlementid As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select top 1 creditoraccountid, clientid,settlementamount from tblsettlements where settlementid = {0}", settlementid), Data.CommandType.Text)
    End Function

    Public Shared Function GetSettlementData(ByVal dataclientid As Integer, ByVal accountid As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select top 1 SettlementDueDate,SettlementAmount,SettlementFee from tblsettlements s where s.ClientID={0} AND CreditorAccountID={1} and Status = 'a' and Active = 1 and IsPaymentArrangement = 1 ORDER by s.Created DESC ", dataclientid, accountid), Data.CommandType.Text)
    End Function

    Public Shared Function GetActivePASettlement(ByVal DataClientId As Integer, ByVal AccountId As Integer) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar(String.Format("select top 1 s.settlementid from tblsettlements s  where s.ClientID={0} AND CreditorAccountID={1} and Status = 'a' and Active = 1 and IsPaymentArrangement = 1", DataClientId, AccountId), CommandType.Text))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetPaymentScheduleData(ByVal SettlementId As Integer) As DataTable
        Dim sb As New StringBuilder
        sb.Append("select s.settlementamount,s.Created,sum(ps.PmtAmount)[InstallmentTotal] from tblsettlements s inner join tblPaymentSchedule ps on ps.SettlementID=s.SettlementID ")
        sb.AppendFormat("where s.SettlementID = {0} and IsPaymentArrangement = 1 ", SettlementId)
        sb.Append("GROUP by s.settlementamount,s.Created ")
        sb.Append("ORDER by s.Created DESC")
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text)
    End Function

    Public Shared Function GetAccountNumber(ByVal dataclientid As Integer) As String
        Return SqlHelper.ExecuteScalar(String.Format("select accountnumber from tblclient where clientid = {0}", dataclientid), CommandType.Text)
    End Function

    'Payment Arrangement Calculator Functions
    Public Shared Function GetPACalculatorSet(ByVal DataClientId As Integer, ByVal AccountId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select top 1 c.* from tblPACalc c where c.ClientID={0} AND c.AccountID={1} and c.Deleted is null ORDER by c.Created desc", dataclientid, accountid), Data.CommandType.Text)
    End Function

    Public Shared Function GetPACalculatorSet(ByVal PASessionId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select c.* from tblPACalc c where c.PASessionID={0}", PASessionId), Data.CommandType.Text)
    End Function

    Public Shared Function GetPACalculatorDetails(ByVal PASessionId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select paymentnumber = row_number() over (order by d.PaymentDueDate), d.* from tblPACalcDetail d where d.PASessionId = {0} and d.deleted is null order By d.PaymentDueDate", PASessionId), Data.CommandType.Text)
    End Function

    Public Shared Function InsertPACalculatorSet(ByVal DataClientId As Integer, ByVal AccountId As Integer, ByVal SettlementAmount As Decimal, ByVal StartDate As Nullable(Of DateTime), ByVal PlanType As Integer, ByVal Lumpsum As Nullable(Of Decimal), ByVal InstallmentMethod As Nullable(Of Integer), ByVal InstallmentAmount As Nullable(Of Decimal), ByVal InstallmentCount As Nullable(Of Integer), ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = DataClientId
        params.Add(param)

        param = New SqlParameter("@AccountID", SqlDbType.Int)
        param.Value = AccountId
        params.Add(param)

        param = New SqlParameter("@SettlementAmount", SqlDbType.Money)
        param.Value = SettlementAmount
        params.Add(param)

        If StartDate.HasValue Then
            param = New SqlParameter("@StartDate", SqlDbType.DateTime)
            param.Value = StartDate.Value
            params.Add(param)
        End If

        param = New SqlParameter("@PlanType", SqlDbType.Int)
        param.Value = PlanType
        params.Add(param)

        If Lumpsum.HasValue Then
            param = New SqlParameter("@LumpSumAmount", SqlDbType.Money)
            param.Value = Lumpsum.Value
            params.Add(param)
        End If

        If InstallmentMethod.HasValue Then
            param = New SqlParameter("@InstallmentMethod", SqlDbType.Int)
            param.Value = InstallmentMethod.Value
            params.Add(param)
        End If

        If InstallmentAmount.HasValue Then
            param = New SqlParameter("@InstallmentAmount", SqlDbType.Money)
            param.Value = InstallmentAmount.Value
            params.Add(param)
        End If

        If InstallmentCount.HasValue Then
            param = New SqlParameter("@InstallmentCount", SqlDbType.Int)
            param.Value = InstallmentCount.Value
            params.Add(param)
        End If

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_PaymentArrangement_InsertCalculatorSession", CommandType.StoredProcedure, params.ToArray))

    End Function

    Public Shared Function UpdatePACalculatorSet(ByVal PASessionId As Integer, ByVal SettlementAmount As Decimal, ByVal StartDate As Nullable(Of DateTime), ByVal PlanType As Integer, ByVal Lumpsum As Nullable(Of Decimal), ByVal InstallmentMethod As Nullable(Of Integer), ByVal InstallmentAmount As Nullable(Of Decimal), ByVal InstallmentCount As Nullable(Of Integer), ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@PASessionID", SqlDbType.Int)
        param.Value = PASessionID
        params.Add(param)

        param = New SqlParameter("@SettlementAmount", SqlDbType.Money)
        param.Value = SettlementAmount
        params.Add(param)

        If StartDate.HasValue Then
            param = New SqlParameter("@StartDate", SqlDbType.DateTime)
            param.Value = StartDate.Value
            params.Add(param)
        End If

        param = New SqlParameter("@PlanType", SqlDbType.Int)
        param.Value = PlanType
        params.Add(param)

        If Lumpsum.HasValue Then
            param = New SqlParameter("@LumpSumAmount", SqlDbType.Money)
            param.Value = Lumpsum.Value
            params.Add(param)
        End If

        If InstallmentMethod.HasValue Then
            param = New SqlParameter("@InstallmentMethod", SqlDbType.Int)
            param.Value = InstallmentMethod.Value
            params.Add(param)
        End If

        If InstallmentAmount.HasValue Then
            param = New SqlParameter("@InstallmentAmount", SqlDbType.Money)
            param.Value = InstallmentAmount.Value
            params.Add(param)
        End If

        If InstallmentCount.HasValue Then
            param = New SqlParameter("@InstallmentCount", SqlDbType.Int)
            param.Value = InstallmentCount.Value
            params.Add(param)
        End If

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_PaymentArrangement_UpdateCalculatorSession", CommandType.StoredProcedure, params.ToArray))

    End Function

    Public Shared Function DeletePACalculatorSet(ByVal PASessionId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@PASessionID", SqlDbType.Int)
        param.Value = PASessionId
        params.Add(param)

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_PaymentArrangement_DeleteCalculatorSession", CommandType.StoredProcedure, params.ToArray))

    End Function

    Public Shared Function InsertPACustomDetail(ByVal PASessionId As Integer, ByVal PaymentDueDate As DateTime, ByVal PaymentAmount As Decimal, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@PASessionID", SqlDbType.Int)
        param.Value = PASessionId
        params.Add(param)

        param = New SqlParameter("@PaymentDueDate", SqlDbType.DateTime)
        param.Value = PaymentDueDate
        params.Add(param)

        param = New SqlParameter("@PaymentAmount", SqlDbType.Money)
        param.Value = PaymentAmount
        params.Add(param)

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_PaymentArrangement_InsertCustomDetail", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Sub UpdatePACustomDetail(ByVal PADetailId As Integer, ByVal PaymentDueDate As DateTime, ByVal PaymentAmount As Decimal, ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@PADetailID", SqlDbType.Int)
        param.Value = PADetailId
        params.Add(param)

        param = New SqlParameter("@PaymentDueDate", SqlDbType.DateTime)
        param.Value = PaymentDueDate
        params.Add(param)

        param = New SqlParameter("@PaymentAmount", SqlDbType.Money)
        param.Value = PaymentAmount
        params.Add(param)

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteScalar("stp_PaymentArrangement_UpdateCustomDetail", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub DeletePACustomDetail(ByVal PAdetailId As Integer, ByVal UserId As Integer)
        Dim sqlStr As String = String.Format("Update tblPACalcDetail Set Deleted = GetDate(), DeletedBy = {1} Where PAdetailid = {0}", PAdetailId, UserId)
        SqlHelper.ExecuteNonQuery(sqlStr, CommandType.Text)
    End Sub

    Public Shared Sub DeleteAllPACustomDetail(ByVal PASessionId As Integer, ByVal UserId As Integer)
        Dim sqlStr As String = String.Format("Update tblPACalcDetail Set Deleted = GetDate(), DeletedBy = {1} Where PAsessionid = {0}", PASessionId, UserId)
        SqlHelper.ExecuteNonQuery(sqlStr, CommandType.Text)
    End Sub

    Public Shared Sub SetPASessionCustom(ByVal PASessionId As Integer, ByVal Custom As Boolean, ByVal userid As Integer)
        Dim sqlStr As String = String.Format("Update tblPACalc Set Custom = {1}, LastModified = GetDate(), LastModifiedBy = {2} Where PAsessionid = {0}", PASessionId, IIf(Custom, 1, 0), userid)
        SqlHelper.ExecuteNonQuery(sqlStr, CommandType.Text)
    End Sub

    Public Shared Sub UpdatePASessionCustomSettlementAmount(ByVal PASessionId As Integer, ByVal SettlementAmount As Decimal, ByVal userid As Integer)
        Dim sqlStr As String = String.Format("Update tblPACalc Set SettlementAmount = {1}, LastModified = GetDate(), LastModifiedBy = {2} Where PAsessionid = {0}", PASessionId, SettlementAmount, userid)
        SqlHelper.ExecuteNonQuery(sqlStr, CommandType.Text)
    End Sub

    Public Shared Function ReadPaymentsJSON(ByVal json As String) As List(Of PaymentArrangementJson)
        Dim ser As New JavaScriptSerializer()
        Dim l As List(Of PaymentArrangementJson) = ser.Deserialize(Of List(Of PaymentArrangementJson))(json)
        Return l
    End Function

    Public Shared Function CreatePaymentArrangements(ByVal SettlementId As Integer, ByVal PASessionId As Integer, ByVal payments As String) As Boolean
        Dim lpayments As List(Of PaymentScheduleHelper.PaymentArrangementJson) = PaymentScheduleHelper.ReadPaymentsJSON(payments)
        If SettlementId = -1 Then
            Throw New Exception("SettlementId is missing!")
        End If

        Dim userid = CInt(HttpContext.Current.User.Identity.Name)
        Dim noteMsg As String = String.Format("A payment plan was created by {0}.", Drg.Util.DataHelpers.UserHelper.GetName(userid))
        'get accountid
        Dim AccountID As String = -1
        Dim Dataclientid As String = -1
        Dim settBal As Double = 0
        Dim dtaccount As DataTable = PaymentScheduleHelper.GetSettlementData(SettlementId)
        If dtaccount.Rows.Count > 0 Then
            AccountID = dtaccount.Rows(0)("creditoraccountid").ToString
            Dataclientid = dtaccount.Rows(0)("clientid").ToString
        Else
            Throw New Exception("Settlement info not found!")
        End If

        DeletePaymentPlan(SettlementId)

        Dim PmtScheduleID As Integer = -1
        If payments.Trim.Length > 0 Then
            For Each Payment As PaymentArrangementJson In lpayments
                PmtScheduleID = -1
                CreatePaymentScheduleItem(PmtScheduleID, Dataclientid, AccountID, SettlementId, CDate(Payment.date), CDec(Payment.amount.Replace("$", "")), userid)
            Next
        Else
            'Custom payments
            Dim dtdetails As DataTable = PaymentScheduleHelper.GetPACalculatorDetails(PASessionId)
            If dtdetails.Rows.Count > 0 Then
                For Each dr As DataRow In dtdetails.Rows
                    PmtScheduleID = -1
                    CreatePaymentScheduleItem(PmtScheduleID, Dataclientid, AccountID, SettlementId, CDate(dr("paymentduedate")), CDec(dr("paymentamount")), userid)
                Next
            End If

        End If
    End Function

    Public Shared Function ExtractFirstPADueDate(ByVal PASessionId As Integer, ByVal payments As String) As String
        Dim lpayments As List(Of PaymentScheduleHelper.PaymentArrangementJson) = PaymentScheduleHelper.ReadPaymentsJSON(payments)
        If payments.Trim.Length > 0 Then
            Return lpayments(0).date
        Else
            'Custom payments
            Dim dtdetails As DataTable = PaymentScheduleHelper.GetPACalculatorDetails(PASessionId)
            If dtdetails.Rows.Count > 0 Then
                Return dtdetails.Rows(0)("paymentduedate")
            End If
        End If
        Return ""
    End Function

    Public Shared Function GetPaymentArrangements(ByVal SettlementId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select * from vw_paymentschedule_ordered Where SettlementId = {0} ORDER BY [order]", SettlementId), CommandType.Text)
    End Function

    Public Shared Function GetPaymentScheduleByPaymentId(ByVal PaymentId As Integer) As DataTable
        Dim sb As New StringBuilder
        sb.AppendFormat("select ps.*, acc.requesttype from tblPaymentSchedule ps join tblAccount_PaymentProcessing acc on ps.PaymentProcessingId = acc.PaymentProcessingId Where acc.PaymentProcessingId = {0}", PaymentId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text)
    End Function

    Public Shared Function GetPaymentScheduleIdByPaymentId(ByVal PaymentId As Integer) As Integer
        Dim sb As New StringBuilder
        sb.AppendFormat("select ps.pmtScheduleId from tblPaymentSchedule ps join tblAccount_PaymentProcessing acc on ps.PaymentProcessingId = acc.PaymentProcessingId Where acc.PaymentProcessingId = {0}", PaymentId)
        Return CInt(SqlHelper.ExecuteScalar(sb.ToString, CommandType.Text))
    End Function

    Public Shared Sub MarkPaymentScheduleAsPaid(ByVal PaymentScheduleId As Integer, ByVal RegisterId As Integer, ByVal UserId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("update tblPaymentSchedule set registerid = {1}, PmtRecdDate = GetDate(), LastModified = GetDate(), LastModifiedBY = {2} where PmtScheduleId = {0}", PaymentScheduleId, RegisterId, UserId), CommandType.Text)
    End Sub

    Public Shared Function GetSettlementInfoPA(ByVal PmtScheduleId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("exec stp_GetSettlementInformationPA {0}", PmtScheduleId), CommandType.Text)
    End Function

    Public Shared Function GetDistinctRestofPaymentVars(ByVal SettlementID As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select installmentcount = count(pmtScheduleId), distinctamountcount = count(distinct pmtamount), distinctmonthcount  = count(distinct month(pmtdate)), distinctdaycount    = count(distinct day(pmtdate)) from vw_paymentschedule_ordered  where SettlementID = {0}  and [order] > 1", SettlementID), CommandType.Text)
    End Function

    Public Shared Function GetScheduleAuthorizationScript(ByVal settlementId As Integer, ByVal LanguageId As Integer) As String
        Dim dt As DataTable = PaymentScheduleHelper.GetPaymentArrangements(settlementId)
        'Get installments distinct values, excluding down payment
        Dim vars As DataRow = GetDistinctRestofPaymentVars(settlementId).Rows(0)
        If vars("installmentcount") = 0 Then Return ""
        'There must be installments to show
        If vars("distinctamountcount") = 1 _
            And vars("distinctdaycount") = 1 _
                And vars("installmentcount") = vars("distinctmonthcount") Then
            Dim distinctamount As Decimal = dt.Rows(1)("pmtamount")
            Dim distinctday As Integer = Day(dt.Rows(1)("pmtdate"))
            If LanguageId = 1 Then
                Return String.Format(" {0} monthly payments of {1:c} due on the day {2} of the month", vars("installmentcount"), distinctamount, distinctday)
            Else
                Return String.Format(" {0} pagos mensuales de {1:c} el dia {2} de cada mes", vars("installmentcount"), distinctamount, distinctday)
            End If
        Else
            'Build Payment Table Here
            Dim pct As String
            If dt.Rows.Count > 11 Then
                pct = "100"
            ElseIf dt.Rows.Count > 6 Then
                pct = "80"
            Else
                pct = "50"
            End If
            Dim sb As New StringBuilder
            sb.AppendFormat("<div class=""pmtContainer""><div class=""pmtTable"" style=""width:{0}% !important;"">", pct)
            For Each dr As DataRow In dt.Rows
                If dr("order") > 1 Then
                    sb.Append("<div class=""pmtrow"">")
                    sb.AppendFormat("<div class=""pmtposition"">{0}.</div>", dr("order"))
                    sb.AppendFormat("<div class=""pmtdate"">{0:MM/dd/yy}</div>", dr("pmtdate"))
                    sb.AppendFormat("<div class=""pmtamount"">{0:c}</div>", dr("pmtamount"))
                    sb.Append("</div>")
                End If
            Next
            sb.Append("</div>")
            Return sb.ToString
        End If

    End Function

    Public Shared Function GetPaymentScheduleReportBySettlement(ByVal SettlementId As Integer) As DataSet
        Return SqlHelper.GetDataSet(String.Format("exec stp_PaymentArrangement_GetInfo {0}", SettlementId), CommandType.Text)
    End Function

    Public Shared Function IsAccountSettledWithActivePA(ByVal AccountId As Integer, ByRef SettlementId As Integer?) As Boolean
        Try
            SettlementId = CInt(SqlHelper.ExecuteScalar(String.Format("exec stp_PaymentArrangement_GetSettledSettlementWithActivePmts {0}", AccountId), CommandType.Text))
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Class PaymentScheduleObject

#Region "Fields"

        Private _AccountID As Integer
        Private _ClientID As Integer
        Private _Created As Date
        Private _CreatedBy As Integer
        Private _LastModified As Date
        Private _LastModifiedBy As Integer
        Private _PmtAmount As Single
        Private _PmtDate As Date
        Private _PmtRecdDate As Date
        Private _PmtScheduleID As Integer
        Private _SettlementID As Integer

#End Region 'Fields

#Region "Properties"

        Public Property AccountID() As Integer
            Get
                Return _AccountID
            End Get
            Set(ByVal Value As Integer)
                _AccountID = Value
            End Set
        End Property

        Public Property ClientID() As Integer
            Get
                Return _ClientID
            End Get
            Set(ByVal Value As Integer)
                _ClientID = Value
            End Set
        End Property

        Public Property Created() As Date
            Get
                Return _Created
            End Get
            Set(ByVal Value As Date)
                _Created = Value
            End Set
        End Property

        Public Property CreatedBy() As Integer
            Get
                Return _CreatedBy
            End Get
            Set(ByVal Value As Integer)
                _CreatedBy = Value
            End Set
        End Property

        Public Property LastModified() As Date
            Get
                Return _LastModified
            End Get
            Set(ByVal Value As Date)
                _LastModified = Value
            End Set
        End Property

        Public Property LastModifiedBy() As Integer
            Get
                Return _LastModifiedBy
            End Get
            Set(ByVal Value As Integer)
                _LastModifiedBy = Value
            End Set
        End Property

        Public Property PmtAmount() As Single
            Get
                Return _PmtAmount
            End Get
            Set(ByVal Value As Single)
                _PmtAmount = Value
            End Set
        End Property

        Public Property PmtDate() As Date
            Get
                Return _PmtDate
            End Get
            Set(ByVal Value As Date)
                _PmtDate = Value
            End Set
        End Property

        Public Property PmtRecdDate() As Date
            Get
                Return _PmtRecdDate
            End Get
            Set(ByVal Value As Date)
                _PmtRecdDate = Value
            End Set
        End Property

        Public Property PmtScheduleID() As Integer
            Get
                Return _PmtScheduleID
            End Get
            Set(ByVal Value As Integer)
                _PmtScheduleID = Value
            End Set
        End Property

        Public Property SettlementID() As Integer
            Get
                Return _SettlementID
            End Get
            Set(ByVal Value As Integer)
                _SettlementID = Value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class PaymentArrangementJson
        Public position As String
        Public [date] As String
        Public amount As String
    End Class

    Public Class PaymentArrangementJsonResponse
        Public status As String
        Public message As String
        Public returnData As Object
    End Class

    Public Class PASessionJson
        Public clientid As String
        Public accountid As String
        Public settlementamount As String
        Public startdate As String
        Public plantype As String
        Public lumpsum As String
        Public installmentmethod As String
        Public installmentamount As String
        Public installmentcount As String
    End Class

#End Region 'Nested Types

End Class