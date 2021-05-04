Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports Drg.Util.DataAccess

Public Class welcomeletter
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
	Private Picture As DataDynamics.ActiveReports.Picture
	Private txtLetter As DataDynamics.ActiveReports.RichTextBox
	Private txtClientName As DataDynamics.ActiveReports.TextBox
	Private txtAddress As DataDynamics.ActiveReports.TextBox
	Private RichTextBox1 As DataDynamics.ActiveReports.RichTextBox
	Private txtNow As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.welcomeletter.rpx")
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.Picture = CType(Me.PageHeader.Controls(0),DataDynamics.ActiveReports.Picture)
		Me.txtLetter = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.RichTextBox)
		Me.txtClientName = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.txtAddress = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.RichTextBox1 = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.RichTextBox)
		Me.txtNow = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
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