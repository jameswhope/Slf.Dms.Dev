<%@ Page Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false" CodeFile="depositdaysago.aspx.vb" Inherits="research_reports_clients_depositdaysago" title="DMP - Research" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "report_clients_depositdaysago", "winreport_clients_depositdaysago", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}
function SetToNow(obj)
{
    var str = Functoid_Date_GetNow("/", false);
    var parts = str.split("/");
    obj.value = parts[0] + "/" + parts[1] + "/" + parts[2].substr(2);
}
function ApplyToChildren(a, color)
{
    for (var i = 0; i < a.childNodes.length; i++)
    {
        var td = a.childNodes[i];
        td.style.backgroundColor = color;
    }
}
function Hover(tbl, over)
{
    var obj = event.srcElement;
    
    if (obj.tagName.toLowerCase() != "td" && obj.parentElement.tagName.toLowerCase() == "td")
        obj = obj.parentElement;
        
    if (obj.tagName.toLowerCase() != "td" && obj.parentElement.parentElement.tagName.toLowerCase() == "td")
        obj = obj.parentElement.parentElement;
        
    if (obj.tagName.toLowerCase() == "td")
    {
        
        //remove hover from last tr
        if (tbl.getAttribute("lastTr") != null)
        {
            var a = tbl.getAttribute("lastTr")
            var color = tbl.getAttribute("lastTrColor")
            ApplyToChildren(a, color);
        }

        //if the mouse is over the table, set hover to current tr
        if (over)
        {
            var curTr = obj.parentElement;
            if (curTr.getAttribute("hover") != "false")
            {
                
                tbl.setAttribute("lastTrColor", curTr.childNodes[0].style.backgroundColor);
                
                var type = curTr.getAttribute("type");
                
                if (type == "Trans")
                    ApplyToChildren(curTr, "rgb(187,255,187)");
                else if (type == "Deposit")
                    ApplyToChildren(curTr, "rgb(255,255,174)");
                else if (type == "Client")
                    ApplyToChildren(curTr, "#f3f3f3");

                tbl.setAttribute("lastTr", curTr);
            }
        }
    }
}
</script>
<style>
    thead th{position:relative; top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);}
    td.l{padding-left:8;border-left:solid 1px silver;border-right:none}
    td.lr{padding-right:8;}
    td.r{padding-right:8;border-right:solid 1px silver;border-left:none}
    table tfoot tr td{background-color:white}
</style>
<body scroll="no">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" id="tdFilter" runat="server">
            <div style="padding:15 15 15 15;overflow:auto;height:100%;width:175;">
                <table style="font-family:tahoma;font-size:11px;width:100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding-bottom:10;"><b>Start Date</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:70;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtStartDate" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td><a class="lnk" href="#" onclick="SetToNow(this.parentElement.previousSibling.firstChild);">Set to now</a></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top:20;"><b>Skip Transactions</b></td>
                    </tr>
                    <tr>
                        <td style="background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-repeat:repeat-x;background-position:left center;"><img height="10" width="1" runat="server" src="~/images/spacer.gif" /></td>
                    </tr>
                    <tr>
                        <td nowrap="true">
                            <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="Bounced Deposits" id="chkBounced" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="true">
                            <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="Voided Deposits" id="chkVoided" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="true">
                            <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="Deposits on Hold" id="chkOnHold" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top:10;">Deposits Of Type</td>
                    </tr>
                    <tr>
                        <td nowrap="true">
                            
                                <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="ACH" id="chkTransAch" runat="server"/>
                            <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="Check" id="chkTransCheck" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top:20;"><b>Include Criteria</b></td>
                    </tr>
                    <tr>
                        <td style="background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-repeat:repeat-x;background-position:left center;"><img height="10" width="1" runat="server" src="~/images/spacer.gif" /></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap>Days Ago:&nbsp;</td>
                                    <td nowrap="true" style=""><input type="text" style="font-size: 11px; font-family: Tahoma;width:25" runat="server" id="txtDaysAgo1" onkeypress="AllowOnlyNumbers()"/></td>
                                    <td nowrap="true" >&nbsp;to&nbsp;</td>
                                    <td nowrap="true" style=""><input type="text" style="font-size: 11px; font-family: Tahoma;width:25" runat="server" id="txtDaysAgo2" onkeypress="AllowOnlyNumbers()" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="true">
							<asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="Include Never Deposited" id="chkNeverDeposited" runat="server"/>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td>
                            <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optClientStatusChoice">
                                <asp:ListItem value="0" text="Exclude Statuses"/>
                                <asp:ListItem value="1" text="Include Statuses" selected="true"/>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csClientStatusID" SelectedRows="3"></asi:SmartCriteriaSelector>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optAgencyChoice">
                                <asp:ListItem value="0" text="Exclude Agencies"/>
                                <asp:ListItem value="1" text="Include Agencies" selected="true"/>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csAgencyID" SelectedRows="3"></asi:SmartCriteriaSelector>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top:10;">Monthly Deposit Method</td>
                    </tr>
                    <tr>
                        <td nowrap="true">
                        <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="ACH" id="chkAch" runat="server"/>
                            <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="Check" id="chkCheck" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top:10;">Hire Date Period</td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:15;">1:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtHireDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:15;">2:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtHireDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    
                </table>
            </div>
        </td>
        <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
        <div style="overflow:auto">
            <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top">
                        <div runat="server" id="dvError" style="display:none;">
                            <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					            <tr>
						            <td valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
						            <td runat="server" id="tdError"></TD>
					            </TR>
				            </TABLE>
				        </div>
                    </td>
                </tr>
                <tr>
                    <td style="background-color:rgb(244,242,232);">
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                <td style="width:100%;">
                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td nowrap="true"><asp:LinkButton id="lnkShowFilter" class="gridButtonSel" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_funnel.png" /></asp:LinkButton></td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkClear" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_clear.png" />Clear Criteria</asp:LinkButton></td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            
                                            <td nowrap="true">
                                                <asp:LinkButton class="gridButton" id="lnkRequery" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton>
                                            </td>
                                            
                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                            
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                            <td nowrap="true"><a runat="server" class="gridButton" href="javascript:printReport()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                            <td nowrap="true" style="width:10;">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="height:100%;width:100%">
                        <div style="width:100%;height:100%;overflow:auto;padding: 0 15 15 15">
                        
                            <table class="list" onmouseover="Hover(this,true)" onmouseout="Hover(this,false)" style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="0">
                                <colgroup>
                                    <col style="border-left:solid 1px silver"/>
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col style="background-color:rgb(255,255,210);border-left:solid 1px silver" />
                                    <col style="background-color:rgb(255,255,210)" />
                                    <col style="background-color:rgb(255,255,210)" />
                                    <col style="background-color:rgb(221,255,221);border-left:solid 1px black" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221);border-right:solid 1px silver" />
                                </colgroup>
                                <thead>
                                    <tr style="height:15px">
                                        <th colspan="14" style="height:15px;background-color:rgb(255,255,255)"></th>
                                    </tr>
                                    <tr style="height:20px">
                                        <th colspan="5" style="height:20px;background-color:rgb(255,255,255)" runat="server" id="tdResults" align="left"></th>
                                        <th nowrap="true" colspan="3" style="height:20px;background-color:rgb(255,255,210);border-left:solid 1px silver;border-top:solid 1px silver" align="center">Monthly Deposit Info</th>
                                        <th nowrap="true" colspan="6" style="height:20px;background-color:rgb(221,255,221);border-left:solid 1px silver;border-top:solid 1px silver;border-right:solid 1px silver" align="center">Last Deposit Made</th>
                                    </tr>
                                    <tr>
                                        <th nowrap="true" style="width:22;height:22" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                        <th align="left">Agency</th>
                                        <th align="left">Name</th>
                                        <th align="center" nowrap="true" style="width:75;">Acct No.</th>
                                        <th align="left">Status</th>
                                        <th align="left" style="padding-left:8;">Method</th>
                                        <th align="center" style="width:55;">Day</th>
                                        <th align="right" style="padding-right:8;">Amount</th>
                                        <th align="center" nowrap="true" style="width:75;">Days Ago</th>
                                        <th align="left">Date</th>
                                        <th align="right">Amount</th>
                                        <th align="center">B</th>
                                        <th align="center">V</th>
                                        <th align="center">ACH</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:repeater id="rpResults" runat="server"><itemtemplate>
                                   
<tr>
    <a href="<%#ResolveUrl("~/clients/client/?id=" & CType(Container.DataItem, Result).ClientID) %>" type="Client">
        <td>
            <img src="<%=ResolveUrl("~/images/16x16_cheque.png") %>"/>
        </td>
        <td>
            <%#CType(Container.DataItem, Result).AgencyName%>&nbsp;
        </td>
        <td>
            <%#CType(Container.DataItem, Result).ClientName%>&nbsp;
        </td>
        <td align="center">
            <%#CType(Container.DataItem, Result).AccountNumber%>&nbsp;
        </td>
        <td>
            <%#CType(Container.DataItem, Result).ClientStatusName%>&nbsp;
        </td>
    </a>
    <a href="<%#ResolveUrl("~/clients/client/finances/ach/?id=" & CType(Container.DataItem, Result).ClientID) %>" type="Deposit">
        <td class="l">
            <%#CType(Container.DataItem, Result).DepositMethod%>&nbsp;
        </td>
        <td align="center">
            <%#CType(Container.DataItem, Result).DepositDay%>&nbsp;
        </td>
        <td align="right" class="lr">
            <%#CType(Container.DataItem, Result).DepositAmount.ToString("c")%>&nbsp;
        </td>
    </a>
    
    <%#GetTransactionInfo(CType(Container.DataItem, Result)) %>
        
</tr>
                                    </itemtemplate></asp:repeater>
                                
                                    <asp:literal runat="server" id="ltrGrid"></asp:literal>
                                </tbody>
                                <tfoot>
                                    <tr hover="false">
                                        <td style="background-color:white;font-weight:bold" colspan="8" align="right" id="tdDepositAmountTotal" runat="Server"></td>
                                        <td style="background-color:white;font-weight:bold" colspan="3" align="right" id="tdAmountTotal" runat="server"></td>
                                        <td style="background-color:white;"colspan="3"></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table onselectstart="return false;" style="height:25;background-color:rgb(239,236,222);background-image:url(<%= ResolveUrl("~/images/grid_bottom_back.bmp") %>);background-repeat:repeat-x;background-position:left bottom;font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="0" width="100%" border="0">
                            <tr>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkFirst" runat="server" class="gridButton"><img id="imgFirst" align="absmiddle" runat="server" src="~/images/16x16_selector_first.png" border="0"/></asp:LinkButton></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkPrev" runat="server" class="gridButton"><img id="imgPrev" align="absmiddle" runat="server" src="~/images/16x16_selector_prev.png" border="0"/></asp:LinkButton></td>
                                <td><img style="margin:0 5 0 5;" border="0" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                <td nowrap="true">Page&nbsp;&nbsp;<asp:TextBox AutoPostBack="true" CssClass="entry2" style="width:40;text-align:center;" runat="server" id="txtPageNumber"></asp:TextBox>&nbsp;&nbsp;of&nbsp;<asp:Label ID="lblPageCount" runat="server"></asp:Label></td>
                                <td><img style="margin:0 5 0 5;" border="0" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkNext" runat="server" class="gridButton"><img id="imgNext" align="absmiddle" runat="server" src="~/images/16x16_selector_next.png" border="0"/></asp:LinkButton></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkLast" runat="server" class="gridButton"><img id="imgLast" align="absmiddle" runat="server" src="~/images/16x16_selector_last.png" border="0"/></asp:LinkButton></td>
                                <td style="width:100%;">&nbsp;</td>
                                <td style="padding-right:7;" nowrap="true" align="right"><asp:Label runat="server" id="lblResults"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </div>
        </td>
    </tr>
</table>
</body>

<asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
<asp:TextBox ID="txtSortField" runat="server"></asp:TextBox>
<asp:LinkButton runat="server" id="lnkDelete" style="display:none;"></asp:LinkButton>

</asp:PlaceHolder></asp:Content>