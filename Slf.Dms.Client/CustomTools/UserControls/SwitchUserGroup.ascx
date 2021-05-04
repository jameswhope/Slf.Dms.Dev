<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SwitchUserGroup.ascx.vb"
    Inherits="CustomTools_UserControls_SwitchUserGroup" %>
<script type="text/javascript" >
    function DoSwitchRedirect() {
        try
        {
            parent.RedirectToDefault();
        }
        catch (e) {
            var btn = document.getElementById('<%= lnkSwitchRedirect.ClientID%>');
            btn.click();
        }
    }
</script>
<table>
    <tr>
        <td colspan="2">
            <asp:Label ID="Label1" runat="server" Text="Select new group:"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <asp:DropDownList ID="ddlUserGroup" runat="server" Height="17px" Width="170px">
            </asp:DropDownList>
            <asp:Button ID="btnSwitch" runat="server" Text="Switch" style="font-family:Tahoma; font-size:11px;" />
        </td>
    </tr>
</table>
<asp:LinkButton ID="lnkSwitchRedirect" runat="server"></asp:LinkButton>