<%@ Page Language="VB" AutoEventWireup="false" CodeFile="collect.aspx.vb" Inherits="clients_client_creditors_accounts_action_collect" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Collect Fees?</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
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

var optNothing = null;
var optCollectAdd = null;
var dvCollectAdd = null;
var optCollectAddAll = null;
var optCollectAddPartial = null;
var spnAddPartial = null;
var txtCollectAddPartial = null;
var optCollectRetainer = null;
var dvCollectRetainer = null;
var optCollectRetainerAll = null;
var optCollectRetainerPartial = null;
var spnRetainerPartial = null;
var txtCollectRetainerPartial = null;
var chkIsVerified = null;

function CancelAndClose()
{
    window.close();
}
function Continue()
{
    LoadControls();

//    if (RequiredExist())
//    {
//        window.top.dialogArguments.Record_Save(chkIsVerified.checked, optCollectAdd.checked, txtCollectAddPartial.value,
//            optCollectRetainer.checked, txtCollectRetainerPartial.value);

        window.parent.dialogArguments.Record_Save(chkIsVerified.checked);

        window.close();
//    }
}
function RequiredExist()
{
    LoadControls();

    RemoveBorder(txtCollectAddPartial);
    RemoveBorder(txtCollectRetainerPartial);

    if (optCollectAdd.checked && optCollectAddPartial.checked)
    {
        if (txtCollectAddPartial.value.length == 0)
        {
            ShowMessage("Please enter an amount.");
            AddBorder(txtCollectAddPartial);
            return false;
        }
        else if (!IsValidNumberFloat(txtCollectAddPartial.value, true, txtCollectAddPartial))
        {
            ShowMessage("The amount you entered is invalid.  Please enter a non-zero, dollar amount.");
            AddBorder(txtCollectAddPartial);
            return false;
        }
    }

    if (optCollectRetainer.checked && optCollectRetainerPartial.checked)
    {
        if (txtCollectRetainerPartial.value.length == 0)
        {
            ShowMessage("Please enter an amount.");
            AddBorder(txtCollectRetainerPartial);
            return false;
        }
        else if (!IsValidNumberFloat(txtCollectRetainerPartial.value, true, txtCollectRetainerPartial))
        {
            ShowMessage("The amount you entered is invalid.  Please enter a non-zero, dollar amount.");
            AddBorder(txtCollectRetainerPartial);
            return false;
        }
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
    if (optNothing == null)
    {
        optNothing = document.getElementById("<%= optNothing.ClientID %>");
        optCollectAdd = document.getElementById("<%= optCollectAdd.ClientID %>");
        dvCollectAdd = document.getElementById("<%= dvCollectAdd.ClientID %>");
        optCollectAddAll = document.getElementById("<%= optCollectAddAll.ClientID %>");
        optCollectAddPartial = document.getElementById("<%= optCollectAddPartial.ClientID %>");
        spnAddPartial = document.getElementById("<%= spnAddPartial.ClientID %>");
        txtCollectAddPartial = document.getElementById("<%= txtCollectAddPartial.ClientID %>");
        optCollectRetainer = document.getElementById("<%= optCollectRetainer.ClientID %>");
        dvCollectRetainer = document.getElementById("<%= dvCollectRetainer.ClientID %>");
        optCollectRetainerAll = document.getElementById("<%= optCollectRetainerAll.ClientID %>");
        optCollectRetainerPartial = document.getElementById("<%= optCollectRetainerPartial.ClientID %>");
        spnRetainerPartial = document.getElementById("<%= spnRetainerPartial.ClientID %>");
        txtCollectRetainerPartial = document.getElementById("<%= txtCollectRetainerPartial.ClientID %>");
        chkIsVerified = document.getElementById("<%= chkIsVerified.ClientID %>");
    }
}
function ResetDisplay()
{
    LoadControls();

    if (optNothing.checked)
    {
        dvCollectAdd.disabled = true;
        dvCollectAdd.style.color = "";

        dvCollectRetainer.disabled = true;
        dvCollectRetainer.style.color = "";

        spnAddPartial.disabled = true;
        spnAddPartial.style.color = "#c3c3c3";
        txtCollectAddPartial.disabled = true;

        spnRetainerPartial.disabled = true;
        spnRetainerPartial.style.color = "#c3c3c3";
        txtCollectRetainerPartial.disabled = true;
    }
    else if (optCollectAdd.checked)
    {
        dvCollectAdd.disabled = false;
        dvCollectAdd.style.color = "";

        dvCollectRetainer.disabled = true;
        dvCollectRetainer.style.color = "#c3c3c3";

        spnRetainerPartial.disabled = true;
        spnRetainerPartial.style.color = "#c3c3c3";
        txtCollectRetainerPartial.disabled = true;

        if (optCollectAddPartial.checked)
        {
            spnAddPartial.disabled = false;
            spnAddPartial.style.color = "";
            txtCollectAddPartial.disabled = false;
        }
        else
        {
            spnAddPartial.disabled = true;
            spnAddPartial.style.color = "#c3c3c3";
            txtCollectAddPartial.disabled = true;
        }
    }
    else if (optCollectRetainer.checked)
    {
        dvCollectAdd.disabled = true;
        dvCollectAdd.style.color = "#c3c3c3";

        dvCollectRetainer.disabled = false;
        dvCollectRetainer.style.color = "";

        spnAddPartial.disabled = true;
        spnAddPartial.style.color = "#c3c3c3";
        txtCollectAddPartial.disabled = true;

        if (optCollectRetainerPartial.checked)
        {
            spnRetainerPartial.disabled = false;
            spnRetainerPartial.style.color = "";
            txtCollectRetainerPartial.disabled = false;
        }
        else
        {
            spnRetainerPartial.disabled = true;
            spnRetainerPartial.style.color = "#c3c3c3";
            txtCollectRetainerPartial.disabled = true;
        }
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
                <font style="font-weight:bold;">Are you sure you want to add this new account?</font>
                <br /><br /><br />
                <asp:Label Visible="false" runat="server" ID="lblInfo"></asp:Label>
                <div style="display:none;">
                    Fee Options:
                    <br /><br />
                    <input onpropertychange="ResetDisplay();" name="modify" type="radio" runat="server" id="optNothing" checked="true" /><label for="<%= optNothing.ClientID() %>">Do not collect any fees on this new account.</label><br />
                    <input onpropertychange="ResetDisplay();" name="modify" type="radio" runat="server" id="optCollectAdd" /><label for="<%= optCollectAdd.ClientID() %>">Collect an Addition Account Fee for this new account.</label>
                    <br />
                    <div runat="server" id="dvCollectAdd" style="padding:5 0 0 40;" disabled="true">
                        <input onpropertychange="ResetDisplay();" name="add" type="radio" runat="server" id="optCollectAddAll" checked="true" /><label for="<%= optCollectAddAll.ClientID() %>">Add default amount of&nbsp;<asp:Label runat="server" ID="lblAddDefault"></asp:Label></label><br />
                        <input onpropertychange="ResetDisplay();" name="add" type="radio" runat="server" id="optCollectAddPartial" /><label for="<%= optCollectAddPartial.ClientID() %>">Add custom amount of:&nbsp;</label><span id="spnAddPartial" runat="server" disabled="true" style="color:#c3c3c3;">&nbsp;$&nbsp;<asp:TextBox Enabled="false" runat="server" ID="txtCollectAddPartial" CssClass="entry" style="width:70;text-align:right;"></asp:TextBox></span>
                    </div>
                    <br />
                    <input onpropertychange="ResetDisplay();" name="modify" type="radio" runat="server" id="optCollectRetainer" /><label for="<%= optCollectRetainer.ClientID() %>">Collect a Retainer Fee for this new account.</label>
                    <br />
                    <div runat="server" id="dvCollectRetainer" style="padding:5 0 0 40;" disabled="true">
                        <input onpropertychange="ResetDisplay();" name="retainer" type="radio" runat="server" id="optCollectRetainerAll" checked="true" /><label for="<%= optCollectRetainerAll.ClientID() %>">Add default amount of&nbsp;<asp:Label runat="server" ID="lblRetainerDefault"></asp:Label></label><br />
                        <input onpropertychange="ResetDisplay();" name="retainer" type="radio" runat="server" id="optCollectRetainerPartial" /><label for="<%= optCollectRetainerPartial.ClientID() %>">Add custom amount of:&nbsp;</label><span id="spnRetainerPartial" runat="server" disabled="true" style="color:#c3c3c3;">&nbsp;$&nbsp;<asp:TextBox Enabled="false" runat="server" ID="txtCollectRetainerPartial" CssClass="entry" style="width:70;text-align:right;"></asp:TextBox></span>
                    </div>
                    <br /><br />
                </div>
                <asp:CheckBox runat="server" ID="chkIsVerified" Text="The creditor has been contacted and the amount verified so Account Verification can be locked." />
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