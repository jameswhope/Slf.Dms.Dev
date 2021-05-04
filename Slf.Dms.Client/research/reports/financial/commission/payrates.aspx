<%@ Page Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master" AutoEventWireup="false" CodeFile="payrates.aspx.vb" Inherits="research_reports_financial_commission_payrates" Title="DMP - Commission" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:panel runat="server" id="pnlBody">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
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
    function RowHover(tbl, over)
    {
        if (event.srcElement.tagName == "TD")
        {
            //remove hover from last tr
            if (tbl.getAttribute("lastTr") != null)
            {
                tbl.getAttribute("lastTr").style.backgroundColor = "#ffffff";
            }

            //if the mouse is over the table, set hover to current tr
            if (over)
            {
                var curTr = event.srcElement.parentElement;
                curTr.style.backgroundColor = "#f3f3f3";
                tbl.setAttribute("lastTr", curTr);
            }
        }
    }

    function printReport()
    {
        //window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "report_commission_payrates", "win_report_commission_payrates", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
        window.print();
    }
    function Year_Change(ddlYear)
    {   
        var ddlMonth=document.getElementById("<%=ddlMonth.ClientId %>");
        Month_Change(ddlMonth);
    }
    function Month_Change(ddlMonth)
    {
        var ddlYear=document.getElementById("<%=ddlYear.ClientId %>");
        var ddlDay=document.getElementById("<%=ddlDay.ClientId %>");
        
        var days = getDaysInMonth(ddlMonth.value,ddlYear.value);
        
        //fix the days in ddlDay
        for (var i = 0; i<days;i++)
        {
            if (ddlDay.options.length>=i+1)
            {
                ddlDay.options[i].innerHTML = i+1;
            }
            else
            {
                var n = document.createElement("option");
                n.value = i + 1;
                ddlDay.options.add(n);
                n.innerHTML = i + 1;
            }
        }
        for (var i = ddlDay.options.length-1; i>days-1; i--)
        {
            ddlDay.options.remove(i);
        }
    }
    function getDaysInMonth(month, year)
    {
        switch(parseInt(month))
        {
            case 1:
                return 31;
            case 2:
                if (isLeapYear(parseInt(year)))
                    return 29;
                else
                    return 28;
            case 3:
                return 31;
            case 4:
                return 30;
            case 5:
                return 31;
            case 6:
                return 30;
            case 7:
                return 31;
            case 8:
                return 31;
            case 9:
                return 30;
            case 10:
                return 31;
            case 11:
                return 30;
            case 12:
                return 31;
        }
    }
    function isLeapYear(yr) 
    {
        return new Date(yr, 2-1, 29).getDate() == 29;
    }
</script>
<style>
    table thead th {font-weight:normal}
</style>

<body scroll="no">
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="background-color:rgb(244,242,232);">
                <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                        <td style="width:100%;">
                            <table class="grid" style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlMonth" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                    <td nowrap="true" style="width:5;">&nbsp;</td>
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlDay" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                    <td nowrap="true" style="width:5;">&nbsp;</td>
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlYear" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                    <td nowrap="true" style="width:5;">&nbsp;</td>
                                    <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td nowrap="true"><asp:LinkButton id="lnkRequery" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton></td>
                                   
                                    <td nowrap="true" style="width:100%;">&nbsp;</td><!--
                                    <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                    -->
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
                <div style="width:100%;height:100%;overflow:auto">
                    <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;" cellspacing="15px">
                        <asp:literal runat="server" id="ltrGrid"></asp:literal>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</body>

</asp:panel>

</asp:Content>


 