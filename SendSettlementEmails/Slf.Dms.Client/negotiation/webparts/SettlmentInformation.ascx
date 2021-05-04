<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlmentInformation.ascx.vb"
    Inherits="negotiation_webparts_SessionNotesControl" %>

<style type="text/css">
    .fixedHeader th
        {
           background-image:url(../images/widget_headbg.png);
	       background-repeat:repeat-x;
	       overflow:hidden;
           position: relative;
           top: expression(this.parentNode.parentNode.parentNode.parentNode.parentNode.scrollTop-1);
           color:#1D78A5;
           TEXT-ALIGN:LEFT;
           table-layout:fixed;
        }
        .entryCell {font-family:tahoma;font-size:10px;}
    .radiobtn_list input{float: left;}
    .radiobtn_list label{margin-top:4px;margin-left:25px;display:block;}        
    html, body, table#main {height: 100%}     
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
             var url = '<%= ResolveUrl("~/util/pop/addressbook.aspx?id=" & DataClientID) %>';
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
        
        function OpenPABox(settid){
             var url = '<%= ResolveUrl("~/util/pop/PaymentArrangementInfo.aspx?sid=") %>' + settid;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Payment Arrangement Info",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 450, width: 550});
             return false;
        }  
</script>
<ajaxToolkit:TabContainer ID="tcSettlementInfo" CssClass="tabContainer" Height="275px"
    ActiveTabIndex="0" runat="server" AutoPostBack="true">
    <ajaxToolkit:TabPanel ID="tpSettlementHistory" runat="server" HeaderText="Settlement History">
        <ContentTemplate>
            <asp:UpdatePanel ID="updSettlementHistory" runat="server">
                <ContentTemplate>
                    <table style=" width: 100%;">
                        <tr valign="top">
                            <td style="height:235px">
                                <asp:GridView ID="gvHistory" runat="server" Width="100%" AllowPaging="True" AllowSorting="True"
                                    AutoGenerateColumns="False" DataSourceID="dsHistory" PageSize="13" GridLines="none"
                                    BorderStyle="None" >
                                    <RowStyle CssClass="GridRowStyle" />
                                    <AlternatingRowStyle CssClass="GridAlternatingRowStyle" />
                                    <PagerStyle CssClass="GridPagerStyle" />
                                    <HeaderStyle CssClass="webpartgridhdrstyle" />
                                    <EmptyDataTemplate>
                                        <div>
                                            No records to display.</div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lnkSelect" runat="server" CommandArgument='<%#bind("SettlementID") %>'
                                                    CommandName="Select">Restore</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="SettlementID" ItemStyle-HorizontalAlign="Center" HeaderText="Settlement ID"
                                            SortExpression="SettlementID" />
                                        <asp:BoundField DataField="Status" ItemStyle-HorizontalAlign="Center" HeaderText="Status"
                                            SortExpression="Status" />
                                        <asp:TemplateField HeaderStyle-HorizontalAlign="Center" HeaderText="Offer Direction"
                                            ItemStyle-HorizontalAlign="Center" SortExpression="OfferDirection">
                                            <ItemTemplate>
                                                <asp:Image ID="imgDir" runat="server" />
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Created" DataFormatString="{0:d}" HtmlEncode="False" HeaderText="Created"
                                            SortExpression="Created">
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SettlementPercent" DataFormatString="{0:N2}"  HeaderText="Percent" SortExpression="SettlementPercent">
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SettlementAmount" DataFormatString="{0:C}" HtmlEncode="False"
                                            HeaderText="Amount" SortExpression="SettlementAmount">
                                            <HeaderStyle HorizontalAlign="Right" />
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SettlementDueDate" DataFormatString="{0:d}" HeaderText="Due Date"
                                            HtmlEncode="False" SortExpression="SettlementDueDate">
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:TemplateField>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                            <HeaderTemplate>
                                                <a>P.A.</a>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#IIf(Not IsDBNull(DataBinder.Eval(Container.DataItem, "IsPaymentArrangement")) AndAlso DataBinder.Eval(Container.DataItem, "IsPaymentArrangement"), "<a href=""javascript:void()"" onclick=""OpenPABox('" & DataBinder.Eval(Container.DataItem, "SettlementId") & "');return false;"">Yes</a>", "No")%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:SqlDataSource ID="dsHistory" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                    SelectCommand="stp_negotiations_getSettlementForClientAndCreditor" 
                                    SelectCommandType="StoredProcedure" ProviderName="System.Data.SqlClient" >
                                    <SelectParameters>
                                    
                                        <asp:Parameter Name="clientid" Type="Int32" />
                                        <asp:Parameter Name="creditoraccountid" Type="Int32" />
                                    
                                    </SelectParameters>
                                    </asp:SqlDataSource>
                            </td>
                        </tr>
                        <tr valign="bottom">
                            <td nowrap="nowrap">
                                <asp:Label ID="labelA" runat="server" Text="A:  Accepted |" />
                                <asp:Label ID="label1" runat="server" Text="R:  Rejected |"></asp:Label>
                                <asp:Label ID="label2" runat="server" Text="Offer Made:"></asp:Label>
                                <asp:Image ID="imgMade" runat="server" ImageUrl="~/negotiation/images/offerout.png" />
                                <asp:Label ID="label3" runat="server" Text="| Offer Received:"></asp:Label>
                                <asp:Image ID="Image1" runat="server" ImageUrl="~/negotiation/images/offerin.png" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="gvHistory" EventName="RowCommand" />
                    <asp:AsyncPostBackTrigger ControlID="gvHistory" EventName="PageIndexChanging" />
                    <asp:AsyncPostBackTrigger ControlID="gvHistory" EventName="Sorting" />
                </Triggers>
            </asp:UpdatePanel>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="tpPendingOffers" runat="server" HeaderText="Pending Offers">
        <ContentTemplate>
            <asp:GridView ID="gvPendingOffers" runat="server" DataSourceID="dsPendingOffers"
                AutoGenerateColumns="false"  Width="100%" BorderStyle="None" GridLines="Horizontal" AllowPaging="true" PageSize="7">  
                <RowStyle CssClass="GridRowStyle" />
                <AlternatingRowStyle CssClass="GridAlternatingRowStyle" />
                <PagerStyle CssClass="GridPagerStyle" />
                <HeaderStyle CssClass="webpartgridhdrstyle" />
                <EmptyDataTemplate>
                 <div>
                No Pending Offers
                </div>
                </EmptyDataTemplate>
                <Columns>
                    <asp:BoundField DataField="negotiator" SortExpression="negotiator" HeaderText="Neg." />
                    <asp:BoundField DataField="due" SortExpression="due" HeaderText="Due Date" DataFormatString="{0:d}" />
                    <asp:TemplateField HeaderText="Creditor Info">
                        <ItemTemplate>
                            <b>Curr:</b>
                            <asp:Label ID="lblCur" runat="server" Text='<%#eval("currentcreditor") %>' /><br />
                            <b>Orig:</b>
                            <asp:Label ID="Label4" runat="server" Text='<%#eval("originalcreditor") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="balance" SortExpression="balance" HeaderText="Acct Bal."
                        DataFormatString="{0:c2}" ItemStyle-Wrap="false">
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="settlementamt" SortExpression="settlementamt" HeaderText="Sett $"
                        DataFormatString="{0:c2}" ItemStyle-Wrap="false">
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="settlementpercent" SortExpression="settlementpercent"
                        HeaderText="Sett %" DataFormatString="{0:p2}" ItemStyle-Wrap="false" >
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="settlementfees" SortExpression="settlementfees" HeaderText="Sett Fees"
                        DataFormatString="{0:c2}" ItemStyle-Wrap="false">
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="dsPendingOffers" ConnectionString="<%$ AppSettings:connectionstring %>"
                runat="server" ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure"
                SelectCommand="stp_Negotiations_getPendingOffersByClientID">
                <SelectParameters>
                     <asp:Parameter Name="clientid" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="tpNotes" runat="server" HeaderText="Notes">
        <HeaderTemplate>
            Notes
        </HeaderTemplate>
        <ContentTemplate>
            <asp:UpdatePanel ID="upDefault" runat="server">
                <ContentTemplate>
                    <asp:Panel Width="100%" ID="pnlComms" runat="server" Style="display: block;">
                        <table width="100%">
                            <tr style="vertical-align: top; display:none;">
                                <td>
                                    <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkAddNote, Nothing) %>;">
                                        <img src="~/images/16x16_note_add.png" border="0" runat="server" />Add Note
                                    </a>
                                    <asp:LinkButton ID="lnkAddNote" runat="server" />
                                    
                                    <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkAddCall, Nothing) %>;">
                                        <img src="~/images/16x16_phone_add.png" border="0" runat="server" />Add Call
                                    </a>
                                    <asp:LinkButton ID="lnkAddCall" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td style="border:solid 1px #80BAE9;">
                                    <asp:RadioButtonList ID="radCommType" AutoPostBack="true" RepeatDirection="Horizontal"
                                        runat="server" TextAlign="right" CssClass="radiobtn_list">
                                        <asp:ListItem Text="All Comms" Value="0" Selected="true"></asp:ListItem>
                                        <asp:ListItem Text="Comms specific to " Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Comms specific to " Value="2"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="overflow: auto; width: 100%; height: 225px;">
                                        <asp:GridView Width="95%" ID="gvNotes" runat="server" AutoGenerateColumns="False" DataSourceID="dsNotes"
                                            CellPadding="4" DataKeyNames="id,Type,CommTable,CommDate,CommTime,Staff" ForeColor="#1D78A5" GridLines="None" AllowSorting="True"
                                            AllowPaging="False" PageSize="4" CssClass="fixedHeader" ToolTip="Click SessionStarted to edit session note for Client">
                                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"  />
                                            <EmptyDataTemplate>
                                                No Notes Available.
                                            </EmptyDataTemplate>
                                            <AlternatingRowStyle CssClass="webpartgridaltrowstyle" />
                                            <RowStyle CssClass="webpartgridrowstyle" />
                                            <HeaderStyle  />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Type" SortExpression="OfferDirection">
                                                    <ItemTemplate>
                                                        <asp:Image ID="imgDir" runat="server" />
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="center" />
                                                    <ItemStyle HorizontalAlign="center" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="By" HeaderText="By" SortExpression="By">
                                                    <HeaderStyle HorizontalAlign="left" />
                                                    <ItemStyle HorizontalAlign="left" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date">
                                                    <HeaderStyle HorizontalAlign="left" />
                                                    <ItemStyle HorizontalAlign="left" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Note" SortExpression="Note" HeaderStyle-HorizontalAlign="left"
                                                    ItemStyle-HorizontalAlign="left">
                                                    <ItemTemplate>
                                                        <asp:Label ID="noteSubject" Font-Bold="true" runat="server" />
                                                        <asp:Label ID="noteText" runat="server" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <PagerTemplate>
                                                <table style="background-color: Silver; width: 100%;">
                                                    <tr style="vertical-align: middle; height: 25px;">
                                                        <td align="right">
                                                            <asp:Label ID="Label1" runat="server" Text="Go to Page " />
                                                            <asp:DropDownList AutoPostBack="true" Style="height: 18px; font-size: 8pt;" ID="ddlPage"
                                                                runat="server" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged">
                                                            </asp:DropDownList>
                                                            of
                                                            <asp:Label ID="lblTotalPages" runat="server" Text="" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </PagerTemplate>
                                            <PagerSettings Position="Bottom" Mode="NumericFirstLast" PageButtonCount="20" />
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="dsNotes" ConnectionString="<%$ AppSettings:connectionstring %>"
                                            runat="server" ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure"
                                            SelectCommand="stp_NegotiationNotesSelect" CancelSelectOnNullParameter="false">
                                            <SelectParameters>
                                                <asp:Parameter Name="clientid" Type="Int32"  />
                                                <asp:Parameter Name="relationid" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue="" />
                                                <asp:Parameter Name="relationtypeid" Type="Int32" ConvertEmptyStringToNull="true" DefaultValue=""/>
                                                <asp:Parameter Name="clientonly" Type="Boolean" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel Width="100%" ID="pnlNote" runat="server" Style="display: none;">
                        <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 10px; width: 100%;
                            height: 100%;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td style="text-align: left;">
                                                <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;">
                                                    <img src="~/images/16x16_save.png" border="0" runat="server" />Save and Close
                                                </a>
                                                <asp:LinkButton ID="lnkSave" runat="server" />
                                            </td>
                                            <td style="text-align: right;" nowrap="nowrap">
                                                <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;">
                                                    <img src="~/images/16x16_cancel.png" border="0" runat="server" />Cancel
                                                </a>
                                                <asp:LinkButton ID="lnkCancel" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="trInfoBox">
                                <td class="iboxHeaderCell">
                                    <div class="iboxDiv">
                                        <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 16;">
                                                    <img id="imgNote" runat="server" border="0" src="~/images/16x16_note3.png" /></td>
                                                <td>
                                                    <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
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
                                <td valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                <div runat="server" id="dvError" style="display: none;">
                                                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                                        width="100%" border="0">
                                                        <tr>
                                                            <td valign="top" style="width: 20;">
                                                                <img id="Img5" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                                            <td runat="server" id="tdError">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    &nbsp;
                                                </div>
                                            </td>
                                        </tr>
                                        <tr style="padding-left: 5px; padding-right: 5px">
                                            <td style="width: 100%;" valign="top">
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                                    cellspacing="0">
                                                    <tr>
                                                        <td style="background-color: #f1f1f1; text-align: left;" colspan="2">
                                                            Details</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell" style="text-align: right;">
                                                            Created by:</td>
                                                        <td style="text-align: left;">
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtCreatedBy"></asp:Label>
                                                            on
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtCreatedDate"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell" style="text-align: right;">
                                                            Last modified by:</td>
                                                        <td style="text-align: left;">
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtLastModifiedBy"></asp:Label>
                                                            on
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtLastModifiedDate"></asp:Label></td>
                                                    </tr>
                                                    <tr id="trMessage" runat="server">
                                                        <td class="entrytitlecell" colspan="2" style="width: 100%; text-align: left;">
                                                            Message:<br />
                                                            <div style="padding-top: 5px">
                                                                <asp:TextBox TabIndex="3" Height="75px" Width="98%" CssClass="entryCell" runat="server"
                                                                    ID="txtMessage" Rows="20" TextMode="MultiLine" MaxLength="1000"></asp:TextBox>
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
                    <asp:Panel Width="100%" ID="pnlCall" runat="server" Style="display: none;">
                        <table runat="server" id="Table2" style="font-family: tahoma; font-size: 11px; width: 100%;
                            height: 100%;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="text-align: left; background-color: rgb(244,242,232);">
                                    <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkSaveCall, Nothing) %>;">
                                        <img src="~/images/16x16_save.png" border="0" runat="server" />Save and Close
                                    
                                    
                                    </a>
                                    <asp:LinkButton ID="lnkSaveCall" runat="server" />
                                </td>
                                <td style="text-align: right; background-color: rgb(244,242,232);">
                                    <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkCancelCall, Nothing) %>;">
                                        <img src="~/images/16x16_cancel.png" border="0" runat="server" />Cancel </a>
                                    <asp:LinkButton ID="lnkCancelCall" runat="server" />
                                </td>
                            </tr>
                            <tr id="tr1" runat="server">
                                <td colspan="2" style="padding: 5px">
                                    <div class="iboxDiv">
                                        <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 16;">
                                                    <img id="Img2" runat="server" border="0" src="~/images/16x16_note3.png" />
                                                </td>
                                                <td>
                                                    <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
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
                                            <td>
                                                <div runat="server" id="Div1" style="display: none;">
                                                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                                        width="100%" border="0">
                                                        <tr>
                                                            <td valign="top" style="width: 20;">
                                                                <img id="Img11" runat="server" src="~/images/16x16_note3.png" align="absmiddle" border="0">
                                                            </td>
                                                            <td runat="server" id="td1">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    &nbsp;
                                                </div>
                                            </td>
                                        </tr>
                                        <tr style="padding-left: 5px; padding-right: 5px">
                                            <td style="width: 50%;" valign="top">
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                                    cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <table style="width: 100%;" cellpadding="0" cellspacing="0">
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
                                                                                <td class="entrytitlecell" align="right" nowrap="nowrap">
                                                                                    Direction:
                                                                                </td>
                                                                                <td nowrap="nowrap" align="left">
                                                                                    <input type="radio" name="rbDirection" id="rbIncoming" runat="server" onclick="javascript:SwitchDirection('Incoming');" /><label
                                                                                        for="<%= rbIncoming.ClientID %>">Incoming</label>&nbsp;&nbsp;&nbsp;<input type="radio"
                                                                                            name="rbDirection" id="rbOutgoing" runat="server" onclick="javascript:SwitchDirection('Outgoing');"
                                                                                            checked="True" /><label for="<%= rbOutgoing.ClientID %>">Outgoing</label>
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="entrytitlecell" align="right" nowrap="nowrap">
                                                                                    Sender:
                                                                                </td>
                                                                                <td id="tdSenderHolder" runat="server" align="left">
                                                                                    <asp:DropDownList CssClass="entryCell" Width="150px" runat="server" ID="cboInternal">
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="entrytitlecell" align="right" nowrap="nowrap">
                                                                                    Recipient:
                                                                                </td>
                                                                                <td id="tdRecipientHolder" runat="server" align="left">
                                                                                    <asp:DropDownList CssClass="entryCell" Width="150px" runat="server" ID="cboExternal">
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <asp:Literal ID="ltrSwapOnLoad" runat="server"></asp:Literal>
                                                                            <tr>
                                                                                <td class="entrytitlecell" align="right" nowrap="nowrap">
                                                                                    Phone&nbsp;Number:
                                                                                </td>
                                                                                <td align="left">
                                                                                    <asp:TextBox CssClass="entryCell" ID="txtPhoneNumber" runat="server" />
                                                                                    <ajaxToolkit:MaskedEditExtender ID="meeNumber" runat="server" TargetControlID="txtPhoneNumber"
                                                                                        MaskType="Number" Mask="(999) 999-9999" ClearMaskOnLostFocus="false" PromptCharacter="#" />
                                                                                </td>
                                                                                <td>
                                                                                    <a href="#" onclick="AddressBook();return false;">
                                                                                        <img id="Img12" runat="server" src="~/images/16x16_addressbook.png" border="0" align="absmiddle" /></a>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td rowspan="3">
                                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="3"
                                                                            cellspacing="0">
                                                                            <tr>
                                                                                <td align="left">
                                                                                    Subject:&nbsp;&nbsp;
                                                                                    <asp:TextBox CssClass="entryCell" runat="server" ID="txtSubject"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:TextBox CssClass="entryCell" Height="100px" Width="98%" runat="server" ID="txtCallMsg"
                                                                                        Rows="20" TextMode="MultiLine" MaxLength="1000"></asp:TextBox>
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
                                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%; border-collapse: collapse"
                                                                            border="0" cellpadding="1" cellspacing="0">
                                                                            <tr>
                                                                                <td style="text-align: right;">
                                                                                    Started:
                                                                                </td>
                                                                                <td nowrap="nowrap" align="left">
                                                                                    <asp:TextBox CssClass="entryCell" ID="txtStarted" runat="server" />
                                                                                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtStarted"
                                                                                        Mask="99/99/9999 99:99:99" MessageValidatorTip="true" OnFocusCssClass="MaskedEditFocus"
                                                                                        OnInvalidCssClass="MaskedEditError" MaskType="DateTime" AcceptAMPM="True" ErrorTooltipEnabled="True" />
                                                                                    &nbsp;&nbsp;<asp:LinkButton runat="server" Text="Set to Now" ID="aStartedNow" CssClass="lnk"
                                                                                        OnClientClick="javascript:SetToNow('txtStarted')" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="text-align: right">
                                                                                    Ended:
                                                                                </td>
                                                                                <td nowrap="nowrap" align="left">
                                                                                    <asp:TextBox CssClass="entryCell" ID="txtEnded" runat="server" />
                                                                                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtEnded"
                                                                                        Mask="99/99/9999 99:99:99" MessageValidatorTip="true" OnFocusCssClass="MaskedEditFocus"
                                                                                        OnInvalidCssClass="MaskedEditError" MaskType="DateTime" AcceptAMPM="True" ErrorTooltipEnabled="True" />
                                                                                    &nbsp;&nbsp;<asp:LinkButton runat="server" ID="aEndedNow" CssClass="lnk" OnClientClick="javascript:SetToNow('txtEnded')"
                                                                                        Text="Set to Now" />
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
                                                        <td style="font-size: 1px">
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
                                            <td class="entrytitlecell" style="width: 100%;">
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
                        <table runat="server" id="Table1" style="font-family: tahoma; font-size: 10px; width: 100%;
                            height: 100%;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="background-color: rgb(244,242,232);">
                                    <a href="#" onclick="javascript:<%=Page.ClientScript.GetPostBackEventReference(lnkCancelLit, Nothing) %>;">
                                        <img id="Img1" src="~/images/16x16_cancel.png" border="0" runat="server" />Cancel
                                    </a>
                                    <asp:LinkButton ID="lnkCancelLit" runat="server" />
                                </td>
                            </tr>
                            <tr id="tr2" runat="server">
                                <td style="padding: 5px">
                                    <div class="iboxDiv">
                                        <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                            <tr>
                                                <td valign="top" style="width: 16;">
                                                    <img id="Img4" runat="server" border="0" src="~/images/16x16_note3.png" />
                                                </td>
                                                <td>
                                                    <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
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
                                            <td>
                                                <div runat="server" id="Div2" style="display: none;">
                                                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                                        width="100%" border="0">
                                                        <tr>
                                                            <td valign="top" style="width: 20;">
                                                                <img id="Img6" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                                            </td>
                                                            <td runat="server" id="td2">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    &nbsp;
                                                </div>
                                            </td>
                                        </tr>
                                        <tr style="padding-left: 5px; padding-right: 5px">
                                            <td style="width: 100%;" valign="top">
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                                                    cellspacing="0">
                                                    <tr>
                                                        <td style="background-color: #f1f1f1;" colspan="2">
                                                            Details
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell">
                                                            Created by:
                                                        </td>
                                                        <td>
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtLitCreatedBy"></asp:Label>
                                                            on
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtLitCreatedDate"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell">
                                                            Last modified by:
                                                        </td>
                                                        <td>
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtLitLastModifiedBy"></asp:Label>
                                                            on
                                                            <asp:Label CssClass="entry2" runat="server" ID="txtLitLastModifiedDate"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="entrytitlecell">
                                                            Subject:
                                                        </td>
                                                        <td>
                                                            <asp:Label CssClass="entry2" runat="server" ID="lblLitSubject"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr id="tr3" runat="server">
                                                        <td class="entrytitlecell" colspan="2" style="width: 100%">
                                                            Message:<br />
                                                            <div style="padding-top: 5px">
                                                                <asp:TextBox CssClass="entry" runat="server" ID="txtLitMessage" Height="75px" Rows="20"
                                                                    TextMode="MultiLine" MaxLength="1000" Columns="50" Enabled="false" />
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
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
</ajaxToolkit:TabContainer>
<asp:HiddenField ID="historyHiddenIDs" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hdnCreditorID" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hdnNoteID" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hdnTempPhoneCallID" runat="server" />
<asp:HiddenField ID="hdnCurrentDoc" runat="server" />
<asp:HiddenField ID="hdnTempNoteID" runat="server" />
<asp:HiddenField ID="hdnAction" runat="server" />
<asp:HiddenField ID="hdnRelationTypeID" runat="server" />
<asp:LinkButton ID="lnkShowDocs" runat="server" />
<asp:LinkButton ID="lnkDeleteDocument" runat="server" />
