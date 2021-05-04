<%@ Page Language="VB" AutoEventWireup="false" CodeFile="timeout.aspx.vb" Inherits="util_pop_timeout" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Timeout Notice</title>
    <link runat="server" type="text/css" rel="stylesheet" href="~/css/default.css" />
</head>
<script type="text/javascript">

var time = <%= ApplicationTimeoutCountdown %>;
var lblCountdown = null;

function Setup()
{
    lblCountdown = document.getElementById("<%= lblCountdown.ClientID %>");
    window.setTimeout("Countdown()", 1000);
}
function Countdown()
{
    time -= 1;

    lblCountdown.innerHTML = time;

    if (time <= 0)
    {
        Logout();
    }
    else
    {
        window.setTimeout("Countdown()", 1000);
    }
}
function Continue()
{
    window.close();
}
function Logout()
{
    window.top.dialogArguments.location.href = "<%= ResolveUrl("~/logout.aspx") %>";
    window.close();
}
</script>
<body onload="Setup();" scroll="no" onunload="window.top.dialogArguments.StartTimeOut();">
    <form id="form1" runat="server">
    <div>
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:5 10 15 10;">
                    Due to inactivity, your session is about ready to timeout.  If you wish to continue working, click the Continue Working button below.
                    <div style="margin:25 0 0 0;font-size:18px;text-align:center;">
                        Logging Out In: <asp:Label style="color:red;" runat="server" ID="lblCountdown"></asp:Label>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a style="color:black" class="lnk" href="javascript:Continue();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />Continue Working</a></td>
                            <td align="right"><a runat="server" id="lnkAction" style="color:black" class="lnk" href="javascript:Logout();">Logout of Session<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle" /></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>