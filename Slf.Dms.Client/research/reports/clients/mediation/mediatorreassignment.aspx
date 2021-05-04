<%@ Page Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false" CodeFile="mediatorreassignment.aspx.vb" Inherits="research_reports_clients_mediation_mediatorreassignment" title="DMP - Research" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
function Record_Fulfillment()
{
    var ids = <%=grdResults.GetSelectedValuesReference() %>;
    window.open("<%=ResolveUrl("~/research/reports/clients/mediation/mediatorassignment_alph.aspx")%>?clientids=" + ids, "win_mediatorassignment", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}
function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "report_clients_accountsoverpercentage", "winreport_clients_myassignments", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
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
						<td style="padding-top:10;">Negotiator:</td>
					</tr>
                    <tr>
                        <td>
                            <table style="font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <asp:dropdownlist runat="server" id="ddlUserID"></asp:dropdownlist>
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
                                            
                                            <td nowrap="true">
                                                <asp:LinkButton class="gridButton" id="lnkRequery" runat="server"><img id="Img3" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton>
                                            </td>
                                                                        
                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                            
                                            <td nowrap="true"><a id="lnkFulfillment" runat="server" class="gridButton" href="javascript:Record_Fulfillment();"><img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_publish.png" />Reassign Negotiators</a></td>
                                            
                                            <td nowrap="true" style="width:10;">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <asi:QueryGrid2 ID="grdResults" runat="server" XmlSchemaFile="~/querygrids.xml"></asi:QueryGrid2>
            </table>
            </div>
        </td>
    </tr>
</table>
</body>

</asp:PlaceHolder></asp:Content>