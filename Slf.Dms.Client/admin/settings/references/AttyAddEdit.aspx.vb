Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Data

Partial Class admin_settings_references_AttyAddEdit
    Inherits System.Web.UI.Page

#Region "Private Variables"
    Private objAttorney As Lexxiom.BusinessServices.Company
    Private _userID As Integer
    Private _attorneyID As Integer
    Private tblRelationTypes As DataTable
#End Region

#Region "Properties"
    Protected Property RelationTypes() As DataTable
        Get
            Return tblRelationTypes
        End Get
        Set(ByVal value As DataTable)
            tblRelationTypes = value
        End Set
    End Property
#End Region

#Region "Page_Load"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                         GlobalFiles.JQuery.UI, _
                                                         "~/jquery/jquery.modaldialog.js"})

        _userID = DataHelper.Nz_int(Page.User.Identity.Name)

        If IsNothing(objAttorney) Then
            objAttorney = New Lexxiom.BusinessServices.Company
        End If

        If Not Page.IsPostBack Then
            LoadStates()
            If IsNumeric(Request.QueryString("id")) Then
                _attorneyID = CType(Request.QueryString("id"), Integer)
                LoadAttorney()
            Else
                _attorneyID = -1
                SetupFormForNewEntry()
            End If
            hdnAttorneyID.Value = _attorneyID.ToString
        Else
            _attorneyID = CType(hdnAttorneyID.Value, Integer)
        End If

        AddTasks()
    End Sub
#End Region

#Region "AddTasks"
    Private Sub AddTasks()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:SaveAndExit();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_save.png") + """ align=""absmiddle""/>Save</a>")
        'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:SaveAndContinue();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_save_New.png") + """ align=""absmiddle""/>Save And Continue</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""../attorneys.aspx""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_cancel.png") + """ align=""absmiddle""/>Cancel</a>")
        'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:RemoveAttorney();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_delete.png") + """ align=""absmiddle""/>Remove Attorney</a>")
        'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""../default.aspx""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" + ResolveUrl("~/images/16x16_book.png") + """ align=""absmiddle""/>Return To Settings</a>")
    End Sub
#End Region

#Region "LoadStates"
    Private Sub LoadStates()
        ddlState.DataSource = objAttorney.GetStates(True)
        ddlState.DataTextField = "Name"
        ddlState.DataValueField = "Abbreviation"
        ddlState.DataBind()
    End Sub
#End Region

#Region "LoadAttorney"
    Private Sub LoadAttorney()
        Dim dsAttorney As DataSet = objAttorney.AttorneyDetail(_attorneyID)
        Dim tblStateLic As DataTable = objAttorney.GetAttorneyStateLic(_attorneyID)
        Dim row As DataRow
        'Dim li As ListItem

        If dsAttorney.Tables(0).Rows.Count = 1 Then
            row = dsAttorney.Tables(0).Rows(0)

            lblTitle.Text = row("FirstName").ToString.Trim & " " & row("LastName").ToString.Trim
            txtFirstName.Text = row("FirstName").ToString
            txtLastName.Text = row("LastName").ToString
            txtMiddleName.Text = row("MiddleName").ToString
            txtAddress1.Text = row("Address1").ToString
            txtAddress2.Text = row("Address2").ToString
            txtCity.Text = row("City").ToString
            txtZip.Text = row("Zip").ToString
            txtPhone.Text = row("Phone1").ToString
            txtFax.Text = row("Fax").ToString
            txtEmailAddress.Text = Convert.ToString(row("EmailAddress"))
            txtEmailAddress2.Text = Convert.ToString(row("EmailAddress2"))
            txtEmailAddress3.Text = Convert.ToString(row("EmailAddress3"))

            If row("UserID") IsNot DBNull.Value Then
                txtUsername.Text = row("Username").ToString
                hdnUserID.Value = row("UserID").ToString
            End If

            'li = ddlState.Items.FindByValue(row("State").ToString)
            'If Not IsNothing(li) Then
            '    li.Selected = True
            'End If

            ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByText(row("State").ToString()))

        End If

        tblRelationTypes = objAttorney.GetAttorneyRelationTypes(True)

        'rptStates.DataSource = dsAttorney.Tables(1)
        'rptStates.DataBind()

        rptCompany.DataSource = dsAttorney.Tables(2)
        rptCompany.DataBind()

        For Each row In tblStateLic.Rows
            AddStateBarRow(row("State").ToString, row("StateBarNum").ToString, False, , CType(row("AttyStateID"), Integer))
        Next

        If tblStateLic.Rows.Count = 0 Then
            AddStateBarRow("", "", False)
        End If

        lblPrimaryFor.Text = ""

    End Sub
#End Region

#Region "SetupFormForNewEntry"
    Private Sub SetupFormForNewEntry()
        Dim objCompany As New Lexxiom.BusinessServices.Company
        Dim tblCompanyList As DataTable = objCompany.CompanyList
        Dim row As DataRow

        'Company listing
        tblCompanyList.Columns.Add("IsRelated")
        tblCompanyList.Columns.Add("Relation")

        For Each row In tblCompanyList.Rows
            row("IsRelated") = "false"
        Next

        tblCompanyList.AcceptChanges()
        tblRelationTypes = objAttorney.GetAttorneyRelationTypes(True)
        rptCompany.DataSource = tblCompanyList
        rptCompany.DataBind()

        'Clear form
        txtEmailAddress.Text = ""
        txtEmailAddress2.Text = ""
        txtEmailAddress3.Text = ""
        txtFirstName.Text = ""
        txtLastName.Text = ""
        txtMiddleName.Text = ""
        txtAddress1.Text = ""
        txtAddress2.Text = ""
        txtCity.Text = ""
        txtZip.Text = ""
        txtPhone.Text = ""
        txtFax.Text = ""
        lblTitle.Text = "New Attorney"

        AddStateBarRow("", "", False)

        objCompany = Nothing
    End Sub
#End Region

#Region "AddStateBarRow"
    Private Sub AddStateBarRow(ByVal strState As String, ByVal strStateBarNum As String, ByVal blnEnableStatePrimary As Boolean, Optional ByVal strIsPrimary As String = "", Optional ByVal intAttyStateID As Integer = -1)
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell
        Dim input As HtmlInputControl

        'Delete Button, Delete Flag, AttyStateID
        cell = New HtmlTableCell
        cell.InnerHtml = "<a href=""#"" onclick=""DeleteStateLicRow(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a><input type='hidden' value='N'><input type='hidden' value='" & intAttyStateID.ToString & "'>"
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "16"
        row.Cells.Add(cell)

        'State
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewDDL(ddlState, strState, 170))
        row.Cells.Add(cell)

        'State Bar Number, ID, Delete Flag
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "<input type='text' class='entry' value='" & strStateBarNum & "'>"
        row.Cells.Add(cell)

        'State Primary
        input = New HtmlControls.HtmlInputText("checkbox")
        input.Attributes("class") = "entry"
        If Not blnEnableStatePrimary Then
            input.Attributes("disabled") = "disabled"
        End If
        If strIsPrimary = "true" Then
            input.Attributes("checked") = "checked"
        End If
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        tblStateLic.Rows.Add(row)
    End Sub
#End Region

#Region "GetNewDDL"
    Private Function GetNewDDL(ByVal ddlSource As DropDownList, ByVal SelectedValue As String, ByVal Width As Integer, Optional ByVal blnEnabled As Boolean = True) As DropDownList
        Dim ddl As New DropDownList
        Dim li, li2 As ListItem

        ddl.CssClass = "entry"
        ddl.Enabled = blnEnabled
        'ddl.Width = UI.WebControls.Unit.Pixel(Width)

        For Each li In ddlSource.Items
            li2 = New ListItem(li.Text, li.Value)
            ddl.Items.Add(li2)
        Next

        ListHelper.SetSelected(ddl, SelectedValue.Trim)

        Return ddl
    End Function
#End Region

#Region "Save Methods"

#Region "Save"
    Private Sub Save()
        Dim item As RepeaterItem
        'Dim chk As CheckBox
        Dim hdn As HiddenField
        Dim ddl As DropDownList
        Dim intCompanyID As Integer

        SaveAttorney()
        SaveUser()

        'Save SA relationships
        For Each item In rptCompany.Items
            'chk = item.FindControl("chkCompany")
            hdn = item.FindControl("hdnCompanyID")
            ddl = item.FindControl("ddlRelation")
            intCompanyID = CType(hdn.Value, Integer)
            If ddl.SelectedIndex > 0 Then 'If chk.Checked Then
                objAttorney.AddUpdateAttorneyRelation(_attorneyID, intCompanyID, ddl.SelectedItem.Text, _userID)
            Else
                'Removing the relationship also removes primaries for this attorney
                objAttorney.RemoveAttorneyRelation(_attorneyID, intCompanyID)
            End If
        Next

        SaveLicensesAndPrimaries(True)

    End Sub
#End Region

#Region "Save User"
    Private Sub SaveUser()
        If Val(hdnUserID.Value) > 0 Then
            'Update only if they set a new password
            If txtPassword.Text.Trim.Length > 0 Then
                Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName.Text)
                DatabaseHelper.AddParameter(cmd, "LastName", txtLastName.Text)
                DatabaseHelper.AddParameter(cmd, "Username", txtUsername.Text)
                DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(txtPassword.Text))
                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", _userID)

                DatabaseHelper.BuildUpdateCommandText(cmd, "tblUser", "UserID = " & hdnUserID.Value)

                Try
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                Finally
                    DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
                End Try
            End If
        ElseIf txtUsername.Text.Trim.Length > 0 AndAlso txtPassword.Text.Trim.Length > 0 Then
            Dim intUserId As Integer = Drg.Util.DataHelpers.UserHelper.InsertUser(txtFirstName.Text, txtLastName.Text, Left(txtFirstName.Text.ToLower, 1) & txtLastName.Text.ToLower & "@lexxiom.com", False, False, False, txtUsername.Text, txtPassword.Text, 1, 3, -1, _userID)

            If _attorneyID > 0 AndAlso intUserId > 0 Then
                Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                DatabaseHelper.AddParameter(cmd, "UserID", intUserId)
                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", _userID)

                DatabaseHelper.BuildUpdateCommandText(cmd, "tblAttorney", "AttorneyID = " & _attorneyID)

                Try
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                Finally
                    DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
                End Try
            End If
        End If
    End Sub
#End Region

#Region "Save Attorney"
    Private Sub SaveAttorney()
        ' need to change the assembly functions
        If _attorneyID > 0 Then
            'objAttorney.UpdateAttorney(_attorneyID, txtFirstName.Text, txtLastName.Text, txtMiddleName.Text, _userID, , txtAddress1.Text, txtAddress2.Text, txtCity.Text, ddlState.SelectedItem.Value, txtZip.Text, txtPhone.Text, , txtFax.Text)

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection

                    cmd.CommandText = "stp_UpdateAttorney"
                    cmd.CommandType = CommandType.StoredProcedure
                    DatabaseHelper.AddParameter(cmd, "AttorneyID", _attorneyID)
                    DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName.Text)
                    DatabaseHelper.AddParameter(cmd, "LastName", txtLastName.Text)
                    DatabaseHelper.AddParameter(cmd, "MiddleName", txtMiddleName.Text)
                    DatabaseHelper.AddParameter(cmd, "Address1", txtAddress1.Text)
                    DatabaseHelper.AddParameter(cmd, "Address2", txtAddress2.Text)
                    DatabaseHelper.AddParameter(cmd, "City", txtCity.Text)
                    DatabaseHelper.AddParameter(cmd, "State", ddlState.SelectedItem.Text)
                    DatabaseHelper.AddParameter(cmd, "Zip", txtZip.Text)
                    DatabaseHelper.AddParameter(cmd, "Phone1", txtPhone.Text)
                    DatabaseHelper.AddParameter(cmd, "Fax", txtFax.Text)
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", _userID)
                    DatabaseHelper.AddParameter(cmd, "EmailAddress", txtEmailAddress.Text)
                    DatabaseHelper.AddParameter(cmd, "EmailAddress2", txtEmailAddress2.Text)
                    DatabaseHelper.AddParameter(cmd, "EmailAddress3", txtEmailAddress3.Text)

                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    End Using
                End Using
            End Using

        Else
            '_attorneyID = objAttorney.InsertAttorney(txtFirstName.Text, txtLastName.Text, txtMiddleName.Text, _userID, , txtAddress1.Text, txtAddress2.Text, txtCity.Text, ddlState.SelectedItem.Value, txtZip.Text, txtPhone.Text, , txtFax.Text)

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection

                    cmd.CommandText = "stp_InsertAttorney"
                    cmd.CommandType = CommandType.StoredProcedure
                    DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName.Text)
                    DatabaseHelper.AddParameter(cmd, "LastName", txtLastName.Text)
                    DatabaseHelper.AddParameter(cmd, "MiddleName", txtMiddleName.Text)
                    DatabaseHelper.AddParameter(cmd, "Address1", txtAddress1.Text)
                    DatabaseHelper.AddParameter(cmd, "Address2", txtAddress2.Text)
                    DatabaseHelper.AddParameter(cmd, "City", txtCity.Text)
                    DatabaseHelper.AddParameter(cmd, "State", ddlState.SelectedItem.Text)
                    DatabaseHelper.AddParameter(cmd, "Zip", txtZip.Text)
                    DatabaseHelper.AddParameter(cmd, "Phone1", txtPhone.Text)
                    DatabaseHelper.AddParameter(cmd, "Fax", txtFax.Text)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", _userID)
                    DatabaseHelper.AddParameter(cmd, "EmailAddress", txtEmailAddress.Text)
                    DatabaseHelper.AddParameter(cmd, "EmailAddress2", txtEmailAddress2.Text)
                    DatabaseHelper.AddParameter(cmd, "EmailAddress3", txtEmailAddress3.Text)

                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    End Using
                End Using
            End Using

            hdnAttorneyID.Value = _attorneyID.ToString
        End If
    End Sub
#End Region

#Region "SaveLicensesAndPrimaries"
    Private Sub SaveLicensesAndPrimaries(ByVal blnSaveClicked As Boolean)
        Dim intCompanyID As Integer
        Dim lstStateLic() As String = lstStateLics.Value.Split("|")
        Dim item As RepeaterItem
        Dim parts() As String
        Dim intAttyStateID As Integer
        Dim blnCheckRelation As Boolean
        Dim hdn As HiddenField
        'Dim chk As CheckBox
        Dim ddl As DropDownList
        Dim li As ListItem

        If blnSaveClicked Then
            intCompanyID = CType(hdnSelectedCompanyID.Value, Integer)
        Else
            intCompanyID = CType(hdnCurrentCompanyID.Value, Integer)
        End If

        For Each lic As String In lstStateLic
            parts = lic.Split(",")
            intAttyStateID = CType(parts(1), Integer)

            'First save state licenses
            If parts(0) = "Y" Then 'delete flag
                objAttorney.RemoveAttorneyState(intAttyStateID)
            Else
                If parts(2) <> "" Then 'selected state
                    objAttorney.AddUpdateAttorneyState(_attorneyID, parts(2), parts(3))
                End If
            End If

            'Next, save state primaries. *Overwrites current state primary, may need
            'to check and flag user first.
            If intCompanyID > 0 Then
                If parts(4) = "true" And parts(0) = "N" Then 'primary=true and delete=N
                    blnCheckRelation = True
                    objAttorney.SaveStatePrimary(intCompanyID, parts(2), _attorneyID, _userID)
                Else
                    objAttorney.RemoveStatePrimary(intCompanyID, parts(2), _attorneyID)
                End If
            End If
        Next

        If blnCheckRelation Then
            'The attorney has been selected to be a primary for at least 1 state, if they have not selected the SA,
            'do it for them and create the relation
            For Each item In rptCompany.Items
                'chk = item.FindControl("chkCompany")
                hdn = item.FindControl("hdnCompanyID")
                ddl = item.FindControl("ddlRelation")
                If intCompanyID = CType(hdn.Value, Integer) AndAlso ddl.SelectedIndex < 1 Then
                    li = ddl.Items.FindByValue("1") 'Local Counsel
                    objAttorney.AddUpdateAttorneyRelation(_attorneyID, intCompanyID, li.Text, _userID)
                    li.Selected = True
                End If
            Next
        End If
    End Sub
#End Region

#End Region

#Region "Click Events"

#Region "lnkSaveAndExit_Click"
    Protected Sub lnkSaveAndExit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndExit.Click
        Save()
        Response.Redirect("../attorneys.aspx")
    End Sub
#End Region

    '#Region "lnkSaveAndContinue_Click"
    '    Protected Sub lnkSaveAndContinue_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndContinue.Click
    '        Save()
    '        LoadAttorney() 'clear form instead?
    '        hdnCurrentCompanyID.Value = "-1" 'reset
    '        hdnSelectedCompanyID.Value = "-1" 'reset
    '    End Sub
    '#End Region

    '#Region "lnkRemoveAttorney_Click"
    '    Protected Sub lnkRemoveAttorney_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemoveAttorney.Click
    '        objAttorney.DeleteAttorney(_attorneyID)
    '        Response.Redirect("../attorneys.aspx")
    '    End Sub
    '#End Region

#Region "lnkCompanyChanged_Click"
    Protected Sub lnkCompanyChanged_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCompanyChanged.Click
        Dim intCompanyID As Integer = CType(hdnSelectedCompanyID.Value, Integer)
        Dim tblStateLic As DataTable
        'Dim item As RepeaterItem
        Dim row As DataRow
        'Dim hdn As HiddenField
        'Dim tdCompany As HtmlTableCell
        'Dim tdCompanyChk As HtmlTableCell
        'Dim tdCompanyRel As HtmlTableCell
        'Dim tdCompanyFiller As HtmlTableCell

        'Company changed, save changes (if any)
        SaveAttorney()
        SaveLicensesAndPrimaries(False)

        'Last, reload state licenses showing primary information for the selected company
        tblStateLic = objAttorney.GetAttorneyStateLic(_attorneyID, intCompanyID)

        For Each row In tblStateLic.Rows
            AddStateBarRow(row("State").ToString, row("StateBarNum").ToString, True, row("IsPrimary").ToString, CType(row("AttyStateID"), Integer))
        Next

        If tblStateLic.Rows.Count = 0 Then
            AddStateBarRow("", "", True)
        End If

        'Dim tr As HtmlTableRow

        'For Each item In rptCompany.Items
        '    hdn = item.FindControl("hdnCompanyID")
        '    'tdCompany = item.FindControl("tdCompany")
        '    'tdCompanyChk = item.FindControl("tdCompanyChk")
        '    'tdCompanyRel = item.FindControl("tdCompanyRel")
        '    'tdCompanyFiller = item.FindControl("tdCompanyFiller")
        '    tr = item.FindControl("trCompany")

        '    If hdn.Value = intCompanyID.ToString Then
        '        'Highlight the selected company
        '        'tdCompany.Style("background-color") = "#ffffcc"
        '        'tdCompanyChk.Style("background-color") = "#ffffcc"
        '        'tdCompanyRel.Style("background-color") = "#ffffcc"
        '        'tdCompanyFiller.Style("background-color") = "#ffffcc"
        '        tr.Style("background-color") = "#ffffcc"
        '    Else
        '        'tdCompany.Style("background-color") = "#FFFFFF"
        '        'tdCompanyChk.Style("background-color") = "#FFFFFF"
        '        'tdCompanyRel.Style("background-color") = "#FFFFFF"
        '        'tdCompanyFiller.Style("background-color") = "#FFFFFF"
        '        tr.Style("background-color") = "#ffffff"
        '    End If
        'Next

        lblPrimaryFor.Text = " for " & hdnSelectedCompanyName.Value
    End Sub
#End Region

#End Region

#Region "rptCompany_ItemDataBound"
    Protected Sub rptCompany_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptCompany.ItemDataBound
        Dim ddl As DropDownList
        Dim rel As HiddenField
        Dim li As ListItem

        'Selecting the attorney's current relation to this company
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            ddl = e.Item.FindControl("ddlRelation")
            rel = e.Item.FindControl("hdnRelation")

            If Not IsNothing(ddl) Then
                li = ddl.Items.FindByText(rel.Value)
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
            End If
        End If
    End Sub
#End Region

End Class
