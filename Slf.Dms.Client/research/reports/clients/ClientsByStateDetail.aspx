<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/reports.master"
    AutoEventWireup="false" CodeFile="ClientsByStateDetail.aspx.vb" Inherits="research_reports_clients_ClientsByStateDetail" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
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
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        margin: 15px;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="color: #666666; padding-bottom: 15px;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;<a
                        id="A3" runat="server" class="lnk" style="color: #666666;" href="~/research/reports/clients">Clients</a>&nbsp;>&nbsp;<a
                            id="A4" runat="server" class="lnk" style="color: #666666;" href="~/research/reports/clients/clientsbystate.aspx">Clients
                            by State</a>&nbsp;>&nbsp;State Detail
            </td>
        </tr>
        <tr>
            <td style="background-color: #f3f3f3; padding: 5 5 5 8;">
                <a id="aBack" runat="server" href="clientsbystate.aspx" class="lnk">Back</a>
            </td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CellPadding="5"
                    Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                    DataSourceID="ds_Clients" DataKeyNames="clientid">
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="16px">
                            <HeaderTemplate>
                                &nbsp;
                            </HeaderTemplate>
                            <ItemTemplate>
                                <img src="~/images/16x16_person.png" runat="server" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="headItem" />
                            <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Name" DataField="name" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                        <asp:BoundField HeaderText="Street" DataField="street" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                        <asp:BoundField HeaderText="City" DataField="city" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                        <asp:BoundField HeaderText="State" DataField="state" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                        <asp:BoundField HeaderText="Status" DataField="status" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                    </Columns>
                    <EmptyDataTemplate>
                        No clients exist.
                    </EmptyDataTemplate>
                </asp:GridView>
            </td>
        </tr>
    </table>
    <asp:SqlDataSource ID="ds_Clients" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
        SelectCommand="stp_ClientsByState" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter Name="companyid" QueryStringField="companyid" Type="Int16" />
            <asp:QueryStringParameter Name="stateid" QueryStringField="stateid" Type="Int16" />
            <asp:QueryStringParameter Name="groupid" QueryStringField="groupid" Type="Int16" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
