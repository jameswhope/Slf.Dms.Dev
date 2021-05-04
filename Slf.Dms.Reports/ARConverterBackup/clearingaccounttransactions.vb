Option Explicit On

Imports Drg.Util.DataAccess

Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports System
Imports System.Drawing

Public Class clearingaccounttransactions
    Inherits ActiveReport3

    Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Orientation = PageOrientation.Portrait

        PageSettings.Margins.Top = 1
        PageSettings.Margins.Left = 1
        PageSettings.Margins.Right = 1
        PageSettings.Margins.Bottom = 1

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
	Private Label2 As DataDynamics.ActiveReports.Label
	Private CompanyName As DataDynamics.ActiveReports.Label
	Private Period As DataDynamics.ActiveReports.Label
	Private Label1 As DataDynamics.ActiveReports.Label
	Private Label4 As DataDynamics.ActiveReports.Label
	Private Label5 As DataDynamics.ActiveReports.Label
	Private Line1 As DataDynamics.ActiveReports.Line
	Private Label6 As DataDynamics.ActiveReports.Label
	Private Label14 As DataDynamics.ActiveReports.Label
	Private AccountNumber As DataDynamics.ActiveReports.TextBox
	Private FirstName As DataDynamics.ActiveReports.TextBox
	Private LastName As DataDynamics.ActiveReports.TextBox
	Private Separator As DataDynamics.ActiveReports.Line
	Private FeeCategory As DataDynamics.ActiveReports.TextBox
	Private Amount As DataDynamics.ActiveReports.TextBox
	Private PageNumbers As DataDynamics.ActiveReports.Label
	Private PT As DataDynamics.ActiveReports.TextBox
	Private PN As DataDynamics.ActiveReports.TextBox
	Private [Date] As DataDynamics.ActiveReports.TextBox
	Private CountRegisterId As DataDynamics.ActiveReports.TextBox
	Private Label11 As DataDynamics.ActiveReports.Label
	Private SumAmount As DataDynamics.ActiveReports.TextBox
	Private TextBox As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.clearingaccounttransactions.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Label = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Picture = CType(Me.ReportHeader.Controls(1),DataDynamics.ActiveReports.Picture)
		Me.Label15 = CType(Me.ReportHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Label2 = CType(Me.ReportHeader.Controls(3),DataDynamics.ActiveReports.Label)
		Me.CompanyName = CType(Me.ReportHeader.Controls(4),DataDynamics.ActiveReports.Label)
		Me.Period = CType(Me.ReportHeader.Controls(5),DataDynamics.ActiveReports.Label)
		Me.Label1 = CType(Me.PageHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label4 = CType(Me.PageHeader.Controls(1),DataDynamics.ActiveReports.Label)
		Me.Label5 = CType(Me.PageHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Line1 = CType(Me.PageHeader.Controls(3),DataDynamics.ActiveReports.Line)
		Me.Label6 = CType(Me.PageHeader.Controls(4),DataDynamics.ActiveReports.Label)
		Me.Label14 = CType(Me.PageHeader.Controls(5),DataDynamics.ActiveReports.Label)
		Me.AccountNumber = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.FirstName = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.LastName = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.Separator = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.Line)
		Me.FeeCategory = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.Amount = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.PageNumbers = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.Label)
		Me.PT = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.PN = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.[Date] = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.CountRegisterId = CType(Me.ReportFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.Label11 = CType(Me.ReportFooter.Controls(1),DataDynamics.ActiveReports.Label)
		Me.SumAmount = CType(Me.ReportFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.TextBox = CType(Me.ReportFooter.Controls(3),DataDynamics.ActiveReports.TextBox)
	End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

    End Sub


    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

    End Sub
End Class