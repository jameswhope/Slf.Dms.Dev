<%@ Control Language="VB" AutoEventWireup="false" CodeFile="StipulationLetterSentHistory.ascx.vb"
    Inherits="processing_webparts_StipulationLetterSentHistory" %>
<style type="text/css">
    .gvStipulation
    {
        margin-top: 5px;
        }
</style> 
<asp:Label ID="lblHistory" runat="server" Text="Stipulation Letter Submission History" ></asp:Label>    
<asp:GridView ID="gvStipulation" runat="server" AllowSorting="False" AutoGenerateColumns="False"
    DataKeyNames="LogId" BorderWidth="0" CssClass="gvStipulation"  >
    <HeaderStyle ForeColor="Black" />
    <EmptyDataTemplate>
        <div class="error">
            The client stipulation letter has not been sent to the client.
        </div>
    </EmptyDataTemplate>
    <Columns>
        <asp:BoundField DataField="dateSent" HeaderText="Date Sent">
            <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="SentByUser" HeaderText="Sent By">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="SendMethod" HeaderText="Method">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="SentTo" HeaderText="Sent To">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
    </Columns>
</asp:GridView>

