<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="admin_settlementtrackerimport_Default"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport">Settlement
                    Tracker Imports</a>
            </td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width: 16;">
                                <img id="Img12" runat="server" border="0" src="~/images/16x16_note3.png" />
                            </td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">
                                            INFORMATION:
                                        </td>
                                        <td class="iboxCloseCell" valign="top" align="right">
                                            <asp:LinkButton runat="server" ID="lnkCloseInformation">
                                                <img id="Img22" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            The links below will assist you in tracking the Settlement Process.
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom: 10; margin-right: 15; float: left; font-family: tahoma;
                    font-size: 11px; " border="0" cellpadding="0" cellspacing="5" class="entry">
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Master Data
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-left: 20;">
                            <a id="A4" runat="server" class="lnk" href="master/Default.aspx">
                                <img id="Img2" style="margin-right: 5;" src="~/images/16x16_table2.png" runat="server"
                                    border="0" align="absmiddle" />View/Edit Master Data</a>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 0 0 5 5; font-size: 13px; border-bottom: solid 1px rgb(200,200,200);
                            font-weight: bold;">
                            Reports
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table class="entry2" cellpadding="0" cellspacing="0" width="50%">
                                <tr>
                                    <td style="padding-left: 20;" valign="top">
                                        <a id="A5" runat="server" class="lnk" href="reports/Default.aspx">
                                            <img id="Img3" style="margin-right: 5;" src="~/images/16x16_piechart.png" runat="server"
                                                border="0" align="absmiddle" />Dashboard</a><br />
                                        <a id="A3" runat="server" class="lnk" href="reports/details.aspx">
                                            <img id="Img1" style="margin-right: 5;" src="~/images/16x16_chart_bar.png" runat="server"
                                                border="0" align="absmiddle" />Details By Creditor Balance Type</a>
                                        <br />
                                         <a id="A9" runat="server" class="lnk" href="reports/detailsbygroup.aspx">
                                            <img id="Img7" style="margin-right: 5;" src="~/images/16x16_chart_bar.png" runat="server"
                                                border="0" align="absmiddle" />Summary By Group</a>
                                        <br />
                                        <a id="A8" runat="server" class="lnk" href="reports/additionaldetails.aspx">
                                            <img id="Img6" style="margin-right: 5;" src="~/images/16x16_chart_bar.png" runat="server"
                                                border="0" align="absmiddle" />Additional Details</a>
                                    </td>
                                    <td valign="top">
                                        
                                        <a id="A7" runat="server" class="lnk" href="reports/taskstatistics.aspx">
                                            <img id="Img5" style="margin-right: 5;" src="~/images/16x16_chart_bar.png" runat="server"
                                                border="0" align="absmiddle" />Task Statistics</a>
                                        <br />
                                        <a id="A12" runat="server" class="lnk" href="reports/creditortrends.aspx">
                                            <img id="Img10" style="margin-right: 5;" src="~/images/16x16_chart_bar.png" runat="server"
                                                border="0" align="absmiddle" />Creditor Trends</a>
                                        <br />
                                        <a id="A13" runat="server" class="lnk" href="reports/rejected.aspx">
                                            <img id="Img11" style="margin-right: 5;" src="~/images/16x16_chart_bar.png" runat="server"
                                                border="0" align="absmiddle" />Rejected Settlements</a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16;">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
