Option Explicit On
'Option Strict On

Imports System.Collections.Generic
Imports Drg.Util.DataAccess

Partial Class admin_settings_stateprimaries
    Inherits System.Web.UI.Page

    Private objCompany As Lexxiom.BusinessServices.Company
    Private _companyID As Integer
    Private _userID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim li As ListItem

        _userID = DataHelper.Nz_int(Page.User.Identity.Name)

        If IsNothing(objCompany) Then
            objCompany = New Lexxiom.BusinessServices.Company
        End If

        If Not Page.IsPostBack Then
            LoadCompanies()

            If IsNumeric(Request.QueryString("id")) Then
                LoadStatePrimaries(CType(Request.QueryString("id"), Integer))
                li = ddlCompanyMain.Items.FindByValue(Request.QueryString("id"))
                If Not IsNothing(li) Then
                    li.Selected = True
                End If
            End If
        End If

        _companyID = CType(ddlCompanyMain.SelectedItem.Value, Integer)

        AddTasks()
    End Sub

    Private Sub AddTasks()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Changes</a>")
    End Sub

    Private Sub LoadStatePrimaries(ByVal intCompanyID As Integer)
        rptStatePrimary.DataSource = objCompany.CompanyStatePrimaryList(intCompanyID)
        rptStatePrimary.DataBind()
    End Sub

    Private Sub LoadCompanies()
        ddlCompanyMain.DataSource = objCompany.CompanyList
        ddlCompanyMain.DataTextField = "ShortCoName"
        ddlCompanyMain.DataValueField = "CompanyID"
        ddlCompanyMain.DataBind()
    End Sub

    Protected Sub rptStatePrimary_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptStatePrimary.ItemDataBound
        Dim ddlAttorney As DropDownList
        Dim hdnAttorneyID As HiddenField
        Dim hdnState As HiddenField
        Dim tdAgent As HtmlTableCell
        Dim tdState As HtmlTableCell
        Dim tdAttorney As HtmlTableCell
        Dim tdPlaceHolder As HtmlTableCell
        Dim li As ListItem

        If _companyID = 0 Then
            _companyID = CType(Request.QueryString("id"), Integer)
        End If

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            hdnState = e.Item.FindControl("hdnState")
            hdnAttorneyID = e.Item.FindControl("hdnAttorneyID")
            tdAgent = e.Item.FindControl("tdAgent")
            tdState = e.Item.FindControl("tdState")
            tdAttorney = e.Item.FindControl("tdAttorney")
            tdPlaceHolder = e.Item.FindControl("tdPlaceHolder")

            'Populating the attorney's for each state. Only attorney's that are linked to 
            'the state will appear in the list.
            ddlAttorney = e.Item.FindControl("ddlAttorney")
            ddlAttorney.DataSource = objCompany.GetAttorneysByState(hdnState.Value, _companyID)
            ddlAttorney.DataTextField = "Name"
            ddlAttorney.DataValueField = "AttorneyID"
            ddlAttorney.DataBind()

            If ddlAttorney.Items.Count = 1 Then
                'No attorneys are licensed for this state
                tdAgent.Style("background-color") = "#ffffcc"
                tdState.Style("background-color") = "#ffffcc"
                tdAttorney.Style("background-color") = "#ffffcc"
                tdPlaceHolder.Style("background-color") = "#ffffcc"
            Else
                'If there is a primary attorney for this state, select it
                li = ddlAttorney.Items.FindByValue(hdnAttorneyID.Value)
                If Not IsNothing(li) Then
                    li.Selected = True
                End If

                If hdnAttorneyID.Value = "-1" Then
                    'Flag a warning that there is no primary selected
                    tdAgent.Style("background-color") = "#FFDFBF"
                    tdState.Style("background-color") = "#FFDFBF"
                    tdAttorney.Style("background-color") = "#FFDFBF"
                    tdPlaceHolder.Style("background-color") = "#FFDFBF"
                End If
            End If

        End If

    End Sub

    Protected Sub ddlCompanyMain_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCompanyMain.SelectedIndexChanged
        trInfoBox.Visible = False
        LoadStatePrimaries(_companyID)
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim hdnState As HiddenField
        Dim ddlAttorney As DropDownList
        Dim intAttorneyID As Integer
        Dim item As RepeaterItem
        'Dim count As Integer
        'Dim tdAgent As HtmlTableCell
        'Dim tdState As HtmlTableCell
        'Dim tdAttorney As HtmlTableCell
        'Dim tdPlaceHolder As HtmlTableCell

        ''First check if there are any states that need primaries selected
        'For Each item In rptStatePrimary.Items
        '    ddlAttorney = item.FindControl("ddlAttorney")

        '    If ddlAttorney.Items.Count > 1 And ddlAttorney.SelectedIndex = 0 Then
        '        tdAgent = item.FindControl("tdAgent")
        '        tdState = item.FindControl("tdState")
        '        tdAttorney = item.FindControl("tdAttorney")
        '        tdPlaceHolder = item.FindControl("tdPlaceHolder")

        '        'Flag a warning that there is no primary selected
        '        tdAgent.Style("background-color") = "#FFDFBF"
        '        tdState.Style("background-color") = "#FFDFBF"
        '        tdAttorney.Style("background-color") = "#FFDFBF"
        '        tdPlaceHolder.Style("background-color") = "#FFDFBF"

        '        count += 1
        '    End If
        'Next

        'If count > 0 Then
        '    trInfoBox.Visible = True
        '    lblInfoBox.Text = "Please select state primaries for the states that have licensed attorneys. States are highlighted in red. Changes <u>not</u> saved."
        'Else
        trInfoBox.Visible = False

        'Save changes to list
        For Each item In rptStatePrimary.Items
            hdnState = item.FindControl("hdnState")
            ddlAttorney = item.FindControl("ddlAttorney")
            intAttorneyID = CType(ddlAttorney.SelectedItem.Value, Integer)

            objCompany.SaveStatePrimary(_companyID, hdnState.Value, intAttorneyID, _userID)
        Next

        'Only calling this to update the highlighted rows
        LoadStatePrimaries(_companyID)
        'End If

    End Sub

    Protected Sub lnkReturn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReturn.Click
        Response.Redirect("attorneys.aspx?id=" & _companyID.ToString)
    End Sub

End Class
