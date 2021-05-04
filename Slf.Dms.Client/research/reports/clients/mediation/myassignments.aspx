<%@ Page Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false" CodeFile="myassignments.aspx.vb" Inherits="research_reports_clients_mediation_myassignments" title="DMP - Research" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "report_clients_accountsoverpercentage", "winreport_clients_myassignments", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
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
function GetOthers(a)
{
	var result = new Array();
	
	
	var type = a.getAttribute("type");
    if (type == "Client")
    {
		var ClientID = a.getAttribute("ClientID");
		var tr = a.parentElement;
		var tbl = tr.parentElement.parentElement;
		var nextTr = tbl.rows[tr.rowIndex+1];
		var prevTr = tbl.rows[tr.rowIndex-1];
		
		for (var i = 0; i< prevTr.all.length; i++)
		{
			var obj = prevTr.all[i];
			if (obj.getAttribute("ClientID") == ClientID)
				result.push(obj);
		}
		for (var i = 0; i< nextTr.all.length; i++)
		{
			var obj = nextTr.all[i];
			if (obj.getAttribute("ClientID") == ClientID)
				result.push(obj);
		}
    }
    
	return result;
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
            
            var others = GetOthers(a);
            for(var i = 0; i < GetOthers.length; i++)
            {
            	if ( others[i] != null) ApplyToChildren(others[i], color);
            }
        }

        //if the mouse is over the table, set hover to current tr
        if (over)
        {
            var curTr = obj.parentElement;
            if (curTr.getAttribute("hover") != "false")
            {
                
                tbl.setAttribute("lastTrColor", curTr.childNodes[0].style.backgroundColor);
                
                var type = curTr.getAttribute("type");
                
                if (type == "Account")
                    ApplyToChildren(curTr, "rgb(187,255,187)");
                else if (type == "Client")
                {
					ApplyToChildren(curTr, "#f3f3f3");
					
					var others = GetOthers(curTr);
					for(var i = 0; i < GetOthers.length; i++)
					{
            			if ( others[i] != null) ApplyToChildren(others[i], "#f3f3f3");
					}
                }

                tbl.setAttribute("lastTr", curTr);
            }
        }
    }
}
function Sort(obj)
{
    document.getElementById("<%=txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
    <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
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
                                            
                                            <!--<td nowrap>Threshold %:&nbsp;</td>
                                            <td nowrap="true" style=""><input type="text" style="font-size: 11px; font-family: Tahoma;width:25" runat="server" id="txtThresholdPercent1" onkeypress="AllowOnlyNumbers()"/></td>
                                            <td nowrap="true" >&nbsp;to&nbsp;</td>
                                            <td nowrap="true" style=""><input type="text" style="font-size: 11px; font-family: Tahoma;width:25" runat="server" id="txtThresholdPercent2" onkeypress="AllowOnlyNumbers()" /></td>
                                            
                                            <td nowrap="true"><img id="Img2" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            -->
                                            <td nowrap="true">
                                                <asp:LinkButton class="gridButton" id="lnkRequery" runat="server"><img id="Img3" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton>
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
                                    <col style="background-color:rgb(221,255,221);border-left:solid 1px silver" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221)" />
                                    <col style="background-color:rgb(221,255,221);border-right:solid 1px silver" />
                                </colgroup>
                                <thead>
                                    <tr style="height:15px">
                                        <th colspan="11" style="height:15px;background-color:rgb(255,255,255)"></th>
                                    </tr>
                                    <tr style="height:20px">
                                        <th colspan="5" style="height:20px;background-color:rgb(255,255,255)"></th>
                                        <th nowrap="true" colspan="6" style="height:20px;background-color:rgb(221,255,221);border-left:solid 1px silver;border-top:solid 1px silver;border-right:solid 1px silver" align="center">Creditor Accounts</th>
                                    </tr>
                                    <tr>
                                        <th nowrap="true" style="width:22;height:22" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                        <th onclick="Sort(this)" runat="server" id="tdAccountNumber" style="cursor:pointer" nowrap align="left" >Acct No.</th>
                                        <th runat="server" id="tdSDABalance" style="cursor:pointer" nowrap align="right" >SDA Balancefdd</th>
                                        <th onclick="Sort(this)" runat="server" id="tdLastName" style="cursor:pointer" nowrap align="left" >Full Name</th>
                                        <th onclick="Sort(this)" runat="server" id="tdSSN" style="cursor:pointer" nowrap align="left" >SSN</th>
                                        
                                        <th nowrap="true" style="width:22;height:22" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                        <th  runat="server" id="tdCreditorName" nowrap align="left" >Creditor</th>
                                        <th  runat="server" id="tdCreditorPhone" nowrap align="left" >Phone</th>
                                        <th  runat="server" id="tdCreditorAccountNumber" nowrap align="left" >Account No.</th>
                                        <th  runat="server" id="tdCreditorBalance" nowrap align="right" style="width:75;">Balance</th>
                                        <th  runat="server" id="tdCreditorMinAvailable" nowrap align="right" >Min Ava.</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:repeater id="rpResults" runat="server"><itemtemplate>
										<%#GetClientInfo(CType(Container.DataItem, Result))%>
                                    </itemtemplate></asp:repeater>
                                </tbody>
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