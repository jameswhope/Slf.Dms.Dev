<%@ Page Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master" AutoEventWireup="false" CodeFile="cancellations.aspx.vb" Inherits="research_reports_financial_clients_cancellations" Title="DMP - Client Cancellations" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel runat="server" ID="pnlBody">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    function Requery()
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkRequery, Nothing) %>;
    }
    function SetDates(ddl)
	{
	    if (ddl.value != 'Custom')
	    {
	        var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
	        var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

	        var str = ddl.value;
	        var parts = str.split(",");
    	    
            txtTransDate1.value = parts[0];
            txtTransDate2.value = parts[1];
        }
	}
	function OnDateChange()
	{
	    SelectOption(document.getElementById('<%=ddlQuickPickDate.ClientID %>'), 'Custom');
	}
	function SetRange(begin, end)
	{
	    document.getElementById("<%=txtTransDate1.ClientId %>").value = begin;
	    document.getElementById("<%=txtTransDate2.ClientId %>").value = end;
	    
	    var ddlGran = document.getElementById('<%=ddlGranularity.ClientID %>');
	    
	    SelectOption(document.getElementById('<%=ddlQuickPickDate.ClientID %>'), 'Custom');
	    
	    if (DaysBetween(begin, end) <= 7)
	    {
	        SelectOption(ddlGran, 'Day');
	    }
	    else if (DaysBetween(begin, end) > 7 && DaysBetween(begin, end) <= 60)
	    {
	        SelectOption(ddlGran, 'Week');
	    }
	    else if (DaysBetween(begin, end) > 60 && DaysBetween(begin, end) < 12)
	    {
	        SelectOption(ddlGran, 'Month');
	    }
	    else
	    {
	        SelectOption(ddlGran, 'Year');
	    }
	    
	    Requery();
	}
	function DaysBetween(start, end)
	{
	    var startDate = new Date();
	    var endDate = new Date();
	    
	    startDate.setFullYear(start.substring(6, 8), start.substring(0, 2), start.substring(3, 5));
	    endDate.setFullYear(end.substring(6, 8), end.substring(0, 2), end.substring(3, 5));
	    
	    return Math.abs(Math.ceil((startDate.getTime()-endDate.getTime())/(86400000)));
	}
 	function SelectOption(ddl, value)
 	{
	    for (i = 0; i < ddl.options.length; i++)
	    {
	        if (ddl.options[i].value == value)
	        {
	            ddl.options[i].selected = true;
	            return;
	        }
	    }
 	}
 	function DrillDown(begin, end, descid, count)
 	{
 	    if (count > 0)
 	    {
             var url = '<%= ResolveUrl("~/util/pop/cancellationdrilldown.aspx") %>?begin=' + begin + '&end=' + end + '&descid=' + descid;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Cancellations",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 400, width: 400}); 
 	    }
 	}
</script>

<script type="text/javascript">
    function PrintReport()
    {
        window.print();
    }
    function Export()
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkExport, Nothing) %>;
    }
</script>

    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="background-color:rgb(244,242,232);" colspan="2">
                <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                        <td style="width:100%;">
                            <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td nowrap="true">
                                        <asp:DropDownList id="ddlQuickPickDate" style="font-family:Tahoma;font-size:11px" onchange="javascript:SetDates(this);" runat="server" />
                                    </td>
                                    <td nowrap="true" style="width:8;">&nbsp;</td>
                                    <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:8;">:</td>
                                    <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:10px;">&nbsp;</td>
                                    <td nowrap="true">By</td>
                                    <td nowrap="true" style="width:10px;">&nbsp;</td>
                                    <td nowrap="true">
                                        <asp:DropDownList id="ddlGranularity" style="font-family:Tahoma;font-size:11px" runat="server" />
                                    </td>
                                    <td nowrap="true" style="width:5px;">&nbsp;</td>
                                    <td nowrap="true"><img id="Img3" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td nowrap="true"><a href="javascript:Requery()" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</a></td>
                                    <td nowrap="true" style="width:100%;">&nbsp;</td>
                                    <td nowrap="true"><a runat="server" class="gridButton" href="javascript:Export();"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /> </a></td>
                                    <td nowrap="true"><a runat="server" class="gridButton" href="javascript:PrintReport()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                    <td nowrap="true" style="width:10;">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblNote" runat="server" />
            </td>
        </tr>
        <asp:Panel ID="pnlReport" runat="server">
        <tr>
            <td>
                <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0">
                    <tr>
                        <td style="border-bottom:solid 2px black;border-right:solid 1px black;background-color:#E5E5E5;" align="center" colspan="2">
                            Reason
                        </td>
                        <asp:Repeater ID="rptHeaders" runat="server">
                            <ItemTemplate>
                                <td style="border-left:solid 1px black;border-right:solid 1px black;border-bottom:solid 2px black;background-color:#E5E5E5;" align="center" colspan="2" onclick="SetRange('<%#Columns(CType(Container.DataItem, String)).BeginDate.ToString("MM/dd/yy") %>', '<%#Columns(CType(Container.DataItem, String)).EndDate.ToString("MM/dd/yy") %>');">
                                    <%#CType(Container.DataItem, String) %>
                                </td>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tr>
                    <asp:Repeater ID="rptReasons" runat="server">
                        <ItemTemplate>
                                <tr style="background-color:<%#IIf(Container.ItemIndex Mod 2 = 0, "#FFFFFF", "#F0F0F0") %>">
                                    <td style="white-space:nowrap;">
                                        <%#IndentTree(CType(Container.DataItem, ReasonsNode).Level) %><%#CType(Container.DataItem, ReasonsNode).Description %>
                                    </td>
                                    <td align="right" style="border-right:solid 1px black;width:100px;font-weight:bold;">
                                        <%#IIf(CType(Container.DataItem, ReasonsNode).IsTotal, "Total:", "&nbsp;") %>
                                    </td>
                                    <asp:Repeater ID="rptStats" DataSource="<%#CType(Container.DataItem, ReasonsNode).Information %>" runat="server">
                                        <ItemTemplate>
                                            <td style="border-left:solid 1px black;cursor: hand;" onclick="javascript:DrillDown('<%#GetDateSpanByIndex(Container.ItemIndex).BeginDate.ToString("MM-dd-yyyy") %>', '<%#GetDateSpanByIndex(Container.ItemIndex).EndDate.ToString("MM-dd-yyyy") %>', <%#CType(CType(Container.Parent.Parent, RepeaterItem).DataItem, ReasonsNode).ReasonsDescID %>, <%#CType(Container.DataItem, ReasonInfo).Count %>);">
                                                <%#CType(Container.DataItem, ReasonInfo).Count %>
                                            </td>
                                            <td style="border-left:solid 1px black;border-right:solid 1px black;cursor: hand;" onclick="javascript:DrillDown('<%#GetDateSpanByIndex(Container.ItemIndex).BeginDate.ToString("MM-dd-yyyy") %>', '<%#GetDateSpanByIndex(Container.ItemIndex).EndDate.ToString("MM-dd-yyyy") %>', <%#CType(CType(Container.Parent.Parent, RepeaterItem).DataItem, ReasonsNode).ReasonsDescID %>, <%#CType(Container.DataItem, ReasonInfo).Count %>);">
                                                <%#CType(Container.DataItem, ReasonInfo).Refund.ToString("c") %>
                                            </td>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </td>
        </tr>
        <asp:Panel ID="pnlOthers" runat="server">
        <tr style="height:10px;width:100%;">
            <td style="border-bottom:dashed 1px black;">
                &nbsp;
            </td>
        </tr>
        <tr style="height:10px;">
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <table style="font-family:tahoma;font-size:11px;width:600px;height:100%;border-bottom:solid 1px black;" cellpadding="5" cellspacing="0">
                    <tr>
                        <td style="font-weight:bold;">
                            Others:
                        </td>
                    </tr>
                    <tr>
                        <td style="border-top:solid 2px black;border-left:solid 1px black;border-right:solid 1px black;border-bottom:solid 2px black;background-color:#E5E5E5;" align="center">
                            Reason
                        </td>
                        <td style="border-top:solid 2px black;border-left:solid 1px black;border-right:solid 1px black;border-bottom:solid 2px black;background-color:#E5E5E5;" align="center">
                            Refund
                        </td>
                        <td style="border-top:solid 2px black;border-left:solid 1px black;border-right:solid 2px black;border-bottom:solid 2px black;background-color:#E5E5E5;" align="center">
                            Created
                        </td>
                    </tr>
                    <asp:Repeater ID="rptOthers" runat="server">
                        <ItemTemplate>
                                <tr style="background-color:<%#IIf(Container.ItemIndex Mod 2 = 0, "#FFFFFF", "#F0F0F0") %>">
                                    <td style="border-left:solid 1px black;border-right:solid 1px black;">
                                        <%#CType(Container.DataItem, OtherReasons).Reason %>
                                    </td>
                                    <td style="border-right:solid 1px black;white-space:nowrap;" align="center">
                                        <%#CType(Container.DataItem, OtherReasons).Refund.ToString("c") %>
                                    </td>
                                    <td style="border-right:solid 1px black;white-space:nowrap;" align="center">
                                        <%#CType(Container.DataItem, OtherReasons).Created.ToString("d") %>
                                    </td>
                                </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </td>
        </tr>
        </asp:Panel>
        </asp:Panel>
        <tr style="height:5px;">
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    <asp:LinkButton ID="lnkRequery" runat="server" />
    <asp:LinkButton ID="lnkExport" runat="server" />
</asp:Panel></asp:Content>