<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addapplicant.aspx.vb" Inherits="clients_new_addapplicant" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Co-Applicant</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <SCRIPT src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></SCRIPT>
</head>
<body onload="SetFocus('<%= txtFirstName.ClientID %>');" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <script type="text/javascript">

    initDocs();

	var zipXml;

	function getXmlLocation()
	{
		var pos = window.location.pathname.lastIndexOf("/");
		return window.location.protocol + "//" + window.location.host + window.location.pathname.substr(0, pos) + "/";
	}
	function initDocs()
	{
		zipXml = new ActiveXObject("Microsoft.XMLDOM");
		zipXml.async = false;
	}
	function txtZipCode_OnBlur(obj)
	{
		var oCity = document.all("txtCity");
		var oState = document.all("cboStateID");

		if (obj.value.length > 0) {

			zipXml.load(getXmlLocation() + "XML/citystatefinder.aspx?zip=" + obj.value);
			var address = zipXml.getElementsByTagName("address")[0];

			if (address != null && address.attributes.length > 0)
			{
				if (address.attributes.getNamedItem("city") != null)
				{
					oCity.value = address.attributes.getNamedItem("city").value;
				}

				if (oState != null)
				{
					if (address.attributes.getNamedItem("stateabbreviation") != null) {
						for (i = 0; i < oState.options.length; i++) {
							if (oState.options[i].text == address.attributes.getNamedItem("stateabbreviation").value)
								oState.selectedIndex = i;
						}
					}
				}
			}
			else
			{
			    oCity.value = "";
			    oState.selectedIndex = 0;
			}
		}
		else
		{
		    oCity.value = "";
		    oState.selectedIndex = 0;
		}
	}
	function AddApplicant()
	{
	    if (RequiredExist())
	    {
            var txtFirstName = document.getElementById("<%= txtFirstName.ClientID %>");
            var txtLastName = document.getElementById("<%= txtLastName.ClientID %>");
            var cboGender = document.getElementById("<%= cboGender.ClientID %>");
            var txtStreet = document.getElementById("<%= txtStreet.ClientID %>");
            var txtStreet2 = document.getElementById("<%= txtStreet2.ClientID %>");
            var txtCity = document.getElementById("<%= txtCity.ClientID %>");
            var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");
            var txtZipCode = document.getElementById("<%= txtZipCode.ClientID %>");
            var cboLanguageID = document.getElementById("<%= cboLanguageID.ClientID %>");
            var txtEmailAddress = document.getElementById("<%= txtEmailAddress.ClientID %>");
            var cboPhoneTypeID1 = document.getElementById("<%= cboPhoneTypeID1.ClientID %>");
            var txtPhoneNumber1 = document.getElementById("<%= txtPhoneNumber1.ClientID %>");
            var txtPhoneExtension1 = document.getElementById("<%= txtPhoneExtension1.ClientID %>");
            var cboPhoneTypeID2 = document.getElementById("<%= cboPhoneTypeID2.ClientID %>");
            var txtPhoneNumber2 = document.getElementById("<%= txtPhoneNumber2.ClientID %>");
            var txtPhoneExtension2 = document.getElementById("<%= txtPhoneExtension2.ClientID %>");
            var cboPhoneTypeID3 = document.getElementById("<%= cboPhoneTypeID3.ClientID %>");
            var txtPhoneNumber3 = document.getElementById("<%= txtPhoneNumber3.ClientID %>");
            var txtPhoneExtension3 = document.getElementById("<%= txtPhoneExtension3.ClientID %>");
            var cboPhoneTypeID4 = document.getElementById("<%= cboPhoneTypeID4.ClientID %>");
            var txtPhoneNumber4 = document.getElementById("<%= txtPhoneNumber4.ClientID %>");
            var txtPhoneExtension4 = document.getElementById("<%= txtPhoneExtension4.ClientID %>");
            var cboPhoneTypeID5 = document.getElementById("<%= cboPhoneTypeID5.ClientID %>");
            var txtPhoneNumber5 = document.getElementById("<%= txtPhoneNumber5.ClientID %>");
            var txtPhoneExtension5 = document.getElementById("<%= txtPhoneExtension5.ClientID %>");
            var optRelationship = document.getElementById("<%= optRelationship.ClientID %>");
            var chkCanAuthorize = document.getElementById("<%= chkCanAuthorize.ClientID %>");

            var Type = "";

            for (i = 0; i < optRelationship.rows.length; i++)
            {
                if (optRelationship.rows[i].cells[0].childNodes[0].checked)
                {
                    Type = optRelationship.rows[i].cells[0].childNodes[0].value;
                    break;
                }
                if (optRelationship.rows[i].cells[1].childNodes[0].checked)
                {
                    Type = optRelationship.rows[i].cells[1].childNodes[0].value;
                    break;
                }
            }

            var Value = txtFirstName.value + "|" + txtLastName.value + "|"
                + cboGender.options[cboGender.selectedIndex].value + "|"
                + txtStreet.value + "|" + txtStreet2.value + "|" + txtCity.value + "|"
                + cboStateID.options[cboStateID.selectedIndex].value + "|" + txtZipCode.value + "|"
                + cboLanguageID.options[cboLanguageID.selectedIndex].value + "|" + txtEmailAddress.value + "|"
                + cboPhoneTypeID1.options[cboPhoneTypeID1.selectedIndex].value + "|" + txtPhoneNumber1.value + "|"
                + txtPhoneExtension1.value + "|" + cboPhoneTypeID2.options[cboPhoneTypeID2.selectedIndex].value + "|"
                + txtPhoneNumber2.value + "|" + txtPhoneExtension2.value + "|"
                + cboPhoneTypeID3.options[cboPhoneTypeID3.selectedIndex].value + "|" + txtPhoneNumber3.value + "|"
                + txtPhoneExtension3.value + "|" + cboPhoneTypeID4.options[cboPhoneTypeID4.selectedIndex].value + "|"
                + txtPhoneNumber4.value + "|" + txtPhoneExtension4.value + "|"
                + cboPhoneTypeID5.options[cboPhoneTypeID5.selectedIndex].value + "|" + txtPhoneNumber5.value + "|"
                + txtPhoneExtension5.value + "|" + Type + "|" + chkCanAuthorize.checked;

            window.top.dialogArguments.AddApplicant(Value);
            window.close();
	    }
	}
	function SetPrimaryAddress()
	{
        var txtStreet = document.getElementById("<%= txtStreet.ClientID %>");
        var txtStreet2 = document.getElementById("<%= txtStreet2.ClientID %>");
        var txtCity = document.getElementById("<%= txtCity.ClientID %>");
        var cboStateID = document.getElementById("<%= cboStateID.ClientID %>");
        var txtZipCode = document.getElementById("<%= txtZipCode.ClientID %>");

        var txtParentStreet = window.top.dialogArguments.GetElement(0);
        var txtParentStreet2 = window.top.dialogArguments.GetElement(1);
        var txtParentCity = window.top.dialogArguments.GetElement(2);
        var cboParentStateID = window.top.dialogArguments.GetElement(3);
        var txtParentZipCode = window.top.dialogArguments.GetElement(4);

        txtStreet.value = txtParentStreet.value;
        txtStreet2.value = txtParentStreet2.value;
        txtCity.value = txtParentCity.value;
        cboStateID.selectedIndex = cboParentStateID.selectedIndex;
        txtZipCode.value = txtParentZipCode.value;
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
	function RequiredExist()
	{
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
	    {
	        RemoveBorder(cboStateID);
	    }

        // Email Address
	    var txtEmailAddress = document.getElementById("<%= txtEmailAddress.ClientID %>");

	    if (txtEmailAddress.value != null && txtEmailAddress.value.length > 0)
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

        // Phone 1
	    var cboPhoneTypeID1 = document.getElementById("<%= cboPhoneTypeID1.ClientID %>");
	    var txtPhoneNumber1 = document.getElementById("<%= txtPhoneNumber1.ClientID %>");
	    var txtPhoneExtension1 = document.getElementById("<%= txtPhoneExtension1.ClientID %>");

	    if (txtPhoneNumber1.value != null && txtPhoneNumber1.value.length > 0)
	    {
            if (!RegexValidate(txtPhoneNumber1.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
	        {
	            ShowMessage("The Number you entered for Phone 1 is invalid.  Please enter a new value.  This is not a required field.");
	            RemoveBorder(cboPhoneTypeID1);
	            RemoveBorder(txtPhoneExtension1);
	            AddBorder(txtPhoneNumber1);
	            return false;
            }
	        else if (cboPhoneTypeID1.selectedIndex == -1 || cboPhoneTypeID1.options[cboPhoneTypeID1.selectedIndex].value == 0)
	        {
	            ShowMessage("Since you entered a Number for Phone 1, you must enter a Type as well.");
	            RemoveBorder(txtPhoneNumber1);
	            RemoveBorder(txtPhoneExtension1);
	            AddBorder(cboPhoneTypeID1);
	            return false;
	        }
	        else
	        {
	            RemoveBorder(cboPhoneTypeID1);
	            RemoveBorder(txtPhoneNumber1);
	            RemoveBorder(txtPhoneExtension1);
	        }
	    }
	    else
	    {
	        RemoveBorder(cboPhoneTypeID1);
	        RemoveBorder(txtPhoneNumber1);
	        RemoveBorder(txtPhoneExtension1);
	    }

        // Phone 2
	    var cboPhoneTypeID2 = document.getElementById("<%= cboPhoneTypeID2.ClientID %>");
	    var txtPhoneNumber2 = document.getElementById("<%= txtPhoneNumber2.ClientID %>");
	    var txtPhoneExtension2 = document.getElementById("<%= txtPhoneExtension2.ClientID %>");

	    if (txtPhoneNumber2.value != null && txtPhoneNumber2.value.length > 0)
	    {
            if (!RegexValidate(txtPhoneNumber2.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
	        {
	            ShowMessage("The Number you entered for Phone 2 is invalid.  Please enter a new value.  This is not a required field.");
	            RemoveBorder(cboPhoneTypeID2);
	            RemoveBorder(txtPhoneExtension2);
	            AddBorder(txtPhoneNumber2);
	            return false;
            }
	        else if (cboPhoneTypeID2.selectedIndex == -1 || cboPhoneTypeID2.options[cboPhoneTypeID2.selectedIndex].value == 0)
	        {
	            ShowMessage("Since you entered a Number for Phone 2, you must enter a Type as well.");
	            RemoveBorder(txtPhoneNumber2);
	            RemoveBorder(txtPhoneExtension2);
	            AddBorder(cboPhoneTypeID2);
	            return false;
	        }
	        else
	        {
	            RemoveBorder(cboPhoneTypeID2);
	            RemoveBorder(txtPhoneNumber2);
	            RemoveBorder(txtPhoneExtension2);
	        }
	    }
	    else
	    {
	        RemoveBorder(cboPhoneTypeID2);
	        RemoveBorder(txtPhoneNumber2);
	        RemoveBorder(txtPhoneExtension2);
	    }

        // Phone 3
	    var cboPhoneTypeID3 = document.getElementById("<%= cboPhoneTypeID3.ClientID %>");
	    var txtPhoneNumber3 = document.getElementById("<%= txtPhoneNumber3.ClientID %>");
	    var txtPhoneExtension3 = document.getElementById("<%= txtPhoneExtension3.ClientID %>");

	    if (txtPhoneNumber3.value != null && txtPhoneNumber3.value.length > 0)
	    {
            if (!RegexValidate(txtPhoneNumber3.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
	        {
	            ShowMessage("The Number you entered for Phone 3 is invalid.  Please enter a new value.  This is not a required field.");
	            RemoveBorder(cboPhoneTypeID3);
	            RemoveBorder(txtPhoneExtension3);
	            AddBorder(txtPhoneNumber3);
	            return false;
            }
	        else if (cboPhoneTypeID3.selectedIndex == -1 || cboPhoneTypeID3.options[cboPhoneTypeID3.selectedIndex].value == 0)
	        {
	            ShowMessage("Since you entered a Number for Phone 3, you must enter a Type as well.");
	            RemoveBorder(txtPhoneNumber3);
	            RemoveBorder(txtPhoneExtension3);
	            AddBorder(cboPhoneTypeID3);
	            return false;
	        }
	        else
	        {
	            RemoveBorder(cboPhoneTypeID3);
	            RemoveBorder(txtPhoneNumber3);
	            RemoveBorder(txtPhoneExtension3);
	        }
	    }
	    else
	    {
	        RemoveBorder(cboPhoneTypeID3);
	        RemoveBorder(txtPhoneNumber3);
	        RemoveBorder(txtPhoneExtension3);
	    }

        // Phone 4
	    var cboPhoneTypeID4 = document.getElementById("<%= cboPhoneTypeID4.ClientID %>");
	    var txtPhoneNumber4 = document.getElementById("<%= txtPhoneNumber4.ClientID %>");
	    var txtPhoneExtension4 = document.getElementById("<%= txtPhoneExtension4.ClientID %>");

	    if (txtPhoneNumber4.value != null && txtPhoneNumber4.value.length > 0)
	    {
            if (!RegexValidate(txtPhoneNumber4.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
	        {
	            ShowMessage("The Number you entered for Phone 4 is invalid.  Please enter a new value.  This is not a required field.");
	            RemoveBorder(cboPhoneTypeID4);
	            RemoveBorder(txtPhoneExtension4);
	            AddBorder(txtPhoneNumber4);
	            return false;
            }
	        else if (cboPhoneTypeID4.selectedIndex == -1 || cboPhoneTypeID4.options[cboPhoneTypeID4.selectedIndex].value == 0)
	        {
	            ShowMessage("Since you entered a Number for Phone 4, you must enter a Type as well.");
	            RemoveBorder(txtPhoneNumber4);
	            RemoveBorder(txtPhoneExtension4);
	            AddBorder(cboPhoneTypeID4);
	            return false;
	        }
	        else
	        {
	            RemoveBorder(cboPhoneTypeID4);
	            RemoveBorder(txtPhoneNumber4);
	            RemoveBorder(txtPhoneExtension4);
	        }
	    }
	    else
	    {
	        RemoveBorder(cboPhoneTypeID4);
	        RemoveBorder(txtPhoneNumber4);
	        RemoveBorder(txtPhoneExtension4);
	    }

        // Phone 5
	    var cboPhoneTypeID5 = document.getElementById("<%= cboPhoneTypeID5.ClientID %>");
	    var txtPhoneNumber5 = document.getElementById("<%= txtPhoneNumber5.ClientID %>");
	    var txtPhoneExtension5 = document.getElementById("<%= txtPhoneExtension5.ClientID %>");

	    if (txtPhoneNumber5.value != null && txtPhoneNumber5.value.length > 0)
	    {
            if (!RegexValidate(txtPhoneNumber5.value, "((\\(\\d{3}\\) ?)|(\\d{3}[- \\.]))?\\d{3}[- \\.]\\d{4}(\\s(x\\d+)?){0,1}$"))
	        {
	            ShowMessage("The Number you entered for Phone 5 is invalid.  Please enter a new value.  This is not a required field.");
	            RemoveBorder(cboPhoneTypeID1);
	            RemoveBorder(txtPhoneExtension5);
	            AddBorder(txtPhoneNumber5);
	            return false;
            }
	        else if (cboPhoneTypeID5.selectedIndex == -1 || cboPhoneTypeID5.options[cboPhoneTypeID5.selectedIndex].value == 0)
	        {
	            ShowMessage("Since you entered a Number for Phone 5, you must enter a Type as well.");
	            RemoveBorder(txtPhoneNumber5);
	            RemoveBorder(txtPhoneExtension5);
	            AddBorder(cboPhoneTypeID5);
	            return false;
	        }
	        else
	        {
	            RemoveBorder(cboPhoneTypeID5);
	            RemoveBorder(txtPhoneNumber5);
	            RemoveBorder(txtPhoneExtension5);
	        }
	    }
	    else
	    {
	        RemoveBorder(cboPhoneTypeID5);
	        RemoveBorder(txtPhoneNumber5);
	        RemoveBorder(txtPhoneExtension5);
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
		</script>
    <form id="form1" runat="server">
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display:none;">
                        <TABLE style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					        <TR>
						        <TD valign="top" width="20"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
						        <TD runat="server" id="tdError"></TD>
					        </TR>
				        </TABLE>
				    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top: 15px">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 70px">
                                First Name:</td>
                            <td style="width: 125px"><asp:TextBox TabIndex="2" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtFirstName" Width="100px"></asp:TextBox></td>
                            <td style="width: 90px">
                                Address Street:</td>
                            <td style="width: 200px">
                                <asp:TextBox TabIndex="6" ID="txtStreet" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%"></asp:TextBox></td>
                            <td rowspan="4" valign="top"><a class="lnk" href="#" onclick="SetPrimaryAddress();return false;"><img border="0" align="absmiddle" style="margin-right:5px;" runat="server" src="~/images/16x16_web_home.png" />Set
                                Primary</a></td>
                        </tr>
                        <tr>
                            <td style="width: 70px">Last Name:</td>
                            <td style="width: 125px"><asp:TextBox TabIndex="3" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtLastName" Width="100px"></asp:TextBox></td>
                            <td style="width: 90px">
                                Address Street 2:</td>
                            <td style="width: 200px">
                                <asp:TextBox TabIndex="7" ID="txtStreet2" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 70px">
                                Gender:</td>
                            <td style="width: 125px">
                                <asp:DropDownList TabIndex="4" ID="cboGender" runat="server" Font-Names="Tahoma" Font-Size="11px" Width="100px">
                                    <asp:ListItem Value=""></asp:ListItem>
                                    <asp:ListItem Value="M">Male</asp:ListItem>
                                    <asp:ListItem Value="F">Female</asp:ListItem>
                                </asp:DropDownList></td>
                            <td style="width: 90px">
                                City, State Zip:</td>
                            <td style="width: 200px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtCity" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%"></asp:TextBox></td>
                                        <td style="width: 40px; padding-right: 7px; padding-left: 7px;">
                                            <asp:DropDownList ID="cboStateID" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                            </asp:DropDownList></td>
                                        <td style="width: 45px">
                                            <asp:TextBox TabIndex="10" ID="txtZipCode" runat="server" Font-Names="tahoma" Font-Size="11px"
                                                Width="100%" MaxLength="5"></asp:TextBox></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 70px">
                                Language:</td>
                            <td style="width: 125px"><asp:DropDownList TabIndex="5" ID="cboLanguageID" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100px">
                            </asp:DropDownList></td>
                            <td style="width: 90px">
                                Email Address:</td>
                            <td style="width: 200px">
                                <asp:TextBox TabIndex="12" ID="txtEmailAddress" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Width="100%"></asp:TextBox></td>
                        </tr>
                    </table>
                                &nbsp;<table border="0" cellpadding="0" cellspacing="0" style="font-size: 11px; width: 100%;
                        font-family: tahoma">
                        <tr>
                            <td style="height: 160px" valign="top">
                    <table style="font-family:tahoma;font-size:11px; table-layout: fixed;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 70px">
                                Phone 1:</td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="13" ID="cboPhoneTypeID1" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                </asp:DropDownList></td>
                            <td style="width: 92px">
                                <cc1:InputMask ID="txtPhoneNumber1" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="14" Width="100%"></cc1:InputMask></td>
                            <td style="width: 45px">
                                <asp:TextBox ID="txtPhoneExtension1" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="15" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 70px">
                                Phone 2:</td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="16" ID="cboPhoneTypeID2" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                </asp:DropDownList></td>
                            <td style="width: 92px">
                                <cc1:InputMask ID="txtPhoneNumber2" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="17" Width="100%"></cc1:InputMask></td>
                            <td style="width: 45px">
                                <asp:TextBox ID="txtPhoneExtension2" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="18" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 70px">
                                Phone 3:</td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="19" ID="cboPhoneTypeID3" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                </asp:DropDownList></td>
                            <td style="width: 92px">
                                <cc1:InputMask ID="txtPhoneNumber3" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="20" Width="100%"></cc1:InputMask></td>
                            <td style="width: 45px">
                                <asp:TextBox ID="txtPhoneExtension3" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="21" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 70px">
                                Phone 4:</td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="22" ID="cboPhoneTypeID4" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                </asp:DropDownList></td>
                            <td style="width: 92px">
                                <cc1:InputMask ID="txtPhoneNumber4" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="23" Width="100%"></cc1:InputMask></td>
                            <td style="width: 45px">
                                <asp:TextBox ID="txtPhoneExtension4" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="24" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 70px">
                                Phone 5:</td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="25" ID="cboPhoneTypeID5" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                </asp:DropDownList></td>
                            <td style="width: 92px">
                                <cc1:InputMask ID="txtPhoneNumber5" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="26" Width="100%"></cc1:InputMask></td>
                            <td style="width: 45px">
                                <asp:TextBox ID="txtPhoneExtension5" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="27" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 70px">
                            </td>
                            <td colspan="3">
                                            <asp:CheckBox ID="chkCanAuthorize" runat="server" Text="Applicant has authorization power" /></td>
                        </tr>
                    </table>
                            </td>
                            <td style="padding-left: 20px; width: 100%" valign="top">
                                <table border="0" cellpadding="0" cellspacing="7" style="font-size: 11px; font-family: tahoma">
                                    <tr>
                                        <td>
                                            Relationship type:
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:RadioButtonList ID="optRelationship" runat="server" CellPadding="0" CellSpacing="0"
                                                Font-Names="Tahoma" Font-Size="11px" RepeatColumns="2">
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
                            </td>
                            <td style="height: 160px" valign="top">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="0" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" id="Img1"/>Cancel and Close</a></td>
                            <td align="right"><a tabindex="28" style="color:black"  class="lnk" href="#" onclick="AddApplicant();return false;">Add Applicant<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle" id="Img2"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>