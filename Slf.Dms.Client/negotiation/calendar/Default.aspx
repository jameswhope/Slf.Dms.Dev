<%@ Page Language="VB" MasterPageFile="~/negotiation/Negotiation.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="negotiation_calendar_Default" title="Untitled Page" %>

<%@ Register Src="~/negotiation/webparts/Calendar.ascx" TagName="Calendar" TagPrefix="cc" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <asp:WebPartManager ID="WebPartManager1" runat="server">
        <Personalization InitialScope="Shared" Enabled="true" />
    </asp:WebPartManager>
    <div style="position:absolute;top:125px;width:100%;">
        <table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
            <tr>
                <td style="text-align:center;vertical-align:top;">
                    <asp:WebPartZone ID="NavBarZone" HeaderText="NavBar" BorderWidth="0px" Padding="3" WebPartVerbRenderMode="TitleBar" runat="server">
                        <ZoneTemplate>
                            <cc:Calendar ID="ccCalendar" title="My Calendar" runat="server" />
                        </ZoneTemplate>
                        <EmptyZoneTextStyle Font-Size="10px" />
                        <MenuLabelStyle ForeColor="#FFFFFF" />
                        <MenuLabelHoverStyle ForeColor="#E2DED6" />
                        <MenuPopupStyle BackColor="#5D7B9D" BorderColor="#CCCCCC" BorderWidth="1px" Font-Names="Tahoma, Verdana, Arial"
                            Font-Size="10px" />
                        <MenuVerbHoverStyle BackColor="#F7F6F3" BorderColor="#CCCCCC" BorderStyle="Solid"
                            BorderWidth="1px" ForeColor="#333333" />
                        <MenuVerbStyle BorderColor="#5D7B9D" BorderStyle="Solid" BorderWidth="1px" ForeColor="#FFFFFF" />
                        <PartChromeStyle CssClass="webPartChromeStyle" BackColor="#F7F6F3" BorderWidth="1px"
                            BorderColor="#A2CEE4" Font-Names="Tahoma, Verdana, Arial" Font-Size="11px" ForeColor="#006699" />
                        <PartStyle CssClass="webPartStyle" Font-Names="Tahoma, Verdana, Arial" Font-Size="11px"
                            ForeColor="#003366" />
                        <PartTitleStyle CssClass="webPartHdrStyle" Font-Bold="true" Font-Names="Tahoma, Verdana, Arial"
                            Font-Size="12px" ForeColor="#006699" />
                        <TitleBarVerbStyle Font-Bold="true" Font-Names="Tahoma, Verdana, Arial" Font-Size="12px"
                            ForeColor="#006699" />
                        <CloseVerb Visible="false" />
                        <MinimizeVerb ImageUrl="~/negotiation/images/minimize_off.png" Description="Minimize" Text="Minimize" />
                        <RestoreVerb ImageUrl="~/negotiation/images/maximize_off.png" Description="Maximize" Text="Maximize" />
                    </asp:WebPartZone>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>