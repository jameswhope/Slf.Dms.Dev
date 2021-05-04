Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Public Class report_servicefee_all_payments
    Inherits GrapeCity.ActiveReports.SectionReport
    Public Sub New()
        MyBase.New()
        InitializeComponent()
    End Sub
#Region "ActiveReports Designer generated code"
    Public ds As GrapeCity.ActiveReports.Data.SqlDBDataSource
    Private WithEvents ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader = Nothing
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents grpCompanyNameHeader As GrapeCity.ActiveReports.SectionReportModel.GroupHeader = Nothing
    Private WithEvents sortofPageHeader As GrapeCity.ActiveReports.SectionReportModel.GroupHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents sortofPageFooter As GrapeCity.ActiveReports.SectionReportModel.GroupFooter = Nothing
    Private WithEvents grpCompanyNameFooter As GrapeCity.ActiveReports.SectionReportModel.GroupFooter = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private WithEvents ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter = Nothing
    Private Label16 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private TextBox1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
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
    Private CommRecipName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private AccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private HireDate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private FirstName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private LastName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line
    Private FeeCategory As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private OriginalBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private BeginningBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PaymentAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private SettlementNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private EndingBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Rate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Amount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox5 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Label3 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private TextBox6 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox7 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Label As GrapeCity.ActiveReports.SectionReportModel.Label
    Private TextBox3 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox4 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private [Date] As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PN As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PT As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PageNumbers As GrapeCity.ActiveReports.SectionReportModel.Label
    Private CountCommPayId As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Label11 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private SumAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(report_servicefee_all_payments))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.grpCompanyNameHeader = New GrapeCity.ActiveReports.SectionReportModel.GroupHeader()
        Me.grpCompanyNameFooter = New GrapeCity.ActiveReports.SectionReportModel.GroupFooter()
        Me.sortofPageHeader = New GrapeCity.ActiveReports.SectionReportModel.GroupHeader()
        Me.sortofPageFooter = New GrapeCity.ActiveReports.SectionReportModel.GroupFooter()
        Me.Label16 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.TextBox1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
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
        Me.CommRecipName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.AccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.HireDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.FirstName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.LastName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.FeeCategory = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.OriginalBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BeginningBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PaymentAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.SettlementNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.EndingBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Rate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Amount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox5 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label3 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.TextBox6 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox7 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.TextBox3 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox4 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.[Date] = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PT = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PageNumbers = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.CountCommPayId = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label11 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.SumAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox1, System.ComponentModel.ISupportInitialize).BeginInit
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
        CType(Me.CommRecipName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.HireDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FeeCategory, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.OriginalBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BeginningBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PaymentAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SettlementNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.EndingBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Rate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox5, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox6, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox7, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox3, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox4, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CountCommPayId, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.AccountNumber, Me.HireDate, Me.FirstName, Me.LastName, Me.Separator, Me.FeeCategory, Me.OriginalBalance, Me.BeginningBalance, Me.PaymentAmount, Me.SettlementNumber, Me.EndingBalance, Me.Rate, Me.Amount})
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
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.CountCommPayId, Me.Label11, Me.SumAmount, Me.TextBox})
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
        Me.PageFooter.Height = 0.4270833!
        Me.PageFooter.Name = "PageFooter"
        '
        'grpCompanyNameHeader
        '
        Me.grpCompanyNameHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.TextBox1})
        Me.grpCompanyNameHeader.DataField = "CompanyName"
        Me.grpCompanyNameHeader.Height = 0.4375!
        Me.grpCompanyNameHeader.Name = "grpCompanyNameHeader"
        '
        'grpCompanyNameFooter
        '
        Me.grpCompanyNameFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(245, Byte), Integer), CType(CType(245, Byte), Integer), CType(CType(245, Byte), Integer))
        Me.grpCompanyNameFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.TextBox2, Me.Label, Me.TextBox3, Me.TextBox4})
        Me.grpCompanyNameFooter.Height = 0.3125!
        Me.grpCompanyNameFooter.Name = "grpCompanyNameFooter"
        '
        'sortofPageHeader
        '
        Me.sortofPageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label1, Me.Label2, Me.Label4, Me.Label5, Me.Line1, Me.Label6, Me.Label7, Me.Label8, Me.Label9, Me.Label10, Me.Label12, Me.Label13, Me.Label14, Me.CommRecipName})
        Me.sortofPageHeader.DataField = "CommRecipName"
        Me.sortofPageHeader.Height = 0.7069445!
        Me.sortofPageHeader.Name = "sortofPageHeader"
        Me.sortofPageHeader.RepeatStyle = GrapeCity.ActiveReports.SectionReportModel.RepeatStyle.OnPageIncludeNoDetail
        '
        'sortofPageFooter
        '
        Me.sortofPageFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(245, Byte), Integer), CType(CType(245, Byte), Integer), CType(CType(245, Byte), Integer))
        Me.sortofPageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.TextBox5, Me.Label3, Me.TextBox6, Me.TextBox7})
        Me.sortofPageFooter.Height = 0.3125!
        Me.sortofPageFooter.Name = "sortofPageFooter"
        '
        'Label16
        '
        Me.Label16.Height = 0.1875!
        Me.Label16.HyperLink = Nothing
        Me.Label16.Left = 0.0625!
        Me.Label16.Name = "Label16"
        Me.Label16.Style = "font-size: 9.75pt; font-weight: bold; text-align: left; ddo-char-set: 0"
        Me.Label16.Text = "Service Fee Payments:"
        Me.Label16.Top = 0!
        Me.Label16.Width = 4.375!
        '
        'TextBox1
        '
        Me.TextBox1.CanGrow = false
        Me.TextBox1.DataField = "CompanyName"
        Me.TextBox1.Height = 0.1875!
        Me.TextBox1.Left = 0.0625!
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Style = "font-size: 9.75pt; font-weight: bold"
        Me.TextBox1.Text = "CompanyName"
        Me.TextBox1.Top = 0.1875!
        Me.TextBox1.Width = 5.875!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 0.0625!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = ""
        Me.Label1.Text = "Acct. #"
        Me.Label1.Top = 0.4375!
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
        Me.Label2.Top = 0.4375!
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
        Me.Label4.Top = 0.4375!
        Me.Label4.Width = 1.0625!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 2.6875!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: left"
        Me.Label5.Text = "Last Name"
        Me.Label5.Top = 0.4375!
        Me.Label5.Width = 1.125!
        '
        'Line1
        '
        Me.Line1.Height = 0!
        Me.Line1.Left = 0!
        Me.Line1.LineWeight = 3!
        Me.Line1.Name = "Line1"
        Me.Line1.Top = 0.6875!
        Me.Line1.Width = 11.25!
        Me.Line1.X1 = 0!
        Me.Line1.X2 = 11.25!
        Me.Line1.Y1 = 0.6875!
        Me.Line1.Y2 = 0.6875!
        '
        'Label6
        '
        Me.Label6.Height = 0.1875!
        Me.Label6.HyperLink = Nothing
        Me.Label6.Left = 3.8125!
        Me.Label6.Name = "Label6"
        Me.Label6.Style = "text-align: left"
        Me.Label6.Text = "Fee Category"
        Me.Label6.Top = 0.4375!
        Me.Label6.Width = 1.1875!
        '
        'Label7
        '
        Me.Label7.Height = 0.1875!
        Me.Label7.HyperLink = Nothing
        Me.Label7.Left = 5!
        Me.Label7.Name = "Label7"
        Me.Label7.Style = "text-align: left"
        Me.Label7.Text = "Setl No."
        Me.Label7.Top = 0.4375!
        Me.Label7.Width = 0.5625!
        '
        'Label8
        '
        Me.Label8.Height = 0.1875!
        Me.Label8.HyperLink = Nothing
        Me.Label8.Left = 5.5625!
        Me.Label8.Name = "Label8"
        Me.Label8.Style = "text-align: right"
        Me.Label8.Text = "Orig Bal."
        Me.Label8.Top = 0.4375!
        Me.Label8.Width = 0.9375!
        '
        'Label9
        '
        Me.Label9.Height = 0.1875!
        Me.Label9.HyperLink = Nothing
        Me.Label9.Left = 6.5!
        Me.Label9.Name = "Label9"
        Me.Label9.Style = "text-align: right"
        Me.Label9.Text = "Beg Bal."
        Me.Label9.Top = 0.4375!
        Me.Label9.Width = 0.9375!
        '
        'Label10
        '
        Me.Label10.Height = 0.1875!
        Me.Label10.HyperLink = Nothing
        Me.Label10.Left = 7.4375!
        Me.Label10.Name = "Label10"
        Me.Label10.Style = "text-align: right"
        Me.Label10.Text = "Pmt Amt."
        Me.Label10.Top = 0.4375!
        Me.Label10.Width = 0.9375!
        '
        'Label12
        '
        Me.Label12.Height = 0.1875!
        Me.Label12.HyperLink = Nothing
        Me.Label12.Left = 8.375!
        Me.Label12.Name = "Label12"
        Me.Label12.Style = "text-align: right"
        Me.Label12.Text = "End Bal."
        Me.Label12.Top = 0.4375!
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
        Me.Label13.Top = 0.4375!
        Me.Label13.Width = 0.75!
        '
        'Label14
        '
        Me.Label14.Height = 0.1875!
        Me.Label14.HyperLink = Nothing
        Me.Label14.Left = 10!
        Me.Label14.Name = "Label14"
        Me.Label14.Style = "text-align: right"
        Me.Label14.Text = "Amount"
        Me.Label14.Top = 0.4375!
        Me.Label14.Width = 0.9375!
        '
        'CommRecipName
        '
        Me.CommRecipName.CanGrow = false
        Me.CommRecipName.DataField = "CommRecipName"
        Me.CommRecipName.Height = 0.1875!
        Me.CommRecipName.Left = 0.0625!
        Me.CommRecipName.Name = "CommRecipName"
        Me.CommRecipName.OutputFormat = resources.GetString("CommRecipName.OutputFormat")
        Me.CommRecipName.Style = "color: Silver; text-align: left"
        Me.CommRecipName.Text = "CommRecipName"
        Me.CommRecipName.Top = 0.1875!
        Me.CommRecipName.Width = 6.125!
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
        Me.FirstName.Width = 1.0625!
        '
        'LastName
        '
        Me.LastName.CanGrow = false
        Me.LastName.DataField = "LastName"
        Me.LastName.Height = 0.1875!
        Me.LastName.Left = 2.6875!
        Me.LastName.Name = "LastName"
        Me.LastName.OutputFormat = resources.GetString("LastName.OutputFormat")
        Me.LastName.Style = "text-align: left"
        Me.LastName.Text = "LastName"
        Me.LastName.Top = 0.0625!
        Me.LastName.Width = 1.125!
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
        'FeeCategory
        '
        Me.FeeCategory.CanGrow = false
        Me.FeeCategory.DataField = "FeeCategory"
        Me.FeeCategory.Height = 0.1875!
        Me.FeeCategory.Left = 3.8125!
        Me.FeeCategory.Name = "FeeCategory"
        Me.FeeCategory.Text = "FeeCategory"
        Me.FeeCategory.Top = 0.0625!
        Me.FeeCategory.Width = 1.1875!
        '
        'OriginalBalance
        '
        Me.OriginalBalance.CanGrow = false
        Me.OriginalBalance.DataField = "OriginalBalance"
        Me.OriginalBalance.Height = 0.1875!
        Me.OriginalBalance.Left = 5.5625!
        Me.OriginalBalance.Name = "OriginalBalance"
        Me.OriginalBalance.OutputFormat = resources.GetString("OriginalBalance.OutputFormat")
        Me.OriginalBalance.Style = "text-align: right"
        Me.OriginalBalance.Text = "OriginalBalance"
        Me.OriginalBalance.Top = 0.0625!
        Me.OriginalBalance.Width = 0.9375!
        '
        'BeginningBalance
        '
        Me.BeginningBalance.CanGrow = false
        Me.BeginningBalance.DataField = "BeginningBalance"
        Me.BeginningBalance.Height = 0.1875!
        Me.BeginningBalance.Left = 6.5!
        Me.BeginningBalance.Name = "BeginningBalance"
        Me.BeginningBalance.OutputFormat = resources.GetString("BeginningBalance.OutputFormat")
        Me.BeginningBalance.Style = "text-align: right"
        Me.BeginningBalance.Text = "BeginningBalance"
        Me.BeginningBalance.Top = 0.0625!
        Me.BeginningBalance.Width = 0.9375!
        '
        'PaymentAmount
        '
        Me.PaymentAmount.CanGrow = false
        Me.PaymentAmount.DataField = "PaymentAmount"
        Me.PaymentAmount.Height = 0.1875!
        Me.PaymentAmount.Left = 7.4375!
        Me.PaymentAmount.Name = "PaymentAmount"
        Me.PaymentAmount.OutputFormat = resources.GetString("PaymentAmount.OutputFormat")
        Me.PaymentAmount.Style = "color: #009F00; text-align: right"
        Me.PaymentAmount.Text = "PaymentAmount"
        Me.PaymentAmount.Top = 0.0625!
        Me.PaymentAmount.Width = 0.9375!
        '
        'SettlementNumber
        '
        Me.SettlementNumber.CanGrow = false
        Me.SettlementNumber.DataField = "SettlementNumber"
        Me.SettlementNumber.Height = 0.1875!
        Me.SettlementNumber.Left = 5!
        Me.SettlementNumber.Name = "SettlementNumber"
        Me.SettlementNumber.Text = "SettlementNumber"
        Me.SettlementNumber.Top = 0.0625!
        Me.SettlementNumber.Width = 0.5625!
        '
        'EndingBalance
        '
        Me.EndingBalance.CanGrow = false
        Me.EndingBalance.DataField = "EndingBalance"
        Me.EndingBalance.Height = 0.1875!
        Me.EndingBalance.Left = 8.375!
        Me.EndingBalance.Name = "EndingBalance"
        Me.EndingBalance.OutputFormat = resources.GetString("EndingBalance.OutputFormat")
        Me.EndingBalance.Style = "text-align: right"
        Me.EndingBalance.Text = "EndingBalance"
        Me.EndingBalance.Top = 0.0625!
        Me.EndingBalance.Width = 0.875!
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
        'Amount
        '
        Me.Amount.CanGrow = false
        Me.Amount.DataField = "Amount"
        Me.Amount.Height = 0.1875!
        Me.Amount.Left = 10!
        Me.Amount.Name = "Amount"
        Me.Amount.OutputFormat = resources.GetString("Amount.OutputFormat")
        Me.Amount.Style = "text-align: right"
        Me.Amount.Text = "Amount"
        Me.Amount.Top = 0.0625!
        Me.Amount.Width = 0.9375!
        '
        'TextBox5
        '
        Me.TextBox5.DataField = "CommPayId"
        Me.TextBox5.DistinctField = "CommPayId"
        Me.TextBox5.Height = 0.1875!
        Me.TextBox5.Left = 2.0625!
        Me.TextBox5.Name = "TextBox5"
        Me.TextBox5.OutputFormat = resources.GetString("TextBox5.OutputFormat")
        Me.TextBox5.Style = "font-weight: bold"
        Me.TextBox5.SummaryFunc = GrapeCity.ActiveReports.SectionReportModel.SummaryFunc.Count
        Me.TextBox5.SummaryGroup = "sortofPageHeader"
        Me.TextBox5.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.Group
        Me.TextBox5.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.SubTotal
        Me.TextBox5.Text = "CountCommPayId"
        Me.TextBox5.Top = 0.0625!
        Me.TextBox5.Width = 1.5!
        '
        'Label3
        '
        Me.Label3.Height = 0.1875!
        Me.Label3.HyperLink = Nothing
        Me.Label3.Left = 0.0625!
        Me.Label3.Name = "Label3"
        Me.Label3.Style = "font-weight: bold"
        Me.Label3.Text = "Commission Recipient Total:"
        Me.Label3.Top = 0.0625!
        Me.Label3.Width = 2!
        '
        'TextBox6
        '
        Me.TextBox6.DataField = "Amount"
        Me.TextBox6.DistinctField = "Amount"
        Me.TextBox6.Height = 0.1875!
        Me.TextBox6.Left = 9.5!
        Me.TextBox6.Name = "TextBox6"
        Me.TextBox6.OutputFormat = resources.GetString("TextBox6.OutputFormat")
        Me.TextBox6.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox6.SummaryGroup = "sortofPageHeader"
        Me.TextBox6.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.Group
        Me.TextBox6.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.SubTotal
        Me.TextBox6.Text = "SumAmountComm"
        Me.TextBox6.Top = 0.0625!
        Me.TextBox6.Width = 1.4375!
        '
        'TextBox7
        '
        Me.TextBox7.Height = 0.1875!
        Me.TextBox7.Left = 5.625!
        Me.TextBox7.Name = "TextBox7"
        Me.TextBox7.OutputFormat = resources.GetString("TextBox7.OutputFormat")
        Me.TextBox7.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox7.Text = "Total for Commission Recipient:"
        Me.TextBox7.Top = 0.0625!
        Me.TextBox7.Width = 3.875!
        '
        'TextBox2
        '
        Me.TextBox2.DataField = "CommPayId"
        Me.TextBox2.DistinctField = "CommPayId"
        Me.TextBox2.Height = 0.1875!
        Me.TextBox2.Left = 1.0625!
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.OutputFormat = resources.GetString("TextBox2.OutputFormat")
        Me.TextBox2.Style = "font-weight: bold"
        Me.TextBox2.SummaryFunc = GrapeCity.ActiveReports.SectionReportModel.SummaryFunc.Count
        Me.TextBox2.SummaryGroup = "grpCompanyNameHeader"
        Me.TextBox2.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.Group
        Me.TextBox2.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.SubTotal
        Me.TextBox2.Text = "CountCommPayId"
        Me.TextBox2.Top = 0.0625!
        Me.TextBox2.Width = 1.5!
        '
        'Label
        '
        Me.Label.Height = 0.1875!
        Me.Label.HyperLink = Nothing
        Me.Label.Left = 0.0625!
        Me.Label.Name = "Label"
        Me.Label.Style = "font-weight: bold"
        Me.Label.Text = "Agency Total:"
        Me.Label.Top = 0.0625!
        Me.Label.Width = 1!
        '
        'TextBox3
        '
        Me.TextBox3.DataField = "Amount"
        Me.TextBox3.DistinctField = "Amount"
        Me.TextBox3.Height = 0.1875!
        Me.TextBox3.Left = 9.5!
        Me.TextBox3.Name = "TextBox3"
        Me.TextBox3.OutputFormat = resources.GetString("TextBox3.OutputFormat")
        Me.TextBox3.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox3.SummaryGroup = "grpCompanyNameHeader"
        Me.TextBox3.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.Group
        Me.TextBox3.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.SubTotal
        Me.TextBox3.Text = "SumAmountCompany"
        Me.TextBox3.Top = 0.0625!
        Me.TextBox3.Width = 1.4375!
        '
        'TextBox4
        '
        Me.TextBox4.Height = 0.1875!
        Me.TextBox4.Left = 6.125!
        Me.TextBox4.Name = "TextBox4"
        Me.TextBox4.OutputFormat = resources.GetString("TextBox4.OutputFormat")
        Me.TextBox4.Style = "font-size: 10pt; font-style: normal; font-weight: bold; text-align: right"
        Me.TextBox4.Text = "Total for Agency's Clients:"
        Me.TextBox4.Top = 0.0625!
        Me.TextBox4.Width = 3.375!
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
        'SumAmount
        '
        Me.SumAmount.DataField = "Amount"
        Me.SumAmount.DistinctField = "Amount"
        Me.SumAmount.Height = 0.1875!
        Me.SumAmount.Left = 9.5!
        Me.SumAmount.Name = "SumAmount"
        Me.SumAmount.OutputFormat = resources.GetString("SumAmount.OutputFormat")
        Me.SumAmount.Style = "font-weight: bold; text-align: right"
        Me.SumAmount.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.SumAmount.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.SumAmount.Text = "SumAmount"
        Me.SumAmount.Top = 0.0625!
        Me.SumAmount.Width = 1.4375!
        '
        'TextBox
        '
        Me.TextBox.Height = 0.1875!
        Me.TextBox.Left = 6.75!
        Me.TextBox.Name = "TextBox"
        Me.TextBox.OutputFormat = resources.GetString("TextBox.OutputFormat")
        Me.TextBox.Style = "font-weight: bold; text-align: right"
        Me.TextBox.Text = "Service Fee Payments Grand Total:"
        Me.TextBox.Top = 0.0625!
        Me.TextBox.Width = 2.75!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 10.98958!
        Me.Sections.Add(Me.ReportHeader)
        Me.Sections.Add(Me.PageHeader)
        Me.Sections.Add(Me.grpCompanyNameHeader)
        Me.Sections.Add(Me.sortofPageHeader)
        Me.Sections.Add(Me.Detail)
        Me.Sections.Add(Me.sortofPageFooter)
        Me.Sections.Add(Me.grpCompanyNameFooter)
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
        CType(Me.TextBox1, System.ComponentModel.ISupportInitialize).EndInit
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
        CType(Me.CommRecipName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.HireDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FeeCategory, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.OriginalBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BeginningBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PaymentAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SettlementNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.EndingBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Rate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox5, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox6, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox7, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox3, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox4, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CountCommPayId, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit
    End Sub

#End Region

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format


    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

    End Sub
End Class
