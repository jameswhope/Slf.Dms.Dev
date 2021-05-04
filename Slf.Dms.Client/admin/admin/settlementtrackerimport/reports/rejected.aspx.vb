Imports System.Collections.Generic

Partial Class admin_settlementtrackerimport_reports_rejected
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _userid As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property ReportDay() As Integer
        Get
            Return ViewState("ReportDay")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportDay") = value
        End Set
    End Property

    Public Property ReportMonth() As Integer
        Get
            Return ViewState("ReportMonth")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportMonth") = value
        End Set
    End Property

    Public Property ReportYear() As Integer
        Get
            Return ViewState("ReportYear")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportYear") = value
        End Set
    End Property

    Public Property TrendTotalUnits() As Integer
        Get
            Return ViewState("_TrendTotalUnits")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TrendTotalUnits") = value
        End Set
    End Property

    Public Property TrendUniqueCreditors() As Integer
        Get
            Return ViewState("_TrendUniqueCreditors")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TrendUniqueCreditors") = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return _userid
        End Get
        Set(ByVal value As Integer)
            _userid = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Protected Sub admin_settlementtrackerimport_reports_rejected_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If hdnMonth.Value = "" Then
            hdnMonth.Value = Now.Month
        End If
        If hdnYear.Value = "" Then
            hdnYear.Value = Now.Year
        End If
        If hdnDay.Value = "" Then
            hdnDay.Value = -1
        End If
        ReportMonth = hdnMonth.Value
        ReportYear = hdnYear.Value
        ReportDay = hdnDay.Value

        If Not IsPostBack Then
            BindGrid(hdnDay.Value)
        End If

        SetRollups()
    End Sub

    Protected Sub gvRejectionReport_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvRejectionReport.DataBound
        gvRejectionReport.ShowHeader = True
    End Sub

    Protected Sub gvRejectionReport_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvRejectionReport.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strSettlementID As String = CType(e.Row.FindControl("hdnRejectedSettlementID"), HtmlInputHidden).Value
            e.Row.Cells(0).Attributes.Add("onClick", "javascript:return PopUpSettlementCalculations(" & strSettlementID & ")")
            e.Row.Cells(1).Attributes.Add("onClick", "javascript:return PopUpSettlementCalculations(" & strSettlementID & ")")
            e.Row.Cells(4).Attributes.Add("onClick", "javascript:return PopUpSettlementCalculations(" & strSettlementID & ")")
            e.Row.Cells(5).Attributes.Add("onClick", "javascript:return PopUpSettlementCalculations(" & strSettlementID & ")")
            e.Row.Cells(6).Attributes.Add("onClick", "javascript:return PopUpSettlementCalculations(" & strSettlementID & ")")
            e.Row.Cells(7).Attributes.Add("onClick", "javascript:return PopUpSettlementCalculations(" & strSettlementID & ")")
            e.Row.Cells(8).Attributes.Add("onClick", "javascript:return PopUpSettlementCalculations(" & strSettlementID & ")")
        End If
    End Sub

    Protected Sub lnkChangeDay_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeDay.Click
        BindGrid(hdnDay.Value)
    End Sub

    Protected Sub lnkChangeMonth_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeMonth.Click
        BindGrid(hdnDay.Value)
    End Sub

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        BindGrid(hdnDay.Value)
    End Sub

    Protected Sub lnkClearFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        ViewState("ddlDay") = -1
        hdnDay.Value = -1
        dsRejections.FilterExpression = ""
        dsRejections.DataBind()
        gvRejectionReport.DataBind()
    End Sub

    Private Sub BindGrid(ByVal rejectDay As Integer)
        ViewState("ddlDay") = rejectDay
        dsRejections.SelectParameters("year").DefaultValue = ReportYear
        dsRejections.SelectParameters("month").DefaultValue = ReportMonth

        If rejectDay = -1 Then
            dsRejections.FilterExpression = Nothing
        Else
            dsRejections.FilterExpression = String.Format("created >= '{0}/{1}/{2} 00:00:01' and created <= '{0}/{1}/{2} 11:59:59'", ReportMonth, rejectDay, ReportYear)
        End If

        dsRejections.DataBind()
        gvRejectionReport.DataBind()
    End Sub

    Private Function BuildDateSelectionsHTMLControlString() As StringBuilder
        Dim bSelected As Boolean = False
        Dim selectCode As New StringBuilder
        selectCode.Append("Filter By Created Day <br/>")
        selectCode.Append("<select id=""cboDay"" runat=""server"" class=""entry"" onchange=""DayChanged(this);"">")
        For i As Integer = 1 To System.DateTime.DaysInMonth(ReportYear, ReportMonth)
            Dim optText As String = ""
            If i = hdnDay.Value Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", i, i)
                bSelected = True
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", i, i)
            End If
            selectCode.Append(optText)
        Next
        If Not bSelected Then
            selectCode.Append("<option label=""All"" value=""-1"" selected=""selected"" />")
        Else
            selectCode.Append("<option label=""All"" value=""-1""  />")
        End If
        selectCode.Append("</select><br/><hr>")
        If IsNothing(ViewState("ddlDay")) Then
            ViewState("ddlDay") = -1
        End If

        selectCode.Append("Select Month <br/>")
        selectCode.Append("<select id=""cboMonth"" runat=""server"" class=""entry"" onchange=""MonthChanged(this);"">")
        For i As Integer = 1 To 12
            Dim optText As String = ""
            If i = ReportMonth Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", MonthName(i, False), i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", MonthName(i, False), i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/>")
        selectCode.Append("Select Year<br/>")
        selectCode.Append("<select id=""cboYear"" runat=""server"" class=""entry"" onchange=""YearChanged(this);"">")
        For i As Integer = Now.AddYears(-3).Year To Now.Year
            Dim optText As String = ""
            If i = ReportYear Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", i, i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", i, i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/>")
        selectCode.AppendFormat("<br/><a href=""{0}"">Home</a>", ResolveUrl("../../settlementtrackerimport/default.aspx"))
        Return selectCode
    End Function

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settlementtrackerimport_trackerimport).CommonTasks

        Dim selectCode As StringBuilder = BuildDateSelectionsHTMLControlString()

        CommonTasks.Add(selectCode.ToString)
    End Sub

    #End Region 'Methods

End Class