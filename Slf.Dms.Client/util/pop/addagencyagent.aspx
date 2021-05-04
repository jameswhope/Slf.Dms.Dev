<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addagencyagent.aspx.vb" Inherits="util_pop_addagencyagent" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" > 
<head id="Head1" runat="server">
    <title>Add Agent</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    
     if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    
    function OnChangeAgent()
    {
   	    var rd = document.getElementById("<%= rdAgentList.ClientID %>")
   	    rd.checked = true;
    }
       
   	function Record_Save()
	{
        var agentid =-1;
        var firstName;
        var lastName;
	    var rd = document.getElementById("<%= rdAgentList.ClientID %>")
	    if (rd.checked==true)
	    {	    
	        var ddl = document.getElementById("<%= ddlAgent.ClientID %>")
	        agentid = ddl.options[ddl.selectedIndex].value;
	        firstName = ddl.options[ddl.selectedIndex].FirstName;
	        lastName = ddl.options[ddl.selectedIndex].LastName;
	        // show message
	        document.getElementById("<%= pnlMain.ClientID %>").style.display = "none";
	        document.getElementById("<%= pnlMessage.ClientID %>").style.display = "inline";
	    }
	    window.parent.Record_AddAgentsBack(agentid, firstName, lastName); 
	    window.close();
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
    <asp:Panel runat="server" ID="pnlMessage" Font-Names="Tahoma" Font-Size="11px" Width="100%" style="padding-top:35;display:block;"><center>
        <br />Select an agent for this agency.</center></asp:Panel>
    <asp:Panel runat="server" ID="pnlMain" style="width:100%;height:100%;">
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display:none;">
                        <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					        <tr>
						        <td valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absMiddle" border="0"></td>
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
                            <td style="width: 10px">
                                <asp:RadioButton ID="rdBlankAgent" runat="server" GroupName="GroupAgent" Checked="true" />
                             </td>
                             <td>
                                New Agent
                             </td>
                        </tr>
                        <tr>
                            <td style="width: 10px; height: 33px;">
                                <asp:RadioButton ID="rdAgentList" runat="server" GroupName="GroupAgent" />
                             </td>
                             <td style="height: 33px">
                                 <asp:DropDownList ID="ddlAgent" runat="server" style="font-family:tahoma;font-size:11px; width: 200px;" ></asp:DropDownList>
                             </td>
                        </tr>
                    </table>
                    <br />
                    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a TabIndex="16" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img2" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                            <td align="right"><a TabIndex="17" style="color:black"  class="lnk" href="#" onclick="Record_Save();return false;">Add Agent<img id="Img3" style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
</form>
</body>
</html>
