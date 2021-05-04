Imports System.Data
Imports System.Data.SqlClient
Imports Infragistics.UltraGauge.Resources
Imports SharedFunctions.AsyncDB
Imports Drg.Util.DataAccess
Imports System.Collections.Generic

Partial Class Agency_Default
    Inherits System.Web.UI.Page

    Public UserID As Integer
    Public UsersIP As String
    Public CommRecId As String
    Public CompanyID As Integer = -1

    Public Structure BatchEntry
        Public CommBatchId As Integer
        Public BatchDate As Date
        Public Amount As Single
        Public Company As String
        Public CommRecID As Integer
        Public CommRec As String

        Public Sub New(ByVal _CommBatchID As Integer, ByVal _BatchDate As Date, ByVal _Amount As Single, ByVal _Company As String, ByVal _CommRecID As Integer, ByVal _CommRec As String)
            Me.CommBatchId = _CommBatchID
            Me.BatchDate = _BatchDate
            Me.Amount = _Amount
            Me.Company = _Company
            Me.CommRecID = _CommRecID
            Me.CommRec = _CommRec
        End Sub
    End Structure

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UsersIP = Request.ServerVariables("REMOTE_ADDR")

        If IsNumeric(Request.QueryString("c")) Then
            CompanyID = CInt(Request.QueryString("c"))
        End If

        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If

        ifmAgencyBatches.Attributes("src") = "overview.aspx?id=" & UserID & "&c=" & CompanyID

        If Not Page.IsPostBack Then
            LoadAgencyBatches()
        End If
    End Sub

    Private Sub LoadAgencyBatches()
        Dim batches As New List(Of BatchEntry)
        Dim SumAmount As Single
        Dim dtToday As Date

        dtToday = "#" & Format(DateAdd(DateInterval.Day, 0, Now), "MM/dd/yyyy") + " 10:00:01 AM#"
        'dtToday = "#" & Format(DateAdd(DateInterval.Day, 0, Now), "MM/dd/yyyy") + " 05:00:01 PM#"
        Try
            Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_AgencyBatchSummary")
                Using cmd.Connection
                    DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                    DatabaseHelper.AddParameter(cmd, "CompanyID", CompanyID)

                    cmd.CommandTimeout = 1800
                    cmd.Connection.Open()
                    Using rd As SqlDataReader = cmd.ExecuteReader()
                        While rd.Read()
                            If DatabaseHelper.Peel_date(rd, "BatchDate") <= dtToday Then
                                SumAmount += DatabaseHelper.Peel_float(rd, "Amount")
                                batches.Add(New BatchEntry(DatabaseHelper.Peel_int(rd, "CommBatchId"), DatabaseHelper.Peel_date(rd, "BatchDate"), DatabaseHelper.Peel_float(rd, "Amount"), DatabaseHelper.Peel_string(rd, "Company"), DatabaseHelper.Peel_int(rd, "CommRecID"), DatabaseHelper.Peel_string(rd, "CommRec")))
                            Else
                                batches.Add(New BatchEntry(DatabaseHelper.Peel_int(rd, "CommBatchId"), DatabaseHelper.Peel_date(rd, "BatchDate"), 0.0, DatabaseHelper.Peel_string(rd, "Company"), DatabaseHelper.Peel_int(rd, "CommRecID"), DatabaseHelper.Peel_string(rd, "CommRec")))
                            End If
                        End While
                    End Using

                    'tdTotal.InnerHtml = "Total: " & SumAmount.ToString("c")
                    'rpBatches.DataSource = batches
                    'rpBatches.DataBind()

                    'rpBatches.Visible = batches.Count > 0
                    'tdTotal.Visible = batches.Count > 0
                    'pnlNone.Visible = batches.Count = 0
                End Using
            End Using
        Catch ex As Exception

        End Try
    End Sub
End Class
