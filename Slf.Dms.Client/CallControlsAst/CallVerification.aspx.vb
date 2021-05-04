Imports ININ.IceLib.Interactions
Imports System.Collections
Imports System.Collections.Generic
Imports System.Collections.ObjectModel
Imports System.Data
Imports System.Configuration
Imports System.Linq

Public MustInherit Class VerificationCallPerson
    Enum Language
        English = 1
        Spanish = 2
    End Enum

    Protected _Id As Integer
    Protected _LawFirm As String
    Protected _State As String
    Protected _FirstDraft As String
    Protected _FirstDraftDate As String
    Protected _DepositMethod As String = "[Not Available]"
    Protected _VersionId As Integer
    Protected _GenericFirm As String
    Protected _Language As Language
    Protected _Applicants As List(Of VerificationApplicant)
    Protected _PrimaryApplicant As VerificationApplicant
    Protected _InitialServiceFees As String = "$775.00"
    Protected _MonthlyAmount As String = "[Not Available]"
    Protected _DepositDay As String = "[Not Available]"
    Protected _BankAccountNumber As String = "[Not Available]"
    Protected _BankName As String = "[Not Available]"
    Protected _SettlementFeePct As String = "[Not Available]"
    Protected _MaintenanceFee As String = "[Not Available]"

    Public MustOverride ReadOnly Property PersonType() As String

    Protected Function GetSSN(ByVal dr As DataRow) As String
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

    Public Property ID() As Integer
        Get
            Return _Id
        End Get
        Set(ByVal value As Integer)
            _Id = value
        End Set
    End Property

    Public Property PreferredLanguage() As Language
        Get
            Return _Language
        End Get
        Set(ByVal value As Language)
            _Language = value
        End Set
    End Property

    Public Property Version() As Integer
        Get
            Return _VersionId
        End Get
        Set(ByVal value As Integer)
            _VersionId = value
        End Set
    End Property

    Public Property DepositMethod() As String
        Get
            Return _DepositMethod
        End Get
        Set(ByVal value As String)
            _DepositMethod = value
        End Set
    End Property

    Public Property State() As String
        Get
            Return _State
        End Get
        Set(ByVal value As String)
            _State = value
        End Set
    End Property

    Public Property LawFirm() As String
        Get
            Return _LawFirm
        End Get
        Set(ByVal value As String)
            _LawFirm = value
        End Set
    End Property

    Public Property FirstDraft() As String
        Get
            Return _FirstDraft
        End Get
        Set(ByVal value As String)
            _FirstDraft = value
        End Set
    End Property

    Public Property FirstDraftDate() As String
        Get
            Return _FirstDraftDate
        End Get
        Set(ByVal value As String)
            _FirstDraftDate = value
        End Set
    End Property

    Public Property GenericFirm() As String
        Get
            Return _GenericFirm
        End Get
        Set(ByVal value As String)
            _GenericFirm = value
        End Set
    End Property

    Public Property InitialSeviceFees() As String
        Get
            Return _InitialServiceFees
        End Get
        Set(ByVal value As String)
            _InitialServiceFees = value
        End Set
    End Property

    Public Property MonthlyDepositAmount() As String
        Get
            Return _MonthlyAmount
        End Get
        Set(ByVal value As String)
            _MonthlyAmount = value
        End Set
    End Property

    Public Property DepositDay() As String
        Get
            Return _DepositDay
        End Get
        Set(ByVal value As String)
            _DepositDay = value
        End Set
    End Property

    Public Property BankAccountNumber() As String
        Get
            Return _BankAccountNumber
        End Get
        Set(ByVal value As String)
            _BankAccountNumber = value
        End Set
    End Property

    Public Property BankName() As String
        Get
            Return _BankName
        End Get
        Set(ByVal value As String)
            _BankName = value
        End Set
    End Property

    Public Property SettlementFeePct() As String
        Get
            Return _SettlementFeePct
        End Get
        Set(ByVal value As String)
            _SettlementFeePct = value
        End Set
    End Property

    Public Property MaitenanceFee() As String
        Get
            Return _MaintenanceFee
        End Get
        Set(ByVal value As String)
            _MaintenanceFee = value
        End Set
    End Property

    Public ReadOnly Property Applicants() As List(Of VerificationApplicant)
        Get
            Return _Applicants
        End Get
    End Property

    Public ReadOnly Property PrimaryApplicant() As VerificationApplicant
        Get
            Return _PrimaryApplicant
        End Get
    End Property

    Protected Function GetPrimary() As VerificationApplicant
        If Not _Applicants Is Nothing AndAlso _Applicants.Count > 0 Then
            Dim qryApplicant = From a In _Applicants _
                               Where a.IsPrimary = True _
                               Select a
            Try
                Return qryApplicant.Take(1)(0)
            Catch ex As Exception
                Return _Applicants(0)
            End Try
        Else
            Return Nothing
        End If
    End Function

    Protected Sub TranslateFields()
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
        For Each app As VerificationApplicant In _Applicants
            If _Language = Language.Spanish Then
                app.Title = app.Title.Replace("Mr.", "Sr.").Replace("Mrs.", "Sra.")
            End If
        Next
    End Sub

    Public MustOverride Function InsertVerficationCall(ByVal CallId As String, ByVal UserId As Integer) As Integer
    Public MustOverride Function GetPreferredLanguage() As Integer
    Public MustOverride Sub GetData()
    Public MustOverride Sub GetApplicants()
    Public MustOverride Sub UpdateRevShare()
    Public MustOverride Function CreatePDF(ByVal VerificationId As Integer, ByVal Questions As DataTable) As String
    Public MustOverride Function AttachPDF(ByVal FileName As String, ByVal UserId As Integer) As String

End Class

Public Class VerificationApplicant
    Private _SSN As String
    Private _Name As String
    Private _IsPrimary As Boolean
    Private _Title As String = ""

    Public Property SSN() As String
        Get
            Return _SSN
        End Get
        Set(ByVal value As String)
            _SSN = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return _Name
        End Get
        Set(ByVal value As String)
            _Name = value
        End Set
    End Property

    Public Property IsPrimary() As Boolean
        Get
            Return _IsPrimary
        End Get
        Set(ByVal value As Boolean)
            _IsPrimary = value
        End Set
    End Property

    Public Property Title() As String
        Get
            Return _Title
        End Get
        Set(ByVal value As String)
            _Title = value
        End Set
    End Property
End Class

Public Class VerificationCallClient
    Inherits VerificationCallPerson

    Public Sub New(ByVal ClientId As Integer)
        _Id = ClientId
    End Sub

    Public Overrides ReadOnly Property PersonType() As String
        Get
            Return "Client"
        End Get
    End Property

    Public Overrides Function InsertVerficationCall(ByVal CallId As String, ByVal UserId As Integer) As Integer
        Return CallVerificationHelper.InsertVerficationCall(_Id, CallId, _Language, UserId)
    End Function

    Public Overrides Function GetPreferredLanguage() As Integer
        Return CallVerificationHelper.GetClientPreferredLanguage(_Id)
    End Function

    Public Overrides Sub GetData()
        Dim dtClient As DataTable = CallVerificationHelper.GetClientData(_Id)
        Dim dtClient2 As DataTable = CallVerificationHelper.GetClientData2(_Id)
        _LawFirm = dtClient.Rows(0)("LawFirm").ToString
        _State = dtClient.Rows(0)("SAState").ToString

        _FirstDraft = String.Format("{0:c}", dtClient.Rows(0)("InitialDraftAmount"))
        If dtClient.Rows(0)("InitialDraftDate") Is DBNull.Value Then
            _FirstDraftDate = "Not Defined"
        Else
            _FirstDraftDate = Format(CDate(dtClient.Rows(0)("InitialDraftDate")), "MM/dd/yyyy")
        End If

        _DepositMethod = dtClient.Rows(0)("DepositMethod").ToString.ToLower
        _VersionId = CallVerificationHelper.GetClientLexxPVVersion(_Id)

        If dtClient2.Rows.Count > 0 Then
            If Not dtClient2.Rows(0)("DepositMethod") Is DBNull.Value Then _DepositMethod = dtClient2.Rows(0)("DepositMethod")
            If Not dtClient2.Rows(0)("MonthlyDepositAmount") Is DBNull.Value Then _MonthlyAmount = String.Format("{0:c}", dtClient2.Rows(0)("MonthlyDepositAmount"))
            If Not dtClient2.Rows(0)("BankAccountNumber") Is DBNull.Value Then _BankAccountNumber = dtClient2.Rows(0)("BankAccountNumber")
            If Not dtClient2.Rows(0)("BankName") Is DBNull.Value Then _BankName = dtClient2.Rows(0)("BankName")
            If Not dtClient2.Rows(0)("SettlementFeePct") Is DBNull.Value Then _SettlementFeePct = String.Format("{0}%", dtClient2.Rows(0)("SettlementFeePct"))
            If Not dtClient2.Rows(0)("MaintenanceFee") Is DBNull.Value Then _MaintenanceFee = String.Format("{0:c}", dtClient2.Rows(0)("MaintenanceFee"))
            If Not dtClient2.Rows(0)("DepositDay") Is DBNull.Value Then
                _DepositDay = dtClient2.Rows(0)("DepositDay")
                If _DepositDay.EndsWith(",") Then _DepositDay.Remove(_DepositDay.Length - 1, 1)
            End If
            If Not dtClient2.Rows(0)("TotalDebt") Is DBNull.Value Then _InitialServiceFees = String.Format("{0:c}", CallVerificationHelper.GetInitialFeeAmount(CallVerificationHelper.GetInitialFeeCategory(dtClient2.Rows(0)("TotalDebt"))))
        End If
        GetApplicants()
        TranslateFields()
    End Sub

    Public Overrides Sub GetApplicants()
        Dim dtApplicant As DataTable = CallVerificationHelper.GetApplicantsData(_Id)
        If dtApplicant.Rows.Count > 0 Then
            _Applicants = New List(Of VerificationApplicant)
            For Each dr As DataRow In dtApplicant.Rows
                _Applicants.Add(New VerificationApplicant() With {.Name = dr("FullName").ToString, .SSN = GetSSN(dr), .IsPrimary = (dr("Primary") = 1), .Title = dr("Title")})
            Next
        End If
        _PrimaryApplicant = GetPrimary()
    End Sub

    Public Overrides Sub UpdateRevShare()
        'update the lead cost if this is a rev share client
        Dim params As New List(Of Data.SqlClient.SqlParameter)
        params.Add(New Data.SqlClient.SqlParameter("clientid", _Id))
        SqlHelper.ExecuteNonQuery("stp_UpdateRevShareLead", , params.ToArray)
    End Sub

    Public Overrides Function CreatePDF(ByVal VerificationId As Integer, ByVal Questions As System.Data.DataTable) As String
        Dim dtClientInfo As DataTable
        Try
            dtClientInfo = CallVerificationHelper.GetCallVerificationClientInfo(VerificationId)
        Catch ex As Exception
            Return ""
        End Try
        Return ClientFileDocumentHelper.GenerateVerificationCallPdf(VerificationId, Questions, dtClientInfo)
    End Function

    Public Overrides Function AttachPDF(ByVal FileName As String, ByVal UserID As Integer) As String
        Return CallVerificationHelper.AttachPDFDocument(_Id, UserID, FileName)
    End Function
End Class

Public Class VerificationCallLead
    Inherits VerificationCallPerson

    Public Sub New(ByVal LeadId As Integer)
        _Id = LeadId
    End Sub

    Public Overrides ReadOnly Property PersonType() As String
        Get
            Return "Lead Applicant"
        End Get
    End Property

    Public Overrides Function InsertVerficationCall(ByVal CallId As String, ByVal UserId As Integer) As Integer
        Return CallVerificationHelper.InsertVerficationCallThirdParty(_Id, CallId, _Language, UserId)
    End Function

    Public Overrides Function GetPreferredLanguage() As Integer
        Return CallVerificationHelper.GetLeadPreferredLanguage(_Id)
    End Function

    Public Overrides Sub GetData()
        Dim dtLead As DataTable = CallVerificationHelper.GetLeadData(_Id)
        Dim dtLead2 As DataTable = CallVerificationHelper.GetLeadData2(_Id)
        _LawFirm = dtLead.Rows(0)("LawFirm").ToString
        _State = dtLead.Rows(0)("SAState").ToString

        _FirstDraft = String.Format("{0:c}", dtLead.Rows(0)("InitialDraftAmount"))
        If dtLead.Rows(0)("InitialDraftDate") Is DBNull.Value Then
            _FirstDraftDate = "Not Defined"
        Else
            _FirstDraftDate = Format(CDate(dtLead.Rows(0)("InitialDraftDate")), "MM/dd/yyyy")
        End If

        _DepositMethod = dtLead.Rows(0)("DepositMethod").ToString.ToLower
        _VersionId = CallVerificationHelper.GetLeadLexxPVVersion(_Id)

        If dtLead2.Rows.Count > 0 Then
            If Not dtLead2.Rows(0)("DepositMethod") Is DBNull.Value Then _DepositMethod = dtLead2.Rows(0)("DepositMethod")
            If Not dtLead2.Rows(0)("MonthlyDepositAmount") Is DBNull.Value Then _MonthlyAmount = String.Format("{0:c}", dtLead2.Rows(0)("MonthlyDepositAmount"))
            If Not dtLead2.Rows(0)("DepositDay") Is DBNull.Value Then _DepositDay = dtLead2.Rows(0)("DepositDay")
            If Not dtLead2.Rows(0)("BankAccountNumber") Is DBNull.Value Then _BankAccountNumber = dtLead2.Rows(0)("BankAccountNumber")
            If Not dtLead2.Rows(0)("BankName") Is DBNull.Value Then _BankName = dtLead2.Rows(0)("BankName")
            If Not dtLead2.Rows(0)("SettlementFeePct") Is DBNull.Value Then _SettlementFeePct = String.Format("{0}%", dtLead2.Rows(0)("SettlementFeePct"))
            If Not dtLead2.Rows(0)("MaintenanceFee") Is DBNull.Value Then _MaintenanceFee = String.Format("{0:c}", dtLead2.Rows(0)("MaintenanceFee"))
            If Not dtLead2.Rows(0)("TotalDebt") Is DBNull.Value Then _InitialServiceFees = String.Format("{0:c}", CallVerificationHelper.GetInitialFeeAmount(CallVerificationHelper.GetInitialFeeCategory(dtLead2.Rows(0)("TotalDebt"))))
        End If
        GetApplicants()
        TranslateFields()
    End Sub

    Public Overrides Sub GetApplicants()
        Dim dtApplicant As DataTable = CallVerificationHelper.GetLeadApplicantsData(_Id)
        If dtApplicant.Rows.Count > 0 Then
            _Applicants = New List(Of VerificationApplicant)
            For Each dr As DataRow In dtApplicant.Rows
                _Applicants.Add(New VerificationApplicant() With {.Name = dr("FullName").ToString, .SSN = GetSSN(dr), .IsPrimary = (dr("Primary") = 1), .Title = dr("Title")})
            Next
        End If
        _PrimaryApplicant = GetPrimary()
    End Sub

    Public Overrides Sub UpdateRevShare()
        Dim params As New List(Of Data.SqlClient.SqlParameter)
        params.Add(New Data.SqlClient.SqlParameter("LeadApplicantId", _Id))
        SqlHelper.ExecuteNonQuery("UpdateRevShareLead_UsingLeadApplicantID", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Overrides Function CreatePDF(ByVal VerificationId As Integer, ByVal Questions As System.Data.DataTable) As String
        Dim dtLeadInfo As DataTable
        Try
            dtLeadInfo = CallVerificationHelper.GetCallVerificationLeadInfo(VerificationId)
        Catch ex As Exception
            Return ""
        End Try
        Return ClientFileDocumentHelper.GenerateVerificationCallPdf(VerificationId, Questions, dtLeadInfo)
    End Function

    Public Overrides Function AttachPDF(ByVal FileName As String, ByVal UserID As Integer) As String
        Dim documentid As String = System.IO.Path.GetFileNameWithoutExtension(FileName)
        SmartDebtorHelper.SaveLeadDocument(_Id, documentid, UserID, SmartDebtorHelper.DocType.VerificationCall)
        Return FileName
    End Function

End Class

Partial Class CallControlsAst_CallVerification
    Inherits System.Web.UI.Page
    Private _Person As VerificationCallPerson
    Private _UserID As Integer

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles form1.Load
        _UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        If Drg.Util.DataAccess.DataHelper.Nz_int(Me.Request.QueryString("ClientId")) > 0 Then
            _Person = New VerificationCallClient(Drg.Util.DataAccess.DataHelper.Nz_int(Me.Request.QueryString("ClientId")))
        ElseIf Drg.Util.DataAccess.DataHelper.Nz_int(Me.Request.QueryString("LeadId")) > 0 Then
            _Person = New VerificationCallLead(Drg.Util.DataAccess.DataHelper.Nz_int(Me.Request.QueryString("LeadId")))
        Else
            Throw New Exception("Missing input parameters")
        End If

        If Not Me.IsPostBack Then
            SetClientDefaultLanguage()
            ShowPage(0)
        Else
            _Person.PreferredLanguage = CInt(Me.ddlLanguage.SelectedValue)
        End If
    End Sub

    Private Sub SetClientDefaultLanguage()
        Try
            _Person.PreferredLanguage = _Person.GetPreferredLanguage()
        Catch ex As Exception
            _Person.PreferredLanguage = VerificationCallPerson.Language.English
        End Try
        Me.ddlLanguage.SelectedIndex = IIf(_Person.PreferredLanguage = VerificationCallPerson.Language.English, 0, 1)
    End Sub

    Private Sub LoadForm()
        _Person.GetData()
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
        Me.rptQuestions.DataSource = CallVerificationHelper.GetCallVerificationQuestions(_Person.PreferredLanguage, _Person.Version)
        Me.rptQuestions.DataBind()
    End Sub

    Private Sub LoadPage1()
        If _Person.PreferredLanguage = VerificationCallPerson.Language.English Then
            Me.ltrPage1.Text = GetQuestionText("I will be asking you a series of questions regarding your understanding of the legal services as they have been explained to you, and the legal service agreement you have signed. If at any time you answer 'No' to a question, I will repeat it to ensure that you understand. If you answer 'No' again, your call will be transferred back to your enrolling representative. This portion of the call should take approximately 3 minutes to complete. What we address during this recording does not limit or replace the written language in the legal service agreement you have signed.  Now, do you understand that when I say {genericfirm}, you understand I am referring to {lawfirm}?")
        Else
            Me.ltrPage1.Text = GetQuestionText("Yo le estaré preguntando una serie de preguntas con respecto a su comprension del servicio legal como han sido explicados a usted y el acuerdo legal de servicio que usted ha firmado. Si en cualquier momento usted contesta 'NO' a una pregunta, yo lo repetiré para asegurar que usted comprenda. Si usted contesta 'No' otra vez, su llamada  será transferida a su representante que lo matriculo.  Puede tomar aproximadamente 3 minutos de completar esta llamada.  Lo qué nosotros dirijimos durante esta grabación no limita ni reemplaza el idioma escrito en el acuerdo legal de servicio que usted ha firmado. ¿Ahora, cuando digo el {genericfirm}, usted comprende que yo me refiero al {lawfirm} correcto?")
        End If
    End Sub

    Private Sub LoadPage2()
        If _Person.PreferredLanguage = VerificationCallPerson.Language.English Then
            Me.ltrPage2.Text = "Do you agree to have us record your answers to these questions? Because we are recording this with your consent, please be sure to answer each of my questions clearly out loud.?"
        Else
            Me.ltrPage2.Text = "¿Esta de acuerdo en que se grabe sus respuestas a estas preguntas? Porque estamos grabando con su consentimiento, por favor conteste cada pregunta claramente en voz alta."
        End If
    End Sub

    Private Sub LoadPage3()
        'Applicants FullName, SSN, Primary 
        'List in grid
        If _Person.PreferredLanguage = VerificationCallPerson.Language.English Then
            Me.ltrPage3.Text = "For verification purposes, please state your full name. <br/>"
            Me.ltrPage3.Text &= "Please state the last four digits of your social security number. <br/>"
        Else
            Me.ltrPage3.Text = "Para propósitos de verificacion, indique por favor su nombre y apellidos. <br/>"
            Me.ltrPage3.Text &= "Indique por favor los últimos cuatro dígitos de su número del seguro social. <br/>"
        End If

        Me.ltrPage3.Text &= "<table class='clientinfo'><tr><th>Full Name</th><th>SSN</th><th>Is Primary</th></tr>"

        '_Person.GetApplicants()
        For Each applicant As verificationApplicant In _Person.Applicants
            Me.ltrPage3.Text &= String.Format("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>", applicant.Name, applicant.SSN, IIf(applicant.IsPrimary, "Yes", "No"))
        Next
        Me.ltrPage3.Text &= "</table>"

        If _Person.PreferredLanguage = VerificationCallPerson.Language.English Then
            Me.ltrPage3.Text &= "<br/>What state do you reside in?<br/>"
        Else
            Me.ltrPage3.Text &= "<br/>En qué estado del país vive usted?<br/>"
        End If
    End Sub

    Private Sub LoadPage4()
        If _Person.PreferredLanguage = VerificationCallPerson.Language.English Then
            Me.ltrPage4.Text = "Great, let’s begin:"
        Else
            Me.ltrPage4.Text = "Bueno, empecemos:"
        End If
    End Sub

    Private Sub LoadPage5()
        If _Person.PreferredLanguage = VerificationCallPerson.Language.English Then
            Me.ltrPage5.Text = "The following questions will highlight and summarize certain parts of the legal service agreement you have signed.</br>"
        Else
            Me.ltrPage5.Text = "Las preguntas siguientes dictaran y resumirán ciertas partes del acuerdo legal de servicio que usted ha firmado.</br>"
        End If
    End Sub

    Private Sub LoadPage7()
        If _Person.PreferredLanguage = VerificationCallPerson.Language.English Then
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
        If _Person.DepositMethod = "check" Then QuestionText = ApplyDepositMethodCheck(QuestionText)
        QuestionText = QuestionText.Replace("{state}", _Person.State).Replace("{lawfirm}", _Person.LawFirm).Replace("{firstdraftamount}", _Person.FirstDraft).Replace("{firstdraftdate}", _Person.FirstDraftDate).Replace("{genericfirm}", _Person.GenericFirm).Replace("{title}", _Person.PrimaryApplicant.Title).Replace("{clientfullname}", _Person.PrimaryApplicant.Name)
        QuestionText = QuestionText.Replace("{initialservicefees}", _Person.InitialSeviceFees).Replace("{monthlyamount}", _Person.MonthlyDepositAmount).Replace("{depositday}", _Person.DepositDay)
        QuestionText = QuestionText.Replace("{bankaccountnumber}", _Person.BankAccountNumber).Replace("{bankname}", _Person.BankName).Replace("{settlementpercentfee}", _Person.SettlementFeePct).Replace("{maintenancefee}", _Person.MaitenanceFee)
        Return QuestionText.Replace("{newline}", "<br/><br/>")
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
            If hdnCallId.Value.Trim.Length > 0 Then
                If Val(hdnRecording.Value.Trim) = 0 Then
                    Dim filepath As String = ConfigurationManager.AppSettings("verificationrecordings").ToString
                    Dim ehostdomain As String = System.Configuration.ConfigurationManager.AppSettings("externalhostdomain").ToString
                    If Me.Request.ServerVariables("SERVER_NAME").ToString.Contains(ehostdomain) Then
                        filepath = ConfigurationManager.AppSettings("verificationrecordingsE").ToString
                    End If
                    Dim username As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tbluser", "username", "userid = " & _UserID)
                    Dim filename As String = String.Format("verif_{0}_{1}_{2}", hdnCallId.Value, Guid.NewGuid.ToString, username)
                    ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "startrecordingpath", String.Format("StartRecordingInPath('{0}', '{1}');", filepath.Replace("\", "\\"), filename), True)
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

    Private Sub InsertVerification()
        Me.hdnVerificationCallId.Value = _Person.InsertVerficationCall(hdnCallId.Value.Trim, _UserID)
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
            _Person.UpdateRevShare()

            ShowPage(7)
        Catch ex As Exception
            ShowError("Error: " & ex.Message)
        End Try
    End Sub

    Private Function GeneratePDF() As String
        Dim pdfname As String = String.Empty
        Try
            pdfname = _Person.CreatePDF(Me.hdnVerificationCallId.Value, Me.GetDataTableDoc())
            If pdfname.Trim.Length = 0 Then Throw New Exception("Could not generate the verification file.")
            pdfname = _Person.AttachPDF(pdfname, _UserID)
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
                answer = IIf(_Person.PreferredLanguage = VerificationCallPerson.Language.English, "Yes", "Sí")
            End If
            dt.Rows.Add(New Object() {questionNo.ToString, String.Format("{0}", CType(question.FindControl("tdQuestion"), HtmlTableCell).InnerText.Trim).Replace("<br/>", ""), answer})
        Next
        Return dt
    End Function

    Private Sub AbortRecord(ByVal LastStep As String, ByVal Message As String)
        Try
            hdnRepExt.Value = ""
            CallVerificationHelper.UpdateVerificationCall(Me.hdnVerificationCallId.Value, Nothing, False, "", "", LastStep, "", "")

            ltrPage9.Text = String.Format("{0} answered No at {1}", _Person.PersonType, LastStep)
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
        _Person.PreferredLanguage = CInt(Me.ddlLanguage.SelectedValue)
        LoadForm()
        CreateVerificationCall()
    End Sub

    Protected Sub lnkCreateVerification_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCreateVerification.Click
        InsertVerification()
    End Sub

    Public Function GetPersonId() As Integer
        Return _Person.ID
    End Function

    Public Function GetPersonType() As String
        Return _Person.PersonType
    End Function
End Class
