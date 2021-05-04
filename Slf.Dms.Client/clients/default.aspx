<%@ Page Language="VB" MasterPageFile="~/clients/clients.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_default" title="DMP - Clients" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server">
<asp:placeholder id="pnlRedirectAgency" runat="server">
<script type="text/javascript">
    window.location="<%=ResolveURL("~/research/queries/clients/agency.aspx") %>";
</script>
</asp:placeholder>
<asp:placeholder id="pnlRedirectAttorney" runat="server">
<script type="text/javascript">
    window.location="<%=ResolveURL("~/research/queries/clients/attorney.aspx") %>";
</script>
</asp:placeholder>

    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td><img runat="server" width="8" height="28" src="~/images/spacer.gif"/></td>
            <asp:PlaceHolder ID="pnlEnrollNewClient" runat="server">
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/clients/new">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_person.png" />Screen New Client
                    </a>
                </td>
            </asp:PlaceHolder>
            <!--<asp:PlaceHolder id="pnlClientsAnalysis" runat="server">
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/clients/analysis">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_chart_bar.png" />Analysis
                    </a>
                </td>
            </asp:PlaceHolder>-->
            <asp:PlaceHolder ID="pnlImportClient" runat="server">
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a id="A1" runat="server" class="menuButton" href="~/clients/import">
                        <img id="Img1" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_person_add.png" />Import Clients
                    </a>
                </td>
            </asp:PlaceHolder>
            <td style="width:100%">&nbsp;</td>
            <td nowrap="true" id="tdSearch" runat="server">
                <a runat="server" class="menuButton" href="~/search.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_search.png" />Search</a></td>
            <td><img runat="server" width="8" height="28" src="~/images/spacer.gif"/></td>
        </tr>
    </table>
</asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body>

    <asp:Panel runat="server" ID="pnlBodyDefault">
        <table style="width:100%;height:100%;" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
    </asp:Panel>

</body>

</asp:Content>