<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="applicant.aspx.vb" Inherits="clients_client_applicants_applicant" title="DMP - Client - Applicant" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
    function make_call(phonenumber, clientid) {
        window.top.parent.MakeClientOutboundCall(clientid, phonenumber);    
    }
</script>

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>

    <script type="text/javascript">

	var zipXml;
	var states = null;

	function initDocs()
	{
		zipXml = new ActiveXObject("Microsoft.XMLDOM");
		zipXml.async = false;
	}
	function txtZipCode_OnBlur(obj)
	{
		var txtCity = document.getElementById("<%= txtCity.ClientID %>");
		var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");

		if (obj.value.length > 0)
		{
            initDocs();

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
		     if(cboStateID.options[cboStateID.selectedIndex].text != "St. Kitts") 
	        {         
	            {
	                txtCity.value = "";
	                cboStateID.selectedIndex = 0;
	            }
	        }
	    }
	    else
	    if(cboStateID.options[cboStateID2.selectedIndex].text != "St. Kitts") 
	        {         
	            {
	                txtCity.value = "";
	                cboStateID.selectedIndex = 0;
	            }
	        }
	    }
	function NotStates()
	{
	     states = document.getElementById("<%= cboStateID.ClientID %>").value;
	     
	    <%--if(states == "1" || states == "34" || states == "42")
	        {
	            {
	                var cty = document.getElementById("<%= txtCity.clientid %>").value;
	                cty = 0;
	                states = 0;
	                alert("We do not accept clients from North Carolina, South Carolina or Alabama.");
	            }
	        }--%>
	 }

	function SetPrimary()
	{
	    var txtStreet = document.getElementById("<%= txtStreet.ClientID %>");
	    var txtStreet2 = document.getElementById("<%= txtStreet2.ClientID %>");
	    var txtCity = document.getElementById("<%= txtCity.ClientID %>");
	    var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");
	    var txtZipCode = document.getElementById("<%= txtZipCode.ClientID %>");

	    var lblStreet = document.getElementById("<%= lblStreet.ClientID %>");
	    var lblStreet2 = document.getElementById("<%= lblStreet2.ClientID %>");
	    var lblCity = document.getElementById("<%= lblCity.ClientID %>");
	    var lblState = document.getElementById("<%= lblState.ClientID %>");
	    var lblZipCode = document.getElementById("<%= lblZipCode.ClientID %>");

        txtStreet.value = lblStreet.innerText;
        txtStreet2.value = lblStreet2.innerText;
        txtCity.value = lblCity.innerText;

        for (i = 0; i < cboStateID.options.length; i++)
        {
            if (cboStateID.options[i].value == lblState.innerText)
            {
                cboStateID.selectedIndex = i;
                break;
            }
        }

        txtZipCode.value = lblZipCode.innerText;
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
        <%= Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_Save()
    {
        if (Record_RequiredExist())
        {
            // push phone values into hidden for server code to catch
            ResetPhones();

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
    function Record_RequiredExist()
    {
        // Social Security Number (SSN)
	    var txtSSN = document.getElementById("<%= txtSSN.ClientID %>");

	    if (txtSSN.value.length > 0)
	    {
	        //if (!RegexValidate(txtSSN.value, "^(?!000)([0-6]\\d{2}|7([0-6]\\d|7[012]))([ -]?)(?!00)\\d\\d\\3(?!0000)\\d{4}$"))
	         if (!RegexValidate(txtSSN.value, "^(?!000)(?!666)\\d{3}[-]?(?!00)\\d{2}[-]?(?!0000)\\d{4}$"))
	        {
	            ShowMessage("The Social Security Number (SSN) you entered is invalid.  Please enter a new value.  This is not a required field.");
	            AddBorder(txtSSN);
	            return false;
	        }
	        else
	        {
	            RemoveBorder(txtSSN);
	        }
	    }
	    else
	    {
            RemoveBorder(txtSSN);
	    }

        // First Name
	    var txtFirstName = document.getElementById("<%= txtFirstName.ClientID %>");

	    if (txtFirstName.value == null || txtFirstName.value.length == 0)
	    {
	        ShowMessage("The First Name is a required field");
	        AddBorder(txtFirstName);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtFirstName);
	    }

        // Last Name
	    var txtLastName = document.getElementById("<%= txtLastName.ClientID %>");

	    if (txtLastName.value == null || txtLastName.value.length == 0)
	    {
	        ShowMessage("The Last Name is a required field");
	        AddBorder(txtLastName);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtLastName);
	    }

        // Last Name
	    var txtLastName = document.getElementById("<%= txtLastName.ClientID %>");

	    if (txtLastName.value == null || txtLastName.value.length == 0)
	    {
	        ShowMessage("The Last Name is a required field");
	        AddBorder(txtLastName);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtLastName);
	    }

        // Date Of Birth
	    var txtDateOfBirth = document.getElementById("<%= txtDateOfBirth.ClientID %>");

	    if (txtDateOfBirth.value.length > 0)
	    {
	        if (!RegexValidate(txtDateOfBirth.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$"))
	        {
	            ShowMessage("The Date Of Birth you entered is invalid.  Please enter a new value.  This is not a required field.");
	            AddBorder(txtDateOfBirth);
	            return false;
	        }
	        else
	        {
	            RemoveBorder(txtDateOfBirth);
	        }
	    }
	    else
	    {
            RemoveBorder(txtDateOfBirth);
	    }

        // Email Address
	    var txtEmailAddress = document.getElementById("<%= txtEmailAddress.ClientID %>");

	    if (txtEmailAddress.value.length > 0)
	    {
            if (!RegexValidate(txtEmailAddress.value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"))
	        {
	            ShowMessage("The Email Address you entered is invalid.  Please enter a new value.  This is not a required field.");
	            AddBorder(txtEmailAddress);
	            return false;
            }
	        else
	        {
	            RemoveBorder(txtEmailAddress);
	        }
        }
        else
        {
            RemoveBorder(txtEmailAddress);
        }

        // Address Street 1
	    var txtStreet = document.getElementById("<%= txtStreet.ClientID %>");

	    if (txtStreet.value == null || txtStreet.value.length == 0)
	    {
	        ShowMessage("The Address Street is a required field");
	        AddBorder(txtStreet);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtStreet);
	    }

        // Address ZipCode
	    var txtZipCode = document.getElementById("<%= txtZipCode.ClientID %>");

	    if (txtZipCode.value == null || txtZipCode.value.length == 0)
	    {
	        ShowMessage("The Address Zip Code is a required field");
	        AddBorder(txtZipCode);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtZipCode);
	    }

        // Address City
	    var txtCity = document.getElementById("<%= txtCity.ClientID %>");

	    if (txtCity.value == null || txtCity.value.length == 0)
	    {
	        ShowMessage("The Address City is a required field");
	        AddBorder(txtCity);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtCity);
	    }

        // Address State
	    var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");

	    if (cboStateID.selectedIndex == -1 || cboStateID.options[cboStateID.selectedIndex].value == 0)
	    {
	        ShowMessage("The Address State is a required field");
	        AddBorder(cboStateID);
	        return false;
	    }
	    else
	    //if (cboStateID.value == "1" || cboStateID.value == "34" || cboStateID.value == "42")
	    //    {
	    //        alert("We do not accept clients from AL, NC or SC any longer. Please advise your supervisor.");
	    //        return false;
	    //    }
	    //else
	    {
	        RemoveBorder(cboStateID);
	    }

        // Phones
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");

        for (i = 1; i < tblPhones.rows.length; i++)
        {
	        var cboPhoneType = tblPhones.rows[i].cells[1].childNodes[0];
	        var txtPhoneNumber = tblPhones.rows[i].cells[2].childNodes[0];
	        var txtPhoneNumberExt = tblPhones.rows[i].cells[3].childNodes[0];

	        if (txtPhoneNumber.value != null && txtPhoneNumber.value.length > 0)
	        {
                if (!RegexValidate(txtPhoneNumber.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
	            {
	                ShowMessage("The Number you entered for Phone " + i + " is invalid.  Please enter a new value.  This is not a required field.");
	                RemoveBorder(cboPhoneType);
	                AddBorder(txtPhoneNumber);
	                return false;
                }
	            else if (cboPhoneType.selectedIndex == -1 || cboPhoneType.options[cboPhoneType.selectedIndex].value == 0)
	            {
	                ShowMessage("Since you entered a Number for Phone " + i + ", you must enter a Type as well.");
	                RemoveBorder(txtPhoneNumber);
	                AddBorder(cboPhoneType);
	                return false;
	            }
	            else
	            {
	                RemoveBorder(cboPhoneType);
	                RemoveBorder(txtPhoneNumber);
	            }
	        }
	        else
	        {
	            RemoveBorder(cboPhoneType);
	            RemoveBorder(txtPhoneNumber);
	        }
        }

        HideMessage()
	    return true;
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
         var url = '<%= ResolveUrl("~/delete.aspx?t=Applicant&p=applicant") %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Applicant",
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
    function Record_SetAsPrimary()
    {
        if (Record_RequiredExist())
        {
            // postback to set primary
            <%= Page.ClientScript.GetPostBackEventReference(lnkSetAsPrimary, Nothing) %>;
        }
    }
    function Record_DeletePhone(obj)
    {
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");

        tblPhones.deleteRow(obj.parentElement.parentElement.rowIndex)
    }
    function Record_AddPhone()
    {
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");
        var trNew = tblPhones.insertRow(-1);

        var tdDelete = trNew.insertCell(-1);
        var tdPhoneType = trNew.insertCell(-1);
        var tdPhoneNumber = trNew.insertCell(-1);
        var tdPhoneNumberExt = trNew.insertCell(-1);

        tdDelete.className = "listItem2";
        tdDelete.insertAdjacentElement("afterBegin", GetNewDelete(tblPhones.rows.length - 1));

        tdPhoneType.className = "listItem2";
        tdPhoneType.insertAdjacentElement("afterBegin", GetNewPhoneType());

        tdPhoneNumber.className = "listItem2";
        tdPhoneNumber.insertAdjacentElement("afterBegin", GetNewPhoneNumber());

        tdPhoneNumberExt.className = "listItem2";
        tdPhoneNumberExt.insertAdjacentElement("afterBegin", GetNewPhoneNumberExt());
    }
    function GetNewDelete(index)
    {
        var a = document.createElement("A");
        var img = document.createElement("IMG");

        img.border = "0";
        img.align = "absmiddle";
        img.src = "<%= ResolveUrl("~/images/16x16_delete.png") %>";

        a.href = "#";
        a.onclick = function () {Record_DeletePhone(this);return false;};

        a.insertAdjacentElement("afterBegin", img);

        return a;
    }
    function GetNewPhoneType()
    {
        var cboPhoneType = document.getElementById("<%= cboPhoneType.ClientID %>");

        var select = document.createElement("SELECT");

        select.className = "entry";
        
        for (i = 0; i < cboPhoneType.options.length; i++)
        {
            var option = document.createElement("OPTION");

            select.options.add(option);
            option.innerText = cboPhoneType.options[i].innerText;
            option.value = cboPhoneType.options[i].value;
        }

        return select;
    }
    function GetNewPhoneNumber()
    {
        var input = document.createElement("INPUT");

        // dynamically create an input mask
        input.type = "text"
        input.className = "entry";
		input.mask = "(nnn) nnn-nnnn";
		input.maskDisplay="_";
		input.maskAlpha = "a";
		input.maskNumeric="n";
		input.maskAlphaNumeric="x";
		input.RegexPattern = "";
		input.OnRegexMatch = "";
		input.OnRegexNoMatch = "";
		input.OnWrongKeyPressed = "";
		input.oncut = function () {ASI_InputMask_OnCut(this)};
		input.onblur = function () {ASI_InputMask_LostFocus(this)};
		input.oninput = function () {ASI_InputMask_OnInput(event, this)};
		input.onpaste = function () {ASI_InputMask_OnPaste(this)};
		input.onfocus = function () {ASI_InputMask_GotFocus(this)};
		input.onclick = function () {ASI_InputMask_OnClick(event, this)};
		input.onkeydown = function () {ASI_InputMask_KeyDown(event, this)};
		input.onkeypress = function () {ASI_InputMask_KeyPress(event, this)};

        return input;
    }
    function GetNewPhoneNumberExt()
    {
        var input = document.createElement("INPUT");

        input.type = "text"
        input.className = "entry";

        return input;
    }
    function ResetPhones()
    {
        var tblPhones = document.getElementById("<%= tblPhones.ClientID %>");
        var txtPhones = document.getElementById("<%= txtPhones.ClientID %>");

        txtPhones.value = "";

        for (i = 1; i < tblPhones.rows.length; i++)
        {
            var cboPhoneType = tblPhones.rows[i].cells[1].childNodes[0];
            var txtPhoneNumber = tblPhones.rows[i].cells[2].childNodes[0];
            var txtPhoneNumberExt = tblPhones.rows[i].cells[3].childNodes[0];

            if (txtPhoneNumber.value != null && txtPhoneNumber.value.length > 0)
            {
                if (txtPhones.value.length > 0)
                {
                    txtPhones.value += "|" + cboPhoneType.options[cboPhoneType.selectedIndex].value + "," + txtPhoneNumber.value + "," + txtPhoneNumberExt.value;
                }
                else
                {
                    txtPhones.value = cboPhoneType.options[cboPhoneType.selectedIndex].value + "," + txtPhoneNumber.value + "," + txtPhoneNumberExt.value;
                }
            }
        }
    }

    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkPersons" runat="server" class="lnk" style="color: #666666;">Applicants</a>&nbsp;>&nbsp;<asp:label id="lblPerson" runat="server" style="color: #666666;"></asp:label></td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img2" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            This applicant's address has been verified against the Federal USPS database which has returned
                                            the following extra information:
                                            <table style="margin:10 0 10 15;font-family:tahoma;font-size:11px;" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td nowrap="true" style="width:65;">Time Zone:</td>
                                                    <td nowrap="true"><asp:Label style="color:rgb(0,129,0);" runat="server" id="lblWebTimeZone"></asp:Label> -- LOCAL TIME -- <asp:Label style="color:rgb(0,129,0);" runat="server" id="lblLocalTime"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td nowrap="true" style="width:65;">Area Code:</td>
                                                    <td nowrap="true"><asp:Label style="color:rgb(0,129,0);" runat="server" id="lblWebAreaCode"></asp:Label></td>
                                                </tr>
                                            </table>
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
                                    <td style="background-color:#f1f1f1;" colspan="2">General Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">SSN:</td>
                                    <td><cc1:InputMask TabIndex="1" cssclass="entry" ID="txtSSN" runat="server" Mask="nnn-nn-nnnn"></cc1:InputMask></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">First Name:</td>
                                    <td><asp:textbox TabIndex="2" cssclass="entry" runat="server" id="txtFirstName"></asp:textbox></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Last Name:</td>
                                    <td><asp:textbox TabIndex="3" cssclass="entry" runat="server" id="txtLastName"></asp:textbox></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Date Of Birth:</td>
                                    <td><cc1:InputMask TabIndex="4" cssclass="entry" ID="txtDateOfBirth" runat="server" Mask="nn/nn/nnnn"></cc1:InputMask></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Gender:</td>
                                    <td><asp:dropdownlist TabIndex="5" cssclass="entry" runat="server" id="cboGender">
                                        <asp:listitem value=""></asp:listitem>
                                        <asp:listitem value="M">Male</asp:listitem>
                                        <asp:listitem value="F">Female</asp:listitem>
                                        </asp:dropdownlist></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Preferred Language:</td>
                                    <td><asp:dropdownlist TabIndex="6" cssclass="entry" runat="server" id="cboLanguageID"></asp:dropdownlist></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Email Address:</td>
                                    <td><asp:textbox TabIndex="7" cssclass="entry" runat="server" id="txtEmailAddress"></asp:textbox></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Deceased:</td>
                                    <td>
                                        <asp:RadioButtonList ID="rblDeceased" runat="server" CssClass="entry2" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="No" Value="False" />
                                            <asp:ListItem Text="Yes" Value="True" />
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </table>
                            <asp:panel runat="server" id="pnlCoapplicantInformation">
                                <table style="margin-top:15;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="background-color:#f1f1f1;">Co-applicant Information</td>
                                    </tr>
                                    <tr>
                                        <td class="entrycell"><asp:checkbox runat="server" id="chkThirdParty" text="Authorized as 3rd party only"></asp:checkbox></td>
                                    </tr>
                                    <tr>
                                        <td class="entrycell">Relationship type:</td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:RadioButtonList ID="optRelationship" runat="server" CellPadding="0" CellSpacing="0"
                                                Font-Names="Tahoma" Font-Size="11px" RepeatColumns="5">
                                                <asp:ListItem Selected="True">Spouse</asp:ListItem>
                                                <asp:ListItem>Father</asp:ListItem>
                                                <asp:ListItem>Mother</asp:ListItem>
                                                <asp:ListItem>Son</asp:ListItem>
                                                <asp:ListItem>Daughter</asp:ListItem>
                                                <asp:ListItem>Brother</asp:ListItem>
                                                <asp:ListItem>Sister</asp:ListItem>
                                                <asp:ListItem>Friend</asp:ListItem>
                                                <asp:ListItem>Coworker</asp:ListItem>
                                                <asp:ListItem>Other</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                </table>
                            </asp:panel>
                        </td>
                        <td><img height="1" width="30" runat="server" src="~/images/spacer.gif" /></td>
                        <td style="width:50%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;" colspan="2">
                                        <table style="width:100%;font-family:tahoma;font-size:11;" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>Address</td>
                                                <td align="right"><a onclick="SetPrimary();return false;" id="lnkSetPrimary" runat="server" href="#" class="lnk">Set Primary</a><asp:label runat="server" id="lblStreet" style="display:none;"></asp:label><asp:label runat="server" id="lblStreet2" style="display:none;"></asp:label><asp:label runat="server" id="lblCity" style="display:none;"></asp:label><asp:label runat="server" id="lblState" style="display:none;"></asp:label><asp:label runat="server" id="lblZipCode" style="display:none;"></asp:label></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Street 1:</td>
                                    <td><asp:textbox TabIndex="8" cssclass="entry" runat="server" id="txtStreet"></asp:textbox></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Street 2:</td>
                                    <td><asp:textbox TabIndex="9" cssclass="entry" runat="server" id="txtStreet2"></asp:textbox></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">City, State Zip:</td>
                                    <td>
                                        <table style="width:100%;" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td><asp:textbox TabIndex="11" cssclass="entry" runat="server" id="txtCity"></asp:textbox></td>
                                                <td style="width:55;padding-left:8;"><asp:dropdownlist TabIndex="12" cssclass="entry" runat="server" id="cboStateID" ></asp:dropdownlist></td>
                                                <td style="width:55;padding-left:8;"><asp:textbox TabIndex="10" cssclass="entry" runat="server" id="txtZipCode"></asp:textbox></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                
                            </table>
                            <table style="margin-top:15;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding: 5 5 5 5;background-color:#f1f1f1;">Phone Numbers</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table id="tblPhones" runat="server" style="margin-bottom:10;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                            <tr>
                                                <td class="headItem2" style="width:16;">&nbsp;</td>
                                                <td class="headItem2">Phone Type</td>
                                                <td class="headItem2">Number</td>
                                                <td class="headItem2">Extension</td>
                                            </tr>
                                        </table>
                                        <a style="color:rgb(51,118,171);" href="#" onclick="Record_AddPhone();" class="lnk"><img style="margin-left:8;margin-right:8;" runat="server" border="0" align="absmiddle" src="~/images/16x16_phone_add.png"/>Add Phone</a><br />
                                        <input type="hidden" runat="server" id="txtPhones" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <asp:dropdownlist runat="server" id="cboPhoneType" style="display:none;"></asp:dropdownlist>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSetAsPrimary"></asp:LinkButton>

</body>

</asp:Content>