<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlementControl.ascx.vb"
    Inherits="research_negotiation_preview_SettlementControl" %>
<link href="preview.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
function FormatCurrency(num,decimalNum,bolLeadingZero,bolParens,bolCommas)
/**********************************************************************
	IN:
		NUM - the number to format
		decimalNum - the number of decimal places to format the number to
		bolLeadingZero - true / false - display a leading zero for
										numbers between -1 and 1
		bolParens - true / false - use parenthesis around negative numbers
		bolCommas - put commas as number separators.										
 
	RETVAL:
		The formatted number!		
 **********************************************************************/
{
	var tmpStr = new String(FormatNumber(num,decimalNum,bolLeadingZero,bolParens,bolCommas));

	if (tmpStr.indexOf("(") != -1 || tmpStr.indexOf("-") != -1) {
		// We know we have a negative number, so place '$' inside of '(' / after '-'
		if (tmpStr.charAt(0) == "(")
			tmpStr = "($"  + tmpStr.substring(1,tmpStr.length);
		else if (tmpStr.charAt(0) == "-")
			tmpStr = "-$" + tmpStr.substring(1,tmpStr.length);
			
		return tmpStr;
	}
	else
		return "$" + tmpStr;		// Return formatted string!
}


function FormatNumber(num,decimalNum,bolLeadingZero,bolParens,bolCommas)
/**********************************************************************
	IN:
		NUM - the number to format
		decimalNum - the number of decimal places to format the number to
		bolLeadingZero - true / false - display a leading zero for
										numbers between -1 and 1
		bolParens - true / false - use parenthesis around negative numbers
		bolCommas - put commas as number separators.
 
	RETVAL:
		The formatted number!
 **********************************************************************/
{ 
        if (isNaN(parseInt(num))) return "NaN";

	var tmpNum = num;
	var iSign = num < 0 ? -1 : 1;		// Get sign of number
	
	// Adjust number so only the specified number of numbers after
	// the decimal point are shown.
	tmpNum *= Math.pow(10,decimalNum);
	tmpNum = Math.round(Math.abs(tmpNum))
	tmpNum /= Math.pow(10,decimalNum);
	tmpNum *= iSign;					// Readjust for sign
	
	
	// Create a string object to do our formatting on
	var tmpNumStr = new String(tmpNum);

	// See if we need to strip out the leading zero or not.
	if (!bolLeadingZero && num < 1 && num > -1 && num != 0)
		if (num > 0)
			tmpNumStr = tmpNumStr.substring(1,tmpNumStr.length);
		else
			tmpNumStr = "-" + tmpNumStr.substring(2,tmpNumStr.length);
		
	// See if we need to put in the commas
	if (bolCommas && (num >= 1000 || num <= -1000)) {
		var iStart = tmpNumStr.indexOf(".");
		if (iStart < 0)
			iStart = tmpNumStr.length;

		iStart -= 3;
		while (iStart >= 1) {
			tmpNumStr = tmpNumStr.substring(0,iStart) + "," + tmpNumStr.substring(iStart,tmpNumStr.length)
			iStart -= 3;
		}		
	}

	// See if we need to use parenthesis
	if (bolParens && num < 0)
		tmpNumStr = "(" + tmpNumStr.substring(1,tmpNumStr.length) + ")";

	return tmpNumStr;		// Return our formatted string!
}
function updateDataByPercent(ctl){
    //debt amt
    var CurrentDebtBal = document.getElementById('<%=txtCurrentBalance.ClientID %>');
    //sett amt
    var SettAmt = document.getElementById('<%=txtSettlementAmt.ClientID %>');
    //sett cost
    var SettCost = document.getElementById('<%=lblSettlementCost.ClientID %>');
    //sett saving
    var SettSavings = document.getElementById('<%=lblSettlementSavings.ClientID %>');
    //sett percent
    var perValue = parseInt(ctl.value);
    if (perValue.toString == '0' || isNaN(perValue)==true){
        SettSavings.value = FormatCurrency(0,2,false,false,false);
        SettCost.value = FormatCurrency(0,2,false,false,false);
        SettAmt.value = FormatCurrency(0,2,false,false,false);
        return;
    }

    var SettValue = parseFloat(CurrentDebtBal.value);
    var CostValue = GetAmount(SettValue,perValue)
    var savingValue = SettValue - CostValue;
    SettSavings.value = FormatCurrency(savingValue,2,false,false,false);
    SettAmt.value = FormatNumber(CostValue,2,false,false,false);
    
    var regBal = document.getElementById('<%=lblAvailRegisterBal.ClientID %>');
    var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$",""));
    var SettFeePercentage = document.getElementById('<%=lblSettlementFeePercentage.ClientID %>');
    var amtAvail = document.getElementById('<%=lblAmtAvailable.ClientID %>');
    var amtBeingSent = document.getElementById('<%=lblAmtBeingSent.ClientID %>');

    if (parseFloat(RegisterBalance) - parseFloat(SettAmt.value)> 0 ){
        amtAvail.value = FormatCurrency(SettAmt.value ,2,false,false,false);
        amtBeingSent.value = FormatCurrency(SettAmt.value ,2,false,false,false);
    }else{
        amtAvail.value = FormatCurrency(parseFloat(regBal.value.replace(/,/g, "").replace("$","")),2,false,false,false);
        amtBeingSent.value =FormatCurrency(parseFloat(regBal.value.replace(/,/g, "").replace("$","")),2,false,false,false);
    }
    
    var amtStillOwed = document.getElementById('<%=lblAmtStillOwed.ClientID %>');
    var amtOwed = parseFloat(amtAvail.value.replace(/,/g, "").replace("$","")) - parseFloat(amtBeingSent.value.replace(/,/g, "").replace("$",""))
    amtStillOwed.value = FormatCurrency(amtOwed,2,false,false,false);
        
    var SettFee = document.getElementById('<%=lblSettlementFee.ClientID %>');
    SettFee.value = FormatCurrency(parseFloat(SettFeePercentage.innerText.replace(/,/g, "").replace("$",""))/100 * savingValue,2,false,false,false);
    
    //Me.Settlement_Cost = Me.Settlement_Fee + Me.Client_OvernightDeliveryFee
    var odFee = document.getElementById('<%=lblOvernightDeliveryCost.ClientID %>');
    var sCost =  parseFloat(SettFee.value.replace(/,/g, "").replace("$","")) +  parseFloat(odFee.value.replace(/,/g, "").replace("$",""));
    SettCost.value = FormatCurrency(sCost,2,false,false,false);
    
    var SettFeeAmtAvail = document.getElementById('<%=lblSettlementFee_AmtAvailable.ClientID %>');
    var SettFeeAmtPaid = document.getElementById('<%=lblSettlementFee_AmtBeingPaid.ClientID %>');
    var SettFeeAmtOwed = document.getElementById('<%=lblSettlementFee_AmtStillOwed.ClientID %>');
    
    var dBal = parseFloat(RegisterBalance) - parseFloat(SettAmt.value.replace(/,/g, "").replace("$",""));
    if (dBal > sCost){
        SettFeeAmtAvail.value = FormatCurrency(sCost,2,false,false,false);
        SettFeeAmtOwed.value = FormatCurrency('0',2,false,false,false);
    }else{
        SettFeeAmtAvail.value = FormatCurrency(dBal,2,false,false,false);
        var owed = sCost - dBal        
        SettFeeAmtOwed.value = FormatCurrency(owed,2,false,false,false);
    }

    SettFeeAmtPaid.value = SettFeeAmtAvail.value
    
}

function updateDataByAmount(ctl){
    
    var CurrentDebtBal = document.getElementById('<%=txtCurrentBalance.ClientID %>');
    var SettPercent = document.getElementById('<%=txtSettlementPercent.ClientID %>');
    var SettCost = document.getElementById('<%=lblSettlementCost.ClientID %>');
    var SettSavings = document.getElementById('<%=lblSettlementSavings.ClientID %>');
    var AmtValue = parseFloat(ctl.value);

    if (AmtValue.toString == '0' || isNaN(AmtValue)==true){
        SettSavings.value = FormatCurrency(0,2,false,false,false);
        SettCost.value = FormatCurrency(0,2,false,false,false);
        return;
    }

    var perVal = GetPercent(AmtValue,parseFloat(CurrentDebtBal.value));
    SettPercent.value = FormatNumber(perVal,1,false,false,false);

    var SettValue = parseFloat(CurrentDebtBal.value);

    var savingValue = SettValue - AmtValue;
    SettSavings.value = FormatCurrency(savingValue,2,false,false,false);

    var regBal = document.getElementById('<%=lblAvailRegisterBal.ClientID %>');
    var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$",""));
    var SettFeePercentage = document.getElementById('<%=lblSettlementFeePercentage.ClientID %>');
    var amtAvail = document.getElementById('<%=lblAmtAvailable.ClientID %>');
    var amtBeingSent = document.getElementById('<%=lblAmtBeingSent.ClientID %>');

    if (parseFloat(RegisterBalance) - parseFloat(AmtValue)> 0 ){
        amtAvail.value = FormatCurrency(AmtValue ,2,false,false,false);
        amtBeingSent.value = FormatCurrency(AmtValue ,2,false,false,false);
    }else{
        amtAvail.value = FormatCurrency(parseFloat(regBal.value.replace(/,/g, "").replace("$","")),2,false,false,false);
        amtBeingSent.value =FormatCurrency(parseFloat(regBal.value.replace(/,/g, "").replace("$","")),2,false,false,false);
    }
    
    var amtStillOwed = document.getElementById('<%=lblAmtStillOwed.ClientID %>');
    var amtOwed = parseFloat(amtAvail.value.replace(/,/g, "").replace("$","")) - parseFloat(amtBeingSent.value.replace(/,/g, "").replace("$",""))
    amtStillOwed.value = FormatCurrency(amtOwed,2,false,false,false);
        
    var SettFee = document.getElementById('<%=lblSettlementFee.ClientID %>');
    SettFee.value = FormatCurrency(parseFloat(SettFeePercentage.innerText.replace(/,/g, "").replace("$",""))/100 * savingValue,2,false,false,false);
    
    //Me.Settlement_Cost = Me.Settlement_Fee + Me.Client_OvernightDeliveryFee
    var odFee = document.getElementById('<%=lblOvernightDeliveryCost.ClientID %>');
    var sCost =  parseFloat(SettFee.value.replace(/,/g, "").replace("$","")) +  parseFloat(odFee.value.replace(/,/g, "").replace("$",""));
    SettCost.value = FormatCurrency(sCost,2,false,false,false);
    
    var SettFeeAmtAvail = document.getElementById('<%=lblSettlementFee_AmtAvailable.ClientID %>');
    var SettFeeAmtPaid = document.getElementById('<%=lblSettlementFee_AmtBeingPaid.ClientID %>');
    var SettFeeAmtOwed = document.getElementById('<%=lblSettlementFee_AmtStillOwed.ClientID %>');
    
    var dBal = RegisterBalance - AmtValue;
    if (dBal > sCost){
        SettFeeAmtAvail.value = FormatCurrency(sCost,2,false,false,false);
        SettFeeAmtOwed.value = FormatCurrency('0',2,false,false,false);
    }else{
        SettFeeAmtAvail.value = FormatCurrency(dBal,2,false,false,false);
        var owed = sCost - dBal        
        SettFeeAmtOwed.value = FormatCurrency(owed,2,false,false,false);
    }

    SettFeeAmtPaid.value = SettFeeAmtAvail.value
            
}
function GetAmount(total,percent){
    var percentAMT = total*(percent/100)
    return percentAMT
}
function GetPercent(amt,total){
    var percentAmt = (amt/total)*100
    return percentAmt
}
function UpdateText(ctl){
    var txt = document.getElementById('<%=txtNote.ClientID %>');
    txt.innerText = ctl.value;
   
}
</script>

<asp:ScriptManagerProxy ID="smpSett" runat="server" />
<table>
    <tr>
        <td colspan="3" class="GridHeaderCell">
            <strong>Settlement #
                <asp:Label ID="lblSettlementNum" runat="server" Text="Label"></asp:Label>
            </strong>
        </td>
    </tr>
    <tr>
        <td colspan="3" style="display: none; color: Red; background-color: Yellow;" id="tdError"
            runat="server">
        </td>
    </tr>
    <tr>
        <td valign="top">
            <asp:Panel runat="server" ID="Panel1" CssClass="cssbox">
                <div class="cssbox_head">
                    <h3>
                        Creditor/Client Info</h3>
                </div>
                <div class="cssbox_body">
                    <table>
                        <tr>
                            <td valign="top">
                                <table>
                                    <tr>
                                        <td class="GridCellHdr" style="height: 19px">
                                            Client</td>
                                        <td class="GridCellText" style="height: 19px">
                                            <asp:Label ID="lblClientName" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            SSN #
                                        </td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblClientSSN" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            Co-Applicant</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblClientCoAppName" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            SSN #</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblClientCoAppSSN" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            Original Creditor</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblOriginalCreditor" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            Current Creditor</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblCurrentCreditor" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            Account #</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblCreditorAcctNum" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            Reference #</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblCreditorRefNum" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td class="GridCellHdr">
                                            Bank Balance as of &nbsp;
                                            <asp:Label ID="lblAsOfDate" runat="server" /></td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblBankBal" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            Register Balance</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblRegisterBal" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td class="GridCellHdr">
                                            Frozen Amount</td>
                                        <td class="GridCellText">
                                            <asp:Label ID="lblFrozenAmt" runat="server" Text="Label"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>
            </asp:Panel>
        </td>
        <td valign="top">
            <asp:Panel runat="server" ID="Panel3" CssClass="cssbox">
                <div class="cssbox_head">
                    <h3>
                        Account Being Settled</h3>
                </div>
                <div class="cssbox_body">
                    <table style="font-size: 8pt;">
                        <tr align="center">
                            <td colspan="3">
                                <asp:RadioButtonList Font-Names="tahoma" ID="radDirection" runat="server" RepeatDirection="Horizontal"
                                    Width="100%">
                                    <asp:ListItem Selected="True">From Us</asp:ListItem>
                                    <asp:ListItem>From Creditor</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                A.</td>
                            <td class="GridCellTextList">
                                Available Register Balance</td>
                            <td>
                                $
                                <asp:TextBox CssClass="moneyText" Enabled="false" ID="lblAvailRegisterBal" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="color: Red; vertical-align: bottom;">
                            <td class="GridCellList">
                                B.</td>
                            <td class="GridCellTextList">
                                Current Balance
                            </td>
                            <td>
                                $
                                <asp:TextBox CssClass="moneyText" Enabled="false" ID="txtCurrentBalance" runat="server"
                                    Width="85px"></asp:TextBox></td>
                        </tr>
                        <tr style="color: Red; vertical-align: bottom;">
                            <td class="GridCellList">
                                C.</td>
                            <td class="GridCellTextList" nowrap="nowrap">
                                Settlement Amount
                                <asp:TextBox Style="text-align: right;" onkeyup="javascript:updateDataByPercent(this);"
                                    ID="txtSettlementPercent" runat="server" Width="30px" AutoPostBack="false" />%
                            </td>
                            <td>
                                $
                                <asp:TextBox CssClass="moneyText" onkeyup="javascript:updateDataByAmount(this);"
                                    ID="txtSettlementAmt" runat="server" AutoPostBack="false"></asp:TextBox>
                                <asp:ImageButton ID="imgAccept" runat="server" ToolTip="Accept Offer" ImageUrl="~/research/negotiation/preview/ajax/accept.png"
                                    OnClick="imgAccept_Click" />
                                <asp:ImageButton ID="imgReject" runat="server" ToolTip="Reject Offer" ImageUrl="~/research/negotiation/preview/ajax/reject.png"
                                    OnClick="imgReject_Click" />
                            </td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                D.</td>
                            <td class="GridCellTextList">
                                Amount Avaliable</td>
                            <td>
                                $
                                <asp:TextBox ID="lblAmtAvailable" Enabled="false" CssClass="moneyText" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                E.</td>
                            <td class="GridCellTextList">
                                Amount Being Sent</td>
                            <td>
                                $
                                <asp:TextBox ID="lblAmtBeingSent" Enabled="false" CssClass="moneyText" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                F.</td>
                            <td class="GridCellTextList">
                                Amount Still Owed*</td>
                            <td>
                                $
                                <asp:TextBox ID="lblAmtStillOwed" Enabled="false" CssClass="moneyText" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                            </td>
                            <td align="right" class="GridCellTextList">
                                Due Date</td>
                            <td>
                                <asp:TextBox ID="txtDueDate" Width="75px" Font-Size="8pt" runat="server"></asp:TextBox>
                                <asp:ImageButton runat="Server" ID="Image1" ImageUrl="~/images/Calendar_scheduleHS.png"
                                    AlternateText="Click to show calendar" />
                                <ajaxToolkit:CalendarExtender ID="extDueDate" runat="server" TargetControlID="txtDueDate"
                                    PopupButtonID="image1" CssClass="MyCalendar">
                                </ajaxToolkit:CalendarExtender>
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>
            </asp:Panel>
        </td>
        <td valign="top">
            <asp:Panel runat="server" ID="Panel4" CssClass="cssbox">
                <div class="cssbox_head">
                    <h3>
                        Settlement Fee Calculation</h3>
                </div>
                <div class="cssbox_body">
                    <table style="width: 98%; height: 125px; font-size: 8pt;">
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                G.
                            </td>
                            <td style="" class="GridCellTextList">
                                Savings</td>
                            <td>
                                $
                                <asp:TextBox ID="lblSettlementSavings" Enabled="false" CssClass="moneyText" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                H.</td>
                            <td style="" class="GridCellTextList">
                                Settlement Fee (G x
                                <asp:Label ID="lblSettlementFeePercentage" runat="server" Text="Label"></asp:Label>%)</td>
                            <td>
                                $
                                <asp:TextBox ID="lblSettlementFee" Enabled="false" CssClass="moneyText" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                I.</td>
                            <td style="" class="GridCellTextList">
                                Disbursement Delivery Cost</td>
                            <td>
                                $
                                <asp:TextBox ID="lblOvernightDeliveryCost" Enabled="false" CssClass="moneyText" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                J.</td>
                            <td style="" class="GridCellTextList">
                                Settlement Cost</td>
                            <td>
                                $
                                <asp:TextBox ID="lblSettlementCost" Enabled="false" CssClass="moneyText" runat="server"
                                    Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                K.</td>
                            <td class="GridCellTextList">
                                Amount Available</td>
                            <td>
                                $
                                <asp:TextBox ID="lblSettlementFee_AmtAvailable" Enabled="false" CssClass="moneyText"
                                    runat="server" Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                L.</td>
                            <td style="" class="GridCellTextList">
                                Amount Being Paid</td>
                            <td>
                                $
                                <asp:TextBox ID="lblSettlementFee_AmtBeingPaid" Enabled="false" CssClass="moneyText"
                                    runat="server" Text="Label"></asp:TextBox></td>
                        </tr>
                        <tr style="vertical-align: bottom;">
                            <td class="GridCellList">
                                M.</td>
                            <td style="" class="GridCellTextList">
                                Amount Still Owed**</td>
                            <td>
                                $
                                <asp:TextBox ID="lblSettlementFee_AmtStillOwed" Enabled="false" CssClass="moneyText"
                                    runat="server" Text="Label"></asp:TextBox></td>
                        </tr>
                    </table>
                    <br />
                </div>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <td align="center" colspan="3" valign="top">
            <table>
                <tr>
                    <td>
                        <asp:LinkButton CssClass="actionButton" ID="lnkCancel" runat="server">Cancel Settlement</asp:LinkButton></td>
                    <td class="menuSeparator">
                        |</td>
                    <td>
                        <asp:LinkButton CssClass="actionButton" ID="lnkHold" runat="server">Hold / Save</asp:LinkButton></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top" colspan="3">
            &nbsp;
        </td>
    </tr>
    <tr>
        <td colspan="3" align="center">
            <ajaxToolkit:TabContainer CssClass="myTab" ID="tabSett" Width="100%" runat="server"
                ActiveTabIndex="1" AutoPostBack="false">
                <ajaxToolkit:TabPanel ID="TabPanel1" runat="server" HeaderText="Additional Info">
                    <ContentTemplate>
                        <table width="100%">
                            <tr style="color: #1080BF; height: 30px; font-size: 14pt; background-image: url(ajax/grid_bg.png);
                                background-repeat: repeat-x;">
                                <td>
                                    Contact
                                </td>
                                <td>
                                    Notes
                                </td>
                            </tr>
                            <tr valign="top">
                                <td style="width: 50%">
                                    <table style="font-size: 8pt;">
                                        <tr>
                                            <td align="right">
                                                Contact Name</td>
                                            <td colspan="2" align="left">
                                                <asp:TextBox ID="TextBox6" runat="server" Width="100%"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                Contact Phone
                                            </td>
                                            <td colspan="2" align="left">
                                                <asp:TextBox ID="txtContactPhone" runat="server"></asp:TextBox>&nbsp; ext
                                                <asp:TextBox ID="TextBox8" runat="server" Width="35px"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                    <ajaxToolkit:MaskedEditExtender ID="mskPhone" runat="server" Mask="\(999\)999\-9999"
                                        ClearMaskOnLostFocus="False" Enabled="True" TargetControlID="txtContactPhone"
                                        CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                        CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                        CultureTimePlaceholder="">
                                    </ajaxToolkit:MaskedEditExtender>
                                </td>
                                <td>
                                    <table style="width: 100%;">
                                        <tr>
                                            <td>
                                                <asp:DropDownList ID="ddlNotes" AutoPostBack="false" onchange="javascript:UpdateText(this);"
                                                    runat="server" Width="100%">
                                                    <asp:ListItem Value="0" Selected="True">Select Note Template</asp:ListItem>
                                                    <asp:ListItem>Client account is now with a different firm or creditor</asp:ListItem>
                                                    <asp:ListItem>Creditor accepted offer</asp:ListItem>
                                                    <asp:ListItem>Creditor calling in for an update on account</asp:ListItem>
                                                    <asp:ListItem>Creditor counter offer</asp:ListItem>
                                                    <asp:ListItem>Creditor need POA</asp:ListItem>
                                                    <asp:ListItem>Creditor rejected offer</asp:ListItem>
                                                    <asp:ListItem>Creditor will try to get offer approved</asp:ListItem>
                                                    <asp:ListItem>Explain program to Creditor; client does not have money to settle account</asp:ListItem>
                                                    <asp:ListItem>Faxed offer to Creditor</asp:ListItem>
                                                    <asp:ListItem>Left message for Creditor</asp:ListItem>
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox ID="txtNote" runat="server" Height="75px" TextMode="MultiLine" Width="100%"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabHistory" runat="server" HeaderText="History">
                    <ContentTemplate>
                        <asp:GridView ID="GridView1" runat="server" Width="100%" AllowPaging="True" AllowSorting="True"
                            AutoGenerateColumns="False" DataSourceID="SqlDataSource1" PageSize="5">
                            <RowStyle CssClass="GridRowStyle"></RowStyle>
                            <AlternatingRowStyle CssClass="GridAlternatingRowStyle" />
                            <PagerStyle CssClass="GridPagerStyle"></PagerStyle>
                            <HeaderStyle CssClass="GridHeaderStyle"></HeaderStyle>
                            <EmptyDataTemplate>
                                <div>
                                    No records to display.</div>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkSelect" runat="server" CommandArgument='<%#bind("SettlementID") %>'
                                            CommandName="Select">Select</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                                <asp:BoundField DataField="OfferDirection" HeaderText="Offer Direction" SortExpression="OfferDirection" />
                                <asp:BoundField DataField="Created" DataFormatString="{0:d}" HtmlEncode="False" HeaderText="Created"
                                    SortExpression="Created">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CreditorAccountBalance" DataFormatString="{0:C}" HtmlEncode="False"
                                    HeaderText="Creditor Account Balance" SortExpression="CreditorAccountBalance">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementPercent" HeaderText="Settlement Percent" SortExpression="SettlementPercent">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementAmount" DataFormatString="{0:C}" HtmlEncode="False"
                                    HeaderText="Settlement Amount" SortExpression="SettlementAmount">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="settlementDueDate" DataFormatString="{0:d}" HtmlEncode="False"
                                    HeaderText="settlement Due Date" SortExpression="settlementDueDate">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="settlementSavings" DataFormatString="{0:C}" HtmlEncode="False"
                                    HeaderText="Settlement Savings" SortExpression="SettlementSavings">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementFee" DataFormatString="{0:C}" HtmlEncode="False"
                                    HeaderText="Settlement Fee" SortExpression="SettlementFee">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementCost" DataFormatString="{0:C}" HtmlEncode="False"
                                    HeaderText="Settlement Cost" SortExpression="SettlementCost">
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SettlementNotes" HeaderText="Settlement Notes" SortExpression="SettlementNotes" />
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                            SelectCommand="SELECT [CreditorAccountBalance], [SettlementPercent], [SettlementAmount], [SettlementDueDate], [SettlementSavings], [SettlementFee], [SettlementCost], [SettlementNotes], [Status], [Created], [SettlementID], [OfferDirection] FROM [tblSettlements] order by [Created] desc">
                        </asp:SqlDataSource>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
            </ajaxToolkit:TabContainer>
        </td>
    </tr>
</table>
