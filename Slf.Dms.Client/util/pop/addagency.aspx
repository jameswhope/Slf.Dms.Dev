<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addagency.aspx.vb" Inherits="util_pop_addagency" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Agency</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body onunload="Record_CheckReset();" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
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
	    var txtName = document.getElementById("<%= txtName.ClientID %>");

        // txtName
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

	</script>

    <form id="form1" runat="server" style="height:100%;">
    <asp:Literal runat="server" ID="ltrJScript"></asp:Literal>
    <asp:Panel runat="server" ID="pnlMessage" Font-Names="Tahoma" Font-Size="11px" Width="100%" style="padding-top:35;display:none;"><center>Saving trust...</center></asp:Panel>
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
                            <td style="width:100;">Name:</td>
                            <td style="width:200;"><asp:TextBox TabIndex="1" ID="txtName" runat="server" CssClass="entry"></asp:TextBox></td>
                        </tr>
                    </table>
                    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a TabIndex="6" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                            <td align="right"><a TabIndex="7" style="color:black"  class="lnk" href="#" onclick="Record_Save();return false;">Add Agency<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
</form>
</body>
</html>