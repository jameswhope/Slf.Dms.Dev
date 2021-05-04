Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class LeadHelper

    Public Enum OfferType As Integer
        Debt = 10
        LoanMod = 20
        Tax = 30
        Grant = 40
        JobSearch = 50
        Bizop = 60
        Education = 70
        Unknown = 80
        Payday = 90
        Bankruptcy = 100
        AutoLoan = 110
        CreditRepair = 120
        EduSearch = 130
        EduGED = 140
    End Enum

    Public Enum Buyer As Integer
        Academix = 500
        Five9 = 501 '1on1
        Lexxiom = 502
        RGR = 503
        LegalHelpers = 504
        NewPath = 505
        ReliantSupport = 506
        ADMA = 507
        AMTASCO = 508
        Plattform = 515
        Cake = 516
    End Enum

    Public Enum TransferType As Integer
        Data
        [Call]
    End Enum

    Public Shared Function GetLead(ByVal LeadID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        Return SqlHelper.GetDataTable("stp_GetLead", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub SaveLead(ByVal LeadID As Integer, ByVal FullName As String, ByVal Address As String, ByVal City As String, ByVal StateCode As String, ByVal ZipCode As String, ByVal Email As String, ByVal AltPhone As String, ByVal ModifiedBy As Integer)
        Dim cmdText As New Text.StringBuilder
        cmdText.Append("update tblLeads set ")
        cmdText.AppendFormat("fullname = '{0}',", FullName)
        cmdText.AppendFormat("address = '{0}',", Address)
        cmdText.AppendFormat("city = '{0}',", City)
        cmdText.AppendFormat("statecode = '{0}',", StateCode)
        cmdText.AppendFormat("zipcode = '{0}',", ZipCode)
        cmdText.AppendFormat("email = '{0}',", Email)
        cmdText.AppendFormat("workphone = '{0}',", AltPhone)
        cmdText.AppendFormat("lastmodified = getdate(), lastmodifiedby = {0} ", ModifiedBy)
        cmdText.Append("where leadid = " & LeadID)
        SqlHelper.ExecuteNonQuery(cmdText.ToString, CommandType.Text)
    End Sub

    Public Shared Function InsertSubmittedOffer(ByVal LeadID As Integer, ByVal OfferID As OfferType, ByVal BuyerID As Integer, ByVal ResultCode As String, ByVal ResultDesc As String, ByVal ResultId As String, ByVal Valid As Boolean, ByVal SubmittedBy As Integer, Optional ByVal CallTransfer As Boolean = False) As Integer
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        params.Add(New SqlParameter("offerid", OfferID))
        params.Add(New SqlParameter("buyerid", BuyerID))
        params.Add(New SqlParameter("resultcode", ResultCode))
        params.Add(New SqlParameter("resultdesc", ResultDesc))
        params.Add(New SqlParameter("submittedby", SubmittedBy))
        params.Add(New SqlParameter("resultid", ResultId))
        params.Add(New SqlParameter("valid", IIf(Valid, 1, 0)))
        params.Add(New SqlParameter("calltransfer", IIf(CallTransfer, 1, 0)))
        Return CInt(SqlHelper.ExecuteScalar("stp_InsertSubmittedOffer", , params.ToArray))
    End Function

    Public Shared Function Submitted(ByVal LeadID As Integer, ByVal OfferID As OfferType, ByVal BuyerID As Buyer, ByVal SuccessResultCode As String) As Boolean
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        params.Add(New SqlParameter("offerid", OfferID))
        params.Add(New SqlParameter("buyerid", BuyerID))
        params.Add(New SqlParameter("resultcode", SuccessResultCode))
        Return CBool(SqlHelper.ExecuteScalar("stp_SuccessOfferSubmitted", , params.ToArray))
    End Function

    Public Shared Function GetLastSubmittedId(ByVal LeadID As Integer, ByVal OfferID As OfferType, ByVal BuyerID As Buyer) As Integer
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        params.Add(New SqlParameter("offerid", OfferID))
        params.Add(New SqlParameter("buyerid", BuyerID))
        Dim obj As Object = SqlHelper.ExecuteScalar("stp_GetLastSuccessOfferSubmittedId", , params.ToArray)
        If Not IsDBNull(obj) Then
            Return CInt(obj)
        End If
    End Function

    Public Shared Function GetLeadStatuses() As DataTable
        Return SqlHelper.GetDataTable("Select leadstatusid, [name] from tblleadstatus where display = 1 order by [name]", CommandType.Text)
    End Function

    Public Shared Sub UpdateLeadStatus(ByVal LeadID As Integer, ByVal LeadStatusId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("Update tblLeads Set LeadStatusId = {1} Where LeadId = {0}", LeadID, LeadStatusId), CommandType.Text)
    End Sub

    Public Shared Sub PostponeDialer(ByVal LeadID As Integer, ByVal NextDate As DateTime)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@Date", SqlDbType.DateTime)
        param.Value = NextDate
        params.Add(param)
        SqlHelper.ExecuteNonQuery(String.Format("Update tblLeads Set CallAgainAfter = @Date Where LeadId = {0}", LeadID), CommandType.Text, params.ToArray)
    End Sub

    Public Shared Function SearchLeads(ByVal SearchPrase As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If SearchPrase.Trim.Length > 0 Then
            param = New SqlParameter("@SearchStr", SqlDbType.VarChar)
            param.Value = SearchPrase.Trim
            params.Add(param)
        End If

        Return SqlHelper.GetDataTable("stp_Search_Leads", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetOffers(ByVal LeadID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        Return SqlHelper.GetDataTable("stp_LeadOffers", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub SetSubmittedOfferCallCompleted(ByVal SubmittedOfferId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("Update tblSubmittedOffers Set DateCallCompleted = GetDate() Where SubmittedOfferId = {0}", SubmittedOfferId), CommandType.Text, Nothing)
    End Sub
    
    Public Shared Function GetBuyer(ByVal OfferID As Integer, ByVal LeadID As Integer, ByVal type As TransferType, Optional ByVal BuyerID As Integer = -1, Optional ByVal MinDebt As Integer = 0) As DataTable
        Dim params As New List(Of SqlParameter)

        params.Add(New SqlParameter("offerid", OfferID))
        params.Add(New SqlParameter("leadid", LeadID))
        If type = TransferType.Data Then
            params.Add(New SqlParameter("datatransfer", 1))
        Else
            params.Add(New SqlParameter("datatransfer", 0))
        End If
        If BuyerID > 0 Then params.Add(New SqlParameter("buyerid", BuyerID))
        If MinDebt > 0 Then params.Add(New SqlParameter("mindebt", MinDebt))

        Return SqlHelper.GetDataTable("stp_GetBuyer", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub SaveLoadMod(ByVal LeadID As Integer, ByVal HouseType As String, ByVal HouseValue As String, ByVal MortgageBal As String, ByVal CreditStatus As String, ByVal CurIntRate As String, ByVal DesiredLoanType As String, ByVal MortgagePayment As String, ByVal Lender As String, ByVal PropertyUse As String, ByVal AnnualIncome As String, ByVal LatePayments As String, ByVal ModifiedBy As Integer, ByVal ValidateOffer As Boolean)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadID", LeadID))
        If HouseType <> "" Then params.Add(New SqlParameter("HouseType", HouseType))
        If HouseValue <> "" Then params.Add(New SqlParameter("HouseValue", HouseValue))
        If MortgageBal <> "" Then params.Add(New SqlParameter("MortgageBal", MortgageBal))
        If MortgagePayment <> "" Then params.Add(New SqlParameter("MortgagePayment", MortgagePayment))
        If Lender <> "" Then params.Add(New SqlParameter("Lender", Lender))
        If CreditStatus <> "" Then params.Add(New SqlParameter("CreditStatus", CreditStatus))
        If CurIntRate <> "" Then params.Add(New SqlParameter("CurIntRate", CurIntRate))
        If DesiredLoanType <> "" Then params.Add(New SqlParameter("DesiredLoanType", DesiredLoanType))
        If PropertyUse <> "" Then params.Add(New SqlParameter("PropertyUse", PropertyUse))
        If AnnualIncome <> "" Then params.Add(New SqlParameter("AnnualIncome", AnnualIncome))
        params.Add(New SqlParameter("LatePayments", LatePayments))
        params.Add(New SqlParameter("UserID", ModifiedBy))
        If ValidateOffer Then params.Add(New SqlParameter("validate", 1))
        SqlHelper.ExecuteNonQuery("stp_SaveLoanModLead", , params.ToArray)
    End Sub

    Public Shared Sub LogError(ByVal Source As String, ByVal Message As String, ByVal StackTrace As String, Optional ByVal LeadID As Integer = -1)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("Source", Source.Replace("www.", "")))
        params.Add(New SqlParameter("Message", Message))
        params.Add(New SqlParameter("StackTrace", StackTrace))
        params.Add(New SqlParameter("LeadID", LeadID)) 'if error is specific to a lead
        SqlHelper.ExecuteNonQuery("stp_LogError", , params.ToArray)
    End Sub

    Public Shared Sub SaveDebtLead(ByVal LeadID As Integer, ByVal BankAccount As String, ByVal MonthlyIncome As String, ByVal TotalDebt As String, ByVal CanAffordPayment As Boolean, ByVal UserID As Integer, ByVal ValidateOffer As Boolean)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        params.Add(New SqlParameter("bankaccount", BankAccount))
        params.Add(New SqlParameter("monthlyincome", MonthlyIncome))
        params.Add(New SqlParameter("totaldebt", TotalDebt))
        params.Add(New SqlParameter("AffordPayment", IIf(CanAffordPayment, 1, 0)))
        params.Add(New SqlParameter("userid", UserID))
        If ValidateOffer Then params.Add(New SqlParameter("validate", 1))
        SqlHelper.ExecuteNonQuery("stp_SaveDebtLead", , params.ToArray)
    End Sub

    Public Shared Sub SaveBkLead(ByVal LeadID As Integer, ByVal TotalDebt As String, ByVal UserID As Integer, Optional ByVal ValidateOffer As Boolean = False)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        params.Add(New SqlParameter("totaldebt", TotalDebt))
        params.Add(New SqlParameter("userid", UserID))
        If ValidateOffer Then params.Add(New SqlParameter("validate", 1))
        SqlHelper.ExecuteNonQuery("stp_SaveBkLead", , params.ToArray)
    End Sub

    Public Shared Sub SaveTaxLead(ByVal LeadID As Integer, ByVal TaxDebt As String, ByVal UserID As Integer, ByVal ValidateOffer As Boolean)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        If CInt(TaxDebt) > 0 Then params.Add(New SqlParameter("taxdebt", TaxDebt))
        If ValidateOffer Then params.Add(New SqlParameter("validate", 1))
        SqlHelper.ExecuteNonQuery("stp_SaveTaxLead", , params.ToArray)
    End Sub

    Public Shared Function ValidLeadCard(ByVal LeadID As Integer) As Boolean
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        Return CBool(SqlHelper.ExecuteScalar("stp_ValidLeadCard", , params.ToArray))
    End Function

    Public Shared Function MyGUID(ByVal LeadID As Integer) As String
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        Return CStr(SqlHelper.ExecuteScalar("stp_GetGuid", , params.ToArray))
    End Function

    Public Shared Sub UpdateCakeId(ByVal LeadID As Integer, ByVal CakeLeadId As String)
        SqlHelper.ExecuteNonQuery(String.Format("update tblleads set CakeLeadId='{0}' where leadid={1}", CakeLeadId, LeadID), CommandType.Text)
    End Sub

    Public Shared Function LeadOfferDetail(ByVal LeadID As Integer, ByVal OfferID As OfferType) As DataTable
        Dim tbl As String = ""

        Select Case OfferID
            Case OfferType.Bankruptcy
                tbl = "tblBkLeads"
            Case OfferType.Tax
                tbl = "tblTaxLeads"
            Case OfferType.Debt
                tbl = "tblDebtLeads"
            Case OfferType.Education, OfferType.EduSearch
                tbl = "tblEduLeads"
            Case OfferType.LoanMod
                tbl = "tblLoanModLeads"
        End Select

        If Len(tbl) > 0 Then
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("leadid", LeadID))
            params.Add(New SqlParameter("tbl", tbl))
            Return SqlHelper.GetDataTable("stp_LeadOfferDetail", CommandType.StoredProcedure, params.ToArray)
        Else
            Return GetLead(LeadID)
        End If
    End Function

    Public Shared Function CanTransferData(ByVal OfferID As Integer) As Boolean
        Return CBool(SqlHelper.ExecuteScalar("select transferdata from tbloffers where offerid = " & OfferID, CommandType.Text))
    End Function

    Public Shared Sub SaveOffer(ByVal OfferID As Integer, ByVal Active As Boolean, ByVal Data As Boolean, ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("offerid", OfferID))
        params.Add(New SqlParameter("active", Active))
        params.Add(New SqlParameter("data", Data))
        params.Add(New SqlParameter("userid", UserId))
        SqlHelper.ExecuteNonQuery("stp_SaveOffer", , params.ToArray)
    End Sub

    Public Shared Function ValidBuyerSubmissions(ByVal LeadID As Integer, ByVal BuyerID As Integer) As Integer
        Dim cmdText As String = String.Format("select count(*) from tblsubmittedoffers s join tblleadoffers lo on lo.leadofferid = s.leadofferid where s.valid = 1 and lo.leadid = {0} and s.buyerid = {1}", LeadID, BuyerID)
        Return CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

    Public Shared Function GetPath(ByVal LeadID As Integer, ByVal QuestionID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", LeadID))
        params.Add(New SqlParameter("questionid", QuestionID))
        Return SqlHelper.GetDataTable("stp_GetPath", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub SaveDOB(ByVal LeadID As Integer, ByVal DOB As String)
        SqlHelper.ExecuteNonQuery(String.Format("update tblleads set DOB = '{0}' where leadid = {1}", DOB, LeadID), CommandType.Text)
    End Sub

    Public Shared Sub UpdateSubmittedOfferValid(ByVal SubmittedOfferId As Integer, ByVal Valid As Boolean)
        SqlHelper.ExecuteNonQuery(String.Format("update tblSubmittedOffers set valid = {0} where SubmittedOfferId = {1}", IIf(Valid, "1", "0"), SubmittedOfferId), CommandType.Text)
    End Sub

End Class