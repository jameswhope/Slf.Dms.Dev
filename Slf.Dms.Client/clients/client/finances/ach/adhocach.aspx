<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="adhocach.aspx.vb" Inherits="clients_client_finances_ach_adhocach" title="DMP - Client - ACH & Fee Structure" EnableViewState="true" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body id="bdMain" runat="server" >

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

    var txtDepositDate = null;
    var txtBankRoutingNumber = null;
    var txtBankAccountNumber = null;
    var txtDepositAmount = null;
    
    var Inputs = null;

    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    
    function Record_Save()
    {
     if (ValidateBankSelection() && Record_RequiredExist())
        {
            var clientid = '<%=ClientID %>';
            var adhocachid = '<%=AdHocAchID %>';
            var depositdate = document.getElementById('<%= txtDepositDate.ClientId %>').value;
            
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirmadhoc.aspx")%>?f=RecordSave&t=Save Additional ACH&m=Are you sure you want to save this Additional ACH?' + '&id=' + clientid + '&d=' + depositdate + '&aid=' + adhocachid + '&rand='+Math.floor(Math.random()*99999);
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Save Additional ACH",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        }
    }
    
    function RecordSave()
    {
        // postback to save
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
    
    function ValidateBankSelection(){
        var bn = document.getElementById('<%= ddlBankName.ClientId %>');
        if (bn){
            if ((bn.options[bn.selectedIndex].value == 'select') && (document.getElementById('<%= txtBankRoutingNumber.ClientId %>').value == '')) 
                {   ShowMessage("The Bank Information is required. ");
                    return false;
                }
        } 
        return true;
       
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
	    if (txtDepositDate == null)
	    {
	        txtDepositDate = document.getElementById("<%= txtDepositDate.ClientID() %>");
            txtBankRoutingNumber = document.getElementById("<%= txtBankRoutingNumber.ClientID() %>");
            txtBankAccountNumber = document.getElementById("<%= txtBankAccountNumber.ClientID() %>");
            txtDepositAmount = document.getElementById("<%= txtDepositAmount.ClientID() %>");

            Inputs = new Array();
            Inputs.push(txtDepositDate);
            Inputs.push(txtBankRoutingNumber);
            Inputs.push(txtBankAccountNumber);
            Inputs.push(txtDepositAmount);
	    }
	}
    function Record_RequiredExist()
    {
        LoadControls();

        // remove all display residue
        for (i = 0; i < Inputs.length; i++)
        {
            RemoveBorder(Inputs[i]);
        }

        // validate inputs
        for (i = 0; i < Inputs.length; i++)
        {
            var Input = Inputs[i];

            var Caption = Input.getAttribute("caption");
            var Required = Input.getAttribute("required");
            var Validate = Input.getAttribute("validate");

            if (Required == null)
                Required = "false";

            // check, if required, that content exists
            if (Required.toLowerCase() == "true")
            {
                if (Input.tagName.toLowerCase() == "select")
                {
                    // control is a dropdownlist
                    if (Input.selectedIndex == -1 || Input.options[Input.selectedIndex].value <= 0)
                    {
	                    ShowMessage("The " + Caption + " field is required.");
	                    AddBorderExt(Input);
                        return false;
                    }
                }
                else if (Input.tagName.toLowerCase() == "input")
                {
                    if (Input.type == "text") // textbox
                    {
                        if (Input.value.length == 0)
                        {
	                        ShowMessage("The " + Caption + " field is required.");
	                        AddBorderExt(Input);
                            return false;
                        }
                        if (Input.value <= 0)
                        {
	                        ShowMessage("You can not enter a deposit of $0.00 or less for the " + Caption + ". Use a rule to do this.");
	                        AddBorderExt(Input);
                            return false;
                        }
                    }
                    else if (Input.type == "checkbox") // checkbox
                    {
                    }
                }
            }

            // check, if control is textbox and content exists, that it is valid
            if (Input.tagName.toLowerCase() == "input" && Input.value.length > 0 && Validate.length > 0)
            {
                if (!(eval(Validate)))
                {
                    ShowMessage("The value you entered for " + Caption + " is invalid.");
                    AddBorderExt(Input);
                    return false;
                }
            }
        }

        
        HideMessage()
	    return true;
    }
    
    function AddBorderExt(ctl)
    {
        try{
            AddBorder(ctl);
        }            
        catch(e) {
        //Do nothing
        }
        
    }
    
	function Record_DeleteConfirm()
	{
	    if(document.getElementById('<%= hdnHasNonDeposit.ClientId %>').value=='1'){
	        alert("This additional was created to resolve a non deposit matter. Therefore it cannot be deleted. Please contact IT.");
	    } else {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Additional ACH&m=Are you sure you want to delete this Additional ACH?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Additional ACH",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        }
	}
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function SetToNow(obj)
    {
        obj.value="<%=NextDate %>";
    }
    function IsValidDateTimeMY(str)
    {
        var parts = str.split("/");
        return IsValidDateTime(parts[0] + "/01/" + parts[1]);
    }
    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkFinances" runat="server" class="lnk" style="color: #666666;">Finances</a>&nbsp;>&nbsp;<a id="lnkACH" runat="server" class="lnk" style="color: #666666;">ACH</a>&nbsp;>&nbsp;<asp:Label runat="server" id="lblACHRule"></asp:Label></td>
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
                        <td valign="top">
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">Collection Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
											<tr>
                                                <td class="entrytitlecell">Deposit Date:</td>
                                                <td><cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Deposit Date" required="true" TabIndex="18" cssclass="entry" ID="txtDepositDate" runat="server" mask="nn/nn/nnnn"></cc1:InputMask></td>
                                                <td style="width:55;"><a class="lnk" runat="server" id="lnkSetToNowStart" href="#" onclick="javascript:SetToNow(this.parentElement.previousSibling.childNodes(0));">Set To Min</a></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Deposit Amount:</td>
                                                <td><asp:textbox maxlength="50" validate="IsValidNumberFloat(Input.value, false, Input);" caption="Deposit Amount" required="true" TabIndex="17" cssclass="entry" ID="txtDepositAmount" runat="server" onkeypress="return onlyDigits(event);"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                                <td>
                                                    <asp:Label ID="lblUsed" runat="server" Text="" ForeColor="#009933"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <!-- My stuff -->
                                 <tr>
                                    <td style="background-color:#f1f1f1;">Created and Modified</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
											<tr>
                                                <td class="entrytitlecell">Created Date:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblCreated" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Created By:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblCreatedBy" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                           <tr>
                                                <td class="entrytitlecell">Modified Date:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblModified" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Modified By:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblModifiedBy" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr id="trNonDeposit" runat="server" > 
                                                <td class="entrytitlecell" style="white-space:nowrap;">Replacement Non-Deposit:</td>
                                                <td style="height:30px">
                                                   <asp:Label ID="lblNondepositMatterId" runat="server" ></asp:Label> 
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <!-- End of my stuff -->
                            </table>
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">Bank Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr id="trSelectBank" runat="server">
                                                <td class="entrytitlecell">Select Bank:</td>
                                                <td style="height:23px">
                                                    <asp:DropDownList ID="ddlBankName" class="entry" runat="server" AutoPostBack="True"
                                                        Width="100%"  AppendDataBoundItems="false">
                                                        <asp:ListItem Text=" " Value="select" />
                                                        <asp:ListItem Text="(Add Bank)" Value="add" />
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Bank Name:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblBankName" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Routing Number:</td>
                                                <td><asp:textbox maxlength="9" validate="IsValidTextLength(Input.value, 9, 9);" caption="Bank Routing Number" required="true" TabIndex="5" cssclass="entry" ID="txtBankRoutingNumber" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Account Number:</td>
                                                <td><asp:textbox maxlength="255" validate="" caption="Bank Account Number" required="true" TabIndex="5" cssclass="entry" ID="txtBankAccountNumber" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Account Type:</td>
                                                <td>
                                                    <asp:DropDownList class="entry" id="cboBankType" runat="server" style="font-size:11px">
                                                        <asp:ListItem value="0" text=""></asp:ListItem>
                                                        <asp:ListItem value="C" text="Checking"></asp:ListItem>
                                                        <asp:ListItem value="S" text="Savings"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                             <tr id="trAccountDisabled" style="display: none;" runat="server"  >
                                                    <td colspan="2" class="entry" style="color:Red" align="left" >&nbsp;</td>
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

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:HiddenField runat ="server" ID="hdnHasNonDeposit" />
</body>

</asp:Content>

