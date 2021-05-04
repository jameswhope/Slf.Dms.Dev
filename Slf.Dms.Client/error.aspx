<%@ Page Language="VB" AutoEventWireup="false" CodeFile="error.aspx.vb" Inherits="_error" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Note</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>);background-position:left top;background-repeat:repeat-x;font-family:tahoma;font-size:11px;">
    <form id="frmMain" runat="server">
        <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;vertical-align:top;text-align:center;margin-top:100px;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:Label id="lblError" style="font-weight:bold;color:darkred;" runat="server" />
                </td>
            </tr>
            <tr style="height:25px;">
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>
                    An unhandled exception has occurred! Please notify <a class="lnk" href="">support</a>...
                </td>
            </tr>
            <tr style="height:100%;">
                <td>&nbsp;</td>
            </tr>
        </table>
    </form>
</body>
</html>