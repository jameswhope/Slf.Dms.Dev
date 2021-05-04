<%@ Page Language="VB" AutoEventWireup="false" CodeFile="passchange.aspx.vb" Inherits="passchange" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DMP - Set Password</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <SCRIPT src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></SCRIPT>
	<style>
	    .txt { FONT-SIZE: 11px; WIDTH: 100%; FONT-FAMILY: tahoma }
	    .btn { BORDER-RIGHT: 1px outset; BORDER-TOP: 1px outset; FONT-SIZE: 11px; BORDER-LEFT: 1px outset; WIDTH: 90; height: 23; BORDER-BOTTOM: 1px outset; FONT-FAMILY: tahoma; BACKGROUND-COLOR: rgb(239,243,252) }
	</style>
</head>
<body onload="SetFocus('<%= txtUsername.ClientID %>');" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x; margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;">
    <form id="form1" runat="server">
    <table cellpadding="0" cellspacing="0" border="0" style="width:100%;height:100%;">
        <tr>
            <td style="height:100%;" align="center" valign="top">
                <asp:Panel runat="server" ID="pnlMain">
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
                                    <td class="partHeader">Set Password</td>
                                </tr>
                                <tr>
                                    <td class="partHolderBody" style="background-color:white;padding:10 10 10 10;">
                                        <table style="font-size: 11px; width: 100%; font-family: tahoma" cellspacing="5" cellpadding="0" border="0">
                                            <tr>
                                                <td style="width: 95">User Name:</td>
                                                <td><asp:TextBox ID="txtUsername" runat="server" MaxLength="50" CssClass="txt"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 95">Current Password:</td>
                                                <td><asp:TextBox ID="txtCurrentPassword" runat="server" MaxLength="50" CssClass="txt" TextMode="Password"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 95">New Password:</td>
                                                <td><asp:TextBox ID="txtNewPassword" runat="server" MaxLength="50" CssClass="txt" TextMode="Password"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 95">Confirm Password:</td>
                                                <td><asp:TextBox ID="txtConfirmPassword" runat="server" MaxLength="50" CssClass="txt" TextMode="Password"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 95">&nbsp;</td>
                                                <td align="right" style="padding-top:5;"><asp:Button ID="cmdGetPassword" runat="server" CssClass="btn" Text="Set Password"></asp:Button></td>
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
                    <tr>
                        <td colspan="2" class="partHolder" style="width:530;">
                            <table class="partTable" style="width:100%;" cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td class="partHeader">Information</td>
                                </tr>
                                <tr>
                                    <td class="partHolderBody">
                                        <table style="font-size: 11px; width: 100%; font-family: tahoma" cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td style="padding:15 20 15 20;">
                                                    <table style="margin-bottom:3;font-family:tahoma;font-size:11;width:100%;" cellpadding="0" cellspacing="0" border="0">
					                                    <tr>
					                                        <td valign="top" style="width:30;"><img align="absmiddle" runat="server" src="~/images/16x16_note2.png" border="0" /></td>
					                                        <td>
					                                            Why are you being asked to set a password?&nbsp;&nbsp;Your account was recently
					                                            assigned a temporary password, either because you forgot your password and a new
					                                            one was emailed to you or because the system settings require password resets
					                                            after a specified amount of time has elapsed.</td>
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
                </table>
                </asp:Panel>
                <asp:Panel Visible="false" style="background-color:white;" CssClass="partHolder" runat="server" ID="pnlSuccess" Width="532">
                    <table class="partTable" style="width:100%;" cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td class="partHeader">Password Reset</td>
                        </tr>
                        <tr>
                            <td class="partHolderBody" style="padding:15 20 0 20;">
                                <table style="font-size:11px;width:100%;font-family:tahoma;width: 100%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td valign="top"><img runat="server" src="~/images/email.jpg" border="0" align="absmiddle" /></td>
                                        <td style="padding-left:20;">Your password has been changed and you are now logged in.
                                            <br />
                                            <ul><li style="color: rgb(255,153,0); list-style-type: square"><a class="lnk" href="default.aspx">DMP Home Page</a></ul></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>