<%@ Page Language="VB" MasterPageFile="~/research/reports/reports.master"
    AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_reports_litigation_default"
    Title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;" colspan="2">
                <a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;Litigation
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
                            Tasks
                        </td>
                    </tr>
                    <tr id="trTasksReport" runat="server">
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/research/reports/litigation/tasks/tasksreport.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_report.png" runat="server" border="0"
                                    align="absmiddle" />Tasks Report</a>
                        </td>
                    </tr>
                    <tr id="trTasksReportNew" runat="server">
                        <td style="padding-left: 20;">
                            <a runat="server" class="lnk" href="~/research/reports/litigation/tasks/default.aspx">
                                <img style="margin-right: 5;" src="~/images/16x16_report.png" runat="server" border="0"
                                    align="absmiddle" />Tasks Report (new)</a>
                        </td>
                    </tr>
                    <tr id="trDocuments" runat="server">
                        <td style="padding-left: 20;">
                            <a id="A2" runat="server" class="lnk" href="~/research/reports/litigation/documents/default.aspx">
                                <img id="Img2" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server" border="0"
                                    align="absmiddle" />Document Report (new)</a>
                        </td>
                    </tr>
                </table>
             </td>
             <td>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; width: 175;" border="0" cellpadding="0" cellspacing="5" id="Table1"
                    runat="server">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            TimeSheet
                        </td>
                    </tr>
                    <tr id="tr1" runat="server">
                        <td style="padding-left: 20;">
                            <a id="A1" runat="server" class="lnk" href="~/research/reports/litigation/timesheet/timesheetreport.aspx">
                                <img id="Img1" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server" border="0"
                                    align="absmiddle" />Matter Expense Entry</a>
                        </td>
                    </tr>
                </table>
             </td>
             
        </tr>
    </table>
</asp:Content>
