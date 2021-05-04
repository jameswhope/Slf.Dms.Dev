Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.Serialization

Partial Class CustomTools_UserControls_KPIGrid
    Inherits System.Web.UI.UserControl

    #Region "Fields"

    Private YearList As New Hashtable 'keeps track of grid doc groups
    Private _EndDate As String = ""
    Private _GroupingType As TypeOfGrouping = TypeOfGrouping.d
    Private _StartDate As String = ""
    Private _baseMonthColumns As String = "KPIMonth,TotalInboundCalls,TotalInternet,TotalLeads,TotalSystemCalls,TotalAppointments,TotalCallsAnswered,NumCasesAgainstMarketingDollars,ConversionPercent,MarketingBudgetSpentPerDay,MarketingBudgetPerDay,CostPerConversionDay,TotalNumCases"
    Private iAddTimes As Integer = 0
    Private iAddedRowCount As Integer = 1

    #End Region 'Fields

    #Region "Enumerations"

    Public Enum TypeOfGrouping
        d = 0
        m = 1
        y = 2
    End Enum

    #End Region 'Enumerations

    #Region "Properties"

    Public Property EndDate() As String
        Get
            Return _EndDate
        End Get
        Set(ByVal value As String)
            _EndDate = value
        End Set
    End Property

    Public Property GroupingType() As TypeOfGrouping
        Get
            Return _GroupingType
        End Get
        Set(ByVal value As TypeOfGrouping)
            _GroupingType = value
        End Set
    End Property

    Public Property StartDate() As String
        Get
            Return _StartDate
        End Get
        Set(ByVal value As String)
            _StartDate = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"
    Public Sub LoadGrid()
        Using sa As New SqlDataAdapter("stp_SmartDebtor_KPI_Grouping", ConfigurationManager.AppSettings("connectionstring").ToString)
            sa.SelectCommand.CommandTimeout = 600
            sa.SelectCommand.CommandType = Data.CommandType.StoredProcedure
            sa.SelectCommand.CommandText = "stp_SmartDebtor_KPI_Grouping"
            sa.SelectCommand.Parameters.Add(New SqlParameter("startdate", "1/1/2007 12:00:00 AM"))
            sa.SelectCommand.Parameters.Add(New SqlParameter("enddate", Now.ToString))
            sa.SelectCommand.Parameters.Add(New SqlParameter("kpiGroupType", "y"))
            sa.SelectCommand.Connection.Open()
            Using dt As New Data.DataTable
                sa.Fill(dt)

                AddHandler gvYear.RowDataBound, AddressOf gvYear_RowDataBound
                gvYear.DataSource = dt
                gvYear.DataBind()
            End Using
        End Using
    End Sub
    Public Sub LoadGrid(ByVal startDate As DateTime, ByVal endDate As DateTime, ByVal groupType As TypeOfGrouping)
        Using sa As New SqlDataAdapter("stp_SmartDebtor_KPI_Grouping", ConfigurationManager.AppSettings("connectionstring").ToString)
            sa.SelectCommand.CommandTimeout = 600
            sa.SelectCommand.CommandType = Data.CommandType.StoredProcedure
            sa.SelectCommand.CommandText = "stp_SmartDebtor_KPI_Grouping"
            sa.SelectCommand.Parameters.Add(New SqlParameter("startdate", startDate))
            sa.SelectCommand.Parameters.Add(New SqlParameter("enddate", endDate))
            sa.SelectCommand.Parameters.Add(New SqlParameter("kpiGroupType", groupType.ToString))
            sa.SelectCommand.Connection.Open()
            Using dt As New Data.DataTable
                sa.Fill(dt)

                AddHandler gvYear.RowDataBound, AddressOf gvYear_RowDataBound
                gvYear.DataSource = dt
                gvYear.DataBind()
            End Using
        End Using
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
    End Sub

    Protected Sub gvMonth_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DCDCDC'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

                'get row data
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim rptMonth As String = rowView("kpiMonth").ToString
                Dim tbl As Table = e.Row.Parent
                CreateTestRow(tbl, rptMonth, e.Row.RowIndex)

        End Select
    End Sub

    Protected Sub gvYear_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DCDCDC'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

                'get row data
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim rptYear As String = rowView("kpiYear").ToString

                'show treeview image for expansion
                If YearList.Contains(rptYear) = True Then
                    e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", rptYear, e.Row.RowIndex))
                    Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
                    imgTree.Visible = False
                    e.Row.Style("display") = "none"
                Else
                    YearList.Add(rptYear, Nothing)
                    e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", rptYear))
                    Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
                    imgTree.Attributes.Add("onclick", "toggleDocument('" & rptYear & "','" & gvYear.ClientID & "');")

                    Dim tbl As Table = e.Row.Parent
                    iAddedRowCount += 1
                    CreateRow(tbl, rptYear, e.Row.RowIndex)

                    iAddTimes += 1
                End If

        End Select
    End Sub

    Private Function CreateChildMonthsGrid(ByVal childYear As String) As TableCell
        Dim tcTemp As New TableCell()
        Dim gv As New GridView
        gv.CssClass = "entry2"
        gv.AutoGenerateColumns = False

        Dim tf As New TemplateField()
        tf.ItemTemplate = New CheckBoxTemplate(ListItemType.Item)
        tf.HeaderTemplate = New CheckBoxTemplate(ListItemType.Header)
        tf.HeaderStyle.CssClass = "headitem5"
        tf.ItemStyle.CssClass = "listitem"
        tf.ItemStyle.HorizontalAlign = HorizontalAlign.Center
        gv.Columns.Add(tf)

        For Each col As String In _baseMonthColumns.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
            Dim bf As New BoundField
            bf.DataField = col
            bf.ItemStyle.HorizontalAlign = HorizontalAlign.Center
            If col.ToLower.Contains("budget") = True _
            Or col.ToLower.Contains("$") = True _
            Or col.ToLower.Contains("cost") = True Then
                bf.DataFormatString = "{0:c2}"
                bf.ItemStyle.HorizontalAlign = HorizontalAlign.Right
            End If
            bf.HeaderText = InsertSpaceAfterCap(col)
            bf.HeaderStyle.CssClass = "headitem5"
            bf.ItemStyle.CssClass = "listitem"
            gv.Columns.Add(bf)
        Next

        gv.ID = String.Format("gvChild_{0}", childYear)
        AddHandler gv.RowDataBound, AddressOf gvMonth_RowDataBound
        gv.DataSource = getMonthlyData(childYear)
        gv.DataBind()
        tcTemp.Controls.Add(gv)
        Return tcTemp
    End Function

    Private Function CreateColumn(ByVal strDisplayText As String) As TableCell
        Dim tcTemp As New TableCell()
        tcTemp.Controls.Add(New LiteralControl(strDisplayText))
        Return tcTemp
    End Function

    Private Sub CreateRow(ByVal table As Table, ByVal grpHeader As String, ByVal grpRow As Integer)
        Dim row As New GridViewRow(-1, -1, DataControlRowType.DataRow, DataControlRowState.Normal)
        row.Attributes.Add("id", String.Format("tr_{0}_child{1}", grpHeader, grpRow))
        'row.Style("cursor") = "hand"
        'row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#C6DEF2'; this.style.filter = 'alpha(opacity=75)';")
        'row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

        row.Style("display") = "none"
        row.Cells.Add(CreateColumn(""))
        row.Cells.Add(CreateChildMonthsGrid(grpHeader))
        row.Cells(1).ColumnSpan = table.Rows.Item(0).Cells.Count - 1
        table.Rows.AddAt(iAddedRowCount + iAddTimes, row)
    End Sub

    Private Sub CreateTestRow(ByVal table As Table, ByVal grpHeader As String, ByVal grpRow As Integer)
        Dim row As New GridViewRow(-1, -1, DataControlRowType.DataRow, DataControlRowState.Normal)
        row.Attributes.Add("id", String.Format("tr_{0}_child{1}", grpHeader, grpRow))
        'row.Style("cursor") = "hand"
        'row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#C6DEF2'; this.style.filter = 'alpha(opacity=75)';")
        'row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

        row.Style("display") = "none"
        row.Cells.Add(CreateColumn(""))
        row.Cells.Add(CreateColumn(""))
        row.Cells.Add(CreateColumn("add days grid here"))
        row.Cells(1).ColumnSpan = table.Rows.Item(0).Cells.Count - 1
        table.Rows.AddAt(grpRow + 1, row)
    End Sub

    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String
        If strToChange.Contains("CityStateZip") Then
            strToChange = strToChange.Replace("CityStateZip", "City,StateZip")
        End If

        Dim strNew As String = ""

        For Each c As Char In strToChange.ToCharArray()
            Select Case Asc(c)
                Case 65 To 95, 49 To 57   'upper caps or numbers
                    strNew += Space(1) & c.ToString
                Case 97 To 122  'lower caps
                    strNew += c.ToString
                Case Else
                    strNew += Space(1) & c.ToString
            End Select
        Next

        strNew = strNew.Replace("I D", "ID")
        strNew = strNew.Replace("K P I", "KPI")
        strNew = strNew.Replace("Percent", "%")
        strNew = strNew.Replace("Dollars", "$")
        strNew = strNew.Replace("Num", "#")
        Return strNew.Trim
    End Function

    Private Function getMonthlyData(ByVal yearToGet As String) As DataTable
        Dim ssql As String = String.Format("stp_SmartDebtor_KPI_Grouping '01/1/{0} 12:00:00 AM','01/1/{1} 12:00:00 AM','m'", Integer.Parse(yearToGet), Integer.Parse(yearToGet) + 1)
        Dim dt As New Data.DataTable
        Using sa As New SqlDataAdapter(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)
            sa.SelectCommand.CommandTimeout = 600
            sa.SelectCommand.CommandType = Data.CommandType.Text
            sa.SelectCommand.Connection.Open()
            sa.Fill(dt)
        End Using
        Return dt
    End Function

    #End Region 'Methods

    #Region "Nested Types"

    Public Class CheckBoxTemplate
        Implements ITemplate

        #Region "Fields"

        Private _ctlName As String
        Private _lit As ListItemType

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal TypeOfList As ListItemType)
            _lit = TypeOfList
        End Sub

        #End Region 'Constructors

        #Region "Methods"

        Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements System.Web.UI.ITemplate.InstantiateIn
            Select Case _lit
                Case DataControlRowType.Header
                    Dim lc As New Literal()
                    lc.Text = ""
                    container.Controls.Add(lc)
                    Exit Select
                Case ListItemType.Item
                    Dim img As New HtmlImage
                    img.ID = "imgTree"
                    img.Src = "~/images/tree_plus.bmp"
                    AddHandler img.DataBinding, AddressOf LinkDataBinding
                    container.Controls.Add(img)
            End Select
        End Sub

        Private Sub LinkDataBinding(ByVal sender As Object, ByVal e As EventArgs)
            Dim img As HtmlImage = TryCast(sender, HtmlImage)
            Dim container As GridViewRow = DirectCast(img.NamingContainer, GridViewRow)
            img.Attributes.Add("onclick", String.Format("toggleDocument('{0}','{1}');", _
                                                        DirectCast(container.DataItem, DataRowView)("kpiMonth").ToString(), _
                                                         container.Parent.ID))
        End Sub

        #End Region 'Methods

    End Class

    #End Region 'Nested Types

End Class