<%@ Page Language="VB" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_default" MasterPageFile="~/research/research.master" Title="DMP - Research" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body>


<script type="text/javascript">

function Hover(tbl, on)
{
    var tblInner = tbl.rows[0].cells[1].childNodes[0];
    var tdHeader = tblInner.rows[0].cells[0];
    var tdBody = tblInner.rows[1].cells[0];

    if (on)
    {
        tdHeader.style.color = "rgb(173,0,0)";
        tdHeader.style.borderBottomColor = "rgb(66,0,0)";
        tdBody.style.color = "rgb(66,0,0)";
    }
    else
    {
        tdHeader.style.color = "rgb(66,97,148)";
        tdHeader.style.borderBottomColor = "#e3e3e3";
        tdBody.style.color = "";
    }
}

</script>

<div style="height:100%;padding:10;" runat="server" id="divFunctions">

    <a id="aQueries" runat="server" href="~/research/queries/default.aspx"><table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);" onmouseout="Hover(this,false);" style="height:115;cursor:pointer;float:left;width:325;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td valign="top" style="width:48"><img alt="" runat="server" src="~/images/48x48_queries.png" border="0"/></td>
            <td valign="top" style="width:100%;">
                <table style="font-size:11px;font-family:tahoma;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td style="padding-bottom:3;border-bottom:solid 1px #e3e3e3;color:rgb(66,97,148);font-weight:bold;font-size:13px;">Queries</td>
                    </tr>
                    <tr>
                        <td style="padding-top:3;">Create, review, print or export data from the system
                            based on simple or advanced query.  Use a custom grouping selector
                            to get the data you want.</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table></a>
    <a id="aReports" runat="server" href="~/research/reports/default.aspx"><table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);" onmouseout="Hover(this,false);"style="height:115;cursor:pointer;float:left;width:325;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td valign="top" style="width:48"><img alt="" runat="server" src="~/images/48x48_reports.png" border="0"/></td>
            <td valign="top" style="width:100%;">
                <table style="font-size:11px;font-family:tahoma;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr><td style="padding-bottom:3;border-bottom:solid 1px #e3e3e3;color:rgb(66,97,148);height:100%;font-weight:bold;font-size:13px;">Reports</td></tr>
                    <tr>
                        <td>View reports about everything, from system objects to detailed financial aggregates.
                        All reports can be viewed as PDF, MS Word, Excel, HTML or text.</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table></a>
    <a id="aNegotiationInterface" runat="server" href="~/research/negotiation/default.aspx"><table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);" onmouseout="Hover(this,false);"style="height:115;cursor:pointer;float:left;width:325;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td valign="top" style="width:48"><img alt="" id="Img1" runat="server" src="~/images/48x48_settings.png" border="0"/></td>
            <td valign="top" style="width:100%;">
                <table style="font-size:11px;font-family:tahoma;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr><td style="padding-bottom:3;border-bottom:solid 1px #e3e3e3;color:rgb(66,97,148);height:100%;font-weight:bold;font-size:13px;">Negotiation Interface</td></tr>
                    <tr>
                        <td>Build criteria,create entities, assign criteria to entities, and generate negotiation distribution lists that can be viewed and exported in either Excel or PDF format.
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table></a>
<a id="aTools" runat="server" href="~/research/tools/default.aspx"><table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);" onmouseout="Hover(this,false);"style="height:115;cursor:pointer;float:left;width:325;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td valign="top" style="width:48"><img alt="" id="Img2" runat="server" src="~/images/48x48_tools.png" border="0"/></td>
            <td valign="top" style="width:100%;">
                <table style="font-size:11px;font-family:tahoma;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr><td style="padding-bottom:3;border-bottom:solid 1px #e3e3e3;color:rgb(66,97,148);height:100%;font-weight:bold;font-size:13px;">Tools</td></tr>
                    <tr>
                        <td>Collection of tools to assist in day-to-day operations.
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table></a>
    <a id="aMetrics" runat="server" href="~/research/metrics/default.aspx"><table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);" onmouseout="Hover(this,false);" style="height:115;cursor:pointer;float:left;width:325;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td valign="top" style="width:48"><img alt="" runat="server" src="~/images/48x48_settings.png" border="0"/></td>
            <td valign="top" style="width:100%;">
                <table style="font-size:11px;font-family:tahoma;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td style="padding-bottom:3;border-bottom:solid 1px #e3e3e3;color:rgb(66,97,148);height:100%;font-weight:bold;font-size:13px;">Metrics</td>
                    </tr>
                    <tr>
                        <td>Description here.</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table></a>
    

</div>

</body>

</asp:Content>
