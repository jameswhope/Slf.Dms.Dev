<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="admin_settlementtrackerimport_reports_Default"
    EnableEventValidation="false" Async="true" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
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
                    Tracker Import</a>&nbsp;>&nbsp;Reports
            </td>
        </tr>
        <tr>
            <td>
                <table class="entry">
                    <tr valign="top">
                        <td>
                            <asp:Chart ID="chartFees" runat="server" BackColor="71, 145, 197" ImageLocation="~/admin/settlementtrackerimport/reports/ChartImages/ChartPicFeesYTD_#SEQ(300,3))"
                                Width="550px" Height="550px" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
                                BorderWidth="2px" BorderColor="#B54001" OnClick="chartStream_Click">
                                <Titles>
                                    <asp:Title ShadowColor="32, 0, 0, 0" Font="Arial, 14.25pt, style=Bold" ShadowOffset="3"
                                        Text="Paid Fees" Name="Title1" ForeColor="26, 59, 105">
                                    </asp:Title>
                                </Titles>
                                <Legends>
                                    <asp:Legend BackColor="Transparent" Alignment="Center" Font="Arial, 8pt" Name="Default"
                                        IsTextAutoFit="False" TableStyle="Wide" Docking="Bottom">
                                    </asp:Legend>
                                </Legends>
                                <BorderSkin SkinStyle="Emboss"></BorderSkin>
                                <Series>
                                    <asp:Series Name="Default" ChartType="Pie" BorderColor="180, 26, 59, 105" Color="220, 65, 140, 240"
                                        ChartArea="ChartArea1" Legend="Default">
                                    </asp:Series>
                                </Series>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BackSecondaryColor="Transparent"
                                        BackColor="Transparent" ShadowColor="Transparent" BorderWidth="0">
                                        <Area3DStyle Rotation="15" />
                                        <AxisY LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt, style=Bold" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisY>
                                        <AxisX LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt, style=Bold" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisX>
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
                        </td>
                        <td>
                            <asp:Chart ID="chartPaid" runat="server" BackColor="71, 145, 197" ImageLocation="~/admin/settlementtrackerimport/reports/ChartImages/ChartPicPaidYTD_#SEQ(300,3))"
                                Width="550px" Height="250px" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
                                BorderWidth="2px" BorderColor="#B54001">
                                <Titles>
                                    <asp:Title ShadowColor="32, 0, 0, 0" Font="Arial, 12.25pt, style=Bold" ShadowOffset="3"
                                        Text="# Paid Settlements" ForeColor="26, 59, 105" Name="Title1">
                                    </asp:Title>
                                </Titles>
                                <Legends>
                                    <asp:Legend Enabled="False" IsTextAutoFit="True" Name="Default" BackColor="Transparent"
                                        Font="Arial, 8.25pt, style=Bold">
                                    </asp:Legend>
                                </Legends>
                                <BorderSkin SkinStyle="Emboss"></BorderSkin>
                                <Series>
                                    <asp:Series ChartArea="ChartArea1" Name="Series1" BorderColor="180, 26, 59, 105"
                                        Color="220, 65, 140, 240" Legend="Default">
                                    </asp:Series>
                                </Series>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BorderDashStyle="Solid"
                                        BackSecondaryColor="White" BackColor="198, 222, 242" ShadowColor="Transparent"
                                        BackGradientStyle="TopBottom">
                                        <Area3DStyle PointGapDepth="2" Rotation="10" Enable3D="True" Inclination="15" IsRightAngleAxes="False"
                                            WallWidth="0" />
                                        <AxisY LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisY>
                                        <AxisX LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt" Interval="1" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisX>
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
                            <asp:SqlDataSource ID="dsPaid" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_getPaid">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="year" />
                                    <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:Chart ID="chartYTDUnits" runat="server" BackColor="71, 145, 197" ImageLocation="~/admin/settlementtrackerimport/reports/ChartImages/ChartPicYTD_#SEQ(300,3))"
                                Width="550px" Height="150px" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
                                BorderWidth="2px" BorderColor="#B54001">
                                <Legends>
                                    <asp:Legend Enabled="False" IsTextAutoFit="False" Name="Default" BackColor="Transparent"
                                        Font="Arial, 8.25pt, style=Bold">
                                    </asp:Legend>
                                </Legends>
                                <Titles>
                                    <asp:Title ShadowColor="32, 0, 0, 0" Font="Arial, 12.25pt, style=Bold" ShadowOffset="3"
                                        Text="YTD Settlement Units" Name="Title1" ForeColor="26, 59, 105">
                                    </asp:Title>
                                </Titles>
                                <BorderSkin SkinStyle="Emboss"></BorderSkin>
                                <Series>
                                    <asp:Series MarkerSize="8" BorderWidth="3" XValueType="Double" Name="Series1" ChartType="Line"
                                        MarkerStyle="Circle" ShadowColor="Black" BorderColor="180, 26, 59, 105" Color="220, 65, 140, 240"
                                        ShadowOffset="2" YValueType="Auto" ChartArea="ChartArea1" Legend="Default">
                                    </asp:Series>
                                </Series>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BorderDashStyle="Solid"
                                        BackSecondaryColor="White" BackColor="198, 222, 242" ShadowColor="Transparent"
                                        BackGradientStyle="TopBottom">
                                        <Area3DStyle Rotation="25" Perspective="9" LightStyle="Realistic" Inclination="40"
                                            IsRightAngleAxes="False" WallWidth="3" />
                                        <AxisY LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisY>
                                        <AxisX LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt" Interval="1" Angle="45" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisX>
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
                            <asp:Chart ID="chartYTDFees" runat="server" BackColor="71, 145, 197" ImageLocation="~/admin/settlementtrackerimport/reports/ChartImages/ChartPicYTD_#SEQ(300,3))"
                                Width="550px" Height="175px" BorderDashStyle="Solid" BackGradientStyle="TopBottom"
                                BorderWidth="2px" BorderColor="#B54001">
                                <Legends>
                                    <asp:Legend Enabled="False" IsTextAutoFit="True" Name="Default" BackColor="Transparent"
                                        Font="Arial, 8.25pt">
                                    </asp:Legend>
                                </Legends>
                                <Titles>
                                    <asp:Title ShadowColor="32, 0, 0, 0" Font="Arial, 12.25pt, style=Bold" ShadowOffset="3"
                                        Text="YTD Settlement Fees" Name="Title1" ForeColor="26, 59, 105">
                                    </asp:Title>
                                </Titles>
                                <BorderSkin SkinStyle="Emboss"></BorderSkin>
                                <Series>
                                    <asp:Series MarkerSize="8" BorderWidth="3" XValueType="Double" Name="Series1" ChartType="Line"
                                        MarkerStyle="Circle" ShadowColor="Black" BorderColor="180, 26, 59, 105" Color="220, 65, 140, 240"
                                        ShadowOffset="2" YValueType="Double" ChartArea="ChartArea1" Legend="Default">
                                    </asp:Series>
                                </Series>
                                <ChartAreas>
                                    <asp:ChartArea Name="ChartArea1" BorderColor="64, 64, 64, 64" BorderDashStyle="Solid"
                                        BackSecondaryColor="White" BackColor="198, 222, 242" ShadowColor="Transparent"
                                        BackGradientStyle="TopBottom">
                                        <Area3DStyle Rotation="25" Perspective="9" LightStyle="Realistic" Inclination="40"
                                            IsRightAngleAxes="False" WallWidth="3" />
                                        <AxisY LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisY>
                                        <AxisX LineColor="64, 64, 64, 64">
                                            <LabelStyle Font="Arial, 8.25pt" Interval="1" />
                                            <MajorGrid LineColor="64, 64, 64, 64" />
                                        </AxisX>
                                    </asp:ChartArea>
                                </ChartAreas>
                            </asp:Chart>
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
