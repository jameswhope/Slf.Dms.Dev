<%@ Page Language="VB" AutoEventWireup="false" CodeFile="attachglobaldoc.aspx.vb" Inherits="util_pop_attachglobaldoc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript">
        function closeAttach() {
            window.close();
        }
    </script>
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x; overflow: auto;">
    <form id="form1" runat="server">
    <div>
        <fieldset class="entry" style="white-space: nowrap; padding: 10px; width:600px" id="fldUploadDoc"
            runat="server">
            <legend>Upload</legend>
            <table cellpadding="2">
                <tr>
                    <td>
                        File Type:
                        <asp:DropDownList ID="ddlDocTypes" runat="server" CssClass="entry2" DataSourceID="ds_DocTypes" DataTextField="DisplayName" DataValueField="TypeID">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:FileUpload ID="FileUpload1" runat="server" CssClass="entry2" Style="width: 500px"
                            Height="25" />
                        <asp:Button ID="btnUpload" runat="server" CssClass="entry2" Text="Upload" Height="25" /><br />
                        <asp:Label ID="Label1" runat="server" ForeColor="Red" Text="&nbsp;"></asp:Label>
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
    <asp:SqlDataSource ID="ds_DocTypes" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
        SelectCommand="select distinct typeid, displayname from tbldocumenttype where not typeid like '%scan%' and docfolder = 'ClientDocs' order by displayname"
        SelectCommandType="Text"></asp:SqlDataSource>
    </form>
</body>
</html>
