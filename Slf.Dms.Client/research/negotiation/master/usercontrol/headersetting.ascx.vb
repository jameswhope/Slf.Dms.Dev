Imports Drg.Util.Helpers
Imports Slf.Dms.Records
Imports Slf.Dms.Controls
Imports system.Data.SqlClient
Imports AssistedSolutions.WebControls


Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper
Imports Lexxiom.BusinessServices
Imports Lexxiom.BusinessData
Imports System.Drawing
Imports System.Text


Partial Class admin_settings_rules_negotiation_usercontrol_headersetting
    Inherits System.Web.UI.UserControl

    Dim bsAssignmentHeader As Lexxiom.BusinessServices.Assignment = New Lexxiom.BusinessServices.Assignment
    Dim bsCriteriaBuilder As Lexxiom.BusinessServices.CriteriaBuilder = New Lexxiom.BusinessServices.CriteriaBuilder()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'UserID = CType(Page.User.Identity.Name, Integer)
        If Not IsPostBack Then
            ClearMsg()
            ShowAvailableFilters()
            LoadExistingHeaders()
            'Profile.FirstName = "Bereket"
            'Profile.LastName = "Data"
            'Profile.Age = 123456
        End If
    End Sub

    Protected Sub ShowAvailableFilters()
        Dim dsViewColumns As DataSet = New DataSet
        Dim dtFilterList As Data.DataTable = New Data.DataTable()                
        Dim dtRow As Data.DataRow
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
                    End If
                Next
                rptheader.DataSource = dtFilterList
                rptheader.DataBind()
            Else
                Throw New Exception("Failed to retrive column names from distribution view.")
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

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
        End Select

        Return sLocalDataType

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub rptheader_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptheader.ItemDataBound
        Dim drpAggregate, drpOrder As DropDownList
        Dim dtFilters As New Data.DataTable
        Dim txtDataType, txtHeaderName As TextBox

        If (e.Item.ItemType = ListItemType.Item) Or (e.Item.ItemType = ListItemType.AlternatingItem) Then
            drpAggregate = CType(e.Item.FindControl("drpAggregate"), DropDownList)
            drpOrder = CType(e.Item.FindControl("drpOrder"), DropDownList)
            txtDataType = CType(e.Item.FindControl("txtDatatype"), TextBox)
            txtHeaderName = CType(e.Item.FindControl("txtHeaderName"), TextBox)
            txtHeaderName.Enabled = False
            drpOrder.Enabled = False
            drpAggregate.Enabled = False
            LoadAggregates(drpAggregate, txtDataType.Text)
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub LoadExistingHeaders()
        Dim dsHeader As DataSet = New DataSet
        Try
            dsHeader = bsAssignmentHeader.GetHeader()
            If (dsHeader.Tables(0).Rows.Count > 0) Then
                PoplulateRepeater(dsHeader.Tables(0))
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsHeader.Dispose()
        End Try
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dt"></param>
    ''' <remarks></remarks>
    Protected Sub PoplulateRepeater(ByVal dt As DataTable)
        Dim rptindx As Integer
        Dim sDataType As String
        Dim sOrderNum As String
        Dim sHeaderName As String
        Dim sDefaultGroup As String
        Dim sAggregate As String
        Dim lstObj As ListItem
        Dim chkItem As CheckBox
        Dim drpAggregate, drpOrder As DropDownList
        Dim rdGroup As RadioButton
        Dim txtHeaderName As TextBox
        Dim dtRow() As DataRow

        For rptindx = 0 To rptheader.Items.Count - 1
            sDataType = CType(rptheader.Items(rptindx).FindControl("txtDataType"), TextBox).Text
            dtRow = dt.Select("HeaderType='" & sDataType & "'")
            If dtRow.Length > 0 Then
                sAggregate = dtRow(0)("SQLAggregation")
                sHeaderName = dtRow(0)("HeaderName")
                sDefaultGroup = dtRow(0)("Default")
                chkItem = CType(rptheader.Items(rptindx).FindControl("chkHeader"), CheckBox)
                txtHeaderName = CType(rptheader.Items(rptindx).FindControl("txtHeaderName"), TextBox)
                rdGroup = CType(rptheader.Items(rptindx).FindControl("defaultGroup"), RadioButton)
                If (sDefaultGroup.ToLower() = "true") Then rdGroup.Checked = True
                chkItem.Checked = True
                EnableRow(rptindx)
                txtHeaderName.Text = sHeaderName
                drpAggregate = CType(rptheader.Items(rptindx).FindControl("drpAggregate"), DropDownList)
                lstObj = New ListItem
                lstObj = drpAggregate.Items.FindByValue(sAggregate)
                If Not lstObj Is Nothing Then lstObj.Selected = True
            End If
        Next
        LoadOrderNum()
        For rptindx = 0 To rptheader.Items.Count - 1
            sDataType = CType(rptheader.Items(rptindx).FindControl("txtDataType"), TextBox).Text
            dtRow = dt.Select("HeaderType='" & sDataType & "'")
            If dtRow.Length > 0 Then
                sOrderNum = dtRow(0)("Order")
                drpOrder = CType(rptheader.Items(rptindx).FindControl("drpOrder"), DropDownList)
                lstObj = New ListItem
                lstObj = drpOrder.Items.FindByValue(sOrderNum)
                If Not lstObj Is Nothing Then
                    lstObj.Selected = True
                    Removethis(lstObj.Value, rptindx)
                End If

            End If
        Next
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub EnableRow(ByVal sender As Object, ByVal e As EventArgs)
        Dim chkItem As CheckBox
        Dim rptItem As RepeaterItem
        Dim indx As Integer

        Try
            chkItem = CType(sender, CheckBox)
            rptItem = chkItem.Parent
            indx = rptItem.ItemIndex
            EnableRow(indx)
            LoadOrderNum()
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
    Protected Sub CascadeSelection(ByVal sender As Object, ByVal e As EventArgs)
        Dim drp As DropDownList
        Dim rptItem As RepeaterItem
        Dim indx As Integer

        Try
            drp = CType(sender, DropDownList)
            rptItem = drp.Parent
            indx = rptItem.ItemIndex
            LoadOrderNum()
            If (drp.SelectedValue <> "-1") Then
                Removethis(drp.SelectedValue, indx)
            Else
                Remove()
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
    Protected Sub RefreshDefaultGrouping(ByVal sender As Object, ByVal e As EventArgs)
        Dim rdGroup As RadioButton
        Dim rptItem As RepeaterItem
        Dim indx, rptIndx As Integer

        Try
            rdGroup = CType(sender, RadioButton)
            rptItem = rdGroup.Parent
            rptIndx = rptItem.ItemIndex
            For indx = 0 To rptheader.Items.Count - 1
                If (rptIndx <> indx) Then CType(rptheader.Items(indx).FindControl("defaultGroup"), RadioButton).Checked = False
            Next
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="indx"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub EnableRow(ByVal indx As Integer)
        Dim txtDatatype, txtHeaderName As TextBox
        Dim drpOrder, drpAggregate As DropDownList
        Dim chkItem As CheckBox
        Dim dtType As String = ""
        Dim rdGroup As RadioButton
        Try
            chkItem = CType(rptheader.Items(indx).FindControl("chkHeader"), CheckBox)
            txtDatatype = CType(rptheader.Items(indx).FindControl("txtDataType"), TextBox)
            drpAggregate = CType(rptheader.Items(indx).FindControl("drpAggregate"), DropDownList)
            drpOrder = CType(rptheader.Items(indx).FindControl("drpOrder"), DropDownList)
            txtHeaderName = CType(rptheader.Items(indx).FindControl("txtHeaderName"), TextBox)
            rdGroup = CType(rptheader.Items(indx).FindControl("defaultGroup"), RadioButton)

            If (chkItem.Checked = True) Then
                dtType = GetDataType(txtDatatype.Text)
                If (dtType.ToLower() <> "string") Then drpAggregate.Enabled = True
                If (dtType.ToLower() = "single") Then
                    rdGroup.Enabled = False
                Else
                    rdGroup.Enabled = True
                End If
                txtHeaderName.Enabled = True
                drpOrder.Enabled = True
            Else
                drpAggregate.Enabled = False
                txtHeaderName.Enabled = False
                drpOrder.Items.Clear()
                drpOrder.Enabled = False
                rdGroup.Enabled = False
                rdGroup.Checked = False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub LoadOrderNum()
        Dim indx As Integer
        Dim chkitem As CheckBox
        Dim drpOrder As DropDownList
        Dim intOrderCount As Integer = 0
        For indx = 0 To rptheader.Items.Count - 1
            chkitem = CType(rptheader.Items(indx).FindControl("chkHeader"), CheckBox)
            If (chkitem.Checked = True) Then
                intOrderCount = intOrderCount + 1
            End If
        Next
        If intOrderCount > 0 Then
            For indx = 0 To rptheader.Items.Count - 1
                drpOrder = CType(rptheader.Items(indx).FindControl("drpOrder"), DropDownList)
                chkitem = CType(rptheader.Items(indx).FindControl("chkHeader"), CheckBox)
                If (chkitem.Checked = True) Then PopulateOrderControl(drpOrder, intOrderCount, drpOrder.SelectedValue)
            Next
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sValue"></param>
    ''' <param name="escape"></param>
    ''' <remarks></remarks>
    Protected Sub Removethis(ByVal sValue As String, ByVal escape As Integer)
        Dim chkitem As CheckBox
        Dim drpOrder As DropDownList
        Dim indx As Integer
        For indx = 0 To rptheader.Items.Count - 1
            drpOrder = CType(rptheader.Items(indx).FindControl("drpOrder"), DropDownList)
            chkitem = CType(rptheader.Items(indx).FindControl("chkHeader"), CheckBox)
            If (chkitem.Checked = True) Then
                If (escape <> indx) Then drpOrder.Items.Remove(drpOrder.Items.FindByValue(sValue))
            End If
        Next
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub Remove()
        Dim chkitem As CheckBox
        Dim drpOrder As DropDownList
        Dim indx As Integer
        For indx = 0 To rptheader.Items.Count - 1
            drpOrder = CType(rptheader.Items(indx).FindControl("drpOrder"), DropDownList)
            chkitem = CType(rptheader.Items(indx).FindControl("chkHeader"), CheckBox)
            If (chkitem.Checked = True) Then
                If (drpOrder.SelectedValue <> "-1") Then Removethis(drpOrder.SelectedValue, indx)
            End If
        Next
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drp"></param>
    ''' <param name="intOrderCount"></param>
    ''' <param name="sOrderNum"></param>
    ''' <remarks></remarks>
    Protected Sub PopulateOrderControl(ByVal drp As DropDownList, ByVal intOrderCount As Integer, ByVal sOrderNum As String)
        Dim indx As Integer
        Dim lstObj As ListItem = New ListItem
        drp.Items.Clear()
        For indx = 1 To intOrderCount
            drp.Items.Add(New ListItem(indx, indx - 1))
        Next
        drp.Items.Insert(0, New ListItem("--", "-1"))
        lstObj = drp.Items.FindByValue(sOrderNum)
        If Not lstObj Is Nothing Then lstObj.Selected = True
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drp"></param>
    ''' <param name="sDataType"></param>
    ''' <remarks></remarks>
    Protected Sub LoadAggregates(ByVal drp As DropDownList, ByVal sDataType As String)
        drp.Items.Add(New ListItem("--", ""))
        Dim dtType As String = GetDataType(sDataType)
        Try
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
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub BitInfo(ByVal drp As DropDownList)
        'TODO
    End Sub

    Protected Sub IntInfo(ByVal drp As DropDownList)
        commonInfo(drp)
        drp.Items.RemoveAt(0)
    End Sub

    Protected Sub SglInfo(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("Get Sum", "sum"))
        drp.Items.Add(New ListItem("Get Average", "avg"))
        drp.Items.Add(New ListItem("Get Lowest", "min"))
        drp.Items.Add(New ListItem("Get Highest", "max"))
    End Sub

    Protected Sub strInfo(ByVal drp As DropDownList)
        commonInfo(drp)
        drp.Enabled = False
    End Sub

    Protected Sub commonInfo(ByVal drp As DropDownList)
        drp.Items.Add(New ListItem("Get Count", "count"))
    End Sub

    Protected Sub datInfo(ByVal drp As DropDownList)
        'TODO
    End Sub

    Protected Function GetDataType(ByVal dtType As String) As String
        Return dtType.Split(":")(1) 'Strip out Index Id that was added to disticly Identify dropdown Item.
    End Function

    Protected Function GetDbFieldName(ByVal dbFieldName As String) As String
        Return dbFieldName.Split(":")(2) 'Strip out Index Id that was added to disticly Identify dropdown Item.
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dbFieldName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function FormatFieldName(ByVal dbFieldName As String) As String
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
            If ((indx > 0) AndAlso (arLetterIndx(indx) = (prevIndx + 1))) Then
                dbFieldName = dbFieldName.Replace(" ", "")
            Else
                dbFieldName = dbFieldName.Replace(arLetters(indx), " " & arLetters(indx))
            End If
            prevIndx = indx
        Next

        're-check for last index
        If (dbFieldName.Substring(arLetterIndx.Count - 1).Trim() <> "") AndAlso (dbFieldName.Substring(arLetterIndx.Count).Trim().Length > 1) Then
            dbFieldName = dbFieldName.Replace(arLetters(arLetters.Count - 1), " " & arLetters(arLetters.Count - 1))
        End If

        Return dbFieldName.Trim()

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub lnkCommit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCommit.Click

        ClearMsg()
        ResetControl()
        Dim dtHeader As DataTable = New DataTable
        Try
            validOrder()
            If (lblMsg.Text.Trim() = "") Then
                CreateColumnHeader(dtHeader)
                BuildTable(dtHeader)
                If (dtHeader.Rows.Count > 0) Then
                    bsAssignmentHeader.AddHeader(dtHeader)
                End If
            End If
        Catch ex As Exception
            DisplayMsg(lblMsg, ex.Message, True)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtHeader"></param>
    ''' <remarks></remarks>
    Protected Sub CreateColumnHeader(ByRef dtHeader As DataTable)
        dtHeader.Columns.Add("HeaderName")
        dtHeader.Columns.Add("SQLField")
        dtHeader.Columns.Add("SQLAggregation")
        dtHeader.Columns.Add("Aggregation")
        dtHeader.Columns.Add("Format")
        dtHeader.Columns.Add("Order")
        dtHeader.Columns.Add("DefaultOrder")
        dtHeader.Columns.Add("CanBeGrouped")
        dtHeader.Columns.Add("HeaderType")
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtHeader"></param>
    ''' <remarks></remarks>
    Protected Sub BuildTable(ByRef dtHeader As DataTable)
        Dim indx As Integer
        Dim dtType As String
        Dim intDefaultGroup As Integer = GetDefaultGrouping()
        Dim sDefaultGroup As String = ""
        Dim chkItem As CheckBox
        Dim rdGroup As RadioButton
        Dim drpOrder, drpAggregate As DropDownList
        Dim txtHeaderName, txtDataType As TextBox
        Dim dtRow As DataRow

        For indx = 0 To rptheader.Items.Count - 1
            chkItem = CType(rptheader.Items(indx).FindControl("chkHeader"), CheckBox)
            If (chkItem.Checked = True) Then
                drpOrder = CType(rptheader.Items(indx).FindControl("drpOrder"), DropDownList)
                drpAggregate = CType(rptheader.Items(indx).FindControl("drpAggregate"), DropDownList)
                txtHeaderName = CType(rptheader.Items(indx).FindControl("txtHeaderName"), TextBox)
                txtDataType = CType(rptheader.Items(indx).FindControl("txtDataType"), TextBox)
                rdGroup = CType(rptheader.Items(indx).FindControl("defaultGroup"), RadioButton)
                dtRow = dtHeader.NewRow()
                dtType = GetDataType(txtDataType.Text)
                dtRow("HeaderName") = txtHeaderName.Text.Trim()
                dtRow("SQLField") = GetSQLField(dtType, txtDataType.Text)
                dtRow("Aggregation") = GetAggregation(dtType)
                dtRow("Format") = GetFormat(dtType)
                dtRow("Order") = drpOrder.SelectedValue
                dtRow("CanBeGrouped") = CanBeGrouped(dtType)
                If (intDefaultGroup <> -1) Then
                    If (rdGroup.Checked = True) Then
                        dtRow("DefaultOrder") = "True"
                    Else
                        dtRow("DefaultOrder") = "False"
                    End If
                Else
                    If (((dtType.ToLower() = "string") Or (dtType.ToLower() = "int32")) And (sDefaultGroup = "")) Then
                        dtRow("DefaultOrder") = "True"
                        sDefaultGroup = "Assigned"
                    Else
                        dtRow("DefaultOrder") = "False"
                    End If
                End If

                If ((dtType.ToLower() = "string")) Then
                    dtRow("SQLAggregation") = drpAggregate.Items(1).Value
                Else
                    dtRow("SQLAggregation") = drpAggregate.SelectedValue
                End If

                dtRow("HeaderType") = txtDataType.Text.Trim()
                dtHeader.Rows.Add(dtRow)

            End If
        Next
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetDefaultGrouping() As Integer
        Dim indx As Integer
        Dim intAssigned As Integer = -1
        Dim rdGroup As RadioButton
        For indx = 0 To rptheader.Items.Count - 1
            rdGroup = CType(rptheader.Items(indx).FindControl("defaultGroup"), RadioButton)
            If (rdGroup.Checked = True) Then
                intAssigned = indx
                Exit For
            End If
        Next
        Return intAssigned
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sDataType"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function CanBeGrouped(ByVal sDataType As String)
        Dim blnFlag As Boolean = False
        Select Case sDataType.ToLower
            Case "int32", "string"
                blnFlag = True
        End Select
        Return blnFlag
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sDataType"></param>
    ''' <param name="Headertype"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetSQLField(ByVal sDataType As String, ByVal Headertype As String)
        Dim FieldName As String = GetDbFieldName(Headertype)
        Select Case sDataType.ToLower
            Case "int32"
                FieldName = "DISTINCT " & FieldName
        End Select
        Return FieldName
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtType"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetAggregation(ByVal dtType As String)
        Dim sAggrType As String = "sum"

        Select Case dtType.ToLower
            Case "string"
                sAggrType = "count"
        End Select

        Return sAggrType

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtType"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function GetFormat(ByVal dtType As String)
        Dim sFormat As String = ""

        Select Case dtType.ToLower
            Case "single"
                sFormat = "C"
        End Select

        Return sFormat

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function validOrder() As Boolean
        Dim indx As Integer
        Dim validflag As Boolean = True
        Dim chkItem As CheckBox
        Dim drpOrder As DropDownList
        Dim sHeaderName As String
        Dim txtHeaderName As TextBox
        Try
            For indx = 0 To rptheader.Items.Count - 1
                chkItem = CType(rptheader.Items(indx).FindControl("chkHeader"), CheckBox)
                drpOrder = CType(rptheader.Items(indx).FindControl("drpOrder"), DropDownList)
                txtHeaderName = CType(rptheader.Items(indx).FindControl("txtHeaderName"), TextBox)
                If (chkItem.Checked = True) Then
                    sHeaderName = txtHeaderName.Text
                    If (sHeaderName.Trim() = "") Then
                        SetBackcolor(txtHeaderName)
                        Throw New Exception("Please Enter Header Name")
                    ElseIf (drpOrder.SelectedValue = "-1") Then
                        SetBackcolor(drpOrder)
                        Throw New Exception("Please Specifiy Header Order")
                    Else
                        OrderLookup(drpOrder.SelectedValue, indx)
                    End If
                End If
            Next
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="txt"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub SetBackcolor(ByVal txt As TextBox)
        txt.BackColor = Color.Tan
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drp"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub SetBackcolor(ByVal drp As DropDownList)
        drp.BackColor = Color.Tan
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="txt"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub ReSetBackcolor(ByVal txt As TextBox)
        txt.BackColor = Color.White
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="drp"></param>
    ''' <remarks></remarks>
    Protected Overloads Sub ReSetBackcolor(ByVal drp As DropDownList)
        drp.BackColor = Color.White
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ResetControl()
        Dim lcindx As Integer
        Dim validflag As Boolean = True
        Dim drpOrder As DropDownList
        Dim txtHeaderName As TextBox
        Dim chkItem As CheckBox
        For lcindx = 0 To rptheader.Items.Count - 1
            chkItem = CType(rptheader.Items(lcindx).FindControl("chkHeader"), CheckBox)
            drpOrder = CType(rptheader.Items(lcindx).FindControl("drpOrder"), DropDownList)
            txtHeaderName = CType(rptheader.Items(lcindx).FindControl("txtHeaderName"), TextBox)
            If (chkItem.Checked = True) Then
                ReSetBackcolor(drpOrder)
                ReSetBackcolor(txtHeaderName)
            End If
        Next
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sOrderNum"></param>
    ''' <remarks></remarks>
    Protected Sub OrderLookup(ByVal sOrderNum As String, ByVal indx As Integer)
        Dim lcindx As Integer
        Dim validflag As Boolean = True
        Dim drpOrder As DropDownList
        Dim arOrder As ArrayList = New ArrayList
        For lcindx = 0 To rptheader.Items.Count - 1
            drpOrder = CType(rptheader.Items(lcindx).FindControl("drpOrder"), DropDownList)
            If ((lcindx <> indx) And (drpOrder.SelectedValue = sOrderNum)) Then
                arOrder.Add(lcindx)
            End If
        Next
        If (arOrder.Count > 0) Then
            arOrder.Add(indx)
            HighlightOverlap(arOrder)
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="arList"></param>
    ''' <remarks></remarks>
    Protected Sub HighlightOverlap(ByVal arList As ArrayList)
        Dim indx As Integer
        Dim drpOrder As DropDownList
        Dim rptIndx As Integer
        For indx = 0 To arList.Count - 1
            rptIndx = CInt(arList(indx))
            drpOrder = CType(rptheader.Items(rptIndx).FindControl("drpOrder"), DropDownList)
            SetBackcolor(drpOrder)
        Next
        Throw New Exception("Header Order overlaps")
    End Sub

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
    Protected Sub ClearMsg()
        lblMsg.BackColor = Color.Transparent
        lblMsg.Text = ""
        imgMsg.Visible = False
    End Sub
End Class
