Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Text
Imports System.Data
Imports System.Collections.Generic

Partial Class tasks_workflows_3
    Inherits System.Web.UI.UserControl

#Region "Variables"

    Private TaskID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblTask"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            TaskID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then

                LoadTaskResolutions()

                Dim Resolved As String = DataHelper.FieldLookup("tblTask", "Resolved", "TaskID = " & TaskID)

                If Resolved Is Nothing OrElse Resolved.Length = 0 Then
                    'LoadExisting()
                Else

                    LoadTrusts(0)

                    LoadTaskValues()

                    'SetControlState(False)

                End If

                ' SetAttributes()

            End If

        End If

    End Sub
    'Private Sub SetControlState(ByVal Enabled As Boolean)

    '    txtSetupFee.Enabled = Enabled
    '    txtSetupFeePercentage.Enabled = Enabled
    '    txtSettlementFeePercentage.Enabled = Enabled
    '    txtAdditionalAccountFee.Enabled = Enabled
    '    txtReturnedCheckFee.Enabled = Enabled
    '    txtOvernightDeliveryFee.Enabled = Enabled

    '    cboTrustID.Enabled = Enabled
    '    txtAccountNumber.Enabled = Enabled

    '    chkinsertsetupfee.Enabled = Enabled

    'End Sub
    'Private Sub SetAttributes()

    '    txtSetupFee.Attributes("onkeypress") = "onlyDigits();"
    '    txtSetupFeePercentage.Attributes("onkeypress") = "onlyDigits();"
    '    txtSettlementFeePercentage.Attributes("onkeypress") = "onlyDigits();"
    '    txtAdditionalAccountFee.Attributes("onkeypress") = "onlyDigits();"
    '    txtReturnedCheckFee.Attributes("onkeypress") = "onlyDigits();"
    '    txtOvernightDeliveryFee.Attributes("onkeypress") = "onlyDigits();"

    '    cboTrustID.Attributes("onchange") = "cboTrustID_OnChange(this);"

    ''  End Sub
    Private Sub LoadTaskValues()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskValue WHERE TaskID = @TaskID"

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

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
                    ElseIf TypeOf c Is CheckBox Then
                        CType(c, CheckBox).Checked = Boolean.Parse(Value)
                    End If

                End If

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    'Private Sub LoadExisting()

    '    Dim ClientIDs() As Integer = DataHelper.FieldLookupIDs("tblClientTask", "ClientID", "TaskID = " & TaskID)

    '    Dim ClientID As Integer = ClientIDs(0)

    '    Dim rd As IDataReader = Nothing
    '    Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

    '    cmd.CommandText = "SELECT * FROM tblClient WHERE ClientID = @ClientID"

    '    DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

    '    Try

    '        cmd.Connection.Open()
    '        rd = cmd.ExecuteReader()

    '        While rd.Read()

    '            ListHelper.SetSelected(cboTrustID, DatabaseHelper.Peel_int(rd, "TrustID"))

    '            txtSetupFee.Text = DatabaseHelper.Peel_double(rd, "SetupFee").ToString("###0.00")
    '            txtSetupFeePercentage.Text = (DatabaseHelper.Peel_double(rd, "SetupFeePercentage") * 100).ToString("###0.00")
    '            txtSettlementFeePercentage.Text = (DatabaseHelper.Peel_double(rd, "SettlementFeePercentage") * 100).ToString("###0.00")
    '            txtAdditionalAccountFee.Text = DatabaseHelper.Peel_double(rd, "AdditionalAccountFee").ToString("###0.00")
    '            txtReturnedCheckFee.Text = DatabaseHelper.Peel_double(rd, "ReturnedCheckFee").ToString("###0.00")
    '            txtOvernightDeliveryFee.Text = DatabaseHelper.Peel_double(rd, "OvernightDeliveryFee").ToString("###0.00")

    '            txtAccountNumber.Text = DatabaseHelper.Peel_string(rd, "AccountNumber")

    '            'if no account number exists, prepare next in line
    '            If txtAccountNumber.Text.Length = 0 Then

    '                Dim Value As Long = DataHelper.Nz_long(PropertyHelper.Value("AccountNumberValue"))
    '                Dim Prefix As String = PropertyHelper.Value("AccountNumberPrefix")
    '                Dim PadLength As Integer = DataHelper.Nz_int(PropertyHelper.Value("AccountNumberPadLength"))
    '                Dim PadCharacter As String = PropertyHelper.Value("AccountNumberPadCharacter")

    '                txtAccountNumber.Text = Prefix & Value.ToString.PadLeft(PadLength, PadCharacter)

    '            End If

    '            LoadTrusts(DatabaseHelper.Peel_int(rd, "TrustID"))

    '            'if never had setup fee transaction collected, check true
    '            If DataHelper.FieldCount("tblRegister", "RegisterID", "ClientID = " & ClientID & " AND EntryTypeID = 2") = 0 Then
    '                chkInsertSetupFee.Checked = True
    '            Else
    '                chkInsertSetupFee.Checked = False
    '            End If

    '        End While

    '    Finally
    '        DatabaseHelper.EnsureReaderClosed(rd)
    '        DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
    '    End Try

    'End Sub
    Private Sub LoadTrusts(ByVal SelectedID As Integer)

        'Dim rd As IDataReader = Nothing
        'Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTrusts")

        'DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY tblTrust.[Name], tblState.[Name], tblTrust.City")

        'Dim SelectionWasMade As Boolean = False

        'cboTrustID.Items.Clear()
        'cboTrustID.Items.Add(New ListItem("< Add New Trust >", -2))
        'cboTrustID.Items.Add(New ListItem(New String("-", 100), -1))

        'Dim liEmpty As New ListItem(String.Empty, 0)

        'cboTrustID.Items.Add(liEmpty)

        'Try

        '    cmd.Connection.Open()
        '    rd = cmd.ExecuteReader()

        '    While rd.Read()

        '        Dim TrustID As Integer = DatabaseHelper.Peel_int(rd, "TrustID")
        '        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
        '        Dim City As String = DatabaseHelper.Peel_string(rd, "City")
        '        Dim StateAbbreviation As String = DatabaseHelper.Peel_string(rd, "StateAbbreviation")

        '        Dim li As New ListItem(Name & " - " & City & ", " & StateAbbreviation, TrustID)

        '        cboTrustID.Items.Add(li)

        '        If TrustID = SelectedID Then

        '            cboTrustID.ClearSelection()
        '            li.Selected = True
        '            SelectionWasMade = True

        '        Else
        '            li.Selected = False
        '        End If

        '    End While

        'Finally
        '    DatabaseHelper.EnsureReaderClosed(rd)
        '    DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        'End Try

        'If Not SelectionWasMade Then
        '    cboTrustID.ClearSelection()
        '    liEmpty.Selected = True
        'End If

        'cboTrustID.Attributes("lastIndex") = cboTrustID.SelectedIndex.ToString()

    End Sub
    Private Sub LoadTaskResolutions()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskResolution"

        cboTaskResolutionID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTaskResolutionID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TaskResolutionID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub UpdateClient(ByVal ClientID As Integer)

        'Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        'DatabaseHelper.AddParameter(cmd, "TrustID", DataHelper.Nz_int(txtTrustID.Value))
        'DatabaseHelper.AddParameter(cmd, "AccountNumber", txtAccountNumber.Text)

        'DatabaseHelper.AddParameter(cmd, "SetupFee", DataHelper.Zn(DataHelper.Nz_double(txtSetupFee.Text)), DbType.Double)
        'DatabaseHelper.AddParameter(cmd, "SetupFeePercentage", DataHelper.Zn(DataHelper.Nz_double(txtSetupFeePercentage.Text) / 100), DbType.Double)
        'DatabaseHelper.AddParameter(cmd, "SettlementFeePercentage", DataHelper.Zn(DataHelper.Nz_double(txtSettlementFeePercentage.Text) / 100), DbType.Double)
        'DatabaseHelper.AddParameter(cmd, "AdditionalAccountFee", DataHelper.Zn(DataHelper.Nz_double(txtAdditionalAccountFee.Text)), DbType.Double)
        'DatabaseHelper.AddParameter(cmd, "ReturnedCheckFee", DataHelper.Zn(DataHelper.Nz_double(txtReturnedCheckFee.Text)), DbType.Double)
        'DatabaseHelper.AddParameter(cmd, "OvernightDeliveryFee", DataHelper.Zn(DataHelper.Nz_double(txtOvernightDeliveryFee.Text)), DbType.Double)

        'DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        'DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        'DatabaseHelper.BuildUpdateCommandText(cmd, "tblClient", "ClientID = " & ClientID)

        'Try
        '    cmd.Connection.Open()
        '    cmd.ExecuteNonQuery()
        'Finally
        '    DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        'End Try

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        ''get associated client
        'Dim ClientID As Integer = TaskHelper.GetClients(TaskID)(0)

        ''check and fix account number
        'If AccountNumberExists(txtAccountNumber.Text, ClientID) Then

        '    CType(Page, tasks_task_resolve).Control_dvError.Style("display") = "inline"
        '    CType(Page, tasks_task_resolve).Control_tdError.InnerHtml = "The Account Number you entered is already in use."

        'Else

        '    'save the form
        '    UpdateClient(ClientID)

        '    'get a new account number and update the properties table
        '    PropertyHelper.Update("AccountNumberValue", GetNextAccountNumber(txtAccountNumber.Text), UserID)

        '    'resolve task, notes and propagations
        '    TaskHelper.Resolve(TaskID, txtResolved.Value, cboTaskResolutionID.SelectedValue, UserID, _
        '        Regex.Split(txtNotes.Value, "\|--\$--\|"), txtPropagations.Value.Split("|"))

        '    If chkInsertSetupFee.checked Then

        '        Dim Amount As Double = DataHelper.Nz_double(txtSetupFee.Text)

        '        Amount = Amount - (Amount * 2) 'make it negative

        '        'insert setup fee
        '        RegisterHelper.Insert(ClientID, Now, Nothing, Nothing, Amount, 0, 2, UserID)

        '        'run the payment manager
        '        PaymentManager.ProcessClient(ClientID)

        '    End If

        '    'store task values
        '    TaskHelper.InsertTaskValue(TaskID, "txtSetupFee", txtSetupFee.Text)
        '    TaskHelper.InsertTaskValue(TaskID, "txtSetupFeePercentage", txtSetupFeePercentage.Text)
        '    TaskHelper.InsertTaskValue(TaskID, "txtSettlementFeePercentage", txtSettlementFeePercentage.Text)
        '    TaskHelper.InsertTaskValue(TaskID, "txtAdditionalAccountFee", txtAdditionalAccountFee.Text)
        '    TaskHelper.InsertTaskValue(TaskID, "txtReturnedCheckFee", txtReturnedCheckFee.Text)
        '    TaskHelper.InsertTaskValue(TaskID, "txtOvernightDeliveryFee", txtOvernightDeliveryFee.Text)

        '    TaskHelper.InsertTaskValue(TaskID, "cboTrustID", txtTrustID.Value)
        '    TaskHelper.InsertTaskValue(TaskID, "txtTrustID", txtTrustID.Value)
        '    TaskHelper.InsertTaskValue(TaskID, "txtAccountNumber", txtAccountNumber.Text)

        '    TaskHelper.InsertTaskValue(TaskID, "chkInsertSetupFee", chkInsertSetupFee.checked)

        '    CType(Page, tasks_task_resolve).ReturnToReferrer()

        'End If

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

    '    Dim NumberPortion As Long = Long.Parse(StringHelper.ApplyFilter(Current, StringHelper.Filter.NumericOnly))

    '    'increment the number portion
    '    NumberPortion += 1

    '    'build the new account number
    '    Dim NewAccountNumber As String = Prefix & (NumberPortion).ToString().PadLeft(PadLength, PadCharacter)

    '    'check to see if it's taken
    '    While AccountNumberExists(NewAccountNumber, 0)

    '        'incremember the number portion again
    '        NumberPortion += 1

    '        'build another new account number
    '        NewAccountNumber = Prefix & NumberPortion.ToString().PadLeft(PadLength, PadCharacter)

    '    End While

    '    Return NumberPortion

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

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
End Class