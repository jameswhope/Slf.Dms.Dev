Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO
Imports Drg.Util.DataHelpers

Public Class NonDepositHelper

    Public Shared Function InsertMatter(ByVal ClientId As Integer, ByVal TypeId As Integer, ByVal MissedDate As Nullable(Of DateTime), ByVal MissedAmount As Nullable(Of Decimal), ByVal DepositId As Nullable(Of Integer), ByVal CreatedBy As Integer, ByVal PlanId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)

        param = New SqlParameter("@NonDepositTypeId", SqlDbType.Int)
        param.Value = TypeId
        params.Add(param)

        param = New SqlParameter("@MissedDate", SqlDbType.DateTime)
        If MissedDate.HasValue Then
            param.Value = MissedDate.Value
        Else
            param.Value = DBNull.Value
        End If
        params.Add(param)

        param = New SqlParameter("@DepositAmount", SqlDbType.Money)
        If MissedAmount.HasValue Then
            param.Value = MissedAmount.Value
        Else
            param.Value = DBNull.Value
        End If
        params.Add(param)

        param = New SqlParameter("@DepositId", SqlDbType.Int)
        If DepositId.HasValue Then
            param.Value = DepositId.Value
        Else
            param.Value = DBNull.Value
        End If
        params.Add(param)

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        param.Value = CreatedBy
        params.Add(param)

        If PlanId > 0 Then
            param = New SqlParameter("@PlanId", SqlDbType.Int)
            param.Value = PlanId
            params.Add(param)
        End If

        param = New SqlParameter("@MatterId", SqlDbType.Int)
        param.Direction = ParameterDirection.InputOutput
        param.Value = DBNull.Value
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_NonDeposit_CreateMatter", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Sub CloseMatter(ByVal MatterId As Integer, ByVal MatterStatusCode As String, ByVal MatterSubstatus As String, ByVal Note As String, ByVal UserID As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@MatterId", SqlDbType.Int)
        param.Value = MatterId
        params.Add(param)

        param = New SqlParameter("@MatterStatusCode", SqlDbType.VarChar)
        param.Value = MatterStatusCode
        params.Add(param)

        param = New SqlParameter("@MatterSubstatus", SqlDbType.VarChar)
        param.Value = MatterSubstatus
        params.Add(param)

        If Note.Trim.Length > 0 Then
            param = New SqlParameter("@Note", SqlDbType.VarChar)
            param.Value = Note.Trim
            params.Add(param)
        End If

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        param.Value = UserID
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_NonDeposit_CloseMatter", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub UpdateMatterStatus(ByVal MatterId As Integer, ByVal MatterStatusCode As String, ByVal MatterSubstatus As String, ByVal Note As String, ByVal UserID As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@MatterId", SqlDbType.Int)
        param.Value = MatterId
        params.Add(param)

        param = New SqlParameter("@MatterStatusCode", SqlDbType.VarChar)
        param.Value = MatterStatusCode
        params.Add(param)

        param = New SqlParameter("@MatterSubstatus", SqlDbType.VarChar)
        param.Value = MatterSubstatus
        params.Add(param)

        If Note.Trim.Length > 0 Then
            param = New SqlParameter("@Note", SqlDbType.VarChar)
            param.Value = Note.Trim
            params.Add(param)
        End If

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        param.Value = UserID
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_NonDeposit_ChangeNonDepositStatus", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function GetClientId(ByVal MatterId As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar("Select clientid from tblmatter where matterid = " & MatterId, CommandType.Text, Nothing))
    End Function

    Public Shared Function GetExpectedAmount(ByVal MatterId As Integer) As Decimal
        Try
            Return Format(CDec(SqlHelper.ExecuteScalar("select expectedamount = case when n.depositid is null then n.depositamount else (Select r.amount from tblregister r where r.registerid = n.depositid) end from tblnondeposit n where n.matterid = " & MatterId, CommandType.Text, Nothing)), "0.00")
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetNonDepositId(ByVal MatterId As Integer) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar("Select nondepositid from tblNonDeposit where matterid = " & MatterId, CommandType.Text, Nothing))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetNonDepositToCallCount() As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar("stp_NonDeposit_GetPendingToCallCIDCount", CommandType.StoredProcedure, Nothing))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function InsertNonDepositReplacement(ByVal NonDepositId As Integer, ByVal DepositDate As DateTime, ByVal DepositAmount As Decimal, ByVal AdHocAchId As Nullable(Of Integer), ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@NonDepositId", SqlDbType.Int)
        param.Value = NonDepositId
        params.Add(param)

        param = New SqlParameter("@DepositDate", SqlDbType.DateTime)
        param.Value = DepositDate
        params.Add(param)

        param = New SqlParameter("@DepositAmount", SqlDbType.Money)
        param.Value = DepositAmount
        params.Add(param)

        param = New SqlParameter("@UserID", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        If AdHocAchId.HasValue AndAlso AdHocAchId.Value > 0 Then
            param = New SqlParameter("@AdHocACHId", SqlDbType.Int)
            param.Value = AdHocAchId
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("stp_NonDeposit_InsertNonDepositReplacement", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function CanReResolveNonDepositMatter(ByVal MatterId As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar("Select m.matterid from tblMatter m inner join tblmatterstatuscode sc on sc.matterstatuscodeid = m.matterstatuscodeid where m.mattertypeid = 5 and sc.matterstatuscode in ('ND_RD') and m.matterid = " & MatterId, CommandType.Text, Nothing))
    End Function

    Public Shared Function CanResolveNonDepositMatter(ByVal MatterId As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar("Select m.matterid from tblMatter m inner join tblmatterstatuscode sc on sc.matterstatuscodeid = m.matterstatuscodeid where m.mattertypeid = 5 and sc.matterstatuscode in ('ND_CR','ND_CC','ND_RE', 'ND_RC') and m.matterid = " & MatterId, CommandType.Text, Nothing))
    End Function

    Public Shared Function GetLastLetterSent(ByVal ClientID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientID
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_NonDeposit_GetLastLetterSent", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetLastGoodDeposit(ByVal ClientID As Integer) As DataTable
        Return SqlHelper.GetDataTable("Select top 1 registerid, transactiondate, amount from tblregister where entrytypeid = 3 and bounce is null and void is null and clientid = " & ClientID & " order by transactiondate desc", CommandType.Text, Nothing)
    End Function

    Public Shared Function GetNonDepositByRegisterId(ByVal RegisterId As Integer) As DataTable
        Return SqlHelper.GetDataTable("Select n.NonDepositId, n.matterid, n.clientid, n.Planid, r.bouncedreason from tblnondeposit n inner join tblregister r on r.registerid = n.depositid where n.DepositId = " & RegisterId, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetNonDepositLetterByRegisterId(ByVal RegisterId As Integer) As DataTable
        Return SqlHelper.GetDataTable("Select l.nondepositletterid, l.lettertype, n.NonDepositId, n.matterid, n.clientid, n.Planid, r.bouncedreason from tblnondepositletter l inner join tblnondeposit n on n.nondepositid = l.nondepositid inner join tblregister r on r.registerid = l.registerid where l.registerid = " & RegisterId, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetNonDepositLetterToPrint(ByVal NonDepositLetterId As Integer) As DataTable
        Return SqlHelper.GetDataTable("Select l.nondepositletterid, n.NonDepositId, l.lettertype, n.clientid, l.filename from tblnondepositletter l inner join tblnondeposit n on n.nondepositid = l.nondepositid where l.nondepositletterid = " & NonDepositLetterId, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetNonDepositDataForLetter(ByVal NonDepositLetterID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@NonDepositLetterID", SqlDbType.Int)
        param.Value = NonDepositLetterID
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_NonDeposit_GetDataForLetter", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetNonDepositData(ByVal MatterID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@MatterId", SqlDbType.Int)
        param.Value = MatterID
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_NonDeposit_GetMatterData", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetAccountNumberByRegisterId(ByVal Registerid As Integer) As String
        Try
            Return SqlHelper.ExecuteScalar(String.Format("select top 1 a.accountnumber from (Select Accountnumber from tblnacharegister where registerid = {0} Union Select  Accountnumber from tblnacharegister2 where registerid = {0}) a", registerid), CommandType.Text, Nothing).ToString.Trim
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function HasPendingSettFees(ByVal ClientId As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar("Select count(registerid) from tblregister Where entrytypeid = 4 and isfullypaid = 0 and void is null and clientid = " & ClientId, CommandType.Text, Nothing))
    End Function

    Public Shared Function CountD5022(ByVal ClientId As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar("select count(distinct datestring)  from tblDocRelation where doctypeid='d5022' and relationtype = 'client' and relateddate between dateadd(m,-6, getdate()) and getdate() and clientid= " & ClientId, CommandType.Text, Nothing))
    End Function

    Private Shared Function ShouldResetNonDepositLetters(ByVal ClientId As Integer, ByVal LastLetterDate As DateTime, ByVal MatterSubstatusId As Integer) As Boolean
        'Get last good deposit info
        Dim dt As DataTable = NonDepositHelper.GetLastGoodDeposit(ClientId)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            'If a good deposit after the letter or matter closed as a successful replacement (85)
            If (DateTime.Compare(CDate(dt.Rows(0)("TransactionDate")), LastLetterDate) > 0) OrElse MatterSubstatusId = 85 Then
                'Restart with first Letter
                Return True
            End If
        End If
        Return False
    End Function

    Public Shared Function GetNextLetterToSend(ByVal ClientId As Integer) As String
        Dim NextLetter As String = "D5030"
        Dim dt As DataTable = NonDepositHelper.GetLastLetterSent(ClientId)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            If Not NonDepositHelper.ShouldResetNonDepositLetters(ClientId, CDate(dr("DateCreated")), CInt(dr("mattersubstatusid"))) Then
                'Get Next Letter
                Select Case dr("lettertype").ToUpper.Trim
                    Case "D5030"
                        'Letter 2
                        NextLetter = "D5031"
                    Case "D5031"
                        'Letter 3
                        NextLetter = "D5013"
                    Case "D5013"
                        'Letter 4
                        NextLetter = "4LETTER"
                    Case "4LETTER"
                        NextLetter = "4LETTER"
                End Select
            End If
        End If
        Return NextLetter
    End Function

    Public Shared Function ShouldSendNonDepositLetter(ByVal NonDepositId As Integer) As Boolean
        Return CInt(SqlHelper.ExecuteScalar("Select count(planid) from tblNonDeposit where planid is not null and NonDepositId = " & NonDepositId, CommandType.Text, Nothing)) > 0
    End Function

    Public Shared Sub DeletePlannedAdHocACH(ByVal AdHocAchId As Integer)
        SqlHelper.ExecuteNonQuery("Delete from tbladhocach where registerid is null and adhocachid = " & AdHocAchId, CommandType.Text, Nothing)
    End Sub

    Public Shared Sub UpdateLetter(ByVal NonDepositLetterId As Integer, ByVal LetterType As String, ByVal DatePrinted As Nullable(Of DateTime), ByVal PrintedBy As Nullable(Of Integer), ByVal SentToEmail As Nullable(Of Boolean), Optional ByVal Filename As String = "")

        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@NonDepositLetterId", SqlDbType.Int)
        param.Value = NonDepositLetterId
        params.Add(param)

        If LetterType.Trim.Length > 0 Then
            param = New SqlParameter("@LetterType", SqlDbType.VarChar)
            param.Value = LetterType
            params.Add(param)
        End If

        If DatePrinted.HasValue Then
            param = New SqlParameter("@PrintedDate", SqlDbType.DateTime)
            param.Value = DatePrinted.Value
            params.Add(param)
        End If

        If PrintedBy.HasValue Then
            param = New SqlParameter("@PrintedBy", SqlDbType.Int)
            param.Value = PrintedBy.Value
            params.Add(param)
        End If

        If SentToEmail.HasValue Then
            param = New SqlParameter("@SentToEmail", SqlDbType.Bit)
            param.Value = IIf(SentToEmail.Value, 1, 0)
            params.Add(param)
        End If

        If Filename.Trim.Length > 0 Then
            param = New SqlParameter("@Filename", SqlDbType.VarChar)
            param.Value = Filename
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("stp_NonDeposit_UpdateLetter", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function InsertPendingCancellation(ByVal CLientid As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = CLientid
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_NonDeposit_InsertPendingCancellation", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Sub SendBouncedDepositLetter(ByVal RegisterId As Integer, ByVal UserId As Integer)
        'Get Bounced resaon, NonDeposit, PlanId 
        Dim dt As DataTable = NonDepositHelper.GetNonDepositLetterByRegisterId(RegisterId)
        Dim matterId As Integer = 0
        Dim bouncedreasonId As Integer = 0
        Dim nondepositletterid As Integer = 0
        Dim nondepositId As Integer = 0
        Dim planid As Integer = 0
        Dim clientId As Integer = 0
        Dim MustSendLetter As Boolean = False
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            nondepositletterid = dr("nondepositletterid")
            clientId = dr("clientid")
            bouncedreasonId = dr("bouncedreason")
            nondepositId = dr("nondepositid")
            If Not dr("planid") Is DBNull.Value Then planid = dr("planid")
            MustSendLetter = dr("lettertype").ToString.Trim.ToLower = "pending"
        End If
        If planid > 0 AndAlso MustSendLetter Then
            NonDepositHelper.SendNonDepositLetter(nondepositletterid, clientId, UserId)
        Else
            'D5025 - Send NSF Letter only
            NonDepositHelper.UpdateLetter(nondepositletterid, "D5025", Nothing, Nothing, Nothing)
            NonDepositHelper.EmailNonDepositLetter(nondepositletterid, UserId)
        End If
    End Sub

    Public Shared Function SendNonDepositLetter(ByVal NondepositLetterId As Integer, ByVal ClientId As Integer, ByVal UserId As Integer) As Boolean
        Dim bSent As Boolean = False
        Dim nextLetter As String = NonDepositHelper.GetNextLetterToSend(ClientId).Trim
        Select Case nextLetter.ToLower
            Case ""
                'Do not send letter
                NonDepositHelper.UpdateLetter(NondepositLetterId, "Remove", Nothing, Nothing, Nothing)
            Case "4letter"
                'Do not send letter yet. Put it in a cancellation queue
                NonDepositHelper.InsertPendingCancellation(ClientId, UserId)
                NonDepositHelper.UpdateLetter(NondepositLetterId, nextLetter, Nothing, Nothing, Nothing)
            Case Else
                NonDepositHelper.UpdateLetter(NondepositLetterId, nextLetter, Nothing, Nothing, Nothing)
                bSent = NonDepositHelper.EmailNonDepositLetter(NondepositLetterId, UserId)
        End Select
        Return bSent
    End Function

    Public Shared Function GenerateLetter(ByVal NonDepositLetterId As Integer, ByVal UserID As Integer) As String
        Dim strDocTypeName As String = "String"
        Dim docName As String = "String"
        Dim rArgs As String
        Dim dt As DataTable = NonDepositHelper.GetNonDepositDataForLetter(NonDepositLetterId)
        If dt Is Nothing OrElse dt.Rows.Count = 0 Then Throw New Exception("Cannot find non deposit letter tp print")
        Dim dr As DataRow = dt.Rows(0)
        Dim matterid As Integer = dr("matterid")
        Dim clientid As Integer = dr("clientid")
        Dim lettertype As String = dr("lettertype")
        Dim bouncedreasonid As Integer = 0
        Dim dueDate As DateTime = CDate(dr("duedate"))
        Dim CheckFee As String = IIf(dr("CheckFee"), "True", "False")
        If Not dr("bouncedreasonid") Is DBNull.Value Then bouncedreasonid = dr("bouncedreasonid")
        Dim bankreason = 0
        Dim bankLast4 As String = ""
        If Not dr("registerid") Is DBNull.Value Then
            Dim acct As String = NonDepositHelper.GetAccountNumberByRegisterId(dr("registerid"))
            If acct.Length > 3 Then bankLast4 = Right(acct, 4)
        End If
        Dim ext As String = "633"

        Select Case lettertype.ToUpper.Trim
            Case "D5025"
                strDocTypeName = "NSFLetter"
                docName = "NSF Letter"
                Select Case bouncedreasonid
                    Case 3 'Invalid
                        bankreason = 1
                    Case 2 'Closed
                        bankreason = 2
                    Case 7 'Frozen
                        bankreason = 3
                    Case Else '4
                        bankreason = 4
                End Select
                'Due Date, CheckFee(True,False), BankStatus (1-invalid, 2-closed, 3-frozen, 4-other), Ext
                rArgs = strDocTypeName & "," & dueDate.ToShortDateString & "," & CheckFee & "," & bankreason.ToString & "," & ext
            Case "D5030"
                Select Case bouncedreasonid
                    Case 1, 69
                        bankreason = 4
                    Case 3 'Invalid
                        bankreason = 3
                    Case 2 'Closed
                        bankreason = 1
                    Case 4 'Stopped
                        bankreason = 5
                    Case 7 'Frozen
                        bankreason = 2
                    Case Else '4
                        bankreason = 0
                End Select
                'DueDate, reason 1-closed, 2-frozen, 3-Invalid, 4-Nsf, 5-Stopped, BankLast4
                strDocTypeName = "NoticeOfNonDepositFirst"
                docName = "Notice of Non Deposit - First"
                rArgs = strDocTypeName & "," & dueDate.ToShortDateString & "," & bankreason.ToString & "," & bankLast4 & "," & ext
            Case "D5031"
                Select Case bouncedreasonid
                    Case 1, 69
                        bankreason = 4
                    Case 3 'Invalid
                        bankreason = 3
                    Case 2 'Closed
                        bankreason = 1
                    Case 4 'Stopped
                        bankreason = 5
                    Case 7 'Frozen
                        bankreason = 2
                    Case Else '4
                        bankreason = 0
                End Select
                'DueDate, reason 1-closed, 2-frozen, 3-Invalid, 4-Nsf, 5-Stopped, BankLast4
                strDocTypeName = "NoticeOfNonDepositSecond"
                docName = "Notice of Non Deposit - Second"
                rArgs = strDocTypeName & "," & dueDate.ToShortDateString & "," & bankreason.ToString & "," & bankLast4 & "," & ext
            Case "D5013"
                'Params: Nothing
                strDocTypeName = "FinalPastDueLetter"
                docName = "Final Notice of Non Deposit"
                rArgs = strDocTypeName
            Case "D8022"
                Dim RefundAmount As Double = 0
                'Params: Refund Amount
                strDocTypeName = "NoticeOfTerminationOfRepresentation"
                docName = "Notice of Termination of Representation"
                rArgs = strDocTypeName & "," & Format(RefundAmount, "0.00")
            Case Else
                Throw New Exception("Invalid Non Deposit letter type " & lettertype)
        End Select

        Dim strDocID As String = ""
        Dim fileName As String = ""
        Dim FilePath As String = ""
        Dim NoteId As Integer
        Dim note As String
        Dim DateStr As String = DateTime.Now.ToString("yyMMdd")

        Try
            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
                Using report As New GrapeCity.ActiveReports.SectionReport

                    Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport()
                    Dim rptDoc As New GrapeCity.ActiveReports.Document.SectionDocument

                    fileName = SharedFunctions.DocumentAttachment.GetUniqueDocumentName(lettertype, clientid)
                    strDocID = SettlementMatterHelper.GetDocIdFromPath(fileName)

                    FilePath = SharedFunctions.DocumentAttachment.BuildAttachmentPath(lettertype, strDocID, DateStr, clientid)
                    Dim ParentDirectory As String = Directory.GetParent(FilePath).FullName

                    If Not Directory.Exists(ParentDirectory) Then
                        Directory.CreateDirectory(ParentDirectory)
                    End If

                    Dim args As String() = rArgs.Split(",")
                    rptDoc = rptTemplates.ViewTemplate(strDocTypeName, clientid, args, False, UserID)
                    report.Document.Pages.AddRange(rptDoc.Pages)

                    Using fStream As New System.IO.FileStream(FilePath, FileMode.CreateNew)
                        pdf.Export(report.Document, fStream)
                    End Using

                    SharedFunctions.DocumentAttachment.CreateScan(fileName, UserID)
                    SharedFunctions.DocumentAttachment.AttachDocument("matter", matterid, lettertype, strDocID, DateStr, clientid, UserID)
                    note = "Generated " & docName & " document for " & ClientHelper.GetDefaultPersonName(clientid)
                    NoteId = NoteHelper.InsertNote(note, UserID, clientid)
                    NoteHelper.RelateNote(NoteId, 19, matterid)
                End Using
            End Using

        Catch ex As Exception
            Throw ex
        End Try

        NonDepositHelper.UpdateLetter(NonDepositLetterId, "", Nothing, Nothing, Nothing, FilePath)

        Return FilePath
    End Function

    Public Shared Function GetOpenNonDeposits(ByVal CompanyId As Nullable(Of Integer), ByVal MatterSubStatusId As Nullable(Of Integer), ByVal NonDepositTypeId As Nullable(Of Integer), ByVal InCancel As Boolean) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If CompanyId.HasValue Then
            param = New SqlParameter("@LawFirmId", SqlDbType.Int)
            param.Value = CompanyId.Value
            params.Add(param)
        End If

        If MatterSubStatusId.HasValue Then
            param = New SqlParameter("@MatterSubStatusId", SqlDbType.Int)
            param.Value = MatterSubStatusId.Value
            params.Add(param)
        End If

        If NonDepositTypeId.HasValue Then
            param = New SqlParameter("@NonDepositTypeId", SqlDbType.Int)
            param.Value = NonDepositTypeId.Value
            params.Add(param)
        End If

        param = New SqlParameter("@InCancellation", SqlDbType.Bit)
        param.Value = IIf(InCancel, 1, 0)
        params.Add(param)

        Return SqlHelper.GetDataTable("stp_NonDeposit_GetOpenNonDeposits", CommandType.StoredProcedure, params.ToArray)

    End Function

    Public Shared Function GetPendingExceptions(ByVal CompanyId As Nullable(Of Integer)) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If CompanyId.HasValue Then
            param = New SqlParameter("@CompanyId", SqlDbType.Int)
            param.Value = CompanyId.Value
            params.Add(param)
        End If

        Return SqlHelper.GetDataTable("stp_NonDeposit_GetPendingExceptions", CommandType.StoredProcedure, params.ToArray)

    End Function

    Public Shared Function GetPendingCancellations(ByVal CompanyId As Nullable(Of Integer)) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If CompanyId.HasValue Then
            param = New SqlParameter("@LawFirmId", SqlDbType.Int)
            param.Value = CompanyId.Value
            params.Add(param)
        End If

        Return SqlHelper.GetDataTable("stp_Nondeposit_getPendingCancellations", CommandType.StoredProcedure, params.ToArray)

    End Function

    Public Shared Function GetActiveMatterSubstatus() As DataTable
        Dim sb As New StringBuilder()
        sb.Append("select st.mattersubstatusid, st.MatterSubStatus from tblmattertypesubstatus mst ")
        sb.Append("inner join tblmattersubstatus st on st.mattersubstatusid = mst.mattersubstatusid ")
        sb.Append("inner join tblmatterstatus t on t.matterstatusid = st.matterstatusid ")
        sb.Append("where mst.mattertypeid = 5 and t.ismatteractive = 1")
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetMatterIdByReplacementAdHoc(ByVal AdHocAchId As Integer) As Integer
        Dim matterid As Nullable(Of Integer) = Nothing
        Dim sb As New StringBuilder()
        sb.Append("Select distinct n.matterid from tblnondeposit n ")
        sb.Append("inner join tblnondepositreplacement r on r.replacementid = n.currentreplacementid ")
        sb.Append("inner join tblmatter m on n.matterid = n.matterid ")
        sb.AppendFormat("where r.adhocachid = {0}", AdHocAchId)
        matterid = SqlHelper.ExecuteScalar(sb.ToString, CommandType.Text, Nothing)
        If matterid.HasValue Then
            Return matterid.Value
        Else
            Return 0
        End If
    End Function

    Public Shared Function GetClientEmailAdresses(ByVal ClientID As Integer) As DataTable
        Dim emails As String = String.Empty
        Dim sb As New StringBuilder()
        sb.Append("select p.emailaddress from tblperson p where p.emailaddress is not null ")
        sb.AppendFormat("and clientid = {0}", ClientID)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetValidClientEmailAdresses(ByVal ClientId As Integer) As String
        Dim emails As New List(Of String)
        Dim dt As DataTable = GetClientEmailAdresses(ClientId)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            For Each dr As DataRow In dt.Rows
                If IsValidEmailAddress(dr("emailaddress")) Then
                    emails.Add(dr("emailaddress").ToString.Trim)
                End If
            Next
        End If
        If emails.Count = 0 Then
            Return ""
        Else
            Return String.Join(",", emails.ToArray)
        End If

    End Function

    Public Shared Function IsValidEmailAddress(ByVal Email As String) As Boolean
        Return Regex.IsMatch(Email, "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$")
    End Function

    Public Shared Function SendLetterByEmail(ByVal FromAddress As String, ByVal EmailAddresses As String, ByVal DocPath As String) As Boolean
        Try
            Dim ldocs As New List(Of String)
            ldocs.Add(DocPath)
            'Send Doc By Email
            EmailHelper.SendMessage(FromAddress, EmailAddresses, "Personal and Confidential", "", ldocs)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Shared Sub RemoveCurrentReplacement(ByVal NonDepositId As Integer, ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@NonDepositId", SqlDbType.Int)
        param.Value = NonDepositId
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_NonDeposit_RemoveCurrentReplacement", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function GetClientData(ByVal MatterId As Integer) As DataTable
        Dim sb As New StringBuilder()
        sb.Append("select c.clientid, c.accountnumber from tblclient c ")
        sb.Append("inner join tblmatter m  on m.clientid = c.clientid ")
        sb.AppendFormat("where m.matterid = {0}", MatterId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text, Nothing)
    End Function

    Public Shared Sub DeleteMatter(ByVal MatterId As Integer, ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@MatterId", SqlDbType.Int)
        param.Value = MatterId
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_NonDeposit_DeleteMatter", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function GetExceptionData(ByVal ExceptionId As Integer) As DataTable
        Dim sb As New StringBuilder()
        sb.Append("select pl.clientid, pl.planid, pl.scheduleddate, pl.expecteddepositamount, e.fixed from tblnondepositexception e ")
        sb.Append("inner join tblplanneddeposit pl on pl.planid = e.planid ")
        sb.AppendFormat("where e.fixed = 0 and e.nondepositexceptionid = {0}", ExceptionId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text, Nothing)
    End Function

    Public Shared Sub UpdateException(ByVal ExceptionId As Integer, ByVal Fixed As Boolean, ByVal UserId As Integer)
        Dim strSql As String = String.Format("update tblnondepositexception set fixed = {0}, fixeddate = GetDate(), fixedby = {2}  Where nondepositexceptionid = {1} ", IIf(Fixed, 1, 0), ExceptionId, UserId)
        SqlHelper.ExecuteNonQuery(strSql, CommandType.Text, Nothing)
    End Sub

    Public Shared Sub DeleteFromCancellation(ByVal CancellationId As Integer, ByVal UserId As Integer)
        Dim strSql As String = String.Format("update tblnondepositpendingcancellation set deleted = GetDate(), deletedby = {1}  Where cancellationid = {0} ", CancellationId, UserId)
        SqlHelper.ExecuteNonQuery(strSql, CommandType.Text, Nothing)
    End Sub

    Public Shared Sub SetLetterToNoEmail(ByVal NonDepositLetterId As Integer)
        Dim strSql As String = String.Format("update tblnondepositletter set noemail = 1 Where nondepositletterid = {0} ", NonDepositLetterId)
        SqlHelper.ExecuteNonQuery(strSql, CommandType.Text, Nothing)
    End Sub

    Public Shared Function MatterExistsForPlannedDeposit(ByVal PlanId As Integer) As Boolean
        Dim strSql As String = String.Format("Select count(nondepositid) from tblnondeposit Where Planid = {0}", PlanId)
        Return CInt(SqlHelper.ExecuteScalar(strSql, CommandType.Text, Nothing)) > 0
    End Function

    Public Shared Sub MapChecks()
        SqlHelper.ExecuteNonQuery("stp_NonDeposit_MapChecksFIFO", CommandType.StoredProcedure, Nothing)
    End Sub

    Public Shared Sub ResolveException(ByVal ExceptionId As Integer, ByVal CreateMatter As Boolean, ByVal UserId As Integer)
        If CreateMatter Then
            Dim dt As DataTable = GetExceptionData(ExceptionId)
            If dt.Rows.Count > 0 Then
                Dim ClientId As Integer = dt.Rows(0)("clientid")
                Dim PlanId As Integer = dt.Rows(0)("planid")
                Dim ScheduledDate As DateTime = dt.Rows(0)("scheduleddate")
                Dim Amount As Decimal = dt.Rows(0)("expecteddepositamount")
                If Not NonDepositHelper.MatterExistsForPlannedDeposit(PlanId) Then
                    NonDepositHelper.InsertMatter(ClientId, 1, ScheduledDate, Amount, Nothing, UserId, PlanId)
                End If
            End If
        End If
        NonDepositHelper.UpdateException(ExceptionId, True, UserId)
    End Sub

    Public Shared Function GetOpenNonDepositsByClientId(ByVal ClientId As Integer) As DataTable
        Dim sb As New StringBuilder()
        sb.Append("select n.nondepositid, n.matterid from tblnondeposit n ")
        sb.Append("inner join tblmatter m on m.matterid = n.matterid ")
        sb.AppendFormat("where  m.matterstatusid in (1,3) and n.clientid = {0}", ClientId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetLettersToEmail() As DataTable
        Return SqlHelper.GetDataTable("stp_NonDeposit_GetPendingLettersToPrint", CommandType.StoredProcedure, Nothing)
    End Function

    'Batch Email
    Public Shared Function EmailNonDepositLetters(ByVal UserId As Integer) As Integer
        Dim docCnt As Integer = 0
        Dim dt As DataTable = NonDepositHelper.GetLettersToEmail
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            For Each dr As DataRow In dt.Rows
                If NonDepositHelper.EmailNonDepositLetter(dr, UserId) Then docCnt += 1
            Next
        End If
        Return docCnt
    End Function

    'Individual Email
    Public Shared Function EmailNonDepositLetter(ByVal NondepositLetterId As Integer, ByVal UserID As Integer) As Boolean
        Dim dt As DataTable = NonDepositHelper.GetNonDepositLetterToPrint(NondepositLetterId)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            Return NonDepositHelper.EmailNonDepositLetter(dt.Rows(0), UserID)
        Else
            Return False
        End If
    End Function

    'Send Letter By Email
    Private Shared Function EmailNonDepositLetter(ByVal dr As DataRow, ByVal UserId As Integer) As Boolean
        Dim NonDepositLetterId = dr("NonDepositLetterId")
        Dim DataClientId As Integer = dr("ClientId")
        Dim LetterToSend As String = dr("LetterType")
        Dim DocPath As String = ""

        If Not dr("Filename") Is DBNull.Value AndAlso File.Exists(dr("Filename").ToString.Trim) Then
            DocPath = dr("Filename").ToString.Trim
        Else
            DocPath = NonDepositHelper.GenerateLetter(NonDepositLetterId, UserId)
        End If

        Dim emails As String = NonDepositHelper.GetValidClientEmailAdresses(DataClientId)
        Dim sentToEmail As Boolean = False
        If emails.Trim.Length > 0 Then
            sentToEmail = NonDepositHelper.SendLetterByEmail("donotreply@lawfirmcs.com", emails, DocPath)
            ReportsHelper.InsertPrintInfo(LetterToSend, DataClientId, DocPath.Substring(DocPath.LastIndexOf("\")), UserId, 1)
            'Clean Letter from Queue
            NonDepositHelper.UpdateLetter(NonDepositLetterId, "", Now, UserId, sentToEmail)
            Return True
        Else
            NonDepositHelper.SetLetterToNoEmail(NonDepositLetterId)
            Return False
        End If
    End Function

End Class
