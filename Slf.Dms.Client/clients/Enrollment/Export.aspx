<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Export.aspx.vb"
    Inherits="Clients_Enrollment_Export" Title="SmartDebtor - Overview" %>

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
                        ItemWidthDefault="175px" Width="100%" Font-Names="Tahoma" 
                        Font-Size="11px" ToolTip="Transfer applicants to Lexxiom">
                        <HoverStyle Cursor="Hand">
                        </HoverStyle>
                        <TextBoxStyle Cursor="Hand" />
                        <SelectedStyle Cursor="Hand">
                        </SelectedStyle>
                        <DefaultStyle Cursor="Hand">
                        </DefaultStyle>
                        <ButtonStyle Width="160px">
                        </ButtonStyle>
                        <LabelStyle Cursor="Hand" Width="500px" />
                        <Items>
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_back.png"
                                SelectedImage="" Text="Back" Tag="Back" Key="B" ToolTip="Return to the initial page" >
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
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upd" >
        <ProgressTemplate>
            <div class="dvProgress" >
                <img src="<%=ResolveUrl("~/images/loading.gif") %>" alt="Progress Image" />&nbsp;Transferring to Lexxiom ...
            </div>
        </ProgressTemplate> 
    </asp:UpdateProgress>
    <table runat="server" id="tblBody" class="enrollment_body">
        <tr>
            <td>
                <table class="window">
                    <tr>
                        <td>
                            <h2>
                                &nbsp;<asp:UpdatePanel ID="upd" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional" RenderMode="Inline"  >
                                    <ContentTemplate>
                                        <asp:Label ID="lblHeader" runat="server"></asp:Label> &nbsp;
                                        <asp:Button ID="btnTransfer" runat="server" Text="Transfer" ToolTip="Transfer selected applicants to Lexxiom" CssClass="transferButton" ></asp:Button> 
                                    </ContentTemplate> 
                                </asp:UpdatePanel> 
                            </h2>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <igtbl:UltraWebGrid ID="wGridPipeline" runat="server"
                                DataSourceID="dsPipe" Browser="Xml">
                                <Bands>
                                    <igtbl:UltraGridBand AllowAdd="No" AllowSorting="Yes" AllowUpdate="No" ColHeadersVisible="Yes"
                                        GridLines="Horizontal" HeaderTitleModeDefault="Always" RowSelectors="No">
                                        <Columns>                                            
                                            <igtbl:UltraGridColumn DataType="System.Int32"  BaseColumnName="LeadApplicantID" Hidden="True">
                                                <Header Caption="LeadApplicantId"></Header>  
                                            </igtbl:UltraGridColumn>
                                            <igtbl:TemplatedColumn Type="CheckBox" AllowResize="Fixed" AllowNull="False" AllowUpdate="Yes" Width="100px">
                                                <HeaderTemplate>
                                                   <input id="cbSelectAll" name="cbSelectAll" type="checkbox" onclick="SelectAll();" style="vertical-align: middle;" />
                                                   <span>Select All</span>
                                                </HeaderTemplate>

<Header>
<RowLayoutColumnInfo OriginX="1"></RowLayoutColumnInfo>
</Header>

                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="top" Font-Size="10px"   /> 
                                                <CellStyle HorizontalAlign="Center">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="1" />
                                                </Footer>
                                            </igtbl:TemplatedColumn> 
                                            <igtbl:UltraGridColumn AllowResize="Free" CellMultiline="No" DataType="System.DateTime"
                                                Format="MM/dd/yyyy hh:mm tt" Width="140px" BaseColumnName="LeadTransferInDate">
                                                <Header Caption="Date Transferred In">
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign = "Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="2" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn AllowResize="Free" CellMultiline="Yes" Type="HyperLink" Width="125px"
                                                BaseColumnName="FullName">
                                                <Header Caption="Applicant" Title="">
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="3" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn CellMultiline="No" DataType="System.String" BaseColumnName="HomePhone"
                                                Format="000-000-0000">
                                                <Header Caption="Phone Number">
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="4" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn CellMultiline="No" Format="$ ###,###,##0.00" BaseColumnName="TotalDebt"
                                                DataType="System.Decimal">
                                                <Header Caption="Total Debt">
                                                    <RowLayoutColumnInfo OriginX="5" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <CellStyle HorizontalAlign="Right">
                                                </CellStyle>
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="5" />
                                                </Footer>
                                              </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn CellMultiline="Yes" Width="125px" BaseColumnName="Name">
                                                <Header Caption="Lead Source">
                                                    <RowLayoutColumnInfo OriginX="6" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Right" />
                                                <Footer>
                                                <RowLayoutColumnInfo OriginX="6"></RowLayoutColumnInfo>
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="Description">
                                                <Header Caption="Status">
                                                    <RowLayoutColumnInfo OriginX="7" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="7" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn BaseColumnName="AssignedTo">
                                                <Header Caption="Assigned To">
                                                    <RowLayoutColumnInfo OriginX="8" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="8" />
                                                </Footer>
                                            </igtbl:UltraGridColumn>
                                            <igtbl:UltraGridColumn DataType="System.DateTime" Format="MM/dd/yyyy" BaseColumnName="LastContacted"
                                                Width="130px">
                                                <Header Caption="Last Contacted">
                                                    <RowLayoutColumnInfo OriginX="9" />
                                                </Header>
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <Footer>
                                                    <RowLayoutColumnInfo OriginX="9" />
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
                                <DisplayLayout AllowColSizingDefault="Free" BorderCollapseDefault="Collapse" HeaderClickActionDefault="NotSet"
                                    HeaderTitleModeDefault="Always" Name="UltraWebGrid1" RowHeightDefault="20px"
                                    RowSizingDefault="Free" SelectTypeCellDefault="Single" SelectTypeRowDefault="Single"
                                    StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AutoGenerateColumns="False"
                                    AllowSortingDefault="OnClient" AllowUpdateDefault="Yes" 
                                    StationaryMargins="Header">
                                    <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                    </FrameStyle>
                                    <Pager PageSize="2">
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
                                SelectCommand="stp_enrollment_getReadyToExport" 
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="userid" Type="Int32" DefaultValue="0" />
                                    <asp:Parameter DefaultValue="0" Name="Manager" Type="Boolean" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <style>
    .transferButton
{
	border: none; 
	background-color:SteelBlue;
	font-family: Tahoma;
	font-size: 11px;
	font-weight: bold;
	color:  white;
	vertical-align: middle;
	padding: 1px; 
	width: 80px;
	height: 20px; 
	cursor: hand; 
}

.transferButtonHover
{
	border: solid 1px black; 
	background-color: SteelBlue;
	font-family: Tahoma;
	font-size: 11px;
	font-weight: bold;
	color:  #F0E68C;
	vertical-align: middle;
	padding: 0px; 
	width: 80px;
	height: 20px; 
	cursor: hand; 
}
.dvProgress
{
	border: solid 1px black;
	background-color:  #F0E68C;
	z-index: 10000;
	margin: 5 5 5 5;
	padding: 5 5 5 5;   
	top: 200px;
	left: 200px;
	position: absolute;  
}
    </style>
    <script type="text/javascript" >
        //Selects all checkboxes in the grid
        function SelectAll() {
            var oGrid = igtbl_getGridById("<%= wGridPipeline.ClientId %>");
            var cbSelectAll = document.getElementById("cbSelectAll");
            var checked = cbSelectAll.checked;
            if (oGrid) {
                for (i = 0; i < oGrid.Rows.length; i++) {
                    oGrid.Rows.getRow(i).getCell(1).setValue(checked);
                }
            }
        }
    </script> 
    
</asp:Content>
