Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Imports Drg.Util.DataAccess

Public Class welcomeletter
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
    Private Picture As GrapeCity.ActiveReports.SectionReportModel.Picture
    Private txtLetter As GrapeCity.ActiveReports.SectionReportModel.RichTextBox
    Private txtClientName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtAddress As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private RichTextBox1 As GrapeCity.ActiveReports.SectionReportModel.RichTextBox
    Private txtNow As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(welcomeletter))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.Picture = New GrapeCity.ActiveReports.SectionReportModel.Picture()
        Me.txtLetter = New GrapeCity.ActiveReports.SectionReportModel.RichTextBox()
        Me.txtClientName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtAddress = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.RichTextBox1 = New GrapeCity.ActiveReports.SectionReportModel.RichTextBox()
        Me.txtNow = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtClientName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAddress, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.txtLetter, Me.txtClientName, Me.txtAddress, Me.RichTextBox1, Me.txtNow})
        Me.Detail.Height = 8!
        Me.Detail.Name = "Detail"
        '
        'PageHeader
        '
        Me.PageHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Picture})
        Me.PageHeader.Height = 1.0625!
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
        Me.Picture.Left = 0!
        Me.Picture.LineColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Picture.Name = "Picture"
        Me.Picture.SizeMode = GrapeCity.ActiveReports.SectionReportModel.SizeModes.Zoom
        Me.Picture.Top = 0!
        Me.Picture.Width = 3.125!
        '
        'txtLetter
        '
        Me.txtLetter.AutoReplaceFields = true
        Me.txtLetter.Font = New System.Drawing.Font("Arial", 10!)
        Me.txtLetter.Height = 5.375!
        Me.txtLetter.Left = 0!
        Me.txtLetter.Name = "txtLetter"
        Me.txtLetter.RTF = resources.GetString("txtLetter.RTF")
        Me.txtLetter.Top = 2.625!
        Me.txtLetter.Width = 7!
        '
        'txtClientName
        '
        Me.txtClientName.DataField = "ClientName"
        Me.txtClientName.Height = 0.25!
        Me.txtClientName.Left = 0!
        Me.txtClientName.Name = "txtClientName"
        Me.txtClientName.Style = "font-size: 11.25pt; font-weight: normal"
        Me.txtClientName.Text = "txtClientName"
        Me.txtClientName.Top = 2.375!
        Me.txtClientName.Width = 4.5!
        '
        'txtAddress
        '
        Me.txtAddress.Height = 0.6875!
        Me.txtAddress.Left = 0!
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.Style = "font-size: 11pt; ddo-char-set: 1"
        Me.txtAddress.Text = "txtAddress"
        Me.txtAddress.Top = 1.1875!
        Me.txtAddress.Width = 3.5625!
        '
        'RichTextBox1
        '
        Me.RichTextBox1.AutoReplaceFields = true
        Me.RichTextBox1.Border.BottomStyle = GrapeCity.ActiveReports.BorderLineStyle.ExtraThickSolid
        Me.RichTextBox1.Border.LeftStyle = GrapeCity.ActiveReports.BorderLineStyle.ExtraThickSolid
        Me.RichTextBox1.Border.RightStyle = GrapeCity.ActiveReports.BorderLineStyle.ExtraThickSolid
        Me.RichTextBox1.Border.TopStyle = GrapeCity.ActiveReports.BorderLineStyle.ExtraThickSolid
        Me.RichTextBox1.Font = New System.Drawing.Font("Arial", 10!)
        Me.RichTextBox1.Height = 1.0625!
        Me.RichTextBox1.Left = 3.875!
        Me.RichTextBox1.Name = "RichTextBox1"
        Me.RichTextBox1.RTF = resources.GetString("RichTextBox1.RTF")
        Me.RichTextBox1.Top = 0.375!
        Me.RichTextBox1.Width = 3.125!
        '
        'txtNow
        '
        Me.txtNow.Height = 0.2!
        Me.txtNow.Left = 0!
        Me.txtNow.Name = "txtNow"
        Me.txtNow.Text = "txtNow"
        Me.txtNow.Top = 0.625!
        Me.txtNow.Width = 3.5625!
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
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtClientName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAddress, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        txtClientName.Text = "Dear " & Fields("ClientName").Value & ","


        txtAddress.Text = Fields("FirstName").Value & " " & Fields("LastName").Value & vbCrLf & Fields("Street").Value
        If Not String.IsNullOrEmpty(DataHelper.Nz_string(Fields("Street2").Value)) Then
            txtAddress.Text += vbCrLf & Fields("Street2").Value
        End If
        txtAddress.Text += vbCrLf & Fields("City").Value & ", " & Fields("State").Value & " " & Fields("ZipCode").Value

        txtNow.Text = Now.ToString("MMMM dd, yyyy")

        txtLetter.RTF = txtLetter.RTF.Replace("#####", Fields("AccountNumber").Value)

    End Sub
End Class