<%@ Page Language="VB" MasterPageFile="~/research/reports/reports.master" AutoEventWireup="true" CodeFile="default.aspx.vb" Inherits="research_reports_financial_default" title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;Financial</td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblServiceFees" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Service Fees</td>
                    </tr>
                    <tr id="trAgency" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/reports/financial/servicefees/agency.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Service Fees</a></td>
                    </tr>
                    <tr id="trMy" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/reports/financial/servicefees/my.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>My Service Fees</a></td>
                    </tr>
                    <tr id="trAll" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/reports/financial/servicefees/all.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>All Service Fees</a></td>
                    </tr>
                    <tr id="tr1" runat="server">
                        <td style="padding-left:20;">
                           <a id="A7" runat="server" class="lnk" href="~/research/reports/financial/servicefees/RefundReport.aspx?rpt=refund"><img id="Img7" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Refund Report</a>
                        </td>
                    </tr>
                    <tr id="tr2" runat="server">
                        <td style="padding-left:20;">
                           <a id="A8" runat="server" class="lnk" href="~/research/reports/clients/LegalCancellations.aspx?rpt=cancellations"><img id="Img8" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Cancellation Report</a>
                        </td>
                    </tr>
                     <tr id="tr5" runat="server">
                        <td style="padding-left:20;">
                           <a id="A13" runat="server" class="lnk" href="~/research/reports/financial/servicefees/FeePaidCompare.aspx?rpt=compare"><img id="Img16" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Fees To Payees</a>
                        </td>
                    </tr>
                </table>
                 <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblCommission" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Commission</td>
                    </tr>
                    <tr id="trBatchPaymentsAgency" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/reports/financial/commission/batchpaymentsagency.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Agency Batch Payments</a></td>
                    </tr>
                    <tr id="trBatchPayments" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/reports/financial/commission/batchpayments.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Batch Payments</a></td>
                    </tr>
                    <tr id="trInitialAgency" runat="server">
                        <td style="padding-left:20;"><a id="A2" class="lnk" href="http://lexsrvsqlprod1/Reportserver?%2fBouncedDrafts%2fBounced+Draft+Report&rs:Command=Render&Agency=<%# AgencyID %>"><img id="Img5" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Initial Draft Status</a></td> 
                    </tr>
                    <tr id="trBatchPaymentsSummary" runat="server">
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/research/reports/financial/commission/batchpaymentssummary.aspx"><img style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Batch Payments Summary</a></td> 
                    </tr>
                    <tr id="trCIDCommissionPayments" runat="server">
                        <td style="padding-left:20;"><a id="A9" runat="server" class="lnk" href="~/research/reports/financial/commission/clientintakepayments.aspx"><img id="Img11" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Client Intake Payments</a></td> 
                    </tr>
                    <tr id="trOwedtoGCA" runat="server">
                        <td style="padding-left:20;"><a class="lnk" href="commission/owed-to-gca.aspx"><img id="Img12" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Owed to GCA</a>
                        </td>
                    </tr>
                    <tr id="tr3" runat="server">
                        <td style="padding-left:20;"><a class="lnk" href="commission/withholdingReport.aspx"><img id="Img13" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="amiddle"/>Commissions Withheld</a>
                        </td>
                    </tr>
                </table>
                <table id="tblAccounting" style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Accounting</td>
                    </tr>
                    <tr id="trDepositReport" runat="server">
                        <td style="padding-left:20;">
                        <%--<a runat="server" class="lnk" href="http://lexsrvsqlprod1/Reportserver?%2fCPASolutions%2fDeposits&rs:Command=Render"><img id="Img1" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Deposit Report</a>--%>
                        <a id="A6" runat="server" class="lnk" href="~/research/reports/financial/accounting/default.aspx?rpt=depo"><img id="Img1" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Deposit Report</a>
                        </td>
                    </tr>
                    <tr id="trDisbursementReport" runat="server">
                        <td style="padding-left:20;">
                        <%--<a runat="server" class="lnk" href="http://lexsrvsqlprod1/reportserver?%2fCPASolutions%2fDisbursements&rs:Command=Render"><img id="Img2" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Disbursement Report</a>--%>
                        <a id="A4" runat="server" class="lnk" href="~/research/reports/financial/accounting/default.aspx?rpt=disb"><img id="Img2" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Disbursement Report</a>
                        </td>
                    </tr>
                    <tr id="trCommissionReport" runat="server">
                        <td style="padding-left:20;">
                        <%--<a runat="server" class="lnk" href="http://lexsrvsqlprod1/reportserver?%2fCPASolutions%2fCommission&rs:Command=Render"><img id="Img3" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Commission Report</a>--%>
                        <a id="A5" runat="server" class="lnk" href="~/research/reports/financial/accounting/default.aspx?rpt=comm"><img id="Img3" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Commission Report</a>
                        </td>
                    </tr>
                    <tr id="trNonDepositReport" runat="server">
                        <td style="padding-left:20;">
                        <%--<a id="A1" runat="server" class="lnk" href="http://lexsrvsqlprod1/Reportserver?%2fGENERAL+REPORTS%2fnonpaylist&rs:Command=Render"><img id="Img4" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Non-Deposit Report</a>--%>
                        <a id="A1" runat="server" class="lnk" href="~/research/reports/financial/accounting/default.aspx?rpt=nopay"><img id="Img4" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Non-Deposit Report</a>
                        </td>
                    </tr>
                    <tr id="trSettlementFeesPaid" runat="server">
                        <td style="padding-left:20;">
                        <%--<a id="A3" runat="server" class="lnk" href="http://lexsrvsqlprod1/Reportserver?%2fReportSvcs%2fSettlement+Fees+Paid&rs:Command=Render"><img id="Img6" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Settlement Fees Paid</a>--%>
                        <a id="A3" runat="server" class="lnk" href="~/research/reports/financial/accounting/default.aspx?rpt=sett"><img id="Img6" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Settlement Fees Paid</a>
                        </td>
                    </tr>
                    <tr id="trBouncedReport" runat="server">
                        <td style="padding-left:20;">
                        <a id="A10" runat="server" class="lnk" href="~/research/reports/financial/accounting/BankReturns/default.aspx"><img id="Img10" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>ACH NOC and Returns</a>
                        </td>
                    </tr>
                    <tr id="tr6" runat="server">
                        <td style="padding-left:20;">
                        <a id="A14" runat="server" class="lnk" href="~/research/reports/financial/IOLTALedger.aspx"><img id="Img17" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>IOLTA Ledger</a>
                        </td>
                    </tr>
                     </tr><tr id="tr4" runat="server">
                        <td style="padding-left:20;">
                        <a id="A12" runat="server" class="lnk" href="~/research/reports/financial/accounting/SettlementProjection.aspx"><img id="Img15" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="absmiddle"/>Settlement Projection</a>
                        </td>
                    </tr>
                </table>              
                <table id="tblMarketing" runat="server" style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Marketing</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a runat="server" class="lnk" href="~/Clients/Enrollment/kpireport.aspx"><img id="Img9" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="middle"/>KPI Report</a></td>
                    </tr>
                </table>     
                <table id="tblMisc" runat="server" style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Miscellaneous</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="A11" runat="server" class="lnk" href="~/Research/Reports/Financial/CompletedClients.aspx"><img id="Img14" style="margin-right:5;" src="~/images/16x16_report.png" runat="server" border="0" align="middle"/>Completed Clients w/balances</a></td>
                    </tr>
                </table>          
            </td>
        </tr>
    </table>
</asp:Content>