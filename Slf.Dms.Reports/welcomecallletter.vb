Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Imports Drg.Util.DataAccess

Public Class welcomecallletter
    Inherits GrapeCity.ActiveReports.SectionReport

    Public Sub New()
        MyBase.New()

        InitializeComponent()

        PageSettings.Margins.Top = 0.75
        PageSettings.Margins.Left = 0.75
        PageSettings.Margins.Right = 0.75
        PageSettings.Margins.Bottom = 0.75

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private Picture1 As GrapeCity.ActiveReports.SectionReportModel.Picture
    Private RichTextBox As GrapeCity.ActiveReports.SectionReportModel.RichTextBox
    Private txtAccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtFirstName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtAddress As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtNow As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(welcomecallletter))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.Picture1 = New GrapeCity.ActiveReports.SectionReportModel.Picture()
        Me.RichTextBox = New GrapeCity.ActiveReports.SectionReportModel.RichTextBox()
        Me.txtAccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtFirstName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtAddress = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtNow = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Picture1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtFirstName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAddress, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.RichTextBox, Me.txtAccountNumber, Me.txtFirstName, Me.txtAddress, Me.txtNow, Me.TextBox})
        Me.Detail.Height = 13.76042!
        Me.Detail.Name = "Detail"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Picture1})
        Me.PageHeader.Height = 1.165972!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.Height = 0!
        Me.PageFooter.Name = "PageFooter"
        '
        'Picture1
        '
        Me.Picture1.Height = 0.875!
        Me.Picture1.ImageData = Nothing
        Me.Picture1.Left = 0!
        Me.Picture1.LineColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Picture1.Name = "Picture1"
        Me.Picture1.SizeMode = GrapeCity.ActiveReports.SectionReportModel.SizeModes.Zoom
        Me.Picture1.Top = 0!
        Me.Picture1.Width = 3.125!
        '
        'RichTextBox
        '
        Me.RichTextBox.AutoReplaceFields = true
        Me.RichTextBox.Font = New System.Drawing.Font("Arial", 10!)
        Me.RichTextBox.Height = 11.25!
        Me.RichTextBox.Left = 0!
        Me.RichTextBox.Name = "RichTextBox"
        Me.RichTextBox.RTF = resources.GetString("RichTextBox.RTF")
        Me.RichTextBox.Top = 2.125!
        Me.RichTextBox.Width = 7!
        '
        'txtAccountNumber
        '
        Me.txtAccountNumber.DataField = "AccountNumber"
        Me.txtAccountNumber.Height = 0.1875!
        Me.txtAccountNumber.Left = 4.875!
        Me.txtAccountNumber.Name = "txtAccountNumber"
        Me.txtAccountNumber.Style = "font-size: 12pt; font-weight: normal; text-align: right; ddo-char-set: 1"
        Me.txtAccountNumber.Text = "txtAccountNumber"
        Me.txtAccountNumber.Top = 0.375!
        Me.txtAccountNumber.Width = 2.125!
        '
        'txtFirstName
        '
        Me.txtFirstName.DataField = "FirstName"
        Me.txtFirstName.Height = 0.25!
        Me.txtFirstName.Left = 0!
        Me.txtFirstName.Name = "txtFirstName"
        Me.txtFirstName.Style = "font-size: 11.25pt; font-weight: normal"
        Me.txtFirstName.Text = "txtFirstName"
        Me.txtFirstName.Top = 1.625!
        Me.txtFirstName.Width = 4.5!
        '
        'txtAddress
        '
        Me.txtAddress.Height = 0.6875!
        Me.txtAddress.Left = 0!
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.Style = "font-size: 11pt; ddo-char-set: 1"
        Me.txtAddress.Text = "txtAddress"
        Me.txtAddress.Top = 0.375!
        Me.txtAddress.Width = 3.4375!
        '
        'txtNow
        '
        Me.txtNow.Height = 0.2!
        Me.txtNow.Left = 0!
        Me.txtNow.Name = "txtNow"
        Me.txtNow.Text = "txtNow"
        Me.txtNow.Top = 0!
        Me.txtNow.Width = 2.375!
        '
        'TextBox
        '
        Me.TextBox.Height = 0.25!
        Me.TextBox.Left = 0!
        Me.TextBox.Name = "TextBox"
        Me.TextBox.Style = "font-size: 11.25pt; font-weight: normal"
        Me.TextBox.Text = "Re: Welcome Call"
        Me.TextBox.Top = 1.1875!
        Me.TextBox.Width = 4.5!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 7!
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
        CType(Me.Picture1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtFirstName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAddress, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        txtFirstName.Text = "Dear " & Fields("FirstName").Value & ","


        txtAddress.Text = Fields("FirstName").Value & " " & Fields("LastName").Value & vbCrLf & Fields("Street").Value
        If Not String.IsNullOrEmpty(DataHelper.Nz_string(Fields("Street2").Value)) Then
            txtAddress.Text += vbCrLf & Fields("Street2").Value
        End If
        txtAddress.Text += vbCrLf & Fields("City").Value & ", " & Fields("State").Value & " " & Fields("ZipCode").Value

        txtNow.Text = Now.ToString("MMMM dd, yyyy")
        txtAccountNumber.Text = "Account # " & Fields("AccountNumber").Value
    End Sub
End Class