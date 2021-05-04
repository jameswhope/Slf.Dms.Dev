<%@ Page Language="VB" AutoEventWireup="false" CodeFile="login.aspx.vb" Inherits="login" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Secure Login</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <SCRIPT src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></SCRIPT>
	<style>
	    .txt { FONT-SIZE: 11px; WIDTH: 100%; FONT-FAMILY: tahoma }
	    .btn { BORDER-RIGHT: 1px outset; BORDER-TOP: 1px outset; FONT-SIZE: 11px; BORDER-LEFT: 1px outset; width:90;height:23; BORDER-BOTTOM: 1px outset; FONT-FAMILY: tahoma; BACKGROUND-COLOR: rgb(239,243,252) }
	</style>
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x; margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;"> <%--onload="SetFocus('<%= txtUsername.ClientID %>');"--%>
    <form id="form1" runat="server">
    <table cellpadding="0" cellspacing="0" border="0" style="width:100%;height:100%;">
<%--        <tr>
            <td>
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td><img style="margin-bottom:10px;margin-left:10px;margin-top:10px;" alt="Logo" runat="server" src="~/images/logo.gif"/></td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>--%>
        <tr>
            <td style="height:100%;" align="center" valign="top">
                <asp:Panel ID="pnlError" runat="server" Visible="false" Width="532">
                    <table id="tblError" style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px; border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid; font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
                        <tr>
                            <td valign="top" width="20"><img src="images/message.png" align="absMiddle" border="0"></td>
                            <td><asp:Label ID="lblError" runat="server"></asp:Label></td>
                        </tr>
                    </table>
                </asp:Panel>
                <table cellpadding="0" cellspacing="15" border="0">
                    <tr>
                        <td valign="top" class="partHolder" style="background-color:white;width:313;">
                            <table class="partTable" style="width:100%;" cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td class="partHeader">Login</td>
                                </tr>
                                <tr>
                                    <td class="partHolderBody" style="padding:10 10 10 10;">
                                        <table style="font-size: 11px; width: 100%; font-family: tahoma" cellspacing="5" cellpadding="0" border="0">
                                            <tr>
                                                <td style="width: 65">User Name:</td>
                                                <td><asp:TextBox ID="txtUsername" runat="server" MaxLength="50" CssClass="txt"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 65">Password:</td>
                                                <td><asp:TextBox ID="txtPassword" runat="server" MaxLength="50" CssClass="txt" TextMode="Password"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 65">&nbsp;</td>
                                                <td><asp:CheckBox ID="chkRememberMe" runat="server" Text="Remember me next time" Checked="True"></asp:CheckBox></td> 
                                            </tr>
                                            <tr>
                                                <td style="width: 65">&nbsp;</td>
                                                <td align="right" style="padding-top:5;"><asp:Button ID="cmdLogin" runat="server" CssClass="btn" Text="Login"></asp:Button></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" class="partHolder" style="width:200;">
                            <table class="partTable" style="width:100%;" cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td class="partHeader">Options</td>
                                </tr>
                                <tr>
                                    <td class="partHolderBody">
                                        <table style="font-size: 11px; width: 100%; font-family: tahoma" cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td style="padding-right: 15px; padding-left: 15px; padding-bottom: 15px; padding-top: 10px">
                                                    <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <li style="color: rgb(255,153,0); list-style-type: square"><a class="lnk" href="unforgot.aspx">Forgot your user name?</a>
                                                                <li style="color: rgb(255,153,0); list-style-type: square"><a class="lnk" href="passforgot.aspx">Forgot your password?</a>
                                                                <li style="color: rgb(255,153,0); list-style-type: square"><a class="lnk" href="register.aspx">Register a new account</a>
                                                                <li style="color: rgb(255,153,0); list-style-type: square"><a runat="server" id="lnkContactUs" class="lnk" href="mailto:info@datarg.com">Contact us</a></li>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
<%--                    <tr>
                        <td colspan="2" class="partHolder" style="width:530;">
                            <table class="partTable" style="width:100%;" cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td class="partHeader">News</td>
                                </tr>
                                <tr>
                                    <td class="partHolderBody">
                                        <table style="font-size: 11px; width: 100%; font-family: tahoma" cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td style="padding-right: 15px; padding-left: 15px; padding-bottom: 15px; padding-top: 10px">
                                                    <table style="font-family:tahoma;font-size:11;width: 100%" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Repeater id="rpNews" runat="server">
											                        <ItemTemplate>
												                        <tr>
													                        <td style="PADDING-LEFT: 10px; PADDING-TOP: 5px">
													                            <table style="margin-bottom:3;font-family:tahoma;font-size:11;width:100%;" cellpadding="0" cellspacing="0" border="0">
													                                <tr>
													                                    <td rowspan="2" style="width:30;"><img align="absmiddle" runat="server" src="~/images/16x16_note2.png" border="0" /></td>
													                                    <td><a target="_blank" class="lnk" href='<%# DataBinder.Eval(Container.DataItem, "link")%>'><%# DataBinder.Eval(Container.DataItem, "title")%></a></td>
													                                </tr>
													                                <tr>
													                                    <td><%#DataBinder.Eval(Container.DataItem, "pubDate")%></td>
                                                                                    </tr>
													                            </table>
													                        </td>
												                        </tr>
											                        </ItemTemplate>
										                        </asp:Repeater>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>