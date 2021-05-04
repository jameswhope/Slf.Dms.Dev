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

Partial Class clients_client_docs_sheets_1
    Inherits System.Web.UI.UserControl

#Region "Variables"

    Private Action As String
    Private DataEntryID As Integer
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private DataEntryTypeID As Integer = 1

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

        txtSetupFee.Enabled = Enabled
        txtSetupFeePercentage.Enabled = Enabled
        txtSettlementFeePercentage.Enabled = Enabled
        txtAdditionalAccountFee.Enabled = Enabled
        txtReturnedCheckFee.Enabled = Enabled
        txtOvernightDeliveryFee.Enabled = Enabled

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

                txtSetupFee.Text = DatabaseHelper.Peel_double(rd, "SetupFee").ToString("###0.00")
                txtSetupFeePercentage.Text = (DatabaseHelper.Peel_double(rd, "SetupFeePercentage") * 100).ToString("###0.00")
                txtSettlementFeePercentage.Text = (DatabaseHelper.Peel_double(rd, "SettlementFeePercentage") * 100).ToString("###0.00")
                txtAdditionalAccountFee.Text = DatabaseHelper.Peel_double(rd, "AdditionalAccountFee").ToString("###0.00")
                txtReturnedCheckFee.Text = DatabaseHelper.Peel_double(rd, "ReturnedCheckFee").ToString("###0.00")
                txtOvernightDeliveryFee.Text = DatabaseHelper.Peel_double(rd, "OvernightDeliveryFee").ToString("###0.00")

                txtMonthlyRoutingNumber.Text = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                txtMonthlyAccountNumber.Text = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                txtMonthlyBankName.Text = DatabaseHelper.Peel_string(rd, "BankName")
                txtMonthlyAmount.Text = DatabaseHelper.Peel_double(rd, "MonthlyFee").ToString("###0.00")
                ListHelper.SetSelected(cboMonthlyDay, DatabaseHelper.Peel_int(rd, "DepositDay"))

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

        txtSetupFee.Attributes("onkeypress") = "onlyDigits();"
        txtSetupFeePercentage.Attributes("onkeypress") = "onlyDigits();"
        txtSettlementFeePercentage.Attributes("onkeypress") = "onlyDigits();"
        txtAdditionalAccountFee.Attributes("onkeypress") = "onlyDigits();"
        txtReturnedCheckFee.Attributes("onkeypress") = "onlyDigits();"
        txtOvernightDeliveryFee.Attributes("onkeypress") = "onlyDigits();"

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
    Private Sub UpdateClient()

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "DepositMethod", "ACH")
        DatabaseHelper.AddParameter(cmd, "DepositDay", DataHelper.Zn(DataHelper.Nz_int(cboMonthlyDay.SelectedValue)))
        DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(txtMonthlyBankName.Text))
        DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", DataHelper.Zn(txtMonthlyRoutingNumber.Text))
        DatabaseHelper.AddParameter(cmd, "BankAccountNumber", DataHelper.Zn(txtMonthlyAccountNumber.Text))

        DatabaseHelper.AddParameter(cmd, "SetupFee", DataHelper.Zn(DataHelper.Nz_double(txtSetupFee.Text)), DbType.Double)
        DatabaseHelper.AddParameter(cmd, "SetupFeePercentage", DataHelper.Zn(DataHelper.Nz_double(txtSetupFeePercentage.Text) / 100), DbType.Double)
        DatabaseHelper.AddParameter(cmd, "SettlementFeePercentage", DataHelper.Zn(DataHelper.Nz_double(txtSettlementFeePercentage.Text) / 100), DbType.Double)
        DatabaseHelper.AddParameter(cmd, "MonthlyFee", DataHelper.Zn(DataHelper.Nz_double(txtMonthlyAmount.Text)), DbType.Double)
        DatabaseHelper.AddParameter(cmd, "AdditionalAccountFee", DataHelper.Zn(DataHelper.Nz_double(txtAdditionalAccountFee.Text)), DbType.Double)
        DatabaseHelper.AddParameter(cmd, "ReturnedCheckFee", DataHelper.Zn(DataHelper.Nz_double(txtReturnedCheckFee.Text)), DbType.Double)
        DatabaseHelper.AddParameter(cmd, "OvernightDeliveryFee", DataHelper.Zn(DataHelper.Nz_double(txtOvernightDeliveryFee.Text)), DbType.Double)

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblClient", "ClientID = " & ClientID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        'upload files to repository and return doc ids
        Dim DocIDs() As Integer = UploadFilesToDocs()

        'create the dataentry record
        DataEntryID = DataEntryHelper.InsertDataEntry(ClientID, DataEntryTypeID, _
            DataHelper.Nz_date(txtConducted.Text), UserID)

        'store docids against the new dataentry record
        DataEntryHelper.InsertDataEntryDocs(DataEntryID, DocIDs)

        'save the form
        UpdateClient()

        'store data entry values
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtSetupFee", txtSetupFee.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtSetupFeePercentage", txtSetupFeePercentage.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtSettlementFeePercentage", txtSettlementFeePercentage.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtAdditionalAccountFee", txtAdditionalAccountFee.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtReturnedCheckFee", txtReturnedCheckFee.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtOvernightDeliveryFee", txtOvernightDeliveryFee.Text)

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
    Private Function UploadFilesToDocs() As Integer()

        Dim DocIDs As New List(Of Integer)

        ' get a collection of parts that were uploaded in the current context
        Dim parts As New List(Of UploadedFile)(HttpUploadModule.GetUploadedFiles())

        ' if this was an upload
        If Not parts Is Nothing AndAlso parts.Count > 0 Then

            Dim DocFolderTypeID As Integer = 2 'legal service agreement (lsa)

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