Imports Drg.Util.DataAccess

Imports Lexxiom.BusinessServices
Imports Lexxiom.BusinessData
Imports System.Drawing
Imports System.Text
Imports System.Data
Imports System.Data.SqlClient

Partial Class Clients_client_creditors_mediation_usercontrol_criteriaBuilder
    Inherits System.Web.UI.UserControl

    Dim bsCriteriaBuilder As Lexxiom.BusinessServices.CriteriaBuilder = New Lexxiom.BusinessServices.CriteriaBuilder()
    Dim bsCriteriaDashBoard As Lexxiom.BusinessServices.CriteriaDashBoard = New Lexxiom.BusinessServices.CriteriaDashBoard()
    Dim sNegotiationLookupFields As String = "" & System.Configuration.ConfigurationManager.AppSettings("NegotiationFieldLookup").ToString
    Dim sNegotiationToken As String = "" & System.Configuration.ConfigurationManager.AppSettings("NegotiationCriteriaToken").ToString
    Public arDashBoardItems As ArrayList = New ArrayList
    Dim sQueryCriteriaId As String = "0"
    Dim sMasterEditPreview As String = ""
    Dim sFilterType As String = ""
    Dim sEntityId As String = "0"
    Dim UserId As Integer
    Dim bUcLoad As Boolean = False

    Public Property LoadFlag() As Boolean
        Get
            Return bUcLoad
        End Get
        Set(ByVal value As Boolean)
            bUcLoad = value
        End Set
    End Property

    ''' <summary>
    ''' Page Load Event
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                 GlobalFiles.JQuery.UI, _
                                                 "~/jquery/json2.js", _
                                                 "~/jquery/jquery.modaldialog.js" _
                                                 })
        Try
            GetParameters()
            SetFilterType()
            If (Not Page.IsPostBack AndAlso Not bUcLoad) Then
                ClearMsg()
                ShowFilter()
                LoadFilters(0)
            End If
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub GetParameters()

        If Not Request.QueryString("CriteriaId") Is Nothing Then
            sQueryCriteriaId = Request.QueryString("criteriaId")
        End If

        If Not Request.QueryString("filter") Is Nothing Then
            sFilterType = Request.QueryString("filter")
        End If

        If Not Request.QueryString("entityId") Is Nothing Then
            sEntityId = Request.QueryString("entityId")
            sFilterType = "stem"
        End If

        UserId = Integer.Parse(Page.User.Identity.Name)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub SetFilterType()
        Select Case sFilterType.Trim().ToLower
            Case "root"
                rdList.SelectedIndex = -1
                rdList.SelectedIndex = 0
            Case "stem"
                rdList.SelectedIndex = -1
                rdList.SelectedIndex = 1
            Case Else
                If (sQueryCriteriaId <> "0") Then
                    rdList.SelectedIndex = -1
                    rdList.SelectedIndex = 1
                Else
                    rdList.SelectedIndex = -1
                    rdList.SelectedIndex = 0
                End If
        End Select
    End Sub


#Region "PAGE BUTTON EVENTS"

    ''' <summary>
    ''' Adds/Updates Criteria. 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub lnkAddCriteria_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddCriteria.Click
        Try
            ShowLoadProgress(True)
            ClearMsg()
            '****************************************************************
            ' Reference: #1 on flowchart
            '****************************************************************
            BuildFilterClause()
            DisablePreview()
            ShowPreviewGrid(False)
            ShowDashBoard(False)
            If ((lblFilter.Text.Trim() <> "") And (lblMsg.Text = "")) Then
                SelectedGridRow(grdView, -1)

                '****************************************************************
                ' Reference: #3 on flowchart
                '****************************************************************
                GetDashBoardSummary()
                If (InStr(lblMsg.Text.ToLower(), "overlap")) Then
                    DisablePreview()
                End If
            End If
        Catch ex As Exception
            ShowFilter(False)
            DisablePreview()
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' Cancel and Reset Controls.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub lnkbtnReset_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkbtnReset.Click
        '****************************************************************
        ' Reference: #9 on flowchart
        '****************************************************************
        ResetView()
        ShowFilter()
        SelectedGridRow(grdView, -1)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub lnkbtnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkbtnSave.Click
        Dim sClientRecord As String
        Dim sClientRecordCount As String
        Try
            ShowLoadProgress(True)
            ClearMsg()
            If ((lblDashBoard.Text.Trim() <> "") AndAlso (lblDashBoard.Text.Trim().IndexOf(",") > 0)) Then ' Check to see if there are records to be added
                sClientRecord = lblDashBoard.Text.Split(",")(0).Trim()
                sClientRecordCount = sClientRecord.Split(":")(1).Trim()
                If (sClientRecordCount = "0") Then Throw New Exception(BuildNoRecordMsg())
            End If
            SaveFilter()
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' Save Criteria Filters. 
    ''' </summary>
    ''' <param name="refreshFilter"></param>
    ''' <remarks></remarks>
    Protected Sub SaveFilter(Optional ByVal refreshFilter As Boolean = True)
        Dim dtNegotiationFilter As NegotiationData.NegotiationFilterDataDataTable = New NegotiationData.NegotiationFilterDataDataTable
        Dim dtRow As NegotiationData.NegotiationFilterDataRow = dtNegotiationFilter.NewNegotiationFilterDataRow
        Dim sfields As String = ""
        Dim strrdList As String = ""
        Dim iFilterId As Integer
        Dim intParentFilterId As Integer = 0
        Dim dsoverlap As DataSet = New DataSet

        Try
            strrdList = rdList.SelectedValue
            ResetBackColor(txtfilterName)

            '****************************************************************
            ' Reference: #7 on flowchart
            '****************************************************************
            If (txtfilterName.Text.Trim = "") Then
                SetBackColor(txtfilterName)
                Throw New Exception("Please enter Criteria/Filter Name")
            Else

                '****************************************************************
                ' Reference: #8 on flowchart
                '****************************************************************
                If (sEntityId.Trim() <> "0") Then txtfilterName.Text = "** " & txtfilterName.Text
                dtRow.Description = txtfilterName.Text.Trim()
                dtRow.FilterClause = lblFilter.Text.Trim()
                dtRow.FilterType = rdList.SelectedValue.ToLower().Trim()
                If (sQueryCriteriaId > 0) Then
                    intParentFilterId = CInt(sQueryCriteriaId)
                Else
                    intParentFilterId = CInt(sEntityId)
                End If
                dtRow.ParentFilterId = intParentFilterId
                dtRow.FilterText = lblFriendlyDisplay.Text.Trim()
                dtNegotiationFilter.AddNegotiationFilterDataRow(dtRow)
                If (txtEditId.Text <> "") Then
                    dtNegotiationFilter.AcceptChanges()
                    dtNegotiationFilter.Rows(0)("FilterId") = txtEditId.Text
                End If
                If (refreshFilter = True) Then
                    dsoverlap = bsCriteriaBuilder.Validate(dtNegotiationFilter)
                    If (dsoverlap.Tables(0).Rows.Count > 0) Then
                        AppendExclusion(dsoverlap.Tables(0))
                        GetAdjustedFilterClause(dsoverlap.Tables(0))
                        dtNegotiationFilter.Rows(0)("FilterClause") = lblFilter.Text.Trim()
                        dtNegotiationFilter.Rows(0)("FilterText") = lblFriendlyDisplay.Text.Trim()
                    End If
                End If

                iFilterId = bsCriteriaBuilder.Add(dtNegotiationFilter, UserId, CInt(sEntityId))

                If rdList.SelectedValue.ToLower().Trim() = "stem" Then
                    Dim dtMasterFilters As DataTable = bsCriteriaBuilder.GetEntityFilters(sEntityId, "base").Tables(0)

                    Using cmd As New SqlCommand("stp_NegotiationFilterInsertParentXref", ConnectionFactory.Create())
                        Using cmd.Connection
                            cmd.Connection.Open()

                            cmd.CommandType = CommandType.StoredProcedure

                            For Each row As DataRow In dtMasterFilters.Rows
                                cmd.Parameters.Clear()
                                cmd.Parameters.Add(New SqlParameter("FilterID", iFilterId))
                                cmd.Parameters.Add(New SqlParameter("ParentFilterID", row("ParentFilterID")))

                                cmd.ExecuteNonQuery()
                            Next
                        End Using
                    End Using
                End If

                If (iFilterId > 0) Then SaveFilterDetail(iFilterId)
                If (refreshFilter) Then ShowFilter()
                ResetView()
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub btnHide_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnHide.Click
        If (InStr(lblMsg.Text, "overlap") <= 0) Then ClearMsg()
        ShowPreviewGrid(False)
        PreviewOn(True)
        If (txtEditId.Text <> "") Then
            ShowFilter(False)
            DisablePreview()
            ResetFilterValues()
            If (lblFriendlyDisplay.Text = "") Then
                LoadFilters(0)
                txtEditId.Text = ""
                SelectedGridRow(grdView, -1)
            End If
        Else
            ShowFilter(True)
        End If
        ResetUpdateValues()
        ShowDashBoard(False)
        'LoadFilters(0)

    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub btnShowPreview_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnShowPreview.Click
        Try
            HasOverlapMsg()
            Dim sFilter As String
            Dim sfields As String = ""

            ShowDashBoard(False)
            PreviewOn(False)
            sFilter = lblFilter.Text
            LoadPreviewGrid(sFilter, 0)
            ShowPreviewGrid(True)
        Catch ex As Exception
            PreviewOn(True)
            ShowPreviewGrid(False)
            DisplayMsg(lblMsg, ex.Message, True)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub lnkHid_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkHid.Click
        HasOverlapMsg()
        ShowDashBoard(False)
        LoadFilters(0)
        SelectedGridRow(grdView, -1)
    End Sub

#End Region

#Region "LOAD FILTERS/CRITERIA"
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="maxCount"></param>
    ''' <remarks></remarks>
    Protected Sub LoadFilters(ByVal maxCount As Integer)
        Dim indx As Integer
        Dim arList As New ArrayList
        For indx = 0 To maxCount
            arList.Add(indx)
        Next
        rptFilters.DataSource = arList
        rptFilters.DataBind()
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function ShowAvailableFilters() As Data.DataTable
        Dim dsViewColumns As DataSet = New DataSet
        Dim dtFilterList As Data.DataTable = New Data.DataTable()
        Dim dtSingleFilter As Data.DataTable = New Data.DataTable()
        Dim dtColumn As Data.DataColumn = New Data.DataColumn()
        Dim dtRow, dtPct As Data.DataRow
        Dim sFieldName, sDataType As String
        Dim indx As Integer
        Dim intRowCount As Integer

        Try


            ClearMsg()
            dsViewColumns = bsCriteriaBuilder.GetViewColumns()
            If (dsViewColumns.Tables(0).Rows.Count > 0) Then
                intRowCount = dsViewColumns.Tables(0).Rows.Count - 1

                ' Add two columns
                dtFilterList.Columns.Add("FieldName")
                dtFilterList.Columns.Add("DataType")

                ' Add Fields for Percentage Computation
                dtSingleFilter.Columns.Add("FieldName")
                dtSingleFilter.Columns.Add("DataType")

                'Populate Filer RowData
                For indx = 0 To intRowCount
                    dtRow = dtFilterList.NewRow()
                    sFieldName = FormatFieldName(dsViewColumns.Tables(0).Rows(indx)("COLUMN_NAME"))
                    sDataType = TransformDataType(dsViewColumns.Tables(0).Rows(indx)("DATA_TYPE"))
                    If (sDataType.Trim() <> "") Then
                        sDataType = indx & ":" & sDataType & ":" & dsViewColumns.Tables(0).Rows(indx)("COLUMN_NAME")        'Iteration ID is added to distinctly identify selected Item.                            
                        dtRow("FieldName") = sFieldName
                        dtRow("DataType") = sDataType
                        dtFilterList.Rows.Add(dtRow)
                        If (GetDataType(sDataType).ToLower = "single") Then
                            dtPct = dtSingleFilter.NewRow
                            dtPct("FieldName") = sFieldName
                            dtPct("DataType") = sDataType
                            dtSingleFilter.Rows.Add(dtPct)
                        End If
                    End If
                Next
                Session("rptPct") = dtSingleFilter
                Session("rptItems") = dtFilterList
                Return dtFilterList
            Else
                Throw New Exception("Failed to retrive column names from distribution view.")
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sDataType"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function TransformDataType(ByVal sDataType As String) As String
        Dim sLocalDataType As String = ""
        Select Case sDataType.ToLower
            Case "money"
                sLocalDataType = "single"
            Case "int"
                sLocalDataType = "int32"
            Case "varchar"
                sLocalDataType = "string"
            Case "datetime"
                sLocalDataType = "datetime"
        End Select

        Return sLocalDataType

    End Function
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub rptFilters_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptFilters.ItemDataBound
        Dim drpName, drpFields As DropDownList
        Dim btnImageButton As ImageButton
        Dim dtFilters As New Data.DataTable

        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            btnImageButton = CType(e.Item.FindControl("btnImgRemove"), ImageButton)
            If (e.Item.ItemIndex = 0) Then btnImageButton.Visible = False

            drpName = CType(e.Item.FindControl("drpName"), DropDownList)
            If (Not Session("rptItems") Is Nothing) Then dtFilters = CType(Session("rptItems"), Data.DataTable)
            If dtFilters.Rows.Count <= 0 Then dtFilters = ShowAvailableFilters()

            drpName.DataSource = dtFilters.DefaultView
            drpName.DataTextField = "FieldName"
            drpName.DataValueField = "DataType"
            drpName.DataBind()
            If (drpName.Items.Count > 0) Then drpName.Items.Insert(0, New ListItem("-- Select Field Name --", "0"))
            dtFilters.Rows.Clear()

            drpFields = CType(e.Item.FindControl("drpField"), DropDownList)
            If (Not Session("rptPct") Is Nothing) Then dtFilters = CType(Session("rptPct"), Data.DataTable)
            If dtFilters.Rows.Count <= 0 Then dtFilters = ShowAvailableFilters()

            drpFields.DataSource = dtFilters.DefaultView
            drpFields.DataTextField = "FieldName"
            drpFields.DataValueField = "DataType"
            drpFields.DataBind()
            drpFields.Items.Insert(0, New ListItem("", ""))
        End If
    End Sub
#End Region

#Region "DROPDOWN INDEX CHANGES"
    Protected Sub drpName_SelectedIndexChange(ByVal sender As Object, ByVal e As EventArgs)

        Dim drpFilter, drpName As DropDownList
        Dim rptItem As RepeaterItem
        Dim indx As Integer
        Dim dtFilters As DataTable = New DataTable

        Try
            ShowFilter(False)
            ShowPreviewGrid(False)
            If (InStr(lblMsg.Text.Trim(), "overlap")) Then ShowFilter()
            ClearMsg()
            drpName = CType(sender, DropDownList)
            rptItem = drpName.Parent
            indx = rptItem.ItemIndex
            InitializeSetting(indx)
            If (drpName.SelectedValue <> "0") Then
                drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
                drpFilter.Items.Clear()
                drpFilter.Visible = True
                LoadList(drpName.SelectedValue, drpFilter)
            End If
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try
    End Sub

    Protected Sub drpFilter_SelectedIndexChange(ByVal sender As Object, ByVal e As EventArgs)
        Dim drpFilter As DropDownList
        Dim rptItem As RepeaterItem
        Dim indx As Integer

        Try
            ShowFilter(False)
            ShowPreviewGrid(False)
            If (InStr(lblMsg.Text.Trim(), "overlap")) Then ShowFilter()
            ClearMsg()
            drpFilter = CType(sender, DropDownList)
            rptItem = drpFilter.Parent
            indx = rptItem.ItemIndex
            ShowCriteriaInput(drpFilter, indx)
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try
    End Sub

    Protected Sub drpClause_SelectedIndexChange(ByVal sender As Object, ByVal e As EventArgs)
        Dim drpClause, drpField As DropDownList

        Dim indx, iItemCount As Integer
        Dim rptItem As RepeaterItem

        iItemCount = rptFilters.Items.Count - 1
        drpClause = CType(sender, DropDownList)
        rptItem = drpClause.Parent
        indx = rptItem.ItemIndex

        ShowFilter(False)
        ShowPreviewGrid(False)
        If (InStr(lblMsg.Text.Trim(), "overlap")) Then ShowFilter()
        'Check to see if a row  has already been added
        Try
            If (drpClause.SelectedValue <> "") Then
                drpField = CType(rptFilters.Items(indx + 1).FindControl("drpName"), DropDownList)
            End If
        Catch ex As Exception ' This error ONly occurs when Index out of range, therefore add a new row
            AddNewRow()
        End Try

    End Sub
#End Region

#Region "CRITERIA OPERATIONS"
    Protected Sub BitInfo(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("--", ""))
        drp.Items.Add(New ListItem("true", "1"))
        drp.Items.Add(New ListItem("false", "0"))
    End Sub

    Protected Sub IntInfo(ByVal drp As DropDownList)
        commonInfo(drp)
        drp.Items.Add(New ListItem("Not In", "Not In"))
    End Sub

    Protected Sub SglInfo(ByVal drp As DropDownList)
        commonInfo(drp)
    End Sub

    Protected Sub strInfo(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("----", ""))
        drp.Items.Add(New ListItem("equal to", "exact"))
        strInfoManip(drp)
        drp.Items.Add(New ListItem("----", ""))
        drp.Items.Add(New ListItem("is not equal to", "not exact"))
        strInfoNegate(drp)
    End Sub

    Protected Sub strInfoManip(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("contains", "any"))
        drp.Items.Add(New ListItem("begin with", "begin"))
        drp.Items.Add(New ListItem("end with", "end"))
        drp.Items.Add(New ListItem("fall between", "between"))
    End Sub

    Protected Sub strInfoNegate(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("does not contain", "not any"))
        drp.Items.Add(New ListItem("does not begin with", "not begin"))
        drp.Items.Add(New ListItem("does not end with", "not end"))
        drp.Items.Add(New ListItem("does not fall between", "not between"))
    End Sub

    Protected Sub commonInfo(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("----", ""))
        Operators(drp)
        strInfoManip(drp)
        drp.Items.Add(New ListItem("----", ""))
        NegationOperators(drp)
        strInfoNegate(drp)
    End Sub

    Protected Sub Operators(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("less than", "<"))
        drp.Items.Add(New ListItem("less or equal to", "<="))
        drp.Items.Add(New ListItem("greater than", ">"))
        drp.Items.Add(New ListItem("greater or equal to", ">="))
        drp.Items.Add(New ListItem("equal to", "="))
    End Sub
    Protected Sub NegationOperators(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("is not less than", "not <"))
        drp.Items.Add(New ListItem("is not less or equal to", "not <="))
        drp.Items.Add(New ListItem("is not greater than", "not >"))
        drp.Items.Add(New ListItem("is not greater or equal to", "not >="))
        drp.Items.Add(New ListItem("is not equal to", "not ="))
    End Sub


    Protected Sub datInfo(ByVal drp As DropDownList)
        commonInfo(drp)
    End Sub

    Protected Sub LoadList(ByVal dtType As String, ByVal drp As DropDownList)
        dtType = GetDataType(dtType)
        Select Case dtType.ToLower
            Case "int32"
                IntInfo(drp)
            Case "string"
                strInfo(drp)
            Case "datetime"
                datInfo(drp)
            Case "single"
                SglInfo(drp)
            Case "bit"
                BitInfo(drp)
            Case Else
        End Select
    End Sub


    Protected Function GetDataType(ByVal dtType As String) As String
        Return dtType.Split(":")(1) 'Strip out Index Id that was added to disticly Identify dropdown Item.
    End Function

    Protected Function GetDbFieldName(ByVal dbFieldName As String) As String
        Return dbFieldName.Split(":")(2) 'Strip out Index Id that was added to disticly Identify dropdown Item.
    End Function
#End Region

#Region "CONTROLS SETTING/RESETTING"

    Protected Sub ResetView()
        Session.Clear()
        LoadFilters(0)
        ClearMsg()
        ShowFilter(False)
        ShowPreviewGrid(False)
        ResetUpdateValues()
        DisablePreview()
        ResetFilterValues()
        ShowDashBoard(False)
    End Sub

    Protected Sub ShowFilter(ByVal blnFlag As Boolean)
        txtfilterName.Visible = blnFlag
        lnkbtnSave.Visible = blnFlag
        imgSave.Visible = blnFlag
        imgCancel.Visible = blnFlag
        lnkbtnCancel.Visible = blnFlag
        lblFriendlyDisplay.Visible = blnFlag
        spnId.Visible = blnFlag
        btnShowPreview.Visible = blnFlag
        imgFind.Visible = blnFlag
        lblDashBoard.Visible = blnFlag
        'HideCheckBox(blnFlag)

        'Fixed 
        lblNotFound.Visible = False
        'dvPod.Visible = False
        'dvFilters.Visible = False
    End Sub

    Protected Sub HideCheckBox(ByVal blnFlag As Boolean)
        Dim indx As Integer
        Dim chkExclusion As CheckBox
        Try
            If (InStr(lblMsg.Text, "overlap")) Then Exit Sub
            If (blnFlag = False) Then
                For indx = 0 To grdView.Rows.Count - 1
                    chkExclusion = CType(grdView.Rows(indx).FindControl("chkExclusion"), CheckBox)
                    If (chkExclusion.Visible) Then
                        chkExclusion.Checked = False
                        chkExclusion.Visible = False
                    End If
                Next
            End If
        Catch ex As Exception

        End Try
    End Sub
    Protected Sub ShowDashBoard(ByVal blnFlag As Boolean)
        dvDashBoard.Visible = blnFlag
        rptDashBoard.Visible = blnFlag
    End Sub

    Protected Sub ShowPreviewGrid(ByVal blnFlag As Boolean)
        spnShowPreview.Visible = blnFlag
        imgDetail.Visible = blnFlag
        ExpandAll.Visible = blnFlag
        btnHide.Visible = blnFlag
    End Sub

    Protected Sub ResetUpdateValues()
        txtEditId.Text = ""
    End Sub

    Protected Sub ResetFilterValues()
        txtfilterName.Text = ""
        lblFilter.Text = ""
        lblFriendlyDisplay.Text = ""
        lblDashBoard.Text = ""
    End Sub


    Protected Sub PreviewOn(ByVal isPreview As Boolean)
        If (isPreview) Then
            If (lblFriendlyDisplay.Text) <> "" Then
                btnShowPreview.Visible = True
                imgFind.Visible = True
            End If

            btnHide.Visible = False
            ExpandAll.Visible = False
        Else
            imgFind.Visible = False
            btnShowPreview.Visible = False
            btnHide.Visible = True
            ExpandAll.Visible = True
        End If
    End Sub

    Protected Sub DisablePreview()
        btnShowPreview.Visible = False
        btnHide.Visible = False
        imgFind.Visible = False
    End Sub

#End Region

#Region "ADD NEW CRITERIA ROW"
    Protected Sub btnImgAdd_AddNew(ByVal sender As Object, ByVal e As ImageClickEventArgs)
        Try
            ClearMsg()
            AddNewRow()
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try

    End Sub

    Protected Sub AddNewRow()
        Dim itemCount As Integer = rptFilters.Items.Count
        Try
            Save(-1)
            LoadFilters(itemCount)
            Retrieve()
            ShowFilter(False)
            ShowPreviewGrid(False)
            'SelectedGridRow(grdView, -1)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
#End Region

#Region "REMOVE CRITERIA ROW"
    Protected Sub btnImgRemove_RemoveRow(ByVal sender As Object, ByVal e As ImageClickEventArgs)
        Dim itemCount As Integer = rptFilters.Items.Count
        Dim btnImageButton As ImageButton
        Dim rptItem As RepeaterItem
        Dim indx As Integer
        Try
            ClearMsg()
            btnImageButton = CType(sender, ImageButton)
            rptItem = btnImageButton.Parent
            indx = rptItem.ItemIndex
            RemoveSelectedRow(indx, itemCount)
            ShowFilter(False)
            ShowPreviewGrid(False)
            'SelectedGridRow(grdView, -1)
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="indx"></param>
    ''' <param name="itemCount"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub RemoveSelectedRow(ByVal indx As Integer, ByVal itemCount As Integer)
        Try
            Save(indx)
            If (itemCount > 1) Then
                LoadFilters(itemCount - 2)
            End If
            Retrieve()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="arRepeaterRow"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub RemoveSelectedRow(ByVal arRepeaterRow As ArrayList)

        Dim indx, itemCount As Integer
        Try
            For indx = 0 To arRepeaterRow.Count - 1
                itemCount = rptFilters.Items.Count
                If (itemCount > 1) Then
                    LoadFilters(itemCount - 2)
                End If
            Next
        Catch ex As Exception
            Throw ex
        End Try

    End Sub
#End Region

#Region "MANIPULATE REPEATER ITEMS"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drp"></param>
    ''' <param name="indx"></param>
    ''' <remarks></remarks>
    Protected Sub ShowCriteriaInput(ByRef drp As DropDownList, ByVal indx As Integer)
        Dim strSelectedCriteria As String = ""
        Dim drpName, drpClause, drpOperation, drpField As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim lstObj As New ListItem
        Dim imghtml As HtmlImage
        Dim lnkhtml As HtmlAnchor



        'DropDownList
        drpName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
        drpClause = CType(rptFilters.Items(indx).FindControl("drpClause"), DropDownList)
        drpOperation = CType(rptFilters.Items(indx).FindControl("drpOperation"), DropDownList)
        drpField = CType(rptFilters.Items(indx).FindControl("drpField"), DropDownList)

        imghtml = CType(rptFilters.Items(indx).FindControl("imglookup"), HtmlImage)
        lnkhtml = CType(rptFilters.Items(indx).FindControl("lnkPop"), HtmlAnchor)

        'TextBox
        txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)

        'Label

        'Initialize Settings
        'InitializeSetting(indx)        
        strSelectedCriteria = drp.SelectedValue.ToLower()

        EnableListItem(drpField)
        If (InStr(drpName.SelectedValue.ToLower, "single") AndAlso (strSelectedCriteria <> "between")) Then
            lstObj = drpField.Items.FindByValue(drpName.SelectedValue)
            If Not lstObj Is Nothing Then lstObj.Enabled = False
            drpOperation.Visible = True
            drpField.Visible = True
        Else
            drpOperation.Visible = False
            drpField.Visible = False
        End If

        EnablePopupLink(drpName, drp, txtInputvalue1, imghtml, lnkhtml)

        drpClause.Visible = True
        Select Case strSelectedCriteria
            Case "<=", "<", ">=", ">", "=", "exact", "any", "begin", "end", "between", "not <=", "not <", "not >=", "not >", "not =", "not exact", "not any", "not begin", "not ends", "not between"
                txtInputvalue1.Visible = True
            Case "not in"
                txtInputvalue1.Visible = True
                drpClause.Visible = True
            Case "1", "0"
            Case Else
        End Select

    End Sub

    Protected Sub EnablePopupLink(ByVal drpName As DropDownList, ByVal drp As DropDownList, ByVal txtInputvalue1 As TextBox, ByVal imghtml As HtmlImage, ByVal lnkhtml As HtmlAnchor)
        Dim sFieldName As String = GetDbFieldName(drpName.SelectedValue).ToLower()
        Dim sComparisonValue As String = drp.SelectedValue.ToLower()
        Dim spopupLink As String
        If (AllowPopUp(sFieldName, sComparisonValue) = True) Then
            spopupLink = "javascript:tCriteria(" & txtInputvalue1.ClientID & ",'" & GetDbFieldName(drpName.SelectedValue) & "');return false;"
            lnkhtml.Attributes.Add("OnClick", spopupLink)
            imghtml.Visible = True
        Else
            imghtml.Visible = False
        End If
    End Sub

    Protected Function AllowPopUp(ByVal sFieldname As String, ByVal sComarisonValue As String) As Boolean
        Return (InStr(sNegotiationLookupFields.ToLower, sFieldname) AndAlso (InStr(sNegotiationToken.Trim().ToLower(), sComarisonValue.Replace(" ", "").Trim())))
    End Function

    Protected Sub EnableListItem(ByVal drp As DropDownList)
        Dim ItemIndx As Integer
        If (drp.Items.Count > 0) Then
            For ItemIndx = 0 To drp.Items.Count - 1
                drp.Items(ItemIndx).Enabled = True
            Next
        End If
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="rowIndx"></param>
    ''' <remarks>This code was initially used to reset control values, due to usability I have Disabled a call to this function.</remarks>
    Protected Sub InitializeSetting(ByVal rowIndx As Integer)
        Dim drpClause, drpOperation, drpField As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim imghtml As HtmlImage


        'DropDownList
        drpClause = CType(rptFilters.Items(rowIndx).FindControl("drpClause"), DropDownList)
        drpOperation = CType(rptFilters.Items(rowIndx).FindControl("drpOperation"), DropDownList)
        drpField = CType(rptFilters.Items(rowIndx).FindControl("drpField"), DropDownList)

        'TextBox
        txtInputvalue1 = CType(rptFilters.Items(rowIndx).FindControl("txtInputvalue1"), TextBox)

        imghtml = CType(rptFilters.Items(rowIndx).FindControl("imglookup"), HtmlImage)

        imghtml.Visible = False

        'Initialize Settings
        drpClause.SelectedIndex = -1
        drpClause.SelectedIndex = 0
        drpClause.Visible = False
        drpOperation.SelectedIndex = -1
        drpOperation.SelectedIndex = 0
        drpOperation.Visible = False
        drpField.SelectedIndex = -1
        drpField.SelectedIndex = 0
        drpField.Visible = False

        txtInputvalue1.Visible = False
        txtInputvalue1.Text = ""
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="arRepeaterRowId"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub Save(ByVal arRepeaterRowId As ArrayList)
        Dim indx As Integer
        Dim drpClause, drpFieldName, drpFilter, drpOperation, drpField As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim dtTable As New Data.DataTable
        Dim dtRow As Data.DataRow

        Try
            'Create Temp Table
            CreateTempTable(dtTable)
            For indx = 0 To rptFilters.Items.Count - 1
                If arRepeaterRowId.Contains(indx) = False Then
                    'DropDownList
                    drpFieldName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
                    drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
                    drpClause = CType(rptFilters.Items(indx).FindControl("drpClause"), DropDownList)
                    drpOperation = CType(rptFilters.Items(indx).FindControl("drpOperation"), DropDownList)
                    drpField = CType(rptFilters.Items(indx).FindControl("drpField"), DropDownList)

                    'TextBox
                    txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)
                    If (drpFieldName.SelectedValue.Trim() <> "0") Then
                        dtRow = dtTable.NewRow()
                        dtRow("FieldName") = drpFieldName.SelectedValue
                        dtRow("drpFilter") = drpFilter.SelectedValue
                        dtRow("drpFilterVisible") = txtInputvalue1.Visible
                        dtRow("Input1") = txtInputvalue1.Text
                        dtRow("Input1Visible") = txtInputvalue1.Visible
                        dtRow("drpClause") = drpClause.SelectedValue
                        dtRow("drpClauseVisible") = drpClause.Visible
                        dtRow("drpPctOf") = drpOperation.SelectedValue
                        dtRow("drpPctOfVisible") = drpOperation.Visible
                        dtRow("drpPctField") = drpField.SelectedValue
                        dtRow("drpPctFieldVisible") = drpField.Visible
                        dtTable.Rows.Add(dtRow)
                    End If
                End If
            Next
            If dtTable.Rows.Count > 0 Then SetSessionTable(dtTable)
        Catch ex As Exception
            Throw ex
        End Try

    End Sub



    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Flagindx"></param>
    ''' <param name="isExclusion"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub Save(ByVal Flagindx As Integer, Optional ByVal isExclusion As Boolean = False)
        Dim indx As Integer
        Dim drpClause, drpFieldName, drpFilter, drpOperation, drpField As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim dtTable As New Data.DataTable
        Dim dtRow As Data.DataRow

        Try


            'Create Temp Table
            CreateTempTable(dtTable)
            For indx = 0 To rptFilters.Items.Count - 1
                If indx <> Flagindx Then
                    'DropDownList
                    drpFieldName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
                    drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
                    drpClause = CType(rptFilters.Items(indx).FindControl("drpClause"), DropDownList)
                    drpOperation = CType(rptFilters.Items(indx).FindControl("drpOperation"), DropDownList)
                    drpField = CType(rptFilters.Items(indx).FindControl("drpField"), DropDownList)

                    'TextBox
                    txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)

                    If (drpFieldName.SelectedValue.Trim() <> "0") Then
                        dtRow = dtTable.NewRow()
                        dtRow("FieldName") = drpFieldName.SelectedValue
                        If (isExclusion = True) Then
                            If (InStr(drpFilter.SelectedValue, "not")) Then
                                dtRow("drpFilter") = drpFilter.SelectedValue
                            Else
                                dtRow("drpFilter") = "not" & " " & drpFilter.SelectedValue
                            End If
                        Else
                            dtRow("drpFilter") = drpFilter.SelectedValue
                        End If

                        dtRow("drpFilterVisible") = txtInputvalue1.Visible
                        dtRow("Input1") = txtInputvalue1.Text
                        dtRow("Input1Visible") = txtInputvalue1.Visible
                        If (isExclusion = True) Then
                            dtRow("drpClause") = drpClause.SelectedValue '"and"
                            dtRow("drpClauseVisible") = "True"
                        Else
                            dtRow("drpClause") = drpClause.SelectedValue
                            dtRow("drpClauseVisible") = drpClause.Visible
                        End If
                        dtRow("drpPctOf") = drpOperation.SelectedValue
                        dtRow("drpPctOfVisible") = drpOperation.Visible
                        dtRow("drpPctField") = drpField.SelectedValue
                        dtRow("drpPctFieldVisible") = drpField.Visible
                        dtTable.Rows.Add(dtRow)
                    End If
                End If
            Next
            If dtTable.Rows.Count > 0 Then SetSessionTable(dtTable)
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>    
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function SaveExclusion() As DataTable
        Dim dtTable As New Data.DataTable
        Try
            'Create Temp Table
            CreateTempTable(dtTable)
            BuildExclusionClause(dtTable)
            Return dtTable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <remarks></remarks>
    Protected Sub SaveExclusion(ByRef dtTable As DataTable)
        Try
            BuildExclusionClause(dtTable)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <remarks></remarks>
    Protected Sub SaveFromSessionTable(ByRef dtTable As DataTable)
        Dim dt As DataTable = New DataTable
        Dim indx As Integer
        Try
            dt = GetSessionTable()
            If (dt.Rows.Count > 0) Then
                For indx = 0 To dt.Rows.Count - 1
                    If (CriteriaAlreadyExists(dtTable, dt.Rows(indx)) = False) Then
                        If ((dtTable.Rows(dtTable.Rows.Count - 1)("drpClause").ToString.Trim() = "") AndAlso (dtTable.Rows(dtTable.Rows.Count - 1)("FieldName").ToString.Trim() <> "")) Then
                            dtTable.Rows(dtTable.Rows.Count - 1)("drpClause") = "and"
                            dtTable.Rows(dtTable.Rows.Count - 1)("drpClauseVisible") = "True"
                        End If
                        dtTable.ImportRow(dt.Rows(indx))
                    End If
                Next
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtSessionTable"></param>    
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function CriteriaAlreadyExists(ByVal dtSessionTable As DataTable, ByVal dtRow As DataRow) As Boolean
        Dim indx As Integer
        Dim Exists As Boolean = False
        If (dtSessionTable.Rows.Count > 0) Then
            For indx = 0 To dtSessionTable.Rows.Count - 1
                If (dtSessionTable.Rows(indx)("FieldName") = dtRow("FieldName") And _
                    dtSessionTable.Rows(indx)("drpFilter") = dtRow("drpFilter") And _
                    dtSessionTable.Rows(indx)("Input1") = dtRow("Input1") And _
                    dtSessionTable.Rows(indx)("drpPctOf") = dtRow("drpPctOf") And _
                    dtSessionTable.Rows(indx)("drpPctField") = dtRow("drpPctField")) Then
                    Exists = True
                    Exit For
                End If
            Next
        End If
        Return Exists

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <remarks></remarks>
    Protected Sub BuildExclusionClause(ByRef dtTable As DataTable)
        Dim indx As Integer
        Dim drpClause, drpFieldName, drpFilter, drpOperation, drpField As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim dtRow As Data.DataRow

        For indx = 0 To rptFilters.Items.Count - 1
            'DropDownList
            drpFieldName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
            drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
            drpClause = CType(rptFilters.Items(indx).FindControl("drpClause"), DropDownList)
            drpOperation = CType(rptFilters.Items(indx).FindControl("drpOperation"), DropDownList)
            drpField = CType(rptFilters.Items(indx).FindControl("drpField"), DropDownList)

            'TextBox
            txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)
            If (drpFieldName.SelectedValue.Trim() <> "0") Then
                dtRow = dtTable.NewRow()
                dtRow("FieldName") = drpFieldName.SelectedValue
                dtRow("drpFilter") = drpFilter.SelectedValue
                dtRow("drpFilterVisible") = txtInputvalue1.Visible
                dtRow("Input1") = txtInputvalue1.Text
                dtRow("Input1Visible") = txtInputvalue1.Visible
                dtRow("drpClause") = drpClause.SelectedValue '"and"  
                dtRow("drpClauseVisible") = "True" ' drpClause.Visible
                dtRow("drpPctOf") = drpOperation.SelectedValue
                dtRow("drpPctOfVisible") = drpOperation.Visible
                dtRow("drpPctField") = drpField.SelectedValue
                dtRow("drpPctFieldVisible") = drpField.Visible
                dtTable.Rows.Add(dtRow)
            End If
        Next
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtCriteriaDetail"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub Save(ByVal dtCriteriaDetail As Data.DataTable)
        Dim indx As Integer
        Dim dtTable As New Data.DataTable
        Dim dtRow As Data.DataRow

        Try

            'Create Temp Table
            CreateTempTable(dtTable)
            For indx = 0 To dtCriteriaDetail.Rows.Count - 1

                dtRow = dtTable.NewRow()
                dtRow("FieldName") = dtCriteriaDetail.Rows(indx)("FieldName")
                dtRow("drpFilter") = dtCriteriaDetail.Rows(indx)("Operation")
                dtRow("drpFilterVisible") = dtCriteriaDetail.Rows(indx)("OperationVisible")
                dtRow("Input1") = dtCriteriaDetail.Rows(indx)("FirstInput")
                dtRow("Input1Visible") = dtCriteriaDetail.Rows(indx)("FirstInputVisible")
                dtRow("drpClause") = dtCriteriaDetail.Rows(indx)("JoinClause")
                dtRow("drpClauseVisible") = dtCriteriaDetail.Rows(indx)("joinClauseVisible")
                dtRow("drpPctOf") = dtCriteriaDetail.Rows(indx)("PctOf")
                dtRow("drpPctOfVisible") = dtCriteriaDetail.Rows(indx)("PctOfVisible")
                dtRow("drpPctField") = dtCriteriaDetail.Rows(indx)("PctField")
                dtRow("drpPctFieldVisible") = dtCriteriaDetail.Rows(indx)("PctFieldVisible")

                dtTable.Rows.Add(dtRow)
            Next

            If dtTable.Rows.Count > 0 Then SetSessionTable(dtTable)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <remarks></remarks>
    Protected Sub CreateTempTable(ByRef dtTable As Data.DataTable)
        With dtTable.Columns
            .Add("FieldName")
            .Add("drpFilter")
            .Add("drpFilterVisible")
            .Add("Input1")
            .Add("Input1Visible")
            .Add("drpClause")
            .Add("drpClauseVisible")
            .Add("drpPctOf")
            .Add("drpPctOfVisible")
            .Add("drpPctField")
            .Add("drpPctFieldVisible")
        End With
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub Retrieve()
        Dim dtTable As New Data.DataTable
        Try
            'Read from Cache            
            dtTable = GetSessionTable()
            Retrieve(dtTable)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetSessionTable() As DataTable
        Dim dtTable As DataTable = New DataTable
        Try
            dtTable = CType(Session("rptFilters"), Data.DataTable)
            Return dtTable
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <remarks></remarks>
    Protected Sub SetSessionTable(ByVal dtTable As DataTable)
        Try
            'Reset Session value.
            Session("rptFilters") = dtTable
        Catch ex As Exception
            Throw ex
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <remarks></remarks>
    Protected Sub Retrieve(ByVal dtTable As DataTable)
        Dim indx As Integer
        Dim drpClause, drpFieldName, drpFilter, drpOperation, drpField As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim imghtml As HtmlImage
        Dim lnkhtml As HtmlAnchor

        Try

            'Read from Cache
            If dtTable.Rows.Count > 0 Then
                For indx = 0 To dtTable.Rows.Count - 1
                    drpFieldName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
                    drpFieldName.SelectedIndex = -1
                    drpFieldName.Items.FindByValue(dtTable.Rows(indx)("FieldName")).Selected = True

                    imghtml = CType(rptFilters.Items(indx).FindControl("imglookup"), HtmlImage)
                    lnkhtml = CType(rptFilters.Items(indx).FindControl("lnkPop"), HtmlAnchor)

                    drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
                    If (dtTable.Rows(indx)("drpFilterVisible") = True) Then
                        LoadList(drpFieldName.SelectedValue, drpFilter)
                        drpFilter.SelectedIndex = -1
                        drpFilter.Items.FindByValue(dtTable.Rows(indx)("drpFilter")).Selected = True
                        drpFilter.Visible = True
                    End If

                    If (dtTable.Rows(indx)("drpClauseVisible") = True) Then
                        drpClause = CType(rptFilters.Items(indx).FindControl("drpClause"), DropDownList)
                        drpClause.SelectedIndex = -1
                        drpClause.Items.FindByValue(dtTable.Rows(indx)("drpClause")).Selected = True
                        drpClause.Visible = True
                    End If

                    txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)
                    If (dtTable.Rows(indx)("Input1Visible") = True) Then
                        txtInputvalue1.Text = dtTable.Rows(indx)("Input1")
                        txtInputvalue1.Visible = True
                    End If

                    If (dtTable.Rows(indx)("drpPctOfVisible") = True) Then
                        drpOperation = CType(rptFilters.Items(indx).FindControl("drpOperation"), DropDownList)
                        drpOperation.SelectedIndex = -1
                        drpOperation.SelectedValue = dtTable.Rows(indx)("drpPctOf")
                        drpOperation.Visible = True
                    End If

                    If (dtTable.Rows(indx)("drpPctFieldVisible") = True) Then
                        drpField = CType(rptFilters.Items(indx).FindControl("drpField"), DropDownList)
                        drpField.SelectedIndex = -1
                        drpField.SelectedValue = dtTable.Rows(indx)("drpPctField")
                        drpField.Visible = True
                    End If
                    EnablePopupLink(drpFieldName, drpFilter, txtInputvalue1, imghtml, lnkhtml)
                Next
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="iFilterId"></param>
    ''' <remarks></remarks>
    Protected Sub SaveFilterDetail(ByVal iFilterId As Integer)
        Dim dtTable As Data.DataTable = New Data.DataTable
        Try
            Save(-1)
            dtTable = GetSessionTable()
            bsCriteriaBuilder.SaveDetail(dtTable, iFilterId, rdList.SelectedValue.ToLower())
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="iKeyId"></param>
    ''' <remarks></remarks>
    Protected Sub LoadFilterDetail(ByVal iKeyId As Integer)
        Dim ds As Data.DataSet = New Data.DataSet
        Dim maxCount As Integer
        Try
            ds = bsCriteriaBuilder.GetFilterDetail(iKeyId)
            If (ds.Tables(0).Rows.Count > 0) Then
                maxCount = ds.Tables(0).Rows.Count
                LoadFilters(maxCount - 1)
                Save(ds.Tables(0))
                Retrieve()
            End If
        Catch ex As Exception
            Throw ex
        Finally
            ds.Dispose()
        End Try
    End Sub

#End Region

#Region "GRIDVIEW DISPLAY"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ShowFilter()
        Try

            If ((sQueryCriteriaId <> "0") And (sFilterType.Trim().ToLower() <> "root")) Then
                ShowChildFilters()
            ElseIf (sEntityId <> "0") Then
                ShowEntityFilters()
            Else
                ShowMasterFilter()
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ShowMasterFilter()
        Dim dsList As DataSet = New DataSet
        Try
            dsList = bsCriteriaBuilder.GetFilters(rdList.SelectedValue, 0)
            grdView.DataSource = dsList.Tables(0).DefaultView
            grdView.DataBind()
            LoadDashBoardSummary(grdView)
        Catch ex As Exception
            Throw ex
        Finally
            dsList.Dispose()
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ShowChildFilters()
        Dim dsList As DataSet = New DataSet
        Try
            dsList = bsCriteriaBuilder.GetFilters(CInt(sQueryCriteriaId))
            grdView.DataSource = dsList.Tables(0).DefaultView
            grdView.DataBind()
            LoadDashBoardDistributionSummary(grdView)
        Catch ex As Exception
            Throw ex
        Finally
            dsList.Dispose()
        End Try
    End Sub

    Protected Sub ShowEntityFilters()
        Dim dsList As DataSet = New DataSet
        Try
            dsList = bsCriteriaBuilder.GetEntityFilters(CInt(sEntityId), "child")
            grdView.DataSource = dsList.Tables(0).DefaultView
            grdView.DataBind()
            LoadDashBoardDistributionSummary(grdView)
        Catch ex As Exception
            Throw ex
        Finally
            dsList.Dispose()
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="gVw"></param>
    ''' <remarks></remarks>
    Protected Sub LoadDashBoardSummary(ByVal gVw As GridView)
        Dim dsDashBoard As DataSet = New DataSet
        Dim RowIndx, iKeyId As Integer
        Dim dtRow() As DataRow
        Try
            dsDashBoard = bsCriteriaDashBoard.GetDashBoard(0)
            For RowIndx = 0 To gVw.Rows.Count - 1
                iKeyId = gVw.DataKeys(RowIndx).Value
                dtRow = dsDashBoard.Tables(0).Select("FilterId=" & iKeyId)
                If (dtRow.Length > 0) Then GridBind(dtRow, RowIndx, gVw)
            Next
        Catch ex As Exception
            Throw ex
        Finally
            dsDashBoard.Dispose()
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtRow"></param>
    ''' <remarks></remarks>
    Protected Sub GridBind(ByVal dtRow() As DataRow, ByVal RowIndx As Integer, ByVal gvw As GridView)

        gvw.Rows(RowIndx).Cells(7).Text = dtRow(0)("ClientCount")
        gvw.Rows(RowIndx).Cells(8).Text = dtRow(0)("AccountCount")
        gvw.Rows(RowIndx).Cells(11).Text = dtRow(0)("ZipCodeCount")
        gvw.Rows(RowIndx).Cells(13).Text = String.Format("{0:c}", dtRow(0)("TotalSDAAmount"))
        CType(gvw.Rows(RowIndx).FindControl("lnkbtnAccountType"), LinkButton).Text = dtRow(0)("StatusCount")
        CType(gvw.Rows(RowIndx).FindControl("lnkbtnState"), LinkButton).Text = dtRow(0)("StateCount")
        CType(gvw.Rows(RowIndx).FindControl("lnkbtnCreditors"), LinkButton).Text = dtRow(0)("CreditorCount")
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="gvw"></param>
    ''' <remarks></remarks>
    Protected Sub LoadDashBoardDistributionSummary(ByVal gvw As GridView)
        Dim dsDashBoard As DataSet = New DataSet
        Dim RowIndx, iKeyId As Integer
        Dim dtRow() As DataRow
        Try
            For RowIndx = 0 To gvw.Rows.Count - 1
                iKeyId = gvw.DataKeys(RowIndx).Value
                dsDashBoard = bsCriteriaDashBoard.GetDashBoard(iKeyId, CInt(sEntityId), "", rdList.SelectedValue)
                If (dsDashBoard.Tables(0).Rows.Count > 0) Then
                    dtRow = dsDashBoard.Tables(0).Select("FilterId=" & iKeyId)
                    GridBind(dtRow, RowIndx, gvw)
                End If
            Next
        Catch ex As Exception
            Throw ex
        Finally
            dsDashBoard.Dispose()
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub EditRow(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            ShowLoadProgress(True)
            HasOverlapMsg()
            Dim Rowindx As Integer = CType(e.CommandArgument, Integer)
            EditRow(Rowindx)
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub RebuildRow(ByVal sender As Object, ByVal e As EventArgs)
        Dim chkExclude As CheckBox
        Dim RowIndx As Integer
        Dim grdFilterId As Integer
        Try
            ShowLoadProgress(True)
            chkExclude = CType(sender, CheckBox)
            RowIndx = CType(chkExclude.Parent.Parent, GridViewRow).RowIndex
            Dim sMsg As String = lblMsg.Text.Trim()
            Dim sOverlapText As String = lblFilter.Text
            grdFilterId = grdView.DataKeys(RowIndx).Value
            If (chkExclude.Checked = True) Then
                ReBuildFilter(RowIndx, grdFilterId, sOverlapText)
            Else
                RevertToOriginal(RowIndx, grdFilterId)
            End If

            If (grdView.Rows.Count > 0) Then
                CheckGridBackColor()
            End If
            GetDashBoardSummary(True)
            If (InStr(lblMsg.Text.ToLower(), "overlap") > 0) Then DisablePreview()
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub CheckGridBackColor()
        Dim indx As Integer
        Dim hasOverlap As Integer = 0
        Try
            For indx = 0 To grdView.Rows.Count - 1
                If ((grdView.Rows(indx).Visible = True) And (grdView.Rows(indx).BackColor = Color.LightPink)) Then
                    hasOverlap = 1
                End If
            Next
            If (hasOverlap = 0) Then ClearMsg()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="RowIndx"></param>
    ''' <remarks></remarks>
    Protected Sub EditRow(ByVal RowIndx As Integer)
        Try
            Dim iKeyId As Integer = grdView.DataKeys(RowIndx).Value
            ClearMsg()
            ShowDashBoard(False)
            ShowPreviewGrid(False)
            ResetUpdateValues()
            DisablePreview()
            ResetFilterValues()
            ShowFilter(True)
            HideCheckBox(False)
            If (iKeyId > 0) Then
                txtEditId.Text = iKeyId
                SelectedGridRow(grdView, RowIndx)
                Dim sCriteriaDescription As String = CType(grdView.Rows(RowIndx).Cells(5).Controls(1), HyperLink).Text
                Dim sCriteria As String = CType(grdView.Rows(RowIndx).FindControl("lblFilterClause"), Label).Text
                Dim sFriendlyDisplay As String = CType(grdView.Rows(RowIndx).FindControl("txtFilterText"), Label).Text  'grdView.Rows(RowIndx).Cells(6).Text
                txtfilterName.Text = sCriteriaDescription
                lblFilter.Text = sCriteria
                If (sFriendlyDisplay.Length > 200) Then
                    lblFriendlyDisplay.Text = sFriendlyDisplay.Substring(0, sFriendlyDisplay.LastIndexOf(" ")) & "..."
                Else
                    lblFriendlyDisplay.Text = sFriendlyDisplay
                End If
                LoadFilterDetail(iKeyId)
            End If
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="blnFlag"></param>
    ''' <remarks></remarks>
    Protected Sub ShowLoadProgress(ByVal blnFlag As Boolean)
        updProgress.Visible = blnFlag

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub ShowAccountTypeSummary(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            ShowLoadProgress(True)
            Dim Rowindx As Integer = CType(e.CommandArgument, Integer)
            DisplayDashBoardSummary(Rowindx, "AccountType")
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="gv"></param>
    ''' <param name="RowIndx"></param>
    ''' <remarks></remarks>
    Protected Sub SelectedGridRow(ByVal gv As GridView, ByVal RowIndx As Integer)
        Dim indx As Integer
        Dim PrevSelectedIndx As Integer = -1

        Dim drpFieldName As String = CType(rptFilters.Items(0).FindControl("drpName"), DropDownList).SelectedValue
        If ((drpFieldName.Trim() = "0") Or (RowIndx = -1) Or (RowIndx > -1)) Then
            For indx = 0 To gv.Rows.Count - 1
                If (gv.Rows(indx).BackColor = Color.LightGoldenrodYellow) Then PrevSelectedIndx = indx
                gv.Rows(indx).BackColor = Color.Transparent
            Next
            ClearMsg()
        End If
        If (RowIndx > -1) Then
            gv.Rows(RowIndx).BackColor = Color.LightGoldenrodYellow
        ElseIf ((txtEditId.Text <> "") And (PrevSelectedIndx >= 0)) Then
            gv.Rows(PrevSelectedIndx).BackColor = Color.LightGoldenrodYellow
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtOverlaps"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub HighlightOverlap(ByVal dtOverlaps As DataTable)
        Dim grdRowindx, grdFilterId As Integer
        ShowFilter(False)
        DisablePreview()
        DisplayMsg(lblMsg, BuildOverlapMsg, True)
        Dim dtRow() As DataRow
        Try
            If (dtOverlaps.Rows.Count > 0) Then
                Dim sOverlapText As String = lblFilter.Text
                Dim sFriendlyText As String = lblFriendlyDisplay.Text
                For grdRowindx = 0 To grdView.Rows.Count - 1
                    grdFilterId = grdView.DataKeys(grdRowindx).Value
                    dtRow = dtOverlaps.Select("FilterId=" & grdFilterId)
                    If (dtRow.Length > 0) Then
                        grdView.Rows(grdRowindx).BackColor = Color.LightPink
                        HighlightOverlap(grdRowindx, "", False)
                    End If
                Next
                GetDashBoardSummary(True)
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function BuildOverlapMsg() As String
        Dim sb As StringBuilder = New StringBuilder()
        sb.Append("The criteria you are trying to add overlaps with the highlighted criteria below.")
        sb.Append("<br>Available Options: ")
        sb.Append("<br>1. Click on save criteria button to automatically re-evaluate, adjust overlaps, and save criteria.")
        sb.Append("<br>2. Check the checkbox button to remove overlapping accounts from  existing criteria.")
        sb.Append("<br>3. Click on delete criteria (<img src='" & ResolveUrl("~/images/16x16_delete.png") & "'" & "align=absmiddle />)  button to delete specific criteria.")
        sb.Append("<br>4. Click on cancel button to revert to original settings.")
        Return sb.ToString()
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function BuildNoRecordMsg() As String
        Dim sb As StringBuilder = New StringBuilder()
        sb.Append("The criteria you specified could not be added to criteria list. This failure could be due to one of the following:")
        sb.Append("<br>1. All accounts for the criteria, you are trying to add, are already included within one or more existing criteria.<br>&nbsp;&nbsp;&nbsp;&nbsp;(See the highlighted criteria in the criteria list below)")
        sb.Append("<br>2. Matching Accounts that meet the criteria, you are trying to add, where not found.")
        Return sb.ToString()
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="RowIndex"></param>
    ''' <param name="IgnoreIndex"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub HighlightOverlap(ByVal RowIndex As Integer, ByVal sMsg As String, ByVal IgnoreIndex As Boolean)
        Dim grdRowindx As Integer
        Dim chkExclusion As CheckBox
        Dim hasOverlap As Integer = 0
        Try
            If (IgnoreIndex = False) Then
                CType(grdView.Rows(RowIndex).FindControl("chkExclusion"), CheckBox).Visible = True
            Else
                For grdRowindx = 0 To grdView.Rows.Count - 1
                    If grdView.Rows(grdRowindx).Visible = True Then
                        If (grdRowindx <> RowIndex) Then
                            chkExclusion = CType(grdView.Rows(grdRowindx).FindControl("chkExclusion"), CheckBox)
                            If (chkExclusion.Visible = True) Then
                                grdView.Rows(grdRowindx).BackColor = Color.LightPink
                                hasOverlap = 1
                            End If
                        End If
                    End If
                Next
            End If
            If (hasOverlap = 1) Then DisplayMsg(lblMsg, sMsg, True)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtOverlaps"></param>
    ''' <remarks></remarks>
    Protected Sub AppendExclusion(ByVal dtOverlaps As DataTable)
        Dim grdRowindx, grdFilterId As Integer
        Dim dtTable As DataTable = New DataTable()
        Dim sCriteria As String = ""
        Dim sFilterText As String = ""
        Dim sFilterDescription As String = ""
        Dim sAppendCriteriaText As String = ""
        Dim chkExclusion As CheckBox
        Dim dtRow() As DataRow
        ShowFilter(False)
        DisablePreview()
        Try
            If (dtOverlaps.Rows.Count > 0) Then
                Dim sOverlapText As String = lblFilter.Text
                Save(-1, True)
                dtTable = GetSessionTable()
                For grdRowindx = 0 To grdView.Rows.Count - 1
                    chkExclusion = grdView.Rows(grdRowindx).FindControl("chkExclusion")
                    If (chkExclusion.Checked = True) Then
                        sCriteria = CType(grdView.Rows(grdRowindx).FindControl("lblFilterClause"), Label).Text
                        grdFilterId = grdView.DataKeys(grdRowindx).Value
                        dtRow = dtOverlaps.Select("FilterId=" & grdFilterId)
                        If (dtRow.Length > 0) Then
                            If (grdFilterId.ToString() = txtEditId.Text) Then
                                sCriteria = sOverlapText
                            Else
                                sAppendCriteriaText = " and not (" & sOverlapText & ")"
                                sCriteria = GetFormatCriteriaToAppend(sCriteria, sAppendCriteriaText)
                            End If
                            If (sCriteria.Trim() <> sOverlapText.Trim()) Then
                                sFilterText = GetFriendlyClause(dtTable)
                                If (sFilterText.Trim().Length > 100) Then
                                    sFilterDescription = sFilterText.Substring(0, 100) & "...."
                                Else
                                    sFilterDescription = sFilterText
                                End If
                                bsCriteriaBuilder.AppendToFilter(sCriteria.Trim(), sFilterDescription, sFilterText, grdFilterId, UserId, rdList.SelectedValue.ToLower(), CInt(sEntityId))
                                bsCriteriaBuilder.SaveExclusion(dtTable, grdFilterId, rdList.SelectedValue.ToLower())
                            End If
                        End If
                    End If
                Next
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtOverlap"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub GetAdjustedFilterClause(ByVal dtOverlap As DataTable)
        Dim grdRowIndx, grdFilterId As Integer
        Dim chkExclusion As CheckBox
        Dim sAdjustedFilterClause As String = ""
        Dim lblFilterClause As Label
        Dim txtFilterText As Label
        Dim dtTable As DataTable = New DataTable
        Dim dtrow() As DataRow
        Dim sFiltextText, sFilterClause As String
        Dim sOriginalFilter, sOriginalDisplay As String
        Dim bFoundGridOverlap As Boolean = False
        ShowFilter(False)
        DisablePreview()

        Try
            sFiltextText = ""
            sFilterClause = ""
            sOriginalFilter = lblFilter.Text
            sOriginalDisplay = lblFriendlyDisplay.Text
            If (dtOverlap.Rows.Count > 0) Then
                CreateTempTable(dtTable)
                dtTable = SaveExclusion()
                For grdRowIndx = 0 To grdView.Rows.Count - 1
                    grdFilterId = grdView.DataKeys(grdRowIndx).Value
                    dtrow = dtOverlap.Select("FilterId=" & grdFilterId)
                    If (dtrow.Length > 0) Then
                        chkExclusion = CType(grdView.Rows(grdRowIndx).FindControl("chkExclusion"), CheckBox)
                        If (chkExclusion.Checked = False) Then
                            bFoundGridOverlap = True
                            lblFilterClause = CType(grdView.Rows(grdRowIndx).FindControl("lblFilterClause"), Label)
                            txtFilterText = CType(grdView.Rows(grdRowIndx).FindControl("txtFilterText"), Label)
                            If ((sFilterClause.Trim() <> "") AndAlso (lblFilterClause.Text.Trim() <> "")) Then sFilterClause = sFilterClause & " or "
                            sFilterClause = sFilterClause & " (" & lblFilterClause.Text.Trim & ")"

                            If ((sFiltextText.Trim() <> "") AndAlso (txtFilterText.Text.Trim() <> "")) Then sFiltextText = sFiltextText & " OR "
                            sFiltextText = sFiltextText & " " & txtFilterText.Text

                            EditRow(grdRowIndx)
                            Save(-1, True)
                            SaveFromSessionTable(dtTable)
                        End If
                    End If
                Next
                If (dtTable.Rows.Count > 0 And bFoundGridOverlap = True) Then
                    LoadFilters(dtTable.Rows.Count)
                    Retrieve(dtTable)
                    BuildFilterClause(False)
                    lblFilter.Text = sOriginalFilter
                    If ((sFilterClause.Trim()) <> "") Then lblFilter.Text = lblFilter.Text & " and not (" & sFilterClause & ")"
                    'lblFriendlyDisplay.Text = sOriginalDisplay
                    'If ((sFiltextText.Trim()) <> "") Then lblFriendlyDisplay.Text = lblFriendlyDisplay.Text & " and   " & sFiltextText
                End If
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="RowIndx"></param>
    ''' <param name="FilterId"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub ReBuildFilter(ByVal RowIndx As Integer, ByVal FilterId As Integer, ByVal sOverlapText As String)
        Dim dsDashBoard As DataSet = New DataSet
        Dim sAppendCriteriaText As String = ""
        Dim dtRow() As DataRow
        Dim EntityCriteriaId = ParseEntityCriteriaId()
        Try
            Dim sCriteria As String = CType(grdView.Rows(RowIndx).FindControl("lblFilterClause"), Label).Text
            If (FilterId.ToString() = txtEditId.Text) Then
                sCriteria = sOverlapText
            Else
                sAppendCriteriaText = " and (not " & sOverlapText & ")"
                sCriteria = GetFormatCriteriaToAppend(sCriteria, sAppendCriteriaText)
            End If
            dsDashBoard = bsCriteriaDashBoard.GetDashBoard(0, CInt(EntityCriteriaId), sCriteria, rdList.SelectedValue)
            'dsDashBoard = bsCriteriaDashBoard.GetDashBoard(0, sCriteria)
            If (dsDashBoard.Tables(0).Rows.Count > 0) Then
                dtRow = dsDashBoard.Tables(0).Select("FilterId=0")
                GridBind(dtRow, RowIndx, grdView)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsDashBoard.Dispose()
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="RowIndx"></param>
    ''' <param name="FilterId"></param>
    ''' <remarks></remarks>
    Protected Sub RevertToOriginal(ByVal RowIndx As Integer, ByVal FilterId As Integer)
        Dim dsDashBoard As DataSet = New DataSet
        Dim dtRow() As DataRow
        Try
            Dim sCriteria As String = CType(grdView.Rows(RowIndx).FindControl("lblFilterClause"), Label).Text
            dsDashBoard = bsCriteriaDashBoard.GetDashBoard(FilterId, sCriteria)
            If (dsDashBoard.Tables(0).Rows.Count > 0) Then
                dtRow = dsDashBoard.Tables(0).Select("FilterId=" & FilterId)
                GridBind(dtRow, RowIndx, grdView)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsDashBoard.Dispose()
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sCriteria"></param>
    ''' <param name="sAppendCriteriaText"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetFormatCriteriaToAppend(ByVal sCriteria As String, ByVal sAppendCriteriaText As String)
        Dim sLcCriteria As String = ""
        If InStr(sCriteria, "or") Then sCriteria = "(" & sCriteria & ")"
        If InStr(sCriteria, sAppendCriteriaText) Then
            sLcCriteria = sCriteria
        Else
            sLcCriteria = sCriteria & sAppendCriteriaText
        End If
        Return sLcCriteria

    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="RowIndx"></param>
    ''' <param name="sType"></param>
    ''' <remarks></remarks>
    Protected Sub DisplayDashBoardSummary(ByVal RowIndx As Integer, ByVal sType As String)
        Dim dsDashBoardType As Data.DataSet = New Data.DataSet
        Try
            ShowLoadProgress(True)
            Dim iKeyId As Integer = grdView.DataKeys(RowIndx).Value
            ClearMsg()
            ShowDashBoard(False)
            ShowPreviewGrid(False)
            ResetUpdateValues()
            DisablePreview()
            ResetFilterValues()
            ShowFilter(False)
            If (iKeyId > 0) Then
                SelectedGridRow(grdView, RowIndx)
                dsDashBoardType = bsCriteriaDashBoard.GetDashBoardSummary(iKeyId, sType)
                LoadDashBoardSummary(dsDashBoardType)
            End If
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            dsDashBoardType.Dispose()
            ShowLoadProgress(False)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub ShowStateSummary(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            ShowLoadProgress(True)
            Dim Rowindx As Integer = CType(e.CommandArgument, Integer)
            DisplayDashBoardSummary(Rowindx, "States")
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub ShowCreditorsSummary(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            ShowLoadProgress(True)
            Dim Rowindx As Integer = CType(e.CommandArgument, Integer)
            DisplayDashBoardSummary(Rowindx, "Creditors")
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="ds"></param>
    ''' <remarks></remarks>
    Protected Sub LoadDashBoardSummary(ByVal ds As Data.DataSet)
        Try
            If (ds.Tables(0).Rows.Count > 0) Then
                ShowDashBoard(True)
                rptDashBoard.DataSource = ds.Tables(0).DefaultView
                rptDashBoard.DataBind()
            End If
        Catch ex As Exception
            ShowDashBoard(True)
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Preview(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            ShowLoadProgress(True)
            HasOverlapMsg()
            Dim Rowindx As Integer = CType(e.CommandArgument, Integer)
            Preview(Rowindx)
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub



    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="RowIndx"></param>
    ''' <remarks></remarks>
    Protected Sub Preview(ByVal RowIndx As Integer)
        Try
            Dim iKeyId As Integer = grdView.DataKeys(RowIndx).Value
            ClearMsg()
            ShowDashBoard(False)
            ShowPreviewGrid(True)
            ResetUpdateValues()
            DisablePreview()
            ResetFilterValues()
            ShowFilter(False)
            PreviewOn(False)
            HideCheckBox(False)
            If (iKeyId > 0) Then
                SelectedGridRow(grdView, RowIndx)
                txtEditId.Text = iKeyId
                Dim sCriteria As String = CType(grdView.Rows(RowIndx).FindControl("lblFilterClause"), Label).Text
                Dim sFields As String = ""
                LoadPreviewGrid(sCriteria, iKeyId)
            End If
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try

    End Sub

    Protected Sub grdView_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdView.PageIndexChanged
        ShowFilter(False)
    End Sub

    Protected Sub grdView_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles grdView.PageIndexChanging
        grdView.PageIndex = e.NewPageIndex
        ShowFilter()
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub grdView_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdView.RowDataBound
        Dim btn As ImageButton
        Dim hpDesc As HyperLink
        Dim lblFilterText As String = ""
        Dim lblFilterBx As Label
        Dim TipDisplay As String = ""
        Dim sTrimmedDisplay As String = ""
        Dim lblFilterType As Label
        Dim sFilterType As String = ""
        Dim iCriteriaId As Integer = 0
        Dim sQueryFormat As String = ""
        If (e.Row.RowType = DataControlRowType.DataRow Or e.Row.RowType = DataControlRowType.EmptyDataRow) Then
            lblFilterBx = CType(e.Row.FindControl("txtFilterText"), Label)
            btn = CType(e.Row.Cells(1).Controls(1), ImageButton)
            hpDesc = CType(e.Row.FindControl("lnkbtnFilterName"), HyperLink)
            lblFilterType = CType(e.Row.FindControl("lblFilterType"), Label)
            lblFilterText = lblFilterBx.Text

            If (lblFilterText.Length > 85) Then
                sTrimmedDisplay = lblFilterText.Substring(0, 85)
                e.Row.Cells(6).Text = lblFilterText.Substring(0, sTrimmedDisplay.LastIndexOf(" ")) & "..."
            End If
            btn.Attributes.Add("OnClick", "javascript:return confirm('Are you sure you want to remove this criteria?\n\nRemoving this criteria will affect other criteria that may have used it as an exclusion criteria. \nAny affected criteria will be adjusted accordingly.');")
            lblFilterText = lblFilterText.Replace(Environment.NewLine, "")
            lblFilterText = lblFilterText.Replace(" and", " and <br>")
            lblFilterText = lblFilterText.Replace(" AND", " and <br>")
            lblFilterText = lblFilterText.Replace(" or", " or <br>")
            lblFilterText = lblFilterText.Replace(" OR", " or <br>")
            TipDisplay = "javascript:Tip('" & lblFilterText & "', BALLOON, true, ABOVE, true)"
            hpDesc.Attributes.Add("OnMouseOver", TipDisplay)
            sFilterType = lblFilterType.Text.ToLower()
            iCriteriaId = CInt(e.Row.DataItem(0))
            If (sFilterType.ToLower() = "root") Then
                sQueryFormat = "CriteriaId=" & iCriteriaId
            Else
                sQueryFormat = "CriteriaId=" & iCriteriaId & "&filter=" & sFilterType
            End If
            'hpDesc.NavigateUrl = ResolveUrl("~/research/negotiation/master/criteriadistribution.aspx?" & sQueryFormat)
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub DeleteRow(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            Dim Rowindx As Integer = CType(e.CommandArgument, Integer)
            Dim iKeyId As Integer = grdView.DataKeys(Rowindx).Value
            Dim sMsg As String = lblMsg.Text.ToLower()
            Dim dsTable As DataTable = New DataTable
            Dim sTextDisplay, sFilterName, sFilterClause As String

            sTextDisplay = ""
            sFilterName = ""
            sFilterClause = ""

            If (InStr(sMsg, "overlap")) Then
                dsTable = SaveExclusion()
                sTextDisplay = lblFriendlyDisplay.Text
                sFilterName = txtfilterName.Text
                sFilterClause = lblFilter.Text
            End If

            If (grdView.Rows.Count > 1) Then
                ReBuildFilter(Rowindx, iKeyId)
            Else
                bsCriteriaBuilder.Delete(iKeyId, UserId)
            End If

            If (InStr(sMsg, "overlap") <= 0) Then
                ClearMsg()
                ShowFilter()
                ResetView()
            Else
                SelectedGridRow(grdView, -1)
                SaveOption(dsTable, sTextDisplay, sFilterName, sFilterClause)
                grdView.Rows(Rowindx).Visible = False
                HighlightOverlap(Rowindx, sMsg, True)
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <param name="sText"></param>
    ''' <param name="sName"></param>
    ''' <param name="sClause"></param>
    ''' <remarks></remarks>
    Protected Sub SaveOption(ByVal dtTable As DataTable, ByVal sText As String, ByVal sName As String, ByVal sClause As String)
        Try
            If (dtTable.Rows.Count > 0) Then
                Retrieve(dtTable)
                lblFriendlyDisplay.Text = sText
                txtfilterName.Text = sName
                lblFilter.Text = sClause
                txtEditId.Text = ""
                ShowFilter(True)
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="RowIndx"></param>
    ''' <param name="FilterId"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub RebuildFilter(ByVal RowIndx As Integer, ByVal FilterId As Integer)
        Dim dsExTable As DataTable = New DataTable
        Dim indx As Integer
        Try
            EditRow(RowIndx)
            dsExTable = SaveExclusion()
            bsCriteriaBuilder.Delete(FilterId, UserId)
            For indx = 0 To grdView.Rows.Count - 1
                If (RowIndx <> indx) Then
                    EditRow(indx)
                    FilterCleanUp(dsExTable)
                End If
            Next
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <remarks></remarks>
    Protected Sub FilterCleanUp(ByVal dtTable As DataTable)
        Dim indx, matchCount, rptIndx As Integer
        Dim RowDelete As Integer
        Dim arIndex As ArrayList = New ArrayList
        Dim CleanupFlag As Integer = 0
        Dim itemCount As Integer
        Try
            matchCount = 0
            rptIndx = 0

            For indx = 0 To dtTable.Rows.Count - 1
                RowDelete = HasRowItem(dtTable.Rows(indx))
                itemCount = rptFilters.Items.Count
                If (RowDelete > -1) Then
                    RemoveSelectedRow(RowDelete, itemCount)
                    CleanupFlag = 1
                End If
            Next

            For indx = 0 To dtTable.Rows.Count - 1
                If (arIndex.Count > 0) Then rptIndx = arIndex(arIndex.Count - 1)
                matchCount = matchCount + HasRowItem(rptIndx, dtTable.Rows(indx), arIndex)
            Next

            If (matchCount = dtTable.Rows.Count) Then
                If (arIndex.Count > 0) Then
                    Save(arIndex)
                    RemoveSelectedRow(arIndex)
                    Retrieve()
                    CleanupFlag = 1
                End If
            End If

            If (CleanupFlag > 0) Then
                BuildFilterClause(False)
                SaveFilter(False)
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtRow"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Overloads Function HasRowItem(ByVal startIndex As Integer, ByVal dtRow As DataRow, ByRef arIndexList As ArrayList) As Integer
        Dim indx As Integer
        Dim drpFieldName, drpFilter As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim rptIndx As Integer = 0

        Try
            For indx = startIndex To rptFilters.Items.Count - 1
                'DropDownList
                drpFieldName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
                drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
                txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)
                If ((drpFieldName.SelectedValue = dtRow("FieldName")) And _
                    (txtInputvalue1.Text = dtRow("Input1")) And _
                    (drpFilter.SelectedValue = dtRow("drpFilter"))) Then
                    arIndexList.Add(indx)
                    rptIndx = 1
                    Exit For
                End If
            Next
        Catch ex As Exception
            Throw ex
        End Try
        Return rptIndx

    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtRow"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Overloads Function HasRowItem(ByVal dtRow As DataRow) As Integer
        Dim indx As Integer
        Dim drpFieldName, drpFilter As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim rptIndx As Integer = -1
        Dim srptFilterValue, sdtFilterValue As String

        Try
            For indx = 0 To rptFilters.Items.Count - 1
                'DropDownList
                drpFieldName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
                drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
                txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)
                srptFilterValue = dtRow("drpFilter").ToString.Replace("not", "").Trim()
                sdtFilterValue = drpFilter.SelectedValue.Replace("not", "").Trim()

                If ((drpFieldName.SelectedValue = dtRow("FieldName")) And _
                    (txtInputvalue1.Text = dtRow("Input1")) And _
                    (srptFilterValue = sdtFilterValue)) Then
                    If ((InStr(dtRow("drpFilter"), "not") = 0) AndAlso (InStr(drpFilter.SelectedValue, "not") > 0)) Then
                        rptIndx = indx
                        Exit For
                    End If
                End If
            Next
        Catch ex As Exception
            Throw ex
        End Try

        Return rptIndx

    End Function
#End Region

#Region "INPUT VALIDATION"

    Protected Function IsEntryValid(ByVal dtType As String, ByVal txtFilter As String, ByVal input1 As TextBox, ByVal drpPct As DropDownList, ByVal drpField As DropDownList) As Boolean
        lblMsg.BackColor = Color.Transparent
        'ClearMsg()
        ResetBackColor(input1)
        ResetBackColor(drpField)
        dtType = GetDataType(dtType)
        Select Case dtType.ToLower
            Case "int32"
                If (input1.Visible = True) Then IsNumber(input1, txtFilter)
            Case "string"
                If (input1.Visible = True) Then isString(input1, txtFilter)
            Case "datetime"
                If (input1.Visible = True) Then isDateTime(input1, txtFilter)
            Case "single"
                If (input1.Visible = True) Then IsSingle(input1, txtFilter)
                If ((drpPct.SelectedValue <> "") AndAlso (drpField.SelectedValue = "")) Then
                    DisplayMsg(lblMsg, "Invalid percentage  comparision", True)
                    SetBackColor(drpField)
                End If
            Case Else
        End Select
    End Function

    Protected Sub IsSingle(ByVal input As TextBox, ByVal txtFilter As String)
        IsNumber(input, txtFilter)
    End Sub

    Protected Sub isDateTime(ByVal input As TextBox, ByVal txtFilter As String)
        Dim strDatePart As String = ""
        Dim sMsg As String = "Invalid date format.Use hypen to specify range. Example: 01/01/05-08/27/08"
        Dim rptItem As RepeaterItem = input.Parent
        Dim rptIndx As Integer = rptItem.ItemIndex

        If ((InStr(txtFilter.ToLower(), "between")) AndAlso (InStr(input.Text, "-") <= 0)) Then
            DisplayMsg(lblMsg, sMsg, True)
            SetBackColor(input)
        ElseIf ((InStr(txtFilter.ToLower(), "between")) AndAlso (input.Text.Trim().EndsWith("-"))) Then
            DisplayMsg(lblMsg, sMsg, True)
            SetBackColor(input)
        ElseIf ((InStr(txtFilter.ToLower(), "between")) AndAlso (InStr(input.Text, "-"))) Then
            strDatePart = input.Text.Split("-")(0)
            If (ValidateDateFormat(strDatePart) = False) Then
                DisplayMsg(lblMsg, "Invalid date format. Value entered BEFORE the hypen ( " & input.Text.Split("-")(0) & " ) is not valid. Please use (mm/dd/yy) format.", True)
                SetBackColor(input)
                Exit Sub
            End If

            strDatePart = input.Text.Split("-")(1)
            If (ValidateDateFormat(strDatePart) = False) Then
                DisplayMsg(lblMsg, "Invalid date format. Value entered AFTER the hypen ( " & input.Text.Split("-")(1) & " ) is not valid. Please use (mm/dd/yy) format.", True)
                SetBackColor(input)
                Exit Sub
            End If
        End If
    End Sub

    Protected Function ValidateDateFormat(ByVal strDatePart As String) As Boolean
        Dim strSettled() As String

        Dim isValid As Boolean = True
        Try

            If (IsNumeric(strDatePart.Replace("/", "").Trim()) = False) Then
                isValid = False
            ElseIf strDatePart.Replace("/", "").Trim().Length <> 6 Then
                isValid = False
            ElseIf (InStr(strDatePart, "/") > 0) Then
                strSettled = strDatePart.Split("/")
                If (strSettled.Length <> 3) Then
                    isValid = False
                End If
            Else
                isValid = False
            End If
        Catch ex As Exception
            isValid = False
        End Try
        Return isValid

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="input"></param>
    ''' <param name="txtFilter"></param>
    ''' <remarks></remarks>
    Protected Sub isString(ByVal input As TextBox, ByVal txtFilter As String)

        Dim sMsg As String = "Invalid Format. Use hypen to specify range. Example: a-b, A-B, aa-bc"
        If ((input.Text.Trim = "")) Then
            DisplayMsg(lblMsg, "Please enter value.", True)
            SetBackColor(input)
        ElseIf ((InStr(txtFilter.ToLower(), "between")) AndAlso (InStr(input.Text, "-") <= 0)) Then
            DisplayMsg(lblMsg, sMsg, True)
            SetBackColor(input)
        ElseIf ((InStr(txtFilter.ToLower(), "between")) AndAlso (input.Text.Trim().EndsWith("-"))) Then
            DisplayMsg(lblMsg, sMsg, True)
            SetBackColor(input)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="input"></param>
    ''' <param name="txtFilter"></param>
    ''' <remarks></remarks>
    Protected Sub IsNumber(ByVal input As TextBox, ByVal txtFilter As String)
        Dim strInputText As String = Replace(input.Text, ",", "")
        Dim sMsg As String = "Invalid Format. Use hypen to specify range. Example: 100-250, 110.25-650.80"
        Dim rptItem As RepeaterItem = input.Parent
        Dim rptIndx As Integer = rptItem.ItemIndex
        Dim drpPct As DropDownList = CType(rptFilters.Items(rptIndx).FindControl("drpOperation"), DropDownList)
        If (InStr(txtFilter.Trim().ToLower(), "begin")) Then
            'Ok to used Begin comparision for Integer data Type. This implementation is added upon user request. (02/27/08) B. Data)
        ElseIf ((InStr(txtFilter.ToLower(), "between")) AndAlso (InStr(input.Text, "-") <= 0)) Then
            DisplayMsg(lblMsg, sMsg, True)
            SetBackColor(input)
        ElseIf ((InStr(txtFilter.ToLower(), "between")) AndAlso (input.Text.Trim().EndsWith("-"))) Then
            DisplayMsg(lblMsg, sMsg, True)
            SetBackColor(input)
        ElseIf ((InStr(txtFilter.ToLower(), "between")) AndAlso (InStr(input.Text, "-"))) Then
            If (IsNumber(input.Text.Split("-")(0).Trim())) = False Then
                DisplayMsg(lblMsg, "Invalid Format. Value entered BEFORE the hypen ( " & input.Text.Split("-")(0) & " ) is not numeric", True)
                SetBackColor(input)
            ElseIf (IsNumber(input.Text.Split("-")(1).Trim())) = False Then
                DisplayMsg(lblMsg, "Invalid Format. Value entered AFTER the hypen ( " & input.Text.Split("-")(1) & " ) is not numeric", True)
                SetBackColor(input)
            End If
        ElseIf (IsNumeric(strInputText) = False) Then
            DisplayMsg(lblMsg, "Please check your criteria. Values must be numeric.", True)
            SetBackColor(input)
        ElseIf ((drpPct.Visible = True) AndAlso (drpPct.SelectedValue <> "") AndAlso (InStr(strInputText, ".") > 0)) Then
            DisplayMsg(lblMsg, "Please enter percentage as a whole number. The module does the conversion for you.", True)
            SetBackColor(input)
        ElseIf ((drpPct.Visible = True) AndAlso (drpPct.SelectedValue <> "") AndAlso (strInputText <= 0)) Then
            DisplayMsg(lblMsg, "Please enter value must be greater than zero.", True)
            SetBackColor(input)
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="txtValue"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function isNumber(ByVal txtValue As String) As Boolean
        Return IsNumeric(txtValue)
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drp"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function DisplayJoinMsg(ByVal drp As DropDownList) As Boolean
        Dim isNotOk As Boolean = False
        If (drp.SelectedValue = "") Then
            DisplayMsg(lblMsg, "Invalid criteira. Refine your criteria", True)
            SetBackColor(drp)
            isNotOk = True
        End If

        Return isNotOk
    End Function

#End Region

#Region "ERROR HANDELING"
    ''' <summary>
    '''     
    ''' </summary>
    ''' <param name="lbl"></param>
    ''' <param name="msg"></param>
    ''' <param name="isError"></param>
    ''' <remarks></remarks>
    Protected Sub DisplayMsg(ByVal lbl As Label, ByVal msg As String, ByVal isError As Boolean)
        If (isError) Then
            lbl.BackColor = Color.LightGoldenrodYellow
            lbl.ForeColor = Color.Red
            imgMsg.Visible = True
        Else
            lbl.BackColor = Color.Transparent
            lbl.ForeColor = Color.Black
            imgMsg.Visible = False
        End If
        lbl.Text = msg
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub HasOverlapMsg()
        Try
            If (InStr(lblMsg.Text.ToLower(), "overlap") <= 0) Then ClearMsg()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ClearMsg()
        lblMsg.BackColor = Color.Transparent
        lblMsg.Text = ""
        imgMsg.Visible = False
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="txtObj"></param>
    ''' <remarks></remarks>
    Protected Sub SetBackColor(ByVal txtObj As TextBox)
        txtObj.BackColor = Color.Tan
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drpObj"></param>
    ''' <remarks></remarks>
    Protected Sub SetBackColor(ByVal drpObj As DropDownList)
        drpObj.BackColor = Color.Tan
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="txtObj"></param>
    ''' <remarks></remarks>
    Protected Sub ResetBackColor(ByVal txtObj As TextBox)
        txtObj.BackColor = Color.White
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drpObj"></param>
    ''' <remarks></remarks>
    Protected Sub ResetBackColor(ByVal drpObj As DropDownList)
        drpObj.BackColor = Color.White
    End Sub

#End Region

#Region "BUILD CRITERIA CLAUSE"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub BuildFilterClause(Optional ByVal CalledByUserAction As Boolean = True)
        Dim indx As Integer
        Dim drpFieldName, drpFilter, drpClause, drpClause1, drpOperation, drpField As DropDownList
        Dim txtInputvalue1 As TextBox
        Dim aCriteria As ArrayList = New ArrayList()
        Dim aComparison As ArrayList = New ArrayList
        Dim sFilterName As String
        Dim sClause As String
        Dim sUserFriendlyClause As String = ""

        Try
            ShowLoadProgress(True)
            lblFilter.Text = ""
            lblFriendlyDisplay.Text = ""
            drpClause1 = Nothing
            For indx = 0 To rptFilters.Items.Count - 1
                'DropDownList
                drpFieldName = CType(rptFilters.Items(indx).FindControl("drpName"), DropDownList)
                drpFilter = CType(rptFilters.Items(indx).FindControl("drpFilter"), DropDownList)
                drpClause = CType(rptFilters.Items(indx).FindControl("drpClause"), DropDownList)
                drpOperation = CType(rptFilters.Items(indx).FindControl("drpOperation"), DropDownList)
                drpField = CType(rptFilters.Items(indx).FindControl("drpField"), DropDownList)

                'TextBox
                txtInputvalue1 = CType(rptFilters.Items(indx).FindControl("txtInputvalue1"), TextBox)

                If (drpFieldName.Items.Count > 0) Then
                    If ((drpFieldName.SelectedValue <> "0") AndAlso (drpFilter.SelectedValue <> "")) Then

                        '*************************************************************
                        ' Reference: #2 On FlowChart
                        '*************************************************************
                        IsEntryValid(drpFieldName.SelectedValue, drpFilter.SelectedValue, txtInputvalue1, drpOperation, drpField)
                        If ((lblMsg.Text <> "") And InStr(lblMsg.Text.ToLower(), "overlap") <= 0) Then
                            Exit Sub
                        Else
                            ResetBackColor(drpClause)
                            sClause = GetFieldClause(GetDbFieldName(drpFieldName.SelectedValue), drpFieldName.SelectedValue, drpFilter.SelectedValue, txtInputvalue1, drpOperation, drpField)
                            sUserFriendlyClause = sUserFriendlyClause & Environment.NewLine & GetFriendlyClause(drpFieldName, drpFilter, txtInputvalue1, drpOperation, drpField) & " " & drpClause.SelectedValue.ToUpper()
                            If ((indx > 0) AndAlso (sClause.Trim().Length > 0)) Then
                                drpClause1 = CType(rptFilters.Items(indx - 1).FindControl("drpClause"), DropDownList)
                                If (DisplayJoinMsg(drpClause1) = True) Then Exit Sub
                            End If
                            aCriteria.Add(sClause.Trim() & " " & drpClause.SelectedValue)
                            If ((InStr(drpFilter.SelectedValue.ToLower(), "not") > 0) AndAlso (drpFilter.SelectedValue.ToLower <> "not in")) Then
                                aComparison.Add("not")
                            Else
                                aComparison.Add("")
                            End If
                        End If
                    End If
                End If
            Next

            If (sUserFriendlyClause.EndsWith("AND")) Then sUserFriendlyClause = sUserFriendlyClause.Substring(0, sUserFriendlyClause.LastIndexOf("AND")).Trim()
            If (sUserFriendlyClause.EndsWith("OR")) Then sUserFriendlyClause = sUserFriendlyClause.Substring(0, sUserFriendlyClause.LastIndexOf("OR")).Trim()

            sFilterName = txtfilterName.Text.Trim()

            If (sUserFriendlyClause.Length >= 100) Then
                txtfilterName.Text = sUserFriendlyClause.Substring(0, sUserFriendlyClause.Substring(0, 100).LastIndexOf(" ")).Trim() & "..."
            Else
                txtfilterName.Text = sUserFriendlyClause.Trim()
            End If

            'Overwrite previous assignment
            If ((CalledByUserAction = False) And (sFilterName.Trim() <> "")) Then
                txtfilterName.Text = sFilterName
            End If

            lblFriendlyDisplay.Text = sUserFriendlyClause
            lblFilter.Text = FormatCriteria(aCriteria, aComparison)

        Catch ex As Exception
            Throw ex
        Finally
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drpFieldName"></param>
    ''' <param name="drpFilter"></param>
    ''' <param name="txtInputvalue1"></param>
    ''' <param name="drpOperation"></param>
    ''' <param name="drpField"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Overloads Function GetFriendlyClause(ByVal drpFieldName As DropDownList, ByVal drpFilter As DropDownList, ByVal txtInputvalue1 As TextBox, ByVal drpOperation As DropDownList, ByVal drpField As DropDownList)
        Dim sClause As String = "Accounts with"
        If (drpFieldName.SelectedValue <> "") Then
            sClause = sClause & " " & drpFieldName.SelectedItem.Text
        End If

        sClause = sClause & " " & GetConjuctionFlow(GetDataType(drpFieldName.SelectedValue), drpFilter.SelectedValue)
        If (drpFilter.SelectedItem.Text <> "") Then
            sClause = sClause & " " & GetComparisionClause(drpFilter.SelectedValue)
        End If
        If (txtInputvalue1.Text.Trim() <> "") Then
            sClause = sClause & " " & txtInputvalue1.Text
        End If
        If (drpOperation.SelectedValue <> "") Then
            sClause = sClause & " " & drpOperation.SelectedItem.Text
        End If
        If (drpField.SelectedValue <> "") Then
            sClause = sClause & " " & drpField.SelectedItem.Text
        End If

        Return sClause
    End Function

    Protected Function GetConjuctionFlow(ByVal dtType As String, ByVal JoinClause As String) As String
        Dim sClause As String = ""
        Select Case dtType.ToLower()
            Case "string"
                If (JoinClause.ToLower().IndexOf("exact") > 0) Then
                    sClause = "that are"
                Else
                    sClause = "that do"
                End If
            Case Else
                If (JoinClause.ToLower().IndexOf("between") > 0) Then
                    sClause = "that do"
                Else
                    sClause = "that are"
                End If
        End Select
        Return sClause
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dt"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Overloads Function GetFriendlyClause(ByVal dt As DataTable)
        Dim sClause As String = ""
        Dim indx As Integer
        For indx = 0 To dt.Rows.Count - 1
            sClause = sClause & " " & "and Accounts with"
            If (dt.Rows(indx)("FieldName") <> "") Then
                sClause = sClause & " " & FormatFieldName(dt.Rows(indx)("FieldName").ToString().Split(":")(2))
            End If
            sClause = sClause & " " & GetConjuctionFlow(GetDataType(dt.Rows(indx)("FieldName").ToString()), dt.Rows(indx)("drpFilter").ToString())
            If (dt.Rows(indx)("drpFilter") <> "") Then
                sClause = sClause & " " & GetComparisionClause(dt.Rows(indx)("drpFilter"))
            End If
            If (dt.Rows(indx)("Input1") <> "") Then
                sClause = sClause & " " & dt.Rows(indx)("Input1")
            End If
            If (dt.Rows(indx)("drpPctOf") <> "") Then
                sClause = sClause & dt.Rows(indx)("drpPctOf")
            End If
            If (dt.Rows(indx)("drpPctField") <> "") Then
                sClause = sClause & " " & FormatFieldName(dt.Rows(indx)("drpPctField").ToString().Split(":")(2))
            End If
        Next

        Return sClause
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sFilter"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetComparisionClause(ByVal sFilter As String)
        Dim sComparison As String = ""
        If (InStr(sFilter, "not") > 0) Then
            Select Case sFilter.ToLower()
                Case "not in"
                    sComparison = sFilter
                Case "not exact", "not ="
                    sComparison = "not equal to"
                Case "not any"
                    sComparison = "not contain"
                Case "not begin"
                    sComparison = "not begin with"
                Case "not end"
                    sComparison = "not end with"
                Case "not between"
                    sComparison = "not fall between"
                Case "not >="
                    sComparison = "not greater or equal to"
                Case "not >"
                    sComparison = "not greater than"
                Case "not <"
                    sComparison = "not less than"
                Case "not <="
                    sComparison = "not less or equal to"
            End Select
        Else
            Select Case sFilter.ToLower()
                Case "not in"
                    sComparison = sFilter
                Case "exact", "="
                    sComparison = "equal to"
                Case "any"
                    sComparison = "contain"
                Case "begin"
                    sComparison = "begin with"
                Case "end"
                    sComparison = "end with"
                Case "between"
                    sComparison = "fall between"
                Case ">="
                    sComparison = "greater or equal to"
                Case ">"
                    sComparison = "greater than"
                Case "<"
                    sComparison = "less than"
                Case "<="
                    sComparison = "less or equal to"
            End Select
        End If
        Return sComparison
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="aCriteriaList"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function FormatCriteria(ByVal aCriteriaList As ArrayList, ByVal aComparison As ArrayList) As String
        Dim sCriteria As String = "("
        Dim sIndxValue As String = ""
        Dim sCurrentJoinClause As String = ""
        Dim indx As Integer
        Dim sPreviousJoin As String = ""
        Dim sNegationJoin As String = ""
        Dim iItems As Integer = aCriteriaList.Count - 1
        Dim sb As StringBuilder = New StringBuilder()

        For indx = 0 To iItems
            sNegationJoin = ""
            sIndxValue = aCriteriaList(indx).ToString.Trim()
            If (indx < iItems) Then
                sNegationJoin = aComparison(indx + 1).ToString.Trim()
            Else
                sNegationJoin = aComparison(indx).ToString.Trim()
            End If
            sCurrentJoinClause = GetJoinClause(sIndxValue)
            If ((indx = iItems) AndAlso (sCurrentJoinClause <> "")) Then
                sCriteria = sCriteria & " " & sIndxValue.Substring(0, sIndxValue.LastIndexOf(sCurrentJoinClause) - 1) & ")"
            ElseIf (sCurrentJoinClause = "and") Then
                If (indx = 0 And aComparison(indx) <> "") Then sCriteria = sNegationJoin & sCriteria
                sCriteria = sCriteria & " " & sIndxValue.Substring(0, sIndxValue.LastIndexOf(sCurrentJoinClause) - 1) & ") " & sCurrentJoinClause & " " & sNegationJoin & " ("
            ElseIf (sCurrentJoinClause = "") Then
                If (indx = 0 And aComparison(indx) <> "") Then
                    sCriteria = sNegationJoin & sCriteria & " " & sIndxValue & ")"
                Else
                    sCriteria = sCriteria & " " & sIndxValue & ")"                    
                End If                
            Else
                If (indx = 0 And aComparison(indx) <> "") Then
                    sCriteria = sNegationJoin & sCriteria & " " & sIndxValue
                Else
                    sCriteria = sCriteria & " " & sIndxValue
                End If
            End If
            sPreviousJoin = sCurrentJoinClause
        Next

        If (sCriteria.ToLower.EndsWith("()")) Then sCriteria = sCriteria.Substring(0, sCriteria.LastIndexOf("()")).Trim()
        If (sCriteria.ToLower.EndsWith("and")) Then sCriteria = sCriteria.Substring(0, sCriteria.LastIndexOf("and")).Trim()
        If (sCriteria.ToLower.EndsWith("or")) Then sCriteria = sCriteria.Substring(0, sCriteria.LastIndexOf("or")).Trim()
        If (sCriteria = "(") Then sCriteria = ""
        Return sCriteria

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sCriteria"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetJoinClause(ByVal sCriteria As String) As String
        Dim sJoinConj As String = ""
        If sCriteria.ToLower().EndsWith("and") Then
            sJoinConj = "and"
        ElseIf sCriteria.ToLower().EndsWith("or") Then
            sJoinConj = "or"
        End If
        Return sJoinConj
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="fieldName"></param>
    ''' <param name="dtType"></param>
    ''' <param name="filter"></param>
    ''' <param name="oText1"></param>
    ''' <param name="drpOp"></param>
    ''' <param name="drpField"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetFieldClause(ByVal fieldName As String, ByVal dtType As String, ByVal filter As String, ByVal oText1 As TextBox, ByVal drpOp As DropDownList, ByVal drpField As DropDownList) As String
        Dim strFilterClause As String = ""
        dtType = GetDataType(dtType)
        Dim strQuery As String = MapOperator(fieldName, filter, dtType, oText1, drpOp, drpField)
        If (strQuery.Trim <> "") Then strFilterClause = strQuery
        Return strFilterClause
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="fieldName"></param>
    ''' <param name="filter"></param>
    ''' <param name="dtType"></param>
    ''' <param name="oText1"></param>
    ''' <param name="drpOp"></param>
    ''' <param name="drpField"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function MapOperator(ByVal fieldName As String, ByVal filter As String, ByVal dtType As String, ByVal oText1 As TextBox, ByVal drpOp As DropDownList, ByVal drpField As DropDownList) As String
        Dim strOperatorToken As String = ""
        Dim sDBFieldName As String = ""
        Dim strNegationClause As String = ""
        If ((InStr(filter, "not") > 0) AndAlso (filter.ToLower <> "not in")) Then
            filter = filter.Replace("not", "").Trim()
            strNegationClause = "not"
        End If

        Select Case filter.ToLower()
            Case "<", ">", "=", ">=", "<="
                If ((drpOp.Visible = True) AndAlso (drpOp.SelectedValue <> "")) Then
                    sDBFieldName = GetDbFieldName(drpField.SelectedValue)
                    strOperatorToken = "(" & fieldName + " " & filter & " (" & (oText1.Text / 100) & " * " & sDBFieldName & ")) "
                Else
                    strOperatorToken = " ( " & strNegationClause & " (" & fieldName + " " & filter & " '" & oText1.Text & "' )) "
                End If

            Case "exact"
                If (InStr(oText1.Text, "|")) Then
                    strOperatorToken = "(" & GetExactParsedValues(oText1.Text, fieldName) & ") "
                Else
                    strOperatorToken = "(RTrim(LTrim(" & fieldName + ")) = '" & oText1.Text & "') "
                End If
            Case "not in"
                strOperatorToken = "(" & fieldName + " not in ( " & oText1.Text & ")) "
            Case "any"
                If (InStr(oText1.Text, "|")) Then
                    strOperatorToken = "(" & GetLikeParsedValues(oText1.Text, fieldName) & ") "
                Else
                    strOperatorToken = "(" & fieldName & " LIKE '%" & oText1.Text & "%' ) "
                End If

            Case "begin"
                If (InStr(oText1.Text, "|")) Then
                    strOperatorToken = "(" & GetBParsedValues(oText1.Text, fieldName) & ") "
                Else
                    strOperatorToken = "(LTrim(" & fieldName + ")  LIKE '" & oText1.Text & "%') "
                End If
            Case "end"
                If (InStr(oText1.Text, "|")) Then
                    strOperatorToken = "(" & GetEParsedValues(oText1.Text, fieldName) & ") "
                Else
                    strOperatorToken = "(RTrim(" & fieldName + ")  LIKE '%" & oText1.Text & "') "
                End If
            Case "between"
                If (dtType.ToLower.Equals("string")) Then
                    If (Trim(oText1.Text.Split("-")(0)).Length > 1) Then
                        strOperatorToken = "( LTRIM(" & fieldName + ")  LIKE  '" & oText1.Text.Split("-")(0).Trim() & "%' OR   LTRIM(" & fieldName + ")  LIKE '" & oText1.Text.Split("-")(1).Trim() & "%') "
                    Else
                        strOperatorToken = "( LTRIM(" & fieldName + ") LIKE  '[" & oText1.Text & "]%' ) "
                    End If

                ElseIf ((dtType.ToLower.Equals("datetime")) Or (dtType.ToLower.Equals("int32")) Or (dtType.ToLower.Equals("single"))) Then
                    strOperatorToken = "(" & fieldName & " >= '" & oText1.Text.Split("-")(0).Trim() & "' AND " & fieldName & " <='" & oText1.Text.Split("-")(1).Trim() & "') "
                End If
            Case "1", "0"
                strOperatorToken = "= " & filter
            Case Else

        End Select
        Return strOperatorToken
    End Function

    Protected Function GetLikeParsedValues(ByVal sToParse As String, ByVal fieldName As String) As String
        Dim sFormatted As String = ""
        Dim sVal() As String = sToParse.Split("|")
        Dim indx As Integer
        Try
            For indx = 0 To sVal.Length - 1
                If (sFormatted <> "") Then sFormatted = sFormatted & " OR "
                sFormatted = sFormatted & "(" & fieldName & " LIKE " & "'%" & sVal(indx).Trim() & "%' ) "
            Next
            If sFormatted.Length > 0 Then sFormatted = "(" & sFormatted & ")"
        Catch ex As Exception

        End Try
        Return sFormatted
    End Function

    Protected Function GetExactParsedValues(ByVal sToParse As String, ByVal fieldName As String) As String
        Dim sFormatted As String = ""
        Dim sVal() As String = sToParse.Split("|")
        Dim indx As Integer
        Try
            For indx = 0 To sVal.Length - 1
                If (sFormatted <> "") Then sFormatted = sFormatted & " OR "
                sFormatted = sFormatted & "(" & fieldName & " = " & "'" & sVal(indx).Trim() & "' ) "
            Next
            If sFormatted.Length > 0 Then sFormatted = "(" & sFormatted & ")"
        Catch ex As Exception

        End Try
        Return sFormatted
    End Function

    Protected Function GetBParsedValues(ByVal sToParse As String, ByVal fieldName As String) As String
        Dim sFormatted As String = ""
        Dim sVal() As String = sToParse.Split("|")
        Dim indx As Integer
        Try
            For indx = 0 To sVal.Length - 1
                If (sFormatted <> "") Then sFormatted = sFormatted & " OR "
                sFormatted = sFormatted & "(LTrim(" & fieldName + ")  LIKE '" & sVal(indx).Trim() & "%') "
            Next
            If sFormatted.Length > 0 Then sFormatted = "(" & sFormatted & ")"
        Catch ex As Exception

        End Try
        Return sFormatted
    End Function

    Protected Function GetEParsedValues(ByVal sToParse As String, ByVal fieldName As String) As String
        Dim sFormatted As String = ""
        Dim sVal() As String = sToParse.Split("|")
        Dim indx As Integer
        Try
            For indx = 0 To sVal.Length - 1
                If (sFormatted <> "") Then sFormatted = sFormatted & " OR "
                sFormatted = sFormatted & "(RTrim(" & fieldName + ")  LIKE '%" & sVal(indx).Trim() & "') "
            Next
            If sFormatted.Length > 0 Then sFormatted = "(" & sFormatted & ")"
        Catch ex As Exception

        End Try
        Return sFormatted
    End Function

#End Region

#Region "GET USER FRIENDLY FIELD NAME"
    ''' <summary>
    ''' Returns User friendly fiel name to display
    ''' </summary>
    ''' <param name="dbFieldName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function FormatFieldName(ByVal dbFieldName As String) As String
        If (dbFieldName.IndexOf(" ") <= 0) Then

            Dim arLetters As New ArrayList
            Dim arLetterIndx As New ArrayList
            Dim indx, prevIndx As Integer

            Dim reg As RegularExpressions.Regex
            Dim rgMatch As RegularExpressions.MatchCollection

            rgMatch = reg.Matches(dbFieldName, "[A-Z]")
            For indx = 0 To rgMatch.Count - 1
                arLetters.Add(rgMatch(indx).Value)
                arLetterIndx.Add(rgMatch(indx).Index)
            Next

            For indx = 0 To arLetters.Count - 1
                If ((indx > 0) AndAlso (arLetterIndx(indx) = (arLetterIndx(indx - 1) + 1)) AndAlso (arLetters(indx) = (arLetters(indx - 1)))) Then
                    dbFieldName = dbFieldName.Replace(" " & arLetters(indx), arLetters(indx))
                ElseIf ((indx > 0) AndAlso (arLetterIndx(indx) = (arLetterIndx(indx - 1) + 1))) Then
                    dbFieldName = dbFieldName.Replace(arLetters(indx), "" & arLetters(indx))
                Else
                    dbFieldName = dbFieldName.Replace(arLetters(indx), " " & arLetters(indx))
                End If
            Next

            're-check for last index
            Dim sLastField As String = dbFieldName.Substring(dbFieldName.LastIndexOf(arLetters(arLetters.Count - 1))).Trim()
            If (sLastField <> "" AndAlso sLastField.Length > 1) Then
                dbFieldName = dbFieldName.Replace(sLastField, " " & sLastField)
            End If

        End If

        Return dbFieldName.Trim()

    End Function


#End Region

#Region "PREVIEW CRITERIA RESULT (TOP LEVEL)"

    ''' <summary>
    ''' 
    ''' </summary>    
    ''' <param name="sFilter"></param>
    ''' <param name="iGridSource"></param>
    ''' <remarks></remarks>
    Protected Sub LoadPreviewGrid(ByVal sFilter As String, ByVal iGridSource As Integer)
        Dim dsPreview As Data.DataSet = New Data.DataSet
        Dim EntityCriteriaId = ParseEntityCriteriaId()
        Try
            If (((lblMsg.Text) <> "") And InStr(lblMsg.Text.ToLower(), "overlap") <= 0) Then
                Exit Sub
            End If

            sFilter = sFilter.Replace("&gt;", ">")
            sFilter = sFilter.Replace("&lt;", "<")
            If (txtEditId.Text <> "") Then iGridSource = txtEditId.Text
            dsPreview = bsCriteriaBuilder.Preview(sFilter, CInt(EntityCriteriaId), iGridSource, rdList.SelectedValue.ToLower())
            rptPreview.DataSource = dsPreview.Tables(0).DefaultView
            rptPreview.DataBind()

            If (dsPreview.Tables(0).Rows.Count <= 0) Then
                lblNotFound.Visible = True
                ExpandAll.Enabled = False
            Else
                ExpandAll.Enabled = True
                ExpandAll.Checked = False
                lblNotFound.Visible = False
            End If
        Catch ex As Exception
            rptPreview.Visible = False
            Throw ex
        Finally
            dsPreview.Dispose()
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Overloads Sub GetDashBoardSummary()
        Dim ds As DataSet = New DataSet
        Dim dsoverlap As DataSet = New DataSet
        Dim sb As StringBuilder = New StringBuilder
        Dim iFilterId As Integer = 0
        Dim EntityCriteriaId = ParseEntityCriteriaId()
        Try
            ShowLoadProgress(True)

            If (txtEditId.Text.Trim() <> "") Then iFilterId = CInt(txtEditId.Text)
            dsoverlap = bsCriteriaBuilder.Validate(rdList.SelectedValue.ToLower(), iFilterId, lblFilter.Text, CInt(EntityCriteriaId))
            If (dsoverlap.Tables(0).Rows.Count > 0) Then
                '****************************************************************
                ' Reference: #4 on flowchart
                '****************************************************************
                HighlightOverlap(dsoverlap.Tables(0))
            Else
                '****************************************************************
                ' Reference: #5 on flowchart
                '****************************************************************
                ShowFilter(True)
                PreviewOn(True)
                ds = bsCriteriaDashBoard.GetDashBoard(0, CInt(EntityCriteriaId), lblFilter.Text, rdList.SelectedValue.ToLower())
                '****************************************************************
                ' Reference: #6 on flowchart
                '****************************************************************
                DisplayDashBoard(ds.Tables(0))
            End If
        Catch ex As Exception
            Throw ex
        Finally
            ds.Dispose()
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function ParseEntityCriteriaId() As String
        Dim sId As String = "0"
        If (sQueryCriteriaId > 0) Then
            sId = sQueryCriteriaId
        ElseIf (sEntityId > 0) Then
            sId = sEntityId
        End If
        Return sId
    End Function
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="IgnoreOverlap"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub GetDashBoardSummary(ByVal IgnoreOverlap As Boolean)
        Dim ds As DataSet = New DataSet
        Dim sAdjustedCriteria = GetFilterCriteria()
        Dim EntityCriteriaId = ParseEntityCriteriaId()

        Dim iFilterId As Integer = 0
        Try
            ShowLoadProgress(True)

            If (txtEditId.Text.Trim() <> "") Then iFilterId = CInt(txtEditId.Text)
            ShowFilter(True)
            PreviewOn(True)
            ds = bsCriteriaDashBoard.GetDashBoard(0, CInt(EntityCriteriaId), sAdjustedCriteria, rdList.SelectedValue.ToLower())
            DisplayDashBoard(ds.Tables(0))
        Catch ex As Exception
            Throw ex
        Finally
            ds.Dispose()
            ShowLoadProgress(False)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetFilterCriteria()
        Dim sAggriateCriteria As String = ""
        Dim sCriteria As String = ""
        Dim sParseCriteria As String = ""
        Dim sCurrentCriteria As String = ""
        Dim sAgFilterClause As String = ""
        Dim chkExclusion As CheckBox
        Dim grdRowIndx As Integer
        sCurrentCriteria = lblFilter.Text

        For grdRowIndx = 0 To grdView.Rows.Count - 1
            chkExclusion = CType(grdView.Rows(grdRowIndx).FindControl("chkExclusion"), CheckBox)
            If (chkExclusion.Visible) Then
                If (chkExclusion.Checked = False) Then
                    sParseCriteria = CType(grdView.Rows(grdRowIndx).FindControl("lblFilterClause"), Label).Text
                    If ((sAgFilterClause.Trim() <> "") AndAlso (sParseCriteria.Trim() <> "")) Then sAgFilterClause = sAgFilterClause & " or "
                    sAgFilterClause = sAgFilterClause & " " & sParseCriteria.Trim()
                End If
            End If
        Next
        If sAgFilterClause.Trim() <> "" Then sCurrentCriteria = sCurrentCriteria & " and not ( " & sAgFilterClause & ")"
        sAggriateCriteria = sCurrentCriteria
        Return sAggriateCriteria
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtDashBoard"></param>
    ''' <remarks></remarks>
    Protected Sub DisplayDashBoard(ByVal dtDashBoard As DataTable)
        Dim sb As StringBuilder = New StringBuilder
        Try
            If dtDashBoard.Rows.Count > 0 Then
                sb.Append("Total Clients: " & dtDashBoard.Rows(0)("ClientCount") & " , ")
                sb.Append("Total Accounts: " & dtDashBoard.Rows(0)("AccountCount") & " , ")
                sb.Append("Total SDA Balance: " & String.Format("{0:c}", dtDashBoard.Rows(0)("TotalSDAAmount")))
                lblDashBoard.Visible = True
                lblDashBoard.Text = sb.ToString()
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

#Region "PREVIEW DRILL"

    ''' <summary>
    ''' Drill down to view Client's Account Information
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub ExpandCollaps(ByVal sender As Object, ByVal e As ImageClickEventArgs)

        Dim imgDetail As ImageButton
        Dim row As RepeaterItem
        Try
            imgDetail = CType(sender, ImageButton)
            row = imgDetail.Parent
            ExpandCollaps(row.ItemIndex, False)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="indx"></param>
    ''' <param name="isAll"></param>
    ''' <remarks></remarks>
    Protected Sub ExpandCollaps(ByVal indx As Integer, ByVal isAll As Boolean)
        Dim ClientId As Integer
        Dim ltDrill As Literal
        Dim imgDetail As ImageButton

        Try
            imgDetail = CType(rptPreview.Items(indx).FindControl("imgExpand"), ImageButton)
            ClientId = CInt(CType(rptPreview.Items(indx).FindControl("lblClientID"), Label).Text)
            ltDrill = CType(rptPreview.Items(indx).FindControl("tblDrill"), Literal)
            If (imgDetail.ImageUrl.IndexOf("plus") > 0) Then
                If (isAll = False) Then CollapsAllPreviewItems()
                imgDetail.ImageUrl = ResolveUrl("~/images/tree_minus.bmp")
                ExpandSelected(ltDrill, ClientId)
            Else
                imgDetail.ImageUrl = ResolveUrl("~/images/tree_plus.bmp")
                ltDrill.Visible = False
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub CollapsAllPreviewItems()
        Dim indx As Integer
        Dim imgDetail As ImageButton
        Try
            For indx = 0 To rptPreview.Items.Count - 1
                CType(rptPreview.Items(indx).FindControl("tblDrill"), Literal).Visible = False
                imgDetail = CType(rptPreview.Items(indx).FindControl("imgExpand"), ImageButton)
                imgDetail.ImageUrl = ResolveUrl("~/images/tree_plus.bmp")
            Next
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="lt"></param>
    ''' <param name="ClientId"></param>
    ''' <remarks></remarks>
    Protected Sub ExpandSelected(ByRef lt As Literal, ByVal ClientId As Integer)
        Dim sb As StringBuilder = New StringBuilder()
        Dim dsPreview As DataSet = New DataSet
        Dim indx As Integer
        Dim sGridFilterId As Integer
        Try
            If (txtEditId.Text.Trim() <> "") Then sGridFilterId = CInt(txtEditId.Text)
            dsPreview = bsCriteriaBuilder.Preview(ClientId, sGridFilterId)
            If (dsPreview.Tables(0).Rows.Count > 0) Then
                ExpandAll.Visible = True
                CreateTableHeader(sb)
                For indx = 0 To dsPreview.Tables(0).Rows.Count - 1
                    sb.Append("<tr><td class='GridViewItems' align='left'>")
                    sb.Append(dsPreview.Tables(0).Rows(indx)("AccountId"))
                    sb.Append("</td><td class='GridViewItems' align='left'>")
                    sb.Append(dsPreview.Tables(0).Rows(indx)("CurrentCreditorAccountNumber"))
                    sb.Append("</td><td class='GridViewItems' align='left'>")
                    sb.Append(dsPreview.Tables(0).Rows(indx)("OriginalCreditor"))
                    sb.Append("</td><td class='GridViewItems'  align='left'>")
                    sb.Append(dsPreview.Tables(0).Rows(indx)("CurrentCreditor"))
                    sb.Append("</td><td class='GridViewItems' align='left'>")
                    sb.Append(dsPreview.Tables(0).Rows(indx)("CurrentCreditorState"))
                    sb.Append("</td><td class='GridViewItems' align='left'>")
                    sb.Append(dsPreview.Tables(0).Rows(indx)("AccountAge"))
                    sb.Append("</td><td class='GridViewItems' align='left'>")
                    sb.Append(dsPreview.Tables(0).Rows(indx)("AccountStatus"))
                    sb.Append("</td><td class='GridViewItems' align='right'>")
                    sb.Append(String.Format("{0:c}", dsPreview.Tables(0).Rows(indx)("CurrentAmount")))
                    sb.Append("</td></tr>")
                Next
                lt.Text = sb.ToString & "</table></td></tr></table>"
                lt.Visible = True
            Else
                ExpandAll.Visible = False
                lt.Visible = False
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsPreview.Dispose()
        End Try
    End Sub


    ''' <summary>
    ''' Create Header for a drill down account 
    ''' </summary>
    ''' <param name="sb"></param>
    ''' <remarks></remarks>
    Protected Sub CreateTableHeader(ByRef sb As StringBuilder)
        sb.Length = 0
        sb.Append("<table border='1' borderColor='lightblue' cellpadding='0' cellspacing='0' width='100%'><tr><td valign='top'>")
        sb.Append("<table border='0' bgcolor='lightpink' cellpadding='0' cellspacing='0' width='100%'>")
        sb.Append("<tr bgcolor='#cccccc' height='20px'>")
        sb.Append("<td class='GridViewItems' align='left'  width='65px'><b>Account Id</b></td>")
        sb.Append("<td class='GridViewItems' align='left'  width='125px'><b>Account Number</b></td>")
        sb.Append("<td class='GridViewItems' align='left'  width='125px'><b>Original Creditor</b></td>")
        sb.Append("<td class='GridViewItems' align='left'  width='140px'><b>Current Creditor</b></td>")
        sb.Append("<td class='GridViewItems' align='left'  width='50px'><b>State</b></td>")
        sb.Append("<td class='GridViewItems' align='left'  width='30px'><b>Age</b></td>")
        sb.Append("<td class='GridViewItems' align='left'  width='150px'><b>Account Status</b></td>")
        sb.Append("<td class='GridViewItems' align='right' width='65px'><b>Debt&nbsp;Amount</b></td></tr>")
    End Sub

    ''' <summary>
    ''' Check/Uncheck to display or collaps drill down account information.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub ExpandAll_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim indx As Integer
        If (ExpandAll.Checked = True) Then
            For indx = 0 To rptPreview.Items.Count - 1
                ExpandCollaps(indx, True)
            Next
        Else
            CollapsAllPreviewItems()
        End If
    End Sub

#End Region

End Class
