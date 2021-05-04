Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Public Class report_servicefee_my_charges
    Inherits GrapeCity.ActiveReports.SectionReport
    Public Sub New()
        MyBase.New()
        InitializeComponent()
    End Sub
#Region "ActiveReports Designer generated code"
    Private Detail As GrapeCity.ActiveReports.SectionReportModel.Detail
    Private AccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private HireDate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private FirstName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private LastName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line
    Private FeeCategory As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Amount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader
    Private Label16 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter
    Private CountRegisterId As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Label11 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private SumAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private sortofPageHeader As GrapeCity.ActiveReports.SectionReportModel.GroupHeader
    Private Label1 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label4 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label5 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Line1 As GrapeCity.ActiveReports.SectionReportModel.Line
    Private Label6 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label14 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private sortofPageFooter As GrapeCity.ActiveReports.SectionReportModel.GroupFooter

    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(report_servicefee_my_charges))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.sortofPageHeader = New GrapeCity.ActiveReports.SectionReportModel.GroupHeader()
        Me.sortofPageFooter = New GrapeCity.ActiveReports.SectionReportModel.GroupFooter()
        Me.Label16 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label1 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label2 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label4 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label5 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Line1 = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.Label6 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label14 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.AccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.HireDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.FirstName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.LastName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.FeeCategory = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Amount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CountRegisterId = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Label11 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.SumAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label4, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label5, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label6, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label14, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.HireDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FeeCategory, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CountRegisterId, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.AccountNumber, Me.HireDate, Me.FirstName, Me.LastName, Me.Separator, Me.FeeCategory, Me.Amount})
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
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.CountRegisterId, Me.Label11, Me.SumAmount, Me.TextBox})
        Me.ReportFooter.Height = 0.2909722!
        Me.ReportFooter.KeepTogether = true
        Me.ReportFooter.Name = "ReportFooter"
        '
        'sortofPageHeader
        '
        Me.sortofPageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label1, Me.Label2, Me.Label4, Me.Label5, Me.Line1, Me.Label6, Me.Label14})
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
        Me.Label16.Text = "Service Fee New Charges/Overview:"
        Me.Label16.Top = 0!
        Me.Label16.Width = 4.625!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 0.0625!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = ""
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
        Me.Label2.Style = "text-align: center"
        Me.Label2.Text = "Hire Date"
        Me.Label2.Top = 0!
        Me.Label2.Width = 1.0625!
        '
        'Label4
        '
        Me.Label4.Height = 0.1875!
        Me.Label4.HyperLink = Nothing
        Me.Label4.Left = 1.8125!
        Me.Label4.Name = "Label4"
        Me.Label4.Style = ""
        Me.Label4.Text = "First Name"
        Me.Label4.Top = 0!
        Me.Label4.Width = 1.875!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 3.6875!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: left"
        Me.Label5.Text = "Last Name"
        Me.Label5.Top = 0!
        Me.Label5.Width = 2.6875!
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
        Me.Label6.Left = 6.375!
        Me.Label6.Name = "Label6"
        Me.Label6.Style = "text-align: left"
        Me.Label6.Text = "Fee Category"
        Me.Label6.Top = 0!
        Me.Label6.Width = 3.75!
        '
        'Label14
        '
        Me.Label14.Height = 0.1875!
        Me.Label14.HyperLink = Nothing
        Me.Label14.Left = 10.125!
        Me.Label14.Name = "Label14"
        Me.Label14.Style = "text-align: right"
        Me.Label14.Text = "Amount"
        Me.Label14.Top = 0!
        Me.Label14.Width = 0.8125!
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
        Me.HireDate.Width = 1.0625!
        '
        'FirstName
        '
        Me.FirstName.CanGrow = false
        Me.FirstName.DataField = "FirstName"
        Me.FirstName.Height = 0.1875!
        Me.FirstName.Left = 1.8125!
        Me.FirstName.Name = "FirstName"
        Me.FirstName.Text = "FirstName"
        Me.FirstName.Top = 0.0625!
        Me.FirstName.Width = 1.875!
        '
        'LastName
        '
        Me.LastName.CanGrow = false
        Me.LastName.DataField = "LastName"
        Me.LastName.Height = 0.1875!
        Me.LastName.Left = 3.6875!
        Me.LastName.Name = "LastName"
        Me.LastName.OutputFormat = resources.GetString("LastName.OutputFormat")
        Me.LastName.Style = "text-align: left"
        Me.LastName.Text = "LastName"
        Me.LastName.Top = 0.0625!
        Me.LastName.Width = 2.6875!
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
        Me.FeeCategory.Left = 6.375!
        Me.FeeCategory.Name = "FeeCategory"
        Me.FeeCategory.Text = "FeeCategory"
        Me.FeeCategory.Top = 0.0625!
        Me.FeeCategory.Width = 3.75!
        '
        'Amount
        '
        Me.Amount.CanGrow = false
        Me.Amount.DataField = "Amount"
        Me.Amount.Height = 0.1875!
        Me.Amount.Left = 10.125!
        Me.Amount.Name = "Amount"
        Me.Amount.OutputFormat = resources.GetString("Amount.OutputFormat")
        Me.Amount.Style = "text-align: right"
        Me.Amount.Text = "Amount"
        Me.Amount.Top = 0.0625!
        Me.Amount.Width = 0.8125!
        '
        'CountRegisterId
        '
        Me.CountRegisterId.DataField = "CountRegisterId"
        Me.CountRegisterId.DistinctField = "CountRegisterId"
        Me.CountRegisterId.Height = 0.1875!
        Me.CountRegisterId.Left = 0.5!
        Me.CountRegisterId.Name = "CountRegisterId"
        Me.CountRegisterId.OutputFormat = resources.GetString("CountRegisterId.OutputFormat")
        Me.CountRegisterId.Style = "font-weight: bold"
        Me.CountRegisterId.SummaryFunc = GrapeCity.ActiveReports.SectionReportModel.SummaryFunc.Count
        Me.CountRegisterId.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.CountRegisterId.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.CountRegisterId.Text = "CountRegisterId"
        Me.CountRegisterId.Top = 0.0625!
        Me.CountRegisterId.Width = 1.5!
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
        Me.TextBox.Text = "Service Fee New Charges Total:"
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
        Me.Sections.Add(Me.sortofPageHeader)
        Me.Sections.Add(Me.Detail)
        Me.Sections.Add(Me.sortofPageFooter)
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
        CType(Me.Label14, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.AccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.HireDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FirstName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.LastName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FeeCategory, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CountRegisterId, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub
#End Region
End Class
