<%@ Control Language="VB" AutoEventWireup="false" CodeFile="RecentSearches.ascx.vb" Inherits="negotiation_webparts_RecentSearches" %>

<script language="javascript" type="text/javascript">
    function RecentSearch(terms)
    {
        document.getElementById('<%=hdnSearchTerms.ClientID %>').value = terms;
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkSearchTerms, Nothing) %>;
    }
</script>

<asp:UpdatePanel ID="updMain" UpdateMode="Conditional" runat="server">
    <ContentTemplate>
        <table style="table-layout:fixed;width:180px;" cellpadding="5" cellspacing="0" border="0">
            <tbody>
                <asp:Repeater ID="rptSearches" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td nowrap="nowrap" style="padding: 0px 5px 5px 20px;">
                                <a href="#" onclick="javascript:RecentSearch('<%#DataBinder.Eval(Container.DataItem, "Terms")%>');"><%#DataBinder.Eval(Container.DataItem, "Terms")%></a>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                <tr runat="server" id="trNoSearches">
                    <td style="padding:0px 5px 5px 20px;">
                        <font style="color:#A1A1A1;font-style:italic;">No Previous Searches</font>
                    </td>
                </tr>
            </tbody>
            
            <asp:HiddenField ID="hdnSearchTerms" runat="server" />
            <asp:LinkButton ID="lnkSearchTerms" runat="server" />
        </table>
    </ContentTemplate>
</asp:UpdatePanel>