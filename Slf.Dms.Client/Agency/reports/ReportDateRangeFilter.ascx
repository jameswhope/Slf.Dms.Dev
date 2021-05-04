<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ReportDateRangeFilter.ascx.vb"
    Inherits="Agency_reports_ReportDateRangeFilter" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<igmisc:webgroupbox id="wgBox1" runat="server" text="Date Period" titlealignment="Left"
    stylesetname="" style="margin: 5 5 5 5" CssClass="paramBox" >
    <Template>
        <igmisc:WebAsyncRefreshPanel ID="WebAsyncRefreshPanel1" runat="server" Width="100%">
            <table class="paramBox" style="width: 100%;">
                <tr>
                    <td>
                        Period:
                    </td>
                    <td>
                        <asp:DropDownList CssClass="paramBox" ID="ddlPeriod" runat="server" Width="120px"
                            AutoPostBack="True" Height="16px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        From:
                    </td>
                    <td>
                        <igsch:WebDateChooser ID="wdBeginPeriod" runat="server" NullDateLabel="No Date" NullValueRepresentation="DateTime_MinValue"
                            AutoPostBack-ValueChanged="true" Value="" Width="120px" Height="19px">
                            <AutoPostBack ValueChanged="True" />
                            <EditStyle Font-Size="11px" Font-Names="tahoma" />
                            <ExpandEffects Type="Fade" />
                            <CalendarLayout CellPadding="5" DayNameFormat="FirstLetter" 
                                NextMonthImageUrl="~/ig_res/default/images/igsch_right_arrow.gif"
                                PrevMonthImageUrl="~/ig_res/default/images/igsch_left_arrow.gif" 
                                ShowFooter="False" ShowMonthDropDown="True"
                                ShowYearDropDown="True" ShowTitle="False">
                                <CalendarStyle BackColor="White" BorderColor="#7F9DB9" BorderStyle="Solid" Font-Names="Tahoma,Verdana"
                                    Font-Size="8pt">
                                </CalendarStyle>
                                <DayHeaderStyle>
                                    <BorderDetails ColorBottom="172, 168, 153" StyleBottom="Solid" WidthBottom="1px" />
                                </DayHeaderStyle>
                                <OtherMonthDayStyle ForeColor="#ACA899" />
                                <SelectedDayStyle BackColor="Transparent" BorderColor="#BB5503" BorderStyle="Solid"
                                    BorderWidth="2px" ForeColor="Black" />
                                <TitleStyle BackColor="#9EBEF5" />
                                <TodayDayStyle BackColor="#FBE694" />
                            </CalendarLayout>
                        </igsch:WebDateChooser>
                    </td>
                  </tr>
                  <tr>
                    <td>
                        To:
                    </td>
                    <td>
                        <igsch:WebDateChooser ID="wdEndPeriod" runat="server" NullDateLabel="No Date" NullValueRepresentation="DateTime_MinValue"
                            AutoPostBack-ValueChanged="true" Width="119px" Height="22px" 
                            style="margin-right: 10px">
                            <AutoPostBack ValueChanged="True" />
                            <EditStyle Font-Size="11px" Font-Names="tahoma" />
                            <ExpandEffects Type="Fade" />
                            <CalendarLayout CellPadding="5" DayNameFormat="FirstLetter" 
                                NextMonthImageUrl="~/ig_res/default/images/igsch_right_arrow.gif"
                                PrevMonthImageUrl="~/ig_res/default/images/igsch_left_arrow.gif" 
                                ShowFooter="False" ShowMonthDropDown="True"
                                ShowYearDropDown="True" ShowTitle="False">
                                <CalendarStyle BackColor="White" BorderColor="#7F9DB9" BorderStyle="Solid" Font-Names="Tahoma,Verdana"
                                    Font-Size="8pt">
                                </CalendarStyle>
                                <DayHeaderStyle>
                                    <BorderDetails ColorBottom="172, 168, 153" StyleBottom="Solid" WidthBottom="1px" />
                                </DayHeaderStyle>
                                <OtherMonthDayStyle ForeColor="#ACA899" />
                                <SelectedDayStyle BackColor="Transparent" BorderColor="#BB5503" BorderStyle="Solid"
                                    BorderWidth="2px" ForeColor="Black" />
                                <TitleStyle BackColor="#9EBEF5" />
                                <TodayDayStyle BackColor="#FBE694" />
                            </CalendarLayout>
                        </igsch:WebDateChooser>
                    </td>
                </tr>
                <tr>
                    <td nowrap="true">
                        Group By:
                    </td>
                    <td>
                        <asp:DropDownList CssClass="paramBox" ID="ddlGroupBy" runat="server" 
                            Width="120px" Height="16px">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </igmisc:WebAsyncRefreshPanel>
    </Template>
</igmisc:webgroupbox>
<style type="text/css">
    .paramBox
    {
        font-family: Tahoma;
        font-size: 11px;
    }
</style>
