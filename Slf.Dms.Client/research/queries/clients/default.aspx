<%@ Page Language="VB" MasterPageFile="~/research/queries/clients/clients.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_queries_clients_default" title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/research/queries">Queries</a>&nbsp;>&nbsp;Clients</td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblDemographics" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Demographics</td>
                    </tr>
                    <tr id="trSimpleOverview" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/clients/demographics.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Simple Overview</a></td>
                    </tr>
                    <tr id="trDuplicates" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/clients/duplicates/"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Duplicates</a></td>
                    </tr>
                </table>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblMyClients" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">My Clients</td>
                    </tr>
                    <tr id="trMyClients" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/clients/agency.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>My Clients</a></td>
                    </tr>
                    <tr id="trMyClientsAttorney" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/clients/attorney.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>My Clients</a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>

