Imports System.Data
Imports System.Data.SqlClient

Partial Class admin_grouping
    Inherits System.Web.UI.Page

    #Region "Properties"

    Public Property Userid() As Integer
        Get
            Return ViewState("_userid")
        End Get
        Set(ByVal value As Integer)
            ViewState("_userid") = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        accGroups.DataBind()
        blcampaign.DataBind()
        blUsers.DataBind()
        blDataBatch.DataBind()
        blOffer.DataBind()
    End Sub

    Protected Sub accGroups_ItemCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs) Handles accGroups.ItemCommand
        Select Case e.CommandName.ToLower
            Case "delete".ToLower
                dsGroups.DeleteParameters("groupid").DefaultValue = e.CommandArgument
                dsGroups.Delete()
                dsGroups.DataBind()
                accGroups.DataBind()
            Case "edit".ToLower
                Dim txt As TextBox = TryCast(e, AjaxControlToolkit.AccordionCommandEventArgs).Container.FindControl("txtGroupName")
                dsGroups.UpdateParameters("name").DefaultValue = txt.Text
                dsGroups.UpdateParameters("groupid").DefaultValue = e.CommandArgument
                dsGroups.Update()
                dsGroups.DataBind()
                accGroups.DataBind()
        End Select
    End Sub

    Protected Sub accGroups_ItemDataBound(ByVal sender As Object, ByVal e As AjaxControlToolkit.AccordionItemEventArgs) Handles accGroups.ItemDataBound
        Select Case e.ItemType
            Case AjaxControlToolkit.AccordionItemType.Header
                Dim rowView As DataRowView = TryCast(e.AccordionItem.DataItem, DataRowView)
                Dim lnk As LinkButton = e.AccordionItem.FindControl("lnkEditGroup")
                lnk.OnClientClick = String.Format("return ShowGroup({0},'{1}');", rowView("groupid").ToString, rowView("name").ToString)

            Case AjaxControlToolkit.AccordionItemType.Content

                Dim hdn As HiddenField = e.AccordionItem.FindControl("hdnGroupID")
                Dim dp As HtmlGenericControl = e.AccordionItem.FindControl("divDropCampaigns")
                Dim du As HtmlGenericControl = e.AccordionItem.FindControl("divDropUsers")
                Dim db As HtmlGenericControl = e.AccordionItem.FindControl("divDropBatches")
                Dim df As HtmlGenericControl = e.AccordionItem.FindControl("divDropOffers")
                Dim ulProducts As New StringBuilder
                Dim ulUsers As New StringBuilder
                Dim ulBatches As New StringBuilder
                Dim ulOffers As New StringBuilder

                If Not IsNothing(dp) Then
                    Using dt As DataTable = GroupsHelper.getCampaigns(hdn.Value)
                        dp.InnerHtml = String.Empty
                        For Each p As DataRow In dt.Rows
                            Dim tDiv As String = "<div style=""margin:2px;padding:2px;display:block;background-color:#DCDCDC;font-weight:bold;font-size:11px;float:left;width:145px;"">"
                            tDiv += String.Format("{0}<img title=""Click to Remove"" src=""../images/16-em-cross.png"" onclick=""remove(this);"" onmouseover=""this.style.cursor='pointer';""/>", p("campaign").ToString)
                            tDiv += "</div>"
                            ulProducts.Append(tDiv)
                        Next
                        ulProducts.Append("<br style=""clear:both""/><hr><ul>")
                        ulProducts.Append("<li class=""placeholder""><font style=""font-weight:bold;"">Drop Campaigns here</font></li>")
                        ulProducts.Append("</ul>")
                        dp.InnerHtml = ulProducts.ToString
                    End Using
                End If

                If Not IsNothing(du) Then
                    Using dt As DataTable = GroupsHelper.getUsers(hdn.Value)
                        du.InnerHtml = String.Empty
                        For Each p As DataRow In dt.Rows
                            Dim tDiv As String = "<div style=""margin:2px;padding:2px;display:block;background-color:#DCDCDC;font-weight:bold;font-size:11px;float:left;width:145px;"">"
                            tDiv += String.Format("{0}<img title=""Click to Remove"" src=""../images/16-em-cross.png"" onclick=""remove(this);"" onmouseover=""this.style.cursor='pointer';""/>", p("user").ToString)
                            tDiv += "</div>"
                            ulUsers.Append(tDiv)
                        Next
                        ulUsers.Append("<br style=""clear:both""/><hr><ul>")
                        ulUsers.Append("<li class=""placeholder""><font style=""font-weight:bold;"">Drop Users here</font></li>")
                        ulUsers.Append("</ul>")
                        du.InnerHtml = ulUsers.ToString
                    End Using
                End If

                If Not IsNothing(db) Then
                    Using dt As DataTable = GroupsHelper.getBatches(hdn.Value)
                        db.InnerHtml = String.Empty
                        For Each p As DataRow In dt.Rows
                            Dim tDiv As String = "<div style=""margin:2px;padding:2px;display:block;background-color:#DCDCDC;font-weight:bold;font-size:11px;float:left;width:145px;"">"
                            tDiv += String.Format("{0}<img title=""Click to Remove"" src=""../images/16-em-cross.png"" onclick=""remove(this);"" onmouseover=""this.style.cursor='pointer';""/>", p("batchname").ToString)
                            tDiv += "</div>"
                            ulBatches.Append(tDiv) 'Format("<div style=""font-weight:bold;font-size:11px;float:left;width:145px;"">{0}<img title=""Click to Remove"" src=""../images/16-em-cross.png"" onclick=""remove(this);""/></div>", p("batchname").ToString)
                        Next
                        ulBatches.Append("<br style=""clear:both""/><hr><ul>")
                        ulBatches.Append("<li class=""placeholder""><font style=""font-weight:bold;"">Drop Batches here</font></li>")
                        ulBatches.Append("</ul>")
                        db.InnerHtml = ulBatches.ToString
                    End Using
                End If

                If Not IsNothing(df) Then
                    Using dt As DataTable = GroupsHelper.getOffers(hdn.Value)
                        df.InnerHtml = String.Empty
                        For Each p As DataRow In dt.Rows
                            Dim tDiv As String = "<div style=""margin:2px;padding:2px;display:block;background-color:#DCDCDC;font-weight:bold;font-size:11px;float:left;width:145px;"">"
                            tDiv += String.Format("{0}<img title=""Click to Remove"" src=""../images/16-em-cross.png"" onclick=""remove(this);"" onmouseover=""this.style.cursor='pointer';""/>", p("offer").ToString)
                            tDiv += "</div>"
                            ulOffers.Append(tDiv) 'Format("<div style=""font-weight:bold;font-size:11px;float:left;width:145px;"">{0}<img src=""../images/16-em-cross.png"" onclick=""remove(this);""/></div>", p("offer").ToString)
                        Next
                        ulOffers.Append("<br style=""clear:both""/><hr><ul>")
                        ulOffers.Append("<li class=""placeholder""><font style=""font-weight:bold;"">Drop Offers here</font></li>")
                        ulOffers.Append("</ul>")
                        df.InnerHtml = ulOffers.ToString
                    End Using
                End If
        End Select
    End Sub

    Protected Sub admin_grouping_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)
    End Sub

    Protected Sub blDataBatch_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles blDataBatch.DataBound
        For Each itm As ListItem In blDataBatch.Items
            itm.Attributes.Add("class", "dragBatch")
            itm.Attributes.Add("onmouseover", "this.style.cursor='Move';")
        Next
    End Sub

    Protected Sub blCampaign_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles blcampaign.DataBound
        For Each itm As ListItem In blcampaign.Items
            itm.Attributes.Add("class", "dragCampaign")
            itm.Attributes.Add("onmouseover", "this.style.cursor='Move';")
        Next
    End Sub

    Protected Sub blUsers_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles blUsers.DataBound
        For Each itm As ListItem In blUsers.Items
            itm.Attributes.Add("class", "dragUser")
            itm.Attributes.Add("onmouseover", "this.style.cursor='Move';")
        Next
    End Sub

    Protected Sub blOffer_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles blOffer.DataBound
        For Each itm As ListItem In blOffer.Items
            itm.Attributes.Add("class", "dragOffer")
            itm.Attributes.Add("onmouseover", "this.style.cursor='Move';")
        Next
    End Sub

    #End Region 'Methods

End Class