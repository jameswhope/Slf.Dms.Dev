Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Public Class report_clients_accountsoverpercentage
    Inherits GrapeCity.ActiveReports.SectionReport
    Public Sub New()
        MyBase.New()
        InitializeComponent()
    End Sub
#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader = Nothing
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents GroupHeader1 As GrapeCity.ActiveReports.SectionReportModel.GroupHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents GroupFooter1 As GrapeCity.ActiveReports.SectionReportModel.GroupFooter = Nothing
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
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private FullName1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private SDABalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private SSN1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private AgencyName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private FullName2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private SSN2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private CreditorName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private CreditorAccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private AccountBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private MinAvailable As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private CreditorPhone As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Line As GrapeCity.ActiveReports.SectionReportModel.Line
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line
    Private [Date] As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PN As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PT As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PageNumbers As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(report_clients_accountsoverpercentage))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.GroupHeader1 = New GrapeCity.ActiveReports.SectionReportModel.GroupHeader()
        Me.GroupFooter1 = New GrapeCity.ActiveReports.SectionReportModel.GroupFooter()
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
        Me.Label2 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.FullName1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.SDABalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.SSN1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.AgencyName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.FullName2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.SSN2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CreditorName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CreditorAccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.AccountBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.MinAvailable = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CreditorPhone = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Line = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.[Date] = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PT = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PageNumbers = New GrapeCity.ActiveReports.SectionReportModel.Label()
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label4, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label5, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label6, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label7, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label8, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label9, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label10, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FullName1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SDABalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SSN1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.AgencyName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FullName2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SSN2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CreditorName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CreditorAccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.AccountBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.MinAvailable, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CreditorPhone, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.CreditorName, Me.CreditorAccountNumber, Me.AccountBalance, Me.MinAvailable, Me.CreditorPhone, Me.Line})
        Me.Detail.Height = 0.2388889!
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
        Me.ReportFooter.Height = 0!
        Me.ReportFooter.KeepTogether = true
        Me.ReportFooter.Name = "ReportFooter"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label1, Me.Label4, Me.Label5, Me.Line1, Me.Label6, Me.Label7, Me.Label8, Me.Label9, Me.Label10, Me.Label2})
        Me.PageHeader.Height = 0.375!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.[Date], Me.PN, Me.PT, Me.PageNumbers})
        Me.PageFooter.Height = 0.4375!
        Me.PageFooter.Name = "PageFooter"
        '
        'GroupHeader1
        '
        Me.GroupHeader1.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.FullName1, Me.SDABalance, Me.SSN1, Me.AgencyName, Me.FullName2, Me.SSN2})
        Me.GroupHeader1.DataField = "ClientID"
        Me.GroupHeader1.Height = 0.4472222!
        Me.GroupHeader1.Name = "GroupHeader1"
        '
        'GroupFooter1
        '
        Me.GroupFooter1.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Separator})
        Me.GroupFooter1.Height = 0.02083333!
        Me.GroupFooter1.Name = "GroupFooter1"
        '
        'Label16
        '
        Me.Label16.Height = 0.1875!
        Me.Label16.HyperLink = Nothing
        Me.Label16.Left = 0.0625!
        Me.Label16.Name = "Label16"
        Me.Label16.Style = "font-size: 9.75pt; font-weight: bold; text-align: left; ddo-char-set: 0"
        Me.Label16.Text = "Query Results - Accounts Over Percentage"
        Me.Label16.Top = 0!
        Me.Label16.Width = 4.375!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 1.8125!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = ""
        Me.Label1.Text = "Full Name"
        Me.Label1.Top = 0.0625!
        Me.Label1.Width = 2.125!
        '
        'Label4
        '
        Me.Label4.Height = 0.1875!
        Me.Label4.HyperLink = Nothing
        Me.Label4.Left = 1!
        Me.Label4.Name = "Label4"
        Me.Label4.Style = "text-align: right"
        Me.Label4.Text = "SDA Bal."
        Me.Label4.Top = 0.0625!
        Me.Label4.Width = 0.75!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 4!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: left"
        Me.Label5.Text = "SSN"
        Me.Label5.Top = 0.0625!
        Me.Label5.Width = 0.8125!
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
        Me.Label6.Text = "Creditor"
        Me.Label6.Top = 0.0625!
        Me.Label6.Width = 1.625!
        '
        'Label7
        '
        Me.Label7.Height = 0.1875!
        Me.Label7.HyperLink = Nothing
        Me.Label7.Left = 6.5625!
        Me.Label7.Name = "Label7"
        Me.Label7.Style = "text-align: left"
        Me.Label7.Text = "Phone"
        Me.Label7.Top = 0.0625!
        Me.Label7.Width = 0.9375!
        '
        'Label8
        '
        Me.Label8.Height = 0.1875!
        Me.Label8.HyperLink = Nothing
        Me.Label8.Left = 7.5625!
        Me.Label8.Name = "Label8"
        Me.Label8.Style = "text-align: left"
        Me.Label8.Text = "Account No."
        Me.Label8.Top = 0.0625!
        Me.Label8.Width = 1.75!
        '
        'Label9
        '
        Me.Label9.Height = 0.1875!
        Me.Label9.HyperLink = Nothing
        Me.Label9.Left = 9.375!
        Me.Label9.Name = "Label9"
        Me.Label9.Style = "text-align: right"
        Me.Label9.Text = "Balance"
        Me.Label9.Top = 0.0625!
        Me.Label9.Width = 0.75!
        '
        'Label10
        '
        Me.Label10.Height = 0.1875!
        Me.Label10.HyperLink = Nothing
        Me.Label10.Left = 10.1875!
        Me.Label10.Name = "Label10"
        Me.Label10.Style = "text-align: right"
        Me.Label10.Text = "Min Ava."
        Me.Label10.Top = 0.0625!
        Me.Label10.Width = 0.75!
        '
        'Label2
        '
        Me.Label2.Height = 0.1875!
        Me.Label2.HyperLink = Nothing
        Me.Label2.Left = 0.0625!
        Me.Label2.Name = "Label2"
        Me.Label2.Style = ""
        Me.Label2.Text = "Acct No."
        Me.Label2.Top = 0.0625!
        Me.Label2.Width = 0.875!
        '
        'FullName1
        '
        Me.FullName1.CanGrow = false
        Me.FullName1.DataField = "FullName1"
        Me.FullName1.Height = 0.1875!
        Me.FullName1.Left = 1.8125!
        Me.FullName1.Name = "FullName1"
        Me.FullName1.Text = "FullName1"
        Me.FullName1.Top = 0.03125!
        Me.FullName1.Width = 2.125!
        '
        'SDABalance
        '
        Me.SDABalance.CanGrow = false
        Me.SDABalance.DataField = "SDABalance"
        Me.SDABalance.Height = 0.1875!
        Me.SDABalance.Left = 1!
        Me.SDABalance.Name = "SDABalance"
        Me.SDABalance.OutputFormat = resources.GetString("SDABalance.OutputFormat")
        Me.SDABalance.Style = "text-align: right"
        Me.SDABalance.Text = "SDABalance"
        Me.SDABalance.Top = 0.03125!
        Me.SDABalance.Width = 0.75!
        '
        'SSN1
        '
        Me.SSN1.CanGrow = false
        Me.SSN1.DataField = "SSN1"
        Me.SSN1.Height = 0.1875!
        Me.SSN1.Left = 4!
        Me.SSN1.Name = "SSN1"
        Me.SSN1.OutputFormat = resources.GetString("SSN1.OutputFormat")
        Me.SSN1.Style = "text-align: left"
        Me.SSN1.Text = "SSN1"
        Me.SSN1.Top = 0.03125!
        Me.SSN1.Width = 0.8125!
        '
        'AgencyName
        '
        Me.AgencyName.CanGrow = false
        Me.AgencyName.DataField = "AccountNumber"
        Me.AgencyName.Height = 0.1875!
        Me.AgencyName.Left = 0!
        Me.AgencyName.Name = "AgencyName"
        Me.AgencyName.Text = "AccountNumber"
        Me.AgencyName.Top = 0.03125!
        Me.AgencyName.Width = 0.875!
        '
        'FullName2
        '
        Me.FullName2.CanGrow = false
        Me.FullName2.DataField = "FullName2"
        Me.FullName2.Height = 0.1875!
        Me.FullName2.Left = 1.8125!
        Me.FullName2.Name = "FullName2"
        Me.FullName2.Text = "FullName2"
        Me.FullName2.Top = 0.21875!
        Me.FullName2.Width = 2.125!
        '
        'SSN2
        '
        Me.SSN2.CanGrow = false
        Me.SSN2.DataField = "SSN2"
        Me.SSN2.Height = 0.1875!
        Me.SSN2.Left = 4!
        Me.SSN2.Name = "SSN2"
        Me.SSN2.OutputFormat = resources.GetString("SSN2.OutputFormat")
        Me.SSN2.Style = "text-align: left"
        Me.SSN2.Text = "SSN2"
        Me.SSN2.Top = 0.21875!
        Me.SSN2.Width = 0.8125!
        '
        'CreditorName
        '
        Me.CreditorName.CanGrow = false
        Me.CreditorName.DataField = "CreditorName"
        Me.CreditorName.Height = 0.1875!
        Me.CreditorName.Left = 4.875!
        Me.CreditorName.Name = "CreditorName"
        Me.CreditorName.Text = "CreditorName"
        Me.CreditorName.Top = 0.03125!
        Me.CreditorName.Width = 1.625!
        '
        'CreditorAccountNumber
        '
        Me.CreditorAccountNumber.CanGrow = false
        Me.CreditorAccountNumber.DataField = "CreditorAccountNumber"
        Me.CreditorAccountNumber.Height = 0.1875!
        Me.CreditorAccountNumber.Left = 7.5625!
        Me.CreditorAccountNumber.Name = "CreditorAccountNumber"
        Me.CreditorAccountNumber.OutputFormat = resources.GetString("CreditorAccountNumber.OutputFormat")
        Me.CreditorAccountNumber.Style = "text-align: left"
        Me.CreditorAccountNumber.Text = "CreditorAccountNumber"
        Me.CreditorAccountNumber.Top = 0.03125!
        Me.CreditorAccountNumber.Width = 1.75!
        '
        'AccountBalance
        '
        Me.AccountBalance.CanGrow = false
        Me.AccountBalance.DataField = "AccountBalance"
        Me.AccountBalance.Height = 0.1875!
        Me.AccountBalance.Left = 9.375!
        Me.AccountBalance.Name = "AccountBalance"
        Me.AccountBalance.OutputFormat = resources.GetString("AccountBalance.OutputFormat")
        Me.AccountBalance.Style = "text-align: right"
        Me.AccountBalance.Text = "AccountBalance"
        Me.AccountBalance.Top = 0.03125!
        Me.AccountBalance.Width = 0.75!
        '
        'MinAvailable
        '
        Me.MinAvailable.CanGrow = false
        Me.MinAvailable.Height = 0.1875!
        Me.MinAvailable.Left = 10.1875!
        Me.MinAvailable.Name = "MinAvailable"
        Me.MinAvailable.OutputFormat = resources.GetString("MinAvailable.OutputFormat")
        Me.MinAvailable.Style = "text-align: right"
        Me.MinAvailable.Text = "MinAvailable"
        Me.MinAvailable.Top = 0.03125!
        Me.MinAvailable.Width = 0.75!
        '
        'CreditorPhone
        '
        Me.CreditorPhone.CanGrow = false
        Me.CreditorPhone.DataField = "CreditorPhone"
        Me.CreditorPhone.Height = 0.1875!
        Me.CreditorPhone.Left = 6.5625!
        Me.CreditorPhone.Name = "CreditorPhone"
        Me.CreditorPhone.Style = "text-align: left"
        Me.CreditorPhone.Text = "CreditorPhone"
        Me.CreditorPhone.Top = 0.03125!
        Me.CreditorPhone.Width = 0.9375!
        '
        'Line
        '
        Me.Line.Height = 0!
        Me.Line.Left = 4.875!
        Me.Line.LineColor = System.Drawing.Color.FromArgb(CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer))
        Me.Line.LineWeight = 1!
        Me.Line.Name = "Line"
        Me.Line.Top = 0!
        Me.Line.Width = 6.25!
        Me.Line.X1 = 4.875!
        Me.Line.X2 = 11.125!
        Me.Line.Y1 = 0!
        Me.Line.Y2 = 0!
        '
        'Separator
        '
        Me.Separator.Height = 0!
        Me.Separator.Left = 0!
        Me.Separator.LineColor = System.Drawing.Color.FromArgb(CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer))
        Me.Separator.LineWeight = 1!
        Me.Separator.Name = "Separator"
        Me.Separator.Top = 0!
        Me.Separator.Width = 11.125!
        Me.Separator.X1 = 0!
        Me.Separator.X2 = 11.125!
        Me.Separator.Y1 = 0!
        Me.Separator.Y2 = 0!
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
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 10.98958!
        Me.Sections.Add(Me.ReportHeader)
        Me.Sections.Add(Me.PageHeader)
        Me.Sections.Add(Me.GroupHeader1)
        Me.Sections.Add(Me.Detail)
        Me.Sections.Add(Me.GroupFooter1)
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
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FullName1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SDABalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SSN1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.AgencyName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FullName2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SSN2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CreditorName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CreditorAccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.AccountBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.MinAvailable, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CreditorPhone, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region
    Private Function IsNull(ByVal o1 As Object, ByVal o2 As Object) As Object
        If IsDBNull(o1) Then
            Return o2
        Else
            Return o1
        End If
    End Function
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        MinAvailable.Text = (CType(IsNull(Fields("AccountBalance").Value, 0), Single) * CType(IsNull(Fields("percent1").Value, 0), Single)).ToString("c")
    End Sub

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

    End Sub

    Private Sub PageHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageHeader.Format

    End Sub

    Private Sub GroupHeader1_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles GroupHeader1.Format
        FullName1.Text = Fields("FirstName1").Value & " " & Fields("LastName1").Value
        FullName2.Text = Fields("FirstName2").Value & " " & Fields("LastName2").Value
    End Sub
End Class
