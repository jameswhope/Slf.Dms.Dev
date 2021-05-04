<%@ Page Title="" Language="VB" MasterPageFile="~/research/queries/financial/accounting/accounting.master"
    AutoEventWireup="false" CodeFile="controlledaccountactivity.aspx.vb" Inherits="research_queries_financial_accounting_controlledaccountactivity" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:PlaceHolder ID="pnlBody" runat="server">
      
        <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
            table-layout: fixed" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                        border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" />
                            </td>
                            <td style="width: 100%;">
                                <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                    background-repeat: repeat-x; background-position: left top; 
                                    font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                    border="0">
                                    <tr>
                                        <td nowrap="nowrap" valign="center" style="padding-left:5px">
                                            Controlled Account:
                                            <asp:DropDownList ID="ddlControlledAccount" runat="server" CssClass="entry2">
                                                <asp:ListItem Text="Disbursement Account" />
                                                <asp:ListItem Text="Escrow Account" />
                                                <asp:ListItem Text="Iniguez General Clearing Account" />
                                                <asp:ListItem Text="Mossler General Clearing Account" />
                                                <asp:ListItem Text="Peavey General Clearing Account" />
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 5;">
                                            &nbsp;
                                        </td>
                                        <td nowrap="nowrap" valign="center" style="padding-left:5px">
                                            Start Date:
                                        </td>
                                        <td>
                                            <igsch:WebDateChooser ID="txtBeginDate" runat="server" Width="78px" Height="10px" Font-Names="tahoma" Font-Size="11px" DropButton-Style-Height="17px" CalendarLayout-CalendarStyle-Font-Names="tahoma" CalendarLayout-CalendarStyle-Font-Size="11px">
                                            </igsch:WebDateChooser>
                                        </td>
                                        <td style="width: 5;">
                                            &nbsp;
                                        </td>
                                        <td nowrap="nowrap" valign="center" style="padding-left:5px">
                                            End Date:
                                        </td>
                                        <td>
                                            <igsch:WebDateChooser ID="txtEndDate" runat="server" Width="78px" Height="10px" Font-Names="tahoma" Font-Size="11px" DropButton-Style-Height="17px" CalendarLayout-CalendarStyle-Font-Names="tahoma" CalendarLayout-CalendarStyle-Font-Size="11px">
                                            </igsch:WebDateChooser>
                                        </td>
                                        <td style="width: 10;">
                                            &nbsp;
                                        </td>
                                        <td>
                                            <img id="Img2" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                        </td>
                                        <td nowrap="nowrap">
                                            <asp:LinkButton ID="lnkRequery" runat="server" class="gridButton">
                                                <img id="Img3" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                    src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton>
                                        </td>
                                        <td>
                                            <img id="Img6" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="lnkExport" runat="server" class="gridButton">
                                                <img id="Img5" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                    src="~/images/icons/xls.png" />&nbsp;Export</asp:LinkButton>
                                        </td>
                                        <td style="width: 100%;">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 10px; height: 30px;">
                    <asp:Literal ID="lblBalance" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td>
                    <div>
                        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="200px" Width="100%">
                            <Bands>
                                <igtbl:UltraGridBand>
                                    <AddNewRow View="NotSet" Visible="NotSet">
                                    </AddNewRow>
                                </igtbl:UltraGridBand>
                            </Bands>
                            <DisplayLayout AllowColSizingDefault="Free" AllowColumnMovingDefault="OnServer" AllowDeleteDefault="Yes"
                                AllowSortingDefault="OnClient" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                                HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1" RowHeightDefault="20px"
                                RowSelectorsDefault="No" SelectTypeRowDefault="Extended" StationaryMargins="Header"
                                StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" ViewType="OutlookGroupBy">
                                <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid"
                                    BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="550px" Width="100%">
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
                                <ImageUrls ExpandImage="~/images/16x16_cheque.png" />
                            </DisplayLayout>
                        </igtbl:UltraWebGrid>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 10px; height: 25px; background-color:#f1f1f1">
                    <asp:Literal ID="lblItems" runat="server"></asp:Literal>
                </td>
            </tr>
        </table>
    </asp:PlaceHolder>
</asp:Content>
