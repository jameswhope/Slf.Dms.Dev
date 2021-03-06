<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="phonecall.aspx.vb" Inherits="clients_client_communication_phonecall" Title="DMP - Client - Phone Call" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register src="../../../CustomTools/UserControls/Scanning/ScanningControl.ascx" tagname="ScanningControl" tagprefix="uc2" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server"><asp:placeholder id="phBody" runat="server">

    <body onload="SetFocus('<%= rbIncoming.ClientID %>');" style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>);background-position:left top;background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:90; }
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    function SetToNow(id)
    {
        var d = new Date();
        var month = d.getMonth() + 1
        var day = d.getDate()
        var year = d.getFullYear()
        
        if (day <= 9)
            day = "0" + day;
        if (month <= 9)
            month = "0" + month;
        
        var s = "/"
        var curDate = month + s + day + s + year
        
        var hours = d.getHours()
        var minutes = d.getMinutes()
        var seconds = d.getSeconds()
        var td="AM";
        if (hours >= 12)
            td = "PM";
        if (hours > 12)
            hours = hours - 12;
        if (hours == 0)
            hours = 12;
        if (minutes <= 9)
            minutes = "0" + minutes;
        if (hours <= 9)
            hours = "0" + hours;
        if (seconds <= 9)
            seconds = "0" + seconds;

        var curTime = hours + ":" + minutes + ":" + seconds + " " + td;

        var txtStarted = document.getElementById("<%= txtStarted.ClientID %>");
        var txtEnded = document.getElementById("<%= txtEnded.ClientID %>");

        if (id == "txtStarted")
        {
            txtStarted.value = curDate + " " + curTime;
        }
        else if (id == "txtEnded")
        {
            txtEnded.value = curDate + " " + curTime;
        }
    }

    var LastDirection = "";

    function SwitchDirection(direction)
    {
        if (LastDirection != direction)
        {
            var tdSenderHolder = document.getElementById("<%= tdSenderHolder.ClientID %>");
            var tdRecipientHolder = document.getElementById("<%= tdRecipientHolder.ClientID %>");
            var cboInternal = document.getElementById("<%= cboInternal.ClientID %>");
            var cboExternal = document.getElementById("<%= cboExternal.ClientID %>");
            
            if (direction == "Outgoing")
            {
                tdSenderHolder.appendChild(cboInternal);
                tdRecipientHolder.appendChild(cboExternal);
            }
            else
            {
                tdRecipientHolder.appendChild(cboInternal);
                tdSenderHolder.appendChild(cboExternal);
            }
            LastDirection = direction;
        }
    }
    function RowHover(td, on)
    {
        if (td.childElement.style.backgroundColor == "#000000")
        {
            return;
        }
        
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_Save()
    {
        if (Record_RequiredExist())
        {
            // postback to save
            <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function AddressBook()
    {
        var url = '<%= ResolveUrl("~/util/pop/addressbook.aspx?id=" & ClientID) %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Address Book",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 450, width: 550});
    }
    function AddRelation()
    {
         var url = '<%= ResolveUrl("~/util/pop/addrelation.aspx?to=phonecall&toid=" & PhoneCallID & "&dependencyid=" & ClientID) %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Add Relation to Call",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 450, width: 500});
    }
    function SetInfo(PersonID, Number)
    {
        var cboExternal = document.getElementById("<%= cboExternal.ClientID %>");
        var txtPhoneNumber = document.getElementById("<%= txtPhoneNumber.ClientID %>");

        txtPhoneNumber.value = Number;

        for (p = 0; p < cboExternal.options.length; p++)
        {
            if (cboExternal.options[p].value == PersonID)
            {
                cboExternal.selectedIndex = p;
                break;
            }
        }
    }
	function ShowMessage(Value)
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    dvError.style.display = "inline";
	    tdError.innerHTML = Value;
	}
	function HideMessage()
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    tdError.innerHTML = "";
	    dvError.style.display = "none";
	}
	function AddBorder(obj)
	{
        obj.style.border = "solid 2px red";
        obj.focus();
	}
	function RemoveBorder(obj)
	{
        obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
	}
    function Record_RequiredExist()
    {
        // cboInternal
        var cboInternal = document.getElementById("<%= cboInternal.ClientID %>");   
        var rbOutgoing = document.getElementById("<%= rbOutgoing.ClientID %>");   
        if (cboInternal.value <= 0)
        {
            if (rbOutgoing.checked)
	            ShowMessage("You must select a sender.");
	        else
	            ShowMessage("You must select a recipient.");
	        AddBorder(cboInternal);
            return false;        
        }
        
        // cboExternal
        var cboExternal = document.getElementById("<%= cboExternal.ClientID %>");   
        var rbIncoming = document.getElementById("<%= rbIncoming.ClientID %>");  
        if (cboExternal.value <= 0)
        {
            if (rbIncoming.checked)
	            ShowMessage("You must select a sender.");
	        else
	            ShowMessage("You must select a recipient.");
	        
	        AddBorder(cboExternal);
            return false;        
        }
    
        // txtMessage
        var txtMessage = document.getElementById("<%= txtMessage.ClientID %>");   
        if (txtMessage.value == null || txtMessage.value.length == 0)
        {
	        ShowMessage("You must enter a message.");
	        AddBorder(txtMessage);
            return false;        
        }
        
        // txtSubject
        var txtSubject = document.getElementById("<%= txtSubject.ClientID %>");   
        if (txtSubject.value == null || txtSubject.value.length == 0)
        {
	        ShowMessage("You must enter a subject.");
	        AddBorder(txtSubject);
            return false;        
        }
                
        // txtPhoneNumber
        var txtPhoneNumber = document.getElementById("<%= txtPhoneNumber.ClientID %>");   
        if (txtPhoneNumber.value.length == 0)
        {
            ShowMessage("The Phone Number is a required field.");
            AddBorder(txtPhoneNumber);
            return false;
        }
        else
        {
            if (!RegexValidate(txtPhoneNumber.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
            {
	            ShowMessage("The Phone Number is invalid.  Please enter a new value.");
                AddBorder(txtPhoneNumber);
                return false;
            }
        }

        // txtStarted
        var txtStarted = document.getElementById("<%= txtStarted.ClientID %>");   
        if (txtStarted.value.length == 0)
        {
            ShowMessage("The Started Time is a required field.");
            AddBorder(txtStarted);
            return false;
        }
        else
        {
	        if (!IsValidDate(txtStarted.value))
            {
                ShowMessage("The Started Time you entered is invalid.  Please enter a new value.");
                AddBorder(txtStarted);
                return false;
            }
        }

        // txtEnded
        var txtEnded = document.getElementById("<%= txtEnded.ClientID %>");   
        if (txtEnded.value.length == 0)
        {
            ShowMessage("The Ended Time is a required field.");
            AddBorder(txtEnded);
            return false;
        }
        else
        {
	        if (!IsValidDate(txtEnded.value))
            {
                ShowMessage("The Ended Time you entered is invalid.  Please enter a new value.");
                AddBorder(txtEnded);
                return false;
            }
        }

        return true;
    }
    function IsValidDate(Date)
    {
        return RegexValidate(Date, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$");
    }
    function isNumber(a) {
        return typeof a == 'number' && isFinite(a);
    }
    function RegexValidate(Value, Pattern)
    {
        //check to see if supposed to validate value
        if (Pattern != null && Pattern.length > 0)
        {
            var re = new RegExp(Pattern);

            return Value.match(re);
        }
        else
        {
            return false;
        }
    }
	function Record_DeleteConfirm()
	{
           var url = '<%= ResolveUrl("~/delete.aspx?t=Phone Call&p=phonecall") %>';
           window.dialogArguments = window;
           currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Phone Call",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 350, width: 400}); 
	}
    function Record_Delete()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
	function Record_DeleteConfirmRelation()
	{
         window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_DeleteRelation&t=Delete Relations&m=Are you sure you want to delete this selection of relations?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Relations",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400});
	}
    function Record_DeleteRelation()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDeleteRelation, Nothing) %>;
    }
    </script>
    
    <script type="text/javascript" language="javascript">
        var attachWin;
        var intAttachWin;
        
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == "IMG")
                obj = obj.parentElement;
                
            if (obj.tagName == "TD")
            {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null)
                {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#f4f4f4";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        function RowClick(tr, docRelID)
        {
            //unselect last row
            var tbl = tr.parentElement.parentElement;
            if (tbl.lastSelTr != null)
            {
                tbl.lastSelTr.coldColor = "#ffffff";
                tbl.lastSelTr.style.backgroundColor = "#ffffff";
            }
            
            //select this row
            tr.coldColor="#ededed";
            tr.style.backgroundColor = "#f0f0f0";
            
            document.getElementById('<%=hdnCurrentDoc.ClientID %>').value = docRelID;
            
            //set this as last
            tbl.lastSelTr = tr;
        }
        function AttachDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = <%=PhoneCallID %>;
            var addRelID = <%=AddRelation %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempPhoneCallID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=ClientID %>&type=phonecall&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
            intAttachWin = setInterval('WaitAttached()', 500);
        }
        function WaitAttached()
        {
            if (attachWin.closed)
            {
                clearInterval(intAttachWin);
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function DeleteDocument()
        {
            if (document.getElementById('<%=hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
            }
        }
        function OpenScanning1()
        {
            var relID = <%=PhoneCallID %>;
            var addRelID = <%=AddRelation %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempPhoneCallID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            
            try{
                self.top.frames[0].ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=ClientID %>&type=note&rel=' + relID);
            }
            catch(e){
                if(window.parent.parent != null)  
                    {
                       var val = window.parent.parent.ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=ClientID %>&type=note&rel=' + relID);
                    }
            }   
        }
        function OpenScanning()
            {
                var sc= document.getElementById('<%=ScanningControl1.ClientId %>') ;
                OpenScanPopup();
            }
        function WaitScanned()
        {
            if (scanWin.closed)
            {
                clearInterval(intScanWin);
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function GetCaller()
        {
            var ClientIndex = null;
            ClientIndex = document.getElementById("<%=cboExternal.ClientID %>").value;
            hdnCaller = ClientIndex
        }
    </script>
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>

        <table style="font-family: tahoma; font-size: 11px; width: 100%;
            height: 100%;" border="0" cellpadding="0" cellspacing="15">
            <tr>
                <td style="color: #666666;">
                    <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a
                        id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a
                            id="lnkCommunications" runat="server" class="lnk" style="color: #666666;">Communications</a>&nbsp;>&nbsp;<asp:label
                                id="lblPhoneCall" runat="server" style="color: #666666;"></asp:label></td>
            </tr>
            <tr>
                <td valign="top">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="3">
                                <div runat="server" id="dvError" style="display: none;">
                                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                        width="100%" border="0">
                                        <tr>
                                            <td valign="top" style="width: 20;">
                                                <img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                            <td runat="server" id="tdError"></td>
                                        </tr>
                                    </table>
                                    &nbsp;
                                </div>
                            </td>
                        </tr>
                        <asp:placeholder runat="server" id="bodMain">
                        <tr>
                            <td style="width:50%;" valign="top">
                                <table style="font-family:tahoma;font-size:11px;width: 100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="background-color: #f1f1f1;" colspan="3">Details</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Direction:</td>
                                        <td nowrap="nowrap"><input type="radio" name="rbDirection" id="rbIncoming" runat="server" onclick="javascript:SwitchDirection('Incoming');"/><label for="<%= rbIncoming.ClientID %>">Incoming</label>&nbsp;&nbsp;&nbsp;<input type="radio" name="rbDirection" id="rbOutgoing" runat="server" onclick="javascript:SwitchDirection('Outgoing');" checked="true" /><label for="<%= rbOutgoing.ClientID %>">Outgoing</label></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Sender:</td>
                                        <td id="tdSenderHolder" runat="server"><asp:dropdownlist cssclass="entry" runat="server" id="cboInternal"></asp:dropdownlist></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Recipient:</td>
                                        <td id="tdRecipientHolder" runat="server"><asp:dropdownlist cssclass="entry" runat="server" id="cboExternal" autopostback="true"></asp:dropdownlist></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <asp:literal ID="ltrSwapOnLoad" runat="server"></asp:literal>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Phone&nbsp;Number:</td>
                                        <td><cc1:InputMask cssclass="entry" ID="txtPhoneNumber" runat="server" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        <td><a href="#" onclick="AddressBook();return false;"><img runat="server" src="~/images/16x16_addressbook.png" border="0" align="absmiddle" /></a></td>
                                    </tr>
                                    <tr id="TrPhoneStatus" runat="server" visible="false">
                                        <td class="entrytitlecell" nowrap="true">Phonecall Status:</td>
                                        <td id="td1" runat="server"><asp:dropdownlist cssclass="entry" runat="server" OnSelectedIndexChanged="cboPhoneCallEntry_SelectedIndexChanged" AutoPostBack="true" id="cboPhoneCallEntry"></asp:dropdownlist></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                </table>
                            </td>
                            <td><img height="1" width="30" runat="server" src="~/images/spacer.gif" /></td>
                            <td style="width:50%;" valign="top">
                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                    cellspacing="0">
                                    <tr>
                                        <td style="background-color: #f1f1f1;" colspan="2">Duration</td>
                                    </tr>
                                    <tr>
                                        <td style="width:50;">Started:</td>
                                        <td nowrap="true">
                                            <cc1:InputMask cssclass="entry" ID="txtStarted" runat="server" Mask="nn/nn/nnnn nn:nn:nn aa" style="width:130;"></cc1:InputMask>&nbsp;&nbsp;<a id="aStartedNow" class="lnk" href="javascript:SetToNow('txtStarted')">Set to Now</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:50;">
                                            Ended:
                                        </td>
                                        <td nowrap="true">
                                            <cc1:InputMask cssclass="entry" ID="txtEnded" runat="server" Mask="nn/nn/nnnn nn:nn:nn aa" style="width:130;"></cc1:InputMask>&nbsp;&nbsp;<a id="aEndedNow" class="lnk" href="javascript:SetToNow('txtEnded')">Set to Now</a>
                                        </td>
                                    </tr>
                       <td align="left" style="background-color: #f1f1f1;" colspan="2">Reason for Call:</td>
                      <tr>
                            <td align="left" colspan="5">
                                <asp:CheckBox ID="ckReason1" Text="Creditor Calls"  TextAlign="Right" runat="server" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:CheckBox ID="ckReason6" Text="Add/Remove Creditor" TextAlign="Right" runat="server" />
                            </td>
                            </td>
                      </tr>
                      <tr>
                            <td align="left" colspan="3">
                                <asp:CheckBox ID="ckReason2" Text="Being Sued" TextAlign="Right" runat="server" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:CheckBox ID="ckReason7" Text="What To Do With Creditor Letters and Statements" TextAlign="Right" runat="server" />
                             </td>
                      </tr>
                      <tr>
                             <td align="left" colspan="3">
                                <asp:CheckBox ID="ckReason3" Text="Change Deposit" TextAlign="Right" runat="server" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:CheckBox ID="ckReason8" Text="Cancelling" TextAlign="Right" runat="server" />
                             </td>
                       </tr>
                       <tr>
                             <td align="left" colspan="3">
                                <asp:CheckBox ID="ckReason4" Text="Explaination of Services" TextAlign="Right" runat="server" />
                                &nbsp; 
                                <asp:CheckBox ID="ckReason9" Text="Explain Statements" TextAlign="Right" runat="server" />
                             </td>
                       </tr>
                       <tr>
                             <td align="left" colspan="3">
                                <asp:CheckBox ID="ckReason5" Text="Negotiation Status" TextAlign="Right" runat="server" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:CheckBox ID="ckReason10" Text="How Much Longer" TextAlign="Right" runat="server" />
                             </td>
                       </tr>
                       <tr>
                             <td align="left" colspan="3">
                                <asp:CheckBox ID="ckReason12" Text="Settlement Offer" TextAlign="Right" runat="server" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:CheckBox ID="ckReason11" Text="Other" TextAlign="Right" runat="server" />
                             </td>
                       </tr>
<%--                       <tr>
                            <td align="left">
                                <asp:Label ID="lblOther" Text="Other:" runat="server" />
                                &nbsp;
                                <asp:TextBox ID="txtOther" runat="server" Width="220" MaxLength="250" Visible="false" />
                            </td>
                       </tr>--%>
                        </tr>
                        </table>
                        <tr>
                            <td class="entrytitlecell" colspan="3" style="width:100%;">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="background-color:#f1f1f1;">Phone Call</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class="entrytitlecell" style="width:100;">Subject:</td>
                                                    <td><asp:TextBox CssClass="entry" runat="server" id="txtSubject"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><asp:textbox cssclass="entry" runat="server" id="txtMessage" rows="7" TextMode="MultiLine" MaxLength="5000" columns="50" style="width:100%;"></asp:textbox></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="trRelations" runat="server" >
                            <td class="entrytitlecell" colspan="3" style="width:100%;padding-top:10px">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0" >
                                    <tr>
                                        <td style="background-color:#f1f1f1;">Related To</td>
                                        <td style="background-color:#f1f1f1;" align="right">
                                            <a class="lnk" href="javascript:AddRelation();">Add Relation</a>&nbsp;|&nbsp;<a class="lnk" id="lnkDeleteConfirmRelation" disabled="true" runat="server" href="#" onmouseup="javascript:Record_DeleteConfirmRelation(this);">Delete</a>
                                        </td>
                                    </tr>
                                    <tr >
                                        <td colspan="2">
                                            <table onmouseover="Grid_RowHover(this, true)" onmouseout="Grid_RowHover(this,false)" class="list" style="font-family:tahoma;font-size:11px;width:100%;" cellspacing="0" cellpadding="3">
                                                <colgroup>
                                                    <col align="center" style="width:20px" />
                                                    <col align="center"/>
                                                    <col align="left" style="width:30%"/>
                                                    <col align="left" style="width:70%"/>
                                                </colgroup>
                                                <thead>
                                                    <tr>
                                                        <td align="center" style="width:20;" class="headItem"><img id="Img1" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img id="Img5" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
                                                        <th style="width: 25;" align="center">
                                                            <img id="Img2" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                        </th>
                                                        <th>Relation Type</th>
                                                        <th>Relation</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <asp:repeater runat="server" id="rpRelations">
                                                    <itemtemplate>
                                                        <a href="<%#ResolveURL(ctype(DataBinder.Eval(Container.DataItem, "NavigateURL"),string).replace("$clientid$",ClientID).replace("$x$",DataBinder.Eval(Container.DataItem, "RelationID")))  %>"
                                                        <tr>
                                                            <td style="width:20;" align="center"><img id="Img6" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img7" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#DataBinder.Eval(Container.DataItem, "PhoneCallRelationID") %>);" style="display:none;" type="checkbox" /></td>
                                                            <td ><img src="<%#ResolveURL(DataBinder.Eval(Container.DataItem, "IconURL"))%>" border="0"/></td>
                                                            <td>
                                                                <%#DataBinder.Eval(Container.DataItem, "RelationTypeName") %>
                                                            </td>
                                                            <td>
                                                                <%#DataBinder.Eval(Container.DataItem, "RelationName") %>
                                                            </td>
                                                        </tr>
                                                        </a>
                                                    </itemtemplate>
                                                </asp:repeater>
                                                </tbody>
                                            </table><input type="hidden" runat="server" id="txtSelectedIDs"/><input type="hidden" value="<%= lnkDeleteConfirmRelation.ClientId%>"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="height:25px;">
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="entrytitlecell" colspan="3" style="width:100%;padding-top:10px">
                                <table id="tblDocuments" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0" runat="server">
                                    <tr>
                                        <td style="background-color:#f1f1f1;">Document</td>
                                        <td style="background-color:#f1f1f1;" align="right">
                                            <a class="lnk" href="javascript:AttachDocument();">Attach Document</a>&nbsp;|&nbsp;<a class="lnk" id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:DeleteDocument();">Delete</a>
                                        </td>
                                    </tr>
                                    <tr id="tr2" runat="server">
                                        <td colspan="2">
                                            <table onmouseover="RowHover(this, true)" onmouseout="RowHover(this,false)" class="list" style="font-family:tahoma;font-size:11px;width:100%;" cellspacing="0" cellpadding="3">
                                                <thead>
                                                    <tr>
                                                        <th style="width:20px;" align="center">
                                                            <img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                        </th>
                                                        <th style="width:11px;">&nbsp;</th>
                                                        <th align="left" style="width:40%;">Document Name</th>
                                                        <th align="left" style="width:100px;display:none;">Origin</th>
                                                        <th align="left">Received</th>
                                                        <th align="left">Created</th>
                                                        <th align="left">Created By</th>
                                                        <th style="width:20px;" align="right"></th>
                                                        <th align="right" style="width:10px;">&nbsp;</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:repeater runat="server" id="rpDocuments">
                                                        <itemtemplate>
                                                            <a href="#" onclick="javascript:RowClick(this.childNodes(0), <%#CType(Container.DataItem.DocRelationID, Integer) %>);">
                                                                <tr>
                                                                    <td style="width:20px;" align="center">
                                                                        <img id="Img2" runat="server" src="~/images/16x16_file_new.png" border="0" align="absmiddle" />
                                                                    </td>
                                                                    <td style="width:11px;">&nbsp;</td>
                                                                    <td align="left" style="width:40%;">
                                                                        <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String).Replace("\", "\\") %>');">
                                                                            <%#CType(Container.DataItem.DocumentType, String) %>&nbsp;
                                                                        </a>
                                                                    </td>
                                                                    <td align="left" style="width:100px;display:none;">
                                                                        <%#CType(Container.DataItem.Origin, String) %>&nbsp;
                                                                    </td>
                                                                    <td align="left">
                                                                        <%#CType(Container.DataItem.Received, String) %>&nbsp;
                                                                    </td>
                                                                    <td align="left">
                                                                        <%#CType(Container.DataItem.Created, String) %>&nbsp;
                                                                    </td>
                                                                    <td align="left">
                                                                        <%#CType(Container.DataItem.CreatedBy, String) %>&nbsp;
                                                                    </td>
                                                                    <td style="width:20px;" align="right">
                                                                        <%#IIf(Not CType(Container.DataItem.Existence, Boolean), "<img src=""" + ResolveUrl("~/images/16x16_no_file.png") + """ border=""0"" align=""absmiddle"" />", "&nbsp;") %>
                                                                    </td>
                                                                    <td align="right" style="width:10px;">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                            </a>
                                                        </itemtemplate>
                                                    </asp:repeater>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        </asp:placeholder>
                        <asp:placeholder runat="server" id="bodReadOnly">
                        <tr>
                            <td style="width:50%;" valign="top">
                                <table style="font-family:tahoma;font-size:11px;width: 100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="background-color: #f1f1f1;" colspan="3">Details</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Direction:</td>
                                        <td nowrap="nowrap" id="ro_tdDirection" runat="server"></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Sender:</td>
                                        <td><asp:label cssclass="entry" runat="server" id="ro_cboInternal"></asp:label></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Recipient:</td>
                                        <td><asp:label cssclass="entry" runat="server" id="ro_cboExternal"></asp:label></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Phone&nbsp;Number:</td>
                                        <td><asp:label cssclass="entry" ID="ro_txtPhoneNumber" runat="server" Mask="(nnn) nnn-nnnn"></asp:label></td>
                                    </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                </table>
                            </td>
                            <td><img height="1" width="30" runat="server" src="~/images/spacer.gif" /></td>
                            <td style="width:50%;" valign="top">
                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                    cellspacing="0">
                                    <tr>
                                        <td style="background-color: #f1f1f1;" colspan="2">Duration</td>
                                    </tr>
                                    <tr>
                                        <td style="width:50;">Started:</td>
                                        <td nowrap="true">
                                            <asp:label cssclass="entry" ID="ro_txtStarted" runat="server" Mask="nn/nn/nnnn nn:nn:nn aa" style="width:130;"></asp:label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:50;">
                                            Ended:
                                        </td>
                                        <td nowrap="true">
                                            <asp:label cssclass="entry" ID="ro_txtEnded" runat="server" Mask="nn/nn/nnnn nn:nn:nn aa" style="width:130;"></asp:label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="entrytitlecell" colspan="3" style="width:100%;">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="background-color:#f1f1f1;">Phone Call</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class="entrytitlecell" style="width:100;">Subject:</td>
                                                    <td><asp:label CssClass="entry" runat="server" id="ro_txtSubject"></asp:label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        </asp:placeholder>
                    </table>
                </td>
            </tr>
            <tr><td></td></tr>
        </table>
        
        <input id="hdnCurrentDoc" type="hidden" runat="server" />
        <input id="hdnTempPhoneCallID" type="hidden" runat="server" />
        <input id="hdnCaller" type="hidden" runat="server" />
        
        <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
        <asp:LinkButton runat="server" id="lnkCancelAndClose" />
        <asp:LinkButton runat="server" id="lnkSave" />
        <asp:LinkButton runat="server" id="lnkDelete" />
        <asp:LinkButton runat="server" id="lnkDeleteRelation" />
        <asp:LinkButton runat="server" id="lnkSetAsPrimary" />
        <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
        <asp:LinkButton ID="lnkShowDocs" runat="server" />
        <uc2:ScanningControl ID="ScanningControl1" runat="server" />
    </body>
</asp:placeholder></asp:Content>