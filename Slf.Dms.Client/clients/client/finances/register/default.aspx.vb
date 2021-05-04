Option Explicit On

Imports LocalHelper

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing

Partial Class clients_client_finances_register_default
    Inherits PermissionPage

#Region "Variables"

    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

    Private relations As New List(Of SharedFunctions.DocRelation)

#End Region

#Region "Structures"
    Public Structure RegisterTransaction
        Public RegisterFirst As Integer
        Public ID As Integer
        Public [Date] As Date
        Public CheckNumber As Object
        Public EntryTypeID As Integer
        Public EntryTypeName As String
        Public OriginalAmount As Object
        Public Amount As Double
        Public SDABalance As Double
        Public PFOBalance As Double
        Public [Description] As String
        Public AccountID As Object
        Public AccountCreditorName As String
        Public AccountNumber As String
        Public AccountCurrentAmount As Double
        Public AdjustedRegisterID As Object
        Public AdjustedRegisterTransactionDate As Date
        Public AdjustedRegisterEntryTypeID As Integer
        Public AdjustedRegisterEntryTypeName As String
        Public AdjustedRegisterAccountID As Object
        Public AdjustedRegisterAccountCreditorName As String
        Public AdjustedRegisterAccountNumber As String
        Public ACHMonth As Object
        Public ACHYear As Object
        Public FeeMonth As Object
        Public FeeYear As Object
        Public BouncedOrVoided As Boolean
        Public NumNotes As Integer
        Public NumPhoneCalls As Integer
        Public RelatedIds As List(Of String)

        Public Sub New(ByVal _RegisterFirst As Integer, ByVal _ID As Integer, ByVal _Date As Date, ByVal _CheckNumber As Object, _
            ByVal _EntryTypeID As Integer, ByVal _EntryTypeName As String, ByVal _OriginalAmount As Object, ByVal _Amount As Double, _
            ByVal _SDABalance As Double, ByVal _PFOBalance As Double, ByVal _Description As String, ByVal _AccountID As Object, _
            ByVal _AccountCreditorName As String, ByVal _AccountNumber As String, ByVal _AccountCurrentAmount As Double, _
            ByVal _AdjustedRegisterID As Object, ByVal _AdjustedRegisterTransactionDate As Date, ByVal _AdjustedRegisterEntryTypeID As Integer, _
            ByVal _AdjustedRegisterEntryTypeName As String, ByVal _AdjustedRegisterAccountID As Object, _
            ByVal _AdjustedRegisterAccountCreditorName As String, ByVal _AdjustedRegisterAccountNumber As String, ByVal _ACHMonth As Object, _
            ByVal _ACHYear As Object, ByVal _FeeMonth As Object, ByVal _FeeYear As Object, ByVal _BouncedOrVoided As Boolean, ByVal _NumNotes As Integer, _
            ByVal _NumPhoneCalls As Integer)

            Me.AccountCreditorName = _AccountCreditorName
            Me.AccountCurrentAmount = _AccountCurrentAmount
            Me.AccountID = _AccountID
            Me.AccountNumber = _AccountNumber
            Me.ACHMonth = _ACHMonth
            Me.ACHYear = _ACHYear
            Me.AdjustedRegisterAccountCreditorName = _AdjustedRegisterAccountCreditorName
            Me.AdjustedRegisterAccountID = _AdjustedRegisterAccountID
            Me.AdjustedRegisterAccountNumber = _AdjustedRegisterAccountNumber
            Me.AdjustedRegisterEntryTypeID = _AdjustedRegisterEntryTypeID
            Me.AdjustedRegisterEntryTypeName = _AdjustedRegisterEntryTypeName
            Me.AdjustedRegisterID = _AdjustedRegisterID
            Me.AdjustedRegisterTransactionDate = _AdjustedRegisterTransactionDate
            Me.Amount = _Amount
            Me.BouncedOrVoided = _BouncedOrVoided
            Me.CheckNumber = _CheckNumber
            Me.[Description] = _Description
            Me.EntryTypeID = _EntryTypeID
            Me.EntryTypeName = _EntryTypeName
            Me.FeeMonth = _FeeMonth
            Me.FeeYear = _FeeYear
            Me.NumNotes = _NumNotes
            Me.NumPhoneCalls = _NumPhoneCalls
            Me.OriginalAmount = _OriginalAmount
            Me.PFOBalance = _PFOBalance
            Me.RegisterFirst = _RegisterFirst
            Me.ID = _ID
            Me.SDABalance = _SDABalance
            Me.[Date] = _Date
            Me.RelatedIds = New List(Of String)
            Me.RelatedIds.Add(_ID.ToString)
        End Sub
    End Structure
#End Region

#Region "rpFeeAdjustments_Display"

    Public Function rpFeeAdjustments_Redirect(ByVal Row As RepeaterItem) As String

        Dim ID As Integer = DataHelper.Nz_int(DataBinder.Eval(Row, "ID"), 0)

        Return ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & ClientID & "&rid=" & ID)

    End Function
    Public Function rpFeeAdjustments_ArrowDirection(ByVal Amount As Double)

        If Amount < 0 Then
            Return "<img src=""" & ResolveUrl("~/images/12x13_arrow_up.png") & """ align=""absmiddle"" title=""Up"" />"
        Else
            Return "<img src=""" & ResolveUrl("~/images/12x13_arrow_down.png") & """ align=""absmiddle"" title=""Down"" />"
        End If

    End Function
    Public Function rpFeeAdjustments_Amount(ByVal Amount As Double)

        If Amount > 0 Then
            Return "<font style=""color:red;"">" & (Amount * -1).ToString("$#,##0.00") & "</font>"
        Else
            Return (Amount * -1).ToString("$#,##0.00")
        End If

    End Function

#End Region

#Region "rpTransactions_Display"

    Public Function rpTransactions_RowStyle(ByVal Row As RegisterTransaction) As String

        Dim BouncedOrVoided As Boolean = Row.BouncedOrVoided

        If BouncedOrVoided Then
            Return "style=""background-color:rgb(255,210,210);"""
        Else
            Return ""
        End If

    End Function
    Public Function rpTransactions_Notes(ByVal Row As RegisterTransaction) As String

        Dim NumNotes As Integer = StringHelper.ParseInt(Convert.ToString(Row.NumNotes))
        Dim NumPhoneCalls As Integer = StringHelper.ParseInt(Convert.ToString(Row.NumPhoneCalls))

        If NumNotes > 0 Or NumPhoneCalls > 0 Then
            Return "<img src=""" & ResolveUrl("~/images/11x16_paperclip.png") & """ border=""0"" />"
        Else
            Return "&nbsp;"
        End If

    End Function
    Public Function rpTransactions_Associations(ByVal Row As RegisterTransaction) As String
        Dim EntryTypeID As Integer = Row.EntryTypeID
        Dim EntryTypeName As String = Row.EntryTypeName
        Dim AdjustedRegisterID As Object = Row.AdjustedRegisterID
        Dim AccountID As Object = Row.AccountID

        Dim Parts As New List(Of String)

        If Not AdjustedRegisterID Is DBNull.Value Then

            Dim Icon As String = String.Empty
            Dim Account As String = String.Empty

            Dim Amount As Double = Row.Amount
            Dim AdjustedRegisterEntryTypeName As String = Row.AdjustedRegisterEntryTypeName
            Dim AdjustedRegisterAccountID As Object = Row.AdjustedRegisterAccountID

            If Not EntryTypeName = "Payment" Then
                If Amount < 0 Then
                    Icon = "<img style=""margin-right:8;"" src=""" & ResolveUrl("~/images/12x13_arrow_up.png") & """ align=""absmiddle"" title=""Up"" />"
                Else
                    Icon = "<img style=""margin-right:8;"" src=""" & ResolveUrl("~/images/12x13_arrow_down.png") & """ align=""absmiddle"" title=""Down"" />"
                End If
            End If

            If Not AdjustedRegisterAccountID Is DBNull.Value Then

                Dim AdjustedRegisterAccountCreditorName As String = Row.AdjustedRegisterAccountCreditorName
                Dim AdjustedRegisterAccountNumber As String = Row.AdjustedRegisterAccountNumber

                If AdjustedRegisterAccountNumber.Length > 3 Then
                    Account = AdjustedRegisterAccountCreditorName & " ****" & AdjustedRegisterAccountNumber.Substring(AdjustedRegisterAccountNumber.Length - 4)
                Else
                    Account = AdjustedRegisterAccountNumber
                End If

                If Account.Length > 0 Then
                    Account = " - " & Account
                End If

            End If

            Parts.Add(Icon & AdjustedRegisterEntryTypeName & Account)

        ElseIf EntryTypeID = 1 Then 'maintenance fee

            Dim FeeMonth As Object = Row.FeeMonth
            Dim FeeYear As Object = Row.FeeYear

            If Not FeeMonth Is DBNull.Value AndAlso Not FeeYear Is DBNull.Value Then
                Parts.Add(New DateTime(FeeYear, FeeMonth, 1).ToString("MMMM yyyy"))
            End If

        ElseIf EntryTypeID = 3 Then 'deposit

            Dim CheckNumber As String = Row.CheckNumber
            Dim ACHMonth As Object = Row.ACHMonth
            Dim ACHYear As Object = Row.ACHYear

            If CheckNumber.Length > 0 Then
                Parts.Add("CHK # " & CheckNumber)
            End If

            If Not ACHMonth Is DBNull.Value AndAlso Not ACHYear Is DBNull.Value Then
                Parts.Add("ACH for " & New DateTime(ACHYear, ACHMonth, 1).ToString("MMM yyyy"))
            End If

        ElseIf Not AccountID Is DBNull.Value Then

            Dim AccountCreditorName As String = Row.AccountCreditorName
            Dim AccountNumber As String = Row.AccountNumber

            If AccountNumber.Length > 3 Then
                Parts.Add(AccountCreditorName & " ****" & AccountNumber.Substring(AccountNumber.Length - 4))
            Else
                Parts.Add(AccountNumber)
            End If

        End If

        If Parts.Count > 0 Then
            Return String.Join(", ", Parts.ToArray())
        Else
            Return "&nbsp;"
        End If

    End Function
    Public Function rpTransactions_Amount(ByVal OriginalAmount As Object, ByVal Amount As Double) As String

        If Not OriginalAmount Is DBNull.Value Then
            Return Math.Abs(CType(OriginalAmount, Double)).ToString("$#,##0.00")
        Else
            Return Math.Abs(Amount).ToString("$#,##0.00")
        End If

    End Function
    Public Function rpTransactions_SDABalance(ByVal SDABalance As Double) As String

        If SDABalance < 0 Then
            Return "<font style=""color:red;"">" & SDABalance.ToString("$#,##0.00") & "</font>"
        Else
            Return SDABalance.ToString("$#,##0.00")
        End If

    End Function
    Public Function rpTransactions_PFOBalance(ByVal PFOBalance As Double) As String

        If PFOBalance < 0 Then
            Return "<font style=""color:red;"">" & PFOBalance.ToString("$#,##0.00") & "</font>"
        Else
            Return PFOBalance.ToString("$#,##0.00")
        End If

    End Function
    Public Function rpTransactions_Redirect(ByVal Row As RegisterTransaction) As String

        Dim ID As Integer = Row.ID
        Dim EntryTypeID As Integer = StringHelper.ParseInt(Row.EntryTypeID)
        Dim EntryTypeName As String = Convert.ToString(Row.EntryTypeName)

        If EntryTypeID = -1 And EntryTypeName = "Payment" Then
            Return ResolveUrl("~/clients/client/finances/bytype/payment.aspx?id=" & ClientID & "&rpid=" & ID)
        Else
            Return ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & ClientID & "&rid=" & ID)
        End If

    End Function

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = StringHelper.ParseInt(User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            ClientID = StringHelper.ParseInt(qs("id"), 0)

            If Not IsPostBack Then
                relations = SharedFunctions.DocumentAttachment.GetRelationsForClient(ClientID)
                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/?id=" & ClientID

                hdnReason.Value = ""

                LoadValues(GetControls(), Me)
                LoadTransactions()

                If ddlType.SelectedValue = "0" Then 'group adjustments view
                    tdVoidConfirm.Style.Remove("display")
                    tdSeparator.Style.Remove("display")
                    tdDeleteConfirm.Style.Remove("display")
                End If
            End If

            SetRollups()
        End If

    End Sub

    Public Function GetAttachmentText(ByVal id As Integer, ByVal type As String) As String
        For Each rel As SharedFunctions.DocRelation In relations
            If rel.RelationID = id And rel.RelationType = type Then
                Return "<img src=""" + ResolveUrl("~/images/11x16_paperclip.png") + """ border="""" alt="""" />"
            End If
        Next

        Return "&nbsp"
    End Function

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(ddlType.ID, ddlType)
        c.Add(chkHideBouncedVoided.ID, chkHideBouncedVoided)

        Return c

    End Function
    Private Sub LoadTransactions()
        Dim trans As New List(Of RegisterTransaction)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTransactions")

        Dim RegisterWhere As String = "r.ClientID = " & ClientID
        Dim PaymentWhere As String = "r.ClientID = " & ClientID

        If ddlType.SelectedValue = "0" Then 'group adjustments
            RegisterWhere += " AND r.AdjustedRegisterID IS NULL"
        End If

        If chkHideBouncedVoided.Checked Then
            RegisterWhere += " AND (r.Bounce IS NULL AND r.Void IS NULL)"
            PaymentWhere += " AND (rp.Bounced = 0 AND rp.Voided = 0)"
        End If

        If RegisterWhere.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "RegisterWhere", "WHERE (" & RegisterWhere & ")")
        End If

        If PaymentWhere.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "PaymentWhere", "WHERE (" & PaymentWhere & ")")
        End If

        DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY Date, RegisterFirst, ID")

        Dim Registers As New List(Of Register)

        Using cmd
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        trans.Add(New RegisterTransaction(DataHelper.Nz_int(reader("RegisterFirst")), DataHelper.Nz(reader("ID")), _
                        DataHelper.Nz_date(reader("Date")), DataHelper.Nz(reader("CheckNumber"), 0), DataHelper.Nz_int(reader("EntryTypeID")), _
                        DataHelper.Nz_string(reader("EntryTypeName")), DataHelper.Nz(reader("OriginalAmount"), DBNull.Value), DataHelper.Nz_double(reader("Amount")), _
                        DataHelper.Nz_double(reader("SDABalance")), DataHelper.Nz_double(reader("PFOBalance")), reader("Description").ToString(), _
                        DataHelper.Nz(reader("AccountID"), DBNull.Value), DataHelper.Nz_string(reader("AccountCreditorName")), DataHelper.Nz_string(reader("AccountNumber")), DataHelper.Nz_double(reader("AccountCurrentAmount")), _
                        DataHelper.Nz(reader("AdjustedRegisterID"), DBNull.Value), DataHelper.Nz_date(reader("AdjustedRegisterTransactionDate")), DataHelper.Nz_int(reader("AdjustedRegisterEntryTypeID")), DataHelper.Nz_string(reader("AdjustedRegisterEntryTypeName")), _
                        DataHelper.Nz(reader("AdjustedRegisterAccountID"), DBNull.Value), DataHelper.Nz_string(reader("AdjustedRegisterAccountCreditorName")), DataHelper.Nz_string(reader("AdjustedRegisterAccountNumber")), _
                        DataHelper.Nz(reader("ACHMonth"), DBNull.Value), DataHelper.Nz(reader("ACHYear"), DBNull.Value), DataHelper.Nz(reader("FeeMonth"), DBNull.Value), _
                        DataHelper.Nz(reader("FeeYear"), DBNull.Value), DataHelper.Nz_bool(reader("BouncedOrVoided")), DataHelper.Nz_int(reader("NumNotes")), _
                        DataHelper.Nz_int(reader("NumPhoneCalls"))))
                    End While
                End Using
            End Using
        End Using

        'If UserID = 531 Then
        'rpTransactions.DataSource = trans
        'Else
        rpTransactions.DataSource = CombinePayment(CombineFee(trans))
        'End If

        rpTransactions.DataBind()
    End Sub
    Private Function CombineFee(ByVal trans As List(Of RegisterTransaction)) As List(Of RegisterTransaction)
        Dim results As New List(Of RegisterTransaction)
        Dim temp As RegisterTransaction
        Dim compare1 As Object
        Dim compare2 As Object

        For Each tran As RegisterTransaction In trans
            temp = tran
            If tran.EntryTypeID = 42 Then
                For Each match As RegisterTransaction In trans
                    If match.EntryTypeID = 2 Then
                        If tran.AdjustedRegisterAccountID Is DBNull.Value Then
                            compare1 = tran.AccountID
                        Else
                            compare1 = tran.AdjustedRegisterAccountID
                        End If

                        If match.AdjustedRegisterAccountID Is DBNull.Value Then
                            compare2 = match.AccountID
                        Else
                            compare2 = match.AdjustedRegisterAccountID
                        End If

                        If compare1.Equals(compare2) And tran.BouncedOrVoided = False And match.BouncedOrVoided = False Then
                            temp.Amount += match.Amount
                            temp.RelatedIds.Add(match.ID)
                            Exit For
                        End If
                    End If
                Next
            End If

            If Not HasWeighted(temp, trans) Then
                results.Add(temp)
            End If
        Next

        Return results
    End Function
    Private Function CombinePayment(ByVal trans As List(Of RegisterTransaction)) As List(Of RegisterTransaction)
        Dim results As New List(Of RegisterTransaction)
        Dim temp As RegisterTransaction
        Dim noAdd As New List(Of Integer)

        For Each tran As RegisterTransaction In trans
            temp = tran

            If tran.EntryTypeID = -1 Then
                For Each match As RegisterTransaction In trans
                    If match.EntryTypeID = -1 And Not match.ID = tran.ID Then
                        If tran.AdjustedRegisterAccountID.Equals(match.AdjustedRegisterAccountID) And Not match.AdjustedRegisterAccountID.Equals(DBNull.Value) And tran.AccountID.Equals(match.AccountID) And Not match.AccountID.Equals(DBNull.Value) And match.BouncedOrVoided = False And tran.BouncedOrVoided = False Then
                            temp.Amount += match.Amount
                            temp.RelatedIds.Add(match.ID)
                            noAdd.Add(match.ID)
                        End If
                    End If
                Next
            End If

            If Not (tran.EntryTypeID = -1 And noAdd.Contains(tran.ID)) Then
                results.Add(temp)
            End If
        Next

        Return results
    End Function
    Private Function HasWeighted(ByVal tran As RegisterTransaction, ByVal trans As List(Of RegisterTransaction)) As Boolean
        For Each match As RegisterTransaction In trans
            If tran.AccountID.Equals(match.AccountID) And tran.EntryTypeID = 2 And match.EntryTypeID = 42 Then
                Return True
            End If
        Next

        Return False
    End Function
    Private Sub SetRollups()
        If Master.UserEdit Then
            Master.CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""Record_AddTransaction();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction.png") & """ align=""absmiddle""/>Add transaction</a>")
        End If

        Master.CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""VoidTransactions();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_entrytype.png") & """ align=""absmiddle""/>Void Transactions</a>")

        Master.CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""ViewStatements();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_Email_Send.png") & """ align=""absmiddle""/>Client Statements</a>")
    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Requery(ByVal OrderBy As String)

        Dim qsb As New QueryStringBuilder(Request.Url.Query)

        If Not OrderBy Is Nothing Then

            If OrderBy.ToLower = "transactiondate desc" Then
                qsb.Remove("ob")
            Else
                qsb("ob") = OrderBy
            End If

        End If

        Dim qs As String = qsb.QueryString

        If qs.Length > 0 Then
            qs = "?" & qs
        End If

        Response.Redirect("~/clients/client/finances/register/" & qs)

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'don't do cleanup on each remove; cleanup client after all removes are done
        RegisterHelper.Remove(GetSelectedRegisterIDs, UserID, False)
        RegisterPaymentHelper.Remove(GetSelectedRegisterPaymentIDs, False)

        ClientHelper.CleanupRegister(ClientID)

        Reload()

    End Sub
    Protected Sub lnkVoid_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVoid.Click

        'insert records for plaza clients
        Dim sqlText As String = ""
        ''Move this logic to the stored procs
        'For Each regID As Integer In GetSelectedRegisterIDs()
        '    'get all registry entries that have a payment and not voided already
        '    sqlText = "select top 1 r.RegisterID,r.ClientID, c.accountnumber as [ClientAcctNum], "
        '    sqlText += "r.AccountID,r.TransactionDate, abs(r.Amount) [Amount], r.EntryTypeID, c.trustid,t.name as [TrustName],c.companyid,rp.RegisterPaymentID, "
        '    sqlText += "e.type as [EntryType] from tblregister as r inner join tblClient as c on r.clientid = c.clientid "
        '    sqlText += "inner join tblentrytype as e on r.entrytypeid=e.entrytypeid inner join tblTrust as t on c.trustid=t.trustid "
        '    sqlText += "left outer join tblregisterpayment as rp on rp.feeregisterid = r.registerid "
        '    sqlText += "where r.void is null and r.registerid = " & regID
        '    Dim dtData As DataTable = Me.GetDataTable(sqlText)
        '    For Each drow As DataRow In dtData.Rows
        '        If drow("trustid").ToString = "22" And (drow("entrytype").ToString.ToLower = "credit" Or drow("RegisterPaymentID") IsNot DBNull.Value) Then
        '            'Edit 7/24/08 - jhernandez
        '            'Set the Flow to credit which will credit the shadow store the voided payment amount.
        '            Dim sqlInsert As String = "INSERT INTO tblNachaRegister2 (Name ,AccountNumber ,RoutingNumber ,Type ,Amount, IsPersonal , "
        '            sqlInsert += "CommRecId ,CompanyId ,ShadowStoreId ,ClientID ,TrustID ,RegisterID ,RegisterPaymentID, Flow) "
        '            sqlInsert += "VALUES ('@TrustName',Null,Null,null,@Amount,0,null,@CompanyID ,@ClientAcctNum ,@Clientid ,@trustid , @registerid ,@RegisterPaymentID, 'credit')"
        '            sqlInsert = sqlInsert.Replace("@TrustName", drow("TrustName").ToString)
        '            sqlInsert = sqlInsert.Replace("@Amount", drow("Amount").ToString)
        '            sqlInsert = sqlInsert.Replace("@CompanyID", drow("CompanyID").ToString)
        '            sqlInsert = sqlInsert.Replace("@ClientAcctNum", drow("ClientAcctNum").ToString)
        '            sqlInsert = sqlInsert.Replace("@Clientid", drow("Clientid").ToString)
        '            sqlInsert = sqlInsert.Replace("@trustid", drow("trustid").ToString)
        '            sqlInsert = sqlInsert.Replace("@registerid", drow("registerid").ToString)
        '            sqlInsert = sqlInsert.Replace("@RegisterPaymentID", IIf(drow("RegisterPaymentID") Is DBNull.Value, "Null", drow("RegisterPaymentID").ToString))
        '            Me.dbExecuteNonScalar(sqlInsert)
        '            Exit For
        '        End If
        '    Next
        'Next
        'For Each regPayID As Integer In GetSelectedRegisterPaymentIDs()
        '    'get all payments that don't have a register entry and not voided already

        '    'Edit 7/21/08 - jhernandez
        '    'Get amount from tblRegisterPayment. Voided payment might not be for the entire fee amount.
        '    sqlText = "select top 1 r.RegisterID,r.ClientID, c.accountnumber as [ClientAcctNum], "
        '    sqlText += "r.AccountID,r.TransactionDate, abs(rp.Amount) [Amount], r.EntryTypeID, c.trustid,t.name as [TrustName],c.companyid,rp.RegisterPaymentID, "
        '    sqlText += "e.type as [EntryType] from tblregister as r inner join tblClient as c on r.clientid = c.clientid "
        '    sqlText += "inner join tblentrytype as e on r.entrytypeid=e.entrytypeid inner join tblTrust as t on c.trustid=t.trustid "
        '    sqlText += "join tblregisterpayment as rp on rp.feeregisterid = r.registerid "
        '    sqlText += "where rp.voided <> 1 and rp.RegisterPaymentID = " & regPayID
        '    Dim dtData As DataTable = Me.GetDataTable(sqlText)
        '    For Each drow As DataRow In dtData.Rows
        '        If drow("trustid").ToString = "22" Then
        '            'Edit 7/24/08 - jhernandez
        '            'Set the Flow to credit which will credit the shadow store the voided payment amount.
        '            Dim sqlInsert As String = "INSERT INTO tblNachaRegister2 (Name ,AccountNumber ,RoutingNumber ,Type ,Amount, IsPersonal , "
        '            sqlInsert += "CommRecId ,CompanyId ,ShadowStoreId ,ClientID ,TrustID ,RegisterID ,RegisterPaymentID, Flow) "
        '            sqlInsert += "VALUES ('@TrustName',Null,Null,null,@Amount,0,null,@CompanyID ,@ClientAcctNum ,@Clientid ,@trustid , @registerid ,@RegisterPaymentID, 'credit')"
        '            sqlInsert = sqlInsert.Replace("@TrustName", drow("TrustName").ToString)
        '            sqlInsert = sqlInsert.Replace("@Amount", drow("Amount").ToString)
        '            sqlInsert = sqlInsert.Replace("@CompanyID", drow("CompanyID").ToString)
        '            sqlInsert = sqlInsert.Replace("@ClientAcctNum", drow("ClientAcctNum").ToString)
        '            sqlInsert = sqlInsert.Replace("@Clientid", drow("Clientid").ToString)
        '            sqlInsert = sqlInsert.Replace("@trustid", drow("trustid").ToString)
        '            sqlInsert = sqlInsert.Replace("@registerid", drow("registerid").ToString)
        '            sqlInsert = sqlInsert.Replace("@RegisterPaymentID", IIf(drow("RegisterPaymentID") Is DBNull.Value, "Null", drow("RegisterPaymentID").ToString))
        '            Me.dbExecuteNonScalar(sqlInsert)
        '            Exit For
        '        End If
        '    Next
        'Next

        'don't do cleanup on each void; cleanup client after all voids are done
      RegisterHelper.Void(GetSelectedRegisterIDs, UserID, DateTime.Parse(hdnVoidDate.Value), False, hdnReason.Value)
      RegisterPaymentHelper.Void(GetSelectedRegisterPaymentIDs, False, UserID, hdnReason.Value)
        ClientHelper.CleanupRegister(ClientID)


        Reload()

    End Sub
    Private Function GetSelectedRegisterIDs() As Integer()

        If txtSelected.Value.Length > 0 Then

            'get selected "," delimited RegisterID's
            Dim Registers() As String = txtSelected.Value.Split(",")


            'build an actual integer array
            Dim RegisterIDs As New List(Of Integer)
            Dim regs As String()
            For Each Register As String In Registers
                If Not Register.Substring(0, 1) = "p" Then
                    regs = Register.Split("|")
                    For Each r As String In regs
                        RegisterIDs.Add(DataHelper.Nz_int(r))
                    Next
                End If
            Next

            Return RegisterIDs.ToArray()

        Else
            Return Nothing
        End If

    End Function
    Private Function GetSelectedRegisterPaymentIDs() As Integer()

        If txtSelected.Value.Length > 0 Then

            'get selected "," delimited RegisterID's
            Dim Registers() As String = txtSelected.Value.Split(",")

            'build an actual integer array
            Dim RegisterPaymentIDs As New List(Of Integer)
            Dim regs As String()
            For Each Register As String In Registers
                If Register.Substring(0, 1) = "p" Then
                    regs = Register.Substring(1).Split("|")
                    For Each r As String In regs
                        RegisterPaymentIDs.Add(DataHelper.Nz_int(r))
                    Next
                End If
            Next

            Return RegisterPaymentIDs.ToArray()

        Else
            Return Nothing
        End If

    End Function
    Private Sub Reload()
        Response.Redirect("~/clients/client/finances/register/?id=" & ClientID)
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
    Protected Sub rpTransactions_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpTransactions.ItemDataBound

        If ddlType.SelectedValue = 0 Then 'group adjustments

            Dim tdSelect As HtmlTableCell = e.Item.FindControl("tdSelect")
            Dim tdIcon As HtmlTableCell = e.Item.FindControl("tdIcon")
            Dim tdAttachments As HtmlTableCell = e.Item.FindControl("tdAttachments")
            Dim tdDate As HtmlTableCell = e.Item.FindControl("tdDate")
            Dim tdID As HtmlTableCell = e.Item.FindControl("tdID")
            Dim tdType As HtmlTableCell = e.Item.FindControl("tdType")
            Dim tdAssociatedTo As HtmlTableCell = e.Item.FindControl("tdAssociatedTo")
            Dim tdAmount As HtmlTableCell = e.Item.FindControl("tdAmount")
            Dim tdSDABalance As HtmlTableCell = e.Item.FindControl("tdSDABalance")
            Dim tdPFOBalance As HtmlTableCell = e.Item.FindControl("tdPFOBalance")
            Dim trFeeAdjustments As HtmlTableRow = e.Item.FindControl("trFeeAdjustments")
            Dim rpFeeAdjustments As Repeater = e.Item.FindControl("rpFeeAdjustments")

            LoadFeeAdjustments(rpFeeAdjustments, e.Item.DataItem.ID)

            If rpFeeAdjustments.Items.Count > 0 Then

                tdSelect.Attributes("class") = "listItem6"
                tdIcon.Attributes("class") = "listItem6"
                tdAttachments.Attributes("class") = "listItem6"
                tdDate.Attributes("class") = "listItem6"
                tdID.Attributes("class") = "listItem6"
                tdType.Attributes("class") = "listItem6"
                tdAssociatedTo.Attributes("class") = "listItem6"
                tdAmount.Attributes("class") = "listItem6"

                tdSDABalance.RowSpan = 2
                tdPFOBalance.RowSpan = 2

                tdSDABalance.VAlign = "top"
                tdPFOBalance.VAlign = "top"

                trFeeAdjustments.Visible = True

                Dim BouncedOrVoided As Boolean = e.Item.DataItem.BouncedOrVoided

                If BouncedOrVoided Then
                    trFeeAdjustments.Style("background-color") = "rgb(255,210,210)"
                End If

            Else

                tdSelect.Attributes("class") = "listItem4"
                tdIcon.Attributes("class") = "listItem4"
                tdAttachments.Attributes("class") = "listItem4"
                tdDate.Attributes("class") = "listItem4"
                tdID.Attributes("class") = "listItem4"
                tdType.Attributes("class") = "listItem4"
                tdAssociatedTo.Attributes("class") = "listItem4"
                tdAmount.Attributes("class") = "listItem4"

            End If

        End If

    End Sub
    Private Sub LoadFeeAdjustments(ByVal rp As Repeater, ByVal RegisterID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblRegister WHERE AdjustedRegisterID = " & RegisterID & "ORDER BY TransactionDate, RegisterID"

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    rp.DataSource = rd
                    rp.DataBind()

                End Using
            End Using
        End Using

    End Sub
    Protected Sub ddlType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlType.SelectedIndexChanged

        If ddlType.SelectedValue = "0" Then 'group adjustments
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlType'")
        Else
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "ddlType", "value", ddlType.SelectedValue)
        End If

        Refresh()

    End Sub
    Protected Sub chkHideBouncedVoided_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkHideBouncedVoided.CheckedChanged

        If Not chkHideBouncedVoided.Checked Then
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'chkHideBouncedVoided'")
        Else
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "chkHideBouncedVoided", "value", chkHideBouncedVoided.Checked)
        End If

        Refresh()

    End Sub
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
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
    Private Sub dbExecuteNonScalar(ByVal sqlCommandText As String)
        Dim sqlCMD As SqlCommand = Nothing
        Try
            sqlCMD = New SqlCommand(sqlCommandText, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString))
            sqlCMD.Connection.Open()
            sqlCMD.ExecuteNonQuery()
        Finally
            sqlCMD = Nothing
        End Try
        
    End Sub
End Class