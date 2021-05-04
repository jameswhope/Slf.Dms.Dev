<%@ Page Language="VB" AutoEventWireup="false" CodeFile="lead-analysis.aspx.vb" Inherits="public_vendor_lead_analysis" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lead Analysis</title>
    <style type="text/css">
        .creditor-item
        {
            border-bottom: solid 1px #d3d3d3;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
        }
        .headItem
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
        }
        .headItem a
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            color: #000000;
            text-decoration: underline;
        }
        h2
        {
            font-family: Tahoma;
            font-weight: normal;
        }
        a
        {
            color: #333333;
            text-decoration: none;
            font-family: Tahoma;
            font-size: 12px;
        }
        a:hover
        {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <h2 id="hHeader" runat="server">
        Lead Analysis
    </h2>
    <hr />
    <div style="margin: 5px 0 0 5px">
        <asp:LinkButton ID="btnRefresh" runat="server"><img src="images/refresh.png" border="0" align="absmiddle" /> Refresh</asp:LinkButton>
    </div>
    <div style="margin: 5px">
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
                    BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="600px" Width="1230px">
                </FrameStyle>
                <HeaderStyleDefault BackColor="LightGray" BorderStyle="Solid" HorizontalAlign="Center">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                </HeaderStyleDefault>
                <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                    Font-Names="Tahoma" Font-Size="11px" HorizontalAlign="Center">
                    <Padding Left="3px" />
                    <BorderDetails ColorLeft="Window" ColorTop="Window" />
                </RowStyleDefault>
            </DisplayLayout>
        </igtbl:UltraWebGrid>
    </div>
    </form>
</body>
</html>
