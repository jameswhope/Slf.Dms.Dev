Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Partial Class clients_client_finances_mediation_calculator
    Inherits EntityPage
    Implements IClientPage


#Region "Variables"

    Public MediationHoldDays As Double

    Private Action As String
    Private QueryString As String
    Private SettlementAmount As Double
    Private _ClientID As Integer = -1
    Private _AccountID As Integer = -1
    Private _MediationID As Integer = -1
    Private qs As QueryStringCollection

    Private UserID As Integer


    Public ReadOnly Property MediationID() As Integer
        Get
            If _MediationID = -1 Then
                _MediationID = DataHelper.Nz_int(qs("id"), 0)
            End If
            Return _MediationID
        End Get
    End Property
    Public ReadOnly Property AccountID() As Integer
        Get
            If _AccountID = -1 Then
                _AccountID = DataHelper.Nz_int(DataHelper.FieldLookup("tblMediation", "AccountID", "MediationID=" & MediationID))
            End If
            Return _AccountID
        End Get
    End Property
    Public ReadOnly Property DataClientID() As Integer Implements IClientPage.DataClientID
        Get
            If _ClientID = -1 Then
                _ClientID = DataHelper.Nz_int(DataHelper.FieldLookup("tblAccount", "ClientID", "AccountID = " & AccountID))
            End If
            Return _ClientID
        End Get
    End Property
    Public Shadows ReadOnly Property ClientID()
        Get
            Return DataClientID
        End Get
    End Property
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            SettlementAmount = DataHelper.Nz_double(qs("sa"), 0.0)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then
                HandleAction()
            End If

        End If

        ucComms.MyPage = Me
    End Sub
    Private Sub HandleAction()

        If AccountHelper.Exists(AccountID) Then

            LoadApplicants()
            LoadAccounts()

            Select Case Action.ToLower
                Case "a"    'add
                    LoadDefaults()
                Case Else   'edit

                    LoadRecord()

                    lblSettlementFee.Text = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", _
                        "SettlementFeePercentage", "ClientID = " & ClientID)).ToString("#,##0.##%")

            End Select

            SetAttributes()

            MediationHoldDays = DataHelper.Nz_double(PropertyHelper.Value("MediationHoldDays"))

        Else
            Close()
        End If

    End Sub
    Private Sub LoadDefaults()

        Dim RegisterBalance As Double

        Dim CurrentAccountBalance As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblAccount", "CurrentAmount", "AccountID = " & AccountID))
        Dim SettlementFeePercentage As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "SettlementFeePercentage", "ClientID = " & ClientID))
        Dim OvernightDeliveryFee As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "OvernightDeliveryFee", "ClientID = " & ClientID))

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetStatsOverviewForClient")

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    If rd.Read() Then

                        RegisterBalance = DatabaseHelper.Peel_double(rd, "RegisterBalance")

                    End If

                End Using
            End Using
        End Using

        txtRegisterBalance.Text = RegisterBalance.ToString("###0.00")
        txtAccountBalance.Text = CurrentAccountBalance.ToString("###0.00")

        If SettlementAmount > 0 Then

            txtSettlementAmount.Text = SettlementAmount.ToString("###0.00")
            txtSettlementPercentage.Text = ((SettlementAmount / CurrentAccountBalance) * 100).ToString("###0.00")
            txtAmountAvailable.Text = IIf(SettlementAmount < RegisterBalance, SettlementAmount.ToString("###0.00"), RegisterBalance.ToString("###0.00"))
            txtAmountBeingSent.Text = txtAmountAvailable.Text
            txtAmountStillOwed2.Text = "0.00"
            txtSavings.Text = (CurrentAccountBalance - SettlementAmount).ToString("###0.00")
            lblSettlementFee.Text = SettlementFeePercentage.ToString("#,##0.##%")

            Dim SettlementFee As Double = (CurrentAccountBalance - SettlementAmount) * SettlementFeePercentage
            Dim SettlementCost As Double = SettlementFee + OvernightDeliveryFee

            Dim AvailableAfterSettlement As Double = RegisterBalance - SettlementAmount
            Dim AmountBeingPaid As Double
            Dim AmountStillOwed As Double

            If AvailableAfterSettlement >= SettlementCost Then
                AmountBeingPaid = SettlementCost
            Else
                If AvailableAfterSettlement > 0 Then
                    AmountBeingPaid = AvailableAfterSettlement
                Else
                    AmountBeingPaid = 0.0
                End If
            End If

            AmountStillOwed = SettlementCost - AmountBeingPaid

            txtSettlementFee.Text = SettlementFee.ToString("###0.00")
            txtOvernightDeliveryAmount.Text = OvernightDeliveryFee.ToString("###0.00")
            txtSettlementCost.Text = SettlementCost.ToString("###0.00")
            txtAvailableAfterSettlement.Text = IIf(AvailableAfterSettlement > 0, AvailableAfterSettlement.ToString("###0.00"), "0.00")
            txtAmountBeingPaid.Text = AmountBeingPaid.ToString("###0.00")
            txtAmountStillOwed.Text = AmountStillOwed.ToString("###0.00")

        End If

    End Sub
    Private Sub LoadRecord()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblMediation WHERE MediationID = @MediationID"

            DatabaseHelper.AddParameter(cmd, "MediationID", MediationID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    If rd.Read() Then

                        txtRegisterBalance.Text = DatabaseHelper.Peel_double(rd, "RegisterBalance").ToString("###0.00")
                        txtAccountBalance.Text = DatabaseHelper.Peel_double(rd, "AccountBalance").ToString("###0.00")
                        txtSettlementPercentage.Text = DatabaseHelper.Peel_double(rd, "SettlementPercentage").ToString("###0.00")
                        txtSettlementAmount.Text = DatabaseHelper.Peel_double(rd, "SettlementAmount").ToString("###0.00")
                        txtAmountAvailable.Text = DatabaseHelper.Peel_double(rd, "AmountAvailable").ToString("###0.00")
                        txtAmountBeingSent.Text = DatabaseHelper.Peel_double(rd, "AmountBeingSent").ToString("###0.00")
                        txtSavings.Text = DatabaseHelper.Peel_double(rd, "Savings").ToString("###0.00")
                        txtSettlementFee.Text = DatabaseHelper.Peel_double(rd, "SettlementFee").ToString("###0.00")
                        txtOvernightDeliveryAmount.Text = DatabaseHelper.Peel_double(rd, "OvernightDeliveryAmount").ToString("###0.00")
                        txtSettlementCost.Text = DatabaseHelper.Peel_double(rd, "SettlementCost").ToString("###0.00")
                        txtAvailableAfterSettlement.Text = DatabaseHelper.Peel_double(rd, "AvailableAfterSettlement").ToString("###0.00")
                        txtAmountBeingPaid.Text = DatabaseHelper.Peel_double(rd, "AmountBeingPaid").ToString("###0.00")
                        txtAmountStillOwed.Text = DatabaseHelper.Peel_double(rd, "AmountStillOwed").ToString("###0.00")
                        txtAmountStillOwed2.Text = "0.00"

                    End If

                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadAccounts()

        Dim CreditorInstances As New List(Of CreditorInstance)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCreditorInstancesForAccount")

            DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        CreditorInstances.Add(New CreditorInstance(DatabaseHelper.Peel_int(rd, "CreditorInstanceID"), _
                            DatabaseHelper.Peel_int(rd, "AccountID"), _
                            DatabaseHelper.Peel_int(rd, "CreditorID"), _
                            DatabaseHelper.Peel_date(rd, "Acquired"), _
                            DatabaseHelper.Peel_string(rd, "AccountNumber"), _
                            DatabaseHelper.Peel_string(rd, "ReferenceNumber"), _
                            DatabaseHelper.Peel_date(rd, "Created"), _
                            DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                            DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                            DatabaseHelper.Peel_date(rd, "LastModified"), _
                            DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                            DatabaseHelper.Peel_string(rd, "LastModifiedByName"), _
                            DatabaseHelper.Peel_bool(rd, "IsCurrent"), _
                            DatabaseHelper.Peel_date(rd, "OriginalDueDate"), _
                            DatabaseHelper.Peel_double(rd, "OriginalAmount"), _
                            DatabaseHelper.Peel_double(rd, "CurrentAmount"), _
                            DatabaseHelper.Peel_string(rd, "CreditorName"), ResolveUrl("~/")))

                    End While

                End Using
            End Using
        End Using

        If CreditorInstances.Count > 0 Then

            CreditorInstances(0).ShowOriginalAmount = True
            CreditorInstances(CreditorInstances.Count - 1).ShowCurrentAmount = True

            rpCreditorInstances.DataSource = CreditorInstances
            rpCreditorInstances.DataBind()

        End If

    End Sub
    Private Sub LoadApplicants()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPersonsForClient")

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Dim Applicants As New List(Of Person)

            Using cmd.Connection

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Applicants.Add(New Person(DatabaseHelper.Peel_int(rd, "PersonID"), _
                            DatabaseHelper.Peel_int(rd, "ClientID"), _
                            DatabaseHelper.Peel_string(rd, "SSN"), _
                            DatabaseHelper.Peel_string(rd, "FirstName"), _
                            DatabaseHelper.Peel_string(rd, "LastName"), _
                            DatabaseHelper.Peel_string(rd, "Gender"), _
                            DatabaseHelper.Peel_ndate(rd, "DateOfBirth"), _
                            DatabaseHelper.Peel_int(rd, "LanguageID"), _
                            DatabaseHelper.Peel_string(rd, "LanguageName"), _
                            DatabaseHelper.Peel_string(rd, "EmailAddress"), _
                            DatabaseHelper.Peel_string(rd, "Street"), _
                            DatabaseHelper.Peel_string(rd, "Street2"), _
                            DatabaseHelper.Peel_string(rd, "City"), _
                            DatabaseHelper.Peel_int(rd, "StateID"), _
                            DatabaseHelper.Peel_string(rd, "StateName"), _
                            DatabaseHelper.Peel_string(rd, "StateAbbreviation"), _
                            DatabaseHelper.Peel_string(rd, "ZipCode"), _
                            DatabaseHelper.Peel_string(rd, "Relationship"), _
                            DatabaseHelper.Peel_bool(rd, "CanAuthorize"), _
                            DatabaseHelper.Peel_bool(rd, "ThirdParty"), _
                            DatabaseHelper.Peel_date(rd, "Created"), _
                            DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                            DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                            DatabaseHelper.Peel_date(rd, "LastModified"), _
                            DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                            DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

                    End While

                    rpApplicants.DataSource = Applicants
                    rpApplicants.DataBind()

                End Using
            End Using
        End Using

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
    Private Sub SetAttributes()

        txtRegisterBalance.Attributes("onblur") = "txtRegisterBalance_OnBlur(this);"
        txtRegisterBalance.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtAccountBalance.Attributes("onblur") = "txtAccountBalance_OnBlur(this);"
        txtAccountBalance.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtSettlementPercentage.Attributes("onblur") = "txtSettlementPercentage_OnBlur(this);"
        txtSettlementPercentage.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtSettlementAmount.Attributes("onblur") = "txtSettlementAmount_OnBlur(this);"
        txtSettlementAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtAmountAvailable.Attributes("onblur") = "txtAmountAvailable_OnBlur(this);"
        txtAmountAvailable.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtAmountBeingSent.Attributes("onblur") = "txtAmountBeingSent_OnBlur(this);"
        txtAmountBeingSent.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtSavings.Attributes("onblur") = "txtSavings_OnBlur(this);"
        txtSavings.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtSettlementFee.Attributes("onblur") = "txtSettlementFee_OnBlur(this);"
        txtSettlementFee.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtOvernightDeliveryAmount.Attributes("onblur") = "txtOvernightDeliveryAmount_OnBlur(this);"
        txtOvernightDeliveryAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtSettlementCost.Attributes("onblur") = "txtSettlementCost_OnBlur(this);"
        txtSettlementCost.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtAvailableAfterSettlement.Attributes("onblur") = "txtAvailableAfterSettlement_OnBlur(this);"
        txtAvailableAfterSettlement.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtAmountBeingPaid.Attributes("onblur") = "txtAmountBeingPaid_OnBlur(this);"
        txtAmountBeingPaid.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtAmountStillOwed.Attributes("onblur") = "txtAmountStillOwed_OnBlur(this);"
        txtAmountStillOwed.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtAmountStillOwed2.Attributes("onblur") = "txtAmountStillOwed2_OnBlur(this);"
        txtAmountStillOwed2.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtFrozenAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"

        txtFrozenDays.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtFrozenDays.Attributes("onblur") = "txtFrozenDays_OnBlur(this);"
        txtFrozenDays.Attributes("onfocus") = "txtFrozenDays_OnFocus(this);"

        imFrozenDate.RegexPattern = "(?=\d)^(?:(?!(?:10\D(?:0?[5-9]|1[0-4])\D(?:1582))|(?:0?9\D(?:0?[3-9]|1[0-3])\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\/31)(?!-31)(?!\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\d\d)(?:[02468][048]|[13579][26])(?!\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\x20BC))))))|(?:0?2(?=.(?:(?:\d\D)|(?:[01]\d)|(?:2[0-8])))))([-.\/])(0?[1-9]|[12]\d|3[01])\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\d)\x20BC)|(?:\d{4}(?!\x20BC)))\d{4}(?:\x20BC)?)(?:$|(?=\x20\d)\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\d){0,2}(?:\x20[aApP][mM]))|(?:[01]\d|2[0-3])(?::[0-5]\d){1,2})?$"

        imFrozenDate.OnRegexMatch = "imFrozenDate_OnMatch();"
        imFrozenDate.OnRegexNoMatch = "imFrozenDate_OnNoMatch();"

    End Sub
    Private Sub GoToClientRecord(ByVal ClientID As Integer)
        Response.Redirect("~/clients/client/?id=" & ClientID)
    End Sub
    Protected Sub rpCreditorInstances_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpCreditorInstances.ItemDataBound

        Dim trOriginalAmount As HtmlTableRow = CType(e.Item.FindControl("trOriginalAmount"), HtmlTableRow)
        Dim trCurrentAmount As HtmlTableRow = CType(e.Item.FindControl("trCurrentAmount"), HtmlTableRow)

        trOriginalAmount.Visible = e.Item.DataItem.ShowOriginalAmount
        trCurrentAmount.Visible = e.Item.DataItem.ShowCurrentAmount

    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Private Sub Close()
        Response.Redirect("~/clients/client/creditors/mediation/?id=" & ClientID & "&tsp=2")
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "RegisterBalance", DataHelper.Nz_double(txtRegisterBalance.Text))
            DatabaseHelper.AddParameter(cmd, "AccountBalance", DataHelper.Nz_double(txtAccountBalance.Text))
            DatabaseHelper.AddParameter(cmd, "SettlementPercentage", DataHelper.Nz_double(txtSettlementPercentage.Text))
            DatabaseHelper.AddParameter(cmd, "SettlementAmount", DataHelper.Nz_double(txtSettlementAmount.Text))
            DatabaseHelper.AddParameter(cmd, "AmountAvailable", DataHelper.Nz_double(txtAmountAvailable.Text))
            DatabaseHelper.AddParameter(cmd, "AmountBeingSent", DataHelper.Nz_double(txtAmountBeingSent.Text))
            DatabaseHelper.AddParameter(cmd, "Savings", DataHelper.Nz_double(txtSavings.Text))
            DatabaseHelper.AddParameter(cmd, "SettlementFee", DataHelper.Nz_double(txtSettlementFee.Text))
            DatabaseHelper.AddParameter(cmd, "OvernightDeliveryAmount", DataHelper.Nz_double(txtOvernightDeliveryAmount.Text))
            DatabaseHelper.AddParameter(cmd, "SettlementCost", DataHelper.Nz_double(txtSettlementCost.Text))
            DatabaseHelper.AddParameter(cmd, "AvailableAfterSettlement", DataHelper.Nz_double(txtAvailableAfterSettlement.Text))
            DatabaseHelper.AddParameter(cmd, "AmountBeingPaid", DataHelper.Nz_double(txtAmountBeingPaid.Text))
            DatabaseHelper.AddParameter(cmd, "AmountStillOwed", DataHelper.Nz_double(txtAmountStillOwed.Text))

            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

            If Action = "a" Then

                DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)

                DatabaseHelper.AddParameter(cmd, "Created", Now)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

                DatabaseHelper.BuildInsertCommandText(cmd, "tblMediation")

            Else
                DatabaseHelper.BuildUpdateCommandText(cmd, "tblMediation", "MediationID = " & MediationID)
            End If

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

        Close()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "id"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblMediation"
        End Get
    End Property

End Class