Option Explicit On

Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports System

Public Class checktoprint
    Inherits ActiveReport3

	Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Orientation = PageOrientation.Landscape

        PageSettings.Margins.Top = 0.5
        PageSettings.Margins.Left = 0.5
        PageSettings.Margins.Right = 0.5
        PageSettings.Margins.Bottom = 0.5

    End Sub

	#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As DataDynamics.ActiveReports.ReportHeader = Nothing
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
    Private WithEvents ReportFooter As DataDynamics.ActiveReports.ReportFooter = Nothing
	Private Label As DataDynamics.ActiveReports.Label = Nothing
	Private [Date] As DataDynamics.ActiveReports.TextBox = Nothing
	Private PN As DataDynamics.ActiveReports.TextBox = Nothing
	Private PT As DataDynamics.ActiveReports.TextBox = Nothing
	Private PageNumbers As DataDynamics.ActiveReports.Label = Nothing
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.checktoprint.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Label = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.[Date] = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.PN = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.PT = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.PageNumbers = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.Label)
	End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub

End Class