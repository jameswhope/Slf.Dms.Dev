Imports ININ.IceLib.Interactions
Imports System.Collections
Imports System.Collections.Generic
Imports System.Collections.ObjectModel
Imports System.Data

Partial Class CallControlsAst_SettlementVerbalAuth
    Inherits System.Web.UI.Page

    Enum Language
        English = 1
        Spanish = 2
    End Enum

    Private _LawFirm As String
    Private _CreditorName As String
    Private _CreditorAccount As String
    Private _Last4Account As String
    Private _SettlementAmount As Double
    Private _SettlementFee As Double
    Private _OvernightFee As Double
    Private _ClientID As Integer
    Private _UserID As Integer
    Private _Language As Language
    Private _SettlementId As Integer
    Private _MatterId As Integer
    Private _DocTypeId As String = "9074"
    Private _ReferenceType As String = "matter"
    Private _ReferenceId As Integer
    Private _DeptPhoneNumber As String
    Private _SettlementDueDate As String
    Private _IsStipulation As Boolean = False
    Private _IsPaymentArrangement As Boolean = False
    Private _DownPayment As Double
    Private _DueDate As DateTime
    Private _IsPAByClient As Boolean = False

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles form1.Load
        _UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)
        _SettlementId = Me.GetSettlemtenId()
        _MatterId = Me.GetMatterId()

        If Not Me.IsPostBack Then
            SetClientDefaultLanguage()
            ShowPage(0)
        Else
            _Language = CInt(Me.ddlLanguage.SelectedValue)
        End If
    End Sub

    Private Function GetMatterId() As Integer
        Dim matterid As Integer = 0
        Try
            matterid = Request.QueryString("matterid")
        Catch ex As Exception
            'return zero
        End Try
        Return matterid
    End Function

    Private Function GetSettlemtenId() As Integer
        Dim settid As Integer = 0
        Try
            settid = Request.QueryString("settid")
        Catch ex As Exception
            ShowError("Cannot get settlementid")
        End Try
        Return settid
    End Function

    Private Sub SetClientDefaultLanguage()
        Try
            _Language = DialerHelper.GetClientLanguageForSett(_SettlementId)
        Catch ex As Exception
            _Language = Language.English
        End Try
        Me.ddlLanguage.SelectedIndex = IIf(_Language = Language.English, 0, 1)
    End Sub

    Private Function GetCallQuestions() As List(Of String)
        Dim questions As New List(Of String)
        Dim usePaymentArrangement As Boolean = (_IsPaymentArrangement AndAlso _SettlementAmount <> _DownPayment)
        Dim schedulescript As String = ""
        Dim monthlyscript As String = ""

        If usePaymentArrangement OrElse _IsPAByClient Then
            schedulescript = PaymentScheduleHelper.GetScheduleAuthorizationScript(_SettlementId, _Language)
            If _IsPAByClient Then
                If Not schedulescript.ToLower.Contains("</div>") Then
                    monthlyscript = schedulescript & "?"
                    schedulescript = ""
                Else
                    monthlyscript = ""
                    schedulescript = ":<br/>" & schedulescript
                End If
            Else
                If Not schedulescript.ToLower.Contains("</div>") Then
                    monthlyscript = IIf(_Language = Language.English, "and ", "y ") & schedulescript
                    schedulescript = ""
                Else
                    monthlyscript = ""
                    schedulescript = IIf(_Language = Language.English, " The other payments will be made as follows:", " Los otros pagos se harán como sigue:") & "<br/>" & schedulescript
                End If
            End If
        End If

        If _Language = Language.English Then
            If Not usePaymentArrangement Then
                'Question1
                questions.Add(String.Format("Do you give your authorization to pay the settlement offer of {0:c} to {1} ending #{2} and authorize the Law Firm to deduct this amount from your Client Deposit Account?", _SettlementAmount, _CreditorName, _Last4Account))
            ElseIf _IsPAByClient Then
                'Question1
                questions.Add(String.Format("Do you give your authorization to pay the down payment of {0:c} to {1} ending #{2} and authorize the Law Firm to deduct these amount from your Client Deposit Account?", _DownPayment, _CreditorName, _Last4Account))
            Else
                'Question1
                questions.Add(String.Format("Do you give your authorization to pay the settlement offer of {0:c} to {1} ending #{2} in installments which includes a down payment of {3:c} due {4:MM/dd/yy} {5} and authorize the Law Firm to deduct these amounts from your Client Deposit Account? {6}", _SettlementAmount, _CreditorName, _Last4Account, _DownPayment, _DueDate, monthlyscript, schedulescript))
            End If
            'Question2
            questions.Add(String.Format("Do you agree with the settlement fees of {0:c} and authorize the Law Firm to deduct this amount from your Client Deposit Account?", _SettlementFee))
            'Question 3
            If Not usePaymentArrangement OrElse _IsPAByClient Then
                questions.Add("Do you agree with the " & Format(GetSettlementDeliveryFees("client", _ClientID), "$###.00") & " fee and authorize the Law Firm to deduct this amount from your Client Deposit Account?")
            Else
                questions.Add("Do you agree with the " & Format(GetSettlementDeliveryFees("client", _ClientID), "$###.00") & " disbursement fee and authorize the Law Firm to deduct this amount from your Client Deposit Account for each monthly payment to the creditor?")
            End If
            'Stipulation Question 4
            If _IsStipulation Then
                'questions.Add(String.Format("Do you understand if the signed Stipulation Agreement from the creditor is not returned to our office by you before the settlement due date of {0} this offer will not be paid?", _SettlementDueDate))
                questions.Add("Do you understand if the signed Stipulation Agreement from the creditor is not returned to our office by you before the settlement due date the settlement will not be paid?")
            End If
            'Payment Arrangement Questions
            If _IsPAByClient Then
                questions.Add(String.Format("Do you understand that you are responsible for the monthly installments to the creditor in the amount of {0}{1}", monthlyscript, schedulescript))
                questions.Add("Do you understand that if your monthly payments are not made on their scheduled due to the creditor the settlement will become null and void and all funds paid could be applied towards the outstanding balance owed to the creditor?")
            ElseIf usePaymentArrangement Then
                questions.Add("Do you understand that if your monthly deposits are not received on their scheduled due date and the Law Firm is unable to process the next installment to the creditor the settlement will become null and void and all funds paid could be applied towards the outstanding balance owed to the creditor?")
            End If
            'Other Payment Arrangement Questions
            If usePaymentArrangement Then
                questions.Add("Do you understand that by not completing the agreed upon payment schedule the statue of limitations on this account may be reset by the creditor?")
                questions.Add("Do you understand if this settlement becomes null and void all settlement fees billed are considered earned by the Law Firm?")
                questions.Add("Do you understand if this settlement becomes null and void the account would have to be re-negotiated by the Law Firm which can result in new settlement fees?")
            End If
            'Question 5
            questions.Add(String.Format("Do you understand that if you have any questions regarding this settlement offer to call the Law Firm's Client Services Department at {0}?", _DeptPhoneNumber))
        Else
            If Not usePaymentArrangement Then
                'Question 1
                questions.Add(String.Format("Usted da su autorización para pagar la oferta de asentamiento de {0:c} de {1}, que finaliza en #{2} y autoriza a la Firma a que descuente esta cantidad de su cuenta de depósito de cliente?", _SettlementAmount, _CreditorName, _Last4Account))
            ElseIf _IsPAByClient Then
                'Question 1
                questions.Add(String.Format("Usted da su autorización para pagar el pago inicial de {0:c} para la oferta de asentamiento de {1}, que finaliza en #{2} y autoriza a la Firma a que descuente esta cantidad de su cuenta de depósito de cliente?", _DownPayment, _CreditorName, _Last4Account))
            Else
                'Question 1
                questions.Add(String.Format("Usted da su autorización para pagar la oferta de asentamiento de {0:c} de {1}, que finaliza en #{2} en tramos, lo que incluye un pago inicial de {3:c} antes del {4:MM/dd/yy} {5} y autoriza a la Firma a que descuente esta cantidad de su cuenta de depósito de cliente? {6}", _SettlementAmount, _CreditorName, _Last4Account, _DownPayment, _DueDate, monthlyscript, schedulescript))
            End If
            'Question 2
            questions.Add(String.Format("Usted está de acuerdo con las tasas de liquidación de {0:c} y autoriza a La Firma a que descuente esta cantidad de su cuenta de depósito de cliente?", _SettlementFee))
            'Question 3
            If Not usePaymentArrangement OrElse _IsPAByClient Then
                questions.Add("Usted está de acuerdo con la tarifa de " & Format(GetSettlementDeliveryFees("client", _ClientID), "$##0.00") & " de envío y autoriza a La Firma a que descuente esta cantidad de su cuenta de depósito de cliente?")
            Else
                questions.Add("Usted está de acuerdo con la tarifa de " & Format(GetSettlementDeliveryFees("client", _ClientID), "$##0.00") & " de envío y autoriza a La Firma a que descuente esta cantidad de su cuenta de depósito de cliente por cada pago al acreedor?")
            End If
            'Stipulation Question 4
            If _IsStipulation Then
                'questions.Add(String.Format("Usted comprende si el Acuerdo firmado de Estipulación del acreedor no es regresado a nuestra oficina antes de la fecha de vencimiento de {0} que esta oferta no será pagada?", _SettlementDueDate))
                questions.Add("Usted comprende si el Acuerdo firmado de Estipulación del acreedor no es regresado a nuestra oficina antes de la fecha de vencimiento que esta oferta no será pagada?")
            End If
            'Payment Arrangement Questions
            If _IsPAByClient Then
                questions.Add(String.Format("Entiende que usted es responsable de las cuotas mensuales al acreedor por cantidad de {0}{1}", monthlyscript, schedulescript))
                questions.Add("Usted comprende que si los pagos mensuales no se hacen al acreedor el asentamiento se cancelará y todos los fondos pagados podrían aplicarse hacia el saldo adeudado al acreedor?")
            ElseIf usePaymentArrangement Then
                questions.Add("Usted comprende que si no se reciben sus depósitos mensuales en la fecha programada y la firma no puede procesar la siguiente cuota al acreedor el asentamiento se cancelará y todos los fondos pagados podrían aplicarse hacia el saldo adeudado al acreedor?")
            End If
            'Other Payment Arrangement Questions
            If usePaymentArrangement Then
                questions.Add("Usted comprende que al no haber completado el calendario de pagos acordado el estatuto de limitaciones sobre esta cuenta puede ser restablecida por el acreedor?")
                questions.Add("Usted comprende que si el asentamiento se cancela, todos los honorarios serán considerados ganancias por el bufete de abogados?")
                questions.Add("Usted comprende que si el asentamiento se cancela la cuenta tendría que re-negociarse por el bufete de abogados por lo cual puede haber nuevos honorarios?")
            End If
            'Question 5
            questions.Add(String.Format("Entiende usted que si tiene alguna pregunta con respecto a este asentamiento ofrecemos que llame al departamento de servicios al cliente al {0}?", _DeptPhoneNumber))
        End If
        Return questions

    End Function



    Private Sub LoadForm()
        GetSettlementData()
        ShowPage(1)
        LoadPage1()
        LoadPage2()
        LoadPage3()
        LoadPage4()
        LoadPage5()
        LoadPage7()
        LoadPage8()
        LoadPage9()
        'Load Questions
        Me.hdnCurrentQuestion.Value = 1
        Me.rptQuestions.DataSource = GetCallQuestions()
        Me.rptQuestions.DataBind()
    End Sub

    Private Function GetSettlementDeliveryFees(ByVal IDType As String, ByVal ID As Integer) As Double
        Dim strSQL As String
        Dim CompanyID As Integer = 0
        Dim ClientID As Integer = 0

        Select Case IDType
            Case "Client"
                ClientID = ID
                strSQL = "stp_GetDeliveryFee " & ID & ", " & 0
            Case Else
                CompanyID = ID
                strSQL = "stp_GetDeliveryFee " & 0 & ", " & ID
        End Select

        Return SqlHelper.ExecuteScalar(strSQL, CommandType.Text)
    End Function

    Private Sub GetSettlementData()
        Dim settlement As SettlementMatterHelper.SettlementInformation = SettlementMatterHelper.GetSettlementInformation(_SettlementId)
        _ClientID = settlement.ClientID

        hdnClientId.Value = _ClientID

        Dim dtClient As DataTable = DialerHelper.GetClientData(_ClientID)
        _LawFirm = dtClient.Rows(0)("LawFirm").ToString
        _CreditorName = Drg.Util.DataHelpers.AccountHelper.GetCreditorName(settlement.AccountID)
        _CreditorAccount = SettlementMatterHelper.GetCreditorAccountNumber(_SettlementId)
        _Last4Account = GetLast4Digits(_CreditorAccount)
        _SettlementAmount = settlement.SettlementAmount
        _SettlementFee = settlement.SettlementFee + settlement.AdjustedSettlementFee
        _OvernightFee = settlement.DeliveryAmount
        _DownPayment = settlement.DownPayment
        _DueDate = settlement.SettlementDueDate

        Try
            _SettlementDueDate = settlement.SettlementDueDate.ToShortDateString
        Catch ex As Exception
            _SettlementDueDate = "No Date"
        End Try

        _IsStipulation = DialerHelper.IsSettlementStipulation(_SettlementId)
        _IsPaymentArrangement = settlement.IsPaymentArrangement
        _IsPAByClient = SettlementMatterHelper.IsPAByClient(_SettlementId)

        Dim dtPhone As DataTable = DialerHelper.GetClientServicesPhoneNumber(dtClient.Rows(0)("CompanyId"))
        If dtPhone.Rows.Count > 0 AndAlso Not dtPhone.Rows(0)("PhoneNumber") Is DBNull.Value Then
            _DeptPhoneNumber = LocalHelper.FormatPhone(dtPhone.Rows(0)("PhoneNumber"))
        Else
            _DeptPhoneNumber = "[Not found in database]"
        End If

    End Sub

    Private Function GetLast4Digits(ByVal AccNumber As String) As String
        Try
            Return Right(AccNumber, 4)
        Catch ex As Exception
            Return AccNumber
        End Try
    End Function

    Private Sub LoadPage1()
        Dim sb As New System.Text.StringBuilder
        If _Language = Language.English Then
            sb.AppendFormat("Today is {0} and I will be asking you some questions regarding your understanding of the settlement offer ", Now.ToLongDateString)
            'sb.AppendFormat("for {0} ending in #{1} as I have just explained to you. <br/>", _CreditorName, _Last4Account)
            sb.Append("as I have just explained to you.<br/>")
            sb.Append("All questions must be answered with a ""Yes"" or ""No"" answer.<br/>")
            sb.Append("If at any time you answer ""No"" to a question, I will repeat it to ensure that you understand.<br/>")
            sb.Append("If you answer ""No"" again, I will stop the recording to go over any additional question you may have regarding the settlement offer. <br/>")
            sb.AppendFormat("Now, do you understand that when I say Law Firm, I am referring to {0}?", _LawFirm)
            sb.AppendLine()
        Else
            sb.AppendFormat("Hoy es {0} y le haré unas preguntas con respecto a su comprensión de la oferta de asentamiento ", Now.ToShortDateString)
            'sb.AppendFormat("de {0}, que finaliza en #{1} como acabo de explicar a usted. <br/>", _CreditorName, _Last4Account)
            sb.Append("como acabo de explicar a usted. <br/>")
            sb.Append("Todas las preguntas deben responderse con una respuesta Sí o No.<br/>")
            sb.Append("Si en cualquier momento que usted responda ""No"" a una pregunta, se repetirá para asegurar de que usted entiende.<br/>")
            sb.Append("Si la respuesta es ""No"" una vez más, se detendrá la grabación para ir sobre cualquier pregunta adicional que usted tenga con respecto a la oferta de asentamiento. <br/>")
            sb.AppendFormat("Ahora, ¿entiende usted que cuando digo La Firma me estoy refiriendo a {0}?", _LawFirm)
            sb.AppendLine()
        End If

        Me.ltrPage1.Text = sb.ToString
    End Sub

    Private Sub LoadPage2()
        Dim sb As New System.Text.StringBuilder

        If _Language = Language.English Then
            sb.AppendLine("Do you agree to have us record your answers to these questions? <br/>Because we are recording this with your consent, please be sure to answer each of my questions clearly out loud.")
        Else
            sb.AppendLine("¿Está de acuerdo que grabemos sus respuestas a estas preguntas? <br/>Porque estamos grabando con su consentimiento, asegúrese de responder cada una de mis preguntas claramente en voz alta.")
        End If
        Me.ltrPage2.Text = sb.ToString
    End Sub

    Private Sub LoadPage3()
        'Applicants FullName, SSN, Primary 
        'List in grid
        Dim dtApplicant As DataTable = CallVerificationHelper.GetApplicantsData(_ClientID)
        If _Language = Language.English Then
            Me.ltrPage3.Text = "For verification purposes, please state your full name. <br/>"
            Me.ltrPage3.Text &= "Please state the last four digits of your social security number. <br/>"
        Else
            Me.ltrPage3.Text = "Para fines de verificacion, indique por favor su nombre completo. <br/>"
            Me.ltrPage3.Text &= "Indique por favor los últimos cuatro dígitos de su número del seguro social. <br/>"
        End If

        Me.ltrPage3.Text &= "<table class='clientinfo'><tr><th>Full Name</th><th>SSN</th><th>Is Primary</th></tr>"

        For Each r As DataRow In dtApplicant.Rows
            Me.ltrPage3.Text &= String.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>", r("FullName").ToString, GetSSN(r), IIf(r("Primary") = 1, "Yes", ""))
        Next
        Me.ltrPage3.Text &= "</table>"
    End Sub

    Private Function GetSSN(ByVal dr As DataRow) As String
        Dim ssn As String
        If dr("ssn") Is DBNull.Value Then
            ssn = "?"
        Else
            ssn = dr("ssn").ToString.Trim
            If ssn.Length = 9 Then
                Try
                    ssn = String.Format("XXX-XX-{2}", ssn.Substring(0, 3), ssn.Substring(3, 2), ssn.Substring(5, 4))
                Catch ex As Exception
                    'ignore it
                End Try
            End If
        End If
        Return ssn
    End Function

    Private Sub LoadPage4()
        If _Language = Language.English Then
            Me.ltrPage4.Text = "Thank you, let’s begin:"
        Else
            Me.ltrPage4.Text = "Gracias, comencemos:"
        End If
    End Sub

    Private Sub LoadPage5()
        If _Language = Language.English Then
            Me.ltrPage5.Text = "The following questions will highlight and summarize certain parts of the Settlement Offer.</br>"
        Else
            Me.ltrPage5.Text = "Las siguientes preguntas  resumirán ciertas partes de la oferta de asentamiento.</br>"
        End If
    End Sub

    Private Sub LoadPage7()
        If _Language = Language.English Then
            Me.ltrPage7.Text = "Thank you. This concludes the verbal authorization to settle this account."
        Else
            Me.ltrPage7.Text = "Con esto concluye la autorización verbal para resolver esta cuenta."
        End If
    End Sub

    Private Sub LoadPage8()
        Me.ltrPage8.Text = ""
    End Sub

    Private Sub LoadPage9()
        Me.ltrPage9.Text = ""
    End Sub

    Protected Sub rptQuestions_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles rptQuestions.ItemCommand
        Select Case e.CommandName.ToLower.Trim
            Case "continue"
                Dim nextQuestion As Integer = CInt(e.CommandArgument) + 1
                Me.hdnCurrentQuestion.Value = nextQuestion
                ShowQuestion(nextQuestion)
                If Me.rptQuestions.Items.Count < nextQuestion Then CompleteRecord("Question " & e.CommandArgument)
            Case Else
                AbortRecord("Question " & e.CommandArgument, "")
        End Select
    End Sub

    Protected Sub rptQuestions_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptQuestions.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            e.Item.Visible = e.Item.ItemIndex + 1 = CInt(Me.hdnCurrentQuestion.Value)
        End If
    End Sub

    Private Sub ShowQuestion(ByVal QuestionNo As Integer)
        For Each itm As RepeaterItem In Me.rptQuestions.Items
            itm.Visible = (itm.ItemIndex = QuestionNo - 1)
        Next
    End Sub

    Protected Sub BtnYes1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnYes1.Click, BtnYes2.Click, BtnYes3.Click, btnStartQuestions.Click
        Dim btn As Button = CType(sender, Button)
        ShowPage(CInt(btn.CommandArgument + 1))
    End Sub

    Protected Sub BtnStartRecording_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnStartRecording.Click
        ShowPage(5)
    End Sub

    Public Sub CreateRecordingCall()
        Try
            If hdnCallId.Value.Trim.Length > 0 Then
                If Val(hdnRecording.Value.Trim) = 0 Then
                    Dim username As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tbluser", "username", "userid = " & _UserID)
                    Dim filepath As String = ConfigurationManager.AppSettings("settlementrecordings").ToString
                    Dim filename As String = String.Format("sett_{0}_{1}_{2}", hdnCallId.Value, Guid.NewGuid.ToString, username)
                    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "startrecordingpath", String.Format("StartRecordingInPath('{0}', '{1}');", filepath.Replace("\", "\\"), filename), True)
                Else
                    Throw New Exception("Sorry, You cannot start this process because the current call is recording already.")
                End If
            Else
                Throw New Exception("Sorry, You cannot start this process because there is no current call.")
            End If
        Catch ex As Exception
            ShowError(ex.Message)
        End Try
    End Sub

    Private Sub InsertSettlementRecording()
        'Insert CallRecording session. Get Id 
        Me.hdnSettlementRecordedCallId.Value = DialerHelper.InsertSettlementRecordedCall(_SettlementId, hdnCallId.Value.Trim, _Language, _UserID)
    End Sub

    Private Sub ShowPage(ByVal PageNumber As Integer)
        Me.trPage0.Visible = (PageNumber = 0)
        Me.trPage1.Visible = (PageNumber = 1)
        Me.trPage2.Visible = (PageNumber = 2)
        Me.trPage3.Visible = (PageNumber = 3)
        Me.trPage4.Visible = (PageNumber = 4)
        Me.trPage5.Visible = (PageNumber = 5)
        Me.trPage6.Visible = (PageNumber = 6)
        Me.trPage7.Visible = (PageNumber = 7)
        Me.trPage8.Visible = (PageNumber = 8)
        Me.trPage9.Visible = (PageNumber = 9)
    End Sub

    Protected Sub BtnNo1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnNo1.Click, BtnNo2.Click, BtnNo3.Click
        Dim btn As Button = CType(sender, Button)
        AbortRecord("Page " & btn.CommandArgument, "")
    End Sub

    Private Sub CompleteRecord(ByVal LastStep As String)
        Try
            DialerHelper.UpdateSettlementRecordedCall(Me.hdnSettlementRecordedCallId.Value, Now, Nothing, 0, LastStep, "")
            ShowPage(7)
        Catch ex As Exception
            ShowError("Error: " & ex.Message)
        End Try
    End Sub

    Private Sub AbortRecord(ByVal LastStep As String, ByVal Message As String)
        Try
            DialerHelper.UpdateSettlementRecordedCall(Me.hdnSettlementRecordedCallId.Value, Nothing, False, 0, LastStep, "")

            ltrPage9.Text = "Client answered No at " & LastStep

            ltrPage9.Text = "<br/>Recorded Call has been stopped."

        Catch ex As Exception
            ShowError(ex.Message)
            Return
        End Try

        ShowPage(9)
    End Sub

    Private Sub ShowError(ByVal Message As String)
        If Message.Trim.Length > 0 Then
            ltrPage8.Text = Message
        Else
            ltrPage8.Text = ""
        End If
        ShowPage(8)
    End Sub

    Protected Sub btnFinish_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        Submit()
    End Sub

    Protected Sub btnClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnClose.Click, btnAborted.Click
        Cancel()
    End Sub

    Protected Sub BtnLanguage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnLanguage.Click
        _Language = CInt(Me.ddlLanguage.SelectedValue)
        LoadForm()
        CreateRecordingCall()
    End Sub

    Private Sub Submit()
        Try
            'Create Record
            Dim recId As Integer = CallControlsHelper.InsertCallRecording(Me.hdnCallId.Value, Me.hdnCallId.Value, "", _ReferenceType, GetMatterId(), _DocTypeId, _UserID)

            DialerHelper.UpdateSettlementRecordedCall(Me.hdnSettlementRecordedCallId.Value, Nothing, True, recId, "", "")
            If _SettlementId > 0 Then
                SettlementMatterHelper.ResolveClientApproval(_SettlementId, _UserID, "verbal", True, "")
            Else
                Throw New Exception("Cannot find the settlement Id.")
            End If
            'Stop Recording
            ScriptManager.RegisterStartupScript(Me.Page, GetType(Page), "persistrecording", String.Format("CloseRecording('{0}', '1');", recId.ToString), True)
        Catch ex As Exception
            ShowError(ex.Message)
        End Try
    End Sub

    Private Sub Cancel()
        ScriptManager.RegisterStartupScript(Me.Page, GetType(Page), "cancelrecording", "CloseRecording('','');", True)
    End Sub

    Protected Sub lnkCreateRecording_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCreateRecording.Click
        InsertSettlementRecording()
    End Sub

    Public Function GetSettMatterId() As Integer
        Return _MatterId
    End Function

End Class
