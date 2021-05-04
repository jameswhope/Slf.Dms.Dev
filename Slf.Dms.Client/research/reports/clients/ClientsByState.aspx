<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/reports.master"
    AutoEventWireup="false" CodeFile="ClientsByState.aspx.vb" Inherits="ClientsByState" %>

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

    <script language="javascript">
        function Export() {
            <%= ClientScript.GetPostBackEventReference(lnkExport, Nothing) %>;
        }
        
        function toggleDocument(docName, gridviewID) {
            var rowName = 'tr_' + docName
            var gv = document.getElementById(gridviewID);
            var rows = gv.getElementsByTagName('tr');
            for (var row in rows) {
                var rowID = rows[row].id
                if (rowID != undefined) {
                    if (rowID.indexOf(rowName + '_child') != -1) {
                        rows[row].style.display = (rows[row].style.display != 'none' ? 'none' : '');
                    } else if (rowID.indexOf(rowName + '_parent') != -1) {
                        var tree = rows[row].cells[0].children[0].src
                        rows[row].cells[0].children[0].src = (tree.indexOf('tree_plus') != -1 ? tree.replace('tree_plus', 'tree_minus') : tree.replace('tree_minus', 'tree_plus'));
                    }
                }
            }
        }        
    </script>

    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        margin: 15px;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="color: #666666; padding-bottom: 15px">
                <a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;<a
                        runat="server" class="lnk" style="color: #666666;" href="~/research/reports/clients">Clients</a>&nbsp;>&nbsp;Clients
                By State
            </td>
        </tr>
        <tr>
            <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                Status:
                <asp:DropDownList ID="ddlClientGroupStatus" runat="server" AutoPostBack="true" DataSourceID="ds_Status"
                    DataTextField="name" DataValueField="clientstatusgroupid" CssClass="entry2">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CellPadding="5"
                    Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                    DataSourceID="ds_Clients" DataKeyNames="companyid,stateid">
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="16px">
                            <HeaderTemplate>
                                &nbsp;
                            </HeaderTemplate>
                            <ItemTemplate>
                                <img id="imgTree" runat="server" src="~/images/tree_plus.bmp" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="headItem" />
                            <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Settlement Attorney" DataField="company" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                        <asp:BoundField HeaderText="" DataField="state" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                        <asp:BoundField HeaderText="Count" DataField="count" ItemStyle-CssClass="creditor-item"
                            HeaderStyle-CssClass="headItem" />
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
    </table>
    <asp:SqlDataSource ID="ds_Clients" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
        SelectCommand="stp_ActiveClientsByState" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Name="UserID" Type="Int32" />
            <asp:ControlParameter Name="GroupID" ControlID="ddlClientGroupStatus" PropertyName="SelectedValue" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="ds_Status" runat="server" ConnectionString="<%$ ConnectionStrings:DMS_RESTOREDConnectionString %>"
        SelectCommand="select clientstatusgroupid, name from tblclientstatusgroup order by name" SelectCommandType="Text">
    </asp:SqlDataSource>
    <asp:LinkButton ID="lnkExport" runat="server"></asp:LinkButton>
</asp:Content>
