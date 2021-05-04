<%@ Page Language="VB" MasterPageFile="~/negotiation/Negotiation.master" AutoEventWireup="false"
    EnableEventValidation="false" CodeFile="Default.aspx.vb" Inherits="negotiation_Default" %>
<%@ MasterType TypeName="negotiation_Negotiation" %>
<%@ Register Src="webparts/SettlementStatisticsControl.ascx" TagName="SettlementStatisticsControl"
    TagPrefix="LexxControl" %>
<%@ Register Src="~/negotiation/webparts/ClientSearchControl.ascx" TagName="ClientSearchControl"
    TagPrefix="LexxControl" %>
<%@ Register Src="~/negotiation/webparts/AvailableNegotiationsControl.ascx" TagName="AvailableNegotiations"
    TagPrefix="LexxControl" %>
<%@ Register TagPrefix="LexxControl" TagName="RecentVisits" Src="~/negotiation/webparts/RecentVisits.ascx" %>
<%@ Register TagPrefix="LexxControl" TagName="RecentSearches" Src="~/negotiation/webparts/RecentSearches.ascx" %>
<%@ Register TagPrefix="LexxControl" TagName="SearchResults" Src="~/negotiation/webparts/SearchResults.ascx" %>
<%@ Register Src="webparts/RecentDialerCalls.ascx" TagName="RecentDialerCalls" TagPrefix="uc1" %>

<%@ Register Src="../CustomTools/UserControls/SwitchUserGroup.ascx" TagName="SwitchUserGroup"
    TagPrefix="uc2" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .creditor-item
        {
            border-bottom: solid 1px #d3d3d3;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            color: Black;
            padding: 2;
        }
        .headItem
        {
            background-color: #e1e1e1;
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: Black;
            text-align: left;
            padding: 2;
        }
    </style>

    <script language="javascript" type="text/javascript">
        function toggleDocument(docName, gridviewID, c, id) {
            var rowName = 'tr_' + docName;
            var gv = document.getElementById(gridviewID);
            var rows = gv.getElementsByTagName('tr');
            for (var row in rows) {
                var rowID = rows[row].id
                if (rowID != undefined) {
                    if (rowID.indexOf(rowName + '_child') != -1) {
                        rows[row].style.display = (rows[row].style.display != 'none' ? 'none' : '');
                    }

                    if (rowID == id) {
                        if (rows[row].cells[c].children[0] != undefined) {
                            var tree = rows[row].cells[c].children[0].src;
                            rows[row].cells[c].children[0].src = (tree.indexOf('tree_plus') != -1 ? tree.replace('tree_plus', 'tree_minus') : tree.replace('tree_minus', 'tree_plus'));
                        }
                    }
                }
            }
        }
        
    </script>

    <table>
        <tr>
            <td valign="top" style="width:200px">
                <div class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_search,this)" title="Click to Minimize the table" />
                        Search
                    </h1>
                    <div id="div_search" class="collapsable" style="display: block">
                        <p>
                            &nbsp;<LexxControl:ClientSearchControl ID="cscSearch" runat="server" />
                    </div>
                </div>
                <div class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_recentsearches,this)" title="Click to Minimize the table" />
                        Recent Searches
                    </h1>
                    <div id="div_recentsearches" class="collapsable" style="display: block">
                        <p>
                            &nbsp;<LexxControl:RecentSearches ID="rcRecentSearches" runat="server" />
                    </div>
                </div>
                <div class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_recentvisits,this)" title="Click to Minimize the table" />
                        Recent Visits
                    </h1>
                    <div id="div_recentvisits" class="collapsable" style="display: block">
                        <p>
                            <LexxControl:RecentVisits ID="rvRecentVisits" runat="server" />
                        </p>
                    </div>
                </div>
            </td>
            <td valign="top">
                <div class="ibox nego">
                    <h1 id="hMyAssignments" runat="server">
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_availablenegotiations,this)" title="Click to Minimize the table" />
                        My Assignments
                    </h1>
                    <div id="div_availablenegotiations" class="collapsable" style="display: block">
                        <p>
                            &nbsp;<LexxControl:AvailableNegotiations ID="pncPendingNegotiations" runat="server"
                                ListLocation="HomePage" />
                    </div>
                </div>
                <div class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_searchresults,this)" title="Click to Minimize the table" />
                        Search Results
                    </h1>
                    <div id="div_searchresults" class="collapsable" style="display: block">
                        <p>
                            &nbsp;<LexxControl:SearchResults ID="srSearchResults" runat="server" />
                    </div>
                </div>
                <div class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_mystats,this)" title="Click to Minimize the table" />
                        My Stats
                    </h1>
                    <div id="div_mystats" class="collapsable" style="display: block">
                        <p style="padding: 5px;">
                            <table class="entry2" id="tblstats" runat="server">
                                <tr id="trAttachSif" runat="server">
                                    <td align="left">
                                        <asp:LinkButton ID="lnkAttachSIF" runat="server" Text="Settlements Waiting on SIF"
                                            CssClass="entry2" />
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td>
                                        <asp:Label ID="lnkAttachSIFCnt" runat="server" Text="0" CssClass="entry2" />
                                    </td>
                                </tr>
                                <tr id="trCheckByTel" runat="server">
                                    <td align="left">
                                        <asp:LinkButton ID="lnkChkByTel" runat="server" Text="Checks By Phone ready to process"
                                            CssClass="entry2" />
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td>
                                        <asp:Label ID="lnkChkByTelCnt" runat="server" Text="0" CssClass="entry2" />
                                    </td>
                                </tr>
                                <tr id="trSettOver" runat="server">
                                    <td align="left">
                                        <asp:LinkButton ID="lnkOver" runat="server" Text="Settlements Over Client Balance"
                                            CssClass="entry2" />
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td>
                                        <asp:Label ID="lblOverCnt" runat="server" Text="0" CssClass="entry2" />
                                    </td>
                                </tr>
                                <tr id="trClientStip" runat="server">
                                    <td align="left">
                                        <asp:LinkButton ID="lnkStip" runat="server" Text="Settlements w/ Client Stipulations"
                                            CssClass="entry2" />
                                    </td>
                                    <td>
                                        :
                                    </td>
                                    <td>
                                        <asp:Label ID="lblStipCnt" runat="server" Text="0" CssClass="entry2" />
                                    </td>
                                </tr>
                            </table>
                            
                                
                            <%-- 
                            <LexxControl:SettlementStatisticsControl ID="SettlementStatisticsControl1" runat="server" />
                            --%>
                        </p>
                    </div>
                </div>
                <div id="divSwitchGroupBox" runat="server" class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_SwitchGroup,this)" title="Click to Minimize the table" />
                        Switch Group
                    </h1>
                    <div id="div_SwitchGroup" class="collapsable" style="display: block">
                        <p>
                            <uc2:SwitchUserGroup ID="SwitchUserGroup1" runat="server" />
                        </p>
                    </div>
                </div>
                <div id="divVerification" runat="server" class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_Verification,this)" title="Click to Minimize the table"
                            alt="" />
                        Verification History
                    </h1>
                    <div id="div_Verification" class="collapsable" style="display: block">
                        <div style="overflow: auto; height: 210px;">
                            <asp:GridView ID="gvVerificationHistory" runat="server" AutoGenerateColumns="false"
                                CellPadding="5" Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None"
                                Visible="true" DataSourceID="ds_VerificationHistory">
                                <Columns>
                                    <asp:TemplateField ItemStyle-Width="16px">
                                        <HeaderTemplate>
                                            <img id="Img1" runat="server" src="~/images/16x16_icon.png" alt="" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <img id="imgTreeDate" runat="server" src="~/images/tree_plus.bmp" alt="" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem" />
                                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Completed" DataField="completed" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" DataFormatString="{0:d}" ItemStyle-Width="80px" />
                                    <asp:TemplateField ItemStyle-Width="16px">
                                        <HeaderTemplate>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <img id="imgTreeCompany" runat="server" src="~/images/tree_plus.bmp" alt="" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem" />
                                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="" DataField="company" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" ItemStyle-Width="80px" />
                                    <asp:TemplateField ItemStyle-Width="16px">
                                        <HeaderTemplate>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <img id="imgTreeRep" runat="server" src="~/images/tree_plus.bmp" alt="" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem" />
                                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="" DataField="rep" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" ItemStyle-Width="130px" />
                                    <asp:BoundField HeaderText="" DataField="client" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" ItemStyle-Width="210px" />
                                    <asp:BoundField HeaderText="Clients" DataField="clients" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="ibox nego">
                    <h1>
                        <img src="images/minimize_off.png" width="20" height="22" border="0" align="right"
                            style="cursor: hand;" onclick="dyntog(div_lastdialercalls,this)" title="Click to Minimize the table" />
                        Recent Dialer Calls
                    </h1>
                    <div id="div_lastdialercalls" class="collapsable" style="display: block">
                        <p>
                            <uc1:RecentDialerCalls ID="RecentDialerCalls1" runat="server" />
                        </p>
                    </div>
            </td>
        </tr>
    </table>
    <asp:SqlDataSource ID="ds_VerificationHistory" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
        SelectCommandType="StoredProcedure" SelectCommand="stp_VerificationHistory">
    </asp:SqlDataSource>
</asp:Content>
