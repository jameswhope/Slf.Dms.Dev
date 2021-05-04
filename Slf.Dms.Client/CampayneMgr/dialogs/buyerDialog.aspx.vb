Partial Class dialogs_buyerDialog
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _buyerid As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property Buyerid() As Integer
        Get
            Return _buyerid
        End Get
        Set(ByVal value As Integer)
            _buyerid = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Protected Sub dialogs_buyerDialog_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsNothing(Request.QueryString("bid")) Then
            Buyerid = Request.QueryString("bid").ToString
        End If

        If Buyerid <> -1 Then
            Dim bo As BuyerHelper.BuyersObject = BuyerHelper.getBuyer(Buyerid)
            With bo
                lblBuyerName.Text = bo.Buyer
                txtBuyerName.Text = bo.Buyer
                txtBuyercode.Text = bo.BuyerCode

                txtAddress.Text = bo.Address
                txtCity.Text = bo.City
                ddlState.SelectedValue = bo.State
                txtZip.Text = bo.Zip
                ddlCountry.SelectedValue = bo.Country
                txtAcctMgr.Text = bo.AccountManager
                ddlBillingCycle.SelectedValue = bo.BillingCycle

                lblCurrentCredit.Text = FormatCurrency("100000", 2, TriState.False, TriState.False, TriState.True)
                lblOwedReturns.Text = FormatCurrency("0", 2, TriState.False, TriState.False, TriState.True)
                txtBuyerNotes.Text = bo.Notes
                chkBuyerActive.Checked = bo.Active
            End With
        Else
            lblBuyerName.Text = "New Buyer"
            txtBuyerName.Text = "New Buyer"
            txtBuyercode.Text = "NEWBUYER"

            txtAddress.Text = ""
            txtCity.Text = ""
            ddlState.SelectedValue = ""
            txtZip.Text = ""
            ddlCountry.SelectedValue = ""
            txtAcctMgr.Text = ""
            ddlBillingCycle.SelectedValue = ""

            lblCurrentCredit.Text = FormatCurrency("100000", 2, TriState.False, TriState.False, TriState.True)
            lblOwedReturns.Text = FormatCurrency("0", 2, TriState.False, TriState.False, TriState.True)

            txtBuyerNotes.Text = ""

            chkBuyerActive.Checked = False
        End If
        
    End Sub

    #End Region 'Methods

End Class