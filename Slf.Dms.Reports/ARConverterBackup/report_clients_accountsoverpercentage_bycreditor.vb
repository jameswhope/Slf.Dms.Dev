Imports System
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Public Class report_clients_accountsoverpercentage_bycreditor
    Inherits ActiveReport3
    Public Sub New()
        MyBase.New()
        InitializeReport()
    End Sub
#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As DataDynamics.ActiveReports.ReportHeader = Nothing
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents GroupHeader1 As DataDynamics.ActiveReports.GroupHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents GroupFooter1 As DataDynamics.ActiveReports.GroupFooter = Nothing
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
	Private Label2 As DataDynamics.ActiveReports.Label
	Private CreditorName As DataDynamics.ActiveReports.TextBox
	Private CreditorPhone As DataDynamics.ActiveReports.TextBox
	Private CreditorAccountNumber As DataDynamics.ActiveReports.TextBox
	Private AccountBalance As DataDynamics.ActiveReports.TextBox
	Private MinAvailable As DataDynamics.ActiveReports.TextBox
	Private Line As DataDynamics.ActiveReports.Line
	Private FullName1 As DataDynamics.ActiveReports.TextBox
	Private SDABalance As DataDynamics.ActiveReports.TextBox
	Private SSN1 As DataDynamics.ActiveReports.TextBox
	Private AgencyName As DataDynamics.ActiveReports.TextBox
	Private Separator As DataDynamics.ActiveReports.Line
	Private [Date] As DataDynamics.ActiveReports.TextBox
	Private PN As DataDynamics.ActiveReports.TextBox
	Private PT As DataDynamics.ActiveReports.TextBox
	Private PageNumbers As DataDynamics.ActiveReports.Label
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.report_clients_accountsoverpercentage_bycreditor.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.GroupHeader1 = CType(Me.Sections("GroupHeader1"),DataDynamics.ActiveReports.GroupHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.GroupFooter1 = CType(Me.Sections("GroupFooter1"),DataDynamics.ActiveReports.GroupFooter)
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
		Me.Label2 = CType(Me.PageHeader.Controls(9),DataDynamics.ActiveReports.Label)
		Me.CreditorName = CType(Me.GroupHeader1.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.CreditorPhone = CType(Me.GroupHeader1.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.CreditorAccountNumber = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.AccountBalance = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.MinAvailable = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.Line = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.Line)
		Me.FullName1 = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.SDABalance = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.SSN1 = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.AgencyName = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.Separator = CType(Me.GroupFooter1.Controls(0),DataDynamics.ActiveReports.Line)
		Me.[Date] = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.PN = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.PT = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.PageNumbers = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.Label)
	End Sub

#End Region
    Private Function IsNull(ByVal o1 As Object, ByVal o2 As Object) As Object
        If IsDBNull(o1) Then
            Return o2
        Else
            Return o1
        End If
    End Function
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        MinAvailable.Text = (CType(IsNull(Fields("AccountBalance").Value, 0), Single) * CType(IsNull(Fields("percent1").Value, 0), Single)).ToString("c")
    End Sub

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub

    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

    End Sub

    Private Sub PageHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageHeader.Format

    End Sub

    Private Sub GroupHeader1_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles GroupHeader1.Format
        FullName1.Text = Fields("FirstName1").Value & " " & Fields("LastName1").Value
    End Sub
End Class
