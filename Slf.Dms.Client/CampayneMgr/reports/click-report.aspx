<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="click-report.aspx.vb" Inherits="reports_click_report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
				        .prepend("<span class='ui-icon ui-icon-gear' title='hide/show filter options'></span>")
				        .end()
			        .find(".portlet-content");
                $(".portlet-header .ui-icon").click(function() {
                    $('.jqDateTbl').toggle();
                });			        
            });
        }

    </script>

    <script language="javascript" type="text/javascript">
        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }
       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    Click Tracker Report
                </div>
                <div class="portlet-content">
                    <div style="padding:10px; float:left">
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                            <ProgressTemplate>
                                <img src="~/images/ajax-loader.gif" alt="Loading.." runat="server" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                    <div class="jqDateTbl" style="padding: 3px 10px 3px 10px; float: right;">
                        <table>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlQuickPickDate" runat="server" Font-Size="12pt">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDate1" runat="server" Size="8" MaxLength="10" Font-Size="12pt"></asp:TextBox>&nbsp;-&nbsp;<asp:TextBox
                                        ID="txtDate2" runat="server" MaxLength="10" Size="8" Font-Size="12pt"></asp:TextBox>
                                </td>
                                <td>
                                    <small>
                                        <asp:Button ID="btnApply" runat="server" Text="Refresh" CssClass="jqButton" Font-Size="10" /></small>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div style="clear:both">
                    </div>
                    <asp:GridView ID="gvClickReport" runat="server" AutoGenerateColumns="false" GridLines="None"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" Width="100%" DataSourceID="ds_ClickReport"
                        CellPadding="3">
                        <Columns>
                            <asp:BoundField DataField="campaignid" HeaderText="ID" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem" />
                            <asp:BoundField DataField="campaign" HeaderText="Campaign" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem" />
                            <asp:BoundField DataField="affiliate" HeaderText="Affiliate" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem" />
                            <asp:BoundField DataField="offer" HeaderText="Offer" HeaderStyle-HorizontalAlign="Left"
                                FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" />
                            <asp:BoundField DataField="vertical" HeaderText="Vertical" HeaderStyle-HorizontalAlign="Left"
                                FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" />
                            <asp:BoundField DataField="mediatype" HeaderText="Media Type" HeaderStyle-HorizontalAlign="Left"
                                FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" />
                            <asp:BoundField DataField="clicks" HeaderText="Clicks" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="conversions" HeaderText="Conversions" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="convpct" HeaderText="Conv %" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p1}" />
                            <asp:BoundField DataField="billable" HeaderText="Billable" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="recieved" HeaderText="Revenue" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="ds_ClickReport" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_ClickReport" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:Parameter Name="from" DbType="DateTime" />
                            <asp:Parameter Name="to" DbType="DateTime" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

