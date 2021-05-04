Imports System.Collections.Generic
Imports System.Data

Partial Class admin_settlementtrackerimport_reports_details
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _DetailType As gridDataType
    Private _FooterRow As GridViewRow
    Private _ReportMonth As Integer
    Private _ReportYear As Integer
    Private _userid As Integer

    #End Region 'Fields

    #Region "Enumerations"

    Public Enum gridDataType
        CurrentData = 0
        OriginalData = 1
    End Enum

    #End Region 'Enumerations

    #Region "Properties"

    Public Property DetailType() As gridDataType
        Get
            Return _DetailType
        End Get
        Set(ByVal value As gridDataType)
            _DetailType = value
        End Set
    End Property

    Public Property ReportMonth() As Integer
        Get
            Return _ReportMonth
        End Get
        Set(ByVal value As Integer)
            _ReportMonth = value
        End Set
    End Property

    Public Property ReportYear() As Integer
        Get
            Return _ReportYear
        End Get
        Set(ByVal value As Integer)
            _ReportYear = value
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

    Protected Sub admin_settlementtrackerimport_reports_details_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SetReportParameters()
        If Not IsPostBack Then
            BindGrid(DetailType)
        End If

        SetRollups()
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
                    _FooterRow = e.Row
                    e.Row.Style("display") = "none"
                Else
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
            Case DataControlRowType.Footer
                For i As Integer = 0 To _FooterRow.Cells.Count - 1
                    e.Row.Cells(i).Text = _FooterRow.Cells(i).Text
                Next

        End Select
    End Sub

    Protected Sub gridview_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.Footer
                For Each tc As TableCell In e.Row.Cells
                    tc.Style("font-weight") = "bold"
                    Dim lbl As New Label
                    lbl.Text = ""
                    tc.Controls.Add(lbl)
                Next

            Case DataControlRowType.Header

                GridViewHelper.AddSortImage(sender, e)
        End Select
    End Sub

    Protected Sub lnkChangeDetail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeDetail.Click
        BindGrid(DetailType)
    End Sub

    Protected Sub lnkChangeMonth_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeMonth.Click
        BindGrid(DetailType)
    End Sub

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        BindGrid(DetailType)
    End Sub

    Private Sub BindGrid(ByVal typeOfDetail As gridDataType)
        Select Case typeOfDetail
            Case gridDataType.CurrentData
                SetupDatasourceAndGrid(dsFirmPaidCancelled, gvFirmPaidCancelled)
                SetupDatasourceAndGrid(dsFirmPaidLost, gvFirmPaidLost)
                SetupDatasourceAndGrid(dsFirmSubmitted, gvFirmSubmitted)
                SetupDatasourceAndGrid(dsPaid, gvPaid)
                SetupDatasourceAndGrid(dsPendingFees, gvPending)
                SetupDatasourceAndGrid(dsTeamExpired, gvTeamExpired)
                SetupDatasourceAndGrid(dsTotals, gvTotals)

                LoadCancelled()
                LoadExpired()
                LoadTotalSubmissions()

            Case gridDataType.OriginalData
                SetupDatasourceAndGrid(dsFirmPaidCancelled_orig, gvFirmPaidCancelled)
                SetupDatasourceAndGrid(dsFirmPaidLost_orig, gvFirmPaidLost)
                SetupDatasourceAndGrid(dsPaid_Orig, gvPaid)
                SetupDatasourceAndGrid(dsPendingFees_orig, gvPending)
                SetupDatasourceAndGrid(dsTotals_orig, gvTotals)
        End Select
    End Sub

    Private Function BuildDateSelectionsHTMLControlString() As StringBuilder
        Dim selectCode As New StringBuilder
        selectCode.Append("Creditor Balance Type <br/>")
        selectCode.Append("<select id=""cboDetail"" runat=""server"" class=""entry"" onchange=""DetailChanged(this);"">")
        Select Case hdnDetail.Value.ToLower
            Case "curr"
                selectCode.Append("<option label=""Current Bal"" value=""curr"" selected=""selected""/>")
                selectCode.Append("<option label=""Original Bal"" value=""orig"" />")
            Case Else
                selectCode.Append("<option label=""Current Bal"" value=""curr"" />")
                selectCode.Append("<option label=""Original Bal"" value=""orig"" selected=""selected"" />")
        End Select
        selectCode.Append("</select><br/><hr>")

        selectCode.Append("Select Month <br/>")
        selectCode.Append("<select id=""cboMonth"" runat=""server"" class=""entry"" onchange=""MonthChanged(this);"">")
        For i As Integer = 1 To 12
            Dim optText As String = ""
            If i = ReportMonth Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", MonthName(i, False), i)
                lblCancelMonth.Text = String.Format("{0} Cancelled", MonthName(i))
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

    Private Sub LoadCancelled()
        lblCancelMonth.Text = String.Format("{0} Cancelled", MonthName(ReportMonth))

        Dim sqlExpired As String = String.Format("stp_settlementimport_reports_getCancelled {0},{1}", ReportYear, ReportMonth)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlExpired, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each row In dt.Rows
                lblMonthCancelledAmt.Text = row("amount").ToString
                lblMonthCancelledCnt.Text = row("total").ToString
                lblMonthCancelledPct.Text = FormatNumber(row("pct").ToString, 2)
                Exit For
            Next
        End Using
    End Sub

    Private Sub LoadExpired()
        Dim sqlExpired As String = String.Format("stp_settlementimport_reports_getExpired {0},{1}", ReportYear, ReportMonth)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlExpired, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each row In dt.Rows
                lblExpiredAmt.Text = row("amount").ToString
                lblExpiredCnt.Text = row("total").ToString
                Exit For
            Next
        End Using
    End Sub

    Private Sub LoadTotalSubmissions()
        Dim sqlExpired As String = String.Format("stp_settlementimport_reports_getTotalSubmissions {0},{1}", ReportYear, ReportMonth)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlExpired, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each row In dt.Rows
                lblTotSubAmt.Text = row("amount").ToString
                lblTotSubCnt.Text = row("total").ToString
                Exit For
            Next
        End Using
    End Sub

    Private Sub SetReportParameters()
        If hdnMonth.Value = "" Then
            hdnMonth.Value = Now.Month
        End If
        If hdnYear.Value = "" Then
            hdnYear.Value = Now.Year
        End If
        If hdnDetail.value = "" Then
            hdnDetail.value = "curr"
        End If

        ReportMonth = hdnMonth.Value
        ReportYear = hdnYear.Value
        Select Case hdnDetail.Value.ToLower
            Case "curr"
                DetailType = gridDataType.CurrentData
            Case Else
                DetailType = gridDataType.OriginalData
        End Select
        ShowDetailData(DetailType)
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settlementtrackerimport_trackerimport).CommonTasks

        Dim selectCode As StringBuilder = BuildDateSelectionsHTMLControlString()

        CommonTasks.Add(selectCode.ToString)
    End Sub

    Private Sub SetupDatasourceAndGrid(ByVal sqlDataSourceControl As SqlDataSource, ByVal gridControlToBind As GridView)
        gridControlToBind.DataSourceID = sqlDataSourceControl.ID
        sqlDataSourceControl.SelectParameters("year").DefaultValue = ReportYear
        sqlDataSourceControl.SelectParameters("month").DefaultValue = ReportMonth
        sqlDataSourceControl.DataBind()
        gridControlToBind.ShowFooter = True
        gridControlToBind.FooterStyle.BackColor = System.Drawing.Color.Bisque
        AddHandler gridControlToBind.RowDataBound, AddressOf gridView_RowDataBound
        AddHandler gridControlToBind.RowCreated, AddressOf gridview_RowCreated
        gridControlToBind.DataBind()
    End Sub

    Private Sub ShowDetailData(ByVal detailType As gridDataType)
        Select Case detailType
            Case gridDataType.CurrentData
                lblDetailType.Text = "Details - Current Bal"
                gvFirmPaidCancelled.Visible = True
                gvTeamExpired.Visible = True
                gvFirmSubmitted.Visible = True
                tdExpired.Visible = True
            Case Else
                lblDetailType.Text = "Details - Original Bal"
                gvFirmSubmitted.Visible = False
                gvFirmPaidCancelled.Visible = False
                gvTeamExpired.Visible = False
                tdExpired.Visible = False
        End Select
    End Sub

    #End Region 'Methods

End Class