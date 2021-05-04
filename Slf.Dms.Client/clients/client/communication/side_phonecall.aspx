<%@ Page Language="VB" AutoEventWireup="false" CodeFile="side_phonecall.aspx.vb" Inherits="clients_client_communication_side_phonecall" title="DMP - Phone Call" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DMP - Phone Calls</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
</head>
<body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;"  onload="SetFocus('<%= rbIncoming.ClientID %>');" >
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <form id="form1" runat="server">  
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
        function RedirectTop(s)
        {
            self.top.location=s;
        }
        function Record_Save()
        {
            if (Record_RequiredExist())
            {
                // postback to save
                <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;        
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
	    function AddressBook()
        {
             var url = '<%= ResolveUrl("~/util/pop/addressbookcompact.aspx?id=" & DataClientID) %>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Address Book",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 450, width: 250});
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
        </script>
        
        <script type="text/javascript" language="javascript">
        var attachWin;
        var scanWin;

        var intAttachWin;
        var intScanWin;
        
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
        function DeleteDocument()
        {
            if (document.getElementById('<%=hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
            }
        }
        function AttachDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = <%=PhoneCallID %>;
            var relType = <%=RelationTypeID %>;
            var addRelID = <%=RelationID %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempPhoneCallID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=DataClientID %>&type=phonecall&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
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
        function OpenScanning()
        {
            var relID = <%=PhoneCallID %>;
            var relType = <%=RelationTypeID %>;
            var addRelID = <%=RelationID %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempPhoneCallID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            try{
                self.top.frames[0].ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=DataClientID %>&context=<%=ContextSensitive %>&type=note&rel=' + relID);
            }
            catch(e){
                if(window.parent.parent != null)  
                    {
                       var val = window.parent.parent.ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=DataClientID %>&context=<%=ContextSensitive %>&type=note&rel=' + relID);
                    }
            }            

        }
        function WaitScanned()
        {
            if (scanWin.closed)
            {
                clearInterval(intScanWin);
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
    </script>

        <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="background-color:rgb(244,242,232);" >
                    <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                            <td style="width:100%;">
                                <table class="grid" style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td nowrap="true">
                                            <asp:LinkButton ID="lnkSave" runat="server" class="gridButton">
                                                <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />
                                                Save and Close
                                            </asp:LinkButton>
                                        </td>
                                        <td nowrap="true" style="width:100%;height:25">&nbsp;</td>
                                        <td nowrap="true">
                                             <asp:LinkButton ID="lnkCancel" runat="server" class="gridButton">
                                                <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_cancel.png" />
                                                Cancel
                                            </asp:LinkButton>
                                        </td>
                                        <td nowrap="true" style="width:10;">&nbsp;</td>
                                     </tr>
                                </table>
                            </td>
                        </tr>
                        
                    </table>
                </td>
            </tr>
            <tr id="trInfoBox" runat="server" >
                <td style="padding:5px">
                    <div class="iboxDiv">
                        <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                            <tr>
                                <td valign="top" style="width:16;"><img id="Img2" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                <td>
                                    <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="iboxHeaderCell"><asp:Literal id="ltrNew" runat="server"></asp:Literal>Phone Call for <b><%=RelationTypeName %></b>&nbsp;<%=EntityName %></td>
                                        </tr>
                                        
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr >
                            <td colspan="3">
                                <div runat="server" id="dvError" style="display:none;">
                                    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					                    <tr>
						                    <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
						                    <td runat="server" id="tdError"></td>
					                    </tr>
				                    </table>&nbsp;
				                </div>
                            </td>
                        </tr>
                        <tr style="padding-left:5px;padding-right:5px">
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
                                        <td id="tdRecipientHolder" runat="server"><asp:dropdownlist cssclass="entry" runat="server" id="cboExternal"></asp:dropdownlist></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <asp:literal ID="ltrSwapOnLoad" runat="server"></asp:literal>
                                    <tr>
                                        <td class="entrytitlecell" nowrap="true">Phone&nbsp;Number:</td>
                                        <td><cc1:InputMask cssclass="entry" ID="txtPhoneNumber" runat="server" Mask="(nnn) nnn-nnnn"></cc1:InputMask></td>
                                        <td><a href="#" onclick="AddressBook();return false;"><img id="Img4" runat="server" src="~/images/16x16_addressbook.png" border="0" align="absmiddle" /></a></td>
                                    </tr>
                                    <tr><td colspan="2" style="font-size:1px">&nbsp;</td></tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="padding-left:5px;padding-right:5px">
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
                                    <tr><td colspan="2" style="font-size:1px">&nbsp;</td></tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="padding-left:5px;padding-right:5px">
                            <td class="entrytitlecell" colspan="3" style="width:100%;">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="background-color:#f1f1f1;">Phone Call</td>
                                    </tr>
                                    <tr>
                                        <td >
                                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class="entrytitlecell" style="width:100;">Subject:&nbsp;&nbsp;</td>
                                                    <td style="width:100%"><asp:TextBox CssClass="entry" runat="server" id="txtSubject"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><asp:textbox cssclass="entry" runat="server" id="txtMessage" rows="20" TextMode="MultiLine" MaxLength="5000" columns="50" style="width:100%;"></asp:textbox></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="entrytitlecell" colspan="3" style="width:100%;padding-top:10px">
                    <table id="tblDocuments" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0" runat="server">
                        <tr>
                            <td style="background-color:#f1f1f1;">Document</td>
                            <td style="background-color:#f1f1f1;" align="right">
                                <a class="lnk" href="javascript:OpenScanning();">Scan Document</a>&nbsp;|&nbsp;<a class="lnk" href="javascript:AttachDocument();">Attach</a>&nbsp;|&nbsp;<a class="lnk" id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:DeleteDocument();">Delete</a>
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
                                            <th align="left" style="width:90%;">Document Name</th>
                                            <th align="right">Created</th>
                                            <th align="right" style="width:5px;">&nbsp;</th>
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
                                                        <td align="left" style="width:90%;">
                                                            <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String).Replace("\", "\\") %>');">
                                                                <%#CType(Container.DataItem.DocumentType, String) %>&nbsp;
                                                            </a>
                                                        </td>
                                                        <td align="right">
                                                            <%#CType(Container.DataItem.Created, String) %>&nbsp;
                                                        </td>
                                                        <td align="right" style="width:5px;">
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
            <tr style="height:100%;">
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
        
        <input id="hdnCurrentDoc" type="hidden" runat="server" />
        <input id="hdnTempPhoneCallID" type="hidden" runat="server" />
        
        <asp:LinkButton ID="lnkShowDocs" runat="server" />
        <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    </form>
</body>
</html>