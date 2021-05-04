<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NonDepositMatterResolve.ascx.vb"
    Inherits="CustomTools_UserControls_NonDepositMatterResolve" %>
<script src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>" type="text/javascript"></script>
<script src="<%= ResolveUrl("~/jscript/validation/Display.js") %>" type="text/javascript"></script>
<script src="<%= ResolveUrl("~/jscript/domain.js") %>" type="text/javascript" ></script>   
 <script type="text/javascript" language="javascript">

    if (window.parent.currentModalDialog) {
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
    }

    function singleDot(txt, e) {
        var digits = '0123456789';
        var cmds = 'acxvz';
        if ((e.shiftKey == true) ||
                (txt.value.indexOf('.') != -1 && (e.keyCode == 190 || e.keyCode == 110)) ||
                (digits.indexOf(String.fromCharCode(e.keyCode)) == -1 && IsSpecialKey(e.keyCode) == false && e.ctrlKey == false))
            return false;
        else
            return true;
    }

    function digitOnly(txt, e) {
        var digits = '0123456789';
        if ((e.shiftKey == true) || (e.keyCode == 190) || (e.keyCode == 110) || (digits.indexOf(String.fromCharCode(e.keyCode)) == -1 && IsSpecialKey(e.keyCode) == false && e.ctrlKey == false))
            return false;
        else
            return true;
    }

    function IsSpecialKey(keyCode) {
        if (keyCode == 190 || keyCode == 110 || keyCode == 8 || keyCode == 9 || keyCode == 13 || keyCode == 45 || keyCode == 46 || (keyCode > 16 && keyCode < 21) || (keyCode > 34 && keyCode < 41) || (keyCode > 95 && keyCode < 106))
            return true;
        else
            return false;
    }
    function FormatAmount(txt) {
        txt.value = FormatNumber(parseFloat(txt.value), true, 2);
    }

    function CloseNonDepResolve(resolved) {
        if (window.parent.currentModalDialog) {
            window.parent.currentModalDialog.modaldialog("returnValue", resolved);
        } else { 
            window.returnValue = resolved;
        }
        window.close();
        return false;
    }
    function SaveNoWarning() {
        var btn = document.getElementById('<%= lnkSaveNoWarning.CLientId%>');  
        btn.click();
        return false;
    }
        
</script>  
<div>
    <div id="dvError" runat="server" style="padding: 5px 5px 5px 5px; width:95%; background-color: #FFFF99; vertical-align: absmiddle; ">
        <asp:Label ID="lblError" runat="server" Style="Font-family: Tahoma; font-size: 11px; color: Red; vertical-align: absmiddle;"></asp:Label>
    </div>
    <table style="width: 360px; font-family:Verdana; font-size: 11px; ">
        <tr>
            <td>
               Resolve Non Deposit Matter:<br /><br />
            </td>
        </tr>
        <tr>
            <td style="padding-left: 10px;">
                <asp:RadioButton GroupName="rdResolve" ID="rdCannot" runat="server" 
                    Text="Client cannot make the deposit." AutoPostBack="True" />
            </td>
        </tr>
        <tr>
            <td style="padding-left: 10px;" >
                <asp:RadioButton GroupName="rdResolve" ID="rdCan" runat="server" 
                    Text="Client will make up deposit:" AutoPostBack="True" TabIndex="1" />
                <br />
                <table id="tbWillMakeDeposit" runat="server" style="table-layout:fixed; width: 100%;"    >
                    <tr>
                        <td style="font-family: tahoma; font-size: 11px; padding-left: 30px; width: 105px; ">
                            Deposit Type:
                        </td>
                        <td style="padding-left: 7px;">
                            <asp:DropDownList ID="ddlDepositMethod" runat="server" AutoPostBack="True" 
                                Width="155px" 
                                style="font-family: tahoma; font-size: 11px; background-color: #ffffcc;" 
                                TabIndex="2">
                                <asp:ListItem Text="Additional ACH" Value="Additional"  />
                                <asp:ListItem Text="Check" Value="Check" Selected="False"/>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-family: tahoma; font-size: 11px; padding-left: 30px; width: 105px;">
                            Date:
                        </td>
                        <td style="padding-left: 7px;">
                            <asp:TextBox ID="txtDepositDate" runat="server" Width="70px" 
                                style="font-family: tahoma; font-size: 11px; background-color: #ffffcc;" 
                                TabIndex="3"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="CalendarDepositDateExtender" runat="server" Enabled="True"
                                TargetControlID="txtDepositDate" PopupButtonID="imgDate">
                            </ajaxToolkit:CalendarExtender>
                            <ajaxToolkit:MaskedEditExtender ID="MaskedEditDepoaitDateExtender" TargetControlID="txtDepositDate"
                                Mask="99/99/9999" MessageValidatorTip="true" OnFocusCssClass="MaskedEditFocus"
                                OnInvalidCssClass="MaskedEditError" MaskType="Date" InputDirection="RightToLeft"
                                ErrorTooltipEnabled="True" runat="server" UserDateFormat="MonthDayYear" ClearMaskOnLostFocus="true" />
                            <asp:Image ID="imgDate" ImageUrl="~/images/Calendar_scheduleHS.png" runat="server"
                                Style="vertical-align: middle;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-family: tahoma; font-size: 11px; padding-left: 30px; width: 105px;">
                            Amount:
                        </td>
                        <td style="font-family: tahoma; font-size: 11px;">
                            $<asp:TextBox ID="txtDepositAmount" runat="server" Width="70px"  
                                style="font-family: tahoma; font-size: 11px; text-align: right; background-color: #ffffcc;" 
                                onkeydown="return singleDot(this, event);" onblur="FormatAmount(this);" 
                                TabIndex="4"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-left: 29px;">
                            <table id="tbBanking" style="margin: 0 30 0 0; float: left; font-family: tahoma; font-size: 11px;
                                width: 300;" border="0" cellpadding="5" cellspacing="0" runat="server">
                                <tr>
                                    <td style="background-color: #f1f1f1;">
                                        Bank Information
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="table-layout: fixed; font-family: tahoma; font-size: 11px; width: 100%;"
                                            border="0" cellpadding="0" cellspacing="5">
                                            <tr id="trSelectBank" runat="server">
                                                <td style="width: 100px;">
                                                    Select Bank:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBankName" class="entry" runat="server" AutoPostBack="True"
                                                        Width="155px" AppendDataBoundItems="false" 
                                                        style="font-family: tahoma; font-size: 11px;background-color: #ffffcc;" 
                                                        TabIndex="5">
                                                        <asp:ListItem Text=" " Value="select" />
                                                        <asp:ListItem Text="(Add Bank)" Value="add" />
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td >
                                                    Bank Name:
                                                </td>
                                                <td >
                                                    <asp:Label ID="lblBankName" runat="server" ></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td >
                                                    Routing Number:
                                                </td>
                                                <td >
                                                    <asp:TextBox MaxLength="9" validate="IsValidTextLength(Input.value, 9, 9);" caption="Bank Routing Number"
                                                        required="true" TabIndex="6" ID="txtBankRoutingNumber" runat="server" 
                                                        style="font-family: tahoma; font-size: 11px; background-color: #ffffcc;"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Account Number:
                                                </td>
                                                <td>
                                                    <asp:TextBox MaxLength="255" validate="" caption="Bank Account Number" required="true"
                                                        TabIndex="7" ID="txtBankAccountNumber" runat="server" 
                                                        style="font-family: tahoma; font-size: 11px; background-color: #ffffcc;"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Account Type:
                                                </td>
                                                <td>
                                                    <asp:DropDownList class="entry" ID="cboBankType" runat="server" 
                                                        Style="font-size: 11px; background-color: #ffffcc;" TabIndex="8">
                                                        <asp:ListItem Value="0" Text=""></asp:ListItem>
                                                        <asp:ListItem Value="C" Text="Checking"></asp:ListItem>
                                                        <asp:ListItem Value="S" Text="Savings"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr id="trAccountDisabled" style="display: none;" runat="server">
                                                <td colspan="2" style="color: Red" align="left">
                                                    &nbsp;
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
        <tr>
            <td style="padding-left: 10px;">
                <asp:RadioButton GroupName="rdResolve" ID="rdPostpone" runat="server" 
                    Text="Suspend Non-dep. Dialer Until:" AutoPostBack="True" TabIndex="9" />
                <table id="tbPostponeDialer" style="margin: 0 0 0 10" runat="server" >
                    <tr>
                        <td nowrap="nowrap" style="padding-left: 30px;">
                            Date:
                            <asp:TextBox ID="txtDialerAfter" runat="server" Width="70px" 
                                style="font-family: tahoma; font-size: 11px; background-color: #ffffcc;" 
                                TabIndex="10"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="txtDialerAfter_CalendarExtender" runat="server"
                                Enabled="True" TargetControlID="txtDialerAfter" PopupButtonID="imgEditDialerDate">
                            </ajaxToolkit:CalendarExtender>
                            <ajaxToolkit:MaskedEditExtender ID="MaskedEditDateExtender" TargetControlID="txtDialerAfter"
                                Mask="99/99/9999" MessageValidatorTip="true" OnFocusCssClass="MaskedEditFocus"
                                OnInvalidCssClass="MaskedEditError" MaskType="Date" InputDirection="RightToLeft"
                                ErrorTooltipEnabled="True" runat="server" UserDateFormat="MonthDayYear" ClearMaskOnLostFocus="true" />
                            <asp:Image ID="imgEditDialerDate" ImageUrl="~/images/Calendar_scheduleHS.png" runat="server"
                                Style="vertical-align: middle;" />
                        </td>
                        <td nowrap="nowrap">
                            Time:
                            <asp:TextBox ID="txtDialerTimeAfter" runat="server" Width="57px" 
                                style="font-family: tahoma; font-size: 11px; background-color: #ffffcc;" 
                                TabIndex="11"></asp:TextBox>
                            <ajaxToolkit:MaskedEditExtender ID="MaskedEditTimeExtender" TargetControlID="txtDialerTimeAfter"
                                Mask="99:99" MessageValidatorTip="true" OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditError"
                                MaskType="Time" InputDirection="RightToLeft" ErrorTooltipEnabled="True" runat="server"
                                AcceptAMPM="true" UserTimeFormat="None" ClearMaskOnLostFocus="true" />&nbsp;or&nbsp;<asp:Button 
                                ID="btn24" runat="server" Text="24hr" 
                                style="font-family: tahoma; font-size: 12px;" TabIndex="12"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="padding-left: 10px;">
                <asp:RadioButton GroupName="rdResolve" ID="rdCancelRequest" runat="server" 
                    Text="Client requests to CANCEL." AutoPostBack="True" />
            </td>
        </tr>
        <tr id="trCloseError" runat="server"  >
            <td style="padding-left: 10px;">
                <asp:RadioButton GroupName="rdResolve" ID="rdError" runat="server" 
                    Text="Close it. Created in ERROR." AutoPostBack="True" />
            </td>
        </tr>
        <tr>
            <td>
                <br />Note: <br />
                <asp:TextBox ID="txtNote" runat="server" 
                    
                    style="font-family: tahoma; font-size: 11px; width: 280px; height: 40px; background-color: #ffffcc;" 
                    TextMode="MultiLine" TabIndex="13"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="center" style="padding: 5px 5px 5px 5px;" >
                <asp:LinkButton ID="lnkSave" runat="server" 
                    style="font-family: tahoma; font-size: 12px; text-decoration: none; padding: 5px 5px 5px 5px; width: 60px;" 
                    TabIndex="14" >Save</asp:LinkButton>&nbsp;
                <asp:LinkButton ID="lnkCancel" runat="server" 
                    style="font-family: tahoma; font-size: 12px; text-decoration: none; padding: 5px 5px 5px 5px; width: 60px;"   
                    OnClientClick="return CloseNonDepResolve(0);" TabIndex="15" >Cancel</asp:LinkButton>
            </td>
        </tr>
        
    </table>

<asp:HiddenField ID="hdnMatterId" runat="server" />
<asp:HiddenField ID="hdnClientId" runat="server" />
<asp:HiddenField ID="hdnNonDepositId" runat="server" />
<asp:LinkButton ID="lnkSaveNoWarning" runat="server" />
</div>
