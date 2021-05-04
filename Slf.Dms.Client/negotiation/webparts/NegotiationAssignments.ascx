<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NegotiationAssignments.ascx.vb" Inherits="negotiation_webparts_NegotiationAssignments" %>

<script type="text/javascript">
    function ShowGroup(source){
        var rows = document.getElementsByTagName('tr');
        for (var x in rows){
            if (x.indexOf('_') != -1){
                var strRow = x;
                strRow = strRow.substring(strRow.lastIndexOf('_')+1);
                if (strRow.indexOf(source) != -1){
                    
                    if (x.indexOf('hdr') == -1){
                    
                        var childRows = document.getElementsByName(x);
                        for (i=0;i<=childRows.length-1;i++){
                            if (childRows(i).style.display == ''){
                                childRows(i).style.display = 'none';
                            }else{
                                childRows(i).style.display = '';
                            }
                        }
                        break;
                    }else{
                        var hdr = $get(x);
                        var cell = hdr.children[0];
                        var img = cell.children[0];
                        var tmpSrc = img.src;
                        if (tmpSrc.indexOf('expand') != -1){
                            tmpSrc = tmpSrc.replace('expand','collapse');
                        }else{
                            tmpSrc = tmpSrc.replace('collapse','expand');
                        }
                        
                        img.src = tmpSrc;
                    }
                }
            }
        }
    }
</script>

<div style="width:100%;">
    <asp:UpdatePanel ID="updPreview" ChildrenAsTriggers="false" UpdateMode="Conditional"
        runat="server">
        <ContentTemplate>
            <asp:GridView ID="gridData" AllowSorting="True" AllowPaging="True" BorderStyle="none" CellPadding="4" ForeColor="#333333" GridLines="None" PagerSettings-Position="TopAndBottom" DataSourceID="dsData" Width="100%" AutoGenerateColumns="false" OnSorting="gridData_Sorting" EnableViewState="true" runat="server">
                <SelectedRowStyle CssClass="webpartgridselectedrowstyle" />
                <HeaderStyle CssClass="webpartgridhdrstyle" />
                <AlternatingRowStyle CssClass="webpartgridaltrowstyle" />
                <RowStyle CssClass="webpartgridrowstyle" />
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <asp:Label ID="lblGroupName" runat="server"></asp:Label>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:Panel ID="pnlGroup" runat="server" BackColor="LightGray" Height="30px">
                                <div class="GridHeaderstyle" style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                    <div style="float: left;">
                                        <asp:Label ID="lblGroup" Font-Size="12pt" Font-Bold="true" Text='<%# Bind("GroupHdr") %>'
                                            runat="server" />
                                    </div>
                                    <div style="float: right; vertical-align: middle;">
                                        <asp:ImageButton ID="Image1" runat="server" ImageUrl="~/images/expand.jpg" />
                                    </div>
                                </div>
                            </asp:Panel>
                            <asp:Panel ID="pnlgrid" runat="server" Width="100%">
                                <asp:GridView ID="gvChild" AutoGenerateColumns="False" BorderStyle="none" CellPadding="4" ForeColor="#333333" GridLines="None" PagerSettings-Mode="NextPreviousFirstLast" Width="100%" OnRowCreated="gvChild_RowCreated" PageSize="50" OnPageIndexChanging="gvChild_PageIndexChanging" OnSorting="gvChild_Sorting" runat="server">
                                    <SelectedRowStyle CssClass="webpartgridselectedrowstyle" />
                                    <HeaderStyle CssClass="webpartgridhdrstyle" />
                                    <AlternatingRowStyle CssClass="webpartgridaltrowstyle" />
                                    <RowStyle CssClass="webpartgridrowstyle" />
                                    <Columns>
                                    </Columns>
                                    <EmptyDataTemplate>
                                            No records to display.
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </asp:Panel>
                            <ajaxToolkit:CollapsiblePanelExtender CollapsedSize="1" ID="cpeGrid" TargetControlID="pnlGrid"
                                ExpandControlID="pnlGroup" CollapseControlID="pnlGroup" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerTemplate>
                    <table width="100%">
                        <tbody>
                            <tr style="font-family: Tahoma; font-size: 8pt">
                                <td align="left">
                                    Group By
                                    <asp:DropDownList ID="ddlGroupBy" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroupBy_SelectedIndexChanged"
                                        Width="150px">
                                        <asp:ListItem>NONE</asp:ListItem>
                                    </asp:DropDownList></td>
                                <td align="left">
                                    <asp:Label ID="Label1" runat="server" Text="Page Size "></asp:Label>
                                    <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged"
                                        Width="59px">
                                        <asp:ListItem>25</asp:ListItem>
                                        <asp:ListItem>50</asp:ListItem>
                                        <asp:ListItem>100</asp:ListItem>
                                        <asp:ListItem>200</asp:ListItem>
                                    </asp:DropDownList>
                                <td align="right">
                                    &nbsp;
                                    <asp:Label ID="Label2" runat="server" Text="Page "></asp:Label>
                                    <asp:DropDownList ID="ddlPage" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged"
                                        Width="45px">
                                    </asp:DropDownList>
                                    <asp:Label ID="Label3" runat="server" Text="of"></asp:Label>
                                    <asp:Label ID="lblPageCount" runat="server" Text="000"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </PagerTemplate>
                <RowStyle CssClass="gridrowstyle"></RowStyle>
                <AlternatingRowStyle CssClass="gridalternatingrowstyle" />
                <PagerStyle CssClass="gridpagerstyle"></PagerStyle>
                <HeaderStyle CssClass="gridheaderstyle"></HeaderStyle>
                <PagerSettings Position="TopAndBottom" />
            </asp:GridView>
            <asp:SqlDataSource ID="dsData" runat="server" SelectCommand="" ConnectionString="<%$ Appsettings:ConnectionString %>">
            </asp:SqlDataSource>
            <asp:Label ID="lblError" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>