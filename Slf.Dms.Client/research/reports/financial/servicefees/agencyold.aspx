<%@ Page Language="VB" MasterPageFile="~/research/reports/financial/servicefees/servicefees.master" AutoEventWireup="false" CodeFile="agencyold.aspx.vb" Inherits="research_reports_financial_servicefees_agencyold" title="DMP - Service Fees" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel runat="server" ID="pnlBody">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">

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
<script type="text/javascript">

function RowHover(td, on)
{
//    if (on)
//	    td.parentElement.style.backgroundColor = "#f3f3f3";
//    else
//	    td.parentElement.style.backgroundColor = "#ffffff";
}
function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "report_servicefee_agency", "win_report_servicefee_byagency", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
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
</script>
<style>
    table thead th {position:relative;fix1:expression(FixHeader(this));font-weight:normal}
</style>
<body scroll="no">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td style="background-color:rgb(244,242,232);">
            <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                    <td style="width:100%;">
                        <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td nowrap="true">
                                    <asp:dropdownlist id="ddlQuickPickDate" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                </td>
                                <td nowrap="true" style="width:8;">&nbsp;</td>
                                <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                <td nowrap="true" style="width:8;">:</td>
                                <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                <td nowrap="true"><asp:LinkButton id="lnkRequery" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton></td>
                               
                                <td nowrap="true" style="width:100%;">&nbsp;</td>
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
        <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
        <div style="overflow:auto">
            <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top" style="height:100%;width:100%">
                        <div style="width:100%;height:100%;overflow:auto">
                        <table onselectstart="return false;" style="font-size:11px;font-family:tahoma" cellspacing="0" cellpadding="3" width="100%" border="0">
                        <thead>
                            <tr>
                                <th nowrap class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                <th nowrap class="headItem" align="left">Acct. No.</th>
                                <th nowrap class="headItem">Hire Date</th>
                                <th nowrap class="headItem" align="left">First Name</th>
                                <th nowrap class="headItem" align="left">Last Name</th>
                                <th nowrap class="headItem" align="left">Fee Category</th>
                                <th nowrap class="headItem" align="left">Setl. No.</th>
                                <!--<hd class="headItem">Pmt. Date<img align="absmiddle" style="margin-left:5;" runat="server" border="0" src="~/images/sort-asc.png" /></th>-->
                                <th nowrap class="headItem" align="right">Orig Bal.</th>
                                <th nowrap class="headItem" align="right">Beg Bal.</th>
                                <th nowrap class="headItem" align="right">Pmt Amt.</th>
                                <th nowrap class="headItem" align="right">End Bal.</th>
                                <th nowrap class="headItem" align="center">Rate</th>
                                <th nowrap class="headItem" align="right">Amount</th>
                            </tr>
                            </thead>
                        <tbody>
                            <asp:repeater id="rpPayments" runat="server">
                                <itemtemplate>
                                    <tr style="<%#IIf(Container.ItemIndex Mod 2 = 0, "", "background-color:#f1f1f1;")%>">
                                        <td style="width:22;cursor:default;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center">
                                            <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" style="cursor:default">
                                            <%#CType(Container.DataItem, Payment).AccountNumber%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" align="center" style="cursor:default">
	                                        <%#CType(Container.DataItem, Payment).HireDate.ToString("MMM d, yyyy")%>
	                                    </td>
	                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" style="cursor:default">
	                                        <%#CType(Container.DataItem, Payment).FirstName%>
	                                    </td>
	                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" style="cursor:default">
	                                        <%#CType(Container.DataItem, Payment).LastName%>
	                                    </td>
	                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" style="cursor:default">
	                                        <%#CType(Container.DataItem, Payment).FeeCategory %>
	                                    </td>
	                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" style="cursor:default">
	                                        <%#CType(Container.DataItem, Payment).SettlementNumber %>&nbsp;
	                                    </td>
	                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right" style="cursor:default">
                                            <%#CType(Container.DataItem, Payment).OriginalBalance.ToString("c")%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right" style="cursor:default">
                                            <%#CType(Container.DataItem, Payment).BeginningBalance.ToString("c")%>
                                        </td>
                                        <td style="<%#LocalHelper.GetCurrencyColor(CType(Container.DataItem, Payment).PaymentAmount) %>" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right" style="cursor:default">
                                            <%#CType(Container.DataItem, Payment).PaymentAmount.ToString("c")%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right" style="cursor:default">
                                            <%#CType(Container.DataItem, Payment).EndingBalance.ToString("c")%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center" style="cursor:default">
                                            <%#(CType(Container.DataItem, Payment).Rate * 100).ToString("F2")%>%
                                        </td>
	                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right" style="cursor:default">
                                            <%#CType(Container.DataItem, Payment).Amount.ToString("c")%>
                                        </td>
                                    </tr>
                                </itemtemplate>
                            </asp:repeater>
                            </tbody>
                        </table><input type="hidden" runat="server" id="txtSelected"/><input type="hidden" runat="server" id="txtSelectedControls"/></div>
                        <asp:panel runat="server" id="pnlNone" style="text-align:center;padding:20 5 5 5;">You have no Service Fees meeting the supplied criteria.</asp:panel>
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

</asp:Panel></asp:Content>