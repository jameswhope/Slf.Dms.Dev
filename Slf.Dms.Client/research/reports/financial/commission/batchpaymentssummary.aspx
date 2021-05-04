<%@ Page Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master" AutoEventWireup="false" CodeFile="batchpaymentssummary.aspx.vb" Inherits="research_reports_financial_commission_batchpaymentssummary" title="DMP - Commission" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
<style type="text/css">
thead th{
	position:relative; 
	top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
}
</style>
<script type="text/javascript">
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function Requery()
{
    var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");
    
    var date1 = txtTransDate1.value.substring(0, 6) + "20" + txtTransDate1.value.substr(6,2);
    var date2 = txtTransDate2.value.substring(0, 6) + "20" + txtTransDate2.value.substr(6,2);
    
    if (!IsValidDateTime(date1))
    {
        ShowMessage("You entered an invalid date in the begin range selector.")
    }
    else if (!IsValidDateTime(date2))
    {
        ShowMessage("You entered an invalid date in the end range selector.")
    }
    else
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkRequery, Nothing) %>;
    }
    
}
function SetDates(ddl)
{
    var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

    var str = ddl.value;
    if (str != "Custom")
    {
        var parts = str.split(",");
        txtTransDate1.value=parts[0];
        txtTransDate2.value=parts[1];
    }
}
function RowHover(tbl, over)
{
    var obj = event.srcElement;
    
    if (obj.tagName == "IMG")
        obj = obj.parentElement;
        
    if (obj.tagName == "TD")
    {
        //remove hover from last tr
        if (tbl.getAttribute("lastTr") != null)
        {
            var lastTr = tbl.getAttribute("lastTr");
            lastTr.style.backgroundColor = "#ffffff";
        }

        //if the mouse is over the table, set hover to current tr
        if (over)
        {
            var curTr = obj.parentElement;
            curTr.style.backgroundColor = "#f3f3f3";
            tbl.setAttribute("lastTr", curTr);
        }
    }
}

function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "query_commission_batchpayments", "winrptservicefeereport", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}
function FixHeader(obj)
{
    var tbl = obj.parentNode.parentNode.parentNode;
    var tbd = tbl.getElementsByTagName("tbody");

    var month = tbd[0];
    var div = tbl.parentNode;

    obj.style.top = (div.scrollTop) + "px";
    obj.style.zIndex = (10000 - obj.sourceIndex);

}
function SetCustom()
{
    var ddl = document.getElementById("<%=ddlQuickPickDate.ClientId %>");
    ddl.selectedIndex=8;	
}
function SetKeyPress()
{
    var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
    txtTransDate1.OnKeyPress = SetCustom;
    AddHandler(txtTransDate1, "keypress", "OnKeyPress");

    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");
    txtTransDate2.OnKeyPress = SetCustom;
    AddHandler(txtTransDate2, "keypress", "OnKeyPress");
}
function AddHandler(eventSource, eventName, handlerName, eventParent)
{
    // TODO: factor into the event function so multiple parents are possible
    //if (eventParent != null)
    //	eventSource.parent = eventParent;
    var eventHandler = function(e) {eventSource[handlerName](e, eventParent);};
	
    if (eventSource.addEventListener)
    {
	    eventSource.addEventListener(eventName, eventHandler, false);
    }
    else if (eventSource.attachEvent)
    { 
	    eventSource.attachEvent("on" + eventName, eventHandler);
    }
    else
    {
	    var originalHandler = eventSource["on" + eventName];
		
	    if (originalHandler)
	    {
		    eventHandler = function(e) {originalHandler(e); eventSource[handlerName](e, eventParent);};
	    }

	    eventSource["on" + eventName] = eventHandler;
    }
}
</script>

<body scroll="no" onload="SetKeyPress();">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" id="tdFilter" runat="server">
            <div style="padding:15 15 15 15;overflow:auto;height:100%;width:175;">
                <table style="font-family:tahoma;font-size:11px;width:100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optCommRecChoice" Visible="false">
                                <asp:ListItem value="0" text="Only exclude recip."/>
                                <asp:ListItem value="1" text="Only include recip." selected="true"/>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csCommRecID"></asi:SmartCriteriaSelector>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Options</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <asp:CheckBox id="chkGroupByAgency" runat="server" checked="true" text="Group By Scenario"></asp:CheckBox>
                                </tr>
                                <tr>
                                    <asp:CheckBox id="chkBreakdownFeeTypes" runat="server" checked="true" text="Breakdown Fee Types"></asp:CheckBox>
                                </tr>
                                <tr>
                                <BR /><BR /><asp:Label id="lblCompany" runat="server"><B>Company</B></asp:Label><BR /><BR />
                                    <asp:DropDownList id="ddlCompany" accesskey="1" runat="server" style="font-family:tahoma;font-size:11px;width:100%;" />
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
                        <TABLE style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					        <TR>
						        <TD valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
						        <TD runat="server" id="tdError"></TD>
					        </TR>
				        </TABLE></div>
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
                                                <asp:dropdownlist id="ddlQuickPickDate" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                            </td>
                                            <td nowrap="true" style="width:8;">&nbsp;</td>
                                            <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                            <td nowrap="true" style="width:8;">:</td>
                                            <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            
                                            <td nowrap="true">
                                                <asp:LinkButton id="lnkRequery" runat="server"></asp:LinkButton>
                                                <a href="javascript:Requery()" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</a>
                                            </td>
                                            
                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                            
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
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
                        <div style="width:100%;height:100%;overflow:auto">
                            <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;" cellspacing="15px">
                                <asp:literal runat="server" id="ltrGrid"></asp:literal>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
        </td>
    </tr>
</table>
</body>

<asp:LinkButton runat="server" id="lnkDelete" style="display:none;"></asp:LinkButton>

</asp:PlaceHolder></asp:Content>