<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="creditorinstance.aspx.vb" Inherits="clients_client_accounts_creditorinstance" title="DMP - Client - Account" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

    <style type="text/css">
        .entrycell {  }
        .entrytitlecell { width:85; }
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var txtAcquired = null;
    var txtAccountNumber = null;
    var txtOriginalAmount = null;
    var txtCurrentAmount = null;
    var hdnCreditor = null;
    var txtCreditor = null;

    var tblBody = null;
    var tblMessage = null;

    function Record_CancelAndClose()
    {
        // postback to cancel and close
        Record_Display("Closing...");
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_Save()
    {
        if (Record_RequiredExist())
        {
            // postback to save
            Record_Display("Saving instance...");
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
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
	function LoadControls()
	{
	    if (txtAcquired == null)
	    {
	        txtAcquired = document.getElementById("<%=txtAcquired.ClientiD %>");
	        txtAccountNumber = document.getElementById("<%=txtAccountNumber.ClientiD %>");
	        txtOriginalAmount = document.getElementById("<%=txtOriginalAmount.ClientiD %>");
	        txtCurrentAmount = document.getElementById("<%=txtCurrentAmount.ClientiD %>");
	        hdnCreditor = document.getElementById("<%=hdnCreditor.ClientiD %>");
	        txtCreditor = document.getElementById("<%=txtCreditor.ClientiD %>");

            tblBody = document.getElementById("<%= tblBody.ClientID %>");
            tblMessage = document.getElementById("<%= tblMessage.ClientID %>");
        }
	}
    function Record_RequiredExist()
    {
        LoadControls();

        if (!IsValidDateTime(txtAcquired.value))
        {
            ShowMessage("Invalid Acquired date.  The Acquired field is required.");
            AddBorder(txtAcquired);
            return false;
        }
        else
        {
            RemoveBorder(txtAcquired);
        }
        
        if (txtAccountNumber.value.length == 0)
        {
            ShowMessage("The Account Number field is required.");
            AddBorder(txtAccountNumber);
            return false;
        }
        else
        {
            RemoveBorder(txtAccountNumber);
        }
        
        if (txtOriginalAmount.value.length == 0)
        {
            ShowMessage("The Original Amount field is required.");
            AddBorder(txtOriginalAmount);
            return false;
        }
        else
        {
            RemoveBorder(txtOriginalAmount);
        }
        
        if (txtCurrentAmount.value.length == 0)
        {
            ShowMessage("The Current Amount field is required.");
            AddBorder(txtCurrentAmount);
            return false;
        }
        else
        {
            RemoveBorder(txtCurrentAmount);
        }

        if (hdnCreditor.value.length == 0)
        {
            ShowMessage("The Creditor field is required.");
            AddBorder(txtCreditor);
            return false;
        }
        else
        {
            RemoveBorder(txtCreditor);
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
        Record_Display("Deleting instance...");
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
        
        if (validated == 0)
        {
            document.getElementById('<%=dvErrorAccounts.ClientID %>').style.display = '';
            btn.parentElement.previousSibling.firstChild.innerHTML="<font color='red'>"+name+"</font>";
        }
        else 
        {
            document.getElementById('<%=dvErrorAccounts.ClientID %>').style.display = 'none';
            btn.parentElement.previousSibling.firstChild.innerHTML=name;
        }
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

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="font-size:11px;color:#666666;"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;<a id="lnkAccounts" runat="server" class="lnk" style="font-size:11px;color:#666666;">Accounts</a>&nbsp;>&nbsp;<a id="lnkAccount" runat="server" class="lnk" style="font-size:11px;color:#666666;">Account</a>&nbsp;>&nbsp;Creditor Instance</td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr id="NewInfo" runat="server" style="padding-bottom:20px" visible="false">
                        <td>
                            <div class="iboxDiv">
                                <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                    <tr>
                                        <td valign="top" style="width:16;"><img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
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
						                <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
						                <td runat="server" id="tdError"></td>
					                </tr>
				                </table>&nbsp;
				            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:400;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">General Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Acquired:</td>
                                                <td><cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Acquired" required="true" TabIndex="18" cssclass="entry" ID="txtAcquired" runat="server" mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true">Account Number:</td>
                                                <td><input type="text" class="entry" id="txtAccountNumber" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" nowrap="true" style="width:95px">Reference Number:</td>
                                                <td><input type="text" class="entry" id="txtReferenceNumber" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Original Amount:</td>
                                                <td><input type="text" class="entry" id="txtOriginalAmount" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Current Amount:</td>
                                                <td><input type="text" class="entry" id="txtCurrentAmount" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">
                                                    For Creditor:
                                                </td>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="font-size: 11px; font-family: Tahoma;width:300px">
                                                        <tr>
                                                            <td>
                                                                <div id="txtForCreditor" runat="server" style="padding: 2; border: solid 1px rgb(165,172,178);">&nbsp;</div>
                                                            </td>
                                                            <td style="width: 20;padding-left:3px;"><input id="btnForCreditor" runat="server" type="button" value="..." style="width: 100%;font-size:10px"/><input type="hidden" id="hdnForCreditor" runat="server" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">
                                                    Creditor:
                                                </td>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="font-size: 11px; font-family: Tahoma;width:300px">
                                                        <tr>
                                                            <td>
                                                                <div id="txtCreditor" runat="server" class="entry" style="padding: 2; border: solid 1px rgb(165,172,178);">&nbsp;</div>
                                                            </td>
                                                            <td style="width: 20;padding-left:3px;"><input id="btnCreditor" runat="server" type="button" value="..." style="width: 100%;font-size:10px"/><input type="hidden" id="hdnCreditor" runat="server" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <div runat="server" id="dvErrorAccounts" style="display:none;">
                                                        <table style="BORDER: #969696 1px solid; FONT-SIZE: 11px; COLOR: red; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" width="100%" border="0">
	                                                        <tr>
		                                                        <td valign="top" style="width:20;"><img runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
		                                                        <td>
		                                                            There are unvalidated creditors in this creditor instance. These creditors need to be validated before they are used.
		                                                        </td>
	                                                        </tr>
                                                        </table>
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
            </td>
        </tr>
    </table>
    <table runat="server" id="tblMessage" style="color:#666666;display:none;font-family:tahoma;font-size:13px;" border="0" cellpadding="0" cellspacing="15"><tr><td></td><td><img id="Img2" src="~/images/loading.gif" runat="server" align="absmiddle" border="0" /></td></tr></table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    
</asp:Content>


