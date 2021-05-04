Imports System.Data

Partial Class util_pop_choosecreditor
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadStates()
            LoadCreditors()
        End If
    End Sub

    Protected Sub btnApprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApprove.Click
        Approve(False)
    End Sub

    Protected Sub btnValidate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnValidate.Click
        Approve(True)
    End Sub

    Private Sub Approve(ByVal blnValidate As Boolean)
        Dim existingCreditorID As Integer = CInt(Request.QueryString("existingCreditorID"))
        Dim existingGroupID As Integer = CInt(Request.QueryString("existingGroupID"))
        Dim newCreditorID As Integer = CInt(Request.QueryString("pendingCreditorID"))
        Dim newGroupID As Integer = CInt(Request.QueryString("pendingGroupID"))
        Dim UserID As Integer = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        'Update the existing creditor
        If rdoExisting.Checked Then
            CreditorGroupHelper.ValidateWithChanges(existingCreditorID, existingGroupID, txtExistingStreet.Text, txtExistingStreet2.Text, txtExistingCity.Text, CInt(ddlExistingState.SelectedItem.Value), txtExistingZipCode.Text, UserID, blnValidate, txtExistingName.Text)
            CreditorGroupHelper.UpdateCreditorGroup(existingGroupID, txtExistingName.Text, UserID)
        Else 'New
            CreditorGroupHelper.ValidateWithChanges(existingCreditorID, existingGroupID, txtNewStreet.Text, txtNewStreet2.Text, txtNewCity.Text, CInt(ddlNewState.SelectedItem.Value), txtNewZipCode.Text, UserID, blnValidate, txtNewName.Text)
            CreditorGroupHelper.UpdateCreditorGroup(existingGroupID, txtNewName.Text, UserID)
        End If

        'Discard the new creditor
        CreditorGroupHelper.UseExistingCreditor(newCreditorID, existingCreditorID, UserID)
        CreditorGroupHelper.CleanupCreditorGroup(newGroupID)

        'Response.Write("<script>window.close();</script>")
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "closeThisWnd", "window.close();", True)
    End Sub

    Private Sub LoadStates()
        Dim obj As New Drg.Util.DataHelpers.DataHelperBase
        Dim tbl As DataTable = obj.GetStates()

        With ddlExistingState
            .DataSource = tbl
            .DataTextField = "Abbreviation"
            .DataValueField = "StateID"
            .DataBind()
        End With

        With ddlNewState
            .DataSource = tbl
            .DataTextField = "Abbreviation"
            .DataValueField = "StateID"
            .DataBind()
        End With
    End Sub

    Private Sub LoadCreditors()
        Dim rec As CreditorGroupHelper.Creditor
        Dim li As ListItem

        rec = CreditorGroupHelper.GetCreditor(CInt(Request.QueryString("existingCreditorID")))
        txtExistingName.Text = rec.Name
        txtExistingStreet.Text = rec.Street
        txtExistingStreet2.Text = rec.Street2
        txtExistingCity.Text = rec.City
        txtExistingZipCode.Text = rec.ZipCode
        li = ddlExistingState.Items.FindByValue(rec.StateID)
        If Not IsNothing(li) Then
            li.Selected = True
        End If

        rec = CreditorGroupHelper.GetCreditor(CInt(Request.QueryString("pendingCreditorID")))
        txtNewName.Text = rec.Name
        txtNewStreet.Text = rec.Street
        txtNewStreet2.Text = rec.Street2
        txtNewCity.Text = rec.City
        txtNewZipCode.Text = rec.ZipCode
        li = ddlNewState.Items.FindByValue(rec.StateID)
        If Not IsNothing(li) Then
            li.Selected = True
        End If
    End Sub
End Class
