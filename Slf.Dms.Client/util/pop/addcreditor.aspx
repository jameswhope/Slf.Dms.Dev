<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addcreditor.aspx.vb" Inherits="util_pop_addcreditor" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Creditor</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body onunload="Record_CheckReset();" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <script type="text/javascript">

    function Record_CheckReset()
    {
        var selc = window.top.dialogArguments[2];

        if (selc.selectedIndex == 0) // still on add new option
        {
            selc.selectedIndex = parseInt(selc.lastIndex);
        }
    }
    function Record_Propagate(ID, Name)
    {
        var wind = window.top.dialogArguments[0];
        var cbos = window.top.dialogArguments[1];
        var selc = window.top.dialogArguments[2];

        var added = false;

        // insert the id/name into the original dropdown; start at index three
        for (i = 3; i < selc.options.length; i++)
        {
            if (selc.options[i].text > Name)
            {
                Insert(wind, cbos, ID, Name, i, true);

                added = true;
                break;
            }
        }

        if (!added) // all list items are greater
        {
            Insert(wind, cbos, ID, Name, i, false);
        }

        // select the recently inserted option
        selc.selectedIndex = i;
        selc.lastIndex = selc.selectedIndex;
    }
    function Insert(wind, cbos, id, name, i, insert)
    {
        for (c = 0; c < cbos.length; c++)
        {
            var cbo = cbos[c];

            // create a new option with ID as value and name as text
            var opt = wind.document.createElement("OPTION");

            if (insert)
            {
                cbo.options.add(opt, i);    // insert in middle
            }
            else
            {
                cbo.options.add(opt);       // add to end
            }

            opt.innerText = name;
            opt.value = id;
        }
    }
	function Record_Save()
	{
	    if (RequiredExist())
	    {
	        // show message
	        document.getElementById("<%= pnlMain.ClientID %>").style.display = "none";
	        document.getElementById("<%= pnlMessage.ClientID %>").style.display = "inline";

            // postback to save
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
	    }
	}
	function txtZipCode_OnBlur(obj)
	{
		var txtCity = document.all("txtCity");
		var cboStateID = document.all("cboStateID");

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
        // Name
	    var txtName = document.getElementById("<%= txtName.ClientID %>");

	    if (txtName.value == null || txtName.value.length == 0)
	    {
	        ShowMessage("The Name is a required field");
	        AddBorder(txtName);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtName);
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
    <form id="form1" runat="server" style="height:100%;">
    <asp:Literal runat="server" ID="ltrJScript"></asp:Literal>
    <asp:Panel runat="server" ID="pnlMessage" Font-Names="Tahoma" Font-Size="11px" Width="100%" style="padding-top:35;display:none;"><center>Saving creditor...</center></asp:Panel>
    <asp:Panel runat="server" ID="pnlMain" style="width:100%;height:100%;">
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display:none;">
                        <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					        <tr>
						        <td valign="top" width="20"><img runat="server" src="~/images/message.png" align="absMiddle" border="0"></td>
						        <td runat="server" id="tdError"></td>
					        </tr>
				        </table>
				    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top:15;height:100%;">
                    <table style="font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 80px">Name:</td>
                            <td style="width: 200px"><asp:TextBox MaxLength="50" TabIndex="1" Font-Names="tahoma" Font-Size="11px" runat="server" ID="txtName" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 80px"> Street:</td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="2" ID="txtStreet" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 80px">Street 2:</td>
                            <td style="width: 200px"><asp:TextBox MaxLength="50" TabIndex="3" ID="txtStreet2" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 80px">City, State Zip:</td>
                            <td style="width: 200px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td><asp:TextBox TabIndex="5" ID="txtCity" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%"></asp:TextBox></td>
                                        <td style="width: 40px; padding-right: 7px; padding-left: 7px;"><asp:DropDownList TabIndex="6" ID="cboStateID" runat="server" Font-Names="Tahoma" Font-Size="11px" Width="100%"></asp:DropDownList></td>
                                        <td style="width: 45px"><asp:TextBox MaxLength="50" TabIndex="4" ID="txtZipCode" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%"></asp:TextBox></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table style="font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 80px">Phone 1:</td>
                            <td style="width: 100px"><asp:DropDownList TabIndex="7" ID="cboPhoneTypeID1" runat="server" Font-Names="Tahoma" Font-Size="11px" Width="100%"></asp:DropDownList></td>
                            <td style="width: 95px"><cc1:InputMask ID="txtPhoneNumber1" runat="server" Font-Names="tahoma" Font-Size="11px" Mask="(nnn) nnn-nnnn" TabIndex="8" Width="100%"></cc1:InputMask></td>
                            <td style="width: 55px"><asp:TextBox ID="txtPhoneExtension1" runat="server" Font-Names="tahoma" Font-Size="11px" MaxLength="10" TabIndex="9" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 80px">Phone 2:</td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="10" ID="cboPhoneTypeID2" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                </asp:DropDownList></td>
                            <td style="width: 95px">
                                <cc1:InputMask ID="txtPhoneNumber2" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="11" Width="100%"></cc1:InputMask></td>
                            <td style="width: 55px">
                                <asp:TextBox ID="txtPhoneExtension2" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="12" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Phone 3:</td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="13" ID="cboPhoneTypeID3" runat="server" Font-Names="Tahoma" Font-Size="11px"
                                    Width="100%">
                                </asp:DropDownList></td>
                            <td style="width: 95px">
                                <cc1:InputMask ID="txtPhoneNumber3" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    Mask="(nnn) nnn-nnnn" TabIndex="14" Width="100%"></cc1:InputMask></td>
                            <td style="width: 55px">
                                <asp:TextBox ID="txtPhoneExtension3" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="15" Width="100%"></asp:TextBox></td>
                        </tr>
                    </table>
                    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a TabIndex="16" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                            <td align="right"><a TabIndex="17" style="color:black"  class="lnk" href="#" onclick="Record_Save();return false;">Add Creditor<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
</form>
</body>
</html>