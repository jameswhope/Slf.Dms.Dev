Imports AnalyticsHelper
Imports System.Data.SqlClient
Imports System.Data

Partial Class reports_DebtTransfers
    Inherits System.Web.UI.Page

    Private totals As DataTable

    Private _CallTransfer_TotalLeads As Integer
    Private _CallTransfer_TotalReturned As Integer
    Private _CallTransfer_Called As Integer
    Private _CallTransfer_Contacted As Integer
    Private _CallTransfer_PctContacted As String
    Private _CallTransfer_NotContacted As Integer
    Private _CallTransfer_Dials As Integer
    Private _CallTransfer_DialsPerContact As String
    Private _CallTransfer_Transferred As Integer
    Private _CallTransfer_PctTransferred As String
    Private _CallTransfer_ContractsSent As Integer
    Private _CallTransfer_ContractsSigned As Integer
    Private _CallTransfer_PctContractsSent As String
    Private _CallTransfer_PctContractsSigned As String

    Private _DirectTransfer_TotalLeads As Integer
    Private _DirectTransfer_TotalReturned As Integer
    Private _DirectTransfer_Called As Integer
    Private _DirectTransfer_Contacted As Integer
    Private _DirectTransfer_PctContacted As String
    Private _DirectTransfer_NotContacted As Integer
    Private _DirectTransfer_Dials As Integer
    Private _DirectTransfer_DialsPerContact As String
    Private _DirectTransfer_Transferred As Integer
    Private _DirectTransfer_PctTransferred As String
    Private _DirectTransfer_ContractsSent As Integer
    Private _DirectTransfer_ContractsSigned As Integer
    Private _DirectTransfer_PctContractsSent As String
    Private _DirectTransfer_PctContractsSigned As String

    Private _TotalLeads As Integer
    Private _TotalReturned As Integer
    Private _Called As Integer
    Private _Contacted As Integer
    Private _NotContacted As Integer
    Private _Dials As Integer
    Private _Transferred As Integer
    Private _ContractsSent As Integer
    Private _ContractsSigned As Integer

    Protected Sub reports_DebtTransfers_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            SetDates()
            SetSources()
            LoadGrid()
        End If
    End Sub

    Private Sub SetSources()
        ddlQuerySource.Items.Clear()
        ddlQuerySource.Items.Add(New ListItem("Operations", 1))
        ddlQuerySource.Items.Add(New ListItem("Class", 2))
        ddlQuerySource.SelectedIndex = 0
    End Sub

    Private Sub SetDates()
        txtDate1.Text = Now.ToString("M/d/yyyy")
        txtDate2.Text = Now.ToString("M/d/yyyy")
        ddlQuickPickDate.Items.Clear()
        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yyyy") & "," & Now.AddDays(-1).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 30 days", RoundDate(Now.AddDays(-30), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 60 days", RoundDate(Now.AddDays(-60), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 90 days", RoundDate(Now.AddDays(-90), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

#Region "Methods"

    Public Shared Function RoundDate(ByVal d As DateTime, ByVal Direction As Integer, ByVal Unit As DateUnit) As DateTime
        Dim result As DateTime = d

        If Unit = DateUnit.Week Then
            If Direction = 1 Then
                While Not result.DayOfWeek = DayOfWeek.Saturday
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfWeek = DayOfWeek.Sunday
                    result = result.AddDays(-1)
                End While
            Else
                If result.DayOfWeek = DayOfWeek.Wednesday Or result.DayOfWeek = DayOfWeek.Thursday Or result.DayOfWeek = DayOfWeek.Friday Then
                    While Not result.DayOfWeek = DayOfWeek.Saturday
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfWeek = DayOfWeek.Monday Or result.DayOfWeek = DayOfWeek.Tuesday Then
                    While Not result.DayOfWeek = DayOfWeek.Sunday
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Month Then
            If Direction = 1 Then
                While Not result.Day = Date.DaysInMonth(result.Year, result.Month)
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.Day = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim DaysInMonth As Integer = Date.DaysInMonth(result.Year, result.Month)
                Dim Midpoint As Integer = DaysInMonth / 2

                If result.Day >= Midpoint And result.Day < DaysInMonth Then
                    While Not result.Day = DaysInMonth
                        result = result.AddDays(1)
                    End While
                ElseIf result.Day < Midpoint And result.Day > 1 Then
                    While Not result.Day = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Year Then
            Dim DaysInYear As Integer
            For i As Integer = 1 To 12
                DaysInYear += Date.DaysInMonth(result.Year, i)
            Next
            If Direction = 1 Then
                While Not result.DayOfYear = DaysInYear
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfYear = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim Midpoint As Integer = DaysInYear / 2

                If result.DayOfYear >= Midpoint And result.DayOfYear < DaysInYear Then
                    While Not result.DayOfYear = DaysInYear
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfYear < Midpoint And result.DayOfYear > 1 Then
                    While Not result.DayOfYear = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        End If

        Return result
    End Function

    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click
        If txtDate1.Text = "" Then
            txtDate1.Text = Format(Now, "MM/dd/yyyy")
        End If
        LoadGrid()
    End Sub

    Protected Sub LoadGrid()
        Try
            Dim ds As DataSet = GetStats()
            gvCallCenterTransferOverview.DataSource = ds.Tables(0)
            gvCallCenterTransferOverview.DataBind()
            gvDebtTransfersByCallCenter.DataSource = ds.Tables(1)
            gvDebtTransfersByCallCenter.DataBind()
            gvDebtTransfersByDirect.DataSource = ds.Tables(2)
            gvDebtTransfersByDirect.DataBind()
        Catch ex As Exception
            LeadHelper.LogError("Debt Analysis", ex.Message, ex.StackTrace)
        End Try

    End Sub

    Protected Function GetStats() As DataSet
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("StartDate", txtDate1.Text))
        params.Add(New SqlParameter("EndDate", txtDate2.Text & " 23:59"))
        Dim ds As DataSet = Nothing

        Try
            Dim storedproc As String = "stp_reports_debttransfers_" + ddlQuerySource.SelectedItem.Text
            If CDate(txtDate1.Text) >= Date.Today.AddDays(-7) Then
                ds = SqlHelper.GetDataSet(storedproc, CommandType.StoredProcedure, params.ToArray)
            Else
                ds = SqlHelper.GetDataSet(storedproc, CommandType.StoredProcedure, params.ToArray, SqlHelper.ConnectionString.IDENTIFYLEWHSE)
            End If
            Return ds
        Catch ex As Exception
            LeadHelper.LogError("repost_debtTransfer.aspx_GetStats()", ex.Message, ex.StackTrace)
            Return ds
        End Try

    End Function

#End Region

    Protected Sub gvDebtTransfersByCallCenter_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDebtTransfersByCallCenter.RowDataBound
        'Select Case e.Row.RowType
        '    Case DataControlRowType.DataRow
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rv As DataRowView = TryCast(e.Row.DataItem, DataRowView)

            Dim ShowBreakdown As New StringBuilder
            ShowBreakdown.Append("return ShowBreakdown(")
            Dim rto As Integer = 0
            If rv("rto").ToString = "True" Then
                rto = 1
            End If
            ShowBreakdown.AppendFormat("{0},{1},{2},false);", rv("advertiserid"), rto, rv("verticalid"))
            'ShowBreakdown.AppendFormat("'{0}');", rv("advertiser"))
            Dim lnk As LinkButton = e.Row.FindControl("showSrcCampaigns")
            lnk.OnClientClick = ShowBreakdown.ToString

            e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.background = '#CCFFFF';")
            If e.Row.RowState = DataControlRowState.Alternate Then
                e.Row.Attributes.Add("onmouseout", "this.style.background = '#f9f9f9';")
            Else
                e.Row.Attributes.Add("onmouseout", "this.style.background = '';")
            End If

            _CallTransfer_TotalLeads += Val(rv("Ttl Leads"))
            _CallTransfer_TotalReturned += Val(rv("Ttl Returned"))
            _CallTransfer_Called += Val(rv("Called"))
            _CallTransfer_Contacted += Val(rv("Contacted"))
            _CallTransfer_NotContacted += Val(rv("Not Contacted"))
            _CallTransfer_Dials += Val(rv("Dials"))
            _CallTransfer_Transferred += Val(rv("Transferred"))
            _CallTransfer_ContractsSent += Val(rv("Contracts Sent"))
            _CallTransfer_ContractsSigned += Val(rv("Contracts Signed"))

        ElseIf e.Row.RowType = DataControlRowType.Footer Then

            Dim pContact As Double = 0.0
            Dim dContact As Double = 0.0
            Dim pTransferred As Double = 0.0
            Dim pSent As Double = 0.0
            Dim pSigned As Double = 0.0

            If _CallTransfer_Called <> 0 Then
                pContact = _CallTransfer_Contacted / _CallTransfer_Called
            End If
            If _CallTransfer_Contacted <> 0 Then
                dContact = _CallTransfer_Dials / _CallTransfer_Contacted
            End If
            If _CallTransfer_Contacted <> 0 Then
                pTransferred = _CallTransfer_Transferred / _CallTransfer_Contacted
            End If
            If _CallTransfer_Transferred <> 0 Then
                pSent = _CallTransfer_ContractsSent / _CallTransfer_Transferred
            End If
            If _CallTransfer_ContractsSent <> 0 Then
                pSigned = _CallTransfer_ContractsSigned / _CallTransfer_ContractsSent
            End If

            e.Row.Cells(0).Text = "Total"
            e.Row.Cells(1).Text = CStr(_CallTransfer_TotalLeads)
            e.Row.Cells(2).Text = CStr(_CallTransfer_TotalReturned)
            e.Row.Cells(3).Text = CStr(_CallTransfer_Called)
            e.Row.Cells(4).Text = CStr(_CallTransfer_Contacted)
            e.Row.Cells(5).Text = Format((Math.Round(pContact * 100, 2)), "0.00") + "%"
            e.Row.Cells(6).Text = CStr(_CallTransfer_NotContacted)
            e.Row.Cells(7).Text = CStr(_CallTransfer_Dials)
            e.Row.Cells(8).Text = CStr(Math.Round(dContact, 2))
            e.Row.Cells(9).Text = CStr(_CallTransfer_Transferred)
            e.Row.Cells(10).Text = Format((Math.Round(pTransferred * 100, 2)), "0.00") + "%"
            e.Row.Cells(11).Text = CStr(_CallTransfer_ContractsSent)
            e.Row.Cells(12).Text = Format((Math.Round(pSent * 100, 2)), "0.00") + "%"
            e.Row.Cells(13).Text = CStr(_CallTransfer_ContractsSigned)
            e.Row.Cells(14).Text = Format((Math.Round(pSigned * 100, 2)), "0.00") + "%"

            _TotalLeads = _CallTransfer_TotalLeads
            _TotalReturned = _CallTransfer_TotalReturned
            _Called = _CallTransfer_Called
            _Contacted = _CallTransfer_Contacted
            _NotContacted = _CallTransfer_NotContacted
            _Dials = _CallTransfer_Dials
            _Transferred = _CallTransfer_Transferred
            _ContractsSent = _CallTransfer_ContractsSent
            _ContractsSigned = _CallTransfer_ContractsSigned

        End If

        'End Select
    End Sub

    Protected Sub gvDebtTransfersByDirect_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDebtTransfersByDirect.RowDataBound
        'Select Case e.Row.RowType
        '    Case DataControlRowType.DataRow

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rv As DataRowView = TryCast(e.Row.DataItem, DataRowView)

            Dim ShowBreakdown As New StringBuilder
            ShowBreakdown.Append("return ShowBreakdown(")
            Dim rto As Integer = 0
            If rv("rto").ToString = "True" Then
                rto = 1
            End If
            ShowBreakdown.AppendFormat("{0},{1},{2},true);", rv("advertiserid"), rto, rv("verticalid"))
            'ShowBreakdown.AppendFormat("'{0}');", rv("advertiser"))
            Dim lnk As LinkButton = e.Row.FindControl("showSrcCampaigns")
            lnk.OnClientClick = ShowBreakdown.ToString

            e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.background = '#CCFFFF';")
            If e.Row.RowState = DataControlRowState.Alternate Then
                e.Row.Attributes.Add("onmouseout", "this.style.background = '#f9f9f9';")
            Else
                e.Row.Attributes.Add("onmouseout", "this.style.background = '';")
            End If
            _DirectTransfer_TotalLeads += Val(rv("Ttl Leads"))
            _DirectTransfer_TotalReturned += Val(rv("Ttl Returned"))
            _DirectTransfer_Called += Val(rv("Called"))
            _DirectTransfer_Contacted += Val(rv("Contacted"))
            _DirectTransfer_NotContacted += Val(rv("Not Contacted"))
            _DirectTransfer_Dials += Val(rv("Dials"))
            _DirectTransfer_Transferred += Val(rv("Transferred"))
            _DirectTransfer_ContractsSent += Val(rv("Contracts Sent"))
            _DirectTransfer_ContractsSigned += Val(rv("Contracts Signed"))

        ElseIf e.Row.RowType = DataControlRowType.Footer Then

            Dim pContact As Double = 0.0
            Dim dContact As Double = 0.0
            Dim pTransferred As Double = 0.0
            Dim pSent As Double = 0.0
            Dim pSigned As Double = 0.0

            If _DirectTransfer_Called <> 0 Then
                pContact = _DirectTransfer_Contacted / _DirectTransfer_Called
            End If
            If _DirectTransfer_Contacted <> 0 Then
                dContact = _DirectTransfer_Dials / _DirectTransfer_Contacted
            End If
            If _DirectTransfer_TotalLeads <> 0 Then
                pTransferred = _DirectTransfer_Transferred / _DirectTransfer_TotalLeads
            End If
            If _DirectTransfer_Transferred <> 0 Then
                pSent = _DirectTransfer_ContractsSent / _DirectTransfer_Transferred
            End If
            If _DirectTransfer_ContractsSent <> 0 Then
                pSigned = _DirectTransfer_ContractsSigned / _DirectTransfer_ContractsSent
            End If

            e.Row.Cells(0).Text = "Total"
            e.Row.Cells(1).Text = CStr(_DirectTransfer_TotalLeads)
            e.Row.Cells(2).Text = CStr(_DirectTransfer_TotalReturned)
            e.Row.Cells(3).Text = CStr(_DirectTransfer_Called)
            e.Row.Cells(4).Text = CStr(_DirectTransfer_Contacted)
            e.Row.Cells(5).Text = Format((Math.Round(pContact * 100, 2)), "0.00") + "%"
            e.Row.Cells(6).Text = CStr(_DirectTransfer_NotContacted)
            e.Row.Cells(7).Text = CStr(_DirectTransfer_Dials)
            e.Row.Cells(8).Text = CStr(Math.Round(dContact, 2))
            e.Row.Cells(9).Text = CStr(_DirectTransfer_Transferred)
            e.Row.Cells(10).Text = Format((Math.Round(pTransferred * 100, 2)), "0.00") + "%"
            e.Row.Cells(11).Text = CStr(_DirectTransfer_ContractsSent)
            e.Row.Cells(12).Text = Format((Math.Round(pSent * 100, 2)), "0.00") + "%"
            e.Row.Cells(13).Text = CStr(_DirectTransfer_ContractsSigned)
            e.Row.Cells(14).Text = Format((Math.Round(pSigned * 100, 2)), "0.00") + "%"

            _TotalLeads += _DirectTransfer_TotalLeads
            _TotalReturned += _DirectTransfer_TotalReturned
            _Called += _DirectTransfer_Called
            _Contacted += _DirectTransfer_Contacted
            _NotContacted += _DirectTransfer_NotContacted
            _Dials += _DirectTransfer_Dials
            _Transferred += _DirectTransfer_Transferred
            _ContractsSent += _DirectTransfer_ContractsSent
            _ContractsSigned += _DirectTransfer_ContractsSigned
        End If
        'End Select
    End Sub
End Class
