<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="creditortrends.aspx.vb" Inherits="admin_settlementtrackerimport_reports_creditortrends" %>

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
    function TrendChanged(TrendSelect) {
        var chosenoption = TrendSelect.options[TrendSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnTrend.ClientID %>");
            hdn.value = chosenoption.value;
            if (hdn.value != 'by team'){
                <%= ClientScript.GetPostBackEventReference(lnkChangeTrend, nothing) %>;
            }else{
                var fldTeam =document.getElementById('fldTeam');
                fldTeam.style.display = 'block';
                
            }
        }
    }
       function TeamChanged(TeamSelect) {
        var chosenoption = TeamSelect.options[TeamSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnTeam.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeTeam, nothing) %>;
        }
    }
</script>
    <table runat="server" id="tblBody" style="font-family: Arial; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport/">Settlement
                    Tracker Import</a>&nbsp;>&nbsp;Creditor Trends
            </td>
        </tr>
        <tr>
            <td>
                
                <asp:GridView ID="gvCreditorTrends" runat="server" CssClass="entry" DataSourceID="dsCreditorTrends"
                    AutoGenerateColumns="False">
                    <EmptyDataTemplate>
                        No trends.
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="dsCreditorTrends" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getCreditorTrendsByYearAndMonth">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                        <asp:Parameter DefaultValue="" Name="top" Type="String" ConvertEmptyStringToNull="true" />
                        <asp:Parameter DefaultValue="" Name="team" Type="String" ConvertEmptyStringToNull="true" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
    <asp:SqlDataSource ID="dsTeams" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                    ProviderName="System.Data.SqlClient" SelectCommand="Select distinct team from tblsettlementtrackerimports where team <> '' and year(date) = @year and month(date) = @month">
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="-1" Name="year" Type="Int32" />
                                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:HiddenField ID="hdnTrend" runat="server" />
    <asp:HiddenField ID="hdnTeam" runat="server" />
    <asp:LinkButton ID="lnkChangeMonth" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />
    <asp:LinkButton ID="lnkChangeTrend" runat="server" />
    <asp:LinkButton ID="lnkChangeTeam" runat="server" />
</asp:Content>
