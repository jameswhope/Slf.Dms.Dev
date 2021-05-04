Option Explicit On

Imports Drg.Util.DataAccess

Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports System
Imports System.Drawing
Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.SessionState

Imports Drg.Util.Helpers

Public Class query_servicefee_remainingreceivables
    Inherits ActiveReport3

    Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Orientation = PageOrientation.Landscape

        PageSettings.Margins.Top = 0.1
        PageSettings.Margins.Left = 0.1
        PageSettings.Margins.Right = 0.1
        PageSettings.Margins.Bottom = 0.1

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As DataDynamics.ActiveReports.ReportHeader = Nothing
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
    Private WithEvents ReportFooter As DataDynamics.ActiveReports.ReportFooter = Nothing
	Private Label As DataDynamics.ActiveReports.Label
	Private Picture As DataDynamics.ActiveReports.Picture
	Private Label15 As DataDynamics.ActiveReports.Label
	Private Label16 As DataDynamics.ActiveReports.Label
	Private CompanyName As DataDynamics.ActiveReports.Label
	Private Period As DataDynamics.ActiveReports.Label
	Private Line1 As DataDynamics.ActiveReports.Line
	Private Label1 As DataDynamics.ActiveReports.Label
	Private Label2 As DataDynamics.ActiveReports.Label
	Private Label4 As DataDynamics.ActiveReports.Label
	Private Label5 As DataDynamics.ActiveReports.Label
	Private Label6 As DataDynamics.ActiveReports.Label
	Private Label7 As DataDynamics.ActiveReports.Label
	Private Label8 As DataDynamics.ActiveReports.Label
	Private Label9 As DataDynamics.ActiveReports.Label
	Private Label10 As DataDynamics.ActiveReports.Label
	Private Label12 As DataDynamics.ActiveReports.Label
	Private Label13 As DataDynamics.ActiveReports.Label
	Private Separator As DataDynamics.ActiveReports.Line
	Private AccountNumber As DataDynamics.ActiveReports.TextBox
	Private HireDate As DataDynamics.ActiveReports.TextBox
	Private FirstName As DataDynamics.ActiveReports.TextBox
	Private LastName As DataDynamics.ActiveReports.TextBox
	Private FeeCategory As DataDynamics.ActiveReports.TextBox
	Private OriginalBalance As DataDynamics.ActiveReports.TextBox
	Private TotalPayments As DataDynamics.ActiveReports.TextBox
	Private RemainingBalance As DataDynamics.ActiveReports.TextBox
	Private LastDepositDate As DataDynamics.ActiveReports.TextBox
	Private RemainingReceivables As DataDynamics.ActiveReports.TextBox
	Private Rate As DataDynamics.ActiveReports.TextBox
	Private [Date] As DataDynamics.ActiveReports.TextBox
	Private PN As DataDynamics.ActiveReports.TextBox
	Private PT As DataDynamics.ActiveReports.TextBox
	Private PageNumbers As DataDynamics.ActiveReports.Label
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.query_servicefee_remainingreceivables.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Label = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Picture = CType(Me.ReportHeader.Controls(1),DataDynamics.ActiveReports.Picture)
		Me.Label15 = CType(Me.ReportHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Label16 = CType(Me.ReportHeader.Controls(3),DataDynamics.ActiveReports.Label)
		Me.CompanyName = CType(Me.ReportHeader.Controls(4),DataDynamics.ActiveReports.Label)
		Me.Period = CType(Me.ReportHeader.Controls(5),DataDynamics.ActiveReports.Label)
		Me.Line1 = CType(Me.PageHeader.Controls(0),DataDynamics.ActiveReports.Line)
		Me.Label1 = CType(Me.PageHeader.Controls(1),DataDynamics.ActiveReports.Label)
		Me.Label2 = CType(Me.PageHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Label4 = CType(Me.PageHeader.Controls(3),DataDynamics.ActiveReports.Label)
		Me.Label5 = CType(Me.PageHeader.Controls(4),DataDynamics.ActiveReports.Label)
		Me.Label6 = CType(Me.PageHeader.Controls(5),DataDynamics.ActiveReports.Label)
		Me.Label7 = CType(Me.PageHeader.Controls(6),DataDynamics.ActiveReports.Label)
		Me.Label8 = CType(Me.PageHeader.Controls(7),DataDynamics.ActiveReports.Label)
		Me.Label9 = CType(Me.PageHeader.Controls(8),DataDynamics.ActiveReports.Label)
		Me.Label10 = CType(Me.PageHeader.Controls(9),DataDynamics.ActiveReports.Label)
		Me.Label12 = CType(Me.PageHeader.Controls(10),DataDynamics.ActiveReports.Label)
		Me.Label13 = CType(Me.PageHeader.Controls(11),DataDynamics.ActiveReports.Label)
		Me.Separator = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.Line)
		Me.AccountNumber = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.HireDate = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.FirstName = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.LastName = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.FeeCategory = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.OriginalBalance = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.TotalPayments = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.RemainingBalance = CType(Me.Detail.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.LastDepositDate = CType(Me.Detail.Controls(9),DataDynamics.ActiveReports.TextBox)
		Me.RemainingReceivables = CType(Me.Detail.Controls(10),DataDynamics.ActiveReports.TextBox)
		Me.Rate = CType(Me.Detail.Controls(11),DataDynamics.ActiveReports.TextBox)
		Me.[Date] = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.PN = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.PT = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.PageNumbers = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.Label)
	End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub

    Private Sub ReportFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportFooter.Format

    End Sub
End Class