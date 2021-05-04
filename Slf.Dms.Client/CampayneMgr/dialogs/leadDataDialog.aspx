<%@ Page Title="" Language="VB" MasterPageFile="~/dialogs/dialog.master" AutoEventWireup="false"
    CodeFile="leadDataDialog.aspx.vb" Inherits="dialogs_leadDataDialog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="dialogHeadCnt" runat="Server">
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                //alert('ready');
                $(".jqFirstButton").button({
                    icons: {
                        primary: "ui-icon-seek-first"
                    },
                    text: false
                });
                $(".jqPrevButton").button({
                    icons: {
                        primary: "ui-icon-seek-prev"
                    },
                    text: false
                });
                $(".jqNextButton").button({
                    icons: {
                        primary: "ui-icon-seek-next"
                    },
                    text: false
                });
                $(".jqLastButton").button({
                    icons: {
                        primary: "ui-icon-seek-end"
                    },
                    text: false
                });
            });
        }
        function popup(data) {
            $("body").append('<form id="exportform" action="../Handlers/CsvExport.ashx?f=LeadData" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }
        function ExportExcel() {
            try {
                var csv_value = $("*[id$='gvData']").table2CSV({ delivery: 'value' });
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphDialogBody" runat="Server">
    <asp:UpdatePanel ID="upData" runat="server">
        <ContentTemplate>
            <div id="divInfo" runat="server" />
            <asp:LinkButton ID="lnkExport" runat="server" Text="Export to Excel" OnClientClick="ExportExcel();" />

            <asp:GridView ID="gvData" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                DataKeyNames="leadid" DataSourceID="dsData" PageSize="20" Width="100%">
                <EmptyDataTemplate>
                    <div class="ui-state-highlight ui-corner-all" style="padding: 10px; margin: 10px;">
                        No Data
                    </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="leadid" HeaderText="leadid" InsertVisible="False" ReadOnly="True"
                        SortExpression="leadid">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FullName" HeaderText="FullName" SortExpression="FullName">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="City" HeaderText="City" SortExpression="City">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="StateCode" HeaderText="StateCode" SortExpression="StateCode">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ZipCode" HeaderText="ZipCode" SortExpression="ZipCode">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ResultCode" HeaderText="ResultCode" SortExpression="ResultCode">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ResultDesc" HeaderText="ResultDesc" SortExpression="ResultDesc">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Submitted" HeaderText="Submitted" SortExpression="Submitted">
                        <HeaderStyle CssClass="ui-widget-header" />
                        <ItemStyle CssClass="ui-widget-content" />
                    </asp:BoundField>
                </Columns>
                <PagerTemplate>
                    <div id="pager" style="background-color: #4c4f56">
                        <table style="width: 100%">
                            <tr>
                                <td style="padding-left: 10px; text-align: center">
                                    <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                        ID="btnFirst" CssClass="jqFirstButton" />
                                    <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                        ID="btnPrevious" CssClass="jqPrevButton" />
                                    Page
                                    <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" Enabled="true" />
                                    of
                                    <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                    <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                        ID="btnNext" CssClass="jqNextButton" />
                                    <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                        ID="btnLast" CssClass="jqLastButton" />
                                </td>
                                <td align="right">
                                </td>
                            </tr>
                        </table>
                    </div>
                </PagerTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="dsData" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                SelectCommand="stp_schoolcampaign_ShowLeadData" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:Parameter Name="SchoolCampaignID" Type="Int32" />
                    <asp:Parameter Name="ResultCode" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
