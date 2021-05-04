<%@ Page Title="" Language="VB" MasterPageFile="~/Agency/agency.master" AutoEventWireup="false" CodeFile="comparison.aspx.vb" Inherits="Agency_dailycomparison" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.UltraWebChart" TagPrefix="igchart" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.UltraChart.Resources.Appearance" TagPrefix="igchartprop" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.UltraChart.Data" TagPrefix="igchartdata" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.UltraWebChart" TagPrefix="igchart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphAgencyBody" runat="Server">
    <asp:UpdateProgress ID="uppDay" runat="server" AssociatedUpdatePanelID="updDaily">
        <ProgressTemplate>
            Refreshing Chart...
            <asp:Image ID="imgWaiting" runat="server" ImageUrl="~/images/loading.gif" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="updDaily" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td class="sideRollupCellHeader">
                                    Select Time Frame Parameter:
                                </td>
                            </tr>
                            <tr>
                                <td class="sideRollupCellBody">
                                    <table id="Table2" runat="server" class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="ddlFrame" runat="server" AutoPostBack="true">
                                                </asp:DropDownList>
                                                <div style="display: none;">
                                                    <asp:TextBox ID="txtStartDay" runat="server" />
                                                    <ajaxToolkit:CalendarExtender ID="ceStart" runat="server" TargetControlID="txtStartDay" />
                                                    <asp:TextBox ID="txtEndDay" runat="server" />
                                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEndDay" />
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
                        <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td class="sideRollupCellHeader">
                                    First Payments
                                </td>
                            </tr>
                            <tr>
                                <td class="sideRollupCellBody">
                                    <table id="Table1" runat="server" class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                        <tr>
                                            <td>
                                                <igchart:UltraChart ID="UltraChart1" runat="server" BackgroundImageFileName="" BorderColor="Black" BorderWidth="1px" EmptyChartText="Data Not Available." Version="8.2" DataSourceID="ds_InitialDraftsCompare" Width="745px" >
                                                    <Tooltips Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False" FormatString="$&lt;DATA_VALUE:###,###,##0.00&gt;" />
                                                    <Data ZeroAligned="True"></Data><ColorModel AlphaLevel="150" ColorBegin="Pink" ColorEnd="DarkRed" ModelStyle="CustomLinear" Scaling="none">
                                                    </ColorModel>
                                                    <Effects>
                                                        <Effects>
                                                            <igchartprop:GradientEffect />
                                                        </Effects>
                                                    </Effects>
                                                    <Axis>
                                                        <PE ElementType="None" Fill="Cornsilk" />
                                                        <X LineThickness="1" TickmarkInterval="0" TickmarkIntervalType="Hours" TickmarkStyle="Smart" Visible="True" Extent="40">
                                                            <Margin>
                                                                <Far Value="7.1428571428571423" />
                                                                <Near Value="3.0769230769230771" />
                                                            </Margin>
                                                            <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                            <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="false" />
                                                            <Labels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Near">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center">
                                                                    <Layout Behavior="Auto">
                                                                    </Layout>
                                                                </SeriesLabels>
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </Labels>
                                                        </X>
                                                        <Y LineThickness="1" TickmarkInterval="50" TickmarkStyle="Smart" Visible="True" Extent="54">
                                                            <Margin>
                                                                <Far Value="8.695652173913043" />
                                                                <Near Value="1.9417475728155338" />
                                                            </Margin>
                                                            <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                            <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="false" />
                                                            <Labels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="$&lt;DATA_VALUE:###,###,##0.00&gt;" Orientation="Horizontal" VerticalAlign="Center">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Far" Orientation="VerticalLeftFacing" VerticalAlign="Center">
                                                                    <Layout Behavior="Auto">
                                                                    </Layout>
                                                                </SeriesLabels>
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </Labels>
                                                        </Y>
                                                        <Y2 LineThickness="1" TickmarkInterval="50" TickmarkStyle="Smart" Visible="False">
                                                            <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                            <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                            <Labels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="&lt;DATA_VALUE:00.##&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Near" Orientation="VerticalLeftFacing" VerticalAlign="Center">
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
                                                            <Labels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Far" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center">
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
                                                            <Labels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
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
                                                            <Labels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                    <Layout Behavior="Auto">
                                                                    </Layout>
                                                                </SeriesLabels>
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </Labels>
                                                        </Z2>
                                                    </Axis>
                                                    
                                                    <Legend Location="Bottom" BorderThickness="0" SpanPercentage="15" Visible="True"></Legend>
                                                </igchart:UltraChart>
                                                <asp:SqlDataSource ID="ds_InitialDraftsCompare" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>" SelectCommand="stp_AgencyIncomeComparison_InitialDrafts" SelectCommandType="StoredProcedure">
                                                    <SelectParameters>
                                                        <asp:Parameter Name="UserID" Type="Int32" />
                                                        <asp:Parameter Name="startday" Type="String" />
                                                        <asp:Parameter Name="endday" Type="String" />
                                                        <asp:QueryStringParameter Name="companyid" QueryStringField="c" Type="Int16" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                <tr>
                    <td>
                        <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td class="sideRollupCellHeader">
                                    Other Payments
                                </td>
                            </tr>
                            <tr>
                                <td class="sideRollupCellBody">
                                    <table id="Table3" runat="server" class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                        <tr>
                                            <td>
                                                <igchart:UltraChart ID="UltraChart2" runat="server" BackgroundImageFileName="" BorderColor="Black" BorderWidth="1px" EmptyChartText="Data Not Available." Version="8.2" DataSourceID="ds_NonInitialDraftsCompare" Width="745px" >
                                                    <Tooltips Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False" FormatString="$&lt;DATA_VALUE:###,###,##0.00&gt;" />
                                                    <Data ZeroAligned="True"></Data><ColorModel AlphaLevel="150" ColorBegin="Pink" ColorEnd="DarkRed" ModelStyle="CustomLinear" Scaling="none">
                                                    </ColorModel>
                                                    <Effects>
                                                        <Effects>
                                                            <igchartprop:GradientEffect />
                                                        </Effects>
                                                    </Effects>
                                                    <Axis>
                                                        <PE ElementType="None" Fill="Cornsilk" />
                                                        <X LineThickness="1" TickmarkInterval="0" TickmarkIntervalType="Hours" TickmarkStyle="Smart" Visible="True" Extent="40">
                                                            <Margin>
                                                                <Far Value="7.1428571428571423" />
                                                                <Near Value="3.0769230769230771" />
                                                            </Margin>
                                                            <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                            <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="false" />
                                                            <Labels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Near">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center">
                                                                    <Layout Behavior="Auto">
                                                                    </Layout>
                                                                </SeriesLabels>
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </Labels>
                                                        </X>
                                                        <Y LineThickness="1" TickmarkInterval="50" TickmarkStyle="Smart" Visible="True" Extent="54">
                                                            <Margin>
                                                                <Far Value="8.695652173913043" />
                                                                <Near Value="1.9417475728155338" />
                                                            </Margin>
                                                            <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                            <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="false" />
                                                            <Labels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="$&lt;DATA_VALUE:###,###,##0.00&gt;" Orientation="Horizontal" VerticalAlign="Center">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Far" Orientation="VerticalLeftFacing" VerticalAlign="Center">
                                                                    <Layout Behavior="Auto">
                                                                    </Layout>
                                                                </SeriesLabels>
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </Labels>
                                                        </Y>
                                                        <Y2 LineThickness="1" TickmarkInterval="50" TickmarkStyle="Smart" Visible="False">
                                                            <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1" Visible="True" />
                                                            <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1" Visible="False" />
                                                            <Labels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="&lt;DATA_VALUE:00.##&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Near" Orientation="VerticalLeftFacing" VerticalAlign="Center">
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
                                                            <Labels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Far" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="VerticalLeftFacing" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Center" Orientation="Horizontal" VerticalAlign="Center">
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
                                                            <Labels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="DimGray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
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
                                                            <Labels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="" Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                                                                <SeriesLabels Font="tahoma, 7pt" FontColor="Gray" HorizontalAlign="Near" Orientation="Horizontal" VerticalAlign="Center">
                                                                    <Layout Behavior="Auto">
                                                                    </Layout>
                                                                </SeriesLabels>
                                                                <Layout Behavior="Auto">
                                                                </Layout>
                                                            </Labels>
                                                        </Z2>
                                                    </Axis>
                                                    
                                                    <Legend Location="Bottom" BorderThickness="0" SpanPercentage="15" Visible="True"></Legend>
                                                </igchart:UltraChart>
                                                <asp:SqlDataSource ID="ds_NonInitialDraftsCompare" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>" SelectCommand="stp_AgencyIncomeComparison_NonInitialDrafts" SelectCommandType="StoredProcedure">
                                                    <SelectParameters>
                                                        <asp:Parameter Name="UserID" Type="Int32" />
                                                        <asp:Parameter Name="startday" Type="String" />
                                                        <asp:Parameter Name="endday" Type="String" />
                                                        <asp:QueryStringParameter Name="companyid" QueryStringField="c" Type="Int16" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
