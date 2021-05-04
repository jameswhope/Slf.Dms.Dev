<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="checktoprint.aspx.vb" Inherits="clients_client_finances_ach_checktoprint" title="DMP - Client - ACH & Fee Structure" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body onload="SetFocus('<%= txtFirstName.ClientID %>');" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entrycell {  }
        .entrytitlecell { width:85; }
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var txtFirstName = null;
    var txtLastName = null;
    var txtSpouseFirstName = null;
    var txtSpouseLastName = null;
    var txtStreet = null;
    var txtStreet2 = null;
    var txtCity = null;
    var cboStateID = null;
    var txtZipCode = null;
    var txtBankName = null;
    var txtBankCity = null;
    var cboBankStateID = null;
    var txtBankZipCode = null;
    var txtBankRoutingNumber = null;
    var txtBankAccountNumber = null;
    var txtCheckNumber = null;
    var txtAmount = null;
    var imCheckDate = null;
    var txtFraction = null;

    var optPrinted = null;
    var optNotPrinted = null;
    var imPrinted = null;
    var cboPrintedBy = null;
    var lnkSetToNow = null;
    var lnkSetToMe = null;

    var Inputs = null;

    function optPrinted_OnPropertyChange(opt)
    {
        LoadControls();

        imPrinted.disabled = !opt.checked;
        cboPrintedBy.disabled = !opt.checked;
        lnkSetToNow.disabled = !opt.checked;
        lnkSetToMe.disabled = !opt.checked;
    }
    function optNotPrinted_OnPropertyChange(opt)
    {
        LoadControls();

        imPrinted.disabled = opt.checked;
        cboPrintedBy.disabled = opt.checked;
        lnkSetToNow.disabled = opt.checked;
        lnkSetToMe.disabled = opt.checked;
    }
	function txtZipCode_OnBlur(obj)
	{
		var txtCity = document.getElementById("<%= txtCity.ClientID %>");
		var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");

		if (obj.value.length > 0)
		{
		    var zipXml = new ActiveXObject("Microsoft.XMLDOM");

		    zipXml.async = false;

			zipXml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + obj.value);

			var address = zipXml.getElementsByTagName("address")[0];

			if (address != null && address.attributes.length > 0)
			{
				if (address.attributes.getNamedItem("city") != null)
				{
					txtCity.value = address.attributes.getNamedItem("city").value;
				}

				if (cboStateID != null)
				{
					if (address.attributes.getNamedItem("stateabbreviation") != null) {
						for (i = 0; i < cboStateID.options.length; i++) {
							if (cboStateID.options[i].text == address.attributes.getNamedItem("stateabbreviation").value)
								cboStateID.selectedIndex = i;
						}
					}
				}
			}
			else
			{
			    txtCity.value = "";
			    cboStateID.selectedIndex = 0;
			}
		}
		else
		{
		    txtCity.value = "";
		    cboStateID.selectedIndex = 0;
		}
	}
	function txtBankZipCode_OnBlur(obj)
	{
		var txtCity = document.getElementById("<%= txtBankCity.ClientID %>");
		var cboStateID = document.getElementById("<%= cboBankStateID.ClientID %>");

		if (obj.value.length > 0)
		{
		    var zipXml = new ActiveXObject("Microsoft.XMLDOM");

		    zipXml.async = false;

			zipXml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + obj.value);

			var address = zipXml.getElementsByTagName("address")[0];

			if (address != null && address.attributes.length > 0)
			{
				if (address.attributes.getNamedItem("city") != null)
				{
					txtCity.value = address.attributes.getNamedItem("city").value;
				}

				if (cboStateID != null)
				{
					if (address.attributes.getNamedItem("stateabbreviation") != null) {
						for (i = 0; i < cboStateID.options.length; i++) {
							if (cboStateID.options[i].text == address.attributes.getNamedItem("stateabbreviation").value)
								cboStateID.selectedIndex = i;
						}
					}
				}
			}
			else
			{
			    txtCity.value = "";
			    cboStateID.selectedIndex = 0;
			}
		}
		else
		{
		    txtCity.value = "";
		    cboStateID.selectedIndex = 0;
		}
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
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_Save()
    {
        if (Record_RequiredExist())
        {
            // postback to save
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
	    if (txtFirstName == null)
	    {
	        txtFirstName = document.getElementById("<%= txtFirstName.ClientID() %>");
            txtLastName = document.getElementById("<%= txtLastName.ClientID() %>");
            txtSpouseFirstName = document.getElementById("<%= txtSpouseFirstName.ClientID() %>");
            txtSpouseLastName = document.getElementById("<%= txtSpouseLastName.ClientID() %>");
            txtStreet = document.getElementById("<%= txtStreet.ClientID() %>");
            txtStreet2 = document.getElementById("<%= txtStreet2.ClientID() %>");
            txtCity = document.getElementById("<%= txtCity.ClientID() %>");
            cboStateID = document.getElementById("<%= cboStateID.ClientID() %>");
            txtZipCode = document.getElementById("<%= txtZipCode.ClientID() %>");
            txtBankName = document.getElementById("<%= txtBankName.ClientID() %>");
            txtBankCity = document.getElementById("<%= txtBankCity.ClientID() %>");
            cboBankStateID = document.getElementById("<%= cboBankStateID.ClientID() %>");
            txtBankZipCode = document.getElementById("<%= txtBankZipCode.ClientID() %>");
            txtBankRoutingNumber = document.getElementById("<%= txtBankRoutingNumber.ClientID() %>");
            txtBankAccountNumber = document.getElementById("<%= txtBankAccountNumber.ClientID() %>");
            txtCheckNumber = document.getElementById("<%= txtCheckNumber.ClientID() %>");
            txtAmount = document.getElementById("<%= txtAmount.ClientID() %>");
            imCheckDate = document.getElementById("<%= imCheckDate.ClientID() %>");
            txtFraction = document.getElementById("<%= txtFraction.ClientID() %>");

            optPrinted = document.getElementById("<%= optPrinted.ClientID() %>");
            optNotPrinted = document.getElementById("<%= optNotPrinted.ClientID() %>");
            imPrinted = document.getElementById("<%= imPrinted.ClientID() %>");
            cboPrintedBy = document.getElementById("<%= cboPrintedBy.ClientID() %>");
            lnkSetToNow = document.getElementById("<%= lnkSetToNow.ClientID() %>");
            lnkSetToMe = document.getElementById("<%= lnkSetToMe.ClientID() %>");

            Inputs = new Array();

            Inputs[Inputs.length] = txtFirstName;
            Inputs[Inputs.length] = txtLastName;
            Inputs[Inputs.length] = txtSpouseFirstName;
            Inputs[Inputs.length] = txtSpouseLastName;
            Inputs[Inputs.length] = txtStreet;
            Inputs[Inputs.length] = txtStreet2;
            Inputs[Inputs.length] = txtCity;
            Inputs[Inputs.length] = cboStateID;
            Inputs[Inputs.length] = txtZipCode;
            Inputs[Inputs.length] = txtBankName;
            Inputs[Inputs.length] = txtBankCity;
            Inputs[Inputs.length] = cboBankStateID;
            Inputs[Inputs.length] = txtBankZipCode;
            Inputs[Inputs.length] = txtBankRoutingNumber;
            Inputs[Inputs.length] = txtBankAccountNumber;
            Inputs[Inputs.length] = txtCheckNumber;
            Inputs[Inputs.length] = txtAmount;
            Inputs[Inputs.length] = imCheckDate;
            Inputs[Inputs.length] = txtFraction;
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

            // check, if required, that content exists
            if (Required.toLowerCase() == "true")
            {
                if (Input.tagName.toLowerCase() == "select")
                {
                    // control is a dropdownlist
                    if (Input.selectedIndex == -1 || Input.options[Input.selectedIndex].value <= 0)
                    {
	                    ShowMessage("The " + Caption + " field is required.");
	                    AddBorder(Input);
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
	                        AddBorder(Input);
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
                    AddBorder(Input);
                    return false;
                }
            }
        }

        // validate fulfillment area
        if (optPrinted.checked)
        {
            if (imPrinted.value.length == 0)
            {
                ShowMessage("Since this check has been printed, the Printed Date field is required.");
                AddBorder(imPrinted);
                return false;
            }
            else
            {
                if (!IsValidDateTime(imPrinted.value))
                {
                    ShowMessage("The value you entered for the Printed Date is invalid.  This field is only required because this check has been printed.");
                    AddBorder(imPrinted);
                    return false;
                }
            }

            if (cboPrintedBy.selectedIndex == -1 || cboPrintedBy.options[cboPrintedBy.selectedIndex].value <= 0)
            {
                ShowMessage("Since this check has been printed, the Printed By field is required.");
                AddBorder(cboPrintedBy);
                return false;
            }
        }

        HideMessage()
	    return true;
    }
	function Record_DeleteConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Check&m=Are you sure you want to delete this check?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Check",
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
    function SetToNow()
    {
        LoadControls();

        if (!lnkSetToNow.disabled)
        {
            imPrinted.value = Functoid_Date_GetNow("/", false);
        }
    }
    function SetToMe()
    {
        LoadControls();

        if (!lnkSetToMe.disabled)
        {
		    for (i = 0; i < cboPrintedBy.options.length; i++)
		    {
			    if (cboPrintedBy.options[i].value == <%= UserID.ToString() %>)
			    {
				    cboPrintedBy.selectedIndex = i;
				    break;
				}
		    }
        }
    }

    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkFinances" runat="server" class="lnk" style="color: #666666;">Finances</a>&nbsp;>&nbsp;<a id="lnkACH" runat="server" class="lnk" style="color: #666666;">ACH</a>&nbsp;>&nbsp;<asp:Label runat="server" id="lblCheckToPrint"></asp:Label></td>
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
                                    <td style="background-color:#f1f1f1;">General Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell">First / Name:</td>
                                                <td>
                                                    <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td style="width:50%;padding-right:5;"><asp:textbox maxlength="50" validate="" caption="Last Name" required="true" TabIndex="1" cssclass="entry" runat="server" id="txtFirstName"></asp:textbox></td>
                                                            <td style="width:50%;"><asp:textbox maxlength="50" validate="" caption="Last Name" required="true" TabIndex="2" cssclass="entry" ID="txtLastName" runat="server"></asp:textbox></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Spouse Name:</td>
                                                <td>
                                                    <table style="width:100%;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td style="width:50%;padding-right:5;"><asp:textbox maxlength="50" validate="" caption="Spouse First Name" required="false" TabIndex="3" cssclass="entry" runat="server" id="txtSpouseFirstName"></asp:textbox></td>
                                                            <td style="width:50%;"><asp:textbox maxlength="50" validate="" caption="Spouse Last Name" required="false" TabIndex="4" cssclass="entry" ID="txtSpouseLastName" runat="server"></asp:textbox></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Street:</td>
                                                <td><asp:textbox maxlength="255" validate="" caption="Street" required="true" TabIndex="5" cssclass="entry" ID="txtStreet" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Street 2:</td>
                                                <td><asp:textbox maxlength="255" validate="" caption="Street 2" required="false" TabIndex="6" cssclass="entry" ID="txtStreet2" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">City, State Zip:</td>
                                                <td>
                                                    <table style="width:100%;" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td><asp:textbox maxlength="50" validate="" caption="City" required="true" TabIndex="8" cssclass="entry" runat="server" id="txtCity"></asp:textbox></td>
                                                            <td style="width:40;padding-left:8;"><asp:dropdownlist validate="" caption="State" required="true" TabIndex="9" cssclass="entry" runat="server" id="cboStateID"></asp:dropdownlist></td>
                                                            <td style="width:55;padding-left:8;"><asp:textbox maxlength="10" validate="" caption="Zip Code" required="true" TabIndex="7" cssclass="entry" runat="server" id="txtZipCode"></asp:textbox></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">Bank Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell">Bank Name:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="Bank Name" required="true" TabIndex="10" cssclass="entry" ID="txtBankName" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">City, State Zip:</td>
                                                <td>
                                                    <table style="width:100%;" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td><asp:textbox maxlength="50" validate="" caption="Bank City" required="false" TabIndex="12" cssclass="entry" runat="server" id="txtBankCity"></asp:textbox></td>
                                                            <td style="width:40;padding-left:8;"><asp:dropdownlist maxlength="50" validate="" caption="Bank State" required="false" TabIndex="13" cssclass="entry" runat="server" id="cboBankStateID"></asp:dropdownlist></td>
                                                            <td style="width:55;padding-left:8;"><asp:textbox maxlength="10" validate="" caption="Bank Zip Code" required="false" TabIndex="11" cssclass="entry" runat="server" id="txtBankZipCode"></asp:textbox></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Routing Number:</td>
                                                <td><asp:textbox maxlength="9" validate="" caption="Routing Number" required="true" TabIndex="14" cssclass="entry" ID="txtBankRoutingNumber" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Account Number:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="Account Number" required="true" TabIndex="15" cssclass="entry" ID="txtBankAccountNumber" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Check Number:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="Check Number" required="true" TabIndex="16" cssclass="entry" ID="txtCheckNumber" runat="server"></asp:textbox></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">Miscellaneous</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell">Amount:</td>
                                                <td><asp:textbox maxlength="50" validate="IsValidNumberFloat(Input.value, true, Input);" caption="Amount" required="true" TabIndex="17" cssclass="entry" ID="txtAmount" runat="server"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Check Date:</td>
                                                <td><cc1:InputMask validate="IsValidDateTime(Input.value);" caption="Check Date" required="true" TabIndex="18" cssclass="entry" ID="imCheckDate" runat="server" mask="nn/nn/nnnn"></cc1:InputMask></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Fraction Code:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="Fraction Code" required="true" TabIndex="19" cssclass="entry" ID="txtFraction" runat="server"></asp:textbox></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">Fulfillment</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td><input TabIndex="20" runat="server" type="radio" name="optFulfillment" id="optNotPrinted" checked="true"></radio><label for="<%= optNotPrinted.ClientID() %>">This check has not been printed</label></td>
                                            </tr>
                                            <tr>
                                                <td><input TabIndex="21" runat="server" type="radio" name="optFulfillment" id="optPrinted"></radio><label for="<%= optPrinted.ClientID() %>">This check has been printed</label></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left:25;">
                                                    <table style="font-family:tahoma;font-size:11px;width:250;" border="0" cellpadding="0" cellspacing="5">
                                                        <tr>
                                                            <td style="width:55;">Printed:</td>
                                                            <td><cc1:InputMask TabIndex="22" cssclass="entry" ID="imPrinted" runat="server" Mask="nn/nn/nnnn"></cc1:InputMask></td>
                                                            <td style="width:55;"><a class="lnk" runat="server" id="lnkSetToNow" href="javascript:SetToNow();">Set To Now</a></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width:55;">Printed By:</td>
                                                            <td><asp:dropdownlist TabIndex="23" cssclass="entry" runat="server" id="cboPrintedBy"></asp:dropdownlist></td>
                                                            <td style="width:55;"><a class="lnk" runat="server" id="lnkSetToMe" href="javascript:SetToMe();">Set To Me</a></td>
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
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    
</body>

</asp:Content>