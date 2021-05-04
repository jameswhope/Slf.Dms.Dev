<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CallControlBar.ascx.vb"   Inherits="CallControls_CallControlBar" %>
<%@ Register Src="Interactions.ascx" TagName="Interactions" TagPrefix="uc1" %>

<script type="text/javascript" language="javascript">
    function make_call(phonenumber) {
        var btn = document.getElementById('<%=btnMakeCall.ClientID %>');
        var txt = document.getElementById('<%=txtNumber.ClientID %>');
        document.getElementById('<%=hdnCallContolLeadId.ClientID %>').value = '';
        txt.value = phonenumber.replace('(', '').replace(')', '').replace('-', '').replace(' ', '').trim();
        btn.click();
    }
    
     function make_call_lead(phonenumber, leadid) {
        var btn = document.getElementById('<%=btnMakeCall.ClientID %>');
        var txt = document.getElementById('<%=txtNumber.ClientID %>');
        txt.value = phonenumber.replace('(', '').replace(')', '').replace('-', '').replace(' ', '').trim();
        document.getElementById('<%=hdnCallContolLeadId.ClientID %>').value = leadid;
        btn.click();
    }
    
    function make_call_ciddialer(callid) {
        document.getElementById('<%=hdnDialerCallId.ClientID %>').value = callid;
        var btn = document.getElementById('<%=lnkCIDDialerMakeCall.ClientID %>');
        btn.click();
    }
    
    function make_call_dialerIN(callid) {
        document.getElementById('<%=hdnDialerCallId.ClientID %>').value = callid;
        var btn = document.getElementById('<%=lnkDialerINMakeCall.ClientID %>');
        btn.click();
    }
    
    function transfer_call(phonenumber) {
        var btn = document.getElementById('<%=btnTransfer.ClientID %>');
        var txt = document.getElementById('<%=txtTransfer.ClientID %>');
        txt.value = phonenumber.replace('(', '').replace(')', '').replace('-', '').replace(' ', '').trim();
        btn.click();
    }
    
    function park_call(phonenumber) {
        var btn = document.getElementById('<%=btnTransferPark.ClientID %>');
        var txt = document.getElementById('<%=txtTransfer.ClientID %>');
        txt.value = phonenumber.replace('(', '').replace(')', '').replace('-', '').replace(' ', '').trim();
        btn.click();
    }
    
    function voicemail_call(phonenumber) {
        var btn = document.getElementById('<%=btnTransferVoiceMail.ClientID %>');
        var txt = document.getElementById('<%=txtTransfer.ClientID %>');
        txt.value = phonenumber.replace('(', '').replace(')', '').replace('-', '').replace(' ', '').trim();
        btn.click();
    }

    function dialpad(digits) {
        var btn = document.getElementById('<%=lnkDialPad.ClientID %>');
        document.getElementById('<%=hdnDialPad.ClientID %>').value = digits;
        btn.click();
    }
    
    function directPickup(inter) {
        var btn = document.getElementById('<%=lnkDirectPickup.ClientID %>');
        var hdn = document.getElementById('<%=hdnDirectPickup.ClientID %>');
        hdn.value = inter;
        btn.click();
    }

    function startRecording() {
        var btn = document.getElementById('<%=lnkStartRecord.ClientID %>');
        btn.click();
    }
    
    function stopRecording() {
        var btn = document.getElementById('<%=lnkStopRecord.ClientID %>');
        btn.click();
    }
    
    function CompleteUWVerificationCall(verifId)
     {
        var hdn = document.getElementById('<%=hdnUWVerifId.ClientID %>');
        hdn.value = verifId;
        var btn = document.getElementById('<%=lnkCompleteUWVerifCall.ClientID %>');
        btn.click();
    }
    
    function CompleteCallRecording(RecId)
     {
        var hdn = document.getElementById('<%=hdnRecordingCallId.ClientID %>');
        hdn.value = RecId;
        var btn = document.getElementById('<%=lnkCompleteRecordingCall.ClientID %>');
        btn.click();
    }

    String.prototype.trim = function() {
        return this.replace(/^\s*/, "").replace(/\s*$/, "");
    }

    function showInteractions() {
        if (document.getElementById("dvInteractions").style.display == "block") {
            document.getElementById("dvInteractions").style.display = "none";
            document.getElementById("imgInteractions").src = "<%= ResolveUrl("~/images/expand.png") %>"; 
        }
        else {
            document.getElementById("dvInteractions").style.display = "block";
            document.getElementById("imgInteractions").src = "<%= ResolveUrl("~/images/collapse.png") %>"; 
        }
    }
    
    function openPhoneBook(){
        var ret = window.showModalDialog('<%= ResolveUrl("~/CallControls/PhoneBook.aspx")%>', null,"dialogWidth:750px; dialogHeight:280px; center:yes; status: no; scrollbars: no;");
        
        if ((ret!= undefined ) && (ret.ext!='') && (ret.action!='')) {
            switch(ret.action)
            {
            case 'call':
                make_call(ret.extension);
                break;
            case 'transfer':
                transfer_call(ret.extension);
                break;
            case 'park':
                park_call(ret.extension);
                break;
            case 'voicemail':
                voicemail_call(ret.extension);   
                break;   
            }
        }
    }
    
    function openLookup(){
        var ret = window.showModalDialog('<%= ResolveUrl("~/CallControls/WorkgroupDir.aspx")%>'+ '?rand='+Math.floor(Math.random()*99999), null,"dialogWidth:740px; dialogHeight:300px; center:yes; status: no; scrollbars: no;");
        
        if ((ret!= undefined ) && (ret.ext!='') && (ret.action!='')) {
            switch(ret.action)
            {
            case 'call':
                make_call(ret.extension);
                break;
            case 'transfer':
                transfer_call(ret.extension);
                break;
            case 'park':
                park_call(ret.extension);
                break;
            case 'voicemail':
                voicemail_call(ret.extension);   
                break;   
            }
        }
    }
        
    function OpenDialPad(){
        var obj = window;
        window.showModalDialog('<%= ResolveUrl("~/CallControls/DialPad.aspx")%>', obj,"dialogWidth: 50px; dialogHeight:260px; center:yes; status: no; scrollbars: no; resizable: no;");
    }
    
    function openHistory(){
        var obj = window;
        var ret = window.showModalDialog('<%= ResolveUrl("~/CallControls/CallHistory.aspx")%>', obj,"dialogWidth: 600px; dialogHeight:200px; center:yes; status: no; scrollbars: no; resizable: no;");
        return false;
    }
    
    function openSearch(PhoneNumber){
        var obj = window;
        var ret = window.showModalDialog('<%= ResolveUrl("~/CallControls/SearchResults.aspx")%>' + '?Phone=' + PhoneNumber, obj,"dialogWidth: 600px; dialogHeight:200px; center:yes; status: no; scrollbars: no; resizable: no;");
        return ret;
    }
    
     function RedirectToDefault() {
        var btn = document.getElementById('<%=lnkSwitchRedirect.ClientID %>');
        btn.click();
    }
    
    function hold_call() {
        var btn = document.getElementById('<%=btnHold.ClientID %>');
        btn.click();
    }
    
    function mute_call() {
        var btn = document.getElementById('<%=btnMute.ClientID %>');
        btn.click();
    }
    
    function JoinConference(inter){
        var txt = document.getElementById('<%=hdnLastInterId.ClientID %>');
        txt.value = inter;
        var btn = document.getElementById('<%=lnkJoinToConference.ClientID %>');
        btn.click();
    }
    
    function createConference(){
        var ret = window.showModalDialog('<%= ResolveUrl("~/CallControls/JoinConference.aspx")%>' + '?rand='+Math.floor(Math.random()*99999) , null,"dialogWidth: 500px; dialogHeight:200px; center:yes; status: no; scrollbars: no; resizable: no;");
        if ((ret!= undefined ) && (ret.interaction!='')) {
            JoinConference(ret.interaction);
        }
        return false;
    }

    function disconnectcall(){
        var btn = document.getElementById('<%=btnDisconnect.ClientID %>');
        btn.click();
    }
      
</script>

<table cellpadding="0" cellspacing="0"  >
    <tr>
        <td>
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <uc1:Interactions ID="Interactions1" runat="server" />
                        <table>
                            <tr>
                                <td>
                                    Make Call:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtNumber" runat="server" MaxLength="16" Width="75px" CssClass="entry2"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:UpdatePanel ID="upCallControls" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional"
                                        RenderMode="Inline">
                                        <ContentTemplate>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton ID="btnMakeCall" runat="server" ImageUrl="~/images/phone2.png" 
                                                            ToolTip="Make Call" TabIndex="1" />
                                                        <asp:HiddenField ID="hdnCallContolLeadId" runat="server" />
                                                        <asp:HiddenField ID="hdnDialerCallId" runat="server" />
                                                        <asp:LinkButton ID="lnkCIDDialerMakeCall" runat="server" />
                                                        <asp:LinkButton ID="lnkDialerINMakeCall" runat="server" />
                                                    </td>
                                                    <td style="padding-left: 5px; padding-right: 5px">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnDialPad" runat="server" ImageUrl="~/images/p_dialpad_dis.png"
                                                            ToolTip="DialPad" OnClientClick="return OpenDialPad();" />
                                                        <asp:HiddenField ID="hdnDialPad" runat="server" />
                                                        <asp:LinkButton ID="lnkDialPad" runat="server" />
                                                    </td>
                                                    <td style="padding-left: 5px; padding-right: 5px">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnPickup" runat="server" ImageUrl="~/images/p_pickup.png" ToolTip="Pickup" />
                                                    </td>
                                                    <td id="tdSepHold" style="padding-left: 5px; padding-right: 5px" runat="server">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnHold" runat="server" ImageUrl="~/images/p_hold.png" ToolTip="Hold" />
                                                    </td>
                                                    <td style="padding-left: 5px; padding-right: 5px">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnMute" runat="server" ImageUrl="~/images/p_mute.gif" ToolTip="Mute" />
                                                    </td>
                                                    <td id="tdSepDisconnect" style="padding-left: 5px; padding-right: 5px" runat="server">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnDisconnect" runat="server" ImageUrl="~/images/p_hangup.png"
                                                            ToolTip="Disconnect" />
                                                    </td>
                                                    <td id="tdSepVoiceMail" style="padding-left: 5px; padding-right: 5px" runat="server">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnVoiceMail" runat="server" ImageUrl="~/images/p_voicemail.gif"
                                                            ToolTip="Send to Voicemail" />
                                                    </td>
                                                    <td style="padding-left: 5px; padding-right: 5px">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnRecord" runat="server" ImageUrl="~/images/p_record.png" ToolTip="Record" />
                                                        <asp:LinkButton ID="lnkStartRecord" runat="server" />
                                                        <asp:LinkButton ID="lnkStopRecord" runat="server" />
                                                        <asp:LinkButton ID="lnkCompleteUWVerifCall" runat="server" />
                                                        <asp:HiddenField ID="hdnUWVerifId" runat="server" />
                                                        <asp:LinkButton ID="lnkCompleteRecordingCall" runat="server" />
                                                        <asp:HiddenField ID="hdnRecordingCallId" runat="server" />
                                                    </td>
                                                    <td style="padding-left: 5px; padding-right: 5px">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="ImgConference" runat="server" ImageUrl="~/images/16x16_phone_add.png" ToolTip="Add to Conference" OnClientClick="return createConference();" />
                                                        <asp:HiddenField ID="hdnLastInterId" runat="server" />
                                                        <asp:LinkButton ID="lnkJoinToConference" runat="server" />
                                                    </td>
                                                    <td style="display: none;">
                                                        <asp:ImageButton ID="btnTransferPark" runat="server" />
                                                    </td>
                                                    <td style="display: none;">
                                                        <asp:ImageButton ID="btnTransferVoiceMail" runat="server" />
                                                    </td>
                                                    <td style="padding-left: 5px; padding-right: 5px">
                                                        |
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/images/16x16_search.png"
                                                            ToolTip="Search" />
                                                    </td>
                                                    <td style="padding-left: 5px; padding-right: 5px">
                                                        |
                                                    </td>
                                                    <td>
                                                        Transfer:
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtTransfer" runat="server" MaxLength="16" Width="75px" CssClass="entry2"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:UpdatePanel ID="upCallControls1" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional"
                                        RenderMode="Inline">
                                        <ContentTemplate>
                                            <asp:ImageButton ID="btnTransfer" runat="server" ImageUrl="~/images/p_transfer.png"
                                                ToolTip="Transfer" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left: 5px; padding-right: 5px">
                        |
                    </td>
                    <td>
                        <img id="ImgPhoneBook" src="<%= ResolveUrl("~/images/16x16_addressbook.png") %>"
                            title="Phone Book" onclick="openPhoneBook();" style="cursor: hand;" />
                    </td>
                    <td style="padding-left: 5px; padding-right: 5px">
                        |
                    </td>
                    <td>
                        <asp:ImageButton ID="ImgHistory" runat="server" ImageUrl="~/images/16x16_clock.png"
                            ToolTip="History" OnClientClick="return openHistory();" style="cursor: hand;" />
                    </td>
                    <td style="padding-left: 5px; padding-right: 5px">
                        |
                    </td>
                    <td>
                        <img id="ImgLookUp" src="<%= ResolveUrl("~/images/16x16_people.png") %>"
                            title="Workgroup Directories" onclick="openLookup();" style="cursor: hand;" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:UpdatePanel ID="UpdMessage" runat="server" ChildrenAsTriggers="True" UpdateMode="Conditional"
                            RenderMode="Inline">
                            <ContentTemplate>
                                <table width="100%">
                                    <tr>
                                        <td width="10px">
                                            <img id="img1" src='<%= ResolveUrl("~/images/bullet_6x6_square_orange.png") %>' title="Refresh"
                                                onclick="window.location.reload();" alt=""  />
                                        </td>
                                        <td width="20px">
                                            <asp:ImageButton ID="ImgBell" runat="server" />
                                        </td>
                                        <td>
                                            <img id="imgFace" src='<%= ResolveUrl("~/images/sad_face.gif") %>' runat="server" alt=""  />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnDisconnectSession" runat="server" Text="Retry" style="width: 56px; font-family:Tahoma; font-size: 10px;"  />
                                        </td>
                                        <td align="right">
                                            <asp:LinkButton ID="lnkDirectPickup" runat="server"></asp:LinkButton>
                                            <asp:HiddenField ID="hdnDirectPickup" runat="server"></asp:HiddenField>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td>
                        Status:
                    </td>
                    <td>
                        <asp:UpdatePanel ID="upStatusChange" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlUserStatus" runat="server" AutoPostBack="true" CssClass="entry2">
                                </asp:DropDownList>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdatePanel ID="upTimeChange" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                            <ContentTemplate>
                                <asp:Label ID="lblTimeInStatus" runat="server"></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td style="padding-left: 5px; padding-right: 5px">
                        |
                    </td>
                    <td>
                        <asp:UpdatePanel ID="upInteractions" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblInteractionId" runat="server" Text="No Current Interaction"></asp:Label>&nbsp;
                                <asp:Literal ID="ltlAlerting" runat="server"></asp:Literal>
                                <asp:Timer ID="Timer1" runat="server" Interval="2000" OnTick="Timer1_Tick">
                                </asp:Timer>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                    <td style="padding-left: 5px; padding-right: 5px">                                
                        <img id="imgInteractions" src="<%= ResolveUrl("~/images/expand.png") %>" onclick="showInteractions();" alt = ""/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<div id="dvInteractions" style="display: none;">
                                    <asp:UpdatePanel ID="updInteractions" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:GridView ID="grdInteractions" runat="server" AutoGenerateColumns="False" CellPadding="3"
                                                SelectedRowStyle-BackColor="#FFFF66" OnRowCommand="grdInteractions_RowCommand"
                                                DataKeyNames="InteractionId">
                                                <Columns>
                                                    <asp:ButtonField ButtonType="Link" Text="->" CommandName="Select" />
                                                    <asp:BoundField DataField="InteractionId" HeaderText="Call Id" />
                                                    <asp:TemplateField HeaderText="Direction">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lbldirection" runat="server" Text='<%# iif(Eval("Direction")=1, "From","To") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="RemoteName" HeaderText="Name" />
                                                    <asp:BoundField DataField="RemoteAddress" HeaderText="Number" />
                                                    <asp:BoundField DataField="Duration" HeaderText="Duration" />
                                                    <asp:BoundField DataField="StateDescription" HeaderText="State" />
                                                    <asp:BoundField DataField="WorkgroupQueueName" HeaderText="Queue" />
                                                </Columns>
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
 <asp:LinkButton ID="lnkSwitchRedirect" runat="server"></asp:LinkButton>
