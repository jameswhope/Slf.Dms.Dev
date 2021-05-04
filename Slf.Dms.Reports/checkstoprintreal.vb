Option Explicit On
Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess




Imports System

Public Class checkstoprintreal
    Inherits GrapeCity.ActiveReports.SectionReport

#Region "Constructor"

    Public Sub New()
        MyBase.New()

        InitializeComponent()

        PageSettings.Orientation = PageOrientation.Portrait

        PageSettings.Margins.Top = 0.25
        PageSettings.Margins.Left = 0.5
        PageSettings.Margins.Right = 0.5
        PageSettings.Margins.Bottom = 0.25

    End Sub

#End Region

#Region "Variables"

    Private _checktoprintid As Integer
    Private _clientid As Integer
    Private _firstname As String
    Private _lastname As String
    Private _spousefirstname As String
    Private _spouselastname As String
    Private _street As String
    Private _street2 As String
    Private _city As String
    Private _stateabbreviation As String
    Private _statename As String
    Private _zipcode As String
    Private _accountnumber As String
    Private _bankname As String
    Private _bankcity As String
    Private _bankstateabbreviation As String
    Private _bankstatename As String
    Private _bankzipcode As String
    Private _bankroutingnumber As String
    Private _bankaccountnumber As String
    Private _amount As Double
    Private _checknumber As String
    Private _checkdate As Nullable(Of DateTime)
    Private _fraction As String
    Private _printed As Nullable(Of DateTime)
    Private _printedby As Integer
    Private _printedbyname As String
    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String

#End Region

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private CheckToPrintID As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Bottom As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private RichTextBox As GrapeCity.ActiveReports.SectionReportModel.RichTextBox = Nothing
    Private BankName2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private BankAddress2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private ClientID2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Label As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Label1 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private ClientName3 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Amount2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private CheckDate2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private ClientAddress2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private ClientName2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Fraction2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private CheckNumber2 As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private BankName As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private BankAddress As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private ClientID As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private ClientAddress As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private ClientName As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Label3 As GrapeCity.ActiveReports.SectionReportModel.Label = Nothing
    Private Amount As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private CheckDate As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Fraction As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private CheckNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox = Nothing
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(checkstoprintreal))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.CheckToPrintID = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Bottom = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.RichTextBox = New GrapeCity.ActiveReports.SectionReportModel.RichTextBox()
        Me.BankName2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BankAddress2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientID2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label1 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.ClientName3 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Amount2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CheckDate2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientAddress2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientName2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Fraction2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CheckNumber2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BankName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BankAddress = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientID = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label2 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.ClientAddress = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ClientName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label3 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Amount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CheckDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Fraction = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CheckNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.CheckToPrintID, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Bottom, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BankName2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BankAddress2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientID2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientName3, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Amount2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CheckDate2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientAddress2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientName2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Fraction2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CheckNumber2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BankName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BankAddress, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientID, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientAddress, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ClientName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CheckDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Fraction, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CheckNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.CheckToPrintID})
        Me.Detail.Height = 0.1979167!
        Me.Detail.Name = "Detail"
        Me.Detail.NewPage = GrapeCity.ActiveReports.SectionReportModel.NewPage.After
        '
        'PageHeader
        '
        Me.PageHeader.Height = 0!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Bottom, Me.RichTextBox, Me.BankName2, Me.BankAddress2, Me.ClientID2, Me.Label, Me.Label1, Me.ClientName3, Me.Amount2, Me.CheckDate2, Me.ClientAddress2, Me.ClientName2, Me.Fraction2, Me.CheckNumber2, Me.BankName, Me.BankAddress, Me.ClientID, Me.Label2, Me.ClientAddress, Me.ClientName, Me.Label3, Me.Amount, Me.CheckDate, Me.Fraction, Me.CheckNumber})
        Me.PageFooter.Height = 5.9375!
        Me.PageFooter.Name = "PageFooter"
        '
        'CheckToPrintID
        '
        Me.CheckToPrintID.DataField = "CheckToPrintID"
        Me.CheckToPrintID.Height = 0.1875!
        Me.CheckToPrintID.Left = 0!
        Me.CheckToPrintID.Name = "CheckToPrintID"
        Me.CheckToPrintID.Style = "font-family: Arial; font-size: 8.25pt; vertical-align: middle; ddo-char-set: 1"
        Me.CheckToPrintID.Text = "CheckToPrintID"
        Me.CheckToPrintID.Top = 0!
        Me.CheckToPrintID.Width = 0.875!
        '
        'Bottom
        '
        Me.Bottom.Height = 0.3125!
        Me.Bottom.Left = 0.8125!
        Me.Bottom.Name = "Bottom"
        Me.Bottom.Style = "font-family: MICR-E13B; font-size: 8pt; vertical-align: middle; ddo-char-set: 1"
        Me.Bottom.Text = "Bottom"
        Me.Bottom.Top = 5.625!
        Me.Bottom.Width = 5.25!
        '
        'RichTextBox
        '
        Me.RichTextBox.AutoReplaceFields = true
        Me.RichTextBox.Font = New System.Drawing.Font("Arial", 10!)
        Me.RichTextBox.Height = 0.8125!
        Me.RichTextBox.Left = 4.5625!
        Me.RichTextBox.Name = "RichTextBox"
        Me.RichTextBox.RTF = resources.GetString("RichTextBox.RTF")
        Me.RichTextBox.Top = 4.8125!
        Me.RichTextBox.Width = 2.875!
        '
        'BankName2
        '
        Me.BankName2.Height = 0.1875!
        Me.BankName2.Left = 0.375!
        Me.BankName2.Name = "BankName2"
        Me.BankName2.Style = "font-family: Arial; font-size: 10pt; font-weight: bold; vertical-align: middle; d" & _
            "do-char-set: 1"
        Me.BankName2.Text = "BankName2"
        Me.BankName2.Top = 4.875!
        Me.BankName2.Width = 3.25!
        '
        'BankAddress2
        '
        Me.BankAddress2.Height = 0.1875!
        Me.BankAddress2.Left = 0.375!
        Me.BankAddress2.Name = "BankAddress2"
        Me.BankAddress2.Style = "font-family: Arial; font-size: 10pt; font-weight: normal; vertical-align: middle;" & _
            " ddo-char-set: 1"
        Me.BankAddress2.Text = "BankAddress2"
        Me.BankAddress2.Top = 5.0625!
        Me.BankAddress2.Width = 3.25!
        '
        'ClientID2
        '
        Me.ClientID2.Height = 0.1875!
        Me.ClientID2.Left = 0.625!
        Me.ClientID2.Name = "ClientID2"
        Me.ClientID2.Style = "font-family: Arial; font-size: 10pt; font-weight: normal; text-align: left; verti" & _
            "cal-align: middle; ddo-char-set: 1"
        Me.ClientID2.Text = "ClientID2"
        Me.ClientID2.Top = 5.25!
        Me.ClientID2.Width = 3!
        '
        'Label
        '
        Me.Label.Height = 0.1875!
        Me.Label.HyperLink = Nothing
        Me.Label.Left = 0.375!
        Me.Label.Name = "Label"
        Me.Label.Style = "vertical-align: middle"
        Me.Label.Text = "Re:"
        Me.Label.Top = 5.25!
        Me.Label.Width = 0.25!
        '
        'Label1
        '
        Me.Label1.Height = 0.25!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 0.375!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = "font-size: 12pt; vertical-align: middle; ddo-char-set: 1"
        Me.Label1.Text = "Pay To The Order Of:"
        Me.Label1.Top = 4.125!
        Me.Label1.Width = 1.6875!
        '
        'ClientName3
        '
        Me.ClientName3.Height = 0.25!
        Me.ClientName3.Left = 2.125!
        Me.ClientName3.Name = "ClientName3"
        Me.ClientName3.Style = "font-family: Arial; font-size: 12pt; font-weight: bold; vertical-align: middle; d" & _
            "do-char-set: 1"
        Me.ClientName3.Text = "ClientName3"
        Me.ClientName3.Top = 4.125!
        Me.ClientName3.Width = 3.0625!
        '
        'Amount2
        '
        Me.Amount2.Height = 0.25!
        Me.Amount2.Left = 6.25!
        Me.Amount2.Name = "Amount2"
        Me.Amount2.OutputFormat = resources.GetString("Amount2.OutputFormat")
        Me.Amount2.Style = "font-family: Arial; font-size: 12pt; font-weight: bold; text-align: left; vertica" & _
            "l-align: middle; ddo-char-set: 1"
        Me.Amount2.Text = "Amount2"
        Me.Amount2.Top = 4.125!
        Me.Amount2.Width = 1.25!
        '
        'CheckDate2
        '
        Me.CheckDate2.Height = 0.25!
        Me.CheckDate2.Left = 6.25!
        Me.CheckDate2.Name = "CheckDate2"
        Me.CheckDate2.OutputFormat = resources.GetString("CheckDate2.OutputFormat")
        Me.CheckDate2.Style = "font-family: Arial; font-size: 12pt; font-weight: normal; text-align: left; verti" & _
            "cal-align: middle; white-space: nowrap; ddo-char-set: 1"
        Me.CheckDate2.Text = "CheckDate2"
        Me.CheckDate2.Top = 3.75!
        Me.CheckDate2.Width = 1.25!
        '
        'ClientAddress2
        '
        Me.ClientAddress2.Height = 0.375!
        Me.ClientAddress2.Left = 0.375!
        Me.ClientAddress2.Name = "ClientAddress2"
        Me.ClientAddress2.Style = "font-family: Arial; font-size: 10pt; font-weight: normal; vertical-align: top; dd" & _
            "o-char-set: 1"
        Me.ClientAddress2.Text = "ClientAddress2"
        Me.ClientAddress2.Top = 3.5625!
        Me.ClientAddress2.Width = 3.25!
        '
        'ClientName2
        '
        Me.ClientName2.Height = 0.375!
        Me.ClientName2.Left = 0.375!
        Me.ClientName2.Name = "ClientName2"
        Me.ClientName2.Style = "font-family: Arial; font-size: 10pt; font-weight: bold; vertical-align: bottom; d" & _
            "do-char-set: 1"
        Me.ClientName2.Text = "ClientName2"
        Me.ClientName2.Top = 3.1875!
        Me.ClientName2.Width = 3.25!
        '
        'Fraction2
        '
        Me.Fraction2.Height = 0.1875!
        Me.Fraction2.Left = 6.25!
        Me.Fraction2.Name = "Fraction2"
        Me.Fraction2.OutputFormat = resources.GetString("Fraction2.OutputFormat")
        Me.Fraction2.Style = "font-family: Arial; font-size: 9pt; font-weight: normal; text-align: left; vertic" & _
            "al-align: middle; white-space: nowrap; ddo-char-set: 1"
        Me.Fraction2.Text = "Fraction2"
        Me.Fraction2.Top = 3.4375!
        Me.Fraction2.Width = 1.25!
        '
        'CheckNumber2
        '
        Me.CheckNumber2.Height = 0.25!
        Me.CheckNumber2.Left = 6.25!
        Me.CheckNumber2.Name = "CheckNumber2"
        Me.CheckNumber2.OutputFormat = resources.GetString("CheckNumber2.OutputFormat")
        Me.CheckNumber2.Style = "font-family: Arial; font-size: 12pt; font-weight: bold; text-align: left; vertica" & _
            "l-align: middle; white-space: nowrap; ddo-char-set: 1"
        Me.CheckNumber2.Text = "CheckNumber2"
        Me.CheckNumber2.Top = 3.125!
        Me.CheckNumber2.Width = 1.25!
        '
        'BankName
        '
        Me.BankName.Height = 0.1875!
        Me.BankName.Left = 0.375!
        Me.BankName.Name = "BankName"
        Me.BankName.Style = "font-family: Arial; font-size: 10pt; font-weight: bold; vertical-align: middle; d" & _
            "do-char-set: 1"
        Me.BankName.Text = "BankName"
        Me.BankName.Top = 2.0625!
        Me.BankName.Width = 3.25!
        '
        'BankAddress
        '
        Me.BankAddress.Height = 0.1875!
        Me.BankAddress.Left = 0.375!
        Me.BankAddress.Name = "BankAddress"
        Me.BankAddress.Style = "font-family: Arial; font-size: 10pt; font-weight: normal; vertical-align: middle;" & _
            " ddo-char-set: 1"
        Me.BankAddress.Text = "BankAddress"
        Me.BankAddress.Top = 2.25!
        Me.BankAddress.Width = 3.25!
        '
        'ClientID
        '
        Me.ClientID.Height = 0.1875!
        Me.ClientID.Left = 0.625!
        Me.ClientID.Name = "ClientID"
        Me.ClientID.Style = "font-family: Arial; font-size: 10pt; font-weight: normal; text-align: left; verti" & _
            "cal-align: middle; ddo-char-set: 1"
        Me.ClientID.Text = "ClientID"
        Me.ClientID.Top = 2.4375!
        Me.ClientID.Width = 3!
        '
        'Label2
        '
        Me.Label2.Height = 0.1875!
        Me.Label2.HyperLink = Nothing
        Me.Label2.Left = 0.375!
        Me.Label2.Name = "Label2"
        Me.Label2.Style = "vertical-align: middle"
        Me.Label2.Text = "Re:"
        Me.Label2.Top = 2.4375!
        Me.Label2.Width = 0.25!
        '
        'ClientAddress
        '
        Me.ClientAddress.Height = 0.375!
        Me.ClientAddress.Left = 0.375!
        Me.ClientAddress.Name = "ClientAddress"
        Me.ClientAddress.Style = "font-family: Arial; font-size: 10pt; font-weight: normal; vertical-align: top; dd" & _
            "o-char-set: 1"
        Me.ClientAddress.Text = "ClientAddress"
        Me.ClientAddress.Top = 1.25!
        Me.ClientAddress.Width = 3.25!
        '
        'ClientName
        '
        Me.ClientName.Height = 0.375!
        Me.ClientName.Left = 0.375!
        Me.ClientName.Name = "ClientName"
        Me.ClientName.Style = "font-family: Arial; font-size: 10pt; font-weight: bold; vertical-align: bottom; d" & _
            "do-char-set: 1"
        Me.ClientName.Text = "ClientName"
        Me.ClientName.Top = 0.875!
        Me.ClientName.Width = 3.25!
        '
        'Label3
        '
        Me.Label3.Height = 0.1875!
        Me.Label3.HyperLink = Nothing
        Me.Label3.Left = 0.5625!
        Me.Label3.Name = "Label3"
        Me.Label3.Style = "font-size: 12pt; font-weight: bold; vertical-align: middle; ddo-char-set: 1"
        Me.Label3.Text = "DEPOSIT SLIP"
        Me.Label3.Top = 0.5625!
        Me.Label3.Width = 1.3125!
        '
        'Amount
        '
        Me.Amount.Height = 0.25!
        Me.Amount.Left = 6.25!
        Me.Amount.Name = "Amount"
        Me.Amount.OutputFormat = resources.GetString("Amount.OutputFormat")
        Me.Amount.Style = "font-family: Arial; font-size: 12pt; font-weight: bold; text-align: left; vertica" & _
            "l-align: middle; ddo-char-set: 1"
        Me.Amount.Text = "Amount"
        Me.Amount.Top = 1.8125!
        Me.Amount.Width = 1.25!
        '
        'CheckDate
        '
        Me.CheckDate.Height = 0.25!
        Me.CheckDate.Left = 6.25!
        Me.CheckDate.Name = "CheckDate"
        Me.CheckDate.OutputFormat = resources.GetString("CheckDate.OutputFormat")
        Me.CheckDate.Style = "font-family: Arial; font-size: 12pt; font-weight: normal; text-align: left; verti" & _
            "cal-align: middle; white-space: nowrap; ddo-char-set: 1"
        Me.CheckDate.Text = "CheckDate"
        Me.CheckDate.Top = 1.4375!
        Me.CheckDate.Width = 1.25!
        '
        'Fraction
        '
        Me.Fraction.Height = 0.1875!
        Me.Fraction.Left = 6.25!
        Me.Fraction.Name = "Fraction"
        Me.Fraction.OutputFormat = resources.GetString("Fraction.OutputFormat")
        Me.Fraction.Style = "font-family: Arial; font-size: 9pt; font-weight: normal; text-align: left; vertic" & _
            "al-align: middle; white-space: nowrap; ddo-char-set: 1"
        Me.Fraction.Text = "Fraction"
        Me.Fraction.Top = 1.125!
        Me.Fraction.Width = 1.25!
        '
        'CheckNumber
        '
        Me.CheckNumber.Height = 0.25!
        Me.CheckNumber.Left = 6.25!
        Me.CheckNumber.Name = "CheckNumber"
        Me.CheckNumber.OutputFormat = resources.GetString("CheckNumber.OutputFormat")
        Me.CheckNumber.Style = "font-family: Arial; font-size: 12pt; font-weight: bold; text-align: left; vertica" & _
            "l-align: middle; white-space: nowrap; ddo-char-set: 1"
        Me.CheckNumber.Text = "CheckNumber"
        Me.CheckNumber.Top = 0.8125!
        Me.CheckNumber.Width = 1.25!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 7.5!
        Me.Sections.Add(Me.PageHeader)
        Me.Sections.Add(Me.Detail)
        Me.Sections.Add(Me.PageFooter)
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule(resources.GetString("$this.StyleSheet"), "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: inherit; font-style: inherit; font-variant: inherit; font-weight: bo" & _
                    "ld; font-size: 16pt; font-size-adjust: inherit; font-stretch: inherit", "Heading1", "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: Times New Roman; font-style: italic; font-variant: inherit; font-wei" & _
                    "ght: bold; font-size: 14pt; font-size-adjust: inherit; font-stretch: inherit", "Heading2", "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: inherit; font-style: inherit; font-variant: inherit; font-weight: bo" & _
                    "ld; font-size: 13pt; font-size-adjust: inherit; font-stretch: inherit", "Heading3", "Normal"))
        CType(Me.CheckToPrintID, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Bottom, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BankName2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BankAddress2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientID2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientName3, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Amount2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CheckDate2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientAddress2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientName2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Fraction2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CheckNumber2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BankName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BankAddress, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientID, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientAddress, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ClientName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CheckDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Fraction, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CheckNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

        _checktoprintid = DataHelper.Nz_int(Fields("CheckToPrintID").Value)
        _clientid = DataHelper.Nz_int(Fields("ClientID").Value)
        _firstname = DataHelper.Nz_string(Fields("FirstName").Value)
        _lastname = DataHelper.Nz_string(Fields("LastName").Value)
        _spousefirstname = DataHelper.Nz_string(Fields("SpouseFirstName").Value)
        _spouselastname = DataHelper.Nz_string(Fields("SpouseLastName").Value)
        _street = DataHelper.Nz_string(Fields("Street").Value)
        _street2 = DataHelper.Nz_string(Fields("Street2").Value)
        _city = DataHelper.Nz_string(Fields("City").Value)
        _stateabbreviation = DataHelper.Nz_string(Fields("StateAbbreviation").Value)
        _statename = DataHelper.Nz_string(Fields("StateName").Value)
        _zipcode = DataHelper.Nz_string(Fields("ZipCode").Value)
        _accountnumber = DataHelper.Nz_string(Fields("AccountNumber").Value)
        _bankname = DataHelper.Nz_string(Fields("BankName").Value)
        _bankcity = DataHelper.Nz_string(Fields("BankCity").Value)
        _bankstateabbreviation = DataHelper.Nz_string(Fields("BankStateAbbreviation").Value)
        _bankstatename = DataHelper.Nz_string(Fields("BankStateName").Value)
        _bankzipcode = DataHelper.Nz_string(Fields("BankZipCode").Value)
        _bankroutingnumber = DataHelper.Nz_string(Fields("BankRoutingNumber").Value)
        _bankaccountnumber = DataHelper.Nz_string(Fields("BankAccountNumber").Value)
        _amount = DataHelper.Nz_double(Fields("Amount").Value)
        _checknumber = DataHelper.Nz_string(Fields("CheckNumber").Value)
        _checkdate = DataHelper.Nz_ndate(Fields("CheckDate").Value)
        _fraction = DataHelper.Nz_string(Fields("Fraction").Value)
        _printed = DataHelper.Nz_ndate(Fields("Printed").Value)
        _printedby = DataHelper.Nz_int(Fields("PrintedBy").Value)
        _printedbyname = DataHelper.Nz_string(Fields("PrintedByName").Value)
        _created = DataHelper.Nz_date(Fields("Created").Value)
        _createdby = DataHelper.Nz_int(Fields("CreatedBy").Value)
        _createdbyname = DataHelper.Nz_string(Fields("CreatedByName").Value)

    End Sub
    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

        ClientName.Text = (_firstname & " " & _lastname & vbCrLf & _spousefirstname & " " & _spouselastname).Trim
        ClientAddress.Text = AddressHelper.GetProper(_street, _street2, _city, _stateabbreviation, _zipcode)
        CheckNumber.Text = _checknumber
        Fraction.Text = _fraction

        If _checkdate.HasValue Then
            CheckDate.Text = _checkdate.Value.ToString("M/d/yyyy")
        End If

        Amount.Text = _amount.ToString("$  #,##0.00")
        BankName.Text = _bankname
        BankAddress.Text = _bankcity & ", " & _bankstateabbreviation & " " & _bankzipcode
        ClientID.Text = _clientid

        ClientName2.Text = ClientName.Text
        ClientAddress2.Text = ClientAddress.Text
        CheckNumber2.Text = CheckNumber.Text
        Fraction2.Text = Fraction.Text
        CheckDate2.Text = CheckDate.Text
        ClientName3.Text = _firstname & " " & _lastname
        Amount2.Text = Amount.Text
        BankName2.Text = BankName.Text
        BankAddress2.Text = BankAddress.Text
        ClientID2.Text = ClientID.Text

        Bottom.Text = "O000" & _checknumber & "   T" & _bankroutingnumber & "T   " _
            & _bankaccountnumber & "O"

    End Sub
End Class