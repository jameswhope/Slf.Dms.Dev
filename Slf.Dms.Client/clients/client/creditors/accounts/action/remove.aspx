<%@ Page Language="VB" AutoEventWireup="false" CodeFile="remove.aspx.vb" Inherits="clients_client_creditors_accounts_action_remove" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Remove Account</title>
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

var optDo = null;
var optDoNot = null;
var dvFees = null;
var chkAddAccount = null;
var chkSettlement = null;
var chkRetainer = null;
var dvRetainerFees = null;
var optRemoveAll = null;
var optRemovePart = null;
var dvRemovePart = null;
var txtAmount = null;
var txtPercent = null;

function CancelAndClose()
{
    window.close();
}
function Continue()
{
    LoadControls();

    if (RequiredExist())
    {
        window.parent.dialogArguments.Record_Remove(optDo.checked, chkAddAccount.checked, chkSettlement.checked,
            chkRetainer.checked, optRemoveAll.checked, txtAmount.value, txtPercent.value);

        window.close();
    }
}
function RequiredExist()
{
    LoadControls();

    RemoveBorder(txtAmount);
    RemoveBorder(txtPercent);

    if (optDo.checked && chkRetainer.checked && optRemovePart.checked)
    {
        if (txtAmount.value.length == 0)
        {
            ShowMessage("In order to remove part of the retainer fee, you must enter the amount to remove.");
            AddBorder(txtAmount);
            return false;
        }
        else if (!IsValidNumberFloat(txtAmount.value, true, txtAmount))
        {
            ShowMessage("The amount you entered was invalid.  Please enter a non-zero, dollar amount.");
            AddBorder(txtAmount);
            return false;
        }
        else if (parseFloat(txtAmount.value) > <%= CurrentFee %>)
        {
            ShowMessage("The amount you entered is more then the original retainer fee.");
            AddBorder(txtAmount);
            return false;
        }

        if (txtPercent.value.length == 0)
        {
            ShowMessage("In order to remove part of the retainer fee, you must enter the percent to remove.");
            AddBorder(txtPercent);
            return false;
        }
        else if (!IsValidNumberFloat(txtPercent.value, true, txtPercent))
        {
            ShowMessage("The percent you entered was invalid.  Please enter a non-zero, percentage.");
            AddBorder(txtPercent);
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
    if (optDo == null)
    {
        optDo = document.getElementById("<%= optDo.ClientID %>");
        optDoNot = document.getElementById("<%= optDoNot.ClientID %>");
        dvFees = document.getElementById("<%= dvFees.ClientID %>");
        chkAddAccount = document.getElementById("<%= chkAddAccount.ClientID %>");
        chkSettlement = document.getElementById("<%= chkSettlement.ClientID %>");
        chkRetainer = document.getElementById("<%= chkRetainer.ClientID %>");
        dvRetainerFees = document.getElementById("<%= dvRetainerFees.ClientID %>");
        optRemoveAll = document.getElementById("<%= optRemoveAll.ClientID %>");
        optRemovePart = document.getElementById("<%= optRemovePart.ClientID %>");
        dvRemovePart = document.getElementById("<%= dvRemovePart.ClientID %>");
        txtAmount = document.getElementById("<%= txtAmount.ClientID %>");
        txtPercent = document.getElementById("<%= txtPercent.ClientID %>");
    }
}
function ResetDisplay()
{
    LoadControls();

    if (optDo.checked)
    {
        dvFees.disabled = false;
        dvFees.style.color = "";

        if (chkRetainer.checked)
        {
            dvRetainerFees.disabled = false;
            dvRetainerFees.style.color = "";

            if (optRemovePart.checked)
            {
                dvRemovePart.disabled = false;
                dvRemovePart.style.color = "";
            }
            else
            {
                dvRemovePart.disabled = true;
                dvRemovePart.style.color = "#c3c3c3";
            }
        }
        else
        {
            dvRetainerFees.disabled = true;
            dvRetainerFees.style.color = "#c3c3c3";
        }
    }
    else
    {
        dvFees.disabled = true;
        dvFees.style.color = "#c3c3c3";
    }
}
function txtAmount_OnKeyUp(txt)
{
    LoadControls();

    var Amount = 0.0;
    var Percent = 0.0;

    Amount = parseFloat(txtAmount.value);
    Percent = (Amount / <%= CurrentFee %>) * 100;

    txtPercent.value = FormatNumber(Percent, true, 2);
}
function txtPercent_OnKeyUp(txt)
{
    LoadControls();

    var Amount = 0.0;
    var Percent = 0.0;

    Percent = parseFloat(txtPercent.value);
    Amount = <%= CurrentFee %> * (Percent / 100);

    txtAmount.value = FormatNumber(Amount, false, 2);
}

</script>

<form id="form1" runat="server" style="height:100%;">
    <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;padding:10;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top">
                <div runat="server" id="dvError" style="display:none;">
                    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
		                <tr>
			                <td valign="top" style="width:20;"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
			                <td runat="server" id="tdError"></td>
		                </tr>
	                </table><br />
	            </div>
                <asp:Label style="font-weight:bold;" runat="server" ID="lblInfo">Are you sure you want to remove this account?</asp:Label>
                <br /><br />
                If you do want to remove this account, please select what you want to do with the fees that have been assessed on this account.
                <br /><br />
                <b>Fee Options:</b>
                <br />
                <br />
                <input onpropertychange="ResetDisplay();" name="modify" type="radio" runat="server" id="optDoNot" /><label for="<%= optDoNot.ClientID() %>">Do not modify any existing fees for this account.</label><br />
                <input onpropertychange="ResetDisplay();" name="modify" type="radio" runat="server" id="optDo" checked="true" /><label for="<%= optDo.ClientID() %>">Modify the fees assessed on this account.</label>
                <br />
                <div runat="server" id="dvFees" style="padding:5 0 0 40;">
                    <input type="checkbox" onpropertychange="ResetDisplay();" runat="server" checked="true" ID="chkAddAccount" /><label for="<%= chkAddAccount.ClientID() %>">Remove Additional Account Fees</label><br />
                    <input type="checkbox" onpropertychange="ResetDisplay();" runat="server" checked="true" ID="chkSettlement" /><label for="<%= chkSettlement.ClientID() %>">Remove Settlement Fees</label><br />
                    <input type="checkbox" onpropertychange="ResetDisplay();" runat="server" checked="true" ID="chkRetainer" /><label for="<%= chkRetainer.ClientID() %>">Remove Retainer Fees</label><br />
                    <div runat="server" id="dvRetainerFees" style="padding:5 0 0 30;">
                        <input onpropertychange="ResetDisplay();" name="remove" type="radio" runat="server" id="optRemoveAll" checked="true" /><label for="<%= optRemoveAll.ClientID() %>">Remove all retainer fees</label><br />
                        <input onpropertychange="ResetDisplay();" name="remove" type="radio" runat="server" id="optRemovePart" /><label for="<%= optRemovePart.ClientID() %>">Remove portion:&nbsp;</label><span runat="server" disabled="true" style="color:#c3c3c3;" id="dvRemovePart">&nbsp;$&nbsp;<asp:TextBox runat="server" ID="txtAmount" CssClass="entry" style="width:55;text-align:right;"></asp:TextBox>&nbsp;&nbsp;or&nbsp;&nbsp;<asp:TextBox runat="server" ID="txtPercent" CssClass="entry" style="width:40;text-align:right;"></asp:TextBox>&nbsp;%</span>
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