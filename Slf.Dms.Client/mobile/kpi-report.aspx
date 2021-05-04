<%@ Page Language="VB" AutoEventWireup="false" CodeFile="kpi-report.aspx.vb" Inherits="mobile_financial_kpi_report"
    EnableViewState="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <link href="css/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <div class="toolbar">
        <h1 id="hTitle" runat="server">
            KPI Report</h1>
        <a href="home.aspx" class="backButton">back</a>
        <h3 id="hOptions" runat="server">
            <asp:Label ID="lblLastMod" runat="server"></asp:Label>
        </h3>
    </div>
    <div>
        <table class="grid3">
            <tr>
                <th style="width: 140px; white-space:nowrap">
                    &nbsp;
                </th>
                <th style="width: 50px; text-align: center">
                    Internet
                </th>
                <th style="width: 50px; text-align: center">
                    Cases
                </th>
                <th style="width: 50px; text-align: right">
                    Per Lead
                </th>
                <th style="width: 60px; text-align: right">
                    Conv
                </th>
                <th style="width: 90px; text-align: right">
                    Spent
                </th>
                <th style="width: 50px; text-align: right">
                    Per Day
                </th>
                <th style="width: 50px; text-align: center">
                    Submitted
                </th>
                <th style="width: 55px; text-align: right; white-space:nowrap">
                    Submitted
                </th>
                <th style="width: 50px; text-align: right">
                    Avg Maint
                </th>
                <th style="width: 65px; text-align: right">
                    Avg Debt
                </th>
                <th style="width: 40px; text-align: center">
                    Goal
                </th>
                <th style="width: 40px; text-align: center">
                    Today
                </th>
                <th style="width: 40px; text-align: center">
                    Pacing
                </th>
            </tr>
        </table>
        <ajaxToolkit:Accordion ID="Accordion1" runat="server" SuppressHeaderPostbacks="false"
            FadeTransitions="true" TransitionDuration="50" FramesPerSecond="100" RequireOpenedPane="false">
            <HeaderTemplate>
                <table class="grid3">
                    <tr>
                        <td style="width: 140px; white-space:nowrap">
                            <img src="images/16x16_plus.png" align="absmiddle" style="margin-right:5px" /><%#Eval("startend")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("internet leads")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("Num Cases Against Marketing Dollars")%>
                        </td>
                        <td style="width: 50px; text-align: right">
                            <%#Eval("Cost Per Lead", "{0:C2}")%>
                        </td>
                        <td style="width: 60px; text-align: right">
                            <%#Eval("Conversion Pct", "{0:P2}")%>
                        </td>
                        <td style="width: 90px; text-align: right">
                            <%#Eval("Marketing Budget Spent", "{0:C2}")%>
                        </td>
                        <td style="width: 50px; text-align: right">
                            <%#Eval("Cost Per Conversion Day", "{0:C2}")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("Submitted Cases")%>
                        </td>
                        <td style="width: 55px; text-align: right; white-space:nowrap">
                            <%#Eval("Submitted Cases Pct", "{0:P2}")%>
                        </td>
                        <td style="width: 50px; text-align: right">
                            <%#Eval("Avg Maint Fee", "{0:C2}")%>
                        </td>
                        <td style="width: 65px; text-align: right">
                            <%#Eval("Avg Total Debt", "{0:C2}")%>
                        </td>
                        <td style="width: 40px; text-align: center">
                            <%#Eval("Goal")%>
                        </td>
                        <td style="width: 40px; text-align: center">
                            <%#Eval("Today")%>
                        </td>
                        <td style="width: 40px; text-align: center">
                            <%#Eval("Pacing")%>
                        </td>
                    </tr>
                </table>
            </HeaderTemplate>
            <ContentTemplate>
                <ajaxToolkit:Accordion ID="accByDay" runat="server" SuppressHeaderPostbacks="false"
                    DataSource='<%# Container.DataItem.CreateChildView("Relation1") %>' FadeTransitions="true"
                    TransitionDuration="50" FramesPerSecond="100" RequireOpenedPane="false" SelectedIndex="-1" OnItemDataBound="accByDay_ItemDataBound">
                    <HeaderTemplate>
                        <table class="grid2">
                            <tr>
                                <td style="width: 130px; padding-left: 20px; white-space:nowrap">
                                    <img id="imgPlus" runat="server" src="images/16x16_plus.png" align="absmiddle" alt="" style="margin-right:5px" /><%#Eval("ConnectDate")%>
                                    <asp:HiddenField ID="hdnConnectDate" runat="server" Value='<%#Bind("ConnectDate") %>' />
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("TotalInternet")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("NumCasesAgainstMarketingDollars")%>
                                </td>
                                <td style="width: 50px; text-align: right">
                                    <%#Eval("CostPerLead", "{0:C2}")%>
                                </td>
                                <td style="width: 60px; text-align: right; white-space:nowrap">
                                    <%#Eval("ConversionPercent", "{0:P2}")%>
                                </td>
                                <td style="width: 90px; text-align: right">
                                    <%#Eval("MarketingBudgetSpentPerDay", "{0:C2}")%>
                                </td>
                                <td style="width: 50px; text-align: right">
                                    <%#Eval("CostPerConversionDay", "{0:C2}")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("TotalNumCases")%>
                                </td>
                                <td style="width: 55px; text-align: right">
                                    <%#Eval("PctOfTotal", "{0:P2}")%>
                                </td>
                                <td style="width: 50px; text-align: right">
                                    <%#Eval("AvgMaintFee", "{0:C2}")%>
                                </td>
                                <td style="width: 65px; text-align: right">
                                    <%#Eval("AvgTotalDebt", "{0:C2}")%>
                                </td>
                                <td style="width: 40px">
                                    &nbsp;
                                </td>
                                <td style="width: 40px">
                                    &nbsp;
                                </td>
                                <td style="width: 40px">
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                    </HeaderTemplate>
                    <ContentTemplate>
                        <table class="grid2">
                            <asp:Repeater ID="rptByDay" runat="server" DataSource='<%# Container.DataItem.CreateChildView("Relation3") %>'>
                                <ItemTemplate>
                                    <tr>
                                        <th style="width: 110px; padding-left: 40px; text-align: left">
                                            <%#Eval("ConnectDate")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("TotalInternet")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("NumCasesAgainstMarketingDollars")%>
                                        </th>
                                        <th style="width: 50px; text-align: right">
                                            <%#Eval("CostPerLead", "{0:C2}")%>
                                        </th>
                                        <th style="width: 60px; text-align: right">
                                            <%#Eval("ConversionPercent", "{0:P2}")%>
                                        </th>
                                        <th style="width: 90px; text-align: right">
                                            <%#Eval("MarketingBudgetSpentPerDay", "{0:C2}")%>
                                        </th>
                                        <th style="width: 50px; text-align: right">
                                            <%#Eval("CostPerConversionDay", "{0:C2}")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("TotalNumCases")%>
                                        </th>
                                        <th style="width: 55px; text-align: right">
                                            <%#Eval("PctOfTotal", "{0:P2}")%>
                                        </th>
                                        <th style="width: 50px; text-align: right">
                                            <%#Eval("AvgMaintFee", "{0:C2}")%>
                                        </th>
                                        <th style="width: 65px; text-align: right">
                                            <%#Eval("AvgTotalDebt", "{0:C2}")%>
                                        </th>
                                        <th style="width: 40px">
                                            &nbsp;
                                        </th>
                                        <th style="width: 40px">
                                            &nbsp;
                                        </th>
                                        <th style="width: 40px">
                                            &nbsp;
                                        </th>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:Accordion>
                </table>
            </ContentTemplate>
        </ajaxToolkit:Accordion>
    </div>
    </form>
</body>
</html>
