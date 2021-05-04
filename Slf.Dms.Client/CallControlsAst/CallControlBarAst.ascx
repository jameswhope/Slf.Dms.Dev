<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CallControlBarAst.ascx.vb" Inherits="CallControlsAst_CallControlBarAst" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

    <style type="text/css">
        #callcontrolsbar td{white-space: nowrap;}
        #tblLines{
            font-size: 11px;
            color: #000000;
            background-color: #FFFFFF;
            border-spacing: 1px; 
        }
        #colLines{
        	background-color: #6699FF;
        }
        #bodyLines tr td{
            border-bottom-style: dotted;
            border-bottom-width: 1px;
            border-color: Gray;  
        }
        #bodyLines tr:hover{
            background-color: #FFFFCC;
            cursor: hand; 
        }
        .lineSelected{
            font-weight: bold;
            background-color: #64FFB1;
        }
        .CallDialog
        {
            color: #000000;
            border: thin outset #999999;
            background-color: #FFFFFF;
        }
        #dvhistoryTitle, #dvDirectoryTitle, #dvFaxTitle, #dv3WayTitle
        {
            background-color: #FF9933;
            color: #FFFFFF;
            font-weight: bold; 
            cursor: move;
            height: 20px;
            padding-top: 7px;
            text-align: center;  
        }
        #dvHistory
        {
        	width: 450px;
        	height: 400px;
        	margin: 5px 5px 5px 5px;
        	overflow: scroll;  
        	}
        #dv3Way
        {
        	width: 100%;
        	height: 100%;
        	}
       .wmimessage
       {
       	    padding: 1px; 
       	    border: thin solid white; 
       	    font-size: xx-small; 
       	    vertical-align: top; 
       	    background-color: #FF0000; 
       	    z-index: 99; 
       	    position: relative; 
       	    left: -15px;
       	    display: none;  
       	    color: yellow; 
       	    font-weight: bold; 
       	}

     </style> 


    <bgsound id="bsoundin" src="" loop="-1" delay="2000" />
    <input type="hidden" id="mfilein" src="<%= ResolveUrl("~/callcontrolsast/ringin.wav")%>" />
    <bgsound id="bsoundout" src="" loop="-1" delay="2000" />
    <input type="hidden" id="mfileout" src="<%= ResolveUrl("~/callcontrolsast/ringout.wav")%>" />
    
    <script type="text/javascript">

        function pageLoad() {
            try {
                docuReady();
            } catch (e) { } 
        }

        function docuReady() {
            $(document).ready(function() {
                $("#<%= txtPhoneNumber.ClientId %>").unbind('keyup').keyup(function(event) {
                    if (event.keyCode == 13) {
                        event.preventDefault();
                        $("#<%= btnMakeCall.ClientId %>").click();
                    }
                });
                $("#<%= txtTransferNo.ClientId %>").unbind('keyup').keyup(function(event) {
                    if (event.keyCode == 13) {
                        event.preventDefault();
                        $("#<%= btnTransfer.ClientId %>").click();
                    }
                });
            });
        }

        function StartRingInTone() {
            bsoundin.src = mfilein.src;
        }

        function StopRingInTone() {
            bsoundin.src = "";
        }

        function StartRingOutTone() {
            bsoundout.src = mfileout.src;
        }

        function StopRingOutTone() {
            bsoundout.src = "";
        }

    </script>
    
    <script type="text/javascript">

         function CallSession() {
             this.sessionId = 0;
             this.CallState = false;
             this.RecvState = false;
             this.HoldState = false;
             this.RecordState = false;
             this.LineStatus = LINE_IDLE;
             this.CallStartTime = null;
             this.CallEndTime = null;
             this.CallDirecction = DIRECTION_NONE;
             this.RemoteNumber = '';
             this.uniqueid = '';
             this.callid = '';
             this.RecordingFileName = '';
         }

         CallSession.prototype.Reset = function() {
             this.sessionId = 0;
             this.CallState = false;
             this.RecvState = false;
             this.HoldState = false;
             this.RecordState = false;
             this.LineStatus = LINE_IDLE;
             this.CallStartTime = null;
             this.CallEndTime = null;
             this.CallDirecction = DIRECTION_NONE;
             this.RemoteNumber = '';
             this.uniqueid = '';
             this.callid = '';
             this.RecordingFileName = '';
         }

         CallSession.prototype.GetsessionId = function() {
             return this.sessionId;
         }

         CallSession.prototype.SetsessionId = function(id) {
             this.sessionId = id;
         }

         CallSession.prototype.GetCallState = function() {
             return this.CallState;
         }

         CallSession.prototype.SetUniqueId = function(id) {
             this.uniqueid = id;
         }

         CallSession.prototype.GetUniqueId = function() {
             return this.uniqueid;
         }

         CallSession.prototype.SetCallId = function(id) {
             this.callid = id;
             StoreSessionVar('currentcallid',id);
         }

         CallSession.prototype.GetCallId = function() {
             return this.callid;
         }

         CallSession.prototype.SetCallState = function(state) {
             this.CallState = state;
         }

         CallSession.prototype.GetRecvState = function() {
             return this.RecvState;
         }

         CallSession.prototype.SetRecvState = function(state) {
             this.RecvState = state;
         }

         CallSession.prototype.GetHoldState = function() {
             return this.HoldState;
         }

         CallSession.prototype.SetHoldState = function(state) {
             this.HoldState = state;
         }

         CallSession.prototype.GetRecordState = function() {
             return this.RecordState;
         }

         CallSession.prototype.SetRecordState = function(state) {
             this.RecordState = state;
         }

         CallSession.prototype.GetRecordingFileName = function() {
             return this.RecordingFileName;
         }

         CallSession.prototype.SetRecordingFileName = function(filename) {
             this.RecordingFileName = filename;
         }

         CallSession.prototype.GetLineStatus = function() {
             return this.LineStatus;
         }

         CallSession.prototype.SetLineStatus = function(status) {
             this.LineStatus = status;
         }

         CallSession.prototype.GetCallStartTime = function() {
              return this.CallStartTime;
         }

         CallSession.prototype.SetCallStartTime = function(d) {
              this.CallStartTime = d;
         }

         CallSession.prototype.GetCallEndTime = function() {
              return this.CallEndTime;
         }

         CallSession.prototype.SetCallEndTime = function(d) {
              this.CallEndTime = d;
          }

          CallSession.prototype.GetCallDirection = function() {
              return this.CallDirection;
          }

          CallSession.prototype.SetCallDirection = function(direction) {
              this.CallDirection = direction;
          }

          CallSession.prototype.GetRemoteNumber = function() {
              return this.RemoteNumber;
          }

          CallSession.prototype.SetRemoteNumber = function(remote_number) {
              this.RemoteNumber = remote_number;
          }

          CallSession.prototype.GetCallDuration = function() {
              var d1 = this.GetCallStartTime();
              var d2 = this.GetCallEndTime();
              return GetElapsedTime(d1, d2);
          }

          function GetElapsedTime(d1, d2) { 
              if (d1 == null) return "00:00:00";
              if (d2 == null) d2 = new Date();

              var d = new Date();

              d.setTime(Math.floor(d2.getTime() - d1.getTime()));
              var timediff = d.getTime();

              var days = Math.floor(timediff / (1000 * 60 * 60 * 24));
              timediff -= days * (1000 * 60 * 60 * 24);
              var hours = Math.floor(timediff / (1000 * 60 * 60));
              timediff -= hours * (1000 * 60 * 60);
              var mins = Math.floor(timediff / (1000 * 60));
              timediff -= mins * (1000 * 60);
              var secs = Math.floor(timediff / 1000);
              timediff -= secs * 1000;

              return ((days > 0) ? (days + 'd ') : '') + (((hours < 10) ? '0' : '') + hours) + ':' + (((mins < 10) ? '0' : '') + mins) + ':' + (((secs < 10) ? '0' : '') + secs);
          }
          
          CallSession.prototype.GetCallStatus = function() {
               var callStatus;
                
               if (this.GetHoldState() == true) {
                   callStatus = "Held";
               } else {
                   callStatus = GetCallStatusStr(this.GetLineStatus());
               }
               return callStatus;
          }  

    </script>
    
    <div style="height: 60px">
        <table id="callcontrolsbar">
            <tr>
            <td>
                <asp:TextBox ID="txtPhoneNumber" runat="server" MaxLength="16" Width="100px" ></asp:TextBox>
            </td>
            <td>
                <asp:ImageButton ID="btnMakeCall" runat="server" ImageUrl="~/images/phone2.png" ToolTip="Make Call"  OnClientClick="MakeCall();return false;" />
            </td>
            <td>
                <asp:ImageButton ID="btnDialPad" runat="server" ImageUrl="~/images/p_dialpad_dis.png" ToolTip="Dialpad" OnClientClick="return false;"  />
            </td>
            <td>
                <asp:ImageButton ID="btnPickup" runat="server" ImageUrl="~/images/p_pickup.png" ToolTip="Pickup" OnClientClick="Pickup();return false;" />
            </td>
            <td>
                <asp:ImageButton ID="btnHold" runat="server" ImageUrl="~/images/p_hold.png" ToolTip="Hold" OnClientClick="Hold();return false;"  />
            </td>
            <td>
                <asp:ImageButton ID="btnMute" runat="server" ImageUrl="~/images/p_mute.gif" ToolTip="Mute" OnClientClick="Mute(); return false;"/>
            </td>
            <td>
                <asp:ImageButton ID="btnHangup" runat="server" ImageUrl="~/images/p_hangup.png" ToolTip="Hangup" OnClientClick="Hangup();return false;"  />
            </td>
            <td>
                <asp:ImageButton ID="btnVoiceMail" runat="server" ImageUrl="~/images/p_voicemail.gif" ToolTip="Forward to Voice Mail" OnClientClick="SendToVoiceMail();return false;"  />
            </td>
            <td>
                <asp:ImageButton ID="btnRecord" runat="server" ImageUrl="~/images/p_record.png" ToolTip="Record Call" OnClientClick="RecordCall();return false;"  />
            </td>
            <td>
                <asp:TextBox ID="txtTransferNo" runat="server" Width="100px"></asp:TextBox>
                <asp:ImageButton ID="btnTransfer" runat="server" ImageUrl="~/images/p_transfer.png" ToolTip="Transfer" OnClientClick="Transfer();return false;"  />
            </td>
            <td>
                <asp:ImageButton ID="img3Way" runat="server" ImageUrl="~/images/p_3way.png" ToolTip="Conference Call" OnClientClick="Open3WayPopup();return false;"  />
            </td>
            <td>
               <asp:ImageButton ID="btnPark" runat="server" ImageUrl="~/images/p_park1.gif" ToolTip="Park Call" OnClientClick="ParkCall();return false;"  />
            </td>
            <td>
                <input id="RdLine1" type="radio" onclick="ChangeLine(1);" name="RdLine" title="Line 1" value="1" /> 
                <input id="RdLine2" type="radio" onclick="ChangeLine(2);" name="RdLine" title="Line 2" value="2" /> 
                <input id="RdLine3" type="radio" onclick="ChangeLine(3);" name="RdLine" title="Line 3" value="3" /> 
            </td>
            <td>
                <span id="currentCall"></span>
            </td>
            <td>
                <asp:ImageButton ID="btnShowCalls" runat="server" ImageUrl="~/images/expand.png" OnClientClick="ShowCalls();return false;" ToolTip="Show Calls"    />
            </td>
            <td id="tdPhoneBook" runat="server">
                <asp:ImageButton ID="ImgDirectory" runat="server" ImageUrl="~/images/16x16_addressbook.png" OnClientClick="OpenDirectoryPopup();return false;" ToolTip="Phone Book"    />
            </td>
             <td>
                <asp:ImageButton ID="ImgHistory" runat="server" ImageUrl="~/images/16x16_clock.png" OnClientClick="OpenHistoryPopup(); return false;" ToolTip="Call History"    />
            </td>
            <td>
                <asp:ImageButton ID="ImgMessages" runat="server" ImageUrl="~/images/mail.gif" OnClientClick="CheckVoiceMail();;return false;" ToolTip="Messages"    />
                <span id="WMI" class="wmimessage"/>
            </td>
            <td>
                <asp:ImageButton ID="ImgFax" runat="server" ImageUrl="~/images/p_fax.gif" OnClientClick="OpenFaxPopup();return false;" ToolTip="Send Fax"    />
            </td>
        </tr>
        <tr>
            <td colspan="19" >
                <table>
                    <tr>
                        <td>
                            <img id="imgConnected" src='<%=ResolveUrl("~/images/sad_face.gif") %>' alt="Status" title="Not Connected" />
                        </td>
                        <td>
                            Status:
                        </td>
                        <td>
                            <select id="cboStatus" runat="server" onchange="SetPresence(this);"  >
                            </select>
                            <asp:HiddenField ID="hdnTimeInStatus" runat="server" />
                            <asp:Label ID="lblTimeInStatus" runat="server" Text=""></asp:Label>
                            <asp:LinkButton ID="lnkSetPresence" runat="server"></asp:LinkButton>
                            <asp:UpdatePanel ID="updAstStatus" runat="server">
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID= "lnkSetPresence" EventName="Click" /> 
                            </Triggers>  
                            </asp:UpdatePanel>
                        </td>
                        <td>
                            <asp:ImageButton ID="imgLogs" runat="server" OnClientClick="showLogs();return false;" ImageUrl="~/images/16x16_play.png" ToolTip="System Log"  />   
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        </table>
    </div>
    <asp:Panel ID="pnlLines" runat="server" >
        <div id="grdLines">
            <table id="tblLines" cellpadding="2px;" >
                <thead>
                    <tr id="colLines">
                        <th id="thLine" width="25px">Line</th>
                        <th id="thCallDirection" width="100px">Direction</th>
                        <th id="thRemoteNumber"  width="150px">Number</th>
                        <th id="thCallDuration"  width="100px">Duration</th>
                        <th id="thCallStatus"  width="100px">Status</th>
                    </tr>
                </thead> 
                <tbody id="bodyLines">
                </tbody> 
            </table>
        </div>
    </asp:Panel>
    
    <asp:Panel ID="pnlDialPad" runat="server" Width="130px"   >
        <div style="text-align:right; "  > 
            <table style="border: solid 1px #000000; margin-top: 5px; background-color: #ffffff;" >
                <tr>
                    <td><asp:Button ID="btnKey1" runat="server" Text="1" OnClientClick="DialPad('1', 1); return false;" /></td>
                    <td><asp:Button ID="btnKey2" runat="server" Text="2" OnClientClick="DialPad('2', 2); return false;"/></td>
                    <td><asp:Button ID="btnKey3" runat="server" Text="3" OnClientClick="DialPad('3', 3); return false;"/></td>
                </tr>
                <tr>
                    <td><asp:Button ID="btnKey4" runat="server" Text="4" OnClientClick="DialPad('4', 4); return false;"/></td>
                    <td><asp:Button ID="btnKey5" runat="server" Text="5" OnClientClick="DialPad('5', 5); return false;"/></td>
                    <td><asp:Button ID="btnKey6" runat="server" Text="6" OnClientClick="DialPad('6', 6); return false;"/></td>
                </tr>
                <tr>
                    <td><asp:Button ID="btnKey7" runat="server" Text="7" OnClientClick="DialPad('7', 7); return false;"/></td>
                    <td><asp:Button ID="btnKey8" runat="server" Text="8" OnClientClick="DialPad('8', 8); return false;"/></td>
                    <td><asp:Button ID="btnKey9" runat="server" Text="9" OnClientClick="DialPad('9', 9); return false;"/></td>
                </tr>
                <tr>
                    <td><asp:Button ID="btnKeyStar" runat="server" Text="*" OnClientClick="DialPad('*', 10); return false;"/></td>
                    <td><asp:Button ID="btnKey0" runat="server" Text="0" OnClientClick="DialPad('0', 0); return false;"/></td>
                    <td><asp:Button ID="btnKeyPound" runat="server" Text="#" OnClientClick="DialPad('#', 11); return false;"/></td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    
    <asp:Panel ID="pnlCallHistory" runat="server" CssClass="CallDialog">
        <div id="dvhistoryTitle">
         Call History
          <img src="<%=ResolveUrl("~/images/16x16_close.png") %>" alt="close" title="Close" 
                style="float: right; padding-right: 3px; cursor: hand; z-index: 99999;" onclick="CloseHistoryPopup();"  />   
        </div>
        <div id="dvHistory">
            <asp:LinkButton ID="lnkReloadHistory" runat="server"></asp:LinkButton>
            <asp:UpdatePanel ID="uptCallHistory" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="grdHistory" runat="server" AutoGenerateColumns="False" CellPadding="3">
                        <Columns>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Image ID="imgStatus" runat="server" /><asp:Label ID="lblStatus" runat="server"
                                        Text=""></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Date" DataField="CallDate" DataFormatString="{0:G}" />
                            <asp:TemplateField HeaderText="Number">
                                <ItemTemplate>
                                    <asp:Label ID="lblClid" runat="server" Text=""></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Number">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkMakeCall" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Duration">
                                <ItemTemplate>
                                    <asp:Label ID="lblDuration" runat="server" Text=""></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BackColor="Silver" />
                    </asp:GridView>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="lnkReloadHistory" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlDirectory" runat="server" Width="650px" CssClass="CallDialog"  >
        <div id="dvDirectoryTitle">
         Phone Book
          <img src="<%=ResolveUrl("~/images/16x16_close.png") %>" alt="close" title="Close" 
                style="float: right; padding-right: 3px; cursor: hand; z-index: 99999;" onclick="CloseDirectoryPopup();"  />   
        </div>
        <div style="height: 400px">
             <iframe id="iDirectory"  class ="" runat="server" />  
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlFax" runat="server" Width="650px" CssClass="CallDialog"  >
        <div id="dvFaxTitle">
         Send Fax
          <img src="<%=ResolveUrl("~/images/16x16_close.png") %>" alt="close" title="Close" 
                style="float: right; padding-right: 3px; cursor: hand; z-index: 99999;" onclick="CloseFaxPopup();"  />   
        </div>
        <div style="height: 400px">
             <iframe id="iSendFax"  class ="" runat="server" />  
        </div>
    </asp:Panel>
    <asp:Panel ID="pnl3Way" runat="server" Width="450px" CssClass="CallDialog"  >
        <div id="dv3WayTitle">
         Conference Call
          <img src="<%=ResolveUrl("~/images/16x16_close.png") %>" alt="close" title="Close" 
                style="float: right; padding-right: 3px; cursor: hand; z-index: 99999;" onclick="Close3WayPopup();"  />   
        </div>
        <div id="dv3Way">
             <iframe id="i3Way"  class ="" runat="server" />  
        </div>
    </asp:Panel>
    
    <cc1:popupcontrolextender ID="PopupDialpad" runat="server" 
    TargetControlID="btnDialPad" PopupControlID="pnlDialPad">
    </cc1:popupcontrolextender>
    <cc1:popupcontrolextender ID="PopupCallHistory" runat="server"  
    TargetControlID="imgHistory" PopupControlID="pnlCallHistory" 
    Position="Bottom" OffsetX="-150" OffsetY="50" 
    BehaviorID="BehaviorPopupCallHistory"  ></cc1:popupcontrolextender>
    <cc1:DragPanelExtender ID="DPECallHistory" runat="server"
    TargetControlID="pnlCallHistory"
    DragHandleID="dvhistoryTitle"  />
    <cc1:popupcontrolextender ID="PopupDirectory" runat="server"  
    TargetControlID="imgDirectory" PopupControlID="pnlDirectory" 
    Position="Bottom" OffsetX="-450" OffsetY="50" 
    BehaviorID="BehaviorPopupDirectory"  ></cc1:popupcontrolextender>
    <cc1:DragPanelExtender ID="DPEDirectory" runat="server"
    TargetControlID="pnlDirectory"
    DragHandleID="dvDirectoryTitle"  />
    <cc1:popupcontrolextender ID="PopupSendFax" runat="server"  
    TargetControlID="imgFax" PopupControlID="pnlFax" 
    Position="Bottom" OffsetX="-450" OffsetY="50" 
    BehaviorID="BehaviorPopupFax"  ></cc1:popupcontrolextender>
    <cc1:DragPanelExtender ID="DPEFax" runat="server"
    TargetControlID="pnlFax"
    DragHandleID="dvFaxTitle"  />
    <cc1:popupcontrolextender ID="Popup3Way" runat="server"  
    TargetControlID="img3Way" PopupControlID="pnl3Way" 
    Position="Bottom" OffsetX="-150" OffsetY="50" 
    BehaviorID="BehaviorPopup3Way"  ></cc1:popupcontrolextender>
    <cc1:DragPanelExtender ID="DPE3Way" runat="server"
    TargetControlID="pnl3Way"
    DragHandleID="dv3WayTitle"  />
    
    <cc1:AlwaysVisibleControlExtender ID="avLogs" TargetControlId="txtLogs" runat="server" VerticalSide="Top" VerticalOffset="30" HorizontalSide="right" HorizontalOffset="20" ScrollEffectDuration=".1"  />     

    <object id="device" classid="clsid:D8395749-5098-4534-9437-675352C9C51B" codebase="<%= ResolveUrl("~/CallControlsAst/device.cab")%>#Version=6,6,0,0" style="display:none;">
    </object>
    <object id="portsip" classid="clsid:727EF490-A113-4D54-B64C-1455828831AC" codebase="<%= ResolveUrl("~/CallControlsAst/portsip.cab")%>#Version=6,6,0,0" style="display:none;">
    </object>
    <asp:TextBox ID="txtLogs" runat="server" TextMode="MultiLine" Rows="10" 
        Width="500px" style="display: none;" ReadOnly="true"  ></asp:TextBox>
    <asp:HiddenField ID="hdnSIPInited" runat="server" />
    <asp:HiddenField ID="hdnSIPRegistered" runat="server" />
    <asp:HiddenField ID="hdnMute" runat="server" />
    <asp:HiddenField ID="hdnUserDisplayName" runat="server" />
    <asp:HiddenField ID="hdnUserName" runat="server" />
    <asp:HiddenField ID="hdnPassword" runat="server" />
    <asp:HiddenField ID="hdnProxyServer" runat="server" />
    <asp:HiddenField ID="hdnProxyPort" runat="server" />
    <asp:HiddenField ID="hdnRecordingPath" runat="server" />
    
    <script type="text/javascript" >
        var device = document.getElementById("device");
        var portsip = document.getElementById("portsip");
        var SIPInited = document.getElementById("<%= hdnSIPInited.ClientId %>");
        var SIPRegistered = document.getElementById("<%= hdnSIPRegistered.ClientId %>");
        var txtLogs = document.getElementById("<%= txtLogs.ClientId %>");
        var mfilein = document.getElementById("mfilein");
        var mfileout = document.getElementById("mfileout");
        var bsoundin = document.getElementById("bsoundin");
        var bsoundout = document.getElementById("bsoundout");
        var Sessions;
        var CurrentLine;
        var Transfer;
        var LINE_BASE = 1;
        var MAXLINE = 3;
        // audio codecs
        var AUDIOCODEC_PCMU = 0;
        var AUDIOCODEC_PCMA = 8;
        var AUDIOCODEC_GSM = 3;
        var AUDIOCODEC_G729 = 18;
        // For DTMF - RFC2833
        var AUDIOCODEC_DTMF = 101;
        // Log level
        var PORTSIP_LOG_NONE = -1;
        var PORTSIP_LOG_DEBUG = 0;
        var PORTSIP_LOG_ERROR = 1;
        var PORTSIP_LOG_WARNING = 2;
        var PORTSIP_LOG_INFO = 3;
        // Line Status
        var LINE_IDLE = 0;
        var LINE_DIALING = 1;
        var LINE_ALERTING = 2;
        var LINE_CALL = 3;
        // Audio record file format
        var FILEFORMAT_WAVE = 1;
        // CALL_DIRECTION
        var DIRECTION_NONE = 0;
        var DIRECTION_INBOUND = 1;
        var DIRECTION_OUTBOUND = 2;
        var intervalid;

        window.onload = window_onload;
        window.onunload = window_onunload; 
        
        function createSessions() {
            Sessions = new Array(9);
            for (i = 0; i < MAXLINE; ++i) {
                Sessions[i] = new CallSession;
            }
        }

        function deleteSessions() {
            for (i = 0; i < MAXLINE; ++i) {
                if (Sessions[i].GetCallState() == true) {
                    portsip.terminateCall(Sessions[i].GetsessionId());
                    Sessions[i].Reset();
                    continue;
                }
                if (Sessions[i].GetRecvState() == true) {
                    portsip.rejectCall(Sessions[i].GetsessionId(), 486, "Busy here");
                    Sessions[i].Reset();
                    continue;
                }
            }
            for (i = 0; i < MAXLINE; ++i) {
                delete Sessions[i];
            }
        }

        function initDevice() {
            device.initialize();
            //device.setAudioInputVolume(0, 15);
            //device.setAudioOutputDevice();
        }

        function unloadDevice() {
            device.unInitialize();
        }

        function initPortsip() {
            var username = document.getElementById("<%= hdnUserName.ClientId %>");
            var pwd = document.getElementById("<%= hdnPassword.ClientId %>");
            var proxyserver = document.getElementById("<%= hdnProxyServer.ClientId %>");
            var proxyport = document.getElementById("<%= hdnProxyPort.ClientId %>");
            var userdisplayname = document.getElementById("<%= hdnUserDisplayName.ClientId %>");
            
            if (SIPInited.value == "1") {
                AddToStatusLogList("The Webphone was inited.");
                return;
            }
            if (username.value == "") {
                AddToStatusLogList("Please enter your user name.");
                return;
            }
            if (proxyserver.value == "") {
                AddToStatusLogList("Please enter the SIP proxy server.");
                return;
            }
            if (proxyport.value == "") {
                AddToStatusLogList("Please enter the SIP proxy port");
                return;
            }
            var LocalIP = device.getLocalIP(0);
            var LocalSIPPort = Math.round(Math.random() * 4000 + 1000);
            var transport = 0; //TRANSPORT_UDP

            ret = portsip.initialize(transport, PORTSIP_LOG_NONE, 8, username.value, userdisplayname.value, "", pwd.value, "PortSIP VoIP 6.0", LocalIP, LocalSIPPort, "", proxyserver.value, Number(proxyport.value), "", 0, "", 0);
            if (ret == -1) {
                AddToStatusLogList("Web Phone Initialization failed.");
                return;
            }

            SIPInited.value = "1";
            SetSRTPType();
            UpdateAudioCodecs();
            InitSettings();
            portsip.enableCheckMwi(1);
            portsip.detectWmi(); 

            ret = portsip.registerServer(80);
            if (ret == -1) {
                AddToStatusLogList("Register to server failed.");
                portsip.unInitialize();

                SIPInited.value = "0";
                return;
            }
            displayButtons();
        }

        function unloadPortsip() {
            if (SIPRegistered.value == "1") {
                portsip.unRegisterServer();
                SIPRegistered.value = "0";
            }
            if (SIPInited.value == "1") {
                portsip.unInitialize();
                SIPInited.value = "0";
            }

        }

        function SetSRTPType() {
            if (SIPInited.value != "1") {
                return;
            }
            var SRTPType = 0; //SRTP_POLICY_NONE
            portsip.setSrtpPolicy(SRTPType);
        }
        
        function UpdateAudioCodecs(){
            if (SIPInited.value != "1") {
                return;
            }
            portsip.clearAudioCodec();
            portsip.addAudioCodec(AUDIOCODEC_PCMU);
            portsip.addAudioCodec(AUDIOCODEC_PCMA);
            portsip.addAudioCodec(AUDIOCODEC_GSM);
            portsip.addAudioCodec(AUDIOCODEC_G729);
            portsip.addAudioCodec(AUDIOCODEC_DTMF);
            portsip.enableDtmfOfRFC2833(101);
        }

        function InitSettings() {
            if (SIPInited.value != "1") {
                return;
            }
            portsip.enableDtmfOfRFC2833(101);
            portsip.setDTMFSamples(160);
            portsip.enableAEC(1);     //  Enable AEC
            portsip.enableAGC(1);     //  Enable AGC
            portsip.enableCNG(0);     //  Disable CNG
            portsip.enableVAD(0);     //  Disable VAD
        }
        function window_onload() {
            createSessions();
            CurrentLine = 0;
            SelectLine(1);
            resetButtons();
            initDevice();
            initPortsip();
            intervalid = setInterval("DisplayLines()", 1000);
            return false;
        }
        function window_onunload() {
            StopRingInTone();
            StopRingOutTone();
            clearInterval(intervalid); 
            unloadDevice();
            deleteSessions();
            unloadPortsip();
            txtLogs.value = "";
            CurrentLine = 0;
            SelectLine(1);
            resetButtons();
            return false;
        }
        function AddToStatusLogList(value) {
            if (txtLogs.value.length == 0)
                txtLogs.value = txtLogs.value + value;
            else
                txtLogs.value = txtLogs.value + "\n" + value;

            txtLogs.scrollTop = txtLogs.scrollHeight;
        }

        function ChangeLine(line) {
        
            line = line - 1;

            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }

            if (CurrentLine == line) {
                return;
            }

            if (Sessions[CurrentLine].GetCallState() == true && Sessions[CurrentLine].GetHoldState() == false) {
                portsip.hold(Sessions[CurrentLine].GetsessionId());
                Sessions[CurrentLine].SetHoldState(true);

                text = "Hold on line: " + (LINE_BASE + CurrentLine);
                AddToStatusLogList(text);
            }

            CurrentLine = line;

            if (Sessions[CurrentLine].GetCallState() == true && Sessions[CurrentLine].GetHoldState() == true) {
                portsip.unHold(Sessions[CurrentLine].GetsessionId());
                Sessions[CurrentLine].SetHoldState(false);

                text = "Call established(unHold) on line: " + (LINE_BASE + CurrentLine);
                AddToStatusLogList(text);
            }
            
            displayButtons();
        }

        function SelectLine(line) {
            var rd = document.getElementById('RdLine' + line);
            rd.checked = true;
        }

        function GetCallDirectionStr(direction, abbr) {
            switch (direction) {
                case DIRECTION_INBOUND:
                    return ((abbr==true)?"From":"Incoming");
                    break;
                case DIRECTION_OUTBOUND:
                    return ((abbr==true)?"To":"Outgoing");
                    break;
                default:
                    return '';
            }
        }

        function GetCallStatusStr(status) {
            switch (status) {
                case LINE_ALERTING :
                    return "Alerting";
                    break;
                case LINE_DIALING :
                    return "Dialing";
                    break;
                case LINE_CALL:
                    return "Connected";
                    break;
                default:
                    return '';
            }
        }

        function DisplayLines() {
            DisplayConnectionStatus();
            DisplayTimeInStatus();
            DisplayCurrentCall();
           
            var cols = document.getElementById("colLines");
            var tbody = document.getElementById("bodyLines");
            var tr, td, th;

            if (tbody.hasChildNodes() == false) {
                //Create Row
                tr = document.createElement("tr");
                for (j = 0; j < cols.childNodes.length; j++) {
                    td = document.createElement("td");
                    td.setAttribute("width", cols.childNodes[j].getAttribute("width")); 
                    tr.appendChild(td);
                }

                //Create Lines
                var tr1;
                for (i = 0; i < MAXLINE; i++) {
                    tr1 = tr.cloneNode(true);
                    tr1.id = 'tr' + (i + 1);
                    tr1.setAttribute("onclick", "SelectLine(" + (i + 1) + ");ChangeLine(" + (i + 1) + ");");
                    tbody.appendChild(tr1);
                }

            }
            
            //Populate lines
            var s;
            for (i = 0; i < MAXLINE; i++) {
                tr = tbody.childNodes[i];  
                s = Sessions[i];
                 if (s.GetLineStatus() == LINE_IDLE) {
                     tr.style.display = 'none';
                     tr.setAttribute("class", "");
                } else {
                    td = tr.childNodes[0];
                    td.innerHTML = (i + 1);
                    td = tr.childNodes[1];
                    td.innerHTML = GetCallDirectionStr(s.GetCallDirection(), false);
                    td = tr.childNodes[2];
                    td.innerHTML = s.GetRemoteNumber();
                    td = tr.childNodes[3];
                    td.innerHTML = s.GetCallDuration();
                    td = tr.childNodes[4];
                    td.innerHTML = s.GetCallStatus();
                    tr.style.display = 'block';
                    if (i == CurrentLine) {
                        tr.setAttribute("class", "lineSelected");
                    } else {
                        tr.setAttribute("class", "");
                    }
                 }
             }
             
              //portsip.detectWmi(); 
        }

        function DisplayConnectionStatus() {
            var img = document.getElementById('imgConnected');   
            if (SIPInited.value == "1" && SIPRegistered.value == "1") {
                img.src='<%=ResolveUrl("~/images/happy_face.gif") %>';
                img.title = 'Connected';
            } else {
            img.src = '<%=ResolveUrl("~/images/sad_face.gif") %>';
                img.title = 'Not Connected';
            }
        }

        function DisplayTimeInStatus() {
            var lasttime = document.getElementById('<%=hdnTimeInStatus.ClientId %>').value;
            var lbltimeinstatus = document.getElementById('<%=lblTimeInStatus.ClientId %>');
            var d1 = new Date(lasttime);  
            lbltimeinstatus.innerHTML = GetElapsedTime(d1, null);   
        }
        
        function DisplayCurrentCall() {
            var call = document.getElementById("currentCall");
            var s = Sessions[CurrentLine];
            if (s.GetLineStatus() == LINE_IDLE) {
                call.innerHTML = "Line " + (LINE_BASE + CurrentLine) + ": No current call.";
            } else {
            call.innerHTML = "Line " + (LINE_BASE + CurrentLine) + ": " + GetCallDirectionStr(s.GetCallDirection(), true) + " " + s.GetRemoteNumber() + " " + s.GetCallDuration() + " (" + s.GetCallStatus() + ")";
            }
        }

        function ShowCalls() {
            var pnl = document.getElementById("<%=pnlLines.Clientid %>");
            var img = document.getElementById("<%=btnShowCalls.Clientid %>");
            if (pnl.style.display != 'block') {
                pnl.style.display = 'block';
                img.src = '<%=ResolveUrl("~/images/collapse.png") %>';
                img.title = "Hide Calls";
            } else {
                pnl.style.display = 'none';
                img.src = '<%=ResolveUrl("~/images/expand.png") %>';
                img.title = "Show Calls";
            }
        }
        
    </script> 
    
    <script type="text/javascript" >

        function getNextAvailableLine() {
            var LineIndex = -1;
            for (i = 0; i < MAXLINE; ++i) {
                if (Sessions[i].GetCallState() == false && Sessions[i].GetRecvState() == false) {
                    LineIndex = i;
                    break;
                }
            }
            return LineIndex;
        }
    
        function SelectNextAvailableLine() {
            var LineIndex = getNextAvailableLine();

            if (LineIndex == -1) {
                AddToStatusLogList("No available lines");
                return false;
            }

            SelectLine(LineIndex+1);
            ChangeLine(LineIndex+1);

            return true;
        }
        
        function MakeCall() {
            var PhoneNo = document.getElementById('<%= txtPhoneNumber.ClientId %>');
            //DialNumber(PhoneNo.value, PhoneNo.value);
            MakeOutboundCall(PhoneNo.value);
        }


        function MakeCall_NextLine(callTo, displayTo, callid) {
            if (SelectNextAvailableLine() == true) {
                DialNumber(callTo, displayTo, callid);
            }
        }

        function DialNumber(callTo, displayTo, callid) {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (callTo == "") {
                AddToStatusLogList("The dial phone number is empty");
                return;
            }
            if (Sessions[CurrentLine].GetCallState() == true || Sessions[CurrentLine].GetRecvState() == true) {
                AddToStatusLogList("Current line is busy now, please switch a line");
                return;
            }
            UpdateAudioCodecs();
            var hasSDP = 1;

            portsip.setAudioDeviceId(0, 0);
            sessionId = portsip.call(callTo, hasSDP);
            if (sessionId <= 0) {
                AddToStatusLogList("Call failed");
                return;
            }
            Sessions[CurrentLine].SetsessionId(sessionId);
            Sessions[CurrentLine].SetCallState(true);
            Sessions[CurrentLine].SetLineStatus(LINE_DIALING);
            Sessions[CurrentLine].SetRemoteNumber(displayTo);
            if (callid) Sessions[CurrentLine].SetCallId(callid);
            displayButtons();
            text = "Calling... on line: " + (LINE_BASE + CurrentLine);
            AddToStatusLogList(text);
        
        }

        function Pickup() {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (Sessions[CurrentLine].GetRecvState() == false) {
                AddToStatusLogList("Current line does not has incoming call, please switch a line.");
                return;
            }
            StopRingInTone();
            if (portsip.answerCall(Sessions[CurrentLine].GetsessionId()) == 0) {
                Sessions[CurrentLine].SetCallState(true);
                Sessions[CurrentLine].SetRecvState(false);
                Sessions[CurrentLine].SetLineStatus(LINE_CALL);
                displayButtons(); 
                text = "Call established on line: " + (LINE_BASE + CurrentLine);
                AddToStatusLogList(text);
                AfterPickup(Sessions[CurrentLine].GetRemoteNumber());
            }
            else {
                Sessions[CurrentLine].Reset();
                text = "Answer call failed on line: " + (LINE_BASE + CurrentLine);
                AddToStatusLogList(text);
                return;
            }
        }

        function Hangup() {
            HangupLine(CurrentLine);
        }

        function HangupLine(line) {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (Sessions[line].GetCallState() == false && Sessions[line].GetRecvState() == false) {
                return;
            }
            StopRingInTone();
            StopRingOutTone();
            if (Sessions[line].GetCallState() == true) {
                portsip.terminateCall(Sessions[line].GetsessionId());
                var callid = Sessions[line].GetCallId();
                var direction = Sessions[line].GetCallDirection();
                Sessions[line].Reset();
                displayButtons();
                text = "Hang Up on line: " + (LINE_BASE + line);
                AddToStatusLogList(text);
                text = "Call Id is: " + callid;
                AddToStatusLogList(text);
                if (callid && direction == DIRECTION_INBOUND) {
                    ClassifyIncomingCall(callid);
                }
                return;
            }
            if (Sessions[line].GetRecvState() == true) {
                portsip.rejectCall(Sessions[line].GetsessionId(), 486, "Busy here");
                Sessions[line].Reset();
                displayButtons();
                text = "Reject call on line: " + (LINE_BASE + line);
                AddToStatusLogList(text);
                return;
            }
        }

        function Hold() {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (Sessions[CurrentLine].GetCallState() == false) {
                return;
            }
            if (Sessions[CurrentLine].GetHoldState() == false) {
                portsip.hold(Sessions[CurrentLine].GetsessionId());
                Sessions[CurrentLine].SetHoldState(true);
                text = "Hold call on line: " + (LINE_BASE + CurrentLine);
            } else { 
                portsip.unHold(Sessions[CurrentLine].GetsessionId());
                Sessions[CurrentLine].SetHoldState(false);
                text = "Call established(unHold) on line: " + (LINE_BASE + CurrentLine);
            }
            displayButtons();
            AddToStatusLogList(text);
        }

        function Mute() {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            var hdnMute = document.getElementById('<%= hdnMute.ClientId %>');
            if (hdnMute.value != 1) {
                hdnMute.value = "1";
                portsip.muteMicrophone(1);
                AddToStatusLogList("Mute set to ON");
            } else {
                hdnMute.value = "0";
                portsip.muteMicrophone(0);
                AddToStatusLogList("Mute set to OFF");
            }
            displayButtons();
        }

        function SendToVoiceMail() {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (Sessions[CurrentLine].GetCallState() == false && Sessions[CurrentLine].GetRecvState() == false) {
                return;
            }

            var voicemail = document.getElementById("<%= hdnUserName.ClientId %>");
            if (Sessions[CurrentLine].GetLineStatus() == LINE_ALERTING) {
                ret = portsip.forwardCall(Sessions[CurrentLine].GetsessionId(), '*6' + voicemail.value);
            } else {
                ret = portsip.refer(Sessions[CurrentLine].GetsessionId(), '*6' + voicemail.value);
            }
            if (ret == 0) {
                StopRingInTone();
                StopRingOutTone();
                Sessions[CurrentLine].Reset();
                displayButtons(); 
                text = "Send to voicemail on line: " + (LINE_BASE + CurrentLine);
            } else {
                text = "Send to voicemail failed on line: " + (LINE_BASE + CurrentLine);
            }
            AddToStatusLogList(text);
        }

        function Transfer() {
            var transferno = document.getElementById("<%= txtTransferNo.ClientId %>");
            TransferTo(transferno.value);
        }

        function TransferTo(transferno) {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (Sessions[CurrentLine].GetCallState() == false) {
                AddToStatusLogList("You must established the call first");
                return;
            }
            if (transferno == "") {
                AddToStatusLogList("The transfer number is empty");
                return;
            }
            if (portsip.refer(Sessions[CurrentLine].GetsessionId(), transferno) == -1) {
                text = "Transfer failed on line: " + (LINE_BASE + CurrentLine);
                AddToStatusLogList(text);
                return;
            }

            var callid = Sessions[CurrentLine].GetCallId();
            var direction = Sessions[CurrentLine].GetCallDirection();
            Sessions[CurrentLine].Reset();
            displayButtons();
            text = "Transfer call on line: " + (LINE_BASE + CurrentLine);
            AddToStatusLogList(text);
            if (callid && direction == DIRECTION_INBOUND) {
                ClassifyIncomingCall(callid);
            }
        }

        function RecordCall() {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (Sessions[CurrentLine].GetCallState() == false) {
                return;
            }
            
            var filePath = document.getElementById("<%= hdnRecordingPath.ClientId%>");
            var fileName = '';
            if (Sessions[CurrentLine].GetRecordState() == false){

                fileName = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) { var r = Math.random() * 16 | 0, v = c == 'x' ? r : r & 0x3 | 0x8; return v.toString(16); });
                if (filePath.value == "") {
                    AddToStatusLogList("The record file path or name is empty!");
                    return;
                }
                
                // Record the audio into file as WAVE format
                portsip.setAudioRecordPathName(filePath.value, fileName, 1, FILEFORMAT_WAVE);
                portsip.startAudioRecordingOnLine(Sessions[CurrentLine].GetsessionId());
                Sessions[CurrentLine].SetRecordState(true);
                Sessions[CurrentLine].SetRecordingFileName(fileName);
                AddToStatusLogList("Start recording audio conversation on line " + (LINE_BASE + CurrentLine));
            } else {
                portsip.stopAudioRecordingOnLine(Sessions[CurrentLine].GetsessionId());
                document.getElementById("<%= hdnRecordingPath.ClientId%>");
                fileName = Sessions[CurrentLine].GetRecordingFileName();
                var callid = Sessions[CurrentLine].GetCallId();
                if (fileName) { sendEmail( callid, fileName) };
                Sessions[CurrentLine].SetRecordingFileName('');
                Sessions[CurrentLine].SetRecordState(false);
                AddToStatusLogList("Stop recording audio conversation on line " + (LINE_BASE + CurrentLine));
            }
            displayButtons();
        }

        function RecordCallInPath(filePath, fileName) {
            if (SIPInited.value != "1" || SIPRegistered.value != "1") {
                return;
            }
            if (Sessions[CurrentLine].GetCallState() == false) {
                return;
            }
            if (Sessions[CurrentLine].GetRecordState() == false) {
                if (filePath == "") {
                    AddToStatusLogList("The record file path or name is empty!");
                    return;
                }

                // Record the audio into file as MP3 format
                portsip.setAudioRecordPathName(filePath, fileName, 0, FILEFORMAT_WAVE);
                portsip.startAudioRecordingOnLine(Sessions[CurrentLine].GetsessionId());
                Sessions[CurrentLine].SetRecordState(true);
                Sessions[CurrentLine].SetRecordingFileName(fileName);
                AddToStatusLogList("Start recording audio conversation on line " + (LINE_BASE + CurrentLine));
            } 
            displayButtons();
        }

        function DialPadString(dialstr) {
            var val;
            for (i = 0; i < dialstr.length; i++) {
                switch (dialstr.charAt(i).toLowerCase()) {
                    case "*":
                        val = 10;
                        break;
                    case "#":
                        val = 11;
                        break;
                    default:   
                        val = parseInt(dialstr.charAt(i)); 
                        break;
                }
                DialPad(dialstr.charAt(i), val);
            }
        }

        function DialPad(keyno, keyvalue) {
            var phonenumber = document.getElementById("<%= txtPhoneNumber.ClientId %>");
            phonenumber.value += keyno;

            if (SIPInited.value == "1" && SIPRegistered.value == "1" && Sessions[CurrentLine].GetCallState() == true) {
                portsip.sendDtmf(Sessions[CurrentLine].GetsessionId(), keyvalue);
            }
        }

        function ParkCall() {
            if (SIPInited.value == "1" && SIPRegistered.value == "1" && Sessions[CurrentLine].GetCallState() == true) {
                var sid = Sessions[CurrentLine].GetsessionId();
                portsip.sendDtmf(sid, 11);
                portsip.sendDtmf(sid, 11);
                portsip.sendDtmf(sid, 7);
                portsip.sendDtmf(sid, 0);
            }
        }

        function enableMakeCall(enable) { 
            var btn = document.getElementById('<%= btnMakeCall.ClientId %>');
            if (enable == true) {
                btn.src = '<%= ResolveUrl("~/images/phone2.png") %>';
                btn.disabled = false;
            } else { 
                btn.src = '<%= ResolveUrl("~/images/phone_dis.png") %>';
                btn.disabled = true;
            }
        }

        function enablePickup(enable) {
            var btn = document.getElementById('<%= btnPickup.ClientId %>');
            if (enable == true) {
                btn.src = '<%= ResolveUrl("~/images/p_pickup.png") %>';
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_pickup_dis.png") %>';
                btn.disabled = true;
            }
        }

        function enableHangup(enable) {
            var btn = document.getElementById('<%= btnHangup.ClientId %>');
            if (enable == true) {
                btn.src = '<%= ResolveUrl("~/images/p_hangup.png") %>';
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_hangup_dis.png") %>';
                btn.disabled = true;
            }
        }

        function enableHold(enable) {
            var btn = document.getElementById('<%= btnHold.ClientId %>');
            if (enable == true) {
                if (Sessions[CurrentLine].GetHoldState() == true) {
                    btn.src = '<%= ResolveUrl("~/images/p_hold_on.png") %>';
                } else { 
                    btn.src = '<%= ResolveUrl("~/images/p_hold.png") %>';
                }
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_hold_dis.png") %>';
                btn.disabled = true;
            }
        }
        
        function enableMute(enable) {
            var btn = document.getElementById('<%= btnMute.ClientId %>');
            var mute = document.getElementById('<%= hdnMute.ClientId %>');
            if (enable == true) {
                if (mute.value == "1") {
                    btn.src = '<%= ResolveUrl("~/images/p_mute_on.gif") %>';
                } else {
                    btn.src = '<%= ResolveUrl("~/images/p_mute.gif") %>';
                }
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_mute_dis.gif") %>';
                btn.disabled = true;
            }
        }

        function enableVoiceMail(enable) {
            var btn = document.getElementById('<%= btnVoiceMail.ClientId %>');
            if (enable == true) {
                btn.src = '<%= ResolveUrl("~/images/p_voicemail.gif") %>';
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_voicemail_dis.gif") %>';
                btn.disabled = true;
            }
        }

        function enableTransfer(enable) {
            var btn = document.getElementById('<%= btnTransfer.ClientId %>');
            if (enable == true) {
                btn.src = '<%= ResolveUrl("~/images/p_transfer.png") %>';
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_transfer_dis.png") %>';
                btn.disabled = true;
            }
        }

        function enable3Way(enable) {
            var btn = document.getElementById('<%= img3Way.ClientId %>');
            if (enable == true) {
                btn.src = '<%= ResolveUrl("~/images/p_3way.png") %>';
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_3way_dis.png") %>';
                btn.disabled = true;
            }
        }

        function enableRecord(enable) {
            var btn = document.getElementById('<%= btnRecord.ClientId %>');
            if (enable == true) {
                if (Sessions[CurrentLine].GetRecordState() == true) {
                    btn.src = '<%= ResolveUrl("~/images/p_record_stop.png") %>';
                } else {
                    btn.src = '<%= ResolveUrl("~/images/p_record.png") %>';
                }
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_record_dis.png") %>';
                btn.disabled = true;
            }
        }

        function enablePark(enable) {
            var btn = document.getElementById('<%= btnPark.ClientId %>');
            if (enable == true) {
                btn.src = '<%= ResolveUrl("~/images/p_park1.gif") %>';
                btn.disabled = false;
            } else {
                btn.src = '<%= ResolveUrl("~/images/p_park1_dis.gif") %>';
                btn.disabled = true;
            }
        }
        
        function resetButtons() {
            enableMakeCall(false);
            enablePickup(false);
            enableHangup(false);
            enableHold(false);
            enableMute(false);
            enableVoiceMail(false);
            enableRecord(false);
            enableTransfer(false);
            enable3Way(false);
            enablePark(false);
        }

        function displayButtons() {
            switch (Sessions[CurrentLine].GetLineStatus()) {
                case LINE_DIALING:
                    enableMakeCall(false);
                    enablePickup(false);
                    enableHangup(true);
                    enableHold(false);
                    enableMute(true);
                    enableVoiceMail(false);
                    enableRecord(false);
                    enableTransfer(false);
                    enable3Way(false);
                    enablePark(false);
                    break;
                case LINE_ALERTING:
                    enableMakeCall(false);
                    enablePickup(true);
                    enableHangup(true);
                    enableHold(false);
                    enableMute(true);
                    enableVoiceMail(true);
                    enableRecord(false);
                    enableTransfer(false);
                    enable3Way(false);
                    enablePark(false);
                    break;
                case LINE_CALL:
                    enableMakeCall(false);
                    enablePickup(false);
                    enableHangup(true);
                    enableHold(true);
                    enableMute(true);
                    enableVoiceMail(true);
                    enableRecord(true);
                    enableTransfer(true);
                    enable3Way(true);
                    enablePark(true);
                    break;
                default:
                    enableMakeCall(true);
                    enablePickup(false);
                    enableHangup(false);
                    enableHold(false);
                    enableMute(false);
                    enableVoiceMail(false);
                    enableRecord(false);
                    enableTransfer(false);
                    enable3Way(false);
                    enablePark(false);
            }
        }

        function getCurrentCall() {
            return Sessions[CurrentLine];
        }

        function getCallRecordState() {
            return Sessions[CurrentLine].GetRecordState();
        }

        function getCallRecordingFile() {
            return Sessions[CurrentLine].GetRecordingFileName();
        }

        function MakeConferenceCall(conferenceid) {
            var APP = 'LWR';
            if (SIPInited.value == "1" && SIPRegistered.value == "1" && Sessions[CurrentLine].GetCallState() == true && conferenceid.length > 0) {
                MapConferenceCall(conferenceid);
                MakeCall_NextLine(APP + 'COP' + conferenceid, 'Conference ' + conferenceid, conferenceid);
            }
        }
        
        function MapCall(callid) {
            if (SIPInited.value == "1" && SIPRegistered.value == "1" && Sessions[CurrentLine].GetCallState() == true && callid.length > 0) {
                var sid = Sessions[CurrentLine].GetsessionId();
                Sessions[CurrentLine].SetCallId(callid);
                portsip.sendDtmf(sid, 10);
                portsip.sendDtmf(sid, 4);
                for (i = 0; i < callid.length; ++i) {
                    portsip.sendDtmf(sid, parseInt(callid.charAt(i)));
                }
                portsip.sendDtmf(sid, 11);
            }
        }

        function MapConferenceCall(conferenceid) {
            if (SIPInited.value == "1" && SIPRegistered.value == "1" && Sessions[CurrentLine].GetCallState() == true && conferenceid.length > 0) {
                var sid = Sessions[CurrentLine].GetsessionId();
                portsip.sendDtmf(sid, 10);
                portsip.sendDtmf(sid, 6);
                for (i = 0; i < conferenceid.length; ++i) {
                    portsip.sendDtmf(sid, parseInt(conferenceid.charAt(i)));
                }
                portsip.sendDtmf(sid, 11);
            }
        } 

        function SetPresence(cbo) {
            var dnd = '*78';
            if (cbo.options[cbo.options.selectedIndex].getAttribute("Available") == 'True') {
                dnd = '*79';
            }
            portsip.call(dnd, 0);
            var btn = document.getElementById('<%=lnkSetPresence.ClientId %>');
            btn.click();
            var lasttime = document.getElementById('<%=hdnTimeInStatus.ClientId %>').value = new Date();
        }

        function OpenHistoryPopup() {
            $find('BehaviorPopupCallHistory').showPopup();
            //reload data
            var btn = document.getElementById('<%= lnkReloadHistory.Clientid %>');
            btn.click(); 
        }

        function CloseHistoryPopup() {
            $find('BehaviorPopupCallHistory').hidePopup();
        }

        function OpenDirectoryPopup() {
            var p = $find('BehaviorPopupDirectory');
            p.add_hiding(unLoadDirectory);
            p.showPopup();
            
            var ifr = document.getElementById('<%= iDirectory.ClientId %>');
            ifr.src = '<%=ResolveUrl("~/CallControlsAst/PhoneBook.aspx") %>';  
        }

        function CloseDirectoryPopup() {
            $find('BehaviorPopupDirectory').hidePopup();
        }
        
        function unLoadDirectory() { 
            var ifr = document.getElementById('<%= iDirectory.ClientId %>');
            ifr.src = '';
        }

        function OpenFaxPopup() {
            var p = $find('BehaviorPopupFax');
            p.showPopup();

            var ifr = document.getElementById('<%= iSendFax.ClientId %>');
            ifr.src = 'http://dmf-tel-0012/recordings/index.php?m=SendFax&f=Display';
        }

        function CloseFaxPopup() {
            $find('BehaviorPopupFax').hidePopup();
        }

        function Open3WayPopup() {
            var p = $find('BehaviorPopup3Way');
            p.showPopup();

            var ifr = document.getElementById('<%= i3Way.ClientId %>');
            ifr.src = '<%=ResolveUrl("~/CallControlsAst/ConferenceCall.aspx") %>';
        }

        function Close3WayPopup() {
            $find('BehaviorPopup3Way').hidePopup();
        }

        function CheckVoiceMail() {
            MakeCall_NextLine('*97','VoiceMail','');
        }

        function showLogs() {
            if (txtLogs.style.display  == 'none') {
                txtLogs.style.display='block';
            } else {
                txtLogs.style.display='none';
            }
        }

        function sendEmail(callid, filename) {
            try {
                SendRecordingByEmail(callid, filename);
            } catch (e) { 
                //ignore
            } 
            
        }
       
    </script> 
    
    
    <script language="javascript" type="text/javascript" for="portsip" event="registerSuccess">
    // <!CDATA[
       text = "Registration succeeded.";
       AddToStatusLogList(text);
	   SIPRegistered.value = "1";
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="registerFailure(reason, code)">
    // <!CDATA[
       text = "Registration failed.";
       AddToStatusLogList(text);
	   SIPRegistered.value = "0";
    // ]]>
    </script>
    
    <script language="javascript" type="text/javascript" for="portsip" event="inviteTrying(sessionId)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       Sessions[LineIndex].SetCallDirection(DIRECTION_OUTBOUND);
       Sessions[LineIndex].SetCallStartTime(new Date());
       text = "Call is trying... on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
    // ]]>
    </script>
    
    <script language="javascript" type="text/javascript" for="portsip" event="InviteRinging(sessionId, hasEarlyMedia, hasVideo, audioCodecName, videoCodecName)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       if(hasEarlyMedia != 1)
       {
         // The ringing hasn't the early media, you have to play the WAV file for the ring tone.
         StartRingOutTone();
       }
       else
       {
         // Do not need to play the wave file.
       }

       text = "Call is ringing... on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);

    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="InviteAnswered(sessionId, reason, code, hasVideo, audioCodecName, videoCodecName)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       StopRingInTone();
       StopRingOutTone();
       Sessions[LineIndex].SetCallState(true);
       Sessions[CurrentLine].SetLineStatus(LINE_CALL);
       displayButtons();
       text = "Call established on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
       
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="InviteClosed(sessionId)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       StopRingInTone();
       StopRingOutTone();
       var callid = Sessions[LineIndex].GetCallId();
       var direction = Sessions[LineIndex].GetCallDirection();
       Sessions[LineIndex].Reset();
       displayButtons(); 
       text = "Call Closed on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
       text = "Call Id is: " + callid; 
       AddToStatusLogList(text);
       if (callid && direction == DIRECTION_INBOUND){
            ClassifyIncomingCall(callid);
       }
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="inviteFailure(sessionId, reason, code)">
    // <!CDATA[

       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }

       if(LineIndex == -1)
       {
         return;
       }

       StopRingInTone();
       StopRingOutTone();

       Sessions[LineIndex].Reset();
       displayButtons(); 
       text = "Call failed on line " + (LINE_BASE + LineIndex) + " : "+reason + " " + code;
       AddToStatusLogList(text);

    // ]]>
    </script>
    
    <script language="javascript" type="text/javascript" for="portsip" event="InviteIncoming(sessionId, callerDisplayName, caller, calleeDisplayName, callee, hasVideo, audioCodecName, videoCodecName)">
    // <!CDATA[
       var LineIndex = -1;
       for (i = 0; i < MAXLINE; ++i) {
            if (Sessions[i].GetCallState() == false && Sessions[i].GetRecvState() == false) {
                Sessions[i].SetRecvState(true);
                LineIndex = i;

                break;
            }
       }
      
       if(LineIndex == -1)
       {
         portsip.rejectCall(sessionId, 486, "Busy here");
         return;
       }

       Sessions[LineIndex].SetsessionId(sessionId);
       StartRingInTone();
       Sessions[LineIndex].SetLineStatus(LINE_ALERTING);
       Sessions[LineIndex].SetCallDirection(DIRECTION_INBOUND);
       Sessions[LineIndex].SetCallStartTime(new Date());
       var calleridlen = caller.indexOf("@");
       if (calleridlen == -1)  calleridlen = caller.length();
       Sessions[LineIndex].SetRemoteNumber(caller.substring(0, calleridlen));
       displayButtons();
       text = "Incoming call on line " + (LINE_BASE + LineIndex) + " from "+ callerDisplayName + " <" + caller + ">";
       AddToStatusLogList(text);

       // Need to play the wave file here to alert the incoming call

    // ]]>
    </script>
    
    <script language="javascript" type="text/javascript" for="portsip" event="inviteBeginForward(forwardingTo)">
    // <!CDATA[
       text = "Call has been forwared to: ";
       text += forwardingTo;
       AddToStatusLogList(text);
    // ]]>
    </script>
    
    <script language="javascript" type="text/javascript" for="portsip" event="RemoteHold(sessionId)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       text = "Placed on hold by remote party on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="RemoteUnHold(sessionId)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       text = "Call established(unHold) on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="TransferTrying(sessionId, referTo)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }

       text = "Transfer trying on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);

        //  for example, if A and B is established call, A transfer B to C, the transfer is trying,
        //  B will got this transferTring event, and use referTo to know C ( C is "referTo" in this case)
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="TransferRinging(sessionId, hasVideo)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       text = "Transfer Ringing on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="PASVTransferSuccess(sessionId)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       text = "Transfer succeeded on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
    // ]]>
    </script>

    <script language="javascript" type="text/javascript" for="portsip" event="PASVTransferFailure(sessionId, reason, code)">
    // <!CDATA[
       var LineIndex = -1;
       for(i=0; i<MAXLINE; ++i)
       {
         if(Sessions[i].GetsessionId() == sessionId)
         {
           LineIndex = i;
           break;
         }
       }
       if(LineIndex == -1)
       {
         return;
       }
       text = "Transfer failed on line " + (LINE_BASE + LineIndex);
       AddToStatusLogList(text);
    // ]]>
    </script>
    
    <script language="javascript" type="text/javascript" for="portsip" event="waitingVoiceMessage(messageAccount, urgentNewMessageCount, urgentOldMessageCount, newMessageCount, oldMessageCount)">
    // <!CDATA[
       var wmi =document.getElementById('WMI')
       wmi.innerHTML = newMessageCount;
       if (newMessageCount == '0'){
            wmi.style.display = 'none';
       } else {
             wmi.style.display = 'inline';
       }
    // ]]>
    </script>
    
   
    
    
