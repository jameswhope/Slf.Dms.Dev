<%@ Page Language="VB" MasterPageFile="~/research/queries/financial/servicefees/servicefees.master" AutoEventWireup="false" CodeFile="commission.aspx.vb" Inherits="research_metrics_financial_commissioncomparison" title="DMP - Commission" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel runat="server" ID="pnlBody">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "query_servicefee_my_payments", "winrptservicefeereport", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}

var bUpdateGraph = true;
var iTimeout;
function UpdateGraph()
{
    if (bUpdateGraph == true)
    {
        bUpdateGraph = false;
        var img = document.getElementById("imgComparison");
        var newsrc = img.basesrc + "?w=" + img.offsetWidth + "&h=" + img.offsetHeight + "&company=" + document.getElementById("<%=ddlCompany.ClientID %>").value;
        var commrec = document.getElementById("<%=ddlCommRec.ClientID %>");
        
        if (commrec)
        {
            newsrc += "&commrecs=" + commrec.value;
        }
        
        img.src = newsrc;
        setTimeout("bUpdateGraph=true",1000);
    }
    else
    {
        clearTimeout(iTimeout);
        iTimeout=setTimeout("UpdateGraph()",100);
    }
}
function SaveGraph()
{
    bUpdateGraph = false;
    var img = document.getElementById("imgComparison");
    document.getElementById("ifrmAttachment").src=img.basesrc + "?w=800&h=600&download=true&company=" + document.getElementById("<%=ddlCompany.ClientID %>").value;
    setTimeout("bUpdateGraph=true", 1000);
}
function Requery()
{
    var ddlGrouping = document.getElementById("<%=ddlGrouping.ClientID %>");
    var ddlSplitting = document.getElementById("<%=ddlSplitting.ClientID %>");
    
    if (parseInt(ddlGrouping.value) < parseInt (ddlSplitting.value))
    {
        HideMessage();
        <%=Page.ClientScript.GetPostBackEventReference(lnkRequery, Nothing) %>
    }
    else
    {
        ShowMessage("Your granularity for grouping must be finer then your granularity for splitting");
    }
}
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function HideMessage()
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    dvError.style.display = "none";
}
</script>
<style>
    thead th{position:relative; top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);}
</style>

<body scroll="no" onload="UpdateGraph();" onresize="UpdateGraph()">
<iframe id="ifrmAttachment" style="display:none"></iframe>
<table style="font-family:tahoma;font-size:11px;width:100%"  border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top">
            <div runat="server" id="dvError" style="display:none;">
                <TABLE style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
			        <TR>
				        <TD valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
				        <TD runat="server" id="tdError"></TD>
			        </TR>
		        </TABLE>
		    </div>
        </td>
    </tr>
    
</table>
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" id="tdFilter" runat="server">
            <div style="padding:15 15 15 15;overflow:auto;height:100%;width:200px;">
                <table style="font-family:tahoma;font-size:11px;width:100%" border="0" cellpadding="0" cellspacing="0">
                    <asp:placeholder id="phRecipientCriteria" runat="server">
                    <tr>
                        <td>
                            <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optRecipientChoice">
                                <asp:ListItem value="0" text="Only exclude recipients"/>
                                <asp:ListItem value="1" text="Only include recipients" selected="true"/>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csCommRecID" SelectedRows="5"></asi:SmartCriteriaSelector>
                        </td>
                    </tr>
                    </asp:placeholder>

                    <tr>
                        <td style="padding-bottom:10;"><div id="lblCompany" runat="server"><b>Company</b></div></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:dropdownlist AccessKey="1" id="ddlCompany" runat="server" style="font-family:tahoma;font-size:11px;width:100%;" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><div id="lblCommRec" runat="server" visible="false"><b>Commission Recipient</b></div></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:DropDownList id="ddlCommRec" runat="server" style="font-family:tahoma;font-size:11px;width:100px;" Visible="false" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Grouping</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <select id="ddlGrouping" runat="server" style="font-family:tahoma;font-size:11px;width:100%;">
                                           <option value="0">Daily</option>
                                           <option value="1">Weekly</option>
                                           <option value="2">Monthly</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Splitting</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <select id="ddlSplitting" runat="server" style="font-family:tahoma;font-size:11px;width:100%;">
                                           <option value="1">Weekly</option>
                                           <option value="2" selected="true">Monthly</option>
                                           <option value="3">Yearly</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Date Range</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:15;">1:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:15;">2:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Chart Style</b></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:checkbox id="chkSpline" runat="server" text="Rounded Lines"></asp:checkbox><br />
                            <asp:checkbox id="chkPointLabels" runat="server" text="Point Labels"></asp:checkbox><br />
                            <asp:checkbox id="chkPointMarkers" runat="server" text="Point Markers"></asp:checkbox><br />
                            <asp:checkbox id="chk3D" runat="server" text="3-Dimensional"></asp:checkbox>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
            <div>
                <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="background-color:rgb(244,242,232);height:25">
                            <table style="color:rgb(80,80,80);width:100%;height:25;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <img runat="server" src="~/images/grid_top_left.png" border="0" />
                                    </td>
                                    <td style="width:100%;">
                                        <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td nowrap="true"><asp:LinkButton id="lnkShowFilter" class="gridButtonSel" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_funnel.png" /></asp:LinkButton></td>
                                                <td nowrap="true"><img id="Img3" style="width:3px" runat="server" src="~/images/spacer.bmp" /></td>
                                                <td nowrap="true"><asp:LinkButton id="lnkShowGrid" class="gridButtonSel" runat="server"><img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_table2.png" /></asp:LinkButton></td>
                                                <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="true"><a href="javascript:Requery()" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Requery</a></td>
                                                <asp:LinkButton id="lnkRequery" runat="server" ></asp:LinkButton>
                                                <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="true"><asp:LinkButton id="lnkClear" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_clear.png" />Clear Criteria</asp:LinkButton></td>
                                                
                                                <td nowrap="true" style="width:100%;">&nbsp;</td>
                                                
                                                <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                                <td nowrap="true"><a class="gridButton" href="<%=ResolveUrl("~/research/metrics/financial/commissiongraph.ashx?w=800&h=600&download=true") %>"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_chart_save.png" /></a></td>
                                                <td nowrap="true" style="width:10;">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="height:100%" valign="top">
                            <div style="height:100%;overflow:auto ">
                                <img galleryimg="false" style="width:100%;height:98%" id="imgComparison" 
                                    basesrc="<%=ResolveUrl("~/research/metrics/financial/commissiongraph.ashx") %>" />
                            </div>
                        </td>
                    </tr>
                    <tr id="trGrid" runat="server">
                        <td style="height:180px;width:100%;border-top:solid 1px #d3d3d3" valign="top">
                            <div style="height:100%;width:100%;overflow:auto;">
                                <table style="width:100%;font-size:11px;font-family:tahoma;padding-left:5px" cellpadding="0" cellspacing="0">
                                    <asp:literal id="ltrGrid" runat="server"></asp:literal>
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

</asp:Panel></asp:Content>