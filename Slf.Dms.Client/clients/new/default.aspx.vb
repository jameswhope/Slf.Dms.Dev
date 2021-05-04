Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Collections.Generic

Partial Class clients_new_default
    Inherits PermissionPage


#Region "Variables"

    ' Enrollment variables for use in javascript
    Public EnrollmentMinimum As Double
    Public EnrollmentInflation As Double
    Public EnrollmentDepositMinimum As Double
    Public EnrollmentDepositPercentage As Double
    Public EnrollmentRetainerPercentage As Double
    Public EnrollmentSettlementPercentage As Double
    Public EnrollmentMonthlyFee As Double
    Public EnrollmentPBMAPR As Double
    Public EnrollmentPBMMinimum As Double
    Public EnrollmentPBMPercentage As Double

    Private UserID As Integer

    Public optTooMuchUnsecuredDebt_idx As Integer
    Public optOther_idx As Integer

#End Region

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlMenu, c, "Clients-Client Enrollment")
        AddControl(pnlBody, c, "Clients-Client Enrollment")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then

            LoadStates()
            LoadBehinds()
            LoadConcerns()
            LoadAgencies()
            LoadCompanies()
            LoadLanguages()
            LoadNotQualifiedReasons()
            LoadNotCommittedReasons()
            LoadPlanOptions()
            LoadTrusts()

            SetProperties()
            SetAttributes()

        End If
        LoadLanguages()
    End Sub
    Private Sub SetProperties()

        EnrollmentMinimum = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentMinimum"))
        EnrollmentInflation = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentInflation"))
        EnrollmentDepositMinimum = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDepositMinimum"))
        EnrollmentDepositPercentage = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDepositPercentage"))
        EnrollmentRetainerPercentage = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentRetainerPercentage"))
        EnrollmentSettlementPercentage = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentSettlementPercentage"))
        EnrollmentMonthlyFee = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentMonthlyFee"))
        EnrollmentPBMAPR = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMAPR"))
        EnrollmentPBMMinimum = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMMinimum"))
        EnrollmentPBMPercentage = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMPercentage"))

        lblEnrollmentDisclosure.Text = PropertyHelper.Value("EnrollmentDisclosure")

        trEnrollmentDisclosure.Visible = lblEnrollmentDisclosure.Text.Length > 0

        Dim DaysUntilAppt As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDaysUntilAppt"))

        imAppointmentDate.Text = Now.AddDays(DaysUntilAppt).ToString("MM/dd/yyyy hh:mm tt")
        txtAppointmentDays.Text = DaysUntilAppt

        Dim CurrentTimeZone As String = DataHelper.FieldLookup("tblTimeZone", "Abbreviation", "DBIsHere = 1")

        lblAppointmentTime.Text = Now.ToString("hh:mm tt") & "&nbsp;&nbsp;(" & CurrentTimeZone & "ST)"

    End Sub
    Private Sub SetAttributes()

        txtName.Attributes("onblur") = "javascript:txtName_OnBlur(this);"
        txtPhone.Attributes("onblur") = "javascript:txtPhone_OnBlur(this);"
        txtZipCode.Attributes("onblur") = "javascript:txtZipCode_OnBlur(this);"
        txtZipCode2.Attributes("onblur") = "javascript:txtZipCode2_OnBlur(this);"

        imAppointmentDate.RegexPattern = "(?=\d)^(?:(?!(?:10\D(?:0?[5-9]|1[0-4])\D(?:1582))|(?:0?9\D(?:0?[3-9]|1[0-3])\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\/31)(?!-31)(?!\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\d\d)(?:[02468][048]|[13579][26])(?!\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\x20BC))))))|(?:0?2(?=.(?:(?:\d\D)|(?:[01]\d)|(?:2[0-8])))))([-.\/])(0?[1-9]|[12]\d|3[01])\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\d)\x20BC)|(?:\d{4}(?!\x20BC)))\d{4}(?:\x20BC)?)(?:$|(?=\x20\d)\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\d){0,2}(?:\x20[aApP][mM]))|(?:[01]\d|2[0-3])(?::[0-5]\d){1,2})?$"

        imAppointmentDate.OnRegexMatch = "javascript:imAppointmentDate_OnMatch();"
        imAppointmentDate.OnRegexNoMatch = "javascript:imAppointmentDate_OnNoMatch();"

        txtAppointmentDays.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtAppointmentDays.Attributes("onblur") = "javascript:txtAppointmentDays_OnBlur(this);"
        txtAppointmentDays.Attributes("onfocus") = "javascript:txtAppointmentDays_OnFocus(this);"

        'txtTotalMonthlyPayment.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtTotalMonthlyPayment.Attributes("onkeyup") = "javascript:txtTotalMonthlyPayment_OnKeyUp(this);"
        'txtTotalUnsecuredDebt.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtTotalUnsecuredDebt.Attributes("onkeyup") = "javascript:txtTotalUnsecuredDebt_OnKeyUp(this);"
        'txtDepositCommitment.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtDepositCommitment.Attributes("onkeyup") = "javascript:txtDepositCommitment_OnKeyUp(this);"

        txtLastName.Attributes("onblur") = "javascript:txtLastName_OnBlur(this);"

    End Sub
    Private Sub LoadPlanOptions()

        Dim Values() As String = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentPercentages'").Split("|")

        Dim r As New HtmlTableRow()
        Dim c As New HtmlTableCell()

        c.InnerHtml = "&nbsp;"
        c.Style("width") = "15"

        r.Cells.Add(c)

        c = New HtmlTableCell()

        c.InnerHtml = "&nbsp;"
        c.Style("width") = "140"

        r.Cells.Add(c)

        For Each Value As String In Values

            c = New HtmlTableCell()

            c.Align = "center"
            c.Style("width") = "70"
            c.Style("font-weight") = "bold"
            c.Style("background-color") = "#f1f1f1"

            c.InnerHtml = "<input type=""hidden"" value=""" & Value & """ />" & Double.Parse(Value).ToString("#,##0.##%")

            r.Cells.Add(c)

        Next

        c = New HtmlTableCell()

        c.InnerHtml = "&nbsp;"

        r.Cells.Add(c)

        tblPlanOptions.Rows.Add(r)

        Dim Points As New List(Of String)

        Points.Add("Estimated total paid:")
        Points.Add("Estimated retainer fee:")
        Points.Add("Estimated maintenance fee:")
        Points.Add("Estimated settlement fee:")
        Points.Add("Estimated settlement cost:")
        Points.Add("Estimated debt free in:")
        Points.Add("Estimated savings:")

        For i As Integer = 0 To Points.Count - 1

            r = New HtmlTableRow()
            c = New HtmlTableCell()

            c.InnerHtml = (i + 8) & "."
            c.Align = "center"
            c.Style("width") = "15"

            r.Cells.Add(c)

            c = New HtmlTableCell()

            c.NoWrap = True
            c.InnerHtml = Points(i)
            c.Style("width") = "150"

            r.Cells.Add(c)

            For j As Integer = 0 To Values.Length - 1

                c = New HtmlTableCell()

                c.NoWrap = True
                c.Align = "right"
                c.Style("width") = "70"
                c.Style("border") = "solid 1px #d3d3d3"

                If i = Points.Count - 1 Then 'last point
                    c.Style("color") = "rgb(0,159,0)"
                End If

                c.InnerHtml = ""

                r.Cells.Add(c)

            Next

            c = New HtmlTableCell()

            c.InnerHtml = "&nbsp;"

            r.Cells.Add(c)

            tblPlanOptions.Rows.Add(r)

        Next

    End Sub
    Private Sub LoadNotQualifiedReasons()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblReason WHERE ReasonTypeID = 1"

        optNotQualifiedReason.Items.Clear()
        Dim idx As Integer = 0
        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                Dim ReasonId As Integer = DatabaseHelper.Peel_int(rd, "ReasonID")
                If ReasonId = 2 Then
                    optTooMuchUnsecuredDebt_idx = idx
                End If
                optNotQualifiedReason.Items.Add(New ListItem(" " & DatabaseHelper.Peel_string(rd, "Name"), ReasonId))
                idx += 1
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        optNotQualifiedReason.Items.Add(New ListItem("There was no reason.  They just didn't qualify.", 0))
        idx += 1
        optOther_idx = idx
        optNotQualifiedReason.Items.Add(New ListItem("Other reason.  Please specify below.", -1))

    End Sub
    Private Sub LoadNotCommittedReasons()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblReason WHERE ReasonTypeID = 2"

        optNotCommittedReason.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                optNotCommittedReason.Items.Add(New ListItem(" " & DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "ReasonID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        optNotCommittedReason.Items.Add(New ListItem("There was no reason.  They just didn't commit.", 0))
        optNotCommittedReason.Items.Add(New ListItem("Other reason.  Please specify below.", -1))

    End Sub
    Private Sub LoadStates()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblState ORDER BY [Name]"

        cboStateID.Items.Clear()
        cboStateID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboStateID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Abbreviation"), DatabaseHelper.Peel_int(rd, "StateID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadBehinds()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblBehind"

        cboBehindID.Items.Clear()
        cboBehindID.Items.Add(New ListItem(String.Empty, 0))
        cboBehindID.Items.Add(New ListItem("Not Behind", -1))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboBehindID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "BehindID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadConcerns()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblConcern ORDER BY [Name]"

        cboConcernID.Items.Clear()
        cboConcernID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboConcernID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "ConcernID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadAgencies()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblAgency ORDER BY [Name]"

        cboAgencyID.Items.Clear()
        cboAgencyID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboAgencyID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "AgencyID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadCompanies()
        Dim CompanyIDs As String = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        If Len(CompanyIDs) > 0 Then
            cmd.CommandText = "SELECT * FROM tblCompany WHERE CompanyID in (" & CompanyIDs & ") ORDER BY [Name]"
        Else
            cmd.CommandText = "SELECT * FROM tblCompany ORDER BY [Name]"
        End If

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboCompanyID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "CompanyID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ' set default company as selected
        Dim DefaultCompanyID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblCompany", "CompanyID", _
            "[Default] = 1"))

        ListHelper.SetSelected(cboCompanyID, DefaultCompanyID)

    End Sub
    Private Sub LoadLanguages()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblLanguage ORDER BY [Default] DESC, [Name]"

        cboLanguageID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboLanguageID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "LanguageID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadTrusts()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TrustID, DisplayName [Name] FROM tbltrust where Display = 1 ORDER BY [Default] DESC, [Name]"

        cboLanguageID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTrustID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "trustid")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Dim EnrollmentID As Integer = InsertEnrollment()

        Dim ClientID As Integer = SetupClient(EnrollmentID)

        'if entered folloup time, write in task propagation exception for this date
        If imAppointmentDate.Text.Length > 0 Then
            TaskPropagationExceptionHelper.Insert(ClientID, 2, DataHelper.Nz_date(imAppointmentDate.Text), UserID)
        End If

        'store iscommitted roadmaps (return id for task assignment)
        Dim IsCommittedRoadmapID As Integer = RoadmapHelper.InsertRoadmap(ClientID, 5, Nothing, UserID)

        'store lsa task
        Dim TaskTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTaskType", "TaskTypeID", "[Name] = 'Generate LSA'"))
        Dim Description As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & TaskTypeID)

        TaskHelper.InsertTask(ClientID, IsCommittedRoadmapID, TaskTypeID, Description, UserID, Now, UserID)

        GoToClientRecord(ClientID)

    End Sub
    Protected Sub lnkSaveNotQualified_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveNotQualified.Click

        Dim EnrollmentID As Integer = InsertEnrollment()

        Select Case optNotQualifiedReason.SelectedValue
            Case 0      'no reason
            Case -1     'custom reason
                EnrollmentHelper.UpdateEnrollmentNotQualified(EnrollmentID, DataHelper.Zn(txtNotQualifiedReason.Text))
            Case Else
                EnrollmentHelper.UpdateEnrollmentNotQualified(EnrollmentID, optNotQualifiedReason.SelectedItem.Text.Trim(New Char() {" "}))
        End Select

        Dim ClientID As Integer = SetupClient(EnrollmentID)

        'store notqualified roadmap
        Select Case optNotQualifiedReason.SelectedValue
            Case -1     'custom reason
                RoadmapHelper.InsertRoadmap(ClientID, 3, txtNotQualifiedReason.Text, UserID)
            Case Else
                RoadmapHelper.InsertRoadmap(ClientID, 3, optNotQualifiedReason.SelectedItem.Text.Trim(New Char() {" "}), UserID)
        End Select

        GoToClientRecord(ClientID)

    End Sub
    Protected Sub lnkSaveNotCommitted_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveNotCommitted.Click

        Dim EnrollmentID As Integer = InsertEnrollment()

        Select Case optNotCommittedReason.SelectedValue
            Case 0      'no reason
            Case -1     'custom reason
                EnrollmentHelper.UpdateEnrollmentNotCommitted(EnrollmentID, DataHelper.Zn(txtNotCommittedReason.Text))
            Case Else
                EnrollmentHelper.UpdateEnrollmentNotCommitted(EnrollmentID, optNotCommittedReason.SelectedItem.Text.Trim(New Char() {" "}))
        End Select

        Dim ClientID As Integer = SetupClient(EnrollmentID)

        'store notcommitted roadmap
        Select Case optNotCommittedReason.SelectedValue
            Case -1     'custom reason
                RoadmapHelper.InsertRoadmap(ClientID, 4, txtNotCommittedReason.Text, UserID)
            Case Else
                RoadmapHelper.InsertRoadmap(ClientID, 4, optNotCommittedReason.SelectedItem.Text.Trim(New Char() {" "}), UserID)
        End Select

        GoToClientRecord(ClientID)

    End Sub
    Private Function InsertEnrollment() As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Name", DataHelper.Zn(txtName.Text))
        DatabaseHelper.AddParameter(cmd, "Phone", DataHelper.Zn(txtPhone.TextUnMasked))
        DatabaseHelper.AddParameter(cmd, "ZipCode", DataHelper.Zn(txtZipCode2.Text))
        DatabaseHelper.AddParameter(cmd, "Behind", (Not ListHelper.GetSelected(cboBehindID) = -1))
        DatabaseHelper.AddParameter(cmd, "BehindID", ListHelper.GetSelected(cboBehindID))
        DatabaseHelper.AddParameter(cmd, "ConcernID", ListHelper.GetSelected(cboConcernID))
        DatabaseHelper.AddParameter(cmd, "TotalUnsecuredDebt", DataHelper.Zn(DataHelper.Nz_double(txtTotalUnsecuredDebt.Text)), DbType.Currency)
        DatabaseHelper.AddParameter(cmd, "TotalMonthlyPayment", DataHelper.Zn(DataHelper.Nz_double(txtTotalMonthlyPayment.Text)), DbType.Currency)
        DatabaseHelper.AddParameter(cmd, "EstimatedEndAmount", DataHelper.Zn(DataHelper.Nz_double(txtEstimatedEndAmount.Value)), DbType.Currency)
        DatabaseHelper.AddParameter(cmd, "EstimatedEndTime", DataHelper.Zn(DataHelper.Nz_int(txtEstimatedEndTime.Value)), DbType.Int32)
        DatabaseHelper.AddParameter(cmd, "DepositCommitment", DataHelper.Zn(DataHelper.Nz_double(txtDepositCommitment.Text)), DbType.Currency)
        DatabaseHelper.AddParameter(cmd, "BalanceAtEnrollment", DataHelper.Zn(DataHelper.Nz_double(txtBalanceAtEnrollment.Value)), DbType.Currency)
        DatabaseHelper.AddParameter(cmd, "BalanceAtSettlement", DataHelper.Zn(DataHelper.Nz_double(txtBalanceAtSettlement.Value)), DbType.Currency)
        DatabaseHelper.AddParameter(cmd, "DeliveryMethod", cboDeliveryMethod.SelectedValue)
        DatabaseHelper.AddParameter(cmd, "AgencyID", ListHelper.GetSelected(cboAgencyID))
        DatabaseHelper.AddParameter(cmd, "CompanyID", ListHelper.GetSelected(cboCompanyID))
        DatabaseHelper.AddParameter(cmd, "Qualified", True)
        DatabaseHelper.AddParameter(cmd, "Committed", True)
        DatabaseHelper.AddParameter(cmd, "FollowUpDate", DataHelper.Zn(imAppointmentDate.Text), DbType.DateTime)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblEnrollment", "EnrollmentID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@EnrollmentID").Value)

    End Function
    Private Sub InsertNotes(ByVal ClientID As Integer, ByVal RoadmapID As Integer)

        'store notes
        If txtNotes.Value.Length > 0 Then

            Dim Notes() As String = Regex.Split(txtNotes.Value, "\|--\$--\|")

            For Each Note As String In Notes

                Dim NoteID As Integer = NoteHelper.InsertNote(Note, UserID, ClientID)

                Dim RoadmapNoteID As Integer = RoadmapHelper.InsertRoadmapNote(RoadmapID, NoteID, UserID)

            Next

        End If

    End Sub
    Private Function SetupClient(ByVal EnrollmentID As Integer) As Integer

        'store client
        Dim ClientID As Integer = ClientHelper.InsertClient(EnrollmentID, _
            DataHelper.Nz_int(cboAgencyID.SelectedValue), DataHelper.Nz_int(cboCompanyID.SelectedValue), _
            UserID)

        'update trust id
        ClientHelper.UpdateField(ClientID, "TrustID", cboTrustID.SelectedValue, UserID)

        'fix enrollment - update clientid
        EnrollmentHelper.UpdateEnrollmentClientID(EnrollmentID, ClientID)

        'auto-complete gender for person
        Dim Gender As String = NameHelper.GetGender(txtFirstName.Text)

        'store primary applicant
        Dim PersonID As Integer = PersonHelper.InsertPerson(ClientID, txtFirstName.Text, txtLastName.Text, _
            Gender, ListHelper.GetSelected(cboLanguageID), txtEmailAddress.Text, txtStreet.Text, _
            txtStreet2.Text, txtCity.Text, ListHelper.GetSelected(cboStateID), txtZipCode.Text, "Prime", _
            True, UserID)

        'store spouse applicant
        If txtFirstNameSpouse.Text.Length > 0 Then

            Dim LastName As String = txtLastNameSpouse.Text

            If LastName.Length = 0 Then
                LastName = txtLastName.Text
            End If

            'auto-complete gender for spouse
            Dim SpouseGender As String = NameHelper.GetGender(txtFirstNameSpouse.Text)

            Dim SpousePersonID As Integer = PersonHelper.InsertPerson(ClientID, txtFirstNameSpouse.Text, _
                LastName, SpouseGender, ListHelper.GetSelected(cboLanguageID), Nothing, txtStreet.Text, _
                txtStreet2.Text, txtCity.Text, ListHelper.GetSelected(cboStateID), txtZipCode.Text, "Spouse", _
                True, UserID)

        End If

        'store home phone number
        Dim HomePhoneType As String = DataHelper.Nz_int(DataHelper.FieldLookup("tblPhoneType", "PhoneTypeID", "[Name] = 'Home'"))
        Dim HomePhoneNumber As String = txtHomePhone.TextUnMasked

        If HomePhoneNumber.Length > 0 Then

            Dim PhoneID As Integer = PhoneHelper.InsertPhone(HomePhoneType, HomePhoneNumber.Substring(0, 3), _
                HomePhoneNumber.Substring(3), String.Empty, UserID)

            Dim PersonPhoneID As Integer = PersonHelper.InsertPersonPhone(PersonID, PhoneID, UserID)

        End If

        'store business phone number
        Dim BusinessPhoneType As String = DataHelper.Nz_int(DataHelper.FieldLookup("tblPhoneType", "PhoneTypeID", "[Name] = 'Business'"))
        Dim BusinessPhoneNumber As String = txtBusinessPhone.TextUnMasked

        If BusinessPhoneNumber.Length > 0 Then

            Dim PhoneID As Integer = PhoneHelper.InsertPhone(BusinessPhoneType, BusinessPhoneNumber.Substring(0, 3), _
                BusinessPhoneNumber.Substring(3), String.Empty, UserID)

            Dim PersonPhoneID As Integer = PersonHelper.InsertPersonPhone(PersonID, PhoneID, UserID)

        End If

        ClientHelper.UpdateClientPrimaryPersonID(ClientID, PersonID)

        'store co-applicants
        If txtApplicants.Value.Length > 0 Then

            Dim Applicants() As String = txtApplicants.Value.Split("$")

            For i As Integer = 0 To Applicants.Length - 1

                Dim Applicant As String = Applicants(i)

                Dim Fields() As String = Applicant.Split("|")

                Gender = Fields(2)

                'auto-complete gender for person if empty
                If Gender Is Nothing OrElse Gender.Length = 0 Then
                    Gender = NameHelper.GetGender(Fields(0))
                End If

                PersonID = PersonHelper.InsertPerson(ClientID, Fields(0), Fields(1), Gender, _
                    Integer.Parse(Fields(8)), Fields(9), Fields(3), Fields(4), Fields(5), _
                    Integer.Parse(Fields(6)), Fields(7), Fields(25), Boolean.Parse(Fields(26)), UserID)

                Dim PhoneType1 As Integer = Integer.Parse(Fields(10))
                Dim PhoneNumber1 As String = StringHelper.ApplyFilter(Fields(11), StringHelper.Filter.AphaNumericOnly)
                Dim PhoneExtension1 As String = Fields(12)

                Dim PhoneType2 As String = Integer.Parse(Fields(13))
                Dim PhoneNumber2 As String = StringHelper.ApplyFilter(Fields(14), StringHelper.Filter.AphaNumericOnly)
                Dim PhoneExtension2 As String = Fields(15)

                Dim PhoneType3 As String = Integer.Parse(Fields(16))
                Dim PhoneNumber3 As String = StringHelper.ApplyFilter(Fields(17), StringHelper.Filter.AphaNumericOnly)
                Dim PhoneExtension3 As String = Fields(18)

                Dim PhoneType4 As String = Integer.Parse(Fields(19))
                Dim PhoneNumber4 As String = StringHelper.ApplyFilter(Fields(20), StringHelper.Filter.AphaNumericOnly)
                Dim PhoneExtension4 As String = Fields(21)

                Dim PhoneType5 As String = Integer.Parse(Fields(22))
                Dim PhoneNumber5 As String = StringHelper.ApplyFilter(Fields(23), StringHelper.Filter.AphaNumericOnly)
                Dim PhoneExtension5 As String = Fields(24)

                If PhoneNumber1.Length > 0 Then

                    Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType1, PhoneNumber1.Substring(0, 3), _
                        PhoneNumber1.Substring(3), PhoneExtension1, UserID)

                    Dim PersonPhoneID As Integer = PersonHelper.InsertPersonPhone(PersonID, PhoneID, UserID)

                End If

                If PhoneNumber2.Length > 0 Then

                    Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType2, PhoneNumber2.Substring(0, 3), _
                        PhoneNumber2.Substring(3), PhoneExtension2, UserID)

                    Dim PersonPhoneID As Integer = PersonHelper.InsertPersonPhone(PersonID, PhoneID, UserID)

                End If

                If PhoneNumber3.Length > 0 Then

                    Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType3, PhoneNumber3.Substring(0, 3), _
                        PhoneNumber3.Substring(3), PhoneExtension3, UserID)

                    Dim PersonPhoneID As Integer = PersonHelper.InsertPersonPhone(PersonID, PhoneID, UserID)

                End If

                If PhoneNumber4.Length > 0 Then

                    Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType4, PhoneNumber4.Substring(0, 3), _
                        PhoneNumber4.Substring(3), PhoneExtension4, UserID)

                    Dim PersonPhoneID As Integer = PersonHelper.InsertPersonPhone(PersonID, PhoneID, UserID)

                End If

                If PhoneNumber5.Length > 0 Then

                    Dim PhoneID As Integer = PhoneHelper.InsertPhone(PhoneType5, PhoneNumber5.Substring(0, 3), _
                        PhoneNumber5.Substring(3), PhoneExtension5, UserID)

                    Dim PersonPhoneID As Integer = PersonHelper.InsertPersonPhone(PersonID, PhoneID, UserID)

                End If

            Next 'person

        End If

        'store initial enrollment roadmap
        Dim RoadmapID As Integer = RoadmapHelper.InsertRoadmap(ClientID, 2, Nothing, UserID)

        'store notes against client and initial enrollment roadmap
        InsertNotes(ClientID, RoadmapID)

        Return ClientID

    End Function
    Private Sub GoToClientRecord(ByVal ClientID As Integer)
        Response.Redirect("~/clients/client/?id=" & ClientID)
    End Sub

End Class