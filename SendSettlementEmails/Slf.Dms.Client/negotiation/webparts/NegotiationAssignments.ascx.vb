Imports Drg.Util.DataHelpers

Imports LexxiomWebPartsControls

Imports System.Collections.Generic
Imports System.Data
Imports System
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.ComponentModel
Imports System.ComponentModel.Design
Imports System.IO

Partial Class negotiation_webparts_NegotiationAssignments
    Inherits System.Web.UI.UserControl

#Region "Declares"
    Private dsPreview As DataSet
    Private sConn As String = ""
    Private sFileSavePath As String

    Private strFilterid As Integer
    Private EntityID As String

    'variables
    Private htLookUp As New Hashtable
    Private m_ColumnCount As Integer

    Private HideGroupedColumnHeaders As Boolean = False
    Private GroupingColumn As String = ""
    Private DisplayColumns As String

    Private _UserID As String

    Public Property UserID() As String
        Get
            Return _UserID
        End Get
        Set(ByVal value As String)
            _UserID = value
        End Set
    End Property
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        sConn = System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString()

        LoadDS()

        SetWebPartVisibility()
    End Sub
#End Region

#Region "Subs/Funcs"
    Private Sub LoadDS()
        Dim sCmd As SqlClient.SqlCommand = Nothing

        dsPreview = New DataSet("PreviewData")

        Using saTemp = New SqlClient.SqlDataAdapter("stp_NegotiationViewColumnSelect 1", Configuration.ConfigurationManager.AppSettings("connectionstring"))
            'preload columns
            saTemp.fill(dsPreview, "Columns")

            'load types
            sCmd = New SqlClient.SqlCommand("SELECT DISTINCT Type FROM tblNegotiationEntity", saTemp.selectcommand.connection)
            saTemp.SelectCommand = sCmd
            saTemp.fill(dsPreview, "EntityType")

            'load entities
            sCmd = New SqlClient.SqlCommand("SELECT Name, NegotiationEntityID, Type FROM tblNegotiationEntity WHERE (Deleted = 0)", saTemp.selectcommand.connection)
            saTemp.SelectCommand = sCmd
            saTemp.fill(dsPreview, "Entities")


            sCmd = New SqlClient.SqlCommand("SELECT fx.EntityID, fx.filterid, nf.Description, nf.AggregateClause,nf.filterType,fx.deleted as [xDeleted],nf.deleted as [fDeleted] FROM  tblNegotiationFilters AS nf INNER JOIN tblNegotiationFilterXref AS fx ON nf.FilterId = fx.FilterId where fx.deleted = 0", saTemp.selectcommand.connection)
            saTemp.SelectCommand = sCmd
            saTemp.fill(dsPreview, "Filters")
        End Using
    End Sub

    Private Function BuildParentSQL() As String
        Dim sqlWhere As String = ""
        Dim sqlSelect As String = ""
        Dim sSQL As String = ""

        Try
            GroupingColumn = Session("NegotiationOptionsConsumer_options").radGroups.SelectedValue
            ViewState("GroupingColumn") = GroupingColumn
            ViewState("ShowGroupingIndex") = Session("NegotiationOptionsConsumer_options").radGroupShow.SelectedIndex

            If Not Session("NegotiationOptionsConsumer_options").chkFilters Is Nothing Then
                For i As Integer = 0 To Session("NegotiationOptionsConsumer_options").chkFilters.Items.Count - 1
                    If Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Selected Then
                        sqlWhere += Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Value & " OR "
                    End If
                Next
            End If

            If sqlWhere.Length < 5 Then
                sqlWhere = "1=0"
            Else
                sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 4)
            End If

            sqlSelect = "stp_NegotiationPreviewGroups '" & GroupingColumn & "','" & sqlWhere.Replace("'", "''") & "'"

            Return sqlSelect
        Catch ex As Exception
            Return ex.Message & vbNewLine & ex.InnerException.ToString
        End Try
    End Function

    Private Sub BindParentGrid(ByVal sqlSelect As String)
        dsData.SelectCommand = sqlSelect
        dsData.DataBind()
        Me.gridData.DataSourceID = dsData.ID
        Me.gridData.DataBind()

        SetWebPartVisibility()
    End Sub

    Private Sub SetWebPartVisibility()
        Dim ctrl As Control = LoadControl("~/negotiation/webparts/NegotiationAssignments.ascx")
        Dim wpm As WebPartManager = WebPartManager.GetCurrentWebPartManager(Page)

        For Each wp As WebPart In wpm.WebParts
            If wp.WebBrowsableObject.GetType().Equals(ctrl.GetType()) Then
                wp.Hidden = gridData.Rows.Count = 0
            End If
        Next
    End Sub

    Private Sub BindParentGrid()
        dsData.DataBind()
        Me.gridData.DataSourceID = dsData.ID
        Me.gridData.DataBind()

        SetWebPartVisibility()
    End Sub

    Private Sub BuildGrid(ByVal ColumnNamesList As String, ByRef GridToBuild As GridView)
        GridToBuild.AutoGenerateColumns = False
        GridToBuild.HeaderStyle.CssClass = "gridheaderstyle"
        GridToBuild.RowStyle.CssClass = "gridrowstyle"
        GridToBuild.PagerStyle.CssClass = "gridpagerstyle"
        GridToBuild.AlternatingRowStyle.CssClass = "gridalternatingrowstyle"
        GridToBuild.PagerSettings.Position = PagerPosition.TopAndBottom

        For i As Integer = 1 To GridToBuild.Columns.Count - 1
            Try
                GridToBuild.Columns.RemoveAt(i)
            Catch ex As Exception
                Continue For
            End Try
        Next

        Dim strGroupCol As String = Me.GroupingColumn

        If strGroupCol.ToString <> "" Then
            Dim groupCol As New BoundField

            If strGroupCol.ToLower.Contains("amount") Or strGroupCol.ToLower.Contains("balance") Or strGroupCol.ToLower.Contains("funds") Then
                groupCol.DataFormatString = "{0:c}"
                groupCol.HtmlEncode = False
                groupCol.ItemStyle.HorizontalAlign = HorizontalAlign.Right
                groupCol.HeaderStyle.HorizontalAlign = HorizontalAlign.Right
            ElseIf strGroupCol.ToLower.Contains("date") Then
                groupCol.DataFormatString = "{0:d}"
                groupCol.HtmlEncode = False
            Else
                groupCol.ItemStyle.HorizontalAlign = HorizontalAlign.Left
                groupCol.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            End If

            groupCol.SortExpression = strGroupCol
            groupCol.DataField = strGroupCol
            groupCol.Visible = False
            groupCol.HeaderText = Me.InsertSpaceAfterCap(strGroupCol).Replace("I D", "ID").Replace("S S N", "SSN").Replace("S D A", "SDA")
            GridToBuild.Columns.Add(groupCol)
        End If

        Dim hlf As HyperLinkField = Nothing

        For Each chkItem As System.Web.UI.WebControls.ListItem In Session("NegotiationOptionsConsumer_options").chkColumns.Items
            If chkItem.Value <> strGroupCol Then
                If chkItem.Selected = True Then
                    Select Case chkItem.Value.ToLower
                        Case "clientid", "currentcreditor"
                            hlf = New HyperLinkField
                            hlf.ItemStyle.HorizontalAlign = HorizontalAlign.Left
                            hlf.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
                            hlf.SortExpression = chkItem.Value
                            hlf.HeaderText = chkItem.Text
                            hlf.DataTextField = chkItem.Value
                            hlf.Target = "_blank"

                            If chkItem.Value.ToLower = "clientid" Then
                                hlf.DataNavigateUrlFields = "clientid".Split(",")
                                hlf.DataNavigateUrlFormatString = "~/clients/client/?id={0}"
                            Else
                                hlf.DataNavigateUrlFields = "clientid,accountid".Split(",")
                                hlf.DataNavigateUrlFormatString = "~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}"
                            End If

                            GridToBuild.Columns.Add(hlf)

                        Case Else
                            Dim dc As New BoundField
                            If chkItem.Text.ToLower.Contains("amount") Or chkItem.Text.ToLower.Contains("balance") Or chkItem.Text.ToLower.Contains("funds") Then
                                dc.DataFormatString = "{0:c}"
                                dc.HtmlEncode = False
                                dc.ItemStyle.HorizontalAlign = HorizontalAlign.Right
                                dc.HeaderStyle.HorizontalAlign = HorizontalAlign.Right
                            ElseIf chkItem.Text.ToLower.Contains("date") Then
                                dc.DataFormatString = "{0:d}"
                                dc.HtmlEncode = False
                            Else
                                dc.ItemStyle.HorizontalAlign = HorizontalAlign.Left
                                dc.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
                            End If
                            dc.SortExpression = chkItem.Value
                            dc.DataField = chkItem.Value
                            dc.HeaderText = chkItem.Text
                            GridToBuild.Columns.Add(dc)
                    End Select
                End If
            End If
        Next

        hlf = New HyperLinkField
        hlf.ItemStyle.HorizontalAlign = HorizontalAlign.Left
        hlf.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
        hlf.Text = "Negotiate"
        hlf.Target = "_self"
        hlf.DataNavigateUrlFields = "clientid,accountid".Split(",")
        hlf.DataNavigateUrlFormatString = "~/negotiation/clients/?cid={0}&crid={1}"
        GridToBuild.Columns.Insert(0, hlf)
    End Sub

    Sub ServerValidationCheckFilters(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        args.IsValid = False

        For i As Integer = 0 To Session("NegotiationOptionsConsumer_options").chkFilters.Items.Count - 1
            If Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Selected Then
                args.IsValid = True
                Exit Sub
            End If
        Next
    End Sub

    Private Function GetCheckedColumns() As String
        Dim strNames As String = ""

        For Each chkItem As System.Web.UI.WebControls.ListItem In Session("NegotiationOptionsConsumer_options").chkColumns.Items
            If chkItem.Selected = True Then
                strNames += chkItem.Value & ","
            End If
        Next

        If strNames.Length < 1 Then
            strNames = ViewState("DisplayColumns")
        Else
            strNames = strNames.Substring(0, strNames.Length - 1)
            ViewState("DisplayColumns") = strNames
        End If

        Return strNames
    End Function

    Private Function GetGridDataTable(ByVal FilterList As List(Of String)) As DataTable
        Dim dtData As New DataTable
        Dim sqlWhere As String = ""
        Dim sqlSelect As String = ""
        Dim sSQL As String = ""
        Dim sColumns As String = GetCheckedColumns()

        Try
            If Me.GroupingColumn.ToString = "" Then
                sqlSelect = "SELECT " & sColumns & Space(1)
            Else
                sqlSelect = "SELECT " & Me.GroupingColumn.ToString & ", " & sColumns.Replace("," & Me.GroupingColumn, "") & Space(1)
            End If

            For Each sFilter As String In FilterList
                sqlWhere += sFilter & " OR "
            Next

            sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 4)
            sqlSelect += "FROM [vwNegotiationDistributionSource] WHERE " & sqlWhere


            If Me.GroupingColumn.ToString = "" Then
                sqlSelect += " GROUP BY " & sColumns

                If ViewState("SortColumn") IsNot Nothing Then
                    Dim strDir As String = ViewState("SortDirection")
                    sqlSelect += " ORDER BY " & ViewState("SortColumn") & Space(1) & IIf(strDir = 1, "DESC", "ASC") & ", " & sColumns
                Else
                    sqlSelect += " ORDER BY " & sColumns
                End If
            Else
                sqlSelect += " GROUP BY " & Me.GroupingColumn & ", " & sColumns.Replace("," & Me.GroupingColumn, "")

                If ViewState("SortColumn") IsNot Nothing Then
                    Dim strDir As String = ViewState("SortDirection")
                    If Me.GroupingColumn <> ViewState("SortColumn") Then
                        sqlSelect += " ORDER BY " & Me.GroupingColumn & ", " & ViewState("SortColumn") & Space(1) & IIf(strDir = 1, "DESC", "ASC")
                    Else
                        sqlSelect += " ORDER BY " & Me.GroupingColumn & Space(1) & IIf(strDir = 1, "DESC", "ASC")
                    End If
                End If
            End If

            Dim dtTemp As New DataTable

            'CacheHelper.WaitForCache("vwNegotiationDistributionSource")
            Using dsTemp = New SqlClient.SqlDataAdapter(sqlSelect, sConn)
                dsTemp.fill(dtTemp)
            End Using

            Return dtTemp
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Private Sub BindGrid()
        Try
            gridData.DataSourceID = "dsData"
            gridData.DataBind()

            SetWebPartVisibility()
        Catch ex As Exception
            Response.Write(ex.Message)
        End Try
    End Sub

    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String
        Dim sChars() As Char = strToChange.ToCharArray()
        Dim strNew As String = ""

        For Each c As Char In sChars
            Select Case Asc(c)
                Case 65 To 95   'upper caps
                    strNew += Space(1) & c.ToString
                Case 97 To 122  'lower caps
                    strNew += c.ToString
            End Select
        Next

        Return strNew.Trim
    End Function
#End Region

#Region "Grid Events"
    Protected Sub gridData_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gridData.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow

            Case DataControlRowType.Pager
                e.Row.Cells(0).ColumnSpan = gridData.Columns.Count + 1
                'load page count drop down
                Dim ddlCurrentPage As DropDownList = DirectCast(e.Row.FindControl("ddlPage"), DropDownList)
                For i As Integer = 1 To Me.gridData.PageCount
                    Dim lTemp As New System.Web.UI.WebControls.ListItem()
                    If i - 1 = Me.gridData.PageIndex Then
                        lTemp.Text = i
                        lTemp.Value = i
                        lTemp.Selected = True
                    Else
                        lTemp.Text = i
                        lTemp.Value = i
                        lTemp.Selected = False
                    End If
                    ddlCurrentPage.Items.Add(lTemp)
                Next

                'set current page
                Dim ddlSize As DropDownList = DirectCast(e.Row.FindControl("ddlPageSize"), DropDownList)
                ddlSize.SelectedIndex = ViewState("PagingSizeIndex")

                'set total pages
                Dim lblPageCount As Label = DirectCast(e.Row.FindControl("lblPageCount"), Label)
                lblPageCount.Text = Me.gridData.PageCount


                'set group drop down
                Dim DisplayColumn As String() = Me.GetCheckedColumns.ToString.Split(",")
                Dim ddlGroup As DropDownList = DirectCast(e.Row.FindControl("ddlGroupBy"), DropDownList)

                Try
                    ddlGroup.Items.Clear()
                    For Each s As String In DisplayColumn
                        Dim g As New System.Web.UI.WebControls.ListItem
                        g.Text = Me.InsertSpaceAfterCap(s).Replace("I D", "ID").Replace("S S N", "SSN").Replace("S D A", "SDA")
                        g.Value = s
                        If s = ViewState("GroupingColumn") Then
                            g.Selected = True
                        End If
                        ddlGroup.Items.Add(g)
                    Next
                Catch ex As Exception
                    Exit Sub
                End Try
        End Select
    End Sub

    Protected Sub ddlPage_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddlCurrentPage As DropDownList = DirectCast(sender, DropDownList)

        Me.gridData.PageIndex = ddlCurrentPage.SelectedValue - 1
        Me.GroupingColumn = ViewState("GroupingColumn")

        BindParentGrid(BuildParentSQL)
    End Sub

    Protected Sub gridData_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gridData.RowDataBound
        Dim gridView As GridView = DirectCast(sender, GridView)

        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim cellIndex As Integer = -1

                For Each field As DataControlField In gridView.Columns
                    'If field.HeaderText.ToString <> "" Then
                    e.Row.Cells(gridView.Columns.IndexOf(field)).CssClass = "headerstyle"
                    If field.SortExpression = gridView.SortExpression Then
                        cellIndex = gridView.Columns.IndexOf(field)
                    End If
                    'End If
                Next

                If cellIndex > -1 Then
                    ' this is a header row, set the sort style 
                    e.Row.Cells(cellIndex).CssClass = IIf(gridView.SortDirection = SortDirection.Ascending, "sortascheaderstyle", "sortdescheaderstyle")
                End If

                Dim lbl As Label = e.Row.FindControl("lblGroupName")

                lbl.Text = Me.InsertSpaceAfterCap(Me.GroupingColumn)

            Case DataControlRowType.DataRow
                'find control in template col
                Dim text As String = DirectCast(e.Row.FindControl("lblGroup"), Label).Text
                'get num of cols for colspan
                Dim intCols As Integer = e.Row.Cells.Count
                Dim tNames As String = ""

                'build list of col names excluding group header
                tNames = GetCheckedColumns()
                Dim colNames As String() = tNames.Split(",")

                If htLookUp.Contains(text) = False Then
                    'if not in lookup table, new group add
                    htLookUp.Add(text, DBNull.Value)

                    'create new gridview and assign filtered data
                    Dim sqlSelect As String, sqlWhere As String
                    DisplayColumns = Me.GetCheckedColumns '.Replace("ApplicantState,", "isnull(ApplicantState,'NON-US') as [ApplicantState],")

                    For i As Integer = 0 To Session("NegotiationOptionsConsumer_options").chkFilters.Items.Count - 1
                        If Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Selected Then
                            sqlWhere += Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Value & " OR "
                        End If
                    Next

                    sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 4)
                    sqlWhere += " AND " & GroupingColumn & " = '" & text & "'"
                    sqlSelect = "stp_NegotiationPreviewGroupDetail '" & DisplayColumns.Replace("'", "''") & "','" & sqlWhere.Replace("'", "''") & "',1,100"
                    ViewState("gridSQL") = sqlSelect

                    Using da = New SqlClient.SqlDataAdapter(sqlSelect, Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                        Dim dt As New DataTable
                        da.fill(dt)

                        Dim gv As GridView = e.Row.FindControl("gvChild")
                        For i As Integer = 1 To gv.Columns.Count - 1
                            gv.Columns.RemoveAt(i)
                        Next
                        Me.BuildGrid(DisplayColumns, gv)
                        gv.PageSize = 50
                        gv.AllowPaging = True
                        gv.AllowSorting = True
                        gv.DataSource = dt
                        gv.DataBind()
                    End Using

                    'span cols
                    e.Row.Cells(0).ColumnSpan = intCols

                    'turn off other cells
                    For i As Integer = 1 To e.Row.Cells.Count - 1
                        e.Row.Cells(i).Visible = False
                    Next
                Else
                    'turn of other rows
                    For i As Integer = 0 To e.Row.Cells.Count - 1
                        e.Row.Cells(i).Visible = False
                    Next
                End If
        End Select
    End Sub

    Protected Sub ddlPageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddlSize As DropDownList = DirectCast(sender, DropDownList)
        Me.gridData.PageSize = ddlSize.SelectedValue
        Me.GroupingColumn = ViewState("GroupingColumn")
        ViewState("PagingSizeIndex") = ddlSize.SelectedIndex
        BindParentGrid(BuildParentSQL)
    End Sub

    Protected Sub gridData_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gridData.Sorting
        ViewState("SortColumn") = e.SortExpression
        ViewState("SortDirection") = e.SortDirection

        Me.GroupingColumn = ViewState("GroupingColumn")

        Dim listFilters As New List(Of String)
        For i As Integer = 0 To Session("NegotiationOptionsConsumer_options").chkFilters.Items.Count - 1
            If Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Selected Then
                listFilters.Add(Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Value)
            End If
        Next
    End Sub
#End Region

#Region "Custom Controls Events"
    Protected Sub gvChild_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        Dim gv As GridView = DirectCast(sender, GridView)
        Dim newpage As Integer = e.NewPageIndex + 1
        Dim sqlSelect As String = ViewState("gridSQL").ToString.Replace("1,100", newpage & ",100")
        ViewState("gridPagingSQL") = sqlSelect
        gv.PageIndex = e.NewPageIndex

        'get group value
        Dim lbl As Label = Nothing
        For Each c As Control In gv.Parent.Parent.Controls
            If c.ID = "pnlGroup" Then
                For Each l As Control In c.Controls
                    If l.ID = "lblGroup" Then
                        lbl = DirectCast(l, Label)
                    End If
                Next
            End If
        Next

        'parse group sql
        Dim iLastEqual As Integer = sqlSelect.LastIndexOf("=") + 1
        Dim iNextComma As Integer = sqlSelect.IndexOf(",", iLastEqual) - 1
        Dim sGroupValue As String = sqlSelect.Substring(iLastEqual, iNextComma - iLastEqual)
        sGroupValue = sGroupValue.Replace("'", "").Trim
        sqlSelect = sqlSelect.Replace(sGroupValue, lbl.Text)

        Using da = New SqlClient.SqlDataAdapter(sqlSelect, Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim dt As New DataTable
            da.fill(dt)
            gv.DataSource = dt
            gv.DataBind()
        End Using
    End Sub

    Protected Sub ddlGroupBy_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.updPreview.Update()
        Dim ddl As DropDownList = DirectCast(sender, DropDownList)
        Dim sqlWhere As String = ""
        Dim sqlSelect As String = ""

        ViewState("GroupingColumn") = ddl.SelectedValue
        ViewState("ShowGroupingIndex") = ddl.SelectedIndex
        Me.GroupingColumn = ViewState("GroupingColumn")


        sqlSelect = "SELECT Distinct " & GroupingColumn & " as [GroupHdr] "
        sqlSelect = sqlSelect.Replace("ApplicantState,", "isnull(ApplicantState,'NON-US') as [ApplicantState],")
        For i As Integer = 0 To Session("NegotiationOptionsConsumer_options").chkFilters.Items.Count - 1
            If Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Selected Then
                sqlWhere += Session("NegotiationOptionsConsumer_options").chkFilters.Items(i).Value & " OR "
            End If
        Next
        sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 4)
        sqlSelect += "FROM [vwNegotiationDistributionSource] WHERE " & sqlWhere
        sqlSelect += " ORDER BY " & GroupingColumn

        dsData.SelectCommand = sqlSelect

        'CacheHelper.WaitForCache("vwNegotiationDistributionSource")
        dsData.DataBind()

        Me.gridData.DataSourceID = dsData.ID
        Me.gridData.DataBind()

        SetWebPartVisibility()
    End Sub

    Protected Sub gvChild_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow

            Case DataControlRowType.Header
                For Each c As TableCell In e.Row.Cells
                    Try
                        Dim lnk As LinkButton = DirectCast(c.Controls(0), LinkButton)
                        lnk.Text = Me.InsertSpaceAfterCap(lnk.Text).Replace("I D", "ID").Replace("S S N", "SSN").Replace("S D A", "SDA")
                    Catch ex As Exception
                        Continue For
                    End Try
                Next
        End Select
    End Sub

    Protected Sub gvChild_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)
        Dim gv As GridView = DirectCast(sender, GridView)
        Dim sqlSelect As String = ViewState("gridSQL")

        'get group value
        Dim lbl As Label = Nothing
        For Each c As Control In gv.Parent.Parent.Controls
            If c.ID = "pnlGroup" Then
                For Each l As Control In c.Controls
                    If l.ID = "lblGroup" Then
                        lbl = DirectCast(l, Label)
                    End If
                Next
            End If
        Next

        'parse group sql
        Dim iLastEqual As Integer = sqlSelect.LastIndexOf("=") + 1
        Dim iNextComma As Integer = sqlSelect.IndexOf(",", iLastEqual) - 1
        Dim sGroupValue As String = sqlSelect.Substring(iLastEqual, iNextComma - iLastEqual)
        sGroupValue = sGroupValue.Replace("'", "").Trim
        sqlSelect = sqlSelect.Replace(sGroupValue, lbl.Text)

        Using da = New SqlClient.SqlDataAdapter(sqlSelect, Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim dt As New DataTable
            da.fill(dt)

            If Not dt Is Nothing Then
                Dim dv As New DataView(dt)
                dv.Sort = e.SortExpression & " " & Me.ConvertSortDirectionToSql(e.SortDirection)
                gv.DataSource = dv
                gv.DataBind()
            End If
        End Using
    End Sub

    Private Function ConvertSortDirectionToSql(ByVal sortDirection As SortDirection) As String
        Dim newSortDirection As String = String.Empty

        Select Case sortDirection
            Case sortDirection.Ascending
                newSortDirection = "ASC"
            Case sortDirection.Descending
                newSortDirection = "DESC"
        End Select

        Return newSortDirection
    End Function

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload
        dsPreview = Nothing
    End Sub
#End Region

#Region "WebPart Connections"
    <ConnectionConsumer("Negotiation Options Consumer", "NegotiationOptionsConsumer")> _
    Public Sub ConsumeNegotiationOptions(ByVal options As wNegotiationOptions)
        If Not options.Options.chkColumns Is Nothing Then
            Session("NegotiationOptionsConsumer_options") = options.Options

            Me.updPreview.Update()
            BindParentGrid(BuildParentSQL)
        End If
    End Sub
#End Region

End Class