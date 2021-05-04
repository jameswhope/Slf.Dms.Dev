<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addnote.aspx.vb" Inherits="clients_new_addnote" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Note</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <SCRIPT src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></SCRIPT>
</head>
<body onload="SetFocus('<%= txtNote.ClientID %>');" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <script type="text/javascript">
	function AddNote()
	{ 
	    if (RequiredExist())
	    {
	        var txtNote = document.getElementById("<%= txtNote.ClientID %>");

            window.top.dialogArguments.AddNote(txtNote.value);
            window.close();
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
        // note body
	    var txtNote = document.getElementById("<%= txtNote.ClientID %>");

	    if (txtNote.value == null || txtNote.value.length == 0)
	    {
	        ShowMessage("The Note is a required field.  If you do not wish to add a note, please select Cancel And Close.");
	        AddBorder(txtNote);
	        return false;
	    }
	    else
	    {
	        RemoveBorder(txtNote);
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
	}
		</script>
    <form id="form1" runat="server">
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top">
                    <div runat="server" id="dvError" style="display:none;">
                        <TABLE style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					        <TR>
						        <TD valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
						        <TD runat="server" id="tdError"></TD>
					        </TR>
				        </TABLE>&nbsp;</div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="height: 100%;">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td>
                                <asp:TextBox TabIndex="2" ID="txtNote" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100%" Rows="10" TextMode="MultiLine" MaxLength="5000"></asp:TextBox></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img2" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle"/>Cancel and Close</a></td>
                            <td align="right"><a tabindex="3" style="color:black"  class="lnk" href="#" onclick="AddNote();return false;">Add Note<img id="Img3" style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>