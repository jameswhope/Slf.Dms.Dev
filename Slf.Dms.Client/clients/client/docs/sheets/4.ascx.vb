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

Partial Class clients_client_docs_sheets_4
    Inherits System.Web.UI.UserControl

#Region "Variables"

    Private Action As String
    Private DataEntryID As Integer
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private DataEntryTypeID As Integer = 4

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
    Private Sub PopulateAccounts()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblAccount INNER JOIN " & _
                                "tblCreditorInstance ON tblAccount.CurrentCreditorInstanceID = " & _
                                "tblCreditorInstance.CreditorInstanceID INNER JOIN " & _
                                    "tblCreditor ON tblCreditorInstance.CreditorID = tblCreditor.CreditorID " & _
                            "WHERE tblAccount.ClientID = @ClientID"

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cboAccounts.Items.Clear()

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()
            While rd.Read()
                Dim Text As String = DatabaseHelper.Peel_string(rd, "Name") & " - " & _
                    DatabaseHelper.Peel_string(rd, "AccountNumber")

                cboAccounts.Items.Add(New ListItem(Text, DatabaseHelper.Peel_int(rd, "AccountID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub HandleAction()
        


        Select Case Action
            Case "a"    'add
                PopulateAccounts()
                PopulateCreditors(cboCreditor, 0)

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

        txtAccountBalance.Enabled = Enabled
        cboAccounts.Enabled = Enabled
        rbExisting.Disabled = Not Enabled
        rbNew.Disabled = Not Enabled
        cboCreditor.Enabled = Enabled
        txtNewAccountNumber.Disabled = Not Enabled

        pnlUploadBoxes.Visible = Enabled
        pnlUploadDocs.Visible = Not Enabled

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
                        Dim ddl As DropDownList = CType(c, DropDownList)
                        Dim li As ListItem = New ListItem(Value)
                        ddl.Items.Add(li)
                        ddl.SelectedIndex = ddl.Items.IndexOf(li)
                    ElseIf TypeOf c Is HtmlInputCheckBox Then
                        CType(c, HtmlInputCheckBox).Checked = Boolean.Parse(Value)
                    ElseIf TypeOf c Is HtmlInputRadioButton Then
                        CType(c, HtmlInputRadioButton).Checked = Boolean.Parse(Value)
                    ElseIf TypeOf c Is HtmlInputText Then
                        CType(c, HtmlInputText).Value = Value
                    End If

                End If

            End While
            If rbNew.Checked Then
                tblExisting.Style("display") = "none"
                tblNew.Style("display") = "block"
            End If
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
        cboCreditor.Attributes("onchange") = "cboCreditor_OnChange(this);"
        txtAccountBalance.Attributes("onkeypress") = "onlyDigits();"

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
    Private Sub UpdateAccount()

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Dim amt As Double
        If Integer.TryParse(txtAccountBalance.Text, amt) Then DatabaseHelper.AddParameter(cmd, "CurrentAmount", amt)

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblAccount", "AccountID = " & cboAccounts.SelectedValue)

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
        If rbNew.Checked Then
            InsertNewAccount(ClientID)
        End If
        UpdateAccount()

        'store data entry values
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtAccountBalance", txtAccountBalance.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "cboCreditor", cboCreditor.SelectedItem.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "cboAccounts", cboAccounts.SelectedItem.Text)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "txtNewAccountNumber", txtNewAccountNumber.Value)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "rbExisting", rbExisting.Checked.ToString)
        DataEntryHelper.InsertDataEntryValue(DataEntryID, "rbNew", rbNew.Checked.ToString)

        'propagate any roadmaps or tasks
        DataEntryHelper.PropogateRoadmaps(DataEntryID, UserID)

        'return to data entries
        Response.Redirect("~/clients/client/docs/?id=" & ClientID)

    End Sub
    Private Function UploadFilesToDocs() As Integer()

        Dim DocIDs As New List(Of Integer)

        ' get a collection of parts that were uploaded in the current context
        Dim parts As New List(Of UploadedFile)(HttpUploadModule.GetUploadedFiles())

        ' if this was an upload
        If Not parts Is Nothing Then

            Dim DocFolderTypeID As Integer = 4 'Creditor Statement

            Dim DocFolderID As Integer = DocFolderHelper.ForceValidate(DocFolderTypeID, ClientID, UserID)

            ' loop through the parts collection
            For Each part As UploadedFile In parts

                Dim DocID As Integer = DocHelper.UploadFileIntoDoc(part, DocFolderID, UserID)

                DocIDs.Add(DocID)

            Next

        End If

        Return DocIDs.ToArray()

    End Function
    Private Sub PopulateCreditors(ByVal cbo As DropDownList, ByVal SelectedID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCreditors")

        Dim SelectionWasMade As Boolean = False

        cbo.Items.Clear()
        cbo.Items.Add(New ListItem("< Add New Creditor >", -2))
        cbo.Items.Add(New ListItem(New String("-", 100), -1))

        Dim liEmpty As New ListItem(String.Empty, 0)

        cbo.Items.Add(liEmpty)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim CreditorID As Integer = DatabaseHelper.Peel_int(rd, "CreditorID")
                Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                Dim City As String = DatabaseHelper.Peel_string(rd, "City")
                Dim StateName As String = DatabaseHelper.Peel_string(rd, "StateName")
                Dim StateAbbreviation As String = DatabaseHelper.Peel_string(rd, "StateAbbreviation")

                If StateAbbreviation.Length > 0 Then
                    If City.Length > 0 Then
                        Name += " - " & City & ", " & StateAbbreviation
                    Else
                        Name += " - " & StateAbbreviation
                    End If
                Else
                    If City.Length > 0 Then
                        Name += " - " & City
                    End If
                End If

                Dim li As New ListItem(Name, CreditorID)

                cbo.Items.Add(li)

                'cbo.SelectedIndex = 2

                If CreditorID = SelectedID Then

                    cbo.ClearSelection()
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
            cbo.ClearSelection()
            liEmpty.Selected = True
        End If

        cbo.Attributes("lastIndex") = cbo.SelectedIndex.ToString()

    End Sub
    Private Sub InsertNewAccount(ByVal ClientID As Integer)
        'grab default setupfeepercentage on record for client
        Dim SetupFeePercentage As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " & ClientID))

        Dim AccountNumber As String = txtNewAccountNumber.Value
        Dim OriginalAmount As Double = 0
        Dim CurrentAmount As Double = 0
        Dim CreditorID As Integer = cboCreditor.SelectedValue
        Dim Acquired As DateTime = Now
        Dim OriginalDueDate As DateTime = Now

        'insert new account against client
        Dim AccountID As Integer = AccountHelper.Insert(ClientID, OriginalAmount, CurrentAmount, _
            SetupFeePercentage, OriginalDueDate, UserID)

        'insert new creditorinstance against new account
        Dim CreditorInstanceID As Integer = CreditorInstanceHelper.Insert(AccountID, CreditorID, _
            Acquired, AccountNumber, UserID)

        'update new account with new creditorinstance id as current
        DataHelper.FieldUpdate("tblAccount", "CurrentCreditorInstanceID", CreditorInstanceID, _
            "AccountID = " & AccountID)

    End Sub

End Class
