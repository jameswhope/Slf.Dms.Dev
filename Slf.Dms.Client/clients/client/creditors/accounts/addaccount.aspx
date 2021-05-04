<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="addaccount.aspx.vb" Inherits="clients_client_accounts_addaccount" title="DMP - Client - Account" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var txtOriginalDueDate = null;
    var txtSetupFeePercentage = null;
    var txtAcquired = null;
    var txtAccountNumber = null;
    var txtOriginalAmount = null;
    var txtCurrentAmount = null;
    var hdnCreditor = null;
    var txtCreditor = null;

    var chkIsVerified = null;
    var chkAddFee = null;
    var txtAddFee = null;
    var chkRetainerFee = null;
    var txtRetainerFee = null;

    var tblBody = null;
    var tblMessage = null;
    
    window.onload = function ()
    {
        var str = document.getElementById('<%=hdnCreditor.ClientID %>').value;
        var str2 = document.getElementById('<%=hdnForCreditor.ClientID %>').value;
        
        if (str.length > 0)
        {
            document.getElementById('<%=txtCreditor.ClientID %>').innerHTML = str.split('|')[1];
            
            // Not Represented creditors will have a creditor id of -9 if no lookup was found
            if (str.split('|')[0] == '-9') 
            {
                ShowMessage('Creditor lookup required.');
                AddBorder(document.getElementById("<%=txtCreditor.ClientID %>"));
            }
        }

        if (str2.length > 0)
        {
            document.getElementById('<%=txtForCreditor.ClientID %>').innerHTML = str2.split('|')[1];
            
            // Not Represented creditors will have a creditor id of -9 if no lookup was found
            if (str2.split('|')[0] == '-9') 
            {
                ShowMessage('Creditor lookup required.');
                AddBorder(document.getElementById("<%=txtForCreditor.ClientID %>"));
            }
        }
    }

    function Record_CancelAndClose()
    {
        // postback to cancel and close
        Record_Display("Closing...");
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_SaveConfirm()
    {
        if (Record_RequiredExist())
        {
            var Amount = 0.0;
            var Percent = 0.0;

            Amount = parseFloat(txtCurrentAmount.value);
            Percent = (parseFloat(txtSetupFeePercentage.value)) / 100;

            // open the "collect fee" pop-up
            var url = '<%= ResolveUrl("~/clients/client/creditors/accounts/action/collect.aspx?id=" & ClientID) %>&t=Confirmation&a=' + Amount + '&pr=' + Percent;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Confirmation",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 400, width: 450}); 
        }
    }
    function Record_Save(IsVerified)
    {
        chkIsVerified.checked = IsVerified;

        // postback to save
        Record_Display("Saving new account...");
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
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
	function LoadControls()
	{
	    if (txtOriginalDueDate == null)
	    {
            txtOriginalDueDate = document.getElementById("<%=txtOriginalDueDate.ClientiD %>");
	        txtSetupFeePercentage = document.getElementById("<%=txtSetupFeePercentage.ClientiD %>");
	        txtAcquired = document.getElementById("<%=txtAcquired.ClientiD %>");
	        txtAccountNumber = document.getElementById("<%=txtAccountNumber.ClientiD %>");
	        txtOriginalAmount = document.getElementById("<%=txtOriginalAmount.ClientiD %>");
	        txtCurrentAmount = document.getElementById("<%=txtCurrentAmount.ClientiD %>");
	        hdnCreditor = document.getElementById("<%=hdnCreditor.ClientiD %>");
	        txtCreditor = document.getElementById("<%=txtCreditor.ClientiD %>");
	        chkIsVerified = document.getElementById("<%=chkIsVerified.ClientiD %>");
            chkAddFee = document.getElementById("<%=chkAddFee.ClientiD %>");
            txtAddFee = document.getElementById("<%=txtAddFee.ClientiD %>");
            chkRetainerFee = document.getElementById("<%=chkRetainerFee.ClientiD %>");
            txtRetainerFee = document.getElementById("<%=txtRetainerFee.ClientiD %>");

            tblBody = document.getElementById("<%= tblBody.ClientID %>");
            tblMessage = document.getElementById("<%= tblMessage.ClientID %>");
        }
	}
    function Record_RequiredExist()
    {
        LoadControls();

        RemoveBorder(txtOriginalDueDate);
        RemoveBorder(txtSetupFeePercentage);
        RemoveBorder(txtAcquired);
        RemoveBorder(txtAccountNumber);
        RemoveBorder(txtOriginalAmount);
        RemoveBorder(txtCurrentAmount);
        RemoveBorder(txtCreditor);

        if (!IsValidDateTime(txtOriginalDueDate.value))
        {
            ShowMessage("Invalid Original Due Date date.  The Original Due Date field is required.");
            AddBorder(txtOriginalDueDate);
            return false;
        }

//        This is all pulled from the data previously entered and can not be changed.
//        if (txtSetupFeePercentage.value.length == 0)
//        {
//            ShowMessage("The Setup Fee Percentage field is required.");
//            AddBorder(txtSetupFeePercentage);
//            return false;
//        }
//        else if (!IsValidNumberFloat(txtSetupFeePercentage.value, false, txtSetupFeePercentage))
//        {
//            ShowMessage("The Retainer Fee Percentage you entered is invalid.  Please enter a percentage between 1 and 100.");
//            AddBorder(txtSetupFeePercentage);
//            return false;
//        }
//        else if (parseFloat(txtSetupFeePercentage.value) < 1 || parseFloat(txtSetupFeePercentage.value) > 100)
//        {
//            ShowMessage("The Retainer Fee Percentage you entered is invalid.  Please enter a percentage between 1 and 100.");
//            AddBorder(txtSetupFeePercentage);
//            return false;
//        }

        if (!IsValidDateTime(txtAcquired.value))
        {
            ShowMessage("Invalid Acquired date.  The Acquired field is required.");
            AddBorder(txtAcquired);
            return false;
        }

        if (txtAccountNumber.value.length == 0)
        {
            ShowMessage("The Account Number field is required.");
            AddBorder(txtAccountNumber);
            return false;
        }

        if (txtOriginalAmount.value.length == 0)
        {
            ShowMessage("The Original Amount field is required.");
            AddBorder(txtOriginalAmount);
            return false;
        }
        else if (!IsValidNumberFloat(txtOriginalAmount.value, true, txtOriginalAmount))
        {
            ShowMessage("The Original Amount you entered is invalid.  Please enter a non-zero, dollar amount.");
            AddBorder(txtOriginalAmount);
            return false;
        }

        if (txtCurrentAmount.value.length == 0)
        {
            ShowMessage("The Current Amount field is required.");
            AddBorder(txtCurrentAmount);
            return false;
        }
        else if (!IsValidNumberFloat(txtCurrentAmount.value, true, txtCurrentAmount))
        {
            ShowMessage("The Current Amount you entered is invalid.  Please enter a non-zero, dollar amount.");
            AddBorder(txtCurrentAmount);
            return false;
        }

        if (hdnCreditor.value.length == 0)
        {
            ShowMessage("The Creditor field is required.");
            AddBorder(txtCreditor);
            return false;
        }
        else
        {
            // Not Represented creditors will have a creditor id of -9 if no lookup was found
            if (hdnCreditor.value.split('|')[0] == '-9') 
            {
                ShowMessage('Creditor lookup required.');
                AddBorder(document.getElementById("<%=txtCreditor.ClientID %>"));
                return false;
            }
        }

        HideMessage()
	    return true;
    }
	function Record_DeleteConfirm()
	{
         window.dialogArguments = window;
         var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Creditor Instance&m=Are you sure you want to delete this Creditor Instance?';
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Creditor Instance",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400}); 
	}
    function Record_Delete()
    {
        // postback to delete
        Record_Display("Deleting account...");
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
   
    function CreditorFinderReturn(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
    {
        btn.nextSibling.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;0

        btn.creditorid=creditorid;
        btn.creditor=name;
        btn.street=street;
        btn.street2=street2;
        btn.city=city;
        btn.stateid=stateid;
        btn.statename=statename;
        btn.stateabbreviation=stateabbreviation;
        btn.zipcode=zipcode;
        btn.creditorgroupid=creditorgroupid;
        btn.validated=validated;

        btn.parentElement.previousSibling.firstChild.innerHTML=name;
        btn.parentElement.previousSibling.firstChild.style.border = 'solid 1px rgb(165,172,178)';
        
        HideMessage();
    }

    function FindCreditor(btn)
    {
        var creditor = btn.creditor;
        var street = btn.street;
        var street2 = btn.street2;
        var city = btn.city;
        var stateid = btn.stateid;
        var zipcode = btn.zipcode;

        if (creditor==null)creditor="";
        if (street==null)street="";
        if (street2==null)street2="";
        if (city==null)city="";
        if (stateid==null)stateid="";
        if (zipcode==null)zipcode="";

        // open the find window
         var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx?")%>' + 
                    'creditor=' + encodeURIComponent(creditor) + 
                    '&street=' + encodeURIComponent(street) + 
                    '&street2=' + encodeURIComponent(street2) + 
                    '&city=' + encodeURIComponent(city) + 
                    '&stateid=' + encodeURIComponent(stateid) + 
                    '&zipcode=' + encodeURIComponent(zipcode);
                    
            window.dialogArguments =  new Array(window, btn, "CreditorFinderReturn");
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
            title: "Find Creditor",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 700, width: 650
            });      
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
        var intAttachWin;
        
        var scanWin;
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
            
            var relID = document.getElementById('<%=hdnTempAccountID.ClientID %>').value + '&temp=1';
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=ClientID %>&type=account&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
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
        function OpenScanning()
        {
            var relID = document.getElementById('<%=hdnTempAccountID.ClientID %>').value;
            
            scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=account&temp=1' + '&rel=' + relID, 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
            intScanWin = setInterval('WaitScanned()', 500);
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
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color:#666666;font-size:13px;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkAccounts" runat="server" class="lnk" style="font-size:11px;color:#666666;">Accounts</a>&nbsp;>&nbsp;Add New Account</td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr id="NewInfo" runat="server" style="padding-bottom:20px" visible="false">
                        <td>
                            <div class="iboxDiv">
                                <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                    <tr>
                                        <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                        <td>
                                            <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class="iboxHeaderCell">INFORMATION:</td>
                                                </tr>
                                                <tr>
                                                    <td class="iboxMessageCell">
                                                        You are creating a new Creditor Instance, and the information
                                                        has been automatically filled out according to the current
                                                        Creditor Instance.  Please change the necessary information
                                                        before saving this new instance.
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
                        <td colspan="3">
                            <div runat="server" id="dvError" style="display:none;">
                                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					                <tr>
						                <td valign="top" style="width:20;"><img id="Img2" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
						                <td runat="server" id="tdError"></td>
					                </tr>
				                </table>&nbsp;
				            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">Creditor Account Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Original Due Date:</td>
                                                <td><cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true" TabIndex="1" cssclass="entry" ID="txtOriginalDueDate" runat="server" mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Retainer Fee %:</td>
                                                <td><input type="text" class="entry" id="txtSetupFeePercentage" runat="server" /></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="background-color:#f1f1f1;">Creditor Instance Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Acquired:</td>
                                                <td><cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true" TabIndex="2" cssclass="entry" ID="txtAcquired" runat="server" mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Account Number:</td>
                                                <td><input type="text" class="entry" id="txtAccountNumber" runat="server" TabIndex="3" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" style="width:95px">Reference Number:</td>
                                                <td><input type="text" class="entry" id="txtReferenceNumber" runat="server" TabIndex="4" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Original Amount:</td>
                                                <td><input type="text" class="entry" id="txtOriginalAmount" runat="server" TabIndex="5" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Current Amount:</td>
                                                <td><input type="text" class="entry" id="txtCurrentAmount" runat="server" TabIndex="6" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">
                                                    For Creditor:
                                                </td>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="font-size: 11px; font-family: Tahoma;width:200px">
                                                        <tr>
                                                            <td>
                                                                <div id="txtForCreditor" runat="server" class="entry" style="padding: 2; border: solid 1px rgb(165,172,178);">&nbsp;</div>
                                                            </td>
                                                            <td style="width: 20;padding-left:3px;"><input TabIndex="7" id="btnForCreditor" runat="server" type="button" value="..." style="width: 100%;font-size:10px"/><input type="hidden" id="hdnForCreditor" runat="server" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">
                                                    Creditor:
                                                </td>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="font-size: 11px; font-family: Tahoma;width:200px">
                                                        <tr>
                                                            <td>
                                                                <div id="txtCreditor" runat="server" class="entry" style="padding: 2; border: solid 1px rgb(165,172,178);">&nbsp;</div>
                                                            </td>
                                                            <td style="width: 20;padding-left:3px;"><input TabIndex="8" id="btnCreditor" runat="server" type="button" value="..." style="width: 100%;font-size:10px"/><input type="hidden" id="hdnCreditor" runat="server" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
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
                                                        <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String)%>');">
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
    <table runat="server" id="tblMessage" style="color:#666666;display:none;font-family:tahoma;font-size:13px;" border="0" cellpadding="0" cellspacing="15"><tr><td></td><td><img src="~/images/loading.gif" runat="server" align="absmiddle" border="0" /></td></tr></table>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <input id="hdnCurrentDoc" type="hidden" runat="server" />
    <input id="hdnTempAccountID" type="hidden" runat="server" />

    <asp:CheckBox runat="server" id="chkIsVerified" style="display:none;"></asp:CheckBox>
    <asp:CheckBox runat="server" id="chkAddFee" style="display:none;"></asp:CheckBox>
    <asp:CheckBox runat="server" id="chkRetainerFee" style="display:none;"></asp:CheckBox>

    <asp:HiddenField runat="server" id="txtAddFee"></asp:HiddenField>
    <asp:HiddenField runat="server" id="txtRetainerFee"></asp:HiddenField>

    <asp:LinkButton ID="lnkShowDocs" runat="server" />
    <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    
    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
</body>

</asp:Content>