<%@ Control Language="VB" AutoEventWireup="false" CodeFile="HistoryControl.ascx.vb"
    Inherits="negotiation_webparts_HistoryControl" %>
<asp:UpdatePanel ID="upHist" runat="server">
    <ContentTemplate>
        <table style="height: 100%; width: 100%;">
            <tr valign="top">
                <td>
                    <div style="overflow: auto;">
                        <asp:GridView ID="GridView1" runat="server" Width="100%" AllowPaging="True" AllowSorting="True"
                            AutoGenerateColumns="False" DataSourceID="SqlDataSource1" PageSize="12" GridLines="none"
                            BorderStyle="None">
                            <RowStyle CssClass="GridRowStyle" />
                            <AlternatingRowStyle CssClass="GridAlternatingRowStyle" />
                            <PagerStyle CssClass="GridPagerStyle" />
                            <HeaderStyle CssClass="webpartgridhdrstyle" />
                            <EmptyDataTemplate>
                                <div>
                                    No records to display.</div>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkSelect" runat="server" CommandArgument='<%#bind("SettlementID") %>'
                                            CommandName="Select">Restore</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Status" ItemStyle-HorizontalAlign="Center" HeaderText="Status"
                                    SortExpression="Status" />
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Offer Direction"
                                    ItemStyle-HorizontalAlign="Center" SortExpression="OfferDirection">
                                    <ItemTemplate>
                                        <asp:Image ID="imgDir" runat="server" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Created" DataFormatString="{0:d}" HtmlEncode="False" HeaderText="Created"
                                    SortExpression="Created">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementPercent" HeaderText="Percent" SortExpression="SettlementPercent">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementAmount" DataFormatString="{0:C}" HtmlEncode="False"
                                    HeaderText="Amount" SortExpression="SettlementAmount">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementDueDate" DataFormatString="{0:d}" HeaderText="Due Date"
                                    HtmlEncode="False" SortExpression="SettlementDueDate">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                            SelectCommand="" />
                    </div>
                </td>
            </tr>
            <tr valign="bottom">
                <td nowrap="nowrap">
                    <asp:Label ID="labelA" runat="server" Text="A:  Accepted |" />
                    <asp:Label ID="label1" runat="server" Text="R:  Rejected |"></asp:Label>
                    <asp:Label ID="label2" runat="server" Text=" Made:"></asp:Label>
                    <asp:Image ID="imgMade" runat="server" ImageUrl="~/negotiation/images/offerout.png" />
                    <asp:Label ID="label3" runat="server" Text="| Received:"></asp:Label>
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/negotiation/images/offerin.png" />
                </td>
            </tr>
        </table>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="Sorting" />
    </Triggers>
</asp:UpdatePanel>
<asp:HiddenField ID="historyHiddenIDs" runat="server" EnableViewState="true" />
