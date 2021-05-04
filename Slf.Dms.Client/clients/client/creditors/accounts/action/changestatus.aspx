<%@ Page Language="VB" AutoEventWireup="false" CodeFile="changestatus.aspx.vb" Inherits="clients_client_creditors_accounts_action_changestatus" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Delete Account</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body scroll="no" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

<script type="text/javascript">

if (window.parent.currentModalDialog) {
    window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
}

var ddlAccountStatusID = null;

function CancelAndClose()
{
    window.close();
}
function Continue()
{
    LoadControls();

    if (RequiredExist())
    {
        window.parent.dialogArguments.Record_ChangeStatus(ddlAccountStatusID.options[ddlAccountStatusID.selectedIndex].value);

        window.close();
    }
}
function RequiredExist()
{
    LoadControls();

    RemoveBorder(ddlAccountStatusID);

    if (ddlAccountStatusID.selectedIndex == -1 || ddlAccountStatusID.options[ddlAccountStatusID.selectedIndex].value <= 0)
    {
        ShowMessage("You must select a new status in order to continue.");
        AddBorder(ddlAccountStatusID);
        return false;
    }

    HideMessage();
    return true;
}
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function HideMessage()
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    tdError.innerHTML = "";
    dvError.style.display = "none";
}
function LoadControls()
{
    if (ddlAccountStatusID == null)
    {
        ddlAccountStatusID = document.getElementById("<%= ddlAccountStatusID.ClientID %>");
    }
}

</script>

<form id="form1" runat="server" style="height:100%;">
    <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;padding:10;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top">
                <div runat="server" id="dvError" style="display:none;">
                    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
		                <tr>
			                <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
			                <td runat="server" id="tdError"></td>
		                </tr>
	                </table><br />
	            </div>
                <asp:Label style="font-weight:bold;" runat="server" ID="lblInfo"></asp:Label>
                <br /><br />
                Please select the new status for this account.
                <br /><br /><br />
                <b>New status:&nbsp;&nbsp;<asp:DropDownList style="font-family:Tahoma;font-size:11px;" runat="Server" ID="ddlAccountStatusID"></asp:DropDownList></b>
                <br />
                <br />
            </td>
        </tr>
        <tr>
            <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><a style="color:black" class="lnk" href="javascript:CancelAndClose();"><img id="Img2" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                        <td align="right"><a style="color:black"  class="lnk" href="#" onclick="Continue();return false;">Continue<img id="Img3" style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>