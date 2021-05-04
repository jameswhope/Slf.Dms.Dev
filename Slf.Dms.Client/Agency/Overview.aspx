<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Overview.aspx.vb" Inherits="Agency_Overview" AsyncTimeout="500" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGauge.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGauge" TagPrefix="igGauge" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGauge.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.UltraGauge.Resources" TagPrefix="igGaugeProp" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebChart" TagPrefix="igchart" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.UltraChart.Resources.Appearance" TagPrefix="igchartprop" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.UltraChart.Data" TagPrefix="igchartdata" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .IncomeGrid
        {
            font-family: Tahoma;
            font-size: 11px;
        }
        .IncomeGridHeaderStyle th
        {
            border-bottom: solid 2px black;
            padding: 4px;
        }
        .IncomeGridRowStyle td
        {
            border-bottom: dotted 1px black;
            padding: 4px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width:750px;">
    <div style="float: left; width:550px;">
        <div>
            <igchart:UltraChart ID="UltraChart2" runat="server" BorderColor="#868686" Width="550px"
                BorderWidth="1px" EmptyChartText="Data Not Available. Please call UltraChart.Data.DataBind() after setting valid Data.DataSource"
                Version="8.2" BackColor="" DataSourceID="ds_NetIncome" BackgroundImageFileName="">
                <TitleTop Font="Tahoma, 12pt, style=Bold" HorizontalAlign="Center" Text="Net Income">
                </TitleTop>
                <Tooltips EnableFadingEffect="True" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                    Font-Strikeout="False" Font-Underline="False" FormatString="&lt;DATA_VALUE:$###,##0.##&gt;"
                    BackColor="White" BorderThickness="0" Font-Names="Tahoma" Font-Size="8pt" />
                <Border Color="134, 134, 134" CornerRadius="10" />
                <ColorModel AlphaLevel="255" ColorBegin="79, 129, 189" ModelStyle="Office2007Style">
                    <Skin ApplyRowWise="False">
                        <PEs>
                            <igchartprop:PaintElement Fill="79, 129, 189" FillGradientStyle="Vertical" FillStopColor="29, 82, 145"
                                Stroke="79, 129, 189" />
                        </PEs>
                    </Skin>
                </ColorModel>
                <Effects>
                    <Effects>
                        <igchartprop:GradientEffect />
                    </Effects>
                </Effects>
                <Axis>
                    <PE ElementType="None" Fill="Cornsilk" />
                    <X Extent="20" LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="True"
                        LineColor="134, 134, 134" TickmarkIntervalType="Hours">
                        <Margin>
                            <Near Value="2.7237354085603114" />
                            <Far Value="3.4965034965034967" />
                        </Margin>
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Tahoma, 8pt" FontColor="89, 89, 89" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;"
                            Orientation="Horizontal" VerticalAlign="Center">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" Orientation="Horizontal"
                                VerticalAlign="Center" Visible="False">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </X>
                    <Y Extent="64" LineThickness="1" TickmarkInterval="50" TickmarkStyle="Smart" Visible="True"
                        LineColor="134, 134, 134" TickmarkIntervalType="Ticks" TickmarkPercentage="25">
                        <Margin>
                            <Near Value="2.4390243902439024" />
                        </Margin>
                        <MajorGridLines AlphaLevel="255" Color="134, 134, 134" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Tahoma, 8pt" FontColor="89, 89, 89" HorizontalAlign="Far" ItemFormatString="$&lt;DATA_VALUE:###,##0.##&gt;"
                            Orientation="Horizontal" VerticalAlign="Center">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Far"
                                Orientation="Horizontal" VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Y>
                    <Y2 LineThickness="1" TickmarkInterval="50" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="&lt;DATA_VALUE:00.##&gt;"
                            Orientation="Horizontal" VerticalAlign="Center">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Near"
                                Orientation="Horizontal" VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Y2>
                    <X2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False"
                        TickmarkIntervalType="Hours">
                        <Margin>
                            <Far Value="11.111111111111111" />
                        </Margin>
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;"
                            Orientation="VerticalLeftFacing" VerticalAlign="Center">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" Orientation="Horizontal"
                                VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </X2>
                    <Z LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString=""
                            Orientation="Horizontal" VerticalAlign="Center">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" Orientation="Horizontal"
                                VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Z>
                    <Z2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString=""
                            Orientation="Horizontal" VerticalAlign="Center">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" Orientation="Horizontal"
                                VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Z2>
                </Axis>
                <ColumnChart ColumnSpacing="2" SeriesSpacing="5">
                </ColumnChart>
                <Legend BackgroundColor="Transparent" BorderThickness="0" Font="Calibri, 9.75pt, style=Bold"
                    FontColor="89, 89, 89"></Legend>
            </igchart:UltraChart>
            <asp:SqlDataSource ID="ds_NetIncome" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
                SelectCommand="stp_Agency_DashBoard_NetIncomeChartData" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="userid" QueryStringField="id" Type="Int16" />
                    <asp:QueryStringParameter Name="companyid" QueryStringField="c" Type="Int16" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <div>
            <asp:Label ID="lblNotes" runat="server" Text="" Font-Bold="true" Font-Italic="true" ForeColor="Red" Font-Names="Tahoma" Font-Size="11px" />
            <asp:GridView ID="gvNetIncome" runat="server" DataSourceID="ds_IncomeGrid" Width="550px"
                AutoGenerateColumns="false" CssClass="IncomeGrid" GridLines="None">
                <HeaderStyle CssClass="IncomeGridHeaderStyle" />
                <RowStyle CssClass="IncomeGridRowStyle" />
                <HeaderStyle BackColor="#C5D9F1" />
            </asp:GridView>
            <asp:SqlDataSource ID="ds_IncomeGrid" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
                SelectCommand="stp_Agency_DashBoard_NetIncomeGridData" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="userid" QueryStringField="id" Type="Int16" />
                    <asp:QueryStringParameter Name="companyid" QueryStringField="c" Type="Int16" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    <div style="float: right; width: 200px; text-align: center">
        <div style="padding-bottom: 20px; margin-left: 50px;">
            <%--<igGauge:UltraGauge ID="UltraGauge1" runat="server" Height="250px" Width="200px"
                BackColor="Transparent">
                <Annotations>
                    <igGaugeProp:BoxAnnotation Bounds="24, 5, 0, 0">
                        <Label Font="Tahoma, 8pt, style=Bold" FormatString="New Clients">
                            <BrushElements>
                                <igGaugeProp:SolidFillBrushElement Color="Black" />
                            </BrushElements>
                        </Label>
                        <BrushElements>
                            <igGaugeProp:SolidFillBrushElement Color="White" />
                        </BrushElements>
                    </igGaugeProp:BoxAnnotation>
                </Annotations>
                <Effects>
                    <igGaugeProp:ShadowGaugeEffect>
                    </igGaugeProp:ShadowGaugeEffect>
                </Effects>
                <Gauges>
                    <igGaugeProp:LinearGauge Bounds="0, 0, 154, 0" CornerExtent="3" Orientation="Vertical"
                        SmoothingMode="HighQuality">
                        <Scales>
                            <igGaugeProp:LinearGaugeScale EndExtent="80" StartExtent="5">
                                <MajorTickmarks EndExtent="79" StartExtent="45">
                                    <StrokeElement Color="DimGray">
                                    </StrokeElement>
                                    <BrushElements>
                                        <igGaugeProp:SolidFillBrushElement Color="White" />
                                    </BrushElements>
                                </MajorTickmarks>
                                <MinorTickmarks EndExtent="86" Frequency="0" StartExtent="40">
                                    <StrokeElement Color="Black">
                                    </StrokeElement>
                                </MinorTickmarks>
                                <Labels Extent="30" Font="Tahoma, 9pt" ZPosition="AboveMarkers">
                                    <Shadow Depth="2">
                                        <BrushElements>
                                            <igGaugeProp:SolidFillBrushElement />
                                        </BrushElements>
                                    </Shadow>
                                    <BrushElements>
                                        <igGaugeProp:SolidFillBrushElement Color="Black" />
                                    </BrushElements>
                                </Labels>
                                <Markers>
                                    <igGaugeProp:LinearGaugeBarMarker InnerExtent="53" OuterExtent="70" PrecisionString="0"
                                        ValueString="50">
                                        <StrokeElement Thickness="0">
                                        </StrokeElement>
                                        <BrushElements>
                                            <igGaugeProp:SolidFillBrushElement Color="155, 187, 88" />
                                        </BrushElements>
                                    </igGaugeProp:LinearGaugeBarMarker>
                                </Markers>
                                <Axes>
                                    <igGaugeProp:NumericAxis EndValue="1000" TickmarkInterval="100" />
                                </Axes>
                            </igGaugeProp:LinearGaugeScale>
                            <igGaugeProp:LinearGaugeScale InnerExtent="29" OuterExtent="51" StartExtent="59">
                                <Labels Font="Tahoma, 8pt">
                                </Labels>
                            </igGaugeProp:LinearGaugeScale>
                        </Scales>
                        <StrokeElement>
                            <BrushElements>
                                <igGaugeProp:SolidFillBrushElement Color="Black" />
                            </BrushElements>
                        </StrokeElement>
                    </igGaugeProp:LinearGauge>
                </Gauges>
            </igGauge:UltraGauge>--%>
        </div>
        <div>
            <igchart:UltraChart ID="ucCurrentClientStatus" runat="server" BackgroundImageFileName=""
                BorderColor="Black" BorderWidth="0px" ChartType="PieChart3D" DataSourceID="ds_CurrentClientStatus"
                EmptyChartText="Data Not Available. Please call UltraChart.Data.DataBind() after setting valid Data.DataSource"
                Version="8.2" Width="250px" Height="200px" Transform3D-Scale="90" Transform3D-XRotation="45"
                Transform3D-YRotation="35">
                <TitleTop Font="Tahoma, 8.25pt, style=Bold" HorizontalAlign="Center" Text="CLIENT STATUS"
                    Extent="15">
                    <Margins Bottom="0" Left="0" Right="0" Top="0" />
                </TitleTop>
                <Tooltips Display="Never" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                    Font-Strikeout="False" Font-Underline="False" />
                <TitleBottom Extent="33" Visible="False" Location="Bottom">
                </TitleBottom>
                <Border Thickness="0" />
                <PieChart3D BreakAllSlices="True" BreakDistancePercentage="3" BreakOthersSlice="True"
                    PieThickness="15" RadiusFactor="150">
                    <Labels FormatString="&lt;ITEM_LABEL&gt; &lt;PERCENT_VALUE:#0&gt;%" LeaderLineThickness="0" />
                    <ChartText>
                        <igchartprop:ChartTextAppearance ChartTextFont="Arial, 7pt" Column="-2" ItemFormatString="&lt;DATA_VALUE:00.00&gt;"
                            Row="-2" Visible="True" />
                    </ChartText>
                </PieChart3D>
                <ColorModel AlphaLevel="200" ColorBegin="" ColorEnd="" ModelStyle="CustomLinear"
                    Scaling="Random">
                </ColorModel>
                <Effects>
                    <Effects>
                        <igchartprop:GradientEffect />
                    </Effects>
                </Effects>
                <Axis>
                    <PE ElementType="None" Fill="Cornsilk" />
                    <X LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Near" ItemFormatString="&lt;ITEM_LABEL&gt;"
                            Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Near"
                                Orientation="Horizontal" VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </X>
                    <Y LineThickness="1" TickmarkInterval="10" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString="&lt;DATA_VALUE:00.##&gt;"
                            Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" FormatString="" HorizontalAlign="Far"
                                Orientation="Horizontal" VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Y>
                    <Y2 LineThickness="1" TickmarkInterval="10" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString=""
                            Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Near"
                                Orientation="Horizontal" VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Y2>
                    <X2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Far" ItemFormatString=""
                            Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" FormatString="" HorizontalAlign="Far"
                                Orientation="Horizontal" VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </X2>
                    <Z LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Far" ItemFormatString=""
                            Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="DimGray" HorizontalAlign="Far" Orientation="Horizontal"
                                VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Z>
                    <Z2 LineThickness="1" TickmarkInterval="0" TickmarkStyle="Smart" Visible="False">
                        <MajorGridLines AlphaLevel="255" Color="Gainsboro" DrawStyle="Dot" Thickness="1"
                            Visible="True" />
                        <MinorGridLines AlphaLevel="255" Color="LightGray" DrawStyle="Dot" Thickness="1"
                            Visible="False" />
                        <Labels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" ItemFormatString=""
                            Orientation="Horizontal" VerticalAlign="Center" Visible="False">
                            <SeriesLabels Font="Verdana, 7pt" FontColor="Gray" HorizontalAlign="Near" Orientation="Horizontal"
                                VerticalAlign="Center">
                                <Layout Behavior="Auto">
                                </Layout>
                            </SeriesLabels>
                            <Layout Behavior="Auto">
                            </Layout>
                        </Labels>
                    </Z2>
                </Axis>
                <Legend BorderThickness="0" SpanPercentage="29"></Legend>
            </igchart:UltraChart>
            <asp:SqlDataSource ID="ds_CurrentClientStatus" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
                SelectCommand="stp_AgencyCurrentClientStatus" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="userid" QueryStringField="id" Type="Int16" />
                    <asp:QueryStringParameter Name="companyid" QueryStringField="c" Type="Int16" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    </div>
    </form>
</body>
</html>
