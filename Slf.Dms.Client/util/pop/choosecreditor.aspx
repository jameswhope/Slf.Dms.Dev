<%@ Page Language="VB" AutoEventWireup="false" CodeFile="choosecreditor.aspx.vb"
    Inherits="util_pop_choosecreditor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Choose Creditor</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }      
        
        window.name = "modal";
    </script>

</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    <form id="form1" runat="server" target="modal">
    <div style="margin: 15px;">
        <h3>
            Which creditor do you want to keep?</h3>
        <table>
            <tr>
                <td>
                    <asp:RadioButton ID="rdoExisting" runat="server" GroupName="Creditor" Checked="true"
                        Text="(Existing)" CssClass="entry2" />
                </td>
                <td>
                    <asp:TextBox ID="txtExistingName" runat="server" CssClass="entry2"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtExistingStreet" runat="server" CssClass="entry2"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtExistingStreet2" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtExistingCity" runat="server" CssClass="entry2" Width="100px"></asp:TextBox>
                </td>
                <td>
                    <asp:DropDownList ID="ddlExistingState" runat="server" CssClass="entry2">
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:TextBox ID="txtExistingZipCode" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:RadioButton ID="rdoNew" runat="server" GroupName="Creditor" Text="(New)" CssClass="entry2" />
                </td>
                <td>
                    <asp:TextBox ID="txtNewName" runat="server" CssClass="entry2"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtNewStreet" runat="server" CssClass="entry2"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtNewStreet2" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtNewCity" runat="server" CssClass="entry2" Width="100px"></asp:TextBox>
                </td>
                <td>
                    <asp:DropDownList ID="ddlNewState" runat="server" CssClass="entry2">
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:TextBox ID="txtNewZipCode" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <p class="entry2">
            Note: The selected creditor will replace any instances of the non-selected creditor
            in the system. The non-selected creditor will be removed from the system.
        </p>
        <hr />
        <table width="100%">
            <tr>
                <td align="right">
                    <asp:LinkButton ID="btnValidate" runat="server" CssClass="lnk"><img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_check.png" /> Validate</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton ID="btnApprove" runat="server" CssClass="lnk"><img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_thumb_up.png" /> Approve</asp:LinkButton>
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
