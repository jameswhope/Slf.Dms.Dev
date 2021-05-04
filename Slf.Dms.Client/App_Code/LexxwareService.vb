Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports PaymentScheduleHelper


' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://service.lexxiom.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class LexxwareService
    Inherits System.Web.Services.WebService

#Region "Others"
    Public Class StatusJsonResponse
        Public status As String
        Public message As String
    End Class

    <WebMethod()> _
        Public Function BuildDocumentTree(ByVal dataclientid As Integer, ByVal creditoraccountid As Integer, ByVal noteid As Integer, ByVal documenttype As documentHelper.enumDocumentType) As String
        Dim results As String
        Try
            Using dt As DataTable = documentHelper.getDocuments(dataclientid, creditoraccountid, noteid, documenttype)
                results = jsonHelper.SerializeObjectIntoJson(dt)
            End Using

        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return results
    End Function

#End Region

#Region "Permanent Payment Arrangements"

    <WebMethod()> _
    Public Function GetPaymentArrangementSettlementID(ByVal dataclientid As String, ByVal accountid As String) As String
        Dim result As String = "Schedule Deleted Successfully!"
        Try
            Dim ssql As String = "select top 1 s.settlementid from tblsettlements s  "
            ssql += String.Format("where s.ClientID={0} AND CreditorAccountID={1} and Status = 'a' and Active = 1 and IsPaymentArrangement = 1 ", dataclientid, accountid)
            ssql += "ORDER by s.Created DESC"
            result = SqlHelper.ExecuteScalar(ssql, CommandType.Text)
            If result = 0 Then result = -1
        Catch ex As Exception
            result = ex.Message.ToString
        End Try
        Return result
    End Function

    <WebMethod()> _
    Public Function DeletePaymentSchedule(ByVal settlementid As String) As String
        Dim result As String = "Schedule Deleted Successfully!"
        Try
            DeletePaymentPlan(settlementid)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <WebMethod()> _
    Public Function CreatePaymentSchedule(ByVal arrangementtype As String, _
                                          ByVal settlementid As String, _
                                          ByVal startdate As String, _
                                          ByVal numberofpayments As String, _
                                          ByVal paymentamount As String, _
                                          ByVal lumpsumamount As String) As String

        Dim result = ""
        Try

            If settlementid = -1 Then
                result = "SettlementId is missing!"
                Return result
            End If


            Dim loggedinuserid = CInt(HttpContext.Current.User.Identity.Name)
            Dim noteMsg As String = String.Format("A payment plan was created by {0}.  The following conditions were agreed to:", Drg.Util.DataHelpers.UserHelper.GetName(loggedinuserid))
            'get accountid
            Dim AccountID As String = -1
            Dim Dataclientid As String = -1
            Dim settBal As Double = 0
            Using dt As DataTable = SqlHelper.GetDataTable(String.Format("select top 1 creditoraccountid, clientid,settlementamount from tblsettlements where settlementid = {0}", settlementid), Data.CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    AccountID = dr("creditoraccountid").ToString
                    Dataclientid = dr("clientid").ToString
                    settBal = dr("settlementamount").ToString
                Next
            End Using
            'get settlement fee
            Dim SettlementFee As String = GetSettlementFee(settlementid)
            Dim PmtScheduleID As Integer = -1
            DeletePaymentPlan(settlementid)

            Select Case arrangementtype.ToLower
                Case "number".ToLower, "amount".ToLower
                    If numberofpayments = 0 Then
                        numberofpayments = Math.Floor(settBal / paymentamount)
                    End If
                    If paymentamount = 0 Then
                        paymentamount = settBal / numberofpayments
                    End If

                    noteMsg += String.Format(" {0} payments of {1},", numberofpayments, FormatCurrency(paymentamount, 2))

                    Dim tot As Double = 0
                    For i As Integer = 0 To numberofpayments - 1
                        PmtScheduleID = -1
                        CreatePaymentScheduleItem(PmtScheduleID, Dataclientid, AccountID, settlementid, CDate(startdate).AddMonths(i), paymentamount, loggedinuserid)
                        tot += paymentamount
                    Next

                    If tot < settBal Then
                        Dim amountLeftOver As Double = settBal - tot
                        If amountLeftOver > 0 Then
                            noteMsg += String.Format(" with your last payment being {0}.", FormatCurrency(amountLeftOver, 2))
                            PmtScheduleID = -1
                            CreatePaymentScheduleItem(PmtScheduleID, Dataclientid, AccountID, settlementid, CDate(startdate).AddMonths(numberofpayments), amountLeftOver, loggedinuserid)
                        End If
                    End If

                Case "custom".ToLower
                    If numberofpayments > 0 AndAlso paymentamount > 0 Then
                        For i As Integer = 0 To numberofpayments - 1
                            PmtScheduleID = -1
                            CreatePaymentScheduleItem(PmtScheduleID, Dataclientid, AccountID, settlementid, CDate(startdate).AddMonths(i), paymentamount, loggedinuserid)
                        Next
                    End If

                    If lumpsumamount > 0 Then
                        PmtScheduleID = -1
                        CreatePaymentScheduleItem(PmtScheduleID, Dataclientid, AccountID, settlementid, CDate(startdate).AddMonths(numberofpayments), lumpsumamount, loggedinuserid)
                    End If

                    noteMsg += String.Format(" {0} payments of {1}, ", numberofpayments, FormatCurrency(paymentamount, 2))
                    noteMsg += String.Format(" with a lump sum payment of {0}.", FormatCurrency(lumpsumamount, 2))

            End Select

            Drg.Util.DataHelpers.NoteHelper.InsertNote(noteMsg, loggedinuserid, Dataclientid)
            result = noteMsg

        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <WebMethod()> _
     Public Function DeleteSchedulePayment(ByVal paymentscheduleid As String) As String
        Dim result As String = "Payment Deleted Successfully!"
        Try
            Dim ssql As String = String.Format("Delete from tblpaymentschedule where PmtScheduleID = {0}", paymentscheduleid)
            SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.Text)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try
        Return result
    End Function

    <WebMethod()> _
     Public Function InsertUpdateSchedulePayment(ByVal paymentscheduleid As String, _
                                                 ByVal settlementid As String, _
                                                 ByVal paymentdate As String, _
                                                 ByVal paymentamount As String) As String
        Dim result As String = ""
        Try
            Dim loggedinuserid = CInt(HttpContext.Current.User.Identity.Name)
            Dim accountid As String = ""
            Dim Dataclientid As String = ""
            If paymentscheduleid = -1 Then
                result = "Payment Added Successfully!!!"
                Dim ssql As String = String.Format("select top 1 * from tblsettlements where settlementid = {0}", settlementid)
                Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
                    For Each dr As DataRow In dt.Rows
                        accountid = dr("creditoraccountid").ToString
                        Dataclientid = dr("clientid").ToString
                    Next
                End Using
            Else
                result = "Payment Updated Successfully!!!"
                Dim ssql As String = String.Format("select top 1 * from tblPaymentSchedule where PmtScheduleID = {0}", paymentscheduleid)
                Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
                    For Each dr As DataRow In dt.Rows
                        accountid = dr("accountid").ToString
                        Dataclientid = dr("clientid").ToString
                    Next
                End Using
            End If

            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("PmtScheduleID", paymentscheduleid))
            params.Add(New SqlParameter("ClientID", Dataclientid))
            params.Add(New SqlParameter("AccountID", accountid))
            params.Add(New SqlParameter("SettlementID", settlementid))
            params.Add(New SqlParameter("PmtDate", paymentdate))
            params.Add(New SqlParameter("PmtAmount", paymentamount))
            params.Add(New SqlParameter("userid", loggedinuserid))
            Dim payArrangeID As String = SqlHelper.ExecuteScalar("stp_paymentarrangement_InsertUpdate", Data.CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <WebMethod()> _
    Public Function CreatePaymentSchedulePlan(ByVal settlementid As Integer, ByVal payments As List(Of PaymentArrangementJson)) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Dim result = ""
        Try
            'Validate First

            If settlementid = -1 Then
                Throw New Exception("SettlementId is missing!")
            End If

            Dim userid = CInt(HttpContext.Current.User.Identity.Name)
            Dim noteMsg As String = String.Format("A payment plan was created by {0}.", Drg.Util.DataHelpers.UserHelper.GetName(userid))
            'get accountid
            Dim AccountID As String = -1
            Dim Dataclientid As String = -1
            Dim settBal As Double = 0
            Dim dtaccount As DataTable = PaymentScheduleHelper.GetSettlementData(settlementid)
            If dtaccount.Rows.Count > 0 Then
                AccountID = dtaccount.Rows(0)("creditoraccountid").ToString
                Dataclientid = dtaccount.Rows(0)("clientid").ToString
                settBal = dtaccount.Rows(0)("settlementamount").ToString
            Else
                Throw New Exception("Settlement info not found!")
            End If

            DeletePaymentPlan(settlementid)

            Dim PmtScheduleID As Integer = -1

            For Each Payment As PaymentArrangementJson In payments
                PmtScheduleID = -1
                CreatePaymentScheduleItem(PmtScheduleID, Dataclientid, AccountID, settlementid, CDate(Payment.date), CDec(Payment.amount.Replace("$", "")), userid)
            Next

            Drg.Util.DataHelpers.NoteHelper.InsertNote(noteMsg, userid, Dataclientid)

            resp.status = "success"
            resp.message = noteMsg

        Catch ex As Exception
            DeletePaymentPlan(settlementid) 'Make it Transactional later
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp

    End Function

#End Region

#Region "Payment Arrangent Session Calculator"

    <WebMethod()> _
    Public Function SavePACalc(ByVal pasessionid As Integer, ByVal sessiondata As PASessionJson) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            If sessiondata Is Nothing Then Throw New Exception("Payment Arrangement calculator data is missing")
            Dim startdate As Nullable(Of DateTime) = IIf(sessiondata.startdate.Trim.Length = 0, Nothing, CDate(sessiondata.startdate))
            Dim lumpsum As Nullable(Of Decimal) = IIf(sessiondata.lumpsum.Trim.Length = 0, Nothing, CDec(sessiondata.lumpsum))
            Dim installmentmethod As Nullable(Of Integer) = IIf(sessiondata.installmentmethod.Trim.Length = 0, Nothing, CInt(sessiondata.installmentmethod))
            Dim installmentamount As Nullable(Of Decimal) = IIf(sessiondata.installmentamount.Trim.Length = 0, Nothing, CDec(sessiondata.installmentamount))
            Dim installmentcount As Nullable(Of Integer) = IIf(sessiondata.installmentcount.Trim.Length = 0, Nothing, CInt(sessiondata.installmentcount))
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)

            If pasessionid < 1 Then
                pasessionid = PaymentScheduleHelper.InsertPACalculatorSet(sessiondata.clientid, sessiondata.accountid, sessiondata.settlementamount, startdate, sessiondata.plantype, lumpsum, installmentmethod, installmentamount, installmentcount, userid)
            Else
                PaymentScheduleHelper.UpdatePACalculatorSet(pasessionid, sessiondata.settlementamount, startdate, sessiondata.plantype, lumpsum, installmentmethod, installmentamount, installmentcount, userid)
            End If

            Dim noteMsg As String = String.Format("A payment arrangement plan was saved by {0}.", Drg.Util.DataHelpers.UserHelper.GetName(userid))

            resp.status = "success"
            resp.message = noteMsg
            resp.returnData = pasessionid

        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp

    End Function

    <WebMethod()> _
       Public Function DeletePACalc(ByVal pasessionid As Integer) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)

            PaymentScheduleHelper.DeletePACalculatorSet(pasessionid, userid)

            Dim noteMsg As String = String.Format("A payment arrangement plan was removed by {0}.", Drg.Util.DataHelpers.UserHelper.GetName(userid))
            resp.status = "success"
            resp.message = noteMsg
            resp.returnData = pasessionid
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function

    <WebMethod()> _
    Public Function GetPACalc(ByVal pasessionid As Integer) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            If pasessionid < 1 Then Throw New Exception("Payment Arrangement calculator data is missing")
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)
            Dim dt As DataTable = PaymentScheduleHelper.GetPACalculatorSet(pasessionid)
            Dim obj As PASessionJson = Nothing
            If dt.Rows.Count > 0 Then
                Dim dr As DataRow = dt.Rows(0)
                obj = New PASessionJson With {.installmentamount = IIf(dr("installmentamount") Is DBNull.Value, "", String.Format("{0:N2}", dr("installmentamount"))), _
                                              .installmentcount = IIf(dr("installmentcount") Is DBNull.Value, "", dr("installmentcount")), _
                                              .installmentmethod = IIf(dr("installmentmethod") Is DBNull.Value, "", dr("installmentmethod")), _
                                              .lumpsum = IIf(dr("lumpsumamount") Is DBNull.Value, "", String.Format("{0:N2}", dr("lumpsumamount"))), _
                                              .plantype = dr("plantype"), _
                                              .settlementamount = String.Format("{0:N2}", dr("settlementamount")), _
                                              .startdate = IIf(dr("startdate") Is DBNull.Value, "", dr("startdate"))}
            Else
                Throw New Exception("A payment arrangement plan was not found.")
            End If

            Dim noteMsg As String = "A payment arrangement plan was found."
            resp.status = "success"
            resp.message = noteMsg
            resp.returnData = obj
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function

#End Region

#Region "Payment Arrangent Session Calculator Customization"

    <WebMethod()> _
        Public Function CreatePACustomCalc(ByVal pasessionid As Integer, ByVal sessiondata As PASessionJson, ByVal payments As List(Of PaymentArrangementJson)) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try

            resp = Me.SavePACalc(pasessionid, sessiondata)

            Try
                pasessionid = resp.returnData
            Catch ex As Exception
                Throw New Exception("Custom payment plan could not be created.")
            End Try

            Dim userid = CInt(HttpContext.Current.User.Identity.Name)

            If pasessionid < 1 Then
                Throw New Exception("Custom payment plan could not get created.")
            Else
                PaymentScheduleHelper.SetPASessionCustom(pasessionid, True, userid)
            End If

            Dim noteMsg As String = String.Format("A custom payment plan was created by {0}.", Drg.Util.DataHelpers.UserHelper.GetName(userid))

            For Each Payment As PaymentArrangementJson In payments
                PaymentScheduleHelper.InsertPACustomDetail(pasessionid, Payment.date, Payment.amount, userid)
            Next

            resp.status = "success"
            resp.message = noteMsg

        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp

    End Function

    <WebMethod()> _
     Public Function SavePADetail(ByVal padetailid As Integer, ByVal pasessionid As Integer, ByVal settlementamount As Decimal, ByVal paymentdata As PaymentArrangementJson) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            If paymentdata Is Nothing Then Throw New Exception("The custom payment calculator data is missing")
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)
            Dim noteMsg As String

            If pasessionid < 1 Then
                Throw New Exception("A custom payment session id is missing")
            Else
                PaymentScheduleHelper.UpdatePASessionCustomSettlementAmount(pasessionid, settlementamount, userid)
            End If

            If padetailid < 1 Then
                'insert
                padetailid = PaymentScheduleHelper.InsertPACustomDetail(pasessionid, CDate(paymentdata.date), CDec(paymentdata.amount), userid)
                noteMsg = String.Format("A custom payment was added by {0}.", Drg.Util.DataHelpers.UserHelper.GetName(userid))
            Else
                'update
                PaymentScheduleHelper.UpdatePACustomDetail(padetailid, CDate(paymentdata.date), CDec(paymentdata.amount), userid)
                noteMsg = String.Format("A custom payment was saved by {0}.", Drg.Util.DataHelpers.UserHelper.GetName(userid))
            End If

            resp.status = "success"
            resp.message = noteMsg
            resp.returnData = padetailid

        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function

    <WebMethod()> _
    Public Function DeletePADetail(ByVal padetailid As Integer, ByVal pasessionid As Integer, ByVal settlementamount As Decimal) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)

            If pasessionid < 1 Then
                Throw New Exception("A custom payment session id is missing")
            Else
                PaymentScheduleHelper.UpdatePASessionCustomSettlementAmount(pasessionid, settlementamount, userid)
            End If

            PaymentScheduleHelper.DeletePACustomDetail(padetailid, userid)

            resp.status = "success"
            resp.message = "Scheduled payment deleted successfully!"
            resp.returnData = padetailid
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function

    <WebMethod()> _
    Public Function DeleteAllPADetails(ByVal pasessionid As Integer) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)
            PaymentScheduleHelper.DeleteAllPACustomDetail(pasessionid, userid)

            resp.status = "success"
            resp.message = "All scheduled payments were deleted successfully!"
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function

    <WebMethod()> _
    Public Function RemovePACustomizations(ByVal pasessionid As Integer) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)
            PaymentScheduleHelper.DeleteAllPACustomDetail(pasessionid, userid)
            PaymentScheduleHelper.SetPASessionCustom(pasessionid, False, userid)

            resp.status = "success"
            resp.message = "The custom payment plan has been rolled back successfully!"
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function
#End Region

    <WebMethod()> _
    Public Function UpdatePACalcSettlementAmount(ByVal pasessionid As Integer, ByVal settlementamount As Decimal) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try

            If settlementamount < 0 Then Throw New Exception("The settlement amount is invalid")

            Dim userid = CInt(HttpContext.Current.User.Identity.Name)

            If pasessionid < 1 Then
                Throw New Exception("A custom payment session id is missing")
            Else
                PaymentScheduleHelper.UpdatePASessionCustomSettlementAmount(pasessionid, settlementamount, userid)
            End If

            resp.status = "success"
            resp.message = "Settlement amount has been updated successfully!"
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function

    <WebMethod()> _
    Public Function ValidatePACalcCustom(ByVal pasessionid As Integer, ByVal settlementamount As Decimal) As PaymentArrangementJsonResponse
        Dim resp As New PaymentArrangementJsonResponse
        Try
            If settlementamount < 0 Then Throw New Exception("The settlement amount is invalid")

            Dim userid = CInt(HttpContext.Current.User.Identity.Name)

            If pasessionid < 1 Then
                Throw New Exception("A custom payment session id is missing")
            Else
                PaymentScheduleHelper.UpdatePASessionCustomSettlementAmount(pasessionid, settlementamount, userid)
                Dim dt As DataTable = PaymentScheduleHelper.GetPACalculatorSet(pasessionid)

                If dt.Rows.Count < 1 Then Throw New Exception("A calculator session id could not be found")

                Dim dtdetails As DataTable = PaymentScheduleHelper.GetPACalculatorDetails(pasessionid)

                If dtdetails.Rows.Count < 1 Then Throw New Exception("There are no payments setup yet.")

                'Dates > today
                If dtdetails.Select(String.Format("paymentduedate < #{0:MM/dd/yy}#", Date.Today)).Length > 0 Then Throw New Exception(String.Format("Scheduled dates cannot be older than {0:MM/dd/yy}", Date.Today))

                Dim totalused As Decimal = dtdetails.Compute("Sum(paymentamount)", String.Empty)

                Dim diff As Decimal = settlementamount - TotalUsed
                If diff > 0 Then
                    Throw New Exception(String.Format("There is a shortage of {0:c}", diff))
                ElseIf diff < 0 Then
                    Throw New Exception(String.Format("There is an overage of {0:c}", diff))
                End If

            End If

            resp.status = "success"
            resp.message = ""
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try

        Return resp
    End Function

    <WebMethod()> _
    Public Function EmailCheckByPhone(ByVal emailaddress As String, ByVal paymentid As Integer, ByVal settlementid As Integer) As StatusJsonResponse
        Dim resp As New StatusJsonResponse
        Try
            Dim userid = CInt(HttpContext.Current.User.Identity.Name)
            resp.message = SettlementMatterHelper.EmailCheckByPhoneConfirmation(emailaddress, paymentid, settlementid, userid)
            resp.status = "success"
        Catch ex As Exception
            resp.status = "error"
            resp.message = ex.Message.ToString
        End Try
        Return resp
    End Function

End Class
