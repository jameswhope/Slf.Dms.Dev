Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Public Class report_servicefee_agency_charges
    Inherits ActiveReport3
	Public Sub New()
	MyBase.New()
		InitializeReport()
	End Sub
	#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As DataDynamics.ActiveReports.ReportHeader = Nothing
    Private WithEvents sortofPageHeader As DataDynamics.ActiveReports.GroupHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents sortofPageFooter As DataDynamics.ActiveReports.GroupFooter = Nothing
    Private WithEvents ReportFooter As DataDynamics.ActiveReports.ReportFooter = Nothing
	Private Label16 As DataDynamics.ActiveReports.Label
	Private Label1 As DataDynamics.ActiveReports.Label
	Private Label2 As DataDynamics.ActiveReports.Label
	Private Label3 As DataDynamics.ActiveReports.Label
	Private Label4 As DataDynamics.ActiveReports.Label
	Private Label5 As DataDynamics.ActiveReports.Label
	Private Line1 As DataDynamics.ActiveReports.Line
	Private Label6 As DataDynamics.ActiveReports.Label
	Private Label14 As DataDynamics.ActiveReports.Label
	Private AccountNumber As DataDynamics.ActiveReports.TextBox
	Private HireDate As DataDynamics.ActiveReports.TextBox
	Private CompanyName As DataDynamics.ActiveReports.TextBox
	Private FirstName As DataDynamics.ActiveReports.TextBox
	Private LastName As DataDynamics.ActiveReports.TextBox
	Private Separator As DataDynamics.ActiveReports.Line
	Private FeeCategory As DataDynamics.ActiveReports.TextBox
	Private Amount As DataDynamics.ActiveReports.TextBox
	Private CountRegisterId As DataDynamics.ActiveReports.TextBox
	Private Label11 As DataDynamics.ActiveReports.Label
	Private SumAmount As DataDynamics.ActiveReports.TextBox
	Private TextBox As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.report_servicefee_agency_charges.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.sortofPageHeader = CType(Me.Sections("sortofPageHeader"),DataDynamics.ActiveReports.GroupHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.sortofPageFooter = CType(Me.Sections("sortofPageFooter"),DataDynamics.ActiveReports.GroupFooter)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Label16 = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label1 = CType(Me.sortofPageHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label2 = CType(Me.sortofPageHeader.Controls(1),DataDynamics.ActiveReports.Label)
		Me.Label3 = CType(Me.sortofPageHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Label4 = CType(Me.sortofPageHeader.Controls(3),DataDynamics.ActiveReports.Label)
		Me.Label5 = CType(Me.sortofPageHeader.Controls(4),DataDynamics.ActiveReports.Label)
		Me.Line1 = CType(Me.sortofPageHeader.Controls(5),DataDynamics.ActiveReports.Line)
		Me.Label6 = CType(Me.sortofPageHeader.Controls(6),DataDynamics.ActiveReports.Label)
		Me.Label14 = CType(Me.sortofPageHeader.Controls(7),DataDynamics.ActiveReports.Label)
		Me.AccountNumber = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.HireDate = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.CompanyName = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.FirstName = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.LastName = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.Separator = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.Line)
		Me.FeeCategory = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.Amount = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.CountRegisterId = CType(Me.ReportFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.Label11 = CType(Me.ReportFooter.Controls(1),DataDynamics.ActiveReports.Label)
		Me.SumAmount = CType(Me.ReportFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.TextBox = CType(Me.ReportFooter.Controls(3),DataDynamics.ActiveReports.TextBox)
	End Sub

	#End Region
End Class
