Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports Drg.Util.DataAccess

Public Class welcomecoverletter
    Inherits ActiveReport3

    Public Sub New()
        MyBase.New()

        InitializeReport()

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
	Private Picture As DataDynamics.ActiveReports.Picture
	Private RichTextBox As DataDynamics.ActiveReports.RichTextBox
	Private txtAddress As DataDynamics.ActiveReports.TextBox
	Private txtNow As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.welcomecoverletter.rpx")
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.Picture = CType(Me.PageHeader.Controls(0),DataDynamics.ActiveReports.Picture)
		Me.RichTextBox = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.RichTextBox)
		Me.txtAddress = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.txtNow = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
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