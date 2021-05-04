Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_reports_financial_clients_cancellations
    Inherits PermissionPage

#Region "Variables"

    Private UserID As Integer
    Public Columns As Dictionary(Of String, DateSpan)
    Public finalReasons As List(Of ReasonsNode)

#End Region

#Region "Structures"
    Public Structure ReasonInfo
        Public Created As Date
        Public Count As Integer
        Public Refund As Double

        Public Sub New(ByVal _Created As Date, ByVal _Count As Integer, ByVal _Refund As Double)
            Me.Created = _Created
            Me.Count = _Count
            Me.Refund = _Refund
        End Sub
    End Structure

    Public Structure ReasonsNode
        Public Description As String
        Public ReasonsDescID As Integer
        Public ParentReasonsID As Integer
        Public Information As List(Of ReasonInfo)
        Public Level As Integer
        Public IsTotal As Boolean

        Public Sub New(ByVal _Description As String, ByVal _ReasonsDescID As Integer, ByVal _ParentReasonsID As Integer)
            Me.Description = _Description
            Me.ReasonsDescID = _ReasonsDescID
            Me.ParentReasonsID = _ParentReasonsID

            Me.Information = New List(Of ReasonInfo)
            Me.Level = 0
            Me.IsTotal = False
        End Sub
    End Structure

    Public Structure DateSpan
        Public BeginDate As Date
        Public EndDate As Date

        Public Sub New(ByVal _BeginDate As Date, ByVal _EndDate As Date)
            Me.BeginDate = _BeginDate
            Me.EndDate = _EndDate
        End Sub

        Public Function IsWithinSpan(ByVal dt As Date) As Boolean
            If dt >= BeginDate And dt <= EndDate Then
                Return True
            End If

            Return False
        End Function
    End Structure

    Public Structure OtherReasons
        Public Reason As String
        Public Created As Date
        Public Refund As Double

        Public Sub New(ByVal _Reason As String, ByVal _Created As Date, ByVal _Refund As Double)
            Me.Reason = _Reason
            Me.Created = _Created
            Me.Refund = _Refund
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then
            LoadQuickPickDates()
            LoadGranularity()

            BuildReasonsTree()
        End If
    End Sub

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex

        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtTransDate1.Text = parts(0)
            txtTransDate2.Text = parts(1)
        End If

    End Sub

    Private Sub LoadGranularity()
        ddlGranularity.Items.Add(New ListItem("Day", "Day"))
        ddlGranularity.Items.Add(New ListItem("Week", "Week"))
        ddlGranularity.Items.Add(New ListItem("Month", "Month"))
        ddlGranularity.Items.Add(New ListItem("Year", "Year"))

        ddlGranularity.SelectedValue = "Day"
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect("~/research/reports/clients/cancellationsxls.ashx")
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        BuildReasonsTree()
    End Sub

    Private Sub BuildReasonsTree()
        Dim tempReasons As New Dictionary(Of Integer, ReasonsNode)
        Dim Others As New List(Of OtherReasons)

        Using cmd As New SqlCommand("SELECT ReasonsDescID, isnull(ParentReasonsDescID, -1) as ParentReasonsDescID, [Description] FROM tblReasonsDesc " + _
        "WHERE not [Description] = '<other>' ORDER BY ParentReasonsDescID, ReasonsDescID", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        tempReasons.Add(DatabaseHelper.Peel_int(reader, "ReasonsDescID"), New ReasonsNode(DatabaseHelper.Peel_string(reader, "Description"), DatabaseHelper.Peel_int(reader, "ReasonsDescID"), DatabaseHelper.Peel_int(reader, "ParentReasonsDescID")))
                    End While
                End Using

                For Each reasonDescID As Integer In tempReasons.Keys
                    cmd.CommandText = "SELECT rs.Created, isnull(count(distinct rs.[Value]), 0) as [Count], isnull(sum(ta.Amount), 0) as Refund " + _
                    "FROM tblReasons as rs left join tblTransactionAudit as ta on ta.ClientID = rs.[Value] and ta.[Type] = 'registerpayment' " + _
                    "WHERE rs.Created between '" + txtTransDate1.Text + "' and '" + txtTransDate2.Text + "' and rs.ValueType = 'ClientID' " + _
                    "and rs.ReasonsDescID = " + reasonDescID.ToString() + " GROUP BY rs.Created"

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            tempReasons(reasonDescID).Information.Add(New ReasonInfo(DatabaseHelper.Peel_date(reader, "Created"), DatabaseHelper.Peel_int(reader, "Count"), DatabaseHelper.Peel_double(reader, "Refund")))
                        End While
                    End Using
                Next

                cmd.CommandText = "SELECT rs.Other, rs.Created, isnull(sum(ta.Amount), 0) as Refund " + _
                "FROM tblReasons as rs left join tblTransactionAudit as ta on ta.ClientID = rs.[Value] and ta.[Type] = 'registerpayment' " + _
                "WHERE rs.Created between '" + txtTransDate1.Text + "' and '" + txtTransDate2.Text + "' and rs.ValueType = 'ClientID' " + _
                "and not rs.Other is null GROUP BY rs.Other, rs.Created ORDER BY rs.Created"

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Others.Add(New OtherReasons(reader("Other").ToString(), Date.Parse(reader("Created").ToString()), Double.Parse(reader("Refund"))))
                    End While
                End Using
            End Using
        End Using

        CreateDateSpans()

        finalReasons = New List(Of ReasonsNode)

        OrderTreeRec(tempReasons, -1)

        rptReasons.DataSource = finalReasons
        rptReasons.DataBind()

        rptHeaders.DataSource = Columns.Keys
        rptHeaders.DataBind()

        rptOthers.DataSource = Others
        rptOthers.DataBind()

        pnlOthers.Visible = Others.Count > 0

        Session("cancellationsxls_pnl") = pnlReport
    End Sub

    Private Sub OrderTreeRec(ByVal reasons As Dictionary(Of Integer, ReasonsNode), ByVal parentID As Integer, Optional ByVal level As Integer = 0)
        Dim tempNode As ReasonsNode

        For Each reasonsID As Integer In reasons.Keys
            If reasons(reasonsID).ParentReasonsID = parentID Then
                tempNode = reasons(reasonsID)

                tempNode.Level = level

                finalReasons.Add(GranulateInfo(tempNode))

                OrderTreeRec(reasons, reasonsID, level + 1)
            End If
        Next
    End Sub

    Private Sub CreateDateSpans()
        Columns = New Dictionary(Of String, DateSpan)

        Select Case ddlGranularity.SelectedValue.ToString()
            Case "Day"
                CreateDateSpanDay()
            Case "Week"
                CreateDateSpanWeek()
            Case "Month"
                CreateDateSpanMonth()
            Case "Year"
                CreateDateSpanYear()
        End Select
    End Sub

    Private Sub CreateDateSpanDay()
        Dim tempDate As DateTime = DateTime.Parse(Date.Parse(txtTransDate1.Text).ToString("MM-dd-yyyy"))
        Dim finalDate As DateTime = DateTime.Parse(Date.Parse(txtTransDate2.Text).ToString("MM-dd-yyyy"))

        While tempDate <= finalDate
            Columns.Add(tempDate.ToString("MM/dd/yyyy"), New DateSpan(tempDate, tempDate))

            tempDate = tempDate.AddDays(1)
        End While
    End Sub

    Private Sub CreateDateSpanWeek()
        Dim tempDate1 As DateTime = DateTime.Parse(Date.Parse(txtTransDate1.Text).ToString("MM-dd-yyyy"))
        Dim tempDate2 As DateTime = tempDate1
        Dim finalDate As DateTime = DateTime.Parse(Date.Parse(txtTransDate2.Text).ToString("MM-dd-yyyy"))

        While tempDate2 <= finalDate And Not tempDate2.DayOfWeek = DayOfWeek.Sunday
            tempDate2 = tempDate2.AddDays(1)
        End While

        Columns.Add(tempDate1.ToString("MM/dd/yyyy") + "<br /> - <br />" + tempDate2.ToString("MM/dd/yyyy"), New DateSpan(tempDate1, tempDate2))

        tempDate1 = tempDate2.AddDays(1)

        While tempDate1.AddDays(7) <= finalDate
            tempDate2 = tempDate1.AddDays(7)

            Columns.Add(tempDate1.ToString("MM/dd/yyyy") + "<br /> - <br />" + tempDate2.ToString("MM/dd/yyyy"), New DateSpan(tempDate1, tempDate2))

            tempDate1 = tempDate2.AddDays(1)
        End While

        If finalDate > tempDate2 Then
            Columns.Add(tempDate2.ToString("MM/dd/yyyy") + "<br /> - <br />" + finalDate.ToString("MM/dd/yyyy"), New DateSpan(tempDate2, finalDate))
        End If
    End Sub

    Private Sub CreateDateSpanMonth()
        Dim tempDate1 As DateTime = DateTime.Parse(Date.Parse(txtTransDate1.Text).ToString("MM-dd-yyyy"))
        Dim tempDate2 As DateTime = tempDate1
        Dim finalDate As DateTime = DateTime.Parse(Date.Parse(txtTransDate2.Text).ToString("MM-dd-yyyy"))

        tempDate2 = New DateTime(tempDate1.Year, tempDate1.Month, DateTime.DaysInMonth(tempDate1.Year, tempDate1.Month))

        If tempDate2 > finalDate Then
            tempDate2 = finalDate
        End If

        Columns.Add(IIf(tempDate1.Month = tempDate2.Month And tempDate1.Day = 1 And tempDate2.Day = tempDate2.DaysInMonth(tempDate2.Year, tempDate2.Month), tempDate1.ToString("Y"), tempDate1.ToString("MM/dd/yyyy") + "<br /> - <br />" + tempDate2.ToString("MM/dd/yyyy")), New DateSpan(tempDate1, tempDate2))

        tempDate1 = tempDate2.AddDays(1)

        While tempDate1.AddMonths(1) <= finalDate
            tempDate2 = New DateTime(tempDate1.Year, tempDate1.Month, DateTime.DaysInMonth(tempDate1.Year, tempDate1.Month))

            Columns.Add(tempDate1.ToString("Y"), New DateSpan(tempDate1, tempDate2))

            tempDate1 = tempDate2.AddDays(1)
        End While

        If finalDate > tempDate2 Then
            Columns.Add(IIf(finalDate.Day = finalDate.DaysInMonth(finalDate.Year, finalDate.Month), finalDate.ToString("Y"), tempDate2.ToString("MM/dd/yyyy") + "<br /> - <br />" + finalDate.ToString("MM/dd/yyyy")), New DateSpan(tempDate2, finalDate))
        End If
    End Sub

    Private Sub CreateDateSpanYear()
        Dim tempDate1 As DateTime = DateTime.Parse(Date.Parse(txtTransDate1.Text).ToString("MM-dd-yyyy"))
        Dim tempDate2 As DateTime = tempDate1
        Dim finalDate As DateTime = DateTime.Parse(Date.Parse(txtTransDate2.Text).ToString("MM-dd-yyyy"))

        tempDate2 = tempDate1.AddYears(1).AddDays(-1)

        If tempDate2 > finalDate Then
            tempDate2 = finalDate
        End If

        Columns.Add(IIf(tempDate1.DayOfYear = 1 And tempDate2.DayOfYear = 365, tempDate1.ToString("yyyy"), tempDate1.ToString("MM/dd/yyyy") + "<br /> - <br />" + tempDate2.ToString("MM/dd/yyyy")), New DateSpan(tempDate1, tempDate2))

        tempDate1 = tempDate2.AddDays(1)

        While tempDate1.AddYears(1) <= finalDate
            tempDate2 = tempDate1.AddYears(1).AddDays(-1)

            Columns.Add(tempDate1.ToString("yyyy"), New DateSpan(tempDate1, tempDate2))

            tempDate1 = tempDate2.AddDays(1)
        End While

        tempDate2 = tempDate2.AddDays(1)

        If finalDate > tempDate2 Then
            Columns.Add(IIf(finalDate.DayOfYear = 365, finalDate.ToString("yyyy"), tempDate2.ToString("MM/dd/yyyy") + "<br /> - <br />" + finalDate.ToString("MM/dd/yyyy")), New DateSpan(tempDate2, finalDate))
        End If
    End Sub

    Private Function GranulateInfo(ByVal reason As ReasonsNode) As ReasonsNode
        Dim newReason As ReasonsNode

        newReason = New ReasonsNode(reason.Description, reason.ReasonsDescID, reason.ParentReasonsID)

        newReason.Level = reason.Level

        For Each col As DateSpan In Columns.Values
            newReason.Information.Add(GetWithinSpan(reason.Information, col))
        Next

        Return newReason
    End Function

    Private Function GetWithinSpan(ByVal infoList As List(Of ReasonInfo), ByVal span As DateSpan) As ReasonInfo
        Dim finalInfo As New ReasonInfo(span.BeginDate, 0, 0)

        For Each info As ReasonInfo In infoList
            If span.IsWithinSpan(info.Created) Then
                finalInfo.Count += info.Count
                finalInfo.Refund += info.Refund
            End If
        Next

        Return finalInfo
    End Function

    Public Function IndentTree(ByVal level As Integer) As String
        Dim ret As String = ""

        level *= 10

        For x As Integer = 0 To level
            ret += "&nbsp;"
        Next

        Return ret
    End Function

    Public Function GetDateSpanByIndex(ByVal idx As Integer) As DateSpan
        Dim count As Integer = 0

        For Each dt As DateSpan In Columns.Values
            If count = idx Then
                Return dt
            End If

            count += 1
        Next

        Return Nothing
    End Function

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class