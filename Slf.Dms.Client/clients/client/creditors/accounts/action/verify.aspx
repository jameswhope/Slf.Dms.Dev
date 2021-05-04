<%@ Page Language="VB" AutoEventWireup="false" CodeFile="verify.aspx.vb" Inherits="clients_client_creditors_accounts_action_verify" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Account Verification</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />

</head>
<body scroll="no" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

<script type="text/javascript">

if (window.parent.currentModalDialog) {
    window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
}

var optDo = null;
var optDoNot = null;

function CancelAndClose()
{
    window.close();
}
function Continue()
{
    LoadControls();

    if (optDo.checked)
    {
        window.parent.dialogArguments.VerifyWithAction();
    }
    else
    {
        window.parent.dialogArguments.VerifyWithoutAction();
    }

    window.close();
}
function LoadControls()
{
    if (optDo == null)
    {
        optDo = document.getElementById("<%= optDo.ClientID %>");
        optDoNot = document.getElementById("<%= optDoNot.ClientID %>");
    }
}

</script>

<form id="form1" runat="server" style="height:100%;">
    <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;padding:10;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top">
                <font style="font-weight:bold;">Are you sure you want to lock verification for this account?</font>
                <br /><br />
                This will automatically collect new retainer fees or adjust current retainer fees based on
                the changes you have made to this creditor account.
                <div style="display:none;">
                    <table style="font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="3" border="0">
                        <tr>
                            <td style="padding-right:10;">Verified Amount:</td>
                            <td style="width:15;" align="center">$</td>
                            <td align="right" style="padding-left:10;"><asp:Label runat="server" ID="lblAmount"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="padding-right:10;">Appropriate Fee:</td>
                            <td style="width:15;" align="center">$</td>
                            <td align="right" style="padding-left:10;"><asp:Label runat="server" ID="lblAppropriateFee"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="padding-right:10;">Current Retainer Fee:</td>
                            <td style="width:15;" align="center">$</td>
                            <td align="right" style="padding-left:10;"><asp:Label runat="server" ID="lblCurrentFee"></asp:Label></td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <asp:Label runat="server" ID="lblAction"></asp:Label>
                    <br />
                    <br />
                    <div style="display:none;">
                        <input name="collect" type="radio" runat="server" id="optDo" checked="true"/><label for="<%= optDo.ClientID() %>">Yes, do the recommended action.</label><br />
                        <input name="collect" type="radio" runat="server" id="optDoNot" /><label for="<%= optDoNot.ClientID() %>">No, do not do the recommended action.</label>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><a style="color:black" class="lnk" href="javascript:CancelAndClose();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                        <td align="right"><a style="color:black"  class="lnk" href="#" onclick="Continue();return false;">Continue<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>