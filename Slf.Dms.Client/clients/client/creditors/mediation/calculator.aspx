<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="calculator.aspx.vb" Inherits="clients_client_finances_mediation_calculator" title="DMP - Client - Negotiation" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="drg" TagName="ToolBarComms" Src="~/clients/client/toolbarcomms.ascx" %>


<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server">

    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_Save();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save Negotiation</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" href="#" onclick="Record_CancelAndClose();return false;">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_cancel.png" />Cancel and Close</a></td>
                <td style="width:100%;">&nbsp;</td>
                <drg:ToolBarComms id="ucComms" runat="server"></drg:ToolBarComms>
                <td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a runat="server" class="menuButton" href="~/search.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_search.png" />Search</a></td>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            </tr>
        </table>
    </asp:Panel>

</asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript">

var pnlMenuDefault = null;
var pnlBodyDefault = null;
var txtRegisterBalance = null;
var txtAccountBalance = null;
var txtSettlementPercentage = null;
var txtSettlementAmount = null;
var txtAmountAvailable = null;
var txtAmountBeingSent = null;
var txtAmountStillOwed2 = null;
var txtSavings = null;
var lblSettlementFee = null;
var txtSettlementFee = null;
var txtOvernightDeliveryAmount = null;
var txtSettlementCost = null;
var txtAvailableAfterSettlement = null;
var txtAmountBeingPaid = null;
var txtAmountStillOwed = null;

var txtFrozenAmount = null;
var imFrozenDate = null;
var txtFrozenDays = null;

function txtFrozenDays_OnFocus(obj)
{
    LoadControls();

    if (imFrozenDate.value.length == 0)
    {
        txtFrozenDays.value = "";
    }
}
function txtFrozenDays_OnBlur(obj)
{
    LoadControls();

    if (IsValidNumberFloat(txtFrozenDays.value, false, txtFrozenDays))
    {
        imFrozenDate.value = Functoid_Date_FormatDateTimeMedium(Functoid_Date_AddDays(new Date(), parseFloat(txtFrozenDays.value)));
    }
    else
    {
        if (txtFrozenDays.value.length == 0)
        {
            imFrozenDate.value = "";
        }
    }
}
function imFrozenDate_OnMatch()
{
    LoadControls();

    if (IsValidDateTime(imFrozenDate.value))
    {
        txtFrozenDays.value = FormatNumber(Functoid_Date_SubtractDays(new Date(imFrozenDate.value), new Date()), false, 4);
    }
}
function imFrozenDate_OnNoMatch()
{
    LoadControls();

    if (!IsValidDateTime(imFrozenDate.value))
    {
        txtFrozenDays.value = "";
    }
}
function HoldSetDefault()
{
    LoadControls();

    txtFrozenDays.value = <%= MediationHoldDays %>;

    txtFrozenDays_OnBlur(txtFrozenDays);
}
function HoldClear()
{
    LoadControls();

    txtFrozenAmount.value = "";
    imFrozenDate.value = "";
    txtFrozenDays.value = "";
}
function ApplicantHover(td, on)
{
    if (on)
	    td.parentElement.style.backgroundColor = "#f3f3f3";
    else
	    td.parentElement.style.backgroundColor = "#ffffff";
}
function ApplicantClick(PersonID)
{
    window.navigate("<%= ResolveUrl("~/clients/client/applicants/applicant.aspx?id=" & ClientID & "&pid=") %>" + PersonID);
}
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function ShowMessageBody(Value)
{
    var pnlBodyDefault = document.getElementById("<%= pnlBodyDefault.ClientID %>");
    var pnlBodyMessage = document.getElementById("<%= pnlBodyMessage.ClientID %>");

    pnlBodyDefault.style.display = "none";
    pnlBodyMessage.style.display = "inline";
    pnlBodyMessage.childNodes[0].rows[0].cells[0].innerHTML = Value;
}
function Record_CancelAndClose()
{
    // postback to cancel and close
    <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
}
function Record_Save()
{
    if (RequiredToSaveExist())
    {
        ShowMessageBody("...Saving negotiation session...");

        // postback to save
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
}
function RequiredToSaveExist()
{
    LoadControls();

    RemoveBorder(txtFrozenAmount);
    RemoveBorder(imFrozenDate);
    RemoveBorder(txtFrozenDays);

    // hold area
    if (txtFrozenAmount.value.length > 0 || imFrozenDate.value.length > 0 || txtFrozenDays.value.length > 0)
    {
        // frozen amount
        if (txtFrozenAmount.value.length == 0)
        {
            ShowMessage("The Hold Amount you entered is required.  To remove the Hold, clear the values from all Hold fields before saving or use the Clear option.");
            AddBorder(txtFrozenAmount);
            return false;
        }
        else
        {
            if (!IsValidNumberFloat(txtFrozenAmount.value, false, txtFrozenAmount))
            {
                ShowMessage("The Hold Amount you entered is not valid.  To remove the Hold, clear the values from all Hold fields before saving or use the Clear option.");
                AddBorder(txtFrozenAmount);
                return false;
            }
            else
            {
                RemoveBorder(txtFrozenAmount);
            }
        }

        // frozen date
        if (imFrozenDate.value.length == 0)
        {
            ShowMessage("The Hold Expiration Date you entered is required.  To remove the Hold, clear the values from all Hold fields before saving or use the Clear option.");
            AddBorder(imFrozenDate);
            return false;
        }
        else
        {
            if (!IsValidDateTime(imFrozenDate.value))
            {
                ShowMessage("The Hold Expiration Date you entered is not valid.  To remove the Hold, clear the values from all Hold fields before saving or use the Clear option.");
                AddBorder(imFrozenDate);
                return false;
            }
            else
            {
                RemoveBorder(imFrozenDate);
            }
        }

        // frozen days
        if (txtFrozenDays.value.length == 0)
        {
            ShowMessage("The Hold Expiration Days you entered is required.  To remove the Hold, clear the values from all Hold fields before saving or use the Clear option.");
            AddBorder(txtFrozenDays);
            return false;
        }
        else
        {
            if (!IsValidNumberFloat(txtFrozenDays.value, false, txtFrozenDays))
            {
                ShowMessage("The Hold Expiration Days you entered is not valid.  To remove the Hold, clear the values from all Hold fields before saving or use the Clear option.");
                AddBorder(txtFrozenDays);
                return false;
            }
            else
            {
                RemoveBorder(txtFrozenDays);
            }
        }
    }

    return true;
}
function LoadControls()
{
    if (pnlMenuDefault == null)
    {
        pnlMenuDefault = document.getElementById("<%= pnlMenuDefault.ClientID %>");
        pnlBodyDefault = document.getElementById("<%= pnlBodyDefault.ClientID %>");
        txtRegisterBalance = document.getElementById("<%= txtRegisterBalance.ClientID %>");
        txtAccountBalance = document.getElementById("<%= txtAccountBalance.ClientID %>");
        txtSettlementAmount = document.getElementById("<%= txtSettlementAmount.ClientID %>");
        txtSettlementPercentage = document.getElementById("<%= txtSettlementPercentage.ClientID %>");
        txtAmountAvailable = document.getElementById("<%= txtAmountAvailable.ClientID %>");
        txtAmountBeingSent = document.getElementById("<%= txtAmountBeingSent.ClientID %>");
        txtAmountStillOwed2 = document.getElementById("<%= txtAmountStillOwed2.ClientID %>");
        txtSavings = document.getElementById("<%= txtSavings.ClientID %>");
        lblSettlementFee = document.getElementById("<%= lblSettlementFee.ClientID %>");
        txtSettlementFee = document.getElementById("<%= txtSettlementFee.ClientID %>");
        txtOvernightDeliveryAmount = document.getElementById("<%= txtOvernightDeliveryAmount.ClientID %>");
        txtSettlementCost = document.getElementById("<%= txtSettlementCost.ClientID %>");
        txtAvailableAfterSettlement = document.getElementById("<%= txtAvailableAfterSettlement.ClientID %>");
        txtAmountBeingPaid = document.getElementById("<%= txtAmountBeingPaid.ClientID %>");
        txtAmountStillOwed = document.getElementById("<%= txtAmountStillOwed.ClientID %>");

        txtFrozenAmount = document.getElementById("<%= txtFrozenAmount.ClientID %>");
        imFrozenDate = document.getElementById("<%= imFrozenDate.ClientID %>");
        txtFrozenDays = document.getElementById("<%= txtFrozenDays.ClientID %>");
    }
}
function ResetCalculator(Executions)
{
    LoadControls();

    var RegisterBalance = parseFloat(txtRegisterBalance.value);
    var AccountBalance = parseFloat(txtAccountBalance.value);
    var SettlementAmount = parseFloat(txtSettlementAmount.value);
    var SettlementPercentage = parseFloat(txtSettlementPercentage.value);
    var AmountAvailable = parseFloat(txtAmountAvailable.value);
    var AmountBeingSent = parseFloat(txtAmountBeingSent.value);
    var Savings = 0.0;
    var SettlementFeePercentage = parseFloat(lblSettlementFee.innerHTML.replace("%", "").replace(",", "")) / 100;
    var SettlementFee = 0.0;
    var OvernightDeliveryAmount = parseFloat(txtOvernightDeliveryAmount.value);
    var SettlementCost = 0.0;
    var AvailableAfterSettlement = 0.0;
    var AmountBeingPaid = 0.0;
    var AmountStillOwed = 0.0;

    Executions = Executions.split(",");

    if (FindIndex(Executions, "C2") != -1)
    {
        SettlementPercentage = (SettlementAmount / AccountBalance) * 100;
        txtSettlementPercentage.value = FormatNumber(SettlementPercentage, false, 2);
    }

    if (FindIndex(Executions, "D") != -1)
    {
        if (SettlementAmount < RegisterBalance)
        {
            AmountAvailable = SettlementAmount;
        }
        else
        {
            AmountAvailable = RegisterBalance;
        }

        txtAmountAvailable.value = FormatNumber(AmountAvailable, false, 2);
    }

    if (FindIndex(Executions, "E") != -1)
    {
        AmountBeingSent = AmountAvailable;
        txtAmountBeingSent.value = FormatNumber(AmountBeingSent, false, 2);
    }

    if (FindIndex(Executions, "G") != -1)
    {
        Savings = AccountBalance - SettlementAmount;
        txtSavings.value = FormatNumber(Savings, false, 2);
    }

    if (FindIndex(Executions, "H") != -1)
    {
        SettlementFee = (AccountBalance - SettlementAmount) * SettlementFeePercentage;
        txtSettlementFee.value = FormatNumber(SettlementFee, false, 2);
    }

    if (FindIndex(Executions, "J") != -1)
    {
        SettlementCost = SettlementFee + OvernightDeliveryAmount;
        txtSettlementCost.value = FormatNumber(SettlementCost, false, 2);
    }

    if (FindIndex(Executions, "K") != -1)
    {
        AvailableAfterSettlement = RegisterBalance - SettlementAmount;

        if (AvailableAfterSettlement > 0)
        {
            txtAvailableAfterSettlement.value = FormatNumber(AvailableAfterSettlement, false, 2)
        }
        else
        {
            txtAvailableAfterSettlement.value = "0.00";
        }
    }

    if (FindIndex(Executions, "L") != -1)
    {
        if (AvailableAfterSettlement >= SettlementCost)
        {
            AmountBeingPaid = SettlementCost;
        }
        else
        {
            if (AvailableAfterSettlement > 0)
            {
                AmountBeingPaid = AvailableAfterSettlement;
            }
            else
            {
                AmountBeingPaid = 0.0;
            }
        }

        txtAmountBeingPaid.value = FormatNumber(AmountBeingPaid, false, 2);
    }

    if (FindIndex(Executions, "M") != -1)
    {
        AmountStillOwed = SettlementCost - AmountBeingPaid;
        txtAmountStillOwed.value = FormatNumber(AmountStillOwed, false, 2);
    }
}
function txtRegisterBalance_OnBlur(txt)
{
    ResetCalculator("C2,D,E,G,H,J,K,L,M");
}
function txtAccountBalance_OnBlur(txt)
{
    ResetCalculator("C2,D,E,G,H,J,K,L,M");
}
function txtSettlementAmount_OnBlur(txt)
{
    ResetCalculator("C2,D,E,G,H,J,K,L,M");
}
function txtSettlementPercentage_OnBlur(txt)
{
    LoadControls();

    // set amount to reflect this amount
    txtSettlementAmount.value = FormatNumber((parseFloat(txt.value) / 100) * parseFloat(txtAccountBalance.value), false, 2);

    ResetCalculator("D,E,G,H,J,K,L,M");
}
function txtAmountAvailable_OnBlur(txt)
{
    ResetCalculator("E,G,H,J,K,L,M");
}
function txtAmountBeingSent_OnBlur(txt)
{
    LoadControls();

    txtAmountAvailable.value = txtAmountBeingSent.value;

    ResetCalculator("G,H,J,K,L,M");
}
function txtSavings_OnBlur(txt)
{
    ResetCalculator("H,J,K,L,M");
}
function txtSettlementFee_OnBlur(txt)
{
    ResetCalculator("J,K,L,M");
}
function txtOvernightDeliveryAmount_OnBlur(txt)
{
    ResetCalculator("J,K,L,M");
}
function txtSettlementCost_OnBlur(txt)
{
    ResetCalculator("K,L,M");
}
function txtAvailableAfterSettlement_OnBlur(txt)
{
    ResetCalculator("L,M");
}
function txtAmountBeingPaid_OnBlur(txt)
{
    ResetCalculator("M");
}
function txtAmountStillOwed_OnBlur(txt)
{
    
}
function txtAmountStillOwed2_OnBlur(txt)
{
    txt.value = "0.00";
}
function FindIndex(Array, Value)
{
    for (var i = 0; i < Array.length; i++)
    {
        if (Array[i] === Value)
            return i;
    }
    return -1;
}

</script>

<body onload="SetFocus('');">

    <asp:Panel runat="server" ID="pnlBodyDefault">
        <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top">
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20">
                                    <img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                        &nbsp;
                    </div>
                    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td valign="top" style="width:30%;">
                                <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr><td class="cLEnrollHeader">Client</td></tr>
                                    <tr>
                                        <td>
                                            <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="3" border="0">
		                                        <tr>
			                                        <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
			                                        <td class="headItem">Type</td>
			                                        <td class="headItem">Name</td>
			                                        <td class="headItem">SSN</td>
		                                        </tr>
		                                        <asp:repeater id="rpApplicants" runat="server">
			                                        <itemtemplate>
				                                        <tr>
				                                            <td style="width:22;" onclick="ApplicantClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="ApplicantHover(this, true);" onmouseout="ApplicantHover(this, false);" class="listItem" align="center">
				                                                <img runat="server" src="~/images/16x16_person.png" border="0"/>
				                                            </td>
				                                            <td onclick="ApplicantClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="ApplicantHover(this, true);" onmouseout="ApplicantHover(this, false);" class="listItem">
				                                                <img align="absmiddle" style="margin-right:3;" title="Can Authorize" src="<%= ResolveUrl("~/images/") %><%#DataBinder.Eval(Container.DataItem, "IconLock")%>" border="0"/><%#DataBinder.Eval(Container.DataItem, "Relationship")%>
				                                            </td>
				                                            <td onclick="ApplicantClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="ApplicantHover(this, true);" onmouseout="ApplicantHover(this, false);" class="listItem">
				                                                <%#DataBinder.Eval(Container.DataItem, "Name")%>
				                                            </td>
				                                            <td onclick="ApplicantClick(<%#DataBinder.Eval(Container.DataItem, "PersonID")%>);" onmouseover="ApplicantHover(this, true);" onmouseout="ApplicantHover(this, false);" class="listItem">
				                                                <%#DataBinder.Eval(Container.DataItem, "SSNFormatted")%>
				                                            </td>
				                                        </tr>
			                                        </itemtemplate>
		                                        </asp:repeater>
	                                        </table>
                                        </td>
                                    </tr>
                                    <tr><td style="height:25;">&nbsp;</td></tr>
                                    <tr><td class="cLEnrollHeader">Account</td></tr>
                                    <tr>
                                        <td>
                                            <table style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="5" border="0">
		                                        <tr>
			                                        <td class="headItem">Creditor</td>
			                                        <td class="headItem">Account #</td>
			                                        <td class="headItem">Acquired</td>
		                                        </tr>
		                                        <asp:repeater id="rpCreditorInstances" runat="server">
			                                        <itemtemplate>
				                                        <tr>
				                                            <td><%#DataBinder.Eval(Container.DataItem, "CreditorName")%></td>
				                                            <td><%#DataBinder.Eval(Container.DataItem, "AccountNumber")%></td>
				                                            <td><%#DataBinder.Eval(Container.DataItem, "Acquired", "{0:MM/dd/yy}")%></td>
				                                        </tr>
				                                        <tr runat="server" id="trOriginalAmount">
				                                            <td colspan="3" style="padding:0 0 3 15;color:red;font-size:10px;">Original&nbsp;amount:&nbsp;<%#DataBinder.Eval(Container.DataItem, "OriginalAmount", "{0:c}")%></td>
				                                        </tr>
				                                        <tr runat="server" id="trCurrentAmount">
				                                            <td colspan="3" style="padding:0 0 3 15;color:red;font-size:10px;">Current&nbsp;amount:&nbsp;<%#DataBinder.Eval(Container.DataItem, "CurrentAmount", "{0:c}")%></td>
				                                        </tr>
				                                        <tr><td class="listItem" colspan="3" style="cursor:default;padding:0 0 0 0;width:1;height:1;"><img height="1" width="1" runat="server" border="0" src="~/images/spacer.gif" /></td></tr>
			                                        </itemtemplate>
		                                        </asp:repeater>
	                                        </table>                                            
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="width:40;" class="cLEnrollSplitter"><img width="40" height="1" src="~/images/spacer.gif" runat="server" /></td>
                            <td valign="top" style="width: 70%;">
                                <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr><td class="cLEnrollHeader">Calculator</td></tr>
                                    <tr>
                                        <td style="padding: 10 10 0 10;">
                                            <table style="font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="border-bottom:solid 1px #d1d1d1;color:#a1a1a1;">Account being settled</td>
                                                    <td style="width:25;"><img height="1" width="25" runat="server" border="0" src="~/images/spacer.gif" /></td>
                                                    <td style="border-bottom: solid 1px #d1d1d1;color:#a1a1a1;">Settlement fee calculation</td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" style="padding: 5 10 10 10;">
                                                        <table style="font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="3" border="0">
                                                            <tr>
                                                                <td style="width:20;" align="center">A.</td>
                                                                <td style="width:130;" nowrap="true">Available SDA balance:</td>
                                                                <td style="width:10;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtRegisterBalance"></asp:TextBox></td>
                                                                <td style="width:16;"><a title="Refresh the available SDA balance" href="#" onclick="return false;"><img src="~/images/16x16_exclamationpoint.png" runat="server" border="0" /></a></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:20;" align="center">B.</td>
                                                                <td style="width:130;" nowrap="true">Current account balance:</td>
                                                                <td style="width:10;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtAccountBalance"></asp:TextBox></td>
                                                                <td style="width:16;"><a title="Refresh the current account balance" href="#" onclick="return false;"><img src="~/images/16x16_exclamationpoint.png" runat="server" border="0" /></a></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:20;" align="center">C.1</td>
                                                                <td style="width:130;" nowrap="true">Settlement amount:</td>
                                                                <td style="width:10;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtSettlementAmount"></asp:TextBox></td>
                                                                <td style="width:16;"></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:20;" align="center">C.2</td>
                                                                <td style="width:130;" nowrap="true">Settlement percentage:</td>
                                                                <td style="width:10;" align="center">%</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtSettlementPercentage"></asp:TextBox></td>
                                                                <td style="width:16;"></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:20;" align="center">D.</td>
                                                                <td style="width:130;" nowrap="true">Amount available:</td>
                                                                <td style="width:10;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtAmountAvailable"></asp:TextBox></td>
                                                                <td style="width:16;"></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:20;" align="center">E.</td>
                                                                <td style="width:130;" nowrap="true">Amount being sent:</td>
                                                                <td style="width:10;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtAmountBeingSent"></asp:TextBox></td>
                                                                <td style="width:16;"></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:20;" align="center">F.</td>
                                                                <td style="width:130;" nowrap="true">Amount still owed:</td>
                                                                <td style="width:10;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtAmountStillOwed2"></asp:TextBox></td>
                                                                <td style="width:16;"></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td style="width:25;">&nbsp;</td>
                                                    <td valign="top" style="padding: 5 10 10 10;">
                                                        <table style="font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="3" border="0">
                                                            <tr>
                                                                <td style="width:15;" align="center">G.</td>
                                                                <td style="width:130;" nowrap="true">Total amount saved:</td>
                                                                <td style="width:5;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtSavings"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:15;" align="center">H.</td>
                                                                <td style="width:130;" nowrap="true">Settlement fee (G x <asp:Label runat="server" ID="lblSettlementFee"></asp:Label>):</td>
                                                                <td style="width:5;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtSettlementFee"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:15;" align="center">I.</td>
                                                                <td style="width:130;" nowrap="true">Overnight delivery fee:</td>
                                                                <td style="width:5;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtOvernightDeliveryAmount"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:15;" align="center">J.</td>
                                                                <td style="width:130;" nowrap="true">Total settlement cost:</td>
                                                                <td style="width:5;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtSettlementCost"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:15;" align="center">K.</td>
                                                                <td style="width:130;" nowrap="true">Available after settlement:</td>
                                                                <td style="width:5;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtAvailableAfterSettlement"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:15;" align="center">L.</td>
                                                                <td style="width:130;" nowrap="true">Amount being paid:</td>
                                                                <td style="width:5;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtAmountBeingPaid"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:15;" align="center">M.</td>
                                                                <td style="width:130;" nowrap="true">Amount still owed:</td>
                                                                <td style="width:5;" align="center">$</td>
                                                                <td style="width:60;"><asp:TextBox style="text-align:right;" MaxLength="10" CssClass="entry" runat="server" ID="txtAmountStillOwed"></asp:TextBox></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <table style="width:100%;height:100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="width:50%;" valign="top">
                                            <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td class="cLEnrollHeader">
                                                        <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td style="font-weight:bold;">Holds</td>
                                                                <td align="right"><a href="javascript:HoldClear();" id="lnkHoldClear" class="lnk" runat="server">Clear</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:HoldSetDefault();" id="lnkHoldSetDefault" class="lnk" runat="server">Set Default</a></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:10 20 0 20;">
                                                        <table style="font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="3" border="0">
                                                            <tr>
                                                                <td style="width:90;" nowrap="true">Amount to hold:</td>
                                                                <td style="width:10;" align="center">$</td>
                                                                <td style="width:115;"><asp:TextBox CssClass="entry" runat="server" ID="txtFrozenAmount"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:90;" nowrap="true">Expiration date:</td>
                                                                <td style="width:10;" align="center">&nbsp;</td>
                                                                <td style="width:115;"><cc1:InputMask CssClass="entry" runat="server" Mask="nn/nn/nnnn nn:nn aa" ID="imFrozenDate"></cc1:InputMask></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width:90;" nowrap="true">Expiration days:</td>
                                                                <td style="width:10;" align="center">&nbsp;</td>
                                                                <td style="width:115;"><asp:TextBox CssClass="entry" runat="server" ID="txtFrozenDays"></asp:TextBox></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="width:40;" class="cLEnrollSplitter"><img runat="server" width="40" height="1" src="~/images/spacer.gif" /></td>
                                        <td style="width:50%;" valign="top">
                                            <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                                                <tr><td class="cLEnrollHeader">Status</td></tr>
                                                <tr>
                                                    <td style="padding: 10 20 0 20;">
                                                        <asp:RadioButtonList CellPadding="0" CellSpacing="0" Font-Names="Tahoma" Font-Size="11px" runat="server" ID="optStatus">
                                                            <asp:ListItem Value="0" Text="Still in negogiation process"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Rejected by creditor"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Rejected by client"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text="Accepted by both creditor and client"></asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlBodyMessage" Style="display: none;">
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top" align="center">
                </td>
            </tr>
        </table>
    </asp:Panel>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>

</body>

</asp:Content>