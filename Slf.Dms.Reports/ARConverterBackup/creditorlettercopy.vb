Option Explicit On

Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports Drg.Util.DataAccess

Public Class creditorlettercopy
    Inherits ActiveReport3

    Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Margins.Top = 0.5
        PageSettings.Margins.Left = 0.5
        PageSettings.Margins.Right = 0.5
        PageSettings.Margins.Bottom = 0.5

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
	Private RichTextBox As DataDynamics.ActiveReports.RichTextBox
	Private txtCreditorAddress As DataDynamics.ActiveReports.TextBox
	Private lblRe As DataDynamics.ActiveReports.TextBox
	Private lblAccountNumber As DataDynamics.ActiveReports.TextBox
	Private txtRe As DataDynamics.ActiveReports.TextBox
	Private txtAccountNumber As DataDynamics.ActiveReports.TextBox
	Private lblReferenceNumber As DataDynamics.ActiveReports.TextBox
	Private txtReferenceNumber As DataDynamics.ActiveReports.TextBox
	Private txtAttorneyName As DataDynamics.ActiveReports.TextBox
	Private txtAttorneyState As DataDynamics.ActiveReports.TextBox
	Private txtNow As DataDynamics.ActiveReports.TextBox
	Private Label8 As DataDynamics.ActiveReports.Label
	Private txtBody As DataDynamics.ActiveReports.TextBox
	Private Line As DataDynamics.ActiveReports.Line
	Private RichTextBox3 As DataDynamics.ActiveReports.RichTextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.creditorlettercopy.rpx")
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.RichTextBox = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.RichTextBox)
		Me.txtCreditorAddress = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.lblRe = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.lblAccountNumber = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.txtRe = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.txtAccountNumber = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.lblReferenceNumber = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.txtReferenceNumber = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.txtAttorneyName = CType(Me.Detail.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.txtAttorneyState = CType(Me.Detail.Controls(9),DataDynamics.ActiveReports.TextBox)
		Me.txtNow = CType(Me.Detail.Controls(10),DataDynamics.ActiveReports.TextBox)
		Me.Label8 = CType(Me.Detail.Controls(11),DataDynamics.ActiveReports.Label)
		Me.txtBody = CType(Me.Detail.Controls(12),DataDynamics.ActiveReports.TextBox)
		Me.Line = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.Line)
		Me.RichTextBox3 = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.RichTextBox)
	End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

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
        s += "        Please take notice that under State and/or Federal Fair Debt Collection Practices Laws, and on behalf of our client, demand is made that you immediately cease all attempts to contact our client by letter or by phone, at home or at our client’s place of employment. If you wish to discuss this alleged debt you may do so, once the requested documentation has been delivered, by contacting the undersigned at the above mailing address."
        s += vbCrLf & vbCrLf
        s += "        Be assured that any litigation filed with respect to this alleged debt will be vigorously contested and a counterclaim for any violation of Fair Debt Collection Practices Laws will be filed. No waiver of violation of Fair Debt Collection Practices Acts should be implied from our request for verification. The documentation requested above should be provided to this office and not to our client directly."
        s += vbCrLf & vbCrLf
        s += "        In order to verify the amount owed to you please forward verification of this debt to my mailing address above."
        s += vbCrLf & vbCrLf & vbCrLf
        s += "Very truly yours, "
        s += vbCrLf & vbCrLf & vbCrLf
        s += "The Seideman Law Firm, P.C."
        txtBody.Text = s
        'p1.Text = "        " & p1.Text.TrimStart()
        'p2.Text = "        " & p2.Text.TrimStart()
        'p3.Text = "        " & p3.Text.TrimStart()
        'p4.Text = "        " & p4.Text.TrimStart()
    End Sub
End Class