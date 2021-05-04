<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/clients/clients.master" AutoEventWireup="false" CodeFile="CompletedClients.aspx.vb" Inherits="research_reports_clients_CompletedClients" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <table>
        <tr>
            <td style="color: #666666; padding-bottom: 15px">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a id="A2"
                    runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;<a id="A3"
                        runat="server" class="lnk" style="color: #666666;" href="~/research/reports/clients">Clients</a>&nbsp;>&nbsp;Completed Clients With Positive CDA
            </td>
        </tr>
    </table>
    <table width="100%">
        <tr>
            <td>
                <asp:Label ID="lblTitle" Text="Completed Clients With Positive CDA" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#2292F1" />
            </td>
        </tr>
        <tr>
            <td>
                <hr style="width:100%; border-width:thick; color:#2292F1;" runat="server"/>
            </td>
        </tr>
        <tr>
            <asp:GridView ID="gvClients" runat="server" AllowPaging="false" Height="90%" Width="100%" AutoGenerateColumns="false" BorderWidth="1" CellPadding="5" >
                <Columns>
                    <asp:BoundField DataField="ClientName" HeaderText="Client Name" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left"/>
                    <asp:BoundField DataField="AccountNumber" HeaderText="Account Number" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left"  />
                    <asp:BoundField DataField="CurrentStatus" HeaderText="Status" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
                    <asp:BoundField DataField="EffectiveDate" HeaderText="EffectiveDate" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="75px" />
                    <asp:BoundField DataField="sda" HeaderText="CDA" DataFormatString="{0:C}" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Right"/>
                    <asp:BoundField DataField="pfo" HeaderText="PFO" DataFormatString="{0:C}" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="DateOfNextDeposit" HeaderText="Next Deposit" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Left"  ItemStyle-HorizontalAlign="Right"/>
                    <asp:BoundField DataField="DepositAmount" HeaderText="Deposit Amount" DataFormatString="{0:C}" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="95px" />
                </Columns>
            </asp:GridView>
        </tr>
    </table>
</asp:Content>

