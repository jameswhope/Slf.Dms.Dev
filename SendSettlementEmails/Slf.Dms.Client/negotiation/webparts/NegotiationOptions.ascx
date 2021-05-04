<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NegotiationOptions.ascx.vb" Inherits="negotiation_webparts_NegotiationOptions" %>

<asp:UpdatePanel ID="updOptions" runat="server">
    <ContentTemplate>
        <table style="height:150px;width:200px;">
            <tbody>
                <tr>
                    <td>
                        <div style="height:130px;overflow-x:visible;overflow-y:auto;width:200px;">
                            <ajaxToolkit:Accordion ID="accOptions" AutoSize="Fill" RequireOpenedPane="false" SuppressHeaderPostbacks="true" runat="server">
                                <Panes>
                                    <ajaxToolkit:AccordionPane ID="paneCols" runat="server">
                                        <Header>
                                            Columns To Display
                                        </Header>
                                        <Content>
                                            <asp:CheckBoxList ID="chkColumns" runat="server" />
                                        </Content>
                                    </ajaxToolkit:AccordionPane>
                                    <ajaxToolkit:AccordionPane ID="paneGroups" runat="server">
                                        <Header>
                                            Group By Column</Header>
                                        <Content>
                                            <asp:RadioButtonList ID="radGroups" runat="server" />
                                        </Content>
                                    </ajaxToolkit:AccordionPane>
                                    <ajaxToolkit:AccordionPane ID="paneShow" runat="server">
                                        <Header>
                                            How to Show Group
                                        </Header>
                                        <Content>
                                            <asp:RadioButtonList ID="radGroupShow" runat="server">
                                                <asp:ListItem Text="Show Collapsed" />
                                                <asp:ListItem Text="Show Expanded" Selected="True" />
                                            </asp:RadioButtonList>
                                        </Content>
                                    </ajaxToolkit:AccordionPane>
                                </Panes>
                            </ajaxToolkit:Accordion>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right;">
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkView, Nothing) %>;">
                            <img src="<%=ResolveUrl("~/negotiation/images/view_off.png") %>" style="border:none;cursor:hand;float:right;" onmouseout="this.src='<%=ResolveUrl("~/negotiation/images/view_off.png") %>';" onmouseover="this.src='<%=ResolveUrl("~/negotiation/images/view_on.png") %>';" alt="View" />
                        </a>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <asp:LinkButton ID="lnkView" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>