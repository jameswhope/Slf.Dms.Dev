<%@ Control Language="VB" AutoEventWireup="false" CodeFile="RecentDialerCalls.ascx.vb" Inherits="negotiation_webparts_RecentDialerCalls" %>

<script language="javascript" type="text/javascript">
    function RecentCall(callid, clientid)
    {
        document.getElementById('<%=hdnRecentCall.ClientID %>').value = '?id=' +  clientid + '&callid=' + callid;
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkRecentCall, Nothing) %>;
    }
</script>

<table style="table-layout:fixed;width:180px;" cellpadding="5" cellspacing="0" border="0">
    <tbody>
        <asp:Repeater ID="rptCalls" runat="server">
            <ItemTemplate>
                <tr>
                    <td nowrap="nowrap" style="padding: 0px 5px 5px 20px;">
                        <a href="#" onclick="javascript:RecentCall('<%#DataBinder.Eval(Container.DataItem, "CallMadeId")%>', '<%#DataBinder.Eval(Container.DataItem, "ClientId")%>');">
                           <%#DataBinder.Eval(Container.DataItem, "FullName")%>&nbsp;<%# DataBinder.Eval(Container.DataItem, "EventDate")%>
                        </a>
                    </td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <tr runat="server" id="trNoCalls">
            <td style="padding:0px 5px 5px 20px;">
                <font style="color:#A1A1A1;font-style:italic;">No Recent Dialer Calls</font>
            </td>
        </tr>
    </tbody>
    
    <asp:HiddenField ID="hdnRecentCall" runat="server" />
    <asp:LinkButton ID="lnkRecentCall" runat="server" />
</table>