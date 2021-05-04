Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports LexxiomLetterTemplates
Imports Slf.Dms.Records
Imports System.Linq
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Partial Class clients_client_underwriting
    Inherits System.Web.UI.Page

#Region "Variables"

    Public SetupFeePercentage As Double

    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer
    Private ClientStatusID As Integer
    Public OldPct As Integer
    Private Pct As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                 GlobalFiles.JQuery.UI, _
                                                 "~/jquery/json2.js", _
                                                 "~/jquery/jquery.modaldialog.js" _
                                                 })

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        Me.btnCurrent.Attributes.Add("onkeydown", "return ResetTab(event);")

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then
                Me.hdnMultideposit.Value = DataHelper.FieldLookup("tblClient", "Multideposit", "ClientID = " & ClientID)
                EnableSmartDebtorCalc()
                If Not CBool(Me.hdnMultideposit.Value) Then
                    trSingleDepositMethod.Style("display") = "block"
                    trSingleDepositRouting.Style("display") = "block"
                    trSingleDepositAccountNumber.Style("display") = "block"
                    trSingleDepositAccountType.Style("display") = "block"
                    trSingleDepositBankName.Style("display") = "block"
                    trSingleDepositBankCity.Style("display") = "block"
                    Me.trMultiDepositPanel.Style("display") = "none"
                Else
                    trSingleDepositMethod.Style("display") = "none"
                    trSingleDepositRouting.Style("display") = "none"
                    trSingleDepositAccountNumber.Style("display") = "none"
                    trSingleDepositAccountType.Style("display") = "none"
                    trSingleDepositBankName.Style("display") = "none"
                    trSingleDepositBankCity.Style("display") = "none"
                    Me.trMultiDepositPanel.Style("display") = "block"
                End If
                Dim RetainerPct As String = DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " & ClientID)
                If RetainerPct <> "" Then
                    ddlRetainer.SelectedValue = CStr((RetainerPct) * 100)
                    OldPct = CInt((RetainerPct) * 100)
                    txtOldPct.Text = CStr(OldPct)
                End If

                LoadRecord()
                LoadPrimaryPerson()
                LoadSecondaryPerson()

                SetAttributes()

            End If

        End If

    End Sub

    Private Sub EnableSmartDebtorCalc()
        'Disable this funtionality here and move it to the Overview Screen, Keep it here hidden in case ask to put it back
        Dim isSmartDebtorClient As Boolean = False 'debtcalculator.IsSmartDebtorClient(ClientID) 
        Me.trCalc.Visible = isSmartDebtorClient
        Me.trCalc2.Visible = isSmartDebtorClient
    End Sub

    Private Sub SetAttributes()

        'setup event handlers
        txtFirstName2.Attributes("onblur") = "txtFirstName2_OnBlur(this);"
        txtLastName2.Attributes("onblur") = "txtLastName2_OnBlur(this);"
        txtZipCode.Attributes("onblur") = "txtZipCode_OnBlur(this);"
        txtZipCode2.Attributes("onblur") = "txtZipCode2_OnBlur(this);"

        'setup input restrictions
        txtZipCode.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtZipCode2.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtDepositAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtAccountNumber.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtRoutingNumber.Attributes("onkeypress") = "AllowOnlyNumbers();"

        'add validation handles
        txtFirstName.Attributes("dvErr") = dvErrorPrimary.ClientID
        txtLastName.Attributes("dvErr") = dvErrorPrimary.ClientID
        txtStreet1.Attributes("dvErr") = dvErrorPrimary.ClientID
        txtStreet2.Attributes("dvErr") = dvErrorPrimary.ClientID
        txtCity.Attributes("dvErr") = dvErrorPrimary.ClientID
        cboStateID.Attributes("dvErr") = dvErrorPrimary.ClientID
        txtZipCode.Attributes("dvErr") = dvErrorPrimary.ClientID
        imDateOfBirth.Attributes("dvErr") = dvErrorPrimary.ClientID
        imSSN.Attributes("dvErr") = dvErrorPrimary.ClientID
        imHomePhone.Attributes("dvErr") = dvErrorPrimary.ClientID
        imHomeFax.Attributes("dvErr") = dvErrorPrimary.ClientID
        imBusinessPhone.Attributes("dvErr") = dvErrorPrimary.ClientID
        imBusinessFax.Attributes("dvErr") = dvErrorPrimary.ClientID
        imAlternatePhone.Attributes("dvErr") = dvErrorPrimary.ClientID
        imCellPhone.Attributes("dvErr") = dvErrorPrimary.ClientID
        txtEmailAddress.Attributes("dvErr") = dvErrorPrimary.ClientID

        txtFirstName2.Attributes("dvErr") = dvErrorSecondary.ClientID
        txtLastName2.Attributes("dvErr") = dvErrorSecondary.ClientID
        txtStreet12.Attributes("dvErr") = dvErrorSecondary.ClientID
        txtStreet22.Attributes("dvErr") = dvErrorSecondary.ClientID
        txtCity2.Attributes("dvErr") = dvErrorSecondary.ClientID
        cboStateID2.Attributes("dvErr") = dvErrorSecondary.ClientID
        txtZipCode2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imDateOfBirth2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imSSN2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imHomePhone2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imHomeFax2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imBusinessPhone2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imBusinessFax2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imAlternatePhone2.Attributes("dvErr") = dvErrorSecondary.ClientID
        imCellPhone2.Attributes("dvErr") = dvErrorSecondary.ClientID
        txtEmailAddress2.Attributes("dvErr") = dvErrorSecondary.ClientID

        cboDepositMethod.Attributes("dvErr") = dvErrorSetup.ClientID
        txtDepositAmount.Attributes("dvErr") = dvErrorSetup.ClientID
        cboDepositDay.Attributes("dvErr") = dvErrorSetup.ClientID
        txtRoutingNumber.Attributes("dvErr") = dvErrorSetup.ClientID
        txtAccountNumber.Attributes("dvErr") = dvErrorSetup.ClientID
        cboBankType.Attributes("dvErr") = dvErrorSetup.ClientID
        txtBankCity.Attributes("dvErr") = dvErrorSetup.ClientID
        cboBankStateID.Attributes("dvErr") = dvErrorSetup.ClientID
        imDepositStartDate.Attributes("dvErr") = dvErrorSetup.ClientID
        trMultiDepositPanel.Attributes("dvErr") = dvErrorSetup.ClientID

    End Sub
    Private Sub SetControls(ByVal Enabled As Boolean)

        txtFirstName.Enabled = Enabled
        txtLastName.Enabled = Enabled
        txtStreet1.Enabled = Enabled
        txtStreet2.Enabled = Enabled
        txtCity.Enabled = Enabled
        cboStateID.Enabled = Enabled
        txtZipCode.Enabled = Enabled
        imDateOfBirth.Enabled = Enabled
        imSSN.Enabled = Enabled
        imHomePhone.Enabled = Enabled
        imHomeFax.Enabled = Enabled
        imBusinessPhone.Enabled = Enabled
        imBusinessFax.Enabled = Enabled
        imAlternatePhone.Enabled = Enabled
        imCellPhone.Enabled = Enabled
        txtEmailAddress.Enabled = Enabled

        txtFirstName2.Enabled = Enabled
        txtLastName2.Enabled = Enabled
        txtStreet12.Enabled = Enabled
        txtStreet22.Enabled = Enabled
        txtCity2.Enabled = Enabled
        cboStateID2.Enabled = Enabled
        txtZipCode2.Enabled = Enabled
        imDateOfBirth2.Enabled = Enabled
        imSSN2.Enabled = Enabled
        imHomePhone2.Enabled = Enabled
        imHomeFax2.Enabled = Enabled
        imBusinessPhone2.Enabled = Enabled
        imBusinessFax2.Enabled = Enabled
        imAlternatePhone2.Enabled = Enabled
        imCellPhone2.Enabled = Enabled
        txtEmailAddress2.Enabled = Enabled

        cboDepositMethod.Enabled = Enabled
        txtDepositAmount.Enabled = Enabled
        cboDepositDay.Enabled = Enabled
        txtRoutingNumber.Enabled = Enabled
        txtAccountNumber.Enabled = Enabled
        cboBankType.Enabled = Enabled
        txtBankCity.Enabled = Enabled
        cboBankStateID.Enabled = Enabled
        imDepositStartDate.Enabled = Enabled

    End Sub
    Private Sub LoadRecord()

        LoadStates(cboStateID)
        LoadStates(cboStateID2)

        lnkClientName.HRef = ResolveUrl("~/clients/client/?id=") & ClientID
        lnkClientName.InnerHtml += ClientHelper.GetDefaultPersonName(ClientID)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblClient WHERE ClientID = @ClientID"

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader

                    If rd.Read Then

                        SetupFeePercentage = DatabaseHelper.Peel_double(rd, "SetupFeePercentage")

                        'fill ddl's and set selected
                        LoadBankStates(DatabaseHelper.Peel_int(rd, "BankStateID"))

                        Dim TrustID As Integer = DatabaseHelper.Peel_int(rd, "TrustID")
                        Dim AgencyID As Integer = DatabaseHelper.Peel_int(rd, "AgencyID")
                        Dim CompanyID As Integer = DatabaseHelper.Peel_int(rd, "CompanyID")

                        hdnCompanyID.Value = CompanyID

                        Dim LeadApplicantID As Integer = SmartDebtorHelper.GetLeadApplicantID(ClientID)
                        Dim AssignedUnderwriter As Integer = DataHelper.Nz_int(DataHelper.FieldLookup( _
                                    "tblClient", "AssignedUnderwriter", "ClientID = " & ClientID))

                        'If the lead came from CID allow user to submit verifications and generate eLSA's
                        If LeadApplicantID > 0 Then
                            hdnLeadApplicantID.Value = LeadApplicantID
                            'Determine to display 3PV or New 3PV
                            Dim use3PV As Boolean = CallVerificationHelper.UsedOldVerification(LeadApplicantID)
                            hdnUse3PV.Value = IIf(use3PV, "1", "0")
                            Me.tbOldVerification.Visible = use3PV
                            Me.tdVerAccessNumber.Visible = use3PV
                            Me.tbNewVerification.Visible = Not use3PV
                            Me.td3PVSep.Visible = Not use3PV
                            Me.td3PVMenu.Visible = False
                            Me.tdVerificationMenu.Visible = Not use3PV

                            divCID.Visible = True
                            trCID.Visible = True
                            trAssign.Visible = (AssignedUnderwriter = 0) 'Allow user to assign this client to themselves if not already assigned
                            ds_leaddocuments.SelectParameters("LeadApplicantID").DefaultValue = hdnLeadApplicantID.Value
                            If use3PV Then
                                ds_leadverification.SelectParameters("LeadApplicantID").DefaultValue = hdnLeadApplicantID.Value
                            Else
                                LoadNewVerification()
                            End If
                        End If

                        If Not TrustID = 0 Then
                            lblTrustName.Text = DataHelper.FieldLookup("tblTrust", "DisplayName", "TrustID = " & TrustID)
                        End If

                        If Not AgencyID = 0 Then
                            lblAgencyName.Text = DataHelper.FieldLookup("tblAgency", "Name", "AgencyID = " & AgencyID)
                        End If

                        If Not CompanyID = 0 Then
                            lblCompanyName.Text = DataHelper.FieldLookup("tblCompany", "Name", "CompanyID = " & CompanyID)
                        End If

                        lblSDAAccountNumber.Text = DatabaseHelper.Peel_string(rd, "AccountNumber")

                        'if no account number exists, prepare next in line
                        ListHelper.SetSelected(cboDepositMethod, DatabaseHelper.Peel_string(rd, "DepositMethod"))
                        txtDepositAmount.Text = DatabaseHelper.Peel_double(rd, "DepositAmount").ToString("###0.00")
                        ListHelper.SetSelected(cboDepositDay, DatabaseHelper.Peel_int(rd, "DepositDay"))
                        txtRoutingNumber.Text = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                        txtAccountNumber.Text = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                        cboBankType.SelectedValue = Trim(DatabaseHelper.Peel_string(rd, "BankType"))
                        lblBankName.Text = DatabaseHelper.Peel_string(rd, "BankName")
                        txtBankCity.Text = DatabaseHelper.Peel_string(rd, "BankCity")
                        imDepositStartDate.Text = DatabaseHelper.Peel_datestring(rd, "DepositStartDate", "MM/dd/yyyy")

                        Dim Saved As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "VWUWSaved")
                        Dim SavedBy As Integer = DatabaseHelper.Peel_int(rd, "VWUWSavedBy")
                        Dim Resolved As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "VWUWResolved")
                        Dim ResolvedBy As Integer = DatabaseHelper.Peel_int(rd, "VWUWResolvedBy")

                        Dim SavedByName As String = UserHelper.GetName(SavedBy)
                        Dim ResolvedByName As String = UserHelper.GetName(ResolvedBy)

                        If Resolved.HasValue Then 'HAS been resolved

                            lblInfoBox.Text = "This verification worksheet was already saved and resolved by " _
                                & ResolvedByName & " on " & Resolved.Value.ToString("MMM d, yyyy") & " at " _
                                & Resolved.Value.ToString("h:mm tt") & "."

                            pnlMenuResolve.Visible = False
                            pnlMenuView.Visible = True
                            trAccounts.Visible = False

                            SetControls(False)

                        Else 'has NOT been resolved

                            pnlMenuResolve.Visible = True
                            pnlMenuView.Visible = False
                            trAccounts.Visible = True

                            LoadAccounts()

                            SetControls(True)

                            'Allow user to adjust the initial draft
                            Dim tblAdhoc As DataTable = SqlHelper.GetDataTable("select *, isnull(banktype,'C')[btype] from tbladhocach where initialdraftyn = 1 and clientid = " & ClientID)
                            Dim li As ListItem
                            lblIniDepStatusMsg.Text = ""
                            lblIniDepStatusMsg.ForeColor = System.Drawing.Color.Black
                            If tblAdhoc.Rows.Count = 1 Then
                                trInitialDepositInfo.Visible = True
                                If Not IsDBNull(tblAdhoc.Rows(0)("registerid")) Then
                                    'Initial deposit has been drafted, dont allow mods
                                    imInitialDepDate.Enabled = False
                                    txtInitialAccount.Enabled = False
                                    txtInitialAmt.Enabled = False
                                    txtInitialRouting.Enabled = False
                                    ddlInitialType.Enabled = False
                                    lblIniDepStatusMsg.Text = "DRAFTED"
                                    lblIniDepStatusMsg.ForeColor = System.Drawing.Color.Blue
                                End If
                                lblInitialMethod.Text = "ACH"
                                hdnAdhocAchID.Value = tblAdhoc.Rows(0)("adhocachid")
                                imInitialDepDate.Text = Format(tblAdhoc.Rows(0)("depositdate"), "MM/dd/yyyy")
                                txtInitialAmt.Text = Format(tblAdhoc.Rows(0)("depositamount"), "###0.00")
                                txtInitialRouting.Text = tblAdhoc.Rows(0)("bankroutingnumber")
                                txtInitialAccount.Text = tblAdhoc.Rows(0)("bankaccountnumber")
                                li = ddlInitialType.Items.FindByValue(CStr(tblAdhoc.Rows(0)("btype")))
                                If Not IsNothing(li) Then
                                    li.Selected = True
                                End If
                            Else
                                'No ACH, instead show initial draft info stored in tblClient
                                tblAdhoc = SqlHelper.GetDataTable(String.Format("select initialdraftdate, isnull(initialdraftamount,0)[initialdraftamount], depositmethod from tblclient where clientid = {0} and initialdraftdate is not null", ClientID))
                                If tblAdhoc.Rows.Count = 1 Then
                                    trInitialDepositInfo.Visible = True
                                    lblInitialMethod.Text = tblAdhoc.Rows(0)("depositmethod")
                                    imInitialDepDate.Text = Format(tblAdhoc.Rows(0)("initialdraftdate"), "MM/dd/yyyy")
                                    txtInitialAmt.Text = Format(tblAdhoc.Rows(0)("initialdraftamount"), "###0.00")
                                    'these are only used for ACH 
                                    trInitialRouting.Visible = False
                                    trInitialAccount.Visible = False
                                    trInitialType.Visible = False
                                End If
                            End If

                            'Enforce draft Validation Initial AdHocs and CID users 
                            If txtInitialRouting.Visible OrElse (hdnLeadApplicantID.Value.Length > 0 AndAlso Not HasCompletedVerification()) Then
                                If lblIniDepStatusMsg.Text.ToUpper <> "DRAFTED" Then
                                    'Check if past date
                                    If imInitialDepDate.Text.Trim.Length > 0 Then
                                        Dim draftdate As DateTime = CDate(imInitialDepDate.Text)
                                        If LocalHelper.AddBusinessDays(draftdate, -2) < Date.Today Then
                                            lblIniDepStatusMsg.Text = "Past deposit date"
                                            lblIniDepStatusMsg.ForeColor = System.Drawing.Color.Red
                                        End If
                                    Else
                                        lblIniDepStatusMsg.Text = "No date"
                                        lblIniDepStatusMsg.ForeColor = System.Drawing.Color.Red
                                    End If
                                End If
                            End If

                            If Saved.HasValue Then 'HAS been saved before

                                lblInfoBox.Text = "This verification worksheet was never resolved but has been " _
                                    & "filled out and saved already by " & SavedByName & " on " _
                                    & Saved.Value.ToString("MMM d, yyyy") & " at " _
                                    & Saved.Value.ToString("h:mm tt") & ".  Please fill in any other " _
                                    & "necessary data and resolve this worksheet."

                            Else 'has NOT been saved before

                                If AssignedUnderwriter = UserID Then 'IS assigned underwriter for this client

                                    lblInfoBox.Text = "You are viewing this worksheet because you are " _
                                        & "the assigned underwriter for this client.  This client was recently " _
                                        & "screened and needs this worksheet to be resolved before they can " _
                                        & "become active. Only enter or modify what you know."

                                Else 'is NOT assigned underwriter for this client

                                    lblInfoBox.Text = "You are not the assigned underwriter for this client, " _
                                        & "but this client was recently screened and needs this worksheet " _
                                        & "to be resolved before they can become active. Only enter or modify " _
                                        & "what you know."

                                End If

                            End If

                        End If

                        If IsDBNull(rd("Accept")) Then
                            lblInfoBox.Text &= "<font color='red'> Client pending attorney approval.</font>"
                        End If
                        chkWelcomeCallLtrNeeded.Checked = DatabaseHelper.Peel_bool(rd, "WelcomeCallLetterNeeded")

                    End If

                End Using
            End Using
        End Using

    End Sub

    Private Sub LoadNewVerification()
        Dim dt As DataTable = CallVerificationHelper.GetCallVerificationByClientId(ClientID)
        Me.grdVerification.DataSource = dt
        Me.grdVerification.DataBind()
    End Sub

    Private Sub LoadBankStates(ByVal SelectedID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblState ORDER BY [Name]"

        Dim SelectionWasMade As Boolean = False

        cboBankStateID.Items.Clear()

        Dim liEmpty As New ListItem(String.Empty, 0)

        cboBankStateID.Items.Add(liEmpty)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")
                Dim StateName As String = DatabaseHelper.Peel_string(rd, "Name")

                Dim li As New ListItem(StateName, StateID)

                cboBankStateID.Items.Add(li)

                If StateID = SelectedID Then

                    cboBankStateID.ClearSelection()
                    li.Selected = True
                    SelectionWasMade = True

                Else
                    li.Selected = False
                End If

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Not SelectionWasMade Then
            cboBankStateID.ClearSelection()
            liEmpty.Selected = True
        End If

    End Sub
    Private Sub LoadPrimaryPerson()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblPerson WHERE ClientID = @ClientID AND Relationship = 'Prime'"

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read() Then

                        txtFirstName.Text = DatabaseHelper.Peel_string(rd, "FirstName")
                        txtLastName.Text = DatabaseHelper.Peel_string(rd, "LastName")
                        txtStreet1.Text = DatabaseHelper.Peel_string(rd, "Street")
                        txtStreet2.Text = DatabaseHelper.Peel_string(rd, "Street2")
                        txtCity.Text = DatabaseHelper.Peel_string(rd, "City")
                        ListHelper.SetSelected(cboStateID, DatabaseHelper.Peel_int(rd, "StateID"))
                        txtZipCode.Text = DatabaseHelper.Peel_string(rd, "ZipCode")
                        imDateOfBirth.Text = DatabaseHelper.Peel_datestring(rd, "DateOfBirth", "MM/dd/yyyy")
                        imSSN.Text = DatabaseHelper.Peel_string(rd, "SSN")

                        Dim Phones As List(Of Phone) = PersonHelper.GetPhones(DatabaseHelper.Peel_int(rd, "PersonID"))

                        imHomePhone.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Home"))
                        imHomeFax.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Home Fax"))
                        imBusinessPhone.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Business"))
                        imBusinessFax.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Business Fax"))
                        imAlternatePhone.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Home 2"))
                        imCellPhone.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Mobile"))

                        txtEmailAddress.Text = DatabaseHelper.Peel_string(rd, "EmailAddress")

                    End If
                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadSecondaryPerson()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            'select spouse
            cmd.CommandText = "SELECT TOP 1 * FROM tblPerson WHERE ClientID = @ClientID AND NOT Relationship = 'prime'"

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read() Then

                        txtFirstName2.Text = DatabaseHelper.Peel_string(rd, "FirstName")
                        txtLastName2.Text = DatabaseHelper.Peel_string(rd, "LastName")
                        txtStreet12.Text = DatabaseHelper.Peel_string(rd, "Street")
                        txtStreet22.Text = DatabaseHelper.Peel_string(rd, "Street2")
                        txtCity2.Text = DatabaseHelper.Peel_string(rd, "City")
                        ListHelper.SetSelected(cboStateID2, DatabaseHelper.Peel_int(rd, "StateID"))
                        txtZipCode2.Text = DatabaseHelper.Peel_string(rd, "ZipCode")
                        imDateOfBirth2.Text = DatabaseHelper.Peel_datestring(rd, "DateOfBirth", "MM/dd/yyyy")
                        imSSN2.Text = DatabaseHelper.Peel_string(rd, "SSN")

                        Dim Phones As List(Of Phone) = PersonHelper.GetPhones(DatabaseHelper.Peel_int(rd, "PersonID"))

                        imHomePhone2.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Home"))
                        imHomeFax2.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Home Fax"))
                        imBusinessPhone2.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Business"))
                        imBusinessFax2.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Business Fax"))
                        imAlternatePhone2.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Home 2"))
                        imCellPhone2.Text = PadForEmptyNoPad(GetPhoneByType(Phones, "Mobile"))

                        txtEmailAddress2.Text = DatabaseHelper.Peel_string(rd, "EmailAddress")

                    End If
                End Using
            End Using
        End Using

    End Sub
    Private Function GetPhoneByType(ByVal Phones As List(Of Phone), ByVal Type As String) As Phone

        For Each Phone As Phone In Phones
            If Phone.PhoneTypeName = Type Then
                Return Phone
            End If
        Next

        Return Nothing

    End Function
    Private Function GetDropDownListsForAccounts() As String

        Dim cboStateID As New DropDownList

        LoadStates(cboStateID)

        'add class and event attrbutes
        cboStateID.Attributes("class") = "grdDDL uns"
        cboStateID.Attributes("onkeydown") = "Grid_DDL_OnKeyDown(this);"
        cboStateID.Attributes("onblur") = "Grid_DDL_OnBlur(this);"

        'render controls out to string
        Using Writer As New IO.StringWriter
            Using HtmlWriter As New HtmlTextWriter(Writer)

                cboStateID.RenderControl(HtmlWriter)

                Return Writer.ToString()

            End Using
        End Using

    End Function
    Private Sub LoadStates(ByVal cbo As DropDownList)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblState ORDER BY Name"

            cbo.Items.Clear()
            cbo.Items.Add(New ListItem(String.Empty, 0))

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()
                        cbo.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "StateID")))
                    End While

                End Using
            End Using
        End Using

    End Sub
    Private Function PadForEmptyNoPad(ByVal Phone As Phone) As String

        If Phone Is Nothing Then
            Return String.Empty
        Else
            Return Phone.NumberFormatted
        End If

    End Function
    Private Function PadForEmpty(ByVal Phone As Phone) As String

        If Phone Is Nothing Then
            Return PadForEmpty(String.Empty)
        Else
            Return PadForEmpty(Phone.NumberFormatted)
        End If

    End Function
    Private Function PadForEmpty(ByVal Value As String) As String

        If Value Is Nothing OrElse Value.Length = 0 Then
            Value = "&nbsp;"
        End If

        Return Value

    End Function
    Private Sub LoadAccounts()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAccountsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Dim Accounts As New List(Of Slf.Dms.Records.Account)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Accounts.Add(New Slf.Dms.Records.Account(DatabaseHelper.Peel_int(rd, "AccountID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_double(rd, "OriginalAmount"), _
                    DatabaseHelper.Peel_double(rd, "CurrentAmount"), _
                    DatabaseHelper.Peel_int(rd, "CurrentCreditorInstanceID"), _
                    DatabaseHelper.Peel_double(rd, "SetupFeePercentage"), _
                    DatabaseHelper.Peel_date(rd, "OriginalDueDate"), _
                    DatabaseHelper.Peel_int(rd, "CreditorID"), _
                    DatabaseHelper.Peel_string(rd, "CreditorName"), _
                    DatabaseHelper.Peel_string(rd, "CreditorStreet"), _
                    DatabaseHelper.Peel_string(rd, "CreditorStreet2"), _
                    DatabaseHelper.Peel_string(rd, "CreditorCity"), _
                    DatabaseHelper.Peel_int(rd, "CreditorStateID"), _
                    DatabaseHelper.Peel_string(rd, "CreditorStatename"), _
                    DatabaseHelper.Peel_string(rd, "CreditorStateAbbreviation"), _
                    DatabaseHelper.Peel_string(rd, "CreditorZipCode"), _
                    DatabaseHelper.Peel_int(rd, "ForCreditorID"), _
                    DatabaseHelper.Peel_string(rd, "ForCreditorName"), _
                    DatabaseHelper.Peel_string(rd, "ForCreditorStreet"), _
                    DatabaseHelper.Peel_string(rd, "ForCreditorStreet2"), _
                    DatabaseHelper.Peel_string(rd, "ForCreditorCity"), _
                    DatabaseHelper.Peel_int(rd, "ForCreditorStateID"), _
                    DatabaseHelper.Peel_string(rd, "ForCreditorStatename"), _
                    DatabaseHelper.Peel_string(rd, "ForCreditorStateAbbreviation"), _
                    DatabaseHelper.Peel_string(rd, "ForCreditorZipCode"), _
                    DatabaseHelper.Peel_date(rd, "Acquired"), _
                    DatabaseHelper.Peel_string(rd, "AccountNumber"), _
                    DatabaseHelper.Peel_string(rd, "ReferenceNumber"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"), _
                    DatabaseHelper.Peel_ndate(rd, "Settled"), _
                    DatabaseHelper.Peel_int(rd, "SettledBy"), _
                    DatabaseHelper.Peel_string(rd, "SettledByName"), _
                    rd("CreditorValidated"), _
                    rd("ForCreditorValidated"), _
                    DatabaseHelper.Peel_int(rd, "CreditorGroupID"), _
                    DatabaseHelper.Peel_int(rd, "ForCreditorGroupID")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        LoadAccountsGrid(Accounts)

    End Sub
    Private Sub LoadAccountsGrid(ByVal Accounts As List(Of Slf.Dms.Records.Account))

        'create grid and write in values
        Dim sb As New StringBuilder
        Dim intNotValidated As Integer

        sb.Append("<table valBox=""true"" valBoxId=""" & dvErrorAccounts.ClientID & """ valLabId=""" & tdErrorAccounts.ClientID & """ onselectstart=""return false;"" border=""0"" cellspacing=""0"" cellpadding=""0"">")
        sb.Append(" <colgroup>")
        sb.Append("     <col class=""c0"" />")
        sb.Append("     <col class=""c1"" />")
        sb.Append("     <col class=""c2"" />")
        sb.Append("     <col class=""c3"" />")
        sb.Append("     <col class=""c4"" />")
        sb.Append("     <col class=""c5"" />")
        sb.Append("     <col class=""c6"" />")
        sb.Append("     <col class=""c7"" />")
        sb.Append("     <col class=""c8"" />")
        sb.Append("     <col class=""c9"" />")
        sb.Append("     <col class=""c10"" />")
        sb.Append("     <col class=""c11"" />")
        sb.Append("     <col class=""c12"" />")
        sb.Append("     <col class=""c13"" />")
        sb.Append("     <col class=""c14"" />")
        sb.Append("     <col class=""c15"" />") 'forstreet
        sb.Append("     <col class=""c16"" />") 'forstreet2
        sb.Append("     <col class=""c17"" />") 'forcity
        sb.Append("     <col class=""c18"" />") 'forstateid
        sb.Append("     <col class=""c19"" />") 'forzipcode
        sb.Append("     <col class=""c20"" />") 'creditorid
        sb.Append("     <col class=""c21"" />") 'forcreditorid
        sb.Append("     <col class=""c22"" />") 'creditorgroupid
        sb.Append("     <col class=""c23"" />") 'forcreditorgroupid
        sb.Append(" </colgroup>")
        sb.Append(" <thead>")
        sb.Append("     <tr>")
        sb.Append("         <th class=""first""><div class=""header""><div class=""header2"">&nbsp;</div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""CreditorName"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Creditor Name</div></div></th>")
        sb.Append("         <th><div class=""header""><div style=""text-align:center;""><img src=""" & ResolveUrl("~/images/13x13_search.png") & """ absmiddle=""align"" border=""0"" /></div></div></th>")
        sb.Append("         <th fieldName=""ForName"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>For</div></div></th>")
        sb.Append("         <th><div class=""header""><div style=""text-align:center;""><img src=""" & ResolveUrl("~/images/13x13_search.png") & """ absmiddle=""align"" border=""0"" /></div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""Amount"" fieldType=""money"" useVal=""true"" valFun=""IsValidCurrency"" mode=""txt"" control=""0""><div class=""header""><div style=""text-align:right;padding-right:5;"">Amount</div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""AccountNumber"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Account No.</div></div></th>")
        sb.Append("         <th fieldName=""ReferenceNumber"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Reference No.</div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""Street"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Billing Street</div></div></th>")
        sb.Append("         <th fieldName=""Street2"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Street 2</div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""City"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>City</div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""StateID"" fieldType=""int"" mode=""ddl"" control=""1""><div class=""header""><div>State</div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""ZipCode"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Zip Code</div></div></th>")
        sb.Append("         <th fieldName=""PhoneBusiness"" fieldType=""varchar"" useVal=""true"" valFun=""IsValidTextPhoneNumber"" mode=""txt"" control=""0""><div class=""header""><div>Phone</div></div></th>")
        sb.Append("         <th fieldName=""PhoneBusinessFax"" fieldType=""varchar"" useVal=""true"" valFun=""IsValidTextPhoneNumber"" mode=""txt"" control=""0""><div class=""header""><div>Fax</div></div></th>")
        sb.Append("         <th fieldName=""ForStreet"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""ForStreet2"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""ForCity"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""ForStateID"" fieldType=""int"" mode=""ddl"" control=""1""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""ForZipCode"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""CreditorID"" fieldType=""int"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""ForCreditorID"" fieldType=""int"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""CreditorGroupID"" fieldType=""int"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""ForCreditorGroupID"" fieldType=""int"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("     </tr>")
        sb.Append(" </thead>")
        sb.Append(" <tbody>")

        Dim c As Integer = 1

        'loop the persons list and write rows
        For Each a As Slf.Dms.Records.Account In Accounts
            Dim statusID As Integer = CInt(DataHelper.FieldLookup("tblAccount", "AccountStatusID", "AccountID = " & a.AccountID))

            If statusID = 171 Then 'NR
                sb.Append(" <tr key=""" & a.AccountID & """ validated=""1"" style='background-color:#E8E8E8;'>")
            ElseIf a.CreditorValidated Then
                sb.Append(" <tr key=""" & a.AccountID & """ validated=""1"" style='background-color:#D2FFD2;'>")
            ElseIf Not a.CanValidateCreditor Then
                sb.Append(" <tr key=""" & a.AccountID & """ validated=""1"">")
            Else
                sb.Append(" <tr key=""" & a.AccountID & """ validated=""0"" style='background-color:#FFDB72;'>")
                intNotValidated += 1
            End If

            sb.Append("     <th onclick=""Grid_RH_OnClick(this);""><div>" & c & "</div></th>")
            sb.Append("     <td><div nowrap=""true"">" & PadForEmpty(a.CreditorName) & "</div></td>")
            sb.Append("     <td align=""center""><div><button style=""font-size:11;width:15;height:15;"" onclick=""FindCreditor(this);"">&nbsp;</button></div></td>")
            sb.Append("     <td><div nowrap=""true"">" & PadForEmpty(a.ForCreditorName) & "</div></td>")
            sb.Append("     <td align=""center""><div><button style=""font-size:11;width:15;height:15;"" onclick=""FindFor(this);"">&nbsp;</button></div></td>")
            sb.Append("     <td onclick=""Grid_TD_OnClick(this);"" align=""right"" style=""color:red;""><div nowrap=""true"">" & PadForEmpty(a.CurrentAmount) & "</div></td>")
            sb.Append("     <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">" & PadForEmpty(a.AccountNumber) & "</div></td>")
            sb.Append("     <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">" & PadForEmpty(a.ReferenceNumber) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.CreditorStreet) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.CreditorStreet2) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.CreditorCity) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.CreditorStateName) & "</div><span style=""display:none;"">" & a.CreditorStateID & "</span></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.CreditorZipCode) & "</div></td>")

            Dim Phones As List(Of Phone) = CreditorHelper.GetPhones(a.CreditorID)

            'get the phones
            sb.Append("     <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">" & PadForEmpty(GetPhoneByType(Phones, "Business")) & "</div></td>")
            sb.Append("     <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">" & PadForEmpty(GetPhoneByType(Phones, "Business Fax")) & "</div></td>")

            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.ForCreditorStreet) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.ForCreditorStreet2) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.ForCreditorCity) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.ForCreditorStateID) & "</td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.ForCreditorZipCode) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.CreditorID) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.ForCreditorID) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.CreditorGroupID) & "</div></td>")
            sb.Append("     <td ><div nowrap=""true"">" & PadForEmpty(a.ForCreditorGroupID) & "</div></td>")

            sb.Append(" </tr>")

            c += 1

        Next

        ' add the new record row
        sb.Append("     <tr key=""*"" validated=""1"">")
        sb.Append("         <th onclick=""Grid_RH_OnClick(this);""><div>*</div></th>")
        sb.Append("         <td><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td align=""center""><div><button style=""font-size:11;width:15;height:15;"" onclick=""FindCreditor(this);"">&nbsp;</button></div></td>")
        sb.Append("         <td><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td align=""center""><div><button style=""font-size:11;width:15;height:15;"" onclick=""FindFor(this);"">&nbsp;</button></div></td>")
        sb.Append("         <td onclick=""Grid_TD_OnClick(this);"" align=""right"" style=""color:red;""><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div><span style=""display:none;""></span></td>")
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'forstreet
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'forstreet2
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'forcity
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'forstateid
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'forzipcode
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'creditorid
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'forcreditorid
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'creditorgroupid
        sb.Append("         <td ><div nowrap=""true"">&nbsp;</div></td>") 'forcreditorgroupid
        sb.Append("     </tr>")

        'finish off the bottom footer
        sb.Append("     <tr>")
        sb.Append("         <td colspan=""13"" style=""height:25;""></td>")
        sb.Append("     </tr>")
        sb.Append(" </tbody>")
        sb.Append("</table>")

        'add to grid div
        grdAccounts.InnerHtml = sb.ToString() & grdAccounts.InnerHtml & GetDropDownListsForAccounts()

        If intNotValidated > 0 Then
            aResolve.Disabled = True
            imgSave.Src = "~/images/16x16_save_disabled.png"
            dvErrorAccounts.Style("display") = ""
            tdErrorAccounts.InnerHtml = "There are unvalidated creditors on this worksheet. You will not be able to resolve this worksheet until they have been validated by a manager."
        End If
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
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResolve.Click
        Save(True)
    End Sub
    Protected Sub lnkSaveForLater_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveForLater.Click
        Save(False)
    End Sub
    Private Sub Save(ByVal Resolving As Boolean, Optional ByVal bReturnToRef As Boolean = True)
        Dim RtrChange As New RtrFeeAdjustmentHelper
        Dim Percentage As Double = CDbl(Val(ddlRetainer.SelectedValue)) / 100

        If Not UpdateInitialDeposit() Then
            'Error updating initial draft
            Exit Sub
        End If

        If Resolving And hdnLeadApplicantID.Value.Length > 0 Then
            If Not VerificationComplete() Then
                'CID client doesn't have a completed 3PV
                Exit Sub
            End If
        End If

        If ddlRetainer.SelectedValue = "10" Then
            DataHelper.FieldUpdate("tblClient", "InitialAgencyPercent", "0.02", "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblClient", "SetupFeePercentage", CStr(Percentage), "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblAccount", "SetupFeePercentage", CStr(Percentage), "ClientID = " & ClientID.ToString())
        Else
            DataHelper.FieldUpdate("tblClient", "InitialAgencyPercent", Nothing, "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblClient", "SetupFeePercentage", CStr(Percentage), "ClientID = " + ClientID.ToString())
            DataHelper.FieldUpdate("tblAccount", "SetupFeePercentage", CStr(Percentage), "ClientID = " & ClientID.ToString())
        End If

        'create all accounts
        'DO THIS FIRST so the fee adjustments will be made before underwriting is completed - in UploadClient()
        UpdateAccounts()
        InsertAccounts()
        DeleteAccounts()

        'nudge all accounts for fees
        Dim rtrHelper As New RtrFeeAdjustmentHelper
        Dim ChangeIt As Boolean = rtrHelper.ShouldRtrFeeChange(ClientID, UserID)

        'OldPct = CInt(Me.txtOldPct.Text)
        'If OldPct = Pct Then
        '      AccountHelper.AdjustRetainerFees(ClientID, UserID, False, Pct, OldPct)
        'Else
        '      AccountHelper.ClientRetainerCorrect(ClientID, UserID, False, Pct, OldPct)
        'End If

        If ChangeIt Then
            'Pay fees after modifying fee entries
            ClientHelper.CleanupRegister(ClientID)
        End If

        'save client info
        UpdateClient(Resolving)

        'save applicants
        UpdatePrimaryApplicant()
        UpdateSecondaryApplicant()

        If chkAssign.Checked Then
            'Assign underwriter on client record
            ClientHelper.UpdateField(ClientID, "AssignedUnderwriter", UserID, UserID)
            SqlHelper.ExecuteNonQuery("update tblClient set AssignedUnderwriterDate = getdate() where clientid = " & ClientID, CommandType.Text)
        End If

        If Resolving Then
            FinishUnderwriting()
        End If

        'update search results table for this client
        ClientHelper.LoadSearch(ClientID)

        If bReturnToRef Then
            ReturnToReferrer(Resolving)
        End If
    End Sub

    Private Sub FinishUnderwriting()

        'RoadmapHelper.InsertRoadmap(ClientID, 12, Nothing, UserID) 'Assigned CS Rep
        RoadmapHelper.InsertRoadmap(ClientID, 11, Nothing, UserID) 'Verification Complete
        RoadmapHelper.InsertRoadmap(ClientID, 15, "Pending attorney approval", UserID) 'Inactive

        'used by attorney portal
        SqlHelper.ExecuteNonQuery(String.Format("insert tblPendingApproval (ClientID) values ({0})", ClientID), CommandType.Text)

        'get any currently-assigned customer service rep
        Dim AssignedCSRep As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "AssignedCSRep", "ClientID = " & ClientID))

        'do we even use this for anything anymore?? we used to create a task for this rep
        If AssignedCSRep = 0 Then
            'get this client's preferred language
            Dim LanguageID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", "LanguageID", "PersonID = " & ClientHelper.GetDefaultPerson(ClientID)))

            'get the next CS Rep who speaks this language
            Dim CSRepUserID As Integer = UserHelper.GetNextUser(LanguageID, 3)

            'assign underwriter on client record
            ClientHelper.UpdateField(ClientID, "AssignedCSRep", CSRepUserID, UserID)
        End If

    End Sub

    Public Sub ReturnToReferrer(ByVal Resolving As Boolean)

        Dim Navigator As Navigator = CType(Page.Master, Site).Navigator

        Dim i As Integer = Navigator.Pages.Count - 1

        If Resolving Then 'don't restrict going back to client home page

            While i >= 0 AndAlso Not Navigator.Pages(i).Url.IndexOf("client/underwriting.aspx") = -1 'not found

                'decrement i
                i -= 1

            End While

        Else 'restrict going back to client home page

            While i >= 0 AndAlso (Not Navigator.Pages(i).Url.IndexOf("client/default.aspx") = -1 _
                Or Not Navigator.Pages(i).Url.IndexOf("client/underwriting.aspx") = -1)

                'decrement i
                i -= 1

            End While

        End If

        If i >= 0 Then
            Response.Redirect(Navigator.Pages(i).Url)
        Else
            Response.Redirect("~/default.aspx")
        End If

    End Sub
    Private Sub UpdatePrimaryApplicant()

        Dim PersonID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "PrimaryPersonID", _
            "ClientID = " & ClientID))

        If Not PersonID = 0 Then

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName.Text)
                DatabaseHelper.AddParameter(cmd, "LastName", txtLastName.Text)
                DatabaseHelper.AddParameter(cmd, "Street", txtStreet1.Text)
                DatabaseHelper.AddParameter(cmd, "Street2", DataHelper.Zn(txtStreet2.Text))
                DatabaseHelper.AddParameter(cmd, "City", txtCity.Text)
                DatabaseHelper.AddParameter(cmd, "StateID", ListHelper.GetSelected(cboStateID))
                DatabaseHelper.AddParameter(cmd, "ZipCode", txtZipCode.Text)
                DatabaseHelper.AddParameter(cmd, "DateOfBirth", DataHelper.Zn(imDateOfBirth.Text), DbType.DateTime)
                DatabaseHelper.AddParameter(cmd, "SSN", DataHelper.Zn(imSSN.TextUnMasked))
                DatabaseHelper.AddParameter(cmd, "EmailAddress", DataHelper.Zn(txtEmailAddress.Text))

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

                DatabaseHelper.BuildUpdateCommandText(cmd, "tblPerson", "PersonID = " & PersonID)

                Using cmd.Connection

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()

                End Using
            End Using

            'update primary applicant phones
            PersonPhoneHelper.Update(PersonID, "Home", imHomePhone.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Home Fax", imHomeFax.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Business", imBusinessPhone.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Business Fax", imBusinessFax.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Home 2", imAlternatePhone.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Mobile", imCellPhone.TextUnMasked, UserID)

        End If

    End Sub
    Private Sub UpdateSecondaryApplicant()

        Dim PersonID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", "PersonID", "ClientID = " _
            & ClientID & " AND Relationship = 'Spouse'"))

        If txtFirstName2.Text.Length > 0 Then

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName2.Text)
                DatabaseHelper.AddParameter(cmd, "LastName", txtLastName2.Text)
                DatabaseHelper.AddParameter(cmd, "Street", txtStreet12.Text)
                DatabaseHelper.AddParameter(cmd, "Street2", DataHelper.Zn(txtStreet22.Text))
                DatabaseHelper.AddParameter(cmd, "City", txtCity2.Text)
                DatabaseHelper.AddParameter(cmd, "StateID", ListHelper.GetSelected(cboStateID2))
                DatabaseHelper.AddParameter(cmd, "ZipCode", txtZipCode2.Text)
                DatabaseHelper.AddParameter(cmd, "DateOfBirth", DataHelper.Zn(imDateOfBirth2.Text), DbType.DateTime)
                DatabaseHelper.AddParameter(cmd, "SSN", DataHelper.Zn(imSSN2.TextUnMasked))
                DatabaseHelper.AddParameter(cmd, "EmailAddress", DataHelper.Zn(txtEmailAddress2.Text))

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

                If PersonID = 0 Then

                    'add on new person field defaults
                    Dim LanguageID As Integer = DataHelper.FieldLookup("tblLanguage", "LanguageID", "[Default] = 1")

                    DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                    DatabaseHelper.AddParameter(cmd, "LanguageID", LanguageID)
                    DatabaseHelper.AddParameter(cmd, "CanAuthorize", True)
                    DatabaseHelper.AddParameter(cmd, "Relationship", "Spouse")

                    Dim Gender As String = NameHelper.GetGender(txtFirstName2.Text)

                    If Gender.Length > 0 Then
                        Gender = Gender.Substring(0, 1)
                    End If

                    DatabaseHelper.AddParameter(cmd, "Gender", DataHelper.Zn(Gender))

                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))

                    DatabaseHelper.BuildInsertCommandText(cmd, "tblPerson", "PersonID", SqlDbType.Int)

                Else
                    DatabaseHelper.BuildUpdateCommandText(cmd, "tblPerson", "PersonID = " & PersonID)
                End If

                Using cmd.Connection

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()

                    If PersonID = 0 Then
                        PersonID = DataHelper.Nz_int(cmd.Parameters("@PersonID").Value)
                    End If

                End Using
            End Using

            'update primary applicant phones
            PersonPhoneHelper.Update(PersonID, "Home", imHomePhone2.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Home Fax", imHomeFax2.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Business", imBusinessPhone2.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Business Fax", imBusinessFax2.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Home 2", imAlternatePhone2.TextUnMasked, UserID)
            PersonPhoneHelper.Update(PersonID, "Mobile", imCellPhone2.TextUnMasked, UserID)

        Else 'delete any spouse
            PersonHelper.Delete("ClientID = " & ClientID & " AND Relationship = 'Spouse'", UserID)
        End If

    End Sub
    Private Sub UpdateClient(ByVal Resolving As Boolean)

        Me.MultipleDepositList.Save()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "DepositMethod", DataHelper.Zn(cboDepositMethod.SelectedValue))
            DatabaseHelper.AddParameter(cmd, "DepositAmount", DataHelper.Zn(DataHelper.Nz_double(txtDepositAmount.Text)), DbType.Double)
            DatabaseHelper.AddParameter(cmd, "DepositDay", ListHelper.GetSelected(cboDepositDay), DbType.Int32)
            DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(lblBankName.Text))
            DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", DataHelper.Zn(txtRoutingNumber.Text))
            DatabaseHelper.AddParameter(cmd, "BankAccountNumber", DataHelper.Zn(txtAccountNumber.Text))
            DatabaseHelper.AddParameter(cmd, "BankCity", DataHelper.Zn(txtBankCity.Text))
            DatabaseHelper.AddParameter(cmd, "BankStateID", ListHelper.GetSelected(cboBankStateID))
            DatabaseHelper.AddParameter(cmd, "DepositStartDate", DataHelper.Zn(imDepositStartDate.Text), DbType.DateTime)

            If cboBankType.SelectedValue = "0" Then
                DatabaseHelper.AddParameter(cmd, "BankType", DBNull.Value, DbType.String)
            Else
                DatabaseHelper.AddParameter(cmd, "BankType", cboBankType.SelectedValue, DbType.String)
            End If

            DatabaseHelper.AddParameter(cmd, "VWUWSaved", Now)
            DatabaseHelper.AddParameter(cmd, "VWUWSavedBy", UserID)

            If Resolving Then

                DatabaseHelper.AddParameter(cmd, "VWUWResolved", Now)
                DatabaseHelper.AddParameter(cmd, "VWUWResolvedBy", UserID)

            End If

            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

            DataHelper.AuditedUpdate(cmd, "tblClient", ClientID, UserID)

        End Using

    End Sub

    Private Sub InsertAccounts()

        Dim InsertRows As New List(Of Integer) 'unique list

        Dim Updates As New List(Of String) 'for phone fields to update after

        Pct = CInt(Val(Me.ddlRetainer.SelectedValue))

        If grdAccountsInserts.Value.Length > 0 Then

            'build dictionary of wd.accountinsert items
            Dim Inserts As New Dictionary(Of Integer, WorksheetData.AccountInsert)

            Dim InsertFields As New List(Of String)

            InsertFields.AddRange(Regex.Split(grdAccountsInserts.Value, "<-\$\$->"))

            'loop through fields and add to dictionary
            For Each InsertField As String In InsertFields

                If InsertField.Length > 0 Then

                    Dim Fields() As String = InsertField.Split(":")

                    Dim KeyID As Integer = DataHelper.Nz_int(Fields(0))
                    Dim Field As String = Fields(1)
                    Dim Type As String = Fields(2)
                    Dim Value As String = InsertField.Substring(KeyID.ToString().Length + Field.Length + Type.Length + 3)

                    'try to find current wd.accountinsert item in dictionary
                    Dim ai As WorksheetData.AccountInsert

                    If Inserts.ContainsKey(KeyID) Then
                        ai = Inserts.Item(KeyID)
                    Else
                        ai = New WorksheetData.AccountInsert()
                    End If

                    Select Case Field.ToLower
                        Case "creditorname"
                            If Value.Contains("&nbsp;") Then
                                Value.Replace("&nbsp;", "")
                            End If
                            ai.CreditorName = Value
                        Case "forname"
                            ai.ForCreditorName = Value
                        Case "amount"
                            ai.Amount = DataHelper.Nz_double(Value)
                        Case "accountnumber"
                            ai.AccountNumber = Value
                        Case "referencenumber"
                            ai.ReferenceNumber = Value
                        Case "street"
                            ai.Street = Value
                        Case "street2"
                            ai.Street2 = Value
                        Case "city"
                            ai.City = Value
                        Case "stateid"
                            ai.StateID = DataHelper.Nz_int(Value)
                        Case "zipcode"
                            ai.ZipCode = Value
                        Case "phonebusiness"
                            ai.PhoneNumber = Value
                        Case "phonebusinessfax"
                            ai.FaxNumber = Value
                        Case "forstreet"
                            ai.ForStreet = Value
                        Case "forstreet2"
                            ai.ForStreet2 = Value
                        Case "forcity"
                            ai.ForCity = Value
                        Case "forstateid"
                            ai.ForStateID = DataHelper.Nz_int(Value)
                        Case "forzipcode"
                            ai.ForZipCode = Value
                        Case "creditorid"
                            ai.CreditorID = DataHelper.Nz_int(Value)
                        Case "forcreditorid"
                            ai.ForCreditorID = DataHelper.Nz_int(Value)
                        Case "creditorgroupid"
                            ai.CreditorGroupID = DataHelper.Nz_int(Value)
                        Case "forcreditorgroupid"
                            ai.ForCreditorGroupID = DataHelper.Nz_int(Value)
                    End Select

                    If Not Inserts.ContainsKey(KeyID) Then
                        Inserts.Add(KeyID, ai)
                    End If

                End If

            Next

            'after making the returned accountinserts well-formed, insert each record to db
            If Inserts.Count > 0 Then

                'loop dictionary of well-formed wd.accountinserts
                For Each ai As WorksheetData.AccountInsert In Inserts.Values

                    Dim AccountID As Integer
                    Dim CreditorInstanceID As Integer
                    Dim CreditorID As Integer
                    Dim CreditorGroupID As Integer
                    Dim ForCreditorID As Integer = 0
                    Dim ForCreditorGroupID As Integer = 0

                    If ai.CreditorID > 0 Then
                        'they chose an existing creditor
                        CreditorID = ai.CreditorID
                    Else
                        If ai.CreditorGroupID > 0 Then
                            'they chose to add a new address
                            CreditorGroupID = ai.CreditorGroupID
                        Else
                            CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(ai.CreditorName, UserID)
                        End If
                        CreditorID = CreditorHelper.InsertCreditor(ai.CreditorName, ai.Street, ai.Street2, ai.City, ai.StateID, ai.ZipCode, UserID, CreditorGroupID)
                    End If

                    'for creditor is not required
                    If ai.ForCreditorID > 0 Then 'selected existing?
                        ForCreditorID = ai.ForCreditorID
                    ElseIf ai.ForCreditorID < 0 Then 'add?
                        If ai.ForCreditorGroupID > 0 Then
                            ForCreditorGroupID = ai.ForCreditorGroupID
                        Else
                            ForCreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(ai.ForCreditorName, UserID)
                        End If
                        ForCreditorID = CreditorHelper.InsertCreditor(ai.ForCreditorName, ai.ForStreet, ai.ForStreet2, ai.ForCity, ai.ForStateID, ai.ForZipCode, UserID, ForCreditorGroupID)
                    End If

                    'get client's setupfeepercentage
                    Dim SetupFeePercentage As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", _
                        "SetupFeePercentage", "ClientID = " & ClientID))

                    'prepare a fresh data command for account insert
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                        'set the status as "Insufficient Funds" from the beginning, if found
                        Dim AccountStatusID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblAccountStatus", "AccountStatusID", "Code = 'IF' AND Description = 'Insufficient Funds'"))

                        If Not AccountStatusID = 0 Then
                            DatabaseHelper.AddParameter(cmd, "AccountStatusID", AccountStatusID)
                        End If

                        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                        DatabaseHelper.AddParameter(cmd, "OriginalAmount", ai.Amount)
                        DatabaseHelper.AddParameter(cmd, "CurrentAmount", ai.Amount)
                        DatabaseHelper.AddParameter(cmd, "SetupFeePercentage", SetupFeePercentage)
                        DatabaseHelper.AddParameter(cmd, "OriginalDueDate", Now)

                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                        DatabaseHelper.BuildInsertCommandText(cmd, "tblAccount", "AccountID", SqlDbType.Int)

                        Using cmd.Connection

                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()

                            AccountID = DataHelper.Nz_int(cmd.Parameters("@AccountID").Value)

                        End Using
                    End Using

                    'prepare a fresh data command for creditorinstance insert
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                        DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
                        DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)
                        DatabaseHelper.AddParameter(cmd, "ForCreditorID", DataHelper.Zn(ForCreditorID))
                        DatabaseHelper.AddParameter(cmd, "Acquired", Now)
                        DatabaseHelper.AddParameter(cmd, "AccountNumber", ai.AccountNumber)
                        DatabaseHelper.AddParameter(cmd, "ReferenceNumber", DataHelper.Zn(ai.ReferenceNumber))
                        DatabaseHelper.AddParameter(cmd, "Amount", ai.Amount)
                        DatabaseHelper.AddParameter(cmd, "OriginalAmount", ai.Amount)

                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                        DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditorInstance", _
                            "CreditorInstanceID", SqlDbType.Int)

                        Using cmd.Connection

                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()

                            CreditorInstanceID = DataHelper.Nz_int(cmd.Parameters("@CreditorInstanceID").Value)

                        End Using
                    End Using

                    'update the account to have the correct creditor instances and amounts
                    AccountHelper.SetWarehouseValues(AccountID)

                    'update any phone numbers for this new account
                    If Not ai.PhoneNumber Is Nothing AndAlso ai.PhoneNumber.Length > 0 Then
                        UpdateCreditorPhone(CreditorID, "Business", StringHelper.ApplyFilter(ai.PhoneNumber, _
                            StringHelper.Filter.AphaNumericOnly))
                    End If

                    If Not ai.FaxNumber Is Nothing AndAlso ai.FaxNumber.Length > 0 Then
                        UpdateCreditorPhone(CreditorID, "Business Fax", StringHelper.ApplyFilter(ai.FaxNumber, _
                            StringHelper.Filter.AphaNumericOnly))
                    End If

                    'add the retainer fee is allowed
                    If chkCollectInsert.Checked Then
                        AccountHelper.AdjustRetainerFee(AccountID, ClientID, UserID, False, Pct, OldPct)
                    End If

                Next
            End If
        End If

    End Sub
    Private Sub DeleteAccounts()

        If grdAccountsDeletes.Value.Length > 0 Then

            Dim Deletes() As String = grdAccountsDeletes.Value.Split(",")

            For Each Delete As String In Deletes

                If Delete.Length > 0 Then

                    Try

                        Dim AccountID As Integer = DataHelper.Nz_int(Delete)

                        AccountHelper.Delete(AccountID)

                    Catch ex As Exception

                    End Try

                End If

            Next

        End If

    End Sub
    Private Sub UpdateAccounts()

        Pct = CInt(Val(Me.ddlRetainer.SelectedValue))

        If grdAccountsUpdates.Value.Length > 0 Then

            'build dictionary of list(of updates) and wd.accountcreditorupdate items
            Dim Updates As New Dictionary(Of Integer, List(Of WorksheetData.AccountUpdate))
            Dim CreditorUpdates As New Dictionary(Of Integer, WorksheetData.AccountCreditorUpdate)

            Dim UpdateFields As New List(Of String)

            UpdateFields.AddRange(Regex.Split(grdAccountsUpdates.Value, "<-\$\$->"))

            'loop through fields and add to dictionary
            For Each UpdateField As String In UpdateFields

                If UpdateField.Length > 0 Then
                    Try
                        Dim Fields() As String = UpdateField.Split(":")

                        If Fields(0) = "*" Then
                            'Hotfix: Not sure why the new row is trying to get updated. Cannot re-produce
                            'locally.
                            Exit For
                        Else
                            Dim AccountID As Integer = DataHelper.Nz_int(Fields(0))
                            Dim Field As String = Fields(1)
                            Dim Type As String = Fields(2)
                            Dim Value As String = UpdateField.Substring(AccountID.ToString().Length + Field.Length _
                                + Type.Length + 3)

                            If Field.ToLower = "amount" Or Field.ToLower = "accountnumber" _
                                Or Field.ToLower = "referencenumber" Or Field.ToLower = "phonebusiness" _
                                     Or Field.ToLower = "phonebusinessfax" Then 'is NOT creditor

                                'try to find current list(of wd.accountupdate) in dictionary
                                Dim lst As List(Of WorksheetData.AccountUpdate)

                                If Updates.ContainsKey(AccountID) Then
                                    lst = Updates.Item(AccountID)
                                Else
                                    lst = New List(Of WorksheetData.AccountUpdate)
                                End If

                                lst.Add(New WorksheetData.AccountUpdate(AccountID, Field, Type, Value))

                                If Not Updates.ContainsKey(AccountID) Then
                                    Updates.Add(AccountID, lst)
                                End If

                            Else 'IS creditor info related

                                'try to find current wd.accountcreditorupdate item in dictionary
                                Dim acu As WorksheetData.AccountCreditorUpdate

                                If CreditorUpdates.ContainsKey(AccountID) Then
                                    acu = CreditorUpdates.Item(AccountID)
                                Else
                                    acu = New WorksheetData.AccountCreditorUpdate(AccountID)
                                End If

                                Select Case Field.ToLower
                                    Case "creditorname"
                                        acu.Name = Value
                                    Case "street"
                                        acu.Street = Value
                                    Case "street2"
                                        acu.Street2 = Value
                                    Case "city"
                                        acu.City = Value
                                    Case "stateid"
                                        acu.StateID = DataHelper.Nz_int(Value)
                                    Case "zipcode"
                                        acu.ZipCode = Value
                                    Case "forname"
                                        acu.ForName = Value
                                    Case "forstreet"
                                        acu.ForStreet = Value
                                    Case "forstreet2"
                                        acu.ForStreet2 = Value
                                    Case "forcity"
                                        acu.ForCity = Value
                                    Case "forstateid"
                                        acu.ForStateID = DataHelper.Nz_int(Value)
                                    Case "forzipcode"
                                        acu.ForZipCode = Value
                                    Case "creditorid"
                                        acu.CreditorID = DataHelper.Nz_int(Value)
                                    Case "creditorgroupid"
                                        acu.CreditorGroupID = DataHelper.Nz_int(Value)
                                    Case "forcreditorid"
                                        acu.ForCreditorID = DataHelper.Nz_int(Value)
                                    Case "forcreditorgroupid"
                                        acu.ForCreditorGroupID = DataHelper.Nz_int(Value)
                                End Select

                                If Not CreditorUpdates.ContainsKey(AccountID) Then
                                    CreditorUpdates.Add(AccountID, acu)
                                End If
                            End If
                        End If
                    Catch ex As Exception
                        Throw New Exception(UpdateField & " ---- " & ex.Message)
                    End Try
                End If
            Next


            'first, deal with creditor updates
            For Each acu As WorksheetData.AccountCreditorUpdate In CreditorUpdates.Values

                Dim CreditorID As Integer = 0
                Dim CreditorGroupID As Integer = 0
                Dim ForCreditorID As Integer = 0
                Dim ForCreditorGroupID As Integer = 0
                Dim CreditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(acu.AccountID)

                If acu.CreditorID > 0 Then
                    'they chose an existing creditor
                    CreditorID = acu.CreditorID
                ElseIf acu.CreditorID = -1 Then
                    If acu.CreditorGroupID > 0 Then
                        'they chose to add a new address
                        CreditorGroupID = acu.CreditorGroupID
                    Else
                        CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(acu.Name, UserID)
                    End If
                    CreditorID = CreditorHelper.InsertCreditor(acu.Name, acu.Street, acu.Street2, acu.City, acu.StateID, acu.ZipCode, UserID, CreditorGroupID)
                End If

                If CreditorID > 0 Then
                    DataHelper.FieldUpdate("tblCreditorInstance", "CreditorID", CreditorID, _
                        "CreditorInstanceID = " & CreditorInstanceID)
                End If

                If acu.ForCreditorID > 0 Then
                    ForCreditorID = acu.ForCreditorID
                ElseIf acu.ForCreditorID = -1 Then
                    If acu.ForCreditorGroupID > 0 Then
                        ForCreditorGroupID = acu.ForCreditorGroupID
                    Else
                        ForCreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(acu.ForName, UserID)
                    End If
                    ForCreditorID = CreditorHelper.InsertCreditor(acu.ForName, acu.ForStreet, acu.ForStreet2, acu.ForCity, acu.ForStateID, acu.ForZipCode, UserID, ForCreditorGroupID)
                End If

                If ForCreditorID > 0 Then
                    DataHelper.FieldUpdate("tblCreditorInstance", "ForCreditorID", ForCreditorID, _
                        "CreditorInstanceID = " & CreditorInstanceID)
                End If
            Next

            'second, deal with account/creditorinstance updates
            For Each lst As List(Of WorksheetData.AccountUpdate) In Updates.Values

                For Each au As WorksheetData.AccountUpdate In lst

                    Select Case au.Field.ToLower

                        Case "amount"

                            UpdateAccount(au.AccountID, "CurrentAmount", "money", au.Value)

                            Dim CreditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(au.AccountID)

                            UpdateCreditorInstance(CreditorInstanceID, au.Field, au.Type, au.Value)

                            'possible retainer fee adjustment
                            If chkCollectUpdate.Checked Then
                                AccountHelper.AdjustRetainerFee(au.AccountID, ClientID, UserID, False, Pct, OldPct)
                            End If

                        Case "accountnumber"

                            Dim CreditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(au.AccountID)

                            UpdateCreditorInstance(CreditorInstanceID, au.Field, au.Type, au.Value)

                        Case "referencenumber"

                            Dim CreditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(au.AccountID)

                            UpdateCreditorInstance(CreditorInstanceID, au.Field, au.Type, au.Value)

                        Case "phonebusiness"

                            Dim CreditorID As Integer = AccountHelper.GetCurrentCreditorID(au.AccountID)

                            UpdateCreditorPhone(CreditorID, "Business", au.Value)

                        Case "phonebusinessfax"

                            Dim CreditorID As Integer = AccountHelper.GetCurrentCreditorID(au.AccountID)

                            UpdateCreditorPhone(CreditorID, "Business Fax", au.Value)

                    End Select

                Next
            Next
        End If

    End Sub
    Private Function UpdateInitialDeposit() As Boolean
        Dim objStore As New WCFClient.Store
        Dim err As String = ""
        Dim bankName As String

        dvErrorSetup.Style("display") = "none"

        If trInitialDepositInfo.Visible AndAlso txtInitialAmt.Enabled Then
            If IsNumeric(hdnAdhocAchID.Value) Then
                'Update their adhoc-ACH initial draft
                If objStore.RoutingIsValid(txtInitialRouting.Text, bankName) Then
                    Try
                        'If CDate(imInitialDepDate.Text) >= LocalHelper.AddBusinessDays(Now, 2) Then
                        SqlHelper.ExecuteNonQuery(String.Format("update tbladhocach set depositdate='{0}', depositamount={1}, bankname='{2}', bankroutingnumber='{3}', bankaccountnumber='{4}', lastmodified=getdate(), lastmodifiedby={5}, banktype='{7}' where adhocachid = {6} and (depositdate <> '{0}' or depositamount <> {1} or bankname <> '{2}' or bankroutingnumber <> '{3}' or bankaccountnumber <> '{4}' or banktype <> '{7}')", imInitialDepDate.Text, txtInitialAmt.Text, bankName, txtInitialRouting.Text, txtInitialAccount.Text, UserID, hdnAdhocAchID.Value, ddlInitialType.SelectedItem.Value), CommandType.Text)
                        'Else
                        '    err = "The date of initial desposit must be at least 2 business days from today."
                        'End If
                    Catch ex As Exception
                        err = "Error updating Initial Deposit Info. " & ex.Message
                    End Try
                Else
                    'Routing number Not found in the web service check, does the routing number exist in our database?
                    Dim ValidRouting As String = SqlHelper.ExecuteScalar(String.Format("SELECT RoutingNumber FROM tblRoutingNumber WHERE RoutingNumber = '{0}'", txtInitialRouting.Text), CommandType.Text)
                    If ValidRouting = Nothing Then
                        err = "The initial deposit Bank Routing Number you entered does not validate against the Federal ACH Directory."
                    Else
                        SqlHelper.ExecuteNonQuery(String.Format("update tbladhocach set depositdate='{0}', depositamount={1}, bankname='{2}', bankroutingnumber='{3}', bankaccountnumber='{4}', lastmodified=getdate(), lastmodifiedby={5}, banktype='{7}' where adhocachid = {6} and (depositdate <> '{0}' or depositamount <> {1} or bankname <> '{2}' or bankroutingnumber <> '{3}' or bankaccountnumber <> '{4}' or banktype <> '{7}')", imInitialDepDate.Text, txtInitialAmt.Text, bankName, txtInitialRouting.Text, txtInitialAccount.Text, UserID, hdnAdhocAchID.Value, ddlInitialType.SelectedItem.Value), CommandType.Text)
                    End If
                End If
            End If

            Try
                'Always update their initial draft info in tblClient
                SqlHelper.ExecuteNonQuery(String.Format("update tblclient set initialdraftdate = '{0}', initialdraftamount = {1} where clientid = {2}", imInitialDepDate.Text, txtInitialAmt.Text, ClientID), CommandType.Text)
            Catch ex As Exception
                err = "Error updating Initial Deposit Info. " & ex.Message
            End Try
        End If

        If Len(err) > 0 Then
            dvErrorSetup.Style("display") = ""
            tdErrorSetup.InnerHtml = err
        End If

        objStore = Nothing
        Return (err.Length = 0)
    End Function
    Private Sub UpdateAccount(ByVal AccountID As Integer, ByVal Field As String, ByVal Type As String, ByVal Value As String)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.Parameters.Add(GetParameter(Field, Type, Value))

            DatabaseHelper.BuildUpdateCommandText(cmd, "tblAccount", "AccountID = " & AccountID)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Private Sub UpdateCreditorInstance(ByVal CreditorInstanceID As Integer, ByVal Field As String, ByVal Type As String, ByVal Value As String)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.Parameters.Add(GetParameter(Field, Type, Value))

            DatabaseHelper.BuildUpdateCommandText(cmd, "tblCreditorInstance", _
                "CreditorInstanceID = " & CreditorInstanceID)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Private Sub UpdateCreditor(ByVal AccountID As Integer, ByVal Field As String, ByVal Type As String, ByVal Value As String)

        Dim CreditorID As Integer = AccountHelper.GetCurrentCreditorID(AccountID)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.Parameters.Add(GetParameter(Field, Type, Value))

            DatabaseHelper.BuildUpdateCommandText(cmd, "tblCreditor", "CreditorID = " & CreditorID)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Private Sub UpdateCreditorPhone(ByVal CreditorID As Integer, ByVal Type As String, ByVal Value As String)

        Dim PhoneTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPhoneType", _
            "PhoneTypeID", "Name = '" & Type & "'"))

        If Value.Length > 0 Then

            If PhoneTypeID = 0 Then
                PhoneTypeID = 32 'other
            End If

            Value = Value.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")

            Dim AreaCode As String = Value.Substring(0, 3)
            Dim Number As String = Value.Substring(3)

            'search for any instance of this phone record
            Dim PhoneID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPhone", "PhoneID", _
                "PhoneTypeID = " & PhoneTypeID & " AND AreaCode = '" & AreaCode & "' AND Number = '" _
                & Number & "'"))

            If Not PhoneID = 0 Then 'phone DOES exist

                'search for any instance of a link between this existing phone record and this creditor
                Dim CreditorPhoneID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblCreditorPhone", _
                    "CreditorPhoneID", "PhoneID = " & PhoneID & " AND CreditorID = " & CreditorID))

                If CreditorPhoneID = 0 Then 'phone exists, not for this creditor

                    'link existing phone record to this creditor
                    CreditorPhoneHelper.Insert(CreditorID, PhoneID, UserID)

                End If

            Else 'phone does NOT exist

                'delete any existing phone record for this creditor with the same phonetypeid
                CreditorHelper.DeletePhones(CreditorID, "PhoneTypeID = " & PhoneTypeID)

                'create new phone record
                PhoneID = PhoneHelper.InsertPhone(PhoneTypeID, AreaCode, Number, String.Empty, UserID)

                'link it to this creditor
                CreditorPhoneHelper.Insert(CreditorID, PhoneID, UserID)

            End If

        Else 'updating phone with empty vlaue

            'delete the existing phone record for this creditor of this phonetype
            CreditorHelper.DeletePhones(CreditorID, "PhoneTypeID = " & PhoneTypeID)

        End If

    End Sub
    Private Function GetParameter(ByVal Field As String, ByVal Type As String, ByVal Value As String) As SqlClient.SqlParameter

        Dim param As New SqlClient.SqlParameter()

        If Value.Length = 0 Then
            param.Value = DBNull.Value
        Else
            param.Value = Value
        End If

        Select Case Type.ToLower
            Case "byte"
                param.DbType = DbType.Byte
            Case "tinyint"
                param.DbType = DbType.Int16
            Case "int"
                param.DbType = DbType.Int32
            Case "bigint"
                param.DbType = DbType.Int64
            Case "char", "varchar", "nvarchar"
                param.DbType = DbType.String
            Case "bit"
                param.DbType = DbType.Boolean
            Case "money"
                param.DbType = DbType.Currency
        End Select

        param.ParameterName = "@" & Field
        param.SourceColumn = "[" + Field + "]"
        param.Direction = ParameterDirection.Input

        Return param
    End Function

    Protected Sub lnkReturn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReturn.Click
        ReturnToReferrer(True)
    End Sub

    Protected Sub btnSD_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSD.Click
        Me.debtcalculator.LoadData(Me.ClientID, True)
    End Sub

    Protected Sub btnCurrent_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCurrent.Click
        Me.debtcalculator.LoadData(Me.ClientID, False)
    End Sub

#Region "CID Functions"

    Protected Sub btnRefreshDocs_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnRefreshDocs.Click
        'EchoSignHelper.GetPendingLeadDocuments(CInt(hdnLeadApplicantID.Value))
        gvDocuments.DataBind()
    End Sub

    Protected Sub btnRefreshVerification_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnRefreshVerification.Click
        gvVerification.DataBind()
    End Sub

    Protected Sub lnkSubmitVerification_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSubmitVerification.Click
        Dim AccessNum As String = ""
        Dim Name As String = txtFirstName.Text & " " & txtLastName.Text
        Dim InitialDraftDate As String
        Dim InitialDraftAmount As Integer

        Try
            dvErrorSetup.Style("display") = "none" 'reset
            If Not Len(imHomePhone.Text.Replace("_", "")) = "14" Then Throw New Exception("Home Phone is required to submit a verification.")
            InitialDraftDate = CDate(imInitialDepDate.Text)
            InitialDraftAmount = CInt(txtInitialAmt.Text)

            ThreePVHelper.SendRequest(CInt(hdnLeadApplicantID.Value), CInt(hdnCompanyID.Value), CInt(cboStateID.SelectedItem.Value), Name, imHomePhone.Text, UserID, AccessNum, tdPVN.InnerHtml, InitialDraftDate, InitialDraftAmount)

            If AccessNum.Length = 10 Then
                tdAccessNum.InnerHtml = Left(AccessNum, 3) & "-" & Mid(AccessNum, 4, 3) & "-" & Right(AccessNum, 4)
            End If

            gvVerification.DataBind()
        Catch ex As Exception
            dvErrorSetup.Style("display") = ""
            tdErrorSetup.InnerHtml = ex.Message
        End Try

    End Sub

    Private Sub generateLSA(ByVal bElectronic As Boolean, Optional ByVal bUseLexxEsign As Boolean = False)
        Dim sBankName As String = ""
        Dim sBankRoutingNum As String = ""
        Dim sBankAcctNum As String = ""
        Dim typeOfAccount As String = "Checking"
        Dim sParalegalName As String = ""
        Dim sParaLegalTitle As String = ""
        Dim sParalegalExt As String = ""
        Dim leadApplicantID As Integer = CInt(hdnLeadApplicantID.Value)
        Dim StateID As Integer = cboStateID.SelectedValue
        Dim bOnlyTruth As Boolean = chkTruthInService.Checked
        Dim bOnlyFeeAddendum As Boolean = chkFeeAddendum.Checked

        Save(False, False)

        'get productid
        Dim monthlyFee As Integer = CInt(Drg.Util.DataAccess.DataHelper.FieldLookup("tblClient", "MonthlyFee", "ClientID=" & ClientID))
        Dim bShowFeeAddendum As Boolean
        Select Case monthlyFee
            Case 90
                bShowFeeAddendum = False
            Case Else
                bShowFeeAddendum = True
        End Select

        'get banking info
        Dim tblBanks As DataTable = SqlHelper.GetDataTable(String.Format("select top 1 bankaccountid, r.customername[bankname], b.routingnumber, b.accountnumber, case when b.banktype = 'C' then 'Checking' else 'Savings' end [banktype] from tblclientbankaccount b join tblroutingnumber r on r.routingnumber = b.routingnumber where clientid = {0} and b.disabled is null", ClientID))

        If tblBanks.Rows.Count > 0 Then
            sBankName = tblBanks.Rows(0)("bankname").ToString
            sBankRoutingNum = tblBanks.Rows(0)("routingnumber").ToString
            sBankAcctNum = tblBanks.Rows(0)("accountnumber").ToString
            typeOfAccount = tblBanks.Rows(0)("banktype").ToString
        End If

        Dim tblCalc As DataTable = SqlHelper.GetDataTable("select companyid, settlementfeepercentage*100[settlementfeepercentage], maintenancefeecap, monthlyfee, isnull(initialdraftamount,0)[initialdraftamount], initialdraftdate, depositday, depositamount, noaccts = (select count(*) from tblaccount a where a.clientid = c.clientid and removed is null and accountstatusid not in (54,55)) from tblclient c where c.clientid = " & ClientID)

        Dim CompanyID As Integer = CInt(tblCalc.Rows(0)("companyid"))
        Dim ContingencyFeePercent As Double = CDbl(tblCalc.Rows(0)("settlementfeepercentage"))
        Dim MaintFeeCap As Double = CDbl(If(IsDBNull(tblCalc.Rows(0)("maintenancefeecap")), 0, tblCalc.Rows(0)("maintenancefeecap")))
        Dim MaintFeePerAcct As Double = CDbl(tblCalc.Rows(0)("monthlyfee"))
        Dim InitialDepositAmount As Double = CDbl(tblCalc.Rows(0)("initialdraftamount"))
        Dim noAccts As Integer = CInt(tblCalc.Rows(0)("noaccts"))
        Dim DepositDay As String = getNth(CStr(tblCalc.Rows(0)("depositday")))
        Dim DepositCommitmentAmount As Double = CDbl(tblCalc.Rows(0)("depositamount"))
        Dim InitialDepositDate As String = Now.AddDays(3)

        If IsDate(tblCalc.Rows(0)("initialdraftdate")) Then
            InitialDepositDate = FormatDateTime(CDate(tblCalc.Rows(0)("initialdraftdate")), DateFormat.ShortDate)
        End If

        'get agent info from I3 db
        Dim sqlParalegal As String = String.Format("stp_SmartDebtor_GetAgentInfoFromUserID {0}", UserID)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlParalegal.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each row As DataRow In dt.Rows
                sParalegalName = row("ParaLegalName").ToString
                sParaLegalTitle = "Law Firm Representative"
                sParalegalExt = row("ParaLegalExt").ToString
            Next
        End Using

        Dim rpt As New LexxiomLetterTemplates.LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)

        If bElectronic Then
            Dim tblBorrowers As DataTable = CredStarHelper.GetBorrowers(leadApplicantID)
            Dim bHasCoApplicant As Boolean = (tblBorrowers.Rows.Count > 1)

            Select Case bUseLexxEsign
                Case True
                    'holds returned documents to process
                    Dim docList As List(Of LetterTemplates.BatchTemplate)

                    'generate documents
                    docList = rpt.Generate_SM_LSA_v3_LexxiomEsign(CompanyID:=CompanyID, StateID:=StateID, ContingencyFeePercent:=ContingencyFeePercent, _
                      MaintenanceFeeCap:=MaintFeeCap, MaintenanceFeePerAccount:=MaintFeePerAcct, BankName:=sBankName, _
                      BankRoutingNum:=sBankRoutingNum, BankAcctNum:=sBankAcctNum, InitialDepositAmount:=InitialDepositAmount, _
                      DepositDay:=DepositDay, DepositCommitmentAmount:=FormatCurrency(DepositCommitmentAmount, 2), _
                      TypeOfAccount:=typeOfAccount, ClientFirstName:=txtFirstName.Text, ClientLastName:=txtLastName.Text, _
                      ClientAddr1:=txtStreet1.Text, ClientAddr2:=txtStreet2.Text, ClientCSZ:=txtCity.Text & ", " & cboStateID.SelectedItem.Text & Space(1) & txtZipCode.Text, _
                      ParalegalName:=sParalegalName, ParalegalTitle:=sParaLegalTitle, ParalegalExt:=sParalegalExt, _
                      NumberOfAccounts:=noAccts, bShowFormLetter:=chkFormLetter.Checked, InitialDepositDate:=InitialDepositDate, _
                      LeadApplicantID:=leadApplicantID, bShowVoidedCheck:=chkVoidedCheck.Checked, bOnlyShowScheduleA:=chkOnlyScheduleA.Checked, bOnlyShowVoidedCheck:=chkOnlyVoidedCheck.Checked, bOnlyShowTruthInService:=bOnlyTruth, _
                      bElectronic:=bElectronic, HasCoApps:=bHasCoApplicant, bShowFeeAddendum:=bShowFeeAddendum, bOnlyFeeAddendum:=bOnlyFeeAddendum)

                    'get new unique signing batch id
                    Dim signingBatchId As String = Guid.NewGuid.ToString

                    'stores the names of the reports
                    Dim dNames As New List(Of String)

                    'needed to check for duplicate documents
                    Dim docIDs As New Hashtable

                    'only get documents that need signatures
                    Dim nosign = From doc As LetterTemplates.BatchTemplate In docList Where Not doc.TemplateName.StartsWith("Signing") Select doc
                    For Each doc As LetterTemplates.BatchTemplate In nosign
                        'assign new doc  id
                        Dim documentId As String = Guid.NewGuid.ToString
                        docIDs.Add(doc.TemplateName.Replace("Signing_", ""), documentId)

                        'export html docs for gui navigation
                        Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.html", documentId)
                        Using finalHTML As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                            finalHTML.OutputType = GrapeCity.ActiveReports.Export.Html.HtmlOutputType.DynamicHtml
                            finalHTML.IncludeHtmlHeader = False
                            finalHTML.IncludePageMargins = False
                            finalHTML.Export(doc.TemplateRpt.Document, path)
                        End Using

                        'need matching pdf for final signing process
                        If Not doc.NeedSignature Then
                            path = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", documentId)
                            Using finalPDF As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                                finalPDF.Export(doc.TemplateRpt.Document, path)
                            End Using
                        End If

                        'save document to db
                        SmartDebtorHelper.SaveLeadDocument(leadApplicantID, documentId, UserID, doc.TemplateType, signingBatchId, txtEmailAddress.Text)
                        dNames.Add(doc.TemplateName)
                    Next

                    Dim needsign = From doc As LetterTemplates.BatchTemplate In docList Where doc.TemplateName.StartsWith("Signing") Select doc
                    For Each doc As LetterTemplates.BatchTemplate In needsign
                        Dim templateName As String = doc.TemplateName.Replace("Signing_", "")
                        If docIDs.Contains(templateName) Then
                            Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", docIDs(templateName))
                            Using finalPDF As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                                finalPDF.Export(doc.TemplateRpt.Document, path.Replace(".html", ".pdf"))
                            End Using
                        End If
                    Next

                    'send notification to client
                    SmartDebtorHelper.SendEsignNotification(txtEmailAddress.Text, dNames.ToArray, signingBatchId, UserID)

                Case Else
                    Dim rDocs As Collections.Generic.Dictionary(Of String, GrapeCity.ActiveReports.SectionReport) = rpt.Generate_SM_LSA_v3_EchoSign(CompanyID:=CompanyID, StateID:=StateID, ContingencyFeePercent:=ContingencyFeePercent, _
                                  MaintenanceFeeCap:=MaintFeeCap, MaintenanceFeePerAccount:=MaintFeePerAcct, BankName:=sBankName, _
                                  BankRoutingNum:=sBankRoutingNum, BankAcctNum:=sBankAcctNum, InitialDepositAmount:=InitialDepositAmount, _
                                  DepositDay:=DepositDay, DepositCommitmentAmount:=FormatCurrency(DepositCommitmentAmount, 2), _
                                  TypeOfAccount:=typeOfAccount, ClientFirstName:=txtFirstName.Text, ClientLastName:=txtLastName.Text, _
                                  ClientAddr1:=txtStreet1.Text, ClientAddr2:="", ClientCSZ:=txtCity.Text & ", " & cboStateID.SelectedItem.Text & Space(1) & txtZipCode.Text, _
                                  ParalegalName:=sParalegalName, ParalegalTitle:=sParaLegalTitle, ParalegalExt:=sParalegalExt, _
                                  NumberOfAccounts:=noAccts, bShowFormLetter:=chkFormLetter.Checked, InitialDepositDate:=InitialDepositDate, _
                                  LeadApplicantID:=leadApplicantID, bShowVoidedCheck:=chkVoidedCheck.Checked, bOnlyShowScheduleA:=chkOnlyScheduleA.Checked, bOnlyShowVoidedCheck:=chkOnlyVoidedCheck.Checked, _
                                  bElectronic:=True, bHasCoApplicant:=bHasCoApplicant, bOnlyShowTruthInService:=bOnlyTruth, LoggedInUserID:=UserID, _
                                  bShowFeeAddendum:=bShowFeeAddendum, bOnlyFeeAddendum:=bOnlyFeeAddendum)

                    Dim recipients As String = txtEmailAddress.Text

                    If Not chkOnlyVoidedCheck.Checked Then
                        For i As Integer = 1 To tblBorrowers.Rows.Count - 1
                            recipients &= "," & tblBorrowers.Rows(i)("email")
                        Next
                    End If

                    Dim documentId As String = "100001"
                    'need to be getting multiple doc ids back and calling saveleaddoc for each..
                    SmartDebtorHelper.SaveLeadDocument(leadApplicantID, documentId, UserID, SmartDebtorHelper.DocType.LSA, txtEmailAddress.Text)
            End Select

            gvDocuments.DataBind()
        Else 'Printed

            Dim rDoc As GrapeCity.ActiveReports.Document.SectionDocument = rpt.Generate_SM_LSA_v3(CompanyID:=CompanyID, StateID:=StateID, ContingencyFeePercent:=ContingencyFeePercent, _
              MaintenanceFeeCap:=MaintFeeCap, MaintenanceFeePerAccount:=MaintFeePerAcct, BankName:=sBankName, _
              BankRoutingNum:=sBankRoutingNum, BankAcctNum:=sBankAcctNum, InitialDepositAmount:=InitialDepositAmount, _
              DepositDay:=DepositDay, DepositCommitmentAmount:=FormatCurrency(DepositCommitmentAmount, 2), _
              TypeOfAccount:=typeOfAccount, ClientFirstName:=txtFirstName.Text, ClientLastName:=txtLastName.Text, _
              ClientAddr1:=txtStreet1.Text, ClientAddr2:="", ClientCSZ:=txtCity.Text & ", " & cboStateID.SelectedItem.Text & Space(1) & txtZipCode.Text, _
              ParalegalName:=sParalegalName, ParalegalTitle:=sParaLegalTitle, ParalegalExt:=sParalegalExt, _
              NumberOfAccounts:=noAccts, bShowFormLetter:=chkFormLetter.Checked, InitialDepositDate:=InitialDepositDate, _
              LeadApplicantID:=leadApplicantID, bShowVoidedCheck:=chkVoidedCheck.Checked, bOnlyShowScheduleA:=chkOnlyScheduleA.Checked, _
              bOnlyShowVoidedCheck:=chkOnlyVoidedCheck.Checked, bOnlyShowTruthInService:=bOnlyTruth, LoggedInUserID:=UserID, _
              bShowFeeAddendum:=bShowFeeAddendum, bOnlyFeeAddendum:=bOnlyFeeAddendum)

            Dim memStream As New System.IO.MemoryStream()
            Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport

            pdf.Export(rDoc, memStream)
            memStream.Seek(0, IO.SeekOrigin.Begin)

            Session("LSAAgreement") = memStream.ToArray

            Dim _sb As New System.Text.StringBuilder()
            _sb.Append("window.open('../enrollment/viewLSA.aspx?type=lsa','',")
            _sb.Append("'toolbar=0,menubar=0,resizable=yes');")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)
        End If

    End Sub

    Public Function SetCurrentStatus(ByVal docId As String, ByVal status As String) As String
        If status.ToLower = "document signed" Then
            Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString
            Return String.Format("<a href='{0}{1}.pdf' target='_blank' style='text-decoration:underline' title='Click to view'>{2}</a>", path, docId, status)
        Else
            Return status
        End If
    End Function

    Protected Sub gvDocuments_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDocuments.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If IsDate(e.Row.Cells(2).Text) Then
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Style.Item("color") = "#000"
                Next
            End If
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            e.Row.ToolTip = rowView("documentName")

        End If
    End Sub

    Protected Sub gvVerification_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVerification.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If IsDate(e.Row.Cells(3).Text) Then
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Style.Item("color") = "#000"
                Next
            End If
        End If
    End Sub

    Protected Sub grdVerification_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdVerification.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If IsDate(e.Row.Cells(2).Text) Then
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Style.Item("color") = "#000"
                Next
            End If
            Dim dv As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim img As HtmlImage = CType(e.Row.Cells(5).FindControl("ImgRec"), HtmlImage)
            Dim aAnchor As HtmlAnchor = CType(e.Row.Cells(5).FindControl("aRecFile"), HtmlAnchor)
            img.Visible = (Not dv("RecCallIdKey") Is DBNull.Value AndAlso dv("RecCallIdKey").ToString.Trim.Length > 0)
            If Not dv("RecordedCallPath") Is DBNull.Value AndAlso dv("RecordedCallPath").ToString.Trim.Length > 0 Then
                img.Src = "~/images/wav_rec.png"
                aAnchor.HRef = dv("RecordedCallPath").ToString.Trim
            Else
                img.Src = "~/images/wav_dis.png"
                aAnchor.HRef = "#"
            End If
        End If
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

    Private Function VerificationComplete() As Boolean
        Dim bComplete As Boolean

        dvErrorSecondary.Style("display") = "none" 'reset
        gvVerification.DataBind() 'in case a verification came in and they didnt refresh the grid

        bComplete = HasCompletedVerification()

        If Not bComplete Then
            dvErrorSecondary.Style("display") = ""
            tdErrorSecondary.InnerHtml = "Verification completion required to resolve this client."
        End If

        Return bComplete
    End Function

    Private Function HasCompletedVerification() As Boolean
        Dim use3PV As Boolean = IIf(hdnUse3PV.Value = "1", True, False)

        If use3PV Then
            For Each row As GridViewRow In gvVerification.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    If IsDate(row.Cells(3).Text) Then
                        Return True
                    End If
                End If
            Next
        Else
            For Each row As GridViewRow In grdVerification.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    If IsDate(row.Cells(2).Text) Then
                        Return True
                    End If
                End If
            Next
        End If
        Return False
    End Function

    Protected Sub lnkReturnToCID_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReturnToCID.Click
        Try
            dvErrorReceived.Style("display") = "none" 'reset
            If Trim(txtReturnNotes.Text).Length = 0 Then
                Throw New Exception("Notes are required to return a client to CID.")
            End If
            Save(False, False)
            UpdateLeadApplicant()
            UpdateLeadCoApplicant()
            SmartDebtorHelper.ReturnToCID(CInt(hdnLeadApplicantID.Value), txtReturnNotes.Text, 23, UserID)
            Response.Redirect("../../default.aspx", False)
        Catch ex As Exception
            dvErrorReceived.Style("display") = ""
            tdErrorReceived.InnerHtml = ex.Message
        End Try
    End Sub

    Private Sub UpdateLeadApplicant()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName.Text)
            DatabaseHelper.AddParameter(cmd, "LastName", txtLastName.Text)
            DatabaseHelper.AddParameter(cmd, "FullName", txtFirstName.Text & " " & txtLastName.Text)
            DatabaseHelper.AddParameter(cmd, "Address1", txtStreet1.Text)
            DatabaseHelper.AddParameter(cmd, "City", txtCity.Text)
            DatabaseHelper.AddParameter(cmd, "StateID", ListHelper.GetSelected(cboStateID))
            DatabaseHelper.AddParameter(cmd, "ZipCode", txtZipCode.Text)
            DatabaseHelper.AddParameter(cmd, "DOB", DataHelper.Zn(imDateOfBirth.Text), DbType.DateTime)
            DatabaseHelper.AddParameter(cmd, "SSN", DataHelper.Zn(imSSN.Text))
            DatabaseHelper.AddParameter(cmd, "Email", DataHelper.Zn(txtEmailAddress.Text))
            DatabaseHelper.AddParameter(cmd, "HomePhone", imHomePhone.Text)
            DatabaseHelper.AddParameter(cmd, "BusinessPhone", imBusinessPhone.Text)
            DatabaseHelper.AddParameter(cmd, "CellPhone", imCellPhone.Text)
            DatabaseHelper.AddParameter(cmd, "FaxNumber", imHomeFax.Text)
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedByID", DataHelper.Nz_int(UserID))
            DatabaseHelper.BuildUpdateCommandText(cmd, "tblLeadApplicant", "LeadApplicantID = " & hdnLeadApplicantID.Value)
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub UpdateLeadCoApplicant()
        Dim LeadCoApplicantID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblLeadCoApplicant", "LeadCoApplicantID", "LeadApplicantID = " & hdnLeadApplicantID.Value))

        If LeadCoApplicantID > 0 Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName2.Text)
                DatabaseHelper.AddParameter(cmd, "LastName", txtLastName2.Text)
                'DatabaseHelper.AddParameter(cmd, "FullName", txtFirstName2.Text & " " & txtLastName2.Text)
                DatabaseHelper.AddParameter(cmd, "Address", txtStreet12.Text)
                DatabaseHelper.AddParameter(cmd, "City", txtCity2.Text)
                DatabaseHelper.AddParameter(cmd, "StateID", ListHelper.GetSelected(cboStateID2))
                DatabaseHelper.AddParameter(cmd, "ZipCode", txtZipCode2.Text)
                DatabaseHelper.AddParameter(cmd, "DOB", DataHelper.Zn(imDateOfBirth2.Text), DbType.DateTime)
                DatabaseHelper.AddParameter(cmd, "SSN", DataHelper.Zn(imSSN2.Text))
                DatabaseHelper.AddParameter(cmd, "Email", DataHelper.Zn(txtEmailAddress2.Text))
                DatabaseHelper.AddParameter(cmd, "HomePhone", imHomePhone2.Text)
                DatabaseHelper.AddParameter(cmd, "BusPhone", imBusinessPhone2.Text)
                DatabaseHelper.AddParameter(cmd, "CellPhone", imCellPhone2.Text)
                DatabaseHelper.AddParameter(cmd, "FaxNumber", imHomeFax2.Text)
                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedByID", DataHelper.Nz_int(UserID))
                DatabaseHelper.BuildUpdateCommandText(cmd, "tblLeadCoApplicant", "LeadCoApplicantID = " & LeadCoApplicantID)
                Using cmd.Connection
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        End If
    End Sub

#End Region

    Protected Sub ImgRefreshVerif_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgRefreshVerif.Click
        Me.LoadNewVerification()
    End Sub

    Protected Sub lnkGo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGo.Click
        Dim bLexx As Boolean = False
        Select Case rblSignChoice.SelectedItem.Value.ToLower
            Case "lexx"
                bLexx = True
            Case Else
                bLexx = False
        End Select
        generateLSA(True, bLexx)
    End Sub

    Protected Sub lnkGenerate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGenerate.Click
        generateLSA(chkElectronicLSA.Checked)
    End Sub
    Protected Sub lnkVerificationCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerificationCall.Click
        'Validate 1rst Deposit
        Dim InitialDraftDate As DateTime
        Dim InitialDraftAmount As Double
        If hdnLeadApplicantID.Value.Length > 0 Then
            dvErrorSetup.Style("display") = "none"
            tdErrorSetup.InnerHtml = ""
            Try
                'Check if past date
                If imInitialDepDate.Text.Trim.Length > 0 Then
                    InitialDraftDate = CDate(imInitialDepDate.Text)
                    If LocalHelper.AddBusinessDays(InitialDraftDate, -2) < Date.Today Then
                        Throw New Exception("Cannot start the verification call because the initial deposit date entered has been processed already. The date must be at least 2 business days from today.")
                    End If
                Else
                    Throw New Exception("Cannot start the verification call because the initial deposit date is not entered.")
                End If
                InitialDraftAmount = CDbl(txtInitialAmt.Text)
                If InitialDraftAmount <= 0 Then Throw New Exception("Cannot start the verification call because the initial draft amount is invalid.")

                Save(False, False)

                ScriptManager.RegisterStartupScript(Page, Page.GetType, "sbmtverif", "submitCallVerification();", True)
            Catch ex As Exception
                dvErrorSetup.Style("display") = ""
                tdErrorSetup.InnerHtml = ex.Message
            End Try
        End If
    End Sub

    Protected Sub chkWelcomeCallLtrNeeded_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkWelcomeCallLtrNeeded.CheckedChanged
        Dim ssql As String = String.Format("update tblclient set WelcomeCallLetterNeeded = {0} where clientid = {1}", IIf(chkWelcomeCallLtrNeeded.Checked, 1, 0), ClientID)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
    End Sub

End Class