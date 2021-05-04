<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientAccountSummary.ascx.vb"
    Inherits="processing_webparts_ClientAccountSummary" %>
    
<asp:UpdatePanel ID="updAccountSummary" runat="server">
    <ContentTemplate>
        <asp:GridView ID="gvSummary" runat="server" AllowSorting="True" AutoGenerateColumns="False"
            DataKeyNames="AccountId,CurrentCreditorID,OriginalCreditorID" GridLines="None"
            DataSourceID="dsSummary">
            <HeaderStyle ForeColor="Black" />
            <EmptyDataTemplate>
                <div>
                    No records to display.</div>
            </EmptyDataTemplate>
            <Columns>
                <asp:BoundField DataField="CurrentCreditorName" HeaderText="Name" SortExpression="CurrentCreditorName">
                    <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                    <ItemStyle HorizontalAlign="left" CssClass="listItem" />
                </asp:BoundField>
                <asp:BoundField DataField="CurrentAccountNumber" HeaderText="Acct #" SortExpression="CurrentAccountNumber">
                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                </asp:BoundField>
                <asp:BoundField DataField="AccountStatusCode" HeaderText="Status" SortExpression="AccountStatusCode">
                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                </asp:BoundField>
                <asp:BoundField DataField="CurrentAmount" DataFormatString="{0:c}" HeaderText="Amt"
                    HtmlEncode="false" SortExpression="CurrentAmount">
                    <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                    <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                </asp:BoundField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="dsSummary" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
            ProviderName="System.Data.SqlClient" SelectCommand="get_ClientAccountOverviewList"
            SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter DefaultValue="" Name="clientId" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="gvSummary" EventName="Sorting" />
    </Triggers>
</asp:UpdatePanel>
