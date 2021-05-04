<%@ Page Language="VB" MasterPageFile="~/research/negotiation/negotiation.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="project_Default" title="DMP - Negotiations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
<script type="text/javascript" language="javascript">
    document.body.onload = function()
    {
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(CheckForUnlock);
    }
    
    document.body.onunload = function()
    {
        OnUnlock();
    }
    
    function CheckForUnlock(sender, args)
    {
        if (args.get_postBackElement().id && args.get_postBackElement().id != '<%=lnkUnlock.ClientID %>' && args.get_postBackElement().id != '<%=lnkLock.ClientID %>')
        {
            OnUnlock();
        }
    }
    
    function OnUnlock()
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkUnlock, Nothing) %>;
    }
</script>

<asp:UpdatePanel ID="updUnlock" runat="server">
    <ContentTemplate>
        <asp:LinkButton ID="lnkUnlock" runat="server" />
        <asp:LinkButton ID="lnkLock" runat="server" />
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="lnkUnlock" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="lnkLock" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>

<asp:Panel ID="pnlMessage" CssClass="errorDiv" Style="margin:10px 0px 0px 10px;" Width="500px" Visible="false" runat="server">
    <table class="errorTable" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <img id="imgMsg" runat="server" src="~/images/16x16_lock.png" align="absmiddle" border="0">
            </td>
            <td>
                <asp:Label ID="lblLocked" Font-Names="Tahoma" Font-Size="11px" ForeColor="Red" Font-Bold="false" runat="server" />
            </td>
        </tr>
    </table>
</asp:Panel>
</asp:Content>