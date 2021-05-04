<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="ExportDetail.aspx.vb"
    Inherits="Clients_Enrollment_ExportDetail" Title="SmartDebtor - Export Details" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebToolbar.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebToolbar" TagPrefix="igtbar" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false"
            style="width: 100%">
            <tr>
                <td nowrap="nowrap" id="tdBack" runat="server">
                    <igtbar:UltraWebToolbar ID="uwToolBar" runat="server" BackgroundImage="" ImageDirectory=""
                        ItemWidthDefault="150px" Width="100%" Font-Names="Tahoma" Font-Size="11px" ToolTip="Transfer applicants to Lexxiom">
                        <HoverStyle Cursor="Hand">
                        </HoverStyle>
                        <TextBoxStyle Cursor="Hand" />
                        <SelectedStyle Cursor="Hand">
                        </SelectedStyle>
                        <DefaultStyle Cursor="Hand">
                        </DefaultStyle>
                        <ButtonStyle Width="120px">
                        </ButtonStyle>
                        <LabelStyle Cursor="Hand" />
                        <Items>
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_back.png"
                                SelectedImage="" Text="Back" Tag="back" DefaultStyle-Width="50px" ToolTip="Return to the initial page">
                                <Images>
                                    <DefaultImage Url="~/images/16x16_back.png" />
                                </Images>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_forward.png"
                            SelectedImage="" Text="Export History" Key="H" ToolTip="List the transfer history" >
                            <Images>
                                <DefaultImage Url="~/images/12x12_calendar.png" />
                            </Images>
                            <DefaultStyle Width="100px">
                            </DefaultStyle>
                            <SelectedStyle Cursor="Hand">
                            </SelectedStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator /> 
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_prospect.png"
                                SelectedImage="" Text="Transfers to Lexxiom" Key="T" ToolTip="Transfer approved applicants to Lexxiom" >
                                <Images>
                                    <DefaultImage Url="~/images/16x16_prospect.png" />
                                </Images>
                                <DefaultStyle Width="120px">
                                </DefaultStyle>
                                <SelectedStyle Cursor="Hand">
                                </SelectedStyle>
                            </igtbar:TBarButton>
                        </Items>
                    </igtbar:UltraWebToolbar>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="Enrollment.css" rel="stylesheet" type="text/css" />
    <table runat="server" id="tblBody" class="enrollment_body">
        <tr>
            <td valign="top">
                <table class="summary" style="width: 200px;">
                    <tr>
                        <td colspan="2">
                            <h2>
                                Summary</h2>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 80px;">
                            Report Number:
                        </td>
                        <td style="width: 100px">
                            <asp:Label ID="lblReportNumber" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Export Date:
                        </td>
                        <td>
                            <asp:Label ID="lblExportDate" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Exported By:
                        </td>
                        <td>
                            <asp:Label ID="lblExecutedBy" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Status:
                        </td>
                        <td>
                            <asp:Label ID="lblExportStatus" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Applicants:
                        </td>
                        <td>
                            <asp:Label ID="lblApplicantCount" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Exported:
                        </td>
                        <td style="height: 24px;">
                            <asp:Label ID="lblSucceeded" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Failed:
                        </td>
                        <td>
                            <asp:Label ID="lblFailed" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Left Pending:
                        </td>
                        <td>
                            <asp:Label ID="lblLeftPending" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: text-top;">
                            Notes:
                        </td>
                        <td>
                            <asp:Label ID="lblNote" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </table>
                <asp:SqlDataSource ID="dsSummary" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    SelectCommand="stp_enrollment_getExportJobById" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="exportjobid" Type="Int32" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
            <td valign="top">
                <table class="window" style="width: 660px;">
                    <tr>
                        <td colspan="2">
                            <h2 id="hPipeline" runat="server">
                                Export Details</h2>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <igtbl:UltraWebGrid ID="wGridPipeline" runat="server" DataSourceID="dsPipe" Browser="Xml">
                                <Bands>
                                    <igtbl:UltraGridBand AllowAdd="No" AllowSorting="Yes" AllowUpdate="No" ColHeadersVisible="Yes"
                                        GridLines="Horizontal" HeaderTitleModeDefault="Always" RowSelectors="No">
                                        <Columns>
                                            <igtbl:UltraGridColumn Hidden="true" BaseColumnName="LeadApplicantId" DataType="System.Int32">
                                                <Header Caption="LeadApplicantId">
                                                </Header>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn AllowResize="Free" Type="HyperLink" Width="200px" BaseColumnName="FullName">
                                                <Header Caption="Lead Applicant" Title="">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Status" Width="150px">
                                                <Header Caption="Status">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Note" Width="300px" CellMultiline="No">
                                                <Header Caption="Notes">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn  Key="EnrollmentPage"  DataType="System.String" BaseColumnName="EnrollmentPage" Hidden="True">
                                                    <Header Caption="EnrollmentPage">
                                                    </Header>
                                                </igtbl:UltraGridColumn>
                                        </Columns>
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                    </igtbl:UltraGridBand>
                                </Bands>
                                <DisplayLayout AllowColSizingDefault="Free" BorderCollapseDefault="Collapse"
                                    HeaderTitleModeDefault="Always" Name="UltraWebGrid1" RowHeightDefault="20px"
                                    RowSizingDefault="Free" SelectTypeCellDefault="Single" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AutoGenerateColumns="False"
                                    LoadOnDemand="Xml">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <Pager PageSize="25" AllowPaging="True">
                                    </Pager>
                                    <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                    </FooterStyleDefault>
                                    <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        <Padding Right="3px" />
                                    </HeaderStyleDefault>
                                    <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                        Font-Names="Verdana" Font-Size="8pt">
                                        <Padding Left="3px" />
                                        <BorderDetails ColorLeft="White" ColorTop="White" />
                                    </RowStyleDefault>
                                    <SelectedRowStyleDefault BackColor="#f1f1f1" ForeColor="Black" BorderWidth="0px"
                                        BorderStyle="None">
                                    </SelectedRowStyleDefault>
                                    <AddNewBox>
                                        <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                        </BoxStyle>
                                    </AddNewBox>
                                    <ActivationObject BorderColor="Black" BorderWidth="">
                                    </ActivationObject>
                                    <FixedCellStyleDefault Width="200px">
                                    </FixedCellStyleDefault>
                                    <FilterOptionsDefault>
                                        <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                            CustomRules="overflow:auto;" Font-Names="Tahoma,Arial,Helvetica,sans-serif" Font-Size="11px"
                                            Width="200px">
                                            <Padding Left="2px" />
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                        </FilterHighlightRowStyle>
                                        <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                            BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Tahoma,Arial,Helvetica,sans-serif"
                                            Font-Size="11px">
                                            <Padding Left="2px" />
                                        </FilterOperandDropDownStyle>
                                    </FilterOptionsDefault>
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                            <asp:SqlDataSource ID="dsPipe" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                SelectCommand="stp_enrollment_getExportDetails" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="exportjobid" Type="Int32" DefaultValue="0" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
