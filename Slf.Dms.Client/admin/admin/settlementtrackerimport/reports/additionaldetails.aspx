<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="additionaldetails.aspx.vb" Inherits="admin_settlementtrackerimport_reports_additionaldetails" %>

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
          
       
    </script>
    <table runat="server" id="tblBody" style="font-family: Arial; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport/">Settlement
                    Tracker Import</a>&nbsp;>&nbsp;Additional Details
            </td>
        </tr>
        <tr>
            <td>
                <table class="entry">
                    <tr style="vertical-align: top;">
                        <td>
                            <asp:GridView ID="gvTurn" runat="server" AutoGenerateColumns="False" CssClass="entry"
                                DataSourceID="dsTurn" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Average Turn Around</div>">
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                                <Columns>
                                    <asp:BoundField DataField="team" HeaderText="Team" SortExpression="team">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AvgDaysTurnAround" HeaderText="Avg Days Turn Around" SortExpression="AvgDaysTurnAround">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsTurn" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getDaysTurnAround">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                        </td>
                        <td>
                            <asp:GridView ID="gvMonthlySettlements" runat="server" AutoGenerateColumns="False"
                                CssClass="entry" DataSourceID="dsMonthlySettlements" AllowSorting="True" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Daily Generated Totals</div>">
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                                <Columns>
                                    <asp:BoundField DataField="date" HeaderText="Date" SortExpression="Date" DataFormatString="{0:d}">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Day">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDay" runat="server" Text='<%# getReportDate(eval("date"))  %>' />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        <FooterStyle HorizontalAlign="Left" CssClass="footerItem" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="generated" HeaderText="Generated Units" SortExpression="generated">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Paid" HeaderText="Paid" SortExpression="Paid Units">
                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                        <FooterStyle HorizontalAlign="Center" CssClass="footerItem" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsMonthlySettlements" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getDailySettlementCounts">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:LinkButton ID="lnkChangeMonth" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />
</asp:Content>
