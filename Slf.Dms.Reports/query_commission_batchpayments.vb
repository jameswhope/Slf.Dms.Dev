Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Public Class query_commission_batchpayments
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
    Private WithEvents sortofPageHeader As GrapeCity.ActiveReports.SectionReportModel.GroupHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents sortofPageFooter As GrapeCity.ActiveReports.SectionReportModel.GroupFooter = Nothing
    Private WithEvents ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter = Nothing
    Private Label16 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label1 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label2 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label4 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label5 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Line1 As GrapeCity.ActiveReports.SectionReportModel.Line
    Private Label6 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label14 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label3 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private Label7 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private CommRecName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TransferAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Amount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private CheckNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Separator As GrapeCity.ActiveReports.SectionReportModel.Line
    Private CheckDate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ACHTries As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private CommBatchId As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private BatchDate As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private ParentCommRecName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private CountCommBatchTransferId As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Label11 As GrapeCity.ActiveReports.SectionReportModel.Label
    Private SumAmount As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(query_commission_batchpayments))
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
        Me.Label = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label3 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.Label7 = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.CommRecName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TransferAmount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Amount = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CheckNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Separator = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.CheckDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ACHTries = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CommBatchId = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.BatchDate = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.ParentCommRecName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.CountCommBatchTransferId = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
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
        CType(Me.Label, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label7, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CommRecName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TransferAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CheckNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CheckDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ACHTries, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CommBatchId, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.BatchDate, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.ParentCommRecName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CountCommBatchTransferId, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.CommRecName, Me.TransferAmount, Me.Amount, Me.CheckNumber, Me.Separator, Me.CheckDate, Me.ACHTries, Me.CommBatchId, Me.BatchDate, Me.ParentCommRecName})
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
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.CountCommBatchTransferId, Me.Label11, Me.SumAmount, Me.TextBox})
        Me.ReportFooter.Height = 0.3125!
        Me.ReportFooter.KeepTogether = true
        Me.ReportFooter.Name = "ReportFooter"
        '
        'sortofPageHeader
        '
        Me.sortofPageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Label1, Me.Label2, Me.Label4, Me.Label5, Me.Line1, Me.Label6, Me.Label14, Me.Label, Me.Label3, Me.Label7})
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
        Me.Label16.Text = "Query Results - Commission Batch Payments:"
        Me.Label16.Top = 0!
        Me.Label16.Width = 4.625!
        '
        'Label1
        '
        Me.Label1.Height = 0.1875!
        Me.Label1.HyperLink = Nothing
        Me.Label1.Left = 3.5625!
        Me.Label1.Name = "Label1"
        Me.Label1.Style = ""
        Me.Label1.Text = "Recipient"
        Me.Label1.Top = 0!
        Me.Label1.Width = 2.4375!
        '
        'Label2
        '
        Me.Label2.Height = 0.1875!
        Me.Label2.HyperLink = Nothing
        Me.Label2.Left = 6!
        Me.Label2.Name = "Label2"
        Me.Label2.Style = "text-align: right"
        Me.Label2.Text = "Transfer Amt"
        Me.Label2.Top = 0!
        Me.Label2.Width = 0.875!
        '
        'Label4
        '
        Me.Label4.Height = 0.1875!
        Me.Label4.HyperLink = Nothing
        Me.Label4.Left = 6.875!
        Me.Label4.Name = "Label4"
        Me.Label4.Style = "text-align: right"
        Me.Label4.Text = "Total Amt"
        Me.Label4.Top = 0!
        Me.Label4.Width = 0.875!
        '
        'Label5
        '
        Me.Label5.Height = 0.1875!
        Me.Label5.HyperLink = Nothing
        Me.Label5.Left = 7.8125!
        Me.Label5.Name = "Label5"
        Me.Label5.Style = "text-align: left"
        Me.Label5.Text = "Check #"
        Me.Label5.Top = 0!
        Me.Label5.Width = 0.9375!
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
        Me.Label6.Left = 8.75!
        Me.Label6.Name = "Label6"
        Me.Label6.Style = "text-align: center"
        Me.Label6.Text = "Check Date"
        Me.Label6.Top = 0!
        Me.Label6.Width = 1.0625!
        '
        'Label14
        '
        Me.Label14.Height = 0.1875!
        Me.Label14.HyperLink = Nothing
        Me.Label14.Left = 9.8125!
        Me.Label14.Name = "Label14"
        Me.Label14.Style = "text-align: left"
        Me.Label14.Text = "ACH Tries"
        Me.Label14.Top = 0!
        Me.Label14.Width = 0.6875!
        '
        'Label
        '
        Me.Label.Height = 0.1875!
        Me.Label.HyperLink = Nothing
        Me.Label.Left = 0!
        Me.Label.Name = "Label"
        Me.Label.Style = "text-align: left"
        Me.Label.Text = "Batch"
        Me.Label.Top = 0!
        Me.Label.Width = 0.4375!
        '
        'Label3
        '
        Me.Label3.Height = 0.1875!
        Me.Label3.HyperLink = Nothing
        Me.Label3.Left = 0.4375!
        Me.Label3.Name = "Label3"
        Me.Label3.Style = "text-align: center"
        Me.Label3.Text = "Batch Date"
        Me.Label3.Top = 0!
        Me.Label3.Width = 1!
        '
        'Label7
        '
        Me.Label7.Height = 0.1875!
        Me.Label7.HyperLink = Nothing
        Me.Label7.Left = 1.4375!
        Me.Label7.Name = "Label7"
        Me.Label7.Style = ""
        Me.Label7.Text = "From"
        Me.Label7.Top = 0!
        Me.Label7.Width = 2.125!
        '
        'CommRecName
        '
        Me.CommRecName.CanGrow = false
        Me.CommRecName.DataField = "CommRecName"
        Me.CommRecName.Height = 0.1875!
        Me.CommRecName.Left = 3.5625!
        Me.CommRecName.Name = "CommRecName"
        Me.CommRecName.Text = "CommRecName"
        Me.CommRecName.Top = 0.0625!
        Me.CommRecName.Width = 2.4375!
        '
        'TransferAmount
        '
        Me.TransferAmount.CanGrow = false
        Me.TransferAmount.DataField = "TransferAmount"
        Me.TransferAmount.Height = 0.1875!
        Me.TransferAmount.Left = 6!
        Me.TransferAmount.Name = "TransferAmount"
        Me.TransferAmount.OutputFormat = resources.GetString("TransferAmount.OutputFormat")
        Me.TransferAmount.Style = "text-align: right"
        Me.TransferAmount.Text = "TransferAmount"
        Me.TransferAmount.Top = 0.0625!
        Me.TransferAmount.Width = 0.875!
        '
        'Amount
        '
        Me.Amount.CanGrow = false
        Me.Amount.DataField = "Amount"
        Me.Amount.Height = 0.1875!
        Me.Amount.Left = 6.875!
        Me.Amount.Name = "Amount"
        Me.Amount.OutputFormat = resources.GetString("Amount.OutputFormat")
        Me.Amount.Style = "text-align: right"
        Me.Amount.Text = "Amount"
        Me.Amount.Top = 0.0625!
        Me.Amount.Width = 0.875!
        '
        'CheckNumber
        '
        Me.CheckNumber.CanGrow = false
        Me.CheckNumber.DataField = "CheckNumber"
        Me.CheckNumber.Height = 0.1875!
        Me.CheckNumber.Left = 7.8125!
        Me.CheckNumber.Name = "CheckNumber"
        Me.CheckNumber.OutputFormat = resources.GetString("CheckNumber.OutputFormat")
        Me.CheckNumber.Style = "text-align: left"
        Me.CheckNumber.Text = "CheckNumber"
        Me.CheckNumber.Top = 0.0625!
        Me.CheckNumber.Width = 0.9375!
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
        'CheckDate
        '
        Me.CheckDate.CanGrow = false
        Me.CheckDate.DataField = "CheckDate"
        Me.CheckDate.Height = 0.1875!
        Me.CheckDate.Left = 8.75!
        Me.CheckDate.Name = "CheckDate"
        Me.CheckDate.OutputFormat = resources.GetString("CheckDate.OutputFormat")
        Me.CheckDate.Style = "text-align: center"
        Me.CheckDate.Text = "CheckDate"
        Me.CheckDate.Top = 0.0625!
        Me.CheckDate.Width = 1.0625!
        '
        'ACHTries
        '
        Me.ACHTries.CanGrow = false
        Me.ACHTries.DataField = "ACHTries"
        Me.ACHTries.Height = 0.1875!
        Me.ACHTries.Left = 9.8125!
        Me.ACHTries.Name = "ACHTries"
        Me.ACHTries.OutputFormat = resources.GetString("ACHTries.OutputFormat")
        Me.ACHTries.Style = "text-align: left"
        Me.ACHTries.Text = "ACHTries"
        Me.ACHTries.Top = 0.0625!
        Me.ACHTries.Width = 0.6875!
        '
        'CommBatchId
        '
        Me.CommBatchId.CanGrow = false
        Me.CommBatchId.DataField = "CommBatchId"
        Me.CommBatchId.Height = 0.1875!
        Me.CommBatchId.Left = 0!
        Me.CommBatchId.Name = "CommBatchId"
        Me.CommBatchId.OutputFormat = resources.GetString("CommBatchId.OutputFormat")
        Me.CommBatchId.Style = "text-align: left"
        Me.CommBatchId.Text = "CommBatchId"
        Me.CommBatchId.Top = 0.0625!
        Me.CommBatchId.Width = 0.4375!
        '
        'BatchDate
        '
        Me.BatchDate.CanGrow = false
        Me.BatchDate.DataField = "BatchDate"
        Me.BatchDate.Height = 0.1875!
        Me.BatchDate.Left = 0.4375!
        Me.BatchDate.Name = "BatchDate"
        Me.BatchDate.OutputFormat = resources.GetString("BatchDate.OutputFormat")
        Me.BatchDate.Style = "text-align: center"
        Me.BatchDate.Text = "BatchDate"
        Me.BatchDate.Top = 0.0625!
        Me.BatchDate.Width = 1!
        '
        'ParentCommRecName
        '
        Me.ParentCommRecName.CanGrow = false
        Me.ParentCommRecName.DataField = "ParentCommRecName"
        Me.ParentCommRecName.Height = 0.1875!
        Me.ParentCommRecName.Left = 1.4375!
        Me.ParentCommRecName.Name = "ParentCommRecName"
        Me.ParentCommRecName.Text = "ParentCommRecName"
        Me.ParentCommRecName.Top = 0.0625!
        Me.ParentCommRecName.Width = 2.125!
        '
        'CountCommBatchTransferId
        '
        Me.CountCommBatchTransferId.DataField = "CommBatchTransferId"
        Me.CountCommBatchTransferId.DistinctField = "CommBatchTransferId"
        Me.CountCommBatchTransferId.Height = 0.1875!
        Me.CountCommBatchTransferId.Left = 0.5!
        Me.CountCommBatchTransferId.Name = "CountCommBatchTransferId"
        Me.CountCommBatchTransferId.OutputFormat = resources.GetString("CountCommBatchTransferId.OutputFormat")
        Me.CountCommBatchTransferId.Style = "font-weight: bold"
        Me.CountCommBatchTransferId.SummaryFunc = GrapeCity.ActiveReports.SectionReportModel.SummaryFunc.Count
        Me.CountCommBatchTransferId.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.CountCommBatchTransferId.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.CountCommBatchTransferId.Text = "CountCommBatchTransferId"
        Me.CountCommBatchTransferId.Top = 0.0625!
        Me.CountCommBatchTransferId.Width = 1.5!
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
        Me.SumAmount.Left = 6.875!
        Me.SumAmount.Name = "SumAmount"
        Me.SumAmount.OutputFormat = resources.GetString("SumAmount.OutputFormat")
        Me.SumAmount.Style = "font-weight: bold; text-align: right"
        Me.SumAmount.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.SumAmount.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.SumAmount.Text = "SumAmount"
        Me.SumAmount.Top = 0.0625!
        Me.SumAmount.Width = 0.875!
        '
        'TextBox
        '
        Me.TextBox.DataField = "TransferAmount"
        Me.TextBox.DistinctField = "TransferAmount"
        Me.TextBox.Height = 0.1875!
        Me.TextBox.Left = 4.8125!
        Me.TextBox.Name = "TextBox"
        Me.TextBox.OutputFormat = resources.GetString("TextBox.OutputFormat")
        Me.TextBox.Style = "font-weight: bold; text-align: right"
        Me.TextBox.SummaryRunning = GrapeCity.ActiveReports.SectionReportModel.SummaryRunning.All
        Me.TextBox.SummaryType = GrapeCity.ActiveReports.SectionReportModel.SummaryType.GrandTotal
        Me.TextBox.Text = "SumTransferAmount"
        Me.TextBox.Top = 0.0625!
        Me.TextBox.Width = 2.0625!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 10.5!
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
        CType(Me.Label, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label3, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label7, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CommRecName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TransferAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Amount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CheckNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CheckDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ACHTries, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CommBatchId, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.BatchDate, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.ParentCommRecName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CountCommBatchTransferId, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label11, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.SumAmount, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub ReportFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportFooter.Format

    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub
End Class
