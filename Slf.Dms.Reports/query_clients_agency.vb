Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Public Class query_clients_agency
    Inherits GrapeCity.ActiveReports.SectionReport
    Public Sub New()
        MyBase.New()
        InitializeComponent()
    End Sub
#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader = Nothing
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents sortofPageHeader As GrapeCity.ActiveReports.SectionReportModel.GroupHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents sortofPageFooter As GrapeCity.ActiveReports.SectionReportModel.GroupFooter = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private WithEvents ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter = Nothing
    Private Label16 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label1 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label
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
    Private AccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private LeadNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ReceivedLSA As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ClientStatusName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line
    Private DateSent As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private FirstName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private LastName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private SSN As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private DateReceived As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private DepositMethod As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private DepositAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private DebtTotal As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private [Date] As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PN As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PT As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PageNumbers As GrapeCity.ActiveReports.SectionReportModel.Label
    Private TextBox8 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox9 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private CountCommPayId As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Label11 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(query_clients_agency))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.sortofPageHeader = New GrapeCity.ActiveReports.SectionReportModel.GroupHeader()
        Me.sortofPageFooter = New GrapeCity.ActiveReports.SectionReportModel.GroupFooter()
        Me.Label16 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label1 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label2 = New GrapeCity.ActiveReports.SectionReportModel.Label()
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
        Me.AccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.LeadNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ReceivedLSA = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientStatusName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.DateSent = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.FirstName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.LastName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.SSN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.DateReceived = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.DepositMethod = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.DepositAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.DebtTotal = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.[Date] = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PT = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PageNumbers = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.TextBox8 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox9 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CountCommPayId = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label11 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).BeginInit
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
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.LeadNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ReceivedLSA, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientStatusName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DateSent, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SSN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DateReceived, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DepositMethod, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DepositAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.DebtTotal, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox8, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox9, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CountCommPayId, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.AccountNumber, Me.LeadNumber, Me.ReceivedLSA, Me.ClientStatusName, Me.Separator, Me.DateSent, Me.FirstName, Me.LastName, Me.SSN, Me.DateReceived, Me.DepositMethod, Me.DepositAmount, Me.DebtTotal})
        Me.Detail.Height = 0.3333333!
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
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.TextBox8, Me.TextBox9, Me.CountCommPayId, Me.Label11})
        Me.ReportFooter.Height = 0.2909722!
        Me.ReportFooter.KeepTogether = true
        Me.ReportFooter.Name = "ReportFooter"
        '
        'PageHeader
        '
        Me.PageHeader.Height = 0!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.[Date], Me.PN, Me.PT, Me.PageNumbers})
        Me.PageFooter.Height = 0.4375!
        Me.PageFooter.Name = "PageFooter"
        '
        'sortofPageHeader
        '
        Me.sortofPageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label1, Me.Label2, Me.Label4, Me.Label5, Me.Line1, Me.Label6, Me.Label7, Me.Label8, Me.Label9, Me.Label10, Me.Label12, Me.Label13, Me.Label14})
        Me.sortofPageHeader.Height = 0.2708333!
        Me.sortofPageHeader.Name = "sortofPageHeader"
        Me.sortofPageHeader.RepeatStyle = GrapeCity.ActiveReports.SectionReportModel.RepeatStyle.OnPageIncludeNoDetail
        '
        'sortofPageFooter
        '
        Me.sortofPageFooter.Height = 0!
        Me.sortofPageFooter.Name = "sortofPageFooter"
        '
        'Label16
        '
        Me.Label16.Height = 0.1875!
        Me.Label16.HyperLink = Nothing
        Me.Label16.Left = 0.0625!
        Me.Label16.Name = "Label16"
        Me.Label16.Style = "font-size: 9.75pt; font-weight: bold; text-align: left; ddo-char-set: 0"
        Me.Label16.Text = "Query Results - My Clients:"
        Me.Label16.Top = 0!
        Me.Label16.Width = 4.375!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 0.0625!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = "text-align: left"
        Me.Label1.Text = "Acct. #"
        Me.Label1.Top = 0!
        Me.Label1.Width = 0.6875!
        '
        'Label2
        '
        Me.Label2.Height = 0.1875!
        Me.Label2.HyperLink = Nothing
        Me.Label2.Left = 0.75!
        Me.Label2.Name = "Label2"
        Me.Label2.Style = "text-align: left"
        Me.Label2.Text = "Lead #"
        Me.Label2.Top = 0!
        Me.Label2.Width = 0.875!
        '
        'Label4
        '
        Me.Label4.Height = 0.1875!
        Me.Label4.HyperLink = Nothing
        Me.Label4.Left = 1.625!
        Me.Label4.Name = "Label4"
        Me.Label4.Style = "text-align: center"
        Me.Label4.Text = "LSA"
        Me.Label4.Top = 0!
        Me.Label4.Width = 0.3125!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 1.9375!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: left"
        Me.Label5.Text = "Status"
        Me.Label5.Top = 0!
        Me.Label5.Width = 1.125!
        '
        'Line1
        '
        Me.Line1.Height = 0!
        Me.Line1.Left = 0!
        Me.Line1.LineWeight = 3!
        Me.Line1.Name = "Line1"
        Me.Line1.Top = 0.25!
        Me.Line1.Width = 11.25!
        Me.Line1.X1 = 0!
        Me.Line1.X2 = 11.25!
        Me.Line1.Y1 = 0.25!
        Me.Line1.Y2 = 0.25!
        '
        'Label6
        '
        Me.Label6.Height = 0.1875!
        Me.Label6.HyperLink = Nothing
        Me.Label6.Left = 3.0625!
        Me.Label6.Name = "Label6"
        Me.Label6.Style = "text-align: center"
        Me.Label6.Text = "Date Sent"
        Me.Label6.Top = 0!
        Me.Label6.Width = 0.9375!
        '
        'Label7
        '
        Me.Label7.Height = 0.1875!
        Me.Label7.HyperLink = Nothing
        Me.Label7.Left = 4!
        Me.Label7.Name = "Label7"
        Me.Label7.Style = "text-align: center"
        Me.Label7.Text = "Date Received"
        Me.Label7.Top = 0!
        Me.Label7.Width = 1!
        '
        'Label8
        '
        Me.Label8.Height = 0.1875!
        Me.Label8.HyperLink = Nothing
        Me.Label8.Left = 5!
        Me.Label8.Name = "Label8"
        Me.Label8.Style = "text-align: left"
        Me.Label8.Text = "First Name"
        Me.Label8.Top = 0!
        Me.Label8.Width = 1.3125!
        '
        'Label9
        '
        Me.Label9.Height = 0.1875!
        Me.Label9.HyperLink = Nothing
        Me.Label9.Left = 6.3125!
        Me.Label9.Name = "Label9"
        Me.Label9.Style = "text-align: left"
        Me.Label9.Text = "Last Name"
        Me.Label9.Top = 0!
        Me.Label9.Width = 1.3125!
        '
        'Label10
        '
        Me.Label10.Height = 0.1875!
        Me.Label10.HyperLink = Nothing
        Me.Label10.Left = 7.625!
        Me.Label10.Name = "Label10"
        Me.Label10.Style = "text-align: left"
        Me.Label10.Text = "SSN"
        Me.Label10.Top = 0!
        Me.Label10.Width = 0.9375!
        '
        'Label12
        '
        Me.Label12.Height = 0.1875!
        Me.Label12.HyperLink = Nothing
        Me.Label12.Left = 8.5625!
        Me.Label12.Name = "Label12"
        Me.Label12.Style = "text-align: left"
        Me.Label12.Text = "Pmt. Type"
        Me.Label12.Top = 0!
        Me.Label12.Width = 0.6875!
        '
        'Label13
        '
        Me.Label13.Height = 0.1875!
        Me.Label13.HyperLink = Nothing
        Me.Label13.Left = 9.25!
        Me.Label13.Name = "Label13"
        Me.Label13.Style = "text-align: right"
        Me.Label13.Text = "Pmt. Amt."
        Me.Label13.Top = 0!
        Me.Label13.Width = 0.75!
        '
        'Label14
        '
        Me.Label14.Height = 0.1875!
        Me.Label14.HyperLink = Nothing
        Me.Label14.Left = 10!
        Me.Label14.Name = "Label14"
        Me.Label14.Style = "text-align: right"
        Me.Label14.Text = "Debt Total"
        Me.Label14.Top = 0!
        Me.Label14.Width = 0.9375!
        '
        'AccountNumber
        '
        Me.AccountNumber.CanGrow = false
        Me.AccountNumber.DataField = "AccountNumber"
        Me.AccountNumber.Height = 0.1875!
        Me.AccountNumber.Left = 0.0625!
        Me.AccountNumber.Name = "AccountNumber"
        Me.AccountNumber.Style = "text-align: left"
        Me.AccountNumber.Text = "AccountNumber"
        Me.AccountNumber.Top = 0.0625!
        Me.AccountNumber.Width = 0.6875!
        '
        'LeadNumber
        '
        Me.LeadNumber.CanGrow = false
        Me.LeadNumber.DataField = "LeadNumber"
        Me.LeadNumber.Height = 0.1875!
        Me.LeadNumber.Left = 0.75!
        Me.LeadNumber.Name = "LeadNumber"
        Me.LeadNumber.OutputFormat = resources.GetString("LeadNumber.OutputFormat")
        Me.LeadNumber.Style = "text-align: left"
        Me.LeadNumber.Text = "LeadNumber"
        Me.LeadNumber.Top = 0.0625!
        Me.LeadNumber.Width = 0.875!
        '
        'ReceivedLSA
        '
        Me.ReceivedLSA.CanGrow = false
        Me.ReceivedLSA.DataField = "ReceivedLSA"
        Me.ReceivedLSA.Height = 0.1875!
        Me.ReceivedLSA.Left = 1.625!
        Me.ReceivedLSA.Name = "ReceivedLSA"
        Me.ReceivedLSA.Style = "text-align: center; vertical-align: top"
        Me.ReceivedLSA.Text = "ReceivedLSA"
        Me.ReceivedLSA.Top = 0.0625!
        Me.ReceivedLSA.Width = 0.3125!
        '
        'ClientStatusName
        '
        Me.ClientStatusName.CanGrow = false
        Me.ClientStatusName.DataField = "ClientStatusName"
        Me.ClientStatusName.Height = 0.1875!
        Me.ClientStatusName.Left = 1.9375!
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
        'DateSent
        '
        Me.DateSent.CanGrow = false
        Me.DateSent.DataField = "DateSent"
        Me.DateSent.Height = 0.1875!
        Me.DateSent.Left = 3.0625!
        Me.DateSent.Name = "DateSent"
        Me.DateSent.OutputFormat = resources.GetString("DateSent.OutputFormat")
        Me.DateSent.Style = "text-align: center"
        Me.DateSent.Text = "DateSent"
        Me.DateSent.Top = 0.0625!
        Me.DateSent.Width = 0.9375!
        '
        'FirstName
        '
        Me.FirstName.CanGrow = false
        Me.FirstName.DataField = "FirstName"
        Me.FirstName.Height = 0.1875!
        Me.FirstName.Left = 5!
        Me.FirstName.Name = "FirstName"
        Me.FirstName.OutputFormat = resources.GetString("FirstName.OutputFormat")
        Me.FirstName.Style = "text-align: left"
        Me.FirstName.Text = "FirstName"
        Me.FirstName.Top = 0.0625!
        Me.FirstName.Width = 1.3125!
        '
        'LastName
        '
        Me.LastName.CanGrow = false
        Me.LastName.DataField = "LastName"
        Me.LastName.Height = 0.1875!
        Me.LastName.Left = 6.3125!
        Me.LastName.Name = "LastName"
        Me.LastName.OutputFormat = resources.GetString("LastName.OutputFormat")
        Me.LastName.Style = "text-align: left"
        Me.LastName.Text = "LastName"
        Me.LastName.Top = 0.0625!
        Me.LastName.Width = 1.3125!
        '
        'SSN
        '
        Me.SSN.CanGrow = false
        Me.SSN.DataField = "SSN"
        Me.SSN.Height = 0.1875!
        Me.SSN.Left = 7.625!
        Me.SSN.Name = "SSN"
        Me.SSN.OutputFormat = resources.GetString("SSN.OutputFormat")
        Me.SSN.Style = "color: Black; text-align: left"
        Me.SSN.Text = "SSN"
        Me.SSN.Top = 0.0625!
        Me.SSN.Width = 0.9375!
        '
        'DateReceived
        '
        Me.DateReceived.CanGrow = false
        Me.DateReceived.DataField = "DateReceived"
        Me.DateReceived.Height = 0.1875!
        Me.DateReceived.Left = 4!
        Me.DateReceived.Name = "DateReceived"
        Me.DateReceived.OutputFormat = resources.GetString("DateReceived.OutputFormat")
        Me.DateReceived.Style = "text-align: center"
        Me.DateReceived.Text = "DateReceived"
        Me.DateReceived.Top = 0.0625!
        Me.DateReceived.Width = 1!
        '
        'DepositMethod
        '
        Me.DepositMethod.CanGrow = false
        Me.DepositMethod.DataField = "DepositMethod"
        Me.DepositMethod.Height = 0.1875!
        Me.DepositMethod.Left = 8.5625!
        Me.DepositMethod.Name = "DepositMethod"
        Me.DepositMethod.OutputFormat = resources.GetString("DepositMethod.OutputFormat")
        Me.DepositMethod.Style = "text-align: left"
        Me.DepositMethod.Text = "DepositMethod"
        Me.DepositMethod.Top = 0.0625!
        Me.DepositMethod.Width = 0.6875!
        '
        'DepositAmount
        '
        Me.DepositAmount.CanGrow = false
        Me.DepositAmount.DataField = "DepositAmount"
        Me.DepositAmount.Height = 0.1875!
        Me.DepositAmount.Left = 9.25!
        Me.DepositAmount.Name = "DepositAmount"
        Me.DepositAmount.OutputFormat = resources.GetString("DepositAmount.OutputFormat")
        Me.DepositAmount.Style = "text-align: right"
        Me.DepositAmount.Text = "DepositAmount"
        Me.DepositAmount.Top = 0.0625!
        Me.DepositAmount.Width = 0.75!
        '
        'DebtTotal
        '
        Me.DebtTotal.CanGrow = false
        Me.DebtTotal.DataField = "DebtTotal"
        Me.DebtTotal.Height = 0.1875!
        Me.DebtTotal.Left = 10!
        Me.DebtTotal.Name = "DebtTotal"
        Me.DebtTotal.OutputFormat = resources.GetString("DebtTotal.OutputFormat")
        Me.DebtTotal.Style = "text-align: right"
        Me.DebtTotal.Text = "DebtTotal"
        Me.DebtTotal.Top = 0.0625!
        Me.DebtTotal.Width = 0.9375!
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
        Me.TextBox8.DataField = "DebtTotal"
        Me.TextBox8.DistinctField = "DebtTotal"
        Me.TextBox8.Height = 0.1875!
        Me.TextBox8.Left = 10!
        Me.TextBox8.Name = "TextBox8"
        Me.TextBox8.OutputFormat = resources.GetString("TextBox8.OutputFormat")
        Me.TextBox8.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox8.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.TextBox8.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.TextBox8.Text = "Sum"
        Me.TextBox8.Top = 0.0625!
        Me.TextBox8.Width = 0.9375!
        '
        'TextBox9
        '
        Me.TextBox9.DataField = "DepositAmount"
        Me.TextBox9.DistinctField = "DepositAmount"
        Me.TextBox9.Height = 0.1875!
        Me.TextBox9.Left = 8.9375!
        Me.TextBox9.Name = "TextBox9"
        Me.TextBox9.OutputFormat = resources.GetString("TextBox9.OutputFormat")
        Me.TextBox9.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox9.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.TextBox9.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.TextBox9.Text = "Sum"
        Me.TextBox9.Top = 0.0625!
        Me.TextBox9.Width = 1.0625!
        '
        'CountCommPayId
        '
        Me.CountCommPayId.DataField = "CommPayId"
        Me.CountCommPayId.DistinctField = "CommPayId"
        Me.CountCommPayId.Height = 0.1875!
        Me.CountCommPayId.Left = 1!
        Me.CountCommPayId.Name = "CountCommPayId"
        Me.CountCommPayId.OutputFormat = resources.GetString("CountCommPayId.OutputFormat")
        Me.CountCommPayId.Style = "font-weight: bold"
        Me.CountCommPayId.SummaryFunc = GrapeCity.ActiveReports.SectionReportModel.SummaryFunc.Count
        Me.CountCommPayId.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.CountCommPayId.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.CountCommPayId.Text = "CountCommPayId"
        Me.CountCommPayId.Top = 0.0625!
        Me.CountCommPayId.Width = 1.5!
        '
        'Label11
        '
        Me.Label11.Height = 0.1875!
        Me.Label11.HyperLink = Nothing
        Me.Label11.Left = 0.0625!
        Me.Label11.Name = "Label11"
        Me.Label11.Style = "font-weight: bold"
        Me.Label11.Text = "Grand Total:"
        Me.Label11.Top = 0.0625!
        Me.Label11.Width = 0.9375!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 10.98958!
        Me.Sections.Add(Me.ReportHeader)
        Me.Sections.Add(Me.PageHeader)
        Me.Sections.Add(Me.sortofPageHeader)
        Me.Sections.Add(Me.Detail)
        Me.Sections.Add(Me.sortofPageFooter)
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
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).EndInit
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
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.LeadNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ReceivedLSA, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientStatusName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DateSent, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SSN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DateReceived, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DepositMethod, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DepositAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.DebtTotal, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox8, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox9, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CountCommPayId, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region
    Private Function nz_bool(ByVal o As Object) As Boolean
        If IsDBNull(o) Then
            Return False
        Else
            Return CType(o, Boolean)
        End If
    End Function
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        ReceivedLSA.Text = IIf(nz_bool(Fields("ReceivedLSA").Value), "X", "")
    End Sub

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

    End Sub
End Class
