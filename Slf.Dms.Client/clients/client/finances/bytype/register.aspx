<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="register.aspx.vb" Inherits="clients_client_finances_bytype_register" title="DMP - Client - Register"  EnableEventValidation="false"  %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ Import Namespace="Slf.Dms.Records" %>
<%@ MasterType TypeName="clients_client" %>
<%@ Register src="action/usercontrols/C21Transaction.ascx" tagname="C21Transaction" tagprefix="uc1" %>
<%@ Register src="action/usercontrols/C21TransactionPicker.ascx" tagname="C21TransactionPicker" tagprefix="uc1" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="cc1" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var lblDescription = null;
    var txtDescription = null;

    var pnlEdit = null;
    var pnlSave = null;

    var txtBounce = null;
    var chkBounceCollectFee = null;
    var txtVoid = null;
    var txtHold = null;
    var txtClear = null;
    var hdnReason = null;
    var hdnBReason = null; 

    function Edit()
    {
        LoadControls();

        lblDescription.style.display = "none";
        txtDescription.style.display = "inline";

        pnlEdit.style.display = "none";
        pnlSave.style.display = "inline";
    }
    function Save()
    {
        // postback to save
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
    function Cancel()
    {
        LoadControls();

        lblDescription.style.display = "inline";
        txtDescription.style.display = "none";

        pnlSave.style.display = "none";
        pnlEdit.style.display = "inline";
    }
    function LoadControls()
    {
        if (lblDescription == null)
        {
            lblDescription = document.getElementById("<%=lblDescription.ClientID %>");
            txtDescription = document.getElementById("<%=txtDescription.ClientID %>");
            pnlEdit = document.getElementById("<%=pnlEdit.ClientID %>");
            pnlSave = document.getElementById("<%=pnlSave.ClientID %>");
            txtBounce = document.getElementById("<%=txtBounce.ClientID %>");
            chkBounceCollectFee = document.getElementById("<%=chkBounceCollectFee.ClientID %>");
            txtVoid = document.getElementById("<%=txtVoid.ClientID %>");
            txtHold = document.getElementById("<%=txtHold.ClientID %>");
            txtClear = document.getElementById("<%=txtClear.ClientID %>");
            hdnReason = document.getElementById("<%=hdnReason.ClientID %>");
            hdnBReason = document.getElementById("<%=hdnBReason.ClientID %>"); 
        }
    }
    function RowHover(td, on)
    {
        var tr = td.parentElement;

        if (tr.style.backgroundColor != "rgb(255,230,230)")
        {
            //preceding deposits
            while (tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.previousSibling;
            }
            
            //main row
            if (on)
                tr.style.backgroundColor = "#f3f3f3";
            else
                tr.style.backgroundColor = "#ffffff";
            
            //following deposits
            tr = td.parentElement.nextSibling;
            while (tr != null && tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.nextSibling;
            }
        }
    }
    function RowClick(RegisterID)
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & ClientID & "&rid=") %>" + RegisterID);
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
	function Record_BounceConfirm()
	{
        var url = '<%= ResolveUrl("~/clients/client/finances/bytype/action/bounce.aspx?id=" & ClientID & "&t=Issue A Bounce") %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Issue A Bounce",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 650, width: 600});      
	}
    function Record_Bounce(BounceDate, CollectFee, BReason)
    {
        LoadControls();

        txtBounce.value = BounceDate;
        chkBounceCollectFee.checked = CollectFee;
        hdnBReason.value = BReason; 

        // postback to bounce
        <%= ClientScript.GetPostBackEventReference(lnkBounce, Nothing) %>;
    }
	function Record_VoidConfirm()
	{
        var url = '<%= ResolveUrl("~/clients/client/finances/bytype/action/void.aspx?id=" & ClientID & "&t=Issue A Void") %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Issue A Void",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 550, width: 400});
	}
    function Record_Void(VoidDate, Reason)
    {
        LoadControls();

        txtVoid.value = VoidDate;
        hdnReason.value = Reason;

        // postback to void
        <%= ClientScript.GetPostBackEventReference(lnkVoid, Nothing) %>;
    }
	function Record_HoldConfirm()
	{
         var url = '<%= ResolveUrl("~/clients/client/finances/bytype/action/hold.aspx?id=" & ClientID & "&t=Issue A Hold") %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Issue A Hold",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 500, width: 400});
	}
	function Record_Hold(HoldDate)
	{
        LoadControls();

        txtHold.value = HoldDate;

        // postback to hold
        <%= ClientScript.GetPostBackEventReference(lnkHold, Nothing) %>;
	}
	function Record_ClearConfirm()
	{
        var url = '<%= ResolveUrl("~/clients/client/finances/bytype/action/clear.aspx?id=" & ClientID & "&t=Issue A Clear") %>';
        window.dialogArguments = window;
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Issue A Clear",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 500, width: 400});
	}
	function Record_Clear(ClearDate)
	{
        LoadControls();

        txtClear.value = ClearDate;

        // postback to clear
        <%= ClientScript.GetPostBackEventReference(lnkClear, Nothing) %>;
	}
	function Record_DeleteConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Transaction&m=Are you sure you want to delete this transaction?<br><br>This will also delete any associated fee payments, commission and chargebacks.';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Transaction",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400});
	}
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    
    function ViewC21(DepositId)
    {
        <%=WebDialogC21.getClientID()%>.Open(); 
    }
    
    function MarkC21(DepositId){
    
       <%= ClientScript.GetPostBackEventReference(lnkMarkC21, Nothing) %>;
    }
        
    function HideC21()
    {
         <%=WebDialogC21.getClientID()%>.Close(); 
    }
        
    function AssignC21()
    {
         <%=WebDialogC21Picker.getClientID()%>.Open(); 
    }
    
    function HideC21Picker()
    {
         <%=WebDialogC21Picker.getClientID()%>.Close(); 
    }
    
    function PromptAssignC21()
    {
        if (!document.getElementById("tdTransactionId").innerText)
        {
            alert("No transaction selected.");
            return false;
        }
        else if (confirm("Are you sure you want to assign this check 21 transaction to the current deposit?") == true) {
            <%=WebDialogC21Picker.getClientID()%>.Close(); 
            return true;
        }  
        else return false; 
    }
    
    function PromptUnassign() {

        if (confirm("Are you sure you want to unassign this check 21 transaction from the current deposit?") == true) {
            <%=WebDialogC21.getClientID()%>.Close(); 
            return true;
        }  
        else return false; 
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
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=ClientID %>&type=register&rel=<%=RegisterID %>', 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
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
            scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=register&rel=<%=RegisterID %>', 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
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
            <td style="color:#666666;font-size:13px;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkFinanceRegister" runat="server" class="lnk" style="font-size:11px;color:#666666;">Finances</a></td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv" style="background-color:rgb(213,236,188);">
                    <table class="iboxTable" style="background-color:rgb(213,236,188);" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td valign="top" ><asp:Label runat="server" ID="lblInfoBox"></asp:Label></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width:40%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="font-size:18px;border-bottom:solid 1px #b3b3b3;" colspan="2"><asp:Label runat="server" ID="lblName"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:Label style="float:right;" runat="server" ID="lblAmount"></asp:Label><asp:Label runat="server" ID="lblPostedWord"></asp:Label> on&nbsp;<asp:Label runat="server" ID="lblTransactionDate"></asp:Label>&nbsp;for:&nbsp;</td>
                                </tr>
                                <tr>
                                    <td align="right" runat="server" id="tdFeeAdjustments" colspan="2" visible="false" style="border-top:solid 1px #d3d3d3;padding-right:2;">
                                        <table style="font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="0">
                                            <asp:Repeater runat="server" id="rpFeeAdjustments">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td class="listItem6" style="padding-left:10;" align="left"><%#DataBinder.Eval(Container.DataItem, "AdjustedReason")%></td>
                                                        <td class="listItem6">Adjusted</td>
                                                        <td class="listItem6"><%#rpFeeAdjustments_ArrowDirection(DataBinder.Eval(Container.DataItem, "Amount"))%></td>
                                                        <td class="listItem6"><%#DataBinder.Eval(Container.DataItem, "TransactionDate", "{0:M/d/yyyy h:mm tt}")%></td>
                                                        <td class="listItem6" style="padding-left:10;" align="right"><%#rpFeeAdjustments_Amount(DataBinder.Eval(Container.DataItem, "Amount"))%></td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <tr>
                                                <td class="listItem7" colspan="4" align="right">Total:&nbsp;&nbsp;<asp:Label runat="server" id="lblAmount2"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asi:tabstrip runat="server" id="tsMain"></asi:tabstrip>
                                    </td>
                                </tr>
                                <tr runat="server" id="tr0">
                                    <td colspan="2">
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                            <tr>
                                                <td colspan="2" nowrap="true" style="background-color:#f1f1f1;">General Information</td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Transaction ID:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblRegisterID"></asp:Label></td>
                                            </tr>
                                            <tr runat="server" id="trCheckNumber" visible="false">
                                                <td class="entrytitlecell">Check Number:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblCheckNumber"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Transaction Type:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblEntryTypeName"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Full Date & Time:</td>
                                                <td><asp:Label runat="server" ID="lblTransactionDate2"></asp:Label></td>
                                            </tr>
                                            <tr runat="server" id="trAccount" visible="false">
                                                <td class="entrytitlecell">Creditor Account:</td>
                                                <td><a runat="server" class="lnk" id="aAccount"></a></td>
                                            </tr>
                                            <tr runat="server" id="trFeeMonthYear" visible="false">
                                                <td class="entrytitlecell">Fee Month/Year:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblFeeMonthYear"></asp:Label></td>
                                            </tr>
                                            <tr runat="server" id="trACHMonthYear" visible="false">
                                                <td class="entrytitlecell">ACH Month/Year:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblACHMonthYear"></asp:Label></td>
                                            </tr>
                                            <tr runat="server" id="trMediator" visible="false">
                                                <td class="entrytitlecell">Mediator:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblMediator"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">SDA Balance After:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblSDABalance"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">PFO Balance After:</td>
                                                <td><asp:Label CssClass="entry" runat="server" ID="lblPFOBalance"></asp:Label></td>
                                            </tr>
                                            
                                        </table>
                                    </td>
                                </tr>
                                <tr runat="server" id="tr1">
                                    <td colspan="2">
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                            <tr>
                                                <td colspan="2" nowrap="true" style="background-color:#f1f1f1;"><asp:Panel runat="server" id="pnlEdit">Description&nbsp;&nbsp;-&nbsp;&nbsp;<a id="A1" class="lnk" runat="server" href="javascript:Edit()"><img id="Img1" style="margin-right:3;" runat="server" src="~/images/16x16_dataentry.png" border="0" align="absmiddle" />Edit</a></asp:Panel><asp:Panel style="display:none;" runat="server" id="pnlSave">Description&nbsp;&nbsp;-&nbsp;&nbsp;<a id="A2" class="lnk" runat="server" href="javascript:Save()"><img id="Img3" style="margin-right:3;" runat="server" src="~/images/16x16_save.png" border="0" align="absmiddle" />Save</a>&nbsp;|&nbsp;<a id="A3" class="lnk" runat="server" href="javascript:Cancel()"><img id="Img4" style="margin-right:3;" runat="server" src="~/images/16x16_cancel.png" border="0" align="absmiddle" />Cancel</a></asp:Panel></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2"><asp:Label runat="server" id="lblDescription"></asp:Label><asp:TextBox style="display:none;width:100%;" Rows="7" CssClass="entry" runat="server" id="txtDescription" TextMode="MultiLine"></asp:TextBox></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td><img height="1" width="30" runat="server" src="~/images/spacer.gif" /></td>
                        <td style="width:60%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr><td style="padding: 5 5 5 5;background-color:#f1f1f1;"><asp:Label runat="server" id="lblPaymentsHeader"></asp:Label></td></tr>
                                <tr>
                                    <td>
                                        <asp:Panel runat="server" id="pnlPaymentsUsedFor">
                                            <table id="tblPaymentsUsedFor" onselectstart="return false;" style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="3" border="0">
		                                        <tr>
		                                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0"/></td>
			                                        <td class="headItem">Date<img style="margin-left:8;" align="absmiddle" runat="server" src="~/images/sort-asc.png" border="0"/></td>
			                                        <td class="headItem" nowrap="true">Fee</td>
			                                        <td class="headItem" align="right" nowrap="true">Total</td>
			                                        <td class="headItem" style="padding-left:10;" nowrap="true">From</td>
			                                        <td class="headItem" nowrap="true">Date</td>
			                                        <td class="headItem" align="right" nowrap="true">Amount</td>
		                                        </tr>
                                                <asp:repeater id="rpPaymentsUsedFor" runat="server">
                                                    <itemtemplate>
                                                        <a class="lnk" href="payment.aspx?id=<%= ClientID %>&rpid=<%#DataBinder.Eval(Container.DataItem, "RegisterPaymentID")%>">
                                                        <tr IsMainRow="true" <%#IIf(DataBinder.Eval(Container.DataItem, "Voided") or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") %>>
                                                            <td valign="top" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" style="width:22;" class="listItem" align="center" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <%#DataBinder.Eval(Container.DataItem, "PaymentDate", "{0:MM/dd/yyyy}")%>&nbsp;
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                This&nbsp;<%#DataBinder.Eval(Container.DataItem, "FeeRegisterEntryTypeName")%>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>" align="right" style="color:rgb(0,139,0);">
                                                                <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>&nbsp;
                                                            </td>
                                                            <asp:repeater runat="server" datasource="<%# CType(Container.DataItem, RegisterPayment).Deposits%>">
                                                                <itemtemplate>
                                                                    <%#IIf(Container.ItemIndex = 0, "", "</tr><tr " & IIf(DataBinder.Eval(Container.DataItem, "Voided") Or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") & ">")%>
                                                                    <td style="padding-left:10;height:24;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                        <a class="lnk" href="register.aspx?id=<%= ClientID %>&rid=<%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterID %>" ><%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterEntryTypeName%></a>
                                                                    </td>
                                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterTransactionDate.ToString("MM/dd/yyyy")%>&nbsp;
                                                                    </td>
                                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" style="color:rgb(0,139,0);" align="right">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).Amount.ToString("c")%>&nbsp;
                                                                    </td>
                                                                </itemtemplate> 
                                                            </asp:repeater>
                                                        </tr>
                                                        </a>
                                                    </itemtemplate>
                                                </asp:repeater>
	                                        </table><br />
	                                        <div nowrap="true" style="text-align:right;">Left&nbsp;to&nbsp;be&nbsp;paid:&nbsp;<asp:label style="color:rgb(255,0,0);" runat="server" id="lblDebitRemaining"></asp:label></div>
	                                    </asp:Panel>
	                                    <asp:Panel runat="server" id="pnlPaymentsMadeWith">
                                            <table id="tblPaymentsMadeWith" onselectstart="return false;" style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="3" border="0">
                                                <tr>
		                                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0"/></td>
			                                        <td class="headItem">Date<img style="margin-left:8;" align="absmiddle" runat="server" src="~/images/sort-asc.png" border="0"/></td>
			                                        <td class="headItem" nowrap="true">Fee</td>
			                                        <td class="headItem" align="right" nowrap="true">Total</td>
			                                        <td class="headItem" style="padding-left:10;" nowrap="true">From</td>
			                                        <td class="headItem" nowrap="true">Date</td>
			                                        <td class="headItem" align="right" nowrap="true">Amount</td>
                                                </tr>
		                                        <asp:Repeater id="rpPaymentsMadeWith" runat="server">
			                                        <ItemTemplate>
			                                            <a class="lnk" href="payment.aspx?id=<%= ClientID %>&rpid=<%#DataBinder.Eval(Container.DataItem, "RegisterPaymentID")%>">
                                                        <tr IsMainRow="true" <%#IIf(DataBinder.Eval(Container.DataItem, "Voided") or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") %>>
                                                            <td valign="top" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" style="width:22;" class="listItem" align="center" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <%#DataBinder.Eval(Container.DataItem, "PaymentDate", "{0:MM/dd/yy}")%>&nbsp;
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <a class="lnk" href="register.aspx?id=<%= ClientID %>&rid=<%#DataBinder.Eval(Container.DataItem, "FeeRegisterID")%>" ><%#DataBinder.Eval(Container.DataItem, "FeeRegisterEntryTypeName")%></a>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>" align="right" style="color:rgb(0,139,0);">
                                                                <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>&nbsp;
                                                            </td>
                                                            <asp:repeater runat="server" datasource="<%# CType(Container.DataItem, RegisterPayment).Deposits%>">
                                                                <itemtemplate>
                                                                    <%#IIf(Container.ItemIndex = 0, "", "</tr><tr " & IIf(DataBinder.Eval(Container.DataItem, "Voided") Or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") & ">")%>
                                                                    <td style="padding-left:10;height:24;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                        <%#IIf(RegisterID = CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterID, "This " & CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterEntryTypeName, "<a class=""lnk"" href=""register.aspx?id=" & DataClientID & "&rid=" & CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterID & """>" & CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterEntryTypeName & "</a>")%>
                                                                    </td>
                                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterTransactionDate.ToString("MM/dd/yy")%>&nbsp;
                                                                    </td>
                                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" style="color:rgb(0,139,0);" align="right">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).Amount.ToString("c")%>&nbsp;
                                                                    </td>
                                                                </itemtemplate> 
                                                            </asp:repeater>
                                                        </tr>
                                                        </a>
			                                        </ItemTemplate>
		                                        </asp:Repeater>
                                            </table><br />
	                                        <div nowrap="true" style="text-align:right;">Left&nbsp;for&nbsp;future&nbsp;payments:&nbsp;&nbsp;<asp:label style="color:rgb(0,149,0);" runat="server" id="lblCreditRemaining"></asp:label></div>
                                        </asp:Panel>
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
    </table>

    <asp:dropdownlist runat="server" id="cboCreditors" style="display:none;"></asp:dropdownlist>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->


    <asp:TextBox runat="server" id="txtBounce" style="display:none;"></asp:TextBox>
    <asp:CheckBox runat="server" id="chkBounceCollectFee" style="display:none;"></asp:CheckBox>
    <asp:TextBox runat="server" id="txtVoid" style="display:none;"></asp:TextBox>
    <asp:TextBox runat="server" id="txtHold" style="display:none;"></asp:TextBox>
    <asp:TextBox runat="server" id="txtClear" style="display:none;"></asp:TextBox>
    
    <asp:LinkButton ID="lnkShowDocs" runat="server" />
    <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
    <asp:LinkButton runat="server" ID="lnkBounce" />
    <asp:LinkButton runat="server" ID="lnkVoid" />
    <asp:LinkButton runat="server" ID="lnkHold" />
    <asp:LinkButton runat="server" ID="lnkClear" />
    <asp:LinkButton runat="server" ID="lnkDelete" />
    <asp:LinkButton runat="server" ID="lnkSave" />
    <asp:LinkButton runat="server" ID="lnkMarkC21" />
    <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    
    <asp:HiddenField ID="hdnCurrentDoc" runat="server" />
    <asp:HiddenField ID="hdnReason" runat="server" />
    <asp:HiddenField ID="hdnBReason" runat="server" /> 
    <cc1:Flyout ID="WebDialogC21" runat="server" Align="LEFT" Position="BOTTOM_CENTER" CloseEvent="NONE" OpenEvent="ONCLICK">
        <div style="text-align: center; position: relative; width: 750px; height: 20px; border: 2px double gray;"" >
            <table style="font-family:tahoma;font-size:11px;width:100%;background-color:rgb(150,230,255);" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td  nowrap="true" style="margin-left: 10px  " >
                        <asp:LinkButton ID="LinkButton1" runat="server" OnClientClick="HideC21();return false;" >Close</asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="lnkUnassign" runat="server" 
                        OnClientClick="return PromptUnassign();" >Unassign</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </div>
        <div style="text-align: center; position: relative; overflow:scroll; width: 750px; height: 450px; border: 2px double gray;"" >
            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td style="background-color:#f1f1f1;">
                        <uc1:C21Transaction ID="C21Transaction1" runat="server" />
                    </td>
                </tr>
             </table> 
        </div>
    </cc1:Flyout>
    <cc1:Flyout ID="WebDialogC21Picker" runat="server" Align="LEFT" Position="BOTTOM_CENTER" CloseEvent="NONE" OpenEvent="ONCLICK" FlyingEffect ="NONE" FadingEffect="false" SlidingEffect="NONE"   IsModal="true" >
       <div style="width: 750px; height: 20px;  border: 2px double gray;"  >
           <table style="font-family:tahoma;font-size:11px;width:100%;background-color:rgb(150,230,255);" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td>
                        <asp:LinkButton ID="lnkAssignC21" runat="server" OnClientClick="return PromptAssignC21();" >Ok</asp:LinkButton>
                        &nbsp;
                        <asp:LinkButton ID="lnkHideC21Picker" runat="server" OnClientClick="HideC21Picker();return false;" >Cancel</asp:LinkButton>
                    </td>
                </tr>
           </table>
       </div>
        <div style="width: 750px; height: 450px; overflow:scroll; border: 2px double gray;" >
            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td  nowrap="true" style="background-color:#f1f1f1; margin-left: 10px  " >
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#f1f1f1;" >
                    Select a Transaction:
                        <uc1:C21TransactionPicker ID="C21TransactionPicker1" runat="server" />
                    </td>
                </tr>
             </table>
         </div> 
    </cc1:Flyout>
    
  </body>
</asp:Content>