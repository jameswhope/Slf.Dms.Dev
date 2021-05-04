<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="add.aspx.vb" Inherits="clients_client_finances_register_add" title="DMP - Client - Add Transaction" %>
<%@ MasterType TypeName="clients_client" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<script type="text/javascript">
function Record_CancelAndClose()
{
    // postback to cancel and close
    <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
}
</script>

<body>
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color:#666666;font-size:13px;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkFinanceRegister" runat="server" class="lnk" style="font-size:11px;color:#666666;">Finances</a>&nbsp;>&nbsp;Add A Transaction</td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td valign="top">
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformation"><img border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            There are four types of transactions that can be added to this client by you.  If you do not see
                                            a type transaction of transaction that you need to add, contact an administrator.
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td><br />
                <table style="width:175;font-family:tahoma;font-size:11px;" border="0" cellpadding="5" cellspacing="0">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Transaction Options</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="aAddDeposit" runat="server" class="lnk" href=""><img style="margin-right:5;" src="~/images/16x16_entrytype.png" runat="server" border="0" align="absmiddle"/>Make A New Deposit</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="aAddFee" runat="server" class="lnk" href=""><img style="margin-right:5;" src="~/images/16x16_entrytype.png" runat="server" border="0" align="absmiddle"/>Assess A New Fee</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="aAddFeeAdjustment" runat="server" class="lnk" href=""><img style="margin-right:5;" src="~/images/16x16_entrytype.png" runat="server" border="0" align="absmiddle"/>Adjust An Existing Fee</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="aAddDebit" runat="server" class="lnk" href=""><img style="margin-right:5;" src="~/images/16x16_entrytype.png" runat="server" border="0" align="absmiddle"/>Make A New Debit</a></td>
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