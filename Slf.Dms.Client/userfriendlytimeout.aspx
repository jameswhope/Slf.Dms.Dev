<%@ Page Language="VB" AutoEventWireup="false" CodeFile="userfriendlytimeout.aspx.vb" Inherits="_userfriendlytimeout" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Error</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>);background-position:left top;background-repeat:repeat-x;font-family:tahoma;font-size:11px;">
    <form id="frmMain" runat="server">
        <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;vertical-align:top;text-align:center;margin-top:100px;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <img src="~\images\serverfire.gif" runat="server" />
                </td>
            </tr>
            <tr style="height:25px;">
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="font-family:Tahoma;font-size:12px;">
                    A timeout error has ocurred and support has been notified.<br />
                    Some of your work may not have been saved.
                    <br />
                    <br />
                    <a class="lnk" href="javascript:history.go(-1);">Click here</a> to return to your work...
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td style="font-family:Tahoma;font-size:10px;">
                    <i>Note: Please verify what has and has not been saved in the system before<br />
                    repeating the action as data may be duplicated.</i>
                </td>
            </tr>
            <tr style="height:100%;">
                <td>&nbsp;</td>
            </tr>
        </table>
    </form>
</body>
</html>