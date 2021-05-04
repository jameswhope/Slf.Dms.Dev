<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="payment.aspx.vb" Inherits="clients_client_finances_bytype_payment" title="DMP - Client - Payment" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register Assembly="Slf.Dms.Controls" Namespace="Slf.Dms.Controls" TagPrefix="asi" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript">

    function Record_AddTransaction()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/add.aspx?id=" & ClientID) %>");
    }
    function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function RowClick(RegisterID)
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & ClientID & "&rid=") %>" + RegisterID);
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
	</script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="font-size:11px;color:#666666;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkFinances" runat="server" class="lnk" style="font-size:11px;color:#666666;">Finances</a>&nbsp;>&nbsp;Payment</td>
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
                                    <td><a class="lnk" runat="server" ID="lnkRegisterID"></a></td>
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
			                                            <a href="<%# "register.aspx?id=" & ClientID & "&rid=" & DataBinder.Eval(Container.DataItem, "DepositRegisterID")%>">
				                                            <tr>
				                                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center"><img runat="server" src="~/images/16x16_cheque.png" border="0"/></td>
				                                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
				                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterEntryTypeName")%>&nbsp;
				                                                </td>
				                                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
				                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterCheckNumber")%>&nbsp;
				                                                </td>
				                                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
				                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterTransactionDate", "{0:MM/dd/yyyy}")%>
				                                                </td>
				                                                <td align="right" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
				                                                    <%#DataBinder.Eval(Container.DataItem, "DepositRegisterAmount", "{0:c}")%>
				                                                </td>
				                                                <td style="color:rgb(0,139,0);padding-right:10;" align="right" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
				                                                    <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>
				                                                </td>
				                                            </tr>
				                                        </a>
			                                        </ItemTemplate>
		                                        </asp:Repeater>
	                                        </table>
	                                    </asp:Panel>
                                    </td>
                                </tr>
                                <tr><td style="height:25;"></td></tr>
                                <tr>
                                    <td>
                                        <asi:TabStrip runat="server" id="tsCommission"></asi:TabStrip>
                                        <div id="dvCommissionPanel0" runat="server">
                                            <table onselectstart="return false;" style="margin-top:15;font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                <tr>
                                                    <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                                                    <td class="headItem">Type</td>
                                                    <td class="headItem">Recipient</td>
                                                    <td class="headItem" align="right">Percent</td>
                                                    <td class="headItem" align="right">Amount</td>
                                                </tr>
                                                <asp:repeater id="rpCommissions" runat="server">
                                                    <itemtemplate>
                                                        <a class="lnk" href="../comm/pay.aspx?id=<%= ClientID %>&cpid=<%#DataBinder.Eval(Container.DataItem, "CommPayID")%>">
                                                        <tr>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" style="width:22;" class="listItem" align="center">
                                                                <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                <%#DataBinder.Eval(Container.DataItem, "CommRecTypeName")%>&nbsp;
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                <%#DataBinder.Eval(Container.DataItem, "Display")%>&nbsp;
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                                <%#DataBinder.Eval(Container.DataItem, "Percent", "{0:#,##0.##%}")%>&nbsp;
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                                <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>&nbsp;
                                                            </td>
                                                        </tr>
                                                        </a>
                                                    </itemtemplate>
                                                </asp:repeater>
                                            </table>
                                            <asp:panel runat="server" id="pnlCommissionsNone" style="text-align:center;padding:20 5 5 5;color:#a1a1a1;">No commissions were issued from this payment.</asp:panel>
                                        </div>
                                        <div id="dvCommissionPanel1" runat="server">
                                            <table onselectstart="return false;" style="margin-top:15;font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                <tr>
                                                    <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                                                    <td class="headItem">Type</td>
                                                    <td class="headItem">Recipient</td>
                                                    <td class="headItem" align="right">Percent</td>
                                                    <td class="headItem" align="right">Amount</td>
                                                </tr>
                                                <asp:repeater id="rpChargebacks" runat="server">
                                                    <itemtemplate>
                                                        <a class="lnk" href="../comm/charge.aspx?id=<%= ClientID %>&cbid=<%#DataBinder.Eval(Container.DataItem, "CommChargebackID")%>">
                                                        <tr>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" style="width:22;" class="listItem" align="center">
                                                                <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                <%#DataBinder.Eval(Container.DataItem, "CommRecTypeName")%>&nbsp;
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                <%#DataBinder.Eval(Container.DataItem, "Display")%>&nbsp;
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                                <%#DataBinder.Eval(Container.DataItem, "Percent", "{0:#,##0.##%}")%>&nbsp;
                                                            </td>
                                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                                <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>&nbsp;
                                                            </td>
                                                        </tr>
                                                        </a>
                                                    </itemtemplate>
                                                </asp:repeater>
                                            </table>
                                            <asp:panel runat="server" id="pnlChargebacksNone" style="text-align:center;padding:20 5 5 5;color:#a1a1a1;">No chargebacks were issued from this payment.</asp:panel>
                                        </div>
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

</asp:Content>