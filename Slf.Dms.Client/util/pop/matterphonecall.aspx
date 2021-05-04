<%@ Page Language="VB" AutoEventWireup="false" CodeFile="matterphonecall.aspx.vb"
    Inherits="util_pop_matterphonecall" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Phone Call</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <style type="text/css">
        .entry
        {
            font-family: tahoma;
            font-size: 11px;
            width: 100%;
        }
        .entrycell
        {
        }
        .entrytitlecell
        {
            width: 90;
        }
    </style>

    <script type="text/javascript">
    window.baseurl = "<%= ResolveUrl("~/")%>";
    
    if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    
    function LoadPropagations()
    {
        var value = window.parent.dialogArguments.GetPhoneNote();
       
        if (value.length > 0)
        {
            var Fields = value.split("|");
            
            var cboInternal = document.getElementById("<%= cboInternal.ClientID %>");   
            var rbOutgoing = document.getElementById("<%= rbOutgoing.ClientID %>");
            var cboExternal = document.getElementById("<%= cboExternal.ClientID %>");   
            var rbIncoming = document.getElementById("<%= rbIncoming.ClientID %>"); 
            var cboPhoneCallEntry = document.getElementById("<%= cboPhoneCallEntry.ClientID %>");    
            var txtMessage = document.getElementById("<%= txtMessage.ClientID %>");   
            var txtSubject = document.getElementById("<%= txtSubject.ClientID %>");   
            var txtPhoneNumber = document.getElementById("<%= txtPhoneNumber.ClientID %>");   
            var txtStarted = document.getElementById("<%= txtStarted.ClientID %>");   
            var txtEnded = document.getElementById("<%= txtEnded.ClientID %>");  
            if (Fields[0]=="true")
            {
                rbOutgoing.checked=true; 
            }
            else
            {
                rbOutgoing.checked=false; 
            }
            if (Fields[1]=="true")
            {
                rbIncoming.checked=true;      
            }
            else
            {
                rbIncoming.checked=false;      
            }
            cboInternal.value=Fields[2];
            cboExternal.value=Fields[3];
            cboPhoneCallEntry.value = Fields[4];
            txtMessage.value = Fields[5];
            txtSubject.value = Fields[6];
            txtPhoneNumber.value = Fields[7];
            txtStarted.value = Fields[8];
            txtEnded.value = Fields[9];
    
        }
    }
    
    function CloseMatterPhone()
    {
        if (window.parent.currentModalDialog) {
           window.parent.currentModalDialog.modaldialog("returnValue", -1); 
        } else {
            window.returnValue ="-1";
        }
        window.close();  
        
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
                   height: 350, width: 550});
    }
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
    function SavePhoneCall()
    {
        if (Record_RequiredExist())
        {
            ResetPropagations();

            var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");
            window.parent.dialogArguments.SavePhoneNote(txtPropagations.value);
            window.close();
        }
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
    
        // Phone Status
        var cboPhoneCallEntry = document.getElementById("<%= cboPhoneCallEntry.ClientID %>");
        if (cboPhoneCallEntry.value <= 0)
        {
            ShowMessage("You must select the phone status.");
	        AddBorder(cboPhoneCallEntry);
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
    
    function ResetPropagations()
    {
        var cboInternal = document.getElementById("<%= cboInternal.ClientID %>");   
        var rbOutgoing = document.getElementById("<%= rbOutgoing.ClientID %>");
        var cboExternal = document.getElementById("<%= cboExternal.ClientID %>");   
        var rbIncoming = document.getElementById("<%= rbIncoming.ClientID %>"); 
        var cboPhoneCallEntry = document.getElementById("<%= cboPhoneCallEntry.ClientID %>");    
        var txtMessage = document.getElementById("<%= txtMessage.ClientID %>");   
        var txtSubject = document.getElementById("<%= txtSubject.ClientID %>");   
        var txtPhoneNumber = document.getElementById("<%= txtPhoneNumber.ClientID %>");   
        var txtStarted = document.getElementById("<%= txtStarted.ClientID %>");   
        var txtEnded = document.getElementById("<%= txtEnded.ClientID %>"); 
        
        var txtPropagations = document.getElementById("<%= txtPropagations.ClientID %>");

        txtPropagations.value = "";
        
        txtPropagations.value += rbOutgoing.checked + "|" + rbIncoming.checked + "|" + cboInternal.value + "|" + cboExternal.value + "|" + cboPhoneCallEntry.value + "|" + txtMessage.value + "|" + txtSubject.value + "|" + txtPhoneNumber.value + "|" + txtStarted.value + "|" + txtEnded.value
        
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
        ConfirmationModalDialog({window: window, 
                                 title: "Delete Relations", 
                                 callback: "Record_DeleteRelation", 
                                 message: "Are you sure you want to delete this selection of relations?"});
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

        function RowHover(tbl, over) {
            var obj = event.srcElement;

            if (obj.tagName == "IMG")
                obj = obj.parentElement;

            if (obj.tagName == "TD") {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null) {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over) {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#f4f4f4";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        function RowClick(tr, docRelID) {
            //unselect last row
            var tbl = tr.parentElement.parentElement;
            if (tbl.lastSelTr != null) {
                tbl.lastSelTr.coldColor = "#ffffff";
                tbl.lastSelTr.style.backgroundColor = "#ffffff";
            }

            //select this row
            tr.coldColor = "#ededed";
            tr.style.backgroundColor = "#f0f0f0";

            document.getElementById('<%=hdnCurrentDoc.ClientID %>').value = docRelID;

            //set this as last
            tbl.lastSelTr = tr;
        }
        
      
        
    </script>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>

</head>
<body  onload="LoadPropagations();">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <form id="form1" runat="server">
    <table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0"
        runat="server" id="tblBody">
        <tr>
            <td>
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                        width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                            </td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top" style="padding-left: 10; height: 100%;">
                <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0"
                    cellpadding="0" cellspacing="15">
                    <tr>
                        <td class="cLEnrollHeader" height="20">
                            Add Phone Call
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <asp:PlaceHolder runat="server" ID="bodMain">
                                    <tr>
                                        <td style="width: 50%;" valign="top">
                                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                                cellspacing="0">
                                                <tr>
                                                    <td style="background-color: #f1f1f1;" colspan="3">
                                                        Details
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Direction:
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <input type="radio" name="rbDirection" id="rbIncoming" runat="server" onclick="javascript:SwitchDirection('Incoming');" /><label
                                                            for="<%= rbIncoming.ClientID %>">Incoming</label>&nbsp;&nbsp;&nbsp;<input type="radio"
                                                                name="rbDirection" id="rbOutgoing" runat="server" onclick="javascript:SwitchDirection('Outgoing');"
                                                                checked="true" /><label for="<%= rbOutgoing.ClientID %>">Outgoing</label>
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Sender:
                                                    </td>
                                                    <td id="tdSenderHolder" runat="server">
                                                        <asp:DropDownList CssClass="entry" runat="server" ID="cboInternal">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Recipient:
                                                    </td>
                                                    <td id="tdRecipientHolder" runat="server">
                                                        <asp:DropDownList CssClass="entry" runat="server" ID="cboExternal">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <asp:Literal ID="ltrSwapOnLoad" runat="server"></asp:Literal>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Phone&nbsp;Number:
                                                    </td>
                                                    <td>
                                                        <cc1:InputMask CssClass="entry" ID="txtPhoneNumber" runat="server" Mask="(nnn) nnn-nnnn"></cc1:InputMask>
                                                    </td>
                                                    <td>
                                                        <a href="#" onclick="AddressBook();return false;">
                                                            <img id="Img5" runat="server" src="~/images/16x16_addressbook.png" border="0" align="absmiddle" /></a>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="entrytitlecell" nowrap="true">
                                                        Phonecall Status:
                                                    </td>
                                                    <td id="td1" runat="server">
                                                        <asp:DropDownList CssClass="entry" runat="server" OnSelectedIndexChanged="cboPhoneCallEntry_SelectedIndexChanged"
                                                            AutoPostBack="true" ID="cboPhoneCallEntry">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <img id="Img6" height="1" width="30" runat="server" src="~/images/spacer.gif" />
                                        </td>
                                        <td style="width: 50%;" valign="top">
                                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                                cellspacing="0">
                                                <tr>
                                                    <td style="background-color: #f1f1f1;" colspan="2">
                                                        Duration
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Started:
                                                    </td>
                                                    <td nowrap="true">
                                                        <cc1:InputMask CssClass="entry" ID="txtStarted" runat="server" Mask="nn/nn/nnnn nn:nn:nn aa"
                                                            Width="150px"></cc1:InputMask>&nbsp;&nbsp;<a id="aStartedNow" class="lnk" href="javascript:SetToNow('txtStarted')">Set
                                                                to Now</a>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 50;">
                                                        Ended:
                                                    </td>
                                                    <td nowrap="true">
                                                        <cc1:InputMask CssClass="entry" ID="txtEnded" runat="server" Mask="nn/nn/nnnn nn:nn:nn aa"
                                                            Width="150px"></cc1:InputMask>&nbsp;&nbsp;<a id="aEndedNow" class="lnk" href="javascript:SetToNow('txtEnded')">Set
                                                                to Now</a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell" colspan="3" style="width: 100%;">
                                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                                cellspacing="0">
                                                <tr>
                                                    <td style="background-color: #f1f1f1;">
                                                        Phone Call
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                                            cellspacing="0">
                                                            <tr>
                                                                <td class="entrytitlecell" style="width: 15;">
                                                                    Subject:
                                                                </td>
                                                                <td align="left">
                                                                    <asp:TextBox CssClass="entry" runat="server" Width="400px" ID="txtSubject"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:TextBox CssClass="entry" runat="server" ID="txtMessage" Rows="7" TextMode="MultiLine"
                                                            MaxLength="1000" Columns="50" Style="width: 100%;"></asp:TextBox>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </asp:PlaceHolder>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 40px; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                padding-right: 10px;">
                <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <a tabindex="3" style="color: black" class="lnk" href="javascript:window.close();">
                                <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                    border="0" align="absmiddle" />Cancel and Close</a>
                        </td>
                        <td align="right">
                            <a tabindex="4" style="color: black" class="lnk" href="#" onclick="javascript:return SavePhoneCall();">
                                Save Phone Call
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="absmiddle" /></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <input id="hdnCurrentDoc" type="hidden" runat="server" />
    <input id="hdnTempPhoneCallID" type="hidden" runat="server" />
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
    <asp:LinkButton runat="server" ID="LinkButton1" />
    <asp:LinkButton runat="server" ID="lnkDelete" />
    <asp:LinkButton runat="server" ID="lnkDeleteRelation" />
    <asp:LinkButton runat="server" ID="lnkSetAsPrimary" />
    <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    <asp:LinkButton ID="lnkShowDocs" runat="server" />
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <input runat="server" id="txtPropagations" type="hidden" />
    </form>
</body>
</html>
