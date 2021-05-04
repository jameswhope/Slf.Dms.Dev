<%@ Page Language="VB" MasterPageFile="~/research/negotiation/negotiation.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="negotiation_master_default"
    Title="DMP - Criteria Builder" %>

<%@ Register Src="usercontrol/criteriaBuilder.ascx" TagName="criteriaBuilder" TagPrefix="uc1" %>



<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <script type="text/javascript" language="javascript">
        document.body.onload = function(ev)
        {
            OnLock();
            
            Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(CheckForUnlock);
        }
        
        document.body.onunload = function(ev)
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
        
        function OnLock()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkLock, Nothing) %>;
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
    
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        height: 100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td valign="top">
                <uc1:criteriaBuilder ID="ucCriteriaBuilder" runat="server" />
            </td>
        </tr>
    </table>
</asp:Content>