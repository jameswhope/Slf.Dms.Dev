Imports System.Collections.Generic
Imports System.Data
Imports System
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.ComponentModel
Imports System.ComponentModel.Design
Imports System.IO
Imports iTextSharp.text.PageSize
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Partial Class PreviewControl
    Inherits System.Web.UI.UserControl
    Private dsPreview As DataSet
#Region "Declares"
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
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Me.accOptions.FindControl("nothing")
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        sConn = System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString

        LoadDS()
        If Not IsPostBack Then
            LoadEntityTypes()
            LoadColumns()
            'CacheView()
            Me.lstEntity.Enabled = False
            Me.lstEntity.Visible = False
        End If

    End Sub
    Protected Sub btnView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnView.Click
        Me.updPreview.Update()
        BindParentGrid(BuildParentSQL)
    End Sub
    Protected Sub rblType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        Me.updPreview.Update()

        Me.dsData.SelectCommand = ""

        Me.gridData.DataSourceID = ""
        Me.gridData.DataSource = Nothing

        Me.chkFilters.Items.Clear()

        Select Case rblType.SelectedValue.ToLower
            Case "master list"
                Me.lstEntity.Enabled = False
                Me.lstEntity.Visible = False
                Me.EntityID = "master"
                LoadFilters()
            Case Else
                GetEntities(rblType.SelectedValue)
                Me.lstEntity.Enabled = True
                Me.lstEntity.Visible = True
        End Select


    End Sub
    Protected Sub lstEntity_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstEntity.SelectedIndexChanged
        Me.updPreview.Update()
        Me.EntityID = DirectCast(sender, ListBox).SelectedValue
        LoadFilters()
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
    'Private Sub CacheView()
    '    Using sqlCMD = New SqlClient.SqlCommand("stp_CacheView 'vwNegotiationDistributionSource','tblCache_PreviewGrid'", New SqlClient.SqlConnection(Configuration.ConfigurationManager.AppSettings("connectionstring").ToString))
    '        sqlCMD.CommandTimeout = 300     '10.8.2008.ug
    '        sqlCMD.connection.open()
    '        sqlCMD.ExecuteNonQuery()
    '    End Using
    'End Sub
    Private Function BuildParentSQL() As String
        Dim sqlWhere As String = ""
        Dim sqlSelect As String = ""
        Dim sSQL As String = ""

        Try

            GroupingColumn = Me.radGroups.SelectedValue
            ViewState("GroupingColumn") = GroupingColumn
            ViewState("ShowGroupingIndex") = Me.radGroupShow.SelectedIndex

            For i As Integer = 0 To Me.chkFilters.Items.Count - 1
                If Me.chkFilters.Items(i).Selected Then
                    sqlWhere += Me.chkFilters.Items(i).Value & " OR "
                End If
            Next
            sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 4)
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
    End Sub
    Private Sub BindParentGrid()
        dsData.DataBind()
        Me.gridData.DataSourceID = dsData.ID
        Me.gridData.DataBind()
    End Sub
    Private Sub LoadColumns()

        Dim dtColumns As DataTable = dsPreview.Tables("Columns")

        Try

            chkColumns.Items.Clear()
            chkColumns.DataTextField = "Column_Name"
            chkColumns.DataValueField = "Column_Name"
            chkColumns.DataSource = dtColumns
            chkColumns.DataBind()

            For Each tItem As System.Web.UI.WebControls.ListItem In chkColumns.Items
                Dim strText As String = tItem.Text
                tItem.Text = Me.InsertSpaceAfterCap(strText).Replace("I D", "ID").Replace("S S N", "SSN").Replace("S D A", "SDA")
                tItem.Selected = True
            Next

            radGroups.DataTextField = "Column_Name"
            radGroups.DataValueField = "Column_Name"
            radGroups.DataSource = dtColumns
            radGroups.DataBind()

            For Each tItem As System.Web.UI.WebControls.ListItem In radGroups.Items
                Dim strText As String = tItem.Text
                tItem.Text = Me.InsertSpaceAfterCap(strText).Replace("I D", "ID").Replace("S S N", "SSN").Replace("S D A", "SDA")
            Next

            radGroups.SelectedIndex = 6

        Catch ex As Exception

        Finally
            dtColumns.Dispose()
            dtColumns = Nothing

        End Try
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

        For Each chkItem As System.Web.UI.WebControls.ListItem In Me.chkColumns.Items
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
        hlf.DataNavigateUrlFormatString = "settlement.aspx?id={0}&aid={1}"
        GridToBuild.Columns.Insert(0, hlf)

    End Sub
    Sub ServerValidationCheckFilters(ByVal source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = False

        For i As Integer = 0 To chkFilters.Items.Count - 1
            If chkFilters.Items(i).Selected Then
                args.IsValid = True
                Exit Sub
            End If
        Next

    End Sub
    Private Function GetCheckedColumns() As String
        Dim strNames As String = ""
        For Each chkItem As System.Web.UI.WebControls.ListItem In Me.chkColumns.Items
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
            Using dsTemp = New SqlClient.SqlDataAdapter(sqlSelect, sConn)
                dsTemp.SelectCommand.CommandTimeout = 240
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
        Catch ex As Exception
            Response.Write(ex.Message)
        End Try

    End Sub
    Public Sub LoadFilters()
        Dim filterExp As String
        Select Case Me.EntityID
            Case "master"
                filterExp = "filterType = 'root'"
            Case Else
                Dim sFilters As String = GetFilters(Me.EntityID)
                filterExp = "FilterID in (" & sFilters & ")"
        End Select
        Dim rowsFilters As DataRow() = dsPreview.Tables("Filters").Select(filterExp)

        chkFilters.Items.Clear()

        If rowsFilters.Length > 0 Then
            For Each row As DataRow In rowsFilters
                Dim l As New System.Web.UI.WebControls.ListItem(row(2), row(3), True)
                l.Selected = True
                chkFilters.Items.Add(l)
            Next
            Me.btnView.Enabled = True
        Else
            chkFilters.Items.Add("No filters available")
            Me.btnView.Enabled = False
        End If



    End Sub
    Private Function GetFilters(ByVal entityID As String) As String
        Dim list As New List(Of String)()

        list.Add("-1")

        Using cmd As New SqlClient.SqlCommand("SELECT isnull(FilterID, 0) as FilterID FROM tblNegotiationFilterXref WHERE Deleted = 0 and EntityID = " & entityID, New SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlClient.SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        list.Add(reader("FilterID"))
                    End While
                End Using
            End Using
        End Using

        AddChildFiltersRec(list, entityID)

        Return String.Join(",", list.ToArray())
    End Function

    Private Sub AddChildFiltersRec(ByRef list As List(Of String), ByVal entityID As String)
        Dim ids As New List(Of String)

        Using cmd As New SqlClient.SqlCommand("SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE ParentNegotiationEntityID = " & entityID, New SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlClient.SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ids.Add(reader("NegotiationEntityID"))
                    End While
                End Using
            End Using
        End Using

        If ids.Count > 0 Then
            Using cmd As New SqlClient.SqlCommand("SELECT isnull(xr.FilterID, 0) as FilterID FROM tblNegotiationFilterXref as xr inner join tblNegotiationFilters as nf on nf.FilterID = xr.FilterID WHERE xr.Deleted = 0 and nf.Deleted = 0 and nf.FilterType = 'leaf' and xr.EntityID in (" & String.Join(", ", ids.ToArray()) & ")", New SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlClient.SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            If Not list.Contains(reader("FilterID")) Then
                                list.Add(reader("FilterID"))
                            End If
                        End While
                    End Using
                End Using
            End Using

            For Each id As Integer In ids
                AddChildFiltersRec(list, id)
            Next
        End If
    End Sub


    Private Sub LoadEntityTypes()

        Dim dtEntity As DataTable = dsPreview.Tables("EntityType")

        rblType.DataTextField = "Type"
        rblType.DataValueField = "Type"
        rblType.DataSource = dtEntity
        rblType.DataBind()

        dtEntity.Dispose()
        dtEntity = Nothing
    End Sub
    Private Sub GetEntities(ByVal eType As String)
        Dim filterExp As String = "Type = '" & eType & "'"
        Dim rowsEntities As DataRow() = dsPreview.Tables("Entities").Select(filterExp)

        lstEntity.Items.Clear()
        lstEntity.Visible = True

        For Each row As DataRow In rowsEntities
            Dim l As New System.Web.UI.WebControls.ListItem(row(0), row(1))
            lstEntity.Items.Add(l)
        Next

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
                'moved to child control
                'Try
                '    Dim lnk As LinkButton = e.Row.FindControl("lnkNegotiate")
                '    lnk.CommandArgument = e.Row.RowIndex
                'Catch ex As Exception
                '    Exit Select
                'End Try

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
                    For i As Integer = 0 To Me.chkFilters.Items.Count - 1
                        If Me.chkFilters.Items(i).Selected Then
                            sqlWhere += Me.chkFilters.Items(i).Value & " OR "
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
        For i As Integer = 0 To Me.chkFilters.Items.Count - 1
            If Me.chkFilters.Items(i).Selected Then
                listFilters.Add(Me.chkFilters.Items(i).Value)
            End If
        Next

        'GetGridData(listFilters, e.SortExpression, e.SortDirection)
        'BindGrid()

    End Sub
#End Region
#Region "Export To Excel"
    Protected Sub btnExcel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
        GroupingColumn = Me.radGroups.SelectedValue
        ViewState("GroupingColumn") = GroupingColumn

        Dim listFilters As New List(Of String)
        For i As Integer = 0 To Me.chkFilters.Items.Count - 1
            If Me.chkFilters.Items(i).Selected Then
                listFilters.Add(Me.chkFilters.Items(i).Value)
            End If
        Next

        If listFilters.Count < 1 Then Exit Sub

        Dim dtData As DataTable = Me.GetGridDataTable(listFilters)

        Export("c:\" & BuildFileName(), dtData)
        Catch ex As Exception
            Response.Write(ex.Message)
        End Try

    End Sub
    Public Function BuildFileName() As String
        Try
            Dim strFileName As String = ""

            Select Case Me.rblType.SelectedItem.Text.ToLower
                Case "master list"
                    strFileName += "Master_List"
                Case Else
                    strFileName += Me.lstEntity.SelectedItem.Text.Replace(" ", "_").Replace("-", "_").Replace("'", "_")
            End Select

            For Each chk As System.Web.UI.WebControls.ListItem In Me.chkFilters.Items
                If chk.Selected Then
                    strFileName += "_" & chk.Text.Replace(" ", "_").Replace("-", "_").Replace("'", "_")
                End If
            Next

            strFileName = strFileName.Replace("__", "_")

            If Right(strFileName, 1) <> "_" Then
                strFileName += "_" & Format(Now, "MMddyyyy") & ".xls"
            Else
                strFileName += Format(Now, "MMddyyyy") & ".xls"
            End If

            Return strFileName
        Catch ex As Exception
            Return "NegotiationsData"
        End Try



    End Function
    Public Shared Sub Export(ByVal fileName As String, ByVal dataTable As DataTable)
        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}", fileName))
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        Dim sw As StringWriter = New StringWriter
        Dim htw As HtmlTextWriter = New HtmlTextWriter(sw)

        '  Create a form to contain the grid
        Dim table As System.Web.UI.WebControls.Table = New System.Web.UI.WebControls.Table
        'table.GridLines = gv.GridLines

        Dim trow As New System.Web.UI.WebControls.TableRow
        For i As Integer = 0 To dataTable.Columns.Count - 1
            Dim tcell As New TableCell
            tcell.Text = dataTable.Columns(i).ColumnName
            trow.Cells.Add(tcell)
        Next
        table.Rows.Add(trow)

        '  add each of the data rows to the table
        For Each row As DataRow In dataTable.Rows
            Dim nrow As New System.Web.UI.WebControls.TableRow
            For i As Integer = 0 To dataTable.Columns.Count - 1
                Dim tcell As New TableCell
                tcell.Attributes.Add("class", "text")
                tcell.Text = row.Item(i).ToString
                nrow.Cells.Add(tcell)
            Next
            table.Rows.Add(nrow)
        Next

        ''  add the footer row to the table
        'If (Not (gv.FooterRow) Is Nothing) Then
        '    PrepareControlForExport(gv.FooterRow)
        '    table.Rows.Add(gv.FooterRow)
        'End If
        '  render the table into the htmlwriter
        table.RenderControl(htw)
        '  render the htmlwriter into the response
        Dim strStyle As String = "<style>.text { mso-number-format:\@; } </style>"
        HttpContext.Current.Response.Write(strStyle)
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    ' Replace any of the contained controls with literals
    Private Shared Sub PrepareControlForExport(ByVal control As Control)
        Dim i As Integer = 0
        Do While (i < control.Controls.Count)
            Dim current As Control = control.Controls(i)
            If (TypeOf current Is LinkButton) Then
                control.Controls.Remove(current)
                control.Controls.AddAt(i, New LiteralControl(CType(current, LinkButton).Text))
            ElseIf (TypeOf current Is ImageButton) Then
                control.Controls.Remove(current)
                control.Controls.AddAt(i, New LiteralControl(CType(current, ImageButton).AlternateText))
            ElseIf (TypeOf current Is HyperLink) Then
                control.Controls.Remove(current)
                control.Controls.AddAt(i, New LiteralControl(CType(current, HyperLink).Text))
            ElseIf (TypeOf current Is DropDownList) Then
                control.Controls.Remove(current)
                control.Controls.AddAt(i, New LiteralControl(CType(current, DropDownList).SelectedItem.Text))
            ElseIf (TypeOf current Is CheckBox) Then
                control.Controls.Remove(current)
                control.Controls.AddAt(i, New LiteralControl(CType(current, CheckBox).Checked))
                'TODO: Warning!!!, inline IF is not supported ?
            End If
            If current.HasControls Then
                PrepareControlForExport(current)
            End If
            i = (i + 1)
        Loop
    End Sub
#End Region
#Region "Export to PDF"
    Protected Sub btnPDF_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim listFilters As New List(Of String)

        GroupingColumn = Me.radGroups.SelectedValue
        ViewState("GroupingColumn") = GroupingColumn

        For i As Integer = 0 To Me.chkFilters.Items.Count - 1
            If Me.chkFilters.Items(i).Selected Then
                listFilters.Add(Me.chkFilters.Items(i).Value)
            End If
        Next

        If listFilters.Count < 1 Then Exit Sub

        Dim dtData As DataTable = Me.GetGridDataTable(listFilters)
        ExportPDF(dtData)
    End Sub
    Private Sub ExportPDF(ByVal dataTable As DataTable)

        Dim r As New iTextSharp.text.Rectangle(8, 11)

        Dim pdfReport As New iTextSharp.text.Document(r.Rotate())
        Dim msReport As New System.IO.MemoryStream()
        Dim writer As PdfWriter = PdfWriter.GetInstance(pdfReport, msReport)

        pdfReport.Open()


        ' Creates the Table 

        Dim ptData As New PdfPTable(dataTable.Columns.Count)
        ptData.SpacingBefore = 8
        ptData.DefaultCell.Padding = 1

        Dim headerwidths As Single() = New Single(dataTable.Columns.Count - 1) {}
        For intK As Integer = 0 To dataTable.Columns.Count - 1
            ' percentage 
            If dataTable.Columns(intK).ColumnName.ToString().ToUpper().Contains("DESC") Then
                headerwidths(intK) = (100 / (dataTable.Columns.Count + 2)) * 3
            Else
                headerwidths(intK) = 100 / (dataTable.Columns.Count + 2)
            End If
        Next
        ptData.SetWidths(headerwidths)
        ptData.WidthPercentage = 100
        ptData.DefaultCell.HorizontalAlignment = Element.ALIGN_JUSTIFIED
        ptData.DefaultCell.VerticalAlignment = Element.ALIGN_MIDDLE
        For intK As Integer = 0 To dataTable.Columns.Count - 1

            'Insert the Table Headers 
            Dim cell As New PdfPCell()
            cell.BorderWidth = 0.001F
            cell.BackgroundColor = New Color(200, 200, 200)
            cell.BorderColor = New Color(100, 100, 100)
            cell.Phrase = New Phrase(dataTable.Columns(intK).ColumnName.ToString(), FontFactory.GetFont("TIMES_ROMAN", BaseFont.WINANSI, 8, Font.BOLD))
            ptData.AddCell(cell)
        Next

        ptData.HeaderRows = 1
        For intJ As Integer = 0 To dataTable.Rows.Count - 1
            ' this is the end of the table header 
            'Insert the Table Data 

            For intK As Integer = 0 To dataTable.Columns.Count - 1
                Dim cell As New PdfPCell()
                cell.BorderWidth = 0.001F
                cell.BorderColor = New Color(100, 100, 100)
                cell.BackgroundColor = New Color(250, 250, 250)
                cell.Phrase = New Phrase(dataTable.Rows(intJ).Item(intK).ToString(), FontFactory.GetFont("TIMES_ROMAN", BaseFont.WINANSI, 8))
                ptData.AddCell(cell)
            Next
        Next


        'Insert the Table 

        pdfReport.Add(ptData)

        'Closes the Report and writes to Memory Stream 

        pdfReport.Close()

        'Writes the Memory Stream Data to Response Object 

        Response.Clear()
        Response.AppendHeader("content-disposition", "attachment;filename=Export.pdf")
        Response.Charset = ""
        Response.ContentType = "application/pdf"
        Response.BinaryWrite(msReport.ToArray())
        Response.[End]()

    End Sub
#End Region
#Region "Custom Controls Events"
   
    
#End Region

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
    Protected Sub gvChild_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        'Select Case e.CommandName
        '    Case "Select"
        '        Me.updPreview.Update()
        '        Dim gv As GridView = DirectCast(sender, GridView)
        '        Dim settArgs As String() = e.CommandArgument.ToString.Split(":")

        '        If settArgs(0).ToString <> "" And settArgs(1).ToString <> "" Then
        '            sc.LoadSettlementData(settArgs(0), settArgs(1), UserID)
        '            Me.mdlPopup.Show()
        '        Else
        '            lblError.ForeColor = System.Drawing.Color.Red
        '            lblError.Text = "Account ID is a required field to negotiate this account."
        '        End If
        'End Select
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
        For i As Integer = 0 To Me.chkFilters.Items.Count - 1
            If Me.chkFilters.Items(i).Selected Then
                sqlWhere += Me.chkFilters.Items(i).Value & " OR "
            End If
        Next
        sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 4)
        sqlSelect += "FROM [vwNegotiationDistributionSource] WHERE " & sqlWhere
        sqlSelect += " ORDER BY " & GroupingColumn

        dsData.SelectCommand = sqlSelect
        dsData.DataBind()

        Me.gridData.DataSourceID = dsData.ID
        Me.gridData.DataBind()
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
        Dim dt As DataTable = gv.DataSource
        If Not IsNothing(dt) Then
            Dim dv As New DataView(dt)
            dv.Sort = e.SortExpression & " " & Me.ConvertSortDirectionToSql(e.SortDirection)
            gv.DataSource = dv
            gv.DataBind()
        End If

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

    Protected Sub gvChild_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        
    End Sub
    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload
        dsPreview = Nothing
    End Sub
    Public Overridable Sub VerifyRenderingInServerForm(ByVal control As Control)

    End Sub
End Class
