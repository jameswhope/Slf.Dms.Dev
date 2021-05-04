<%@ Page ValidateRequest="false" Language="VB" AutoEventWireup="false" CodeFile="confirm.aspx.vb" Inherits="util_pop_confirm"%>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Confirm</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    </script>
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <form id="form1" runat="server">
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:15 15 15 15;">
                    <asp:Label runat="server" ID="lblMessage"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />Cancel and Close</a></td>
                            <td align="right"><a runat="server" id="lnkAction" tabindex="2" style="color:black" class="lnk" href="#"></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>