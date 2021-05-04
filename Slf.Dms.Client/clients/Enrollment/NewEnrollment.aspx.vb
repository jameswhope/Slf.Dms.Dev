Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports AssistedSolutions.WebControls.CityStateFinder
Imports System.Net
Imports System.Data
Imports System.Security.Cryptography.X509Certificates
Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers
Imports LexxiomLetterTemplates
Imports Infragistics.WebUI.UltraWebGrid
Imports System.Collections.Generic
Imports LeadRoadmapHelper
Partial Class Clients_Enrollment_NewEnrollment
    Inherits System.Web.UI.Page

#Region "Variables"

    Public UserID As Integer
    Public UserTypeID As Integer
    Public UserGroupID As Integer
    Public a As Boolean = True
    Public aID As Integer = 0
    Public Loading As Boolean
    Public FromWhere As String = String.Empty
    Public ExportDtl As Int16 = 0
#End Region

    Public EnrollmentMinDeposit As Double
    Public EnrollmentMinPct As Double
    Public EnrollmentMaxPct As Double
    Public EnrollmentCurrentPct As Double
    Public EnrollmentInflation As Double
    Public EnrollmentPBMAPR As Double
    Public EnrollmentPBMMinimum As Double
    Public EnrollmentPBMPercentage As Double
    Public EndPageRedirect As Boolean = True
    Public CurrentStatus As Integer = -1
    Public CurrentAssignment As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserId=" & UserID))

        aID = Request.QueryString("id")
        FromWhere = Request.QueryString("pg")
        ExportDtl = Request.QueryString("fxid")

        If aID > 0 Then 'This is an update or this is an insert if there is no Applicant ID jhope 04/19
            a = False
        Else
            a = True
        End If

        SetProperties()

        If Not IsPostBack Then
            LoadCallVars()

            'Insert call info if present
            Me.InsertCallInfo(aID)

            Loading = True
            LoadData()
            assignTXT(UserID, aID)
            SetAttributes()
            bShowGridLinks(aID)

            divMsg.Style("display") = "none"
            divMsg.InnerText = ""

            LoadPlanOptions()

            If Request.QueryString("a") = "saved" Then
                lblLastSave.Text = "Applicant saved " & Now.ToString
            End If
        End If

        If IsPostBack Then
            Loading = False

            If ddlLeadSource.SelectedItem.Text = "Paper Lead" Or Me.ddlLeadSource.SelectedItem.Text = "Radio" Or Me.ddlLeadSource.SelectedItem.Text = "TV" Then
                trPaperLeadCode.Style("display") = ""
            End If
        End If

        BindGrids()

        ddlStatus.Attributes.Add("onChange", "GetStatusValue();") 'jhope 4/19
        'ddlAssignTo.Attributes.Add("onChange", "GetAssignedToValue();") 'jhope 9/29/2009

        CurrentAssignment = DataHelper.FieldTop1("tblLeadAudit", "NewValue", "LeadApplicantID = " & aID & " AND ModificationType = 'Assign new Rep'", "ModificationDate DESC")

        Dim sb As New StringBuilder
        sb.Append("<script type=""text/javascript"">Recalc(1);</script>")
        Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "Recalc", sb.ToString)
    End Sub

    Private Sub LoadCallVars()
        If Not Request.QueryString("dnis") Is Nothing Then hdnDnis.Value = Request.QueryString("dnis")
        If Not Request.QueryString("ani") Is Nothing Then hdnAni.Value = Request.QueryString("ani")
        If Not Request.QueryString("callidkey") Is Nothing Then hdnCallId.Value = Request.QueryString("callidkey")
        CheckForLeadTransfered()
    End Sub

    Private Sub CheckForLeadTransfered()
        'Get the lead id associated with the call
        Dim callId As String = hdnCallId.Value.Trim
        Dim LeadId As Nullable(Of Integer) = 0
        If callId.Length > 0 Then
            Dim sb As New System.Text.StringBuilder
            sb.AppendFormat("Select LeadApplicantId From tblLeadCall Where CallIdKey = '{0}'", callId)
            Dim cmd As SqlCommand = New SqlCommand(sb.ToString, ConnectionFactory.Create())
            Try
                cmd.Connection.Open()
                Dim objid As Object = cmd.ExecuteScalar()
                If Not objid Is Nothing AndAlso Not objid Is DBNull.Value Then Int32.TryParse(objid, LeadId)
            Finally
                If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
            End Try

            If Not LeadId.HasValue OrElse LeadId.Value = 0 Then
                'Check for repeat callers
                Dim phone As String = hdnAni.Value.Trim
                If phone.Length > 0 Then
                    sb = New System.Text.StringBuilder
                    sb.AppendFormat("Select Top 1 LeadApplicantId From tblLeadApplicant Where Replace(Replace(Replace(Replace(leadphone,' ',''),'-',''),'(', ''),')','') = '{0}' order by statusid desc", phone)
                    cmd = New SqlCommand(sb.ToString, ConnectionFactory.Create())
                    Try
                        cmd.Connection.Open()
                        Dim objid As Object = cmd.ExecuteScalar()
                        If Not objid Is Nothing AndAlso Not objid Is DBNull.Value Then Int32.TryParse(objid, LeadId)
                    Finally
                        If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
                    End Try
                End If
            End If

            If LeadId.HasValue AndAlso LeadId.Value > 0 Then
                Me.Response.Redirect(String.Format("{0}?id={1}&p1={2}&p2={3}&s={4}", GetDefaultPage(LeadId.Value), LeadId.Value, Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s"))))
            End If
        End If
    End Sub

    Public Function GetLeadId() As Integer
        Return aID
    End Function

    Private Function GetDefaultPage(ByVal LeadId As String) As String
        Dim defaultpage As String = DataHelper.FieldLookup("tblLeadApplicant", "EnrollmentPage", "LeadApplicantId=" & LeadId)

        If Not defaultpage Is Nothing AndAlso defaultpage.Trim.Length > 0 Then
            Return defaultpage
        Else
            Return "prompt.aspx"
        End If

    End Function

    Private Sub SetAttributes()
        txtTotalDebt.Attributes("onkeyup") = "javascript:Recalc(1);"
        txtDepositComitmment.Attributes("onkeyup") = "javascript:Recalc();"
        txtDownPmt.Attributes("onkeyup") = "javascript:Recalc(1);"
        ddlSettlementPct.Attributes("onchange") = "javascript:Recalc(1);"
        ddlMaintenanceFee.Attributes("onchange") = "javascript:Recalc(1);"
        ddlSubMaintenanceFee.Attributes("onchange") = "javascript:Recalc(1);"
        ddlSettlementFee.Attributes("onchange") = "javascript:Recalc(1);"
    End Sub

    Private Sub SetProperties()
        EnrollmentMinDeposit = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDepositMinimum"))
        EnrollmentMinPct = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDepositPercentage"))
        EnrollmentMaxPct = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDepositPercentageMax"))
        EnrollmentCurrentPct = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentDepositCurrentPct"))

        EnrollmentInflation = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentInflation"))
        EnrollmentPBMAPR = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMAPR"))
        EnrollmentPBMMinimum = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMMinimum"))
        EnrollmentPBMPercentage = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMPercentage"))


    End Sub

    Private Sub LoadData()
        bindDDL(ddlBehind, "SELECT BehindID, description FROM tblLeadBehind", "description", "BehindID")
        bindDDL(ddlConcerns, "select concernsid, [description]  from tblLeadConcerns", "description", "concernsid")
        bindDDL(ddlDelivery, "select deliveryid, description from tblLeadDelivery", "description", "deliveryid")
        bindDDL(ddlStatus, "select statusid, description  from tblLeadStatus", "description", "statusid")
        bindDDL(ddlLanguage, "select LanguageID, [name] from tblLanguage", "name", "LanguageID")
        bindDDL(ddlTimeZone, "SELECT TimeZoneID, Name FROM tblTimeZone Order By Name Asc", "Name", "TimeZoneId")
        bindDDL(cboStateID, "select stateid, abbreviation from tblstate", "abbreviation", "stateid")
        bindDDL(ddlLeadSource, "Select LeadSourceID, Name from tblleadsources", "Name", "LeadSourceID")
        bindDDL(ddlAssignTo, "Select UserID, FirstName + ' ' + LastName[Name] from tbluser Where UserGroupId IN (1, 24, 25, 26) Order by [Name]", "Name", "UserID")
        bindDDL(ddlCompany, "select Companyid, name from tblcompany", "name", "Companyid")
        bindDDL(ddlSettlementPct, "SELECT SettlementPctID, SettlementPct FROM tblLeadSettlementPct", "SettlementPct", "SettlementPctID", False)
        bindDDL(ddlMaintenanceFee, "SELECT MaintenanceFeeID, MaintenanceFee FROM tblLeadMaintenanceFee ORDER BY MaintenanceFee", "MaintenanceFee", "MaintenanceFeeID", False)
        bindDDL(ddlSubMaintenanceFee, "SELECT SubMaintenanceFeeID, Amount FROM tblLeadSubMaintenanceFee", "Amount", "SubMaintenanceFeeID", False)
        bindDDL(ddlSettlementFee, "SELECT SettlementFeeID, SettlementFee FROM tblLeadSettlementFee", "SettlementFee", "SettlementFeeID", False)
        Dim x As Integer = 0
        For x = 1 To 31
            ddlDepositDay.Items.Add(x.ToString)
        Next x

        ddlMaintenanceFee.SelectedValue = 1
        ddlSubMaintenanceFee.SelectedValue = 1

    End Sub

    Private Sub bindDDL(ByVal ddlToBind As DropDownList, ByVal sqlSelect As String, ByVal TextField As String, ByVal ValueField As String, Optional ByVal blnAddEmptyRow As Boolean = True)

        Try
            If blnAddEmptyRow Then
                Dim blankItem As New ListItem(String.Empty, 0)
                blankItem.Selected = False
                ddlToBind.Items.Add(blankItem)
            End If

            ddlToBind.AppendDataBoundItems = True

            Dim cmd As New SqlCommand(sqlSelect, ConnectionFactory.Create())
            Dim rdr As SqlDataReader = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            ddlToBind.DataTextField = TextField
            ddlToBind.DataValueField = ValueField
            ddlToBind.DataSource = rdr
            ddlToBind.DataBind()
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Private Sub assignTXT(ByVal UserID As Integer, Optional ByVal LeadApplicantID As Integer = 0)
        'Setup the call
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim rdr, rdr2 As SqlDataReader

        If LeadApplicantID <> 0 Then
            strSQL = "SELECT *, convert(varchar(10), FirstAppointmentDate, 111) as FirstAppDate, convert(varchar(8), FirstAppointmentDate, 108) as FirstAppTime  FROM tblLeadApplicant WHERE LeadApplicantID =" & LeadApplicantID
            'Load the datareaders if we have an existing client
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignTheApplicantData(rdr)
            rdr.Close()
            cmd.Dispose()
            strSQL = "SELECT * FROM tblLeadCalculator WHERE LeadApplicantID = " & LeadApplicantID
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            rdr = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            AssignTheApplicantCalculatorData(rdr)
        Else 'we're inserting a new client blank all the fields and clear all the grids and their rows
            ClearAllEntryData()
        End If

        If (Me.txtPhone.Text.Trim = "" OrElse Me.txtPhone.Text.Trim = "(   )    -") AndAlso hdnAni.Value.Trim.Length > 0 Then
            Me.txtPhone.RawText = hdnAni.Value.Trim
        End If


    End Sub

    Private Sub ClearAllEntryData()

        '1.Setup
        Me.txtName.Text = ""
        Me.txtPhone.Text = ""
        Me.txtZip.Text = ""
        Me.txtPaperLeadCode.Text = ""
        Me.FirstAppDate.Value = ""
        Me.FirstAppTime.Value = ""
        Me.FirstAppLeadTime.Value = ""

        'Notes grid
        wGrdNotes.DataSource = Nothing

        '2. Calculator
        Me.txtTotalDebt.Text = "0.00"
        Me.txtDownPmt.Text = "0.00"
        Me.txtDepositComitmment.Text = ""
        Me.lblSettlementFee.Text = ""
        Me.lblSettlementPct2.Text = ""
        Me.lblSubMaintenanceFee.Text = ""
        Me.lblMaintenanceFeeTotal.Text = ""

        'Banking grid

        'Creditors grid


        '3. Primary
        txtFirstName.Text = ""
        txtLastName.Text = ""
        txtAddress.Text = ""
        txtCity.Text = ""
        txtZip.Text = ""
        txtHomePhone.Text = ""
        txtBusPhone.Text = ""
        txtCellPhone.Text = ""
        txtFaxNo.Text = ""
        txtSSN.Text = ""
        txtDOB.Text = ""
        txtEmailAddress.Text = ""

        'Co-App grid
        Me.wGrdCoApp.DataSource = Nothing

    End Sub

    Private Sub AssignTheApplicantData(ByVal rdr As SqlDataReader)
        While rdr.Read
            Try
                lblPerson.Text = StrConv(rdr.Item("FullName").ToString, VbStrConv.ProperCase)

                '1. Setup
                Me.txtName.Text = StrConv(rdr.Item("LeadName").ToString, VbStrConv.ProperCase)
                Me.txtPhone.Text = rdr.Item("LeadPhone").ToString
                Me.txtSZip.Text = rdr.Item("LeadZip").ToString
                Me.ddlBehind.Items.FindByValue(rdr.Item("BehindID")).Selected = True
                Me.ddlConcerns.Items.FindByValue(rdr.Item("ConcernsID")).Selected = True
                Me.ddlLeadSource.Items.FindByValue(rdr.Item("LeadSourceID")).Selected = True
                Me.ddlCompany.Items.FindByValue(rdr.Item("CompanyID")).Selected = True
                Me.ddlLanguage.Items.FindByValue(rdr.Item("LanguageID")).Selected = True
                Me.ddlDelivery.Items.FindByValue(rdr.Item("DeliveryID")).Selected = True
                Me.ddlAssignTo.Items.FindByValue(rdr.Item("RepID")).Selected = True
                Me.ddlStatus.Items.FindByValue(rdr.Item("StatusID")).Selected = True
                If Not rdr.Item("TimeZoneId") Is DBNull.Value Then
                    Me.ddlTimeZone.Items.FindByValue(rdr.Item("TimeZoneId")).Selected = True
                End If
                If Not rdr.Item("FirstAppDate") Is DBNull.Value Then
                    Me.FirstAppDate.Value = rdr.Item("FirstAppDate")
                End If
                If Not rdr.Item("FirstAppTime") Is DBNull.Value Then
                    Me.FirstAppTime.Value = rdr.Item("FirstAppTime")
                    Me.CalculateTime(False)
                End If

                Me.txtPaperLeadCode.Text = rdr.Item("PaperLeadCode").ToString

                If Me.ddlLeadSource.SelectedItem.Text = "Paper Lead" Or Me.ddlLeadSource.SelectedItem.Text = "Radio" Or Me.ddlLeadSource.SelectedItem.Text = "TV" Then
                    trPaperLeadCode.Style("display") = ""
                End If

                '2.25.09 - jhernandez
                'Users need to be able to re-assign bankruptcy cases 
                'If ddlAssignTo.SelectedIndex > 0 Then 'In pipeline?
                '    'Only managers can re-assign
                '    ddlAssignTo.Enabled = Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID)
                'End If

                '3. Primary
                txtFirstName.Text = StrConv(rdr.Item("FirstName").ToString, VbStrConv.ProperCase)
                txtLastName.Text = StrConv(rdr.Item("LastName").ToString, VbStrConv.ProperCase)
                txtAddress.Text = rdr.Item("Address1").ToString
                txtCity.Text = StrConv(rdr.Item("City").ToString, VbStrConv.ProperCase)
                cboStateID.Items.FindByValue(rdr.Item("StateID")).Selected = True
                txtZip.Text = rdr.Item("ZipCode").ToString
                txtHomePhone.Text = rdr.Item("HomePhone").ToString
                txtBusPhone.Text = rdr.Item("BusinessPhone").ToString
                txtCellPhone.Text = rdr.Item("CellPhone").ToString
                txtFaxNo.Text = rdr.Item("FaxNumber").ToString
                txtSSN.Text = rdr.Item("SSN").ToString
                txtDOB.Text = rdr.Item("DOB").ToString
                txtEmailAddress.Text = rdr.Item("Email").ToString

                Dim b As Infragistics.WebUI.UltraWebToolbar.TBarButton = CType(Me.uwToolBar.Items.FromKey("switch"), Infragistics.WebUI.UltraWebToolbar.TBarButton)
                b.Visible = (CDate(rdr.Item("Created")) < New Date(2009, 9, 30, 18, 32, 0) AndAlso rdr.Item("LeadTransferOutDate") Is DBNull.Value)
            Catch ex As Exception
                Continue While
            End Try
        End While
    End Sub

    Private Sub AssignTheApplicantCalculatorData(ByVal rdr As SqlDataReader)
        Dim li As ListItem

        While rdr.Read
            Try
                '2. Calculator
                txtTotalDebt.Text = Format(rdr.Item("TotalDebt"), "#####0.00")

                li = ddlSettlementPct.Items.FindByText(rdr.Item("SettlementPct").ToString)
                If Not IsNothing(li) Then
                    ddlSettlementPct.ClearSelection()
                    li.Selected = True
                Else
                    Me.AddandAssignListItem(ddlSettlementPct, rdr.Item("SettlementPct").ToString)
                End If

                li = ddlMaintenanceFee.Items.FindByText(Format(rdr.Item("MaintenanceFee"), "####0.00"))
                If Not IsNothing(li) Then
                    ddlMaintenanceFee.ClearSelection()
                    li.Selected = True
                Else
                    Me.AddandAssignListItem(ddlMaintenanceFee, Format(rdr.Item("MaintenanceFee"), "####0.00"))
                End If

                li = ddlSubMaintenanceFee.Items.FindByText(Format(rdr.Item("SubMaintenanceFee"), "####0.00"))
                ddlSubMaintenanceFee.ClearSelection()
                If Not IsNothing(li) Then
                    li.Selected = True
                Else
                    Me.AddandAssignListItem(ddlSubMaintenanceFee, Format(rdr.Item("SubMaintenanceFee"), "####0.00"))
                End If

                li = ddlSettlementFee.Items.FindByText(rdr.Item("SettlementFeePct"))
                If Not IsNothing(li) Then
                    ddlSettlementFee.ClearSelection()
                    li.Selected = True
                Else
                    Me.AddandAssignListItem(ddlSettlementFee, rdr.Item("SettlementFeePct"))
                End If

                txtDownPmt.Text = Format(rdr.Item("InitialDeposit"), "#####0.00")
                txtDepositComitmment.Text = Format(rdr.Item("DepositCommittment"), "#####0.00")
                If Not rdr.Item("DateOfFirstDeposit") Is DBNull.Value Then
                    wFirstDepositDate.Value = rdr.Item("DateOfFirstDeposit")
                End If

                li = ddlDepositDay.Items.FindByText(rdr.Item("ReOccurringDepositDay").ToString)
                If Not IsNothing(li) Then
                    ddlDepositDay.ClearSelection()
                    li.Selected = True
                End If

                Recalc()
            Catch ex As Exception
                Throw New Exception(ex.Message)
            End Try
        End While

    End Sub

    Private Sub AddandAssignListItem(ByVal ddl As DropDownList, ByVal Value As String)
        Dim l As New ListItem(Value, Value)
        ddl.Items.Add(l)
        ddl.ClearSelection()
        l.Selected = True
    End Sub

    Protected Sub txtSZip_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtSZip.TextChanged
        Try
            ServicePointManager.ServerCertificateValidationCallback = New Security.RemoteCertificateValidationCallback(AddressOf customCertificateValidation)

            Dim loc() As CityStateLocations = AssistedSolutions.WebControls.CityStateFinder.CityStateFinder.SearchOn(txtSZip.Text, True)
            Dim li As ListItem
            Dim CompanyID As String

            If loc.Length > 0 Then
                cboStateID.ClearSelection()
                li = cboStateID.Items.FindByText(loc(0).StateAbbreviation)
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
                txtCity.Text = loc(0).City

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection
                        cmd.CommandText = "select companyid from tbllsa_variablestatedata where clientstate = '" & loc(0).StateName & "'"
                        cmd.Connection.Open()
                        CompanyID = CStr(cmd.ExecuteScalar())
                        ddlCompany.ClearSelection()
                        li = ddlCompany.Items.FindByValue(CompanyID)
                        If Not IsNothing(li) Then
                            li.Selected = True
                            ddlCompany.Enabled = False
                        End If
                    End Using
                End Using
            End If

            'Populate client name in step 3 only if a name does not already exist there
            If txtFirstName.Text.Trim = "" AndAlso txtLastName.Text.Trim = "" Then
                Dim name() As String = Split(txtName.Text, " ")
                txtFirstName.Text = name(0)
                If name.Length > 0 Then
                    txtLastName.Text = name(1)
                End If
            End If
        Catch ex As Exception
            ddlCompany.Enabled = True
        Finally
            'always populate even if web service is not working
            txtZip.Text = txtSZip.Text
        End Try
    End Sub

    Private Function customCertificateValidation(ByVal sender As Object, ByVal cert As X509Certificate, ByVal chain As X509Chain, ByVal sslPolicyErrors As Security.SslPolicyErrors) As Boolean
        Return True
    End Function

    Private Sub uwToolbar_ButtonClicked(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebToolbar.ButtonEvent) Handles uwToolBar.ButtonClicked
        If Loading = False Then
            Select Case e.Button.Text
                Case "Back"
                    If FromWhere = "fix" Then
                        Response.Redirect("ExportDetail.aspx?id=" & ExportDtl)
                    Else
                        Response.Redirect(String.Format("Default.aspx?p1={0}&p2={1}&s={2}", Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s"))))
                    End If
                Case "New Applicant"
                    Response.Redirect(String.Format("NewEnrollment.aspx?p1={0}&p2={1}&s={2}", Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s"))))
                Case "Save Applicant"
                    Loading = False
                    Save(a, aID)
                    Loading = False
                Case "Generate LSA"
                    generateLSA()
                Case "Print Form"
                    PrintInfoSheet()
                Case "Switch Model"
                    SDModelHelper.ConvertToModel("newenrollment2.aspx", aID, UserID)
                    Me.Response.Redirect(String.Format("newenrollment2.aspx?id={0}", aID))
                Case Else
            End Select
        End If
    End Sub

    Private Sub Save(ByVal a As Boolean, ByVal aID As Integer)

        Dim cmd As SqlCommand
        Dim strSQL As String
        Dim dblTotalDebt As Double = Val(txtTotalDebt.Text)
        Dim dblDownPayment As Double = Val(txtDownPmt.Text)
        Dim dblDepositCommitment As Double = Val(txtDepositComitmment.Text)
        Dim FullName As String = ""

        If Me.txtFirstName.Text.ToString <> "" Then
            FullName = StrConv(txtFirstName.Text, VbStrConv.ProperCase)
        End If
        If Me.txtLastName.Text.ToString <> "" Then
            FullName += " " & StrConv(txtLastName.Text, VbStrConv.ProperCase)
        End If

        If FullName = "" Then
            FullName = txtName.Text
        End If

        Dim dFirstAppointment As String = "Null"
        Dim tFirstAppTime As String = "12:00 AM"
        Dim TimeZone As String = "Null"
        If Me.FirstAppTime.Text.Trim.Length > 0 Then
            tFirstAppTime = Me.FirstAppTime.Text.Trim
        End If
        If Me.FirstAppDate.Text.Trim.Length > 0 Then
            dFirstAppointment = String.Format("'{0} {1}'", Me.FirstAppDate.Text.Trim, tFirstAppTime)
        End If
        If Me.ddlTimeZone.Text.Trim.Length > 0 Then
            TimeZone = ddlTimeZone.SelectedValue
        End If

        If Loading = False Then
            'Save the appliant demographic data
            Try
                If a Then
                    strSQL = "INSERT INTO tblLeadApplicant (FirstName, LastName, FullName, Address1, City, StateID, ZipCode, HomePhone, BusinessPhone, CellPhone, FaxNumber, Email, SSN, DOB, ConcernsID, BehindID, LeadSourceID, CompanyID, LanguageID, DeliveryID, RepID, StatusID, PaperLeadCode, Created, CreatedByID, LastModified, LastModifiedByID, LeadName, LeadPhone, LeadZip, FirstAppointmentDate, TimeZoneId) " _
                    & "VALUES ('" _
                    & StrConv(txtFirstName.Text, VbStrConv.ProperCase) & "', '" _
                    & StrConv(txtLastName.Text, VbStrConv.ProperCase) & "', '" _
                    & FullName & "', '" _
                    & Me.txtAddress.Text.ToString & "', '" _
                    & StrConv(txtCity.Text, VbStrConv.ProperCase) & "', " _
                    & Me.cboStateID.SelectedIndex & ", '" _
                    & Me.txtZip.Text.ToString & "', '" _
                    & FormatPhone(Me.txtHomePhone.Text.ToString) & "', '" _
                    & FormatPhone(Me.txtBusPhone.Text.ToString) & "', '" _
                    & FormatPhone(Me.txtCellPhone.Text.ToString) & "', '" _
                    & FormatPhone(Me.txtFaxNo.Text.ToString) & "', '" _
                    & Me.txtEmailAddress.Text.ToString & "', '" _
                    & Me.txtSSN.Text.ToString & "', '" _
                    & Me.txtDOB.Text.ToString & "', " _
                    & Me.ddlConcerns.SelectedValue & ", " _
                    & Me.ddlBehind.SelectedValue & ", " _
                    & Me.ddlLeadSource.SelectedValue & ", " _
                    & Me.ddlCompany.SelectedValue & ", " _
                    & Me.ddlLanguage.SelectedValue & ", " _
                    & Me.ddlDelivery.SelectedValue & ", " _
                    & Me.ddlAssignTo.SelectedValue & ", " _
                    & Me.ddlStatus.SelectedValue & ", '" _
                    & txtPaperLeadCode.Text.Trim & "', '" _
                    & Now & "', " _
                    & UserID & ", '" _
                    & Now & "', " _
                    & UserID & ", '" _
                    & txtName.Text & "', '" _
                    & txtPhone.Text & "', '" _
                    & txtSZip.Text & "', " _
                    & dFirstAppointment & ", " _
                    & TimeZone & ") " _
                    & "SELECT SCOPE_IDENTITY()" 'jhope 4/17 down V

                    cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                    cmd.Connection.Open()
                    aID = cmd.ExecuteScalar()
                    cmd.Connection.Close()

                    '7.22.09.ug.insert roadmap for each status change, initial applicant status
                    LeadRoadmapHelper.InsertRoadmap(aID, CInt(Me.ddlStatus.SelectedValue), 0, "Applicant Created.", UserID)
                    'Update tblLeadAudit for a beginning history jhope 9/28/2009
                    CurrentAssignment = DataHelper.FieldTop1("tblLeadAudit", "NewValue", "LeadApplicantID = " & aID & " AND ModificationType = 'Assign new Rep'", "ModificationDate DESC")
                    If CurrentAssignment = "" Then
                        CurrentAssignment = "0"
                    End If
                    If ddlAssignTo.SelectedValue <> CurrentAssignment Then
                        Dim OldAssignments(0) As LeadHelper.OldAssignments
                        OldAssignments(0).LeadApplicantID = aID
                        OldAssignments(0).OldValue = CurrentAssignment
                        OldAssignments(0).NewValue = ddlAssignTo.SelectedValue
                        OldAssignments(0).TableName = "tblLeadAppliant"
                        OldAssignments(0).FieldName = "RepID"
                        LeadHelper.LogAssignments(OldAssignments, UserID, CInt(Me.ddlAssignTo.SelectedValue))
                        hdnAssignedTo.Value = Me.ddlAssignTo.SelectedValue
                    End If
                    If ddlStatus.SelectedValue <> hdnClientStatus.Value Then 'jhope 9/28/2009
                        hdnClientStatus.Value = Me.ddlStatus.SelectedValue
                    End If

                End If 'jhope 4/17

                If Not a Then 'jhope 4/17
                    strSQL = "UPDATE tblLeadApplicant SET " _
                    & "FirstName = '" & StrConv(txtFirstName.Text, VbStrConv.ProperCase) & "', " _
                    & "LastName = '" & StrConv(txtLastName.Text, VbStrConv.ProperCase) & "', " _
                    & "FullName = '" & FullName & "', " _
                    & "Address1 = '" & Me.txtAddress.Text.ToString & "', " _
                    & "City = '" & StrConv(txtCity.Text, VbStrConv.ProperCase) & "', " _
                    & "StateID = " & cboStateID.SelectedIndex & ", " _
                    & "ZipCode = '" & Me.txtZip.Text.ToString & "', " _
                    & "HomePhone = '" & FormatPhone(Me.txtHomePhone.Text.ToString) & "', " _
                    & "BusinessPhone = '" & FormatPhone(Me.txtBusPhone.Text.ToString) & "', " _
                    & "CellPhone = '" & FormatPhone(Me.txtCellPhone.Text.ToString) & "', " _
                    & "FaxNumber = '" & FormatPhone(Me.txtFaxNo.Text.ToString) & "', " _
                    & "Email = '" & Me.txtEmailAddress.Text & "', " _
                    & "SSN = '" & Me.txtSSN.Text & "', " _
                    & "DOB = '" & Me.txtDOB.Text & "', " _
                    & "ConcernsID = " & Me.ddlConcerns.SelectedValue & ", " _
                    & "BehindID = " & Me.ddlBehind.SelectedValue & ", " _
                    & "LeadSourceID = " & Me.ddlLeadSource.SelectedValue & ", " _
                    & "CompanyID = " & Me.ddlCompany.SelectedValue & ", " _
                    & "LanguageID = " & Me.ddlLanguage.SelectedValue & ", " _
                    & "DeliveryID = " & Me.ddlDelivery.SelectedValue & ", " _
                    & "RepID = " & CInt(Me.ddlAssignTo.SelectedValue) & ", " _
                    & "StatusID = " & CInt(Me.ddlStatus.SelectedValue) & ", " _
                    & "PaperLeadCode = '" & txtPaperLeadCode.Text.Trim & "', " _
                    & "LastModified = '" & Now & "', " _
                    & "LastModifiedByID = " & UserID & ", " _
                    & "LeadName = '" & txtName.Text & "', " _
                    & "LeadPhone = '" & txtPhone.Text & "', " _
                    & "LeadZip = '" & txtSZip.Text & "', " _
                    & "FirstAppointmentDate = " & dFirstAppointment & ", " _
                    & "TimeZoneId = " & TimeZone _
                    & "WHERE LeadApplicantID = " & aID

                    cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery() 'jhope 04/17
                    cmd.Connection.Close()

                    '7.22.09.ug.insert roadmap for each status change, applicant status change
                    Dim parentID As Integer = LeadRoadmapHelper.GetRoadmapID(aID)
                    '9/28/2009 jhope made it conditional so it will only write if the status is 0 or it has changed.
                    CurrentStatus = CStr(Val(DataHelper.FieldTop1("tblLeadRoadmap", "LeadStatusID", "LeadApplicantID = " & aID, "Created DESC")))
                    If Me.ddlStatus.SelectedValue <> CurrentStatus Then
                        If CInt(Me.ddlStatus.SelectedValue) <> parentID Then
                            LeadRoadmapHelper.InsertRoadmap(aID, CInt(Me.ddlStatus.SelectedValue), parentID, "Applicant Status Changed.", UserID)
                        End If
                    End If
                    'Update tblLeadAudit for a history jhope 9/28/2009
                    CurrentAssignment = DataHelper.FieldTop1("tblLeadAudit", "NewValue", "LeadApplicantID = " & aID & " AND ModificationType = 'Assign new Rep'", "ModificationDate DESC")
                    If CurrentAssignment = "" Then
                        CurrentAssignment = "0"
                    End If
                    If Me.ddlAssignTo.SelectedValue <> CurrentAssignment Then
                        Dim OldAssignments(0) As LeadHelper.OldAssignments
                        OldAssignments(0).LeadApplicantID = aID
                        OldAssignments(0).OldValue = CurrentAssignment
                        OldAssignments(0).NewValue = ddlAssignTo.SelectedValue
                        OldAssignments(0).TableName = "tblLeadAppliant"
                        OldAssignments(0).FieldName = "RepID"
                        LeadHelper.LogAssignments(OldAssignments, UserID, CInt(Me.ddlAssignTo.SelectedValue))
                    End If
                    'hdnClientStatus.Value = Me.ddlStatus.SelectedValue
                    'hdnAssignedTo.Value = Me.ddlAssignTo.SelectedValue
                End If

                UpdateCallInfo(aID)

                If txtQuickNote.Text <> "" Then
                    InsertNote(txtQuickNote.Text, aID, UserID)
                End If

            Catch ex As Exception 'jhope 4/17
                Alert.Show("There has been an error saving this Applicant. " & ex.Message & ". Please contact your system administrator.")
            End Try
        End If

        'Save the Calculator data for the applicant
        'The Retainer fee is the SubMaintenanceFee stuff
        Try
            If a Then
                strSQL = "INSERT INTO tblLeadCalculator (LeadApplicantID, TotalDebt, SettlementPct, SubMaintenanceFee, MaintenanceFee,  SettlementFeePct, InitialDeposit, DepositCommittment, DateOfFirstDeposit, ReOccurringDepositDay) "
                strSQL += "VALUES ("
                strSQL += aID & ", "
                strSQL += dblTotalDebt & ", "
                strSQL += CDbl(ddlSettlementPct.SelectedItem.Text) & ", "
                strSQL += Val(Me.ddlSubMaintenanceFee.SelectedItem.Text) & ", "
                strSQL += CInt(ddlMaintenanceFee.SelectedItem.Text) & ", "
                strSQL += CInt(Me.ddlSettlementFee.SelectedItem.Text) & ", "
                strSQL += dblDownPayment & ", "
                strSQL += dblDepositCommitment & ", '"
                strSQL += Me.wFirstDepositDate.Text.ToString & "', "
                strSQL += CInt(Me.ddlDepositDay.SelectedItem.Text) & ")"
            Else
                strSQL = "SELECT LeadApplicantID FROM tblLeadCalculator WHERE LeadApplicantID = " & aID 'jhope 4/17 added test and insert if test fails
                cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
                cmd.Connection.Open()
                Dim GotIt As Integer = cmd.ExecuteScalar
                cmd.Connection.Close()
                If GotIt > 0 Then
                    strSQL = "UPDATE tblLeadCalculator SET "
                    strSQL += "TotalDebt =	" & dblTotalDebt & ", "
                    strSQL += "SettlementPct = " & CDbl(ddlSettlementPct.SelectedItem.Text) & ", "
                    strSQL += "SubMaintenanceFee = " & Val(ddlSubMaintenanceFee.SelectedItem.Text) & ", "
                    strSQL += "MaintenanceFee = " & CDbl(ddlMaintenanceFee.SelectedItem.Text) & ", "
                    strSQL += "SettlementFeePct = " & CDbl(ddlSettlementFee.SelectedItem.Text) & ", "
                    strSQL += "InitialDeposit = " & dblDownPayment & ", "
                    strSQL += "DepositCommittment = " & dblDepositCommitment & ", "
                    strSQL += "DateOfFirstDeposit = '" & wFirstDepositDate.Text.ToString & "', "
                    strSQL += "ReOccurringDepositDay = " & CInt(ddlDepositDay.SelectedItem.Text)
                    strSQL += " where LeadApplicantID = " & aID
                Else
                    strSQL = "INSERT INTO tblLeadCalculator (LeadApplicantID, TotalDebt, SettlementPct, SubMaintenanceFee, MaintenanceFee,  SettlementFeePct, InitialDeposit, DepositCommittment, DateOfFirstDeposit, ReOccurringDepositDay) " 'jhope 04/17
                    strSQL += "VALUES ("
                    strSQL += aID & ", "
                    strSQL += dblTotalDebt & ", "
                    strSQL += CDbl(ddlSettlementPct.SelectedItem.Text) & ", "
                    strSQL += Val(Me.ddlSubMaintenanceFee.SelectedItem.Text) & ", "
                    strSQL += CInt(ddlMaintenanceFee.SelectedItem.Text) & ", "
                    strSQL += CInt(Me.ddlSettlementFee.SelectedItem.Text) & ", "
                    strSQL += dblDownPayment & ", "
                    strSQL += dblDepositCommitment & ", '"
                    strSQL += Me.wFirstDepositDate.Text.ToString & "', "
                    strSQL += CInt(Me.ddlDepositDay.SelectedItem.Text) & ")"
                End If
            End If

            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()

            bShowGridLinks(aID)

        Catch ex As Exception 'jhope 04/17
            Alert.Show("There has been an error saving this applicants Calculator data. " & ex.Message & ". Please contact your system administrator.")
        End Try

        SaveCreditorAccountInfo()

        Dim urlredirect As String

        If hdnCallIdKey.Value = "" Then
            urlredirect = String.Format("newenrollment.aspx?id={0}&a=saved&p1={1}&p2={2}&s={3}", aID, Request.QueryString("p1"), Request.QueryString("p2"), HttpUtility.UrlEncode(Request.QueryString("s")))
            If Not FromWhere Is Nothing AndAlso FromWhere.Trim.Length > 0 Then urlredirect = String.Format("{0}&pg={1}&fxid={2}", urlredirect, FromWhere, ExportDtl)
        Else
            urlredirect = String.Format("newenrollment.aspx?callidkey={0}&ani={1}", hdnCallIdKey.Value, hdnAni.Value)
        End If

        Response.Redirect(urlredirect, EndPageRedirect)
    End Sub

    Private Sub InsertCallInfo(ByVal LeadId As Integer)
        Dim callId As String = hdnCallId.Value.Trim
        If callId.Length > 0 Then
            Dim sb As New System.Text.StringBuilder
            sb.AppendFormat("if Not Exists(Select CallIdKey From tblLeadCall Where CallIdKey = '{0}')", callId)
            sb.Append(" Insert Into tblLeadCall(LeadApplicantId, CallIdKey, Dnis, Ani, Created, CreatedBy, LastModified, LastModifiedBy) ")
            sb.AppendFormat(" values ({0}, '{1}', '{2}', '{3}', Getdate(), {4}, Getdate(), {4})", IIf(LeadId = 0, "null", LeadId), callId, hdnDnis.Value.Trim, hdnAni.Value.Trim, UserID)
            Dim cmd As SqlCommand = New SqlCommand(sb.ToString, ConnectionFactory.Create())
            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                'Reset Vars
                'hdnCallId.Value = ""
                'hdnDnis.Value = ""
                'hdnAni.Value = ""
            Finally
                If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
            End Try
        End If
    End Sub

    Private Sub UpdateCallInfo(ByVal LeadId As Integer)
        Dim callId As String = hdnCallId.Value.Trim
        Dim dnis As String

        If callId.Length > 0 AndAlso LeadId > 0 Then
            Dim sb As New System.Text.StringBuilder
            dnis = CallControlsHelper.GetDnis(callId)
            sb.Append("Update tblLeadCall Set ")
            sb.AppendFormat(" LeadApplicantId = {0} ", LeadId)
            sb.AppendFormat(", Dnis = '{0}' ", dnis)
            sb.Append(", LastModified = GetDate() ")
            sb.AppendFormat(", LastModifiedBy = {0} ", UserID)
            sb.AppendFormat(" Where CallIdKey = '{0}' ", callId)
            Dim cmd As SqlCommand = New SqlCommand(sb.ToString, ConnectionFactory.Create())
            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                hdnCallId.Value = ""
            Finally
                If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()
            End Try
        End If
    End Sub

    Protected Sub Page_PreLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreLoad
        Loading = True
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Loading = True

    End Sub

    Private Sub LoadPlanOptions()
        Dim Values() As String = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'EnrollmentPercentages'").Split("|")

        Dim r As New HtmlTableRow()
        Dim c As New HtmlTableCell()

        c.InnerHtml = "&nbsp;"
        c.Style("width") = "140"

        r.Cells.Add(c)

        For Each Value As String In Values

            c = New HtmlTableCell()

            c.Align = "center"
            c.Style("width") = "70"
            c.Style("font-weight") = "bold"
            c.Style("background-color") = "#f1f1f1"

            c.InnerHtml = "<input type=""hidden"" value=""" & Value & """ /><h2>" & Double.Parse(Value).ToString("#,##0.##%") & "</h2>"

            r.Cells.Add(c)

        Next

        c = New HtmlTableCell()

        c.InnerHtml = "&nbsp;"

        r.Cells.Add(c)

        tblPlanOptions.Rows.Add(r)

        Dim Points As New List(Of String)

        Points.Add("Estimated Total Paid:")
        Points.Add("Estimated Retainer fee:")
        Points.Add("Estimated maintenance fee:")
        Points.Add("Estimated settlement fee:")
        Points.Add("Estimated settlement cost:")
        Points.Add("Estimated debt free in:")
        Points.Add("Estimated savings:")

        For i As Integer = 0 To Points.Count - 1

            r = New HtmlTableRow()
            c = New HtmlTableCell()

            c.NoWrap = True
            c.InnerHtml = "<h3>" & StrConv(Points(i), VbStrConv.ProperCase) & "</h3>"
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

#Region "grids"
    Private Sub bShowGridLinks(ByVal applicantID As Integer)
        Select Case applicantID
            Case 0
                lnkAddNotes.Visible = False
                lnkAddBanks.Visible = False
                lnkAddCreditors.Visible = False
                lnkAddCoApps.Visible = False
            Case Else
                lnkAddNotes.Visible = True
                lnkAddBanks.Visible = True
                lnkAddCreditors.Visible = True
                lnkAddCoApps.Visible = True
        End Select
    End Sub

    Private Sub ShowGrid(ByVal sqlDS_ToUse As SqlDataSource, ByVal gridToShow As Infragistics.WebUI.UltraWebGrid.UltraWebGrid)
        Try

            Dim dv As DataView
            Dim recordCount As Integer

            dv = CType(sqlDS_ToUse.Select(DataSourceSelectArguments.Empty), DataView)
            recordCount = dv.Table.Rows.Count
            If recordCount = 0 Then
                gridToShow.Visible = False
            Else
                gridToShow.Visible = True
            End If
        Catch ex As Exception
            gridToShow.Visible = False
        End Try

    End Sub

    Private Sub BindGrids()

        dsNotes.SelectParameters("applicantID").DefaultValue = aID
        dsNotes.DataBind()
        ShowGrid(dsNotes, wGrdNotes)

        dsBanks.SelectParameters("applicantID").DefaultValue = aID
        dsBanks.DataBind()
        ShowGrid(dsBanks, wGrdBanking)

        dsCoApp.SelectParameters("applicantID").DefaultValue = aID
        dsCoApp.DataBind()
        ShowGrid(dsCoApp, wGrdCoApp)

        dsCreditors.SelectParameters("applicantID").DefaultValue = aID
        dsCreditors.DataBind()
        ShowGrid(dsCreditors, wGrdCreditors)

    End Sub
#Region "Notes"
    Protected Sub btnNotesRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNotesRefresh.Click
        Dim aID As Integer = Request.QueryString("id")

        dsNotes.SelectParameters("applicantID").DefaultValue = aID
        dsNotes.DataBind()
    End Sub

    Protected Sub wGrdNotes_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdNotes.InitializeRow
        Dim cellValue As String = e.Row.Cells(2).Value.ToString
        Dim noteID As Integer = e.Row.Cells(4).Value.ToString

        Dim strUrl As String = "<a href=""javascript:EditNote(" & noteID & ");"">" & Server.HtmlEncode(cellValue) & "</a>"

        e.Row.Cells(2).Value = strUrl
    End Sub
#End Region
#Region "Bank"
    Protected Sub btnBankRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNotesRefresh.Click
        Dim aID As Integer = Request.QueryString("id")

        dsBanks.SelectParameters("applicantID").DefaultValue = aID
        dsBanks.DataBind()
    End Sub

    Protected Sub wGrdBanking_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles wGrdBanking.DataBound
        Dim dv As DataView = CType(dsBanks.Select(DataSourceSelectArguments.Empty), DataView)
        lnkAddBanks.Visible = (dv.Count = 0)
    End Sub

    Protected Sub wGrdBanking_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles wGrdBanking.InitializeLayout
        e.Layout.Bands(0).Columns.Add("Type", "Type")
        e.Layout.Bands(0).Columns.FromKey("Type").CellStyle.HorizontalAlign = HorizontalAlign.Center
        e.Layout.Bands(0).Columns.FromKey("Checking").Hidden = True
    End Sub

    Protected Sub wGrdBanking_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdBanking.InitializeRow
        Dim cellValue As String = e.Row.Cells(1).Value.ToString
        Dim bankID As Integer = e.Row.Cells(5).Value.ToString

        Dim strUrl As String = "<a href=""javascript:EditBank(" & bankID & ");"">" & Server.HtmlEncode(cellValue) & "</a>"
        e.Row.Cells(1).Value = strUrl

        Dim strAcctNum As String = e.Row.Cells(3).Value.ToString
        e.Row.Cells(3).Value = "**" & Right(strAcctNum, 4)

        Dim strAcctType As String = ""
        Select Case e.Row.Cells(4).Value.ToString
            Case False
                strAcctType = "Savings"
            Case True
                strAcctType = "Checking"
        End Select

        e.Row.Cells.FromKey("type").Value = strAcctType
    End Sub
#End Region

#Region "CoApp"
    Protected Sub btnCoAppRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCoAppRefresh.Click
        Dim aID As Integer = Request.QueryString("id")

        dsCoApp.SelectParameters("applicantID").DefaultValue = aID
        dsCoApp.DataBind()
    End Sub
    Protected Sub wGrdCoApp_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles wGrdCoApp.InitializeLayout
        Me.wGrdCoApp.DataKeyField = "LeadCoApplicantID"
        e.Layout.Bands(0).DataKeyField = "LeadCoApplicantID"
        e.Layout.Bands(0).BaseTableName = "tblLeadCoApplicant"

        e.Layout.AllowUpdateDefault = Infragistics.WebUI.UltraWebGrid.AllowUpdate.Yes
        e.Layout.AllowAddNewDefault = Infragistics.WebUI.UltraWebGrid.AllowAddNew.Yes
        e.Layout.AllowDeleteDefault = AllowDelete.Yes
    End Sub
    Protected Sub wGrdCoApp_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdCoApp.InitializeRow
        Dim cellValue As String = e.Row.Cells(1).Value.ToString
        Dim coAppID As Integer = e.Row.Cells(3).Value.ToString

        Dim strUrl As String = "<a href=""javascript:EditCoApp(" & coAppID & ");"">" & Server.HtmlEncode(cellValue) & "</a>"

        e.Row.Cells(1).Style.Padding.Left = Unit.Pixel(3)
        e.Row.Cells(1).Value = strUrl
    End Sub
#End Region

#Region "Creditors"
    Protected Sub btnCreditorRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreditorRefresh.Click
        Dim aID As Integer = Request.QueryString("id")
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim creditorInfo() As String = hdnCreditorInfo.Value.Split("|")

        Try
            If Val(hdnLeadCreditorInstance.Value) > 0 Then
                strSQL = "UPDATE tblLeadCreditorInstance SET "
                strSQL += "CreditorGroupID = " & creditorInfo(7) & ", "
                strSQL += "CreditorID = " & creditorInfo(0) & ", "
                strSQL += "Name = '" & creditorInfo(1).Replace("'", "''") & "', "
                strSQL += "Street = '" & creditorInfo(2).Replace("'", "''") & "', "
                strSQL += "Street2 = '" & creditorInfo(3).Replace("'", "''") & "', "
                strSQL += "City = '" & creditorInfo(4).Replace("'", "''") & "', "
                strSQL += "StateID = " & creditorInfo(5) & ", "
                strSQL += "ZipCode = '" & creditorInfo(6) & "', "
                strSQL += "Modified = '" & Now & "', "
                strSQL += "ModifiedBy = " & UserID & " "
                strSQL += "WHERE leadCreditorInstance = " & hdnLeadCreditorInstance.Value
            Else
                strSQL = "INSERT INTO tblLeadCreditorInstance (LeadApplicantID, CreditorGroupID, CreditorID, Name, Street, Street2, City, StateID, ZipCode, Created, CreatedBy, Modified, ModifiedBy) "
                strSQL += "VALUES ("
                strSQL += aID & ", "
                strSQL += creditorInfo(7) & ", "
                strSQL += creditorInfo(0) & ", '"
                strSQL += creditorInfo(1).Replace("'", "''") & "', '"
                strSQL += creditorInfo(2).Replace("'", "''") & "', '"
                strSQL += creditorInfo(3).Replace("'", "''") & "', '"
                strSQL += creditorInfo(4).Replace("'", "''") & "', "
                strSQL += creditorInfo(5) & ", '"
                strSQL += creditorInfo(6) & "', '"
                strSQL += Now & "', "
                strSQL += UserID & ", '"
                strSQL += Now & "', "
                strSQL += UserID & ")"
            End If

            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            'do nothing
        Finally
            If cmd.Connection.State <> ConnectionState.Closed Then cmd.Connection.Close()

            SaveCreditorAccountInfo()

            dsCreditors.SelectParameters("applicantID").DefaultValue = aID
            wGrdCreditors.DataBind()
            wGrdCreditors.Visible = True
        End Try
    End Sub
    Protected Sub wGrdCreditors_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles wGrdCreditors.InitializeLayout
        Me.wGrdCreditors.DataKeyField = "LeadCreditorInstance"
        e.Layout.Bands(0).DataKeyField = "LeadCreditorInstance"
        e.Layout.Bands(0).BaseTableName = "tblLeadCreditorInstance"
        e.Layout.AllowUpdateDefault = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
        e.Layout.AllowAddNewDefault = Infragistics.WebUI.UltraWebGrid.AllowAddNew.No
        e.Layout.AllowDeleteDefault = AllowDelete.Yes
    End Sub
    Protected Sub wGrdCreditors_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles wGrdCreditors.InitializeRow
        Dim cellValue As String = e.Row.Cells(1).Value.ToString
        Dim creditorInstanceID As Integer = e.Row.Cells(4).Value.ToString
        Dim strUrl As String = "<a href='javascript:EditCreditor(" & creditorInstanceID & ",""" & e.Row.Cells(1).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(7).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(8).Value.ToString.Replace("""", "'") & """,""" & e.Row.Cells(9).Value.ToString.Replace("""", "'") & """," & e.Row.Cells(10).Value & ",""" & e.Row.Cells(11).Value.ToString.Replace("""", "'") & """);'>" & Server.HtmlEncode(cellValue) & "</a>"
        e.Row.Cells(1).Value = strUrl
    End Sub
#End Region
#End Region

#Region "LSA"
    Private Sub generateLSA()
        Try
            Dim sBankName As String = ""
            Dim sBankRoutingNum As String = ""
            Dim sBankAcctNum As String = ""
            Dim typeOfAccount As String = ""
            Dim sParalegalName As String = ""
            Dim sParaLegalTitle As String = ""
            Dim sParalegalExt As String = ""

            If wGrdBanking.Rows.Count > 0 Then
                sBankName = wGrdBanking.Rows(0).Cells(1).Value
                sBankName = sBankName.Substring(sBankName.IndexOf(">") + 1).Replace("</a>", "")

                sBankRoutingNum = wGrdBanking.Rows(0).Cells(2).Value
                sBankAcctNum = wGrdBanking.Rows(0).Cells(3).Value
                If wGrdBanking.Rows(0).Cells(4).Value = True Then
                    typeOfAccount = "Checking"
                Else
                    typeOfAccount = "Savings"
                End If

            Else
                sBankName = ""
                sBankRoutingNum = ""
                sBankAcctNum = ""
                typeOfAccount = "Checking"
            End If


            Dim CompanyID As Integer = ddlCompany.SelectedIndex
            Dim StateID As Integer = 0
            If cboStateID.SelectedIndex <> 0 Then
                StateID = cboStateID.SelectedValue
            Else
                Throw New Exception("Client State is needed for LSA Agreement!")
            End If

            Dim ContingencyFeePercent = CDbl(ddlSettlementFee.SelectedItem.Text)
            Dim FirstYearServiceFeeAmount = CDbl(ddlMaintenanceFee.SelectedItem.Text)
            Dim SubsequentYearServiceFeeAmount = Val(ddlSubMaintenanceFee.SelectedItem.Text)

            Dim BankName As String = sBankName
            Dim BankRoutingNum As String = sBankRoutingNum
            Dim BankAcctNum As String = sBankAcctNum
            Dim InitialDepositAmount As String = txtDownPmt.Text
            Dim DepositDay As String = getNth(ddlDepositDay.Text)
            Dim DepositCommitmentAmount As String = txtDepositComitmment.Text

            '***********************************
            'get agent info from I3 db
            Dim sqlParalegal As String = String.Format("stp_SmartDebtor_GetAgentInfoFromUserID {0}", UserID)
            Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlParalegal.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)

                For Each row As DataRow In dt.Rows
                    sParalegalName = row("ParaLegalName").ToString
                    sParaLegalTitle = "Law Firm Representative"
                    sParalegalExt = row("ParaLegalExt").ToString
                Next
            End Using
            '***********************************


            '*********show optional form letter****************
            Dim bShowFormLetter As Boolean = True
            If Me.ddlStatus.SelectedItem.Value <> 2 Then
                bShowFormLetter = False
            End If

            bShowFormLetter = chkFormLetter.Checked
            '************************


            Dim rpt As New LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim rDoc As New GrapeCity.ActiveReports.Document.SectionDocument
            rDoc = rpt.Generate_SM_LSA(CompanyID, StateID, ContingencyFeePercent, FirstYearServiceFeeAmount, _
                            SubsequentYearServiceFeeAmount, BankName, BankRoutingNum, BankAcctNum, _
                            InitialDepositAmount, DepositDay, FormatCurrency(DepositCommitmentAmount, 2), typeOfAccount, txtFirstName.Text, txtLastName.Text, _
                             txtAddress.Text, "", txtCity.Text & ", " & cboStateID.SelectedItem.Text & Space(1) & txtZip.Text, sParalegalName, sParaLegalTitle, sParalegalExt, bShowFormLetter)

            Dim memStream As New System.IO.MemoryStream()
            Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
            pdf.Export(rDoc, memStream)

            memStream.Seek(0, IO.SeekOrigin.Begin)


            Session("LSAAgreement") = memStream.ToArray

            Dim _sb As New System.Text.StringBuilder()
            _sb.Append("window.open('viewLSA.aspx?type=lsa','',")
            _sb.Append("'toolbar=0,menubar=0,resizable=yes');")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)

            divMsg.Style("display") = "none"
            divMsg.InnerText = ""

        Catch ex As Exception
            divMsg.Style("display") = "block"
            Dim err As New StringBuilder
            err.Append("<BR/>" & ex.Message & "<BR/>")
            err.Append("<a style=""cursor:pointer;color:blue; text-decoration:underline;"" onclick=""javascript:document.getElementById('" & divMsg.ClientID & "').style.display ='none';"">Close</a>")
            divMsg.InnerHtml = err.ToString
        End Try
    End Sub
#End Region

#Region "Utils"
    Private Sub InsertNote(ByVal noteText As String, ByVal applicantID As String, ByVal createdByUserID As String)
        Dim strSQL As String = ""
        Dim cmd As SqlCommand = Nothing

        strSQL = "INSERT INTO tblLeadNotes (LeadApplicantID, notetypeid,NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) " _
                           & "VALUES (" _
                           & applicantID & ", 3 ,'OTHER', '" _
                           & noteText.Replace("'", "''") & "', '" _
                           & Now & "', " _
                           & createdByUserID & ", '" _
                           & Now & "', " _
                           & createdByUserID & ")"
        Try
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()
            txtQuickNote.Text = ""
        Catch ex As Exception
            Throw ex
        Finally
            cmd = Nothing
        End Try

    End Sub
    Private Function getNth(ByVal numberToFormat As String) As String
        Dim lastNumber As String = Right(numberToFormat, 1)
        Select Case Val(lastNumber)
            Case 1
                Return numberToFormat & "st"
            Case 2
                Return numberToFormat & "nd"
            Case 3
                Return numberToFormat & "rd"
            Case Else
                Return numberToFormat & "th"
        End Select
    End Function
    Private Function FormatPhone(ByVal p As String) As String
        Dim NewPhone As String = p
        If Val(Mid(p, 2, 3)) = 0 Then
            NewPhone = NewPhone.Replace("(", "")
            NewPhone = NewPhone.Replace(")", "")
            NewPhone = NewPhone.Replace("-", "")
            NewPhone = ""
        End If
        Return NewPhone

    End Function

    Private Function FormatDate(ByVal v As Date) As String
        Dim NewDate As Date = v
        If DatePart(DateInterval.Year, NewDate).ToString = "1900" Then
            v = ""
        End If
        Return v
    End Function

#End Region

    'This method has the same calculations as the javascript Recalc() function. Used when postbacks are needed.
    Private Sub Recalc()
        If IsNumeric(txtTotalDebt.Text) Then
            Try
                'Get the current values
                Dim TotDebt As Double = CDbl(Me.txtTotalDebt.Text)
                Dim SettlementPct As Double = CDbl(ddlSettlementPct.SelectedItem.Text) / 100
                Dim SettlementPctTotal As Double = TotDebt * SettlementPct
                Dim SettlementFee As Double = CDbl(ddlSettlementFee.SelectedItem.Text) / 100

                'Est Settlement amount client will pay out
                Me.lblSettlementPct2.Text = Format(CDbl(SettlementPctTotal.ToString), "$#,##0.00")
                'Settlement fees total amount based on debt
                Me.lblSettlementFee.Text = Format((TotDebt - SettlementPctTotal) * SettlementFee, "$#,##0.00")
                'This is just an approximation
                Me.lblCurrentMonthly.Text = Format(TotDebt * EnrollmentCurrentPct, "$#,##0.00")

                'Nominal deposit
                If TotDebt * EnrollmentMinPct <= EnrollmentMinDeposit Then
                    Me.txtNominalDeposit.Text = Format(EnrollmentMinDeposit, "$#,##0.00")
                Else
                    Me.txtNominalDeposit.Text = Format(TotDebt * EnrollmentMinPct, "$#,##0.00")
                End If

                'LowAmount
                If TotDebt * EnrollmentMinPct <= EnrollmentMinDeposit Then
                    Me.lblLowAmt.Text = Format(EnrollmentMinDeposit, "$#,##0.00")
                Else
                    Me.lblLowAmt.Text = Format(TotDebt * EnrollmentMinPct, "$#,##0.00")
                End If

                'High Amount
                If TotDebt * EnrollmentMaxPct <= EnrollmentMinDeposit Then
                    Me.lblHighAmt.Text = Format(EnrollmentMinDeposit, "$#,##0.00")
                Else
                    Me.lblHighAmt.Text = Format(TotDebt * EnrollmentMaxPct, "$#,##0.00")
                End If

                'Maintenance Fees
                Dim MaintenanceFee1 As Double
                If ddlMaintenanceFee.SelectedItem.Text <> "" Then
                    MaintenanceFee1 = CDbl(ddlMaintenanceFee.SelectedItem.Text) * 12
                Else
                    MaintenanceFee1 = 0
                End If
                lblMaintenanceFeeTotal.Text = Format(MaintenanceFee1, "$#,##0.00")

                'Recommendation
                Dim Counseling As Double = TotDebt * EnrollmentMinPct
                Dim Bankruptcy1 As Double = TotDebt * EnrollmentMinPct
                Dim Bankruptcy2 As Double = EnrollmentMinDeposit
                Dim Deposit As Double = Val(txtDepositComitmment.Text.ToString)

                If Deposit > Counseling Then
                    lblDebtSettle.Text = "Credit Counseling"
                    lblDebtSettle.CssClass = "orange"
                ElseIf Deposit > Bankruptcy1 Or Deposit < Bankruptcy2 Then
                    lblDebtSettle.Text = "Bankruptcy"
                    lblDebtSettle.CssClass = "red"
                Else
                    lblDebtSettle.Text = "Debt Settlement"
                    lblDebtSettle.CssClass = "green"
                End If

                'Total settlement and fees
                Dim SettlementPct2 As Double = CDbl(lblSettlementPct2.Text)
                Dim MaintenanceFee As Double = CDbl(lblMaintenanceFeeTotal.Text)
                Dim SubMaintenanceFeeTotal As Double
                Dim SettlementFee2 As Double = CDbl(lblSettlementFee.Text)
                Dim InitialDeposit As Double = Val(txtDownPmt.Text)
                Dim DepositCommitment As Double = Val(txtDepositComitmment.Text)
                Dim MaintenanceFeeMonthly As Double = Val(ddlMaintenanceFee.SelectedItem.Text)
                Dim dblTerm As Double

                If ((((SettlementPct2 + SettlementFee2 + MaintenanceFee1) - InitialDeposit) / (DepositCommitment)) / 12) < 0 Then
                    dblTerm = 0
                ElseIf DepositCommitment > 0 Then
                    dblTerm = (((SettlementPct2 + SettlementFee2 + MaintenanceFee1) - InitialDeposit) / (DepositCommitment)) / 12
                End If
                txtTerm.Text = Format(dblTerm, "0.##")

                'Subsequent Maintenance Fees, calculate based on remainder of term minus the first year
                If ddlSubMaintenanceFee.SelectedItem.Text <> "" And dblTerm > 0 Then
                    SubMaintenanceFeeTotal = CDbl(ddlSubMaintenanceFee.SelectedItem.Text) * ((dblTerm * 12) - 12)
                End If
                lblSubMaintenanceFee.Text = Format(SubMaintenanceFeeTotal, "$#,##0.00")

                Dim TotalSettlementFees As Double = SettlementPct2 + MaintenanceFee + SubMaintenanceFeeTotal + SettlementFee2
                Me.txtSettlementFees.Text = Format(TotalSettlementFees, "$#,##0.00")
            Catch ex As Exception

            End Try
        End If
    End Sub

    Protected Sub btnRemoveCoApp_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveCoApp.Click
        Dim cmd As SqlCommand

        Try
            cmd = New SqlCommand("delete from tblLeadCoApplicant where LeadCoApplicantID = " & hdnLeadCoApplicantID.Value, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()

            dsCoApp.SelectParameters("applicantID").DefaultValue = aID
            dsCoApp.DataBind()
            ShowGrid(dsCoApp, wGrdCoApp)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Protected Sub btnRemoveBank_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveBank.Click
        Dim cmd As SqlCommand

        Try
            cmd = New SqlCommand("delete from tblLeadBanks where LeadBankID = " & hdnLeadBankID.Value, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()

            dsBanks.SelectParameters("applicantID").DefaultValue = aID
            dsBanks.DataBind()
            ShowGrid(dsBanks, wGrdBanking)

            Dim dv As DataView = CType(dsBanks.Select(DataSourceSelectArguments.Empty), DataView)
            lnkAddBanks.Visible = (dv.Table.Rows.Count = 0)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Protected Sub btnRemoveCreditor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveCreditor.Click
        Dim cmd As SqlCommand

        Try
            SaveCreditorAccountInfo()

            cmd = New SqlCommand("delete from tblLeadCreditorInstance where LeadCreditorInstance = " & hdnLeadCreditorInstance.Value, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()

            dsCreditors.SelectParameters("applicantID").DefaultValue = aID
            wGrdCreditors.DataBind()
            ShowGrid(dsCreditors, wGrdCreditors)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Private Sub SaveCreditorAccountInfo()
        Dim intLeadCreditorInstance As Integer
        Dim txtAccountNo As TextBox
        Dim txtBalance As TextBox
        Dim txtCreditorPhone As TextBox
        Dim txtExt As TextBox
        Dim col As TemplatedColumn
        Dim item As CellItem
        Dim strSQL As String
        Dim cmd As SqlCommand

        For i As Integer = 0 To wGrdCreditors.Rows.Count - 1
            intLeadCreditorInstance = CInt(wGrdCreditors.Rows(i).Cells(4).Text)

            col = wGrdCreditors.Columns(2)
            item = col.CellItems(i)
            txtAccountNo = CType(item.FindControl("txtAccountNo"), TextBox)

            col = wGrdCreditors.Columns(3)
            item = col.CellItems(i)
            txtBalance = CType(item.FindControl("txtBalance"), TextBox)

            col = wGrdCreditors.Columns(5)
            item = col.CellItems(i)
            txtCreditorPhone = CType(item.FindControl("txtCreditorPhone"), TextBox)

            col = wGrdCreditors.Columns(6)
            item = col.CellItems(i)
            txtExt = CType(item.FindControl("txtExt"), TextBox)

            strSQL = "update tblLeadCreditorInstance set "
            strSQL += "AccountNumber = '" & txtAccountNo.Text & "', "
            strSQL += "Balance = " & Val(txtBalance.Text.Replace("$", "").Replace(",", "")) & ", "
            strSQL += "Phone = '" & txtCreditorPhone.Text & "', "
            strSQL += "Ext = '" & txtExt.Text & "' "
            strSQL += "where LeadCreditorInstance = " & intLeadCreditorInstance

            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()
        Next
    End Sub

    Private Sub CalculateTime(ByVal local As Boolean)
        Dim LocalFromUtc As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", "FromUTC", "DBIsHere = 1"))
        Dim LeadfromUtc As Integer = LocalFromUtc

        If Me.ddlTimeZone.SelectedIndex > 0 Then
            LeadfromUtc = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", "FromUTC", "TimeZoneID = " & ddlTimeZone.SelectedValue))
        End If

        Try
            If local Then
                Me.FirstAppTime.Value = Nothing
                Me.FirstAppTime.Value = FirstAppLeadTime.Value.AddHours(LocalFromUtc - LeadfromUtc)
            Else
                Me.FirstAppLeadTime.Value = Nothing
                Me.FirstAppLeadTime.Value = FirstAppTime.Value.AddHours(LeadfromUtc - LocalFromUtc)
            End If
        Catch ex As Exception
            'Do Nothing
        End Try

    End Sub

    Private Sub FirstAppLeadTime_ValueChanged(ByVal sender As Object, ByVal args As Infragistics.WebUI.WebDataInput.ValueChangeEventArgs) Handles FirstAppLeadTime.ValueChange
        CalculateTime(True)
    End Sub

    Private Sub FirstAppTime_ValueChanged(ByVal sender As Object, ByVal args As Infragistics.WebUI.WebDataInput.ValueChangeEventArgs) Handles FirstAppTime.ValueChange
        CalculateTime(False)
    End Sub

    Private Sub ddlTimeZone_SelectedIndexChanged(ByVal sender As Object, ByVal args As System.EventArgs) Handles ddlTimeZone.SelectedIndexChanged
        CalculateTime(True)
    End Sub

    Public Sub SaveAndNoEndPage()
        Loading = False
        EndPageRedirect = False
        Save(a, aID)
        Loading = False
    End Sub

    Protected Sub btnSaveAndNoEndPage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSaveAndNoEndPage.Click
        SaveAndNoEndPage()
    End Sub

    Private Sub PrintInfoSheet()
        If Not aID = 0 Then
            Dim rpt As New LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim rDoc As New GrapeCity.ActiveReports.Document.SectionDocument
            rDoc = rpt.ViewApplicantInformationSheet(aID)
            Dim memStream As New System.IO.MemoryStream()
            Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
            pdf.Export(rDoc, memStream)

            memStream.Seek(0, IO.SeekOrigin.Begin)

            Session("infosheet") = memStream.ToArray

            Dim _sb As New System.Text.StringBuilder()
            _sb.Append("window.open('viewLSA.aspx?type=info','',")
            _sb.Append("'toolbar=0,menubar=0,resizable=yes');")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)

            divMsg.Style("display") = "none"
            divMsg.InnerText = ""
        End If
    End Sub
End Class
