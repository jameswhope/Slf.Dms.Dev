<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master" AutoEventWireup="false" CodeFile="WithholdingReport.aspx.vb" Inherits="research_reports_financial_commission_WithholdingReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
<ajaxToolkit:ToolkitScriptManager ID="ScriptManager2" runat="server" EnablePageMethods="true">
    </ajaxToolkit:ToolkitScriptManager>
<%--    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>--%>
   <script type="text/javascript">
     
     function extStartDate_SelectionChanged(sender,args)
        {
                var hdnStartDate = document.getElementById('<%=hdnStartDate.ClientID %>');
                var txtStartDate = document.getElementById('<%=txtStart.ClientID %>');
                
                hdnStartDate.value = txtStartDate.value;
            }

            function extEndDate_SelectionChanged(sender, args) {
                var hdnEndDate = document.getElementById('<%=hdnEndDate.ClientID %>');
                var txtEndDate = document.getElementById('<%=txtEnd.ClientID %>');

                hdnEndDate.value = txtEndDate.value;
            }

     </script>
<style type="text/css">
        th
        {
            background-color: #d3d3d3;
            padding: 4 3 3 3;
            border-bottom: solid 1px #b3b3b3;
        }
    </style>
    <table border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;<a
                        id="A3" runat="server" class="lnk" style="color: #666666;" href="~/research/reports/financial">Financial</a>&nbsp;>&nbsp;Commission
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                       <td>
                            <asp:DropDownList ID="ddlAgency" runat="server" Width="250px" Height="17px" Font-Size="12px">
                                <asp:ListItem Text="Choose a report" Value="-1" />
                                <asp:ListItem Text="Agency Report" Value="0" />
                                <asp:ListItem Text="Attorney Report" Value="1" />
                            </asp:DropDownList> &nbsp; &nbsp
                    </td>
                    <td valign="middle">
                            <asp:Label ID="lblStart" runat="server" Text="Start Date" Font-Names="Tahoma" Font-Size="12px" Font-Bold="true"  />
                    </td>
                    <td>
                            <asp:textbox ID="txtStart" runat="server" Text="" Font-Bold="false" Font-Size="12px" Font-Names="Tahoma" />
                            <asp:ImageButton runat="Server" ID="StartImage" ImageUrl="~/images/16x16_calendar.png"
                                AlternateText="Click to show calendar" /><ajaxToolkit:CalendarExtender ID="extStartDate" OnClientDateSelectionChanged="extStartDate_SelectionChanged" runat="server" TargetControlID="txtStart" PopupButtonID="StartImage" />
                &nbsp; &nbsp;
                    </td>
                    <td valign="middle">
                            <asp:Label ID="lblEnd" runat="server" Text="End Date" Font-Names="Tahoma" Font-Size="12px" Font-Bold="true"  />
                    </td>
                    <td>
                            <asp:textbox ID="txtEnd" runat="server" Text="" Font-Bold="false" Font-Size="12px" Font-Names="Tahoma" />
                            <asp:ImageButton runat="Server" ID="EndImage" ImageUrl="~/images/16x16_calendar.png"
                                AlternateText="Click to show calendar" /><ajaxToolkit:CalendarExtender ID="extEndDate" OnClientDateSelectionChanged="extEndDate_SelectionChanged" runat="server" TargetControlID="txtEnd" PopupButtonID="EndImage" />
                &nbsp; &nbsp;
                    </td>
                    <td>
                            <asp:Label ID="lblReport" runat="server" Text="Refresh" style="vertical-align:middle; text-align:center;" Font-Size="12px" Font-Bold="true"></asp:Label> &nbsp;
                            <asp:ImageButton AlternateText="Print Report" ID="ibRefresh" ImageUrl="~/images/48x48Refresh.jpg" runat="server" style="text-align:center; vertical-align:middle;" onClick="btnRefresh_Click"/>
                    </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table style="color: rgb(80,80,80); width: 100%; font-size: 12px; font-family: tahoma;"
                    border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width: 100%;">
                            <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                border="0">
                                <tr>
                                    <td style="width: 10;">
                                        &nbsp;
                                    </td>
                                    <td style="white-space:nowrap; font-size:12px; font-weight:bold;">
                                        Commissions Withheld
                                    </td>
                                    <td style="width: 100%;">
                                        &nbsp;
                                    </td>
                                    <td nowrap="true">
                                        <asp:LinkButton ID="lnkExport" runat="server" class="gridButton">
                                            <img id="Img2" runat="server" align="middle" border="0" class="gridButtonImage"
                                                src="~/images/icons/xls.png" /></asp:LinkButton>
                                    </td>
                                    <td style="width: 10;">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <div id="dvData" runat="server" visible="true">
                        <tr>
                            <td align="center" style="font-style:italic; font-size:12px;" visible="true">
                            <p></p>
                                No data is available for the selected date range or commission recipient..........................
                            </td>
                        </tr>
                    </div>
                    
                </table>
                <asp:GridView ID="gvWithheld" runat="server" ShowFooter="True"
                    GridLines="None" 
                    HeaderStyle-CssClass="headItem4" Width="1100px" Font-Size="14px" 
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField HeaderText="Withheld From" ReadOnly="True" 
                            DataField="WithheldFrom">
                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Transferred to" ReadOnly="True" 
                            DataField="Name">
                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AccountNumber" HeaderText="GCA Account" > 
                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Original Amount" DataField="OriginalAmount" 
                            DataFormatString="{0:c}">
                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" />
                        <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Withheld" DataField="AmountWithheld" 
                            DataFormatString="{0:c}">
                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" />
                        <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Current Amount" DataField="Amount" DataFormatString="{0:c}">
                        <HeaderStyle HorizontalAlign="Right" VerticalAlign="Middle" />
                        <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:TemplateField>
                            <ItemStyle Width="20px" />
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Withheld By" DataField="WithHeldBy">
                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Date Withheld" DataField="DateWithheld" DataFormatString="{0:d}">
                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                        </asp:BoundField>
                    </Columns>
                    <HeaderStyle CssClass="headItem4"></HeaderStyle>
                    
                </asp:GridView>
            </td>
        </tr>
    </table>
    <%--<asp:SqlDataSource ID="ds_Withheld" runat="server" SelectCommand="stp_GetPeriodWithholdings" SelectCommandType="StoredProcedure"
        ConnectionString="<%$ AppSettings:connectionstring %>"></asp:SqlDataSource>--%>
<asp:HiddenField ID="hdnStartDate" runat="server" />
<asp:HiddenField ID="hdnEndDate" runat="server" />
</asp:Content>

