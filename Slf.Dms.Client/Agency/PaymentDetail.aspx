﻿<%@ Page Title="" Language="VB" MasterPageFile="~/Agency/agency.master" AutoEventWireup="false" CodeFile="PaymentDetail.aspx.vb" Inherits="Agency_PaymentDetail" %>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="cphAgencyBody" Runat="Server">
    <table>
        <tr>
            <td style="height: 22px">
                <asp:Label ID="lblInfo" runat="server" CssClass="entry2"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <igtbl:UltraWebGrid ID="ugDetail" runat="server" DataMember="DefaultView" DataSourceID="ds_Detail"
                    Height="100%" Width="528px" DisplayLayout-RowsRange="500" DisplayLayout-ScrollBar="Never">
                    <Bands>
                        <igtbl:UltraGridBand GroupByRowDescriptionMask="[value] ([sum:Amount])">
                            <Columns>
                                <igtbl:UltraGridColumn BaseColumnName="Fee" IsBound="True" Key="Fee">
                                    <Header Caption="Fee">
                                    </Header>
                                </igtbl:UltraGridColumn>
                                <igtbl:UltraGridColumn AllowGroupBy="Yes" BaseColumnName="Recipient" IsBound="True" Key="Recipient"
                                    Width="300px">
                                    <HeaderStyle Width="300px" />
                                    <CellStyle Width="300px">
                                    </CellStyle>
                                    <Header Caption="Recipient">
                                        <RowLayoutColumnInfo OriginX="2" />
                                    </Header>
                                    <Footer>
                                        <RowLayoutColumnInfo OriginX="2" />
                                    </Footer>
                                </igtbl:UltraGridColumn>
                                <igtbl:UltraGridColumn AllowGroupBy="No" BaseColumnName="Amount" DataType="System.Decimal"
                                    Format="$ ###,###,##0.00" IsBound="True" Key="Amount" Width="180px">
                                    <HeaderStyle Width="180px" HorizontalAlign="Right" />
                                    <CellStyle Width="180px" HorizontalAlign="Right">
                                    </CellStyle>
                                    <Header Caption="Amount">
                                        <RowLayoutColumnInfo OriginX="3" />
                                    </Header>
                                    <Footer>
                                        <RowLayoutColumnInfo OriginX="3" />
                                    </Footer>
                                </igtbl:UltraGridColumn>
                            </Columns>
                            <AddNewRow View="NotSet" Visible="NotSet">
                            </AddNewRow>
                        </igtbl:UltraGridBand>
                    </Bands>
                    <DisplayLayout AllowColSizingDefault="Free" AllowColumnMovingDefault="OnServer" AllowSortingDefault="OnClient"
                        BorderCollapseDefault="Separate" HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1"
                        RowHeightDefault="20px" RowSelectorsDefault="No" SelectTypeRowDefault="Extended"
                        StationaryMargins="Header" StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed"
                        Version="4.00" ViewType="OutlookGroupBy" UseFixedHeaders="True">
                        <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="None"
                            BorderWidth="1px" Font-Names="tahoma" Font-Size="8.25pt" Height="900px"
                            Width="528px" TextOverflow="Ellipsis">
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
                        <HeaderStyleDefault BackColor="White" BorderStyle="Solid" HorizontalAlign="Left" Font-Bold="True">
                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                        </HeaderStyleDefault>
                        <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                            Font-Names="tahoma" Font-Size="8.25pt">
                            <Padding Left="3px" />
                            <BorderDetails ColorLeft="Window" ColorTop="Window" />
                        </RowStyleDefault>
                        <GroupByRowStyleDefault BackColor="#99CCFF" BorderColor="Window">
                        </GroupByRowStyleDefault>
                        <GroupByBox>
                            <BoxStyle BackColor="#99CCFF" BorderColor="Window">
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
                <asp:SqlDataSource ID="ds_Detail" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
                    SelectCommand="stp_AgencyPaymentDetail" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="payment" QueryStringField="payment" Type="String" />
                        <asp:QueryStringParameter Name="type" QueryStringField="type" Type="String" />
                        <asp:QueryStringParameter Name="startdate" QueryStringField="startdate" Type="DateTime" />
                        <asp:QueryStringParameter Name="enddate" QueryStringField="enddate" Type="DateTime" />
                        <asp:QueryStringParameter Name="dateperiod" QueryStringField="dateperiod" Type="String" />
                        <asp:QueryStringParameter Name="datepartname" QueryStringField="datepartname" Type="String" />
                        <asp:QueryStringParameter Name="userid" QueryStringField="id" Type="Int16" />
                        <asp:QueryStringParameter Name="companyid" QueryStringField="c" Type="Int16" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
</asp:Content>

