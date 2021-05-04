
Partial Class dialogs_schoolCampaignDialog
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        If Not IsNothing(Request.QueryString("id")) Then
            SchoolCampaignID = Request.QueryString("id").ToString
        Else
            SchoolCampaignID = -1
        End If
        imgEnforce.ToolTip = "Forces use of acceptance in area."
        imgAcceptAll.ToolTip = "Restricts form submission based on zip code."

        If Not IsPostBack Then
            If SchoolCampaignID = -1 Then
                txtName.Text = "New School Campaign"
                txtDescription.Text = ""
                ddlType.Text = ""
                txtPostUrl.Text = ""
                txtPayout.Text = "0.00"
                txtSubmitted.Text = "0"
                txtLeads.Text = "0"
                txtRejected.Text = "0"
                txtCredited.Text = "0"
                txtEstCommission.Text = "0.00"
                ddlAcceptanceAreaRule.Text = ""
                ddlLocationType.Text = ""
                txtInstructions.Text = ""
                chkStatus.Checked = False
                chkEnforceAcceptanceArea.Checked = False
                chkAcceptsAllZipCodes.Checked = False
            Else
                Using sco As SchoolFormControl.SchoolCampaignObject = SchoolFormControl.SchoolCampaignObject.GetSchoolCampaign(SchoolCampaignID)
                    txtName.Text = sco.Name
                    txtDescription.Text = sco.Description
                    ddlType.Text = sco.Type
                    txtPostUrl.Text = sco.PostUrl
                    txtPayout.Text = sco.Payout
                    txtSubmitted.Text = sco.Submitted
                    txtLeads.Text = sco.Leads
                    txtRejected.Text = sco.Rejected
                    txtCredited.Text = sco.Credited
                    txtEstCommission.Text = sco.EstCommission
                    ddlAcceptanceAreaRule.Text = sco.AcceptanceAreaRule
                    ddlLocationType.Text = sco.LocationType
                    txtInstructions.Text = sco.Instructions
                    chkStatus.Checked = sco.Status
                    chkEnforceAcceptanceArea.Checked = sco.EnforceAcceptanceArea
                    chkAcceptsAllZipCodes.Checked = sco.AcceptsAllZipCodes

                    ddlSchoolLocations.Items.Add(New ListItem("-- Select Form --", -1))
                    For Each sf As SchoolFormControl.SchoolCampaignsFormDefinitionObject In sco.SchoolForms
                        ddlSchoolLocations.Items.Add(New ListItem(sf.Name, sf.SchoolFormID))
                    Next
                End Using
            End If
        End If
    End Sub
    Public Property SchoolCampaignID() As String
        Get
            Return hdnSchoolCampaignID.Value
        End Get
        Set(ByVal value As String)
            hdnSchoolCampaignID.Value = value
        End Set
    End Property
End Class
