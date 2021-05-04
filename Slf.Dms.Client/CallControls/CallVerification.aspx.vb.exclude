Imports ININ.IceLib.Interactions
Imports System.Collections
Imports System.Collections.Generic
Imports System.Collections.ObjectModel
Imports System.Data

Partial Class CallControls_CallVerification
    Inherits System.Web.UI.Page

    Enum Language
        English = 1
        Spanish = 2
    End Enum

    Private _currentInteraction As Interaction
    Private _LawFirm As String
    Private _State As String
    Private _FirstDraft As String
    Private _FirstDraftDate As String
    Private _DepositMethod As String
    Private _VersionId As Integer
    Private _GenericFirm As String

    Private _ClientID As Integer
    Private _UserID As Integer
    Private _Language As Language

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles form1.Load
        _UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)
        _ClientID = Drg.Util.DataAccess.DataHelper.Nz_int(Me.Request.QueryString("ClientId"))

        If Not Me.IsPostBack Then
            SetClientDefaultLanguage()
            ShowPage(0)
        Else
            _Language = CInt(Me.ddlLanguage.SelectedValue)
        End If
    End Sub

    Private Function GetCurrentInteraction(ByVal MaxAttempts As Integer) As Interaction
        Dim Ct As Integer = 0
        Dim inter As Interaction = Nothing
        While inter Is Nothing
            inter = Session("CurrentInteraction")
            Ct += 1
            If Ct > MaxAttempts Then Exit While
        End While
        Return inter
    End Function

    Private Sub SetClientDefaultLanguage()
        Try
            _Language = CallVerificationHelper.GetClientPreferredLanguage(_ClientID)
        Catch ex As Exception
            _Language = Language.English
        End Try
        Me.ddlLanguage.SelectedIndex = IIf(_Language = Language.English, 0, 1)
    End Sub

    Private Sub LoadForm()
        GetClientData()
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
        Me.rptQuestions.DataSource = CallVerificationHelper.GetCallVerificationQuestions(_Language, _VersionId)
        Me.rptQuestions.DataBind()
    End Sub

    Private Sub GetClientData()
        Dim dtClient As DataTable = CallVerificationHelper.GetClientData(_ClientID)
        _LawFirm = dtClient.Rows(0)("LawFirm").ToString
        _State = dtClient.Rows(0)("SAState").ToString

        _FirstDraft = String.Format("{0:c}", dtClient.Rows(0)("InitialDraftAmount"))
        If dtClient.Rows(0)("InitialDraftDate") Is DBNull.Value Then
            _FirstDraftDate = "Not Defined"
        Else
            _FirstDraftDate = Format(CDate(dtClient.Rows(0)("InitialDraftDate")), "MM/dd/yyyy")
        End If

        _DepositMethod = dtClient.Rows(0)("DepositMethod").ToString.ToLower
        _VersionId = CallVerificationHelper.GetClientLexxPVVersion(_ClientID)
        Select Case _VersionId
            Case 1
                If _Language = Language.Spanish Then
                    _GenericFirm = "Bufete de Abogados"
                Else
                    _GenericFirm = "Law Firm"
                End If
            Case Else
                If _Language = Language.Spanish Then
                    _GenericFirm = "Abogado"
                Else
                    _GenericFirm = "Attorney"
                End If
        End Select
    End Sub

    Private Sub LoadPage1()
        If _Language = Language.English Then
            Me.ltrPage1.Text = GetQuestionText("I will be asking you a series of questions regarding your understanding of the legal services as they have been explained to you, and the legal service agreement you have signed. If at any time you answer 'No' to a question, I will repeat it to ensure that you understand. If you answer 'No' again, your call will be transferred back to your enrolling representative. This portion of the call should take approximately 3 minutes to complete. What we address during this recording does not limit or replace the written language in the legal service agreement you have signed.  Now, do you understand that when I say {genericfirm}, you understand I am referring to {lawfirm}?")
        Else
            Me.ltrPage1.Text = GetQuestionText("Yo le estaré preguntando una serie de preguntas con respecto a su comprension del servicio legal como han sido explicados a usted y el acuerdo legal de servicio que usted ha firmado. Si en cualquier momento usted contesta 'NO' a una pregunta, yo lo repetiré para asegurar que usted comprenda. Si usted contesta 'No' otra vez, su llamada  será transferida a su representante que lo matriculo.  Puede tomar aproximadamente 3 minutos de completar esta llamada.  Lo qué nosotros dirijimos durante esta grabación no limita ni reemplaza el idioma escrito en el acuerdo legal de servicio que usted ha firmado. ¿Ahora, cuando digo el {genericfirm}, usted comprende que yo me refiero al {lawfirm} correcto?")
        End If
    End Sub

    Private Sub LoadPage2()
        If _Language = Language.English Then
            Me.ltrPage2.Text = "Do you agree to have us record your answers to these questions? Because we are recording this with your consent, please be sure to answer each of my questions clearly out loud.?"
        Else
            Me.ltrPage2.Text = "¿Esta de acuerdo en que se grabe sus respuestas a estas preguntas? Porque estamos grabando con su consentimiento, por favor conteste cada pregunta claramente en voz alta."
        End If
    End Sub

    Private Sub LoadPage3()
        'Applicants FullName, SSN, Primary 
        'List in grid
        Dim dtApplicant As DataTable = CallVerificationHelper.GetApplicantsData(_ClientID)
        If _Language = Language.English Then
            Me.ltrPage3.Text = "For verification purposes, please state your full name. <br/>"
            Me.ltrPage3.Text &= "Please state the last four digits of your social security number. <br/>"
        Else
            Me.ltrPage3.Text = "Para propósitos de verificacion, indique por favor su nombre y apellidos. <br/>"
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
            Me.ltrPage4.Text = "Great, let’s begin:"
        Else
            Me.ltrPage4.Text = "Bueno, empecemos:"
        End If
    End Sub

    Private Sub LoadPage5()
        If _Language = Language.English Then
            Me.ltrPage5.Text = "The following questions will highlight and summarize certain parts of the legal service agreement you have signed.</br>"
        Else
            Me.ltrPage5.Text = "Las preguntas siguientes dictaran y resumirán ciertas partes del acuerdo legal de servicio que usted ha firmado.</br>"
        End If
    End Sub

    Private Sub LoadPage7()
        If _Language = Language.English Then
            Me.ltrPage7.Text = "this completed this portion of the call. Thank you."
        Else
            Me.ltrPage7.Text = "Esto concluye esta parte de la llamada. Gracias."
        End If
    End Sub

    Private Sub LoadPage8()
        Me.ltrPage8.Text = ""
    End Sub

    Private Sub LoadPage9()
        Me.ltrPage9.Text = ""
    End Sub

    Private Function ApplyDepositMethodCheck(ByVal QuestionText As String) As String
        Dim qText As String = QuestionText
        If QuestionText.ToLower.StartsWith("your initial deposit amount of") Then
            qText = "Your initial deposit amount of {firstdraftamount} is scheduled for {firstdraftdate} - is that correct?"
        ElseIf QuestionText.ToLower.StartsWith("su depósito inicial por la cantidad de") Then
            qText = "Su cantidad inicial de depósito de {firstdraftamount} está planificada para el {firstdraftdate} - ¿Correcto?"
        ElseIf QuestionText.ToLower.StartsWith("su cantidad inicial del depósito") Then
            qText = "Su cantidad inicial de depósito de {firstdraftamount} está planificada para el {firstdraftdate} - ¿Correcto?"
        End If
        Return qText
    End Function

    Public Function GetQuestionText(ByVal QuestionText As String) As String
        If _DepositMethod = "check" Then QuestionText = ApplyDepositMethodCheck(QuestionText)
        Return QuestionText.Replace("{state}", _State).Replace("{lawfirm}", _LawFirm).Replace("{firstdraftamount}", _FirstDraft).Replace("{firstdraftdate}", _FirstDraftDate).Replace("{genericfirm}", _GenericFirm)
    End Function

    Protected Sub rptQuestions_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles rptQuestions.ItemCommand
        Select Case e.CommandName.ToLower.Trim
            Case "continue"
                Dim nextQuestion As Integer = CInt(e.CommandArgument) + 1
                Me.hdnCurrentQuestion.Value = nextQuestion
                ShowQuestion(nextQuestion)
                CallVerificationHelper.InsertVerficationCallLog(Me.hdnVerificationCallId.Value, e.CommandArgument, 0)
                If Me.rptQuestions.Items.Count < nextQuestion Then CompleteRecord("Question " & e.CommandArgument)
            Case "continuewithno"
                Dim nextQuestion As Integer = CInt(e.CommandArgument) + 1
                Me.hdnCurrentQuestion.Value = nextQuestion
                ShowQuestion(nextQuestion)
                CallVerificationHelper.InsertVerficationCallLog(Me.hdnVerificationCallId.Value, e.CommandArgument, 1)
                If Me.rptQuestions.Items.Count < nextQuestion Then CompleteRecord("Question " & e.CommandArgument)
            Case Else
                CallVerificationHelper.InsertVerficationCallLog(Me.hdnVerificationCallId.Value, e.CommandArgument, 1)
                AbortRecord("Question " & e.CommandArgument, "")
        End Select
    End Sub

    Protected Sub rptQuestions_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptQuestions.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            e.Item.Visible = CType(e.Item.DataItem, System.Data.DataRowView)("QuestionNo") = CInt(Me.hdnCurrentQuestion.Value)
        End If
    End Sub

    Private Sub ShowQuestion(ByVal QuestionNo As Integer)
        For Each itm As RepeaterItem In Me.rptQuestions.Items
            itm.Visible = (itm.ItemIndex = QuestionNo - 1)
        Next
    End Sub

    Protected Sub BtnYes1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnYes1.Click, BtnYes2.Click, BtnYes3.Click, btnStartQuestions.Click, BtnStartRecording.Click
        Dim btn As Button = CType(sender, Button)
        ShowPage(CInt(btn.CommandArgument + 1))
    End Sub

    Private Sub CreateVerificationCall()
        Try
            Dim interactionId As String
            _currentInteraction = GetCurrentInteraction(1000)
            If Not _currentInteraction Is Nothing AndAlso Not _currentInteraction.IsDisconnected AndAlso Not _currentInteraction.StateDescription.Trim.ToLower = "dialing" Then
                If Not _currentInteraction.IsRecording Then
                    StartRecording()
                    interactionId = _currentInteraction.CallIdKey
                    Me.hdnVerificationCallId.Value = CallVerificationHelper.InsertVerficationCall(_ClientID, interactionId, _Language, _UserID)
                Else
                    Throw New Exception("Sorry, You cannot start the verification process because the current call is recording already.")
                End If
            Else
                Throw New Exception("Sorry, You cannot start the verification process because there is no current call.")
            End If
        Catch ex As Exception
            ShowError(ex.Message)
        End Try
    End Sub

    Private Sub StartRecording()
        Try
            _currentInteraction.Record(True, False)
        Catch ex As Exception
            CallControlsHelper.InsertCallMessageLog("Start Recording Verification Error: " & ex.Message, _UserID)
            Throw
        End Try
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
            Dim pdfname As String = GeneratePDF()
            CallVerificationHelper.UpdateVerificationCall(Me.hdnVerificationCallId.Value, Now, True, "", "", LastStep, pdfname, "")

            'update the lead cost if this is a rev share client
            Dim params As New List(Of Data.SqlClient.SqlParameter)
            params.Add(New Data.SqlClient.SqlParameter("clientid", _ClientID))
            SqlHelper.ExecuteNonQuery("stp_UpdateRevShareLead", , params.ToArray)

            ShowPage(7)
        Catch ex As Exception
            ShowError("Error: " & ex.Message)
        End Try
    End Sub

    Private Function GeneratePDF() As String
        Dim pdfname As String = String.Empty
        Try
            pdfname = CallVerificationHelper.CreatePDF(Me.hdnVerificationCallId.Value, Me.GetDataTableDoc())
            If pdfname.Trim.Length = 0 Then Throw New Exception("Could not generate the verification file.")
            pdfname = CallVerificationHelper.AttachPDFDocument(_ClientID, _UserID, pdfname)
            If pdfname.Trim.Length = 0 Then Throw New Exception("Could not attach the verification file.")
        Catch ex As Exception
            CallControlsHelper.InsertCallMessageLog("Error generating verification call .pdf: " & ex.Message, _UserID)
            pdfname = ""
            'Throw
        End Try
        Return pdfname
    End Function

    Private Function GetHTMLDoc() As String
        Dim sb As New System.Text.StringBuilder
        Dim text As String
        Dim number As Integer
        Dim aYes As String = "Yes"
        Dim aNo As String = "No"
        sb.Append("<table style='font-size: 8px; border: solid 1px black;'><td>Question</td><td>Answer</td></tr>")
        For Each question As RepeaterItem In Me.rptQuestions.Items
            number = question.ItemIndex + 1
            text = CType(question.FindControl("tdQuestion"), HtmlTableCell).InnerText.Trim
            sb.AppendFormat("<tr><td align='left'>{0}. {1}</td><td align='left'>{2}</td></tr>", number.ToString.Trim, text, aYes)
        Next
        sb.Append("</table>")
        Return sb.ToString
    End Function

    Private Function GetDataTableDoc() As DataTable
        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("No"))
        dt.Columns.Add(New DataColumn("Question"))
        dt.Columns.Add(New DataColumn("Answer"))
        Dim dtAnswers As DataTable = CallVerificationHelper.GetCallVerificationAnswers(hdnVerificationCallId.Value)
        Dim answer As String
        Dim questionNo As Integer
        For Each question As RepeaterItem In Me.rptQuestions.Items
            questionNo = question.ItemIndex + 1
            If dtAnswers.Select(String.Format("QuestionNo={0}", questionNo.ToString))(0)("AnsweredNo") Then
                answer = "No"
            Else
                answer = IIf(_Language = Language.English, "Yes", "Sí")
            End If
            dt.Rows.Add(New Object() {questionNo.ToString, String.Format("{0}", CType(question.FindControl("tdQuestion"), HtmlTableCell).InnerText.Trim), answer})
        Next
        Return dt
    End Function

    Private Sub AbortRecord(ByVal LastStep As String, ByVal Message As String)
        Try
            hdnRepExt.Value = ""
            CallVerificationHelper.UpdateVerificationCall(Me.hdnVerificationCallId.Value, Nothing, False, "", "", LastStep, "", "")

            ltrPage9.Text = "Client answered No at " & LastStep
            If _Language = Language.English Then
                ltrPage9.Text = "<br/>This call will be transferred to your agent so he/she can explain to you better."
            Else
                ltrPage9.Text = "<br/>Esta llamada sera transferida a su representante para que el o ella le explique sus dudas con mayor detalle."
            End If

            CallVerificationHelper.ReturnToCID(_ClientID, "Verification call stopped at step " & LastStep, _UserID)

            'Get Rep Name and extention
            Dim dtRep As DataTable = CallVerificationHelper.GetClientIntakeRep(_ClientID)
            If dtRep.Rows.Count > 0 Then
                Dim AgentName As String = dtRep.Rows(0)("FullName")
                Dim repName As String = dtRep.Rows(0)("username")
                Dim extension As String = ConnectionContext.GetUserExtension(repName.Trim)

                If extension.Trim.Length = 0 Then
                    'Throw New Exception(String.Format("Could not get the extension number of {0} to transfer this call.", AgentName))
                    ltrPage9.Text &= String.Format("<br/><font color='red'>[Could not get the extension number of {0} to transfer this call.]</font>", AgentName)
                Else
                    btnCallTransfer.CommandArgument = extension
                    ltrPage9.Text &= String.Format("<br/>Agent Name: {0}", AgentName)
                    If _Language = Language.English Then
                        ltrPage9.Text &= "<br/>Please, wait while this call is being transferred. Thank you."
                    Else
                        ltrPage9.Text &= "<br/>Por favor, espere en la linea mientras su llamada esta siendo transferida. Gracias."
                    End If
                    hdnRepExt.Value = extension.ToString
                End If
            Else
                'Throw New Exception("Could not get the Client Intake Rep Information to transfer this call.")
                ltrPage9.Text &= "<br/><font color='red'>[Could not get the Client Intake Rep Information to transfer this call.]</font>"
            End If
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
        'Close Form
    End Sub

    Protected Sub btnClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnClose.Click
        'Close Form
    End Sub

    Protected Sub BtnLanguage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnLanguage.Click
        _Language = CInt(Me.ddlLanguage.SelectedValue)
        LoadForm()
        CreateVerificationCall()
    End Sub


End Class
