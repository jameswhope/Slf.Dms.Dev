<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ContactsControl.ascx.vb"
    Inherits="negotiation_webparts_ContactsControl" %>

<asp:UpdatePanel ID="upCred" runat="server">
    <ContentTemplate>
        <table id="table_contact" style="width: 100%;" class="box">
            <tr>
                <td align="right" nowrap="nowrap">
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Name:" />
                </td>
                <td align="left" nowrap="nowrap">
                    <asp:TextBox ID="txtEditFirst" TabIndex="1" Width="75px" runat="server" ToolTip="First Name" />&nbsp;
                    <asp:TextBox ID="txtEditLast" TabIndex="2" Width="100px" runat="server" ToolTip="Last Name" />
                    <ajaxToolkit:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender1" runat="server"
                        TargetControlID="txtEditFirst" WatermarkText="First Name">
                    </ajaxToolkit:TextBoxWatermarkExtender>
                    <ajaxToolkit:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender2" runat="server"
                        TargetControlID="txtEditLast" WatermarkText="Last Name">
                    </ajaxToolkit:TextBoxWatermarkExtender>
                </td>
            </tr>
            <tr>
                <td align="right" nowrap="nowrap">
                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Tel Number:" />
                </td>
                <td nowrap="nowrap">
                    <asp:TextBox ToolTip="Area Code" Width="30px" ID="txtEditArea" TabIndex="3" onkeyup="javascript:MoveToNext(this, 4);"
                        runat="server" />
                    <ajaxToolkit:MaskedEditExtender ID="meeArea" runat="server" TargetControlID="txtEditArea"
                        MaskType="Number" Mask="(999)" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                    <asp:TextBox ID="txtEditNumber" Width="55px" ToolTip="Phone Number" TabIndex="4"
                        onkeyup="javascript:MoveToNext(this, 8);" runat="server" />
                    <ajaxToolkit:MaskedEditExtender ID="meeNumber" runat="server" TargetControlID="txtEditNumber"
                        MaskType="Number" Mask="999-9999" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                    <asp:TextBox Width="35px" ID="txtEditExt" ToolTip="Extension if available." TabIndex="5"
                        onkeyup="javascript:MoveToNext(this, 5);" runat="server" />
                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtEditExt"
                        MaskType="None" Mask="99999" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                </td>
            </tr>
            <tr>
                <td align="right" nowrap="nowrap">
                    <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Fax Number:" />
                </td>
                <td nowrap="nowrap">
                    <asp:TextBox ToolTip="Area Code" Width="30px" ID="txtEditFaxArea" TabIndex="6" onkeyup="javascript:MoveToNext(this, 4);"
                        runat="server" />
                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtEditFaxArea"
                        MaskType="Number" Mask="(999)" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                    <asp:TextBox Width="55px" ToolTip="Fax Number" ID="txtEditFax" TabIndex="7" onkeyup="javascript:MoveToNext(this, 8);"
                        runat="server" />
                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtEditFax"
                        MaskType="Number" Mask="999-9999" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                </td>
            </tr>
            <tr>
                <td align="right" nowrap="nowrap">
                    <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Email:" />
                </td>
                <td align="left" nowrap="nowrap">
                    <asp:TextBox ID="txtEditEmail" Width="150px" TabIndex="8" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    <asp:ImageButton ID="ibtnUpdate" onmouseout="SwapImage(this);" onmouseover="SwapImage(this);"
                        CausesValidation="true" CommandName="Update" runat="server" TabIndex="9" ImageUrl="~/negotiation/images/save_off.png" />
                </td>
            </tr>
        </table>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ibtnUpdate" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
<asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hdnNoteID" runat="server" EnableViewState="true" />
