<%@ Page Language="VB" AutoEventWireup="false" CodeFile="passforgot.aspx.vb" Inherits="passforgot" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Forgot Your Password</title>
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
            <td>
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td><img style="margin-bottom:10px;margin-left:10px;margin-top:10px;" alt="Logo" runat="server" src="~/images/logo.gif"/></td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
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
                                    <td class="partHeader">Forgot Your Password</td>
                                </tr>
                                <tr>
                                    <td class="partHolderBody" style="background-color:white;padding:10 10 10 10;">
                                        <table style="font-size: 11px; width: 100%; font-family: tahoma" cellspacing="5" cellpadding="0" border="0">
                                            <tr>
                                                <td style="width: 65">User Name:</td>
                                                <td><asp:TextBox ID="txtUsername" runat="server" MaxLength="50" CssClass="txt"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 65">&nbsp;<input type="text" style="display:none;" /></td>
                                                <td align="right" style="padding-top:5;"><asp:Button ID="cmdGetPassword" runat="server" CssClass="btn" Text="Get Password"></asp:Button></td>
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
                                                            <td><li style="color: rgb(255,153,0); list-style-type: square"><a class="lnk" href="unforgot.aspx">Forgot your user name?</a><li style="color: rgb(255,153,0); list-style-type: square"><a class="lnk" href="default.aspx">Back to login</a><li style="color: rgb(255,153,0); list-style-type: square"><a runat="server" id="lnkContactUs" class="lnk" href="mailto:info@datarg.com">Contact us</a></li></td>
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
					                                            Forgot your password?&nbsp;&nbsp;No problem.&nbsp;&nbsp;Just fill in your username
					                                            and we will send you a new temporary password by email.<br /><br />We cannot send
					                                            you your current password because of the security measures we have in place.&nbsp;&nbsp;All 
					                                            security information is encrypted within the database, and cannot be deciphered once
					                                            entered.&nbsp;&nbsp;After you received the email, simply use the temporary password
					                                            to login, and the system will prompt you to enter a new password for future use.</td>
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
                                        <td style="padding-left:20;">A new temporary password has been emailed to <asp:label runat="server" ID="lblEmail"></asp:label>, which is the email address we have
                                            on file for your User Name.
                                            <br />
                                            <ul><li style="color: rgb(255,153,0); list-style-type: square"><a class="lnk" href="default.aspx">Back to login</a><li style="color: rgb(255,153,0); list-style-type: square"><a runat="server" id="lnkContactUs2" class="lnk" href="mailto:info@datarg.com">Contact us</a></li></ul></td>
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