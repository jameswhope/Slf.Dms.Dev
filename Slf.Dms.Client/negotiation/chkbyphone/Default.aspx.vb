Imports System.Data
Imports System.Data.SqlClient

Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports Drg.Util.DataHelpers
Imports LexxiomLetterTemplates

Partial Class negotiation_chkbyphone_Default
    Inherits System.Web.UI.Page

#Region "Fields"

    Public UserID As Integer

#End Region 'Fields

#Region "Methods"
    <Web.Services.WebMethod()>
    Public Shared Function PM_sendConfirmation(ByVal confirmationToAddress As String, ByVal PaymentId As String, ByVal settlementID As String, ByVal currentUserID As String) As String
        Return SettlementMatterHelper.EmailCheckByPhoneConfirmation(confirmationToAddress, PaymentId, settlementID, currentUserID)
    End Function

    Protected Sub dsPhoneProcessing_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsPhoneProcessing.Selected
        hdnChecksByPhone.Value = e.AffectedRows
        hChecks.InnerHtml = String.Format("Checks By Phone ({0})", e.AffectedRows)
    End Sub

    Protected Sub gvPhoneProcessing_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvPhoneProcessing.DataBound
        hdnChecksByPhone.Value = gvPhoneProcessing.Rows.Count
        hChecks.InnerHtml = String.Format("Checks By Phone ({0})", hdnChecksByPhone.Value)
    End Sub

    Protected Sub gvPhoneProcessing_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPhoneProcessing.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)

        End Select
    End Sub

    Protected Sub gvPhoneProcessing_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPhoneProcessing.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strMatterID As String = CType(e.Row.FindControl("hdnChkPhoneMatterId"), HtmlInputHidden).Value
            Dim checkNumber As String = CType(e.Row.FindControl("hdnPhoneCheck"), HtmlInputHidden).Value
            Dim paymentid As String = CType(e.Row.FindControl("hdnPaymentId"), HtmlInputHidden).Value
            Dim strSettlementID As String = DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & CInt(strMatterID))
            Dim payableTo As String = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "PayableTo", "SettlementId = " & strSettlementID)
            Dim popupDelivery As String = String.Format("javascript:return popupDeliveryMethod({0},{1},'P','{2}')", paymentid, strMatterID, payableTo.Replace("'", ""))
            Dim img As HtmlImage = CType(e.Row.Cells(0).FindControl("ImgPhoneIcon"), HtmlImage)
            img.Attributes.Add("onClick", popupDelivery)
            For i As Integer = 1 To e.Row.Cells.Count - 1
                e.Row.Cells(i).Attributes.Add("onClick", "javascript:return popupPhoneInfo(" & strSettlementID & ", " & IIf(String.IsNullOrEmpty(checkNumber), "0", checkNumber) & ", " & paymentid & ")")
            Next
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
        End If
    End Sub

    Protected Sub negotiation_chkbyphone_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not IsPostBack Then
            Me.LoadChecksByPhone()
        End If
    End Sub

    Private Sub LoadChecksByPhone()
        dsPhoneProcessing.SelectParameters("userid").DefaultValue = UserID
        dsPhoneProcessing.DataBind()
        gvPhoneProcessing.DataBind()
        Dim args As New DataSourceSelectArguments("CreditorName")
        Dim dv As DataView = CType(dsPhoneProcessing.Select(args), DataView)
        ddlCBPCreditors.DataSource = dv.ToTable(True, "CreditorName")
        ddlCBPCreditors.DataTextField = "CreditorName"
        ddlCBPCreditors.DataValueField = "CreditorName"
        ddlCBPCreditors.DataBind()
    End Sub

    Private Sub FilterCBP()
        Dim filterExpr As String = ddlCBPCreditors.SelectedItem.Text
        If filterExpr.Trim.ToLower = "--all--" Then
            filterExpr = ""
        Else
            filterExpr = String.Format("CreditorName = '{0}'", filterExpr.Replace("'", "''"))
        End If
        dsPhoneProcessing.SelectParameters("userid").DefaultValue = UserID
        dsPhoneProcessing.FilterExpression = filterExpr
        dsPhoneProcessing.DataBind()
        gvPhoneProcessing.DataBind()
    End Sub

    Protected Sub btnReloadCheckByPhone_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReloadCheckByPhone.Click
        FilterCBP()
    End Sub

    Protected Sub lnkCBPFiler_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCBPFiler.Click
        FilterCBP()
    End Sub

#End Region 'Methods

End Class