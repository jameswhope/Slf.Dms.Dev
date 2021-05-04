<%@ Control Language="VB" AutoEventWireup="false" CodeFile="C21Transaction.ascx.vb" Inherits="Clients_client_finances_bytype_action_usercontrols_C21Transaction" %>
<link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" /> 
<style type="text/css">
    .entry { font-family:tahoma;font-size:11px;width:100%; }
    .entrycell {  }
    .entrytitlecell { width:100; }
    .style1
    {
        width: 185px;
    }
</style>

<table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
    <tr>
        <td valign="top">
            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td colspan="2" nowrap="true" style="background-color:#f1f1f1;"><b>Check 21 Transaction</b></td>
                </tr>
                <tr>
                    <td class="style1">Transaction ID:</td>
                    <td><asp:Label CssClass="entry" runat="server" ID="lblTransactionID"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Account Number (Shadow Store Id):</td>
                    <td><asp:Label CssClass="entry" runat="server" ID="lblAccountNumber"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Check Number:</td>
                    <td><asp:Label CssClass="entry" runat="server" ID="lblCheckNumber"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Amount:</td>
                    <td><asp:Label CssClass="entry" runat="server" ID="lblAmount"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Current State:</td>
                    <td><asp:Label CssClass="entry" runat="server" ID="lblState"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Current Status:</td>
                    <td><asp:Label CssClass="entry" runat="server" ID="lblStatus"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Created on:</td>
                    <td><asp:Label runat="server" ID="lblCreated"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Received on:</td>
                    <td><asp:Label runat="server" ID="lblReceivedDate"></asp:Label></td>
                </tr>
                <tr>
                    <td class="style1">Processed on:</td>
                    <td><asp:Label runat="server" ID="lblProcessedDate"></asp:Label></td>
                </tr>
         </table>
        </td>
        </tr>
        <tr>
        <td>
        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
            <tr id="trFrontImage" runat="server"  >
                <td class="style1">
                    Front Image:</td>
            </tr>
            <tr>
                <td>
                    <asp:Image ID="imgFront" runat="server" AlternateText="Front Image" BorderWidth="1px"  />
                </td>
            </tr>
            <tr>
                <td class="style1">
                    Back Image:</td>
            </tr>
            <tr id="trBackImage" runat="server">
                <td>
                    <asp:Image ID="imgBack" runat="server" AlternateText="Back Image" BorderWidth="1px" />
                </td>
            </tr>
    </table>
        </td>
    </tr>
</table>

