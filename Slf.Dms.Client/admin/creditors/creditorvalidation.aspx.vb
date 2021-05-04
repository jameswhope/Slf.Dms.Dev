Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Collections.Generic
Imports System.Data

Partial Class admin_creditors_creditorvalidation
    Inherits System.Web.UI.Page

    Private UserID As Integer
    Private qs As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                           GlobalFiles.JQuery.UI, _
                                           "~/jquery/json2.js", _
                                           "~/jquery/jquery.modaldialog.js" _
                                           })

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not IsPostBack Then
            LoadStates()
            LoadPendingValidations()
            Page.Form.DefaultButton = btnSearch.UniqueID
        End If
    End Sub

    Private Sub LoadPendingValidations()
        Dim tbl As DataTable = CreditorGroupHelper.GetPendingValidations

        gvPending.DataSource = tbl
        gvPending.DataBind()

        lblPending.Text = "<b>Pending Validations</b> (<font color='blue'>" & tbl.Rows.Count & "</font>)"
    End Sub

    Private Sub LoadStates()
        Dim obj As New DataHelperBase
        Dim tbl As DataTable = obj.GetStates()
        Dim row As DataRow

        row = tbl.NewRow
        row("Abbreviation") = "-- ALL -- "
        row("StateID") = "-1"
        tbl.Rows.InsertAt(row, 0)

        cboStateID.DataSource = tbl
        cboStateID.DataTextField = "Abbreviation"
        cboStateID.DataValueField = "StateID"
        cboStateID.DataBind()
    End Sub

    Protected Sub gvCreditors_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rv As DataRowView = CType(e.Row.DataItem, DataRowView)

                If hdnPendingCreditorID.Value = rv.Row.Item(1).ToString Then
                    'dont allow validation against itself, they must choose another match or click Validate Creditor
                    e.Row.Style("color") = "#cccccc"
                Else
                    If rv.Row.Item(7).ToString.ToLower = "true" Then 'validated creditor?
                        e.Row.Style("background-color") = "#D2FFD2"
                        e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#C9EFC9';")
                        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#D2FFD2';")
                    Else
                        e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
                        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                    End If

                    e.Row.Style("cursor") = "hand"
                    e.Row.Attributes.Add("onclick", "ChooseCreditor(" & rv.Row.Item(0).ToString & "," & rv.Row.Item(1).ToString & ");")
                End If
        End Select
    End Sub

    Protected Sub gvPending_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rv As DataRowView = CType(e.Row.DataItem, DataRowView)

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                e.Row.Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(sender, "Select$" + e.Row.RowIndex.ToString))
                e.Row.Style("cursor") = "hand"
        End Select
    End Sub

    Protected Sub gvPending_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvPending.RowCommand
        Select Case e.CommandName
            Case "Select"
                Dim dk As DataKey = gvPending.DataKeys(e.CommandArgument)
                Dim row As GridViewRow = gvPending.Rows(e.CommandArgument)
                Dim li As ListItem
                Dim i As Integer

                hdnPendingCreditorGroupID.Value = dk(0)
                hdnPendingCreditorID.Value = dk(1)

                txtStreet.Text = row.Cells(3).Text.Replace("&nbsp;", "")
                txtStreet2.Text = row.Cells(4).Text.Replace("&nbsp;", "")
                txtCity.Text = row.Cells(5).Text.Replace("&nbsp;", "")
                txtZipCode.Text = row.Cells(7).Text.Replace("&nbsp;", "")

                cboStateID.ClearSelection()
                li = cboStateID.Items.FindByText(row.Cells(6).Text)
                If Not li Is Nothing Then
                    li.Selected = True
                End If

                Requery(row.Cells(2).Text)

                'highlight this row
                row.Style("background-color") = "#ffffda"
                row.Attributes("onmouseover") = "this.style.backgroundColor = '#ffffda';"
                row.Attributes("onmouseout") = "this.style.backgroundColor = '#ffffda';"

                'reset the last row
                If IsNumeric(ViewState("LastRow")) Then
                    i = CInt(ViewState("LastRow"))
                    If i < gvPending.Rows.Count Then
                        row = gvPending.Rows(i)
                        row.Style("background-color") = ""
                        row.Attributes("onmouseover") = "this.style.backgroundColor = '#ffffda';"
                        row.Attributes("onmouseout") = "this.style.backgroundColor = '';"
                    End If
                End If

                ViewState("LastRow") = e.CommandArgument
        End Select
    End Sub

    Private Sub Requery(ByVal creditor As String, Optional ByVal bCreditorSelected As Boolean = True)
        Dim dsCreditors As DataSet
        Dim dv As DataView
        Dim li As ListItem

        dsCreditors = CreditorGroupHelper.GetCreditorGroups(creditor, txtStreet.Text, txtStreet2.Text, txtCity.Text, cboStateID.SelectedItem.Value, False)
        If dsCreditors.Tables(1).Rows.Count < 2 Then
            dsCreditors = CreditorGroupHelper.GetCreditorGroups(creditor, "", txtStreet2.Text, txtCity.Text, cboStateID.SelectedItem.Value, False)
        End If
        dv = dsCreditors.Tables(0).DefaultView
        Accordion1.DataSource = dv
        Accordion1.DataBind()
        Accordion1.Visible = True
        If dsCreditors.Tables(0).Rows.Count > 1 Then
            Accordion1.SelectedIndex = -1
        Else
            Accordion1.SelectedIndex = 0
        End If

        ddlCreditorGroup.ClearSelection()
        ddlCreditorGroup.DataSource = CreditorGroupHelper.GetPotentialGroups(creditor)
        ddlCreditorGroup.DataTextField = "name"
        ddlCreditorGroup.DataValueField = "creditorgroupid"
        ddlCreditorGroup.DataBind()

        li = ddlCreditorGroup.Items.FindByText(creditor)
        If Not IsNothing(li) Then
            li.Selected = True
        End If

        If bCreditorSelected Then
            txtCreditorGroup.Text = ddlCreditorGroup.SelectedItem.Text
        End If

        txtStreet.Focus()
    End Sub

    Private Sub Clear(Optional ByVal blnAccordionVisible As Boolean = False)
        txtStreet.Text = ""
        txtStreet2.Text = ""
        txtCity.Text = ""
        cboStateID.ClearSelection()
        txtZipCode.Text = ""
        txtCreditorGroup.Text = ""
        If Not blnAccordionVisible Then
            ddlCreditorGroup.Items.Clear()
            hdnPendingCreditorID.Value = "-1"
            hdnPendingCreditorGroupID.Value = "-1"
        End If
        hdnExistingCreditorID.Value = "-1"
        Accordion1.Visible = blnAccordionVisible
    End Sub

    Protected Sub lnkValidateCreditor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkValidateCreditor.Click
        CreditorGroupHelper.ValidateCreditor(CInt(hdnPendingCreditorID.Value), UserID)
        LoadPendingValidations()
        Clear()
    End Sub

    Protected Sub lnkValidateWithChanges_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkValidateWithChanges.Click
        ValidateWithChanges(True)
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnSearch.Click
        If Not IsNothing(ddlCreditorGroup.SelectedItem) Then
            If txtCreditorGroup.Text <> ddlCreditorGroup.SelectedItem.Text AndAlso txtCreditorGroup.Text.Trim.Length > 1 Then
                Requery(txtCreditorGroup.Text.Trim, False)
            Else
                Requery(ddlCreditorGroup.SelectedItem.Text)
            End If
        End If
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        Clear(True)
        txtCreditorGroup.Focus()
    End Sub

    Protected Sub lnkApprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkApprove.Click
        ValidateWithChanges(False)
    End Sub

    Private Sub ValidateWithChanges(ByVal blnValidate As Boolean)
        Dim CreditorGroupID As Integer
        Dim Name As String

        If String.Compare(ddlCreditorGroup.SelectedItem.Text, txtCreditorGroup.Text, False) = 0 Then
            CreditorGroupID = CInt(ddlCreditorGroup.SelectedItem.Value)
            Name = ddlCreditorGroup.SelectedItem.Text
        Else
            CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(txtCreditorGroup.Text.Trim, UserID)
            Name = txtCreditorGroup.Text.Trim
        End If

        CreditorGroupHelper.ValidateWithChanges(CInt(hdnPendingCreditorID.Value), CreditorGroupID, txtStreet.Text, txtStreet2.Text, txtCity.Text, CInt(cboStateID.SelectedItem.Value), txtZipCode.Text, UserID, blnValidate, Name)

        If hdnPendingCreditorGroupID.Value <> CreditorGroupID Then
            'User changed groups, remove old group if no longer being used
            CreditorGroupHelper.CleanupCreditorGroup(CInt(hdnPendingCreditorGroupID.Value))
        End If

        LoadPendingValidations()
        Clear()
    End Sub

    Protected Sub ddlCreditorGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCreditorGroup.SelectedIndexChanged
        Requery(ddlCreditorGroup.SelectedItem.Text)
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        LoadPendingValidations()
        Clear()
    End Sub

    Public Function GetAccounts(ByVal CreditorID As Integer) As String
        Return CreditorGroupHelper.GetAccounts(CreditorID)
    End Function
End Class
