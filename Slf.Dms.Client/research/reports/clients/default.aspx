<%@ Page Language="VB" MasterPageFile="~/research/reports/clients/clients.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_reports_clients_default" title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;Clients</td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblTransactions" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Transactions</td>
                    </tr>
                    <tr id="trDepositDaysAgo" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/reports/clients/transactions/depositdaysago.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Deposit Days Ago</a></td>
                    </tr>
                </table>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblMediation" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Negotiation</td>
                    </tr>
                    <tr id="trAccountsOverPercentage" runat="server">
                        <td style=""><a class="lnk" href="http://report02/slf.dms.client/login.aspx?ReturnUrl=%2fslf.dms.client%2fresearch%2freports%2fclients%2fmediation%2faccountsoverpercentage.aspx&user=<%=encUserID %>"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Accounts Over Percentage</a></td>
                    </tr>
                    <tr id="trMediatorReassignment" runat="server">
                        <td style=""><a runat="server" class="lnk" href="~/research/reports/clients/mediation/mediatorreassignment.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Negotiator Reassignment</a></td>
                    </tr>
                    <tr id="trMyAssignments" runat="server">
                        <td style=""><a runat="server" class="lnk" href="~/research/reports/clients/mediation/myassignments.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>My Assignments (By Client)</a></td>
                    </tr>
                    <tr id="trMyAssignments_ByCreditor" runat="server">
                        <td style=""><a runat="server" class="lnk" href="~/research/reports/clients/mediation/myassignments_bycreditor.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>My Assignments (By Creditor)</a></td>
                    </tr>
                    <tr id="trNegotiationListUnsorted" runat="server">
                        <td style=""><a id="A4" runat="server" class="lnk" href="http://lexsrvsqlprod1/reportserver/?%2fNegotiation+Reports%2fNegotiation+List+-+Unsorted&rs:Command=Render"><img id="Img8" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Negotiation List&nbsp;–&nbsp;Unsorted</a></td>
                    </tr>                     
                </table>
                <table id="tblClientServices" style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Client Services</td>
                    </tr>
                    <tr id="trCancellations" runat="server">
                        <td style="padding-left:20;"><a class="lnk" runat="server" href="~/research/reports/clients/cancellations.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Client Cancellations</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A1" class="lnk" runat="server" href="~/research/reports/clients/clientsbystate.aspx">
                                <img id="Img1" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server"
                                    border="0" align="absmiddle" />Clients By State</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A2" class="lnk" runat="server" href="~/research/reports/clients/CompletedClients.aspx">
                                <img id="Img3" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server"
                                    border="0" align="absmiddle" />Completed With CDA Bal.</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A3" class="lnk" runat="server" href="~/research/reports/clients/ActiveClients.aspx">
                                <img id="Img4" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server"
                                    border="0" align="absmiddle" />Active Clients</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A5" class="lnk" runat="server" href="~/research/reports/clients/ActiveClientsPA.aspx">
                                <img id="Img5" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server"
                                    border="0" align="absmiddle" />Clients with Active P.A. </a>
                        </td>
                    </tr>
                </table>
                <table id="tblLegal" style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Legal</td>
                    </tr>
                      <tr id="tr2" runat="server">
                        <td style="padding-left:20;">
                           <a id="A8" runat="server" class="lnk" href="~/research/reports/clients/LegalCancellations.aspx?rpt=CancelledClients"><img id="Img2" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Legal Cancellation Report</a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>