<%@ Control Language="VB" AutoEventWireup="false" CodeFile="DocumentsControl.ascx.vb"
    Inherits="UserControl_DocumentsControl" %>
    <script type="text/javascript">
    //doc gridview script
    function checkAll(chk_SelectAll) {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;

        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                el.checked = chkState;
            }
        }
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
    
<asp:GridView ID="gvDocs" runat="server" HeaderStyle-CssClass="headItem5" RowStyle-CssClass="listItem"
    AllowPaging="False" AllowSorting="true" AutoGenerateColumns="False" DataSourceID="dsDocs" CssClass="entry"
    GridLines="None" DataKeyNames="pdfPath" DataMember="DefaultView" PageSize="25">
    <RowStyle CssClass="listItem" />
    <PagerSettings Mode="NumericFirstLast" PageButtonCount="5" Position="Bottom"  />
    <PagerStyle BackColor="#DCDCDC" Font-Names="Tahoma" Font-Size="Smaller" />
    <Columns>
        <asp:TemplateField>
            <HeaderTemplate>
            </HeaderTemplate>
            <ItemTemplate>
                <img id="imgTree" runat="server" src="~/images/tree_plus.bmp" />
            </ItemTemplate>
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
        </asp:TemplateField>
        <asp:TemplateField>
            <HeaderTemplate>
                &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
            </HeaderTemplate>
            <ItemTemplate>
                <input type="checkbox" runat="server" id="chk_select" />
            </ItemTemplate>
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
        </asp:TemplateField>
        <asp:TemplateField>
            <HeaderTemplate>
                <img id="Img8Hdr" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
            </HeaderTemplate>
            <ItemTemplate>
                <img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
            </ItemTemplate>
            <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
            <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
        </asp:TemplateField>
        <asp:BoundField DataField="DocTypeID" HeaderText="DocTypeID" SortExpression="DocTypeID"
            Visible="false">
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
        </asp:BoundField>
        <asp:TemplateField HeaderText="Document Name" SortExpression="DisplayName">
            <ItemTemplate>
                <asp:Label ID="lblDisplayName" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>
            </ItemTemplate>
            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:BoundField DataField="Received" HeaderText="Received" ReadOnly="True" SortExpression="Received"
            DataFormatString="{0:d}">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Created" HeaderText="Created" ReadOnly="True" SortExpression="Created"
            DataFormatString="{0:d}">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Createdby" HeaderText="Created By" ReadOnly="True" SortExpression="Createdby"
            DataFormatString="{0:d}" HtmlEncode="false">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="pdfPath" HeaderText="pdfPath" ReadOnly="True" SortExpression="pdfPath"
            Visible="false" />
    </Columns>
    <PagerTemplate>
        <div id="pager">
            <table class="entry">
                <tr>
                    <td style="padding-left:10px;">
                        Page(s)
                        <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true">
                        </asp:DropDownList>
                        of
                        <asp:Label ID="lblNumber" runat="server"></asp:Label>
                    </td>
                    <td style="padding-right:10px; text-align:right;">
                        <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                            ID="btnFirst" />
                        <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                            ID="btnPrevious" />
                        -
                        <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                            ID="btnNext" />
                        <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                            ID="btnLast" />
                    </td>
                </tr>
            </table>
            
        </div>
    </PagerTemplate>
    <EmptyDataTemplate>
        No Documents!
    </EmptyDataTemplate>
    <HeaderStyle CssClass="headItem5" />
</asp:GridView>
<asp:SqlDataSource ID="dsDocs" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
    SelectCommandType="StoredProcedure" SelectCommand=""
    ProviderName="System.Data.SqlClient">
</asp:SqlDataSource>
