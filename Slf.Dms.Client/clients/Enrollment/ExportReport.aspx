<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="ExportReport.aspx.vb"
    Inherits="Clients_Enrollment_ExportReport" Title="SmartDebtor - Export Job Report" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebToolbar.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebToolbar" TagPrefix="igtbar" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" 
            onselectstart="return false" style="width: 100%">
            <tr>
                <td nowrap="nowrap" id="tdBack" runat="server">
                    <igtbar:UltraWebToolbar ID="uwToolBar" runat="server" BackgroundImage="" ImageDirectory=""
                        ItemWidthDefault="150px" Width="100%" Font-Names="Tahoma" 
                        Font-Size="11px" ToolTip="Transfer applicants to Lexxiom">
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
                                SelectedImage="" Text="Back" Tag="Back" ToolTip="Return to the initial page" >
                                <Images>
                                    <DefaultImage Url="~/images/16x16_back.png" />
                                </Images>
                                <DefaultStyle Width="50px">
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
            <td colspan="2">
                <table class="window">
                    <tr>
                        <td colspan="2">
                            <h2 id="hPipeline" runat="server">
                                Export Jobs</h2>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <igtbl:UltraWebGrid ID="wGridPipeline" runat="server" Browser="Xml">
                                <Bands>
                                    <igtbl:UltraGridBand AllowAdd="No" AllowSorting="Yes" AllowUpdate="No" ColHeadersVisible="Yes"
                                        GridLines="Horizontal" HeaderTitleModeDefault="Always" RowSelectors="No">
                                        <Columns>                                            
                                            <igtbl:UltraGridColumn AllowResize="Free"  Type="HyperLink" Width="80px"
                                                BaseColumnName="ExportJobId" DataType="System.Int32">
                                                <Header Caption="Job Id" Title="">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn AllowResize="Free" DataType="System.DateTime"
                                                Format="MM/dd/yyyy hh:mm tt" Width="120px" BaseColumnName="ExportDate">
                                                <Header Caption="Date">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="ExecutedBy">
                                                <Header Caption="By">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Status">
                                                <Header Caption="Status">
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="ApplicantCount" DataType="System.Int32">
                                                <Header Caption="Applicants">
                                                    <RowLayoutColumnInfo OriginX="5" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="5" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Succeeded" DataType="System.Int32">
                                                <Header Caption="Succeeded">
                                                    <RowLayoutColumnInfo OriginX="6" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="6" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Failed" DataType="System.Int32">
                                                <Header Caption="Failed">
                                                    <RowLayoutColumnInfo OriginX="7" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="7" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="LeftPending" DataType="System.Int32">
                                                <Header Caption="Left Pending">
                                                    <RowLayoutColumnInfo OriginX="8" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="8" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Notes" Width="250px" CellMultiline="No">
                                               <Header Caption="Notes">
                                                    <RowLayoutColumnInfo OriginX="9" />
                                                </Header> 
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle TextOverflow="Ellipsis"  />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="9" />
                                                </Footer>
                                            </igtbl:UltraGridColumn> 
                                         </Columns>
                                        <AddNewRow View="NotSet" Visible="NotSet">
                                        </AddNewRow>
                                        <RowExpAreaStyle BackColor="#f1f1f1">                                 
                                        </RowExpAreaStyle>
                                    </igtbl:UltraGridBand>
                                    <igtbl:UltraGridBand AllowAdd="No" AllowSorting="Yes" AllowUpdate="No" ColHeadersVisible="Yes"
                                        GridLines="Horizontal" HeaderTitleModeDefault="Always" RowSelectors="No">
                                        <Columns>     
                                            <igtbl:UltraGridColumn  BaseColumnName="LeadApplicantId" DataType="System.Int32" Hidden="true" >
                                            </igtbl:UltraGridColumn> 
                                            <igtbl:UltraGridColumn  BaseColumnName="ExportJobId" DataType="System.Int32" Hidden="true">
                                            </igtbl:UltraGridColumn>                                      
                                            <igtbl:UltraGridColumn AllowResize="Free"  Width="80px"
                                                BaseColumnName="LeadExportId" DataType="System.Int32">
                                                <Header Caption="Export Id" Title="">
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="FullName" Width="200px" >
                                                <Header Caption="Lead Applicant">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Status" Width="100px">
                                                <Header Caption="Status">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Note" Width="350px"  >
                                                <Header Caption="Notes">
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle TextOverflow="Ellipsis"  />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                         </Columns>
                                         <RowExpAreaStyle BackColor="#f1f1f1"></RowExpAreaStyle>   
                                    </igtbl:UltraGridBand> 
                                </Bands>
                                <DisplayLayout AllowColSizingDefault="Free" BorderCollapseDefault="Collapse"
                                    HeaderTitleModeDefault="Always" Name="UltraWebGrid1" RowHeightDefault="20px"
                                    RowSizingDefault="Free" SelectTypeCellDefault="Single" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AutoGenerateColumns="False"
                                    LoadOnDemand="NotSet" ViewType="Hierarchical">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <Images ><CollapseImage Url="~/ig_res/Default/images/ig_treeXPMinus.GIF"></CollapseImage><ExpandImage Url="~/ig_res/Default/images/ig_treeXPPlus.GIF"></ExpandImage><CurrentRowImage Url="~/ig_res/Default/images/arrow_brown2_beveled.gif"></CurrentRowImage><CurrentEditRowImage Url="~/ig_res/Default/images/arrow_brown2_beveled.gif"></CurrentEditRowImage></Images>
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
                                    <RowExpAreaStyleDefault BackColor="#f1f1f1" >
                                    </RowExpAreaStyleDefault>  
                                </DisplayLayout>
                            </igtbl:UltraWebGrid>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
