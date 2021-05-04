<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientSearchControl.ascx.vb" Inherits="negotiation_webparts_ClientSearchControl" %>

<asp:UpdatePanel ID="updMain" UpdateMode="Conditional" runat="server">
    <ContentTemplate>
        <table>
            <tbody>
                <tr>
                    <td style="padding-left:8px">
                        <asp:TextBox ID="txtSearch" Width="150px" runat="server" />
                    </td>
                    <td>
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkGo, Nothing) %>;">
                            <img alt="Search" onmouseout="this.src='<%=ResolveUrl("~/negotiation/images/go_off.png") %>';"
                                onmouseover="this.src='<%=ResolveUrl("~/negotiation/images/go_on.png") %>';"
                                src="<%=ResolveUrl("~/negotiation/images/go_off.png") %>" style="border: none;
                                cursor: hand; float: right;" />
                        </a>
                    </td>
                </tr>
                <tr>
                    <td style="height:60px">
                        <asp:RadioButtonList ID="radSearchDepth" runat="server">
                            <asp:ListItem Text="Search my assignments" Value="assignments" />
                            <asp:ListItem Text="Search entire system" Value="system" Selected="True" />
                        </asp:RadioButtonList>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </tbody>
        </table>

        <asp:LinkButton ID="lnkGo" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>