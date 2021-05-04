<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="adddeb.aspx.vb" Inherits="clients_client_finances_bytype_adddeb" title="DMP - Client - Add New Debit" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript">

    var cboEntryTypeID = null;

    var txtAmount = null;
    var txtTransactionDate = null;
    var cboAccountID = null;
    var cboMediatorID = null;
    var txtCheckNumber = null;
    var txtDescription = null;

    var trAccountID = null;
    var trMediatorID = null;

    var tblBody = null;
    var tblMessage = null;

    function Record_Save()
    {
        LoadControls();

        if (Record_RequiredExist())
        {
            // postback to save
            Record_Display("Saving debit...");
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function LoadControls()
    {
        if (cboEntryTypeID == null)
        {
            cboEntryTypeID = document.getElementById("<%= cboEntryTypeID.ClientID %>");

            txtAmount = document.getElementById("<%= txtAmount.ClientID %>");
            txtTransactionDate = document.getElementById("<%= txtTransactionDate.ClientID %>");
            cboAccountID = document.getElementById("<%= cboAccountID.ClientID %>");
            cboMediatorID = document.getElementById("<%= cboMediatorID.ClientID %>");
            txtCheckNumber = document.getElementById("<%= txtCheckNumber.ClientID %>");
            txtDescription = document.getElementById("<%= txtDescription.ClientID %>");

            trAccountID = document.getElementById("<%= trAccountID.ClientID %>");
            trMediatorID = document.getElementById("<%= trMediatorID.ClientID %>");

            tblBody = document.getElementById("<%= tblBody.ClientID %>");
            tblMessage = document.getElementById("<%= tblMessage.ClientID %>");
        }
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        Record_Display("Closing...");
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
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
    function Record_RequiredExist()
    {
        RemoveBorder(cboEntryTypeID);
        RemoveBorder(txtTransactionDate);
        RemoveBorder(cboAccountID);
        RemoveBorder(cboMediatorID);
        RemoveBorder(txtAmount);
        RemoveBorder(txtDescription);

        // amount is always available and required
	    if (txtAmount.value.length == 0)
	    {
            ShowMessage("The Amount is required.");
            AddBorder(txtAmount);
            return false;
	    }
	    else
	    {
	        if (!IsValidNumberFloat(txtAmount.value, true, txtAmount))
	        {
                ShowMessage("The Amount you entered is invalid.  Please enter a new value.");
                AddBorder(txtAmount);
                return false;
	        }
	    }

        // date is always available and required
	    if (txtTransactionDate.value.length == 0)
	    {
            ShowMessage("The Debit Date is required.");
            AddBorder(txtTransactionDate);
            return false;
	    }
	    else
	    {
	        if (!IsValidDateTime(txtTransactionDate.value))
	        {
                ShowMessage("The Debit Date you entered is invalid.  Please enter a new value.");
                AddBorder(txtTransactionDate);
                return false;
	        }
	    }

        // transaction types
        if (cboEntryTypeID.selectedIndex == -1 || cboEntryTypeID.options[cboEntryTypeID.selectedIndex].value <= 0)
        {
            ShowMessage("The Debit Type is required.");
            AddBorder(cboEntryTypeID);
            return false;
        }

        // account id
        if (trAccountID.style.display == "inline")
        {
            if (cboAccountID.selectedIndex == -1 || cboAccountID.options[cboAccountID.selectedIndex].value <= 0)
            {
                ShowMessage("Based on the Debit Type you selected, the Account is required.");
                AddBorder(cboAccountID);
                return false;
            }
        }

        // mediator id
        if (trMediatorID.style.display == "inline")
        {
            if (cboMediatorID.selectedIndex == -1 || cboMediatorID.options[cboMediatorID.selectedIndex].value <= 0)
            {
                ShowMessage("Based on the Debit Type you selected, the Account is a required field.");
                AddBorder(cboMediatorID);
                return false;
            }
        }

        HideMessage()
	    return true;
	}
	function cboEntryTypeID_OnChange(cbo)
	{
	    LoadControls();

	    if (cbo.selectedIndex != -1 && cbo.options[cbo.selectedIndex].value == "18") //settlement / client withdrawal
	    {
	        trAccountID.style.display = "inline";
	        trMediatorID.style.display = "inline";
	    }
	    else
	    {
	        trAccountID.style.display = "none";
	        trMediatorID.style.display = "none";
	    }
	}
    function SetToNow(lnk)
    {
        var d = new Date();
        var month = d.getMonth() + 1
        var day = d.getDate()
        var year = d.getFullYear()

        if (day <= 9)
            day = "0" + day;
        if (month <= 9)
            month = "0" + month;

        var s = "/";
        var curDate = month + s + day + s + year;

        var hours = d.getHours();
        var minutes = d.getMinutes();
        var seconds = d.getSeconds();
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

        var curTime = hours + ":" + minutes + " " + td;

        var txtDate = lnk.parentElement.previousSibling.childNodes[0];

        txtDate.value = curDate + " " + curTime;
    }
    function Record_Display(Message)
    {
        LoadControls();

        tblBody.style.display = "none";
        tblMessage.style.display = "inline";
        tblMessage.rows[0].cells[0].innerHTML = Message;
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
        function AttachDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = document.getElementById('<%=hdnTempRegisterID.ClientID %>').value + '&temp=1';
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=ClientID %>&type=register&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
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
        function OpenScanning_old()
        {
            var relID = document.getElementById('<%=hdnTempRegisterID.ClientID %>').value + '&temp=1';
            
            scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=register&rel=' + relID, 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
            intScanWin = setInterval('WaitScanned()', 500);
        }
         function OpenScanning(){
            var relID = document.getElementById('<%=hdnTempRegisterID.ClientID %>').value + '&temp=1';
            try{
                self.top.frames[0].ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=ClientID %>&type=register&rel=' + relID);
            }
            catch(e){
                if(window.parent.parent != null) {
                       var val = window.parent.parent.ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=ClientID %>&type=register&rel=' + relID);
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
        function DeleteDocument()
        {
            if (document.getElementById('<%=hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
            }
        }
    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color:#666666;font-size:13px;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkFinanceRegister" runat="server" class="lnk" style="color:#666666;font-size:13px;">Finances</a>&nbsp;>&nbsp;Add New Debit</td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
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
                    <tr>
                        <td style="width:50%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;" colspan="3" nowrap="true">General&nbsp;Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" nowrap="true">Debit&nbsp;Type:</td>
                                    <td><asp:DropDownList CssClass="entry" runat="server" id="cboEntryTypeID"></asp:DropDownList></td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" nowrap="true">Debit&nbsp;Date:</td>
                                    <td><cc1:InputMask CssClass="entry" mask="nn/nn/nnnn nn:nn aa" runat="server" id="txtTransactionDate"></cc1:InputMask></td>
                                    <td style="width:60;"><a class="lnk" href="#" onclick="SetToNow(this);return false;">Set to Now</a></td>
                                </tr>
                                <tr id="trAccountID" runat="server" style="display:none;">
                                    <td class="entrytitlecell" nowrap="true">Concerning&nbsp;Account:</td>
                                    <td><asp:DropDownList CssClass="entry" runat="server" id="cboAccountID"></asp:DropDownList></td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr id="trMediatorID" runat="server" style="display:none;">
                                    <td class="entrytitlecell" nowrap="true">Concerning&nbsp;Mediator:</td>
                                    <td><asp:DropDownList CssClass="entry" runat="server" id="cboMediatorID"></asp:DropDownList></td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" nowrap="true">Check&nbsp;Number:</td>
                                    <td><asp:TextBox CssClass="entry" runat="server" id="txtCheckNumber"></asp:TextBox></td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" nowrap="true">Transaction&nbsp;Amount:</td>
                                    <td><asp:TextBox CssClass="entry" runat="server" id="txtAmount"></asp:TextBox></td>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                        <td><img height="1" width="30" runat="server" src="~/images/spacer.gif" /></td>
                        <td style="width:50%;" valign="top">&nbsp;</td>
                    </tr>
                </table><br />
                <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0" border="0">
                    <tr>
                        <td nowrap="true" style="background-color:#f1f1f1;">Description</td>
                    </tr>
                    <tr>
                        <td><asp:TextBox MaxLength="255" style="width:100%;" Rows="5" CssClass="entry" runat="server" id="txtDescription" TextMode="MultiLine"></asp:TextBox></td>
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
                                                        <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String) %>');">
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
    </table>
    <table runat="server" id="tblMessage" style="color:#666666;display:none;font-family:tahoma;font-size:13px;" border="0" cellpadding="0" cellspacing="15"><tr><td></td><td><img id="Img2" src="~/images/loading.gif" runat="server" align="absmiddle" border="0" /></td></tr></table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
            
    <input id="hdnCurrentDoc" type="hidden" runat="server" />
    <input id="hdnTempRegisterID" type="hidden" runat="server" />
    
    <asp:LinkButton ID="lnkShowDocs" runat="server" />
    <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
    <asp:LinkButton runat="server" ID="lnkSave" />
    
</body>

</asp:Content>