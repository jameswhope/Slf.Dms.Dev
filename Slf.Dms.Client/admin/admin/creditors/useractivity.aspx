<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="useractivity.aspx.vb" Inherits="admin_creditors_useractivity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td nowrap="nowrap">
                <a class="menuButton" href="../">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_admin.png" alt="Admin Home" />Admin Home</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="true">
                <a class="menuButton" href="creditorvalidation.aspx" runat="server">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_check.png" />Validate Creditors</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="true">
                <a class="menuButton" runat="server" href="validationstats.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_chart_bar.png" />Creditor Stats</a>
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:Panel runat="server" ID="pnlMain" Style="width: 100%; height: 100%; padding: 15px;">
        <style type="text/css">
            .creditor-item
            {
                border-bottom: dotted 1px #d3d3d3;
                white-space: nowrap;
                font-family: Tahoma;
                font-size: 11px;
            }
            .creditor-item2
            {
                border-bottom: dotted 1px #d3d3d3;
                white-space: nowrap;
                font-family: Tahoma;
                font-size: 11px;
                text-align: center;
            }
            .headItem
            {
                font-family: Tahoma;
                font-size: 11px;
                font-weight: normal;
                text-align: left;
            }
            .headItem2
            {
                font-family: Tahoma;
                font-size: 11px;
                font-weight: normal;
                text-align: center;
                background-color: #dcdcdc;
            }
            .footerItem
            {
                white-space: nowrap;
                font-family: Tahoma;
                font-size: 11px;
                text-align: center;
                font-weight: bold;
            }
        </style>
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="padding-bottom: 7px;">
                    <b>User Activity Since 10/6/09</b>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CellPadding="5"
                        Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                        DataSourceID="dsStats" ShowFooter="true" DataKeyNames="CreatedBy">
                        <Columns>
                            <asp:TemplateField ItemStyle-CssClass="creditor-item" ItemStyle-Width="16px">
                                <HeaderTemplate>
                                    <img runat="server" src="~/images/16x16_icon.png" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <img runat="server" src="~/images/16x16_person.png" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="headItem" />
                                <ItemStyle CssClass="creditor-item" />
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="User" DataField="name" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="Dept" DataField="dept" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="Validated" DataField="validated" ItemStyle-CssClass="creditor-item2"
                                HeaderStyle-CssClass="headItem2" FooterStyle-CssClass="footerItem" />
                            <asp:BoundField HeaderText="Approved" DataField="approved" ItemStyle-CssClass="creditor-item2"
                                HeaderStyle-CssClass="headItem2" FooterStyle-CssClass="footerItem" />
                            <asp:BoundField HeaderText="Duplicates" DataField="duplicates" ItemStyle-CssClass="creditor-item2"
                                HeaderStyle-CssClass="headItem2" FooterStyle-CssClass="footerItem" />
                            <asp:BoundField HeaderText="Pending" DataField="pending" ItemStyle-CssClass="creditor-item2"
                                HeaderStyle-CssClass="headItem2" FooterStyle-CssClass="footerItem" />
                            <asp:BoundField HeaderText="Total" DataField="total" ItemStyle-CssClass="creditor-item2"
                                HeaderStyle-CssClass="headItem2" FooterStyle-CssClass="footerItem" />
                            <asp:BoundField HeaderText="Last Insertion" DataField="lastinsertion" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
        <asp:SqlDataSource ID="dsStats" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
            SelectCommand="stp_CreditorHistoryStats" SelectCommandType="StoredProcedure">
        </asp:SqlDataSource>
    </asp:Panel>
</asp:Content>
