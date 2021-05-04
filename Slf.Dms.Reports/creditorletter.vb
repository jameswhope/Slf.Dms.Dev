Option Explicit On
Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports

Imports System



Imports Drg.Util.DataAccess

Public Class creditorletter
    Inherits GrapeCity.ActiveReports.SectionReport

    Public Sub New()
        MyBase.New()

        InitializeComponent()

        PageSettings.Margins.Top = 0.5
        PageSettings.Margins.Left = 0.5
        PageSettings.Margins.Right = 0.5
        PageSettings.Margins.Bottom = 0.5

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As GrapeCity.ActiveReports.SectionReportModel.PageHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents PageFooter As GrapeCity.ActiveReports.SectionReportModel.PageFooter = Nothing
    Private RichTextBox As GrapeCity.ActiveReports.SectionReportModel.RichTextBox
    Private txtCreditorAddress As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private lblRe As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private lblAccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtRe As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtAccountNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private lblReferenceNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtReferenceNumber As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtAttorneyName As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtAttorneyState As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtNow As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtBody As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Line As GrapeCity.ActiveReports.SectionReportModel.Line
    Private RichTextBox3 As GrapeCity.ActiveReports.SectionReportModel.RichTextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(creditorletter))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.PageHeader = New GrapeCity.ActiveReports.SectionReportModel.PageHeader()
        Me.PageFooter = New GrapeCity.ActiveReports.SectionReportModel.PageFooter()
        Me.RichTextBox = New GrapeCity.ActiveReports.SectionReportModel.RichTextBox()
        Me.txtCreditorAddress = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.lblRe = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.lblAccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtRe = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtAccountNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.lblReferenceNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtReferenceNumber = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtAttorneyName = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtAttorneyState = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtNow = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtBody = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.Line = New GrapeCity.ActiveReports.SectionReportModel.Line()
        Me.RichTextBox3 = New GrapeCity.ActiveReports.SectionReportModel.RichTextBox()
        CType(Me.txtCreditorAddress, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.lblRe, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.lblAccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtRe, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAccountNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.lblReferenceNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtReferenceNumber, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAttorneyName, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtAttorneyState, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtBody, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.RichTextBox, Me.txtCreditorAddress, Me.lblRe, Me.lblAccountNumber, Me.txtRe, Me.txtAccountNumber, Me.lblReferenceNumber, Me.txtReferenceNumber, Me.txtAttorneyName, Me.txtAttorneyState, Me.txtNow, Me.txtBody})
        Me.Detail.Height = 4.478472!
        Me.Detail.Name = "Detail"
        Me.Detail.NewPage = GrapeCity.ActiveReports.SectionReportModel.NewPage.BeforeAfter
        '
        'PageHeader
        '
        Me.PageHeader.Height = 0!
        Me.PageHeader.Name = "PageHeader"
        '
        'PageFooter
        '
        Me.PageFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Line, Me.RichTextBox3})
        Me.PageFooter.Height = 0.6756945!
        Me.PageFooter.Name = "PageFooter"
        '
        'RichTextBox
        '
        Me.RichTextBox.AutoReplaceFields = true
        Me.RichTextBox.Font = New System.Drawing.Font("Arial", 10!)
        Me.RichTextBox.Height = 1.375!
        Me.RichTextBox.Left = 0.375!
        Me.RichTextBox.Name = "RichTextBox"
        Me.RichTextBox.RTF = resources.GetString("RichTextBox.RTF")
        Me.RichTextBox.Top = 0.125!
        Me.RichTextBox.Width = 3.25!
        '
        'txtCreditorAddress
        '
        Me.txtCreditorAddress.Height = 0.6875!
        Me.txtCreditorAddress.Left = 0.375!
        Me.txtCreditorAddress.Name = "txtCreditorAddress"
        Me.txtCreditorAddress.Text = "txtCreditorAddress"
        Me.txtCreditorAddress.Top = 2.125!
        Me.txtCreditorAddress.Width = 6.875!
        '
        'lblRe
        '
        Me.lblRe.Height = 0.2!
        Me.lblRe.Left = 0.375!
        Me.lblRe.Name = "lblRe"
        Me.lblRe.Text = "Re:"
        Me.lblRe.Top = 3.0625!
        Me.lblRe.Width = 1.5!
        '
        'lblAccountNumber
        '
        Me.lblAccountNumber.Height = 0.2!
        Me.lblAccountNumber.Left = 0.375!
        Me.lblAccountNumber.Name = "lblAccountNumber"
        Me.lblAccountNumber.Text = "Account Number:"
        Me.lblAccountNumber.Top = 3.25!
        Me.lblAccountNumber.Width = 1.5!
        '
        'txtRe
        '
        Me.txtRe.DataField = "ClientName"
        Me.txtRe.Height = 0.2!
        Me.txtRe.Left = 1.875!
        Me.txtRe.Name = "txtRe"
        Me.txtRe.Text = "txtRe"
        Me.txtRe.Top = 3.0625!
        Me.txtRe.Width = 5.375!
        '
        'txtAccountNumber
        '
        Me.txtAccountNumber.DataField = "AccountNumber"
        Me.txtAccountNumber.Height = 0.2!
        Me.txtAccountNumber.Left = 1.875!
        Me.txtAccountNumber.Name = "txtAccountNumber"
        Me.txtAccountNumber.Text = "txtAccountNumber"
        Me.txtAccountNumber.Top = 3.25!
        Me.txtAccountNumber.Width = 5.375!
        '
        'lblReferenceNumber
        '
        Me.lblReferenceNumber.Height = 0.2!
        Me.lblReferenceNumber.Left = 0.375!
        Me.lblReferenceNumber.Name = "lblReferenceNumber"
        Me.lblReferenceNumber.Text = "Reference Number:"
        Me.lblReferenceNumber.Top = 3.45!
        Me.lblReferenceNumber.Width = 1.5!
        '
        'txtReferenceNumber
        '
        Me.txtReferenceNumber.DataField = "ReferenceNumber"
        Me.txtReferenceNumber.Height = 0.2!
        Me.txtReferenceNumber.Left = 1.875!
        Me.txtReferenceNumber.Name = "txtReferenceNumber"
        Me.txtReferenceNumber.Text = "txtReferenceNumber"
        Me.txtReferenceNumber.Top = 3.45!
        Me.txtReferenceNumber.Width = 5.375!
        '
        'txtAttorneyName
        '
        Me.txtAttorneyName.Height = 0.2!
        Me.txtAttorneyName.Left = 3.9375!
        Me.txtAttorneyName.Name = "txtAttorneyName"
        Me.txtAttorneyName.Style = "font-size: 8pt; text-align: right; ddo-char-set: 1"
        Me.txtAttorneyName.Text = "txtAttorneyName"
        Me.txtAttorneyName.Top = 0.5625!
        Me.txtAttorneyName.Width = 3.25!
        '
        'txtAttorneyState
        '
        Me.txtAttorneyState.Height = 0.2!
        Me.txtAttorneyState.Left = 3.9375!
        Me.txtAttorneyState.Name = "txtAttorneyState"
        Me.txtAttorneyState.Style = "font-size: 8pt; text-align: right; ddo-char-set: 1"
        Me.txtAttorneyState.Text = "txtAttorneyState"
        Me.txtAttorneyState.Top = 0.71875!
        Me.txtAttorneyState.Width = 3.25!
        '
        'txtNow
        '
        Me.txtNow.Height = 0.2!
        Me.txtNow.Left = 0.375!
        Me.txtNow.Name = "txtNow"
        Me.txtNow.Text = "txtNow"
        Me.txtNow.Top = 1.6875!
        Me.txtNow.Width = 2.3125!
        '
        'txtBody
        '
        Me.txtBody.Height = 0.2!
        Me.txtBody.Left = 0.375!
        Me.txtBody.Name = "txtBody"
        Me.txtBody.Style = "text-align: justify"
        Me.txtBody.Top = 4!
        Me.txtBody.Width = 6.875!
        '
        'Line
        '
        Me.Line.Height = 0!
        Me.Line.Left = 0.375!
        Me.Line.LineColor = System.Drawing.Color.FromArgb(CType(CType(128, Byte), Integer), CType(CType(128, Byte), Integer), CType(CType(128, Byte), Integer))
        Me.Line.LineWeight = 1!
        Me.Line.Name = "Line"
        Me.Line.Top = 0!
        Me.Line.Width = 2!
        Me.Line.X1 = 2.375!
        Me.Line.X2 = 0.375!
        Me.Line.Y1 = 0!
        Me.Line.Y2 = 0!
        '
        'RichTextBox3
        '
        Me.RichTextBox3.AutoReplaceFields = true
        Me.RichTextBox3.Font = New System.Drawing.Font("Arial", 10!)
        Me.RichTextBox3.Height = 0.5!
        Me.RichTextBox3.Left = 0.375!
        Me.RichTextBox3.Name = "RichTextBox3"
        Me.RichTextBox3.RTF = resources.GetString("RichTextBox3.RTF")
        Me.RichTextBox3.Top = 0.0625!
        Me.RichTextBox3.Width = 6.875!
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
        CType(Me.txtCreditorAddress, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.lblRe, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.lblAccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtRe, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAccountNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.lblReferenceNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtReferenceNumber, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAttorneyName, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtAttorneyState, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtNow, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtBody, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        txtRe.Text = Fields("ClientName").Value
        If Not IsDBNull(Fields("ClientName2").Value) Then
            txtRe.Text += ", " & Fields("ClientName2").Value
        End If
        txtCreditorAddress.Text = Fields("CreditorName").Value & vbCrLf & Fields("CreditorStreet").Value
        If Not String.IsNullOrEmpty(DataHelper.Nz_string(Fields("CreditorStreet2").Value)) Then
            txtCreditorAddress.Text += vbCrLf & Fields("CreditorStreet2").Value
        End If
        txtCreditorAddress.Text += vbCrLf & Fields("CreditorCity").Value & ", " & Fields("CreditorState").Value & " " & Fields("CreditorZipCode").Value

        txtAttorneyName.Text = Fields("AttorneyName").Value & ", Of Counsel"
        txtAttorneyState.Text = "Licensed in " & Fields("PrimaryPersonState").Value

        txtNow.Text = Now.ToString("MMMM dd, yyyy")

        If Fields("AttorneyName").Value Is DBNull.Value Then
            txtAttorneyName.Visible = False
            txtAttorneyState.Visible = False
        Else
            txtAttorneyName.Visible = True
            txtAttorneyState.Visible = True
        End If

        If Fields("ReferenceNumber").Value Is DBNull.Value Then
            lblReferenceNumber.Visible = False
        Else
            lblReferenceNumber.Visible = True
        End If

        Dim s As String = "To Whom It May Concern:"
        s += vbCrLf & vbCrLf
        s += "        This law firm represents the above referenced consumer and alleged debt.  Based on the information provided, our client disputes the alleged claim and requests verification of the alleged debt. Verification should include all documents evidencing the debt including, but not limited to: any document signed by our client with respect to the debt such as contracts, notes, leases, or other written agreements, each invoice or transaction record and any other loan documents; ledgers; or, other documents reflecting all consideration, payments, offsets and credits.1 Further, request is made for all documents that will demonstrate when this debt was first due or that it is not barred by the statute of limitations."
        s += vbCrLf & vbCrLf
        s += "        Please take notice that under State and/or Federal Fair Debt Collection Practices Laws, and on behalf of our client, demand is made that you immediately cease all attempts to contact our client by letter or by phone, at home or at our client�s place of employment. If you wish to discuss this alleged debt you may do so, once the requested documentation has been delivered, by contacting the undersigned at the above mailing address."
        s += vbCrLf & vbCrLf
        s += "        Be assured that any litigation filed with respect to this alleged debt will be vigorously contested and a counterclaim for any violation of Fair Debt Collection Practices Laws will be filed. No waiver of violation of Fair Debt Collection Practices Acts should be implied from our request for verification. The documentation requested above should be provided to this office and not to our client directly."
        s += vbCrLf & vbCrLf
        s += "        In order to verify the amount owed to you please forward verification of this debt to my mailing address above."
        s += vbCrLf & vbCrLf & vbCrLf
        s += "Very truly yours, "
        s += vbCrLf & vbCrLf & vbCrLf
        s += "The Seideman Law Firm, P.C."
        txtBody.Text = s
    End Sub
End Class