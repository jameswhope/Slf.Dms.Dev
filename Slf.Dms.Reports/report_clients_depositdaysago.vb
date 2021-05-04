Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Public Class report_clients_depositdaysago
    Inherits GrapeCity.ActiveReports.SectionReport
    Public Sub New()
        MyBase.New()
        InitializeComponent()
    End Sub
#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader = Nothing
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private WithEvents ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter = Nothing
    Private Label16 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label1 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label4 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label5 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Line1 As GrapeCity.ActiveReports.SectionReportModel.Line
    Private Label6 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label7 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label8 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label9 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label10 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label12 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label13 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label14 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private AccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ClientName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ClientStatusName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line
    Private DepositMethod As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private DepositAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private DaysAgo As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TransactionDate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private DepositDay As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Void As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ACH As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Bounce As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private AgencyName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private [Date] As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PN As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PT As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PageNumbers As GrapeCity.ActiveReports.SectionReportModel.Label
    Private TextBox8 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox10 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(report_clients_depositdaysago))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.Label16 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label1 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label4 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label5 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Line1 = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.Label6 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label7 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label8 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label9 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label10 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label12 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label13 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label14 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label2 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.AccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientStatusName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.DepositMethod = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.DepositAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.DaysAgo = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TransactionDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.DepositDay = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Void = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ACH = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Bounce = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.AgencyName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.[Date] = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PT = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PageNumbers = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.TextBox8 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox10 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label4, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label5, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label6, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label7, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label8, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label9, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label10, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label12, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label13, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label14, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientStatusName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DepositMethod, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DepositAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DaysAgo, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TransactionDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DepositDay, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Void, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ACH, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Bounce, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.AgencyName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox8, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox10, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.AccountNumber, Me.ClientName, Me.ClientStatusName, Me.Separator, Me.DepositMethod, Me.DepositAmount, Me.DaysAgo, Me.TransactionDate, Me.DepositDay, Me.txtAmount, Me.Void, Me.ACH, Me.Bounce, Me.AgencyName})
        Me.Detail.Height = 0.3222222!
        Me.Detail.KeepTogether = true
        Me.Detail.Name = "Detail"
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label16})
        Me.ReportHeader.Height = 0.3125!
        Me.ReportHeader.Name = "ReportHeader"
        '
        'ReportFooter
        '
        Me.ReportFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(240, Byte), Integer), CType(CType(240, Byte), Integer), CType(CType(240, Byte), Integer))
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.TextBox8, Me.TextBox10})
        Me.ReportFooter.Height = 0.3020833!
        Me.ReportFooter.KeepTogether = true
        Me.ReportFooter.Name = "ReportFooter"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label1, Me.Label4, Me.Label5, Me.Line1, Me.Label6, Me.Label7, Me.Label8, Me.Label9, Me.Label10, Me.Label12, Me.Label13, Me.Label14, Me.Label, Me.Label2})
        Me.PageHeader.Height = 0.375!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.[Date], Me.PN, Me.PT, Me.PageNumbers})
        Me.PageFooter.Height = 0.4375!
        Me.PageFooter.Name = "PageFooter"
        '
        'Label16
        '
        Me.Label16.Height = 0.1875!
        Me.Label16.HyperLink = Nothing
        Me.Label16.Left = 0.0625!
        Me.Label16.Name = "Label16"
        Me.Label16.Style = "font-size: 9.75pt; font-weight: bold; text-align: left; ddo-char-set: 0"
        Me.Label16.Text = "Query Results - Deposit Days Ago"
        Me.Label16.Top = 0!
        Me.Label16.Width = 4.375!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 3.0625!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = ""
        Me.Label1.Text = "Acct. #"
        Me.Label1.Top = 0.0625!
        Me.Label1.Width = 0.6875!
        '
        'Label4
        '
        Me.Label4.Height = 0.1875!
        Me.Label4.HyperLink = Nothing
        Me.Label4.Left = 1.5!
        Me.Label4.Name = "Label4"
        Me.Label4.Style = ""
        Me.Label4.Text = "Client Name"
        Me.Label4.Top = 0.0625!
        Me.Label4.Width = 1.5625!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 3.75!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: left"
        Me.Label5.Text = "Status"
        Me.Label5.Top = 0.0625!
        Me.Label5.Width = 1.125!
        '
        'Line1
        '
        Me.Line1.Height = 0!
        Me.Line1.Left = 0!
        Me.Line1.LineWeight = 3!
        Me.Line1.Name = "Line1"
        Me.Line1.Top = 0.3125!
        Me.Line1.Width = 11.125!
        Me.Line1.X1 = 0!
        Me.Line1.X2 = 11.125!
        Me.Line1.Y1 = 0.3125!
        Me.Line1.Y2 = 0.3125!
        '
        'Label6
        '
        Me.Label6.Height = 0.1875!
        Me.Label6.HyperLink = Nothing
        Me.Label6.Left = 4.875!
        Me.Label6.Name = "Label6"
        Me.Label6.Style = "text-align: left"
        Me.Label6.Text = "Method"
        Me.Label6.Top = 0.0625!
        Me.Label6.Width = 0.5625!
        '
        'Label7
        '
        Me.Label7.Height = 0.1875!
        Me.Label7.HyperLink = Nothing
        Me.Label7.Left = 5.4375!
        Me.Label7.Name = "Label7"
        Me.Label7.Style = "text-align: center"
        Me.Label7.Text = "Day"
        Me.Label7.Top = 0.0625!
        Me.Label7.Width = 0.375!
        '
        'Label8
        '
        Me.Label8.Height = 0.1875!
        Me.Label8.HyperLink = Nothing
        Me.Label8.Left = 5.8125!
        Me.Label8.Name = "Label8"
        Me.Label8.Style = "text-align: right"
        Me.Label8.Text = "Amount"
        Me.Label8.Top = 0.0625!
        Me.Label8.Width = 0.9375!
        '
        'Label9
        '
        Me.Label9.Height = 0.1875!
        Me.Label9.HyperLink = Nothing
        Me.Label9.Left = 6.75!
        Me.Label9.Name = "Label9"
        Me.Label9.Style = "text-align: center"
        Me.Label9.Text = "Days Ago"
        Me.Label9.Top = 0.0625!
        Me.Label9.Width = 0.6875!
        '
        'Label10
        '
        Me.Label10.Height = 0.1875!
        Me.Label10.HyperLink = Nothing
        Me.Label10.Left = 7.4375!
        Me.Label10.Name = "Label10"
        Me.Label10.Style = "text-align: center"
        Me.Label10.Text = "Date"
        Me.Label10.Top = 0.0625!
        Me.Label10.Width = 0.9375!
        '
        'Label12
        '
        Me.Label12.Height = 0.1875!
        Me.Label12.HyperLink = Nothing
        Me.Label12.Left = 8.375!
        Me.Label12.Name = "Label12"
        Me.Label12.Style = "text-align: right"
        Me.Label12.Text = "Amount"
        Me.Label12.Top = 0.0625!
        Me.Label12.Width = 0.875!
        '
        'Label13
        '
        Me.Label13.Height = 0.1875!
        Me.Label13.HyperLink = Nothing
        Me.Label13.Left = 9.25!
        Me.Label13.Name = "Label13"
        Me.Label13.Style = "text-align: center"
        Me.Label13.Text = "V"
        Me.Label13.Top = 0.0625!
        Me.Label13.Width = 0.5!
        '
        'Label14
        '
        Me.Label14.Height = 0.1875!
        Me.Label14.HyperLink = Nothing
        Me.Label14.Left = 10.25!
        Me.Label14.Name = "Label14"
        Me.Label14.Style = "text-align: center"
        Me.Label14.Text = "ACH"
        Me.Label14.Top = 0.0625!
        Me.Label14.Width = 0.625!
        '
        'Label
        '
        Me.Label.Height = 0.1875!
        Me.Label.HyperLink = Nothing
        Me.Label.Left = 9.75!
        Me.Label.Name = "Label"
        Me.Label.Style = "text-align: center"
        Me.Label.Text = "B"
        Me.Label.Top = 0.0625!
        Me.Label.Width = 0.5!
        '
        'Label2
        '
        Me.Label2.Height = 0.1875!
        Me.Label2.HyperLink = Nothing
        Me.Label2.Left = 0.0625!
        Me.Label2.Name = "Label2"
        Me.Label2.Style = ""
        Me.Label2.Text = "Agency"
        Me.Label2.Top = 0.0625!
        Me.Label2.Width = 1.4375!
        '
        'AccountNumber
        '
        Me.AccountNumber.CanGrow = false
        Me.AccountNumber.DataField = "AccountNumber"
        Me.AccountNumber.Height = 0.1875!
        Me.AccountNumber.Left = 3.0625!
        Me.AccountNumber.Name = "AccountNumber"
        Me.AccountNumber.Text = "AccountNumber"
        Me.AccountNumber.Top = 0.0625!
        Me.AccountNumber.Width = 0.6875!
        '
        'ClientName
        '
        Me.ClientName.CanGrow = false
        Me.ClientName.DataField = "ClientName"
        Me.ClientName.Height = 0.1875!
        Me.ClientName.Left = 1.5!
        Me.ClientName.Name = "ClientName"
        Me.ClientName.Text = "ClientName"
        Me.ClientName.Top = 0.0625!
        Me.ClientName.Width = 1.5625!
        '
        'ClientStatusName
        '
        Me.ClientStatusName.CanGrow = false
        Me.ClientStatusName.DataField = "ClientStatusName"
        Me.ClientStatusName.Height = 0.1875!
        Me.ClientStatusName.Left = 3.75!
        Me.ClientStatusName.Name = "ClientStatusName"
        Me.ClientStatusName.OutputFormat = resources.GetString("ClientStatusName.OutputFormat")
        Me.ClientStatusName.Style = "text-align: left"
        Me.ClientStatusName.Text = "ClientStatusName"
        Me.ClientStatusName.Top = 0.0625!
        Me.ClientStatusName.Width = 1.125!
        '
        'Separator
        '
        Me.Separator.Height = 0!
        Me.Separator.Left = 0!
        Me.Separator.LineColor = System.Drawing.Color.FromArgb(CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer))
        Me.Separator.LineWeight = 1!
        Me.Separator.Name = "Separator"
        Me.Separator.Top = 0.3125!
        Me.Separator.Width = 11.25!
        Me.Separator.X1 = 0!
        Me.Separator.X2 = 11.25!
        Me.Separator.Y1 = 0.3125!
        Me.Separator.Y2 = 0.3125!
        '
        'DepositMethod
        '
        Me.DepositMethod.CanGrow = false
        Me.DepositMethod.DataField = "DepositMethod"
        Me.DepositMethod.Height = 0.1875!
        Me.DepositMethod.Left = 4.875!
        Me.DepositMethod.Name = "DepositMethod"
        Me.DepositMethod.Text = "DepositMethod"
        Me.DepositMethod.Top = 0.0625!
        Me.DepositMethod.Width = 0.5625!
        '
        'DepositAmount
        '
        Me.DepositAmount.CanGrow = false
        Me.DepositAmount.DataField = "DepositAmount"
        Me.DepositAmount.Height = 0.1875!
        Me.DepositAmount.Left = 5.8125!
        Me.DepositAmount.Name = "DepositAmount"
        Me.DepositAmount.OutputFormat = resources.GetString("DepositAmount.OutputFormat")
        Me.DepositAmount.Style = "text-align: right"
        Me.DepositAmount.Text = "DepositAmount"
        Me.DepositAmount.Top = 0.0625!
        Me.DepositAmount.Width = 0.9375!
        '
        'DaysAgo
        '
        Me.DaysAgo.CanGrow = false
        Me.DaysAgo.DataField = "DaysAgo"
        Me.DaysAgo.Height = 0.1875!
        Me.DaysAgo.Left = 6.75!
        Me.DaysAgo.Name = "DaysAgo"
        Me.DaysAgo.OutputFormat = resources.GetString("DaysAgo.OutputFormat")
        Me.DaysAgo.Style = "text-align: center"
        Me.DaysAgo.Text = "DaysAgo"
        Me.DaysAgo.Top = 0.0625!
        Me.DaysAgo.Width = 0.6875!
        '
        'TransactionDate
        '
        Me.TransactionDate.CanGrow = false
        Me.TransactionDate.DataField = "TransactionDate"
        Me.TransactionDate.Height = 0.1875!
        Me.TransactionDate.Left = 7.4375!
        Me.TransactionDate.Name = "TransactionDate"
        Me.TransactionDate.OutputFormat = resources.GetString("TransactionDate.OutputFormat")
        Me.TransactionDate.Style = "text-align: center"
        Me.TransactionDate.Text = "TransactionDate"
        Me.TransactionDate.Top = 0.0625!
        Me.TransactionDate.Width = 0.9375!
        '
        'DepositDay
        '
        Me.DepositDay.CanGrow = false
        Me.DepositDay.DataField = "DepositDay"
        Me.DepositDay.Height = 0.1875!
        Me.DepositDay.Left = 5.4375!
        Me.DepositDay.Name = "DepositDay"
        Me.DepositDay.Style = "text-align: center"
        Me.DepositDay.Text = "DepositDay"
        Me.DepositDay.Top = 0.0625!
        Me.DepositDay.Width = 0.375!
        '
        'txtAmount
        '
        Me.txtAmount.CanGrow = false
        Me.txtAmount.DataField = "Amount"
        Me.txtAmount.Height = 0.1875!
        Me.txtAmount.Left = 8.375!
        Me.txtAmount.Name = "txtAmount"
        Me.txtAmount.OutputFormat = resources.GetString("txtAmount.OutputFormat")
        Me.txtAmount.Style = "text-align: right"
        Me.txtAmount.Text = "txtAmount"
        Me.txtAmount.Top = 0.0625!
        Me.txtAmount.Width = 0.875!
        '
        'Void
        '
        Me.Void.CanGrow = false
        Me.Void.DataField = "Void"
        Me.Void.Height = 0.1875!
        Me.Void.Left = 9.25!
        Me.Void.Name = "Void"
        Me.Void.OutputFormat = resources.GetString("Void.OutputFormat")
        Me.Void.Style = "text-align: center"
        Me.Void.Top = 0.0625!
        Me.Void.Width = 0.5!
        '
        'ACH
        '
        Me.ACH.CanGrow = false
        Me.ACH.DataField = "ACH"
        Me.ACH.Height = 0.1875!
        Me.ACH.Left = 10.25!
        Me.ACH.Name = "ACH"
        Me.ACH.OutputFormat = resources.GetString("ACH.OutputFormat")
        Me.ACH.Style = "text-align: center"
        Me.ACH.Top = 0.0625!
        Me.ACH.Width = 0.6875!
        '
        'Bounce
        '
        Me.Bounce.CanGrow = false
        Me.Bounce.DataField = "Bounce"
        Me.Bounce.Height = 0.1875!
        Me.Bounce.Left = 9.75!
        Me.Bounce.Name = "Bounce"
        Me.Bounce.OutputFormat = resources.GetString("Bounce.OutputFormat")
        Me.Bounce.Style = "text-align: center"
        Me.Bounce.Top = 0.0625!
        Me.Bounce.Width = 0.5!
        '
        'AgencyName
        '
        Me.AgencyName.CanGrow = false
        Me.AgencyName.DataField = "AgencyName"
        Me.AgencyName.Height = 0.1875!
        Me.AgencyName.Left = 0.0625!
        Me.AgencyName.Name = "AgencyName"
        Me.AgencyName.Text = "AgencyName"
        Me.AgencyName.Top = 0.0625!
        Me.AgencyName.Width = 1.4375!
        '
        'Date
        '
        Me.[Date].DataField = "=System.DateTime.Now"
        Me.[Date].Height = 0.1875!
        Me.[Date].Left = 8.125!
        Me.[Date].Name = "Date"
        Me.[Date].OutputFormat = resources.GetString("Date.OutputFormat")
        Me.[Date].Style = "color: DarkGray; text-align: right"
        Me.[Date].Text = "Date"
        Me.[Date].Top = 0.1875!
        Me.[Date].Width = 2.8125!
        '
        'PN
        '
        Me.PN.Height = 0.1875!
        Me.PN.Left = 2!
        Me.PN.Name = "PN"
        Me.PN.OutputFormat = resources.GetString("PN.OutputFormat")
        Me.PN.Style = "color: DarkGray; text-align: center"
        Me.PN.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.PN.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.PageCount
        Me.PN.Text = "#"
        Me.PN.Top = 0.1875!
        Me.PN.Visible = false
        Me.PN.Width = 0.25!
        '
        'PT
        '
        Me.PT.Height = 0.1875!
        Me.PT.Left = 2.3125!
        Me.PT.Name = "PT"
        Me.PT.OutputFormat = resources.GetString("PT.OutputFormat")
        Me.PT.Style = "color: DarkGray; text-align: center"
        Me.PT.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.PageCount
        Me.PT.Text = "##"
        Me.PT.Top = 0.1875!
        Me.PT.Visible = false
        Me.PT.Width = 0.25!
        '
        'PageNumbers
        '
        Me.PageNumbers.Height = 0.1875!
        Me.PageNumbers.HyperLink = Nothing
        Me.PageNumbers.Left = 0!
        Me.PageNumbers.Name = "PageNumbers"
        Me.PageNumbers.Style = "color: DarkGray"
        Me.PageNumbers.Text = "PageNumbers"
        Me.PageNumbers.Top = 0.1875!
        Me.PageNumbers.Width = 1.9375!
        '
        'TextBox8
        '
        Me.TextBox8.DataField = "Amount"
        Me.TextBox8.DistinctField = "Amount"
        Me.TextBox8.Height = 0.1875!
        Me.TextBox8.Left = 7.8125!
        Me.TextBox8.Name = "TextBox8"
        Me.TextBox8.OutputFormat = resources.GetString("TextBox8.OutputFormat")
        Me.TextBox8.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox8.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.TextBox8.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.TextBox8.Text = "SumAmount"
        Me.TextBox8.Top = 0.0625!
        Me.TextBox8.Width = 1.4375!
        '
        'TextBox10
        '
        Me.TextBox10.DataField = "DepositAmount"
        Me.TextBox10.DistinctField = "DepositAmount"
        Me.TextBox10.Height = 0.1875!
        Me.TextBox10.Left = 5.8125!
        Me.TextBox10.Name = "TextBox10"
        Me.TextBox10.OutputFormat = resources.GetString("TextBox10.OutputFormat")
        Me.TextBox10.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox10.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.TextBox10.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.TextBox10.Text = "SumDepAmount"
        Me.TextBox10.Top = 0.0625!
        Me.TextBox10.Width = 0.9375!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 10.98958!
        Me.Sections.Add(Me.ReportHeader)
        Me.Sections.Add(Me.PageHeader)
        Me.Sections.Add(Me.Detail)
        Me.Sections.Add(Me.PageFooter)
        Me.Sections.Add(Me.ReportFooter)
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule(resources.GetString("$this.StyleSheet"), "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: inherit; font-style: inherit; font-variant: inherit; font-weight: bo" & _
                    "ld; font-size: 16pt; font-size-adjust: inherit; font-stretch: inherit", "Heading1", "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: Times New Roman; font-style: italic; font-variant: inherit; font-wei" & _
                    "ght: bold; font-size: 14pt; font-size-adjust: inherit; font-stretch: inherit", "Heading2", "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: inherit; font-style: inherit; font-variant: inherit; font-weight: bo" & _
                    "ld; font-size: 13pt; font-size-adjust: inherit; font-stretch: inherit", "Heading3", "Normal"))
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label4, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label5, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label6, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label7, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label8, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label9, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label10, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label12, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label13, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label14, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientStatusName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DepositMethod, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DepositAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DaysAgo, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TransactionDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DepositDay, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Void, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ACH, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Bounce, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.AgencyName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox8, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox10, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        If Not IsDBNull(Fields("Void").Value) Then
            Void.Text = "X"
        End If
        If Not IsDBNull(Fields("Bounce").Value) Then
            Bounce.Text = "X"
        End If
        If Not IsDBNull(Fields("AchYear").Value) Then
            ACH.Text = "X"
        End If
        If IsDBNull(Fields("DepositMethod").Value) Then
            DepositMethod.Text = "Check"
        End If
    End Sub

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

    End Sub

    Private Sub PageHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageHeader.Format

    End Sub
End Class
