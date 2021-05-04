<%@ Control Language="VB" AutoEventWireup="false" CodeFile="RptFeesPaid.ascx.vb" Inherits="CustomTools_UserControls_RptFeesPaid" %>
<table>
<tr>
<td class="tdGrdFees" >
    <asp:GridView ID="grdFeesPaid1" runat="server" AutoGenerateColumns="True"   
        ShowFooter="True" EmptyDataText="No data to display" CssClass="grdFeesPaid grdFeesPaid1">
        <EmptyDataRowStyle CssClass="grdFeesPaidEmpty" />
    </asp:GridView>
</td>
<td class="tdGrdFees" >
    <asp:GridView ID="grdFeesPaid2" runat="server" AutoGenerateColumns="True" 
        ShowFooter="True" EmptyDataText="No data to display" CssClass="grdFeesPaid grdFeesPaid2">
        <EmptyDataRowStyle CssClass="grdFeesPaidEmpty" />
    </asp:GridView>
</td>
<td class="tdGrdFees" >
    <asp:GridView ID="grdFeesPaidDiff" runat="server" AutoGenerateColumns="True" 
       ShowFooter="True" EmptyDataText="No data to display" CssClass="grdFeesPaid grdFeesPaidDiff">
        <EmptyDataRowStyle CssClass="grdFeesPaidEmpty" />
    </asp:GridView>
</td>
</tr>
</table>