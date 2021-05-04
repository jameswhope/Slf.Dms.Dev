<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="default.aspx.vb" Inherits="clients_client_docs_default" Title="DMP - Client - Documents" %>

<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" language="javascript">
        window.onload = function ()
        {
            document.getElementById('<%=hdnCurrentDoc.ClientID %>').value;
        }
        function OpenDocument(path)
        {
            window.open(path);
        }
        function SelectDocument(obj, path)
        {
            var hdnCurrentDoc = document.getElementById('<%=hdnCurrentDoc.ClientID %>');
            
            if (obj.checked)
            {
                hdnCurrentDoc.value += path + '|';
            }
            else
            {
                hdnCurrentDoc.value = hdnCurrentDoc.value.replace(path + '|', '');
            }
        }
        function DeleteDocument()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
        }
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
    </script>

    <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%; vertical-align: top;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td>
                <table style="width: 100%; color: rgb(120,120,120); font-size: 11; font-family: Verdana, Arial, Helvetica"
                    cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td valign="top">
                            <asp:Label Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                runat="server" ID="lnkName" />
                            &nbsp;
                            <br />
                            <asp:Label runat="server" ID="lblAddress" />
                        </td>
                        <td align="right" valign="top">
                            <asp:Label runat="server" Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                ID="lblAccountNumber" />
                            <asp:Label runat="server" ID="lblSSN" Visible="false" />
                            <asp:Label runat="server" ID="lblLeadNumber" />
                            Status:&nbsp;
                            <asp:Label runat="server" ID="lnkStatus" />
                            <asp:Label runat="server" ID="lnkStatus_ro" Visible="false" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-position: left center;
            background-repeat: repeat-x;">
            <td>
                <img height="30" width="1" runat="server" src="~/images/spacer.gif" />
            </td>
        </tr>
        <tr id="trAdminControls" runat="server">
            <td>
                <a href="javascript:DeleteDocument();" class="lnk">Delete Document</a>
            </td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="gvDocuments" runat="server" ShowHeader="true" CssClass="entry"
                    AutoGenerateColumns="false" AllowSorting="true" AllowPaging="true" PageSize="15">
                    <Columns>
                        <asp:BoundField DataField="docID" HeaderText="docid" SortExpression="docid" Visible="false">
                            <HeaderStyle CssClass="headItem5" />
                            <ItemStyle CssClass="listItem" />
                        </asp:BoundField>
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
                        <asp:TemplateField HeaderText="Document Name" SortExpression="documentname">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDocument" runat="server" Text='<%#eval("documentname") %>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Received" HeaderText="Received" SortExpression="Received" DataFormatString="{0:d}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="100" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="100"/>
                        </asp:BoundField>
                        <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created" DataFormatString="{0:d}">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="100"/>
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="100"/>
                        </asp:BoundField>
                        <asp:BoundField DataField="CreatedBy" HeaderText="Created By" SortExpression="CreatedBy"
                            HtmlEncode="false">
                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:BoundField>
                        
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="info">
                            This client does not have a directory!</div>
                    </EmptyDataTemplate>
                    <PagerTemplate>
                        <div id="pager">
                            <table class="entry">
                                <tr>
                                    <td style="padding-right: 10px; text-align: left;">
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
                                    <td style="padding-left: 10px; text-align:right">
                                        Page(s)
                                        <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true">
                                        </asp:DropDownList>
                                        of
                                        <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </PagerTemplate>
                </asp:GridView>
                <%--<table style="font-family: tahoma; font-size: 11px; width: 100%; background-color: #d0d0d0;">
                    <tr>
                        <td style="width: 20px;" align="center">
                            <img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                        </td>
                        <td style="width: 11px;">
                            &nbsp;
                        </td>
                        <td align="left" style="width: 260px;">
                            Document Name
                        </td>
                        <td align="left" style="width: 60px;">
                            Received
                        </td>
                        <td align="left" style="width: 60px;">
                            Created
                        </td>
                        <td align="left">
                            Created By
                        </td>
                        <td style="width: 20px;" align="right">
                        </td>
                    </tr>
                </table>--%>
            </td>
        </tr>
        <tr style="width: 100%;">
            <td colspan="2" style="width: 100%;">
                <asp:TreeView ID="trvFiles" ExpandDepth="FullyExpand" ShowLines="false" Font-Names="Tahoma"
                    Font-Size="11px" ForeColor="#000000" Width="100%" ShowExpandCollapse="true" CollapseImageUrl="~/images/16x16_empty.png"
                    ExpandImageUrl="~/images/16x16_empty.png" NodeIndent="0" runat="server">
                    <NodeStyle Width="100%" />
                    <HoverNodeStyle BackColor="#d1d1d1" />
                </asp:TreeView>
            </td>
        </tr>
        <tr>
            <td id="tdNoDir" style="font-weight: bold; color: #A03535;" runat="server">
                This client does not have a directory!
            </td>
        </tr>
        <tr style="height: 100%;">
            <td>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnCurrentDoc" runat="server" />
    <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
</asp:Content>
