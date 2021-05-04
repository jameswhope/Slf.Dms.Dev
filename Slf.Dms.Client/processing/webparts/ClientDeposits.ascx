<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientDeposits.ascx.vb" Inherits="negotiation_webparts_ClientDeposits" %>

<script language="javascript" type="text/javascript">
    function AddAdditional()
    {
        window.open('<%=ResolveUrl("~/processing/popups/AddAdditional.aspx") %>?id=<%=DataClientID %>', 'AddAdditional', 'height=325,width=475');
    }
    
    function AddRule()
    {
        window.open('<%=ResolveUrl("~/processing/popups/AddRule.aspx") %>?id=<%=DataClientID %>', 'AddRule', 'height=325,width=700');
    }
    
    function LoadDeposits()
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkLoadDeposits, Nothing) %>;
    }
</script>

<asp:Panel ID="pnlDeposits" runat="server" style="height:300px">
    <table style="border-bottom:solid 1px #CCCCCC;width:100%;">
        <tbody>
            <tr>
                <td>
                    <a class="lnk" href="javascript:AddAdditional();">Add Additional ACH</a>
                    &nbsp;|&nbsp;
                    <a class="lnk" href="javascript:AddRule();">Add Rule</a>
                </td>
            </tr>
        </tbody>
    </table>
    <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="3" border="0">
        <tbody>
            <tr class="webpartgridhdrstyle">
                <td align="left">Date</td>
                <td align="left">Check #</td>
                <td align="right" style="padding-right:10px;">Amount</td>
                <td align="center">Void</td>
                <td align="center">Bounced</td>
                <td style="width:50px;">&nbsp;</td>
                <td align="left">Type</td>
            </tr>
            <asp:Repeater id="rpDeposits" runat="server">
                <ItemTemplate>
                    <tr>
                        <td align="left">
                            <%#LocalHelper.GetDateString(DataBinder.Eval(Container.DataItem, "TransactionDate"))%>&nbsp;
                        </td>
                        <td align="left">
                            <%#DataBinder.Eval(Container.DataItem, "CheckNumber").ToString()%>&nbsp;
                        </td>
                        <td align="right" style="padding-right:10px;">
                            <%#LocalHelper.GetCurrencyString(DataBinder.Eval(Container.DataItem, "Amount"))%>&nbsp;
                        </td>
                        <td align="center">
                            <%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Void"), Page)%>&nbsp;
                        </td>
                        <td align="center">
                            <%#LocalHelper.GetBoolString(DataBinder.Eval(Container.DataItem, "Bounce"), Page)%>&nbsp;
                        </td>
                        <td align="center" style="width:50px;">
                            <%#DataBinder.Eval(Container.DataItem, "DepositMethod").ToString()(0)%>&nbsp;
                        </td>
                        <td align="left">
                            <%#DataBinder.Eval(Container.DataItem, "DepositType").ToString()%>&nbsp;
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tbody>
    </table>
</asp:Panel>
<asp:Panel ID="pnlNone" style="text-align:center;color:#A1A1A1;padding:5px 5px 5px 5px;height:290px" runat="server">
    Client has no deposits
</asp:Panel>

<asp:LinkButton ID="lnkLoadDeposits" runat="server" />