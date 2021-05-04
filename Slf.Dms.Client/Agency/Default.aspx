<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Agency_Default"
    MasterPageFile="~/Agency/agency.master" Title="Payment Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphAgencyBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    
    <script language="javascript">     
        function RowClick_AgencyBatch(tr, CommBatchId, CompanyID, CommRecID) {
            var ifmAgencyBatches = document.getElementById('<%=ifmAgencyBatches.ClientID %>');

            ifmAgencyBatches.src = '<%=ResolveUrl("~/research/reports/financial/commission/batchdetail.aspx") %>?company=' + CompanyID + '&commrecid=' + CommRecID + '&commissionbatchids=' + CommBatchId;
        }

        function ShowRpt(CommRecID) {
            var ifmAgencyBatches = document.getElementById('<%=ifmAgencyBatches.ClientID %>');
            var id = '<%=UserID %>';
            var company = '<%=CompanyID %>';

            ifmAgencyBatches.src = '<%=ResolveUrl("~/research/reports/financial/accounting/default_nomaster.aspx") %>?rpt=disb_2&id=' + id + '&c=' + company;
        }

        function ShowAgencyLink(url) {
            var ifmAgencyBatches = document.getElementById('<%=ifmAgencyBatches.ClientID %>');

            ifmAgencyBatches.src = url;
        }

        function ShowInitialDraft(UserID) {
            var ifmAgencyBatches = document.getElementById('<%=ifmAgencyBatches.ClientID %>');
            var ip = '<%=UsersIP %>';

            if (ip.indexOf('192.168.') > -1) {
                ifmAgencyBatches.src = 'http://lex-srv-sql1/Reportserver?%2fBouncedDrafts%2fBouncedDraftReport3&rs:Command=Render&UserID=' + UserID;
            }
            else {
                ifmAgencyBatches.src = 'http://74.212.234.30/Reportserver?%2fBouncedDrafts%2fBouncedDraftReport3&rs:Command=Render&UserID=' + UserID;
            }
        }    
    </script>
    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
        <tr>
            <td valign="top" style="width: 150px">
                <table style="table-layout: fixed; font-family: tahoma; font-size: 11px; width: 180px;"
                    cellpadding="5" cellspacing="0" border="0">
                    <%--<asp:PlaceHolder ID="phAgencyReports" runat="server">
                        <tr>
                            <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-x;
                                background-position: left center;">
                                <img id="Img40" height="20" width="1" runat="server" src="~/images/spacer.gif" />
                            </td>
                        </tr>
                        <tr>
                            <td style="background-color: #f1f1f1; font-weight: bold;">
                                Agency Reports
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="width: 100%;">
                                <a class="lnk" href="#" onclick="javascript:ShowRpt('<%=CommRecId %>');">
                                    <img id="Img41" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server"
                                        border="0" align="absmiddle" />Disbursement Report</a>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="width: 100%;">
                                <a class="lnk" href="#" onclick="javascript:ShowInitialDraft('<%=UserID %>');">
                                    <img id="Img1" style="margin-right: 5;" src="~/images/16x16_report.png" runat="server"
                                        border="0" align="absmiddle" />Initial Draft Status</a>
                            </td>
                        </tr>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="phAgencyCommission" runat="server">
                        <tr>
                            <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-x;
                                background-position: left center;">
                                <img id="Img13" height="20" width="1" runat="server" src="~/images/spacer.gif" />
                            </td>
                        </tr>
                        <tr>
                            <td style="background-color: #f1f1f1; font-weight: bold;">
                                Agency Batches&nbsp;<a class="lnk" href="<%=ResolveURL("~/research/reports/financial/commission/batchpaymentsagency.aspx") %>"
                                    style="font-weight: normal; display: none;">(All Batches)</a>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="width: 100%;">
                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                    cellspacing="0">
                                    <tr>
                                        <td valign="top" style="width: 100%">
                                            <table style="font-family: tahoma; font-size: 11px; width: 100%" onmouseover="Grid_RowHover(this, true)"
                                                onmouseout="Grid_RowHover(this, false)" onselectstart="return false;" cellspacing="0"
                                                cellpadding="1" width="100%" border="0">
                                                <thead>
                                                    <tr>
                                                        <th class="StatHeadItem" nowrap align="left">
                                                            #
                                                        </th>
                                                        <th class="StatHeadItem" nowrap align="center">
                                                            Date
                                                        </th>
                                                        <th class="StatHeadItem" nowrap align="right">
                                                            Amount
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:Repeater ID="rpBatches" runat="server">
                                                        <ItemTemplate>
                                                            <tr onclick="RowClick_AgencyBatch(this.childNodes(0), <%#CType(Container.DataItem,BatchEntry).CommBatchId %>, '<%#CType(Container.DataItem,BatchEntry).Company %>', <%#CType(Container.DataItem,BatchEntry).CommRecID %>);"
                                                                title="<%#CType(Container.DataItem,BatchEntry).CommRec %>">
                                                                <td style="cursor: pointer" class="StatListItem" nowrap="true">
                                                                    <%#CType(Container.DataItem, BatchEntry).CommBatchId%>
                                                                </td>
                                                                <td style="cursor: pointer" class="StatListItem" nowrap="true" align="center">
                                                                    <%#CType(Container.DataItem, BatchEntry).BatchDate.ToString("MMM d, yy")%>
                                                                </td>
                                                                <td style="cursor: pointer" class="StatListItem" align="right">
                                                                    <%#CType(Container.DataItem, BatchEntry).Amount.ToString("c")%>
                                                                </td>
                                                            </tr>
                                                            <tr hover="false">
                                                                <td colspan="3" style="height: 2; background-image: url(<%= ResolveUrl("~/images/dot.png") %>);
                                                                    background-position: bottom bottom; background-repeat: repeat-x;">
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                            <asp:Panel ID="pnlNone" Style="text-align: center; padding: 20 5 5 5;" Visible="false"
                                                runat="server">
                                                You have no Batches.</asp:Panel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle" align="right" id="tdTotal" style="height: 21; padding-right: 2px;
                                            font-weight: bold" runat="server">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </asp:PlaceHolder>--%>
                </table>
            </td>
<%--            <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-y;
                background-position: center top;">
                <img id="Img15" width="3" height="1" runat="server" src="~/images/spacer.gif" />
            </td>--%>
            <td valign="top" style="width: 90%;">
                <iframe id="ifmAgencyBatches" runat="server" style="width: 100%; height: 100%;" frameborder="0"
                    scrolling="auto" src="Overview.aspx">
                </iframe>
            </td>
        </tr>
    </table>
</asp:Content>
