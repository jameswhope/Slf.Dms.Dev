<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CalculatorControl.ascx.vb"
    Inherits="negotiation_webparts_CalculatorControl" %>

<style type="text/css">
.headerCell
{
    text-align: right;
    font-family:Tahoma;
    font-weight:bold;
}
.textCell
{
    text-align: right;
}
.calcCell
{
    text-align: right;
    width:100px;
}

INPUT
{
    border:none;
    font-family:Tahoma;
}
.modalBackground 
{
    background-color:#808080;
    filter:alpha(opacity=70);
    opacity:0.7;
}
.modalPopup 
{
    background-color: #F5FAFD;
    border-width:1px;
    border-style:ridge;
    border-color:Gray;
    padding:0px;
    width:60%;
} 
.PanelDragHeader
{
 background-color:steelblue;
 color:White;
 text-align: center;
 cursor:hand;
}
  .MyCalendar .ajax__calendar_header {height:20px;width:100%;background-color:lightsteelblue}
    .MyCalendar .ajax__calendar_today {cursor:pointer;padding-top:3px; background-color:lightsteelblue}
    .MyCalendar .ajax__calendar_container {border:1px solid #646464;background-color: white;color: black;}
    .MyCalendar .ajax__calendar_other .ajax__calendar_day,
    .MyCalendar .ajax__calendar_other .ajax__calendar_year {color: gray;}
    .MyCalendar .ajax__calendar_hover .ajax__calendar_day,
    .MyCalendar .ajax__calendar_hover .ajax__calendar_month,
    .MyCalendar .ajax__calendar_hover .ajax__calendar_year {color: black;}
    .MyCalendar .ajax__calendar_active .ajax__calendar_day,
    .MyCalendar .ajax__calendar_active .ajax__calendar_month,
    .MyCalendar .ajax__calendar_active .ajax__calendar_year  {color: black;font-weight:bold;background-color:lightsteelblue;}

</style>

<script type="text/javascript">
function DueDate_SelectionChanged()
{
    var hdnDueDate = document.getElementById('<%=hdnDueDate.ClientID %>');
    var txtDueDate = document.getElementById('<%=txtDueDate.ClientID %>');
    
    hdnDueDate.value = txtDueDate.value;
    
    <%=Page.ClientScript.GetPostBackEventReference(lnkDueDate, Nothing) %>;
}

function ConvertToCurrency(num)
{
    return new Number(num).localeFormat('c');
}

function updateDataByPercent(ctl){

    //debt amt
    var CurrentDebtBal = document.getElementById('<%=lblCurrentBalance.ClientID %>');
    //sett amt
    var SettAmt = document.getElementById('<%=txtSettlementAmt.ClientID %>');
    //sett cost
    var SettCost = document.getElementById('<%=lblSettlementCost.ClientID %>');
    //sett saving
    var SettSavings = document.getElementById('<%=lblSettlementSavings.ClientID %>');
    
    //fee fields
    var regBal = document.getElementById('<%=lblAvailRegisterBal.ClientID %>');
    var SettFeePercentage = document.getElementById('<%=lblSettlementFeePercentage.ClientID %>');
    var amtAvail = document.getElementById('<%=lblAvailSDABal.ClientID %>');
    var SettFeeAmtAvail = document.getElementById('<%=lblSettlementFee_AmtAvailable.ClientID %>');
    var SettFeeAmtPaid = document.getElementById('<%=lblSettlementFee_AmtBeingPaid.ClientID %>');
    var SettFeeAmtOwed = document.getElementById('<%=lblSettlementFee_AmtStillOwed.ClientID %>');
    
    //percent of creditor acct bal
    var perValue = parseFloat(ctl.value);
    if (perValue.toString == '0' || isNaN(perValue)==true){
        SettSavings.value = ConvertToCurrency(0);
        SettCost.value = ConvertToCurrency(0);
        SettAmt.value = ConvertToCurrency(0);
        return;
    }

    //get bal owed to creditor
    var CreditorAcctBal = parseFloat(CurrentDebtBal.innerText.replace(/,/g, "").replace("$",""));
    
    //amt creditor will settle acct for
    var SettlementAmt =  GetAmount(CreditorAcctBal,perValue)
    SettAmt.value =  String.format("{0:N2}",SettlementAmt);
    
    //amt client saved 
    var SettlementSavings = CreditorAcctBal-SettlementAmt
    SettSavings.innerText = ConvertToCurrency(SettlementSavings);
    
    //update fee calcs
    //get avail register bal
    var tempRegBal = regBal.innerText.replace(/,/g, "").replace("$","");
    if (isNaN(parseFloat(tempRegBal))==true){
        var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$","").replace("(","").replace(")",""));
        RegisterBalance = RegisterBalance*-1;
    }else{
        var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$",""));
    }
    
    if (parseFloat(RegisterBalance) - parseFloat(SettlementAmt)> 0 ){
        amtAvail.value = ConvertToCurrency(SettAmt.value);
    }else{
        amtAvail.value = ConvertToCurrency(parseFloat(regBal.innerText.replace(/,/g, "").replace("$","")));
    }
    
    //sett fee        
    var SettFee = document.getElementById('<%=lblSettlementFee.ClientID %>');
    var SettFeeAmt = parseFloat(SettFeePercentage.value.replace(/,/g, "").replace("$",""))/100 * SettlementSavings; 
    SettFee.value = ConvertToCurrency(SettFeeAmt)
    
    //sett fee credit
    var SettFeeCredit = document.getElementById('<%=lblSettlementFeeCredit.ClientID %>');
    var SettFeeCreditValue = parseFloat(SettFeeCredit.value.replace(/,/g, "").replace("$","").replace("(","").replace(")",""));
    
    //od fee
    var odFee = document.getElementById('<%=lblOvernightDeliveryCost.ClientID %>');
    var odFeeValue = parseFloat(odFee.value.replace(/,/g, "").replace("$",""))
    if (SettFeeAmt > SettFeeCreditValue){
        var sCost =  (SettFeeAmt-SettFeeCreditValue) +  odFeeValue;
    }else{
        var sCost =  0 +  odFeeValue;
    }
    SettCost.value = ConvertToCurrency(sCost);
    
    
    var dBal = parseFloat(RegisterBalance) - parseFloat(SettlementAmt);
    if (dBal > sCost){
        SettFeeAmtAvail.value = ConvertToCurrency(sCost);
        SettFeeAmtOwed.value = ConvertToCurrency('0');
    }else{
        SettFeeAmtAvail.value = ConvertToCurrency(dBal);
        var owed = sCost - dBal        
        SettFeeAmtOwed.value = ConvertToCurrency(owed);
    }

    SettFeeAmtPaid.value = SettFeeAmtAvail.value
    
    
    
}

function updateDataByAmount(ctl){

    ctl.value = ctl.value.replace(/\$|\,/g,'')

    var CurrentDebtBal = document.getElementById('<%=lblCurrentBalance.ClientID %>');
    var SettPercent = document.getElementById('<%=txtSettlementPercent.ClientID %>');
    var SettCost = document.getElementById('<%=lblSettlementCost.ClientID %>');
    var SettSavings = document.getElementById('<%=lblSettlementSavings.ClientID %>');
    var AmtValue = parseFloat(ctl.value);

    if (AmtValue.toString == '0' || isNaN(AmtValue)==true){
        SettSavings.value = ConvertToCurrency(0);
        SettCost.value = ConvertToCurrency(0);
        return;
    }

    var perVal = GetPercent(AmtValue,parseFloat(CurrentDebtBal.innerText.replace(/,/g, "").replace("$","")));
    SettPercent.value = String.format("{0:N2}",perVal);

    var SettValue = parseFloat(CurrentDebtBal.innerText.replace(/,/g, "").replace("$",""));

    var savingValue = SettValue - AmtValue;
    SettSavings.value = ConvertToCurrency(savingValue);

  //get avail register bal
    var regBal = document.getElementById('<%=lblAvailRegisterBal.ClientID %>');
    var tempRegBal = regBal.innerText.replace(/,/g, "").replace("$","");
    if (isNaN(parseFloat(tempRegBal))==true){
        var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$","").replace("(","").replace(")",""));
        RegisterBalance = RegisterBalance*-1;
    }else{
        var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$",""));
    }
    
    var SettFeePercentage = document.getElementById('<%=lblSettlementFeePercentage.ClientID %>');
    var amtAvail = document.getElementById('<%=lblAvailSDABal.ClientID %>');

    if (parseFloat(RegisterBalance) - parseFloat(AmtValue)> 0 ){
        amtAvail.value = ConvertToCurrency(AmtValue);
    }else{
        amtAvail.value = ConvertToCurrency(parseFloat(regBal.innerText.replace(/,/g, "").replace("$","")));
    }
    
    //settlement fee
    var SettFee = document.getElementById('<%=lblSettlementFee.ClientID %>');
    var SettFeeAmt = parseFloat(SettFeePercentage.value.replace(/,/g, "").replace("$",""))/100 * savingValue;
    SettFee.innerText = ConvertToCurrency(SettFeeAmt)
    
    //sett fee credit
    var SettFeeCredit = document.getElementById('<%=lblSettlementFeeCredit.ClientID %>');
    var SettFeeCreditValue = parseFloat(SettFeeCredit.value.replace(/,/g, "").replace("$","").replace("(","").replace(")",""));
    
    //Me.Settlement_Cost = Me.Settlement_Fee + Me.Client_OvernightDeliveryFee
    var odFee = document.getElementById('<%=lblOvernightDeliveryCost.ClientID %>');
    var odFeeValue = parseFloat(odFee.value.replace(/,/g, "").replace("$",""))
    if (SettFeeAmt > SettFeeCreditValue){
        var sCost =  (SettFeeAmt-SettFeeCreditValue) +  odFeeValue;
    }else{
        var sCost =  0 +  odFeeValue;
    }
    
    SettCost.value = ConvertToCurrency(sCost);
    
    var SettFeeAmtAvail = document.getElementById('<%=lblSettlementFee_AmtAvailable.ClientID %>');
    var SettFeeAmtPaid = document.getElementById('<%=lblSettlementFee_AmtBeingPaid.ClientID %>');
    var SettFeeAmtOwed = document.getElementById('<%=lblSettlementFee_AmtStillOwed.ClientID %>');

    var dBal = RegisterBalance - AmtValue;
    if (dBal > sCost){
        SettFeeAmtAvail.value = ConvertToCurrency(sCost);
        SettFeeAmtOwed.value = ConvertToCurrency('0');
    }else{
        SettFeeAmtAvail.value = ConvertToCurrency(dBal);
        var owed = sCost - dBal        
        SettFeeAmtOwed.value = ConvertToCurrency(owed);
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
</script>

<asp:UpdatePanel ID="upDefault" runat="server">
    <ContentTemplate>
        <table id="table_calc" style="font-size: 8pt; height: 260px;" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td style="vertical-align: top; border-right: solid 1px #A1D0E0; border-bottom: solid 1px #A1D0E0;">
                    <table class="box">
                        <tr>
                            <td style="height: 35px;">
                            </td>
                            <td style="height: 35px;">
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" nowrap>
                                <asp:Label Text="Available SDA Bal:" ID="Label1" runat="server" />
                            </td>
                            <td nowrap="nowrap" class="textCell">
                                <asp:Label ID="lblAvailSDABal" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell">
                                <asp:Label Text="SDA Balance:" ForeColor="graytext" ID="Label2" runat="server" />
                            </td>
                            <td nowrap="nowrap" class="textCell">
                                <asp:Label Text="" ForeColor="graytext" ID="lblAvailRegisterBal" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell">
                                <asp:Label Text="Funds on Hold:" ForeColor="graytext" ID="Label3" runat="server" />
                            </td>
                            <td nowrap="nowrap" class="textCell">
                                <asp:Label ID="lblFrozenAmt" ForeColor="graytext" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell">
                                <asp:Label Text="Account Bal:" ID="Label4" runat="server" />
                            </td>
                            <td nowrap="nowrap" class="textCell">
                                <asp:Label ID="lblCurrentBalance" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell">
                                <asp:Label Text="Next Dep Date:" ID="Label5" runat="server" />
                            </td>
                            <td nowrap="nowrap" class="textCell">
                                <asp:Label ID="lblNextDepDate" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell">
                                <asp:Label Text="Next Dep Amt:" ID="Label7" runat="server" />
                            </td>
                            <td nowrap="nowrap" class="textCell">
                                <asp:Label ID="lblNextDepAmt" runat="server" Text="" />
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="border-bottom: solid 1px #A1D0E0;" valign="top">
                    <table class="box">
                        <tr style="height: 35px; vertical-align: top; text-align: center; font-size: 12pt">
                            <td colspan="2">
                                <asp:Label ID="labeltitle" runat="server" Text="Settlement Fee Calculation" Font-Size="Small"
                                    Font-Bold="true" />
                            </td>
                        </tr>
                        <tr class="headerCell">
                            <td>
                                Savings:</td>
                            <td>
                                <asp:TextBox Width="55px" ID="lblSettlementSavings" runat="server" CssClass="label cur"></asp:TextBox></td>
                        </tr>
                        <tr class="headerCell">
                            <td>
                                <asp:TextBox Style="display: none; border: none; text-align: right; width: 15px"
                                    Enabled="false" ID="lblSettlementFeePercentage" runat="server"></asp:TextBox>Settlement
                                Fee:</td>
                            <td>
                                <asp:TextBox ID="lblSettlementFee" Width="55px" runat="server" CssClass="label cur"></asp:TextBox></td>
                        </tr>
                        <tr class="headerCell">
                            <td nowrap="nowrap" style="height: 22px">
                                Settlement Fee Credit:</td>
                            <td style="height: 22px">
                                <asp:TextBox ID="lblSettlementFeeCredit" runat="server" CssClass="label cur" Width="55px"></asp:TextBox></td>
                        </tr>
                        <tr class="headerCell">
                            <td nowrap="nowrap" style="height: 22px">
                                Overnight Delivery Cost:</td>
                            <td style="height: 22px">
                                <asp:TextBox ID="lblOvernightDeliveryCost" Width="55px" runat="server" CssClass="label cur"></asp:TextBox></td>
                        </tr>
                        <tr class="headerCell">
                            <td>
                                Total Cost:</td>
                            <td>
                                <asp:TextBox ID="lblSettlementCost" runat="server" Width="55px" CssClass="label cur"></asp:TextBox></td>
                        </tr>
                        <tr class="headerCell">
                            <td>
                                Amount Available:</td>
                            <td>
                                <asp:TextBox ID="lblSettlementFee_AmtAvailable" Width="55px" runat="server" CssClass="label cur"></asp:TextBox></td>
                        </tr>
                        <tr class="headerCell">
                            <td>
                                Amount Being Paid:</td>
                            <td>
                                <asp:TextBox ID="lblSettlementFee_AmtBeingPaid" Width="55px" runat="server" CssClass="label cur"></asp:TextBox></td>
                        </tr>
                        <tr class="headerCell">
                            <td>
                                Amount Still Owed:</td>
                            <td>
                                <asp:TextBox ID="lblSettlementFee_AmtStillOwed" Width="55px" runat="server" CssClass="label cur"></asp:TextBox></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table class="box" style="width: 100%;">
                        <tr>
                            <td colspan="2">
                                <asp:RadioButtonList ID="radDirection" runat="server" CssClass="label" Font-Bold="true"
                                    Font-Names="tahoma" RepeatDirection="Vertical" RepeatLayout="Table" TextAlign="right">
                                    <asp:ListItem Selected="True" Value="Received">Offer received from Creditor</asp:ListItem>
                                    <asp:ListItem Value="Made">Offer made to Creditor</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <div>
                                    Settlement Amt:
                                    <asp:TextBox ID="txtSettlementPercent" runat="server" AutoPostBack="false" Enabled="true"
                                        Height="12px" MaxLength="5" onchange="javascript:updateDataByPercent(this);"
                                        onkeyup="javascript:updateDataByPercent(this);" Width="25px" Wrap="False">0</asp:TextBox>%
                                </div>
                                <div>
                                    <asp:ImageButton ID="imgDown" runat="server" AlternateText="Down" Height="15" ImageUrl="~/negotiation/images/droparrow_off.png"
                                        onmouseout="SwapImage(this);" onmouseover="SwapImage(this);" Width="15" />
                                </div>
                                <div>
                                    <asp:ImageButton ID="imgUp" runat="server" AlternateText="Up" Height="15" ImageUrl="~/negotiation/images/uparrow_off.png"
                                        onmouseout="SwapImage(this);" onmouseover="SwapImage(this);" Width="15" />
                                </div>
                                <div>
                                    $<asp:TextBox ID="txtSettlementAmt" runat="server" AutoPostBack="false" CssClass="cur"
                                        Height="12px" onkeyup="javascript:updateDataByAmount(this);" Width="40px" Wrap="False">0.00</asp:TextBox>
                                </div>
                                <ajaxToolkit:NumericUpDownExtender ID="NumericUpDownExtender1" runat="server" Maximum="100"
                                    Minimum="1" RefValues="" ServiceDownMethod="" ServiceUpMethod="" TargetButtonDownID="imgDown"
                                    TargetButtonUpID="imgUp" TargetControlID="txtSettlementPercent" Width="60">
                                </ajaxToolkit:NumericUpDownExtender>
                            </td>
                            <td align="right" style="height: 40px;">
                                <asp:ImageButton ID="ibtnAccept" runat="server" ImageUrl="~/negotiation/images/accept_off.png"
                                    OnClick="ibtnAccept_Click" onmouseout="SwapImage(this);" onmouseover="SwapImage(this);" />
                                <asp:ImageButton ID="ibtnReject" runat="server" ImageUrl="~/negotiation/images/reject_off.png"
                                    OnClick="ibtnReject_Click" onmouseout="SwapImage(this);" onmouseover="SwapImage(this);" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:Button ID="btnDummy" runat="server" Style="display: none;" />
        <ajaxToolkit:ModalPopupExtender ID="mpeAccept" runat="server" TargetControlID="btnDummy"
            PopupControlID="pnlAccept" CancelControlID="btnClose" BackgroundCssClass="modalBackground" />
        <asp:Panel ID="pnlAccept" runat="server" Style="display: none" CssClass="modalPopup">
            <asp:Panel ID="Panel2" runat="server" Style="display: block;" CssClass="PanelDragHeader">
                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr class="headerstyle">
                        <td align="left" style="padding-left: 10px;">
                            <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="14pt" Text="Accept Offer" /></td>
                        <td align="right" style="padding-right: 10px;">
                            <asp:LinkButton ID="btnClose" runat="server" ForeColor="white" Text="Close" Width="50px" /></td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlDueDate" runat="server" Style=" height:75px;text-align: center; display: block;
                color: White; font-size:14pt; vertical-align:top;">
                <asp:Label style="font-size:14pt;"  runat="server" ID="lblDate" Text="Select Offer Due Date:" />
                <asp:TextBox style="border:1px solid darkblue; font-size:14pt; height:20px;" ID="txtDueDate" Width="150px" runat="server"/>
                <asp:ImageButton runat="Server" ID="Image1" ImageUrl="~/images/Calendar_scheduleHS.png"
                    AlternateText="Click to show calendar" />
                <ajaxToolkit:CalendarExtender ID="extDueDate" OnClientDateSelectionChanged="DueDate_SelectionChanged" runat="server" TargetControlID="txtDueDate"
                    PopupButtonID="image1" CssClass="MyCalendar"/>
                    <br />
            </asp:Panel>
            <asp:Panel ID="pnlSettAcceptForm" Style="display: none; text-align: center;" runat="server"
                Width="100%">
                <iframe id="rptFrame" runat="server" src="" style="width: 100%; height: 400px" ></iframe>
            </asp:Panel>
        </asp:Panel>
        
        <asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnNoteID" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnDueDate" runat="server" />
        <asp:LinkButton ID="lnkDueDate" runat="server" />
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ibtnReject" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
