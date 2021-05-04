<%@ Page Title="" Language="VB" MasterPageFile="~/site.master" AutoEventWireup="false"
    CodeFile="RunningBalance.aspx.vb" Inherits="Agency_RunningBalance" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img id="Img1" width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td nowrap="nowrap">
                <a class="menuButton" href="default.aspx">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_accounts.png" />Payment Dashboard</a>
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table style="width: 95%; margin: 0 15 15 15" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td style="padding: 10 7 7 0">
                <table class="entry2" style="background-color: #cccccc">
                    <tr>
                        <td>
                            From:
                        </td>
                        <td>
                            <igsch:WebDateChooser ID="txtStartDate" runat="server" Width="78px" Height="10px"
                                Font-Names="tahoma" Font-Size="11px" DropButton-Style-Height="17px" CalendarLayout-CalendarStyle-Font-Names="tahoma"
                                CalendarLayout-CalendarStyle-Font-Size="11px">
                            </igsch:WebDateChooser>
                        </td>
                        <td>
                            To:
                        </td>
                        <td>
                            <igsch:WebDateChooser ID="txtEndDate" runat="server" Width="78px" Height="10px" Font-Names="tahoma"
                                Font-Size="11px" DropButton-Style-Height="17px" CalendarLayout-CalendarStyle-Font-Names="tahoma"
                                CalendarLayout-CalendarStyle-Font-Size="11px">
                            </igsch:WebDateChooser>
                        </td>
                        <td>
                            <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="entry2" />
                            <asp:Button ID="btnExport" runat="server" Text="Export" ToolTip="Export to Excel" CssClass="entry2" />
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <asp:Label ID="Label1" runat="server" CssClass="entry2" ForeColor="Red"></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server">
                    <Bands>
                        <igtbl:UltraGridBand>
                            <AddNewRow View="NotSet" Visible="NotSet">
                            </AddNewRow>
                        </igtbl:UltraGridBand>
                    </Bands>
                    <DisplayLayout AllowSortingDefault="No" AllowColSizingDefault="NotSet" AllowColumnMovingDefault="None"
                        AllowDeleteDefault="No" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                        HeaderClickActionDefault="Select" Name="UltraWebGrid1" RowHeightDefault="20px"
                        RowSelectorsDefault="No" SelectTypeRowDefault="Extended" StationaryMargins="Header"
                        StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" ViewType="OutlookGroupBy">
                        <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid"
                            BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="500px" Width="100%">
                        </FrameStyle>
                        <Pager MinimumPagesForDisplay="2">
                            <PagerStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                            </PagerStyle>
                        </Pager>
                        <EditCellStyleDefault BorderStyle="None" BorderWidth="0px">
                        </EditCellStyleDefault>
                        <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                        </FooterStyleDefault>
                        <HeaderStyleDefault BackColor="LightGray" BorderStyle="Solid" HorizontalAlign="Left">
                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                        </HeaderStyleDefault>
                        <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                            Font-Names="Tahoma" Font-Size="11px">
                            <Padding Left="3px" />
                            <BorderDetails ColorLeft="Window" ColorTop="Window" />
                        </RowStyleDefault>
                        <GroupByRowStyleDefault BackColor="red" BorderColor="Window">
                        </GroupByRowStyleDefault>
                        <GroupByBox>
                            <BoxStyle BackColor="ActiveBorder" BorderColor="Window">
                            </BoxStyle>
                        </GroupByBox>
                        <AddNewBox Hidden="False">
                            <BoxStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid" BorderWidth="1px">
                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                            </BoxStyle>
                        </AddNewBox>
                        <ActivationObject BorderColor="" BorderWidth="">
                        </ActivationObject>
                        <FilterOptionsDefault>
                            <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                Font-Size="11px" Height="300px" Width="200px">
                                <Padding Left="2px" />
                            </FilterDropDownStyle>
                            <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                            </FilterHighlightRowStyle>
                            <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                Font-Size="11px">
                                <Padding Left="2px" />
                            </FilterOperandDropDownStyle>
                        </FilterOptionsDefault>
                    </DisplayLayout>
                </igtbl:UltraWebGrid>
                <div style="margin: 10 0 10 0; padding: 5; background-color: lightyellow; width: 400px"
                    class="entry2">
                    BOUNCE: Chargebacks generated because of bounced deposits<br />
                    VOID: Chargebacks generated from voided payments, grouped by client status<br />
                    <font color="gray" style="font-weight: bold">Weekend, no batches sent.</font>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>
