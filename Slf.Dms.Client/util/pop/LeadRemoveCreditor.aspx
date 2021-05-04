<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LeadRemoveCreditor.aspx.vb" Inherits="util_pop_LeadRemoveCreditor" Title="Removing a creditor." %>
<%@ Register TagPrefix="cc1" Namespace="AssistedSolutions.WebControls" Assembly="AssistedSolutions.WebControls.InputMask" %>

<script type="text/javascript">
    
function Save_Reason()
	{
	        <%--// show message
	        document.getElementById("<%= pnlMain.ClientID %>").style.display = "none";
	        document.getElementById("<%= pnlMessage.ClientID %>").style.display = "inline";--%>
	}
	
function GetReasonValue()
    {
        var ddlReason = document.getElementById("<%= ddlReason.ClientID %>");
        var reason = ddlReason.options[ddlReason.selectedIndex].value;
        if(reason == "Other")
            {
                document.getElementById("<%= lblreason.clientid %>").style.display = "inline";
                document.getElementById("<%=txtOther.ClientID %>").style.display = "inline";
            }
        else
            {
                document.getElementById("<%= lblreason.clientid %>").style.display = "none";
                document.getElementById("<%=txtOther.ClientID %>").style.display = "none";
            }
    }

function terminate()
    {   
        var vReturnValue = document.getElementById("<%= ddlReason.ClientID %>");
        vReturnValue = vReturnValue.options[vReturnValue.selectedIndex].value;
        if(vReturnValue != undefined)
            {
            window.returnValue = vReturnValue;
            window.close();
            }
        else
            {
                alert("You must choose a reason why this creditor is being removed.");
            }
    }	
	
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1" runat="server">
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <form id="form1" runat="server">
   <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager> 
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:15 15 5 15 15;">
                    <asp:Label runat="server" ID="lblMessage"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 15; height: 100%;" valign="top">
                    <table border="0" cellpadding="0" cellspacing="7" style="font-family: tahoma; font-size: 11px;">
                        <tr>
                            <td style="font-family:Tahoma;font-size:11px;">
                                Reason:</td>
                            <td>
                                <asp:DropDownList ID="ddlReason" runat="server" Height="16px" Width="203px" Font-Size="11px" Font-Names="Tahoma" autopostback="false" onchange="GetReasonValue()">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                                <td style="font-family:Tahoma;font-size:11px; display:none;" ID="lblreason" runat="server">
                                Reason:</td>
                                <td>
                                <asp:TextBox ID="txtOther" runat="server" Height="21px" Width="198px" style="display:none;"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnSave" runat="server" Font-Names="tahoma" Font-Size="11px" 
                                    Width="75" Text="Save" OnClick="btnSave_OnClick">
                                </asp:Button>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>  
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="1" style="color:black" class="lnk" href="javascript:terminate();"><img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />Cancel and Close</a></td>
                            <td align="right"><a runat="server" id="lnkSaveReasons" tabindex="2" style="color:black" class="lnk" href="#" onclick="Save_Reasons();return false;"></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hdnReason" runat="server" />
    </form>
</body>
</html>
