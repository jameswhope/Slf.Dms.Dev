<%@ Page Language="VB" MasterPageFile="~/research/reports/reports.master"
    AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_reports_dialer_default"
    Title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;" colspan="2">
                <a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;Dialer
            </td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5" id="tblTasks"
                    runat="server">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Dialer Calls
                        </td>
                    </tr>
                    <tr id="trCallsReport" runat="server">
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/research/reports/dialer/calls/dialercalls.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_report.png" runat="server" border="0"
                                    align="absmiddle" />Calls Report</a>
                        </td>
                    </tr>
                </table>
             </td>
        </tr>
    </table>
</asp:Content>
