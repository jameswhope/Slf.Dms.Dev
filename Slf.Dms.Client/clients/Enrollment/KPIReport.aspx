<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="KPIReport.aspx.vb" Inherits="Clients_Enrollment_KPIReport" EnableViewState="false" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height: 28px; white-space: nowrap">
                <a id="A1" runat="server" class="menuButton" href="reports.aspx">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_back.png" />Reports</a>
            </td>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <link href="Enrollment.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>

    <style type="text/css">
        .accordionHeader
        {
            padding: 3px;
            border: none;
            border-bottom: solid 1px #d3d3d3;
            cursor: pointer;
            background-color: #f1f1f1;
            font-family: Tahoma;
            font-size: 11px;
            margin: 0;
        }
        .accordionHeader td
        {
            padding: 3px;
            border-collapse: collapse;
            text-align: center;
        }
        .accordionSelectedHeader
        {
            padding: 3px;
            border-bottom: solid 1px #d3d3d3;
            cursor: pointer;
            background-color: #dedede;
            font-family: Tahoma;
            font-size: 11px;
            margin: 0;
        }
        .accordionSelectedHeader td
        {
            padding: 3px;
            border-collapse: collapse;
            text-align: center;
        }
        .accordionContent
        {
            font-family: Tahoma;
            font-size: 11px;
            background-color: #dedede;
            border: none;
            width: 950px;
        }
    </style>
    <div style="padding: 5px">
        Last Updated:
        <asp:Label ID="lblLastMod" runat="server"></asp:Label>
    </div>
    <asi:TabStrip runat="server" ID="tsKPI">
    </asi:TabStrip>
    <div id="phKPI" runat="server" style="display: block">
        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Visible="false">
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
                    BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="600px" Width="100%">
                </FrameStyle>
                <HeaderStyleDefault BackColor="LightGray" BorderStyle="Solid" HorizontalAlign="Right"
                    Wrap="true" Height="40px">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                </HeaderStyleDefault>
                <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                    Font-Names="Tahoma" Font-Size="11px">
                    <Padding Left="3px" />
                    <BorderDetails ColorLeft="Window" ColorTop="Window" />
                </RowStyleDefault>
            </DisplayLayout>
        </igtbl:UltraWebGrid>
    </div>
    <div id="phKPIRev" runat="server" style="display: none">
        <igtbl:UltraWebGrid ID="uwgKPIRevShare" runat="server" Visible="false">
            <Bands>
                <igtbl:UltraGridBand>
                    <AddNewRow View="NotSet" Visible="NotSet">
                    </AddNewRow>
                </igtbl:UltraGridBand>
            </Bands>
            <DisplayLayout AllowSortingDefault="No" AllowColSizingDefault="NotSet" AllowColumnMovingDefault="None"
                AllowDeleteDefault="No" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                HeaderClickActionDefault="Select" Name="uwgKPIRevShare" RowHeightDefault="20px"
                RowSelectorsDefault="No" SelectTypeRowDefault="Extended" StationaryMargins="Header"
                StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" ViewType="OutlookGroupBy">
                <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid"
                    BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="600px" Width="100%">
                </FrameStyle>
                <HeaderStyleDefault BackColor="LightGray" BorderStyle="Solid" HorizontalAlign="Right"
                    Wrap="true" Height="40px">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                </HeaderStyleDefault>
                <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                    Font-Names="Tahoma" Font-Size="11px">
                    <Padding Left="3px" />
                    <BorderDetails ColorLeft="Window" ColorTop="Window" />
                </RowStyleDefault>
            </DisplayLayout>
        </igtbl:UltraWebGrid>
    </div>
    <div id="phRev" runat="server" style="display: none">
        <igtbl:UltraWebGrid ID="UltraWebGrid2" runat="server" Visible="false">
            <Bands>
                <igtbl:UltraGridBand>
                    <AddNewRow View="NotSet" Visible="NotSet">
                    </AddNewRow>
                </igtbl:UltraGridBand>
            </Bands>
            <DisplayLayout AllowSortingDefault="No" AllowColSizingDefault="NotSet" AllowColumnMovingDefault="None"
                AllowDeleteDefault="No" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                HeaderClickActionDefault="Select" Name="UltraWebGrid2" RowHeightDefault="20px"
                RowSelectorsDefault="No" SelectTypeRowDefault="Extended" StationaryMargins="Header"
                StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" ViewType="OutlookGroupBy">
                <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid"
                    BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="600px" Width="100%">
                </FrameStyle>
                <HeaderStyleDefault BackColor="LightGray" BorderStyle="Solid" HorizontalAlign="Right"
                    Wrap="true" Height="40px">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                </HeaderStyleDefault>
                <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                    Font-Names="Tahoma" Font-Size="11px">
                    <Padding Left="3px" />
                    <BorderDetails ColorLeft="Window" ColorTop="Window" />
                </RowStyleDefault>
            </DisplayLayout>
        </igtbl:UltraWebGrid>
    </div>
    <div id="phPer" runat="server" style="display: none">
        <table style="background-color: #C5D9F1; text-align: center" cellpadding="3">
            <tr>
                <td style="width: 100px; text-align: left">
                    Month
                </td>
                <td style="width: 80px">
                    Submitted Cases
                </td>
                <td style="width: 90px">
                    Active
                </td>
                <td style="width: 70px">
                    Inactive
                </td>
                <td style="width: 70px">
                    Pending
                </td>
                <td style="width: 70px">
                    Cancelled
                </td>
                <td style="width: 70px">
                    Non-Deposit
                </td>
                <td style="width: 70px">
                    Pending Approval
                </td>
                <td style="width: 80px">
                    0-30 days
                </td>
                <td style="width: 80px">
                    31-60 days
                </td>
                <td style="width: 80px">
                    61-90 days
                </td>
                <td style="width: 80px">
                    3-6 months
                </td>
                <td style="width: 80px">
                    6-9 months
                </td>
                <td style="width: 80px">
                    +9 months
                </td>
            </tr>
        </table>
        <ajaxToolkit:Accordion ID="Accordion1" runat="server" SuppressHeaderPostbacks="false"
            FadeTransitions="true" TransitionDuration="100" FramesPerSecond="50" RequireOpenedPane="false"
            HeaderCssClass="accordionHeader" HeaderSelectedCssClass="accordionSelectedHeader"
            ContentCssClass="accordionContent">
            <HeaderTemplate>
                <table>
                    <tr>
                        <td style="width: 100px; text-align: left">
                            <%#Eval("mthyr")%>
                        </td>
                        <td style="width: 80px">
                            <%#Eval("submittedcases")%>
                        </td>
                        <td style="width: 90px">
                            <%#Eval("active")%>
                            (<%#Eval("activepct", "{0:P1}")%>)
                        </td>
                        <td style="width: 70px">
                            <%#Eval("inactive")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("pending")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("cancelled")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("nondeposit")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("pendingapproval")%>
                        </td>
                        <td style="width: 80px">
                            <%#Eval("30days")%>
                            (<%#Eval("30dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("60days")%>
                            (<%#Eval("60dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("90days")%>
                            (<%#Eval("90dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("6months")%>
                            (<%#Eval("6monthspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("9months")%>
                            (<%#Eval("9monthspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("9monthsplus")%>
                            (<%#Eval("9monthspluspct", "{0:P1}")%>)
                        </td>
                    </tr>
                </table>
            </HeaderTemplate>
            <ContentTemplate>
                <asp:GridView ID="gvPersistency" runat="server" AutoGenerateColumns="false" DataSource='<%# Container.DataItem.CreateChildView("Relation1") %>'
                    BorderStyle="None">
                    <Columns>
                        <asp:BoundField DataField="mthyr" HeaderText="Month" HeaderStyle-CssClass="top-col"
                            ItemStyle-CssClass="center-col3" ItemStyle-Width="90px" />
                        <asp:BoundField DataField="retention" HeaderText="Days" HeaderStyle-CssClass="top-col"
                            ItemStyle-CssClass="center-col3" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="cases" HeaderText="Cancelled" HeaderStyle-CssClass="top-col"
                            ItemStyle-CssClass="center-col3" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="casespct" HeaderText="%" HeaderStyle-CssClass="top-col"
                            ItemStyle-CssClass="center-col3" ItemStyle-Width="80px" DataFormatString="{0:P1}" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </ajaxToolkit:Accordion>
        <asp:Repeater ID="rptFooter" runat="server">
            <ItemTemplate>
                <table style="background-color: #C5D9F1; text-align: center" cellpadding="3">
                    <tr>
                        <td style="width: 100px; text-align: left">
                            &nbsp;
                        </td>
                        <td style="width: 80px">
                            <%#Eval("submittedcases")%>
                        </td>
                        <td style="width: 90px">
                            <%#Eval("active")%>
                            (<%#Eval("activepct", "{0:P1}")%>)
                        </td>
                        <td style="width: 70px">
                            <%#Eval("inactive")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("pending")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("cancelled")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("nondeposit")%>
                        </td>
                        <td style="width: 70px">
                            <%#Eval("pendingapproval")%>
                        </td>
                        <td style="width: 80px">
                            <%#Eval("30days")%>
                            (<%#Eval("30dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("60days")%>
                            (<%#Eval("60dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("90days")%>
                            (<%#Eval("90dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("6months")%>
                            (<%#Eval("6monthspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("9months")%>
                            (<%#Eval("9monthspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 80px">
                            <%#Eval("9monthsplus")%>
                            (<%#Eval("9monthspluspct", "{0:P1}")%>)
                        </td>
                    </tr>
                </table>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
