<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NegotiationEntities.ascx.vb" Inherits="negotiation_webparts_NegotiationEntities" %>

<script language="javascript" type="text/javascript">
    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(RestoreScrollPosition);
    
    function RestoreScrollPosition()
    {
        var ls = document.getElementById('<%=lstEntity.ClientID %>');
        var st = document.getElementById('<%=hdnScrollTop.ClientID %>');
        
        ls.scrollTop = st.value;
    }
    
    function SaveScrollPosition()
    {
        var ls = document.getElementById('<%=lstEntity.ClientID %>');
        var st = document.getElementById('<%=hdnScrollTop.ClientID %>');
        
        st.value = ls.scrollTop;
    }
</script>

<style type="text/css">
    .selectList
    {
        color: #1080BF;
        overflow-x: visible;
        overflow-y: auto;
    }
</style>

<asp:UpdatePanel ID="updEntities" runat="server">
    <ContentTemplate>
        <div>
            <br />
            <asp:ListBox ID="lstEntity" AutoPostBack="true" CssClass="selectList" EnableViewState="true" Height="150px" Width="200px" SelectionMode="Multiple" onchange="javascript:SaveScrollPosition();" runat="server" />
            <ajaxToolkit:ListSearchExtender ID="lseEntity" TargetControlID="lstEntity" PromptPosition="Top" runat="server" />
        </div>
    </ContentTemplate>
</asp:UpdatePanel>

<asp:HiddenField ID="hdnScrollTop" runat="server" />