Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Public Class report_clients_depositdaysago
    Inherits ActiveReport3
    Public Sub New()
        MyBase.New()
        InitializeReport()
    End Sub
#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As DataDynamics.ActiveReports.ReportHeader = Nothing
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
    Private WithEvents ReportFooter As DataDynamics.ActiveReports.ReportFooter = Nothing
	Private Label16 As DataDynamics.ActiveReports.Label
	Private Label1 As DataDynamics.ActiveReports.Label
	Private Label4 As DataDynamics.ActiveReports.Label
	Private Label5 As DataDynamics.ActiveReports.Label
	Private Line1 As DataDynamics.ActiveReports.Line
	Private Label6 As DataDynamics.ActiveReports.Label
	Private Label7 As DataDynamics.ActiveReports.Label
	Private Label8 As DataDynamics.ActiveReports.Label
	Private Label9 As DataDynamics.ActiveReports.Label
	Private Label10 As DataDynamics.ActiveReports.Label
	Private Label12 As DataDynamics.ActiveReports.Label
	Private Label13 As DataDynamics.ActiveReports.Label
	Private Label14 As DataDynamics.ActiveReports.Label
	Private Label As DataDynamics.ActiveReports.Label
	Private Label2 As DataDynamics.ActiveReports.Label
	Private AccountNumber As DataDynamics.ActiveReports.TextBox
	Private ClientName As DataDynamics.ActiveReports.TextBox
	Private ClientStatusName As DataDynamics.ActiveReports.TextBox
	Private Separator As DataDynamics.ActiveReports.Line
	Private DepositMethod As DataDynamics.ActiveReports.TextBox
	Private DepositAmount As DataDynamics.ActiveReports.TextBox
	Private DaysAgo As DataDynamics.ActiveReports.TextBox
	Private TransactionDate As DataDynamics.ActiveReports.TextBox
	Private DepositDay As DataDynamics.ActiveReports.TextBox
	Private txtAmount As DataDynamics.ActiveReports.TextBox
	Private Void As DataDynamics.ActiveReports.TextBox
	Private ACH As DataDynamics.ActiveReports.TextBox
	Private Bounce As DataDynamics.ActiveReports.TextBox
	Private AgencyName As DataDynamics.ActiveReports.TextBox
	Private [Date] As DataDynamics.ActiveReports.TextBox
	Private PN As DataDynamics.ActiveReports.TextBox
	Private PT As DataDynamics.ActiveReports.TextBox
	Private PageNumbers As DataDynamics.ActiveReports.Label
	Private TextBox8 As DataDynamics.ActiveReports.TextBox
	Private TextBox10 As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.report_clients_depositdaysago.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Label16 = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label1 = CType(Me.PageHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label4 = CType(Me.PageHeader.Controls(1),DataDynamics.ActiveReports.Label)
		Me.Label5 = CType(Me.PageHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Line1 = CType(Me.PageHeader.Controls(3),DataDynamics.ActiveReports.Line)
		Me.Label6 = CType(Me.PageHeader.Controls(4),DataDynamics.ActiveReports.Label)
		Me.Label7 = CType(Me.PageHeader.Controls(5),DataDynamics.ActiveReports.Label)
		Me.Label8 = CType(Me.PageHeader.Controls(6),DataDynamics.ActiveReports.Label)
		Me.Label9 = CType(Me.PageHeader.Controls(7),DataDynamics.ActiveReports.Label)
		Me.Label10 = CType(Me.PageHeader.Controls(8),DataDynamics.ActiveReports.Label)
		Me.Label12 = CType(Me.PageHeader.Controls(9),DataDynamics.ActiveReports.Label)
		Me.Label13 = CType(Me.PageHeader.Controls(10),DataDynamics.ActiveReports.Label)
		Me.Label14 = CType(Me.PageHeader.Controls(11),DataDynamics.ActiveReports.Label)
		Me.Label = CType(Me.PageHeader.Controls(12),DataDynamics.ActiveReports.Label)
		Me.Label2 = CType(Me.PageHeader.Controls(13),DataDynamics.ActiveReports.Label)
		Me.AccountNumber = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.ClientName = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.ClientStatusName = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.Separator = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.Line)
		Me.DepositMethod = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.DepositAmount = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.DaysAgo = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.TransactionDate = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.DepositDay = CType(Me.Detail.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.txtAmount = CType(Me.Detail.Controls(9),DataDynamics.ActiveReports.TextBox)
		Me.Void = CType(Me.Detail.Controls(10),DataDynamics.ActiveReports.TextBox)
		Me.ACH = CType(Me.Detail.Controls(11),DataDynamics.ActiveReports.TextBox)
		Me.Bounce = CType(Me.Detail.Controls(12),DataDynamics.ActiveReports.TextBox)
		Me.AgencyName = CType(Me.Detail.Controls(13),DataDynamics.ActiveReports.TextBox)
		Me.[Date] = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.PN = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.PT = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.PageNumbers = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.Label)
		Me.TextBox8 = CType(Me.ReportFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.TextBox10 = CType(Me.ReportFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
	End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        If Not IsDBNull(Fields("Void").Value) Then
            Void.Text = "X"
        End If
        If Not IsDBNull(Fields("Bounce").Value) Then
            Bounce.Text = "X"
        End If
        If Not IsDBNull(Fields("AchYear").Value) Then
            ACH.Text = "X"
        End If
        If IsDBNull(Fields("DepositMethod").Value) Then
            DepositMethod.Text = "Check"
        End If
    End Sub

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

    End Sub

    Private Sub PageHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageHeader.Format

    End Sub
End Class
