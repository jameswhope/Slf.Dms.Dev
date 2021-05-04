<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_client_accounts_default" Title="DMP - Client - Accounts" %>
<%@ Import Namespace="Drg.Util.DataAccess" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    
    function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function Record_AddAccount()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/creditors/accounts/addaccount.aspx?id=" & ClientID) %>");
    }
    function Record_DeleteConfirm()
    {
        if (!document.getElementById("<%= lnkDeleteConfirm.ClientID() %>").disabled)
        {
             window.dialogArguments = window;
             var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Accounts&m=Are you sure you want to delete this selection of accounts?';
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Accounts",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400}); 
        }
    }
    function Record_Delete()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function Verify(){
        <%= Page.ClientScript.GetPostBackEventReference(lnkVerAction, Nothing) %>;
    }
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0" cellpadding="15">
        <tr>
            <td style="height: 100%;" valign="top">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;height:100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="font-size:11px;color:#666666;" width="78%" valign="top"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;Accounts<br /><br />
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background-color:rgb(244,242,232);">
                                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td><img id="Img4" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                                <td style="width:100%;">
                                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td nowrap="true"><asp:DropDownList AutoPostBack="true" style="font-size:11px;font-family:tahoma;" runat="server" id="ddlType"><asp:ListItem value="0" text="Summary"></asp:ListItem><asp:ListItem value="1" text="Detail"></asp:ListItem></asp:DropDownList></td>
                                                            <td nowrap="true"><asp:CheckBox AutoPostBack="true"  runat="server" id="chkHideRemoved" text="Hide Removed"></asp:CheckBox></td>
                                                            <td nowrap="true"><asp:CheckBox AutoPostBack="true"  runat="server" id="chkHideSettled" text="Hide Settled"></asp:CheckBox></td>
                                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                                            <td runat="server" id="tdDelete" align="right"><a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="javascript:Record_DeleteConfirm();">Delete</a></td>
                                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                            <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img10" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                                            <td nowrap="true"><a runat="server" class="gridButton" href="javascript:window.print()"><img id="Img11" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                                            <td nowrap="true"><img id="Img1" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                            <td nowrap="true">
                                                                <a class="lnk" id="lnkVerify" disabled="false" runat="server" href="javascript:Verify();">
                                                                    Verify</a> <asp:CheckBox ID="chkAdjustRet" runat="server" AutoPostBack="false" Text="Adjust Retainer Fees" />
                                                            </td>
                                                            <td nowrap="true" style="width:10;">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <table class="list" onmouseover="Grid_RowHover_Nested(this, true)" onmouseout="Grid_RowHover_Nested(this, false)" onselectstart="return false;" style="font-size: 11px; font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                            <colgroup>
                                                <col align="center" style="width:20;" />
                                                <col align="center" style="width:22;" />
                                                <col align="center" style="width:17;"/>
                                                <col align="left"/>
                                                <col align="left"/>
                                                <col align="left"/>
                                                <col align="left" id="colPhone" runat="server"/>
                                                <col align="left"/>
                                                <col align="left" id="colReferenceNumber" runat="server"/>
                                                <col align="center" id="colVerified" runat="server"/>
                                                <col align="center" id="colPercent" runat="server"/>
                                                <col align="right" id="colOriginalAmount" runat="server"/>
                                                <col align="right"/>
                                                <col align="center" id="colColor" runat="server"/>
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);" style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);" style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></th>
                                                    <th><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" /></th>
                                                    <th><img runat="server" src="~/images/12x16_paperclip.png" border="0" /></th>
                                                    <th>Status</th>
                                                    <th>Matters</th>
                                                    <th>Creditor</th>
                                                    <th id="thPhone" runat="server">Phone</th>
                                                    <th nowrap="true">Account #</th>
                                                    <th nowrap="true" id="thReferenceNumber" runat="server">Reference #</th>
                                                    <th id="thVerified" runat="server" ><img runat="server" src="~/images/16x16_lock.png" border="0" align="absmiddle" /></th>
                                                    <th id="thPercent" runat="server" nowrap="true" >&nbsp;%&nbsp;</th>
                                                    <th width="10%" id="thOriginalAmount" runat="server">Original</th>
                                                    <th width="10%" >Current</th>
                                                    <th style="width: 22;" id="thColor" runat="server"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" /></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <asp:Repeater ID="rpAccounts" runat="server">
                                                <ItemTemplate>
                                                    <a href="<%# ResolveUrl("~/clients/client/creditors/accounts/account.aspx?id=") + clientid.tostring() + "&aid=" + DataBinder.Eval(Container.DataItem, "AccountId").ToString() %>" <%#GetBackgroundColor(DataBinder.Eval(Container.DataItem, "Removed"), DataBinder.Eval(Container.DataItem, "Settled"), DataBinder.Eval(Container.DataItem, "Verified"), DataBinder.Eval(Container.DataItem, "NR"), DataBinder.Eval(Container.DataItem, "PA"), DataBinder.Eval(Container.DataItem, "AccountStatusCode")) %>>
                                                        <tr <%#GetBackgroundColor(DataBinder.Eval(Container.DataItem, "Removed"), DataBinder.Eval(Container.DataItem, "Settled"), DataBinder.Eval(Container.DataItem, "Verified"), DataBinder.Eval(Container.DataItem, "NR"), DataBinder.Eval(Container.DataItem, "PA"), DataBinder.Eval(Container.DataItem, "AccountStatusCode")) %>>
                                                            <td style="width:20;"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img8" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#DataBinder.Eval(Container.DataItem, "AccountId")%>);" style="display: none;" type="checkbox" /></td>
                                                            <td style="padding:6 0 6 0;width:24;"><img align="absmiddle" runat="server" src="~/images/16x16_accounts.png" border="0" /></td>
                                                            <td runat="server" id="tdAttachments"><%#GetAttachmentText(Integer.Parse(DataBinder.Eval(Container.DataItem, "AccountID")), "account")%></td>
                                                            <td ><%#DataBinder.Eval(Container.DataItem, "AccountStatusCode")%>&nbsp;</td>
                                                            <td><%#IIf(DataBinder.Eval(Container.DataItem, "ActiveMatters") > 0, "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/matter_16x16.jpg") & """ border=""0"" />", IIf(DataBinder.Eval(Container.DataItem, "ActiveMatters") = 0 And DataBinder.Eval(Container.DataItem, "ClosedMatters") > 0, "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/matter_grey_16x16.png") & """ border=""0"" />", "&nbsp;"))%></td>
                                                            <td><%#rpAccounts_CreditorName(Container, (ddlType.SelectedIndex = 1))%></td>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td nowrap=""true"">" & rpAccounts_CreditorPhone(Container) & "&nbsp;</td>")%>
                                                            <td ><%#rpAccounts_AccountNumber(Container, (ddlType.SelectedIndex = 1))%></td>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td >" & rpAccounts_ReferenceNumber(Container, (ddlType.SelectedIndex = 1)) & "&nbsp;</td>")%>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td >" & IIf(CType(DataBinder.Eval(Container.DataItem, "Verified"), Boolean), "<img src=""" & ResolveUrl("~/images/16x16_lock.png") & """ border=""0"" align=""absmiddle""/>", "&nbsp;") & "</td>")%>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "<td nowrap=""true"" style=""color:rgb(235,0,0);"" >" & (CType(DataBinder.Eval(Container.DataItem, "CurrentAmount"), Double) / accountTotal).ToString("p") & "</td>", "")%>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td style=""color:rgb(235,0,0);"" >" & CType(DataBinder.Eval(Container.DataItem, "OriginalAmount"), Double).ToString("c") & "</td>")%>
                                                            <td style="color:rgb(235,0,0);" ><%#CType(DataBinder.Eval(Container.DataItem, "CurrentAmount"), Double).ToString("c")%></td>
                                                            <%#IIf(ddlType.selectedindex = 0, "<td style=""width:22;""><span style=""width:14;height:14;background:" & GetAccountColor(Container.ItemIndex) & """ /></td>", "")%>
                                                        </tr>
                                                    </a>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <asp:Repeater ID="rpNR" runat="server">
                                                <ItemTemplate>
                                                    <a href="addaccount.aspx?id=<%=clientid.tostring() %>&clid=<%#Eval("creditliabilityid") %>" title="Not Represented: Click to add account" style="background-color:#e8e8e8">
                                                        <tr style="background-color:#e8e8e8">
                                                            <td>&nbsp;</td>
                                                            <td style="padding:6 0 6 0"><img align="absmiddle" runat="server" src="~/images/16x16_accounts.png" alt="" border="0" /></td>
                                                            <td>&nbsp;</td>
                                                            <td>NR</td>
                                                            <td>&nbsp;</td>
                                                            <td><%#rpNR_CreditorName(Container, (ddlType.SelectedIndex = 1))%></td>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td nowrap=""true"">&nbsp;</td>")%>
                                                            <td ><%#Eval("last4")%></td>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td >&nbsp;</td>")%>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td >&nbsp;</td>")%>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "<td nowrap=""true"" style=""color:rgb(235,0,0);"" >--</td>", "")%>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "", "<td style=""color:rgb(235,0,0);"" >" & CType(DataBinder.Eval(Container.DataItem, "OriginalAmount"), Double).ToString("c") & "</td>")%>
                                                            <td style="color:rgb(235,0,0);" ><%#CType(DataBinder.Eval(Container.DataItem, "CurrentAmount"), Double).ToString("c")%></td>
                                                            <%#IIf(ddlType.SelectedIndex = 0, "<td style=""width:22;"">&nbsp;</td>", "")%>
                                                        </tr>
                                                    </a>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tbody>
                                        <tfoot >
                                            <tr >
                                                <td colspan="<%=iif(ddlType.selectedindex=0, "8","10") %>" align="right" style="padding-top:6;background-color:white"><b>Total</b></td>
                                                <td id="tdOriginalTotal1" runat="server" align="right" style="padding-top:6;color:rgb(235,0,0);background-color:white"><%=(originalTotal + notRepOrigTotal).ToString("c")%></td>
                                                <td align="right" style="padding-top:6;color:rgb(235,0,0);background-color:white"><%=(accountTotal + notRepTotal).ToString("c")%></td>
                                            </tr>
                                            <tr>
                                                <td colspan="<%=iif(ddlType.selectedindex=0, "8","10") %>" align="right" style="padding-top:3;background-color:white"><b>Total Active</b></td>
                                                <td id="tdOriginalTotal2" runat="server" align="right" style="padding-top:3;color:rgb(235,0,0);background-color:white"><%=originalTotalActive.ToString("c")%></td>
                                                <td align="right" style="font-weight:bold;padding-top:3;color:rgb(235,0,0);background-color:white"><%=accountTotalActive.ToString("c")%></td>
                                            </tr>
                                        </tfoot>
                                        </table><input type="hidden" runat="server" id="txtSelectedAccounts"/><input type="hidden" runat="server" id="txtSelectedControlsClientIDs"/>
                                        <asp:Panel runat="server" ID="pnlNoAccounts" style="text-align:center;padding: 10 5 5 5;">This client has no accounts</asp:Panel>
                                        <table class="entry2" style="border: 1px solid black;" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan="10" style="padding:3px;border-bottom: 1px solid black; text-align: center; background-color: #DCDCDC">
                                                    Legend
                                                </td>
                                            </tr>
                                            <tr style="padding:3px;">
                                                <td style="background-color: #C8F5C8; border-bottom: 1px solid black; width: 15px">
                                                    &nbsp;
                                                </td>
                                                <td style="border-bottom: 1px solid black">
                                                    Settled
                                                </td>
                                                <td style="background-color: #CEECF5; border-bottom: 1px solid black; width: 15px">
                                                    &nbsp;
                                                </td>
                                                <td style="border-bottom: 1px solid black; white-space:nowrap">
                                                    P.A.
                                                </td>
                                                <td style="background-color: #F5C8C8;border-bottom: 1px solid black; width: 15px">
                                                    &nbsp;
                                                </td>
                                                <td style="border-bottom: 1px solid black">
                                                    Removed
                                                </td>
                                                <td style="background-color: #F5F58F;border-bottom: 1px solid black; width: 15px">
                                                    &nbsp;
                                                </td>
                                                <td style="border-bottom: 1px solid black">
                                                    Unverified
                                                </td>
                                                <td style="background-color: #DEDEDE;border-bottom: 1px solid black; width: 15px">
                                                    &nbsp;
                                                </td>
                                                <td style="border-bottom: 1px solid black; white-space:nowrap">
                                                    Not Represented
                                                </td>
                                            </tr>
                                            <tr style="padding:3px;border-bottom: 1px solid black;">
                                                <td style="width: 16px">
                                                    <img align="absmiddle" src="<%= ResolveUrl("~/images/matter_16x16.jpg")%>" border="0" />
                                                </td>
                                                <td colspan="3">
                                                    Active Matters
                                                </td>
                                                <td style="width: 15px">
                                                    <img align="absmiddle" src="<%= ResolveUrl("~/images/matter_grey_16x16.png")%>" border="0" />
                                                </td>
                                                <td colspan="3">
                                                    Closed Matters
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <asp:placeholder id="phStatistics" runat="server">
                            <td style="background-position: center top; background-repeat: repeat-y; background-image: url(<%= ResolveUrl("~/images/dot.png") %>);" rowspan="4">
                                <img id="Img3" height="35" runat="server" src="~/images/spacer.gif" border="0" /></td>
                            <td style="width: 28%;" valign="top" rowspan="4">
                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="padding: 5 5 10 5;">Statistics</td>
                                    </tr>
                                    <tr>
                                        <td>
                                        <img id="accountBreakDownGraph" width="240" height="240" src="<%=ResolveUrl("~/clients/client/creditors/accounts/AccountBreakdownGraphHandler.ashx?width=240&height=240&id=") + DataClientId.ToString() %>" />
                                        <!--<img id="accountTrendGraph" width="240" height="240" src="<%=ResolveUrl("~/clients/client/creditors/accounts/AccountTrendGraphHandler.ashx?width=240&height=240&id=") + DataClientId.ToString() %>" style="display:none"/>-->
                                            <ul>
                                                <!--<li>Debt Breakdown</li>
                                                <li><a href="#" class="lnk">Debt Trend</a></li>-->
                                            </ul>
                                            
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </asp:placeholder>
                    </tr>
                    <tr>
                        <td style="height:100%"> </td>
                    </tr>   
                </table>
            </td>
        </tr>
    </table>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveACH"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveFees"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkVerAction"></asp:LinkButton>
</asp:Content>
