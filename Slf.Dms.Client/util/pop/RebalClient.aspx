<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RebalClient.aspx.vb" Inherits="util_pop_RebalClient" %>

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

<script type="text/javascript" language="javascript">    
if (window.parent.currentModalDialog) {
    window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
}
    
    
function ReBalance_Client()
	{
	        <%--// show message
	        document.getElementById("<%= pnlMain.ClientID %>").style.display = "none";
	        document.getElementById("<%= pnlMessage.ClientID %>").style.display = "inline";--%>

            // postback to save
            <%= ClientScript.GetPostBackEventReference(lnkRebalance, Nothing) %>;
	}
	
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Rebalance Client(s)</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <form id="form1" runat="server">
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:15 15 5 15 15;">
                    <asp:Label runat="server" ID="lblMessage"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 15";> 
                    <asp:RadioButtonList ID="radRebal" runat="server" AutoPostback="true" RepeatDirection="horizontal" RepeatLayout="table" Font-Names="Tahoma" Font-Size="11px">
                    <asp:listitem Selected="False" Text="ALL Clients" Value="A" />
                    <asp:ListItem Selected="True" Text="Single Client" Value="S" />
                    </asp:RadioButtonList>
               </td>
              </tr>  
            <tr>
                <td style="padding-left: 15; height: 100%;" valign="top">
                    <table border="0" cellpadding="0" cellspacing="7" style="font-family: tahoma; font-size: 11px;">
                        <tr>
                            <td colspan="2">
                                <asp:label id="lblEnter" text="Enter the Account Number of the client you wish to Re-Balance:" runat="server" /><br /><br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:label id="lblAccount" text="Account Number:" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="txtAcctNo" runat="server" Font-Names="tahoma" Font-Size="11px">
                                </asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:label id="lblClientIDA" text="ClientID:" runat="server" />
                            </td>
                            <td>
                                <asp:Label ID="lblClientID" runat="server" Font-Names="tahoma" Font-Size="11px" Width="100">
                                </asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:label id="lblNameA" text="Name:" runat="server" />
                            </td>
                            <td>
                                <asp:Label ID="lblName" runat="server" Font-Names="tahoma" Font-Size="11px" Width="200">
                                </asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnConfirm" runat="server" Font-Names="tahoma" Font-Size="11px" Width="75" Text="Confirm">
                                </asp:Button>
                            </td>
                        </tr>
                    </table>
                    <asp:LinkButton runat="server" ID="lnkRebalance"></asp:LinkButton>
                </td>
            </tr>  
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />Cancel and Close</a></td>
                            <td align="right"><a runat="server" id="lnkReBalanceClient" tabindex="2" style="color:black" class="lnk" href="#" onclick="ReBalance_Client();return false;"></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
