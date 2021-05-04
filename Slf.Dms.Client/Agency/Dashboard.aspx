<%@ Page Title="" Language="VB" MasterPageFile="~/Agency/agency.master" AutoEventWireup="false" CodeFile="Dashboard.aspx.vb" Inherits="Agency_Dashboard" EnableEventValidation="false" %>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.UltraWebChart" TagPrefix="igchart" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.UltraChart.Resources.Appearance" TagPrefix="igchartprop" %>
<%@ Register Src="reports/ReportDateRangeFilter.ascx" TagName="ReportDateRangeFilter" TagPrefix="uc1" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.UltraChart.Data" TagPrefix="igchartdata" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphAgencyBody" runat="Server">
    <igmisc:WebAsyncRefreshPanel ID="WebAsyncRefreshPanel1" runat="server" Height="20px" Width="80px">
        <table>
            <tr>
                <td>
                    <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td class="sideRollupCellHeader">
                                First Payment Summary
                            </td>
                        </tr>
                        <tr>
                            <td class="sideRollupCellBody">
                                <table id="Table2" runat="server" class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                    <tr>
                                        <td>
                                            <igchart:UltraChart ID="ucInitialDrafts" runat="server" BackgroundImageFileName="" BorderColor="Black" BorderWidth="1px" ChartType="LineChart" EmptyChartText="Data Not Available. Please call UltraChart.Data.DataBind() after setting valid Data.DataSource" Version="8.2" Width="745px" DataSourceID="ds_InitialDrafts">
                                                <Tooltips EnableFadingEffect="True" Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False" FormatString="&lt;DATA_VALUE:$###,##0.##&gt;" BackColor="White" BorderThickness="0" Font-Names="Tahoma" Font-Size="8pt" />
                                                <ColorModel AlphaLevel="150" ColorBegin="Pink" ColorEnd="DarkRed" ModelStyle="CustomLinear">
                                                </ColorModel>
                                                <Effects>
                                                    <Effects>
                                                        <igchartprop:GradientEffect />
                                                    </Effects>
                                                </Effects>
                                                <Axis>
                                                    <PE ElementType="None" Fill="Cornsilk" />
                                                    <X Extent="30" LineThickness="1" TickmarkInterval="0" TickmarkIntervalType="Hours" TickmarkStyle="Smart" Visible="True">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="Horizontal" VerticalAlign="Center">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Near" Orientation="VerticalLeftFacing" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </X>
                                                    <Y Extent="46" LineThickness="1" TickmarkInterval="40" TickmarkStyle="Smart" Visible="True">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="&lt;DATA_VALUE:$###,###,##0.##&gt;" Orientation="Horizontal" VerticalAlign="Center">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Far" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Y>
                                                    <Y2 LineThickness="1" TickmarkInterval="40" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="&lt;DATA_VALUE:00.##&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Y2>
                                                    <X2 LineThickness="1" TickmarkInterval="0" TickmarkIntervalType="Hours" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Far" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Far" Orientation="VerticalLeftFacing" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </X2>
                                                    <Z LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Z>
                                                    <Z2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Z2>
                                                </Axis>
                                                <Legend BorderThickness="0" Location="Bottom" SpanPercentage="12" Visible="True"></Legend>
                                            </igchart:UltraChart>
                                            <asp:SqlDataSource ID="ds_InitialDrafts" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>" SelectCommand="stp_AgencyInitialDraftsCommission" SelectCommandType="StoredProcedure" EnableCaching="True" ProviderName="<%$ ConnectionStrings:DMS_RESTOREDConnectionString.ProviderName %>">
                                                <SelectParameters>
                                                    <asp:Parameter Name="startdate" Type="DateTime" />
                                                    <asp:Parameter Name="enddate" Type="DateTime" />
                                                    <asp:Parameter Name="dateperiod" Type="String" />
                                                    <asp:Parameter Name="userid" Type="Int16" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 0 3px 0 3px">
                                            <div id="divInitialDrafts" runat="server" style="width: 745px; height: 93px; overflow: auto; border: solid 1px black; background-color: White">
                                                <asp:GridView ID="gvInitialDrafts" runat="server" BackColor="White" BorderColor="Black" BorderStyle="None" BorderWidth="0" Width="100%" DataSourceID="ds_InitialDrafts" AutoGenerateColumns="false" CellPadding="2">
                                                    <RowStyle CssClass="entry2" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="entry2" HorizontalAlign="Right" />
                                                </asp:GridView>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td rowspan="2" valign="top">
                    <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0" width="300px">
                        <tr>
                            <td class="sideRollupCellHeader">
                                Parameters
                            </td>
                        </tr>
                        <tr>
                            <td class="sideRollupCellBody">
                                <table id="Table3" runat="server" class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                    <tr>
                                        <td>
                                            <uc1:ReportDateRangeFilter ID="DateRangeBox" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Button CssClass="gridButton" ID="btnViewReport" runat="server" Text="View Report" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0" width="300px">
                        <tr>
                            <td class="sideRollupCellHeader">
                                All Other Payment Summary
                            </td>
                        </tr>
                        <tr>
                            <td class="sideRollupCellBody">
                                <table id="Table1" runat="server" class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                    <tr>
                                        <td>
                                            <igchart:UltraChart ID="ucDeposits" runat="server" BackgroundImageFileName="" BorderColor="Black" BorderWidth="1px" ChartType="LineChart" EmptyChartText="Data Not Available. Please call UltraChart.Data.DataBind() after setting valid Data.DataSource" Version="8.2" Width="745px" DataSourceID="ds_NonInitialDrafts">
                                                <Tooltips EnableFadingEffect="True" Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False" FormatString="&lt;DATA_VALUE:$###,##0.##&gt;" BackColor="White" BorderThickness="0" Font-Names="Tahoma" Font-Size="8pt" />
                                                <ColorModel AlphaLevel="150" ColorBegin="Pink" ColorEnd="DarkRed" ModelStyle="CustomLinear">
                                                </ColorModel>
                                                <Effects>
                                                    <Effects>
                                                        <igchartprop:GradientEffect />
                                                    </Effects>
                                                </Effects>
                                                <Axis>
                                                    <PE ElementType="None" Fill="Cornsilk" />
                                                    <X Extent="30" LineThickness="1" TickmarkInterval="0" TickmarkIntervalType="Hours" TickmarkStyle="Smart" Visible="True">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="Horizontal" VerticalAlign="Center">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Near" Orientation="VerticalLeftFacing" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </X>
                                                    <Y Extent="46" LineThickness="1" TickmarkInterval="20" TickmarkStyle="Smart" Visible="True">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="&lt;DATA_VALUE:$###,###,##0.##&gt;" Orientation="Horizontal" VerticalAlign="Center">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Far" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Y>
                                                    <Y2 LineThickness="1" TickmarkInterval="20" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="&lt;DATA_VALUE:00.##&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Y2>
                                                    <X2 LineThickness="1" TickmarkInterval="0" TickmarkIntervalType="Hours" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Far" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Far" Orientation="VerticalLeftFacing" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </X2>
                                                    <Z LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Z>
                                                    <Z2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                                                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </SeriesLabels>
                                                            <Layout Behavior="Auto">
                                                            </Layout>
                                                        </Labels>
                                                    </Z2>
                                                </Axis>
                                                <Legend BorderThickness="0" Location="Bottom" SpanPercentage="12" Visible="True"></Legend>
                                            </igchart:UltraChart>
                                            <asp:SqlDataSource ID="ds_NonInitialDrafts" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>" EnableCaching="True" SelectCommand="stp_AgencyNonInitialDraftsCommission" SelectCommandType="StoredProcedure" ProviderName="<%$ ConnectionStrings:DMS_RESTOREDConnectionString.ProviderName %>">
                                                <SelectParameters>
                                                    <asp:Parameter Name="startdate" Type="DateTime" />
                                                    <asp:Parameter Name="enddate" Type="DateTime" />
                                                    <asp:Parameter Name="dateperiod" Type="String" />
                                                    <asp:Parameter Name="userid" Type="Int16" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 0 3px 0 3px">
                                            <div id="divNonInitialDrafts" runat="server" style="width: 745px; height: 93px; overflow: auto; border: solid 1px black; background-color: White">
                                                <asp:GridView ID="gvNonInitialDrafts" runat="server" BackColor="White" BorderColor="Black" BorderStyle="None" BorderWidth="0" Width="100%" DataSourceID="ds_NonInitialDrafts" AutoGenerateColumns="false" CellPadding="2">
                                                    <RowStyle CssClass="entry2" HorizontalAlign="Right" />
                                                    <HeaderStyle CssClass="entry2" HorizontalAlign="Right" />
                                                </asp:GridView>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td class="sideRollupCellHeader">
                                Client Intake
                            </td>
                        </tr>
                        <tr>
                            <td class="sideRollupCellBody" style="padding: 13px 14px 13px 14px">
                                <div id="divClientIntake" runat="server" style="width: 745px; height: 83px; overflow: auto; border: solid 1px black; background-color: White">
                                    <asp:GridView ID="gvIntake" runat="server" GridLines="None" BackColor="White" BorderColor="Black" BorderStyle="None" BorderWidth="1px" Width="100%" DataSourceID="ds_Intake" AutoGenerateColumns="false" CellPadding="2">
                                        <RowStyle CssClass="entry2" HorizontalAlign="Right" />
                                        <HeaderStyle CssClass="entry2" Height="25px" HorizontalAlign="Right" />
                                    </asp:GridView>
                                </div>
                                <asp:SqlDataSource ID="ds_Intake" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>" SelectCommand="stp_AgencyClientIntake" SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:Parameter Name="startdate" Type="DateTime" />
                                        <asp:Parameter Name="enddate" Type="DateTime" />
                                        <asp:Parameter Name="dateperiod" Type="String" />
                                        <asp:Parameter Name="userid" Type="Int16" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </igmisc:WebAsyncRefreshPanel>
</asp:Content>
