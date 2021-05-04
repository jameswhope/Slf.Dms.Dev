<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="unsold.aspx.vb" Inherits="reports_unsold" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" language="javascript">
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $(".jqButton").button();
            });
        }

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
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDate1" runat="server" Size="7" MaxLength="10"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate1" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                    TargetControlID="txtDate1" PopupButtonID="imgDate1" />&nbsp;-&nbsp;<asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="7"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate2" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                    TargetControlID="txtDate2" PopupButtonID="imgDate2" />&nbsp;&nbsp;
                            <asp:TextBox ID="txtTime1" runat="server" Size="7" MaxLength="8" Text="12:00 AM"></asp:TextBox>&nbsp;-&nbsp;<asp:TextBox
                                ID="txtTime2" runat="server" Size="7" MaxLength="8" Text="11:59 PM"></asp:TextBox>
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnApply" runat="server" Text="Apply" Font-Size="8pt" CssClass="jqButton" />
                            </small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvSummary" runat="server" AutoGenerateColumns="true" GridLines="None"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" Width="100%" HeaderStyle-CssClass="headitem3" RowStyle-CssClass="griditem2"
                        CellPadding="4" Caption="<div class='ui-widget-header'>Unsold Job Search Leads</div>">
                    </asp:GridView>
                    <br />
                    <asp:GridView ID="gvAttempts" runat="server" AutoGenerateColumns="false" GridLines="None"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" Width="100%"
                        CellPadding="4" Caption="<div class='ui-widget-header'>Attempts vs Sold</div>">
                        <Columns>
                            <asp:BoundField DataField="BuyerOfferXrefID" HeaderText="ID" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="Offer" HeaderText="Offer" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="Buyer" HeaderText="Buyer" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="ContractName" HeaderText="Contract" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="DailyCap" HeaderText="Current Cap" ItemStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem3" ItemStyle-CssClass="griditem3" HeaderStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="rt_attempts" HeaderText="Attempts" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="rt_accepted" HeaderText="Accepted" ItemStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="rt_rejected" HeaderText="Rejected" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="rt_rate" HeaderText="Rejection Rate" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem3" ItemStyle-CssClass="griditem3" ItemStyle-HorizontalAlign="Right"
                                DataFormatString="{0:p0}" />
                            <asp:BoundField DataField="a_attempts" HeaderText="Attempts" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="a_accepted" HeaderText="Accepted" ItemStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="a_rejected" HeaderText="Rejected" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="a_rate" HeaderText="Rejection Rate" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem3" ItemStyle-CssClass="griditem3" ItemStyle-HorizontalAlign="Right"
                                DataFormatString="{0:p0}" />
                            <asp:BoundField DataField="total_rate" HeaderText="Rejection Rate" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Right"
                                DataFormatString="{0:p0}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <asp:PlaceHolder ID="phrJsRunner" runat="server"></asp:PlaceHolder>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>