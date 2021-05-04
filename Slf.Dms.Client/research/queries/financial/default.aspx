<%@ Page Language="VB" MasterPageFile="~/research/queries/queries.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_queries_financial_default" title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/research/queries">Queries</a>&nbsp;>&nbsp;Financial</td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblServiceFees" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Service Fees</td>
                    </tr>
                    <tr id="trMy" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/financial/servicefees/my.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>My Service Fees</a></td>
                    </tr>
                    <tr id="trAll" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/financial/servicefees/all.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>All Service Fees</a></td>
                    </tr>
                    <tr id="trByAgency" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/financial/servicefees/byagency.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Service Fees by Agency</a></td>
                    </tr>
                    <tr id="trRemainingReceivables" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/financial/servicefees/remainingreceivables.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Remaining Receivables</a></td>
                    </tr>

                </table>
                
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5"  id="tblAccounting" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Accounting</td>
                    </tr>
                    <tr id="trGeneralClearingAccountTransfers" runat="server">
                        <td style="padding-left:20; white-space:nowrap"><a runat="server" class="lnk" href="~/research/queries/financial/accounting/clearingaccount.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>General Clearing Account Transfers</a></td>
                    </tr>
                    <tr id="tr1" runat="server">
                        <td style="padding-left:20; white-space:nowrap"><a id="A1" runat="server" class="lnk" href="~/research/queries/financial/accounting/disbursementaccount1.aspx"><img id="Img1" style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Disbursement Account Transfers</a></td>
                    </tr>
                    <tr id="tr2" runat="server">
                        <td style="padding-left:20; white-space:nowrap"><a id="A2" runat="server" class="lnk" href="~/research/queries/financial/accounting/controlledaccountactivity.aspx"><img id="Img2" style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Controlled Account Activity</a></td>
                    </tr>
                    <tr id="tr3" runat="server">
                        <td style="padding-left:20; white-space:nowrap"><a id="A3" runat="server" class="lnk" href="~/research/queries/financial/accounting/transfers.aspx"><img id="Img3" style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Bank Transfers</a></td>
                    </tr>
                    <tr id="trChecksToPrint" runat="server"> 
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/financial/accounting/checkstoprint/default.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Checks To Print</a></td>
                    </tr>
                </table>
                
                
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5"  id="tblCommission" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Commission</td>
                    </tr>
                    <tr id="trBatchPayments" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/queries/financial/commission/batchpayments.aspx"><img style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Batch Payments</a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>

