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

Public Class report_servicefee_my
    Inherits ActiveReport3

    Private ChargesRequired As Boolean = True

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
	Private srPayments As DataDynamics.ActiveReports.SubReport
	Private srCharges As DataDynamics.ActiveReports.SubReport
	Private [Date] As DataDynamics.ActiveReports.TextBox
	Private PN As DataDynamics.ActiveReports.TextBox
	Private PT As DataDynamics.ActiveReports.TextBox
	Private PageNumbers As DataDynamics.ActiveReports.Label
	Private PreviousBalance As DataDynamics.ActiveReports.TextBox
	Private TextBox As DataDynamics.ActiveReports.TextBox
	Private NewChargesTotal As DataDynamics.ActiveReports.TextBox
	Private TextBox2 As DataDynamics.ActiveReports.TextBox
	Private FeePaymentsTotal As DataDynamics.ActiveReports.TextBox
	Private TextBox4 As DataDynamics.ActiveReports.TextBox
	Private EndingBalance As DataDynamics.ActiveReports.TextBox
	Private asdf As DataDynamics.ActiveReports.TextBox
	Private Line1 As DataDynamics.ActiveReports.Line
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.report_servicefee_my.rpx")
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
		Me.srPayments = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.SubReport)
		Me.srCharges = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.SubReport)
		Me.[Date] = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.PN = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.PT = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.PageNumbers = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.Label)
		Me.PreviousBalance = CType(Me.ReportFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.TextBox = CType(Me.ReportFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.NewChargesTotal = CType(Me.ReportFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.TextBox2 = CType(Me.ReportFooter.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.FeePaymentsTotal = CType(Me.ReportFooter.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.TextBox4 = CType(Me.ReportFooter.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.EndingBalance = CType(Me.ReportFooter.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.asdf = CType(Me.ReportFooter.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.Line1 = CType(Me.ReportFooter.Controls(8),DataDynamics.ActiveReports.Line)
	End Sub

#End Region

    Private Sub PageFooter_BeforePrint(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.BeforePrint
        PageNumbers.Text = "Page " & PN.Value & " of " & PT.Value
    End Sub
    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format
        EndingBalance.Text = CType((Fields("NewChargesTotal").Value - Fields("FeePaymentsTotal").Value + Fields("PreviousBalance").Value), Single).ToString("c")

        Using cmd As IDbCommand = CommandHelper.DeepClone(CType(HttpContext.Current.Session("rptcmd_report_servicefee_my_payments"), IDbCommand))
            Using cmd.Connection
                cmd.Connection.Open()
                Dim dt As DataTable = New DataTable
                Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                da.Fill(dt)

                Dim rpt As ActiveReport3 = New report_servicefee_my_payments

                rpt.DataSource = dt
                rpt.UserData = cmd
                srPayments.Report = rpt

            End Using
        End Using
        Try
            Using cmd As IDbCommand = CommandHelper.DeepClone(CType(HttpContext.Current.Session("rptcmd_report_servicefee_my_charges"), IDbCommand))
                Using cmd.Connection
                    cmd.Connection.Open()
                    Dim dt As DataTable = New DataTable
                    Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
                    da.Fill(dt)

                    Dim rpt As ActiveReport3 = New report_servicefee_my_charges

                    rpt.DataSource = dt
                    rpt.UserData = cmd
                    srCharges.Report = rpt

                End Using
            End Using
        Catch
            ChargesRequired = False
            ReportFooter.Visible = False
        End Try
    End Sub

    Private Sub ReportHeader_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportHeader.Format

    End Sub

    Private Sub ReportFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReportFooter.Format
        If Not ChargesRequired Then
            ReportFooter.Visible = False
        End If
    End Sub
End Class