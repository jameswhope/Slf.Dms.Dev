<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlementInformation.ascx.vb" Inherits="processing_webparts_SettlementInformation" %>
<link id="Link1" href="<%= ResolveUrl("../css/globalstyle.css")%>" type="text/css" rel="stylesheet" />

<asp:UpdatePanel ID="updSettlementHistory" runat="server">
    <ContentTemplate>
        <div style="margin-top:5px">
                    <asp:GridView ID="GridView1" runat="server" AllowPaging="False" AllowSorting="True"
                        AutoGenerateColumns="False" BorderStyle="None" DataSourceID="SqlDataSource1"
                        GridLines="none" Width="100%" CssClass="entry">
                        <HeaderStyle ForeColor="Black" />
                        <EmptyDataTemplate>
                            <div>
                                No records to display.</div>
                        </EmptyDataTemplate>
                        <Columns>
                            <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-HorizontalAlign="Center"
                                HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="Left" CssClass="listitem" />
                            </asp:BoundField>
                             <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" ItemStyle-HorizontalAlign="Center"
                                HtmlEncode="false" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="Center" CssClass="listitem" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CreatedBy" DataFormatString="{0:d}" HeaderText="Created By"
                                HtmlEncode="False" >
                                <HeaderStyle HorizontalAlign="Left" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="Left" CssClass="listitem" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Comment" HeaderText="Comment"  HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="Left" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="Left" CssClass="listitem" />
                            </asp:BoundField>                            
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                        SelectCommand=""></asp:SqlDataSource>         
        </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="RowCommand" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="Sorting" />
    </Triggers>
</asp:UpdatePanel>
      
<asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
