<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="conversions.aspx.vb" Inherits="admin_conversions" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

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
                $(".portlet-header .ui-icon-gear").click(function() {
                    $('.jqDateTbl').toggle();
                });
            });
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    Conversions
                </div>
                <div class="portlet-content">
                    <div style="padding: 10px; float: left">
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                            <ProgressTemplate>
                                <img id="Img1" src="~/images/ajax-loader.gif" alt="Loading.." runat="server" />
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
                                    <asp:TextBox ID="txtDate1" runat="server" Size="7" MaxLength="10" Font-Size="12pt"></asp:TextBox>&nbsp;-&nbsp;<asp:TextBox
                                        ID="txtDate2" runat="server" MaxLength="10" Size="7" Font-Size="12pt"></asp:TextBox>
                                </td>
                                <td>
                                    <small>
                                        <asp:Button ID="btnApply" runat="server" Text="Apply" Font-Size="10pt" CssClass="jqButton" />
                                    </small>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div style="clear:both">
                    </div>
                    <asp:GridView ID="gvConversions" runat="server" AutoGenerateColumns="false" GridLines="None"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" Width="100%" DataSourceID="ds_Conversions"
                        ShowFooter="true" CellPadding="5" AllowSorting="true">
                        <Columns>
                            <asp:BoundField DataField="Offer" HeaderText="Offer" HeaderStyle-HorizontalAlign="Left" SortExpression="Offer"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem" />
                            <asp:BoundField DataField="Buyer" HeaderText="Buyer" HeaderStyle-HorizontalAlign="Left" SortExpression="Buyer"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem" />
                            <asp:BoundField DataField="Conversions" HeaderText="Conversions" HeaderStyle-HorizontalAlign="Right" SortExpression="Conversions"
                                FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="Cap" HeaderText="Daily Cap" HeaderStyle-HorizontalAlign="Right" SortExpression="Cap"
                                FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="conv_pct" HeaderText="%" HeaderStyle-HorizontalAlign="Right" SortExpression="conv_pct"
                                FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p0}" />
                            <asp:BoundField DataField="RPT" HeaderText="RPT" HeaderStyle-HorizontalAlign="Right" SortExpression="RPT"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" />
                            <asp:BoundField DataField="Revenue" HeaderText="Revenue" HeaderStyle-HorizontalAlign="Right" SortExpression="Revenue"
                                HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="ds_Conversions" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_ConversionsRpt" SelectCommandType="StoredProcedure">
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
