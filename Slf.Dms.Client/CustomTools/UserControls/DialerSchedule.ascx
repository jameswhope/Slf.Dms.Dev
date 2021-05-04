<%@ Control Language="VB" AutoEventWireup="false" CodeFile="DialerSchedule.ascx.vb"
    Inherits="CustomTools_UserControls_DialerSchedule" %>
<table>
    <tr id="trRetryafter" runat="server">
        <td nowrap="nowrap" >
            <asp:LinkButton ID="lnkDialerResumeAfter" runat="server" Title="Click to Edit"></asp:LinkButton>
        </td>
        <td>
            &nbsp;
        </td>
        <td>
            <asp:Button ID="btnSet24" runat="server" Text="24 hr" ToolTip="Hold dialer for 24 hrs" />
        </td>
        <td>
            &nbsp;
        </td>
    </tr>
    <tr id="trRetryAfterEdit" runat="server" >
        <td style="Width: 100px;" nowrap="nowrap">
            <asp:TextBox ID="txtDialerAfter" runat="server" Width="70px" style="background-color: #ffffcc;"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtDialerAfter_CalendarExtender" runat="server"
                Enabled="True" TargetControlID="txtDialerAfter" PopupButtonID="imgEditDialerDate">
            </ajaxToolkit:CalendarExtender>
            <ajaxToolkit:MaskedEditExtender ID="MaskedEditDateExtender" TargetControlID="txtDialerAfter" Mask="99/99/9999"
                MessageValidatorTip="true" OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditError"
                MaskType="Date" InputDirection="RightToLeft" ErrorTooltipEnabled="True" runat="server"  UserDateFormat="MonthDayYear" ClearMaskOnLostFocus="true"  />
            <asp:Image ID="imgEditDialerDate" ImageUrl="~/images/Calendar_scheduleHS.png" runat="server"
                Style="vertical-align: middle;" />
        </td>
        <td>
            <asp:TextBox ID="txtDialerTimeAfter" runat="server" Width="57px" style="background-color: #ffffcc;"></asp:TextBox>
             <ajaxToolkit:MaskedEditExtender ID="MaskedEditTimeExtender" TargetControlID="txtDialerTimeAfter" Mask="99:99"
                MessageValidatorTip="true" OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditError"
                MaskType="Time" InputDirection="RightToLeft" ErrorTooltipEnabled="True" runat="server" AcceptAMPM="true" UserTimeFormat="None"   ClearMaskOnLostFocus="true"  />
        </td>
        <td>
            <asp:Button ID="btnDialerRetrySave" runat="server" Text="Save" Width="47px" />
        </td>
        <td>
            <asp:Button ID="btnDialerRetryCancel" runat="server" Text="Cancel" Width="47px" />
        </td>
    </tr>
</table>
<asp:HiddenField ID="hdnDialerClientId" runat="server" />
<asp:HiddenField ID="hdnMatterId" runat="server" />
