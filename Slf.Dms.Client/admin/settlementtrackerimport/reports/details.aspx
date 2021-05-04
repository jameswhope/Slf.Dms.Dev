<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="details.aspx.vb" Inherits="admin_settlementtrackerimport_reports_details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript">
   function MonthChanged(monthSelect) {
        var chosenoption = monthSelect.options[monthSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnMonth.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeMonth, nothing) %>;
        }

    }
    function YearChanged(YearSelect) {
        var chosenoption = YearSelect.options[YearSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnYear.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeYear, nothing) %>;
        }
       }
 function DetailChanged(DetailSelect) {
        var chosenoption = DetailSelect.options[DetailSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnDetail.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeDetail, nothing) %>;
        }
       }       
    </script>

    <table runat="server" id="tblBody" style="font-family: Arial; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport/">Settlement
                    Tracker Import</a>&nbsp;>&nbsp;<asp:Label ID="lblDetailType" runat="server" Text="Details" />
            </td>
        </tr>
        <tr>
            <td>
                <table class="entry" id="tblCurrent" runat="server">
                    <tr valign="top">
                        <td style="width: 55%;">
                            <br />
                            <asp:GridView ID="gvPending" runat="server" DataSourceID="dsPendingFees" CssClass="entry"
                                AllowSorting="True" AutoGenerateColumns="False" GridLines="None" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Pending</div>"
                                ShowFooter="true">
                                <Columns>
                                    <asp:BoundField DataField="Pending" HeaderText="Pending" SortExpression="Pending"
                                        HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="150px" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="True" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Fees" HeaderText="Fees" ReadOnly="True" SortExpression="Fees"
                                        DataFormatString="{0:c}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Units" HeaderText="Units" ReadOnly="True" SortExpression="Units"
                                        HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                                <FooterStyle BackColor="Bisque" />
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsPendingFees" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getPending">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:GridView ID="gvPaid" runat="server" DataSourceID="dsPaid" CssClass="entry" AllowSorting="True"
                                AutoGenerateColumns="False" GridLines="None" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Paid</div>">
                                <Columns>
                                    <asp:BoundField DataField="Paid" HeaderText="Paid" SortExpression="Paid" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="150px" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="True" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Fees" HeaderText="Fees" ReadOnly="True" SortExpression="Fees"
                                        DataFormatString="{0:c}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Units" HeaderText="Units" ReadOnly="True" SortExpression="Units"
                                        HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PctPaid" HeaderText="% Paid" ReadOnly="True" SortExpression="PctPaid"
                                        DataFormatString="{0:p2}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AvgSettlementFeeAmt" HeaderText="Avg Settlement Fee $"
                                        ReadOnly="True" SortExpression="AvgSettlementFeeAmt" DataFormatString="{0:c}"
                                        HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AvgSettlementPct" HeaderText="Avg Settlement %" ReadOnly="True"
                                        SortExpression="AvgSettlementPct" DataFormatString="{0:p2}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsPaid" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getPaid">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:GridView ID="gvTotals" runat="server" DataSourceID="dsTotals" CssClass="entry"
                                AllowSorting="True" AutoGenerateColumns="False" GridLines="None" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Total Amts</div>">
                                <Columns>
                                    <asp:BoundField DataField="Paid" HeaderText="Total" SortExpression="Paid" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="150px" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="True" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Fees" HeaderText="Fees" ReadOnly="True" SortExpression="Fees"
                                        DataFormatString="{0:c}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Units" HeaderText="Units" ReadOnly="True" SortExpression="Units"
                                        HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Balance" HeaderText="Balance" ReadOnly="True" SortExpression="Balance"
                                        DataFormatString="{0:c}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementAmt" HeaderText="Settlement $" ReadOnly="True"
                                        SortExpression="SettlementAmt" DataFormatString="{0:c}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AvgSettlementPct" HeaderText="Avg Settlement %" ReadOnly="True"
                                        SortExpression="AvgSettlementPct" DataFormatString="{0:p2}" HtmlEncode="False">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsTotals" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getTotals">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:GridView ID="gvFirmPaidLost" runat="server" DataSourceID="dsFirmPaidLost" CssClass="entry"
                                AllowSorting="True" AutoGenerateColumns="False" GridLines="None" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Firm Paid - Lost</div>">
                                <Columns>
                                    <asp:BoundField DataField="LawFirm" HeaderText="Law Firm" SortExpression="LawFirm">
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                        <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PaidUnits" HeaderText="Paid Units" SortExpression="PaidUnits">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PaidFeesLost" HeaderText="Paid Fees Lost" SortExpression="PaidFeesLost"
                                        DataFormatString="{0:c2}">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="totalunits" HeaderText="Total Units" SortExpression="totalunits">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="totalpotentiallost" HeaderText="Total Potential Lost"
                                        SortExpression="totalpotentiallost" DataFormatString="{0:c2}">
                                        <FooterStyle HorizontalAlign="Right" CssClass="footerItem" />
                                        <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                    </asp:BoundField>
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsFirmPaidLost" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getFirmPaidLost">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:GridView ID="gvFirmPaidCancelled" runat="server" DataSourceID="dsFirmPaidCancelled"
                                CssClass="entry" AllowSorting="True" AutoGenerateColumns="False" GridLines="None"
                                Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Firm Paid - Cancelled</div>">
                                <Columns>
                                    <asp:BoundField DataField="LawFirm" HeaderText="Law Firm" SortExpression="LawFirm">
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Paid" HeaderText="Paid" SortExpression="Paid">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PctPaid" HeaderText="% Paid" SortExpression="PctPaid"
                                        DataFormatString="{0:p2}">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Cancelled" HeaderText="Cancelled" SortExpression="Cancelled">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PctCancelled" HeaderText="% Cancelled" SortExpression="PctCancelled"
                                        DataFormatString="{0:n2}">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsFirmPaidCancelled" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getFirmPaidCancelled">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                        </td>
                        <td align="center" >
                            <br />
                            <table class="entry" border="0" cellpadding="0" cellspacing="0" id="tdExpired" runat="server">
                                <tr style="background-color: #3376AB; color: White">
                                    <td colspan="3" style="text-align: center">
                                        Expired
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; border-right: solid 1px black;">
                                        <asp:Label ID="lblExpiredAmt" runat="server" Text="0.00" />
                                    </td>
                                    <td style="text-align: center">
                                        <asp:Label ID="lblExpiredCnt" runat="server" Text="0" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr style="background-color: #3376AB; color: White">
                                    <td colspan="2" style="text-align: center">
                                        <asp:Label ID="lblCancelMonth" runat="server" Text="Month Cancelled" />
                                    </td>
                                    <td style="text-align: center">
                                        %
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; border-right: solid 1px black;">
                                        <asp:Label ID="lblMonthCancelledAmt" runat="server" Text="0.00" />
                                    </td>
                                    <td style="text-align: center; border-right: solid 1px black;">
                                        <asp:Label ID="lblMonthCancelledCnt" runat="server" Text="0" />
                                    </td>
                                    <td style="text-align: center">
                                        <asp:Label ID="lblMonthCancelledPct" runat="server" Text="0.00" />
                                    </td>
                                </tr>
                                <tr style="background-color: #3376AB; color: White">
                                    <td colspan="3" style="text-align: center">
                                        <asp:Label ID="Label1" runat="server" Text="Total Submissions" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; border-right: solid 1px black;">
                                        <asp:Label ID="lblTotSubAmt" runat="server" Text="0.00" />
                                    </td>
                                    <td style="text-align: center">
                                        <asp:Label ID="lblTotSubCnt" runat="server" Text="0" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <asp:GridView ID="gvTeamExpired" runat="server" AutoGenerateColumns="False" CssClass="entry"
                                DataSourceID="dsTeamExpired">
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                                <Columns>
                                    <asp:BoundField DataField="Team" HeaderText="Team" SortExpression="Team">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Expired" HeaderText="Expired" SortExpression="Expired">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Cancelled" HeaderText="Cancelled" SortExpression="Cancelled">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsTeamExpired" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getExpiredCancelledByTeam">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:GridView ID="gvFirmSubmitted" runat="server" AutoGenerateColumns="False" CssClass="entry"
                                DataSourceID="dsFirmSubmitted">
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                                <Columns>
                                    <asp:BoundField DataField="Firm" HeaderText="Law Firm" SortExpression="Firm">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Submitted" HeaderText="Total Submitted" SortExpression="Submitted">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SubmittedPct" HeaderText="% of Total" DataFormatString="{0:p2}"
                                        SortExpression="SubmittedPct">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsFirmSubmitted" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getTotalsByFirm">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
                <asp:SqlDataSource ID="dsPendingFees_orig" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getPending">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                        <asp:Parameter DefaultValue="1" Name="UseOriginalBalance " />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="dsPaid_Orig" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getPaid">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                        <asp:Parameter DefaultValue="1" Name="UseOriginalBalance " />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="dsTotals_orig" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getTotals">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                        <asp:Parameter DefaultValue="1" Name="UseOriginalBalance " />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="dsFirmPaidLost_orig" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getFirmPaidLost">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                        <asp:Parameter DefaultValue="1" Name="UseOriginalBalance " />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="dsFirmPaidCancelled_orig" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getFirmPaidCancelled">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:HiddenField ID="hdnDetail" runat="server" />
    <asp:LinkButton ID="lnkChangeMonth" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />
    <asp:LinkButton ID="lnkChangeDetail" runat="server" />
</asp:Content>
