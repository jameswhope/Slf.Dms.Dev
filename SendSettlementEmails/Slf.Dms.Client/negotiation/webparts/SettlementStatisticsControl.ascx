<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlementStatisticsControl.ascx.vb"
    Inherits="negotiation_webparts_SettlementStatisticsControl" %>
<ajaxToolkit:TabContainer ID="TabContainer1" Width="100%" runat="server" ActiveTabIndex="0" CssClass="tabContainer">
    <ajaxToolkit:TabPanel ID="tpIndividStats" Width="60%" runat="server" HeaderText="Individual">
        <ContentTemplate>
            <asp:GridView ID="gvIndivid" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                CellPadding="4" DataSourceID="sdsIndivid" ForeColor="#333333" GridLines="None">
                <SelectedRowStyle CssClass="webpartgridselectedrowstyle" />
                <HeaderStyle CssClass="webpartgridhdrstyle" />
                <AlternatingRowStyle CssClass="webpartgridaltrowstyle" />
                <RowStyle CssClass="webpartgridrowstyle" />
                <EmptyDataTemplate>
                    Individual statistics are not available.
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="Status" ItemStyle-HorizontalAlign="center" HeaderText="Status" ReadOnly="True" SortExpression="Status" />
                    <asp:TemplateField HeaderText="Offer Direction" SortExpression="OfferDirection">
                    <ItemTemplate>
                        <asp:Image ID="imgDir" runat="server" />
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                    <asp:BoundField DataField="Total" HeaderText="Total" ReadOnly="True" SortExpression="Total" />
                    <asp:BoundField DataField="Min Settlement %" HeaderText="Min %" ReadOnly="True"
                        SortExpression="Min Settlement %" ItemStyle-HorizontalAlign="center"
                         HtmlEncode="false" DataFormatString="{0:N2}"/>
                    <asp:BoundField DataField="Max Settlement %" HeaderText="Max %" ReadOnly="True"
                        SortExpression="Max Settlement %" ItemStyle-HorizontalAlign="center" HtmlEncode="false" DataFormatString="{0:N2}"/>
                    <asp:BoundField DataField="Avg Settlement %" HeaderText="Avg %" ReadOnly="True"
                        SortExpression="Avg Settlement %" ItemStyle-HorizontalAlign="center" HtmlEncode="false" DataFormatString="{0:N2}"/>
                    <asp:BoundField DataField="Min Settlement Amt" DataFormatString="{0:c}" HeaderText="Min Amt"
                        HtmlEncode="False" ReadOnly="True" SortExpression="Min Amt" ItemStyle-HorizontalAlign="right"/>
                    <asp:BoundField DataField="Max Settlement Amt" DataFormatString="{0:c}" HeaderText="Max Amt"
                        HtmlEncode="False" ReadOnly="True" SortExpression="Max Amt" ItemStyle-HorizontalAlign="right"/>
                    <asp:BoundField DataField="Avg Settlement Amt" DataFormatString="{0:c}" HeaderText="Avg Amt"
                        HtmlEncode="False" ReadOnly="True" SortExpression="Avg Amt" ItemStyle-HorizontalAlign="right"/>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sdsIndivid" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                ProviderName="System.Data.SqlClient" SelectCommand="stp_NegotiationStatsIndividual"
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter DefaultValue="0" Name="UserID" SessionField="UserID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="tpGroupStats" Width="60%" runat="server" HeaderText="Group">
        <ContentTemplate>
            <asp:GridView ID="gvGroup"  runat="server" AllowSorting="True" AutoGenerateColumns="False"
                CellPadding="4" DataSourceID="sdsGroup" ForeColor="#333333" GridLines="None"
                AllowPaging="True" PageSize="10">
                <SelectedRowStyle CssClass="webpartgridselectedrowstyle" />
                <HeaderStyle CssClass="webpartgridhdrstyle" />
                <AlternatingRowStyle CssClass="webpartgridaltrowstyle" />
                <RowStyle CssClass="webpartgridrowstyle" />
                <EmptyDataTemplate>
                    Group statistics are not available.
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="UserName" HeaderText="Name" ReadOnly="True" SortExpression="UserName" />
                    <asp:BoundField DataField="Status" HeaderText="Status" ReadOnly="True" SortExpression="Status" />
                    <asp:TemplateField HeaderText="Offer Direction" SortExpression="OfferDirection">
                    <ItemTemplate>
                        <asp:Image ID="imgDir" runat="server" />
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                    <asp:BoundField DataField="Total" ItemStyle-HorizontalAlign="center" HeaderText="Total" ReadOnly="True" SortExpression="Total" />
                    <asp:BoundField DataField="Min Settlement %" HeaderText="Min %" ReadOnly="True"
                        SortExpression="Min Settlement %" ItemStyle-HorizontalAlign="center" HtmlEncode="false" DataFormatString="{0:N2}"/>
                    <asp:BoundField DataField="Max Settlement %" HeaderText="Max %" ReadOnly="True"
                        SortExpression="Max Settlement %" ItemStyle-HorizontalAlign="center" HtmlEncode="false" DataFormatString="{0:N2}"/>
                    <asp:BoundField DataField="Avg Settlement %" HeaderText="Avg %" ReadOnly="True"
                        SortExpression="Avg Settlement %" ItemStyle-HorizontalAlign="center" HtmlEncode="false" DataFormatString="{0:N2}"/>
                    <asp:BoundField DataField="Min Settlement Amt" ItemStyle-HorizontalAlign="right"
                        HtmlEncode="false" DataFormatString="{0:c}" HeaderText="Min Amt" ReadOnly="True"
                        HeaderStyle-HorizontalAlign ="right"
                        SortExpression="Min Settlement Amt" />
                    <asp:BoundField DataField="Max Settlement Amt" HeaderText="Max Amt" ReadOnly="True"
                        ItemStyle-HorizontalAlign="right" HtmlEncode="false" DataFormatString="{0:c}"
                        HeaderStyle-HorizontalAlign ="right"
                        SortExpression="Max Settlement Amt" />
                    <asp:BoundField DataField="Avg Settlement Amt" HeaderText="Avg Amt" ReadOnly="True"
                        ItemStyle-HorizontalAlign="right" HtmlEncode="false" DataFormatString="{0:c}"
                         HeaderStyle-HorizontalAlign ="right"
                        SortExpression="Avg Settlement Amt" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="sdsGroup" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                ProviderName="System.Data.SqlClient" SelectCommand="stp_NegotiationStatsGroup"
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter DefaultValue="0" Name="UserID" SessionField="UserID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
</ajaxToolkit:TabContainer>
