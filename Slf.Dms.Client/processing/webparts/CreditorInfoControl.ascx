<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CreditorInfoControl.ascx.vb"
    Inherits="negotiation_webparts_CreditorInfoControl" %>

<asp:UpdatePanel ID="upCred" runat="server">
    <ContentTemplate>
        <div id="divCreditor" runat="server" >
            <table style="display: block;" id="tblView"  runat="server">
                <tr class="entry2">
                    <td nowrap="nowrap" align="right" style="width: 85px;">
                        <asp:Label ID="Label11" runat="server" CssClass="entryFormat" Text="Orig. Creditor:" /></td>
                    <td align="left" nowrap="nowrap">
                        <asp:Label ID="lblViewForCreditorName" CssClass="entryFormat" Width="150px" runat="server" Text='<%# Eval("forcreditorname") %>' />
                    </td>
                </tr>
                <tr class="entry2">
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label15" runat="server" CssClass="entryFormat" Text="Curr. Creditor:" /></td>
                    <td align="left" nowrap="nowrap">
                        <asp:Label ID="lblViewCurrCreditorName"  CssClass="entryFormat" runat="server" Width="150px" Text='<%# Eval("creditorname") %>' />
                    </td>
                </tr>
                <tr class="entry2">
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label12" runat="server" CssClass="entryFormat" Text="Date Acquired:" /></td>
                    <td align="left" nowrap="nowrap">
                        <asp:Label ID="lblViewAcquired" runat="server" CssClass="entryFormat" Width="75px" Text='<%# Eval("Acquired","{0:d}") %>' />
                    </td>
                </tr>
                <tr class="entry2">
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label19" runat="server" CssClass="entryFormat" Text="Orig. Bal:"></asp:Label></td>
                    <td align="left" nowrap="nowrap">
                        <asp:Label ID="lblViewOrigAmt" runat="server" CssClass="entryFormat"  Text='<%# Eval("OriginalAmount","{0:C}") %>'
                            Width="62px" ReadOnly="true"/>
                    </td>
                </tr>
                <tr class="entry2">
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label21" runat="server" CssClass="entryFormat" Text="Curr. Bal:" /></td>
                    <td align="left" nowrap="nowrap">
                        <asp:Label ID="lblViewCurrAmt" CssClass="entryFormat" runat="server" Width="62px"
                            Text='<%# Eval("CurrentAmount","{0:C}") %>' ReadOnly="true" />
                    </td>
                </tr>
                <tr class="entry2">
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label13" runat="server" CssClass="entryFormat"  Text="Acct #:"></asp:Label></td>
                    <td align="left" nowrap="nowrap">
                        <asp:Label ID="lblViewAcctNum" runat="server" CssClass="entryFormat" ReadOnly="true"
                            Text='<%# Eval("AccountNumber") %>' Width="100px"/>
                    </td>
                </tr>
                <tr class="entry2">
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label17" runat="server" CssClass="entryFormat" Text="Ref #:"></asp:Label></td>
                    <td align="left" nowrap="nowrap">
                        <asp:Label ID="lblViewRefNum" runat="server" CssClass="entryFormat" ReadOnly="true"
                            Text='<%# Eval("ReferenceNumber") %>' Width="100px"/>
                    </td>
                </tr>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
