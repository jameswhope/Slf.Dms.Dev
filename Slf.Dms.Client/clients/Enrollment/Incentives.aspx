<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="Incentives.aspx.vb" Inherits="Clients_Enrollment_Incentives" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <!--#include file="mgrtoolbar.inc"-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .creditor-item
        {
            border-bottom: solid 1px #d3d3d3;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
        }
        .headItem
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
        }
        .headItem a
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            color: #000000;
            text-decoration: underline;
        }
    </style>
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 600px;
                margin: 15px;" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <h4>
                            Client Intake Reps</h4>
                        <asp:GridView ID="gvReps" runat="server" AutoGenerateColumns="false" CellPadding="5"
                            Width="520px" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                            DataSourceID="ds_Overview" AllowSorting="true">
                            <Columns>
                                <asp:TemplateField ItemStyle-Width="16px">
                                    <HeaderTemplate>
                                        <img id="imgTree" runat="server" src="~/images/16x16_icon.png" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img id="imgTree" runat="server" src="~/images/16x16_person2.png" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Rep" DataField="rep" ItemStyle-CssClass="creditor-item"
                                    HeaderStyle-CssClass="headItem" SortExpression="Rep" />
                                <asp:BoundField HeaderText="Last Incentive Approved" DataField="lastincentive" ItemStyle-CssClass="creditor-item"
                                    HeaderStyle-CssClass="headItem" DataFormatString="{0:d}" SortExpression="LastIncentive" />
                                <asp:BoundField HeaderText="Last Client Created" DataField="lastclient" ItemStyle-CssClass="creditor-item"
                                    HeaderStyle-CssClass="headItem" DataFormatString="{0:d}" SortExpression="LastClient" />
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            <asp:SqlDataSource ID="ds_Overview" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                SelectCommand="stp_IncentivesOverview" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
