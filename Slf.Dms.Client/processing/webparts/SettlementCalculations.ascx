<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlementCalculations.ascx.vb"
    Inherits="processing_webparts_SettlementCalculations" %>
<style type="text/css">
    .style1
    {
/*        height: 373px;*/
    }
</style>
<table width="650px" cellpadding="0" cellspacing="10" border="0">
    <tr>
        <td style="font-size:12px; font-weight:bold; border-bottom: solid 1px #000000">
            Account Being Settled
        </td>
        <td style="font-size:12px; font-weight:bold; border-bottom: solid 1px #000000">
            Settlement Fee Calculation
        </td>
    </tr>
    <tr>
        <td valign="top" style="padding-right:15px" rowspan="5">
            <table width="100%" cellspacing="0" cellpadding="3" class="entryFormat">
                <tr>
                    <td colspan="2">
                        <table cellspacing="0" cellpadding="3" class="entryFormat">
                            <tr >
                                <td align="right">Original Creditor:
                                </td>
                                <td>
                                    <asp:Label ID="lblOrigCreditor" runat="server" CssClass="entryFormat"></asp:Label>
                                </td>
                            </tr>
                            <tr >
                                <td align="right">Current Creditor:
                                </td>
                                <td>
                                    <asp:Label ID="lblCurCreditor" runat="server" CssClass="entryFormat"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Account No:
                                </td>
                                <td>
                                <asp:Label ID="lblAcctNo" runat="server" CssClass="entryFormat"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Reference No:
                                </td>
                                <td> <asp:Label ID="lblRefNo" runat="server" CssClass="entryFormat"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Deadline:
                                </td>
                                <td>
                                    <asp:Label ID="lblDueDate" runat="server" CssClass="entryFormat"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        A. Creditor Account Balance:
                    </td>
                    <td align="right">
                        
                    </td>
                </tr>
                 <tr id="trOrigBal" runat="server">
                    <td style="padding-left:20px;">
                        Original
                    </td>
                    <td align="right">
                        <asp:Label ID="lblOriginalBalance" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr id="trCurrBal" runat="server">
                    <td style="padding-left:20px;">
                        Current
                    </td>
                    <td align="right">
                        <asp:Label ID="lblCurrentBalance" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        B. <b>Settlement Amount:</b>
                    </td>
                    <td align="right" class="entryFormat" style="font-weight:bold">
                        <asp:Literal ID="txtSettlementAmt" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr id="trDownPayment" runat="server">
                    <td style="padding-left:20px;">
                       Down Payment Amount: 
                    </td>
                    <td align="right" class="entryFormat"  >
                        <asp:Literal ID="txtDownPaymentAmt" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr id="trStillOwedToCreditor" runat="server">
                    <td style="padding-left:20px;">
                       Amount Still Owed To Creditor: 
                    </td>
                    <td align="right" class="entryFormat"  >
                        <asp:Literal ID="txtStillOwedToCreditor" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td class="entryFormat">
                        C. PFO Balance:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblPFOBalance" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="entryFormat">
                        D. SDA Balance:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblCurrentSDA" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        E. Bank Reserve:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblBankReserve" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        F. Funds On Hold:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblFundsOnHold" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        G. Amount Available:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblAvailSDABal" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        H. Amount Being Sent:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblAmtSent" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        I. Amount Still Owed:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblAmtOwed" runat="server" CssClass="entryFormat"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
        <td valign="top" class="style1">
            <table width="100%" cellspacing="0" cellpadding="3" class="entryFormat">
                <tr>
                    <td>
                        J. Savings (A-B):
                    </td>
                    <td align="right">
                        <asp:Label ID="lblSettlementSavings" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
                <tr>
                    <td>
                        K. Settlement Fee:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblSettlementFee" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
                <tr>
                    <td>
                        L. Adjusted Settlement Fee:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblAdjustedFee" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
                <tr>
                    <td>
                        M. Settlement Fee Credit (PR only):
                    </td>
                    <td align="right">
                        <asp:Label ID="lblSettlementFeeCredit" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
                <tr>
                    <td>
                        N. Disbursement Delivery Cost:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblOvernightDeliveryCost" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
                <tr>
                    <td>
                        O. <b>Settlement Cost:</b>
                    </td>
                    <td align="right">
                        <asp:Label ID="lblSettlementCost" runat="server" CssClass="entryFormat" Font-Bold="true" />
                    </td>
                </tr>
                <tr>
                    <td>
                        P. Amount Available:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblSettlementFee_AmtAvailable" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Q. Amount Being Paid:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblSettlementFee_AmtBeingPaid" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
                <tr>
                    <td>
                        R. Amount Still Owed:
                    </td>
                    <td align="right">
                        <asp:Label ID="lblSettlementFee_AmtStillOwed" runat="server" CssClass="entryFormat" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
     <tr>
        <td style="font-size:12px; font-weight:bold; border-bottom: solid 1px #000000; color:Red;">
            Special Instructions
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="lblSpecialInstructions" runat="server" />
        </td>
    </tr>
    <tr>
        <td style="font-size:12px; font-weight:bold; border-bottom: solid 1px #000000">
            Expected Deposits
        </td>
    </tr>
    <tr>
        <td>
            <asp:GridView ID="gvExpected" runat="server" AutoGenerateColumns="false" Width="100%" CssClass="entry2" GridLines="Horizontal" BorderWidth="0">
                <Columns>
                    <asp:BoundField DataField="depositdate" HeaderText="Date" DataFormatString="{0:MMM d, yyyy}" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="listItem" />
                    <asp:BoundField DataField="depositamount" HeaderText="Amount" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="listItem" />
                    <asp:BoundField DataField="depositmethod" HeaderText="Method" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="listItem" />
                    <asp:BoundField DataField="deposittype" HeaderText="Type" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="listItem" />
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding:7px">Client has no expected deposits before the settlement due date.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </td>
    </tr>
    <tr>
        <td></td>
        <td>
            <span style="font-weight:bold;width: 40%;">Delivery Method:</span><asp:Label ID="lblDeliveryMethod" runat="server" style="text-align: right;width: 60%;" />
        </td>
    </tr>
</table>