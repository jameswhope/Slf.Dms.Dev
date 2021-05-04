Option Explicit On

Imports Slf.Dms.Records

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports AssistedSolutions.SlickUpload
Imports AssistedSolutions.SlickUpload.Providers

Imports System.Data
Imports System.Web.UI
Imports System.Collections.Generic

Partial Class clients_client_docs_sheets_2
    Inherits System.Web.UI.UserControl

#Region "Variables"

    Private Action As String
    Private DataEntryID As Integer
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private DataEntryTypeID As Integer = 2

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            DataEntryID = DataHelper.Nz_int(qs("deid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then
                HandleAction()
            End If

        End If

    End Sub
    Private Sub HandleAction()

        Select Case Action
            Case "a"    'add

                LoadExisting()

                'setup javascript attributes since we are adding
                SetAttributes()

                ' Make sure that the required uploadId has been generated
                If Request.QueryString("uploadId") Is Nothing Then

                    Dim qsb As New QueryStringBuilder(Request.Url.Query)
                    qsb("uploadId") = Guid.NewGuid().ToString()
                    Response.Redirect("~/clients/client/docs/data.aspx?" & qsb.QueryString)

                End If

            Case Else   'edit

                LoadRecord()
                LoadDocs()

                SetControlState(False)

        End Select

    End Sub
    Private Sub SetControlState(ByVal Enabled As Boolean)

        optTypePersonCheck.Disabled = Not Enabled
        optTypeACHInformation.Disabled = Not Enabled
        optTypeCashiersCheck.Disabled = Not Enabled

        txtDepositRoutingNumber.Enabled = Enabled
        txtDepositAccountNumber.Enabled = Enabled
        txtDepositBankName.Enabled = Enabled
        txtDepositAmount.Enabled = Enabled

        txtMonthlyRoutingNumber.Enabled = Enabled
        txtMonthlyAccountNumber.Enabled = Enabled
        txtMonthlyBankName.Enabled = Enabled
        txtMonthlyAmount.Enabled = Enabled
        cboMonthlyDay.Enabled = Enabled

        pnlUploadBoxes.Visible = Enabled
        pnlUploadDocs.Visible = Not Enabled

    End Sub
    Private Sub LoadExisting()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblClient WHERE ClientID = @ClientID"

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                txtMonthlyRoutingNumber.Text = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                txtMonthlyAccountNumber.Text = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                txtMonthlyBankName.Text = DatabaseHelper.Peel_string(rd, "BankName")
                txtMonthlyAmount.Text = DatabaseHelper.Peel_double(rd, "MonthlyFee").ToString("###0.00")
                ListHelper.SetSelected(cboMonthlyDay, DatabaseHelper.Peel_int(rd, "DepositDay"))

                txtDepositAmount.Text = "0.00"

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblDataEntryValue WHERE DataEntryID = @DataEntryID"

        DatabaseHelper.AddParameter(cmd, "DataEntryID", DataEntryID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                Dim Value As String = DatabaseHelper.Peel_string(rd, "Value")

                Dim c As Control = FindControl(Name)

                If Not c Is Nothing Then

                    If TypeOf c Is TextBox Then
                        CType(c, TextBox).Text = Value
                    ElseIf TypeOf c Is DropDownList Then
                        CType(c, DropDownList).SelectedValue = Value
                    ElseIf TypeOf c Is HtmlInputCheckBox Then
                        CType(c, HtmlInputCheckBox).Checked = Boolean.Parse(Value)
                    ElseIf TypeOf c Is HtmlInputRadioButton Then
                        CType(c, HtmlInputRadioButton).Checked = Boolean.Parse(Value)
                    End If

                End If

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadDocs()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetDocsForDataEntry")

        DatabaseHelper.AddParameter(cmd, "DataEntryID", DataEntryID)

        Dim Docs As New List(Of Doc)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Docs.Add(New Doc(DatabaseHelper.Peel_int(rd, "DocID"), _
                    DatabaseHelper.Peel_string(rd, "Name"), _
                    DatabaseHelper.Peel_int(rd, "DocFolderID"), _
                    DatabaseHelper.Peel_string(rd, "DocFolderName"), _
                    DatabaseHelper.Peel_double(rd, "Size"), _
                    DatabaseHelper.Peel_string(rd, "Type"), _
                    DatabaseHelper.Peel_int(rd, "FileID"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"), ResolveUrl("~/")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Docs.Count > 0 Then

            rpDocs.DataSource = Docs
            rpDocs.DataBind()

        End If

    End Sub
    Private Sub SetAttributes()

        optTypePersonCheck.Attributes("onpropertychange") = "optTypePersonCheck_OnPropertyChange(this);"
        optTypeCashiersCheck.Attributes("onpropertychange") = "optTypeCashiersCheck_OnPropertyChange(this);"

        txtDepositRoutingNumber.Attributes("onkeypress") = "onlyDigits();"
        txtDepositAccountNumber.Attributes("onkeypress") = "onlyDigits();"
        txtDepositAmount.Attributes("onkeypress") = "onlyDigits();"

        txtMonthlyRoutingNumber.Attributes("onkeypress") = "onlyDigits();"
        txtMonthlyAccountNumber.Attributes("onkeypress") = "onlyDigits();"
        txtMonthlyAmount.Attributes("onkeypress") = "onlyDigits();"

        Page.Form.Enctype = "multipart/form-data"

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_docs_data""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        'upload files to repository and return doc ids
        Dim DocIDs() As Integer = UploadFilesToDocs()

        'create the dataentry record
        DataEntryID = DataEntryHelper.InsertDataEntry(ClientID, DataEntryTypeID, _
            DataHelper.Nz_date(txtConducted.Text), UserID)

        'store docids against the new dataentry record
        DataEntryHelper.InsertDataEntryDocs(DataEntryID, DocIDs)

        'store check to be printed, if ach info was submitted
        If optTypeACHInformation.Checked Then
            CreateCheckToPrint()
        End If

        'store monthly ach info
        ClientHelper.UpdateACHInfo(ClientID, DataHelper.Nz_int(cboMonthlyDay.SelectedValue), _
            txtMonthlyBankName.Text, txtMonthlyRoutingNumber.Text, txtMonthlyAccountNumber.Text, _
            DataHelper.Nz_double(txtMonthlyAmount.Text), UserID)

        'store data entry values
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "optTypePersonCheck", optTypePersonCheck.Checked)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "optTypeACHInformation", optTypeACHInformation.Checked)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "optTypeCashiersCheck", optTypeCashiersCheck.Checked)

        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtDepositRoutingNumber", txtDepositRoutingNumber.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtDepositAccountNumber", txtDepositAccountNumber.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtDepositBankName", txtDepositBankName.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtDepositAmount", txtDepositAmount.Text)

        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtMonthlyRoutingNumber", txtMonthlyRoutingNumber.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtMonthlyAccountNumber", txtMonthlyAccountNumber.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtMonthlyBankName", txtMonthlyBankName.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtMonthlyAmount", txtMonthlyAmount.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "cboMonthlyDay", cboMonthlyDay.SelectedValue)

        'propagate any roadmaps or tasks
        DataEntryHelper.PropogateRoadmaps(DataEntryID, UserID)

        'check if it's time to go-to-underwriting
        DataEntryHelper.SetupUnderwriting(ClientID, UserID)

        'return to data entries
        Response.Redirect("~/clients/client/docs/?id=" & ClientID)

    End Sub
    Private Sub CreateCheckToPrint()

        Dim FirstName As String = String.Empty
        Dim LastName As String = String.Empty
        Dim Street As String = String.Empty
        Dim Street2 As String = String.Empty
        Dim City As String = String.Empty
        Dim StateAbbreviation As String = String.Empty
        Dim StateName As String = String.Empty
        Dim ZipCode As String = String.Empty
        Dim AccountNumber As String = String.Empty
        Dim BankName As String = txtDepositBankName.Text
        Dim BankCity As String = String.Empty
        Dim BankStateAbbreviation As String = String.Empty
        Dim BankStateName As String = String.Empty
        Dim BankZipCode As String = String.Empty

        'fill primary person data
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPrimaryPersonForClient")

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    If rd.Read() Then

                        FirstName = DatabaseHelper.Peel_string(rd, "FirstName")
                        LastName = DatabaseHelper.Peel_string(rd, "LastName")
                        Street = DatabaseHelper.Peel_string(rd, "Street")
                        Street2 = DatabaseHelper.Peel_string(rd, "Street2")
                        City = DatabaseHelper.Peel_string(rd, "City")
                        StateAbbreviation = DatabaseHelper.Peel_string(rd, "StateAbbreviation")
                        StateName = DatabaseHelper.Peel_string(rd, "StateName")
                        ZipCode = DatabaseHelper.Peel_string(rd, "ZipCode")
                        AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")

                    End If
                End Using
            End Using
        End Using

        'try to get spouse info
        Dim SpouseFirstName As String = DataHelper.FieldLookup("tblPerson", "FirstName", "ClientID = " _
            & ClientID & " AND Relationship = 'Spouse'")

        Dim SpouseLastName As String = DataHelper.FieldLookup("tblPerson", "LastName", "ClientID = " _
            & ClientID & " AND Relationship = 'Spouse'")

        'retrieve fraction for check
        Dim Fraction As String = PropertyHelper.Value("CheckPrintingFraction")

        'fill ach from table (which will retrieve if necessary)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblACH WHERE ACHID = @ACHID"

            DatabaseHelper.AddParameter(cmd, "ACHID", Drg.Util.DataHelpers.ACHHelper.GetACH(txtDepositRoutingNumber.Text, UserID))

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    If rd.Read() Then

                        BankCity = DatabaseHelper.Peel_string(rd, "City")
                        BankStateAbbreviation = DatabaseHelper.Peel_string(rd, "StateCode")
                        BankStateName = DataHelper.FieldLookup("tblState", "Name", "Abbreviation = '" & BankStateAbbreviation & "'")
                        BankZipCode = DatabaseHelper.Peel_string(rd, "ZipCode")

                        If DatabaseHelper.Peel_string(rd, "ZipCodeExtension").Length > 0 Then
                            BankZipCode += "-" & DatabaseHelper.Peel_string(rd, "ZipCodeExtension")
                        End If

                    End If
                End Using
            End Using
        End Using

        CheckToPrintHelper.InsertCheckToPrint(ClientID, FirstName, LastName, SpouseFirstName, _
            SpouseLastName, Street, Street2, City, StateAbbreviation, StateName, ZipCode, _
            AccountNumber, BankName, BankCity, BankStateAbbreviation, BankStateName, BankZipCode, _
            txtDepositRoutingNumber.Text, txtDepositAccountNumber.Text, _
            DataHelper.Nz_double(txtDepositAmount.Text), Now.ToString("yyyyMMdd"), Now, Fraction, UserID)

    End Sub
    Private Function UploadFilesToDocs() As Integer()

        Dim DocIDs As New List(Of Integer)

        ' get a collection of parts that were uploaded in the current context
        Dim parts As New List(Of UploadedFile)(HttpUploadModule.GetUploadedFiles())

        ' if this was an upload
        If Not parts Is Nothing AndAlso parts.Count > 0 Then

            Dim DocFolderTypeID As Integer = 3 'deposit payment

            Dim DocFolderID As Integer = DocFolderHelper.ForceValidate(DocFolderTypeID, ClientID, UserID)

            ' loop through the parts collection
            For Each part As UploadedFile In parts

                Dim DocID As Integer = DocHelper.UploadFileIntoDoc(part, DocFolderID, UserID)

                DocIDs.Add(DocID)

            Next

        End If

        Return DocIDs.ToArray()

    End Function
End Class