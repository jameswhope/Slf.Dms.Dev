<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="property.aspx.vb" Inherits="admin_settings_properties_property" title="DMP - Admin Settings - Property" %>
<%@ MasterType VirtualPath="~/admin/settings/settings.master" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

    <script type="text/javascript">

	function ShowMessage(Value)
	{
	    var pnlError = document.getElementById("<%= pnlError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    pnlError.style.display = "inline";
	    tdError.innerHTML = Value;
	}
	function ShowMessageBody(Value)
	{
	    var tblBody = document.getElementById("<%= tblBody.ClientID %>");
	    var tblMessage = document.getElementById("<%= tblMessage.ClientID %>");

	    tblBody.style.display = "none";
	    tblMessage.style.display = "inline";
	    tblMessage.rows[0].cells[0].innerHTML = Value;
	}
	function HideMessage()
	{
	    var pnlError = document.getElementById("<%= pnlError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    tdError.innerHTML = "";
	    pnlError.style.display = "none";
	}
    function lboValues_OnDblClick(obj)
    {
        if (obj.selectedIndex != -1)
        {
            obj.options.remove(obj.selectedIndex);

            ResetValues();
        }
    }
    function AddValue()
    {
        var lboValues = document.getElementById("<%= lboValues.ClientID %>");
        var lblType = document.getElementById("<%= lblType.ClientID %>");
        var txtAdd = document.getElementById("<%= txtAdd.ClientID %>");

        if (RequiredToAddExist())
        {
            var Option = document.createElement("OPTION");

            lboValues.options.add(Option);

	        var Value = new String(txtAdd.value);

            if (lblType.innerText.toLowerCase() == "dollar amount" || lblType.innerText.toLowerCase() == "number")
            {
                Value = Value.replace("$", "").replace(",", "").replace("|", "");
                Option.innerText = CurrencyFormat(Value);
                Option.value = CurrencyFormat(parseFloat(Value));
            }
            else if (lblType.innerText.toLowerCase() == "percentage")
            {
                Value = Value.replace("%", "").replace(",", "").replace("|", "");
                Option.innerText = CurrencyFormat(Value);
                Option.value = parseFloat(Value) / 100;
            }
            else
            {
                Value = Value.replace("|", "");
                Option.innerText = Value;
                Option.value = Value;
            }

            ResetValues();

            txtAdd.value = "";
            txtAdd.focus();
        }
    }
	function RequiredToAddExist()
	{
	    var lblType = document.getElementById("<%= lblType.ClientID %>");
	    var txtAdd = document.getElementById("<%= txtAdd.ClientID %>");

	    if (txtAdd.value == null || txtAdd.value.length == 0)
	    {
	        ShowMessage("If you want to add a new value, you must type it in the textbox provided.  The value must be a " + lblType.innerText.toLowerCase() + ".");
	        AddBorder(txtAdd);
	        return false;
	    }
	    else
	    {
	        var Value = new String(txtAdd.value);

            if (lblType.innerText.toLowerCase() == "percentage" || lblType.innerText.toLowerCase() == "dollar amount" || lblType.innerText.toLowerCase() == "number")
            {
                // figure out the type, then remove unnecessary (but often inputed) characters
                if (lblType.innerText.toLowerCase() == "dollar amount" || lblType.innerText.toLowerCase() == "number")
                {
                    Value = Value.replace("$", "").replace(",", "").replace("|", "");
                }
                else if (lblType.innerText.toLowerCase() == "percentage")
                {
                    Value = Value.replace("%", "").replace(",", "").replace("|", "");
                }

                if (isNaN(parseFloat(Value)) || parseFloat(Value) == 0)
                {
	                ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be a " + lblType.innerText.toLowerCase() + ".");
	                AddBorder(txtAdd);
	                return false;
                }
	            else
	            {
	                RemoveBorder(txtAdd);
	            }
            }
	    }

        RemoveBorder(txtAdd);
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
	    if (obj != null)
	    {
            obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
        }
	}
    function ResetValues()
    {
        var lboValues = document.getElementById("<%= lboValues.ClientID %>");
        var txtValue = document.getElementById("<%= txtValue.ClientID %>");

        txtValue.value = "";

        for (i = 0; i < lboValues.options.length; i++)
        {
            if (txtValue.value != null && txtValue.value.length > 0)
            {
                txtValue.value += "|" + lboValues.options[i].value;
            }
            else
            {
                txtValue.value = lboValues.options[i].value;
            }
        }
    }
    function CurrencyFormat(Amount)
    {
        var i = parseFloat(Amount);
        if(isNaN(i)) { i = 0.00; }
        var minus = '';
        if(i < 0) { minus = '-'; }
        i = Math.abs(i);
        i = parseInt((i + .005) * 100);
        i = i / 100;
        s = new String(i);
        if(s.indexOf('.') < 0) { s += '.00'; }
        if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
        s = minus + s;
        return s;
    }
    function RequiredExist()
    {
        var txtAdd = document.getElementById("<%= txtAdd.ClientID %>");
        var lblType = document.getElementById("<%= lblType.ClientID %>");
        var chkMulti = document.getElementById("<%= chkMulti.ClientID %>");
        var txtValue = document.getElementById("<%= txtValue.ClientID %>");
        var chkNullable = document.getElementById("<%= chkNullable.ClientID %>");

        if (chkMulti.checked)
        {
            if (txtValue.value == null || txtValue.value.length == 0)
            {
	            ShowMessage("At least one Value is required.  Please use the Add box below.");
	            AddBorder(txtAdd);
	            return false;
            }
            else
            {
                RemoveBorder(txtAdd);
                RemoveBorder(txtValue);
            }
        }
        else
        {
            if (!chkNullable.checked && (txtValue.value == null || txtValue.value.length == 0))
            {
	            ShowMessage("The Value field is required.");
	            AddBorder(txtValue);
	            return false;
            }
            else
            {
	            var Value = new String(txtValue.value);

                if (lblType.innerText.toLowerCase() == "percentage" || lblType.innerText.toLowerCase() == "dollar amount" || lblType.innerText.toLowerCase() == "number")
                {
                    // figure out the type, then remove unnecessary (but often inputed) characters
                    if (lblType.innerText.toLowerCase() == "dollar amount" || lblType.innerText.toLowerCase() == "number")
                    {
                        Value = Value.replace("$", "").replace(",", "");
                    }
                    else if (lblType.innerText.toLowerCase() == "percentage")
                    {
                        Value = Value.replace("%", "").replace(",", "");
                    }

                    if (isNaN(parseFloat(Value)) || parseFloat(Value) == 0)
                    {
	                    ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be a " + lblType.innerText.toLowerCase() + ".");
	                    AddBorder(txtValue);
	                    return false;
                    }
	                else
	                {
	                    txtValue.value = parseFloat(Value);
	                    RemoveBorder(txtValue);
	                }
                }
            }

            RemoveBorder(txtAdd);
            RemoveBorder(txtValue);
        }

        HideMessage()
	    return true;
    }
    function Record_Print()
    {
        alert("Under Construction");
    }
    function Record_Save()
    {
        if (RequiredExist())
        {
            ShowMessageBody("Saving property...");

            // postback to save
            <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function Record_Cancel()
    {
        ShowMessageBody("Canceling and closing...");

        // postback to cancel
        <%= Page.ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;
    }

    </script>
    
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color:#666666;"><a runat="server" class="lnk" style="color:#666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color:#666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color:#666666;" href="~/admin/settings/properties">Properties</a>&nbsp;>&nbsp;<asp:Label runat="server" ID="lblProperty"></asp:Label></td>
        </tr>
        <tr>
            <td>
                <asp:Panel runat="server" ID="pnlError" style="display:none;">
                    <TABLE style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
				        <TR>
					        <TD valign="top" width="20"><img runat="server" src="~/images/message.png" align="absmiddle" border="0" /></TD>
					        <TD runat="server" id="tdError"></TD>
				        </TR>
			        </TABLE>&nbsp;
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <table style="border-collapse:collapse;border:solid 1px #d3d3d3;font-size:11px;font-family:tahoma;" cellpadding="7" cellspacing="0" border="0">
                    <tr>
                        <td style="border:solid 1px #d3d3d3;width:80;background-color:#f1f1f1">Property ID:</td>
                        <td style="border:solid 1px #d3d3d3;width:300"><asp:Label runat="server" ID="lblPropertyID"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="border:solid 1px #d3d3d3;width:80;background-color:#f1f1f1">Name:</td>
                        <td style="border:solid 1px #d3d3d3;width:300"><asp:Label runat="server" ID="lblName"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="border:solid 1px #d3d3d3;width:80;background-color:#f1f1f1">Type:</td>
                        <td style="border:solid 1px #d3d3d3;width:300"><asp:Label runat="server" ID="lblType"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="border:solid 1px #d3d3d3;width:80;background-color:#f1f1f1" valign="top">Description:</td>
                        <td style="border:solid 1px #d3d3d3;width:300"><asp:Label runat="server" ID="lblDescription"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="border:solid 1px #d3d3d3;width:80;background-color:#f1f1f1" valign="top">Value:</td>
                        <td style="border:solid 1px #d3d3d3;width:300">
                            <asp:Panel runat="server" ID="pnlMulti">
                                <div style="color:#a1a1a1;font-style:italic;padding-bottom:7;">Double-click a row to remove a value</div>
                                <asp:ListBox Rows="5" width="100%" Font-Names="tahoma" font-size="11px" style="margin-bottom:7;" runat="server" ID="lboValues"></asp:ListBox>
                                <table cellspacing="0" cellpadding="0" width="100%" border="0">
                                    <tr>
                                        <td style="padding-right:7;"><asp:textbox width="100%" Font-Names="tahoma" font-size="11px" runat="server" ID="txtAdd"></asp:textbox></td>
                                        <td style="width:85;"><input onclick="AddValue();" type="button" style="font-family:tahoma;font-size:11px;width:100%;height:22px;" runat="server" id="cmdAdd" value="Add Value" /></td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:textbox width="100%" Font-Names="tahoma" font-size="11px" runat="server" ID="txtValue"></asp:textbox>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <table runat="server" id="tblMessage" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color:#666666;"></td>
        </tr>
    </table>

    <asp:CheckBox runat="server" ID="chkNullable" style="display:none;"/>
    <asp:CheckBox runat="server" ID="chkMulti" style="display:none;"/>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkCancel"></asp:LinkButton>

</asp:Content>