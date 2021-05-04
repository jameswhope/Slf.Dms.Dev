Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Public Class report_servicefee_all_payments
    Inherits ActiveReport3
	Public Sub New()
	MyBase.New()
		InitializeReport()
	End Sub
#Region "ActiveReports Designer generated code"
    Public ds As DataDynamics.ActiveReports.DataSources.SqlDBDataSource
    Private WithEvents ReportHeader As DataDynamics.ActiveReports.ReportHeader = Nothing
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents grpCompanyNameHeader As DataDynamics.ActiveReports.GroupHeader = Nothing
    Private WithEvents sortofPageHeader As DataDynamics.ActiveReports.GroupHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents sortofPageFooter As DataDynamics.ActiveReports.GroupFooter = Nothing
    Private WithEvents grpCompanyNameFooter As DataDynamics.ActiveReports.GroupFooter = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
    Private WithEvents ReportFooter As DataDynamics.ActiveReports.ReportFooter = Nothing
    Private Label16 As DataDynamics.ActiveReports.Label
    Private TextBox1 As DataDynamics.ActiveReports.TextBox
    Private Label1 As DataDynamics.ActiveReports.Label
    Private Label2 As DataDynamics.ActiveReports.Label
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
    Private CommRecipName As DataDynamics.ActiveReports.TextBox
    Private AccountNumber As DataDynamics.ActiveReports.TextBox
    Private HireDate As DataDynamics.ActiveReports.TextBox
    Private FirstName As DataDynamics.ActiveReports.TextBox
    Private LastName As DataDynamics.ActiveReports.TextBox
    Private Separator As DataDynamics.ActiveReports.Line
    Private FeeCategory As DataDynamics.ActiveReports.TextBox
    Private OriginalBalance As DataDynamics.ActiveReports.TextBox
    Private BeginningBalance As DataDynamics.ActiveReports.TextBox
    Private PaymentAmount As DataDynamics.ActiveReports.TextBox
    Private SettlementNumber As DataDynamics.ActiveReports.TextBox
    Private EndingBalance As DataDynamics.ActiveReports.TextBox
    Private Rate As DataDynamics.ActiveReports.TextBox
    Private Amount As DataDynamics.ActiveReports.TextBox
    Private TextBox5 As DataDynamics.ActiveReports.TextBox
    Private Label3 As DataDynamics.ActiveReports.Label
    Private TextBox6 As DataDynamics.ActiveReports.TextBox
    Private TextBox7 As DataDynamics.ActiveReports.TextBox
    Private TextBox2 As DataDynamics.ActiveReports.TextBox
    Private Label As DataDynamics.ActiveReports.Label
    Private TextBox3 As DataDynamics.ActiveReports.TextBox
    Private TextBox4 As DataDynamics.ActiveReports.TextBox
    Private [Date] As DataDynamics.ActiveReports.TextBox
    Private PN As DataDynamics.ActiveReports.TextBox
    Private PT As DataDynamics.ActiveReports.TextBox
    Private PageNumbers As DataDynamics.ActiveReports.Label
    Private CountCommPayId As DataDynamics.ActiveReports.TextBox
    Private Label11 As DataDynamics.ActiveReports.Label
    Private SumAmount As DataDynamics.ActiveReports.TextBox
    Private TextBox As DataDynamics.ActiveReports.TextBox
    Public Sub InitializeReport()
        Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.report_servicefee_all_payments.rpx")
        Me.ds = (DirectCast((Me.DataSource), DataDynamics.ActiveReports.DataSources.SqlDBDataSource))

        Me.ReportHeader = CType(Me.Sections("ReportHeader"), DataDynamics.ActiveReports.ReportHeader)
        Me.PageHeader = CType(Me.Sections("PageHeader"), DataDynamics.ActiveReports.PageHeader)
        Me.grpCompanyNameHeader = CType(Me.Sections("grpCompanyNameHeader"), DataDynamics.ActiveReports.GroupHeader)
        Me.sortofPageHeader = CType(Me.Sections("sortofPageHeader"), DataDynamics.ActiveReports.GroupHeader)
        Me.Detail = CType(Me.Sections("Detail"), DataDynamics.ActiveReports.Detail)
        Me.sortofPageFooter = CType(Me.Sections("sortofPageFooter"), DataDynamics.ActiveReports.GroupFooter)
        Me.grpCompanyNameFooter = CType(Me.Sections("grpCompanyNameFooter"), DataDynamics.ActiveReports.GroupFooter)
        Me.PageFooter = CType(Me.Sections("PageFooter"), DataDynamics.ActiveReports.PageFooter)
        Me.ReportFooter = CType(Me.Sections("ReportFooter"), DataDynamics.ActiveReports.ReportFooter)
        Me.Label16 = CType(Me.ReportHeader.Controls(0), DataDynamics.ActiveReports.Label)
        Me.TextBox1 = CType(Me.grpCompanyNameHeader.Controls(0), DataDynamics.ActiveReports.TextBox)
        Me.Label1 = CType(Me.sortofPageHeader.Controls(0), DataDynamics.ActiveReports.Label)
        Me.Label2 = CType(Me.sortofPageHeader.Controls(1), DataDynamics.ActiveReports.Label)
        Me.Label4 = CType(Me.sortofPageHeader.Controls(2), DataDynamics.ActiveReports.Label)
        Me.Label5 = CType(Me.sortofPageHeader.Controls(3), DataDynamics.ActiveReports.Label)
        Me.Line1 = CType(Me.sortofPageHeader.Controls(4), DataDynamics.ActiveReports.Line)
        Me.Label6 = CType(Me.sortofPageHeader.Controls(5), DataDynamics.ActiveReports.Label)
        Me.Label7 = CType(Me.sortofPageHeader.Controls(6), DataDynamics.ActiveReports.Label)
        Me.Label8 = CType(Me.sortofPageHeader.Controls(7), DataDynamics.ActiveReports.Label)
        Me.Label9 = CType(Me.sortofPageHeader.Controls(8), DataDynamics.ActiveReports.Label)
        Me.Label10 = CType(Me.sortofPageHeader.Controls(9), DataDynamics.ActiveReports.Label)
        Me.Label12 = CType(Me.sortofPageHeader.Controls(10), DataDynamics.ActiveReports.Label)
        Me.Label13 = CType(Me.sortofPageHeader.Controls(11), DataDynamics.ActiveReports.Label)
        Me.Label14 = CType(Me.sortofPageHeader.Controls(12), DataDynamics.ActiveReports.Label)
        Me.CommRecipName = CType(Me.sortofPageHeader.Controls(13), DataDynamics.ActiveReports.TextBox)
        Me.AccountNumber = CType(Me.Detail.Controls(0), DataDynamics.ActiveReports.TextBox)
        Me.HireDate = CType(Me.Detail.Controls(1), DataDynamics.ActiveReports.TextBox)
        Me.FirstName = CType(Me.Detail.Controls(2), DataDynamics.ActiveReports.TextBox)
        Me.LastName = CType(Me.Detail.Controls(3), DataDynamics.ActiveReports.TextBox)
        Me.Separator = CType(Me.Detail.Controls(4), DataDynamics.ActiveReports.Line)
        Me.FeeCategory = CType(Me.Detail.Controls(5), DataDynamics.ActiveReports.TextBox)
        Me.OriginalBalance = CType(Me.Detail.Controls(6), DataDynamics.ActiveReports.TextBox)
        Me.BeginningBalance = CType(Me.Detail.Controls(7), DataDynamics.ActiveReports.TextBox)
        Me.PaymentAmount = CType(Me.Detail.Controls(8), DataDynamics.ActiveReports.TextBox)
        Me.SettlementNumber = CType(Me.Detail.Controls(9), DataDynamics.ActiveReports.TextBox)
        Me.EndingBalance = CType(Me.Detail.Controls(10), DataDynamics.ActiveReports.TextBox)
        Me.Rate = CType(Me.Detail.Controls(11), DataDynamics.ActiveReports.TextBox)
        Me.Amount = CType(Me.Detail.Controls(12), DataDynamics.ActiveReports.TextBox)
        Me.TextBox5 = CType(Me.sortofPageFooter.Controls(0), DataDynamics.ActiveReports.TextBox)
        Me.Label3 = CType(Me.sortofPageFooter.Controls(1), DataDynamics.ActiveReports.Label)
        Me.TextBox6 = CType(Me.sortofPageFooter.Controls(2), DataDynamics.ActiveReports.TextBox)
        Me.TextBox7 = CType(Me.sortofPageFooter.Controls(3), DataDynamics.ActiveReports.TextBox)
        Me.TextBox2 = CType(Me.grpCompanyNameFooter.Controls(0), DataDynamics.ActiveReports.TextBox)
        Me.Label = CType(Me.grpCompanyNameFooter.Controls(1), DataDynamics.ActiveReports.Label)
        Me.TextBox3 = CType(Me.grpCompanyNameFooter.Controls(2), DataDynamics.ActiveReports.TextBox)
        Me.TextBox4 = CType(Me.grpCompanyNameFooter.Controls(3), DataDynamics.ActiveReports.TextBox)
        Me.[Date] = CType(Me.PageFooter.Controls(0), DataDynamics.ActiveReports.TextBox)
        Me.PN = CType(Me.PageFooter.Controls(1), DataDynamics.ActiveReports.TextBox)
        Me.PT = CType(Me.PageFooter.Controls(2), DataDynamics.ActiveReports.TextBox)
        Me.PageNumbers = CType(Me.PageFooter.Controls(3), DataDynamics.ActiveReports.Label)
        Me.CountCommPayId = CType(Me.ReportFooter.Controls(0), DataDynamics.ActiveReports.TextBox)
        Me.Label11 = CType(Me.ReportFooter.Controls(1), DataDynamics.ActiveReports.Label)
        Me.SumAmount = CType(Me.ReportFooter.Controls(2), DataDynamics.ActiveReports.TextBox)
        Me.TextBox = CType(Me.ReportFooter.Controls(3), DataDynamics.ActiveReports.TextBox)
    End Sub

#End Region

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format


    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

    End Sub
End Class
