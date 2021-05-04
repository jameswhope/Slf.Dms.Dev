<%@ Page Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false" CodeFile="attorney.aspx.vb" Inherits="research_queries_clients_attorney" title="DMP - Clients" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBodyAgency" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "query_clients_agency", "winquery_clients_agency", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}
function Search()
{
    <%=Page.ClientScript.GetPostBackEventReference(lnkRequery, Nothing) %>;
}
</script>
<style type="text/css">
thead th{
	position:relative; 
	top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
}
</style>
<body scroll="no">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" id="tdFilter" runat="server">
            <div style="padding:15 15 15 15;overflow:auto;height:100%;width:175;">
                <table style="font-family:tahoma;font-size:11px;width:100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding-bottom:10;"><b>Search</b></td>
                    </tr>
                    <tr>
                       <td nowrap="true">
                            <asp:TextBox style="width:140;font-family:tahoma;font-size:11px" runat="server" ID="txtSearchClients" onkeypress="if(event.keyCode==13)Search();"></asp:TextBox>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                     <tr>
                        <td>
                            <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optStatusChoice">
                                <asp:ListItem value="0" text="Only exclude statuses"/>
                                <asp:ListItem value="1" text="Only include statuses" selected="true"/>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csClientStatusID" SelectedRows="5"></asi:SmartCriteriaSelector>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Recieved LSA</b></td>
                    </tr>
                    <tr>
                        <td nowrap="true">
                            <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="Yes" id="chkRecievedLSAYes" runat="server" />
                            <asp:CheckBox style="font-size: 11px; font-family: Tahoma" selected="true" Text="No" id="chkRecievedLSANo" runat="server"/>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Date Screened</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:15;">1:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtEnrolledDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:15;">2:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtEnrolledDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
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
                    <td style="background-color:rgb(244,242,232);">
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                <td style="width:100%;">
                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td nowrap="true"><asp:LinkButton id="lnkShowFilter" class="gridButtonSel" runat="server"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_funnel.png" /></asp:LinkButton></td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkRequery" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Requery</asp:LinkButton></td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkClear" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_clear.png" />Clear Criteria</asp:LinkButton></td>
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
                <asi:QueryGrid id="grdResults" runat="server"></asi:QueryGrid>
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