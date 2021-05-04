Imports System.Collections.Generic

Partial Class admin_settlementtrackerimport_reports_additionaldetails
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _userid As Integer

    #End Region 'Fields

    #Region "Properties"

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

    Public Function getReportDate(ByVal reportDate As String) As String
        Dim dString As String = reportDate
        If IsDate(reportDate) Then
            dString = DateTime.Parse(reportDate).DayOfWeek
        Else
            dString = ""
        End If
        Return dString
    End Function

    Protected Sub admin_settlementtrackerimport_reports_additionaldetails_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If hdnMonth.Value = "" Then
            hdnMonth.Value = Now.Month
        End If
        If hdnYear.Value = "" Then
            hdnYear.Value = Now.Year
        End If
        ReportMonth = hdnMonth.Value
        ReportYear = hdnYear.Value

        If Not IsPostBack Then
            BindGrid()
        End If

        SetRollups()
    End Sub
    Private Sub BindGrid()
        dsTurn.SelectParameters("year").DefaultValue = ReportYear
        dsTurn.SelectParameters("month").DefaultValue = ReportMonth
        dsTurn.DataBind()
        AddHandler gvTurn.RowDataBound, AddressOf gridView_RowDataBound
        gvTurn.DataBind()


        dsMonthlySettlements.SelectParameters("year").DefaultValue = ReportYear
        dsMonthlySettlements.SelectParameters("month").DefaultValue = ReportMonth
        dsMonthlySettlements.DataBind()
        AddHandler gvMonthlySettlements.RowDataBound, AddressOf gridView_RowDataBound
        gvMonthlySettlements.DataBind()

    End Sub

    Protected Sub gridView_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                e.Row.CssClass = "headitem5"

            Case DataControlRowType.DataRow
                e.Row.CssClass = "listitem"
                e.Row.Style("cursor") = "hand"
                If e.Row.Cells(0).Text.ToString.ToLower = "total" Then
                    e.Row.CssClass = "footerItem"
                    Using gv As GridView = TryCast(sender, GridView)
                        gv.FooterRow.Cells.Clear()
                        For i As Integer = 0 To e.Row.Cells.Count - 1
                            gv.FooterRow.Cells.AddAt(i, e.Row.Cells(i))
                        Next
                    End Using
                Else
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
            Case DataControlRowType.Footer

        End Select
    End Sub

    Private Function BuildDateSelectionsHTMLControlString() As StringBuilder
        Dim selectCode As New StringBuilder
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

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        BindGrid()
    End Sub

    Protected Sub lnkChangeMonth_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeMonth.Click
        BindGrid()
    End Sub
End Class