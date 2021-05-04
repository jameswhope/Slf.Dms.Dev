<%@ Page Language="VB" MasterPageFile="~/research/queries/financial/accounting/accounting.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_queries_financial_checkstoprint_default" title="DMP - Research - Checks To Print" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server"><asp:placeholder id="pnlBody" runat="server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
window.baseurl = '<%= ResolveUrl("~/")%>';

function Record_Fulfillment()
{
     var Ids = <%=grdResults.GetSelectedValuesReference() %>;
     var url = '<%= ResolveUrl("~/research/queries/financial/accounting/checkstoprint/action.aspx") %>?ids=' + Ids;
     window.dialogArguments = window;
     currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
               title: "Checks To Print - Fulfillment",
               dialogArguments: window,
               resizable: false,
               scrollable: false,
               height: 600, width: 600});   
}
function Record_DeleteConfirm(obj)
{
    if (!obj.disabled){
        ConfirmationModalDialog({window: window, 
                                 title: "Delete Checks To Print", 
                                 callback: "Record_Delete", 
                                 message: "Are you sure you want to delete this selection of Checks To Print?"});
        }
}
function Record_Delete()
{
    // postback to delete
    <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
}
</script>

<body scroll="no">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" id="tdFilter" runat="server">
            <div style="padding:15 15 15 15;overflow:auto;height:100%;width:175;">
                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optClientChoice">
                                <asp:ListItem value="0" text="Only exclude clients"/>
                                <asp:ListItem value="1" text="Only include clients" selected="true"/>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csClientID" SelectedRows="5"></asi:SmartCriteriaSelector>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:CheckBox runat="server" id="chkChecksPrinted" text="All checks printed" checked="true"></asp:CheckBox></td>
                    </tr>
                    <tr>
                        <td><asp:CheckBox runat="server" id="chkChecksNotPrinted" text="All checks not printed" checked="true"></asp:CheckBox></td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Entered</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:15;">1:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="imCreatedDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:15;">2:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="imCreatedDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Printed</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:15;">1:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="imPrintedDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:15;">2:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="imPrintedDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="padding-bottom:10;"><b>Amount</b></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                                <tr>
                                    <td nowrap="true" style="width:15;">1:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><asp:TextBox class="entry" runat="server" ID="txtAmount1"></asp:TextBox></td>
                                    <td nowrap="true" style="width:15;">2:</td>
                                    <td nowrap="true" style="width:50%;padding-right:5;"><asp:TextBox class="entry" runat="server" ID="txtAmount2"></asp:TextBox></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
            <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
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
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><a id="lnkDeleteConfirm" disabled="true" runat="server" class="gridButton" href="#" onclick="javascript:Record_DeleteConfirm(this);"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_delete.png" /></a></td>
                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                            <td nowrap="true"><a id="lnkFulfillment" disabled="true" runat="server" class="gridButton" href="javascript:Record_Fulfillment();"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_publish.png" />Fulfillment</a></td>
                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                            <td nowrap="true"><a runat="server" class="gridButton" href="javascript:printResults()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
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
        </td>
    </tr>
</table>
</body>

<asp:LinkButton runat="server" id="lnkDelete" style="display:none;"></asp:LinkButton>

</asp:placeholder></asp:Content>