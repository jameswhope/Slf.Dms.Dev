Imports System.Data
Imports System.Collections.Generic
Imports Drg.Util.DataAccess
Imports Slf.Dms.Records

Public Class SettlementCallResolution
    Private _settlement As SettlementMatterHelper.SettlementInformation
    Private _CallResolutionId As Integer
    Private _Settlementid As Integer
    Private _CreditorName As String = String.Empty
    Private _OrigCreditorName As String = String.Empty
    Private _CreditorAccountNumber As String = String.Empty
    Private _TaskId As Integer = 0
    Private _TaskResolution As String = String.Empty
    Private _MatterSubStatus As String = String.Empty
    Private _RecFile As String = String.Empty
    Private _RecId As Integer = 0
    Private _Resolved As Nullable(Of DateTime) = Nothing
    Private _ResolvedByUser As String

    Public Sub New(ByVal ResolutionId As Integer)
        _CallResolutionId = ResolutionId
    End Sub

    Public Property Settlement() As SettlementMatterHelper.SettlementInformation
        Get
            Return _settlement
        End Get
        Set(ByVal value As SettlementMatterHelper.SettlementInformation)
            _settlement = value
        End Set
    End Property

    Public Property CallResolutionId() As Integer
        Get
            Return _CallResolutionId
        End Get
        Set(ByVal value As Integer)
            _CallResolutionId = value
        End Set
    End Property

    Public Property SettlementId() As Integer
        Get
            Return _Settlementid
        End Get
        Set(ByVal value As Integer)
            _Settlementid = value
        End Set
    End Property

    Public Property CreditorAccountNumber() As String
        Get
            Return _CreditorAccountNumber
        End Get
        Set(ByVal value As String)
            _CreditorAccountNumber = value
        End Set
    End Property

    Public Property CreditorName() As String
        Get
            Return _CreditorName
        End Get
        Set(ByVal value As String)
            _CreditorName = value
        End Set
    End Property

    Public Property OriginalCreditorName() As String
        Get
            Return _OrigCreditorName
        End Get
        Set(ByVal value As String)
            _OrigCreditorName = value
        End Set
    End Property

    Public Property TaskId() As Integer
        Get
            Return _TaskId
        End Get
        Set(ByVal value As Integer)
            _TaskId = value
        End Set
    End Property

    Public Property TaskResolution() As String
        Get
            Return _TaskResolution
        End Get
        Set(ByVal value As String)
            _TaskResolution = value
        End Set
    End Property

    Public Property MatterSubStatus() As String
        Get
            Return _MatterSubStatus
        End Get
        Set(ByVal value As String)
            _MatterSubStatus = value
        End Set
    End Property

    Public Property RecFile() As String
        Get
            Return _RecFile
        End Get
        Set(ByVal value As String)
            _RecFile = value
        End Set
    End Property

    Public Property RecId() As Integer
        Get
            Return _RecId
        End Get
        Set(ByVal value As Integer)
            _RecId = value
        End Set
    End Property

    Public Property Resolved() As Nullable(Of DateTime)
        Get
            Return _Resolved
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            _Resolved = value
        End Set
    End Property

    Public ReadOnly Property ResolvedF() As String
        Get
            If Not _Resolved.HasValue OrElse Resolved.Value = New DateTime() Then
                Return ""
            Else
                Return _Resolved.Value.ToString
            End If
        End Get
    End Property

    Public Property ResolvedByUser() As String
        Get
            Return _ResolvedByUser
        End Get
        Set(ByVal value As String)
            _ResolvedByUser = value
        End Set
    End Property

End Class

Public Class NonDepositCallResolution
    Public Enum NonDepositTypes
        Missed = 1
        Bounced = 2
    End Enum
    Private _CallResolutionId As Integer
    Private _TaskId As Integer = 0
    Private _TaskResolution As String = String.Empty
    Private _MatterSubStatus As String = String.Empty
    Private _Resolved As Nullable(Of DateTime) = Nothing
    Private _ResolvedByUser As String
    Private _NonDepositId As Integer
    Private _NonDepositTypeId As Integer
    Private _NonDepositType As String
    Private _DepositDate As String = String.Empty
    Private _DepositAmount As Decimal
    Private _BouncedDate As String = String.Empty
    Private _DepositId As Integer
    Private _MatterId As Integer
    Private _MatterNumber As String
    Private _bouncedReasonDescription As String

    Public Sub New(ByVal ResolutionId As Integer)
        _CallResolutionId = ResolutionId
    End Sub

    Public Property CallResolutionId() As Integer
        Get
            Return _CallResolutionId
        End Get
        Set(ByVal value As Integer)
            _CallResolutionId = value
        End Set
    End Property

    Public Property TaskId() As Integer
        Get
            Return _TaskId
        End Get
        Set(ByVal value As Integer)
            _TaskId = value
        End Set
    End Property

    Public Property TaskResolution() As String
        Get
            Return _TaskResolution
        End Get
        Set(ByVal value As String)
            _TaskResolution = value
        End Set
    End Property

    Public Property MatterSubStatus() As String
        Get
            Return _MatterSubStatus
        End Get
        Set(ByVal value As String)
            _MatterSubStatus = value
        End Set
    End Property

    Public Property Resolved() As Nullable(Of DateTime)
        Get
            Return _Resolved
        End Get
        Set(ByVal value As Nullable(Of DateTime))
            _Resolved = value
        End Set
    End Property

    Public ReadOnly Property ResolvedF() As String
        Get
            If Not _Resolved.HasValue OrElse Resolved.Value = New DateTime() Then
                Return ""
            Else
                Return _Resolved.Value.ToString
            End If
        End Get
    End Property

    Public Property ResolvedByUser() As String
        Get
            Return _ResolvedByUser
        End Get
        Set(ByVal value As String)
            _ResolvedByUser = value
        End Set
    End Property

    Public Property NonDepositId() As Integer
        Get
            Return _NonDepositId
        End Get
        Set(ByVal value As Integer)
            _NonDepositId = value
        End Set
    End Property

    Public Property NonDepositTypeId() As Integer
        Get
            Return _NonDepositTypeId
        End Get
        Set(ByVal value As Integer)
            _NonDepositTypeId = value
        End Set
    End Property

    Public Property NonDepositType() As String
        Get
            Return _NonDepositType
        End Get
        Set(ByVal value As String)
            _NonDepositType = value
        End Set
    End Property

    Public Property DepositDate() As String
        Get
            Return _DepositDate
        End Get
        Set(ByVal value As String)
            _DepositDate = value
        End Set
    End Property

    Public Property BouncedDate() As String
        Get
            Return _BouncedDate
        End Get
        Set(ByVal value As String)
            _BouncedDate = value
        End Set
    End Property

    Public Property DepositID() As Integer
        Get
            Return _DepositId
        End Get
        Set(ByVal value As Integer)
            _DepositId = value
        End Set
    End Property

    Public Property MatterId() As Integer
        Get
            Return _MatterId
        End Get
        Set(ByVal value As Integer)
            _MatterId = value
        End Set
    End Property

    Public Property MatterNumber() As String
        Get
            Return _MatterNumber
        End Get
        Set(ByVal value As String)
            _MatterNumber = value
        End Set
    End Property

    Public Property DepositAmount() As Decimal
        Get
            Return _DepositAmount
        End Get
        Set(ByVal value As Decimal)
            _DepositAmount = value
        End Set
    End Property

    Public Property BouncedReasonDescription() As String
        Get
            Return _bouncedReasonDescription
        End Get
        Set(ByVal value As String)
            _bouncedReasonDescription = value
        End Set
    End Property

End Class

Partial Class CustomTools_UserControls_DialerCallX
    Inherits System.Web.UI.UserControl

#Region "Private Vars"
    Private _CallId As Integer
    Private _ClientId As Integer
    Private _UserId As Integer

    Dim _UserFullName As String = ""
    Dim _NonDepCount As Integer = 0


    Dim _LanguageId As Integer = 1
    Dim _Address As String = String.Empty
    Dim _Last4SSN As String = String.Empty
    Dim _DOB As String = String.Empty
#End Region

    Public Function GetClientId() As Integer
        Return _ClientId
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _CallId = Request.QueryString("CallId").ToString()
        _ClientId = Request.QueryString("Id").ToString
        _UserId = CInt(Page.User.Identity.Name)
        If Not Me.IsPostBack Then
            _UserFullName = DialerHelper.GetUserFullName(_UserId)
            LoadClientInfo()
            LoadCoapplicants()
            LoadCall()
            'Settlements
            LoadClientIssuesSettl()
            LoadClientRejectReasons()
            LoadSettlScript()
            'Non Deposit
            LoadClientIssuesNonDeposits()
            'Select default panel
            Select Case hdnDCallReasonId.Value
                Case "1"
                    Me.AcClientIssues.SelectedIndex = 0
                Case "2", "3"
                    If Me.AcClientIssues.Panes(0).Visible Then
                        Me.AcClientIssues.SelectedIndex = 1
                    Else
                        Me.AcClientIssues.SelectedIndex = 0
                    End If
            End Select
        End If
    End Sub

    Private Sub LoadClientInfo()
        Dim dt As DataTable = DialerHelper.GetClientData(_ClientId)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            Me.lblClientName.Text = dr("ClientName")
            Me.lblClientStatus.Text = dr("status")
            Me.lblClientAccountNumber.Text = dr("ClientAccountNumber")
            Me.lblLawFirm.Text = dr("LawFirm")
            Me.lblSSN.Text = LocalHelper.FormatSSN(dr("SSN"))
            If Not dr("DateOfBirth") Is DBNull.Value Then
                Me.lblDateOfBirth.Text = CDate(dr("DateOfBirth")).ToShortDateString
            Else
                Me.lblDateOfBirth.Text = "Not on file"
            End If
            Dim SDA As Double = 0
            Dim PFO As Double = 0
            Dim BankReserve As Double = 0
            Dim AvaiSDA As Double = 0
            Dim fundsOnHold As Double = 0
            ClientHelper2.GetBalances(_ClientId, SDA, BankReserve, AvaiSDA, PFO, fundsOnHold)
            Me.lblSDA.Text = String.Format("{0:c}", SDA)
            Me.lblBankRes.Text = String.Format("{0:c}", BankReserve)
            Me.lblPFO.Text = String.Format("{0:c}", PFO)
            Me.lblAvailableSDA.Text = String.Format("{0:c}", AvaiSDA)
            Me.lblAvailableSDA.ForeColor = IIf(AvaiSDA < 0, System.Drawing.Color.Red, Nothing)
            'Me.lblSDA.Text = String.Format("{0:c}", dr("SDABalance"))
            'Me.lblPFO.Text = String.Format("{0:c}", dr("PFOBalance"))
            Dim ds As DataSet = ClientHelper2.ExpectedDeposits(_ClientId, DateAdd(DateInterval.Day, 90, Now))
            If ds.Tables(1).Rows.Count > 0 Then
                Me.lblNextDepositDate.Text = Format(CDate(ds.Tables(1).Rows(0)("depositdate")), "MMM d, yyyy")
                Me.lblNextDepositAmount.Text = FormatCurrency(Val(ds.Tables(1).Rows(0)("depositamount")), 2)
            End If
            If Not dr("hardship") Is DBNull.Value Then
                hdnHardship.value = CDate(dr("hardship")).ToShortDateString
                ltrHardShip.Text = String.Format("<a href='" & ResolveUrl("~/") & "clients/client/hardship/?id={0}' >{1}</a>", _ClientId, Format(dr("hardship"), "M/d/yyyy"))
            Else
                hdnHardship.Value = ""
                ltrHardShip.Text = String.Format("<a href='" & ResolveUrl("~/") & "clients/client/hardship/?id={0}' >Not on file</a>", _ClientId)
            End If
            Dim cidrep As String = DialerHelper.GetCIDRep(_ClientId)
            If Not cidrep Is Nothing AndAlso cidrep.Trim.Length > 0 Then cidrep = "Agent: " & cidrep
            Me.lblCIDRep.Text = cidrep
            _LanguageId = dr("LanguageId")
            _Address = dr("Address")
            If _LanguageId <> 1 And _LanguageId <> 2 Then _LanguageId = 1
            SetSettlementLanguage()
            lblLegalFees.Text = String.Format("{0:c}", DialerHelper.GetMonthlyFee(_ClientId))
        End If
        grdClientBanking.DataSource = DialerHelper.GetClientBankInfo(_ClientId)
        grdClientBanking.DataBind()
    End Sub

    Private Sub LoadCall()
        Dim dt As DataTable = DialerHelper.GetDialerCall(_CallId)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            Dim pn As String = dr("phone")
            If pn.Length > 1 AndAlso pn.StartsWith("1") Then pn = pn.Substring(1)
            Me.lblPhoneNumber.Text = dr("phonetype") & " " & LocalHelper.FormatPhone(pn) & IIf(dr("ext").ToString.Trim.Length > 0, " ext. " & dr("ext").ToString.Trim, "")
            Me.hdnDPhoneId.Value = dr("phoneId")
            Me.hdnDPhoneNumber.Value = pn
            If Not dr("AnsweredDate") Is DBNull.Value Then
                Me.hdnDAnsweredDate.Value = dr("AnsweredDate")
            Else
                Me.hdnDAnsweredDate.Value = Now
            End If
            Me.hdnDCallReasonId.Value = dr("ReasonId")
            Me.imgClientPhone.Attributes.Add("onclick", String.Format("parent.make_call('{0}')", pn))
            Dim retryafter As DateTime
            If Not dr("RetryAfter") Is DBNull.Value Then
                retryafter = dr("RetryAfter")
            Else
                retryafter = Now.AddDays(1)
            End If
            Me.txtNextContactDate.Value = retryafter.ToShortDateString
            Me.txtNextContactTime.Value = retryafter.ToShortTimeString
            Dim resultId As Integer = 0
            If Not dr("resultid") Is DBNull.Value Then resultId = dr("resultid")
            Select Case resultId
                Case 1
                    RdPerson.Checked = True
                Case 2
                    RdAM.Checked = True
                Case 3
                    RdMessage.Checked = True
                Case 4
                    RdNoAnswer.Checked = True
                Case 8
                    RdBadNumber.Checked = True
                Case 5
                    rdBusy.Checked = True
            End Select
            Dim mc As Integer = DialerHelper.GetTodayMessagesLeftCount(_ClientId, dr("PhoneId"))
            lblCustomAni.Text = DialerHelper.GetOutboundAni(_ClientId, dr("ReasonId"))
            If mc > 0 Then
                RdMessage.Text = String.Format("Message <font color=""blue"">({0})</font>", mc)
            Else
                RdMessage.Text = "Message"
            End If
            If Not IsPostBack Then
                hdnPersonId.Value = DialerHelper.GetPersonIdByPhone(dr("PhoneId"))
                LoadPersonData(hdnPersonId.Value)
            End If
        End If
    End Sub

#Region "Settlements"
    Private Sub LoadClientIssuesSettl()
        Dim dt As DataTable
        Dim reasonId As Integer = 1
        If Not DialerHelper.CallIssuesCreated(_CallId, reasonId) Then
            Dim drReason As DataRow = DialerHelper.GetReason(reasonId)
            dt = DialerHelper.GetClientIssuesSettlements(_ClientId)
            For Each dr As DataRow In dt.Rows
                DialerHelper.InsertCallResolution(_CallId, drReason("ReasonId"), "tblTask", "TaskId", dr("TaskId"), Now.AddMinutes(drReason("DefaultExpiration")), _UserId)
            Next
        End If
        BindSettGrid()
    End Sub

    Private Sub BindSettGrid()
        Dim resolution As SettlementCallResolution = Nothing
        Dim lResolution As New List(Of SettlementCallResolution)

        Dim dt As DataTable = DialerHelper.GetCallResolutions4Settlements(_CallId)
        For Each dr As DataRow In dt.Rows
            resolution = New SettlementCallResolution(dr("CallResolutionId"))
            resolution.SettlementId = dr("settlementId")
            resolution.Settlement = SettlementMatterHelper.GetSettlementInformation(dr("settlementId"))
            If Not dr("CreditorAccountNumber") Is DBNull.Value Then resolution.CreditorAccountNumber = dr("CreditorAccountNumber")
            If Not dr("Creditor Name") Is DBNull.Value Then resolution.CreditorName = dr("Creditor Name")
            If Not dr("TaskResolution") Is DBNull.Value Then resolution.TaskResolution = dr("TaskResolution")
            If Not dr("MatterSubStatus") Is DBNull.Value Then resolution.MatterSubStatus = dr("MatterSubStatus")
            If Not dr("RecId") Is DBNull.Value Then resolution.RecId = dr("RecId")
            If Not dr("RecFile") Is DBNull.Value Then resolution.RecFile = dr("RecFile")
            If Not dr("Resolved") Is DBNull.Value Then resolution.Resolved = dr("Resolved")
            If Not dr("ResolvedByUser") Is DBNull.Value Then resolution.ResolvedByUser = dr("ResolvedByUser")
            If Not dr("TaskId") Is DBNull.Value Then resolution.TaskId = dr("TaskId")

            'Get Original Creditor
            resolution.OriginalCreditorName = GetOriginalCreditorName(resolution.Settlement.AccountID)
            lResolution.Add(resolution)
        Next
        Dim settCount As Integer = CalculatePendingIssues(dt)
        hdnSettCount.Value = settCount
        Me.rpSettlements.DataSource = lResolution
        Me.rpSettlements.DataBind()
        CType(Me.apPendingSettl.HeaderContainer.FindControl("ltrSettCount"), Literal).Text = String.Format(" ({0} of {1})", settCount, dt.Rows.Count)
        Me.apPendingSettl.Visible = (settCount > 0) OrElse hdnDCallReasonId.Value = "1"
    End Sub

    Public Function rpNR_CreditorName(ByVal Row As RepeaterItem) As String
        If Not IsDBNull(CType(Row.DataItem, SettlementCallResolution).OriginalCreditorName) AndAlso CType(Row.DataItem, SettlementCallResolution).OriginalCreditorName <> CType(Row.DataItem, SettlementCallResolution).CreditorName Then
            Return Convert.ToString(CType(Row.DataItem, SettlementCallResolution).OriginalCreditorName) & "<br>" & "<img style=""margin:3 0 0 5;"" src=""" _
                & ResolveUrl("~/") & "images/arrow_end.png"" align=""absmiddle"" border=""0"" />" _
                & Convert.ToString(CType(Row.DataItem, SettlementCallResolution).CreditorName)
        Else
            Return Convert.ToString(CType(Row.DataItem, SettlementCallResolution).CreditorName)
        End If
    End Function

    Private Function GetOriginalCreditorName(ByVal AccountId As Integer) As String
        Dim credName As String = ""
        Try
            Dim dt As DataTable = DialerHelper.GetCreditorInfo(AccountId)
            If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
                credName = dt.Rows(0)("ForCreditorName")
            End If
        Catch ex As Exception
            'Nothing
        End Try
        Return credName
    End Function

    Private Sub LoadClientRejectReasons()
        Me.ddlRejectReason.DataSource = DialerHelper.GetRejectReasons()
        Me.ddlRejectReason.DataValueField = "ReasonId"
        Me.ddlRejectReason.DataTextField = "ReasonName"
        Me.ddlRejectReason.DataBind()
    End Sub

    Protected Sub lnkReloadSett_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReloadSett.Click
        BindSettGrid()
    End Sub

    Private Sub RejectSettlement(ByVal SettlementID As Integer)
        SettlementMatterHelper.ResolveClientApproval(SettlementID, _UserId, "verbal", False, "", Me.ddlRejectReason.SelectedItem.Text, "", 0, "", "")
        BindSettGrid()
        Me.UpdateSetts.Update()
        ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "updtreject", String.Format("{0}.Close();", DialFlyout.getClientID), True)
    End Sub

    Protected Sub lnkRejectOK_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRejectOK.Click
        RejectSettlement(CInt(hdnCurrentSettId.Value))
    End Sub

    Private Function GetSettlementIntroScript(ByVal LanguageId As Integer) As String
        Dim sb As New System.Text.StringBuilder
        If LanguageId = 2 Then
            sb.AppendFormat(CreateP(CreateComment("Buenos días/Buenas tartes") & ", estoy intentando llamar a " & CreateComment("Sr. / Sra.") & " <b>{0}</b>. "), GetPersonDDL())
            sb.AppendFormat(CreateP("Hola, mi nombre es <b>{0}</b> estoy llamando por <b>{1}</b>. "), _UserFullName, Me.lblLawFirm.Text)
            sb.AppendFormat(CreateP("Quisiera informarle de que para fines de capacitación y de su propia seguridad esta llamada puede ser supervisada o grabada."))
            sb.AppendFormat(CreateP("Para fines de verificación puedo confirmar su dirección de casa y últimos 4 dígitos de su de su número de seguro social. " & CreateComment("Address: <b>{0}</b>, Last 4 SSN: <b>{1}</b>.")), _Address, _Last4SSN)
            'sb.Append(CreateP("[<i>Review notes and transaction</i>]"))
            If hdnHardship.Value.Trim.Length = 0 Then
                sb.AppendFormat(CreateP("Veo que no tenemos en el archivo sus ingresos y gastos, esta información ayuda a los procesos de negociación, se actualizará esta información al final de esta llamada."))
            End If
            sb.AppendFormat(CreateP("En este momento tenemos {0} ofertas de solución para usted: " & CreateComment("Read creditor name and last 4 digits account ending for each settlement")), hdnSettCount.Value)
            sb.Append(CreateP("Sólo tardará unos minutos para revisar la oferta de acuerdo con usted."))
        Else
            sb.AppendFormat(CreateP("Good " & CreateComment("morning/afternoon") & ", I am trying to reach " & CreateComment("Mr. / Mrs.") & " <b>{0}</b>. "), GetPersonDDL())
            sb.AppendFormat(CreateP("Hi, my name is <b>{0}</b> I am calling for <b>{1}</b>"), _UserFullName, Me.lblLawFirm.Text)
            sb.AppendFormat(CreateP("I would like to inform you that for training purposes and your own security this call may be monitored or recorded."))
            sb.AppendFormat(CreateP("For verification purposes can I please confirm your home address and last 4-digits of your of your Social Security number. " & CreateComment("Address: <b>{0}</b>, Last 4 SSN: <b>{1}</b>.")), _Address, _Last4SSN)
            'sb.Append(CreateP("[<i>Review notes and transaction</i>]"))
            If hdnHardship.Value.Trim.Length = 0 Then
                sb.AppendFormat(CreateP("I see we do not have a current hardship on file for you, which is your income and expenses, this information helps with the negotiation processes, I will update this information at the end of this call."))
            End If
            sb.AppendFormat(CreateP("At this time we have {0} settlement offer(s) for you: " & CreateComment("Read creditor name and last 4 digits account ending for each settlement")), hdnSettCount.Value)
            sb.Append(CreateP("It will just take a few minutes to go over the settlement offer with you."))
        End If
        Return sb.ToString
    End Function

    Public Function GetSettlementScript(ByVal Settlement As SettlementCallResolution) As String
        Dim sb As New System.Text.StringBuilder
        Dim ClientLastAccount As Boolean = (DialerHelper.GetNotSettleAccountCount(_ClientId) < 2)

        sb.Append(CreateBR("<u>Things to cover:</u>"))
        sb.Append("<ul  class=""coverlist"">")
        sb.Append(CreateLI("Name of original creditor and last 4-digits of account #."))
        sb.Append(CreateLI("Current Balance, Settlement Amount, Savings, Settlement Fees, Due Date, Overnight Delivery Cost."))
        sb.Append(CreateLI("Inform the client that settlement fees will be deducted from their SDA account as funds become available."))
        sb.Append(CreateLI("Any shortage to complete settlement (setup any rules/additional, which should be read back to the client for verification purposes"))
        sb.Append(CreateLI("Increase/decrease settlement amount by $10.00"))
        sb.Append(CreateLI("Payment arrangement (if applicable, explain the terms of the payment arrangement)"))
        sb.Append(CreateLI("Inform client once the account is paid the settlement acceptance form will be mailed with the finalized settlement kit in approx 2-3 weeks."))
        If ClientLastAccount Then
            sb.Append(CreateLI("If it's the client’s last account and the client has enough to cover the settlement fees with their SDA funds, remove banking information from any future drafts. Inform client their account will be closed and completed approx 2 weeks after the debt is paid and if any funds remain in their SDA they will be reimbursed at that time."))
        End If
        sb.Append(CreateLI("If the settlement fees will be paid down by their next draft, client is to be transferred to Finance Team to set that final payment up after verbal is acquired from the client."))
        sb.Append("</ul>")
        Return sb.ToString
    End Function

    Private Function GetSettlementAfterIntroScript(ByVal LanguageId As Integer) As String
        Dim sb As New System.Text.StringBuilder
        If LanguageId = 2 Then
            sb.Append(CreateP("Tiene preguntas adicionales sobre su cuenta o con respecto a las ofertas de liquidación que acabamos de analizar? " & CreateComment("Answer any additional questions")))
            sb.Append(CreateP(CreateComment("If there are multiple settlement offers and not sufficient funds to settle all the accounts, the client will have to decide which settlement offer to accept and which to decline.  Once the client has decided proceed with Settlement Verbal Script.")))
            'sb.Append(CreateP("[<i>Start recording the Settlement Verbal Script now</i>]"))
            sb.AppendFormat(CreateP("¿Tiene números adicionales o dirección de correo electrónico que le gustaría agregar en este momento?."))
            If _DOB.Trim.Length = 0 Then
                sb.AppendFormat(CreateP("¿Veo que no tenemos su fecha de nacimiento en el archivo, por favor puedo tomar esa información de usted?"))
            End If
            sb.Append(CreateP(CreateComment("Acquire any Hardship information that may need to be updated at this time and do the Closing Greeting.")))
            sb.Append(CreateP(CreateComment("If client needs to be transferred to Finance do so at this time and do the Closing Greeting.")))
        Else
            sb.Append(CreateP("Do you have any additional questions on your account or regarding the settlement offer(s) we have just discussed? " & CreateComment("Answer any additional questions")))
            sb.Append(CreateP(CreateComment("If there are multiple settlement offers and not sufficient funds to settle all the accounts, the client will have to decide which settlement offer to accept and which to decline.  Once the client has decided proceed with Settlement Verbal Script.")))
            'sb.Append(CreateP("[<i>Start recording the Settlement Verbal Script now</i>]"))
            sb.AppendFormat(CreateP("Do you have any additional numbers or email address you would like to add at this time?"))
            If _DOB.Trim.Length = 0 Then
                sb.AppendFormat(CreateP("I see we do not have your DOB on file, can I please that information from you?"))
            End If
            sb.Append(CreateP(CreateComment("Acquire any Hardship information that may need to be updated at this time and do the Closing Greeting.")))
            sb.Append(CreateP(CreateComment("If client needs to be transferred to Finance do so at this time and do the Closing Greeting.")))
        End If
        Return sb.ToString
    End Function

    Private Function GetSettlementClosingGreeting(ByVal LanguageId As Integer) As String
        Dim sb As New System.Text.StringBuilder
        If LanguageId = 2 Then
            sb.AppendFormat(CreateP("Gracias por hablar con <b>{0}</b> en el día de hoy. Otra vez mi nombre es  <b>{1}</b>, felicitaciones en su oferta de asentamiento."), Me.lblLawFirm.Text, _UserFullName)
        Else
            sb.AppendFormat("Thank You for your time with <b>{0}</b>. ", Me.lblLawFirm.Text)
            sb.AppendFormat("Again may name is <b>{0}</b>, congratulations on your settlement offer.", _UserFullName)
        End If
        Return sb.ToString
    End Function

    Private Sub LoadSettlScript()
        Me.ltrSettlementIntro.Text = Me.GetSettlementIntroScript(1)
        Me.ltrSettlementAfterIntro.Text = Me.GetSettlementAfterIntroScript(1)
        Me.ltrSettlementClosing.Text = Me.GetSettlementClosingGreeting(1)
        Me.ltrSettlementIntroSP.Text = Me.GetSettlementIntroScript(2)
        Me.ltrSettlementAfterIntroSP.Text = Me.GetSettlementAfterIntroScript(2)
        Me.ltrSettlementClosingSP.Text = Me.GetSettlementClosingGreeting(2)
    End Sub

    Private Function CreateP(ByVal s As String) As String
        Return String.Format("<p>{0}</p>", s)
    End Function

    Private Function CreateBR(ByVal s As String) As String
        Return String.Format("{0}<br/>", s)
    End Function

    Private Function CreateLI(ByVal s As String) As String
        Return String.Format("<li>{0}</li>", s)
    End Function

    Private Function CreateComment(ByVal s As String) As String
        Return String.Format("<font color=""rgb(60,60,60)"" style=""background-color: #FFFFFF;""><i>[{0}]</i></font>", s)
    End Function

    Private Sub SetSettlementLanguage()
        Dim bSpanish As Boolean = (_LanguageId = 2)
        Me.ltrSettlementIntro.Visible = Not bSpanish
        Me.ltrSettlementAfterIntro.Visible = Not bSpanish
        Me.ltrSettlementClosing.Visible = Not bSpanish
        Me.ltrSettlementIntroSP.Visible = bSpanish
        Me.ltrSettlementAfterIntroSP.Visible = bSpanish
        Me.ltrSettlementClosingSP.Visible = bSpanish
        lnkSettEN.Style.Add("Text-Decoration", IIf(bSpanish, "none", "underline"))
        lnkSettSP.Style.Add("Text-Decoration", IIf(Not bSpanish, "none", "underline"))
    End Sub

    Protected Sub lnkSettEN_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSettEN.Click
        _LanguageId = 1
        SetSettlementLanguage()
    End Sub

    Protected Sub lnkSettSP_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSettSP.Click
        _LanguageId = 2
        SetSettlementLanguage()
    End Sub

    Protected Sub lnkEditFeeAppr_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEditFeeAppr.Click
        Try
            Dim settId As Integer = CInt(hdnCurrentSettId.Value)
            Dim SettFee As Double = Val(hdnSettlementFee.Value)
            Dim DelFee As Double = Val(hdnDeliveryFee.Value)
            Dim pass As String = DataHelper.GenerateSHAHash(Me.txtManagerPwd.Text.Trim)
            Dim ManagerID As Integer = DialerHelper.GetUserId(Me.txtManager.Text.Trim, pass)
            Dim bIsManager As Boolean = True
            Dim functionId As Integer = DataHelper.Nz_string(DataHelper.FieldLookup("tblFunction", "FunctionID", "FullName='Settlement Processing-Payments Override'"))
            Dim p As Slf.Dms.Controls.PermissionHelper.Permission = Slf.Dms.Controls.PermissionHelper.GetPermission(Context, functionId, _UserId)
            bIsManager = Not p Is Nothing AndAlso p.CanDo(Slf.Dms.Controls.PermissionHelper.PermissionType.View)
            If ManagerID = 0 Then
                Throw New Exception("Invalid username or password.")
            ElseIf Not bIsManager Then
                Throw New Exception("Only a manager is allow to execute this action.")
            Else
                SettlementMatterHelper.AdjustSettlementFee(settId, _UserId, DelFee, SettFee, True, ManagerID, False, Nothing)
                Me.BindSettGrid()
                Me.UpdateSetts.Update()
                ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "updtfees", String.Format("CancelSeetFees({0});{1}.Close();", settId, ManAppFlyout.getClientID), True)
            End If
        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "errorupdtfees", String.Format("alert('Error updating fees: {0}');", ex.Message.Replace("'", "''")), True)
        End Try
    End Sub

    Protected Sub rpSettlements_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpSettlements.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim scr As SettlementCallResolution = CType(e.Item.DataItem, SettlementCallResolution)
            Dim gv As GridView = e.Item.FindControl("grdDeposits")
            FillNextDepositGrid(gv, scr.Settlement.SettlementDueDate)
        End If
    End Sub

#End Region

#Region "Non Deposits"

    Private Sub LoadClientIssuesNonDeposits()
        Dim dt As DataTable
        Dim reasonId As Integer = 2
        If hdnDCallReasonId.Value = "3" Then reasonId = 3
        If Not DialerHelper.CallIssuesCreated(_CallId, reasonId) Then
            Dim drReason As DataRow = DialerHelper.GetReason(reasonId)
            dt = DialerHelper.GetClientIssuesNonDeposits(_ClientId)
            For Each dr As DataRow In dt.Rows
                DialerHelper.InsertCallResolution(_CallId, drReason("ReasonId"), "tblTask", "TaskId", dr("TaskId"), Now.AddMinutes(drReason("DefaultExpiration")), _UserId)
            Next
        End If
        BindNonDepositGrid()
    End Sub

    Private Sub BindNonDepositGrid()
        Dim resolution As NonDepositCallResolution = Nothing
        Dim lResolution As New List(Of NonDepositCallResolution)

        Dim dt As DataTable = DialerHelper.GetCallResolutions4NonDeposits(_CallId)
        For Each dr As DataRow In dt.Rows
            resolution = New NonDepositCallResolution(dr("CallResolutionId"))
            resolution.MatterId = dr("MatterId")
            resolution.MatterNumber = dr("MatterNumber")
            resolution.NonDepositId = dr("NonDepositId")
            resolution.NonDepositTypeId = dr("NonDepositTypeId")
            resolution.NonDepositType = dr("NonDepositType")
            resolution.DepositDate = CDate(dr("DepositDate")).ToShortDateString
            resolution.DepositAmount = dr("DepositAmount")
            If resolution.NonDepositTypeId = NonDepositCallResolution.NonDepositTypes.Bounced Then
                resolution.BouncedDate = CDate(dr("BouncedDate")).ToShortDateString
                resolution.DepositID = dr("DepositId")
            End If
            If Not dr("TaskResolution") Is DBNull.Value Then resolution.TaskResolution = dr("TaskResolution")
            If Not dr("MatterSubStatus") Is DBNull.Value Then resolution.MatterSubStatus = dr("MatterSubStatus")
            If Not dr("Resolved") Is DBNull.Value Then resolution.Resolved = dr("Resolved")
            If Not dr("ResolvedByUser") Is DBNull.Value Then resolution.ResolvedByUser = dr("ResolvedByUser")
            If Not dr("TaskId") Is DBNull.Value Then resolution.TaskId = dr("TaskId")
            resolution.BouncedReasonDescription = dr("BouncedReason")
            lResolution.Add(resolution)
        Next
        _NonDepCount = CalculatePendingIssues(dt)
        Me.rpNonDeposits.DataSource = lResolution
        Me.rpNonDeposits.DataBind()
        CType(Me.apNonDeposits.HeaderContainer.FindControl("ltrNonDepositCount"), Literal).Text = String.Format(" ({0} of {1})", _NonDepCount, dt.Rows.Count)
        Me.apNonDeposits.Visible = (_NonDepCount > 0) OrElse hdnDCallReasonId.Value = "2" OrElse hdnDCallReasonId.Value = "3"
    End Sub

#End Region

    'Save Call Changes
    Protected Sub btnSaveCallMade_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSaveCallMade.Click
        Try
            DialerHelper.UpdateCallMade(_CallId, 0, CDate(CDate(Me.txtNextContactDate.Text).ToShortDateString & " " & CDate(Me.txtNextContactTime.Value).ToShortTimeString), Nothing, 0, Now, _UserId, "")
            LoadCall()
        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "errorcontactdate", String.Format("alert('{0}');", ex.Message.Replace("'", "")), True)
        End Try
    End Sub

    Protected Sub btnSuspend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSuspend.Click
        Dim NextContactDate As DateTime = Now.AddDays(1)
        DialerHelper.UpdateCallMade(_CallId, 0, NextContactDate, Nothing, 0, Now, _UserId, "")
        Me.txtNextContactDate.Value = NextContactDate.ToShortDateString
        Me.txtNextContactTime.Value = NextContactDate
    End Sub

    Public Function GetLast4(ByVal str As String) As String
        If str.Trim.Length > 3 Then
            Return Right(str.Trim, 4)
        Else
            Return str.Trim
        End If
    End Function

    Protected Sub lnkSaveNote_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveNote.Click
        If Me.txtNote.Text.Trim.Length > 0 Then
            Drg.Util.DataHelpers.NoteHelper.InsertNote(Me.txtNote.Text.Trim, _UserId, _ClientId)
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "savenotes", FlyoutNote.getClientID() & ".Close();ClearNotes();", True)
        Else
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "errorsavenotes", "alert('Pease enter a note.');", True)
        End If
    End Sub

    Private Sub FillNextDepositGrid(ByVal gv As GridView, ByVal DueDate As DateTime)
        Dim dsExpected As New DataSet
        dsExpected = ClientHelper2.ExpectedDeposits(GetClientId, DueDate)
        gv.DataSource = dsExpected.Tables(1)
        gv.DataBind()
    End Sub

    Private Sub NotifyDialer(ByVal ResultId As Integer)
        'Update call result
        DialerHelper.UpdateCallMade(_CallId, ResultId, Nothing, Nothing, _UserId, Nothing, _UserId, "")
        UpdateNextTimeToCall()
        If Drg.Util.DataAccess.DataHelper.FieldLookup("tbldialercall", "CreatedBy", "CallMadeId=" & _CallId) = 30 Then
            Try
                'Send Custom Notification
                Dim psession As ININ.IceLib.Connection.Session = Session("IceSession")
                Dim notif As New ININ.IceLib.Connection.Extensions.CustomNotification(psession)
                Dim hd As New ININ.IceLib.Connection.Extensions.CustomMessageHeader(ININ.IceLib.Connection.Extensions.CustomMessageType.ServerNotification, "CallMadeId", "DialerCallResultChanged")
                Dim req As New ININ.IceLib.Connection.Extensions.CustomRequest(hd)
                req.Write(New String() {_CallId.ToString, ResultId.ToString})
                notif.SendServerRequestNoResponse(req)
            Catch ex As Exception
                'Do Nothing
            End Try
        End If
    End Sub

    Protected Sub RdPerson_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RdPerson.CheckedChanged
        If RdPerson.Checked Then
            'Update call result
            DialerHelper.UpdateCallMade(_CallId, 1, Nothing, Nothing, _UserId, Nothing, _UserId, "")
            UpdateNextTimeToCall()
            Me.InsertPhoneCallNote("completed successfully. Rep. spoke with client.")
        End If
    End Sub

    Protected Sub RdAM_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RdAM.CheckedChanged
        If RdAM.Checked Then
            NotifyDialer(2)
            Me.InsertPhoneCallNote("unsuccessful. Call was answered by machine, no message left.")
        End If
    End Sub

    Protected Sub rdMessage_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RdMessage.CheckedChanged
        If RdMessage.Checked Then
            NotifyDialer(3)
            Me.InsertPhoneCallNote("unsuccessful. A message has been left to client.")
        End If
    End Sub

    Protected Sub rdNoAnswer_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RdNoAnswer.CheckedChanged
        If RdNoAnswer.Checked Then
            NotifyDialer(4)
            Me.InsertPhoneCallNote("unsuccessful. Nobody answered the call.")
        End If
    End Sub

    Protected Sub rdBadNumber_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RdBadNumber.CheckedChanged
        If RdBadNumber.Checked Then
            NotifyDialer(8)
            'Remove Number from Dialer
            DialerHelper.ExcludePhoneNumberFromDialer(Me.hdnDPhoneId.Value)
            Me.InsertPhoneCallNote("unsuccessful. Bad or disconnected number. The number has been removed from the dialer.")
        End If
    End Sub

    Protected Sub rdBusy_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdBusy.CheckedChanged
        If rdBusy.Checked Then
            NotifyDialer(5)
            Me.InsertPhoneCallNote("unsuccessful. The line was busy.")
        End If
    End Sub

    Private Sub UpdateNextTimeToCall()
        DialerHelper.UpdateMattersNextTimeToCall(_CallId, hdnDCallReasonId.Value)
    End Sub

    Private Sub LoadCoapplicants()
        Dim Applicants As New List(Of Person)
        Dim dt As DataTable = DialerHelper.GetApplicants(_ClientId)
        For Each dr As DataRow In dt.Rows
            Applicants.Add( _
                        New Person( _
                        DataHelper.Nz_int(dr("PersonID")), _
                        DataHelper.Nz_int(dr("ClientID")), _
                        DataHelper.Nz_string(dr("SSN")), _
                        DataHelper.Nz_string(dr("FirstName")), _
                        DataHelper.Nz_string(dr("LastName")), _
                        DataHelper.Nz_string(dr("Gender")), _
                        DataHelper.Nz_ndate(dr("DateOfBirth")), _
                        DataHelper.Nz_int(dr("LanguageID")), _
                        DataHelper.Nz_string(dr("LanguageName")), _
                        DataHelper.Nz_string(dr("EmailAddress")), _
                        DataHelper.Nz_string(dr("Street")), _
                        DataHelper.Nz_string(dr("Street2")), _
                        DataHelper.Nz_string(dr("City")), _
                        DataHelper.Nz_int(dr("StateID")), _
                        DataHelper.Nz_string(dr("StateName")), _
                        DataHelper.Nz_string(dr("StateAbbreviation")), _
                        DataHelper.Nz_string(dr("ZipCode")), _
                        DataHelper.Nz_string(dr("Relationship")), _
                        DataHelper.Nz_bool(dr("CanAuthorize")), _
                        DataHelper.Nz_bool(dr("ThirdParty")), _
                        DataHelper.Nz_date(dr("Created")), _
                        DataHelper.Nz_int(dr("CreatedBy")), _
                        DataHelper.Nz_string(dr("CreatedByName")), _
                        DataHelper.Nz_date(dr("LastModified")), _
                        DataHelper.Nz_int(dr("LastModifiedBy")), _
                        DataHelper.Nz_string(dr("LastModifiedByName"))))

        Next

        ddlPerson.DataSource = Applicants
        ddlPerson.DataTextField = "Name"
        ddlPerson.DataValueField = "PersonId"
        ddlPerson.DataBind()

        lblCoApp.Text = String.Format("({0})", Applicants.Count)
        If Applicants.Count > 0 Then
            rpApplicants.DataSource = Applicants
            rpApplicants.DataBind()
            lblCoApp.Text = String.Format("({0})", Applicants.Count)
        End If

    End Sub

    Protected Sub rpApplicants_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpApplicants.ItemDataBound

        If e.Item.ItemType = ListItemType.Separator Then Return
        Dim lblPhones As Literal = CType(e.Item.FindControl("lblPhones"), Literal)

        Dim Phones As List(Of Phone) = Drg.Util.DataHelpers.PersonHelper.GetPhones(e.Item.DataItem.PersonID)

        Dim EmailAddress As String = e.Item.DataItem.EmailAddress

        If Phones.Count > 0 Or EmailAddress.Length > 0 Then

            lblPhones.Text = "<table style=""width:100%;font-family:tahoma;font-size:11;"" cellpadding=""1"" cellspacing=""0"" border=""0"">"

            If EmailAddress.Length > 0 Then

                lblPhones.Text += " <tr>" _
                    & "<td style=""width:80;"">Email Address</td>" _
                    & "<td style=""width:150;"">" & EmailAddress & "</td>" _
                    & "<td></td>" _
                    & "</tr>"

            End If

            For Each Phone As Phone In Phones

                lblPhones.Text += " <tr>" _
                    & "<td style=""width:80;"">" & Phone.PhoneTypeName & "</td>" _
                    & "<td style=""width:150;"" align=""left"" >" & Phone.NumberFormatted & IIf(Phone.Extension.Trim.Length > 0, " ext. " & Phone.Extension.Trim, "") & "</td>" _
                    & "<td style=""width:20;"" align=""center"" onclick=""parent.make_call('" & Phone.NumberFormatted & "')""><img  valign=""top"" src=""" & ResolveUrl("~/images/phone2.png") & """ style=""cursor:hand;""/></td>" _
                    & "</tr>"

            Next

            lblPhones.Text += "</table>"

        Else
            lblPhones.Text = "<em>&lt;no contact information&gt;</em>"
        End If

    End Sub

    Private Function GetPersonDDL() As String
        Dim htmlString As New StringBuilder
        Dim stringWriter As New System.IO.StringWriter(htmlString)
        Dim hw As New HtmlTextWriter(stringWriter)
        Dim output As String = Me.lblClientName.Text
        Dim sel As New HtmlSelect
        Try
            sel.ID = "ddlDynPerson"
            sel.Items.Clear()
            For Each l As ListItem In ddlPerson.Items
                sel.Items.Add(New ListItem(l.Text, l.Value))
            Next
            sel.SelectedIndex = sel.Items.IndexOf(sel.Items.FindByValue(hdnPersonId.Value))
            sel.Attributes.Add("onchange", "changeperson(this)")
            sel.Style.Add("background-color", "yellow")
            sel.RenderControl(hw)
            output = htmlString.ToString
        Catch ex As Exception
        Finally
            hw.Close()
            stringWriter.Close()
        End Try
        Return output
    End Function

    Private Sub LoadPersonData(ByVal PersonId As Integer)
        _Last4SSN = "Not in file"
        _DOB = ""
        _Address = "Not in file"
        _UserFullName = DialerHelper.GetUserFullName(_UserId)
        Dim dt As DataTable = DialerHelper.GetPersonData(PersonId)
        If dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            If Not dr("SSN") Is DBNull.Value Then _Last4SSN = Me.GetLast4(LocalHelper.FormatSSN(dr("SSN")))
            If Not dr("DateOfBirth") Is DBNull.Value Then _DOB = CDate(dr("DateOfBirth")).ToShortDateString
            _Address = dr("Address")
        End If
    End Sub

    Protected Sub lnkChangePerson_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangePerson.Click
        Dim PersonId As Integer = Me.hdnPersonId.Value
        'ChangeVariables()
        LoadPersonData(PersonId)
        'reload script
        LoadSettlScript()
    End Sub

    Private Sub InsertPhoneCallNote(ByVal CallDisposition As String)
        Try
            Dim pc As New NewPhoneCallHelper()
            Dim Subject As String = ""
            Dim reasonCall As String = ""
            Dim dt As DataTable
            Dim relationid As Integer = 0
            Select Case hdnDCallReasonId.Value.Trim
                Case "1"
                    dt = DialerHelper.GetTopSettlementCallResolutionIssue(_CallId)
                    If dt.Rows.Count > 0 Then
                        relationid = dt.Rows(0)("matterid")
                        Subject = String.Format("Dialer call for matter {0}. Settlement {2} #{1} ", relationid, GetLast4(dt.Rows(0)("accountnumber")), dt.Rows(0)("creditorname"))
                    End If
                    reasonCall = "12"
                Case "2", "3"
                    Subject = "non deposit "
                    reasonCall = "3"
                Case "Else"
                    Subject = "Dialer call"
            End Select
            Dim Body As String = String.Format("Dialer phone call attempt to {0} was {1}", lblPhoneNumber.Text, CallDisposition)
            Dim Pid As Integer = pc.InsertPhoneCall(_ClientId, _UserId, _UserId, hdnPersonId.Value, 1, Me.hdnDPhoneNumber.Value, Body, Subject, CDate(hdnDAnsweredDate.Value), Now, reasonCall)
            If relationid > 0 Then
                'pc.RelatePhoneCall(Pid, 19, relationid)
            End If
        Catch ex As Exception
            'Do not stop process if an error occurs in the generation of the note
        End Try
    End Sub

    Private Function CalculatePendingIssues(ByVal dt As DataTable) As Integer
        Dim dv As New DataView(dt)
        dv.RowFilter = "Resolved is null"
        Return dv.Count
    End Function

    Protected Sub lnkReloadNonDep_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReloadNonDep.Click
        BindNonDepositGrid()
        Me.UpdateSetts.Update()
    End Sub
End Class
