<%@ Page Language="VB" AutoEventWireup="false" CodeFile="hold.aspx.vb" Inherits="clients_client_finances_bytype_action_hold" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Issue A Hold</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

<script type="text/javascript">

if (window.parent.currentModalDialog) {
    window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
}

var imHold = null;

function CancelAndClose()
{
    window.close();
}
function Continue()
{
    if (RequiredExist())
    {
        window.parent.dialogArguments.Record_Hold(imHold.value);
        window.close();
    }
}
function RequiredExist()
{
    LoadControls();

    if (imHold.value.length == 0)
    {
        ShowMessage("The Hold Date is required.");
        AddBorder(imHold);
        return false;
    }
    else
    {
        if (!IsValidDateTime(imHold.value))
        {
            ShowMessage("The Hold Date is invalid.  Please enter a different value.");
            AddBorder(imHold);
            return false;
        }
    }

    HideMessage()
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
    if (imHold == null)
    {
        imHold = document.getElementById("<%= imHold.ClientID() %>");
    }
}
function SetToNow()
{
    LoadControls();

    if (!lnkSetToNow.disabled)
    {
        imHold.value = Functoid_Date_FormatDateTimeMedium(new Date(), "/");
    }
}

</script>

<form id="form1" runat="server" style="padding-left:10;height:100%;">
    <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top" style="height:100%;font-family:tahoma;font-size:11px;">
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                        width="100%" border="0">
                        <tr>
                            <td valign="top" width="20"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                            <td runat="server" id="tdError"></td>
                        </tr>
                    </table>
                    &nbsp;
                </div>
                <br />
                <b>Are you sure you want to issue a hold on this deposit?</b>
                <br />
                <br />
                While this deposit is held, the funds associated will not be available.
                <br />
                <br />
                <table style="font-family:tahoma;font-size:11px;width:275;" border="0" cellpadding="0" cellspacing="7">
                    <tr>
                        <td style="width:65;">Entered By:</td>
                        <td><asp:Label ID="lblBy" runat="server" CssClass="entry"></asp:Label></td>
                        <td style="width:55;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Hold Until Date:</td>
                        <td><cc1:InputMask cssclass="entry" ID="imHold" runat="server" Mask="nn/nn/nnnn nn:nn aa"></cc1:InputMask></td>
                        <td><a class="lnk" runat="server" id="lnkSetToNow" href="javascript:SetToNow();">Set To Now</a></td>
                    </tr>
                </table>
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