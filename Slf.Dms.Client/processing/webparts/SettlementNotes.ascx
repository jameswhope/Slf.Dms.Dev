<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlementNotes.ascx.vb"
    Inherits="processing_webparts_SettlementNotes" %>
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
            var url = '<%= ResolveUrl("~/util/pop/addressbook.aspx?id="  & DataClientID) %>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Address Book",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 450, width: 550});
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
       
</script>

<asp:UpdatePanel ID="upDefault" runat="server">
    <ContentTemplate>
        <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
        <asp:Panel ID="pnlComms" runat="server" Style="display: block;" Width="100%">
            <table width="100%" cellpadding="0" cellspacing="0" class="entryFormat">
                <tr style="vertical-align: top; background-color:#F3F3F3;">
                    <td class="entry2" style="padding-left:15px;padding-top:5px;" >
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkAddNote, Nothing) %>;" class="lnk">
                            <img id="Img1" runat="server" border="0" src="~/images/16x16_note_add.png" align="absmiddle" alt="" /> Add
                            Note </a>
                            &nbsp;&nbsp;
                        <asp:LinkButton ID="lnkAddNote" runat="server" />
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkAddCall, Nothing) %>;" class="lnk">
                            <img id="Img2" runat="server" border="0" src="~/images/16x16_phone_add.png" align="absmiddle" alt="" /> Add
                            Call </a>
                        <asp:LinkButton ID="lnkAddCall" runat="server" />
                    </td>
                    <td align="right" style="padding-right:15px;padding-top:5px;">
                        <asp:RadioButtonList ID="radCommType" runat="server" AutoPostBack="true"
                            RepeatDirection="Horizontal" CssClass="entryFormat" >
                            <asp:ListItem Selected="true" Text="All Comms" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Comms specific to " Value="1"></asp:ListItem>
                            <asp:ListItem Text="Comms specific to " Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="overflow: auto; width: 100%; height: 350px;">
                            <asp:GridView ID="gvNotes" runat="server" AllowPaging="False" AllowSorting="True"
                                AutoGenerateColumns="False" CellPadding="4" DataKeyNames="fieldid,Type"
                                GridLines="None" PageSize="4" Width="100%" >
                                <EmptyDataTemplate>
                                    No Notes Available.
                                </EmptyDataTemplate>
                                <Columns>
                                    <asp:TemplateField SortExpression="OfferDirection">
                                        <HeaderTemplate>
                                            <asp:Image runat="server" ImageUrl="~/images/16x16_icon.png" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Image ID="imgDir" runat="server" />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="center" CssClass="headitem5" Font-Names="Tahoma" Font-Size="11px" ForeColor="Black" />
                                        <ItemStyle HorizontalAlign="center" CssClass="listItem" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date" HtmlEncode="false" DataFormatString="{0:MMM, dd yy}">
                                        <HeaderStyle HorizontalAlign="left" CssClass="headitem5" Font-Names="Tahoma" Font-Size="11px" ForeColor="Black" />
                                        <ItemStyle HorizontalAlign="left"  CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            By
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("By")%><br />
                                            <%#Eval("Usergroup")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="left" CssClass="headitem5" Font-Names="Tahoma" Font-Size="11px" ForeColor="Black" />
                                        <ItemStyle HorizontalAlign="left" CssClass="listItem" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderStyle-HorizontalAlign="left" HeaderText="Message" ItemStyle-HorizontalAlign="left"
                                        SortExpression="Note">
                                        <ItemTemplate>
                                            <asp:Label ID="noteSubject" runat="server" Font-Bold="true" CssClass="entryFormat"></asp:Label>
                                            <asp:Label ID="noteText" runat="server" CssClass="entryFormat"></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="left" CssClass="headitem5" Font-Names="Tahoma" Font-Size="11px" ForeColor="Black" />
                                        <ItemStyle HorizontalAlign="left" Wrap="true" CssClass="listItem" />
                                    </asp:TemplateField>
                                </Columns>
                                <PagerTemplate>
                                    <table style="background-color: Silver; width: 100%;" class="entry">
                                        <tr style="vertical-align: middle; height: 25px;">
                                            <td align="right">
                                                <asp:Label ID="Label1" runat="server" Text="Go to Page "></asp:Label>
                                                <asp:DropDownList ID="ddlPage" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged"
                                                    Style="height: 18px; font-size: 8pt;">
                                                </asp:DropDownList>
                                                of
                                                <asp:Label ID="lblTotalPages" runat="server" Text=""></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </PagerTemplate>
                                <PagerSettings Mode="NumericFirstLast" PageButtonCount="20" Position="Bottom" />
                            </asp:GridView>
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlNote" runat="server" Style="display: none;" >
            <table id="tblBody" runat="server" border="0" cellpadding="0" cellspacing="0" class="entry" >
                <tr>
                    <td style="padding:5px">
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;" class="lnk">
                            <img id="Img3" runat="server" border="0" src="~/images/16x16_save.png" align="absmiddle" alt="" /> Save</a>
                        <asp:LinkButton ID="lnkSave" runat="server">
                        </asp:LinkButton>
                        &nbsp;|&nbsp;
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;" class="lnk">
                            <img id="Img4" runat="server" border="0" src="~/images/16x16_cancel.png" align="absmiddle" alt="" /> Cancel</a>
                        <asp:LinkButton ID="lnkCancel" runat="server">
                        </asp:LinkButton>
                    </td>
                </tr>
                <tr id="trInfoBox">
                    <td class="iboxHeaderCell">
                        <div class="iboxDiv">
                            <table border="0" cellpadding="7" cellspacing="0" class="iboxTable">
                                <tr>
                                    <td style="width: 16;" valign="top">
                                        <img id="imgNote" runat="server" border="0" src="~/images/16x16_note3.png" />
                                    </td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" class="iboxTable2">
                                            <tr>
                                                <td class="iboxHeaderCell">
                                                    <asp:Literal ID="ltrNew" runat="server"></asp:Literal>Note for <b>
                                                        <%=RelationTypeName %>
                                                    </b>&nbsp;<%=EntityName %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td colspan="3">
                                    <div id="dvError" runat="server" style="display: none;">
                                        <table border="0" cellpadding="0" cellspacing="10" style="border-right: #969696 1px solid;
                                            border-top: #969696 1px solid; font-size: 11px; border-left: #969696 1px solid;
                                            color: red; border-bottom: #969696 1px solid; font-family: Tahoma; background-color: #ffffda"
                                            width="100%">
                                            <tr>
                                                <td style="width: 20;" valign="top">
                                                    <img id="Img5" runat="server" align="absmiddle" border="0" src="~/images/message.png">
                                                </td>
                                                <td id="tdError" runat="server">
                                                </td>
                                            </tr>
                                        </table>
                                        &nbsp;
                                    </div>
                                </td>
                            </tr>
                            <tr style="padding-left: 5px; padding-right: 5px">
                                <td style="width: 100%;" valign="top">
                                    <table border="0" cellpadding="5" cellspacing="0" style="font-family: tahoma; font-size: 11px;">
                                        <tr>
                                            <td colspan="2" style="background-color: #f1f1f1; text-align: left;">
                                                Details
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="entrytitlecell">
                                                Created by:
                                            </td>
                                            <td style="text-align: left;">
                                                <asp:Label ID="txtCreatedBy" runat="server" CssClass="entry2"></asp:Label>
                                                on
                                                <asp:Label ID="txtCreatedDate" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="entrytitlecell">
                                                Last Modified by:
                                            </td>
                                            <td style="text-align: left;">
                                                <asp:Label ID="txtLastModifiedBy" runat="server" CssClass="entry2"></asp:Label>
                                                on
                                                <asp:Label ID="txtLastModifiedDate" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr id="trMessage" runat="server">
                                            <td class="entrytitlecell" colspan="3" style="width: 100%; text-align: left;">
                                                Message:<br />
                                                <div style="padding-top: 5px">
                                                    <asp:TextBox ID="txtMessage" runat="server" Height="75px" MaxLength="1000" Rows="20"
                                                        TabIndex="3" TextMode="MultiLine" Width="98%" CssClass="entry2" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlCall" runat="server" Style="display: none;" Width="100%">
            <table id="Table2" runat="server" border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma;
                font-size: 11px; width: 100%; height: 100%;">
                <tr>
                    <td style="text-align: left; background-color: rgb(244,242,232);">
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkSaveCall, Nothing) %>;">
                            <img id="Img6" runat="server" border="0" src="~/images/16x16_save.png" />Save and
                            Close </a>
                        <asp:LinkButton ID="lnkSaveCall" runat="server">
                        </asp:LinkButton>
                    </td>
                    <td style="text-align: right; background-color: rgb(244,242,232);">
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkCancelCall, Nothing) %>;">
                            <img id="Img7" runat="server" border="0" src="~/images/16x16_cancel.png" />Cancel
                        </a>
                        <asp:LinkButton ID="lnkCancelCall" runat="server">
                        </asp:LinkButton>
                    </td>
                </tr>
                <tr id="tr1" runat="server">
                    <td colspan="2" style="padding: 5px">
                        <div class="iboxDiv">
                            <table border="0" cellpadding="7" cellspacing="0" class="iboxTable">
                                <tr>
                                    <td style="width: 16;" valign="top">
                                        <img id="Img8" runat="server" border="0" src="~/images/16x16_note3.png" />
                                    </td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" class="iboxTable2">
                                            <tr>
                                                <td class="iboxHeaderCell">
                                                    <asp:Literal ID="ltrNewCall" runat="server"></asp:Literal>Phone Call for <b>
                                                        <%=RelationTypeName %>
                                                    </b>&nbsp;<%=EntityName %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" valign="top">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td colspan="3">
                                    <div id="Div1" runat="server" style="display: none;">
                                        <table border="0" cellpadding="0" cellspacing="10" style="border-right: #969696 1px solid;
                                            border-top: #969696 1px solid; font-size: 11px; border-left: #969696 1px solid;
                                            color: red; border-bottom: #969696 1px solid; font-family: Tahoma; background-color: #ffffda"
                                            width="100%">
                                            <tr>
                                                <td style="width: 20;" valign="top">
                                                    <img id="Img11" runat="server" align="absmiddle" border="0" src="~/images/16x16_note3.png">
                                                </td>
                                                <td id="td1" runat="server">
                                                </td>
                                            </tr>
                                        </table>
                                        &nbsp;
                                    </div>
                                </td>
                            </tr>
                            <tr style="padding-left: 5px; padding-right: 5px">
                                <td style="width: 50%;" valign="top">
                                    <table border="0" cellpadding="5" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                                        width: 100%;">
                                        <tr>
                                            <td colspan="3">
                                                <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                    <tr style="background-color: #f1f1f1; text-align: center;">
                                                        <td>
                                                            Details
                                                        </td>
                                                        <td>
                                                            Phone Call
                                                        </td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td>
                                                            <table width="100%">
                                                                <tr>
                                                                    <td align="right" class="entrytitlecell" nowrap="nowrap">
                                                                        Direction:
                                                                    </td>
                                                                    <td align="left" nowrap="nowrap">
                                                                        <input id="rbIncoming" runat="server" name="rbDirection" onclick="javascript:SwitchDirection('Incoming');"
                                                                            type="radio" /><label for="<%= rbIncoming.ClientID %>">Incoming</label>&nbsp;&nbsp;&nbsp;<input
                                                                                id="rbOutgoing" runat="server" checked="True" name="rbDirection" onclick="javascript:SwitchDirection('Outgoing');"
                                                                                type="radio" /><label for="<%= rbOutgoing.ClientID %>">Outgoing</label>
                                                                    </td>
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right" class="entrytitlecell" nowrap="nowrap">
                                                                        Sender:
                                                                    </td>
                                                                    <td id="tdSenderHolder" runat="server" align="left">
                                                                        <asp:DropDownList ID="cboInternal" runat="server" Width="150px">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right" class="entrytitlecell" nowrap="nowrap">
                                                                        Recipient:
                                                                    </td>
                                                                    <td id="tdRecipientHolder" runat="server" align="left">
                                                                        <asp:DropDownList ID="cboExternal" runat="server" Width="150px">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <asp:Literal ID="ltrSwapOnLoad" runat="server"></asp:Literal>
                                                                <tr>
                                                                    <td align="right" class="entrytitlecell" nowrap="nowrap">
                                                                        Phone&nbsp;Number:
                                                                    </td>
                                                                    <td align="left">
                                                                        <asp:TextBox ID="txtPhoneNumber" runat="server">
                                                                        </asp:TextBox>
                                                                        <ajaxToolkit:MaskedEditExtender ID="meeNumber" runat="server" ClearMaskOnLostFocus="false"
                                                                            Mask="(999) 999-9999" MaskType="Number" PromptCharacter="#" TargetControlID="txtPhoneNumber">
                                                                        </ajaxToolkit:MaskedEditExtender>
                                                                    </td>
                                                                    <td>
                                                                        <a href="#" onclick="AddressBook();return false;">
                                                                            <img id="Img12" runat="server" align="absmiddle" border="0" src="~/images/16x16_addressbook.png" /></a>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td rowspan="3">
                                                            <table border="0" cellpadding="3" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                                                                width: 100%;">
                                                                <tr>
                                                                    <td align="left" colspan="2">
                                                                        Subject:&nbsp;&nbsp;
                                                                        <asp:TextBox ID="txtSubject" runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <asp:TextBox ID="txtCallMsg" runat="server" Height="100px" MaxLength="1000" Rows="20"
                                                                            TextMode="MultiLine" Width="98%" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="background-color: #f1f1f1; text-align: center;">
                                                            Duration
                                                        </td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="0" cellpadding="1" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                                                                width: 100%; border-collapse: collapse">
                                                                <tr>
                                                                    <td style="text-align: right;">
                                                                        Started:
                                                                    </td>
                                                                    <td align="left" nowrap="nowrap">
                                                                        <asp:TextBox ID="txtStarted" runat="server">
                                                                        </asp:TextBox>
                                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender6" runat="server" AcceptAMPM="True"
                                                                            ErrorTooltipEnabled="True" Mask="99/99/9999 99:99:99" MaskType="DateTime" MessageValidatorTip="true"
                                                                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditError" TargetControlID="txtStarted">
                                                                        </ajaxToolkit:MaskedEditExtender>
                                                                        &nbsp;&nbsp;<asp:LinkButton ID="aStartedNow" runat="server" CssClass="lnk" OnClientClick="javascript:SetToNow('txtStarted')"
                                                                            Text="Set to Now">
                                                                        </asp:LinkButton>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="text-align: right">
                                                                        Ended:
                                                                    </td>
                                                                    <td align="left" nowrap="nowrap">
                                                                        <asp:TextBox ID="txtEnded" runat="server">
                                                                        </asp:TextBox>
                                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" AcceptAMPM="True"
                                                                            ErrorTooltipEnabled="True" Mask="99/99/9999 99:99:99" MaskType="DateTime" MessageValidatorTip="true"
                                                                            OnFocusCssClass="MaskedEditFocus" OnInvalidCssClass="MaskedEditError" TargetControlID="txtEnded">
                                                                        </ajaxToolkit:MaskedEditExtender>
                                                                        &nbsp;&nbsp;<asp:LinkButton ID="aEndedNow" runat="server" CssClass="lnk" OnClientClick="javascript:SetToNow('txtEnded')"
                                                                            Text="Set to Now">
                                                                        </asp:LinkButton>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" style="font-size: 1px">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="font-size: 1px">
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr style="padding-left: 5px; padding-right: 5px">
                                <td style="width: 50%;" valign="top">
                                </td>
                            </tr>
                            <tr style="padding-left: 5px; padding-right: 5px">
                                <td class="entrytitlecell" colspan="3" style="width: 100%;">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="height: 100%;">
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlLit" runat="server" Style="display: none;">
            <table id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" style="font-family: tahoma;
                font-size: 10px; width: 100%; height: 100%;">
                <tr>
                    <td style="background-color: rgb(244,242,232);">
                        <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkCancelLit, Nothing) %>;">
                            <img id="Img9" runat="server" border="0" src="~/images/16x16_cancel.png" />Cancel
                        </a>
                        <asp:LinkButton ID="lnkCancelLit" runat="server">
                        </asp:LinkButton>
                    </td>
                </tr>
                <tr id="tr2" runat="server">
                    <td style="padding: 5px">
                        <div class="iboxDiv">
                            <table border="0" cellpadding="7" cellspacing="0" class="iboxTable">
                                <tr>
                                    <td style="width: 16;" valign="top">
                                        <img id="Img10" runat="server" border="0" src="~/images/16x16_note3.png" />
                                    </td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" class="iboxTable2">
                                            <tr>
                                                <td class="iboxHeaderCell">
                                                    <asp:Literal ID="Literal1" runat="server"></asp:Literal>Litigation Entry for <b>Client</b>
                                                    <%=EntityName%>
                                                </td>
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
                            <tr>
                                <td colspan="3">
                                    <div id="Div2" runat="server" style="display: none;">
                                        <table border="0" cellpadding="0" cellspacing="10" style="border-right: #969696 1px solid;
                                            border-top: #969696 1px solid; font-size: 11px; border-left: #969696 1px solid;
                                            color: red; border-bottom: #969696 1px solid; font-family: Tahoma; background-color: #ffffda"
                                            width="100%">
                                            <tr>
                                                <td style="width: 20;" valign="top">
                                                    <img id="Img13" runat="server" align="absmiddle" border="0" src="~/images/message.png">
                                                </td>
                                                <td id="td2" runat="server">
                                                </td>
                                            </tr>
                                        </table>
                                        &nbsp;
                                    </div>
                                </td>
                            </tr>
                            <tr style="padding-left: 5px; padding-right: 5px">
                                <td style="width: 100%;" valign="top">
                                    <table border="0" cellpadding="5" cellspacing="0" style="font-family: tahoma; font-size: 11px;
                                        width: 100%;">
                                        <tr>
                                            <td colspan="2" style="background-color: #f1f1f1;">
                                                Details
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="entrytitlecell">
                                                Created by:
                                            </td>
                                            <td>
                                                <asp:Label ID="txtLitCreatedBy" runat="server" CssClass="entry2"></asp:Label>
                                                on
                                                <asp:Label ID="txtLitCreatedDate" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="entrytitlecell">
                                                Last modified by:
                                            </td>
                                            <td>
                                                <asp:Label ID="txtLitLastModifiedBy" runat="server" CssClass="entry2"></asp:Label>
                                                on
                                                <asp:Label ID="txtLitLastModifiedDate" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="entrytitlecell">
                                                Subject:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblLitSubject" runat="server" CssClass="entry2"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr id="tr3" runat="server">
                                            <td class="entrytitlecell" colspan="2" style="width: 100%">
                                                Message:<br />
                                                <div style="padding-top: 5px">
                                                    <asp:TextBox ID="txtLitMessage" runat="server" Columns="50" CssClass="entry" Enabled="false"
                                                        Height="75px" MaxLength="1000" Rows="20" TextMode="MultiLine">
                                                    </asp:TextBox>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="height: 100%;">
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="gvnotes" EventName="Sorting" />
    </Triggers>
</asp:UpdatePanel>
<asp:HiddenField ID="NegGuid" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hdnTempNoteID" runat="server" />
<asp:HiddenField ID="hdnTempPhoneCallID" runat="server" />
<asp:HiddenField ID="hdnAction" runat="server" />
<asp:HiddenField ID="hdnRelationTypeID" runat="server" />
<asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hdnCreditorID" runat="server" EnableViewState="true" />
