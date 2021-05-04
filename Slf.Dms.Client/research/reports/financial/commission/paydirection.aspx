<%@ Page Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master" AutoEventWireup="false" CodeFile="paydirection.aspx.vb" Inherits="research_reports_financial_commission_paydirection" Title="DMP - Commission" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
<asp:panel runat="server" id="pnlBody">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
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
        window.print();
    }
    
    function Year_Change(ddlYear)
    {   
        var ddlMonth = document.getElementById("<%=ddlMonth.ClientId %>");
        Month_Change(ddlMonth);
    }
    
    function Month_Change(ddlMonth)
    {
        var ddlYear = document.getElementById("<%=ddlYear.ClientId %>");
        var ddlDay = document.getElementById("<%=ddlDay.ClientId %>");
        
        var days = getDaysInMonth(ddlMonth.value,ddlYear.value);
        
        for (var i = 0; i < days; i++)
        {
            if (ddlDay.options.length >= i + 1)
            {
                ddlDay.options[i].innerHTML = i + 1;
            }
            else
            {
                var n = document.createElement("option");
                n.value = i + 1;
                ddlDay.options.add(n);
                n.innerHTML = i + 1;
            }
        }
        for (var i = ddlDay.options.length - 1; i > days - 1; i--)
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
        return new Date(yr, 2 - 1, 29).getDate() == 29;
    }
</script>
<style>
    table thead th {font-weight:normal}
</style>

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
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlCompany" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                                                       
                                    <td nowrap="true"><img id="Img1" style="margin:0 3 0 3;" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                    <td nowrap="true"><asp:LinkButton id="lnkRequery" runat="server" OnClick="lnkRequery_Click" class="gridButton"><img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton></td>
                                   
                                    <td nowrap="true"><img id="Img3" style="margin:0 3 0 3;" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                    <td nowrap="true"><asp:LinkButton id="lnkNewScenario" runat="server" onclick="lnkNewScenario_Click" class="gridButton"><img id="Img4" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_trust.png" />New Scenario</asp:LinkButton></td>

                                   <td nowrap="true"><img id="Img6" style="margin:0 3 0 3;" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                    <td nowrap="true"><asp:LinkButton id="lnkSettings" runat="server" onclick="lnkSettings_Click" class="gridButton"><img id="Img7" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_tools.png" />Settings</asp:LinkButton></td>
                                   
                                    <td nowrap="true" style="width:100%;">&nbsp;</td>
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
                <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;" cellspacing="15px">
                    <asp:Literal ID="ltrGrid" runat="server"></asp:Literal>
                </table>
            </td>
        </tr>
    </table>
</asp:panel>
</asp:Content>