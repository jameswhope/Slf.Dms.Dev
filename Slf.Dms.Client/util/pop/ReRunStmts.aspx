<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ReRunStmts.aspx.vb" Inherits="util_pop_ReRunStmts" %>
<%@ Register TagPrefix="cc1" Namespace="AssistedSolutions.WebControls" Assembly="AssistedSolutions.WebControls.InputMask" %>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript" language="javascript">    
if (window.parent.currentModalDialog) {
    window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
}
    
function ReRun_Statements()
	{
	        <%--// show message
	        document.getElementById("<%= pnlMain.ClientID %>").style.display = "none";
	        document.getElementById("<%= pnlMessage.ClientID %>").style.display = "inline";--%>

            // postback to save
            <%= ClientScript.GetPostBackEventReference(lnkStmts, Nothing) %>;
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
   <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager> 
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:15 15 5 15 15;">
                    <asp:Label runat="server" ID="lblMessage"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 15";> 
                    <asp:RadioButtonList ID="radRebal" runat="server" AutoPostback="true" RepeatDirection="horizontal" RepeatLayout="table" Font-Names="Tahoma" Font-Size="11px">
                    <asp:listitem Selected="False" Text="ALL Statements" Value="A" />
                    <asp:ListItem Selected="True" Text="Single Statement" Value="S" />
                    <asp:ListItem Selected="False" Text="Settlement Attorney" Value="SA" />
                    </asp:RadioButtonList>
               </td>
              </tr>  
            <tr>
                <td style="padding-left: 15; height: 100%;" valign="top">
                    <table border="0" cellpadding="0" cellspacing="7" style="font-family: tahoma; font-size: 11px;">
                        <tr>
                            <td>
                                <asp:label id="lblPeriod" text="Pay Period: " runat="server" >
                                </asp:label> 
                            </td>
                            <td nowrap="nowrap" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtStmtDate" Mask="nn/nn/nnnn"></cc1:InputMask></td>
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
                    <asp:LinkButton runat="server" ID="lnkStmts"></asp:LinkButton>
                </td>
            </tr>  
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />Cancel and Close</a></td>
                            <td align="right"><a runat="server" id="lnkRunStmts" tabindex="2" style="color:black" class="lnk" href="#" onclick="ReRun_Statements();return false;"></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
