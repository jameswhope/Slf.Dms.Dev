Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports Drg.Util.DataAccess

Public Class welcomecallletter
    Inherits ActiveReport3

    Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Margins.Top = 0.75
        PageSettings.Margins.Left = 0.75
        PageSettings.Margins.Right = 0.75
        PageSettings.Margins.Bottom = 0.75

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
	Private Picture1 As DataDynamics.ActiveReports.Picture
	Private RichTextBox As DataDynamics.ActiveReports.RichTextBox
	Private txtAccountNumber As DataDynamics.ActiveReports.TextBox
	Private txtFirstName As DataDynamics.ActiveReports.TextBox
	Private txtAddress As DataDynamics.ActiveReports.TextBox
	Private txtNow As DataDynamics.ActiveReports.TextBox
	Private TextBox As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.welcomecallletter.rpx")
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.Picture1 = CType(Me.PageHeader.Controls(0),DataDynamics.ActiveReports.Picture)
		Me.RichTextBox = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.RichTextBox)
		Me.txtAccountNumber = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.txtFirstName = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.txtAddress = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.txtNow = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.TextBox = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
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