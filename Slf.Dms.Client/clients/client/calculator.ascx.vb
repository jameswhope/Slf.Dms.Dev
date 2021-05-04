Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data

Public Structure Client_Calculator
    Public CliendId As Integer
    Public SettlementPercent As Decimal
    Public SettlementFee As Integer
    Public FirstMaintanance As Decimal
    Public SecondMaintenance As Decimal
    Public InitialDeposit As Decimal
    Public RegularDeposit As Decimal
    Public TotalDebt As Decimal
End Structure

Partial Class Clients_client_calculator
    Inherits System.Web.UI.UserControl

    Private _client As Client_Calculator

    Public EnrollmentMinDeposit As Double
    Public EnrollmentMinPct As Double
    Public EnrollmentMaxPct As Double
    Public EnrollmentCurrentPct As Double
    Public EnrollmentInflation As Double
    Public EnrollmentPBMAPR As Double
    Public EnrollmentPBMMinimum As Double
    Public EnrollmentPBMPercentage As Double

    Public Sub LoadData(ByVal Clientid As Integer, ByVal UseSmartDebtor As Boolean)
        LoadDDLs()
        SetAttributes()
        SetProperties()
        If UseSmartDebtor Then
            LoadClientDataFromLeadInfo(Clientid)
        Else
            LoadClientDataFromClientInfo(Clientid)
        End If
        PopulateFields()
        Recalc()
    End Sub

    Private Sub LoadDDLs()
        bindDDL(ddlSettlementPct, "SELECT SettlementPctID, SettlementPct FROM tblLeadSettlementPct", "SettlementPct", "SettlementPct")
        bindDDL(ddlMaintenanceFee, "SELECT MaintenanceFeeID, MaintenanceFee FROM tblLeadMaintenanceFee ORDER BY MaintenanceFee", "MaintenanceFee", "MaintenanceFee")
        bindDDL(ddlSubMaintenanceFee, "SELECT SubMaintenanceFeeID, Amount FROM tblLeadSubMaintenanceFee", "Amount", "Amount")
        bindDDL(ddlSettlementFee, "SELECT SettlementFeeID, SettlementFee FROM tblLeadSettlementFee", "SettlementFee", "SettlementFee")
    End Sub

    Private Sub bindDDL(ByVal ddlToBind As DropDownList, ByVal sqlSelect As String, ByVal TextField As String, ByVal ValueField As String)
        Dim cmd As SqlCommand = Nothing
        Try
            cmd = New SqlCommand(sqlSelect, ConnectionFactory.Create())
            Dim rdr As SqlDataReader = DatabaseHelper.ExecuteReader(cmd, Data.CommandBehavior.CloseConnection)
            ddlToBind.DataTextField = TextField
            ddlToBind.DataValueField = ValueField
            ddlToBind.DataSource = rdr
            ddlToBind.DataBind()
        Catch ex As Exception
            Throw ex
        Finally
            If Not cmd Is Nothing AndAlso cmd.Connection.State <> Data.ConnectionState.Closed Then cmd.Connection.Close()
        End Try
    End Sub

    Private Sub LoadClientDataFromLeadInfo(ByVal ClientId As Integer)
        _client = New Client_Calculator
        _client.CliendId = ClientId
        Dim dt As DataTable = GetData(String.Format("Select l.TotalDebt, l.SettlementFeePct, l.SettlementPct, l.InitialDeposit, l.MaintenanceFee, l.SubMaintenanceFee, l.DepositCommittment From tblLeadCalculator l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = {0}", ClientId))
        LoadClient(dt)
    End Sub

    Private Sub LoadClientDataFromClientInfo(ByVal ClientId As Integer)
        _client = New Client_Calculator
        _client.CliendId = ClientId
        Dim sb As New System.Text.StringBuilder()
        sb.AppendLine("select ")
        sb.AppendLine("TotalDebt = (select sum(a.currentamount) from tblaccount a ")
        sb.AppendLine("where a.clientid = c.clientid ")
        sb.AppendLine("and a.accountstatusid <> 55 ")
        sb.AppendLine("and not (a.accountstatusid = 54 ")
        sb.AppendLine("and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))), ")
        sb.AppendLine("100 * c.SettlementFeePercentage as SettlementFeePct, ")
        sb.AppendLine("null as SettlementPct, ")
        sb.AppendLine("c.MonthlyFee as MaintenanceFee, ")
        sb.AppendLine("c.SubSequentMaintFee as SubMaintenanceFee, ")
        sb.AppendLine("c.InitialDraftAmount as InitialDeposit, ")
        sb.AppendLine("DepositCommittment = Case When c.MultiDeposit = 1 Then ")
        sb.AppendLine("(Select sum(d.DepositAmount) From tblClientDepositDay d Where d.DeletedDate is Null and d.ClientId=c.ClientId) ")
        sb.AppendLine("Else c.DepositAmount End ")
        sb.AppendLine("from tblclient c ")
        sb.AppendFormat("where c.clientid = {0}", ClientId)
        Dim dt As DataTable = GetData(sb.ToString)
        LoadClient(dt)
        If _client.SettlementPercent = 0 Then
            'Get settlement percent from SD
            dt = GetData(String.Format("Select l.SettlementPct From tblLeadCalculator l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = {0}", ClientId))
            If Not dt Is Nothing And dt.Rows.Count > 0 Then
                If Not dt.Rows(0)("SettlementPct") Is DBNull.Value Then _client.SettlementPercent = dt.Rows(0)("SettlementPct")
            End If
        End If
    End Sub

    Private Sub LoadClient(ByVal dt As DataTable)
        If Not dt Is Nothing And dt.Rows.Count > 0 Then
            Dim dr As DataRow = dt.Rows(0)
            If Not dr("TotalDebt") Is DBNull.Value Then _client.TotalDebt = dr("TotalDebt")
            If Not dr("SettlementPct") Is DBNull.Value Then _client.SettlementPercent = dr("SettlementPct")
            If Not dr("SettlementFeePct") Is DBNull.Value Then _client.SettlementFee = dr("SettlementFeePct")
            If Not dr("InitialDeposit") Is DBNull.Value Then _client.InitialDeposit = dr("InitialDeposit")
            If Not dr("MaintenanceFee") Is DBNull.Value Then _client.FirstMaintanance = dr("MaintenanceFee")
            If Not dr("SubMaintenanceFee") Is DBNull.Value Then _client.SecondMaintenance = dr("SubMaintenanceFee")
            If Not dr("DepositCommittment") Is DBNull.Value Then _client.RegularDeposit = dr("DepositCommittment")
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Dim clientid As Integer = Me.Request.QueryString("id")
            LoadData(clientid, False)
        End If
    End Sub

    Public Function IsSmartDebtorClient(ByVal Clientid As Integer) As Boolean
        Dim dt As DataTable = GetData(String.Format("Select l.LeadApplicantId From tblLeadApplicant l inner join  tblImportedClient i on i.ExternalClientId = l.LeadApplicantId and i.SourceId = 1 inner join tblClient c on c.ServiceImportId = i.importId Where c.clientid = {0}", Clientid))
        Return (dt.Rows.Count > 0)
    End Function

    Private Function GetData(ByVal cmdText As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = cmdText
        Dim ds As DataSet = DatabaseHelper.ExecuteDataset(cmd)
        Return ds.Tables(0)
    End Function

    Private Sub PopulateFields()

        If Not ddlSettlementFee.Items.FindByValue(_client.SettlementFee.ToString) Is Nothing Then
            ddlSettlementFee.SelectedIndex = ddlSettlementFee.Items.IndexOf(ddlSettlementFee.Items.FindByValue(_client.SettlementFee))
        Else
            'ddlSettlementFee.SelectedIndex = 0
            AddandSelectListItem(ddlSettlementFee, _client.SettlementFee.ToString)
        End If

        If Not ddlSettlementPct.Items.FindByValue(_client.SettlementPercent.ToString) Is Nothing Then
            ddlSettlementPct.SelectedIndex = ddlSettlementPct.Items.IndexOf(ddlSettlementPct.Items.FindByValue(_client.SettlementPercent))
        Else
            'ddlSettlementPct.SelectedIndex = 0
            AddandSelectListItem(ddlSettlementPct, _client.SettlementPercent.ToString)
        End If

        If Not ddlMaintenanceFee.Items.FindByValue(Format(_client.FirstMaintanance, "#####0.00")) Is Nothing Then
            ddlMaintenanceFee.SelectedIndex = ddlMaintenanceFee.Items.IndexOf(ddlMaintenanceFee.Items.FindByValue(Format(_client.FirstMaintanance, "#####0.00")))
        Else
            'ddlMaintenanceFee.SelectedIndex = 0
            AddandSelectListItem(ddlMaintenanceFee, Format(_client.FirstMaintanance, "#####0.00"))
        End If

        If Not ddlSubMaintenanceFee.Items.FindByValue(Format(_client.SecondMaintenance, "#####0.00")) Is Nothing Then
            ddlSubMaintenanceFee.SelectedIndex = ddlSubMaintenanceFee.Items.IndexOf(ddlSubMaintenanceFee.Items.FindByValue(Format(_client.SecondMaintenance, "#####0.00")))
        Else
            'ddlSubMaintenanceFee.SelectedIndex = 0
            AddandSelectListItem(ddlSubMaintenanceFee, Format(_client.SecondMaintenance, "#####0.00"))
        End If

        Me.txtTotalDebt.Text = Format(_client.TotalDebt, "#####0.00")
        Me.txtDownPmt.Text = Format(_client.InitialDeposit, "#####0.00")
        Me.txtDepositComitmment.Text = Format(_client.RegularDeposit, "#####0.00")


    End Sub

    Private Sub AddandSelectListItem(ByVal ddl As DropDownList, ByVal Value As String)
        Dim litem As New ListItem(Value, Value)
        ddl.Items.Add(litem)
        ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(Value))
    End Sub

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
                Dim SubMaintentanceFeeMonthly As Double = Val(ddlSubMaintenanceFee.SelectedItem.Text)
                Dim dblTerm As Double

                If ((((SettlementPct2 + SettlementFee2 + MaintenanceFee1) - InitialDeposit) / (DepositCommitment)) / 12) < 0 Then
                    dblTerm = 0
                ElseIf DepositCommitment > 0 Then
                    dblTerm = ((((SettlementPct2 + SettlementFee2 + (-12 * (DepositCommitment - MaintenanceFeeMonthly)))) / (DepositCommitment - SubMaintentanceFeeMonthly)) / 12) + 1
                    'dblTerm = (((SettlementPct2 + SettlementFee2 + MaintenanceFee1) - InitialDeposit) / (DepositCommitment)) / 12
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

    Private Sub SetAttributes()
        txtTotalDebt.Attributes("onkeyup") = "javascript:Recalc(1);"
        txtDepositComitmment.Attributes("onkeyup") = "javascript:Recalc();"
        txtDownPmt.Attributes("onkeyup") = "javascript:Recalc(1);"
        ddlSettlementPct.Attributes("onchange") = "javascript:Recalc(1);"
        ddlMaintenanceFee.Attributes("onchange") = "javascript:Recalc(1);"
        ddlSubMaintenanceFee.Attributes("onchange") = "javascript:Recalc(1);"
        ddlSettlementFee.Attributes("onchange") = "javascript:Recalc(1);"
    End Sub

End Class
