<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/reports.master"
    AutoEventWireup="false" CodeFile="owed-to-gca.aspx.vb" Inherits="research_reports_financial_commission_owed_to_gca" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        th
        {
            background-color: #d3d3d3;
            padding: 4 3 3 3;
            border-bottom: solid 1px #b3b3b3;
        }
    </style>
    <table border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;<a
                        id="A3" runat="server" class="lnk" style="color: #666666;" href="~/research/reports/financial">Financial</a>&nbsp;>&nbsp;Commission
            </td>
        </tr>
        <tr>
            <td>
                <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                    border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 100%;">
                            <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                border="0">
                                <tr>
                                    <td style="width: 10;">
                                        &nbsp;
                                    </td>
                                    <td style="white-space:nowrap">
                                        Owed to GCA
                                    </td>
                                    <td style="width: 100%;">
                                        &nbsp;
                                    </td>
                                    <td nowrap="true">
                                        <asp:LinkButton ID="lnkExport" runat="server" class="gridButton">
                                            <img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                src="~/images/icons/xls.png" /></asp:LinkButton>
                                    </td>
                                    <td style="width: 10;">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <asp:GridView ID="gvOwed" runat="server" ShowFooter="true" AutoGenerateColumns="true"
                    DataSourceID="ds_Owed" GridLines="None" HeaderStyle-CssClass="headItem4" Width="900px">
                </asp:GridView>
            </td>
        </tr>
    </table>
    <asp:SqlDataSource ID="ds_Owed" runat="server" SelectCommand="stp_OwedToGCA" SelectCommandType="StoredProcedure"
        ConnectionString="<%$ AppSettings:connectionstring %>"></asp:SqlDataSource>
</asp:Content>
