<%@ Page Language="VB" AutoEventWireup="false" CodeFile="collectsetupfee.aspx.vb" Inherits="util_pop_collectsetupfee" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Collect Retainer Fee?</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body scroll="no" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
    
var chkCollectInsert = null;
var chkCollectUpdate = null;

window.close = function() { window.parent.currentModalDialog.modaldialog("close"); }; 

function CancelAndClose()
{
    window.parent.Record_ResolveCancel();
    window.close();
    
}
function Resolve()
{
    LoadControls();

    if (chkCollectInsert.checked && chkCollectUpdate.checked)
    {
        window.parent.Record_ResolveWithCollect();
    }
    else if (chkCollectInsert.checked && !chkCollectUpdate.checked)
    {
        window.parent.Record_ResolveWithCollectInsert();
    }
    else if (!chkCollectInsert.checked && chkCollectUpdate.checked)
    {
        window.parent.Record_ResolveWithCollectUpdate();
    }
    else if (!chkCollectInsert.checked && !chkCollectUpdate.checked)
    {
        window.parent.Record_ResolveWithoutCollect();
    }

    window.close();
}
function LoadControls()
{
    if (chkCollectInsert == null)
    {
        chkCollectInsert = document.getElementById("<%= chkCollectInsert.ClientID %>");
        chkCollectUpdate = document.getElementById("<%= chkCollectUpdate.ClientID %>");
    }
}

</script>

<form id="form1" runat="server" style="height:100%;">
    <table style="width:100%;height:100%;font-family:tahoma;font-size:11px;padding:10;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top" style="height:100%;padding:0 10 0 10;">
                <font style="font-weight:bold;">Are you sure you want to resolve this worksheet?</font>
                <br /><br />
                This will automatically collect new retainer fees or adjust current retainer fees based on
                the changes you have made to this client's creditor accounts.
            </td>
        </tr>
        <tr style="display:none;">
            <td>
                <asp:Label style="font-weight:bold;" runat="server" ID="lblInfo"></asp:Label>
                <div style="padding:5 0 5 30;">
                    <asp:CheckBox AutoPostBack="true" runat="server" ID="chkCollectInsert" Text="Add retainer fees for new accounts" /><br />
                    <asp:CheckBox AutoPostBack="true" runat="server" ID="chkCollectUpdate" Text="Adjust retainer fees for current accounts" />
                </div>
            </td>
        </tr>
        <tr style="display:none;">
            <td valign="top" style="padding:5 10 0 10;"><div style="background-color:#f1f1f1;padding:5;">New & Updated Accounts</div></td>
        </tr>
        <tr style="display:none;">
            <td valign="top" style="height:100%;padding:0 10 0 10;">
                <table style="overflow:auto;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="3" cellspacing="0" border="0">
                    <tr>
                        <td class="headItem">Type</td>
                        <td class="headItem">Name</td>
                        <td class="headItem" align="right">Amount</td>
                        <td class="headItem" align="right">Fee %</td>
                        <td class="headItem">Action</td>
                        <td class="headItem" align="right">Current</td>
                        <td class="headItem" align="right">New</td>
                        <td class="headItem" align="right">Adjusted</td>
                    </tr>
                    <asp:Repeater runat="server" ID="rpModifiedAccountFees">
                        <ItemTemplate>
                            <tr>
                                <td class="listItem"><%#DataBinder.Eval(Container.DataItem, "Type")%></td>
                                <td class="listItem"><%#DataBinder.Eval(Container.DataItem, "Name")%></td>
                                <td class="listItem" align="right"><%#DataBinder.Eval(Container.DataItem, "Amount", "{0:$#,##0.00}")%></td>
                                <td class="listItem" align="right"><%#DataBinder.Eval(Container.DataItem, "Percentage", "{0:#,##0.00%}")%></td>
                                <td id="tdAction" runat="server" class="listItem" style="color:blue;"><%#DataBinder.Eval(Container.DataItem, "Action")%></td>
                                <td id="tdCurrent" runat="server" class="listItem" align="right"><%#DataBinder.Eval(Container.DataItem, "CurrentFeeAmount", "{0:$#,##0.00}")%></td>
                                <td id="tdNew" runat="server" class="listItem" align="right"><%#DataBinder.Eval(Container.DataItem, "NewFeeAmount", "{0:$#,##0.00}")%></td>
                                <td id="tdAdjusted" runat="server" class="listItem" align="right"><%#DataBinder.Eval(Container.DataItem, "AdjustFeeAmount", "{0:$#,##0.00}")%></td>
                           </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </td>
        </tr>
        <tr style="display:none;">
            <td align="right" style="padding:5 10 10 0;">
                <table style="border-top:solid 1px #b3b3b3;font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding-right:10;">Current retainer fee total:</td>
                        <td style="width:5;" align="center">$</td>
                        <td style="padding-left:5;" align="right"><asp:Label ID="lblCurrentTotal" runat="server" CssClass="entry"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="padding-right:10;">Added fees and adjustments:</td>
                        <td align="center">$</td>
                        <td style="padding-left:5;" align="right"><asp:Label ID="lblNew" runat="server" CssClass="entry"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="padding-right:10;">New retainer fee total:</td>
                        <td align="center">$</td>
                        <td style="padding-left:5;" align="right"><asp:Label ID="lblNewTotal" runat="server" CssClass="entry"></asp:Label></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><a style="color:black" class="lnk" href="javascript:CancelAndClose();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                        <td align="right"><a style="color:black"  class="lnk" href="#" onclick="Resolve();return false;">Continue<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>