Option Explicit On
Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports

Imports Drg.Util.DataAccess




Imports System
Imports System.Drawing
Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.SessionState

Imports Drg.Util.Helpers

Public Class query_servicefee_remainingreceivables
    Inherits GrapeCity.ActiveReports.SectionReport

    Public Sub New()
        MyBase.New()

        InitializeComponent()

        PageSettings.Orientation = PageOrientation.Landscape

        PageSettings.Margins.Top = 0.1
        PageSettings.Margins.Left = 0.1
        PageSettings.Margins.Right = 0.1
        PageSettings.Margins.Bottom = 0.1

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader = Nothing
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private WithEvents ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter = Nothing
    Private Label As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Picture As GrapeCity.ActiveReports.SectionReportModel.Picture
    Private Label15 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label16 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private CompanyName As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Period As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Line1 As GrapeCity.ActiveReports.SectionReportModel.Line
    Private Label1 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label4 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label5 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label6 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label7 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label8 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label9 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label10 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label12 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label13 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line
    Private AccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private HireDate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private FirstName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private LastName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private FeeCategory As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private OriginalBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TotalPayments As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private RemainingBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private LastDepositDate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private RemainingReceivables As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Rate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private [Date] As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PN As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PT As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PageNumbers As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(query_servicefee_remainingreceivables))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.Label = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Picture = New GrapeCity.ActiveReports.SectionReportModel.Picture()
        Me.Label15 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label16 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.CompanyName = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Period = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Line1 = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.Label1 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label2 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label4 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label5 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label6 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label7 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label8 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label9 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label10 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label12 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label13 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.AccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.HireDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.FirstName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.LastName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.FeeCategory = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.OriginalBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TotalPayments = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.RemainingBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.LastDepositDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.RemainingReceivables = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Rate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.[Date] = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PT = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PageNumbers = New GrapeCity.ActiveReports.SectionReportModel.Label()
        CType(Me.Label, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label15, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CompanyName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Period, System.ComponentModel.ISupportInitialize).BeginInit
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
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.HireDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FeeCategory, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.OriginalBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TotalPayments, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.RemainingBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.LastDepositDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.RemainingReceivables, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Rate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.CanShrink = true
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Separator, Me.AccountNumber, Me.HireDate, Me.FirstName, Me.LastName, Me.FeeCategory, Me.OriginalBalance, Me.TotalPayments, Me.RemainingBalance, Me.LastDepositDate, Me.RemainingReceivables, Me.Rate})
        Me.Detail.Height = 0.3222222!
        Me.Detail.Name = "Detail"
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label, Me.Picture, Me.Label15, Me.Label16, Me.CompanyName, Me.Period})
        Me.ReportHeader.Height = 1.603472!
        Me.ReportHeader.Name = "ReportHeader"
        '
        'ReportFooter
        '
        Me.ReportFooter.Height = 0!
        Me.ReportFooter.KeepTogether = true
        Me.ReportFooter.Name = "ReportFooter"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Line1, Me.Label1, Me.Label2, Me.Label4, Me.Label5, Me.Label6, Me.Label7, Me.Label8, Me.Label9, Me.Label10, Me.Label12, Me.Label13})
        Me.PageHeader.Height = 0.34375!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.PageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.[Date], Me.PN, Me.PT, Me.PageNumbers})
        Me.PageFooter.Height = 0.40625!
        Me.PageFooter.Name = "PageFooter"
        '
        'Label
        '
        Me.Label.Height = 0.1875!
        Me.Label.HyperLink = Nothing
        Me.Label.Left = 0!
        Me.Label.Name = "Label"
        Me.Label.Style = "font-size: 9.75pt; font-weight: bold; text-align: center; ddo-char-set: 0"
        Me.Label.Text = "Remaining Receivables Report"
        Me.Label.Top = 0.6875!
        Me.Label.Width = 11.0625!
        '
        'Picture
        '
        Me.Picture.Height = 0.875!
        Me.Picture.ImageData = Nothing
        Me.Picture.Left = 0!
        Me.Picture.LineColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Picture.Name = "Picture"
        Me.Picture.SizeMode = GrapeCity.ActiveReports.SectionReportModel.SizeModes.Zoom
        Me.Picture.Top = 0!
        Me.Picture.Width = 3.1875!
        '
        'Label15
        '
        Me.Label15.Height = 0.1875!
        Me.Label15.HyperLink = Nothing
        Me.Label15.Left = 0!
        Me.Label15.Name = "Label15"
        Me.Label15.Style = "font-size: 9.75pt; font-weight: bold; text-align: left; ddo-char-set: 0"
        Me.Label15.Text = "Company:"
        Me.Label15.Top = 1.0625!
        Me.Label15.Width = 0.875!
        '
        'Label16
        '
        Me.Label16.Height = 0.1875!
        Me.Label16.HyperLink = Nothing
        Me.Label16.Left = 0!
        Me.Label16.Name = "Label16"
        Me.Label16.Style = "font-size: 9.75pt; font-weight: bold; text-align: left; ddo-char-set: 0"
        Me.Label16.Text = "As of:"
        Me.Label16.Top = 1.25!
        Me.Label16.Width = 0.875!
        '
        'CompanyName
        '
        Me.CompanyName.DataField = "CompanyName"
        Me.CompanyName.Height = 0.1875!
        Me.CompanyName.HyperLink = Nothing
        Me.CompanyName.Left = 0.875!
        Me.CompanyName.Name = "CompanyName"
        Me.CompanyName.Style = "font-size: 9.75pt; font-weight: normal; text-align: left; ddo-char-set: 0"
        Me.CompanyName.Text = "CompanyName"
        Me.CompanyName.Top = 1.0625!
        Me.CompanyName.Width = 2.125!
        '
        'Period
        '
        Me.Period.DataField = "Period"
        Me.Period.Height = 0.1875!
        Me.Period.HyperLink = Nothing
        Me.Period.Left = 0.875!
        Me.Period.Name = "Period"
        Me.Period.Style = "font-size: 9.75pt; font-weight: normal; text-align: left; ddo-char-set: 0"
        Me.Period.Text = "Period"
        Me.Period.Top = 1.25!
        Me.Period.Width = 2.125!
        '
        'Line1
        '
        Me.Line1.Height = 0!
        Me.Line1.Left = 0!
        Me.Line1.LineWeight = 3!
        Me.Line1.Name = "Line1"
        Me.Line1.Top = 0.3125!
        Me.Line1.Width = 11.25!
        Me.Line1.X1 = 0!
        Me.Line1.X2 = 11.25!
        Me.Line1.Y1 = 0.3125!
        Me.Line1.Y2 = 0.3125!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 0.0625!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = ""
        Me.Label1.Text = "Acct. #"
        Me.Label1.Top = 0.0625!
        Me.Label1.Width = 0.6875!
        '
        'Label2
        '
        Me.Label2.Height = 0.1875!
        Me.Label2.HyperLink = Nothing
        Me.Label2.Left = 0.75!
        Me.Label2.Name = "Label2"
        Me.Label2.Style = "text-align: center"
        Me.Label2.Text = "Hire Date"
        Me.Label2.Top = 0.0625!
        Me.Label2.Width = 0.875!
        '
        'Label4
        '
        Me.Label4.Height = 0.1875!
        Me.Label4.HyperLink = Nothing
        Me.Label4.Left = 1.625!
        Me.Label4.Name = "Label4"
        Me.Label4.Style = ""
        Me.Label4.Text = "First Name"
        Me.Label4.Top = 0.0625!
        Me.Label4.Width = 1.1875!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 2.8125!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: left"
        Me.Label5.Text = "Last Name"
        Me.Label5.Top = 0.0625!
        Me.Label5.Width = 1.25!
        '
        'Label6
        '
        Me.Label6.Height = 0.1875!
        Me.Label6.HyperLink = Nothing
        Me.Label6.Left = 4.0625!
        Me.Label6.Name = "Label6"
        Me.Label6.Style = "text-align: left"
        Me.Label6.Text = "Fee Category"
        Me.Label6.Top = 0.0625!
        Me.Label6.Width = 1.4375!
        '
        'Label7
        '
        Me.Label7.Height = 0.1875!
        Me.Label7.HyperLink = Nothing
        Me.Label7.Left = 5.5!
        Me.Label7.Name = "Label7"
        Me.Label7.Style = "text-align: center"
        Me.Label7.Text = "Lst Dep."
        Me.Label7.Top = 0.0625!
        Me.Label7.Width = 0.9375!
        '
        'Label8
        '
        Me.Label8.Height = 0.1875!
        Me.Label8.HyperLink = Nothing
        Me.Label8.Left = 6.4375!
        Me.Label8.Name = "Label8"
        Me.Label8.Style = "text-align: right"
        Me.Label8.Text = "Orig Bal."
        Me.Label8.Top = 0.0625!
        Me.Label8.Width = 0.9375!
        '
        'Label9
        '
        Me.Label9.Height = 0.1875!
        Me.Label9.HyperLink = Nothing
        Me.Label9.Left = 7.375!
        Me.Label9.Name = "Label9"
        Me.Label9.Style = "text-align: right"
        Me.Label9.Text = "Tot. Pmts."
        Me.Label9.Top = 0.0625!
        Me.Label9.Width = 0.9375!
        '
        'Label10
        '
        Me.Label10.Height = 0.1875!
        Me.Label10.HyperLink = Nothing
        Me.Label10.Left = 8.3125!
        Me.Label10.Name = "Label10"
        Me.Label10.Style = "text-align: right"
        Me.Label10.Text = "Rem Bal."
        Me.Label10.Top = 0.0625!
        Me.Label10.Width = 0.9375!
        '
        'Label12
        '
        Me.Label12.Height = 0.1875!
        Me.Label12.HyperLink = Nothing
        Me.Label12.Left = 10!
        Me.Label12.Name = "Label12"
        Me.Label12.Style = "text-align: right"
        Me.Label12.Text = "Rem Receiv."
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
        Me.Label13.Text = "Rate"
        Me.Label13.Top = 0.0625!
        Me.Label13.Width = 0.75!
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
        'AccountNumber
        '
        Me.AccountNumber.CanGrow = false
        Me.AccountNumber.DataField = "AccountNumber"
        Me.AccountNumber.Height = 0.1875!
        Me.AccountNumber.Left = 0.0625!
        Me.AccountNumber.Name = "AccountNumber"
        Me.AccountNumber.Text = "AccountNumber"
        Me.AccountNumber.Top = 0.0625!
        Me.AccountNumber.Width = 0.6875!
        '
        'HireDate
        '
        Me.HireDate.CanGrow = false
        Me.HireDate.DataField = "HireDate"
        Me.HireDate.Height = 0.1875!
        Me.HireDate.Left = 0.75!
        Me.HireDate.Name = "HireDate"
        Me.HireDate.OutputFormat = resources.GetString("HireDate.OutputFormat")
        Me.HireDate.Style = "text-align: center"
        Me.HireDate.Text = "HireDate"
        Me.HireDate.Top = 0.0625!
        Me.HireDate.Width = 0.875!
        '
        'FirstName
        '
        Me.FirstName.CanGrow = false
        Me.FirstName.DataField = "FirstName"
        Me.FirstName.Height = 0.1875!
        Me.FirstName.Left = 1.625!
        Me.FirstName.Name = "FirstName"
        Me.FirstName.Text = "FirstName"
        Me.FirstName.Top = 0.0625!
        Me.FirstName.Width = 1.1875!
        '
        'LastName
        '
        Me.LastName.CanGrow = false
        Me.LastName.DataField = "LastName"
        Me.LastName.Height = 0.1875!
        Me.LastName.Left = 2.8125!
        Me.LastName.Name = "LastName"
        Me.LastName.OutputFormat = resources.GetString("LastName.OutputFormat")
        Me.LastName.Style = "text-align: left"
        Me.LastName.Text = "LastName"
        Me.LastName.Top = 0.0625!
        Me.LastName.Width = 1.25!
        '
        'FeeCategory
        '
        Me.FeeCategory.CanGrow = false
        Me.FeeCategory.DataField = "FeeCategory"
        Me.FeeCategory.Height = 0.1875!
        Me.FeeCategory.Left = 4.0625!
        Me.FeeCategory.Name = "FeeCategory"
        Me.FeeCategory.Text = "FeeCategory"
        Me.FeeCategory.Top = 0.0625!
        Me.FeeCategory.Width = 1.4375!
        '
        'OriginalBalance
        '
        Me.OriginalBalance.CanGrow = false
        Me.OriginalBalance.DataField = "OriginalBalance"
        Me.OriginalBalance.Height = 0.1875!
        Me.OriginalBalance.Left = 6.4375!
        Me.OriginalBalance.Name = "OriginalBalance"
        Me.OriginalBalance.OutputFormat = resources.GetString("OriginalBalance.OutputFormat")
        Me.OriginalBalance.Style = "text-align: right"
        Me.OriginalBalance.Text = "OriginalBalance"
        Me.OriginalBalance.Top = 0.0625!
        Me.OriginalBalance.Width = 0.9375!
        '
        'TotalPayments
        '
        Me.TotalPayments.CanGrow = false
        Me.TotalPayments.DataField = "TotalPayments"
        Me.TotalPayments.Height = 0.1875!
        Me.TotalPayments.Left = 7.375!
        Me.TotalPayments.Name = "TotalPayments"
        Me.TotalPayments.OutputFormat = resources.GetString("TotalPayments.OutputFormat")
        Me.TotalPayments.Style = "text-align: right"
        Me.TotalPayments.Text = "TotalPayments"
        Me.TotalPayments.Top = 0.0625!
        Me.TotalPayments.Width = 0.9375!
        '
        'RemainingBalance
        '
        Me.RemainingBalance.CanGrow = false
        Me.RemainingBalance.DataField = "RemainingBalance"
        Me.RemainingBalance.Height = 0.1875!
        Me.RemainingBalance.Left = 8.3125!
        Me.RemainingBalance.Name = "RemainingBalance"
        Me.RemainingBalance.OutputFormat = resources.GetString("RemainingBalance.OutputFormat")
        Me.RemainingBalance.Style = "text-align: right"
        Me.RemainingBalance.Text = "RemainingBalance"
        Me.RemainingBalance.Top = 0.0625!
        Me.RemainingBalance.Width = 0.9375!
        '
        'LastDepositDate
        '
        Me.LastDepositDate.CanGrow = false
        Me.LastDepositDate.DataField = "LastDepositDate"
        Me.LastDepositDate.Height = 0.1875!
        Me.LastDepositDate.Left = 5.5!
        Me.LastDepositDate.MultiLine = false
        Me.LastDepositDate.Name = "LastDepositDate"
        Me.LastDepositDate.OutputFormat = resources.GetString("LastDepositDate.OutputFormat")
        Me.LastDepositDate.Style = "text-align: center"
        Me.LastDepositDate.Text = "LastDepositDate"
        Me.LastDepositDate.Top = 0.0625!
        Me.LastDepositDate.Width = 0.9375!
        '
        'RemainingReceivables
        '
        Me.RemainingReceivables.CanGrow = false
        Me.RemainingReceivables.DataField = "RemainingReceivables"
        Me.RemainingReceivables.Height = 0.1875!
        Me.RemainingReceivables.Left = 10!
        Me.RemainingReceivables.Name = "RemainingReceivables"
        Me.RemainingReceivables.OutputFormat = resources.GetString("RemainingReceivables.OutputFormat")
        Me.RemainingReceivables.Style = "text-align: right"
        Me.RemainingReceivables.Text = "RemainingReceivables"
        Me.RemainingReceivables.Top = 0.0625!
        Me.RemainingReceivables.Width = 0.875!
        '
        'Rate
        '
        Me.Rate.CanGrow = false
        Me.Rate.DataField = "Rate"
        Me.Rate.Height = 0.1875!
        Me.Rate.Left = 9.25!
        Me.Rate.Name = "Rate"
        Me.Rate.OutputFormat = resources.GetString("Rate.OutputFormat")
        Me.Rate.Style = "text-align: center"
        Me.Rate.Text = "Rate"
        Me.Rate.Top = 0.0625!
        Me.Rate.Width = 0.75!
        '
        'Date
        '
        Me.[Date].DataField = "=System.DateTime.Now"
        Me.[Date].Height = 0.1875!
        Me.[Date].Left = 8.1875!
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
        Me.PrintWidth = 11.01042!
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
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label15, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CompanyName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Period, System.ComponentModel.ISupportInitialize).EndInit
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
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.HireDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FeeCategory, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.OriginalBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TotalPayments, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.RemainingBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.LastDepositDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.RemainingReceivables, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Rate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub

    Private Sub ReportFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportFooter.Format

    End Sub
End Class