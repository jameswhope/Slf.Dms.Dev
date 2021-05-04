<%@ Page Language="VB" MasterPageFile="~/Clients/client/client.master" AutoEventWireup="false" CodeFile="account.aspx.vb" Inherits="clients_client_accounts_account" Title="DMP - Client - Account"  EnableEventValidation="false"%>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ Register Src="~/CustomTools/UserControls/CreditorHarassmentFormControl.ascx" TagName="harassment" TagPrefix="hc1" %>
<%@ Register Assembly="Infragistics2.Web.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.Web.UI.LayoutControls" TagPrefix="ig" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>

    <body onunload="javascript:verifyCheck();" style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top; background-repeat: repeat-x;" >
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
                width: 100;
            }
          
        </style>

        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\controls\grid.js") %>"></script>

        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

        <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

        <script type="text/javascript">

    var txtVerifiedAmount = null;
    var lblVerifiedRetainerFee = null;
    var chkVerifiedFee = null;
    
    var chkRemoveModifyFees = null;
    var chkRemoveAdditional = null;
    var chkRemoveSettlement = null;
    var chkRemoveRetainer = null;
    var chkRemoveRetainerAll = null;
    var txtRemoveAmount = null;
    var txtRemovePercent = null;
    var txtAccountStatusID = null;

    var tblBody = null;
    var tblMessage = null;

    function txtVerifiedAmount_OnKeyUp(txt)
    {
        LoadControls();

        var VerifiedAmount = 0.0;
        var VerifiedFeePercentage = <%= SetupFeePercentage %>;
        var VerifiedRetainerFee = 0.0;

        VerifiedAmount = parseFloat(txtVerifiedAmount.value);
        VerifiedRetainerFee = VerifiedAmount * VerifiedFeePercentage;

        lblVerifiedRetainerFee.innerHTML = FormatNumber(VerifiedRetainerFee, true, 2);
    }
    function VerifyConfirm()
    {
        if (VerifyRequiredExist())
        {
            var VerifiedAmount = 0.0;

            VerifiedAmount = parseFloat(txtVerifiedAmount.value);

            showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?id=" & ClientID & "&aid=" & AccountID & "&t=Account Verification&p=") %><%= ResolveUrl("~/clients/client/creditors/accounts/action/verify.aspx") %>" + "&a=" + VerifiedAmount, window, "status:off;help:off;dialogWidth:350px;dialogHeight:250px");
            
            
        }
    }
    function VerifyWithAction()
    {
        chkVerifiedFee.checked = true;

        // postback to verify
        Record_Display("Locking verification...");
        <%= Page.ClientScript.GetPostBackEventReference(lnkVerify, Nothing) %>;
    }
    function VerifyWithoutAction()
    {
        chkVerifiedFee.checked = false;

        // postback to verify
        Record_Display("Locking verification...");
        <%= Page.ClientScript.GetPostBackEventReference(lnkVerify, Nothing) %>;
    }
    function VerifyRequiredExist()
    {
        LoadControls();

        RemoveBorder(txtVerifiedAmount);

        if (txtVerifiedAmount.value.length == 0)
        {
            ShowMessage("In order to verify this account, you must enter a verification amount.");
            AddBorder(txtVerifiedAmount);
            return false;
        }
        else if (!IsValidNumberFloat(txtVerifiedAmount.value, false, txtVerifiedAmount))
        {
            ShowMessage("The Verification Amount you entered was invalid.  Please enter a non-zero, dollar amount.");
            AddBorder(txtVerifiedAmount);
            return false;
        }

        HideMessage();
        return true;
    }
    function LoadControls()
    {
        if (txtVerifiedAmount == null)
        {
            txtVerifiedAmount = document.getElementById("<%= txtVerifiedAmount.ClientID %>");
            lblVerifiedRetainerFee = document.getElementById("<%= lblVerifiedRetainerFee.ClientID %>");
            chkVerifiedFee = document.getElementById("<%= chkVerifiedFee.ClientID %>");

            chkRemoveModifyFees = document.getElementById("<%= chkRemoveModifyFees.ClientID %>");
            chkRemoveAdditional = document.getElementById("<%= chkRemoveAdditional.ClientID %>");
            chkRemoveSettlement = document.getElementById("<%= chkRemoveSettlement.ClientID %>");
            chkRemoveRetainer = document.getElementById("<%= chkRemoveRetainer.ClientID %>");
            chkRemoveRetainerAll = document.getElementById("<%= chkRemoveRetainerAll.ClientID %>");
            txtRemoveAmount = document.getElementById("<%= txtRemoveAmount.ClientID %>");
            txtRemovePercent = document.getElementById("<%= txtRemovePercent.ClientID %>");
            txtAccountStatusID = document.getElementById("<%= txtAccountStatusID.ClientID %>");

            tblBody = document.getElementById("<%= tblBody.ClientID %>");
            tblMessage = document.getElementById("<%= tblMessage.ClientID %>");
        }
    }
    function aRemoveCreditor_Click(e)
    {
        var a = e.srcElement;
        a.previousSibling.style.display="none";
        a.previousSibling.previousSibling.creditorid=null;
    }
    function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        Record_Display("Closing...");
        <%= Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
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
	function Record_RemoveConfirm()
	{
        showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?id=" & ClientID & "&aid=" & AccountID & "&t=Remove Account&p=") %><%= ResolveUrl("~/clients/client/creditors/accounts/action/remove.aspx") %>", window, "status:off;help:off;dialogWidth:550px;dialogHeight:450px;");
	}
	function Record_Remove(ModifyFees, Additional, Settlement, Retainer, All, Amount, Percent)
	{
	    LoadControls();

        chkRemoveModifyFees.checked = ModifyFees;
        chkRemoveAdditional.checked = Additional;
        chkRemoveSettlement.checked = Settlement;
        chkRemoveRetainer.checked = Retainer;
        chkRemoveRetainerAll.checked = All;
        txtRemoveAmount.value = Amount;
        txtRemovePercent.value = Percent;

        // postback to remove
        Record_Display("Removing account...");
        <%= Page.ClientScript.GetPostBackEventReference(lnkRemove, Nothing) %>;
	}
	function Record_SettleConfirm()
	{
        showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?id=" & ClientID & "&aid=" & AccountID & "&t=Settle Account&p=") %><%= ResolveUrl("~/clients/client/creditors/accounts/action/settle.aspx") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
	}
	function Record_Settle()
	{
	    LoadControls();

        // postback to settle
        Record_Display("Settling account...");
        <%= Page.ClientScript.GetPostBackEventReference(lnkSettle, Nothing) %>;
	}
	function CI_DeleteConfirm(obj)
	{
        if (!document.getElementById("<%= lnkDeleteConfirm.ClientID() %>").disabled)
        {
            showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx?f=CI_Delete&t=Delete Creditor Instances&m=Are you sure you want to delete this selection of creditor instances?") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
        }
	}
	function CI_Delete()
    {
        Record_Display("Deleting creditor instance...");
	    <%= Page.ClientScript.GetPostBackEventReference(lnkDeleteCI, Nothing) %>;
    }
	function Record_DeleteConfirm()
	{
        showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?id=" & ClientID & "&aid=" & AccountID & "&t=Delete Account&p=") %><%= ResolveUrl("~/clients/client/creditors/accounts/action/delete.aspx") %>", window, "status:off;help:off;dialogWidth:550px;dialogHeight:450px;");
	}
	function Record_Delete(ModifyFees, Additional, Settlement, Retainer, All, Amount, Percent)
    {
	    LoadControls();

        chkRemoveModifyFees.checked = ModifyFees;
        chkRemoveAdditional.checked = Additional;
        chkRemoveSettlement.checked = Settlement;
        chkRemoveRetainer.checked = Retainer;
        chkRemoveRetainerAll.checked = All;
        txtRemoveAmount.value = Amount;
        txtRemovePercent.value = Percent;

        // postback to delete
        Record_Display("Deleting account...");
        <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function Record_ChangeStatusConfirm()
    {
        showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?id=" & ClientID & "&aid=" & AccountID & "&t=Change Account Status&p=") %><%= ResolveUrl("~/clients/client/creditors/accounts/action/changestatus.aspx") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");    }
    function Record_ChangeStatus(AccountStatusID)
    {
	    LoadControls();

        txtAccountStatusID.value = AccountStatusID;

        // postback to change status
        Record_Display("Changing status...");
        <%= Page.ClientScript.GetPostBackEventReference(lnkChangeStatus, Nothing) %>;
    }
    function Record_Display(Message)
    {
        LoadControls();

        tblBody.style.display = "none";
        tblMessage.style.display = "inline";
        tblMessage.rows[0].cells[0].innerHTML = Message;
    }
    
    function PrintLetter(ltrType){
    
        switch(ltrType)
        {
        case "date":
            <%= Page.ClientScript.GetPostBackEventReference(lnkDemandDate, Nothing) %>;
            break;
        case "nondate":
            <%= Page.ClientScript.GetPostBackEventReference(lnkDemandNonDate, Nothing) %>;
            break;
        }
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
            
            var relID = <%=AccountID %>;
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=ClientID %>&type=account&rel=<%=AccountID %>', 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
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
            scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=account&rel=<%=AccountID %>', 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
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
<script type="text/javascript" language="javascript">
    function verifyCheck() {
                if ('<%= bVerifiedAccount %>' != 'True') {
                    var result = confirm('This account is not yet verified. Would you like to verify this account? (Press Ok to go back and verify, Cancel to continue leaving page.)');
                    if (result == true) {
                        var url = 'account.aspx?id=<%=ClientID %>&aid=<%=AccountID %>'
                        window.location = url
                    }
                }
            }
</script>
        <script type="text/javascript" language="javascript">
        var intFade;
        var intMenu;
        var j = 0;
        var h = 0;
        function ShowLetterLinks(objChk,validated)
        {
            if (objChk.checked == true && validated != 'False')
            {
                document.getElementById("<%= lnkDemandDateSpecific.ClientID() %>").disabled = false;
                document.getElementById("<%= lnkDemandNonDateSpecific.ClientID() %>").disabled = false;
                document.getElementById("<%= txtDemandDate.ClientID() %>").disabled = false;
                document.getElementById("<%= lnkNonRepLetter.ClientID() %>").disabled = false;
                document.getElementById("<%= lnkLetterOfRep.ClientID() %>").disabled = false;
            }
            else
            {
                document.getElementById("<%= lnkDemandDateSpecific.ClientID() %>").disabled = true;
                document.getElementById("<%= lnkDemandNonDateSpecific.ClientID() %>").disabled = true;
                document.getElementById("<%= txtDemandDate.ClientID() %>").disabled = true;
                document.getElementById("<%= lnkNonRepLetter.ClientID() %>").disabled = true;
                document.getElementById("<%= lnkLetterOfRep.ClientID() %>").disabled = true;
            }
        }
        
        function PrintLetter(ltrType)
        {
            var strReports = '';
            var i = 0;
            switch(ltrType)
            {
                case "ltrrep":
                    if (document.getElementById("<%= lnkNonRepLetter.ClientID() %>").disabled !=true)
                    {
                        var creds = document.getElementById('<%=txtSelectedIDs.ClientID %>');
                        var strCreds = creds.value;

                        if (strCreds.indexOf(",") > 0)
                        {
                            var aCreds = strCreds.split(",");
                            for (i = 0; i < aCreds.length; i++)
                            {
                            strReports += 'LetterOfRepresentation_' + aCreds[i] + ',';
                            }
                            strReports = strReports.substr(0,strReports.length-1)
                        }
                        else
                            {
                            strReports += 'LetterOfRepresentation_' + strCreds;
                            }
                        ViewReport(strReports);
                    }                    
                
                    break;
                case "nonrep":
                    if (document.getElementById("<%= lnkNonRepLetter.ClientID() %>").disabled !=true)
                    {
                        var creds = document.getElementById('<%=txtSelectedIDs.ClientID %>');
                        var strCreds = creds.value;

                        if (strCreds.indexOf(",") > 0)
                        {
                            var aCreds = strCreds.split(",");
                            for (i = 0; i < aCreds.length; i++)
                            {
                            strReports += 'NonRepresentationOfDebtLetter_' + aCreds[i] + ',';
                            }
                            strReports = strReports.substr(0,strReports.length-1)
                        }
                        else
                            {
                            strReports += 'NonRepresentationOfDebtLetter_' + strCreds;
                            }
                        ViewReport(strReports);
                    }                    
                
                    break;
                case "date":
                    if (document.getElementById("<%= lnkDemandDateSpecific.ClientID() %>").disabled !=true)
                    {
                        var txtDate = document.getElementById('<%=txtDemandDate.ClientID %>');
                        var creds = document.getElementById('<%=txtSelectedIDs.ClientID %>');
                        var strCreds = creds.value;
                        if (txtDate.value == ''){
                            ShowMessage('A date is required');
                            return;
                        }
                        HideMessage;

                        if (strCreds.indexOf(",") > 0)
                        {
                            var aCreds = strCreds.split(",");
                            for (i = 0; i < aCreds.length; i++)
                            {
                            strReports += 'DemandDateSpecificLetter_' + aCreds[i] + '_' + txtDate.value + ',';
                            }
                            strReports = strReports.substr(0,strReports.length-1)
                        }
                        else
                            {
                            strReports += 'DemandDateSpecificLetter_' + strCreds + '_' + txtDate.value;
                            }
                        ViewReport(strReports);
                    }
                    break;
                case "nondate":
                    if (document.getElementById("<%= lnkDemandNonDateSpecific.ClientID() %>").disabled !=true)
                    {
                        var creds = document.getElementById('<%=txtSelectedIDs.ClientID %>');
                        var strCreds = creds.value;

                        if (strCreds.indexOf(",") > 0)
                        {
                            var aCreds = strCreds.split(",");
                            for (i = 0; i < aCreds.length; i++)
                            {
                            strReports += 'DemandNonDateSpecificLetter_' + aCreds[i] + ',';
                            }
                            strReports = strReports.substr(0,strReports.length-1)
                        }
                        else
                            {
                            strReports += 'DemandNonDateSpecificLetter_' + strCreds;
                            }
                        ViewReport(strReports);
                    }                    
                    break;
                    
            }
            
            
        }       
        
        function ViewReport(reports)
        {
            grayOut(true, '?clientid=' + <%=ClientID.ToString() %> + '&reports=' + reports + '&user=' + <%=UserID.ToString() %>);
        }
        function CloseReport()
        {
            grayOut(false);
        }
        function grayOut(vis, query)
        {
            var dark = document.getElementById('darkenScreenObject');
            var pageWidth;
            var pageHeight;
            
            if (!dark)
            {
                var tbody = document.getElementsByTagName('body')[0];
                var tnode = document.createElement('div');
                tnode.style.position = 'absolute';
                tnode.style.top = '0px';
                tnode.style.left = '0px';
                tnode.style.overflow = 'hidden';
                tnode.style.display = 'none';
                tnode.id = 'darkenScreenObject';
                tbody.appendChild(tnode);
                dark = document.getElementById('darkenScreenObject');
            }
            if (vis)
            {
                if (document.body && (document.body.scrollWidth || document.body.scrollHeight))
                {
                    pageWidth = document.body.scrollWidth + 'px';
                    pageHeight = document.body.scrollHeight + 'px';
                }
                else if (document.body.offsetWidth)
                {
                    pageWidth = document.body.offsetWidth + 'px';
                    pageHeight = document.body.offsetHeight + 'px';
                }
                else
                {
                    pageWidth = '100%';
                    pageHeight = '100%';
                }
                
                dark.style.opacity = .1;
                dark.style.MozOpacity = .1;
                dark.style.filter = 'alpha(opacity=' + 1 + ')';
                dark.innerHTML = "<div id=\"dvCloseMenu\" style=\"position:absolute;left:0px;top:-30px;width:100%;height:25px;background-color:white;\"><a href=\"\" id=\"dvCloseReport\" class=\"lnk\" onclick=\"javascript:CloseReport();\" style=\"visibility:visible;font-weight:bold;\">Close</a></div><div id=\"dvReport\" style=\"position:relative;width:725px;height:550px;z-index:51;visibility:hidden;background-color:Transparent;\"><iframe src=\"../../reports/report.aspx" + query + "\" style=\"width:100%;height:95%;\" frameborder=\"0\" /></div>";
                dark.style.zIndex = 50;
                dark.style.backgroundColor = '#000000';
                dark.style.width = pageWidth;
                dark.style.height = pageHeight;
                dark.style.verticalAlign = 'middle';
                dark.style.textAlign = 'center';
                dark.style.margin = 'auto';
                dark.style.display = 'inline';
                
                j = 0;
                //intFade = setInterval('FadingIn()', 10);
                ///////////////////////////////////////////////////////////////
                dark.style.opacity = .70;
                dark.style.MozOpacity = .70;
                dark.style.filter = 'alpha(opacity=70)';
                
                var report = document.getElementById('dvReport');
                report.style.top = (window.screen.height / 2) - 350;
                report.style.verticalAlign = 'middle';
                report.style.textAlign = 'center';
                report.style.margin = 'auto';
                report.style.visibility = 'visible';
                intMenu = setInterval('DropMenu()', 15);
                h = -30;
                ///////////////////////////////////////////////////////////////
            }
            else
            {
                dark.style.display = 'none';
                window.location.reload();
            }
        }
        function FadingIn()
        {
            var dark = document.getElementById('darkenScreenObject');
            
            if (j < 70)
            {
                dark.style.opacity = j / 100;
                dark.style.MozOpacity = j / 100;
                dark.style.filter = 'alpha(opacity=' + j + ')';
                
                j = j + 4;
            }
            else
            {
                clearInterval(intFade);
                var report = document.getElementById('dvReport');
                report.style.top = (window.screen.height / 2) - 350;
                report.style.verticalAlign = 'middle';
                report.style.textAlign = 'center';
                report.style.margin = 'auto';
                report.style.visibility = 'visible';
                intMenu = setInterval('DropMenu()', 15);
                h = -30;
            }
        }
        function DropMenu()
        {
            if (h < 0)
	        {
	            h = h + 2;
	            document.getElementById('dvCloseMenu').style.top = h;
	        }
	        else
	        {
	            clearInterval(intMenu);
	        }
        }
        
        </script>

        <asp:ScriptManager ID="smAcct" runat="server" EnablePartialRendering="true" ScriptMode="Release">
        </asp:ScriptManager>
      
                <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="font-size:11px;color:#666666;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkPersons" runat="server" class="lnk" style="font-size:11px;color:#666666;">Accounts</a>&nbsp;>&nbsp;<span id="lnkAccount" runat="server" style="font-size:11px;color:#666666;"></span></td>
        </tr>
        <tr>
            <td valign="top">
                <table style="width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
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
                        <td valign="top">
                            <table style="width:100%;" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td valign="top">
                                        <div style="font-size:18px;border-bottom:solid 1px #b3b3b3;padding:5;" colspan="2"><asp:Label runat="server" ID="lblName"></asp:Label></div>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                            <tr>
                                                <td class="entrytitlecell">Current Due:</td>
                                                <td><asp:Label runat="server" id="lblCurrentAmount"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Current Status:</td>
                                                <td><asp:Label runat="server" id="lblCurrentStatus">&nbsp;</asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Original Account #:</td>
                                                <td><asp:Label runat="server" id="lblAccountNumber"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Originally Due:</td>
                                                <td><asp:Label ID="lblOriginalDueDate" runat="server"></asp:Label></td>
                                            </tr>
                                            <tr id="trSettlementFeeCredit" runat="server" visible="false">
                                                <td class="entrytitlecell">Settlement Credit:</td>
                                                <td><asp:Label runat="server" id="lblSettlementFeeCredit"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width:25;"><img runat="server" src="~/images/spacer.gif" width="25" height="1" border="0"/></td>
                                    <td style="width:375;height:100%;" valign="top">
                                        <table runat="server" id="tblVerification" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="height:23;width:100%;">
                                                    <table style="background-color:#d3d3d3;width:100%;font-size:11px;font-family:Tahoma;" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td style="width:21;" valign="top"><img border="0" src="~/images/corner_gray_lt.gif" runat="server"/></td>
                                                            <td align="center"><img style="margin-right:3;" align="absmiddle" border="0" src="~/images/16x16_lock.png" runat="server"/>Balance Verification</td>
                                                            <td style="width:21;"><img border="0" src="~/images/corner_gray_rt.gif" runat="server"/></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" style="">
                                                    <table style="font-size:11px;border-right:solid 1px #d3d3d3;border-left:solid 1px #d3d3d3;border-bottom:solid 1px #d3d3d3;" border="0" cellpadding="0" cellspacing="0" style="width:100%;">
                                                        <tr>
                                                            <td>
                                                                <table style="font-size:11px;background-color:#f1f1f1;" border="0" cellpadding="5" cellspacing="0" style="width:100%;">
                                                                    <tr>
                                                                        <td align="center" style="border-bottom:solid 1px #d3d3d3;">Original</td>
                                                                        <td align="center" style="border-bottom:solid 1px #d3d3d3;border-left:solid 1px #d3d3d3;">Verified</td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div style="width:100%;padding:15;">
                                                                <table style="width:100%;font-size:11px;" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td style="width:80;padding:4 0 4 0;">Amount:</td>
                                                                        <td style="width:10;">$</td>
                                                                        <td style="width:55;" align="right"><asp:label runat="server" id="lblUnverifiedAmount"></asp:label></td>
                                                                        <td>&nbsp;</td>
                                                                        <td style="width:80;">Amount:</td>
                                                                        <td style="width:10;">$</td>
                                                                        <td style="width:55;padding:0;" align="right"><asp:textbox style="text-align:right;" class="entry" runat="server" id="txtVerifiedAmount"></asp:textbox><asp:label runat="server" id="lblVerifiedAmount"></asp:label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td nowrap="true" style="width:80;padding:4 0 4 0;">Retainer&nbsp;(<asp:label runat="server" id="lblOriginalRetainerFeePercentage"></asp:label>):</td>
                                                                        <td style="width:10;">$</td>
                                                                        <td style="width:55;" align="right"><asp:label class="entry" runat="server" id="lblUnverifiedRetainerFee"></asp:label></td>
                                                                        <td>&nbsp;</td>
                                                                        <td nowrap="true" style="width:80;">Retainer&nbsp;(<asp:label runat="server" id="lblVerifiedRetainerFeePercentage2"></asp:label>):</td>
                                                                        <td style="width:10;">$</td>
                                                                        <td style="width:55;" align="right"><asp:label class="entry" runat="server" id="lblVerifiedRetainerFee"></asp:label></td>
                                                                    </tr>
                                                                </table>
                                                                </div>
                                                                <asp:panel id="pnlVerificationAction" runat="server" style="background-color:#f1f1f1;padding:8 0 8 0;text-align:center;">
                                                                    <a runat="server" href="javascript:VerifyConfirm();" class="lnk"><img border="0" align="absmiddle" runat="server" src="~/images/16x16_arrowright_clear.png" style="margin-right:5;"/>Click Here to Submit Verification</a></asp:panel>
                                                                <asp:panel id="pnlVerificationDisplay" runat="server" style="background-color:#d3d3d3;padding:8 0 8 0;text-align:center;">
                                                                    This account was verified on&nbsp;<asp:Label runat="server" id="lblVerified"></asp:Label>&nbsp;by&nbsp;<asp:Label runat="server" id="lblVerifiedBy"></asp:Label>
                                                                    <asp:Label ID="lblSpacer" runat="server" Text="    |    " /><asp:linkbutton ID="ckUnverify" runat="server" Visible="false" Text="Un-Verify" OnClick="UnVerify_Click" />
                                                                </asp:panel>
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
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="0" cellpadding="0" border="0">
                                <tr><td><asi:tabstrip runat="server" id="tsTabStrip"></asi:tabstrip></td></tr>
                                <tr>
                                    <td>
                                        <div id="dvTab0" runat="server" style="padding-top:10;">
                                            <table style="margin-top:15;background-color:#f3f3f3;font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="padding:5 7 5 7;color:rgb(50,112,163);">Creditor Instances</td>
                                                    <td style="padding-right:7;" align="right">
                                                        <a style="color:rgb(51,118,171);" href="<%=ResolveURL("~/clients/client/creditors/accounts/creditorinstance.aspx?a=a&id=" & ClientID & "&aid=" & AccountID) %>" class="lnk">Change Current Creditor</a>&nbsp;|&nbsp;<a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="#" onmouseup="javascript:CI_DeleteConfirm(this);">Delete</a>
                                                   </td>
                                                </tr>
                                            </table>
                                            <table onmouseover="Grid_RowHover(this, true)" onmouseout="Grid_RowHover(this,false)" class="list" style="font-family:tahoma;font-size:11px;width:100%;" cellspacing="0" cellpadding="3">
                                                <colgroup>
                                                    <col align="center"/>
                                                    <col align="center"/>
                                                    <col align="left"/>
                                                    <col align="left"/>
                                                    <col align="left"/>
                                                    <col align="left"/>
                                                    <col align="left"/>
                                                    <col align="left"/>
                                                    <col align="left"/>
                                                </colgroup>
                                                <thead>
                                                    <tr>
                                                        <th align="center" style="width:20;" class="headItem"><img id="Img1" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img id="Img5" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></th>
                                                        <th style="width: 25;" align="center">
                                                            <img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                        </th>
                                                        <th>Creditor</th>
                                                        <th>For Creditor</th>
                                                        <th>Acquired<img style="margin-left:5;" runat="server" src="~/images/sort-asc.png" border="0" align="absmiddle" /></th>
                                                        <th>Account #</th>
                                                        <th>Reference #</th>
                                                        <th>Original Amt.</th>
                                                        <th>Current Amt.</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:repeater runat="server" id="rpCreditorInstances">
                                                        <itemtemplate>
                                                            <a href="<%#ResolveURL("~/clients/client/creditors/accounts/creditorinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&ciid=" & DataBinder.Eval(Container.DataItem, "CreditorInstanceID"))  %>"
                                                            <tr>
                                                                <td style="width:20;" align="center"><img id="Img6" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img7" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input id="chkCred" onpropertychange="ShowLetterLinks(this, '<%#DataBinder.Eval(Container.DataItem, "Validated") %>');;Grid_CheckOrUncheck(this, <%#DataBinder.Eval(Container.DataItem, "CreditorInstanceID") %>);" style="display:none;" type="checkbox" /></td>
                                                                <td ><img src="<%#ResolveURL("~/images/16x16_accounts.png")%>" border="0"/></td>
                                                                <td><font color='<%#DataBinder.Eval(Container.DataItem, "Color") %>'><%#DataBinder.Eval(Container.DataItem, "CreditorName") %></font>&nbsp;</td>
                                                                <td><%#DataBinder.Eval(Container.DataItem, "ForCreditorName") %>&nbsp;</td>
                                                                <td><%#DataBinder.Eval(Container.DataItem, "Acquired", "{0:MM/dd/yyyy}") %>&nbsp;</td>
                                                                <td><%#Snippet(DataBinder.Eval(Container.DataItem, "AccountNumber")) %>&nbsp;</td>
                                                                <td><%#Snippet(DataBinder.Eval(Container.DataItem, "ReferenceNumber")) %>&nbsp;</td>
                                                                <td><%#DataBinder.Eval(Container.DataItem, "OriginalAmount", "{0:c}") %>&nbsp;</td>
                                                                <td><%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}") %>&nbsp;</td>
                                                            </tr>
                                                            </a>
                                                        </itemtemplate>
                                                    </asp:repeater>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <td colspan="9">
                                                        <a class="lnk" onclick="javascript:PrintLetter('date');" id="lnkDemandDateSpecific" disabled="true" runat="server" href="#">Print Creditor Demand Letter (Date Specific)</a><cc1:InputMask class="entry" runat="server" Mask="nn/nn/nnnn" Width="75" ID="txtDemandDate" />&nbsp;|&nbsp;
                                                        <a class="lnk" onclick="javascript:PrintLetter('nondate');" id="lnkDemandNonDateSpecific" disabled="true" runat="server" href="#">Print Creditor Demand Letter (Non-Date Specific)</a>&nbsp;|&nbsp;
                                                        <a class="lnk" onclick="javascript:PrintLetter('nonrep');" id="lnkNonRepLetter" disabled="true" runat="server" href="#">Non Representation of Debt Letter</a>&nbsp;|&nbsp;
                                                        <a class="lnk" onclick="javascript:PrintLetter('ltrrep');" id="lnkLetterOfRep" disabled="true" runat="server" href="#">Letter Of Representation</a>&nbsp;|&nbsp;
                                                        <hc1:harassment ID="Harassment1" runat="server" />
                                                        </td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                            <input type="hidden" runat="server" id="txtSelectedIDs"/><input type="hidden" value="<%= lnkDeleteConfirm.ClientId%>"/>
                                        </div>
                                        <div id="dvTab1" runat="server" style="padding-top:10;display:none">
                                        
                                        </div>
                                        <div id="dvTab2" runat="server" style="padding-top:10;display:none">
                                        </div>
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
                <asp:UpdatePanel ID="updDocs" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
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
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="Harassment1" EventName="ReloadDocuments" />
                    </Triggers>
                </asp:UpdatePanel>
            </td>
        </tr>
    </table>
                <table runat="server" id="tblMessage" style="color: #666666; display: none; font-family: tahoma; font-size: 13px;" border="0" cellpadding="0" cellspacing="15">
                    <tr>
                        <td>
                        </td>
                        <td>
                            <img src="~/images/loading.gif" runat="server" align="absmiddle" border="0" />
                        </td>
                    </tr>
                </table>
           
        <%-- <asp:dropdownlist runat="server" id="cboCreditors" style="display:none;"></asp:dropdownlist>--%>
        <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
        <asp:CheckBox runat="server" ID="chkVerifiedFee" Style="display: none;"></asp:CheckBox>
        <asp:CheckBox runat="server" ID="chkRemoveModifyFees" Style="display: none;"></asp:CheckBox>
        <asp:CheckBox runat="server" ID="chkRemoveAdditional" Style="display: none;"></asp:CheckBox>
        <asp:CheckBox runat="server" ID="chkRemoveSettlement" Style="display: none;"></asp:CheckBox>
        <asp:CheckBox runat="server" ID="chkRemoveRetainer" Style="display: none;"></asp:CheckBox>
        <asp:CheckBox runat="server" ID="chkRemoveRetainerAll" Style="display: none;"></asp:CheckBox>
        <input type="hidden" runat="server" id="txtCreditorInstances" />
        <input type="hidden" runat="server" id="txtRefundFee" />
        <input type="hidden" runat="server" id="txtRemoveAmount" />
        <input type="hidden" runat="server" id="txtRemovePercent" />
        <input type="hidden" runat="server" id="txtAccountStatusID" />
        <asp:LinkButton runat="server" ID="lnkShowDocs" />
        <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
        <asp:LinkButton runat="server" ID="lnkDelete" />
        <asp:LinkButton runat="server" ID="lnkDeleteCI" />
        <asp:LinkButton runat="server" ID="lnkVerify" />
        <asp:LinkButton runat="server" ID="lnkRemove" />
        <asp:LinkButton runat="server" ID="lnkChangeStatus" />
        <asp:LinkButton runat="server" ID="lnkSettle" />
        <asp:LinkButton runat="server" ID="lnkDemandDate" />
        <asp:LinkButton runat="server" ID="lnkDemandNonDate" />
        <input id="hdnCurrentDoc" type="hidden" runat="server" />
        <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    </body>
</asp:Content>
