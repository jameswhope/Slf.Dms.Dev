Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_sdcalculator
    Inherits System.Web.UI.Page

#Region "Variables"

    Public QueryString As String
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        qs = LoadQueryString()

        PrepQuerystring()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then
                LoadCalculator()
                LoadPrimaryPerson()
                newCalcModel.ApplicantID = ClientID
                If UseNewCalculator Then Recalc(False)
            End If

        End If
        SetRollups()
    End Sub

    Public ReadOnly Property UseNewCalculator() As Boolean
        Get
            Return (Me.hdnCalculator.Value = "1")
        End Get
    End Property

    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub

    Private Sub SetRollups()

        Dim Views As List(Of String) = CType(Master, clients_client).Views
        Dim CommonTasks As List(Of String) = CType(Master, clients_client).CommonTasks

        Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_objectbrowser.png") & """ align=""absmiddle""/>Show main overview</a>")

    End Sub

    Private Sub LoadPrimaryPerson()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(ClientID))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")
                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)

                lblName.Text = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
                    DatabaseHelper.Peel_string(rd, "LastName"), _
                    DatabaseHelper.Peel_string(rd, "SSN"), _
                    DatabaseHelper.Peel_string(rd, "EmailAddress"))

                lblAddress.Text = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), State, _
                    DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

                lblSSN.Text = "SSN: " & StringHelper.PlaceInMask(DatabaseHelper.Peel_string(rd, "SSN"), "___-__-____")

            Else
                lblName.Text = "No Applicant"
                lblAddress.Text = "No Address"
            End If

            lnkStatus.Text = ClientHelper.GetStatus(ClientID, Now)

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim NumApplicants As Integer = DataHelper.FieldCount("tblPerson", "PersonID", "ClientID = " & ClientID)

        If NumApplicants > 1 Then
            lnkNumApplicants.InnerText = "(" & NumApplicants & ")"
            lnkNumApplicants.HRef = "~/clients/client/applicants/" & QueryString
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

    Private Sub LoadCalculator()
        Me.trNewCalculator.Visible = False
        Me.trCalculator.Visible = False
        'Select calculator
        If newCalcModel.IsSmartDebtorClient(ClientID) Then
            If Me.newCalcModel.UsesNewCalculator(ClientID) Then
                Me.trNewCalculator.Visible = True
                hdnCalculator.Value = "1"
                SetProperties()
            Else
                Me.trCalculator.Visible = True
                hdnCalculator.Value = "0"
            End If
        End If
        Me.btnCurrent.Font.Underline = True
    End Sub

    Protected Sub btnSD_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSD.Click
        Calc(True)
        Me.btnCurrent.Font.Underline = False
        Me.btnSD.Font.Underline = True
    End Sub

    Protected Sub btnCurrent_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCurrent.Click
        Calc(False)
        Me.btnCurrent.Font.Underline = True
        Me.btnSD.Font.Underline = False
    End Sub

    Private Sub Recalc(ByVal UseLeadData As Boolean)
        Dim id As Integer = Me.ClientID
        If UseLeadData Then id = CallVerificationHelper.GetLeadIdfromClientId(Me.ClientID)
        newCalcModel.ApplicantID = id
        newCalcModel.UseLeadData = UseLeadData
        newCalcModel.LoadClientData()
        newCalcModel.ReCalcModel(newCalcModel.InitialDeposit, newCalcModel.DepositCommittment, newCalcModel.TotalDebt, newCalcModel.TotalNumberOfAccts)
    End Sub

    Private Sub SetProperties()
        newCalcModel.EstimateGrowthPct = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentInflation")) * 100, "#.##")
        newCalcModel.InterestRate = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMAPR")) * 100, "#.##")
        newCalcModel.MinPaymentAmt = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMMinimum")), "0.00")
        newCalcModel.MinPaymentPct = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentPBMPercentage")) * 100, "#.##")
        newCalcModel.SettlementFeePct = Format(DataHelper.Nz_double(PropertyHelper.Value("EnrollmentSettlementPercentage")) * 100, "#.##")

        Dim ssql As New StringBuilder
        ssql.AppendFormat("select MaintenanceFeeCap,monthlyfee from tblclient where clientid = {0}", ClientID)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each uprop As DataRow In dt.Rows
                newCalcModel.ServiceFeeCap = Format(DataHelper.Nz_double(uprop("MaintenanceFeeCap").ToString), "0.00")
                newCalcModel.MonthlyFeePerAcct = Format(DataHelper.Nz_double(uprop("monthlyfee").ToString, "0.00"))
                Exit For
            Next
        End Using
    End Sub

    Private Sub Calc(ByVal UseSDData As Boolean)
        If Not UseNewCalculator Then
            sdcalculator.LoadData(ClientID, UseSDData)
        Else
            Recalc(UseSDData)
        End If
    End Sub

End Class