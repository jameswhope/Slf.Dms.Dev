Option Explicit On
Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports

Imports Drg.Util.DataAccess




Imports System
Imports System.Drawing

Public Class checkstoprint
    Inherits GrapeCity.ActiveReports.SectionReport

    Public Sub New()
        MyBase.New()

        InitializeComponent()

        PageSettings.Orientation = PageOrientation.Landscape

        PageSettings.Margins.Top = 0.25
        PageSettings.Margins.Left = 0.25
        PageSettings.Margins.Right = 0.25
        PageSettings.Margins.Bottom = 0.25

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader = Nothing
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private WithEvents ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter = Nothing
    Private Label As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label1 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label3 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label4 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label5 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Line1 As GrapeCity.ActiveReports.SectionReportModel.Line = Nothing
    Private Label6 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label7 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label8 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label9 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label10 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private ClientName As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private BankName As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private BankRoutingNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private BankAccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Amount As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line = Nothing
    Private CheckNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Status As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Created As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private CreatedByName As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Fraction As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Printed As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private [Date] As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private PN As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private PT As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private PageNumbers As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private CountCheckToPrintID As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Label11 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private SumAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(checkstoprint))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.Label = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label1 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label2 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label3 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label4 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label5 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Line1 = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.Label6 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label7 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label8 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label9 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label10 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.ClientName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BankName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BankRoutingNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BankAccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Amount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.CheckNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Status = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Created = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CreatedByName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Fraction = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Printed = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.[Date] = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PT = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PageNumbers = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.CountCheckToPrintID = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label11 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.SumAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Label, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label4, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label5, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label6, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label7, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label8, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label9, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label10, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BankName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BankRoutingNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BankAccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CheckNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Status, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Created, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CreatedByName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Fraction, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Printed, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CountCheckToPrintID, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.ClientName, Me.BankName, Me.BankRoutingNumber, Me.BankAccountNumber, Me.Amount, Me.Separator, Me.CheckNumber, Me.Status, Me.Created, Me.CreatedByName, Me.Fraction, Me.Printed})
        Me.Detail.Height = 0.3222222!
        Me.Detail.Name = "Detail"
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label})
        Me.ReportHeader.Height = 0.625!
        Me.ReportHeader.Name = "ReportHeader"
        '
        'ReportFooter
        '
        Me.ReportFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(240, Byte), Integer), CType(CType(240, Byte), Integer), CType(CType(240, Byte), Integer))
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.CountCheckToPrintID, Me.Label11, Me.SumAmount})
        Me.ReportFooter.Height = 0.3125!
        Me.ReportFooter.Name = "ReportFooter"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label1, Me.Label2, Me.Label3, Me.Label4, Me.Label5, Me.Line1, Me.Label6, Me.Label7, Me.Label8, Me.Label9, Me.Label10})
        Me.PageHeader.Height = 0.3125!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.PageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.[Date], Me.PN, Me.PT, Me.PageNumbers})
        Me.PageFooter.Height = 0.375!
        Me.PageFooter.Name = "PageFooter"
        '
        'Label
        '
        Me.Label.Height = 0.375!
        Me.Label.HyperLink = Nothing
        Me.Label.Left = 0!
        Me.Label.Name = "Label"
        Me.Label.Style = "font-size: 19.5pt; font-weight: normal; ddo-char-set: 1"
        Me.Label.Text = "Checks To Print"
        Me.Label.Top = 0!
        Me.Label.Width = 2.125!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 0.0625!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = ""
        Me.Label1.Text = "Client"
        Me.Label1.Top = 0.0625!
        Me.Label1.Width = 1.1875!
        '
        'Label2
        '
        Me.Label2.Height = 0.1875!
        Me.Label2.HyperLink = Nothing
        Me.Label2.Left = 1.3125!
        Me.Label2.Name = "Label2"
        Me.Label2.Style = ""
        Me.Label2.Text = "Bank"
        Me.Label2.Top = 0.0625!
        Me.Label2.Width = 1.25!
        '
        'Label3
        '
        Me.Label3.Height = 0.1875!
        Me.Label3.HyperLink = Nothing
        Me.Label3.Left = 2.625!
        Me.Label3.Name = "Label3"
        Me.Label3.Style = ""
        Me.Label3.Text = "Routing No."
        Me.Label3.Top = 0.0625!
        Me.Label3.Width = 0.875!
        '
        'Label4
        '
        Me.Label4.Height = 0.1875!
        Me.Label4.HyperLink = Nothing
        Me.Label4.Left = 3.5625!
        Me.Label4.Name = "Label4"
        Me.Label4.Style = ""
        Me.Label4.Text = "Account No."
        Me.Label4.Top = 0.0625!
        Me.Label4.Width = 1!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 4.625!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: right"
        Me.Label5.Text = "Amount"
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
        Me.Line1.Width = 10.5!
        Me.Line1.X1 = 0!
        Me.Line1.X2 = 10.5!
        Me.Line1.Y1 = 0.3125!
        Me.Line1.Y2 = 0.3125!
        '
        'Label6
        '
        Me.Label6.Height = 0.1875!
        Me.Label6.HyperLink = Nothing
        Me.Label6.Left = 5.5625!
        Me.Label6.Name = "Label6"
        Me.Label6.Style = "text-align: left"
        Me.Label6.Text = "Check No."
        Me.Label6.Top = 0.0625!
        Me.Label6.Width = 0.6875!
        '
        'Label7
        '
        Me.Label7.Height = 0.1875!
        Me.Label7.HyperLink = Nothing
        Me.Label7.Left = 6.3125!
        Me.Label7.Name = "Label7"
        Me.Label7.Style = "text-align: left"
        Me.Label7.Text = "Fraction"
        Me.Label7.Top = 0.0625!
        Me.Label7.Width = 0.9375!
        '
        'Label8
        '
        Me.Label8.Height = 0.1875!
        Me.Label8.HyperLink = Nothing
        Me.Label8.Left = 7.3125!
        Me.Label8.Name = "Label8"
        Me.Label8.Style = "text-align: left"
        Me.Label8.Text = "Status"
        Me.Label8.Top = 0.0625!
        Me.Label8.Width = 0.8125!
        '
        'Label9
        '
        Me.Label9.Height = 0.1875!
        Me.Label9.HyperLink = Nothing
        Me.Label9.Left = 8.1875!
        Me.Label9.Name = "Label9"
        Me.Label9.Style = "text-align: left"
        Me.Label9.Text = "Created"
        Me.Label9.Top = 0.0625!
        Me.Label9.Width = 0.875!
        '
        'Label10
        '
        Me.Label10.Height = 0.1875!
        Me.Label10.HyperLink = Nothing
        Me.Label10.Left = 9.125!
        Me.Label10.Name = "Label10"
        Me.Label10.Style = "text-align: left"
        Me.Label10.Text = "Created By"
        Me.Label10.Top = 0.0625!
        Me.Label10.Width = 1.3125!
        '
        'ClientName
        '
        Me.ClientName.Height = 0.1875!
        Me.ClientName.Left = 0.0625!
        Me.ClientName.Name = "ClientName"
        Me.ClientName.Text = "ClientName"
        Me.ClientName.Top = 0.0625!
        Me.ClientName.Width = 1.1875!
        '
        'BankName
        '
        Me.BankName.DataField = "BankName"
        Me.BankName.Height = 0.1875!
        Me.BankName.Left = 1.3125!
        Me.BankName.Name = "BankName"
        Me.BankName.Text = "BankName"
        Me.BankName.Top = 0.0625!
        Me.BankName.Width = 1.25!
        '
        'BankRoutingNumber
        '
        Me.BankRoutingNumber.DataField = "BankRoutingNumber"
        Me.BankRoutingNumber.Height = 0.1875!
        Me.BankRoutingNumber.Left = 2.625!
        Me.BankRoutingNumber.Name = "BankRoutingNumber"
        Me.BankRoutingNumber.Text = "BankRoutingNumber"
        Me.BankRoutingNumber.Top = 0.0625!
        Me.BankRoutingNumber.Width = 0.875!
        '
        'BankAccountNumber
        '
        Me.BankAccountNumber.DataField = "BankAccountNumber"
        Me.BankAccountNumber.Height = 0.1875!
        Me.BankAccountNumber.Left = 3.5625!
        Me.BankAccountNumber.Name = "BankAccountNumber"
        Me.BankAccountNumber.Text = "BankAccountNumber"
        Me.BankAccountNumber.Top = 0.0625!
        Me.BankAccountNumber.Width = 1!
        '
        'Amount
        '
        Me.Amount.DataField = "Amount"
        Me.Amount.Height = 0.1875!
        Me.Amount.Left = 4.625!
        Me.Amount.Name = "Amount"
        Me.Amount.OutputFormat = resources.GetString("Amount.OutputFormat")
        Me.Amount.Style = "color: #009F00; text-align: right"
        Me.Amount.Text = "Amount"
        Me.Amount.Top = 0.0625!
        Me.Amount.Width = 0.8125!
        '
        'Separator
        '
        Me.Separator.Height = 0!
        Me.Separator.Left = 0!
        Me.Separator.LineColor = System.Drawing.Color.FromArgb(CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer), CType(CType(211, Byte), Integer))
        Me.Separator.LineWeight = 1!
        Me.Separator.Name = "Separator"
        Me.Separator.Top = 0.3125!
        Me.Separator.Width = 10.5!
        Me.Separator.X1 = 0!
        Me.Separator.X2 = 10.5!
        Me.Separator.Y1 = 0.3125!
        Me.Separator.Y2 = 0.3125!
        '
        'CheckNumber
        '
        Me.CheckNumber.DataField = "CheckNumber"
        Me.CheckNumber.Height = 0.1875!
        Me.CheckNumber.Left = 5.5625!
        Me.CheckNumber.Name = "CheckNumber"
        Me.CheckNumber.Text = "CheckNumber"
        Me.CheckNumber.Top = 0.0625!
        Me.CheckNumber.Width = 0.6875!
        '
        'Status
        '
        Me.Status.Height = 0.1875!
        Me.Status.Left = 7.3125!
        Me.Status.Name = "Status"
        Me.Status.Text = "Status"
        Me.Status.Top = 0.0625!
        Me.Status.Width = 0.8125!
        '
        'Created
        '
        Me.Created.DataField = "Created"
        Me.Created.Height = 0.1875!
        Me.Created.Left = 8.1875!
        Me.Created.Name = "Created"
        Me.Created.OutputFormat = resources.GetString("Created.OutputFormat")
        Me.Created.Text = "Created"
        Me.Created.Top = 0.0625!
        Me.Created.Width = 0.875!
        '
        'CreatedByName
        '
        Me.CreatedByName.DataField = "CreatedByName"
        Me.CreatedByName.Height = 0.1875!
        Me.CreatedByName.Left = 9.125!
        Me.CreatedByName.Name = "CreatedByName"
        Me.CreatedByName.OutputFormat = resources.GetString("CreatedByName.OutputFormat")
        Me.CreatedByName.Text = "CreatedByName"
        Me.CreatedByName.Top = 0.0625!
        Me.CreatedByName.Width = 1.3125!
        '
        'Fraction
        '
        Me.Fraction.DataField = "Fraction"
        Me.Fraction.Height = 0.1875!
        Me.Fraction.Left = 6.3125!
        Me.Fraction.Name = "Fraction"
        Me.Fraction.Text = "Fraction"
        Me.Fraction.Top = 0.0625!
        Me.Fraction.Width = 0.9375!
        '
        'Printed
        '
        Me.Printed.DataField = "Printed"
        Me.Printed.Height = 0!
        Me.Printed.Left = 7.3125!
        Me.Printed.Name = "Printed"
        Me.Printed.OutputFormat = resources.GetString("Printed.OutputFormat")
        Me.Printed.Style = "color: #787878; font-family: Tahoma; font-size: 7.5pt; ddo-char-set: 1"
        Me.Printed.Text = "Printed"
        Me.Printed.Top = 0.25!
        Me.Printed.Width = 0.8125!
        '
        'Date
        '
        Me.[Date].DataField = "=System.DateTime.Now"
        Me.[Date].Height = 0.1875!
        Me.[Date].Left = 7.6875!
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
        'CountCheckToPrintID
        '
        Me.CountCheckToPrintID.DataField = "CheckToPrintID"
        Me.CountCheckToPrintID.DistinctField = "CheckToPrintID"
        Me.CountCheckToPrintID.Height = 0.1875!
        Me.CountCheckToPrintID.Left = 0.5!
        Me.CountCheckToPrintID.Name = "CountCheckToPrintID"
        Me.CountCheckToPrintID.OutputFormat = resources.GetString("CountCheckToPrintID.OutputFormat")
        Me.CountCheckToPrintID.Style = "font-weight: bold"
        Me.CountCheckToPrintID.SummaryFunc = GrapeCity.ActiveReports.SectionReportModel.SummaryFunc.Count
        Me.CountCheckToPrintID.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.CountCheckToPrintID.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.CountCheckToPrintID.Text = "CountCheckToPrintID"
        Me.CountCheckToPrintID.Top = 0.0625!
        Me.CountCheckToPrintID.Width = 0.9375!
        '
        'Label11
        '
        Me.Label11.Height = 0.1875!
        Me.Label11.HyperLink = Nothing
        Me.Label11.Left = 0.0625!
        Me.Label11.Name = "Label11"
        Me.Label11.Style = "font-weight: bold"
        Me.Label11.Text = "Total:"
        Me.Label11.Top = 0.0625!
        Me.Label11.Width = 0.4375!
        '
        'SumAmount
        '
        Me.SumAmount.DataField = "Amount"
        Me.SumAmount.DistinctField = "Amount"
        Me.SumAmount.Height = 0.1875!
        Me.SumAmount.Left = 4!
        Me.SumAmount.Name = "SumAmount"
        Me.SumAmount.OutputFormat = resources.GetString("SumAmount.OutputFormat")
        Me.SumAmount.Style = "color: #009F00; font-weight: bold; text-align: right"
        Me.SumAmount.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.SumAmount.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.SumAmount.Text = "SumAmount"
        Me.SumAmount.Top = 0.0625!
        Me.SumAmount.Width = 1.4375!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 10.5!
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
        CType(Me.Label, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label4, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label5, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label6, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label7, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label8, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label9, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label10, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BankName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BankRoutingNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BankAccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CheckNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Status, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Created, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CreatedByName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Fraction, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Printed, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CountCheckToPrintID, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

        If Not Fields("Printed").Value Is Nothing And Fields("Printed").Value.ToString().Length > 0 Then

            Status.Text = "Printed"
            Status.ForeColor = Color.FromArgb(0, 0, 220)

            Printed.Visible = True

        Else

            Status.Text = "Not Printed"
            Status.ForeColor = Color.Red

            Printed.Visible = False

        End If

        ClientName.Text = Fields("FirstName").Value.ToString() & " " & Fields("LastName").Value.ToString()

    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub
End Class