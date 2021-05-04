<%@ Control Language="VB" AutoEventWireup="false" CodeFile="RecentVisits.ascx.vb" Inherits="negotiation_webparts_RecentVisits" %>

<script language="javascript" type="text/javascript">
    function RecentVisit(id)
    {
        document.getElementById('<%=hdnRecentVisit.ClientID %>').value = id;
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkRecentVisit, Nothing) %>;
    }
</script>

<table style="table-layout:fixed;width:180px;" cellpadding="5" cellspacing="0" border="0">
    <tbody>
        <asp:Repeater ID="rptSearches" runat="server">
            <ItemTemplate>
                <tr>
                    <td nowrap="nowrap" style="padding: 0px 5px 5px 20px;">
                        <a href="#" onclick="javascript:RecentVisit(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);"><%#DataBinder.Eval(Container.DataItem, "Name")%></a>
                    </td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <tr runat="server" id="trNoSearches">
            <td style="padding:0px 5px 5px 20px;">
                <font style="color:#A1A1A1;font-style:italic;">No Recent Visits</font>
            </td>
        </tr>
    </tbody>
    
    <asp:HiddenField ID="hdnRecentVisit" runat="server" />
    <asp:LinkButton ID="lnkRecentVisit" runat="server" />
</table>