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

Public Class report_servicefee_agency
    Inherits GrapeCity.ActiveReports.SectionReport

    Private ChargesRequired As Boolean = True

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
    Private srPayments As GrapeCity.ActiveReports.SectionReportModel.SubReport
    Private srCharges As GrapeCity.ActiveReports.SectionReportModel.SubReport
    Private [Date] As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PN As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PT As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private PageNumbers As GrapeCity.ActiveReports.SectionReportModel.Label
    Private PreviousBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private NewChargesTotal As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private FeePaymentsTotal As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox4 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private EndingBalance As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private asdf As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Line1 As GrapeCity.ActiveReports.SectionReportModel.Line
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(report_servicefee_agency))
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
        Me.srPayments = New GrapeCity.ActiveReports.SectionReportModel.SubReport()
        Me.srCharges = New GrapeCity.ActiveReports.SectionReportModel.SubReport()
        Me.[Date] = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PN = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PT = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.PageNumbers = New GrapeCity.ActiveReports.SectionReportModel.Label()
        Me.PreviousBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.NewChargesTotal = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.FeePaymentsTotal = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox4 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.EndingBalance = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.asdf = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Line1 = New GrapeCity.ActiveReports.SectionReportModel.Line()
        CType(Me.Label, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label15, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.CompanyName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.Period, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.PreviousBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.NewChargesTotal, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.FeePaymentsTotal, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox4, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.EndingBalance, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.asdf, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.CanShrink = true
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.srPayments, Me.srCharges})
        Me.Detail.Height = 2.28125!
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
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.PreviousBalance, Me.TextBox, Me.NewChargesTotal, Me.TextBox2, Me.FeePaymentsTotal, Me.TextBox4, Me.EndingBalance, Me.asdf, Me.Line1})
        Me.ReportFooter.Height = 1.228472!
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
        Me.Label.Text = "Service Fee Report"
        Me.Label.Top = 0.6875!
        Me.Label.Width = 11!
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
        Me.Label16.Text = "Period:"
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
        'srPayments
        '
        Me.srPayments.CloseBorder = false
        Me.srPayments.Height = 0.6875!
        Me.srPayments.Left = 0!
        Me.srPayments.Name = "srPayments"
        Me.srPayments.Report = Nothing
        Me.srPayments.ReportName = "rptChecklist_Questions"
        Me.srPayments.Top = 0.0625!
        Me.srPayments.Width = 11!
        '
        'srCharges
        '
        Me.srCharges.CloseBorder = false
        Me.srCharges.Height = 0.7083333!
        Me.srCharges.Left = 0!
        Me.srCharges.Name = "srCharges"
        Me.srCharges.Report = Nothing
        Me.srCharges.ReportName = "rptChecklist_Questions"
        Me.srCharges.Top = 1.541667!
        Me.srCharges.Width = 11!
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
        'PreviousBalance
        '
        Me.PreviousBalance.DataField = "PreviousBalance"
        Me.PreviousBalance.Height = 0.1875!
        Me.PreviousBalance.Left = 9.5!
        Me.PreviousBalance.Name = "PreviousBalance"
        Me.PreviousBalance.OutputFormat = resources.GetString("PreviousBalance.OutputFormat")
        Me.PreviousBalance.Style = "font-weight: bold; text-align: right"
        Me.PreviousBalance.Text = "PreviousBalance"
        Me.PreviousBalance.Top = 0.4375!
        Me.PreviousBalance.Width = 1.4375!
        '
        'TextBox
        '
        Me.TextBox.Height = 0.1875!
        Me.TextBox.Left = 5.4375!
        Me.TextBox.Name = "TextBox"
        Me.TextBox.OutputFormat = resources.GetString("TextBox.OutputFormat")
        Me.TextBox.Style = "font-weight: bold; text-align: right"
        Me.TextBox.Text = "Service Fee Previous Balance:"
        Me.TextBox.Top = 0.4375!
        Me.TextBox.Width = 4.0625!
        '
        'NewChargesTotal
        '
        Me.NewChargesTotal.DataField = "NewChargesTotal"
        Me.NewChargesTotal.Height = 0.1875!
        Me.NewChargesTotal.Left = 9.5!
        Me.NewChargesTotal.Name = "NewChargesTotal"
        Me.NewChargesTotal.OutputFormat = resources.GetString("NewChargesTotal.OutputFormat")
        Me.NewChargesTotal.Style = "font-weight: bold; text-align: right"
        Me.NewChargesTotal.Text = "NewChargesTotal"
        Me.NewChargesTotal.Top = 0.625!
        Me.NewChargesTotal.Width = 1.4375!
        '
        'TextBox2
        '
        Me.TextBox2.Height = 0.1875!
        Me.TextBox2.Left = 5.4375!
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.OutputFormat = resources.GetString("TextBox2.OutputFormat")
        Me.TextBox2.Style = "font-weight: bold; text-align: right"
        Me.TextBox2.Text = "Service Fee New Charges:"
        Me.TextBox2.Top = 0.625!
        Me.TextBox2.Width = 4.0625!
        '
        'FeePaymentsTotal
        '
        Me.FeePaymentsTotal.DataField = "FeePaymentsTotal"
        Me.FeePaymentsTotal.Height = 0.1875!
        Me.FeePaymentsTotal.Left = 9.5!
        Me.FeePaymentsTotal.Name = "FeePaymentsTotal"
        Me.FeePaymentsTotal.OutputFormat = resources.GetString("FeePaymentsTotal.OutputFormat")
        Me.FeePaymentsTotal.Style = "font-weight: bold; text-align: right"
        Me.FeePaymentsTotal.Text = "FeePaymentsTotal"
        Me.FeePaymentsTotal.Top = 0.8125!
        Me.FeePaymentsTotal.Width = 1.4375!
        '
        'TextBox4
        '
        Me.TextBox4.Height = 0.1875!
        Me.TextBox4.Left = 5.4375!
        Me.TextBox4.Name = "TextBox4"
        Me.TextBox4.OutputFormat = resources.GetString("TextBox4.OutputFormat")
        Me.TextBox4.Style = "font-weight: bold; text-align: right"
        Me.TextBox4.Text = "Service Fee Payments:"
        Me.TextBox4.Top = 0.8125!
        Me.TextBox4.Width = 4.0625!
        '
        'EndingBalance
        '
        Me.EndingBalance.Height = 0.1875!
        Me.EndingBalance.Left = 9.5!
        Me.EndingBalance.Name = "EndingBalance"
        Me.EndingBalance.OutputFormat = resources.GetString("EndingBalance.OutputFormat")
        Me.EndingBalance.Style = "font-weight: bold; text-align: right"
        Me.EndingBalance.Text = "EndingBalance"
        Me.EndingBalance.Top = 1!
        Me.EndingBalance.Width = 1.4375!
        '
        'asdf
        '
        Me.asdf.Height = 0.1875!
        Me.asdf.Left = 5.4375!
        Me.asdf.Name = "asdf"
        Me.asdf.OutputFormat = resources.GetString("asdf.OutputFormat")
        Me.asdf.Style = "font-weight: bold; text-align: right"
        Me.asdf.Text = "Service Fee Ending Balance:"
        Me.asdf.Top = 1!
        Me.asdf.Width = 4.0625!
        '
        'Line1
        '
        Me.Line1.Height = 0!
        Me.Line1.Left = 7.3125!
        Me.Line1.LineWeight = 3!
        Me.Line1.Name = "Line1"
        Me.Line1.Top = 0.390625!
        Me.Line1.Width = 3.6875!
        Me.Line1.X1 = 7.3125!
        Me.Line1.X2 = 11!
        Me.Line1.Y1 = 0.390625!
        Me.Line1.Y2 = 0.390625!
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
        CType(Me.Label, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label15, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Label16, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.CompanyName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.Period, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.[Date], System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PN, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PT, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PageNumbers, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.PreviousBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.NewChargesTotal, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.FeePaymentsTotal, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox4, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.EndingBalance, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.asdf, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        EndingBalance.Text = CType((Fields("NewChargesTotal").Value - Fields("FeePaymentsTotal").Value + Fields("PreviousBalance").Value), Single).ToString("c")

        Using cmd As IDbCommand = CommandHelper.DeepClone(CType(HttpContext.Current.Session("rptcmd_report_servicefee_agency_payments"), IDbCommand))
            Using cmd.Connection
                cmd.Connection.Open()
                Dim dt As DataTable = New DataTable
                Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                da.Fill(dt)

                Dim rpt As ActiveReport3 = New report_servicefee_agency_payments

                rpt.DataSource = dt
                rpt.UserData = cmd
                srPayments.Report = rpt

            End Using
        End Using
        Try
            Using cmd As IDbCommand = CommandHelper.DeepClone(CType(HttpContext.Current.Session("rptcmd_report_servicefee_agency_charges"), IDbCommand))
                Using cmd.Connection
                    cmd.Connection.Open()
                    Dim dt As DataTable = New DataTable
                    Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                    da.Fill(dt)

                    Dim rpt As ActiveReport3 = New report_servicefee_agency_charges

                    rpt.DataSource = dt
                    rpt.UserData = cmd
                    srCharges.Report = rpt

                End Using
            End Using
        Catch
            ChargesRequired = False
            ReportFooter.Visible = False
        End Try
    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub

    Private Sub ReportFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportFooter.Format
        If Not ChargesRequired Then
            ReportFooter.Visible = False
        End If
    End Sub
End Class