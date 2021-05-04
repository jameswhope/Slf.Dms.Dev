Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Imports Drg.Util.DataAccess

Public Class welcomecoverletter
    Inherits GrapeCity.ActiveReports.SectionReport

    Public Sub New()
        MyBase.New()

        InitializeComponent()

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private Picture As GrapeCity.ActiveReports.SectionReportModel.Picture
    Private RichTextBox As GrapeCity.ActiveReports.SectionReportModel.RichTextBox
    Private txtAddress As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtNow As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(welcomecoverletter))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.Picture = New GrapeCity.ActiveReports.SectionReportModel.Picture()
        Me.RichTextBox = New GrapeCity.ActiveReports.SectionReportModel.RichTextBox()
        Me.txtAddress = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtNow = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAddress, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.RichTextBox, Me.txtAddress, Me.txtNow})
        Me.Detail.Height = 5.603472!
        Me.Detail.Name = "Detail"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Picture})
        Me.PageHeader.Height = 0.8944445!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.Height = 0!
        Me.PageFooter.Name = "PageFooter"
        '
        'Picture
        '
        Me.Picture.Height = 0.875!
        Me.Picture.ImageData = Nothing
        Me.Picture.Left = 0.0625!
        Me.Picture.LineColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Picture.Name = "Picture"
        Me.Picture.SizeMode = GrapeCity.ActiveReports.SectionReportModel.SizeModes.Zoom
        Me.Picture.Top = 0!
        Me.Picture.Width = 3.188!
        '
        'RichTextBox
        '
        Me.RichTextBox.AutoReplaceFields = true
        Me.RichTextBox.Font = New System.Drawing.Font("Arial", 10!)
        Me.RichTextBox.Height = 2.9375!
        Me.RichTextBox.Left = 0!
        Me.RichTextBox.Name = "RichTextBox"
        Me.RichTextBox.RTF = resources.GetString("RichTextBox.RTF")
        Me.RichTextBox.Top = 2.6875!
        Me.RichTextBox.Width = 6.5!
        '
        'txtAddress
        '
        Me.txtAddress.Height = 0.6875!
        Me.txtAddress.Left = 0!
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.Style = "font-size: 12pt; ddo-char-set: 1"
        Me.txtAddress.Text = "txtAddress"
        Me.txtAddress.Top = 1.25!
        Me.txtAddress.Width = 3.4375!
        '
        'txtNow
        '
        Me.txtNow.Height = 0.2!
        Me.txtNow.Left = 0!
        Me.txtNow.Name = "txtNow"
        Me.txtNow.Style = "font-size: 12pt; ddo-char-set: 1"
        Me.txtNow.Text = "txtNow"
        Me.txtNow.Top = 0.875!
        Me.txtNow.Width = 2.375!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
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
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAddress, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

        txtAddress.Text = Fields("FirstName").Value & " " & Fields("LastName").Value & vbCrLf & Fields("Street").Value
        If Not String.IsNullOrEmpty(DataHelper.Nz_string(Fields("Street2").Value)) Then
            txtAddress.Text += vbCrLf & Fields("Street2").Value
        End If
        txtAddress.Text += vbCrLf & Fields("City").Value & ", " & Fields("State").Value & " " & Fields("ZipCode").Value

        txtNow.Text = Now.ToString("MMMM dd, yyyy")

    End Sub
End Class