Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_ach_checktoprint
    Inherits EntityPage

#Region "Variables"

    Private Action As String
    Private CheckToPrintID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Public UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            CheckToPrintID = DataHelper.Nz_int(qs("ctpid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then
                HandleAction()
            End If

            SetRollups()
            SetAttributes()

        End If

    End Sub
    Private Sub SetAttributes()

        txtZipCode.Attributes("onblur") = "txtZipCode_OnBlur(this);"
        txtBankZipCode.Attributes("onblur") = "txtBankZipCode_OnBlur(this);"

        txtZipCode.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtBankZipCode.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtBankRoutingNumber.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtBankAccountNumber.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtCheckNumber.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"

        optPrinted.Attributes("onpropertychange") = "optPrinted_OnPropertyChange(this);"
        optNotPrinted.Attributes("onpropertychange") = "optNotPrinted_OnPropertyChange(this);"

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit() Then
            'add applicant tasks
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this check</a>")

            If Not Action = "a" Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this check</a>")
            End If

            'add normal tasks

        End If
        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinances.HRef = "~/clients/client/finances/?id=" & ClientID
        lnkACH.HRef = "~/clients/client/finances/ach/?id=" & ClientID

    End Sub
    Private Sub HandleAction()

        LoadStates()
        LoadPrintedBys()

        Select Case Action
            Case "a"    'add

                lblCheckToPrint.Text = "Add New Check To Print"

                optPrinted.Checked = False
                optNotPrinted.Checked = True

                imPrinted.Enabled = False
                cboPrintedBy.Enabled = False
                lnkSetToNow.Disabled = True
                lnkSetToMe.Disabled = True

            Case Else   'edit
                LoadRecord()
        End Select

    End Sub
    Private Sub LoadPrintedBys()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblUser ORDER BY LastName, FirstName"

            cboPrintedBy.Items.Clear()
            cboPrintedBy.Items.Add(New ListItem(String.Empty, 0))

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        cboPrintedBy.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LastName") _
                            & ", " & DatabaseHelper.Peel_string(rd, "FirstName"), _
                            DatabaseHelper.Peel_int(rd, "UserID")))

                    End While

                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadStates()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblState ORDER BY [Abbreviation]"

        cboStateID.Items.Clear()
        cboStateID.Items.Add(New ListItem(String.Empty, 0))

        cboBankStateID.Items.Clear()
        cboBankStateID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboStateID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Abbreviation"), DatabaseHelper.Peel_string(rd, "Abbreviation")))
                cboBankStateID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Abbreviation"), DatabaseHelper.Peel_string(rd, "Abbreviation")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblCheckToPrint WHERE CheckToPrintID = @CheckToPrintID"

        DatabaseHelper.AddParameter(cmd, "CheckToPrintID", CheckToPrintID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                lblCheckToPrint.Text = DatabaseHelper.Peel_int(rd, "CheckToPrintID")
                txtFirstName.Text = DatabaseHelper.Peel_string(rd, "FirstName")
                txtLastName.Text = DatabaseHelper.Peel_string(rd, "LastName")
                txtSpouseFirstName.Text = DatabaseHelper.Peel_string(rd, "SpouseFirstName")
                txtSpouseLastName.Text = DatabaseHelper.Peel_string(rd, "SpouseLastName")
                txtStreet.Text = DatabaseHelper.Peel_string(rd, "Street")
                txtStreet2.Text = DatabaseHelper.Peel_string(rd, "Street2")
                txtCity.Text = DatabaseHelper.Peel_string(rd, "City")
                ListHelper.SetSelected(cboStateID, DatabaseHelper.Peel_string(rd, "StateAbbreviation"))
                txtZipCode.Text = DatabaseHelper.Peel_string(rd, "ZipCode")

                txtBankName.Text = DatabaseHelper.Peel_string(rd, "BankName")
                txtBankCity.Text = DatabaseHelper.Peel_string(rd, "BankCity")
                ListHelper.SetSelected(cboBankStateID, DatabaseHelper.Peel_string(rd, "BankStateAbbreviation"))
                txtBankZipCode.Text = DatabaseHelper.Peel_string(rd, "BankZipCode")
                txtBankRoutingNumber.Text = DatabaseHelper.Peel_string(rd, "bankRoutingNumber")
                txtBankAccountNumber.Text = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                txtCheckNumber.Text = DatabaseHelper.Peel_string(rd, "CheckNumber")

                txtAmount.Text = DatabaseHelper.Peel_double(rd, "Amount")
                imCheckDate.Text = DatabaseHelper.Peel_datestring(rd, "CheckDate", "MM/dd/yyyy")
                txtFraction.Text = DatabaseHelper.Peel_string(rd, "Fraction")

                If rd.IsDBNull(rd.GetOrdinal("Printed")) Then

                    optPrinted.Checked = False
                    optNotPrinted.Checked = True

                    imPrinted.Enabled = False
                    cboPrintedBy.Enabled = False
                    lnkSetToNow.Disabled = True
                    lnkSetToMe.Disabled = True

                Else

                    optPrinted.Checked = True
                    optNotPrinted.Checked = False

                    imPrinted.Text = DatabaseHelper.Peel_datestring(rd, "Printed", "MM/dd/yyyy")
                    ListHelper.SetSelected(cboPrintedBy, DatabaseHelper.Peel_int(rd, "PrintedBy"))

                    imPrinted.Enabled = True
                    cboPrintedBy.Enabled = True
                    lnkSetToNow.Disabled = False
                    lnkSetToMe.Disabled = False

                End If

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

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
    Private Sub Close()
        Response.Redirect("~/clients/client/finances/ach/?id=" & ClientID)
    End Sub
    Private Function InsertOrUpdateCheckToPrint() As Integer

        Dim StateName As String = DataHelper.FieldLookup("tblState", "Name", "Abbreviation = '" & cboStateID.SelectedValue & "'")
        Dim BankStateName As String = DataHelper.FieldLookup("tblState", "Name", "Abbreviation = '" & cboBankStateID.SelectedValue & "'")

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "FirstName", DataHelper.Zn(txtFirstName.Text))
        DatabaseHelper.AddParameter(cmd, "LastName", DataHelper.Zn(txtLastName.Text))
        DatabaseHelper.AddParameter(cmd, "SpouseFirstName", DataHelper.Zn(txtSpouseFirstName.Text))
        DatabaseHelper.AddParameter(cmd, "SpouseLastName", DataHelper.Zn(txtSpouseLastName.Text))
        DatabaseHelper.AddParameter(cmd, "Street", DataHelper.Zn(txtStreet.Text))
        DatabaseHelper.AddParameter(cmd, "Street2", DataHelper.Zn(txtStreet2.Text))
        DatabaseHelper.AddParameter(cmd, "City", DataHelper.Zn(txtCity.Text))
        DatabaseHelper.AddParameter(cmd, "StateAbbreviation", DataHelper.Zn(cboStateID.SelectedValue))
        DatabaseHelper.AddParameter(cmd, "StateName", DataHelper.Zn(StateName))
        DatabaseHelper.AddParameter(cmd, "ZipCode", DataHelper.Zn(txtZipCode.Text))

        DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(txtBankName.Text))
        DatabaseHelper.AddParameter(cmd, "BankCity", DataHelper.Zn(txtBankCity.Text))
        DatabaseHelper.AddParameter(cmd, "BankStateAbbreviation", DataHelper.Zn(cboBankStateID.SelectedValue))
        DatabaseHelper.AddParameter(cmd, "BankStateName", DataHelper.Zn(BankStateName))
        DatabaseHelper.AddParameter(cmd, "BankZipCode", DataHelper.Zn(txtBankZipCode.Text))
        DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", txtBankRoutingNumber.Text)
        DatabaseHelper.AddParameter(cmd, "BankAccountNumber", txtBankAccountNumber.Text)
        DatabaseHelper.AddParameter(cmd, "CheckNumber", txtCheckNumber.Text)

        DatabaseHelper.AddParameter(cmd, "Amount", DataHelper.Nz_double(txtAmount.Text))
        DatabaseHelper.AddParameter(cmd, "CheckDate", DataHelper.Nz_ndate(imCheckDate.Text))
        DatabaseHelper.AddParameter(cmd, "Fraction", txtFraction.Text)

        If optPrinted.Checked Then
            DatabaseHelper.AddParameter(cmd, "Printed", DataHelper.Nz_date(imPrinted.Text))
            DatabaseHelper.AddParameter(cmd, "PrintedBy", DataHelper.Nz_double(cboPrintedBy.SelectedValue))
        Else
            DatabaseHelper.AddParameter(cmd, "Printed", DBNull.Value, DbType.DateTime)
            DatabaseHelper.AddParameter(cmd, "PrintedBy", DBNull.Value, DbType.Int32)
        End If

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        If Action = "a" Then 'add

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblCheckToPrint", "CheckToPrintID", SqlDbType.Int)

        Else 'edit
            DatabaseHelper.BuildUpdateCommandText(cmd, "tblCheckToPrint", "CheckToPrintID = " & CheckToPrintID)
        End If

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Action = "a" Then 'add
            CheckToPrintID = DataHelper.Nz_int(cmd.Parameters("@CheckToPrintID").Value)
        End If

        Return CheckToPrintID

    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Save()

        Close()

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete check to print
        CheckToPrintHelper.Delete(CheckToPrintID)

        'drop back to ach
        Close()

    End Sub
    Private Sub Save()

        'save record
        InsertOrUpdateCheckToPrint()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "ctpid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblCheckToPrint"
        End Get
    End Property
End Class