Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Public Class query_commission_batchpayments
    Inherits ActiveReport3
    Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Orientation = PageOrientation.Landscape

        PageSettings.Margins.Top = 0.25
        PageSettings.Margins.Left = 0.25
        PageSettings.Margins.Right = 0.25
        PageSettings.Margins.Bottom = 0.25

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
	Private Label4 As DataDynamics.ActiveReports.Label
	Private Label5 As DataDynamics.ActiveReports.Label
	Private Line1 As DataDynamics.ActiveReports.Line
	Private Label6 As DataDynamics.ActiveReports.Label
	Private Label14 As DataDynamics.ActiveReports.Label
	Private Label As DataDynamics.ActiveReports.Label
	Private Label3 As DataDynamics.ActiveReports.Label
	Private Label7 As DataDynamics.ActiveReports.Label
	Private CommRecName As DataDynamics.ActiveReports.TextBox
	Private TransferAmount As DataDynamics.ActiveReports.TextBox
	Private Amount As DataDynamics.ActiveReports.TextBox
	Private CheckNumber As DataDynamics.ActiveReports.TextBox
	Private Separator As DataDynamics.ActiveReports.Line
	Private CheckDate As DataDynamics.ActiveReports.TextBox
	Private ACHTries As DataDynamics.ActiveReports.TextBox
	Private CommBatchId As DataDynamics.ActiveReports.TextBox
	Private BatchDate As DataDynamics.ActiveReports.TextBox
	Private ParentCommRecName As DataDynamics.ActiveReports.TextBox
	Private CountCommBatchTransferId As DataDynamics.ActiveReports.TextBox
	Private Label11 As DataDynamics.ActiveReports.Label
	Private SumAmount As DataDynamics.ActiveReports.TextBox
	Private TextBox As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.query_commission_batchpayments.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.sortofPageHeader = CType(Me.Sections("sortofPageHeader"),DataDynamics.ActiveReports.GroupHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.sortofPageFooter = CType(Me.Sections("sortofPageFooter"),DataDynamics.ActiveReports.GroupFooter)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Label16 = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label1 = CType(Me.sortofPageHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label2 = CType(Me.sortofPageHeader.Controls(1),DataDynamics.ActiveReports.Label)
		Me.Label4 = CType(Me.sortofPageHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Label5 = CType(Me.sortofPageHeader.Controls(3),DataDynamics.ActiveReports.Label)
		Me.Line1 = CType(Me.sortofPageHeader.Controls(4),DataDynamics.ActiveReports.Line)
		Me.Label6 = CType(Me.sortofPageHeader.Controls(5),DataDynamics.ActiveReports.Label)
		Me.Label14 = CType(Me.sortofPageHeader.Controls(6),DataDynamics.ActiveReports.Label)
		Me.Label = CType(Me.sortofPageHeader.Controls(7),DataDynamics.ActiveReports.Label)
		Me.Label3 = CType(Me.sortofPageHeader.Controls(8),DataDynamics.ActiveReports.Label)
		Me.Label7 = CType(Me.sortofPageHeader.Controls(9),DataDynamics.ActiveReports.Label)
		Me.CommRecName = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.TransferAmount = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.Amount = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.CheckNumber = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.Separator = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.Line)
		Me.CheckDate = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.ACHTries = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.CommBatchId = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.BatchDate = CType(Me.Detail.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.ParentCommRecName = CType(Me.Detail.Controls(9),DataDynamics.ActiveReports.TextBox)
		Me.CountCommBatchTransferId = CType(Me.ReportFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.Label11 = CType(Me.ReportFooter.Controls(1),DataDynamics.ActiveReports.Label)
		Me.SumAmount = CType(Me.ReportFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.TextBox = CType(Me.ReportFooter.Controls(3),DataDynamics.ActiveReports.TextBox)
	End Sub

#End Region

    Private Sub ReportFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportFooter.Format

    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub
End Class
