Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO

Partial Class clients_client_dataentry
    Inherits System.Web.UI.Page

#Region "Variables"

    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer
    Private ClientStatusID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then

                LoadRecord()
                LoadPrimaryPerson()
                LoadSecondaryPerson()

                SetAttributes()

            End If

            ClientStatusID = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CurrentClientStatusID", "ClientID=" & ClientID))
            If ClientStatusID = 23 Then
                tdSendBackToAgency.Visible = True
            Else
                tdSendBackToAgency.Visible = False
            End If
        End If

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
        chkReceivedLSA.Attributes("dvErr") = dvErrorReceived.ClientID
        chkReceivedDeposit.Attributes("dvErr") = dvErrorReceived.ClientID

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
        txtBankName.Attributes("dvErr") = dvErrorSetup.ClientID
        txtBankCity.Attributes("dvErr") = dvErrorSetup.ClientID
        cboBankStateID.Attributes("dvErr") = dvErrorSetup.ClientID
        imDepositStartDate.Attributes("dvErr") = dvErrorSetup.ClientID

    End Sub
    Private Sub SetControls(ByVal Enabled As Boolean)

        chkReceivedLSA.Disabled = Not Enabled
        chkReceivedDeposit.Disabled = Not Enabled

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
        txtBankName.Enabled = Enabled
        txtBankCity.Enabled = Enabled
        cboBankStateID.Enabled = Enabled
        imDepositStartDate.Enabled = Enabled
        monthlyFee.Enabled = Enabled

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

                        chkReceivedLSA.Checked = DatabaseHelper.Peel_bool(rd, "ReceivedLSA")
                        chkReceivedDeposit.Checked = DatabaseHelper.Peel_bool(rd, "ReceivedDeposit")

                        'fill ddl's and set selected
                        LoadBankStates(DatabaseHelper.Peel_int(rd, "BankStateID"))

                        Dim TrustID As Integer = DatabaseHelper.Peel_int(rd, "TrustID")
                        Dim AgencyID As Integer = DatabaseHelper.Peel_int(rd, "AgencyID")
                        Dim CompanyID As Integer = DatabaseHelper.Peel_int(rd, "CompanyID")

                        If Not TrustID = 0 Then
                            lblTrustName.Text = DataHelper.FieldLookup("tblTrust", "Name", "TrustID = " & TrustID)
                        End If

                        If Not AgencyID = 0 Then
                            lblAgencyName.Text = DataHelper.FieldLookup("tblAgency", "Name", "AgencyID = " & AgencyID)
                        End If

                        If Not CompanyID = 0 Then
                            lblCompanyName.Text = DataHelper.FieldLookup("tblCompany", "Name", "CompanyID = " & CompanyID)
                        End If

                        ListHelper.SetSelected(cboDepositMethod, DatabaseHelper.Peel_string(rd, "DepositMethod"))
                        txtDepositAmount.Text = DatabaseHelper.Peel_double(rd, "DepositAmount").ToString("###0.00")
                        ListHelper.SetSelected(cboDepositDay, DatabaseHelper.Peel_int(rd, "DepositDay"))
                        txtRoutingNumber.Text = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                        txtAccountNumber.Text = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                        cboBankType.SelectedValue = DatabaseHelper.Peel_string(rd, "BankType")
                        txtBankName.Text = DatabaseHelper.Peel_string(rd, "BankName")
                        txtBankCity.Text = DatabaseHelper.Peel_string(rd, "BankCity")
                        imDepositStartDate.Text = DatabaseHelper.Peel_datestring(rd, "DepositStartDate", "MM/dd/yyyy")
                        ListHelper.SetSelected(monthlyFee, DatabaseHelper.Peel_decimal(rd, "MonthlyFee").ToString("F"))

                        Dim Saved As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "VWDESaved")
                        Dim SavedBy As Integer = DatabaseHelper.Peel_int(rd, "VWDESavedBy")
                        Dim Resolved As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "VWDEResolved")
                        Dim ResolvedBy As Integer = DatabaseHelper.Peel_int(rd, "VWDEResolvedBy")

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

                            If Saved.HasValue Then 'HAS been saved before

                                lblInfoBox.Text = "This verification worksheet was never resolved but has been " _
                                    & "filled out and saved already by " & SavedByName & " on " _
                                    & Saved.Value.ToString("MMM d, yyyy") & " at " _
                                    & Saved.Value.ToString("h:mm tt") & ".  Please fill in any other " _
                                    & "necessary data and resolve this worksheeet."

                            Else 'has NOT been saved before

                                If UserHelper.HasPosition(UserID, 5) Then 'IS data entry person

                                    lblInfoBox.Text = "You are viewing this worksheet because you are " _
                                        & "a data entry user.  This client was recently " _
                                        & "screened and needs this worksheet to be resolved before " _
                                        & "Verification can conduct a welcome interview.  None of the " _
                                        & "fields are required.  Only enter or modify what you know."

                                Else 'is NOT data entry person

                                    lblInfoBox.Text = "You are not a data entry user, but this client was recently " _
                                        & "screened and needs this worksheet to be resolved before " _
                                        & "Verification can conduct a welcome interview.  None of the " _
                                        & "fields are required.  Only enter or modify what you know."

                                End If

                            End If

                        End If

                    End If

                End Using
            End Using
        End Using

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

            ''select top other applicant - sorting first by the spouse
            'cmd.CommandText = "SELECT * FROM tblPerson WHERE ClientID = @ClientID AND NOT " _
            '    & "Relationship = 'Prime' ORDER BY (CASE Relationship WHEN 'Spouse' THEN 1 ELSE 0 END) DESC"

            'select spouse
            cmd.CommandText = "SELECT * FROM tblPerson WHERE ClientID = @ClientID AND Relationship = 'Spouse'"

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

        Dim Accounts As New List(Of Account)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Accounts.Add(New Account(DatabaseHelper.Peel_int(rd, "AccountID"), _
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
                    DatabaseHelper.Peel_string(rd, "SettledByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        LoadAccountsGrid(Accounts)

    End Sub
    Private Sub LoadAccountsGrid(ByVal Accounts As List(Of Account))

        'create grid and write in values
        Dim sb As New StringBuilder

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
        sb.Append(" </colgroup>")
        sb.Append(" <thead>")
        sb.Append("     <tr>")
        sb.Append("         <th class=""first""><div class=""header""><div class=""header2"">&nbsp;</div></div></th>")
        sb.Append("         <th isReq=""true"" fieldName=""CreditorName"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Creditor Name</div></div></th>")
        sb.Append("         <th><div class=""header""><div style=""text-align:center;""><img src=""" & ResolveUrl("~/images/13x13_search.png") & """ absmiddle=""align"" border=""0"" /></div></div></th>")
        sb.Append("         <th fieldName=""ForName"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>For</div></div></th>")
        sb.Append("         <th><div class=""header""><div style=""text-align:center;""><img src=""" & ResolveUrl("~/images/13x13_search.png") & """ absmiddle=""align"" border=""0"" /></div></div></th>")
        sb.Append("         <th fieldName=""Amount"" fieldType=""money"" useVal=""true"" valFun=""IsValidCurrency"" mode=""txt"" control=""0""><div class=""header""><div style=""text-align:right;padding-right:5;"">Amount</div></div></th>")
        sb.Append("         <th fieldName=""AccountNumber"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Account No.</div></div></th>")
        sb.Append("         <th fieldName=""ReferenceNumber"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div>Reference No.</div></div></th>")
        sb.Append("         <th fieldName=""Street"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""Street2"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""City"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""StateID"" fieldType=""int"" mode=""ddl"" control=""1""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""ZipCode"" fieldType=""varchar"" mode=""txt"" control=""0""><div class=""header""><div></div></div></th>")
        sb.Append("         <th fieldName=""PhoneBusiness"" fieldType=""varchar"" useVal=""true"" valFun=""IsValidTextPhoneNumber"" mode=""txt"" control=""0""><div class=""header""><div>Phone</div></div></th>")
        sb.Append("         <th fieldName=""PhoneBusinessFax"" fieldType=""varchar"" useVal=""true"" valFun=""IsValidTextPhoneNumber"" mode=""txt"" control=""0""><div class=""header""><div>Fax</div></div></th>")
        sb.Append("     </tr>")
        sb.Append(" </thead>")
        sb.Append(" <tbody>")

        Dim c As Integer = 1

        'loop the persons list and write rows
        For Each a As Account In Accounts

            sb.Append(" <tr key=""" & a.AccountID & """>")
            sb.Append("     <th onclick=""Grid_RH_OnClick(this);""><div>" & c & "</div></th>")
            sb.Append("     <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">" & PadForEmpty(a.CreditorName) & "</div></td>")
            sb.Append("     <td align=""center""><div><button style=""font-size:11;width:15;height:15;"" onclick=""FindCreditor(this);"">&nbsp;</button></div></td>")
            sb.Append("     <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">" & PadForEmpty(a.ForCreditorName) & "</div></td>")
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

            sb.Append(" </tr>")

            c += 1

        Next

        ' add the new record row
        sb.Append("     <tr key=""*"">")
        sb.Append("         <th onclick=""Grid_RH_OnClick(this);""><div>*</div></th>")
        sb.Append("         <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">&nbsp;</div></td>")
        sb.Append("         <td align=""center""><div><button style=""font-size:11;width:15;height:15;"" onclick=""FindCreditor(this);"">&nbsp;</button></div></td>")
        sb.Append("         <td onclick=""Grid_TD_OnClick(this);""><div nowrap=""true"">&nbsp;</div></td>")
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
        sb.Append("     </tr>")

        'finish off the bottom footer
        sb.Append("     <tr>")
        sb.Append("         <td colspan=""13"" style=""height:25;""></td>")
        sb.Append("     </tr>")
        sb.Append(" </tbody>")
        sb.Append("</table>")

        'add to grid div
        grdAccounts.InnerHtml = sb.ToString() & grdAccounts.InnerHtml & GetDropDownListsForAccounts()

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
    Private Sub Save(ByVal Resolving As Boolean)

        'create all accounts
        UpdateAccounts()
        InsertAccounts()
        DeleteAccounts()

        'nudge all accounts for fees
        AccountHelper.AdjustRetainerFees(ClientID, UserID)

        'save client info
        UpdateClient(Resolving)

        'save applicants
        UpdatePrimaryApplicant()
        UpdateSecondaryApplicant()

        'do roadmap propagations - no roadmap entry can be entered more then once
        If chkReceivedLSA.Checked Then
            RoadmapHelper.InsertRoadmap(ClientID, 7, Nothing, UserID)
        End If

        If chkReceivedDeposit.Checked Then
            RoadmapHelper.InsertRoadmap(ClientID, 8, Nothing, UserID)
        End If

        If Resolving Then
            SetupUnderwriting()
        End If

        'update search results table for this client
        ClientHelper.LoadSearch(ClientID)

        ReturnToReferrer(Resolving)

    End Sub

    Private Sub SetupUnderwriting()

        'insert roadmap for "started underwriting"
        RoadmapHelper.InsertRoadmap(ClientID, 10, Nothing, UserID)

        Dim AssignedUnderwriter As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", _
            "AssignedUnderwriter", "ClientID = " & ClientID))

        'setup welcome interview task
        Dim TaskTypeID As Integer = 4

        Dim Description As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", _
            "TaskTypeID = " & TaskTypeID)

        'get current roadmap location
        Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(ClientID, Now, _
            "RoadmapID"))

        Dim TaskDue As DateTime = LocalHelper.AddBusinessDays(Now, DataHelper.Nz_int(PropertyHelper.Value("DaysTillLSAFollowupDue")))
        If AssignedUnderwriter = 0 Then 'no assigned underwriter

            'get this client's preferred language
            Dim LanguageID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", _
                "LanguageID", "PersonID = " & ClientHelper.GetDefaultPerson(ClientID)))

            'get the next underwriter who speaks this language
            Dim UnderwriterUserID As Integer = UserHelper.GetNextUser(LanguageID, 2)

            'send task to newly assigned underwriter
            TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, _
                UnderwriterUserID, TaskDue, UserID)

            'assign underwriter on client record
            ClientHelper.UpdateField(ClientID, "AssignedUnderwriter", UnderwriterUserID, UserID)

        Else 'HAS assigned underwriter

            'just resend the task to the already-assigned underwriter
            TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, _
                AssignedUnderwriter, TaskDue, UserID)

        End If

        'setup account number if doesn't have one
        'If DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & ClientID).Length = 0 Then

        '    Dim Value As Long = DataHelper.Nz_long(PropertyHelper.Value("AccountNumberValue"))
        '    Dim Prefix As String = PropertyHelper.Value("AccountNumberPrefix")
        '    Dim PadLength As Integer = DataHelper.Nz_int(PropertyHelper.Value("AccountNumberPadLength"))
        '    Dim PadCharacter As String = PropertyHelper.Value("AccountNumberPadCharacter")

        '    Dim AccountNumber As String = Prefix & Value.ToString.PadLeft(PadLength, PadCharacter)

        '    'make sure this number isn't in use
        '    'If AccountNumberExists(AccountNumber, ClientID) Then
        '    '    AccountNumber = GetNextAccountNumber(AccountNumber)
        '    'End If

        '    ''update client record with accountnumber
        '    'ClientHelper.UpdateField(ClientID, "AccountNumber", AccountNumber, UserID)

        '    ''get a new account number and update the properties table
        '    'PropertyHelper.Update("AccountNumberValue", GetNextAccountNumber(AccountNumber), UserID)
        'End If
        If DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & ClientID).Length = 0 Then
            'make sure this number isn't in use
            Dim AccountNumber As String = GetNextAccountNumber(AccountNumber)
            'update client record with accountnumber
            ClientHelper.UpdateField(ClientID, "AccountNumber", AccountNumber, UserID)

            CreateDirForClient(ClientID)
        End If

    End Sub

    Private Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String

        Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    reader.Read()
                    rootDir = "\\" + DatabaseHelper.Peel_string(reader, "StorageServer") + "\" + DatabaseHelper.Peel_string(reader, "StorageRoot") + "\" + DatabaseHelper.Peel_string(reader, "AccountNumber") + "\"
                End Using

                If Not System.IO.Directory.Exists(rootDir) Then
                    Directory.CreateDirectory(rootDir)
                    cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder ORDER BY [Name] ASC"
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Directory.CreateDirectory(rootDir + DatabaseHelper.Peel_string(reader, "Name"))
                        End While
                    End Using
                End If
            End Using
        End Using

        Return rootDir
    End Function

    Public Sub ReturnToReferrer(ByVal Resolving As Boolean)

        Dim Navigator As Navigator = CType(Page.Master, Site).Navigator

        Dim i As Integer = Navigator.Pages.Count - 1

        If Resolving Then 'don't restrict going back to client home page

            While i >= 0 AndAlso Not Navigator.Pages(i).Url.IndexOf("dataentry.aspx") = -1 'not found

                'decrement i
                i -= 1

            End While

        Else 'restrict going back to client home page

            While i >= 0 AndAlso (Not Navigator.Pages(i).Url.IndexOf("client/default.aspx") = -1 _
                Or Not Navigator.Pages(i).Url.IndexOf("client/dataentry.aspx") = -1)

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

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "ReceivedLSA", chkReceivedLSA.Checked)
            DatabaseHelper.AddParameter(cmd, "ReceivedDeposit", chkReceivedDeposit.Checked)

            DatabaseHelper.AddParameter(cmd, "DepositMethod", DataHelper.Zn(cboDepositMethod.SelectedValue))
            DatabaseHelper.AddParameter(cmd, "DepositAmount", DataHelper.Zn(DataHelper.Nz_double(txtDepositAmount.Text)), DbType.Double)
            DatabaseHelper.AddParameter(cmd, "DepositDay", ListHelper.GetSelected(cboDepositDay), DbType.Int32)
            DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(txtBankName.Text))
            DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", DataHelper.Zn(txtRoutingNumber.Text))
            DatabaseHelper.AddParameter(cmd, "BankAccountNumber", DataHelper.Zn(txtAccountNumber.Text))
            DatabaseHelper.AddParameter(cmd, "BankCity", DataHelper.Zn(txtBankCity.Text))
            DatabaseHelper.AddParameter(cmd, "BankStateID", ListHelper.GetSelected(cboBankStateID))
            DatabaseHelper.AddParameter(cmd, "DepositStartDate", DataHelper.Zn(imDepositStartDate.Text), DbType.DateTime)
            DatabaseHelper.AddParameter(cmd, "monthlyFee", DataHelper.Zn_double(monthlyFee.SelectedValue), DbType.Decimal)

            If cboBankType.SelectedValue = "0" Then
                DatabaseHelper.AddParameter(cmd, "BankType", DBNull.Value, DbType.String)
            Else
                DatabaseHelper.AddParameter(cmd, "BankType", cboBankType.SelectedValue, DbType.String)
            End If

            DatabaseHelper.AddParameter(cmd, "VWDESaved", Now)
            DatabaseHelper.AddParameter(cmd, "VWDESavedBy", UserID)

            If Resolving Then

                DatabaseHelper.AddParameter(cmd, "VWDEResolved", Now)
                DatabaseHelper.AddParameter(cmd, "VWDEResolvedBy", UserID)

            End If

            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

            DataHelper.AuditedUpdate(cmd, "tblClient", ClientID, UserID)

        End Using

    End Sub
    'Private Function AccountNumberExists(ByVal AccountNumber As String, ByVal ClientID As Integer) As Boolean

    '    Dim NumClients As Integer = DataHelper.FieldCount("tblClient", "ClientID", "AccountNumber = '" & AccountNumber & "' AND NOT ClientID = " & ClientID)

    '    Return NumClients > 0

    'End Function
    'Private Function GetNextAccountNumber(ByVal Current As String) As String

    '    Dim Prefix As String = PropertyHelper.Value("AccountNumberPrefix")
    '    Dim PadLength As Integer = DataHelper.Nz_int(PropertyHelper.Value("AccountNumberPadLength"))
    '    Dim PadCharacter As String = PropertyHelper.Value("AccountNumberPadCharacter")

    '    Return GetNextAccountNumber(Current, Prefix, PadLength, PadCharacter)

    'End Function
    'Private Function GetNextAccountNumber(ByVal Current As String, ByVal Prefix As String, _
    '    ByVal PadLength As Integer, ByVal PadCharacter As String) As String

    '    Try

    '        Dim NumberPortion As Long = Long.Parse(StringHelper.ApplyFilter(Current, StringHelper.Filter.NumericOnly))

    '        'increment the number portion
    '        NumberPortion += 1

    '        'build the new account number
    '        Dim NewAccountNumber As String = Prefix & (NumberPortion).ToString().PadLeft(PadLength, PadCharacter)

    '        'check to see if it's taken
    '        While AccountNumberExists(NewAccountNumber, 0)

    '            'incremember the number portion again
    '            NumberPortion += 1

    '            'build another new account number
    '            NewAccountNumber = Prefix & NumberPortion.ToString().PadLeft(PadLength, PadCharacter)

    '        End While

    '        Return NumberPortion

    '    Catch ex As Exception
    '        Return "0"
    '    End Try

    'End Function
    Private Function GetNextAccountNumber(ByVal Current As String) As String
        Dim Prefix As String = PropertyHelper.Value("AccountNumberPrefix")
        Dim PadLength As Integer = DataHelper.Nz_int(PropertyHelper.Value("AccountNumberPadLength"))
        Dim PadCharacter As String = PropertyHelper.Value("AccountNumberPadCharacter")
        Dim num As String

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAccountNumber")
            cmd.Connection.Open()
            num = cmd.ExecuteScalar()
        End Using

        Return Prefix & num.ToString().PadLeft(PadLength, PadCharacter)
    End Function

    Private Sub InsertAccounts()

        Dim InsertRows As New List(Of Integer) 'unique list

        Dim Updates As New List(Of String) 'for phone fields to update after

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

                    'figure out creditorid for values entered
                    Dim CreditorID As Integer = CreditorHelper.Find(ai.CreditorName, ai.Street, ai.Street2, _
                        ai.City, ai.StateID, ai.ZipCode, True, UserID)

                    'figure out forcreditorid for values entered
                    Dim ForCreditorID As Integer = CreditorHelper.Find(ai.ForCreditorName, True, UserID)

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

                        If String.IsNullOrEmpty(ai.AccountNumber) Then
                            ai.AccountNumber = "NEED"
                        End If

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
                        AccountHelper.AdjustRetainerFee(AccountID, ClientID, UserID)
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

        If grdAccountsUpdates.Value.Length > 0 Then

            'build dictionary of list(of updates) and wd.accountcreditorupdate items
            Dim Updates As New Dictionary(Of Integer, List(Of WorksheetData.AccountUpdate))
            Dim CreditorUpdates As New Dictionary(Of Integer, WorksheetData.AccountCreditorUpdate)

            Dim UpdateFields As New List(Of String)

            UpdateFields.AddRange(Regex.Split(grdAccountsUpdates.Value, "<-\$\$->"))

            'loop through fields and add to dictionary
            For Each UpdateField As String In UpdateFields

                If UpdateField.Length > 0 Then

                    Dim Fields() As String = UpdateField.Split(":")

                    Dim AccountID As Integer = DataHelper.Nz_int(Fields(0))
                    Dim Field As String = Fields(1)
                    Dim Type As String = Fields(2)
                    Dim Value As String = UpdateField.Substring(AccountID.ToString().Length + Field.Length _
                        + Type.Length + 3)

                    If Field.ToLower = "amount" Or Field.ToLower = "accountnumber" _
                        Or Field.ToLower = "referencenumber" Or Field.ToLower = "phonebusiness" _
                        Or Field.ToLower = "phonebusinessfax" Or Field.ToLower = "forname" Then 'is NOT creditor

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
                        End Select

                        If Not CreditorUpdates.ContainsKey(AccountID) Then
                            CreditorUpdates.Add(AccountID, acu)
                        End If
                    End If
                End If
            Next


            'first, deal with creditor updates
            For Each acu As WorksheetData.AccountCreditorUpdate In CreditorUpdates.Values

                'build (by finding or creating) the creditorid
                Dim CreditorID As Integer = GetCreditorID(acu)

                Dim CreditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(acu.AccountID)

                DataHelper.FieldUpdate("tblCreditorInstance", "CreditorID", CreditorID, _
                    "CreditorInstanceID = " & CreditorInstanceID)

            Next


            'second, deal with account/creditorinstance updates
            For Each lst As List(Of WorksheetData.AccountUpdate) In Updates.Values

                For Each au As WorksheetData.AccountUpdate In lst

                    Select Case au.Field.ToLower
                        Case "forname"

                            Dim CreditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(au.AccountID)

                            If au.Value.Length > 0 Then

                                Dim ForCreditorID As Integer = CreditorHelper.Find(au.Value, True, UserID)

                                UpdateCreditorInstance(CreditorInstanceID, "ForCreditorID", "int", ForCreditorID)

                            Else
                                UpdateCreditorInstance(CreditorInstanceID, "ForCreditorID", "int", "")
                            End If

                        Case "amount"

                            UpdateAccount(au.AccountID, "CurrentAmount", "money", au.Value)

                            Dim CreditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(au.AccountID)

                            UpdateCreditorInstance(CreditorInstanceID, au.Field, au.Type, au.Value)

                            'possible retainer fee adjustment
                            If chkCollectUpdate.Checked Then
                                AccountHelper.AdjustRetainerFee(au.AccountID, ClientID, UserID)
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
    Private Function GetCreditorID(ByVal acu As WorksheetData.AccountCreditorUpdate) As Integer

        Dim CreditorID As Integer = AccountHelper.GetCurrentCreditorID(acu.AccountID)

        'open current creditor record and augment what is missing
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblCreditor WHERE CreditorID = @CreditorID"

            DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    If rd.Read Then

                        'only fill in the gaps (don't assign if not null)
                        If acu.Name Is Nothing Then
                            acu.Name = DatabaseHelper.Peel_string(rd, "Name")
                        End If

                        If acu.Street Is Nothing Then
                            acu.Street = DatabaseHelper.Peel_string(rd, "Street")
                        End If

                        If acu.Street2 Is Nothing Then
                            acu.Street2 = DatabaseHelper.Peel_string(rd, "Street2")
                        End If

                        If acu.City Is Nothing Then
                            acu.City = DatabaseHelper.Peel_string(rd, "City")
                        End If

                        If acu.StateID = 0 Then
                            acu.StateID = DatabaseHelper.Peel_int(rd, "StateID")
                        End If

                        If acu.ZipCode Is Nothing Then
                            acu.ZipCode = DatabaseHelper.Peel_string(rd, "ZipCode")
                        End If

                    End If
                End Using
            End Using
        End Using

        'once augmented, find or create
        Return CreditorHelper.Find(acu.Name, acu.Street, acu.Street2, acu.City, acu.StateID, _
            acu.ZipCode, True, UserID)

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
End Class