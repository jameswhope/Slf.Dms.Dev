<%@ Control Language="VB" AutoEventWireup="false" CodeFile="C21TransactionPicker.ascx.vb"
    Inherits="Clients_client_finances_bytype_action_usercontrols_C21TransactionPicker"  %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>

<style>
    .btnCell
    {
        border: none;
        cursor: hand;
        width: 70px;
    }
    .btnCellSelected
    {
        border: solid 1px #000000;
        cursor: hand;
        width: 70px;
    }
</style>
<asp:ScriptManagerProxy Id="myProxy"  runat="server"  >
</asp:ScriptManagerProxy>
<table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 770px;
    height: 510px;" border="0" cellpadding="0" cellspacing="15">
    <tr>    
        <td valign="top" style="height:100%; width: 100%;">
            <div style="height:100%; width: 100%; ">
                <div style="height:250px; width: 700px; overflow: scroll;">
                        <igtbl:UltraWebGrid ID="ug_C21Transactions" runat="server" DataSourceID="ds_C21Transactions"
                Browser="Xml" >
                <Bands>
                    <igtbl:UltraGridBand AllowUpdate="RowTemplateOnly" CellClickAction="RowSelect">
                        <Columns>
                            <igtbl:UltraGridColumn BaseColumnName="TransactionId" IsBound="True" Key="TransactionId">
                                <Header Caption="Transaction Id">
                                </Header>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Received Date" DataType="System.DateTime"
                                IsBound="True" Key="Received Date" Format="MM/dd/yyyy hh:mm tt">
                                <Header Caption="Received Date">
                                    <RowLayoutColumnInfo OriginX="1" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="1" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Processed Date" DataType="System.DateTime"
                                IsBound="True" Key="Processed Date" Format="MM/dd/yyyy hh:mm tt">
                                <Header Caption="Processed Date">
                                    <RowLayoutColumnInfo OriginX="2" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="2" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Account Number" IsBound="True" Key="Account Number">
                                <Header Caption="Account Number">
                                    <RowLayoutColumnInfo OriginX="3" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="3" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Check Number" IsBound="True" Key="Check Number">
                                <Header Caption="Check Number">
                                    <RowLayoutColumnInfo OriginX="4" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="4" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Amount" DataType="System.Decimal" IsBound="True"
                                Key="Amount" Format="$###,###,##0.00 ">
                                <Header Caption="Amount">
                                    <RowLayoutColumnInfo OriginX="5" />
                                </Header>
                                <CellStyle HorizontalAlign="Right" />
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="5" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Status" IsBound="True" Key="Status">
                                <Header Caption="Status">
                                    <RowLayoutColumnInfo OriginX="6" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="6" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="State" IsBound="True" Key="State">
                                <Header Caption="State">
                                    <RowLayoutColumnInfo OriginX="7" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="7" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Check Type" IsBound="True" Key="Check Type">
                                <Header Caption="Check Type">
                                    <RowLayoutColumnInfo OriginX="8" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="8" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Front Image" IsBound="True" Key="Front Image"
                                Hidden="True">
                                <Header Caption="Front Image">
                                    <RowLayoutColumnInfo OriginX="9" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="9" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                            <igtbl:UltraGridColumn BaseColumnName="Back Image" IsBound="True" Key="Back Image"
                                Hidden="True">
                                <Header Caption="Back Image">
                                    <RowLayoutColumnInfo OriginX="10" />
                                </Header>
                                <Footer>
                                    <RowLayoutColumnInfo OriginX="10" />
                                </Footer>
                            </igtbl:UltraGridColumn>
                           <igtbl:TemplatedColumn BaseColumnName="Hide"  CellMultiline="No" DataType="System.Boolean" AllowRowFiltering="true" Key="Hide"   >
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkShowHidden" runat="server" Text="Show Hidden" onclick="ShowHiddenRows(this);"/>
                                </HeaderTemplate> 
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <CellTemplate>
                                    <asp:CheckBox id="chkhide" Checked="<%#Container.Text %>"  Text="Hide" runat="server" onclick='HideRow(this)' /> 
                                </CellTemplate> 
                                <CellStyle HorizontalAlign="Center" ></CellStyle> 
                                <Footer>
                                     <RowLayoutColumnInfo OriginX="11" />
                                </Footer>
                            </igtbl:TemplatedColumn>  
                        </Columns>
                        <RowEditTemplate>
                        </RowEditTemplate>
                        <RowTemplateStyle BackColor="Window" BorderColor="Window" BorderStyle="Ridge" Width="0px"
                            Height="0px" HorizontalAlign="Left" VerticalAlign="Top">
                            <BorderDetails WidthBottom="3px" WidthLeft="3px" WidthRight="3px" WidthTop="3px" />
                        </RowTemplateStyle>
                        <AddNewRow View="NotSet" Visible="NotSet">
                        </AddNewRow>
                    </igtbl:UltraGridBand>
                </Bands>
                <DisplayLayout AllowColSizingDefault="Free" AllowColumnMovingDefault="OnServer" BorderCollapseDefault="Separate"
                    HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1" RowHeightDefault="20px"
                    RowSelectorsDefault="No" SelectTypeRowDefault="Single" TableLayout="Fixed" Version="4.00"
                    AutoGenerateColumns="False" LoadOnDemand="Xml" CellClickActionDefault="RowSelect"
                    AllowSortingDefault="OnClient" RowsRange="-1">
                    <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid"
                        BorderWidth="1px" Font-Names="Microsoft Sans Serif" Font-Size="8.25pt">
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
                        Font-Names="Microsoft Sans Serif" Font-Size="8.25pt">
                        <Padding Left="3px" />
                        <BorderDetails ColorLeft="Window" ColorTop="Window" />
                    </RowStyleDefault>
                    <GroupByRowStyleDefault BackColor="Control" BorderColor="Window">
                    </GroupByRowStyleDefault>
                    <SelectedRowStyleDefault BackColor="#99CCFF">
                    </SelectedRowStyleDefault>
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
                    <ClientSideEvents AfterRowActivateHandler="ugC21Transactions_AfterRowActivateHandler" >
                    </ClientSideEvents>
                    <Images>
                        <FilterImage Url="~/Clients/Enrollment/images/ig_tblFilter.gif" AlternateText="Filter.." />
                    </Images>
                </DisplayLayout>
            </igtbl:UltraWebGrid>
                </div>
                <table id="tblImage" width="100%" style="display:none; ">
                    <tr>
                        <td>
                            <table  width="100%" cellpadding="3px" cellspacing="3px" style="font-family: tahoma; font-size: 11px; " >
                                <tr>
                                    <td width="80px">
                                        Transaction Id:
                                    </td>
                                    <td width="200px" id="tdTransactionId" style="font-weight: bold;" nowrap="true">
                                    </td>
                                    <td id="tdbtnFrontImage" class="btnCellSelected" onclick="showTransactionImage(0);">
                                        Front Image
                                    </td>
                                    <td id="tdbtnBackImage" class="btnCell" onclick="showTransactionImage(1);">
                                        Back Image
                                    </td>
                                    <td></td>
                                </tr>
                            </table>
                            <table style="width: 100%; height: 100%;">
                                <tr>
                                    <td id="tdFrontImage" style="display: block;">
                                        <img id="imgFrontImage" alt="Front Image" border="1" src=""  />
                                    </td>
                                </tr>
                                <tr>
                                    <td id="tdBackImage" style="display: none;">
                                        <img id="ImgBackImage" alt="Back Image" border="1" src="" />
                                    </td>
                                </tr>
                            </table>
                            </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
</table>

<asp:SqlDataSource ID="ds_C21Transactions" runat="server" ConnectionString="<%$ Appsettings:connectionstring %>"
    ProviderName="System.Data.SqlClient" SelectCommand="stp_GetNotMappedC21items"
    SelectCommandType="StoredProcedure" >
</asp:SqlDataSource>
<input id="hdnImagePath" type="hidden" runat="server" />
<input id="hdnShowHidden" type="hidden" value="false" />
<input id="hdnHideTransArgs" type="hidden" runat="server" />

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>
<asp:LinkButton id="lnkHideC21" runat="server"  ></asp:LinkButton>
</ContentTemplate>
</asp:UpdatePanel>

<script type="text/javascript">
    

    function DisplayGrdRows() {
        var show = document.getElementById("hdnShowHidden").value;
        var grid = igtbl_getGridById("<%=ug_C21Transactions.ClientId %>");
        var gridName = grid.Id;
        var i = 0;
        var row = igtbl_getRowById(gridName + '_r_0');
        while (row) {
            if (show == "true" || row.getCellFromKey("Hide").getElement().children[0].checked == false) {
                row.setHidden(false);
            } else {
                row.setHidden(true);
                document.getElementById("tblImage").style.display = 'none';
                document.getElementById("tdTransactionId").innerText = "";
            }
            i++;
            row = igtbl_getRowById(gridName + '_r_' + i);
        }
    }

    function ShowHiddenRows(chk) {
        document.getElementById("hdnShowHidden").value = chk.checked;
        DisplayGrdRows();
    }
    
    function HideRow(chk) {
        var cell = igtbl_getCellById(chk.parentElement.id);
        cell.setValue(chk.checked, null);
        DisplayGrdRows();
        var row = igtbl_getRowById(chk.parentElement.parentElement.id);
        document.getElementById("<%=hdnHideTransArgs.ClientId%>").value =  ((chk.checked == true)?'1':'0') + '|' + row.getCell(0).getValue();
        <%=Page.ClientScript.GetPostbackEventReference(lnkHideC21, Nothing) %>;
    }

    function ugC21Transactions_AfterRowActivateHandler(gridName, rowId) {
       
        var ImageTable = document.getElementById("tblImage");
        
       ImageTable.style.display = "block";

        var row = igtbl_getRowById(rowId);
        
        var tdTransId = document.getElementById("tdTransactionId");
        tdTransId.innerText = row.getCell(0).getValue();

        var hdnImagePath = document.getElementById("<%= hdnImagePath.ClientId %>");
        var imgFront = document.getElementById("imgFrontImage");
        imgFront.src = hdnImagePath.value + row.getCell(9).getValue().replace(/\\/g, "/");

        var imgBack = document.getElementById("imgBackImage");
        imgBack.src = hdnImagePath.value + row.getCell(10).getValue().replace(/\\/g, "/");
        
    }

      function showTransactionImage(ImageType) {
        var tdFrontImage;
        var tdBackImage;
        var btnFrontImage;
        var btnBackImage;

        btnFrontImage = document.getElementById("tdbtnFrontImage");
        btnBackImage = document.getElementById("tdbtnBackImage");
        tdFrontImage = document.getElementById("tdFrontImage");
        tdBackImage = document.getElementById("tdBackImage");

        if (ImageType == 0) {
            btnFrontImage.className = "btnCellSelected";
            btnBackImage.className = "btnCell";
            tdFrontImage.style.display = "block";
            tdBackImage.style.display = "none";
        }
        else {
            btnFrontImage.className = "btnCell";
            btnBackImage.className = "btnCellSelected";
            tdFrontImage.style.display = "none";
            tdBackImage.style.display = "block";
        }
    }

    function SetChoice(rowNum) {
        alert(rowNum); 
    }
</script>

