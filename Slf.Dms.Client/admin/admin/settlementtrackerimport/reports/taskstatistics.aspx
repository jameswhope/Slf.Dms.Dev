<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="taskstatistics.aspx.vb" Inherits="admin_settlementtrackerimport_reports_taskstatistics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript">
        function ExportExcel() {
            try {
                var oExcel = new ActiveXObject("Excel.Application");
                var oBook = oExcel.Workbooks.Add;
                var oSheet = oBook.Worksheets(1);
                var detailsTable = document.getElementById('tblDetail');
                for (var y = 0; y < detailsTable.rows.length; y++) {
                    for (var x = 0; x < detailsTable.rows(y).cells.length; x++) {
                        oSheet.Cells(y + 1, x + 1) = detailsTable.rows(y).cells(x).innerText;
                    }
                }
                oExcel.Visible = true;
                oExcel.UserControl = true;
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
        }
        function ShowDetailData(detailData) {
            var ld = document.getElementById('divLoading');
            ld.style.display = 'block';

            var div = document.getElementById('<%=divDetailData.ClientID %>');
            div.style.display = 'none';

            //get accounts
            PageMethods.PM_getDetailData(detailData, OnRequestComplete, OnRequestError);
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.show();

        }
        function ClosePopup() {
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.hide();
            return false;
        }
        function OnRequestError(error, userContext, methodName) {
            if (error != null) {
                alert(error.get_message());
            }
        }
        function OnRequestComplete(result, userContext, methodName) {
            var ddObj = eval('(' + result + ')');

            var lbl = document.getElementById('<%= lblTerm.ClientID %>');
            lbl.innerHTML = ddObj.GridCaption;

            var div = document.getElementById('<%=divDetailData.ClientID %>');
            div.style.display = 'block';
            var ld = document.getElementById('divLoading');
            ld.style.display = 'none';
            div.innerHTML = ddObj.GridviewData;
        }    

    function YearChanged(YearSelect) {
        var chosenoption = YearSelect.options[YearSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnYear.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeYear, nothing) %>;
        }
    }

    </script>

    <table runat="server" id="tblBody" style="font-family: Arial; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport/">Settlement
                    Tracker Import</a>&nbsp;>&nbsp;Task Statistics
            </td>
        </tr>
        <tr>
            <td>
                <table class="entry">
                    <tr style="vertical-align: top;">
                        <td>
                            <asp:GridView ID="gvSettlementPipeline" runat="server" AutoGenerateColumns="False"
                                CssClass="entry" DataSourceID="dsSettlementPipeline" AllowSorting="True" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Settlement Pipeline</div>">
                                <Columns>
                                    <asp:BoundField DataField="MonthNumber" HeaderText="MonthNumber" SortExpression="MonthNumber"
                                        Visible="false" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="YearNumber" HeaderText="Year" SortExpression="YearNumber"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="MonthName" HeaderText="Month" SortExpression="MonthName"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Offers" HeaderText="Offers" SortExpression="Offers" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Submitted: With Funds" HeaderText="Submitted: With Funds"
                                        ReadOnly="True" SortExpression="Submitted: With Funds" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" ItemStyle-BackColor="#E2E2E2" HeaderStyle-BackColor="#E2E2E2"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Submitted: Future Deposit" HeaderText="Submitted: Future Deposit"
                                        ReadOnly="True" SortExpression="Submitted: Future Deposit" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" ItemStyle-BackColor="#E2E2E2" HeaderStyle-BackColor="#E2E2E2"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Submitted: Shortage" HeaderText="Submitted: Shortage"
                                        ReadOnly="True" SortExpression="Submitted: Shortage" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" ItemStyle-BackColor="#E2E2E2" HeaderStyle-BackColor="#E2E2E2"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Waiting: SIF" HeaderText="Waiting: SIF" ItemStyle-BackColor="#EAF1DD"
                                        HeaderStyle-BackColor="#EAF1DD" SortExpression="Waiting: SIF" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Waiting: MGR" HeaderText="Waiting: MGR" ItemStyle-BackColor="#EAF1DD"
                                        HeaderStyle-BackColor="#EAF1DD" SortExpression="Waiting: MGR" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Waiting: Client" HeaderText="Waiting: Client" ItemStyle-BackColor="#EAF1DD"
                                        HeaderStyle-BackColor="#EAF1DD" SortExpression="Waiting: Client" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Waiting: Accounting" ItemStyle-BackColor="#EAF1DD" HeaderStyle-BackColor="#EAF1DD"
                                        HeaderText="Waiting: Accounting" SortExpression="Waiting: Accounting" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Waiting: Deposit" HeaderText="Waiting: Deposit" ItemStyle-BackColor="#EAF1DD"
                                        HeaderStyle-BackColor="#EAF1DD" SortExpression="Waiting: Deposit" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Waiting: LC/SA Approval" ItemStyle-BackColor="#EAF1DD"
                                        HeaderStyle-BackColor="#EAF1DD" HeaderText="Waiting: LC/SA Approval" SortExpression="Waiting: LC/SA Approval"
                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Processing: Chk By Phone" HeaderText="Processing: Chk By Phone"
                                        SortExpression="Processing: Chk By Phone" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Processing: Email" HeaderText="Processing: Email" SortExpression="Processing: Email"
                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Processing: Print" HeaderText="Processing: Print" SortExpression="Processing: Print"
                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" />
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsSettlementPipeline" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_settlementpipeline">
                                <SelectParameters>
                                    <asp:Parameter Name="year" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:GridView ID="gvSettlementResolution" runat="server" AutoGenerateColumns="False"
                                CssClass="entry" DataSourceID="dsSettlementResolution" AllowSorting="True" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Settlement Resolution</div>">
                                <Columns>
                                    <asp:BoundField DataField="MonthNumber" HeaderText="MonthNumber" SortExpression="MonthNumber"
                                        Visible="false" />
                                    <asp:BoundField DataField="YearNumber" HeaderText="Year" SortExpression="YearNumber"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="MonthName" HeaderText="Month" SortExpression="MonthName"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Rejected/Cancelled: By Client" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" HeaderText="Rejected/Cancelled: By Client" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" SortExpression="Rejected/Cancelled: By Client"
                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Rejected/Cancelled: By Mgr" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" HeaderText="Rejected/Cancelled: By Mgr" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" SortExpression="Rejected/Cancelled: By Mgr" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Rejected/Cancelled: By Atty" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" HeaderText="Rejected/Cancelled: By Atty" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" SortExpression="Rejected/Cancelled: By Atty" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Rejected/Cancelled: By Creditor" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" HeaderText="Rejected/Cancelled: By Creditor"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" SortExpression="Rejected/Cancelled: By Creditor"
                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Expired: No SIF" HeaderText="Expired: No SIF" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" SortExpression="Expired: No SIF" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Expired: In Mgr Queue" ItemStyle-BackColor="#E6B9B8" HeaderStyle-BackColor="#E6B9B8"
                                        HeaderText="Expired: In Mgr Queue" SortExpression="Expired: In Mgr Queue" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Expired: No Client Approval" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                        HeaderText="Expired: No Client Approval" SortExpression="Expired: No Client Approval"
                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Expired: In Accounting" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                        HeaderText="Expired: In Accounting" SortExpression="Expired: In Accounting" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Expired: No Deposit" ItemStyle-BackColor="#E6B9B8" HeaderStyle-BackColor="#E6B9B8"
                                        HeaderText="Expired: No Deposit" SortExpression="Expired: No Deposit" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Expired: No LC/SA Approval" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" HeaderText="Expired: No LC/SA Approval" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" SortExpression="Expired: No LC/SA Approval" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" />
                                    <asp:BoundField DataField="Paid: Matter" HeaderText="Paid: Matter" ItemStyle-BackColor="#D7E4BC"
                                        HeaderStyle-BackColor="#D7E4BC" SortExpression="Paid: Matter" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Paid: Manual" HeaderText="Paid: Manual" ItemStyle-BackColor="#D7E4BC"
                                        HeaderStyle-BackColor="#D7E4BC" SortExpression="Paid: Manual" HeaderStyle-HorizontalAlign="Center"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Paid: Total" HeaderText="Paid: Total" ItemStyle-BackColor="#D7E4BC"
                                        HeaderStyle-BackColor="#D7E4BC" ReadOnly="True" SortExpression="Paid: Total"
                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" />
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsSettlementResolution" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_settlementResolution">
                                <SelectParameters>
                                    <asp:Parameter Name="year" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:GridView ID="gvSettlementReceivables" runat="server" AutoGenerateColumns="False"
                                CssClass="entry" DataSourceID="dsSettlementReceivables" AllowSorting="True" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;'>Settlement Receivables</div>">
                                <Columns>
                                    <asp:BoundField DataField="MonthNumber" HeaderText="MonthNumber" SortExpression="MonthNumber"
                                        Visible="false" />
                                    <asp:BoundField DataField="YearNumber" HeaderText="Year" SortExpression="YearNumber"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="MonthName" HeaderText="MonthName" SortExpression="MonthName"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="In Month: Earned" HeaderText="In Month: Earned" SortExpression="In Month: Earned"
                                        HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c2}"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="In Month: Collected" HeaderText="In Month: Collected"
                                        SortExpression="In Month: Collected" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                                        DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="In Month: Difference" HeaderText="In Month: Difference"
                                        ReadOnly="True" SortExpression="In Month: Difference" HeaderStyle-HorizontalAlign="Right"
                                        ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Balance: Receivables" HeaderText="Balance: Receivables"
                                        SortExpression="Balance: Receivables" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                                        DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Collected: Receivables" HeaderText="Collected: Receivables"
                                        SortExpression="Collected: Receivables" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                                        DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="Uncollectable" HeaderText="Uncollectable" ItemStyle-BackColor="#E6B9B8"
                                        HeaderStyle-BackColor="#E6B9B8" SortExpression="Uncollectable" HeaderStyle-HorizontalAlign="Right"
                                        ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5"
                                        ItemStyle-CssClass="listItem" />
                                    <asp:BoundField DataField="New: Receivables" HeaderText="New: Receivables" ItemStyle-BackColor="#D7E4BC"
                                        HeaderStyle-BackColor="#D7E4BC" ReadOnly="True" SortExpression="New: Receivables"
                                        HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c2}"
                                        HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" />
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsSettlementReceivables" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_settlementimport_reports_SettlementReceivables">
                                <SelectParameters>
                                    <asp:Parameter Name="year" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Button ID="dummyButton" runat="server" Text="Button" Style="display: none" />
    <ajaxToolkit:ModalPopupExtender ID="mpeData" runat="server" TargetControlID="dummyButton"
        PopupControlID="pnlPopup" BackgroundCssClass="modalBackgroundTracker" BehaviorID="programmaticModalPopupBehavior"
        RepositionMode="RepositionOnWindowResizeAndScroll" PopupDragHandleControlID="programmaticPopupDragHandle"
        Y="50">
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopupTracker" Style="display: none;
        border-collapse: collapse;width: 100%;">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #3D3D3D;
                    border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
                    <div id="dvCloseMenu" runat="server" onmouseover="this.style.cursor='hand';" style="padding: 3px;
                        width: 100%; background-color: #3D3D3D; z-index: 51; text-align: right; vertical-align: middle;
                        border-collapse: collapse;" ondblclick="return ClosePopup();">
                        <div style="float: left; color: White;">
                            Statistics Detail Data</div>
                        <asp:Image ID="imgClose" runat="server" ImageUrl="~/images/16x16_close.png" onclick="return ClosePopup();" />
                    </div>
                </asp:Panel>
                <table class="entry" style="height: 100%">
                    <tr valign="top">
                        <td style="height: 400px;">
                            <asp:Panel ID="pnlInfo" runat="server" CssClass="entry" Style="background-color: #66CCFF;">
                                <asp:Label ID="lblTerm" runat="server" Text="" Font-Size="12px" />
                            </asp:Panel>
                            <div id="divLoading" style="display: block; text-align: center; padding-top: 100px;"
                                class="entry">
                                Loading...<br />
                                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/loading.gif" />
                            </div>
                            <div id="divDetailData" runat="server" style="height: 400px; overflow-y: scroll;
                                overflow-x: hidden; display: none;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color: #DCDCDC">
                            <table class="entry" border="0">
                                <tr>
                                    <td align="right" style="background-color: #DCDCDC">
                                        <table class="entry" border="0">
                                            <tr style="white-space: nowrap; font-size: 12px;">
                                                <td style="text-align: left; padding: 3px;">
                                                    <asp:LinkButton ID="lnkExportExcel" runat="server" Text="Export to Excel" CssClass="lnk"
                                                        OnClientClick="ExportExcel();" />
                                                </td>
                                                <td style="text-align: right; padding: 3px;">
                                                    <asp:LinkButton ID="btnClose" runat="server" Text="Close" CssClass="lnk" OnClientClick="return ClosePopup();" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />
</asp:Content>

