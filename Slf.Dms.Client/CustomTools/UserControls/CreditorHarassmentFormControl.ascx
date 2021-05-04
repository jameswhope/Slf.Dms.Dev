<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CreditorHarassmentFormControl.ascx.vb"
    Inherits="CreditorHarassmentFormControl" %>
<asp:UpdateProgress ID="upHarass" runat="server" AssociatedUpdatePanelID="pnlUpdate">
    <ProgressTemplate>
        <div id="processMessage" style="position: absolute; top: 45%; left: 35%; width: 150px;
            height: 75px; color: Black; background-color: White; border: solid 1px black;">
            <div style="text-align: center; vertical-align: middle;">
                <br />
                Saving Form...
                <br />
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/bigloading.gif" />
            </div>
        </div>
    </ProgressTemplate>
</asp:UpdateProgress>
<asp:LinkButton ID="lnkShow" runat="server" Text="Create Harassment Form"></asp:LinkButton>
<asp:Panel ID="Panel1" runat="server" ScrollBars="None" CssClass="modalHarassPopup"
    Style="display: none;">
    <asp:UpdatePanel ID="pnlUpdate" runat="server">
        <ContentTemplate>
            <asp:Panel ID="pnlPopHdrHarass" runat="server" Style="display: block;" CssClass="formTitleBar">
                Client Debt Collection Abuse Intake Form
            </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" Style="display: block; height: 625px; width: 100%;"
                ScrollBars="Auto">
                <div id="dvError" runat="server" style="display: none; width:50%;" class="error">
                    No Reason Selected!!!
                </div>
                <ajaxToolkit:Accordion ID="accHarassmentForm" runat="server" CssClass="entry" HeaderCssClass="accHeader"
                    ContentCssClass="accContent" FadeTransitions="true" TransitionDuration="250" AutoSize="None">
                    <Panes>
                        <ajaxToolkit:AccordionPane ID="acpInfo" runat="server">
                            <Header>
                                Client Info</Header>
                            <Content>
                                <table class="entry" border="0">
                                    <tr>
                                        <td align="right">
                                            Client Account Number :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox runat="server" ID="txtAcctNum_8_String" Width="200px" CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Card Holder's Name :
                                        </td>
                                        <td align="left">
                                            <asp:DropDownList ID="cboCardHolderName_9_string" runat="server" Width="75%" CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            State :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtStateName_132_string" runat="server" CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Contact Date :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="dteAbuse_133_string" Width="200px" runat="server" CssClass="entry2" />
                                            <asp:ImageButton runat="Server" ID="img_dteAbuse_133_string" ImageUrl="~/images/Calendar_scheduleHS.png"
                                                AlternateText="Click to show calendar" />
                                            <ajaxToolkit:CalendarExtender ID="extDueDate" runat="server" TargetControlID="dteAbuse_133_string"
                                                PopupButtonID="img_dteAbuse_133_string" CssClass="MyCalendar" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Original Creditor :
                                        </td>
                                        <td align="left">
                                            <asp:DropDownList ID="cboOrigCreditor" runat="server" Width="75%" CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Have you been sued by this Creditor?
                                        </td>
                                        <td align="left">
                                            <asp:RadioButtonList ID="radSued" runat="server" RepeatDirection="Horizontal" CssClass="entry2">
                                                <asp:ListItem>Yes</asp:ListItem>
                                                <asp:ListItem>No</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Debt Collector :
                                        </td>
                                        <td align="left">
                                            <asp:DropDownList ID="cboDebtCollector_137_string" runat="server" Width="75%" CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Individual Calling :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtSpokeIndividualCalling_135_String" runat="server" Width="200px"
                                                CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr id="trIndividualCalling">
                                        <td>
                                        </td>
                                        <td align="left">
                                            <asp:CheckBoxList ID="cblSpokeCallingIndividual_16_array" runat="server" CssClass="entry2">
                                                <asp:ListItem Text="Identified themselves as a bill collector" />
                                                <asp:ListItem Text="Claimed to be law enforcement or connected with federal, state or local government" />
                                                <asp:ListItem Text="Claimed to be an Attorney or with an Attorney's office" />
                                                <asp:ListItem Text="Claimed to be employed by a Credit Bureau" />
                                                <asp:ListItem Text="Other" />
                                            </asp:CheckBoxList>
                                            <asp:TextBox ID="txtSpokeCallingIndividualOther_17_string" runat="server" Width="200px"
                                                CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Phone # of Caller :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtSpokeCallingIndividualPhone_136_string" runat="server" Width="100px"
                                                CssClass="entry2" />
                                            <ajaxToolkit:MaskedEditExtender ID="txtSpokeCallingIndividualPhone_136_string_MaskedEditExtender"
                                                runat="server" TargetControlID="txtSpokeCallingIndividualPhone_136_string" PromptCharacter="#"
                                                MaskType="Number" Mask="(999) 999-9999" MessageValidatorTip="true" ClearTextOnInvalid="true"
                                                ClearMaskOnLostFocus="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Phone number creditor called :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtPhoneCreditorCalled" runat="server" Width="100px"
                                                CssClass="entry2" />
                                            <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender6"
                                                runat="server" TargetControlID="txtPhoneCreditorCalled" PromptCharacter="#"
                                                MaskType="Number" Mask="(999) 999-9999" MessageValidatorTip="true" ClearTextOnInvalid="true"
                                                ClearMaskOnLostFocus="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Most recent date of abuse :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="dteSpokeCallingIndividualDateOfAbuse_19_string" Width="200px" runat="server"
                                                CssClass="entry2" />
                                            <asp:ImageButton runat="Server" ID="img_dteSpokeCallingIndividualDateOfAbuse_19_string"
                                                ImageUrl="~/images/Calendar_scheduleHS.png" AlternateText="Click to show calendar" />
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="dteSpokeCallingIndividualDateOfAbuse_19_string"
                                                PopupButtonID="img_dteSpokeCallingIndividualDateOfAbuse_19_string" CssClass="MyCalendar" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Date abuse began :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="dteDateAbuseBegan" Width="200px" runat="server" CssClass="entry2" />
                                            <asp:ImageButton runat="Server" ID="ImageButton1" ImageUrl="~/images/Calendar_scheduleHS.png"
                                                AlternateText="Click to show calendar" />
                                            <ajaxToolkit:CalendarExtender ID="dteDateAbuseBegan_CalendarExtender4" runat="server"
                                                TargetControlID="dteDateAbuseBegan" PopupButtonID="img_dteDateAbuseBegan_19_string"
                                                CssClass="MyCalendar" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Times called (on most recent date of abuse) :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtSpokeCallingIndividualNumTimesCalled_20_string" runat="server"
                                                Width="100px" Text="0" CssClass="entry2" />
                                            <ajaxToolkit:FilteredTextBoxExtender ID="txtSpokeCallingIndividualNumTimesCalled_20_string_FilteredTextBoxExtender"
                                                runat="server" TargetControlID="txtSpokeCallingIndividualNumTimesCalled_20_string"
                                                FilterType="Numbers" FilterMode="ValidChars" />
                                        </td>
                                    </tr>
                                     <tr>
                                        <td align="right">
                                            Estimated number of daily calls during period of abuse :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtEstNumTimes" runat="server"
                                                Width="100px" Text="0" CssClass="entry2" />
                                            <ajaxToolkit:FilteredTextBoxExtender ID="txtEstNumTimes_FilteredTextBoxExtender1"
                                                runat="server" TargetControlID="txtEstNumTimes"
                                                FilterType="Numbers" FilterMode="ValidChars" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Time :
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="iSpokeCallingIndividualTime_21_string" runat="server" Width="100px"
                                                CssClass="entry2" />
                                            <ajaxToolkit:MaskedEditExtender ID="iSpokeCallingIndividualTime_21_string_MaskedEditExtender1"
                                                runat="server" TargetControlID="iSpokeCallingIndividualTime_21_string" PromptCharacter="_"
                                                MaskType="Time" Mask="99:99" AcceptAMPM="true" />
                                            <asp:DropDownList ID="ddlTZ" runat="server" CssClass="entry2">
                                                <asp:ListItem Text="PST" />
                                                <asp:ListItem Text="EST" />
                                                <asp:ListItem Text="MST" />
                                                <asp:ListItem Text="CMT" />
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </Content>
                        </ajaxToolkit:AccordionPane>
                        <ajaxToolkit:AccordionPane ID="acpReasons" runat="server">
                            <Header>
                                Select Harassment Type(Choose One)</Header>
                            <Content>
                                <ajaxToolkit:Accordion ID="lbreasons_27_string" runat="server" RequireOpenedPane="false"
                                    HeaderCssClass="accSubHeader" ContentCssClass="accSubContent" SuppressHeaderPostbacks="false"
                                    FadeTransitions="true" TransitionDuration="250">
                                    <Panes>
                                        <ajaxToolkit:AccordionPane ID="acp_Spoke" runat="server">
                                            <Header>
                                                <asp:CheckBox ID="lblSpoke" runat="server" Text="I spoke to the person who called" />
                                            </Header>
                                            <Content>
                                                No additional reasons needed.
                                            </Content>
                                        </ajaxToolkit:AccordionPane>
                                        <ajaxToolkit:AccordionPane ID="acp_Msg" runat="server">
                                            <Header>
                                                <asp:CheckBox ID="Label2" runat="server" Text="The person who called Left a Message" />
                                            </Header>
                                            <Content>
                                                No additional reasons needed.
                                            </Content>
                                        </ajaxToolkit:AccordionPane>
                                        <ajaxToolkit:AccordionPane ID="acp_Mail" runat="server">
                                            <Header>
                                                <asp:CheckBox ID="Label3" runat="server" Text="Received Mail" />
                                            </Header>
                                            <Content>
                                                <asp:CheckBoxList ID="cblMail_31_string" runat="server" CssClass="entry2" BackColor="Transparent">
                                                    <asp:ListItem>By postcard</asp:ListItem>
                                                    <asp:ListItem>Using words or symbols on the outside of the envelope they indicated they were trying to collect a debt.</asp:ListItem>
                                                    <asp:ListItem>That looked like it was from a court or attorney but was not.</asp:ListItem>
                                                </asp:CheckBoxList>
                                            </Content>
                                        </ajaxToolkit:AccordionPane>
                                        <ajaxToolkit:AccordionPane ID="acp_door" runat="server">
                                            <Header>
                                                <asp:CheckBox ID="Label4" runat="server" Text="The person came to my door" />
                                            </Header>
                                            <Content>
                                                No additional reasons needed.
                                            </Content>
                                        </ajaxToolkit:AccordionPane>
                                    </Panes>
                                </ajaxToolkit:Accordion>
                                <div style="margin-left: 5px; padding-top: 10px;">
                                    <asp:Label ID="label1" runat="server">
                            Describe in full detail contact with creditor :
                                    </asp:Label>
                                    <asp:TextBox ID="txtDoorContactInfo_32_string" runat="server" Height="100px" TextMode="MultiLine"
                                        Width="97%" />
                                </div>
                            </Content>
                        </ajaxToolkit:AccordionPane>
                        <ajaxToolkit:AccordionPane ID="acpAdditional" runat="server">
                            <Header>
                                THE COLLECTION ABUSE MAY FALL INTO ONE OR MORE OF THESE CATEGORIES. PLEASE SELECT
                                ALL APPLICABLE</Header>
                            <Content>
                                <asp:Panel ID="array_36_home_header" runat="server" CssClass="accSubHeader" Height="30px">
                                    <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                        <div style="float: left; vertical-align: middle;">
                                            <asp:ImageButton ID="img_array_36_home_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                        </div>
                                        <div style="float: left; padding-left: 5px;">
                                            Collector is calling you at home (before 8am or after 9pm).
                                        </div>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="array_36_home_content" runat="server" CssClass="accSubContent" Height="0">
                                    No additional reasons needed.
                                </asp:Panel>
                                <ajaxToolkit:CollapsiblePanelExtender ID="cpeClientInfo" runat="Server" TargetControlID="array_36_home_content"
                                    ExpandControlID="array_36_home_header" CollapseControlID="array_36_home_header"
                                    Collapsed="True" AutoCollapse="false" AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_36_home_header"
                                    ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                <asp:Panel ID="array_38_work_header" runat="server" CssClass="accSubHeader" Height="30px">
                                    <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                        <div style="float: left; vertical-align: middle;">
                                            <asp:ImageButton ID="img_array_38_work_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                        </div>
                                        <div style="float: left; padding-left: 5px;">
                                            Collector is calling you at work.
                                        </div>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="array_38_work_content" runat="server" CssClass="accSubContent" Height="0">
                                    No additional reasons needed.
                                </asp:Panel>
                                <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="Server"
                                    TargetControlID="array_38_work_content" ExpandControlID="array_38_work_header"
                                    CollapseControlID="array_38_work_header" Collapsed="True" AutoCollapse="false"
                                    AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_38_work_header"
                                    ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                <asp:Panel ID="array_40_third_header" runat="server" CssClass="accSubHeader" Height="30px">
                                    <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                        <div style="float: left; vertical-align: middle;">
                                            <asp:ImageButton ID="img_array_40_third_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                        </div>
                                        <div style="float: left; padding-left: 5px;">
                                            Collector is contacting third-parties with information regarding your debt(s).
                                        </div>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="array_40_third_content" runat="server" CssClass="accSubContent" Height="0">
                                    <div id="divThirdParties" runat="server" class="entry2">
                                        <asp:Panel ID="array_43_header" runat="server" CssClass="accSubHeader" Height="30px">
                                            <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                <div style="float: left; vertical-align: middle;">
                                                    <asp:ImageButton ID="img_array_43_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                                </div>
                                                <div style="float: left; padding-left: 5px;">
                                                    Employer
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <asp:Panel ID="array_43_content" runat="server" CssClass="accSubContent" Height="0">
                                            <table border="0" class="entry2">
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Name :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdEmployerContactName_44_string" runat="server" Width="200px" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Number :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdEmployerContactPhone_45_string" runat="server" Width="200px"
                                                            CssClass="entry2" />
                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtThirdEmployerContactPhone_45_string"
                                                            PromptCharacter="#" MaskType="Number" Mask="(999) 999-9999" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        May we contact them :
                                                    </td>
                                                    <td align="left">
                                                        <asp:RadioButtonList ID="rblThirdEmployerMayWeContact_46_string" runat="server" RepeatDirection="Horizontal"
                                                            CssClass="entry2">
                                                            <asp:ListItem>Yes</asp:ListItem>
                                                            <asp:ListItem>No</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" valign="top">
                                                        What happened? :
                                                    </td>
                                                    <td>
                                                        <asp:CheckBoxList ID="cblThirdEmployerWhatHappened_50_array" runat="server" CssClass="entry2">
                                                            <asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
                                                            <asp:ListItem>Stated that you owed them a debt</asp:ListItem>
                                                            <asp:ListItem>Contacted Employer more than once when they were not requested to do so even though the Employer had given correct information</asp:ListItem>
                                                            <asp:ListItem>Communicated by postcard</asp:ListItem>
                                                            <asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
                                                        </asp:CheckBoxList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender17" runat="Server"
                                            TargetControlID="array_43_content" ExpandControlID="array_43_header" CollapseControlID="array_43_header"
                                            Collapsed="True" AutoCollapse="false" AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_43_header"
                                            ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                        <asp:Panel ID="array_51_header" runat="server" CssClass="accSubHeader" Height="30px">
                                            <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                <div style="float: left; vertical-align: middle;">
                                                    <asp:ImageButton ID="img_array_51_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                                </div>
                                                <div style="float: left; padding-left: 5px;">
                                                    Co-Worker
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <asp:Panel ID="array_51_content" runat="server" CssClass="accSubContent" Height="0">
                                            <table border="0" class="entry2">
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Name :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdCoWorkerContactName_52_string" runat="server" Width="200px">
                                                        </asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Number :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdCoWorkerContactPhone_53_string" runat="server" Width="200px"
                                                            CssClass="entry2" />
                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtThirdCoWorkerContactPhone_53_string"
                                                            PromptCharacter="#" MaskType="Number" Mask="(999) 999-9999" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        May we contact them :
                                                    </td>
                                                    <td align="left">
                                                        <asp:RadioButtonList ID="rblThirdCoWorkerMayWeContact_54_string" runat="server" RepeatDirection="Horizontal"
                                                            CssClass="entry2">
                                                            <asp:ListItem>Yes</asp:ListItem>
                                                            <asp:ListItem>No</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" valign="top">
                                                        What happened? :
                                                    </td>
                                                    <td>
                                                        <asp:CheckBoxList CssClass="entry2" ID="cblThirdCoWorkerWhatHappened_55_array" runat="server">
                                                            <asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
                                                            <asp:ListItem>Stated that you owed them a debt</asp:ListItem>
                                                            <asp:ListItem>Contacted Co-Worker more than once when they were not requested to do so even though the Co-Worker had given correct information</asp:ListItem>
                                                            <asp:ListItem>Communicated by post card</asp:ListItem>
                                                            <asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
                                                        </asp:CheckBoxList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender18" runat="Server"
                                            TargetControlID="array_51_content" ExpandControlID="array_51_header" CollapseControlID="array_51_header"
                                            Collapsed="True" AutoCollapse="false" AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_51_header"
                                            ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                        <asp:Panel ID="array_70_header" runat="server" CssClass="accSubHeader" Height="30px">
                                            <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                <div style="float: left; vertical-align: middle;">
                                                    <asp:ImageButton ID="img_array_70_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                                </div>
                                                <div style="float: left; padding-left: 5px;">
                                                    Neighbors
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <asp:Panel ID="array_70_content" runat="server" CssClass="accSubContent" Height="0">
                                            <table border="0" class="entry2">
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Name :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdNeighborsContactName_64_string" runat="server" Width="200px">
                                                        </asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Number :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdNeighborsContactPhone_65_string" runat="server" Width="200px"
                                                            CssClass="entry2" />
                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtThirdNeighborsContactPhone_65_string"
                                                            PromptCharacter="#" MaskType="Number" Mask="(999) 999-9999" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        May we contact them :
                                                    </td>
                                                    <td align="left">
                                                        <asp:RadioButtonList ID="rblThirdNeighborsMayWeContact_66_string" runat="server"
                                                            RepeatDirection="Horizontal" CssClass="entry2">
                                                            <asp:ListItem>Yes</asp:ListItem>
                                                            <asp:ListItem>No</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" valign="top">
                                                        What happened? :
                                                    </td>
                                                    <td>
                                                        <asp:CheckBoxList CssClass="entry2" ID="cblThirdNeighborsWhatHappened_67_array" runat="server">
                                                            <asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
                                                            <asp:ListItem>Stated that you owed them a debt</asp:ListItem>
                                                            <asp:ListItem>Contacted Neighbor more than once when they were not requested to do so even though the Neighbor had given correct information</asp:ListItem>
                                                            <asp:ListItem>Communicated by post card</asp:ListItem>
                                                            <asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
                                                        </asp:CheckBoxList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender19" runat="Server"
                                            TargetControlID="array_70_content" ExpandControlID="array_70_header" CollapseControlID="array_70_header"
                                            Collapsed="True" AutoCollapse="false" AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_70_header"
                                            ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                        <asp:Panel ID="array_78_header" runat="server" CssClass="accSubHeader" Height="30px">
                                            <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                <div style="float: left; vertical-align: middle;">
                                                    <asp:ImageButton ID="img_array_78_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                                </div>
                                                <div style="float: left; padding-left: 5px;">
                                                    Friends
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <asp:Panel ID="array_78_content" runat="server" CssClass="accSubContent" Height="0">
                                            <table border="0" class="entry2">
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Name :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdFriendsContactName_72_string" runat="server" Width="200px">
                                                        </asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Number :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdFriendsContactPhone_73_string" runat="server" Width="200px"
                                                            CssClass="entry2" />
                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtThirdFriendsContactPhone_73_string"
                                                            PromptCharacter="#" MaskType="Number" Mask="(999) 999-9999" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        May we contact them :
                                                    </td>
                                                    <td align="left">
                                                        <asp:RadioButtonList ID="rblThirdFriendsMayWeContact_74_string" runat="server" RepeatDirection="Horizontal"
                                                            CssClass="entry2">
                                                            <asp:ListItem>Yes</asp:ListItem>
                                                            <asp:ListItem>No</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" valign="top">
                                                        What happened? :
                                                    </td>
                                                    <td>
                                                        <asp:CheckBoxList ID="cblThirdFriendsWhatHappened_75_array" runat="server" CssClass="entry2">
                                                            <asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
                                                            <asp:ListItem>Stated that you owed them a debt</asp:ListItem>
                                                            <asp:ListItem>Contacted Friend more than once when they were not requested to do so even though the Friend had given correct information</asp:ListItem>
                                                            <asp:ListItem>Communicated by post card</asp:ListItem>
                                                            <asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
                                                        </asp:CheckBoxList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender20" runat="Server"
                                            TargetControlID="array_78_content" ExpandControlID="array_78_header" CollapseControlID="array_78_header"
                                            Collapsed="True" AutoCollapse="false" AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_78_header"
                                            ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                        <asp:Panel ID="array_79_header" runat="server" CssClass="accSubHeader" Height="30px">
                                            <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                <div style="float: left; vertical-align: middle;">
                                                    <asp:ImageButton ID="img_array_79_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                                </div>
                                                <div style="float: left; padding-left: 5px;">
                                                    Family Members
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <asp:Panel ID="array_79_content" runat="server" CssClass="accSubContent" Height="0">
                                            <table border="0" class="entry2">
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Name :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdFamilyContactName_80_string" runat="server" Width="200px">
                                                        </asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        Contacted Persons Number :
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtThirdFamilyContactPhone_81_string" runat="server" Width="200px"
                                                            CssClass="entry2" />
                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtThirdFamilyContactPhone_81_string"
                                                            PromptCharacter="#" MaskType="Number" Mask="(999) 999-9999" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        May we contact them :
                                                    </td>
                                                    <td align="left">
                                                        <asp:RadioButtonList ID="rblThirdFamilyMayWeContact_82_string" runat="server" RepeatDirection="Horizontal"
                                                            CssClass="entry2">
                                                            <asp:ListItem>Yes</asp:ListItem>
                                                            <asp:ListItem>No</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" valign="top">
                                                        What happened? :
                                                    </td>
                                                    <td>
                                                        <asp:CheckBoxList ID="cblThirdFamilyWhatHappened_83_array" runat="server" CssClass="entry2">
                                                            <asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
                                                            <asp:ListItem>Stated that you owed them a debt</asp:ListItem>
                                                            <asp:ListItem>Contacted Family Member more than once when they were not requested to do so even though the Family Member had given correct information</asp:ListItem>
                                                            <asp:ListItem>Communicated by post card</asp:ListItem>
                                                            <asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
                                                        </asp:CheckBoxList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender21" runat="Server"
                                            TargetControlID="array_79_content" ExpandControlID="array_79_header" CollapseControlID="array_79_header"
                                            Collapsed="True" AutoCollapse="false" AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_79_header"
                                            ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                        <asp:Panel ID="string_86_header" runat="server" CssClass="accSubHeader" Height="30px">
                                            <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                <div style="float: left; vertical-align: middle;">
                                                    <asp:ImageButton ID="img_string_86_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                                </div>
                                                <div style="float: left; padding-left: 5px;">
                                                    Other
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <asp:Panel ID="string_86_content" runat="server" CssClass="accSubContent" Height="0">
                                            <asp:TextBox ID="txtThirdOther_86_string" runat="server" Width="75%" Height="100px"
                                                TextMode="MultiLine" />
                                        </asp:Panel>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender22" runat="Server"
                                            TargetControlID="string_86_content" ExpandControlID="string_86_header" CollapseControlID="string_86_header"
                                            Collapsed="True" AutoCollapse="false" AutoExpand="false" CollapsedSize="1" ImageControlID="img_string_86_header"
                                            ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                    </div>
                                </asp:Panel>
                                <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender2" runat="Server"
                                    TargetControlID="array_40_third_content" ExpandControlID="array_40_third_header"
                                    CollapseControlID="array_40_third_header" Collapsed="True" AutoCollapse="false"
                                    AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_40_third_header"
                                    ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                <asp:Panel ID="array_90_lang_header" runat="server" CssClass="accSubHeader" Height="30px">
                                    <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                        <div style="float: left; vertical-align: middle;">
                                            <asp:ImageButton ID="img_array_90_lang_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                        </div>
                                        <div style="float: left; padding-left: 5px;">
                                            Collector is using abusive language.
                                        </div>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="array_90_lang_content" runat="server" CssClass="accSubContent" Height="0">
                                    <table class="entry2" style="width: 75%;">
                                        <tr>
                                            <td align="right" valign="top">
                                                What happened? :
                                            </td>
                                            <td>
                                                <asp:CheckBoxList ID="cblLangWhatHappened_97_array" runat="server" CssClass="entry2">
                                                    <asp:ListItem>Used obscene or profane language</asp:ListItem>
                                                    <asp:ListItem>Other</asp:ListItem>
                                                </asp:CheckBoxList>
                                                Please Explain :
                                                <asp:TextBox ID="txtLangWhatHappenedExplain_98_string" runat="server" Width="98%"
                                                    Height="100px" TextMode="MultiLine" />
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender3" runat="Server"
                                    TargetControlID="array_90_lang_content" ExpandControlID="array_90_lang_header"
                                    CollapseControlID="array_90_lang_header" Collapsed="True" AutoCollapse="false"
                                    AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_90_lang_header"
                                    ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                <asp:Panel ID="array_101_threat_header" runat="server" CssClass="accSubHeader" Height="30px">
                                    <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                        <div style="float: left; vertical-align: middle;">
                                            <asp:ImageButton ID="img_array_101_threat_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                        </div>
                                        <div style="float: left; padding-left: 5px;">
                                            Collector is threatening you.
                                        </div>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="array_101_threat_content" runat="server" CssClass="accSubContent"
                                    Height="0">
                                    <table class="entry2" style="width: 75%;">
                                        <tr>
                                            <td align="right" valign="top">
                                                What happened? :
                                            </td>
                                            <td>
                                                <div id="divThreat" runat="server">
                                                    <asp:Panel ID="array_106_header_violence" runat="server" CssClass="accSubHeader"
                                                        Height="30px">
                                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                            <div style="float: left; vertical-align: middle;">
                                                                <asp:ImageButton ID="img_array_106_header_violence" runat="server" ImageUrl="~/images/checkbox.png" />
                                                            </div>
                                                            <div style="float: left; padding-left: 5px;">
                                                                Used or threatened to use violence.
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="array_106_content_violence" runat="server" CssClass="accSubContent"
                                                        Height="0">
                                                        No additional reasons needed.</asp:Panel>
                                                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender6" runat="Server"
                                                        TargetControlID="array_106_content_violence" ExpandControlID="array_106_header_violence"
                                                        CollapseControlID="array_106_header_violence" Collapsed="True" AutoCollapse="false"
                                                        AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_106_header_violence"
                                                        ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                    <asp:Panel ID="array_106_header_body" runat="server" CssClass="accSubHeader" Height="30px">
                                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                            <div style="float: left; vertical-align: middle;">
                                                                <asp:ImageButton ID="img_array_106_header_body" runat="server" ImageUrl="~/images/checkbox.png" />
                                                            </div>
                                                            <div style="float: left; padding-left: 5px;">
                                                                Harmed or threatened to harm you or another person (body, property or reputation).
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="array_106_content_body" runat="server" CssClass="accSubContent" Height="0">
                                                        No additional reasons needed.</asp:Panel>
                                                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender7" runat="Server"
                                                        TargetControlID="array_106_content_body" ExpandControlID="array_106_header_body"
                                                        CollapseControlID="array_106_header_body" Collapsed="True" AutoCollapse="false"
                                                        AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_106_header_body"
                                                        ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                    <asp:Panel ID="array_106_header_sell" runat="server" CssClass="accSubHeader" Height="30px">
                                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                            <div style="float: left; vertical-align: middle;">
                                                                <asp:ImageButton ID="img_array_106_header_sell" runat="server" ImageUrl="~/images/checkbox.png" />
                                                            </div>
                                                            <div style="float: left; padding-left: 5px;">
                                                                Threatened to sell your debt to a third party.
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="array_106_content_sell" runat="server" CssClass="accSubContent" Height="0">
                                                        No additional reasons needed.</asp:Panel>
                                                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender8" runat="Server"
                                                        TargetControlID="array_106_content_sell" ExpandControlID="array_106_header_sell"
                                                        CollapseControlID="array_106_header_sell" Collapsed="True" AutoCollapse="false"
                                                        AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_106_header_sell"
                                                        ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                    <asp:Panel ID="array_106_header_criminal" runat="server" CssClass="accSubHeader"
                                                        Height="30px">
                                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                            <div style="float: left; vertical-align: middle;">
                                                                <asp:ImageButton ID="img_array_106_header_criminal" runat="server" ImageUrl="~/images/checkbox.png" />
                                                            </div>
                                                            <div style="float: left; padding-left: 5px;">
                                                                Threatened criminal prosecution if you did not give them a post dated check.
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="array_106_content_criminal" runat="server" CssClass="accSubContent"
                                                        Height="0">
                                                        No additional reasons needed.</asp:Panel>
                                                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender9" runat="Server"
                                                        TargetControlID="array_106_content_criminal" ExpandControlID="array_106_header_criminal"
                                                        CollapseControlID="array_106_header_criminal" Collapsed="True" AutoCollapse="false"
                                                        AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_106_header_criminal"
                                                        ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                    <asp:Panel ID="array_106_header_unlawful" runat="server" CssClass="accSubHeader"
                                                        Height="30px">
                                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                            <div style="float: left; vertical-align: middle;">
                                                                <asp:ImageButton ID="img_array_106_header_unlawful" runat="server" ImageUrl="~/images/checkbox.png" />
                                                            </div>
                                                            <div style="float: left; padding-left: 5px;">
                                                                Threatened to take unlawful actions against you before judgement is taken.
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="array_106_content_unlawful" runat="server" CssClass="accSubContent"
                                                        Height="0">
                                                        <div id="divUnlawful" runat="server">
                                                            <asp:Panel ID="array_115_header_unlawful_arrest" runat="server" CssClass="accSubHeader"
                                                                Height="30px">
                                                                <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                                    <div style="float: left; vertical-align: middle;">
                                                                        <asp:ImageButton ID="img_array_115_header_unlawful_arrest" runat="server" ImageUrl="~/images/checkbox.png" />
                                                                    </div>
                                                                    <div style="float: left; padding-left: 5px;">
                                                                        Used or threatened to use violence.
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                            <asp:Panel ID="array_115_content_unlawful_arrest" runat="server" CssClass="accSubContent"
                                                                Height="0">
                                                                No additional reasons needed.</asp:Panel>
                                                            <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender12" runat="Server"
                                                                TargetControlID="array_115_content_unlawful_arrest" ExpandControlID="array_115_header_unlawful_arrest"
                                                                CollapseControlID="array_115_header_unlawful_arrest" Collapsed="True" AutoCollapse="false"
                                                                AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_115_header_unlawful_arrest"
                                                                ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                            <asp:Panel ID="array_115_header_unlawful_seizure" runat="server" CssClass="accSubHeader"
                                                                Height="30px">
                                                                <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                                    <div style="float: left; vertical-align: middle;">
                                                                        <asp:ImageButton ID="img_array_115_header_unlawful_seizure" runat="server" ImageUrl="~/images/checkbox.png" />
                                                                    </div>
                                                                    <div style="float: left; padding-left: 5px;">
                                                                        Seizure of Property.
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                            <asp:Panel ID="array_115_content_unlawful_seizure" runat="server" CssClass="accSubContent"
                                                                Height="0">
                                                                No additional reasons needed.</asp:Panel>
                                                            <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender13" runat="Server"
                                                                TargetControlID="array_115_content_unlawful_seizure" ExpandControlID="array_115_header_unlawful_seizure"
                                                                CollapseControlID="array_115_header_unlawful_seizure" Collapsed="True" AutoCollapse="false"
                                                                AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_115_header_unlawful_seizure"
                                                                ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                            <asp:Panel ID="array_115_header_unlawful_jobloss" runat="server" CssClass="accSubHeader"
                                                                Height="30px">
                                                                <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                                    <div style="float: left; vertical-align: middle;">
                                                                        <asp:ImageButton ID="img_array_115_header_unlawful_jobloss" runat="server" ImageUrl="~/images/checkbox.png" />
                                                                    </div>
                                                                    <div style="float: left; padding-left: 5px;">
                                                                        Job Loss.
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                            <asp:Panel ID="array_115_content_unlawful_jobloss" runat="server" CssClass="accSubContent"
                                                                Height="0">
                                                                No additional reasons needed.</asp:Panel>
                                                            <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender14" runat="Server"
                                                                TargetControlID="array_115_content_unlawful_jobloss" ExpandControlID="array_115_header_unlawful_jobloss"
                                                                CollapseControlID="array_115_header_unlawful_jobloss" Collapsed="True" AutoCollapse="false"
                                                                AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_115_header_unlawful_jobloss"
                                                                ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                            <asp:Panel ID="array_115_header_unlawful_garnishment" runat="server" CssClass="accSubHeader"
                                                                Height="30px">
                                                                <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                                    <div style="float: left; vertical-align: middle;">
                                                                        <asp:ImageButton ID="img_array_115_header_unlawful_garnishment" runat="server" ImageUrl="~/images/checkbox.png" />
                                                                    </div>
                                                                    <div style="float: left; padding-left: 5px;">
                                                                        Garnishment.
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                            <asp:Panel ID="array_115_content_unlawful_garnishment" runat="server" CssClass="accSubContent"
                                                                Height="0">
                                                                No additional reasons needed.</asp:Panel>
                                                            <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender15" runat="Server"
                                                                TargetControlID="array_115_content_unlawful_garnishment" ExpandControlID="array_115_header_unlawful_garnishment"
                                                                CollapseControlID="array_115_header_unlawful_garnishment" Collapsed="True" AutoCollapse="false"
                                                                AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_115_header_unlawful_garnishment"
                                                                ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                            <asp:Panel ID="array_115_header_unlawful_other" runat="server" CssClass="accSubHeader"
                                                                Height="30px">
                                                                <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                                    <div style="float: left; vertical-align: middle;">
                                                                        <asp:ImageButton ID="img_array_115_header_unlawful_other" runat="server" ImageUrl="~/images/checkbox.png" />
                                                                    </div>
                                                                    <div style="float: left; padding-left: 5px;">
                                                                        Other.
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                            <asp:Panel ID="array_115_content_unlawful_other" runat="server" CssClass="accSubContent"
                                                                Height="0">
                                                                <asp:TextBox ID="txtThreatWhatHappenedUnlawFulOther_116_string" runat="server" Width="98%"
                                                                    Height="100px" TextMode="MultiLine" />
                                                            </asp:Panel>
                                                            <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender16" runat="Server"
                                                                TargetControlID="array_115_content_unlawful_other" ExpandControlID="array_115_header_unlawful_other"
                                                                CollapseControlID="array_115_header_unlawful_other" Collapsed="True" AutoCollapse="false"
                                                                AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_115_header_unlawful_other"
                                                                ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                        </div>
                                                    </asp:Panel>
                                                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender10" runat="Server"
                                                        TargetControlID="array_106_content_unlawful" ExpandControlID="array_106_header_unlawful"
                                                        CollapseControlID="array_106_header_unlawful" Collapsed="True" AutoCollapse="false"
                                                        AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_106_header_unlawful"
                                                        ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                    <asp:Panel ID="array_106_header_other" runat="server" CssClass="accSubHeader" Height="30px">
                                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                                            <div style="float: left; vertical-align: middle;">
                                                                <asp:ImageButton ID="img_array_106_header_other" runat="server" ImageUrl="~/images/checkbox.png" />
                                                            </div>
                                                            <div style="float: left; padding-left: 5px;">
                                                                Other.
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="array_106_content_other" runat="server" CssClass="accSubContent" Height="0">
                                                        <asp:TextBox ID="txtThreatWhatHappenedOther_104_string" runat="server" Width="98%"
                                                            TextMode="MultiLine" Height="100px" />
                                                    </asp:Panel>
                                                    <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender11" runat="Server"
                                                        TargetControlID="array_106_content_other" ExpandControlID="array_106_header_other"
                                                        CollapseControlID="array_106_header_other" Collapsed="True" AutoCollapse="false"
                                                        AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_106_header" ExpandedImage="~/images/check.png"
                                                        CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender4" runat="Server"
                                    TargetControlID="array_101_threat_content" ExpandControlID="array_101_threat_header"
                                    CollapseControlID="array_101_threat_header" Collapsed="True" AutoCollapse="false"
                                    AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_101_threat_header"
                                    ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                                <asp:Panel ID="array_108_another_header" runat="server" CssClass="accSubHeader" Height="30px">
                                    <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                        <div style="float: left; vertical-align: middle;">
                                            <asp:ImageButton ID="img_array_108_another_header" runat="server" ImageUrl="~/images/checkbox.png" />
                                        </div>
                                        <div style="float: left; padding-left: 5px;">
                                            Collector is Harassing you in another manner.
                                        </div>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="array_108_another_content" runat="server" CssClass="accSubContent"
                                    Height="0">
                                    <table class="entry2" style="width: 75%;">
                                        <tr>
                                            <td align="right" valign="top">
                                                What happened? :
                                            </td>
                                            <td>
                                                <asp:CheckBoxList ID="cblAnotherWhatHappened_112_array" runat="server" CssClass="entry2">
                                                    <asp:ListItem>Said you committed a crime.</asp:ListItem>
                                                    <asp:ListItem>Published your name as a person who does not pay bills.</asp:ListItem>
                                                    <asp:ListItem>Listed your debt for sale to the public.</asp:ListItem>
                                                    <asp:ListItem>Other</asp:ListItem>
                                                </asp:CheckBoxList>
                                                <asp:TextBox ID="txtAnotherWhatHappenedExplain_110_string" runat="server" Height="100px"
                                                    Width="98%" TextMode="MultiLine" />
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <ajaxToolkit:CollapsiblePanelExtender ID="CollapsiblePanelExtender5" runat="Server"
                                    TargetControlID="array_108_another_content" ExpandControlID="array_108_another_header"
                                    CollapseControlID="array_108_another_header" Collapsed="True" AutoCollapse="false"
                                    AutoExpand="false" CollapsedSize="1" ImageControlID="img_array_108_another_header"
                                    ExpandedImage="~/images/check.png" CollapsedImage="~/images/checkbox.png" SuppressPostBack="true" />
                            </Content>
                        </ajaxToolkit:AccordionPane>
                    </Panes>
                </ajaxToolkit:Accordion>
                <table class="entry2" style="width:95%;">
                    <tr>
                        <td align="center" style="height: 45px; background-color: silver">
                            Please fill out information below if you know it, thank you.
                        </td>
                    </tr>
                    <tr style="white-space: nowrap;">
                        <td>
                            <table width="98%" class="entry2">
                                <tr style="white-space: nowrap;" class="entry2">
                                    <td>
                                    </td>
                                    <td>
                                        Last Sent
                                    </td>
                                    <td style="width: 50px">
                                        Total Sent
                                    </td>
                                </tr>
                                <tr class="entry2">
                                    <td>
                                        Original Notice of Representation by Legal Counsel Mailed :
                                    </td>
                                    <td>
                                        <asp:TextBox ID="dteNoticeOfRep" Width="200px" runat="server" CssClass="entry2" />
                                        <asp:ImageButton runat="Server" ID="img_dteNoticeOfRep" ImageUrl="~/images/Calendar_scheduleHS.png"
                                            AlternateText="Click to show calendar" />
                                        <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="dteNoticeOfRep"
                                            PopupButtonID="img_dteNoticeOfRep" CssClass="MyCalendar" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtRepTotal" ReadOnly="true" HorizontalAlign="Center" runat="server"
                                            Width="25px" CssClass="entry2"/>
                                    </td>
                                </tr>
                                <tr class="entry2">
                                    <td>
                                        Cease & Desist Notice Mailed :
                                    </td>
                                    <td>
                                        <asp:TextBox ID="dteCease" Width="200px" runat="server" CssClass="entry2"/>
                                        <asp:ImageButton runat="Server" ID="img_dteCease" ImageUrl="~/images/Calendar_scheduleHS.png"
                                            AlternateText="Click to show calendar" />
                                        <ajaxToolkit:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="dteCease"
                                            PopupButtonID="img_dteCease" CssClass="MyCalendar" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCeaseTotal" ReadOnly="true" HorizontalAlign="Center" runat="server"
                                            Width="25px" CssClass="entry2"/>
                                    </td>
                                </tr>
                                <tr class="entry2">
                                    <td colspan="2">
                                        <asp:CheckBox ID="chkInterest" runat="server" CssClass="entry2"
                                        Text="Creditor added interest, fees or charges not authorized in the original agreement or by state law." />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkSubmit" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="lnkCancel" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <div class="formFooterBar">
        <asp:LinkButton ID="lnkCancel" CssClass="button" runat="server">
            <span>Cancel</span>
        </asp:LinkButton>
        <asp:LinkButton ID="lnkSubmit" CssClass="button" runat="server">
            <span>Save Form</span>
        </asp:LinkButton>
    </div>
</asp:Panel>
<ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" Y="50" runat="server" PopupDragHandleControlID="pnlHdr"
    TargetControlID="lnkShow" PopupControlID="Panel1" BackgroundCssClass="modalHarassBackground"
    DropShadow="false" CancelControlID="lnkCancel" />
<asp:SqlDataSource ConnectionString="<%$ AppSettings:connectionstring %>" ID="sdsCardHolderName"
    runat="server" SelectCommand="SELECT c.ClientID, c.AccountNumber,  s.Abbreviation, p.FirstName+ ' ' + p.LastName as [CardHolder],p.personid 
                         FROM tblClient c INNER JOIN tblPerson p ON p.ClientID = c.ClientID INNER JOIN tblState s ON s.StateID = p.StateID WHERE c.clientid = @clientID"
    ProviderName="System.Data.SqlClient">
    <SelectParameters>
        <asp:QueryStringParameter QueryStringField="id" Name="clientid" DefaultValue="-1" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsOrigCred" ConnectionString="<%$ AppSettings:connectionstring %>"
    runat="server" SelectCommand="
select accountid,[OriginalInfo],OrigCredID
from
(
	SELECT 
		a.accountid
		,OrigCr.[Name] + ' #' + right(OrigCi.AccountNumber,4) as [OriginalInfo]
		,OrigCr.creditorid as OrigCredID 
	FROM tblAccount as a 
		INNER JOIN tblCreditorInstance OrigCi ON OrigCi.CreditorInstanceID = a.originalCreditorInstanceID 
		INNER JOIN tblCreditor OrigCr ON OrigCr.CreditorID = OrigCi.CreditorID 
		INNER JOIN tblCreditor cr ON cr.CreditorID = OrigCr.CreditorID 
	WHERE 
		(a.clientid = @clientID) 
	
	union  

	select 
		'-1' as accountid 
		, 'Unknown' as OriginalInfo
		, '-1' as OrigCredID
) as OrigCredData
ORDER BY OriginalInfo
" ProviderName="System.Data.SqlClient">
    <SelectParameters>
        <asp:QueryStringParameter QueryStringField="id" Name="clientid" DefaultValue="-1" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsDebtCollector" ConnectionString="<%$ AppSettings:connectionstring %>"
    runat="server" SelectCommand="SELECT AccountID, CurrentInfo, CurrentCredID FROM (SELECT a.AccountID, cr.Name + ' #' + RIGHT (ci.AccountNumber, 4) AS CurrentInfo, cr.CreditorID AS CurrentCredID FROM tblAccount AS a INNER JOIN tblCreditorInstance AS OrigCi ON OrigCi.CreditorInstanceID = a.OriginalCreditorInstanceID INNER JOIN tblCreditorInstance AS ci ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN tblCreditor AS cr ON cr.CreditorID = ci.CreditorID WHERE (a.ClientID = @clientid) UNION SELECT '-1' AS accountid, 'Unknown' AS CurrentInfo, '-1' AS CurrentCredID) AS CurrCredData ORDER BY CurrentInfo"
    ProviderName="System.Data.SqlClient">
    <SelectParameters>
        <asp:QueryStringParameter QueryStringField="id" Name="clientid" DefaultValue="-1" />
    </SelectParameters>
</asp:SqlDataSource>

<script type="text/javascript">
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_initializeRequest(InitializeRequest);
    prm.add_endRequest(EndRequest);
    var postBackElement;
    function InitializeRequest(sender, args) {

        if (prm.get_isInAsyncPostBack())
            args.set_cancel(true);
        postBackElement = args.get_postBackElement();

        if (postBackElement.id == "<%= lnkSubmit.ClientID %>")
            $get("<%= upHarass.ClientID %>").style.display = 'block';
    }
    function EndRequest(sender, args) {
        if (postBackElement.id == "<%= lnkSubmit.ClientID  %>")
            $get("<%= upHarass.ClientID %>").style.display = 'none';
    }


    function lbreasons_AfterGroupExpanded(oListbar, oGroup, oEvent) {
        //Add code to handle your event here.
        for (var grp in oListbar.Groups) {
            if (oGroup.getText() != oListbar.Groups[grp].getText()) {
                //collapse all other panels
                oListbar.Groups[grp].setExpanded(false, false);
            }
        }
    }

    function pageLoad() {
        var accordion = $find('<%= lbreasons_27_string.ClientID %>' + '_AccordionExtender');
        accordion.add_selectedIndexChanged(onAccordionPaneChanged);
    }
    function onAccordionPaneChanged(sender, eventArgs) {
        var newPaneID = eventArgs._selectedIndex;
        var acc = $find('<%= lbreasons_27_string.ClientID %>' + '_AccordionExtender');
        for (paneIdx = 0; paneIdx < acc.get_Count(); paneIdx++) {
            var opane = sender.get_Pane(paneIdx).header;
            var ochk = opane.children[0];
            ochk.checked = (paneIdx == newPaneID) ? true : false;

        }
    }
</script>


<style type="text/css">
    .modalHarassPopup
    {
        z-index: 99999999;
        background-color: White;
        width: 75%;
        vertical-align: middle;
        position: absolute !important;
        bottom: 50%;
        left: 45%;
        height: 630px;
    }
    .modalHarassBackground
    {
        z-index: 99999998;
        background-color: #6D7B8D;
        position: absolute !important;
        top: 0;
        left: 0;
        height: 100%;
        width: 100%;
        filter: alpha(opacity=50);
        opacity: 0.5;
        -moz-opacity: 0.5;
    }
    .formTitleBar
    {
        background-image: url('../../../../images/menubackbig.png');
        background-repeat: repeat-x;
        border: solid 1px rgb(112,168,209);
        height: 30px;
        vertical-align: middle;
        text-align: center;
        background-color: #4791C5;
        font-size: medium;
        font-weight: bold;
        color: black;
        width: 100%;
        white-space: nowrap;
    }
    .formFooterBar
    {
        /*
        
        background-color: #4791C5;
        font-size: medium;
        font-weight: bold;
         padding-top: 3px;
        padding-right: 10px;
        text-align: right;
        color: black;
        width: 100%;
        
        
        */
        border: solid 1px rgb(112,168,209);
        height: 35px;
        background-image: url('../../../../images/menubackbig.png');
        background-repeat: repeat-x;
        white-space: nowrap;
    }
    .accHeader
    {
        border: 1px solid #3376AB;
        color: black;
        background-color: #4791C5;
        font-family: tahoma;
        font-size: 12px;
        font-weight: bold;
        padding: 5px;
        margin-top: 5px;
        cursor: pointer;
        margin-left: 10px;
        margin-right: 10px;
        text-align: left;
        vertical-align: middle;
    }
    .accContent
    {
        background-color: #D3DEEF;
        border: 1px dotted #3376AB;
        border-top: none;
        padding-top: 10px;
        width: 98%;
        margin-left: 10px;
        margin-right: 10px;
        text-align: left;
    }
    .accSubHeader
    {
        cursor: pointer; /*border: 1px solid #3376AB;*/
        margin-left: 10px;
        margin-right: 10px;
        padding-top: 3px;
        padding-bottom: 3px;
        text-align: left;
        vertical-align: middle;
    }
    .accSubContent
    {
        background-color: #D3DEEF; /*border: 1px dotted #3376AB;
        border-top: none;
        padding-left:15px;
        */
        margin-left: 15px;
        margin-right: 15px;
        text-align: left;
    }
    /*button*/a.button
    {
        /* Sliding right image */
        background: transparent url('../../../../images/button_right_06.png') no-repeat scroll top right;
        display: block;
        float: right;
        height: 32px; /* CHANGE THIS VALUE ACCORDING TO IMAGE HEIGHT */
        margin-right: 6px;
        padding-right: 20px; /* CHENGE THIS VALUE ACCORDING TO RIGHT IMAGE WIDTH */ /* FONT PROPERTIES */
        text-decoration: none;
        color: #000000;
        font-family: tahoma;
        font-size: 12px;
        font-weight: bold;
    }
    a.button span
    {
        /* Background left image */
        background: transparent url('../../../../images/button_left_06.png') no-repeat;
        display: block;
        line-height: 22px; /* CHANGE THIS VALUE ACCORDING TO BUTTONG HEIGHT */
        padding: 7px 0 5px 18px;
    }
    a.button:hover span
    {
        text-decoration: underline;
    }
</style>
