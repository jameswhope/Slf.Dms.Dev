<%@ Page Language="VB" MasterPageFile="~/negotiation/Negotiation.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="negotiation_clients_Default" EnableEventValidation="false" %>
<%@ MasterType TypeName="negotiation_Negotiation" %>

<%@ Register Src="../webparts/ContactsControl.ascx" TagName="ContactsControl" TagPrefix="LexxWebPart" %>
<%@ Register Src="../webparts/SettlmentInformation.ascx" TagName="SettlementInformation"
    TagPrefix="LexxWebPart" %>
<%@ Register Src="~/negotiation/webparts/CalculatorControl.ascx" TagName="SettlementCalculatorControl"
    TagPrefix="LexxWebPart" %>
<%@ Register Src="~/negotiation/webparts/HistoryControl.ascx" TagName="SettlementHistoryControl"
    TagPrefix="LexxWebPart" %>
<%@ Register Src="~/negotiation/webparts/ClientInfoControl.ascx" TagName="ClientInfoControl"
    TagPrefix="LexxWebPart" %>
<%@ Register Src="~/negotiation/webparts/CreditorInfoControl.ascx" TagName="SettlementCreditorInfoControl"
    TagPrefix="LexxWebPart" %>
<%@ Register Src="~/negotiation/webparts/AvailableNegotiationsControl.ascx" TagName="AvailableNegotiations"
    TagPrefix="LexxWebPart" %>
<%@ Register Src="~/negotiation/webparts/ClientDocuments.ascx" TagName="ClientDocuments"
    TagPrefix="LexxWebPart" %>
<%@ Register src="~/negotiation/webparts/ReportsControl.ascx" TagName="ReportsControl" TagPrefix="LexxWebPart" %>
<%@ Register src="~/CustomTools/UserControls/PaymentArrangementCalc.ascx" tagname="PaymentArrangementCalc" tagprefix="uc2" %>    

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    
    <table style="width: 100%;">
        <tbody>
            <tr>
                <td style="vertical-align: top; width: 300px"> 
                    <div class="ibox nego">
                        <h1>
                            Account Info
                        </h1>
                        <div>
                            <LexxWebPart:SettlementCreditorInfoControl ID="SettlementCreditorInfoControl1" runat="server" title="Creditor Information" />
                        </div>
                    </div>
                    <div class="ibox nego">
                        <h1>
                            Client Info
                        </h1>
                        <div>
                            <LexxWebPart:ClientInfoControl ID="SettlementClientInfoControl1" runat="server" title="Client Information" />
                        </div>
                    </div>
                </td>
                <td style="vertical-align: top;">
                    <div class="ibox nego" style="width: 400px; overflow: visible;">
                        <h1>
                            Settlement Calculator
                            <a href="javascript:void();" onclick="return getSDASpan();" style="float:right;display:inline-block;margin:-14px 3px 0 0;font-size:10px;text-decoration:underline;">24-month span</a>
                        </h1>
                        <div>
                            <LexxWebPart:SettlementCalculatorControl ID="SettlementCalculatorControl1" runat="server" title="Settlement Calculator" />
                        </div>
                    </div>
                    <div class="ibox nego" style="width: 400px; overflow: visible;">
                        <h1>
                            Payment Plan Calculator
                        </h1>
                        <div>
                           <uc2:PaymentArrangementCalc ID="PaymentArrangementCalculator" runat="server"  /> 
                        </div>
                    </div>
                </td>
                 <td  style="vertical-align: top; width: 100%">
                    <div class="ibox nego">
                        <h1>
                            Settlement Information
                        </h1> 
                        <div>
                            <LexxWebPart:SettlementInformation ID="SessionNotesControl1" runat="server" title="Settlement Information" />
                        </div>
                    </div>
                    <div class="ibox nego">
                         <h1 id="hMyAssignments" runat="server">
                            My Assignments
                         </h1>
                        <div style="padding: 5px">
                            <ajaxToolkit:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Width="100%"
                                CssClass="tabContainer">
                                <ajaxToolkit:TabPanel runat="server" HeaderText="My Assignments" ID="tpAvailableNegotiations">
                                    <ContentTemplate>
                                        <LexxWebPart:AvailableNegotiations ID="AvailableNegotiations" runat="server" title="My Assignments"
                                            ListLocation="ClientPage" />
                                    </ContentTemplate>
                                </ajaxToolkit:TabPanel>
                                <ajaxToolkit:TabPanel ID="tpReportsControl" runat="server" HeaderText="Reports">
                                    <ContentTemplate>
                                        <LexxWebPart:ReportsControl ID="ReportsControl1" runat="server" />
                                    </ContentTemplate>
                                </ajaxToolkit:TabPanel>
                            </ajaxToolkit:TabContainer>
                        </div>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>

    <div id="dialog-monthly-span" title="24 - Month Span Of Available Funds" style="min-height:750px;" >
        <div>
            <div id="divLoading" style="float:left;"></div> 
        </div>
        <div style="clear:both; padding-bottom:3px"/>
        <div id="divGrid" style="min-height:750px;">
        </div>
    </div>   
  
</asp:Content>
