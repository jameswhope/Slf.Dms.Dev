Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Namespace admin

    Partial Class admin_CallStats
        Inherits System.Web.UI.Page

        'Private _LexxtimeWebService As New LexxtimeSvc.LexxtimeWebServiceSoapClient

        'Last updated J Hope 04/26/2011
        'Added Revenue, Labor Cost and Gross Margin to summary and individual data
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not Page.IsPostBack Then
                If Me.txtDate1.Text = "" Then
                    Me.txtDate1.Text = Format(Now, "MM/dd/yyyy")
                End If
                GetTheData(Format(Now, "MM/dd/yyyy"), -1)
            End If
        End Sub

        Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
            If txtDate1.Text = "" Then
                txtDate1.Text = Format(Now, "MM/dd/yyyy")
            End If

            Dim groupID As Integer = ddlGroups.SelectedItem.Value

            GetTheData(txtDate1.Text, groupID)
        End Sub

        Protected Function GetLeadStatistics(ByVal StartDate As DateTime, ByVal EndDate As DateTime, Optional ByVal GroupID As Integer = -1) As DataTable
            Dim ssql As String = "stp_callstats_LeadStatistics"
            Dim sParams As New List(Of SqlParameter)
            Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
            sParams.Add(New SqlParameter("@StartDate", StartDate))
            sParams.Add(New SqlParameter("@EndDate", EndDate))
            sParams.Add(New SqlParameter("@GroupID", GroupID))
            If DateDiff(DateInterval.Day, StartDate, Today) > 7 Then
                connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
            End If
            Return SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, sParams.ToArray, connStr)
        End Function

        Protected Function GetTransfersData(ByVal StartDate As DateTime, ByVal EndDate As DateTime, Optional ByVal GroupID As Integer = -1) As DataTable
            Dim ssql As String = "stp_IdentiFyle_Stats3"
            Dim sParams As New List(Of SqlParameter)
            Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
            sParams.Add(New SqlParameter("@StartDate", StartDate))
            sParams.Add(New SqlParameter("@EndDate", EndDate))
            sParams.Add(New SqlParameter("@GroupID", GroupID))
            If DateDiff(DateInterval.Day, StartDate, Today) > 7 Then
                connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
            End If
            Return SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, sParams.ToArray, connStr)
        End Function

        Protected Function GetRevenueData(ByVal StartDate As DateTime, ByVal EndDate As DateTime, ByVal groupID As Integer) As DataTable
            Dim ssql As String = "stp_IdentiFyle_Revenue_Stats"
            Dim sParams As New List(Of SqlParameter)
            Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
            sParams.Add(New SqlParameter("@StartDate", StartDate))
            sParams.Add(New SqlParameter("@EndDate", EndDate))
            sParams.Add(New SqlParameter("@GroupID", groupID))
            If DateDiff(DateInterval.Day, StartDate, Today) > 7 Then
                connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
            End If
            Return SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, sParams.ToArray, connStr)
        End Function

        Protected Sub GetTheData(ByVal dateOfData As String, ByVal groupID As Integer)
            Try
                Dim dt1 As DataTable = GetLeadStatistics(dateOfData, dateOfData & " 11:59 PM", groupID)
                Me.grdIdentiFyle.DataSource = dt1
                Me.grdIdentiFyle.DataBind()

                Dim dt2 As DataTable = GetRevenueData(dateOfData, dateOfData & " 11:59 PM", groupID)
                Me.gvIncome.DataSource = dt2
                Me.gvIncome.DataBind()

                Dim dt3 As DataTable = GetTransfersData(dateOfData, dateOfData & " 11:59 PM", groupID)
                Me.grdIdentiFyleTransfers.DataSource = dt3
                Me.grdIdentiFyleTransfers.DataBind()
            Catch ex As Exception
                LeadHelper.LogError("Call Stats", ex.Message, ex.StackTrace)
            End Try
        End Sub

        Protected Sub grdIdentiFyleTransfers_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdIdentiFyleTransfers.RowDataBound
            Select Case e.Row.RowType
                Case DataControlRowType.DataRow
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';this.style.cursor = 'hand';")
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

                    Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)

                    If rowview("AvgPointPerHr") < 5.0 Then
                        e.Row.ForeColor = System.Drawing.Color.Red
                    End If
                    If Not IsDBNull(rowview("created")) Then
                        If DateDiff(DateInterval.Day, CDate(rowview("created").ToString), Now) <= 10 Then
                            e.Row.Cells(0).ForeColor = System.Drawing.Color.Green
                        End If
                    End If
            End Select
        End Sub

    End Class

End Namespace