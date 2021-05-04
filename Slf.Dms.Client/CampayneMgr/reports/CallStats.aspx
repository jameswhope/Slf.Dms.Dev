<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="CallStats.aspx.vb" Inherits="admin.admin_CallStats" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
        function extStartDate_SelectionChanged(sender, args) {
            var hdnStartDate = document.getElementById('<%=hdnStartDate.ClientID %>');
            var txtDate1 = document.getElementById('<%=txtDate1.ClientID %>');

            hdnStartDate.value = txtDate1.value;
        }
    </script>
    <script type="text/javascript">
        //initial jquery stuff
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".jqButton").button();
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			            .find(".portlet-header")
				            .addClass("ui-widget-header ui-corner-all")
				            .prepend("<span class='ui-icon ui-icon-gear' title='Press to filter grid'></span>")
				            .end()
			            .find(".portlet-content");
                $(".portlet-header .ui-icon").click(function() {
                    $('.jqDateTbl').toggle();
                });
            });
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left; padding: 0px 3px 3px 3px">
        Reports > Call Stats
    </div>
    <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upPage">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlGroups"  runat="server" DataSourceID="dsGroups" DataTextField="Name" DataValueField="groupid" />
                            <asp:SqlDataSource ID="dsGroups" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                             SelectCommand="SELECT groupid, Name FROM tblGroups union ALL SELECT -1,'All Groups' order by GroupId">
                            </asp:SqlDataSource>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDate1" runat="server" Size="5" MaxLength="10" 
                                Width="100px"></asp:TextBox>
                            <asp:ImageButton runat="Server" ID="StartImage" ImageUrl="~/images/24x24_calendar.png"
                                AlternateText="Click to show calendar" ImageAlign="AbsMiddle" /><cc1:CalendarExtender
                                    ID="extStartDate" OnClientDateSelectionChanged="extStartDate_SelectionChanged"
                                    runat="server" TargetControlID="txtDate1" PopupButtonID="StartImage" />
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" Font-Size="8pt" CssClass="jqButton" />
                            </small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">             
                        <asp:GridView ID="grdIdentiFyle" runat="server" Width="100%" GridLines="None" Caption="<div class='ui-widget-header'>Lead Statistics</div>"
                            BorderStyle="None" AlternatingRowStyle-CssClass="altrow">
                            <HeaderStyle HorizontalAlign="Right" CssClass="headitem2" />
                            <RowStyle HorizontalAlign="Right" CssClass="griditem2" />
                            <AlternatingRowStyle HorizontalAlign="Right" CssClass="griditem2" />
                        </asp:GridView>

                        <asp:GridView ID="gvIncome" runat="server" GridLines="None" BorderStyle="None" Caption="<div class='ui-widget-header'>Income & Expense Statistics</div>"
                            AlternatingRowStyle-CssClass="altrow" AutoGenerateColumns="False" Width="100%">
                            <Columns>
                                <asp:BoundField DataField="TotalPoints" HeaderText="Total Points" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ElapsedTime" HeaderText="Elapsed Time" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AvgPointsPerHr" HeaderText="Avg. Points Per. Hr." HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EstGrossRevenue" HeaderText="Est. Gross Revenue" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EstLaborCost" HeaderText="Est. Labor Cost" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EstGrossMargin" HeaderText="Est. Gross Margin" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                   
                        <asp:GridView ID="grdIdentiFyleTransfers" runat="server" GridLines="None" BorderStyle="None" Caption="<div class='ui-widget-header'>Lead Transfers</div>"
                            AlternatingRowStyle-CssClass="altrow" AutoGenerateColumns="False" Width="100%">
                            <Columns>
                                <asp:BoundField DataField="username" HeaderText="Name" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Dials" HeaderText="Dials" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CallTransfers" HeaderText="Call Transfers" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PctCallTransfers" HeaderText="% Call Transfers" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DataTransfers" HeaderText="Data Transfers" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PctDataTransfers" HeaderText="% Data Transfers" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="TotalSales" HeaderText="Total Sales" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="TotalPoints" HeaderText="Total Points" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ElapsedTime" HeaderText="Elapsed Time" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AvgPointPerHr" HeaderText="Avg Points Per Hour" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Active" HeaderText="In/Out" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ATime" HeaderText="Last Time Punch" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="{0:c}" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="LaborCost" HeaderText="Labor Cost" DataFormatString="{0:c}" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="GrossMargin" HeaderText="Gross Margin" DataFormatString="{0:c}" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    
                </div>
            </div>
            <asp:HiddenField ID="hdnStartDate" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
