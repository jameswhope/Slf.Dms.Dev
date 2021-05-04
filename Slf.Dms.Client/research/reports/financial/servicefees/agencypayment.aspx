<%@ Page Language="VB" MasterPageFile="~/site.master" AutoEventWireup="false" CodeFile="agencypayment.aspx.vb" Inherits="clients_client_finances_bytype_agencypayment" title="DMP - Client - Register" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register Assembly="Slf.Dms.Controls" Namespace="Slf.Dms.Controls" TagPrefix="asi" %>

<asp:Content ID="cntMenu" ContentPlaceHolderID="cphMenu" Runat="Server"><asp:Panel runat="server" ID="pnlMenu">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            <td nowrap="true">
                <a class="menuButton" href="#" runat="server" id="lnkBack">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_arrowleft_clear.png" />Back to Service Fees</a></td>
            <td width="100%"></td>
        </tr>
    </table>   
</asp:Panel></asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel ID="pnlBody" runat="Server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript">

    function RowClick(RegisterID)
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & ClientID & "&rid=") %>" + RegisterID);
    }
	</script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><div style="color:rgb(80,80,80);font-family:tahoma;font-size:medium;" runat="server" ID="lnkClient"></div></td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv" style="background-color:rgb(213,236,188);">
                    <table class="iboxTable" style="background-color:rgb(213,236,188);" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td valign="top" ><asp:Label runat="server" ID="lblInfoBox"></asp:Label></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width:40%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;" colspan="2">Payment Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Payment Date:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblPaymentDate"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Paid Amount:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblPaymentAmount"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="height:25;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="background-color:#f1f1f1;" colspan="2">Fee Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Transaction ID:</td>
                                    <td><div  runat="server" ID="lnkRegisterID"></div></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Transaction Type:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblEntryTypeName"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Posting Date:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblTransactionDate"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Transaction Amount:</td>
                                    <td nowrap="true"><asp:Label runat="server" ID="lblAmount"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Balance After:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblBalance"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Check Number:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblCheckNumber"></asp:Label></td>
                                </tr>
                            </table>
                        </td>
                        <td><img height="1" width="30" runat="server" src="~/images/spacer.gif" /></td>
                        <td style="width:60%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr><td style="padding: 5 5 5 5;background-color:#f1f1f1;">Deposits Used For This Payment</td></tr>
                                <tr>
                                    <td>
                                        <asp:Panel runat="server" id="pnlCredits">
                                            <table id="tblCredits" onselectstart="return false;" style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="3" border="0">
		                                        <tr>
		                                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0"/></td>
			                                        <td class="headItem">Type</td>
			                                        <td class="headItem">Check #</td>
			                                        <td class="headItem">Date</td>
			                                        <td class="headItem" align="right" nowrap="true">Original Total</td>
			                                        <td class="headItem" align="right" style="padding-right:10;" nowrap="true">Portion Used</td>
		                                        </tr>
		                                        <asp:Repeater id="rpDeposits" runat="server">
			                                        <ItemTemplate>
			                                            <tr >
			                                                <td class="listItem" align="center" style="cursor:default"><img runat="server" src="~/images/16x16_cheque.png" border="0" style="cursor:default" /></td>
			                                                <td class="listItem" style="cursor:default" >
			                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterEntryTypeName")%>&nbsp;
			                                                </td>
			                                                <td class="listItem" style="cursor:default" >
			                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterCheckNumber")%>&nbsp;
			                                                </td>
			                                                <td class="listItem" style="cursor:default" >
			                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterTransactionDate", "{0:MM/dd/yyyy}")%>
			                                                </td>
			                                                <td align="right" class="listItem" style="cursor:default" >
			                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterAmount", "{0:c}")%>
			                                                </td>
			                                                <td style="color:rgb(0,139,0);padding-right:10;cursor:default" align="right" class="listItem" >
			                                                    <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>
			                                                </td>
			                                            </tr>
			                                        </ItemTemplate>
		                                        </asp:Repeater>
	                                        </table>
	                                    </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>

</body>

</asp:Panel></asp:Content>