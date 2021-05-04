Option Explicit On

Imports Drg.Util.DataAccess

Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports System
Imports System.Drawing

Public Class checkstoprint
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
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
    Private WithEvents ReportFooter As DataDynamics.ActiveReports.ReportFooter = Nothing
	Private Label As DataDynamics.ActiveReports.Label = Nothing
	Private Label1 As DataDynamics.ActiveReports.Label = Nothing
	Private Label2 As DataDynamics.ActiveReports.Label = Nothing
	Private Label3 As DataDynamics.ActiveReports.Label = Nothing
	Private Label4 As DataDynamics.ActiveReports.Label = Nothing
	Private Label5 As DataDynamics.ActiveReports.Label = Nothing
	Private Line1 As DataDynamics.ActiveReports.Line = Nothing
	Private Label6 As DataDynamics.ActiveReports.Label = Nothing
	Private Label7 As DataDynamics.ActiveReports.Label = Nothing
	Private Label8 As DataDynamics.ActiveReports.Label = Nothing
	Private Label9 As DataDynamics.ActiveReports.Label = Nothing
	Private Label10 As DataDynamics.ActiveReports.Label = Nothing
	Private ClientName As DataDynamics.ActiveReports.TextBox = Nothing
	Private BankName As DataDynamics.ActiveReports.TextBox = Nothing
	Private BankRoutingNumber As DataDynamics.ActiveReports.TextBox = Nothing
	Private BankAccountNumber As DataDynamics.ActiveReports.TextBox = Nothing
	Private Amount As DataDynamics.ActiveReports.TextBox = Nothing
	Private Separator As DataDynamics.ActiveReports.Line = Nothing
	Private CheckNumber As DataDynamics.ActiveReports.TextBox = Nothing
	Private Status As DataDynamics.ActiveReports.TextBox = Nothing
	Private Created As DataDynamics.ActiveReports.TextBox = Nothing
	Private CreatedByName As DataDynamics.ActiveReports.TextBox = Nothing
	Private Fraction As DataDynamics.ActiveReports.TextBox = Nothing
	Private Printed As DataDynamics.ActiveReports.TextBox = Nothing
	Private [Date] As DataDynamics.ActiveReports.TextBox = Nothing
	Private PN As DataDynamics.ActiveReports.TextBox = Nothing
	Private PT As DataDynamics.ActiveReports.TextBox = Nothing
	Private PageNumbers As DataDynamics.ActiveReports.Label = Nothing
	Private CountCheckToPrintID As DataDynamics.ActiveReports.TextBox = Nothing
	Private Label11 As DataDynamics.ActiveReports.Label = Nothing
	Private SumAmount As DataDynamics.ActiveReports.TextBox = Nothing
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.checkstoprint.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Label = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label1 = CType(Me.PageHeader.Controls(0),DataDynamics.ActiveReports.Label)
		Me.Label2 = CType(Me.PageHeader.Controls(1),DataDynamics.ActiveReports.Label)
		Me.Label3 = CType(Me.PageHeader.Controls(2),DataDynamics.ActiveReports.Label)
		Me.Label4 = CType(Me.PageHeader.Controls(3),DataDynamics.ActiveReports.Label)
		Me.Label5 = CType(Me.PageHeader.Controls(4),DataDynamics.ActiveReports.Label)
		Me.Line1 = CType(Me.PageHeader.Controls(5),DataDynamics.ActiveReports.Line)
		Me.Label6 = CType(Me.PageHeader.Controls(6),DataDynamics.ActiveReports.Label)
		Me.Label7 = CType(Me.PageHeader.Controls(7),DataDynamics.ActiveReports.Label)
		Me.Label8 = CType(Me.PageHeader.Controls(8),DataDynamics.ActiveReports.Label)
		Me.Label9 = CType(Me.PageHeader.Controls(9),DataDynamics.ActiveReports.Label)
		Me.Label10 = CType(Me.PageHeader.Controls(10),DataDynamics.ActiveReports.Label)
		Me.ClientName = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.BankName = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.BankRoutingNumber = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.BankAccountNumber = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.Amount = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.Separator = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.Line)
		Me.CheckNumber = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.Status = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.Created = CType(Me.Detail.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.CreatedByName = CType(Me.Detail.Controls(9),DataDynamics.ActiveReports.TextBox)
		Me.Fraction = CType(Me.Detail.Controls(10),DataDynamics.ActiveReports.TextBox)
		Me.Printed = CType(Me.Detail.Controls(11),DataDynamics.ActiveReports.TextBox)
		Me.[Date] = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.PN = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.PT = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.PageNumbers = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.Label)
		Me.CountCheckToPrintID = CType(Me.ReportFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.Label11 = CType(Me.ReportFooter.Controls(1),DataDynamics.ActiveReports.Label)
		Me.SumAmount = CType(Me.ReportFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
	End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

        If Not Fields("Printed").Value Is Nothing And Fields("Printed").Value.ToString().Length > 0 Then

            Status.Text = "Printed"
            Status.ForeColor = Color.FromArgb(0, 0, 220)

            Printed.Visible = True

        Else

            Status.Text = "Not Printed"
            Status.ForeColor = Color.Red

            Printed.Visible = False

        End If

        ClientName.Text = Fields("FirstName").Value.ToString() & " " & Fields("LastName").Value.ToString()

    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub
End Class